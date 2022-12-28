IMPORT $.getCars;

newLayout := RECORD
     getCars.CarsDS_Raw.brand;
     AvgCost := AVE(GROUP, getCars.CarsDS_Raw.price);
END;

carsTable := TABLE(getCars.CarsDS_Raw, newLayout, getCars.CarsDS_Raw.brand);

OUTPUT(carsTable, NAMED('brand_Cost_Avg'));

newLayout2 := RECORD
     getCars.CarsDS_Raw.model;
     getCars.CarsDS_Raw.brand;
     AvgCost := AVE(GROUP, getCars.CarsDS_Raw.price);
END;

carsTable2 := TABLE(getCars.CarsDS_Raw, newLayout2,getCars.CarsDS_Raw.model, getCars.CarsDS_Raw.brand);

OUTPUT(carsTable2, NAMED('brand_Model_Avg'));

newLayout3 := RECORD
     getCars.CarsDS_Raw.year;
     getCars.CarsDS_Raw.brand;
     Total := COUNT(GROUP);
END;

carsTable3 := TABLE(getCars.CarsDS_Raw, newLayout3, getCars.CarsDS_Raw.brand);

OUTPUT(carsTable3, NAMED('brand_Year_Sum'));

getSample := SAMPLE(carsTable3, 2, 5);

OUTPUT(getSample, NAMED('getSample'));

distcars := DISTRIBUTE(getSample, HASH32(year));
OUTPUT(distcars, NAMED('distcars'));