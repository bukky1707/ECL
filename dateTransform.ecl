IMPORT $.getStoreSale;
IMPORT STD;

//OUTPUT((getStoreSale.SalesDS));
dateRec := RECORD
    INTEGER2 year; 
END;

OUTPUT(COUNT(getStoreSale.SalesDS(STD.Date.DaysBetween(STD.date.FromStringToDate(orderdate, '%m/%d/%Y'), STD.date.FromStringToDate(shipdate, '%m/%d/%Y'))>5 and profit < 200)),NAMED('NotProfitable'));

temp := getStoreSale.SalesDS(STD.DATE.Month(STD.date.FromStringToDate(orderdate, '%m/%d/%Y')) = 12 and STD.DATE.Day(STD.date.FromStringToDate(orderdate, '%m/%d/%Y')) BETWEEN 15 and 31 
and STD.date.FromStringToDate(shipdate, '%m/%d/%Y') < STD.Date.DateFromParts((STD.DATE.Year(STD.date.FromStringToDate(orderdate, '%m/%d/%Y'))) + 1,1,15) and profit > 250);
OUTPUT(temp,NAMED('LowProfit'));

LeapYear := getStoreSale.SalesDS(STD.Date.IsDateLeapYear(STD.date.FromStringToDate(orderdate, '%m/%d/%Y')));
yeartransform := PROJECT(LeapYear, TRANSFORM(   
    dateRec, 
    Self.year := STD.Date.Year(STD.date.FromStringToDate(Left.orderdate, '%m/%d/%Y'));
));
OUTPUT(DEDUP(yeartransform), NAMED('LeapYear'));
