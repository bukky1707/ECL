STRING5 firstName := 'Bukky';
STRING lastName := 'Adekunle';
STRING fullName := 'My full name is ' + firstName + ' ' + lastName;
OUTPUT(fullName, NAMED('fullName'));

INTEGER2 num1 := 234;
INTEGER num2 := 345;
STRING StrNum1 := (STRING) num1;
STRING StrNum2 := (STRING) num2;
STRING concatMe := StrNum1 + strNum2;
OUTPUT(concatMe, NAMED('concatMe'));

INTEGER difference  := num1 - num2;
STRING result := (STRING) difference;
OUTPUT(result, NAMED('result'));

INTEGER Two  := 2;
INTEGER total := 100 + 200 * Two;
OUTPUT(total, NAMED('Total'));