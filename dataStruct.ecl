person_Rec := RECORD
  UNSIGNED  personID;
  STRING15  firstName;
  STRING25  lastName;
  BOOLEAN   isEmployed;
  UNSIGNED  avgHouseIncome; 
  INTEGER   empGroupNum;
END;

//Inline dataset
empDS := DATASET([ {1102,'Fred','Smith', FALSE, 1000, 900},
                       {1102,'Fact','Smith', TRUE, 200000, 100},
                       {1012,'Joe','Blow', TRUE, 11250, 200},
                       {1085,'Blue','Moon', TRUE, 185000, 500},
                       {1055,'Silver','Jo', FALSE, 5000, 900},
                       {1265,'Darling','Jo', TRUE, 5000, 100},
                       {1265,'Blue','Silver', TRUE, 75000, 200},
                       {1333,'Jane','Smith', FALSE, 50000, 900},
                       {1023,'Alex','Donny',TRUE, 102000, 200},
                       {1024,'Nancy','Alp', TRUE, 201100, 700},
                       {1025,'Sunny', 'Alp', FALSE, 20055, 300},
                       {1025,'Jack', 'Smith', TRUE, 34455, 300},
                       {1025,'River', 'Blue', FALSE, 45667, 700},
                       {1025,'Math', 'Fun', TRUE, 21000, 200}, 
                       {1025,'Zack', 'Foo', FALSE, 87200, 600}, 
                       {1025,'Sarah', 'Cream', TRUE, 56000, 400},
                       {1025,'Mary', 'Foo', FALSE, 45500, 700},
                       {1025,'Dan', 'Jo', FALSE, 23500, 600},
                       {1025,'Nancy', 'Sunlight', TRUE, 90000, 800},
                       {1025,'Don', 'Sunlight', TRUE, 105000, 800},
                       {1333,'Funny','Joke', FALSE, 31450, 103}]
                        ,person_Rec);

SET OF INTEGER lowerIncome  := [10000, 12000, 13000, 8000, 8500];
SET OF INTEGER higherIncome  := [90000, 80000, 75000];

INTEGER upperBand  := 100000;
INTEGER lowerBand  := 10000;

midRangeIncome := (empDS(avgHouseIncome BETWEEN lowerBand and upperBand));
OUTPUT(midRangeIncome, NAMED('midRangeIncome'));

employees1 := empDS(avgHouseIncome NOT IN lowerIncome);
OUTPUT(employees1, NAMED('avgHouseIncome_is_not_in_lowerIncome'));

employees2 := empDS(avgHouseIncome IN higherIncome);
OUTPUT(employees2, NAMED('avgHouseIncome_is_in_higherIncome'));

OUTPUT(COUNT(empDS(lastName = 'Jo')),NAMED('peopleNamedJo'));

temp := empDS(isEmployed = true);
OUTPUT(ROUND(SUM(temp, avgHouseIncome),2),NAMED('incomeSum'));

maxVal := MAX(empDS, empGroupNum);
minVal := MIN(empDS, empGroupNum);

STRING maximum := (STRING) maxVal;
STRING minimum := (STRING) minVal;

STRING final := 'Max Group Number is ' + maximum + ', and Min Group Num is ' + minimum;
OUTPUT(final);