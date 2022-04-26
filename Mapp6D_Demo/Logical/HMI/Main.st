PROGRAM _INIT
	
	init := TRUE;	
	TempTestString := 'Test';
	
	(*	   <text class="TextID" font-family="Arial" font-size="40" y="70" x="50" font-weight="bold">ID:</text>
	   <text class="TextXY1" font-family="Arial" font-size="25" y="110" x="50" font-weight="bold">X: Y: </text>
	   <text class="TextRxRy1" font-family="Arial" font-size="25" y="150" x="50" font-weight="bold">Rx: Ry: </text>
	   <text class="TextZRz1" font-family="Arial" font-size="25" y="190" x="50" font-weight="bold">Z: Zx:</text>*)

	
	offsetHeight[0] := 435;
	offsetHeight[1] := 45;
	offsetOut[0] := 475.0;
	offsetOut[1] := 520.0;
	
	MTLookUpTable_0.Enable := TRUE;
	MTLookUpTable_0.NodeVectorX := offsetHeight; 
	MTLookUpTable_0.FcnValues := offsetOut; 
	MTLookUpTable_0.NumberOfNodes := 2; 
	
END_PROGRAM

PROGRAM _CYCLIC


//	IF gDemoSystem THEN
//		gShuttleStartupInfo[0].initXPos := 0.1;
//		gShuttleStartupInfo[0].initYPos := 0.1;
//		gShuttleStartupInfo[0].nextStationSelector:= '2';
//		gShuttleStartupInfo[1].initXPos := 0.3;
//		gShuttleStartupInfo[1].initYPos := 0.3;
//		gShuttleStartupInfo[1].nextStationSelector := '3';
//		gDemoSystem := FALSE;
//	END_IF
	
	
	IF EDGEPOS(visSelectedShuttle = '#rect1') THEN
		gMain.Par.SelectedIndex := 0;
	ELSIF EDGEPOS(visSelectedShuttle = '#rect2')THEN
		gMain.Par.SelectedIndex := 1;
	ELSIF EDGEPOS(visSelectedShuttle = '#rect3')THEN
		gMain.Par.SelectedIndex := 2;
	ELSIF EDGEPOS(visSelectedShuttle = '#rect4')THEN
		gMain.Par.SelectedIndex := 3;
	END_IF
	
	// draw Shuttles 
	
	nrOfShuttlesHMI := UINT_TO_USINT(gMain.Status.ShuttlesPresent);
	FOR i := 0 TO 4 DO
		pShuttleInfo ACCESS ADR(gVisShuttle.ShuttleInfoVis[i]);
		drawShuttles;
//		pShuttleStartupInfo ACCESS ADR(gShuttleStartupInfo[i]);
//		drawConfigShuttles;
	END_FOR
	
//	// draw Motor Segments;
//	FOR i := 0 TO NR_OF_SEGMENTS DO
//		pSegments ACCESS ADR(gSegments[i]);
//		drawMotorSegments;
//	END_FOR

	// harrisb - May 18, 2021 : added to set default demo segments
	// Demo segment Layout (show 4 segments) 
	IF gSettings.DemoType THEN
//		demoMotorSegmentLayoutCmd := FALSE;
		FOR i := 0 TO NR_OF_SEGMENTS DO
			IF (i = 0)OR(i = 1)OR(i = 5)OR(i = 6)THEN
				gSegments[i].visible := TRUE;
			ELSE
				gSegments[i].visible := FALSE;
			END_IF
		END_FOR
	ELSIF NOT(gSettings.DemoType) THEN
		FOR i := 0 TO NR_OF_SEGMENTS DO
			IF (i = 0)OR(i = 1)THEN
				gSegments[i].visible := TRUE;
			ELSE
				gSegments[i].visible := FALSE;
			END_IF
		END_FOR
	END_IF
	
	IF EDGE(gSettings.DemoType) THEN
		showTyleSvg := TRUE;
	END_IF
	
	// draw Motor Segments;
	FOR i := 0 TO NR_OF_SEGMENTS DO
		pSegments ACCESS ADR(gSegments[i]);
		drawMotorSegments;
	END_FOR
	
	// Reset segment Layout
	IF resetMotorSegmentLayoutCmd THEN
		resetMotorSegmentLayoutCmd := FALSE;
		FOR i := 0 TO NR_OF_SEGMENTS DO
			gSegments[i].visible := TRUE;
		END_FOR
	END_IF
	
	// Reset Shuttle Startup Layout
	IF resetShuttleInitLayoutCmd THEN
		resetShuttleInitLayoutCmd := FALSE;
		FOR i := 0 TO NUM_SHUTTLES DO
			gShuttleStartupInfo[i].initXPos := 0.42+0.12*(i);
			gShuttleStartupInfo[i].initYPos := 0.060;
		END_FOR
	END_IF	
	
	// Handle tyle click configuration
	IF this.tableConfigClick THEN
		this.tableConfigClick := FALSE;
		brdkStrRemove(ADR(this.tableConfigString),0,3);
		tmpString := this.tableConfigString;
		this.tableConfigID := STRING_TO_USINT(tmpString);
		this.tableConfigID := this.tableConfigID - 1;
		IF gSegments[this.tableConfigID].visible THEN
			gSegments[this.tableConfigID].visible := FALSE;
		ELSE
			gSegments[this.tableConfigID].visible := TRUE;
		END_IF
	END_IF
	
	// harrisb - May 21, 2021 : Hide disconnected segments
	FOR i := 0 TO NR_OF_SEGMENTS DO
	
		CASE i OF
		
			// allow segment 1 to be ON on its own
			0: IF gSegments[i].visible AND NOT((gSegments[i+1].visible)OR(gSegments[i+5].visible)OR(gSegments[i-5].visible))THEN
			
				END_IF
			5,10,15,20,25,30,35,40,45: IF gSegments[i].visible AND NOT((gSegments[i+1].visible)OR(gSegments[i+5].visible)OR(gSegments[i-5].visible))THEN
					gSegments[i].visible := FALSE;
				END_IF
		  
			4,9,14,19,24,29,34,39,44,49:	IF gSegments[i].visible AND NOT((gSegments[i-1].visible)OR(gSegments[i+5].visible)OR(gSegments[i-5].visible))THEN
					gSegments[i].visible := FALSE;
				END_IF
			
			ELSE
				IF gSegments[i].visible AND NOT((gSegments[i+1].visible)OR(gSegments[i-1].visible)OR(gSegments[i+5].visible)OR(gSegments[i-5].visible))THEN
					gSegments[i].visible := FALSE;
				END_IF
				
		END_CASE;
			
	END_FOR
	
	
	// Handle different svg views on config page
	IF showConfigSvgCmd THEN
		showConfigSvgCmd := FALSE;
		showConfigSvg := TRUE;
		showTyleSvg := FALSE;
		shuttleStartPosSvg := FALSE;
	END_IF
	
	// Handle different svg views on config page
	IF showTyleSvgCmd THEN
		showTyleSvgCmd := FALSE;
		showTyleSvg := TRUE;
		showConfigSvg := FALSE;
		shuttleStartPosSvg := FALSE;
	END_IF
	
	// Handle different svg views on config page
	IF shuttleStartPosSvgCmd THEN
		shuttleStartPosSvgCmd := FALSE;
		showTyleSvg := FALSE;
		showConfigSvg := FALSE;
		shuttleStartPosSvg := TRUE;
	END_IF
	

	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

