IMPORT $.getCars;

dark_colors := ['gray','black','charcoal','brown','shadow black', 'super black'];
invalidColors := ['color','no_color'];

getNewCar := RECORD
   STRING name;
   String state;
   Boolean Old_Exp;
   String colorType;
END;

// Standalone Functions
getNewCar transformation(getCars.CarsDS_Raw C) := TRANSFORM
    Self := C;
    SELF.name := C.brand + ' ' + C.model;
    Self.Old_Exp := IF(C.price >= 10000 and C.year <= 2012, True, False);
    Self.colorType := (MAP(C.color In invalidColors => 'Invalid Entry', C.color in dark_colors => 'Dark', 'Light'));
END;

projected_cars := PROJECT(getCars.CarsDS_Raw, transformation(LEFT));
OUTPUT(projected_cars, NAMED('Standalone_Transformed_Structure'));

getNewCars := PROJECT(getCars.CarsDS_Raw, TRANSFORM(   
    getNewCar, Self := Left;
    SELF.name := Left.brand + ' ' + Left.model;
    Self.Old_Exp := IF(Left.price >= 10000 and Left.year <= 2012, True, False);
    Self.colorType := (MAP(Left.color In invalidColors => 'Invalid Entry', Left.color in dark_colors => 'Dark', 'Light'));
));

OUTPUT(getNewCars, NAMED('Inline_Transformed_Structure'));
