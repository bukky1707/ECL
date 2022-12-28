EXPORT getCars := MODULE 
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

  EXPORT CarsDS_Raw := DATASET('~us::cars::raw::thor', // File name
                    Cars_Rec,       // Record definition
                    THOR); //  File type with indicator that row one is the header
  
  END;