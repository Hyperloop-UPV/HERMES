#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package fmi3

import "core:c"

Status :: enum {
  OK,
  Warning,
  Discard,
  Error,
  Fatal,
}

DependencyKind :: enum {
  Independent,
  Constant,
  Fixed,
  Tunable,
  Discrete,
  Dependent,
}

IntervalQualifier :: enum {
  NotYetKnown,
  Unchanged,
  Changed,
}

LogMessageCallback :: #type proc "c"(instanceEnvironment: InstanceEnvironment, status: Status, category, message: String)

ClockUpdateCallback :: #type proc "c"(instanceEnvironment: InstanceEnvironment)

IntermediateUpdateCallback :: #type proc "c"(instanceEnvironment: InstanceEnvironment, intermediateUpdateTime: Float64, intermediateVariableSetRequested, intermediateVariableGetAllowed, intermediateStepFinished, canReturnEarly: Boolean, earlyReturnRequested: ^Boolean, earlyReturnTime: ^Float64)

LockPreemptionCallback :: #type proc "c"()
UnlockPreemptionCallback :: #type proc "c"()

/***************************************************
Types for Common Functions
****************************************************/

GetVersionTYPE :: #type proc "c"() -> cstring

SetDebugLoggingTYPE :: #type proc "c"(instance: Instance, loggingOn: Boolean, nCategories: c.size_t, categories: [^]String) -> Status

InstantiateModelExchangeTYPE :: #type proc "c"(instanceName, instantiationToken, resourcePath: String, visible, loggingOn: Boolean, instanceEnvironment: InstanceEnvironment, logMessage: LogMessageCallback) -> Instance

InstantiateCoSimulationTYPE :: #type proc "c"(instanceName, instantiationToken, resourcePath: String, visible, loggingOn, eventModeUsed, earlyReturnAllowed: Boolean, requiredIntermediateValues: [^]ValueReference, nRequiredIntermediateVariables: c.size_t, instanceEnvironment: InstanceEnvironment, logMessage: LogMessageCallback, intermediateUpdate: IntermediateUpdateCallback) -> Instance

InstantiateScheduledExecutionTYPE :: #type proc "c"(instanceName, instantiationToken, resourcePath: String, visible, loggingOn: Boolean, instanceEnvironment: InstanceEnvironment, logMessage: LogMessageCallback, clockUpdate: ClockUpdateCallback, lockPreemption: LockPreemptionCallback, unlockPreemption: UnlockPreemptionCallback) -> Instance

FreeInstanceTYPE :: #type proc "c"(instance: Instance)

EnterInitializationModeTYPE :: #type proc "c"(instance: Instance, toleranceDefined: Boolean, tolerance, startTime: Float64, stopTimeDefined: Boolean, stopTime: Float64) -> Status

ExitInitializationModeTYPE :: #type proc "c"(instance: Instance) -> Status

EnterEventModeTYPE :: #type proc "c"(instance: Instance) -> Status

TerminateTYPE :: #type proc "c"(instance: Instance) -> Status

ResetTYPE :: #type proc "c"(instance: Instance) -> Status

/* Getting and setting variable values */

GetFloat32TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Float32, nValues: c.size_t) -> Status

GetFloat64TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Float64, nValues: c.size_t) -> Status

GetInt8TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int8, nValues: c.size_t) -> Status

GetUInt8TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt8, nValues: c.size_t) -> Status

GetInt16TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int16, nValues: c.size_t) -> Status

GetUInt16TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt16, nValues: c.size_t) -> Status

GetInt32TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int32, nValues: c.size_t) -> Status

GetUInt32TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt32, nValues: c.size_t) -> Status

GetInt64TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int64, nValues: c.size_t) -> Status

GetUInt64TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt64, nValues: c.size_t) -> Status

GetBooleanTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Boolean, nValues: c.size_t) -> Status

GetStringTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]String, nValues: c.size_t) -> Status

GetBinaryTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, valueSizes: [^]c.size_t, values: [^]Binary, nValues: c.size_t) -> Status


GetClockTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Clock) -> Status


SetFloat32TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Float32, nValues: c.size_t) -> Status

SetFloat64TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Float64, nValues: c.size_t) -> Status

SetInt8TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int8, nValues: c.size_t) -> Status

SetUInt8TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt8, nValues: c.size_t) -> Status

SetInt16TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int16, nValues: c.size_t) -> Status

SetUInt16TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt16, nValues: c.size_t) -> Status

SetInt32TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int32, nValues: c.size_t) -> Status

SetUInt32TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt32, nValues: c.size_t) -> Status

SetInt64TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Int64, nValues: c.size_t) -> Status

SetUInt64TYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]UInt64, nValues: c.size_t) -> Status

SetBooleanTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Boolean, nValues: c.size_t) -> Status

SetStringTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]String, nValues: c.size_t) -> Status

SetBinaryTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, valueSizes: [^]c.size_t, values: [^]Binary, nValues: c.size_t) -> Status


SetClockTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, values: [^]Clock) -> Status


GetNumberOfVariableDependenciesTYPE :: #type proc "c"(instance: Instance, valueReference: ValueReference, nDependencies: ^c.size_t) -> Status

GetVariableDependenciesTYPE :: #type proc "c"(instance: Instance, dependent: ValueReference, elementIndicesOfDependent: [^]c.size_t, independents: [^]ValueReference, elementIndicesOfIndependents: [^]c.size_t, dependencyKinds: [^]DependencyKind, nDependencies: c.size_t) -> Status

GetFMUStateTYPE :: #type proc "c"(instance: Instance, fmuState: ^FMUState) -> Status

SetFMUStateTYPE :: #type proc "c"(instance: Instance, fmuState: FMUState) -> Status

FreeFMUStateTYPE :: #type proc "c"(instance: Instance, fmuState: ^FMUState) -> Status

SerializeFMUStateTYPE :: #type proc "c"(instance: Instance, fmuState: FMUState, serializedState: [^]Byte, size: c.size_t) -> Status

DeserializeFMUStateTYPE :: #type proc "c"(instance: Instance, fmuState: FMUState, serializedState: [^]Byte, size: c.size_t) -> Status

GetDirectionalDerivativeTYPE :: #type proc "c"(instance: Instance, unknowns: [^]ValueReference, nUnknowns: c.size_t, knowns: [^]ValueReference, nKnowns: c.size_t, seed: [^]Float64, nSeed: c.size_t, sensitivity: [^]Float64, nSensitivity: c.size_t) -> Status

GetAdjointDerivativeTYPE :: #type proc "c"(instance: Instance, unknowns: [^]ValueReference, nUnknowns: c.size_t, knowns: [^]ValueReference, nKnowns: c.size_t, seed: [^]Float64, nSeed: c.size_t, sensitivity: [^]Float64, nSensitivity: c.size_t) -> Status

EnterConfigurationModeTYPE :: #type proc "c"(instance: Instance) -> Status

ExitConfigurationModeTYPE :: #type proc "c"(instance: Instance) -> Status


GetIntervalDecimalTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, intervals: [^]Float64, qualifiers: [^]IntervalQualifier) -> Status

GetIntervalFractionTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, counters, resolutions: [^]UInt64, qualifiers: [^]IntervalQualifier) -> Status

GetShiftDecimalTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, shifts: [^]Float64) -> Status

GetShiftFractionTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, counters, resolutions: [^]UInt64) -> Status


SetIntervalDecimalTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, intervals: [^]Float64, qualifiers: [^]IntervalQualifier) -> Status

SetIntervalFractionTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, counters, resolutions: [^]UInt64, qualifiers: [^]IntervalQualifier) -> Status

SetShiftDecimalTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, shifts: [^]Float64) -> Status

SetShiftFractionTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, counters, resolutions: [^]UInt64) -> Status


EvaluateDiscreteStatesTYPE :: #type proc "c"(instance: Instance) -> Status

UpdateDiscreteStatesTYPE :: #type proc "c"(instance: Instance, discreteStatesNeedUpdate, terminateSimulation, nominalsOfContinuousStatesChanged, valuesOfContinuousStatesChanged, nextEventTimeDefined, nextEventTime: ^Boolean) -> Status


EnterContinuousTimeModeTYPE :: #type proc "c"(instance: Instance) -> Status

CompletedIntegratorStepTYPE :: #type proc "c"(instance: Instance, noSetFMUStatePriorToCurrentPoint: Boolean, enterEventMode, terminateSimulation: ^Boolean) -> Status

SetTimeTYPE :: #type proc "c"(instance: Instance, time: Float64) -> Status

SetContinuousStatesTYPE :: #type proc "c"(instance: Instance, continuousStates: [^]Float64, nContinuousStates: c.size_t) -> Status

GetContinuousStateDerivativesTYPE :: #type proc "c"(instance: Instance, derivatives: [^]Float64, nContinuousStates: c.size_t) -> Status

GetEventIndicatorsTYPE :: #type proc "c"(instance: Instance, eventIndicators: [^]Float64, nEventIndicators: c.size_t) -> Status

GetContinuousStatesTYPE :: #type proc "c"(instance: Instance, continuousStates: [^]Float64, nContinuousStates: c.size_t) -> Status

GetNominalOfContinuousStatesTYPE :: #type proc "c"(instance: Instance, nominals: [^]Float64, nContinuousStates: c.size_t) -> Status


GetNumberOfEventIndicatorsTYPE :: #type proc "c"(instance: Instance, nEventIndicators: ^c.size_t) -> Status

GetNumberOfContinuousStatesTYPE :: #type proc "c"(instance: Instance, nContinuousStates: ^c.size_t) -> Status

EnterStepModeTYPE :: #type proc "c"(instance: Instance) -> Status

GetOutputDerivativesTYPE :: #type proc "c"(instance: Instance, valueReferences: [^]ValueReference, nValueReferences: c.size_t, orders: [^]Int32, values: [^]Float64, nValues: c.size_t) -> Status

DoStepTYPE :: #type proc "c"(instance: Instance, currentCommunicationPoint, communicationStepSize: Float64, noSetFMUStatePriorToCurrentPoint: Boolean, eventHandlingNeeded, terminateSimulation, earlyReturn: ^Boolean, lastSuccessfulTime: ^Float64) -> Status

ActivateModelPartitionTYPE :: #type proc "c"(instance: Instance, clockReference: ValueReference, activationTime: Float64) -> Status
