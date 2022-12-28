IMPORT $.getFlights;
//Find the average distance each carrier flies out of each airport by day of week
carrierbyweekday := RECORD
     //getFlights.gsecData.FlightNumber;
     getFlights.gsecData.IsOpMon; getFlights.gsecData.isoptue;
     getFlights.gsecData.isopwed; getFlights.gsecData.isopthu; getFlights.gsecData.isopfri; getFlights.gsecData.isopsat;
     getFlights.gsecData.isopsun;
     avgdistancebyweekday := AVE(GROUP, getFlights.gsecData.FlightDistance);
END;
avgdistbyweekday := TABLE(getFlights.gsecData, carrierbyweekday,getFlights.gsecData.IsOpMon, getFlights.gsecData.isoptue
,getFlights.gsecData.isopwed, getFlights.gsecData.isopthu, getFlights.gsecData.isopfri, getFlights.gsecData.isopsat,
 getFlights.gsecData.isopsun);
OUTPUT(avgdistbyweekday, NAMED('avgdistancebyweekday'));
//How many carriers leave a station?
flightLayout := RECORD
     //getFlights.GSECRec;
     getFlights.gsecData.DepartStationCode;
     numberdepartcarriersbystation := COUNT(GROUP); 
END;
flightsbystation := TABLE(getFlights.gsecData, flightLayout, getFlights.gsecData.departstationcode);
OUTPUT(flightsbystation, NAMED('departcarriersbystation'));

//How many days each carrier operation per flight number?
carrierbyflightnumber := RECORD
     //getFlights.gsecData.FlightNumber;
     getFlights.gsecData.FlightNumber;
     avgdistancebyweekday := COUNT(GROUP);
END;
carrierflights := TABLE(getFlights.gsecData, carrierbyflightnumber,getFlights.gsecData.IsOpMon, getFlights.gsecData.isoptue
,getFlights.gsecData.isopwed, getFlights.gsecData.isopthu, getFlights.gsecData.isopfri, getFlights.gsecData.isopsat,
 getFlights.gsecData.isopsun);
OUTPUT(carrierflights, NAMED('carrierflights'));
// Write 2 additional data aggreation