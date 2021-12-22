// -------------------------------------------------------------------------
// Read mapp configuration parameter
// -------------------------------------------------------------------------
FUNCTION_BLOCK MpCfgRW
	// -------------------------------------------------------------------------
	// MpLink state machine
	CASE Info.state OF
		// -------------------------------------------------------------------------
		// Wait for new command
		stateWait:
			// Reset all funtion blocks
			Info.DevLink_1.enable 				:= FALSE;
			Info.DevLink_1();
			Info.MpComConfigManager_1.Enable 	:= FALSE;
			Info.MpComConfigManager_1();
			Info.FileOpen_1.enable				:= FALSE;
			Info.FileOpen_1();
			Info.FileRead_1.enable				:= FALSE;
			Info.FileRead_1();
			Info.FileClose_1.enable				:= FALSE;
			Info.FileClose_1();

			IF Enable THEN
				Active := TRUE;
				DataType := '';
				Value := '';
				Info.state := stateDevLink;
			ELSE
				Active := FALSE;
				CommandDone := FALSE;
			END_IF
		// -------------------------------------------------------------------------
		// Link file device used for exporting data
		stateDevLink:
			Info.DevLink_1.enable 	:= TRUE;
			Info.DevLink_1.pDevice	:= ADR('MpCfgDev');
			Info.DevLink_1.pParam	:= ADR('/DEVICE=C:/');
			Info.DevLink_1();
		
			// Success
			IF Info.DevLink_1.status = ERR_OK OR Info.DevLink_1.status = fiERR_DEVICE_ALREADY_EXIST THEN
				Info.state := stateExport;
			// Errror
			ELSIF Info.DevLink_1.status <> ERR_FUB_BUSY THEN
				StatusID := Info.DevLink_1.status;
				Info.state := stateError;
			END_IF
		// -------------------------------------------------------------------------
		// Export mapp data
		stateExport:
			Info.MpComConfigManager_1.Enable 		:= TRUE;
			Info.MpComConfigManager_1.MpLink		:= ADR(MpLink);
			Info.MpComConfigManager_1.DeviceName 	:= ADR('MpCfgDev');
			Info.MpComConfigManager_1.FileName 		:= ADR('MpCfg.xml');
			Info.MpComConfigManager_1.Scope			:= mpCOM_CONFIG_SCOPE_COMPONENT;
			Info.MpComConfigManager_1.Export		:= TRUE;
			Info.MpComConfigManager_1();
			
			// Success
			IF Info.MpComConfigManager_1.CommandDone AND NOT Info.MpComConfigManager_1.Error THEN
				Info.state := stateOpen;
			// Errror
			ELSIF Info.MpComConfigManager_1.Error THEN
				StatusID := Info.MpComConfigManager_1.StatusID;
				Info.state := stateError;
			END_IF
		// -------------------------------------------------------------------------
		// Open mapp data
		stateOpen:
			Info.FileOpen_1.enable		:= TRUE;
			Info.FileOpen_1.pDevice 	:= ADR('MpCfgDev');
			Info.FileOpen_1.pFile		:= ADR('MpCfg.xml');
			Info.FileOpen_1.mode 		:= fiREAD_WRITE;
			Info.FileOpen_1();
			
			// Success
			IF Info.FileOpen_1.status = ERR_OK THEN
				IF Info.FileOpen_1.filelen > SIZEOF(Info.Buffer) THEN
					StatusID := MpCfgBufferSizeExceeded;
					Info.state := stateError;
				ELSE
					Info.state := stateRead;
				END_IF
			// Errror
			ELSIF Info.FileOpen_1.status <> ERR_FUB_BUSY THEN
				StatusID := Info.FileOpen_1.status;
				Info.state := stateError;
			END_IF
			
		// -------------------------------------------------------------------------
		// Read mapp data file
		stateRead:
			Info.FileRead_1.enable		:= TRUE;
			Info.FileRead_1.ident		:= Info.FileOpen_1.ident;
			Info.FileRead_1.len			:= Info.FileOpen_1.filelen;
			Info.FileRead_1.pDest		:= ADR(Info.Buffer);
			Info.FileRead_1();
			
			// Success
			IF Info.FileRead_1.status = ERR_OK THEN
				Info.state := stateFindData;
			// Errror
			ELSIF Info.FileRead_1.status <> ERR_FUB_BUSY THEN
				StatusID := Info.FileRead_1.status;
				Info.state := stateError;
			END_IF
				
		// -------------------------------------------------------------------------
		// Write mapp data file
		stateWrite:
			Info.FileWrite_1.enable		:= TRUE;
			Info.FileWrite_1.ident		:= Info.FileOpen_1.ident;
			Info.FileWrite_1.len		:= Info.FileOpen_1.filelen;
			Info.FileWrite_1.pSrc		:= ADR(Info.Buffer);
			Info.FileWrite_1();
			
			// Success
			IF Info.FileWrite_1.status = ERR_OK THEN
				Info.state := stateClose;
				// Errror
			ELSIF Info.FileWrite_1.status <> ERR_FUB_BUSY THEN
				StatusID := Info.FileWrite_1.status;
				Info.state := stateError;
			END_IF
			
		// -------------------------------------------------------------------------
		// Find data
		stateFindData:
			// Prepare property string
			Info.tmpStr1 := '<Property ID="';
			brsstrcat(ADR(Info.tmpStr1), ADR(ParaName));
			brsstrcat(ADR(Info.tmpStr1), ADR('"'));
			// Find property string
			Info.offset1 := FindInMem(ADR(Info.Buffer), Info.FileOpen_1.filelen, ADR(Info.tmpStr1), brsstrlen(ADR(Info.tmpStr1)), FALSE);
			
			// Found parameter string
			IF Info.offset1 > 0 THEN
				// Prepare data type start string
				Info.tmpStr1 := 'DataType="';
				// Find data type string start
				Info.offset2 := brsstrlen(ADR(Info.tmpStr1))+FindInMem(ADR(Info.Buffer)+Info.offset1, Info.FileOpen_1.filelen, ADR(Info.tmpStr1), brsstrlen(ADR(Info.tmpStr1)), FALSE);

				// Found data type start
				IF Info.offset2 > 0 THEN
					// Prepare data type end string
					Info.tmpStr1 := '"';
					// Find data type string
					Info.len := FindInMem(ADR(Info.Buffer)+Info.offset1+Info.offset2, Info.FileOpen_1.filelen, ADR(Info.tmpStr1), brsstrlen(ADR(Info.tmpStr1)), FALSE);

					// Found data type end, copy data to output
					IF Info.len > 0 THEN
						brsmemset(ADR(DataType), 0, SIZEOF(DataType));
						brsmemcpy(ADR(DataType), ADR(Info.Buffer)+Info.offset1+Info.offset2, Info.len);

						// Prepare value start string
						Info.tmpStr1 := 'Value="';
						// Find data type string start
						Info.offset2 := brsstrlen(ADR(Info.tmpStr1))+FindInMem(ADR(Info.Buffer)+Info.offset1, Info.FileOpen_1.filelen, ADR(Info.tmpStr1), brsstrlen(ADR(Info.tmpStr1)), FALSE);

						// Found value start
						IF Info.offset2 > 0 THEN
							// Prepare value end string
							Info.tmpStr1 := '"';
							// Find value end string
							Info.len := FindInMem(ADR(Info.Buffer)+Info.offset1+Info.offset2, Info.FileOpen_1.filelen, ADR(Info.tmpStr1), brsstrlen(ADR(Info.tmpStr1)), FALSE);

							// Found value end, copy data to output
							IF Info.len > 0 THEN
								brsmemset(ADR(Value), 0, SIZEOF(Value));
								brsmemcpy(ADR(Value), ADR(Info.Buffer)+Info.offset1+Info.offset2, Info.len);
								
								// Finish when command is reading
								IF ReadWrite = MpCfgRead THEN
									Info.state := stateClose;
								// Insert new data in next step
								ELSE
									Info.state := stateInsertData;
								END_IF
							// Value end was not found
							ELSE
								StatusID := MpCfgValueNotFound;
								Info.state := stateError;
							END_IF
						// Value start was not found
						ELSE
							StatusID := MpCfgValueNotFound;
							Info.state := stateError;
						END_IF
					// Data type end was not found
					ELSE
						StatusID := MpCfgTypeNotFound;
						Info.state := stateError;
					END_IF
				// Data type end was not found
				ELSE
					StatusID := MpCfgTypeNotFound;
					Info.state := stateError;
				END_IF
			// Parameter name was not found
			ELSE
				StatusID := MpCfgParaNotFound;
				Info.state := stateError;
			END_IF

		// -------------------------------------------------------------------------
		// Insert new data
		stateInsertData:
			
		// -------------------------------------------------------------------------
		// Close mapp data file
		stateClose:
			Info.FileClose_1.enable		:= TRUE;
			Info.FileClose_1.ident		:= Info.FileOpen_1.ident;
			Info.FileClose_1();
			
			// Success
			IF Info.FileClose_1.status = ERR_OK THEN
				Active := FALSE;
				CommandDone := TRUE;					
				Info.state := stateWait;
				// Errror
			ELSIF Info.FileClose_1.status <> ERR_FUB_BUSY THEN
				StatusID := Info.FileClose_1.status;
				Info.state := stateError;
			END_IF

			// -------------------------------------------------------------------------
			// Error state
		stateError:
			Info.DevLink_1.enable 				:= FALSE;
			Info.MpComConfigManager_1.Enable 	:= FALSE;
			Info.FileOpen_1.enable				:= FALSE;
			Info.FileRead_1.enable				:= FALSE;
			Info.FileWrite_1.enable	:= FALSE;

			Active := FALSE;
			Error := TRUE;
			CommandDone := TRUE;
			
			Info.FileClose_1.enable	:= TRUE;
			Info.FileClose_1.ident	:= Info.FileOpen_1.ident;
			
			IF ErrorReset THEN
				StatusID := 0;
				Error := FALSE;
				Info.state := stateWait;
			END_IF
	END_CASE;

	ErrorReset := FALSE;
END_FUNCTION_BLOCK
