# Kereskedési stratégia szimulációja az RSI Expert Advisor segítségével

Ez az adattár MQL5 kódot tartalmaz a kereskedési stratégia szimulálásához és teszteléséhez a Relative Strength Index (RSI) mutató segítségével. A stratégiát egy Expert Advisor (EA) hajtja végre, amely osztályokat használ szimulációhoz és kereskedési logikához.

## Tartalomjegyzék

- [Bevezetés](#bevezetés)
- [Használat](#usage)
- [Parameters](#parameters)
- [Tesztelés és optimalizálás](#testing-and-optimization)
- [Licenc](#licenc)

## Bevezetés

A projekt három elsődleges MQL5 fájlból áll:

1. **Simulate.mqh**: Tartalmazza a "Simulate" osztályt, amely a kereskedési műveletek szimulálására és a teljesítménymutatók követésére szolgál.

2. **SimulateRSI.mqh**: Kibővíti a "Simulate" osztályt, és az RSI indikátoron és a mozgóátlagokon alapuló kereskedési stratégiát valósít meg.

3. **RsiEA.mq5**: A fő szakértői tanácsadó (EA), amely a "SimulateRSI" osztályt használja az RSI-alapú kereskedési stratégia szimulálására és tesztelésére.

## Használat
1. **Fájlok másolása**: Másolja a `Simulate.mqh`, `SimulateRSI.mqh`, `RsiEA.mq5` fájlokat a MetaTrader terminál "Experts" könyvtárába.

2. **Fordítás**: Fordítsa le az `RsiEA.mq5` szkriptet a MetaEditor segítségével.

3. **Futtassa az EA-t**: Húzza az összeállított EA-t (`RsiEA.ex5`) egy diagramra a MetaTraderben. Győződjön meg arról, hogy az automatizált kereskedés engedélyezve van.

4. **Paraméterek beállítása**: Módosítsa az EA paramétereit kereskedési preferenciáinak megfelelően. A részletekért lásd a *Paraméterek* részt.

## Paraméterek
Az "RsiEA.mq5" szkript különféle paramétereket tartalmaz, amelyek beállíthatók a kereskedési stratégia testreszabásához. Íme a legfontosabb paraméterek:

- **Magic Number**: Az EA kereskedéseinek egyedi azonosítója.
- **Lot Size**: Az egyes kereskedési pozíciók mérete.
- **Stop Loss and Take Profit**: Értékek a veszteség megállítása és a profit bevétele szintjének beállításához.
Alkalmazott ár: A számításokban használt ár (pl. zárás, magas, alacsony, nyitás).
- **RSI-paraméterek**: Arány, Keskeny, Óra, Eltolás az RSI-számításhoz.
- **MA paraméterek**: A mozgóátlag kiszámításának időszaka.

## Tesztelés és optimalizálás
A kereskedési stratégia teszteléséhez és optimalizálásához kövesse az alábbi lépéseket:

1. **Visszatesztelés**: Végezzen visszaellenőrzést a MetaTraderben a korábbi adatok felhasználásával a stratégia teljesítményének értékeléséhez.

2. **Optimalizálás**: Állítsa be a paramétereket, hogy megtalálja az optimális készletet a nyereség maximalizálásához vagy a veszteségek minimalizálásához.

3. **Forward Testing**: A stratégiát demo számlán vagy kis élő ügyletekkel valósítsa meg a valós idejű teljesítmény megfigyeléséhez.

## Licenc
Ez a projekt az MIT Licenc alatt van licencelve.

Kérjük, vegye figyelembe, hogy ez egy általános sablon, és előfordulhat, hogy a projekt konkrét részletei és követelményei alapján módosítania kell.