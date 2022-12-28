IMPORT $.getCars;


allMinPrices := MAX(getCars.CarsDS_Raw, price);
OUTPUT(getCars.CarsDS_Raw(price = allMinPrices), NAMED('allMinPrices'));

avgPrice := ROUND(AVE(getCars.CarsDS_Raw, price),2);
OUTPUT(avgPrice, NAMED('averagePriceofCars'));
OUTPUT(getCars.CarsDS_Raw(price > avgPrice), NAMED('expCars'));

