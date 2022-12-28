IMPORT STD;

STRING str1:='Today is sunny with chance of rain.';
STRING str2:='This class is awesome :)';
string str3:='Can I take a break tomorrow?';

OUTPUT(STD.Str.CompareIgnoreCase(str1,'Today is sunny With'),NAMED('isEqual'));
OUTPUT(STD.Str.Contains(str2,'abcjklol',TRUE),NAMED('isIncluded'));
OUTPUT(STD.Str.CountWords(STD.STR.ToCapitalCase(Str2),' '), NAMED('wordCount'));
OUTPUT(STD.STR.FindWord(str3,'Taking'), NAMED('isTaking'));
OUTPUT(STD.STR.FindReplace(str3, 'a', '@'), NAMED('replaceMe'));
OUTPUT(STD.STR.Repeat('Life is nice :)',3), NAMED('threeFun'));
OUTPUT(STD.STR.SplitWords(str3, 'a'), NAMED('aSplit'));
OUTPUT(STD.STR.Reverse(str3), NAMED('backward'));
OUTPUT(MAP(STD.Str.CompareIgnoreCase(str3,'Did you take a break?') = -1 => 'Bigger', 
STD.Str.CompareIgnoreCase(str3,'Did you take a break?') = 1 => 'smaller', 
'Why not!'), NAMED('checkFacts'));




