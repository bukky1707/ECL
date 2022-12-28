IMPORT $.getFlights;
IMPORT $.getAirlines;
GSECRec2 := RECORD
    STRING3             Carrier;                                // two or three letter code assigned by IATA or ICAO for the Carrier
    INTEGER2            FlightNumber;                           // flight number-not unique
    STRING1             CodeShareFlag;                          // service type indicator is used to classify carriers according to the type of air service they provide
    STRING3             CodeShareCarrier;                       // alternate flight designator or ticket selling airline
    STRING1             ServiceType;                            // classify carriers according to the type of air service they provide
    STRING8             EffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             DiscontinueDate;                        // discontinued date represents the last date that the carrier has scheduled this flight service to operate; YYYYMMDD
    UNSIGNED1           IsOpMon;                                // indicates whether the flight has service on Monday
    UNSIGNED1           IsOpTue;                                // indicates whether the flight has service on Tuesday
    UNSIGNED1           IsOpWed;                                // indicates whether the flight has service on Wednesday
    UNSIGNED1           IsOpThu;                                // indicates whether the flight has service on Thursday
    UNSIGNED1           IsOpFri;                                // indicates whether the flight has service on Friday
    UNSIGNED1           IsOpSat;                                // indicates whether the flight has service on Saturday
    UNSIGNED1           IsOpSun;                                // indicates whether the flight has service on Sunday
    STRING3             DepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING2             DepartCountryCode;                      // standard IATA Country code for the point of trip origin
    STRING2             DepartStateProvCode;                    // Innovata State Code
    STRING3             DepartCityCode;                         // departure city code contains the city code for the point of trip origin
    STRING10            DepartTimePassenger;                    // published flight departure time; HHMMSS
    STRING10            DepartTimeAircraft;                     // agreed SLOT departure time; HHMMSS
    STRING5             DepartUTCVariance;                      // UTC Variant for the departure airport; [+-]HHMM
    STRING2             DepartTerminal;                         // departure terminal
    STRING3             ArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING2             ArriveCountryCode;                      // standard IATA Country code for the point of arrival
    STRING2             ArriveStateProvCode;                    // Innovata State Code
    STRING3             ArriveCityCode;                         // arrival city code contains the city code for the point of trip origin
    STRING10            ArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING10            ArriveTimeAircraft;                     // agreed SLOT arrival time; HHMMSS
    STRING5             ArriveUTCVariance;                      // UTC Variant for the arrival airport; [+-]HHMM
    STRING2             ArriveTerminal;                         // arrival terminal
    STRING3             EquipmentSubCode;                       // sub aircraft type on the first leg of the flight
    STRING3             EquipmentGroupCode;                     // group aircraft type on the first leg of the flight
    VARSTRING4          CabinCategoryClasses;                   // most commonly used service classes
    VARSTRING40         BookingClasses;                         // full list of Service Class descriptions
    INTEGER1            ArriveDayIndicator;                     // signifies which day the flight will arrive with respect to the origin depart day; <blank> = same day, -1 = day before, 1 = day after, 2 = two days after
    INTEGER1            NumberOfIntermediateStops;              // set to zero (i.e. nonstop) if the flight does not land between the point of origin and final destination
    VARSTRING50         IntermediateStopStationCodes;           // IATA airport codes where stops occur, separated by “!”
    BOOLEAN             IsEquipmentChange;                      // signifies whether there has been an aircraft change at a stopover point for the flight leg
    VARSTRING60         EquipmentCodesAcrossSector;             // sub-aircraft type on each leg of the flight
    VARSTRING80         MealCodes;                              // contains up to two meal codes per class of service
    INTEGER2            FlightDurationLessLayover;              // fefers to Actual Air time of flight; does not include layover time
    INTEGER2            FlightDistance;                         // shortest distance (in miles) between the origin and destination points
    INTEGER2            FlightDistanceThroughIndividualLegs;
    INTEGER2            LayoverTime;                            // minutes
    INTEGER2            IVI;
    INTEGER2            FirstLegNumber;
    VARSTRING50         InFlightServiceCodes;
    BOOLEAN             IsCodeShare;                            // true if flight is operated by another carrier
    BOOLEAN             IsWetLease;                             // true if wet lease (owned by one carrier and operated by another)
    VARSTRING155        CodeShareInfo;                          // information regarding operating and marketing carriers
    INTEGER             FirstClassSeats;
    INTEGER             BusinessClassSeats;
    INTEGER             PremiumEconomySeats;
    INTEGER             EconomyClassSeats;
    INTEGER             TotalSeats;
    UNSIGNED            SectorizedId;                           // unique record ID
    UNSIGNED            depart_minutes_after_midnight;
    BOOLEAN             SameStation;
    STRING              ServiceDays;
    BOOLEAN             OnTimeArrival;
END;
//Display the first 200 rows and explore the data

temp := CHOOSEN(getFlights.gsecData, 200);
OUTPUT(temp, NAMED('twohundredflightrows'));

//Filter down to only Delta(DL) flights operating in November 2019, display result as filteredData
OUTPUT(getFlights.gsecData(carrier = 'DL' and effectivedate <= '20191101' and DiscontinueDate >= '20191130'), NAMED('filteredData'));

/*Display Flights that their DepartStationCode are in LHR or ORD
and ArriveStationCode is in JFK, ATL, or ORD. Sort the result by
Carrier and FlightNumber*/
set0 :=  ['LHR','ORD'];
set1 := ['JFK', 'ATL', 'ORD'];
test3 := getFlights.gsecData(DepartStationCode in set0 and getFlights.gsecData.ArriveStationCode IN set1);
OUTPUT(SORT(test3, getFlights.gsecData.carrier, getFlights.gsecData.FlightNumber), NAMED('sortedData'));

//Get the min FlightNumber, save and display result as minFlightNumber
minimum := MIN(getFlights.gsecData, FlightNumber);
OUTPUT(minimum, NAMED('minFlightNumber'));

//Filter your dataset for minFlightNumber and display results as getFlightNumbers
t2:= getFlights.gsecData(getFlights.gsecData.FlightNumber= minimum);
OUTPUT(getFlights.gsecData(getFlights.gsecData.FlightNumber= minimum),NAMED('getFlightNumbers'));

//How may rows are in getFlightNumbers?
OUTPUt(Count(t2), NAMED('minFlights'));

//depart_minutes_after_midnight := ((UNSIGNED1) getFlights.gsecData.DepartTimePassenger[1..2] * 60 +
//(UNSIGNED1) getFlights.gsecData.DepartTimePassenger[3..4]);
//OUTPUT(depart_minutes_after_midnight, NAMED('Flights_after_midnight'));

getNewFlights := PROJECT(getFlights.gsecData, TRANSFORM(   
    GSECRec2, Self := Left;
    SELF.depart_minutes_after_midnight := (UNSIGNED1) LEFT.DepartTimePassenger[1..2] * 60 +
    (UNSIGNED1) LEFT.DepartTimePassenger[3..4];
    SELF.SameStation := IF(LEFT.departstationcode = LEFT.arrivestationcode, TRUE, FALSE);
    SELF.ServiceDays := IF(LEFT.isopmon + LEFT.isoptue + LEFT.isopwed + LEFT.isopthu +LEFT.isopfri + LEFT.isopsat +
    LEFT.isopsun = 7, 'Open all days','Not open all days');
    SELF.OnTimeArrival := IF(LEFT.ArriveTimeAircraft = LEFT.ArriveTimePassenger, TRUE, FALSE);
));
OUTPUT(COUNT(getNewFlights(SameStation = TRUE)));
OUTPUT(getNewFlights, NAMED('Enriched_Flight_Dataset'));

