
TYPE
	MpCfgInfoType : 	STRUCT 
		state : MpCfgStateType;
		DevLink_1 : DevLink;
		FileOpen_1 : FileOpen;
		FileRead_1 : FileRead;
		FileWrite_1 : FileWrite;
		FileClose_1 : FileClose;
		MpComConfigManager_1 : MpComConfigManager;
		Buffer : ARRAY[0..MpCfgMaxBufferSize]OF USINT;
		NodeName : STRING[MpCfgMaxNameSize];
		NodeValue : STRING[MpCfgMaxValueSize];
		offset1 : DINT;
		offset2 : DINT;
		len : DINT;
		tmpStr1 : STRING[MpCfgMaxNameSize];
		tmpStr2 : STRING[MpCfgMaxNameSize];
	END_STRUCT;
	MpCfgStateType : 
		(
		stateWait,
		stateDevLink,
		stateExport,
		stateOpen,
		stateRead,
		stateWrite,
		stateClose,
		stateFindData,
		stateInsertData,
		stateError
		);
END_TYPE
