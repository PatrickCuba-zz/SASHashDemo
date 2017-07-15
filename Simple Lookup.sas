/* Simple Lookup */
* Find Addresses from the Lookup *;
Data Customer_Detail;
	If _N_=0 Then Set Address;

	If _N_=1 Then Do;
		Declare Hash ReadB(Dataset: "Address");
		ReadB.DefineKey('ClientID');
		ReadB.DefineData('ClientID', 'Suburb', 'State');
		ReadB.DefineDone();

		Call Missing(of _All_);
	End;

	Set Customer;

	/* Fetch Address Details */
	Suburb='';
	State='';
	rc=ReadB.Find();
	* if rc=0; * To return matches only * ;
	Drop Rc;
Run;
