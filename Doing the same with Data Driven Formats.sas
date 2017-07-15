/* Build Suburb & State Formats */
Data Fmt;
	Set Address End=End;
	Fmtname='Set_Suburb';
	Start=ClientID;
	Label=Suburb;
	Output;
	Fmtname='Set_State';
	Label=State;
	Output;

	If End Then Do;
		Fmtname='Set_Suburb';
		HLO='O';
		Start=.;
		Label='';
		Output;
		Fmtname='Set_State';
		Output;
	End;
Run;
Proc Sort Data=Fmt;
	By Fmtname ClientID;
Run;
Proc Format Cntlin=Fmt;
Run;

/* Build Balance Format */
Data Fmt;
	Set Account_Balance End=End;
	By ClientID Acct;

	Fmtname='Client_Bal';
	Start=ClientID;

	If First.ClientID Then Label=0;

	Label+Bal;

	If Last.ClientID;

	Output;

	If End Then Do;
		HLO='O';
		Label=0;
		Start=.;
		Output;
	End;
Run;
Proc Format Cntlin=Fmt;
Run;

/* Apply Formats to incoming dataset */
Data Customer_Detail(Keep=ClientID Cust_Bal Suburb State Name) 
     State_Summ(Keep=State StateBal);
	Length _NewState $3.;
	Set Customer End=End;

	Retain _NewState '' StateBal . ;

	Suburb=Put(ClientID, Set_Suburb.);
	State=Put(ClientID, Set_State.);

	If _N_=1 Then _NewState=State;

	Cust_Bal=Input(Put(ClientID, Client_Bal.), 8.);
	StateBal=Sum(StateBal, Cust_Bal);

	_NewStateBal=Lag1(StateBal);

	Output Customer_Detail;

	If _NewState ne State or End Then Do;
		_HoldState=State;
		State=_NewState;

		If ^End Then StateBal=_NewStateBal;
		Output State_Summ;
		StateBal=0;
		StateBal=Sum(StateBal, Cust_Bal);
		State=_HoldState;
		_NewState=State;
	End;
Run;

/* Pull Individual States from State Summary */
Data _Null_;
	Set State_Summ;

	Call Symput(Compress('Each_State_'||_N_), State);
	Call Symput('Max_States', _n_);
Run;

/* Create Each Dataset using the Generated State Variables */
%Macro EachState;
	%Do i = 1 %to &Max_States.;
		Data &&Each_State_&i.;	
			Set State_Summ;
			Where State="&&Each_State_&i.";
		Run;
	%End;
%Mend;
%EachState;


Proc SQL Noprint;
	Select State Into :SQL_Each_State_1-
	From State_Summ;
Quit;
%Let SQL_Max_States=&SQLOBS.;
%Macro EachState;
	%Do i = 1 %to &SQL_Max_States.;
		Proc SQL Noprint;
			Create Table &&SQL_Each_State_&i. As
			Select *
			From State_Summ
			Where State="&&SQL_Each_State_&i.";
		Quit;
	%End;
%Mend;
%EachState;
