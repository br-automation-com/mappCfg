// -------------------------------------------------------------------------
// Read mapp configuration parameter
// -------------------------------------------------------------------------
FUNCTION_BLOCK MpReadLink
	// -------------------------------------------------------------------------
	// MpLink state machine
	CASE Info.state OF
		// -------------------------------------------------------------------------
		// Wait for new command
		stateWait:
			IF Enable THEN
				Active := TRUE;
				Info.state := stateDevLink;
			ELSE
				Active := FALSE;
			END_IF
		// -------------------------------------------------------------------------
		// Link file device used for exporting data
		stateDevLink:
			Info.DevLink_01.enable 	:= TRUE;
			Info.DevLink_01.pDevice := ADR('MpLinkDev');
			Info.DevLink_01.pParam	:= ADR('/DEVICE=C:/');
			Info.DevLink_01();
		
			// Success
			IF Info.DevLink_01.status = ERR_OK THEN
				Info.state := stateExport;
			// Errror
			ELSIF Info.DevLink_01.status <> ERR_FUB_BUSY THEN
			END_IF
		// -------------------------------------------------------------------------
		// Export mapp data
		stateExport:
			Info.MpComConfigManager_01.Enable 		:= TRUE;
			Info.MpComConfigManager_01.DeviceName 	:= ADR('MpLinkDev');
			Info.MpComConfigManager_01.FileName 	:= ADR('MpLink.xml');
			Info.MpComConfigManager_01.Scope		:= mpCOM_CONFIG_SCOPE_COMPONENT;
			Info.MpComConfigManager_01.Export		:= TRUE;
			Info.MpComConfigManager_01();
			
			IF Info.MpComConfigManager_01.CommandDone THEN
			END_IF
	END_CASE;
END_FUNCTION_BLOCK
