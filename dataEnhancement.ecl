studentRec := RECORD
 INTEGER studentID;
 STRING name;
 STRING zipCode;
 INTEGER age;
 STRING major;
 BOOLEAN isGraduated;
END;

studentDS := DATASET([{100, 'Zoro', 30330, 26, 'History', TRUE}, {409, 'Dan', 40001, 26, 'Nursing', FALSE},
 {300, 'Sarah', 30000, 25, 'Art', FALSE}, {800, 'Sandy', 30339, 20, 'Math', TRUE},
 {202, 'Alan', 40001, 33, 'Math', TRUE}, {604, 'Danny', 40001, 18, 'N/A', FALSE},
 {305, 'Liz', 30330, 22, 'Chem', TRUE}, {400, 'Matt', 30005, 22, 'nursing', TRUE}],
 studentRec);

 majorRec := RECORD
 STRING majorID;
 STRING majorName;
 INTEGER numOfYears;
 STRING department;
END;

majorDS := DATASET([{'M101', 'Dentist', 5, 'medical'}, {'M102', 'Nursing', 4, 'Medical'}, {'M201', 'Surgeon', 12, 'Medical'},
 {'S101', 'Math', 4, 'Science'}, {'S333', 'Computer', 4, 'Science'}, {'A101', 'Art', 3, 'Art'},
 {'A102', 'Digital Art', 3, 'Art'}],majorRec);

 addressRec := RECORD
    STRING city;
    STRING2 state;
    STRING5 zipCode;
 END;

addrDS := DATASET([{'Atlanta', 'GA', '30330'}, {'atlanta', 'GA', '30331'}, {'Newyork', 'NY', '40001'},
 {'Los A', 'CA', '50001'}, {'Dallas', 'Texas', '30000'}, {'Boston', 'MA', '60067'},
 {'Tampa', 'FL', '30044'}, {'smyrna', 'GA', '30330'}],
 addressRec);

studentsWithDeclaredMajor := JOIN(studentDS, majorDS,
                            LEFT.major = RIGHT.majorName, 
                                TRANSFORM(studentRec,
                                SELF := LEFT,
                                SElf := RIGHT;
                            ));
OUTPUT(studentsWithDeclaredMajor,NAMED('studentsWithDeclaredMajor'));

studentsWithUnDeclaredMajor := JOIN(studentDS, majorDS,
                            LEFT.major = RIGHT.majorName, 
                                TRANSFORM(studentRec,
                                SELF := LEFT,
                                SElf := RIGHT;
                            ), LEFT ONLY);
OUTPUT(studentsWithUnDeclaredMajor,NAMED('studentsWithUnDeclaredMajor'));

studentRec2 := RECORD
 INTEGER studentID;
 STRING name;
 STRING zipCode;
 STRING city;
 INTEGER age;
 STRING major;
 BOOLEAN isGraduated;
END;

graduatedstudentsWithcity := JOIN(studentDS, addrDS,                         
                        LEFT.zipCode = RIGHT.zipCode,
                        TRANSFORM(studentRec2,
                        SELF := LEFT,
                        SELF := RIGHT),
                        LEFT OUTER, LOOKUP);

OUTPUT(graduatedstudentsWithcity(isGraduated = true),NAMED('graduatedstudentsWithcity'));

tempRec := RECORD
    INTEGER studentID;
    STRING name;
    STRING zipCode;
    INTEGER age;
    STRING major;
    BOOLEAN isGraduated;
    STRING department;
END;
allStudentsRec := RECORD
    INTEGER studentID;
    STRING name;
    STRING zipCode;
    STRING city;
    INTEGER age;
    STRING major;
    BOOLEAN isGraduated;
    STRING department;
    STRING2 state;
END;

allStudentinfo := JOIN(studentDS, majorDS,                         
                        LEFT.major = RIGHT.majorName,
                        TRANSFORM(tempRec,
                        SELF := LEFT,
                        SELF := RIGHT,
                        SELF := []), LEFT OUTER);
allStudentinfowithaddress := JOIN(allStudentinfo, addrDS,                         
                            LEFT.zipCode = RIGHT.zipCode,
                            TRANSFORM(allStudentsRec,
                            SELF := LEFT,
                            SELF := RIGHT,
                            ), LEFT OUTER, LOOKUP);
OUTPUT(allStudentinfowithaddress, NAMED('allStudentinfowithaddress'));