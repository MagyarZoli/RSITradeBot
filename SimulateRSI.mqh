//+--------------------------------------------------------------------------------------------------+
//|                                                                                  SimulateRSI.mqh |
//|                                                                                        MagyarZ95 |
//|                                                                             https://www.mql5.com |
//+--------------------------------------------------------------------------------------------------+
#property copyright "MagyarZ95"
#property link "https://www.mql5.com"
#property version "1.08"
#property description "SimulateRSI - A class for simulating RSI-based trading strategies."

#include "Simulate.mqh"

//+--------------------------------------------------------------------------------------------------+
//| Class: SimulateRSI                                                                               |
//| Description: A class for simulating RSI-based trading strategies.                                |
//| Members:                                                                                         |
//|   - string cSymbol: Symbol for trading.                                                          |
//|   - ENUM_TIMEFRAMES cPeriod: Timeframe for trading.                                              |
//|   - int cPeriodRSI: RSI period for the strategy.                                                 |
//|   - int cPeriodMA: Moving Average period for the strategy.                                       |
//|   - ENUM_APPLIED_PRICE cAppliedPrice: Applied price for trading.                                 |
//|   - int cMax: Maximum RSI level for strategy.                                                    |
//|   - int cMin: Minimum RSI level for strategy.                                                    |
//|   - int cShift: Shift value for data retrieval.                                                  |
//|   - int cTimeInterval: Time interval between simulated trades.                                   |
//|   - int gHandle: Indicator handle for RSI.                                                       |
//|   - int gSellCount, gBuyCount: Counters for sell and buy trades.                                 |
//|   - int gSellSimulate[], gBuySimulate[]: Arrays for simulated sell and buy trades.               |
//|   - double gSellProfit, gBuyProfit: Total profits for sell and buy trades.                       |
//|   - double gBufferRSI[], gBufferMA[]: Arrays for RSI and Moving Average values.                  |
//|   - double gSellApplied[], gBuyApplied[]: Arrays for applied prices in sell and buy trades.      |
//|   - datetime gLastOrderTime: Time of the last simulated trade.                                   |
//|   - bool gHighLevel[2], gLowLevel[2]: Flags indicating if RSI is above or below predefined levels|
//|   - bool gStrategy[4], gSellStrategy[2], gBuyStrategy[2]: Flags indicating active                |
//|     trading strategies.                                                                          |
//|   - Simulate gSell, gBuy: Instances of Simulate class for sell and buy trades.                   |
//| Methods:                                                                                         |
//|   - SimulateRSI(): Default constructor initializing default values and handles.                  |
//|   - SimulateRSI(symbol, period, periodRSI, periodMA, appliedPrice, max, min, shift,              |
//|     timeInterval): Parameterized constructor with user-defined values.                           |
//|   - SimulateRSI(other): Copy constructor for creating an instance based on another instance.     |
//|   - GetSymbol(): Returns the trading symbol.                                                     |
//|   - GetPeriod(): Returns the trading timeframe.                                                  |
//|   - GetPeriodRSI(): Returns the RSI period.                                                      |
//|   - GetPeriodMA(): Returns the Moving Average period.                                            |
//|   - GetAppliedPrice(): Returns the applied price for trading.                                    |
//|   - GetMax(): Returns the maximum RSI level.                                                     |
//|   - GetMin(): Returns the minimum RSI level.                                                     |
//|   - GetShift(): Returns the shift value for data retrieval.                                      |
//|   - GetTimeInterval(): Returns the time interval between trades.                                 |
//|   - GetSellSimulate(): Returns the Simulate instance for sell trades.                            |
//|   - GetBuySimulate(): Returns the Simulate instance for buy trades.                              |
//|   - GetSellTotalProfit(): Returns the total profit for sell trades.                              |
//|   - GetBuyTotalProfit(): Returns the total profit for buy trades.                                |
//|   - Tick(): Simulates trading logic based on RSI and Moving Average indicators.                  |
//|   - Comparable(other): Compares two SimulateRSI instances based on various parameters.           |
//| Private Methods:                                                                                 |
//|   - HandleInit(): Initializes the indicator handle and arrays.                                   |
//|   - SimulateSellStrategy(): Simulates the sell strategy.                                         |
//|   - SimulateBuyStrategy(): Simulates the buy strategy.                                           |
//|   - SimulateTradeSell(index): Simulates sell trade at given index                                |
//|   - SimulateTradeBuy(index): Simulates buy trade at given index.                                 |
//|   - SimulateCloseSell(close): Simulates closing sell trade.                                      |
//|   - SimulateCloseBuy(close): Simulates closing buy trade.                                        |
//|   - Level(border): Determines RSI levels for trading.                                            |
//|   - RSIMovingAverage(): Calculates RSI moving average.                                           |
//+--------------------------------------------------------------------------------------------------+
class SimulateRSI {
private:
  string cSymbol;
  int cPeriodRSI, cPeriodMA, cMax, cMin, cShift, cTimeInterval;
  ENUM_TIMEFRAMES cPeriod;
  ENUM_APPLIED_PRICE cAppliedPrice;
  
  int gHandle, gSellCount, gBuyCount;
  int gSellSimulate[], gBuySimulate[];
  double  gSellProfit, gBuyProfit;
  double gBufferRSI[], gBufferMA[], gSellApplied[], gBuyApplied[];
  datetime gLastOrderTime;
  bool gHighLevel[2], gLowLevel[2], gStrategy[4], gSellStrategy[2], gBuyStrategy[2];
  Simulate gSell, gBuy;
  
public:
  SimulateRSI() {
    cSymbol = _Symbol;
    cPeriod = PERIOD_CURRENT;
    cPeriodRSI = 5;
    cPeriodMA = 3;
    cAppliedPrice = PRICE_CLOSE;
    cMax = 90;
    cMin = 10;
    cShift = 1;
    cTimeInterval = 1;
    HandleInit();
  }
  
  SimulateRSI(string symbol, ENUM_TIMEFRAMES period, int periodRSI, int periodMA, ENUM_APPLIED_PRICE appliedPrice, int max, int min, int shift, int timeInterval) {
    cSymbol = symbol;
    cPeriod = period;
    cPeriodRSI = periodRSI;
    cPeriodMA = periodMA;
    cAppliedPrice = appliedPrice;
    cMax = max;
    cMin = min;
    cShift = shift;
    cTimeInterval = timeInterval;
    HandleInit();
  }
  
  SimulateRSI(const SimulateRSI &other) {
    cSymbol = other.GetSymbol();
    cPeriod = other.GetPeriod();
    cPeriodRSI = other.GetPeriodRSI();
    cPeriodMA = other.GetPeriodMA();
    cAppliedPrice = other.GetAppliedPrice();
    cMax = other.GetMax();
    cMin = other.GetMin();
    cShift = other.GetShift();
    cTimeInterval = other.GetTimeInterval();
    HandleInit();
  }
  
  string GetSymbol() const {
    return cSymbol;
  }
  
  ENUM_TIMEFRAMES GetPeriod() const {
    return cPeriod;
  }
 
  int GetPeriodRSI() const {
    return cPeriodRSI;
  }
  
  int GetPeriodMA() const {
    return cPeriodMA;
  }
  
  ENUM_APPLIED_PRICE GetAppliedPrice() const {
    return cAppliedPrice;
  }
  
  int GetMax() const {
    return cMax;
  }
  
  int GetMin() const {
    return cMin;
  }
  
  int GetShift() const {
    return cShift;
  }
  
  int GetTimeInterval() const {
    return cTimeInterval;
  }

  Simulate GetSellSimulate() const {
    return gSell;
  }
  
  Simulate GetBuySimulate() const {
    return gBuy;
  }
  
  double GetSellTotalProfit() const {
    return gSell.GetTotalProfit();
  }
  
  double GetBuyTotalProfit() const {
    return gBuy.GetTotalProfit();
  }
  
  void Tick() {
    CopyBuffer(gHandle, 0, cShift, 3, gBufferRSI);
    CopyBuffer(gHandle, 0, cShift, cPeriodMA, gBufferMA);
    if (TimeCurrent() > gLastOrderTime + cTimeInterval) {
      Level(10);
      gSell = SimulateSellStrategy();
      gBuy = SimulateBuyStrategy();
      gLastOrderTime = TimeCurrent();
    }
  }
  
  int Comparable(const SimulateRSI &other) {
    if (gBuy.Comparable(other.GetBuySimulate()) >= 1) return 1;
    else if (gBuy.Comparable(other.GetBuySimulate()) <= -1) return -1;
    if (cPeriod > other.GetPeriod()) return 1;
    else if (cPeriod < other.GetPeriod()) return -1;
    if (cPeriodRSI > other.GetPeriodRSI()) return 1;
    else if (cPeriodRSI < other.GetPeriodRSI()) return -1;
    if (cPeriodMA > other.GetPeriodMA()) return 1;
    else if (cPeriodMA < other.GetPeriodMA()) return -1;
    if (cAppliedPrice > other.GetAppliedPrice()) return 1;
    else if (cAppliedPrice < other.GetAppliedPrice()) return -1;
    if (cMax > other.GetMax()) return 1;
    else if (cMax < other.GetMax()) return -1;
    if (cMin > other.GetMin()) return 1;
    else if (cMin < other.GetMin()) return -1;
    if (cShift > other.GetShift()) return 1;
    else if (cShift < other.GetShift()) return -1;
    if (cTimeInterval > other.GetTimeInterval()) return 1;
    else if (cTimeInterval < other.GetTimeInterval()) return -1;
    if (cSymbol.Compare(other.GetSymbol(), true) >= 1) return 1;
    else if (cSymbol.Compare(other.GetSymbol(), true) <= -1) return -1;
    return 0;
  }
  
private:
  void HandleInit() {
    SetIndexBuffer(0, gBufferRSI);
    gHandle = iRSI(cSymbol, cPeriod, cPeriodRSI, cAppliedPrice);
    if (gHandle == INVALID_HANDLE) {
      Alert("Failed to create indicator handle ", GetLastError());
      return;
    }
    gSellCount = 0;
    gBuyCount = 0;
    ArraySetAsSeries(gBufferRSI, true);
    ArraySetAsSeries(gBufferMA, true);
    ArrayResize(gSellApplied, 30);
    ArrayResize(gBuyApplied, 30);
    gLastOrderTime = TimeCurrent() - cTimeInterval;
    Tick();
  }
  
  Simulate SimulateSellStrategy() {
    double totalProfit = 0.0, rsima = RSIMovingAverage();
    if (gBufferRSI[0] < gBufferRSI[1]) {
      if (gSellStrategy[0] && gBufferRSI[1] >= (cMax - cPeriodRSI) && gBufferRSI[1] < cMax) {
        gSellStrategy[0] = false;
        totalProfit += SimulateCloseBuy(SimulateTradeSell(0));
      } else if (gSellStrategy[1] && gBufferRSI[1] >= cMax && gBufferRSI[1] < (cMax + cPeriodRSI)) {
        gSellStrategy[1] = false;
        totalProfit += SimulateCloseBuy(SimulateTradeSell(1));
      } else if (!gStrategy[0] && gBufferRSI[1] >= (cMax + cPeriodRSI)) {
        gStrategy[0] = true;
        totalProfit += SimulateCloseBuy(SimulateTradeSell(2));
      }
    } else if (!gStrategy[1] && (gBufferRSI[0] > cMax || gBufferRSI[1] > cMax) && gBufferRSI[0] < gBufferRSI[1]) {
      gStrategy[1] = true;
      totalProfit += SimulateCloseBuy(SimulateTradeSell(3));
    } else if (!gStrategy[2] && !gHighLevel[0] && gHighLevel[1]) {
      gStrategy[2] = true;
      totalProfit += SimulateCloseBuy(SimulateTradeSell(4));
    } else if (!gStrategy[3] && rsima >= cMax) {
      gStrategy[3] = true;
      totalProfit += SimulateCloseBuy(SimulateTradeSell(5));
    }
    return Simulate(totalProfit, gBufferRSI, gBufferMA, cMax, cMin, cPeriodRSI);
  }
  
  Simulate SimulateBuyStrategy() {
    double totalProfit = 0.0, rsima = RSIMovingAverage();
    if (gBufferRSI[0] > gBufferRSI[1]) {
      if (gBuyStrategy[0] && gBufferRSI[1] <= (cMin + cPeriodRSI) && gBufferRSI[1] > cMin) {
        gBuyStrategy[0] = false;
        totalProfit += SimulateCloseSell(SimulateTradeBuy(0));
      } else if (gBuyStrategy[1] && gBufferRSI[1] <= cMin && gBufferRSI[1] > (cMin - cPeriodRSI)) {
        gBuyStrategy[1] = false;
        totalProfit += SimulateCloseSell(SimulateTradeBuy(1));
      } else if (gStrategy[0] && gBufferRSI[1] <= (cMin - cPeriodRSI)) {
        gStrategy[0] = false;
        totalProfit += SimulateCloseSell(SimulateTradeBuy(2));
      }
    } else if (gStrategy[1] && (gBufferRSI[0] < cMin || gBufferRSI[1] < cMin) && gBufferRSI[0] > gBufferRSI[1]) {
      gStrategy[1] = false;
      totalProfit += SimulateCloseSell(SimulateTradeBuy(3));
    } else if (gStrategy[2] && !gLowLevel[0] && gLowLevel[1]) {
      gStrategy[2] = false;
      totalProfit += SimulateCloseSell(SimulateTradeBuy(4));
    } else if (gStrategy[3] && rsima <= cMin) {
      gStrategy[3] = false;
      totalProfit += SimulateCloseSell(SimulateTradeBuy(5));
    }
    return Simulate(totalProfit, gBufferRSI, gBufferMA, cMax, cMin, cPeriodRSI);
  }
  
  double SimulateTradeSell(int index) {
    switch (cAppliedPrice) {
      case PRICE_CLOSE:
        gSellApplied[index] = iClose(cSymbol, cPeriod, 0);
        break;
      case PRICE_HIGH:
        gSellApplied[index] = iHigh(cSymbol, cPeriod, 0);
        break;
      case PRICE_LOW:
        gSellApplied[index] = iLow(cSymbol, cPeriod, 0);
        break;
      case PRICE_OPEN:
        gSellApplied[index] = iOpen(cSymbol, cPeriod, 0);
        break;
    }
    return gSellApplied[index];
  }
  
  double SimulateTradeBuy(int index) {
    switch (cAppliedPrice) {
      case PRICE_CLOSE:
        gBuyApplied[index] = iClose(cSymbol, cPeriod, 0);
        break;
      case PRICE_HIGH:
        gBuyApplied[index] = iHigh(cSymbol, cPeriod, 0);
        break;
      case PRICE_LOW:
        gBuyApplied[index] = iLow(cSymbol, cPeriod, 0);
        break;
      case PRICE_OPEN:
        gBuyApplied[index] = iOpen(cSymbol, cPeriod, 0);
        break;
    }
    return gBuyApplied[index];
  }
  
  double SimulateCloseSell(double close) {
    double result = 0.0;
    for (int i = 0; i < ArraySize(gSellApplied); i++) {
      if (gSellApplied[i] == 0) continue;
      result += gSellApplied[i] - close;
      gSellApplied[i] = 0;
    }
    return result;
  }
  
  double SimulateCloseBuy(double close) {
    double result = 0.0;
    for (int i = 0; i < ArraySize(gBuyApplied); i++) {
      if (gBuyApplied[i] == 0) continue;
      result += close - gBuyApplied[i];
      gBuyApplied[i] = 0;
    }
    return result;
  }
  
  void Level(int border) {
    for (int i = 0; i <= 1; i++) {
      if (gBufferRSI[i] > cMax) gHighLevel[i] = true;
      else if (gBufferRSI[i] < (cMax - border)) gHighLevel[i] = false;
      if (gBufferRSI[i] < cMin) gLowLevel[i] = true;
      else if (gBufferRSI[i] > (cMin + border)) gLowLevel[i] = false;
    }
  }
  
  double RSIMovingAverage() {
    double rsima = 0;
    for (int i = 0; i < ArraySize(gBufferMA); i++) rsima += gBufferMA[i];
    return rsima / cPeriodMA;
  }
};