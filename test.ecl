OUTPUT('My First Code', NAMED('Test'));
Cars_Rec := RECORD
      INTEGER  carID;
      INTEGER  price;
      STRING   brand;
      STRING   model;
      INTEGER  year;
      STRING   title_status;
      REAL     mileage;
      STRING   color;
      INTEGER  vin;
      INTEGER  lotNum;
      STRING   state;
      STRING   country;
      STRING   condition;
END;

// Create dataset: file is a csv format
CarsDS_Raw := DATASET('~raw::usa_cars.csv',         // File name
                    Cars_Rec,       // Record definition
                    CSV(HEADING(1))); //  File type with indicator that row one is the header

// Covert to thor file, speeds up execustion time
OUTPUT(CarsDS_Raw,,'~us::cars::raw::thor', OVERWRITE, EXPIRE(180));

sometwoHundredRecords := CHOOSEN(CarsDS_Raw, 200);
OUTPUT(sometwoHundredRecords, NAMED('sometwoHundredRecords'));

someFiftyRecords := CHOOSEN(CarsDS_Raw, 50, 150);
OUTPUT(someFiftyRecords, NAMED('someFiftyRecords'));

cars_2008 := CarsDS_Raw(year = 2008);
OUTPUT(SORT(cars_2008, Brand),NAMED('Cars_2008'));
OUTPUT(CarsDS_Raw(price BETWEEN 10000 and 15000 AND year > 2018), NAMED('price_Range_between_10000_and_15000'));

OUTPUT(CarsDS_Raw(country NOT IN ['usa']), NAMED('NotUSAcountries'));

//Valid prices are prices greater than zero, if no value returns then all prices are valid
OUTPUT(CarsDS_Raw(price < 0), NAMED('Validation_of_prices'));

//Validation check 1 - Check if all the years are valid
OUTPUT(CarsDS_Raw(year < 1900), NAMED('Validation_of_years'));

//Validation check 2 - Check if all the states are valid states in USA and Canada
OUTPUT(CarsDS_Raw(state not in ['alabama', 'alaska', 'american samoa', 'arizona', 'arkansas', 'california', 'colorado', 'connecticut', 'delaware', 'district of columbia', 'florida', 'georgia', 'guam', 'hawaii', 'idaho', 'illinois', 'indiana', 'iowa', 'kansas', 'kentucky', 'louisiana', 'maine', 'maryland', 'massachusetts', 'michigan', 'minnesota', 'minor outlying islands', 'mississippi', 'missouri', 'montana', 'nebraska', 'nevada', 'new hampshire', 'new jersey', 'new mexico', 'new york', 'north carolina', 'north dakota', 'northern mariana islands', 'ohio', 'oklahoma', 'oregon', 'pennsylvania', 'puerto rico', 'rhode island', 'south carolina', 'south dakota', 'tennessee', 'texas', 'U.S. Virgin Islands', 'utah', 'vermont', 'virginia', 'washington', 'west virginia', 'wisconsin', 'wyoming','ontario']), NAMED('Validation_of_states'));
