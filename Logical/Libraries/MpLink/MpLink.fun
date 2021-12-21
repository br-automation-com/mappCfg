
FUNCTION_BLOCK MpReadLink
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType;
		Enable : BOOL;
		ErrorReset : BOOL;
		ParaName : STRING[80];
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		Error : BOOL;
		StatusID : DINT;
		CommandDone : BOOL;
	END_VAR
	VAR
		Info : MpLinkInfoType;
	END_VAR
END_FUNCTION_BLOCK
