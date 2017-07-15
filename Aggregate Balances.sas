/* Hash Iterator Example */
/* Aggregate balances from multiple accounts */
Data Customer_Detail;
	If _N_=0 Then Set Address Account_Balance;

	If _N_=1 Then Do;
		Declare Hash ReadB(Dataset: "Address");
		ReadB.DefineKey('ClientID');
		ReadB.DefineData('ClientID', 'Suburb', 'State');
		ReadB.DefineDone();

		Declare Hash RBalances(Dataset: "Account_Balance", Ordered: "a", Multidata: "Yes");
		RBalances.DefineKey('ClientID'); 
		RBalances.DefineData('ClientID', 'Acct', 'Bal');
		RBalances.DefineDone();

		Call Missing(of _All_);
	End;

	Set Customer;

	/* Fetch Address Details */
	Suburb='';
	State='';
	rc=ReadB.Find();
	
	/* Aggregate the Balances to a Client */
	Cust_Bal=0;
	Bal=0;
	rc=RBalances.Find();
	Do Until(rc ne 0);
		Cust_Bal=Cust_Bal+Bal;
		rc=RBalances.Find_Next();		
	End;
	Drop Rc Acct Bal;
Run;
