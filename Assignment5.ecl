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

CarsDS_Raw := DATASET('~us::cars::raw::thor', // File name
                    Cars_Rec,       // Record definition
                    THOR); //  File type with indicator that row one is the header


STRING fullName(STRING firstName, INTEGER val1, INTEGER val2) := FUNCTION
    STRING value := (STRING) val1;
    STRING result := 'Hello ' + firstName + ' welcome to this function, ' + value + ' is your lucky number.';
    RETURN result;
END;

OUTPUT(FullName('Bukky',17,2),named('LuckyNumber'));

STRING GetMaxPrice(DATASET(Cars_Rec) temp, STRING input):= FUNCTION 
    maximumPrice := MAX(temp, price);
    STRING answer := 'My name is ' +  input + ' and max price is: ' + maximumPrice;
    RETURN answer;
END;
OUTPUT(GetMaxPrice(CarsDS_Raw, 'Bukky'), named('GetMaxPrice'));


  

