PROGRAM _INIT
	
	visSelectedTab;
	
	IF gSettings.DemoType THEN
		gAssemblyX_max := (XY_MAX * 2)- HALF_SHUTTLE;
		gAssemblyY_max := (XY_MAX * 2)- HALF_SHUTTLE;
	ELSE
		gAssemblyX_max := (XY_MAX)- HALF_SHUTTLE;
		gAssemblyY_max := (XY_MAX * 2)- HALF_SHUTTLE;
	END_IF
	
	(* Initilaize communication *)
	gComm6D_IN;
	gComm6D_OUT;    
	
	(* Initialize function blocks *)
	MC_BR_AsmReadStatus_Acp6D_0.Assembly    :=    ADR(gAssembly6D_1);
	MC_BR_AsmReadInfo_Acp6D_0.Assembly      :=    ADR(gAssembly6D_1);
	MC_BR_AsmPowerOn_Acp6D_0.Assembly       :=    ADR(gAssembly6D_1);
	MC_BR_AsmPowerOff_Acp6D_0.Assembly      :=    ADR(gAssembly6D_1);
	MC_BR_AsmGetShuttle_Acp6D_0.Assembly    :=    ADR(gAssembly6D_1);
	MC_BR_AsmStop_Acp6D_0.Assembly          :=    ADR(gAssembly6D_1);  
	MC_BR_MoveInPlaneAsync_Acp6D_0.Assembly :=	  ADR(gAssembly6D_1); 
	MC_BR_AsmGetInfo_Acp6D_0.Assembly 		:=	  ADR(gAssembly6D_1);

	
	(* Initialize main control variable *)
	(* InPlane Movement (X & Y) *)
	gMain.Par.InPlane.Acceleration          :=    20.0;   //[m/s²]
	gMain.Par.InPlane.Velocity              :=    2.0;    //[m/s]
	gMain.Par.InPlane.EndVelocity           :=    0.0;    //[m/s]
	// Top right position
	gMain.Par.InPlane.Position.X            :=    gAssemblyX_max; //[m] 
	gMain.Par.InPlane.Position.Y            :=    gAssemblyY_max; //[m]
	gMain.Par.InPlane.Path                  :=    mcACP6D_PATH_X_THEN_Y;
	gMain.Par.InPlane.Mode                  :=    mcACP6D_MOVE_ABSOLUTE;
    
	(* Enable Diagnostic FUBs *)
	MC_BR_AsmReadStatus_Acp6D_0.Enable      :=    TRUE;
	MC_BR_AsmReadInfo_Acp6D_0.Enable        :=    TRUE;

		
	gMain.Cmd.Jog.Distance := 0.02;
	gMain.Cmd.Jog.Degrees := 0.5;
	
	gMain.Par.JogShort.Position.Rz := 0.5;
	gMain.Par.JogShort.Position.Ry := 0.0;
	gMain.Par.JogShort.Position.Rx := 0.0;
	gMain.Par.JogShort.Position.Z := 0.001;
	
	gMain.Par.JogShort.Velocity.Rx := 0.1;
	gMain.Par.JogShort.Velocity.Rz := 0.1;
	gMain.Par.JogShort.Velocity.Ry := 0.1;
	gMain.Par.JogShort.Velocity.Z := 0.005;
	
	gMain.Par.JogShort.Mode := mcACP6D_MOVE_ABSOLUTE;
	gMain.Par.JogShort.Rotation.Type := mcACP6D_SHORT_AX_ROT_ONLY;
		
	gMain.Par.JogShort.Rotation.Center.X := 60;
	gMain.Par.JogShort.Rotation.Center.Y := 60;
	
	gMain.Par.Jog.Velocity := 0.25;
	gMain.Par.Jog.Acceleration := 20;
	
	gMain.Par.Velocity := 2.0;
	gMain.Par.Accel := 20.0;
	
	
	zHeight[0] := 0.001;
	zHeight[1] := 0.004;
	zRollLimit[0] := 0.008;
	zRollLimit[1] := 0.055;
	
	MTLookUpTable_0.Enable := TRUE;
	MTLookUpTable_0.NodeVectorX := zHeight; 
	MTLookUpTable_0.FcnValues := zRollLimit; 
	MTLookUpTable_0.NumberOfNodes := 2; 


	
	
END_PROGRAM

PROGRAM _CYCLIC
	
    (* Check for current status *)
	IF (gMain.Status.ErrorStop) THEN
		(* If an error occurs, go to the error state *)
		MainStep    :=    MAIN_ERROR;
	ELSIF (gMain.Status.StartUp) THEN
		(* As long, as the 6D - controller is in startup, stay in startup state *)
		MainStep    :=    MAIN_STARTUP;
	END_IF    
	
	(* Limit the selected index for the shuttle array *)
	gMain.Par.SelectedIndex                                :=    LIMIT(0, gMain.Par.SelectedIndex, MIN(gMain.Status.ShuttlesPresent - 1, MAX_INDEX_SHUTTLE));
	(* State machine *)
	CASE MainStep OF
	
		MAIN_STARTUP:
			(* Wait for the 6D controller to be started *)
			IF (gMain.Status.Disabled) THEN
				(* If assembly is disabled *)
				MainStep                                :=    MAIN_DISABLED;
			ELSIF NOT(gMain.Status.StartUp) THEN
				(* If assembly is in any other state, disable it *)
				MainStep                                :=    MAIN_POWER_OFF;
			END_IF
        
		MAIN_POWER_OFF:
			(* Activate Function block *)
			MC_BR_AsmPowerOff_Acp6D_0.Execute            :=    TRUE;
			(* Wait for the command to be done *)
			IF (MC_BR_AsmPowerOff_Acp6D_0.Done) THEN
				(* Reset the function block *)
				MC_BR_AsmPowerOff_Acp6D_0.Execute        :=    FALSE;
				(* Next step *)
				MainStep                                :=    MAIN_DISABLED;
			ELSIF (MC_BR_AsmPowerOff_Acp6D_0.Error) THEN
				(* Next step *)
				MainStep                                :=    MAIN_ERROR;
			END_IF
        
		MAIN_DISABLED:
			IF (gMain.Cmd.Power) THEN
				(* Next step *)
				MainStep                                :=    MAIN_POWER_ON;
			END_IF
        
		MAIN_POWER_ON:
			(* Activate Function block *)
			MC_BR_AsmPowerOn_Acp6D_0.Execute            :=    TRUE;
			(* Wait for the command to be done *)
			IF (MC_BR_AsmPowerOn_Acp6D_0.Done) THEN
				(* Reset the function block *)
				MC_BR_AsmPowerOn_Acp6D_0.Execute        :=    FALSE;
				(* Delete data from global shuttle array *)
				brsmemset(ADR(gShuttleReference),0,SIZEOF(gShuttleReference));
				(* Next step *)
				MainStep                                :=    MAIN_GET_SHUTTLE;
			ELSIF (MC_BR_AsmPowerOn_Acp6D_0.Error) THEN
				(* Next step *)
				MainStep                                :=    MAIN_ERROR;
			END_IF
        
		MAIN_GET_SHUTTLE:
			(* Enable the function block *)
			MC_BR_AsmGetShuttle_Acp6D_0.Enable            :=    TRUE;
			(* Wait until the data is valid *)    
			IF (MC_BR_AsmGetShuttle_Acp6D_0.Valid) THEN
				(* Check any shuttle is present *)
				IF (MC_BR_AsmGetShuttle_Acp6D_0.TotalCount > 0) THEN
					(* Reset the "next" command *)
					MC_BR_AsmGetShuttle_Acp6D_0.Next    :=    FALSE;
					(* Save the number of shuttles *)
					gMain.Status.ShuttlesPresent        :=    UINT_TO_USINT(MC_BR_AsmGetShuttle_Acp6D_0.TotalCount);
					(* Next step *)
					MainStep                            :=    MAIN_GET_SHUTTLE_WAIT;
				ELSE
					(* No shuttles present *)
					gMain.Status.ShuttlesPresent        :=    0;
					(* Disable the function block *)
					MC_BR_AsmGetShuttle_Acp6D_0.Enable  :=    TRUE;
					(* Next step *)
					MainStep                            :=    MAIN_READY;
				END_IF
			END_IF
        
		MAIN_GET_SHUTTLE_WAIT:
			(* Search for the next free index *)
			FOR i := 0 TO MAX_INDEX_SHUTTLE DO
				IF (gShuttleReference[i].ID = 0) THEN
					(* Save the current array index and exit the loop *)
					NextFreeIndex                        :=    i;
					EXIT;
				END_IF
			END_FOR            
			(* Save the shuttle reference *)
			gShuttleReference[NextFreeIndex].Reference    :=   MC_BR_AsmGetShuttle_Acp6D_0.Shuttle;
			gShuttleReference[NextFreeIndex].ID           :=   MC_BR_AsmGetShuttle_Acp6D_0.AdditionalInfo.ShuttleID;            
			(* Check if there are more shuttles to read out *)
			IF (MC_BR_AsmGetShuttle_Acp6D_0.RemainingCount > 0) THEN
				(* Get next shuttle *)
				MC_BR_AsmGetShuttle_Acp6D_0.Next        :=    TRUE;
				(* Next step *)
				MainStep                                :=    MAIN_GET_SHUTTLE;
			ELSE
				(* Reset the function block *)
				MC_BR_AsmGetShuttle_Acp6D_0.Enable      :=    FALSE;
				(* Next step *)
				MainStep                                :=    MAIN_READY;
			END_IF
        
		MAIN_READY:
			
			visShowReset := C_HIDE; 
			
			IF NOT(gMain.Cmd.Power) OR (gMain.Status.Disabled) THEN
				(* Power off the system, if the power command is reset, or the assembly is disabled *)
				(* Reset command *)
				gMain.Cmd.Power                         :=    FALSE;
				(* Next step *)
				MainStep                                :=    MAIN_POWER_OFF;
			ELSIF (gMain.Cmd.Start) THEN
				(* Start a movement when the command is set and a valid shuttleID is selected *)
				(* Reset command *)
				gMain.Cmd.Start                         :=    FALSE;
				(* Next step *)
				MainStep                                :=    MAIN_START_MOVEMENT;
			ELSIF (gMain.Cmd.StopAll) THEN
				(* Stop all shuttles in the assembly, if the command is set *)
				(* Reset command *)
				gMain.Cmd.StopAll                       :=    FALSE;
				(* Next step *)
				MainStep                                :=    MAIN_STOP_ALL_SHUTTLES;
			ELSIF gMain.Cmd.Land THEN
				gMain.Cmd.Land := FALSE;
				MainStep  								:=    MAIN_LEVITATE;
			ELSIF gMain.Cmd.Move6D THEN
				gMain.Cmd.Move6D := FALSE;
				MainStep                                :=    MAIN_MOVE_6D;
			ELSIF gMain.Cmd.Arc THEN
				gMain.Cmd.Arc := FALSE;
				MainStep                                :=    MAIN_MOVE_ARC;
			ELSIF gMain.Cmd.Group THEN
				gMain.Cmd.Group := FALSE;
				MainStep                                :=    MAIN_MOVE_GROUP;
			ELSIF gMain.Cmd.Weigh THEN
				gMain.Cmd.Weigh := FALSE;
				MainStep                                :=    MAIN_WEIGH;
			ELSIF gMain.Cmd.Pause THEN
				gMain.Cmd.Pause := FALSE;
				MainStep  								:=    MAIN_HALT_SELECTED;
			ELSIF gMain.Cmd.Resume THEN
				gMain.Cmd.Resume := FALSE;
				MainStep  								:=    MAIN_RESUME_SELECTED;
			ELSIF gMain.Cmd.Stop THEN
				gMain.Cmd.Stop := FALSE;
				MainStep  								:=    MAIN_STOP_SELECTED;
			ELSIF gMain.Cmd.ResetAll THEN
				gMain.Cmd.ResetAll := FALSE;
				MainStep  								:=    MAIN_RECOVER_ALL; // Recover disabled shuttles
			END_IF
			
			// Jog command recieved
			IF EDGEPOS(gMain.Cmd.Jog.Left OR gMain.Cmd.Jog.Right OR gMain.Cmd.Jog.Neg OR gMain.Cmd.Jog.Pos OR gMain.Cmd.Jog.RzP OR gMain.Cmd.Jog.RzN OR gMain.Cmd.Jog.RxP OR gMain.Cmd.Jog.RxN OR gMain.Cmd.Jog.RyP OR gMain.Cmd.Jog.RyN OR gMain.Cmd.Jog.Up OR gMain.Cmd.Jog.Down)OR(gMain.Cmd.Jog.Zero)THEN
				MainStep             :=    MAIN_JOG_SHUTTLE;
			END_IF
	
		MAIN_WEIGH:
			
			WeighAct;
			
			
		MAIN_START_MOVEMENT:
			
			(* Activate the function block *)
			MC_BR_MoveInPlane_Acp6D_0.Shuttle            :=    ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
			MC_BR_MoveInPlane_Acp6D_0.Parameters        :=    gMain.Par.InPlane; //Parameter set in INIT, can be modified in Watch
			MC_BR_MoveInPlane_Acp6D_0.Execute            :=    TRUE;
			(* Wait for the command to be accepted *)
			IF (MC_BR_MoveInPlane_Acp6D_0.Acknowledge) THEN
				(* Reset the function block *)
				MC_BR_MoveInPlane_Acp6D_0.Execute        :=    FALSE;
				(* Next step *)
				MainStep                                :=    MAIN_READY;
			ELSIF (MC_BR_MoveInPlane_Acp6D_0.Error) THEN
				(* Next step *)
				MainStep                                :=    MAIN_ERROR;
			END_IF
        
		MAIN_JOG_SHUTTLE:
		
			// Jog function
			JogAct;
			
			TON_0.PT := t#1s;
			TON_0.IN := NOT(gMain.Cmd.Jog.Left OR gMain.Cmd.Jog.Right OR gMain.Cmd.Jog.Neg OR gMain.Cmd.Jog.Pos OR gMain.Cmd.Jog.RxP OR gMain.Cmd.Jog.RxN OR gMain.Cmd.Jog.RyP OR gMain.Cmd.Jog.RyN OR gMain.Cmd.Jog.Up OR gMain.Cmd.Jog.Down);
		
			IF TON_0.Q THEN
				TON_0.IN := FALSE;
				MainStep := MAIN_READY;
				MC_BR_ShStop_Acp6D_0.Execute := FALSE;
			END_IF
	
			
		MAIN_LEVITATE:
			
			MC_BR_ShLevitation_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
			
			IF(gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].State <> mcACP6D_SH_STATE_LANDED)THEN	
				MC_BR_ShLevitation_Acp6D_0.Parameters.Level := mcACP6D_LEVEL_LAND;
				MC_BR_ShLevitation_Acp6D_0.Execute := TRUE;
			ELSE
				MC_BR_ShLevitation_Acp6D_0.Parameters.Level := mcACP6D_LEVEL_LEVITATE;
				MC_BR_ShLevitation_Acp6D_0.Execute := TRUE;
			END_IF
			
			IF MC_BR_ShLevitation_Acp6D_0.Done THEN
				(* Next step *)
				MC_BR_ShLevitation_Acp6D_0.Execute := FALSE;
				MainStep                           := MAIN_READY;
			ELSIF MC_BR_ShLevitation_Acp6D_0.Error THEN
				(* Next step *)
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_ShLevitation_Acp6D_0.ErrorID; 
				MC_BR_ShLevitation_Acp6D_0.Execute := FALSE;
				MainStep                           := MAIN_ERROR;
			END_IF
		

		MAIN_MOVE_6D:
			
			gMain.Par.Arc.Option := mcACP6D_ARC_ANGULAR;
			
			MC_BR_Move6D_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
			MC_BR_Move6D_Acp6D_0.Execute := TRUE;
			
			gMain.Par.Move6D.InPlane.Velocity := gMain.Par.Velocity;
			gMain.Par.Move6D.InPlane.Acceleration := gMain.Par.Accel;
		
			MC_BR_Move6D_Acp6D_0.Parameters := gMain.Par.Move6D;
			MC_BR_Move6D_Acp6D_0.Parameters.InPlane.Position.X := gMain.Par.Move6D.InPlane.Position.X/1000; // convert to m
			MC_BR_Move6D_Acp6D_0.Parameters.InPlane.Position.Y := gMain.Par.Move6D.InPlane.Position.Y/1000; // convert to m
			MC_BR_Move6D_Acp6D_0.Parameters.ShortAxis.Position.Z := gMain.Par.Move6D.ShortAxis.Position.Z/1000; // convert to m
			MC_BR_Move6D_Acp6D_0.Parameters.ShortAxis.Position.Rx := gMain.Par.Move6D.ShortAxis.Position.Rx * 0.017453293; // convert to mrad
			MC_BR_Move6D_Acp6D_0.Parameters.ShortAxis.Position.Ry := gMain.Par.Move6D.ShortAxis.Position.Ry * 0.017453293; // convert to mrad
			MC_BR_Move6D_Acp6D_0.Parameters.ShortAxis.Position.Rz := gMain.Par.Move6D.ShortAxis.Position.Rz * 0.017453293; // convert to mrad
			
			MC_BR_Move6D_Acp6D_0.CommandLabel := 150;
			
			IF MC_BR_Move6D_Acp6D_0.Done OR MC_BR_Move6D_Acp6D_0.Acknowledge THEN
				MC_BR_Move6D_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_READY;
			ELSIF MC_BR_Move6D_Acp6D_0.Error THEN
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_Move6D_Acp6D_0.ErrorID; 
				MC_BR_MoveArc_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_ERROR;
			END_IF

		MAIN_MOVE_ARC:
			
			gMain.Par.Arc.Option := mcACP6D_ARC_ANGULAR;

			MC_BR_MoveArc_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
			MC_BR_MoveArc_Acp6D_0.Execute := TRUE;	
			
			gMain.Par.Arc.Velocity := gMain.Par.Velocity;
			gMain.Par.Arc.Acceleration := gMain.Par.Accel;
			gMain.Par.Arc.EndVelocity := gMain.Par.EndVelocity;
					
			MC_BR_MoveArc_Acp6D_0.Parameters := gMain.Par.Arc;			
			MC_BR_MoveArc_Acp6D_0.Parameters.Angular.Angle := gMain.Par.Arc.Angular.Angle * 0.017453293; // convert to mrad
			MC_BR_MoveArc_Acp6D_0.Parameters.Angular.Center.X := gMain.Par.Arc.Angular.Center.X/1000; // convert to m
			MC_BR_MoveArc_Acp6D_0.Parameters.Angular.Center.Y := gMain.Par.Arc.Angular.Center.Y/1000;
			MC_BR_MoveArc_Acp6D_0.CommandLabel := 160;
			
			IF MC_BR_MoveArc_Acp6D_0.Done OR MC_BR_MoveArc_Acp6D_0.Acknowledge THEN
				MC_BR_MoveArc_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_READY;					
			ELSIF MC_BR_MoveArc_Acp6D_0.Error THEN
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_MoveArc_Acp6D_0.ErrorID; 
				MC_BR_MoveArc_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_ERROR;
			END_IF
			
					
		MAIN_MOVE_GROUP:
			
		MAIN_RECOVER:
						
			IF(gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].State = mcACP6D_SH_STATE_DISABLED)THEN
				MC_BR_ShRecover_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
				MC_BR_ShRecover_Acp6D_0.Execute := TRUE;
			END_IF
			
			IF MC_BR_ShRecover_Acp6D_0.Done THEN
				MC_BR_ShRecover_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_READY;
			ELSIF MC_BR_ShRecover_Acp6D_0.Error THEN
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_ShRecover_Acp6D_0.ErrorID; 
				MC_BR_ShRecover_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_ERROR;				
			END_IF
		
		MAIN_RECOVER_ALL:
			
		
			IF (k <=(gMain.Status.ShuttlesPresent - 1))THEN
				MC_BR_ShRecover_Acp6D_0.Shuttle := ADR(gShuttleReference[k].Reference);
				IF ((gVisShuttle.ShuttleInfoVis[k].State = mcACP6D_SH_STATE_DISABLED)) THEN
					MC_BR_ShRecover_Acp6D_0.Execute := TRUE;
				ELSIF(k < gMain.Status.ShuttlesPresent)THEN
					k := k+1;
				END_IF
				
				IF MC_BR_ShRecover_Acp6D_0.Done THEN			
					k := k+1;
					MC_BR_ShRecover_Acp6D_0.Execute := FALSE;
					IF (k = gMain.Status.ShuttlesPresent) THEN
						k := 0;
						MainStep          := MAIN_READY;
						visResetSelected := C_HIDE;
					END_IF
				ELSIF MC_BR_ShRecover_Acp6D_0.Error THEN
					ErrorStep := MainStep;
					ErrorNumber := MC_BR_ShRecover_Acp6D_0.ErrorID;
					MC_BR_ShRecover_Acp6D_0.Execute := FALSE;
					k := 0;
					MainStep          := MAIN_ERROR;
					visResetSelected := C_HIDE;

				END_IF
			ELSE
				k := 0;
				MainStep          := MAIN_READY;
					visResetSelected := C_HIDE;
			END_IF
		
		MAIN_HALT_SELECTED:
			
				MC_BR_ShHalt_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
				MC_BR_ShHalt_Acp6D_0.Option := mcACP6D_HALT;
				MC_BR_ShHalt_Acp6D_0.Execute := TRUE;
	
			IF MC_BR_ShHalt_Acp6D_0.Done THEN
				MC_BR_ShHalt_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_READY;
			ELSIF MC_BR_ShHalt_Acp6D_0.Error THEN
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_ShHalt_Acp6D_0.ErrorID;
				MC_BR_ShHalt_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_ERROR;
			END_IF
			
		MAIN_RESUME_SELECTED:
			
			MC_BR_ShHalt_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
			MC_BR_ShHalt_Acp6D_0.Option := mcACP6D_CONTINUE;
			MC_BR_ShHalt_Acp6D_0.Execute := TRUE;
			
			IF MC_BR_ShHalt_Acp6D_0.Done THEN
				MC_BR_ShHalt_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_READY;
			ELSIF MC_BR_ShHalt_Acp6D_0.Error THEN
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_ShHalt_Acp6D_0.ErrorID;
				MC_BR_ShHalt_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_ERROR;
			END_IF
			
			
		MAIN_STOP_SELECTED:
			
	
				MC_BR_ShStop_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
				MC_BR_ShStop_Acp6D_0.Execute := TRUE;
		
			IF MC_BR_ShStop_Acp6D_0.Done OR(gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].State = mcACP6D_SH_STATE_IDLING)THEN
				MC_BR_ShStop_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_READY;
			ELSIF MC_BR_ShStop_Acp6D_0.Error THEN
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_ShStop_Acp6D_0.ErrorID;
				MC_BR_ShStop_Acp6D_0.Execute := FALSE;
				MainStep          := MAIN_ERROR;
			END_IF
			
		MAIN_STOP_ALL_SHUTTLES:
			(* Activate Function block *)
			MC_BR_AsmStop_Acp6D_0.Execute               :=    TRUE;
			(* Wait for the command to be done *)
			IF (MC_BR_AsmStop_Acp6D_0.Done) THEN
				(* Reset the function block *)
				MC_BR_AsmStop_Acp6D_0.Execute           :=    FALSE;
				(* Next step *)
				MainStep                                :=    MAIN_READY;
			ELSIF (MC_BR_AsmStop_Acp6D_0.Error) THEN
				(* Next step *)
				ErrorStep := MainStep;
				ErrorNumber := MC_BR_AsmStop_Acp6D_0.ErrorID;
				MainStep                                :=    MAIN_ERROR;
			END_IF
        
		MAIN_ERROR:
			visShowReset := C_SHOW;
			(* Reset the assembly after diagnosis *)
			IF (gMain.Cmd.ErrorReset) AND NOT(gMain.Status.ErrorStop) THEN
				(* Reset command *)
				gMain.Cmd.ErrorReset                    :=    FALSE;
				(* Reset function blocks *)
				MC_BR_AsmPowerOn_Acp6D_0.Execute        :=    FALSE;
				MC_BR_AsmPowerOff_Acp6D_0.Execute       :=    FALSE;
				MC_BR_AsmGetShuttle_Acp6D_0.Enable      :=    FALSE;
				MC_BR_AsmGetShuttle_Acp6D_0.Next        :=    FALSE;
				MC_BR_AsmStop_Acp6D_0.Execute           :=    FALSE;
				MC_BR_MoveInPlane_Acp6D_0.Execute       :=    FALSE; 
				
				// Reset Commands
				gMain.Cmd.Arc                         	:=    FALSE;
				gMain.Cmd.Stop                         	:=    FALSE;
				gMain.Cmd.Move6D                       	:=    FALSE;
				gMain.Cmd.Weigh                        	:=    FALSE;
				gMain.Cmd.StopAll                      	:=    FALSE;
				gMain.Cmd.Land                         	:=    FALSE;
				
			
				ErrorNumber := 0;
				
				(* Next step *)
				IF (gMain.Status.Disabled) THEN
					(* Reset command *)
					gMain.Cmd.Power                     :=    FALSE;
					MainStep                            :=    MAIN_DISABLED;
				ELSIF (gMain.Status.Ready) THEN
					(* Reset command *)
					gMain.Cmd.Power                     :=    TRUE;
					MainStep                            :=    MAIN_READY;
				END_IF
			END_IF
	END_CASE
	

	statusCount := 0;
	FOR i := 0 TO (NUM_SHUTTLES-1) DO	
		
		MC_BR_ShReadInfo_Acp6D_0[i].Shuttle					:= ADR(gShuttleReference[i].Reference);
		MC_BR_ShReadInfo_Acp6D_0[i].Enable					:= gMain.Status.Ready; //gAcp6DCtrl.Status.PowerOn;
				
		MC_BR_ReadCyclicPosition_Acp6D_0[i].Shuttle 		:= ADR(gShuttleReference[i].Reference);;
		MC_BR_ReadCyclicPosition_Acp6D_0[i].Enable			:= gMain.Status.Ready; //gAcp6DCtrl.Status.PowerOn;
		
		IF(MC_BR_ShReadInfo_Acp6D_0[i].Valid)THEN
		
			gVisShuttle.ShuttleInfo[i].Position 	:= MC_BR_ShReadInfo_Acp6D_0[i].ShuttleInfo.Position; 
			gVisShuttle.ShuttleInfo[i].ID			:= UINT_TO_USINT(MC_BR_ShReadInfo_Acp6D_0[i].ShuttleInfo.ShuttleID);
			gVisShuttle.ShuttleInfo[i].State		:= MC_BR_ShReadInfo_Acp6D_0[i].ShuttleInfo.State;
				
			gVisShuttle.ShuttleInfoVis[i].State	:= MC_BR_ShReadInfo_Acp6D_0[i].ShuttleInfo.State;
			gVisShuttle.ShuttleInfoVis[i].Position.X := gVisShuttle.ShuttleInfo[i].Position.X* 1000.0;
			gVisShuttle.ShuttleInfoVis[i].Position.Y := gVisShuttle.ShuttleInfo[i].Position.Y* 1000.0;
			gVisShuttle.ShuttleInfoVis[i].Position.Z := gVisShuttle.ShuttleInfo[i].Position.Z* 1000.0;
			gVisShuttle.ShuttleInfoVis[i].Position.Rx := gVisShuttle.ShuttleInfo[i].Position.Rx* 1000.0;
			gVisShuttle.ShuttleInfoVis[i].Position.Ry := gVisShuttle.ShuttleInfo[i].Position.Ry* 1000.0;
			gVisShuttle.ShuttleInfoVis[i].Position.Rz := gVisShuttle.ShuttleInfo[i].Position.Rz* 1000.0;
			gVisShuttle.ShuttleInfoVis[i].ID := gVisShuttle.ShuttleInfo[i].ID;
			
		ELSIF MC_BR_ShReadInfo_Acp6D_0[i].Error OR MC_BR_ShReadInfo_Acp6D_0[i].Error THEN
			
			MC_BR_ShReadInfo_Acp6D_0[i].Enable 			:= FALSE;
			MC_BR_ReadCyclicPosition_Acp6D_0[i].Enable	:= FALSE;
			
		END_IF
		
		IF ((gVisShuttle.ShuttleInfoVis[i].State = mcACP6D_SH_STATE_DISABLED)) THEN
			statusCount := statusCount + 1;
		END_IF
		
		IF statusCount > 0 THEN
			visResetSelected := C_SHOW;
		ELSE
			visResetSelected := C_HIDE;
			statusCount := 0;
		END_IF
		
		MC_BR_ShReadInfo_Acp6D_0[i]();
		MC_BR_ReadCyclicPosition_Acp6D_0[i]();
	
	END_FOR
	
	// Set present Flags for visability
	IF gMain.Status.ShuttlesPresent > 0 THEN
		FOR i:= 0 TO (gMain.Status.ShuttlesPresent - 1) DO
			gMain.Status.ShtPresent[i] := TRUE;		
		END_FOR
	END_IF
	
	// Change the Land and take off image
	IF(gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].State <> mcACP6D_SH_STATE_LANDED)THEN
		visuLandText := 'Media/Land.png';
	ELSE
		visuLandText := 'Media/Levitate.png';
	END_IF
	
	
	// read assembly info or clear error

	IF MC_BR_AsmGetInfo_Acp6D_0.Error THEN
		MC_BR_AsmGetInfo_Acp6D_0.Execute := FALSE;
	ELSE
		MC_BR_AsmGetInfo_Acp6D_0.Execute 		:= gMain.Status.Ready;
	END_IF
	
	(* Call Function blocks *)
	MC_BR_AsmReadStatus_Acp6D_0();
	MC_BR_AsmReadInfo_Acp6D_0();
	MC_BR_AsmPowerOn_Acp6D_0();
	MC_BR_AsmPowerOff_Acp6D_0();
	MC_BR_AsmGetShuttle_Acp6D_0();
	MC_BR_AsmStop_Acp6D_0();
	MC_BR_MoveInPlane_Acp6D_0();
	MC_BR_MoveShortAxis_Acp6D_0();
	MC_BR_ShStop_Acp6D_0();
	MC_BR_ShLevitation_Acp6D_0();
	MC_BR_MoveInPlaneAsync_Acp6D_0();
	MC_BR_ShGetPayload_Acp6D_0();
	MC_BR_Move6D_Acp6D_0();
	MC_BR_MoveArc_Acp6D_0();
	MC_BR_ShRecover_Acp6D_0();
	MC_BR_ShHalt_Acp6D_0();
	MC_BR_AsmGetInfo_Acp6D_0();
	
	MTLookUpTable_0();
	TON_0();
	
	(* Assign Current Info and Status of the Assembly *)
	gMain.Status.AsmPlcOpenState        :=    MC_BR_AsmReadInfo_Acp6D_0.AssemblyInfo.AssemblyState;
	gMain.Status.ControllerState        :=    MC_BR_AsmReadInfo_Acp6D_0.AssemblyInfo.Controller6DState;
	gMain.Status.StartUp                :=    MC_BR_AsmReadStatus_Acp6D_0.AssemblyStartUp;
	gMain.Status.Disabled               :=    MC_BR_AsmReadStatus_Acp6D_0.AssemblyDisabled;
	gMain.Status.Homing                 :=    MC_BR_AsmReadStatus_Acp6D_0.AssemblyHoming;
	gMain.Status.Ready                  :=    MC_BR_AsmReadStatus_Acp6D_0.AssemblyReady;
	gMain.Status.Stopping               :=    MC_BR_AsmReadStatus_Acp6D_0.AssemblyStopping;
	gMain.Status.ErrorStop              :=    MC_BR_AsmReadStatus_Acp6D_0.AssemblyErrorStop;
	

	// Display the ^D Status Text
	CASE gMain.Status.AsmPlcOpenState OF
		mcACP6D_DISABLED:
			visStatusText := 'Disabled';
			visPowerImage := 'Media/Power.png';
		mcACP6D_HOMING:
			visStatusText := 'Homeing';
			visPowerImage := 'Media/PowerHome.png';
		mcACP6D_READY:
			visStatusText := 'Running';
			visPowerImage := 'Media/PowerOn.png';
		mcACP6D_STOPPING:
			visStatusText := 'Stopping';
			visPowerImage := 'Media/PowerStop.png';
		mcACP6D_ERRORSTOP:
			visStatusText := 'Error Stop';
			visPowerImage := 'Media/PowerRed.png';
		mcACP6D_STARTUP:
			visStatusText := 'Starting Up';
			visPowerImage := 'Media/PowerStarting.png';
		mcACP6D_INVALID_CONFIGURATION:
			visStatusText := 'Problem with Config';
			visPowerImage := 'Media/PowerConfig.png';
	END_CASE	
	
	// Create the demo macro when first going to demo tab
	IF EDGEPOS(visSelectedTab = 4)AND(gMain.Status.ShuttlesPresent > 0)THEN
		gCreateDemo := TRUE;		
	END_IF	
	
	(* Show the ID of the currently selected shuttle reference *)
	gMain.Status.SelectedShuttleID      :=    gShuttleReference[gMain.Par.SelectedIndex].ID;
	gMain.Status.Position 				:=	  gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].Position;
	gMain.Status.Position.Rx := gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].Position.Rx / 17.453293;
	gMain.Status.Position.Ry := gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].Position.Ry / 17.453293;
	gMain.Status.Position.Rz := gVisShuttle.ShuttleInfoVis[gMain.Par.SelectedIndex].Position.Rz / 17.453293;

END_PROGRAM

PROGRAM _EXIT    
    (* Disable FUBs *)
	MC_BR_AsmReadStatus_Acp6D_0.Enable    :=    TRUE;
	MC_BR_AsmReadInfo_Acp6D_0.Enable    :=    TRUE;
     
	(* Call Function blocks *)
	MC_BR_AsmReadStatus_Acp6D_0();
	MC_BR_AsmReadInfo_Acp6D_0();
END_PROGRAM
