#include "../../../usim/usim.h"

#include "imgui.h"
#include "imgui_impl_sdl3.h"
#include "imgui_impl_sdlrenderer3.h"
#include "implot.h"

#include <SDL3/SDL.h>

/* File containing simple visual micro simulator
 *
 * Created on: 27 oct. 2026
 *   Author: victor
 */

#define TARGET_FPS 60
#define TARGET_NS (1000000000 / TARGET_FPS)

#if defined(_MSC_VER) && !defined(__clang__)
#define DLLEXPORT extern "C" __declspec(dllexport)
#else
#define DLLEXPORT extern "C"
#endif

// utility structure for realtime plot
struct ScrollingBuffer {
  int MaxSize;
  int Offset;
  ImVector<ImVec2> Data;
  void Init(int max_size = 2000) {
    MaxSize = max_size;
    Offset  = 0;
    Data.reserve(MaxSize);
  }

  ScrollingBuffer(int max_size = 2000) {
    this->Init(max_size);
  }

  void AddPoint(float x, float y) {
    if (Data.size() < MaxSize)
      Data.push_back(ImVec2(x,y));
    else {
      Data[Offset] = ImVec2(x,y);
      Offset =  (Offset + 1) % MaxSize;
    }
  }
  void Erase() {
    if (Data.size() > 0) {
      Data.shrink(0);
      Offset  = 0;
    }
  }
};

struct USim_Memory {
  USim_API *api;
  SDL_Window *window;
  SDL_Renderer *renderer;
  uint64_t target_ns;
  float delta_time;

  ImGuiContext *imgui_ctx;
  ImPlotContext *implot_ctx;
  ImGuiIO *imgui_io;
  ImGuiStyle *imgui_style;

  ScrollingBuffer scrolling_gpio_data[Event_Variant_GPIO_PK15];
  ScrollingBuffer scrolling_systick_data;
  float newest_time;
  float time_history;

  bool show_gpio_graph;
  bool show_systick_graph;
  bool show_implot_style_editor;
};

bool Init_Window(USim_Memory *mem)
{
  if(!SDL_Init(SDL_INIT_VIDEO)) {
    SDL_Log("Error: SDL_Init(): %s", SDL_GetError());
    return false;
  }

  float primary_scale = SDL_GetDisplayContentScale(SDL_GetPrimaryDisplay());
  mem->window = SDL_CreateWindow(
    "usim example", (int)(1280*primary_scale), (int)(800*primary_scale),
    SDL_WINDOW_RESIZABLE | SDL_WINDOW_HIDDEN | SDL_WINDOW_HIGH_PIXEL_DENSITY
  );
  if(!mem->window) {
    SDL_Log("Error: SDL_CreateWindow(): %s", SDL_GetError());
    return false;
  }

  mem->renderer = SDL_CreateRenderer(mem->window, 0);
  if(!mem->renderer) {
    SDL_Log("Error: SDL_CreateRenderer(): %s", SDL_GetError());
    return false;
  }
  SDL_SetRenderVSync(mem->renderer, 1);

  SDL_SetWindowPosition(mem->window,
    SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED
  );
  SDL_ShowWindow(mem->window);

  IMGUI_CHECKVERSION();
  mem->imgui_ctx = ImGui::CreateContext();
  mem->implot_ctx = ImPlot::CreateContext();
  mem->imgui_io = &ImGui::GetIO();
  mem->imgui_io->ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;     // Enable Keyboard Controls

  mem->imgui_style = &ImGui::GetStyle();
  ImGui::StyleColorsDark(mem->imgui_style);
  mem->imgui_style->FrameRounding = 3.0f;
  mem->imgui_style->GrabRounding = 3.0f;

  mem->imgui_style->ScaleAllSizes(primary_scale);
  mem->imgui_style->FontScaleDpi = primary_scale;

  ImGui_ImplSDL3_InitForSDLRenderer(mem->window, mem->renderer);
  ImGui_ImplSDLRenderer3_Init(mem->renderer);

  // Load Fonts
  // - If fonts are not explicitly loaded, Dear ImGui will select an embedded font: either AddFontDefaultVector() or AddFontDefaultBitmap().
  //   This selection is based on (style.FontSizeBase * style.FontScaleMain * style.FontScaleDpi) reaching a threshold.
  // - You can load multiple fonts and use ImGui::PushFont()/PopFont() to select them.
  // - If a file cannot be loaded, AddFont functions will return a nullptr. Please handle those errors in your code (e.g. use an assertion, display an error and quit).
  // - Read 'docs/FONTS.md' for more instructions and details.
  // - Use '#define IMGUI_ENABLE_FREETYPE' in your imconfig file to use FreeType for higher quality font rendering.
  // - Remember that in C/C++ if you want to include a backslash \ in a string literal you need to write a double backslash \\ !
  //io.Fonts->AddFontDefaultVector();
  //io.Fonts->AddFontDefaultBitmap();
  //io.Fonts->AddFontFromFileTTF("c:\\Windows\\Fonts\\segoeui.ttf");
  //io.Fonts->AddFontFromFileTTF("../../misc/fonts/DroidSans.ttf");
  //io.Fonts->AddFontFromFileTTF("../../misc/fonts/Roboto-Medium.ttf");
  //io.Fonts->AddFontFromFileTTF("../../misc/fonts/Cousine-Regular.ttf");
  //ImFont* font = io.Fonts->AddFontFromFileTTF("c:\\Windows\\Fonts\\ArialUni.ttf");
  //IM_ASSERT(font != nullptr);

  mem->time_history = 20.0f;
  mem->newest_time = (float)SDL_GetTicksNS() / 1000'000'000.0f;

  for(uint32_t i = 0; i < Event_Variant_GPIO_PK15; i++) {
    mem->scrolling_gpio_data[i].Init(256);
    mem->scrolling_gpio_data[i].AddPoint(mem->newest_time, 0);
  }

  mem->scrolling_systick_data.Init(4096);
  mem->scrolling_systick_data.AddPoint(mem->newest_time, 0);

  mem->show_implot_style_editor = true;

  return true;
}

DLLEXPORT bool USim_init(void *memory, USim_API *api, const char *board_name, uint64_t usim_id, void **usim_rawmem)
{
  (void)board_name;
  USim_Memory *usim_mem;
  if(!(*usim_rawmem)) {
    usim_mem = (USim_Memory*)SDL_calloc(1, sizeof(USim_Memory));

    usim_mem->api = api;
    usim_mem->target_ns = TARGET_NS;
    if(!Init_Window(usim_mem)) {
      return false;
    }
  } else {
    usim_mem = *((USim_Memory**)usim_rawmem);
  }

  bool ok = true;
  // subscribe to all gpio events
  for(uint8_t i = 0; i < Event_Variant_GPIO_PK15; i++) {
    ok = ok && api->subscribe_event(memory, usim_id, Event_Kind_GPIO, (USim_Event_Variant)i);
  }
  ok = ok && api->subscribe_event(memory, usim_id, Event_Kind_SysTick, Event_Variant_SysTick_Interrupt);
  if(!ok) {
    SDL_Log("Error: Could not subscribe to core simulator events");
    return false;
  }

  *usim_rawmem = usim_mem;
  return true;
}

/* assumes spec is already setup */
inline void plot_gpio_line(const char *title, ImPlotSpec *spec, ScrollingBuffer *buf)
{
  spec->Offset = buf->Offset;
  ImPlot::PlotLine(title, &buf->Data[0].x, &buf->Data[0].y, buf->Data.size(), *spec);
}

void Plot_GPIOGraph(USim_Memory *mem, float oldest)
{
  static const char *gpio_names[] = {
    "PA0", "PA1", "PA2", "PA3", "PA4", "PA5", "PA6", "PA7",
    "PA8", "PA9", "PA10", "PA11", "PA12", "PA13", "PA14", "PA15",
    "PB0", "PB1", "PB2", "PB3", "PB4", "PB5", "PB6", "PB7",
    "PB8", "PB9", "PB10", "PB11", "PB12", "PB13", "PB14", "PB15",
    "PC0", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7",
    "PC8", "PC9", "PC10", "PC11", "PC12", "PC13", "PC14", "PC15",
    "PD0", "PD1", "PD2", "PD3", "PD4", "PD5", "PD6", "PD7",
    "PD8", "PD9", "PD10", "PD11", "PD12", "PD13", "PD14", "PD15",
    "PE0", "PE1", "PE2", "PE3", "PE4", "PE5", "PE6", "PE7",
    "PE8", "PE9", "PE10", "PE11", "PE12", "PE13", "PE14", "PE15",
    "PF0", "PF1", "PF2", "PF3", "PF4", "PF5", "PF6", "PF7",
    "PF8", "PF9", "PF10", "PF11", "PF12", "PF13", "PF14", "PF15",
    "PG0", "PG1", "PG2", "PG3", "PG4", "PG5", "PG6", "PG7",
    "PG8", "PG9", "PG10", "PG11", "PG12", "PG13", "PG14", "PG15",
    "PH0", "PH1", "PH2", "PH3", "PH4", "PH5", "PH6", "PH7",
    "PH8", "PH9", "PH10", "PH11", "PH12", "PH13", "PH14", "PH15",
    0,     0,     0,     0,     0,     0,     0,     0,
    0,     0,     0,     0,     0,     0,     0,     0,
    "PJ0", "PJ1", "PJ2", "PJ3", "PJ4", "PJ5", "PJ6", "PJ7",
    "PJ8", "PJ9", "PJ10", "PJ11", "PJ12", "PJ13", "PJ14", "PJ15",
    "PK0", "PK1", "PK2", "PK3", "PK4", "PK5", "PK6", "PK7",
    "PK8", "PK9", "PK10", "PK11", "PK12", "PK13", "PK14", "PK15",
  };

  static const char *generic_gpio_names[] = {
    "PAx", "PBx", "PCx", "PDx", "PEx",
    "PFx", "PGx", "PHx", 0, "PJx", "PKx",
  };

  static const char *plot_names[] = {
    "##PAx_Graph", "##PBx_Graph", "##PCx_Graph", "##PDx_Graph", "##PEx_Graph",
    "##PFx_Graph", "##PGx_Graph", "##PHx_Graph", 0, "##PJx_Graph", "##PKx_Graph",
  };

  // TODO: Table of graphs so that it can be shown as 5 gpios | 5 gpios
  //                                               or 2 | 2 | 2 | 2 | 2

  float plotHeight = 8*ImGui::GetTextLineHeight();
  ImVec2 windowSize = ImGui::GetMainViewport()->WorkSize;
  static const float pad = 60;

  static const int ncols = 5;
  static const int nrows = SDL_arraysize(plot_names) / ncols;

  uint8_t portpin_idx_min = 0;
  uint8_t portpin_idx_max = 0;
  bool before_skip = true;

  // 10 gpios
  if(ImGui::BeginTable("##GPIO_Graph_Table", ncols)) {
    for(int rowidx = 0; rowidx < nrows; rowidx++) {
      ImGui::TableNextRow();
      for(int colidx = 0; colidx < ncols; colidx++) {
        ImGui::TableSetColumnIndex(colidx);
        size_t i = rowidx*ncols + colidx;
        if(i > ((uint8_t)Event_Variant_GPIO_PH15 / 0x10)) {
          // skip GPIOI since it doesn't exist in stm32h7xx
          i++;
          if(before_skip) {
            portpin_idx_max += 0x10;
            portpin_idx_min += 0x10;
            before_skip = false;
          }
        }
        portpin_idx_max += 0x10;

        if(ImPlot::BeginPlot(plot_names[i], ImVec2((windowSize.x - pad)/ncols, plotHeight))) {
          ImPlot::SetupAxes("time", generic_gpio_names[i]);
          ImPlot::SetupAxisLimits(ImAxis_X1, oldest, mem->newest_time, ImGuiCond_Always);
          ImPlot::SetupAxisLimits(ImAxis_Y1, 0.0, 1.0);

          ImPlotSpec spec;
          spec.Stride = 2 * sizeof(float);
          spec.FillAlpha = 1.0f;

          for(uint8_t idx = portpin_idx_min; idx < portpin_idx_max; idx++) {
            plot_gpio_line(gpio_names[idx], &spec, &mem->scrolling_gpio_data[idx]);
          }

          ImPlot::EndPlot();
        }

        portpin_idx_min += 0x10;
      }
    }

    ImGui::EndTable();
  }
}

void Plot_SysTickGraph(USim_Memory *mem, float oldest)
{
  if(ImPlot::BeginPlot("##SysTick_Graph", ImVec2(-1, 8*ImGui::GetTextLineHeight()))) {
    ImPlot::SetupAxes("time", "SysTick");
    ImPlot::SetupAxisLimits(ImAxis_X1, oldest, mem->newest_time, ImGuiCond_Always);
    ImPlot::SetupAxisLimits(ImAxis_Y1, -0.1, 1.1);

    ImPlotSpec spec;
    spec.Stride = 2 * sizeof(float);
    spec.FillAlpha = 0.8f;
    ScrollingBuffer *buf = &mem->scrolling_systick_data;
    spec.Offset = buf->Offset;
    ImPlot::PlotLine("Interrupt", &buf->Data[0].x, &buf->Data[0].y, buf->Data.size(), spec);

    ImPlot::EndPlot();
  }
}

DLLEXPORT bool USim_update(void *usim_rawmem)
{
  USim_Memory *mem = (USim_Memory*)usim_rawmem;

  uint64_t start_ticks = SDL_GetTicksNS();

sdlPollEvent:
  SDL_Event sdl_event;
  while(SDL_PollEvent(&sdl_event)) {
    ImGui_ImplSDL3_ProcessEvent(&sdl_event);
    if(sdl_event.type == SDL_EVENT_QUIT) {
      // should quit now!
      return true;
    }
    if((sdl_event.type == SDL_EVENT_WINDOW_CLOSE_REQUESTED) &&
      (sdl_event.window.windowID == SDL_GetWindowID(mem->window)))
    {
      // should quit now!
      return true;
    }
  }

  if(SDL_GetWindowFlags(mem->window) & SDL_WINDOW_MINIMIZED) {
    SDL_Delay(10);
    goto sdlPollEvent;
  }

  ImGui_ImplSDLRenderer3_NewFrame();
  ImGui_ImplSDL3_NewFrame();
  ImGui::NewFrame();

  /* -------------------------------- */

  ImGuiWindowFlags window_flags = ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoSavedSettings | ImGuiWindowFlags_NoFocusOnAppearing | ImGuiWindowFlags_NoNav | ImGuiWindowFlags_NoBringToFrontOnFocus;

  const ImGuiViewport *viewport = ImGui::GetMainViewport();
  ImGui::SetNextWindowPos(viewport->GetCenter(), ImGuiCond_Always, ImVec2(0.5f, 0.5f));
  ImGui::SetNextWindowSize(viewport->WorkSize);
  window_flags |= ImGuiWindowFlags_NoMove;

  float oldest = mem->newest_time - mem->time_history;
  if(ImGui::Begin("usim event gathering", 0, window_flags)) {
    ImGui::SliderFloat("History", &mem->time_history, 1.0f, 80.0f, "%.1f s");

    mem->show_gpio_graph |= ImGui::Button("Show GPIO Graph");
    if(mem->show_gpio_graph) {
      if(ImGui::Begin("GPIO Graph", &mem->show_gpio_graph)){
        Plot_GPIOGraph(mem, oldest);
      }
      ImGui::End();
    }

    mem->show_systick_graph |= ImGui::Button("Show SysTick Graph");
    if(mem->show_systick_graph) {
      if(ImGui::Begin("SysTick Graph", &mem->show_systick_graph)) {
        Plot_SysTickGraph(mem, oldest);
      }
      ImGui::End();
    }

    // TODO: Some menu or smt for this?
    if(mem->show_implot_style_editor) {
      ImGui::Begin("Style Editor (ImPlot)", &mem->show_implot_style_editor);
      ImPlot::ShowStyleEditor();
      ImGui::End();
    }

    ImGui::Text("App average %.3f ms/frame (%.1f FPS)",
      1000.0f / mem->imgui_io->Framerate, mem->imgui_io->Framerate
    );
  }
  ImGui::End();

  /* -------------------------------- */

  ImGui::Render();
  SDL_SetRenderScale(mem->renderer,
    mem->imgui_io->DisplayFramebufferScale.x,
    mem->imgui_io->DisplayFramebufferScale.y
  );
  SDL_RenderClear(mem->renderer);
  ImGui_ImplSDLRenderer3_RenderDrawData(ImGui::GetDrawData(), mem->renderer);
  SDL_RenderPresent(mem->renderer);

  /* ----------------------------- */

  USim_Event event;
  while(mem->api->poll_event(mem->api->channel, &event)) {
    float cur_time = (float)event.instant / 1000'000'000.0f;
    mem->newest_time = SDL_max(cur_time, mem->newest_time);

    switch(event.kind) {
      case Event_Kind_Quit: break;
      case Event_Kind_Count: break;

      case Event_Kind_GPIO: {
        mem->scrolling_gpio_data[event.variant].AddPoint(
          cur_time, (float)event.as.gpio.value
        );
      } break;

      case Event_Kind_SysTick: {
        // Easy way to show when SysTick was called, just make a very thin spike
        // +-1 us
        float prev_instant = cur_time + 0.0000001f;
        float next_instant = cur_time + 0.0000001f;
        mem->scrolling_systick_data.AddPoint(prev_instant, 0);
        mem->scrolling_systick_data.AddPoint(cur_time, 1);
        mem->scrolling_systick_data.AddPoint(next_instant, 0);
      } break;
    }
  }

  /* ----------------------------- */

  uint64_t dif_ticks = SDL_GetTicksNS() - start_ticks;
  if(dif_ticks < mem->target_ns) {
    SDL_DelayPrecise(mem->target_ns - dif_ticks);
  }
  mem->delta_time = (float)(SDL_GetTicksNS() - start_ticks)/1000000.0f;

  return false;
}

DLLEXPORT void USim_deinit(void *usim_rawmem)
{
  USim_Memory *mem = (USim_Memory*)usim_rawmem;

  ImGui_ImplSDLRenderer3_Shutdown();
  ImGui_ImplSDL3_Shutdown();
  if(mem->imgui_ctx) {
    ImGui::DestroyContext(mem->imgui_ctx);
  }
  if(mem->implot_ctx) {
    ImPlot::DestroyContext(mem->implot_ctx);
  }
  if(mem->renderer) {
    SDL_DestroyRenderer(mem->renderer);
  }
  if(mem->window) {
    SDL_DestroyWindow(mem->window);
  }
  SDL_Quit();
  SDL_free(mem);
}
