IMPORT STD;
IMPORT $.getFlights;

flightsLayout:= RECORD
    STRING3             Carrier;                                // two or three letter code assigned by IATA or ICAO for the Carrier
    STRING8             EffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             DiscontinueDate;                        // discontinued date represents the last date that the carrier has scheduled this flight service to operate; YYYYMMDD
    STRING3             DepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING10            DepartTimePassenger;                    // published flight arrival time; HHMMSS
    STRING2             DepartCountryCode;                      // standard IATA Country code for the point of trip origin
    STRING2             DepartStateProvCode;                    // Innovata State Code
    STRING3             DepartCityCode;      
    INTEGER2            FlightDistance;                         // shortest distance (in miles) between the origin and destination points    
    INTEGER2            FirstLegFlightTime;
    STRING3             LayoverStationCode;                      // standard IATA Airport code for the point of arrival
    INTEGER2            LayoverFlightTime;                         // shortest distance (in miles) between the origin and destination points
    INTEGER2            LayoverTime;     
    STRING10            LayoverDepartTimePassenger;  
     STRING10           LayoverArriveTimePassenger;  
    STRING3             ArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING10            ArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING2             ArriveCountryCode;                      // standard IATA Country code for the point of arrival
    STRING2             ArriveStateProvCode;                    // Innovata State Code
    STRING3             ArriveCityCode;                         // arrival city code contains the city code for the point of trip origin
    INTEGER1            NumberOfIntermediateStops;              // set to zero (i.e. nonstop) if the flight does not land between the point of origin and final destination
    STRING3             NextDayCarrier;                                // two or three letter code assigned by IATA or ICAO for the Carrier
    STRING8             NextDayEffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             NextDayDiscontinueDate;                        // discontinued date represents the last date that the carrier has scheduled this flight service to operate; YYYYMMDD
    STRING3             FinalDepartStationCode;                      // standard IATA Airport code for the point of arrival
    STRING10            FinalDepartTimePassenger;                    // published flight arrival time; HHMMSS
    STRING2             FinalDepartCountryCode;                      // standard IATA Country code for the point of trip origin
    STRING2             FinalDepartStateProvCode;                    // Innovata State Code
    STRING3             FinalDepartCityCode; 
    STRING3             FinalArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING10            FinalArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING2             FinalArriveCountryCode;                      // standard IATA Country code for the point of trip origin
    STRING2             FinalArriveStateProvCode;                    // Innovata State Code
    STRING3             FinalArriveCityCode; 
    INTEGER             FinalLegFlightTime;
    INTEGER             TotaltimeofFlight;
    //UNSIGNED            SectorizedId;                           // unique record ID

END;
marchFlights := getFlights.gsecData(effectivedate BETWEEN '20200301' and '20200330');
OUTPUT(marchFlights, NAMED('FlightsInMarch2020'));

texasDeparture := marchFlights(departstationcode = 'AUS');
OUTPUT(texasDeparture);

chicagoArrival := marchFlights(arrivestationcode = 'BMI');
OUTPUT(chicagoArrival);

test := JOIN(texasDeparture, chicagoArrival,
                            (LEFT.arrivestationcode = RIGHT.departstationcode AND 
                            LEFT.Carrier = RIGHT.Carrier AND 
                            (STD.Date.FromStringToTime(RIGHT.departtimepassenger, '%H%M%S') -  STD.Date.FromStringToTime(LEFT.ArriveTimePassenger, '%H%M%S') between 3600 and 7200 AND
                            //LEFT.DepartTimeAircraft   
                            STD.Date.Day(STD.date.FromStringToDate(LEFT.effectivedate, '%m/%d/%Y')) = STD.Date.Day(STD.date.FromStringToDate(RIGHT.effectivedate, '%m/%d/%Y')))), 
                                TRANSFORM(flightsLayout,
                                SELF.arrivestationcode := RIGHT.arrivestationcode,
                                SElf.departstationcode := LEFT.departstationcode,
                                SELF.ArriveTimePassenger := LEFT.ArriveTimePassenger,
                                SELF.LayoverArriveTimePassenger := RIGHT.ArriveTimePassenger,
                                SELF.DepartTimePassenger := LEFT.DepartTimePassenger,
                                SELF.DepartCityCode := LEFT.DepartCityCode,
                                SELF.DepartCountryCode := LEFT.DepartCountryCode,
                                SELF.DepartStateProvCode := LEFT.DepartStateProvCode,
                                SELF.LayoverStationCode := LEFT.ArriveStationCode,
                                SELF.LayoverDepartTimePassenger := RIGHT.DepartTimePassenger,

                                SELF.ArriveCityCode := RIGHT.ArriveCityCode,
                                SELF.ArriveCountryCode := RIGHT.ArriveCountryCode,
                                SELF.ArriveStateProvCode := RIGHT.ArriveStateProvCode,
                                SELF.FirstLegFlightTime := LEFT.FlightDurationLessLayover,
                                SELF.LayoverTime :=  (STD.Date.FromStringToTime(LEFT.arrivetimepassenger, '%H%M%S') -  STD.Date.FromStringToTime(RIGHT.departtimepassenger, '%H%M%S'))/60,                              
                                Self.LayoverFlightTime := RIGHT.FlightDurationLessLayover,
                                SELF.TotaltimeofFlight := SELF.LayoverTime + SELF.LayoverFlightTime + SELF.FirstLegFlightTime,
                                SELF := LEFT,
                                SELF := [],
                               ));

/*test1 := JOIN(chicagoArrival,texasDeparture,
                            LEFT.departstationcode = RIGHT.arrivestationcode AND 
                            LEFT.Carrier = RIGHT.Carrier, 
                                TRANSFORM(getFlights.GSECRec,
                                SELF := LEFT,
                                SElf := RIGHT;
                            ));
OUTPUT(test,NAMED('studentsWithDeclaredMajor'));*/
OUTPUT(test,NAMED('texasTochicago'));
OUTPUT(COUNT(test),NAMED('CounttexasTochicago'));
//OUTPUT(test(layovertime between 60 and),NAMED('texasTochicagoNoStops'));

nextDayFlight := marchFlights(departstationcode ='BMI' AND arrivestationcode = 'ORD' AND departtimepassenger < '100000.000');
OUTPUT(nextDayFlight, NAMED('nextDayFlight'));

//OUTPUT(nextDayFlight(STD.DATE.AdjustDate(STD.DATE.FromStringToDate(effectivedate, '%Y/%m/%d'), , , 1) = 20200310));
finalSet := JOIN(test, nextDayFlight,
             (//STD.Date.DaysBetween(STD.DATE.FromStringToDate(LEFT.effectivedate, '%m/%d/%Y'), STD.date.FromStringToDate(RIGHT.effectivedate, '%m/%d/%Y')) = 1 AND 
             (INTEGER) LEFT.effectivedate + 1 = (INTEGER) RIGHT.effectivedate),
             TRANSFORM(flightsLayout,
             SELF.NextDayCarrier := RIGHT.Carrier,
             SELF.NextDayEffectiveDate := RIGHT.EffectiveDate,
             SELF.NextDayDiscontinueDate := RIGHT.DiscontinueDate,
             SELF.FinalDepartStationCode := RIGHT.DepartStationCode,
             SELF.FinalArriveStationCode := RIGHT.ArriveStationCode,
             SELF.LayoverTime := LEFT.LayoverTime,
             SELF.FinalDepartTimePassenger := RIGHT.DepartTimePassenger,                 
             SELF.FinalDepartCountryCode := RIGHT.DepartCountryCode,                      
             SELF.FinalDepartStateProvCode := RIGHT.DepartStateProvCode,                 
             SELF.FinalDepartCityCode := RIGHT.DepartCityCode,
             SELF.FinalArriveTimePassenger := RIGHT.arrivetimepassenger,                 
             SELF.FinalArriveCountryCode := RIGHT.ArriveCountryCode,                      
             SELF.FinalArriveStateProvCode := RIGHT.ArriveStateProvCode,                 
             SELF.FinalArriveCityCode := RIGHT.ArriveCityCode,
             SELF.FinalLegFlightTime := RIGHT.FlightDurationLessLayover,
             //SELF.TotaltimeofFlight := ((UNSIGNED1)LEFT.DepartTimePassenger[1..2] * 60 + 
	                   //(UNSIGNED1)LEFT.DepartTimePassenger[3..4]),
             SELF.TotaltimeofFlight := LEFT.TotaltimeofFlight + RIGHT.FlightDurationLessLayover,
             SELF := LEFT,
             self := []),ALL);

OUTPUT((finalSet), NAMED('finalSet'));