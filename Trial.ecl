IMPORT $.getEmp;

getEmpNew := RECORD
   UNSIGNED personID;
   String fullName;
   Boolean manager;
   String EmpBand;
   BOOLEAN isPromoting;
END;
OUTPUT(getEmp.empDS, Named('OriginalDataset'));

getNewEmployees := PROJECT(getEmp.empDS, TRANSFORM(
    getEmpNew, SELF.fullName := Left.firstName + ' ' + Left.lastName;
    Self.manager := IF(Left.empGroupNum IN [600, 700, 800], True, False);
    Self.EmpBand := IF((Left.empGroupNum IN [500, 600, 700, 800] and Left.avgHouseIncome >= 80000),'Upper', 'Lower');
    Self.isPromoting := [];
    SELF := Left;
));

OUTPUT(getNewEmployees, NAMED('TransformedDS'));