
PROGRAM _INIT
	 
END_PROGRAM

PROGRAM _CYCLIC
	IF Read THEN
		MpReadLink_01.Enable := TRUE;
		MpReadLink_01.MpLink := ADR(gDatabaseCore);
	END_IF
	 
END_PROGRAM


