//******************************************************************************************************
// Find second data in first data																		
//******************************************************************************************************
FUNCTION FindInMem
	FindInMem := -1;
	IF (len1 > len2) THEN
		IF(direction) THEN
			idx := len1 - len2; 
			WHILE(idx > 0) DO
				IF (brsmemcmp(data1 + idx, data2, len2) = 0) THEN
					FindInMem := idx;
					EXIT;
				END_IF
				idx := idx - 1;
			END_WHILE;
		ELSE
			FOR idx:=0 TO len1 - len2 DO
				IF (brsmemcmp(data1 + idx, data2, len2) = 0) THEN
					FindInMem := idx;
					EXIT;
				END_IF
			END_FOR;
		END_IF
	END_IF
END_FUNCTION

//******************************************************************************************************
// Find and replace string																	
//******************************************************************************************************
FUNCTION ReplaceString
	IF (brsstrlen(dataSTR) >= brsstrlen(searchSTR)) THEN
		FOR idx:=0 TO brsstrlen(dataSTR) - brsstrlen(searchSTR) DO
			IF (brsmemcmp(dataSTR + idx, searchSTR, brsstrlen(searchSTR)) = 0) THEN
				// Move data around
				brsmemmove(dataSTR + idx + brsstrlen(replaceSTR), dataSTR + idx + brsstrlen(searchSTR), brsstrlen(dataSTR) - brsstrlen(searchSTR) + 1);
				brsmemcpy(dataSTR + idx, replaceSTR, brsstrlen(replaceSTR));
				// Set found flag and exit if only one hit is needed
				ReplaceString := TRUE;
				IF(first) THEN
					EXIT;
				END_IF
				// Correct index for next search
				IF(brsstrlen(replaceSTR) > 0) THEN
					idx := idx + brsstrlen(replaceSTR);
				END_IF
				idx := idx - 1;
				// Exit if no data is left
				IF (brsstrlen(dataSTR) = 0 OR brsstrlen(dataSTR) < brsstrlen(searchSTR)) THEN
					EXIT;
				END_IF
			END_IF
		END_FOR;
	END_IF
END_FUNCTION

