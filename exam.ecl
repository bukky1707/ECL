IMPORT MyMod;
IMPORT STD;

OUTPUT(MyMod);
Properties_Rec := RECORD 
      BOOLEAN PasswordNotReqD {XPATH('passwordnotreqd')};
      BOOLEAN PwdNeverExpires {XPATH('pwdneverexpires')};
      BOOLEAN HasPW {XPATH('hasspn')};
END;

Aces_Rec := RECORD
    STRING  SamplePW1;
    STRING  SamplePW2;
END;

Users_Rec := RECORD
    Properties_Rec Properties;
    Aces_Rec Aces ;
END;

UserSampleDS := DATASET([
                     { true,  false, false,  '20150805', false },
                     { true,  true,  true,   '20210102', false },
                     { false, false, true ,  '20181112', false },
                     { false, false, false , '20190101', false } ],Users_Rec);

//************************************************************
UserWithScore := RECORD
    BOOLEAN  PasswordNotReqD;
    BOOLEAN  PwdNeverExpires;
    BOOLEAN  HasPW;
    INTEGER  Total_PW_Score;
END;

UserWithScore xForm (Users_Rec Le) := TRANSFORM
    SELF.PasswordNotReqD  := Le.Properties.PasswordNotReqD;
    SELF.PwdNeverExpires  := Le.Properties.PwdNeverExpires;
    SELF.HasPW            := Le.Properties.HasPW;

    INTEGER PasswordNotReqDScore := IF(Le.Properties.PasswordNotReqD, 1, 0);
    INTEGER PwdNeverExpiresScore := IF(Le.Properties.PwdNeverExpires, 2, 0);
    INTEGER HasPWScore           := IF(Le.Properties.HasPW, 1, 0);
    INTEGER SamplePW1Score       := IF(STD.Date.DaysBetween((INTEGER)Le.Aces.SamplePW1, STD.Date.Today()) >= 60, 1, 0);  

    SELF.Total_PW_Score       := PasswordNotReqDScore + PwdNeverExpiresScore + HasPWScore + SamplePW1Score;
END;
FinalResult := PROJECT(UserSampleDS, xForm(LEFT));
OUTPUT(FinalResult, NAMED('FinalResult'));

PROJECT(UserSampleDS, TRANSFORM(Users_Rec,SELF := LEFT, SELF := []));