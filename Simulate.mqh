//+--------------------------------------------------------------------------------------------------+
//|                                                                                     Simulate.mqh |
//|                                                                                        MagyarZ95 |
//|                                                                             https://www.mql5.com |
//+--------------------------------------------------------------------------------------------------+
#property copyright "MagyarZ95"
#property link "https://www.mql5.com"
#property version "1.08"
#property description "Simulate - A class for simulating trading results."

//+--------------------------------------------------------------------------------------------------+
//| Class: Simulate                                                                                  |
//| Description: A class for simulating trading results.                                             |
//| Members:                                                                                         |
//|   - double cTotalProfit: Total profit achieved in simulation.                                    |
//|   - int cMax: Maximum value for simulation.                                                      |
//|   - int cMin: Minimum value for simulation.                                                      |
//|   - int cPeriod: Period value for simulation.                                                    |
//|   - double gBuffer[]: Array for storing buffer values.                                           |
//|   - double gBufferMA[]: Array for storing moving average values.                                 |
//| Methods:                                                                                         |
//|   - Simulate(): Default constructor initializing default values.                                 |
//|   - Simulate(totalProfit, buffer[], bufferMA[], max, min, period): Parameterized constructor     |
//|     with user-defined values.                                                                    |
//|   - GetTotalProfit(): Returns the total profit value.                                            |
//|   - GetMax(): Returns the maximum value.                                                         |
//|   - GetMin(): Returns the minimum value.                                                         |
//|   - GetPeriod(): Returns the period value.                                                       |
//|   - GetBuffer(buffer[]): Copies buffer values to the parameter.                                  |
//|   - GetBufferMA(bufferMA[]): Copies MA buffer values to the param.                               |
//|   - Comparable(other): Compares two Simulate instances.                                          |
//| Private Methods:                                                                                 |
//|   - CopyArray(sourceArray[], destinationArray[]): Copies values from sourceArray to              |
//|     destinationArray.                                                                            |
//+--------------------------------------------------------------------------------------------------+
class Simulate {
private:
  double cTotalProfit; 
  int cMax, cMin, cPeriod;

public:
  double gBuffer[], gBufferMA[];
  
  Simulate() {
    cTotalProfit = 0.0;
    cMax = 90;
    cMin = 10;
    cPeriod = 5;
    ArrayResize(gBuffer, 3);
    ArrayResize(gBufferMA, 3);
  }
  
  Simulate(double totalProfit, double &buffer[], double &bufferMA[], int max, int min, int period) {
    cTotalProfit = totalProfit;
    cMax = max;
    cMin = min;
    cPeriod = period;
    CopyArray(buffer, gBuffer);
    CopyArray(bufferMA, gBufferMA);
  }
  
  Simulate(const Simulate &other) {
    cTotalProfit = other.GetTotalProfit();
    cMax = other.GetMax();
    cMin = other.GetMin();
    cPeriod = other.GetPeriod();
    CopyArray(other.gBuffer, gBuffer);
    CopyArray(other.gBufferMA, gBufferMA);
  }
  
  double GetTotalProfit() const {
    return cTotalProfit;
  }
  
  int GetMax() const {
    return cMax;
  }
  
  int GetMin() const {
    return cMin;
  }
  
  int GetPeriod() const {
    return cPeriod;
  }
  
  void GetBuffer(double &buffer[]) {
    CopyArray(gBuffer, buffer);
  }
  
  void GetBufferMA(double &bufferMA[]) {
    CopyArray(gBufferMA, bufferMA);
  }

  int Comparable(const Simulate &other) {
    if (cTotalProfit > other.GetTotalProfit()) return 1;
    else if (cTotalProfit < other.GetTotalProfit()) return -1;
    if (cPeriod > other.GetPeriod()) return 1;
    else if (cPeriod < other.GetPeriod()) return -1;
    if (cMax > other.GetMax()) return 1;
    else if (cMax < other.GetMax()) return -1;
    if (cMin > other.GetMin()) return 1;
    else if (cMin < other.GetMin()) return -1;
    return 0;
  }

private:
  void CopyArray(const double &sourceArray[], double &destinationArray[]) {
    ArrayResize(destinationArray, ArraySize(sourceArray));
    for (int i = 0; i < ArraySize(sourceArray); i++) destinationArray[i] = sourceArray[i];
  }
};