
ACTION drawMotorSegments: 
	IF showTyleSvg OR init THEN
		IF i = 0 THEN
			gShowMotorSegments := '';
			brdkStrCat(ADR(gShowMotorSegments), ADR('[{"select":"#MS'));
		ELSE
			brdkStrCat(ADR(gShowMotorSegments), ADR('{"select":"#MS'));
		END_IF
		
		tmpString := USINT_TO_STRING(i+1);
		brdkStrCat(ADR(gShowMotorSegments), ADR(tmpString));
		brdkStrCat(ADR(gShowMotorSegments), ADR('","display":'));
		IF pSegments.visible THEN
			brdkStrCat(ADR(gShowMotorSegments), ADR('true'));
		ELSE
			brdkStrCat(ADR(gShowMotorSegments), ADR('false'));
		END_IF
		
		IF i = NR_OF_SEGMENTS THEN
			brdkStrCat(ADR(gShowMotorSegments), ADR('}]'));
		ELSE
			brdkStrCat(ADR(gShowMotorSegments), ADR('},'));
		END_IF
	END_IF
	
	
	IF i = NR_OF_SEGMENTS THEN
		showTyleSvg := FALSE;
		init := FALSE;
	END_IF
	
	
END_ACTION
