
TYPE
	workStationList_typ : 	STRUCT 
		listProvider : STRING[800];
		stationCounter : USINT;
		tmpString : STRING[80];
	END_STRUCT;
	local_typ : 	STRUCT 
		workStationList : workStationList_typ;
		tableConfigClick : BOOL;
		tableConfigString : STRING[80];
		tableConfigID : USINT;
	END_STRUCT;
END_TYPE
