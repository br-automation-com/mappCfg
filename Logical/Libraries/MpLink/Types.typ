
TYPE
	MpLinkInfoType : 	STRUCT 
		state : MpLinkStateType;
		DevLink_01 : DevLink;
		MpComConfigManager_01 : MpComConfigManager;
	END_STRUCT;
	MpLinkStateType : 
		(
		stateWait,
		stateDevLink,
		stateExport
		);
END_TYPE
