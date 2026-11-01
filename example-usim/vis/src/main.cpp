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

  // ['A','K'] (both included)
  ScrollingBuffer scrolling_gpio_data['K' - 'A' + 1];
  ScrollingBuffer scrolling_systick_data;
  float newest_time;
  float time_history;
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

  mem->time_history = 80.0f;
  mem->newest_time = (float)SDL_GetTicksNS() / 1000'000'000.0f;

  mem->scrolling_gpio_data['A' - 'A'].Init();
  mem->scrolling_gpio_data['B' - 'A'].Init();
  mem->scrolling_gpio_data['C' - 'A'].Init();
  mem->scrolling_gpio_data['D' - 'A'].Init();
  mem->scrolling_gpio_data['E' - 'A'].Init();
  mem->scrolling_gpio_data['F' - 'A'].Init();
  mem->scrolling_gpio_data['G' - 'A'].Init();
  mem->scrolling_gpio_data['H' - 'A'].Init();
  // there is no gpio['I']
  mem->scrolling_gpio_data['J' - 'A'].Init();
  mem->scrolling_gpio_data['K' - 'A'].Init();
  mem->scrolling_systick_data.Init(4096);

  mem->scrolling_gpio_data['A' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['B' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['C' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['D' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['E' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['F' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['G' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['H' - 'A'].AddPoint(mem->newest_time, 0);
  // there is no gpio['I']
  mem->scrolling_gpio_data['J' - 'A'].AddPoint(mem->newest_time, 0);
  mem->scrolling_gpio_data['K' - 'A'].AddPoint(mem->newest_time, 0);
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

  bool ok = api->subscribe_event(memory, Event_Kind_GPIO_Modified, usim_id);
  ok = ok && api->subscribe_event(memory, Event_Kind_SysTick, usim_id);
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
  if(ImPlot::BeginPlot("##GPIO_Graph", ImVec2(-1, 20*ImGui::GetTextLineHeight()))) {
    ImPlot::SetupAxes("time", "GPIO values");
    ImPlot::SetupAxisLimits(ImAxis_X1, oldest, mem->newest_time, ImGuiCond_Always);
    ImPlot::SetupAxisLimits(ImAxis_Y1, 0, (double)0xFFFFU);

    ImPlotSpec spec;
    spec.Stride = 2 * sizeof(float);
    spec.FillAlpha = 0.8f;

    plot_gpio_line("GPIOA", &spec, &mem->scrolling_gpio_data['A' - 'A']);
    plot_gpio_line("GPIOB", &spec, &mem->scrolling_gpio_data['B' - 'A']);
    plot_gpio_line("GPIOC", &spec, &mem->scrolling_gpio_data['C' - 'A']);
    plot_gpio_line("GPIOD", &spec, &mem->scrolling_gpio_data['D' - 'A']);
    plot_gpio_line("GPIOE", &spec, &mem->scrolling_gpio_data['E' - 'A']);
    plot_gpio_line("GPIOF", &spec, &mem->scrolling_gpio_data['F' - 'A']);
    plot_gpio_line("GPIOG", &spec, &mem->scrolling_gpio_data['G' - 'A']);
    plot_gpio_line("GPIOH", &spec, &mem->scrolling_gpio_data['H' - 'A']);
    // there is no 'I'
    plot_gpio_line("GPIOJ", &spec, &mem->scrolling_gpio_data['J' - 'A']);
    plot_gpio_line("GPIOK", &spec, &mem->scrolling_gpio_data['K' - 'A']);

    ImPlot::EndPlot();
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

  ImGuiWindowFlags window_flags = ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoSavedSettings | ImGuiWindowFlags_NoFocusOnAppearing | ImGuiWindowFlags_NoNav;

  const ImGuiViewport *viewport = ImGui::GetMainViewport();
  ImGui::SetNextWindowPos(viewport->GetCenter(), ImGuiCond_Always, ImVec2(0.5f, 0.5f));
  ImGui::SetNextWindowSize(viewport->WorkSize);
  window_flags |= ImGuiWindowFlags_NoMove;

  float oldest = mem->newest_time - mem->time_history;
  if(ImGui::Begin("usim event gathering", 0, window_flags)) {
    ImGui::SliderFloat("History", &mem->time_history, 1.0f, 160.0f, "%.1f s");

    Plot_GPIOGraph(mem, oldest);
    Plot_SysTickGraph(mem, oldest);

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

      case Event_Kind_GPIO_Modified: {
        mem->scrolling_gpio_data[event.as.gpio_mod.gpio_char - 'A'].AddPoint(
          cur_time, (float)event.as.gpio_mod.value
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
