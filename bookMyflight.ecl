IMPORT STD;
IMPORT $.getFlights;
//TTL = Texas to Layover
flightLayout := RECORD
    STRING3             TTLCarrier;
    INTEGER2            TTLFlightNumber;                           // flight number-not unique
    STRING8             TTLEffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             TTLDiscontinueDate;   
    STRING3             TTLDepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING2             TTLDepartStateProvCode;                    // Innovata State Code
    STRING3             TTLDepartCityCode;                         // departure city code contains the city code for the point of trip origin
    STRING10            TTLDepartTimePassenger;                    // published flight departure time; HHMMSS
    STRING2             TTLDepartTerminal;                         // departure terminal
    STRING3             TTLArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING2             TTLArriveStateProvCode;                    // Innovata State Code
    STRING10            TTLArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING2             TTLArriveTerminal;                         // arrival terminal
    INTEGER2            TTLFlightDurationLessLayover;              // fefers to Actual Air time of flight; does not include layover time
    INTEGER2            LayoverTime;
    STRING3             LTBCarrier;
    INTEGER2            LTBFlightNumber;                           // flight number-not unique
    STRING8             LTBEffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             LTBDiscontinueDate;   
    STRING3             LTBDepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING2             LTBDepartStateProvCode;                    // Innovata State Code
    STRING3             LTBDepartCityCode;                         // departure city code contains the city code for the point of trip origin
    STRING10            LTBDepartTimePassenger;                    // published flight departure time; HHMMSS
    STRING2             LTBDepartTerminal;                         // departure terminal
    STRING3             LTBArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING2             LTBArriveStateProvCode;                    // Innovata State Code
    STRING10            LTBArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING2             LTBArriveTerminal;                         // arrival terminal
    INTEGER2            LTBFlightDurationLessLayover;              // fefers to Actual Air time of flight; does not include layover time
    STRING3             BTOCarrier;
    INTEGER2            BTOFlightNumber;                           // flight number-not unique
    STRING8             BTOEffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             BTODiscontinueDate;   
    STRING3             BTODepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING2             BTODepartStateProvCode;                    // Innovata State Code
    STRING3             BTODepartCityCode;                         // departure city code contains the city code for the point of trip origin
    STRING10            BTODepartTimePassenger;                    // published flight departure time; HHMMSS
    STRING2             BTODepartTerminal;                         // departure terminal
    STRING3             BTOArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING2             BTOArriveStateProvCode;                    // Innovata State Code
    STRING10            BTOArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING2             BTOArriveTerminal;                         // arrival terminal
    INTEGER2            BTOFlightDurationLessLayover;              // fefers to Actual Air time of flight; does not include layover time 
    INTEGER3            TotalTimeOfFlight;

END;

FlightsInMarch := getFlights.gsecData(effectivedate BETWEEN '20200301' and '20200331');
OUTPUT(FlightsInMarch, NAMED('FlightsInMarch2020'));

texasDeparture := FlightsInMarch(departstationcode = 'AUS');
OUTPUT(texasDeparture);

chicagoArrival := FlightsInMarch(arrivestationcode = 'BMI');
OUTPUT(chicagoArrival);

texasDepChiArrival := JOIN(texasDeparture, chicagoArrival,
                    (LEFT.arrivestationcode = RIGHT.DepartStationCode
                    AND LEFT.Carrier = RIGHT.Carrier AND 
                    (STD.Date.FromStringToTime(RIGHT.departtimepassenger, '%H%M%S') -  STD.Date.FromStringToTime(LEFT.ArriveTimePassenger, '%H%M%S')
                    between 3600 and 7200)),
                    TRANSFORM(flightLayout,
                        SELF.TTLCarrier := LEFT.Carrier;
                        SELF.TTLArriveStateProvCode := LEFT.ArriveStateProvCode;
                        SELF.TTLArriveStationCode := LEFT.ArriveStationCode;
                        SELF.TTLArriveTerminal := LEFT.ArriveTerminal;
                        SELF.TTLDepartCityCode := LEFT.DepartCityCode;
                        SELF.TTLFlightDurationLessLayover := LEFT.FlightDurationLessLayover;
                        SELF.TTLFlightNumber := LEFT.FlightNumber;
                        SELF.TTLEffectiveDate := LEFT.EffectiveDate;
                        SELF.TTLArriveTimePassenger := LEFT.ArriveTimePassenger;
                        SELF.TTLDepartStateProvCode := LEFT.DepartStateProvCode;
                        SELF.TTLDiscontinueDate := LEFT.DiscontinueDate;
                        SELF.TTLDepartStationCode := LEFT.DepartStationCode;
                        SELF.TTLDepartTimePassenger := LEFT.DepartTimePassenger;
                        SELF.TTLDepartTerminal := LEFT.DepartTerminal;
                        SELF.LTBCarrier := RIGHT.Carrier;
                        SELF.LTBArriveStateProvCode := RIGHT.ArriveStateProvCode;
                        SELF.LTBArriveStationCode := RIGHT.ArriveStationCode;
                        SELF.LTBArriveTerminal := RIGHT.ArriveTerminal;
                        SELF.LTBDepartCityCode := RIGHT.DepartCityCode;
                        SELF.LTBFlightDurationLessLayover := RIGHT.FlightDurationLessLayover;
                        SELF.LTBFlightNumber := RIGHT.FlightNumber;
                        SELF.LTBEffectiveDate := RIGHT.EffectiveDate;
                        SELF.LTBArriveTimePassenger := RIGHT.ArriveTimePassenger;
                        SELF.LTBDepartStateProvCode := RIGHT.DepartStateProvCode;
                        SELF.LTBDiscontinueDate := RIGHT.DiscontinueDate;
                        SELF.LTBDepartStationCode := RIGHT.DepartStationCode;
                        SELF.LTBDepartTimePassenger := RIGHT.DepartTimePassenger;
                        SELF.LTBDepartTerminal := RIGHT.DepartTerminal;
                        SELF.LayoverTime :=  ABS((STD.Date.FromStringToTime(RIGHT.departtimepassenger, '%H%M%S') -  STD.Date.FromStringToTime(LEFT.arrivetimepassenger, '%H%M%S'))/60),  
                        SELF := [];
                    ),ALL);
OUTPUT(texasDepChiArrival,NAMED('texasTochicago'));
OUTPUT(COUNT(texasDepChiArrival),NAMED('CounttexasTochicago'));

nextDayFlight := FlightsInMarch(departstationcode ='BMI' AND arrivestationcode = 'ORD' AND departtimepassenger < '100000.000');
OUTPUT(nextDayFlight, NAMED('nextDayFlight'));

possibleFlights := JOIN(texasDepChiArrival, nextDayFlight,
                ((INTEGER) LEFT.ttleffectivedate + 1 = (INTEGER) RIGHT.effectivedate),
                TRANSFORM(
                    flightLayout,
                    SELF.BTOCarrier := RIGHT.Carrier;
                        SELF.BTOArriveStateProvCode := RIGHT.ArriveStateProvCode;
                        SELF.BTOArriveStationCode := RIGHT.ArriveStationCode;
                        SELF.BTOArriveTerminal := RIGHT.ArriveTerminal;
                        SELF.BTODepartCityCode := RIGHT.DepartCityCode;
                        SELF.BTOFlightDurationLessLayover := RIGHT.FlightDurationLessLayover;
                        SELF.BTOFlightNumber := RIGHT.FlightNumber;
                        SELF.BTOEffectiveDate := RIGHT.EffectiveDate;
                        SELF.BTOArriveTimePassenger := RIGHT.ArriveTimePassenger;
                        SELF.BTODepartStateProvCode := RIGHT.DepartStateProvCode;
                        SELF.BTODiscontinueDate := RIGHT.DiscontinueDate;
                        SELF.BTODepartStationCode := RIGHT.DepartStationCode;
                        SELF.BTODepartTimePassenger := RIGHT.DepartTimePassenger;
                        SELF.BTODepartTerminal := RIGHT.DepartTerminal;       
                        SELF.TotalTimeOfFlight := LEFT.LayoverTime + LEFT.LTBFlightDurationLessLayover + LEFT.TTLFlightDurationLessLayover  + RIGHT.FlightDurationLessLayover;                
                        SELF := LEFT;
                        SELF := [];
                ));
OUTPUT((possibleFlights), NAMED('possibleFlights'));