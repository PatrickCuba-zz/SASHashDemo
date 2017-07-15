Proc SQL Noprint;
	Create Table Customer_Detail As
	Select a.ClientID	
		 , Name
		 , Suburb
         , State
		 , Sum(CustBal, 0) as CustBal
	From Customer a
	Left Join Address b
	On a.ClientID=b.ClientID
	Left Join 
	(Select ClientID
	      , Sum(Bal) As CustBal
	 From Account_Balance
	 Group By 1) c
	 On a.ClientID=c.ClientID
	;
Quit;

Proc Summary Data=Customer_Detail Noprint Missing Nway;
	Class State;
	Output Out=State_Summary(Drop=_Type_ _Freq_) Sum(CustBal)=StateBal;
	Output Out=NSW_Summary(Drop=_Type_ _Freq_ Where=(State='NSW')) Sum(CustBal)=StateBal;
	Output Out=QLD_Summary(Drop=_Type_ _Freq_ Where=(State='QLD')) Sum(CustBal)=StateBal;
	Output Out=VIC_Summary(Drop=_Type_ _Freq_ Where=(State='VIC')) Sum(CustBal)=StateBal;
Quit;