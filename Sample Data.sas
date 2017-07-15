/* Sample Tables */
Data Customer;
	Infile Datalines Truncover DSD DLM=',';
	Input ClientID : 8.
          Name     : $20.
		  ;
	Datalines;
1, Tommy
2, James
3, Mary
4, Timothy
5, John
6, Janine
8, Jasmin
;
Run;
Data Address;
	Infile Datalines Truncover DSD DLM=',';
	Input ClientID : 8.
          Suburb   : $30.
          State    : $3.
		  ;
	Datalines;
1, Roseville, NSW
2, Bankstown, NSW
3, Ultimo, NSW
4, Figg Tree Pocket, QLD
5, Cleveland, QLD
6, Geelong, VIC
7, Joondalup, WA
;
Run;
Data Account_Balance;
	Infile Datalines Truncover DSD DLM=',';
	Input ClientID : 8.
          Acct     : 8.
          Bal      : 8.
		  ;
	Datalines;
1, 1, 50
1, 2, 100
2, 3, 50
3, 3, 5
4, 4, 500
5, 5, 20
5, 6, 110
6, 7, 10
7, 8, 0
;
Run;

