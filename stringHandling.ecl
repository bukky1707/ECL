IMPORT $.getCars;
IMPORT STD;

transformedCars := RECORD
    INTEGER ID;
    STRING carInfo;
    STRING pricePercentage;
    STRING funColors;
    STRING newState;
    string newCondition;
    string newTitleStatus;
END;

getNewCars2 := PROJECT(getCars.CarsDS_Raw, TRANSFORM(   
    transformedCars, 
    SELF.ID := COUNTER;
    Self.carInfo := STD.STR.ToTitleCase(Left.brand) + '_' + STD.STR.ToTitleCase(Left.color);
    Self.funColors :=STD.STR.FindReplace(STD.STR.FindReplace(STD.Str.ToUpperCase(Left.color), 'A', '@'),'E','8');
    Self.newState := STD.Str.Reverse(STD.Str.ToTitleCase(Left.state));
    Self.pricePercentage := (STRING)ROUND((LEFT.price/1000)) + '%';
    Self.newCondition := MAP(STD.Str.Contains(Left.condition,'hours',TRUE)=>'Less Than a Day', 
    STD.Str.Contains(Left.condition,'days',TRUE)=>'Days After Days','Unknown Condition');
    Self.newTitleStatus := STD.STR.FindReplace(STD.Str.ToUpperCase(Left.title_status),' ',' *** ');
));

OUTPUT(CHOOSEN(getNewCars2,151,100), NAMED('funCars'));
OUTPUT(IF(COUNT(getNewCars2(newCondition= 'Unknown Condition')) > 0, 'There is an unknown condition car in the dataset', 'There is not an unknown condition car in the dataset'), NAMED('unknownConditionCars'));
OUTPUT(COUNT(getNewCars2(funColors= 'OR@NG8')), NAMED('orangeCars'));
