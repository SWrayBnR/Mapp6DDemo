
ACTION drawShuttles:

		//////////// CREATE TEXT CODE /////////
	// Create the Texts
	IF (i < gMain.Status.ShuttlesPresent) AND (gMain.Status.Ready) THEN
		IF i = 0 THEN
			TESTString := '';
		END_IF
		
		IF pShuttleInfo.State <> mcACP6D_SH_STATE_MOTION THEN
		brdkStrCat(ADR(TESTString), ADR('<text class="ShtId'));
		TempTestString := UINT_TO_STRING(gShuttleReference[i].ID);
		brdkStrCat(ADR(TESTString), ADR(TempTestString));
		brdkStrCat(ADR(TESTString), ADR('" font-family="Helvetica, Arial, sans-serif" font-size="25" y="'));
		
	
		MTLookUpTable_0.Enable := TRUE;
		MTLookUpTable_0.InX := pShuttleInfo.Position.Y;
		MTLookUpTable_0();
		YOffset := MTLookUpTable_0.Out;
		// Add Y position		
		tmpCalc := YOffset-((pShuttleInfo.Position.Y));
		TempTestString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(TESTString), ADR(TempTestString));
		
		// ADD X position
		brdkStrCat(ADR(TESTString), ADR('" x="'));		
		tmpCalc := ((pShuttleInfo.Position.X));// * 2)) - XOffset;

		TempTestString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(TESTString), ADR(TempTestString));
	
		// Add the Text
		brdkStrCat(ADR(TESTString), ADR('">ID:'));
		TempTestString := USINT_TO_STRING(pShuttleInfo.ID);
		brdkStrCat(ADR(TESTString), ADR(TempTestString));
			brdkStrCat(ADR(TESTString), ADR('</text>'));
		ELSE
			
		END_IF
		
			
	END_IF
	///////
	
	// Change the rectangles //
	IF i = 0 THEN
		showShuttles := '';
		tmpString := gShowMotorSegments;
		brdkStrRemove(ADR(tmpString),-1,1);
		brdkStrCat(ADR(showShuttles), ADR(tmpString));
		brdkStrCat(ADR(showShuttles), ADR(','));
	END_IF

	brdkStrCat(ADR(showShuttles), ADR('{"select":"#rect'));

	
	tmpString := USINT_TO_STRING(i+1);
	brdkStrCat(ADR(showShuttles), ADR(tmpString));
	brdkStrCat(ADR(showShuttles), ADR('","display":'));
	IF (nrOfShuttlesHMI >= (i+1))AND(pShuttleInfo.State <> mcACP6D_SH_STATE_RESERVED)THEN
		brdkStrCat(ADR(showShuttles), ADR('true'));		
	ELSE
		brdkStrCat(ADR(showShuttles), ADR('false'));
	END_IF

	IF(pShuttleInfo.State = mcACP6D_SH_STATE_OBSTACLE)THEN
		brdkStrCat(ADR(showShuttles), ADR(',"style":"fill:4;')); // Yellow
	ELSIF(pShuttleInfo.State = mcACP6D_SH_STATE_STOPPED)THEN // RED
		brdkStrCat(ADR(showShuttles), ADR(',"style":"fill:0;'));
	ELSIF pShuttleInfo.State = mcACP6D_SH_STATE_LANDED THEN // BLUE
		brdkStrCat(ADR(showShuttles), ADR(',"style":"fill:2;'));
	ELSIF pShuttleInfo.State = mcACP6D_SH_STATE_DISABLED THEN // Red/maroon
		brdkStrCat(ADR(showShuttles), ADR(',"style":"fill:3;'));
	ELSE									// Black border white
		brdkStrCat(ADR(showShuttles), ADR(',"style":"fill:6;'));
	END_IF
	
	IF (gMain.Par.SelectedIndex = i)THEN // Green border  
	brdkStrCat(ADR(showShuttles), ADR('stroke:5;stroke-width:5px;"'));
	ELSE								// Black border 
	brdkStrCat(ADR(showShuttles), ADR('stroke:7;stroke-width:1px;"'));
	END_IF
	
	brdkStrCat(ADR(showShuttles), ADR(',"translate":['));
	
	tmpCalc := ((pShuttleInfo.Position.X * 2))-120;
	tmpString := REAL_TO_STRING(tmpCalc);
	brdkStrCat(ADR(showShuttles), ADR(tmpString));
	brdkStrCat(ADR(showShuttles), ADR(','));
	
	tmpCalc := 960 - ((pShuttleInfo.Position.Y * 2))-120;
	tmpString := REAL_TO_STRING(tmpCalc);
	brdkStrCat(ADR(showShuttles), ADR(tmpString));
	
	brdkStrCat(ADR(showShuttles), ADR(']'));

	brdkStrCat(ADR(showShuttles), ADR(',"spin":['));
	
	tmpCalc := ((pShuttleInfo.Position.Rz/17.453293)*-1);
	tmpString := REAL_TO_STRING(tmpCalc);
	brdkStrCat(ADR(showShuttles), ADR(tmpString));
	brdkStrCat(ADR(showShuttles), ADR(',120,120'));
	// END Rectangles
//	brdkStrCat(ADR(showShuttles), ADR(']}'));

	
//	IF i = UINT_TO_USINT(gMain.Status.ShuttlesPresent)THEN
	IF i = 4 THEN
		brdkStrCat(ADR(showShuttles), ADR(']}]'));
	ELSE		
		brdkStrCat(ADR(showShuttles), ADR(']},'));
	END_IF

	sizeOfArray := brdkStrLen(ADR(showShuttles));
	

	
	
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////

	IF i = gMain.Par.SelectedIndex THEN

		
		// Display the Shuttle Rx position
		showShuttlesPosRx := '';
		brdkStrCat(ADR(showShuttlesPosRx), ADR('[{"select":"#ShuttleMain'));
		brdkStrCat(ADR(showShuttlesPosRx), ADR('","display":'));
		brdkStrCat(ADR(showShuttlesPosRx), ADR('true'));		
		brdkStrCat(ADR(showShuttlesPosRx), ADR(',"translate":['));	
		tmpCalc := (0);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRx), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRx), ADR(','));	
		tmpCalc := (((pShuttleInfo.Position.Z)*-1)*5);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRx), ADR(tmpString));	
		brdkStrCat(ADR(showShuttlesPosRx), ADR(']'));
		brdkStrCat(ADR(showShuttlesPosRx), ADR(',"spin":['));	
		tmpCalc := ((pShuttleInfo.Position.Rx/17.453293));
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRx), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRx), ADR(',200,2.5'));
		brdkStrCat(ADR(showShuttlesPosRx), ADR(']},'));	
		brdkStrCat(ADR(showShuttlesPosRx), ADR('{"select":"#ShuttleTop'));
		brdkStrCat(ADR(showShuttlesPosRx), ADR('","display":'));
		brdkStrCat(ADR(showShuttlesPosRx), ADR('true'));		
		brdkStrCat(ADR(showShuttlesPosRx), ADR(',"translate":['));	
		tmpCalc := (0);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRx), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRx), ADR(','));	
		tmpCalc := (((pShuttleInfo.Position.Z)*-1)*5);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRx), ADR(tmpString));	
		brdkStrCat(ADR(showShuttlesPosRx), ADR(']'));
		brdkStrCat(ADR(showShuttlesPosRx), ADR(',"spin":['));	
		tmpCalc := ((pShuttleInfo.Position.Rx/17.453293));
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRx), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRx), ADR(',200,2.5'));	
		brdkStrCat(ADR(showShuttlesPosRx), ADR(']}]'));
		sizeOfArray1 := brdkStrLen(ADR(showShuttlesPosRx));
		
		
		// Display the Shuttle Ry position
		showShuttlesPosRy := '';
		brdkStrCat(ADR(showShuttlesPosRy), ADR('[{"select":"#ShuttleMain'));
		brdkStrCat(ADR(showShuttlesPosRy), ADR('","display":'));
		brdkStrCat(ADR(showShuttlesPosRy), ADR('true'));		
		brdkStrCat(ADR(showShuttlesPosRy), ADR(',"translate":['));	
		tmpCalc := (0);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRy), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRy), ADR(','));	
		tmpCalc := (((pShuttleInfo.Position.Z)*-1)*5);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRy), ADR(tmpString));	
		brdkStrCat(ADR(showShuttlesPosRy), ADR(']'));
		brdkStrCat(ADR(showShuttlesPosRy), ADR(',"spin":['));	
		tmpCalc := ((pShuttleInfo.Position.Ry/17.453293));
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRy), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRy), ADR(',200,2.5'));
		brdkStrCat(ADR(showShuttlesPosRy), ADR(']},'));	
		brdkStrCat(ADR(showShuttlesPosRy), ADR('{"select":"#ShuttleTop'));
		brdkStrCat(ADR(showShuttlesPosRy), ADR('","display":'));
		brdkStrCat(ADR(showShuttlesPosRy), ADR('true'));		
		brdkStrCat(ADR(showShuttlesPosRy), ADR(',"translate":['));	
		tmpCalc := (0);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRy), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRy), ADR(','));	
		tmpCalc := (((pShuttleInfo.Position.Z)*-1)*5);
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRy), ADR(tmpString));	
		brdkStrCat(ADR(showShuttlesPosRy), ADR(']'));
		brdkStrCat(ADR(showShuttlesPosRy), ADR(',"spin":['));	
		tmpCalc := ((pShuttleInfo.Position.Ry/17.453293));
		tmpString := REAL_TO_STRING(tmpCalc);
		brdkStrCat(ADR(showShuttlesPosRy), ADR(tmpString));
		brdkStrCat(ADR(showShuttlesPosRy), ADR(',200,2.5'));	

//		brdkStrCat(ADR(showShuttlesPosRy), ADR(']},'));
	
		// Select the text
//		brdkStrCat(ADR(showShuttlesPosRy), ADR(TESTString));	
//		brdkStrCat(ADR(showShuttlesPosRy), ADR('{"select":"#TextId'));	

//		tmpString := USINT_TO_STRING(i+1);
//		brdkStrCat(ADR(showShuttlesPosRy), ADR(tmpString));
//		brdkStrCat(ADR(showShuttlesPosRy), ADR('","display":'));
//		brdkStrCat(ADR(showShuttlesPosRy), ADR('true'));	
//		brdkStrCat(ADR(showShuttlesPosRy), ADR('>test</'));	

		brdkStrCat(ADR(showShuttlesPosRy), ADR(']}]'));
		sizeOfArray2 := brdkStrLen(ADR(showShuttlesPosRy));
				
	END_IF
	
	//showShuttles := '';
	//showShuttles := '[{"select":"#rect1","display":false, "translate":[100,100]}]';
END_ACTION
