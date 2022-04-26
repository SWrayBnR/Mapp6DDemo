
PROGRAM _INIT
	(* Insert code here *)
	
	MacroName := 'Demo';
	inc			:= 0;
	MC_BR_MacroCreate_Acp6D_0.Assembly := ADR(gAssembly6D_1);
	MC_BR_AsmPowerOn_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmReadStatus_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_MacroDelete_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetShuttle_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_MoveInPlaneAsync_Acp6D_0.Assembly := ADR(gAssembly6D_1);

	
END_PROGRAM

PROGRAM _CYCLIC
	

	Cmd.Start := gCreateDemo;
	
	IF MacroState < C_NEXT_COMMAND_05 THEN
		visMacroStatus := 'Waiting';
		visLockRun := FALSE;
	ELSIF MacroState >= C_NEXT_COMMAND_05 AND MacroState < C_REMAKE_DEMO_MACRO_70 THEN
		visMacroStatus := 'Creating Demo Marco';
		visLockRun := FALSE;
	ELSIF MacroState = C_REMAKE_DEMO_MACRO_70 THEN
		visMacroStatus := 'Ready';
		visLockRun := TRUE;
	ELSIF MacroState > C_RUN_DEMO_MACRO_80 OR MacroState <= C_RE_RUN_85 THEN
		visMacroStatus := 'Runing Macro';
		visLockRun := FALSE;
	END_IF
	
	
	CASE MacroState OF
		
		C_WAIT_00:
			
			ResetMacroFubs;	
			
			IF(Cmd.Start)THEN
				Cmd.Start := FALSE;
				command := 0;
				MacroState := C_READ_STATUS_01;
				MC_BR_AsmReadStatus_0.Enable := TRUE;
			END_IF;
		
		C_READ_STATUS_01:
			
			IF(MC_BR_AsmReadStatus_0.Valid)THEN
				IF 	gCreateDemo THEN
					MacroName := 'Demo';
					gCreateDemo := FALSE;
					DemoAct;
				END_IF
				IF(MC_BR_AsmReadStatus_0.AssemblyDisabled)THEN
					MacroState := C_POWER_ON_02;
				ELSIF(MC_BR_AsmReadStatus_0.AssemblyReady)THEN
					MacroState := C_CREATE_03;
				END_IF;
			END_IF;
			
		C_POWER_ON_02:
			
			MC_BR_AsmPowerOn_Acp6D_0.Execute := TRUE;
			
			IF(MC_BR_AsmPowerOn_Acp6D_0.Done)THEN
				MC_BR_AsmPowerOn_Acp6D_0.Execute := FALSE;
				MacroState := C_CREATE_03;				
			END_IF;
			
		C_CREATE_03:
			
			MC_BR_MacroCreate_Acp6D_0.Parameters.Name := MacroName;
			int_to_str := USINT_TO_STRING(inc);
			brsstrcat(ADR(MC_BR_MacroCreate_Acp6D_0.Parameters.Name),ADR(int_to_str));
			TempName := MC_BR_MacroCreate_Acp6D_0.Parameters.Name;
			MC_BR_MacroCreate_Acp6D_0.Execute := TRUE;
			
			IF(MC_BR_MacroCreate_Acp6D_0.Done)THEN
				MC_BR_MacroCreate_Acp6D_0.Execute := FALSE;
				MacroState := C_NEXT_COMMAND_05;
				MacroSh[inc] := MC_BR_MacroCreate_Acp6D_0.MacroShuttle;			
			ELSIF MC_BR_MacroCreate_Acp6D_0.ErrorID = -1065811716 THEN
					MC_BR_MacroCreate_Acp6D_0.Execute := FALSE;
					MacroState := C_DELETE_04;	
			END_IF;
		
		C_DELETE_04:
			
			MC_BR_MacroDelete_0.Name := MacroName;			
			MC_BR_MacroDelete_0.Command :=	mcACP6D_MACRO_DELETE_SPECIFIC;
			MC_BR_MacroDelete_0.Execute := TRUE;
			
			IF(MC_BR_MacroDelete_0.Done)THEN
				MC_BR_MacroDelete_0.Execute := FALSE;
				Cmd.Start := FALSE;
				MacroState := C_WAIT_00;
			ELSIF  MC_BR_MacroDelete_0.ErrorID = -1065811714  THEN
				MC_BR_MacroDelete_0.Execute := FALSE;
				Cmd.Start := FALSE;
				MacroState := C_WAIT_00;	
			END_IF
			
		C_NEXT_COMMAND_05:
		
			IF gMacro[command].CommandType = 60 THEN
				MacroState := gMacro[command].CommandType;
			ELSE
				MacroState := gMacro[command].CommandType;
			END_IF
		
		C_MOVE_IN_PLANE_010:
			
			MC_BR_MoveInPlane_Acp6D_0.Shuttle 	 := ADR(MacroSh[inc]);;
			MC_BR_MoveInPlane_Acp6D_0.Parameters := gMacro[command].MovePlane;	
			MC_BR_MoveInPlane_Acp6D_0.Execute 	 := TRUE;
		
			IF(MC_BR_MoveInPlane_Acp6D_0.Acknowledge)THEN
				MC_BR_MoveInPlane_Acp6D_0.Execute := FALSE;
				command := command + 1;
				MacroState := C_NEXT_COMMAND_05;
			END_IF;
			
		C_MOVE_IN_PLANE_ASYNC_015:
			
			MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters	:= gMacro[command].MoveAsync;
			MC_BR_MoveInPlaneAsync_Acp6D_0.Execute 	:= TRUE;

			IF(MC_BR_MoveInPlaneAsync_Acp6D_0.Acknowledge)THEN
				MC_BR_MoveInPlaneAsync_Acp6D_0.Execute := FALSE;
				command := command + 1;
				MacroState := C_NEXT_COMMAND_05;			
			END_IF;
			
		C_MOVE_IN_6D_PLANE_020:
		
			MC_BR_Move6D_Acp6D_0.Shuttle 	:= ADR(MacroSh[inc]);
			MC_BR_Move6D_Acp6D_0.Parameters	:= gMacro[command].Move6D;
			MC_BR_Move6D_Acp6D_0.Execute 	:= TRUE;

			IF(MC_BR_Move6D_Acp6D_0.Acknowledge)THEN
				MC_BR_Move6D_Acp6D_0.Execute := FALSE;
				command := command + 1;
				MacroState := C_NEXT_COMMAND_05;			
			END_IF;
			
		C_MOVE_ARC_025:
			
			MC_BR_MoveArc_Acp6D_0.Shuttle 		:= ADR(MacroSh[inc]);
			MC_BR_MoveArc_Acp6D_0.Parameters	:= gMacro[command].MoveArc;
			MC_BR_MoveArc_Acp6D_0.Execute 		:= TRUE;

			IF(MC_BR_MoveArc_Acp6D_0.Acknowledge)THEN
				MC_BR_MoveArc_Acp6D_0.Execute := FALSE;
				command := command + 1;
				MacroState := C_NEXT_COMMAND_05;			
			END_IF;
			
			
		C_SAVE_60:
			
			MC_BR_MacroSave_0.Shuttle := ADR(MacroSh[inc]);
			MC_BR_MacroSave_0.Execute := TRUE;
			
			IF(MC_BR_MacroSave_0.Done)THEN
				ExistingMacroNames[inc] := TempName;
				MC_BR_MacroSave_0.Execute := FALSE;
				MacroState := C_REMAKE_DEMO_MACRO_70;
				command := 0;
				inc := inc+1;
				i := 0;
			ELSIF(MC_BR_MacroSave_0.Error AND Clear)THEN
				MC_BR_MacroSave_0.Execute := FALSE;
				MacroState := C_RESET_100;
			END_IF;
			
		
		C_REMAKE_DEMO_MACRO_70:
			
			// Recreate the demo macro for all shuttles (MAX 4 in this action)
			IF(inc < gMain.Status.ShuttlesPresent)THEN			
				MacroState := C_READ_STATUS_01;
			END_IF
						
			IF RunMacro THEN
				RunMacro := FALSE;
				MacroState := C_RUN_DEMO_MACRO_80;
			END_IF
				
		C_RUN_DEMO_MACRO_80:
			
			MC_BR_MacroRun_0.Shuttle := ADR(gShuttleReference[0].Reference);
			MC_BR_MacroRun_0.Execute := TRUE;
			MC_BR_MacroRun_0.Name	:= ExistingMacroNames[0];
			
			IF(MC_BR_MacroRun_0.Acknowledge)THEN
				MC_BR_MacroRun_0.Execute := FALSE;
				MacroState := C_RUN_DEMO_MACRO_81;
			END_IF;
		
		C_RUN_DEMO_MACRO_81:
			
			IF gMain.Status.ShuttlesPresent > 3 THEN
				MC_BR_MacroRun_0.Shuttle := ADR(gShuttleReference[3].Reference);
				MC_BR_MacroRun_0.Execute := TRUE;
				MC_BR_MacroRun_0.Name	:= ExistingMacroNames[3];
			
				IF(MC_BR_MacroRun_0.Acknowledge)THEN
					MC_BR_MacroRun_0.Execute := FALSE;
					MacroState := C_RUN_DEMO_MACRO_82;
				END_IF;
			ELSE
				MacroState := C_RUN_DEMO_MACRO_82;
			END_IF
	
		C_RUN_DEMO_MACRO_82:
			
			IF gMain.Status.ShuttlesPresent > 2 THEN
				MC_BR_MacroRun_0.Shuttle := ADR(gShuttleReference[2].Reference);
				MC_BR_MacroRun_0.Execute := TRUE;
				MC_BR_MacroRun_0.Name	:= ExistingMacroNames[2];
			
				IF(MC_BR_MacroRun_0.Acknowledge)THEN
					MC_BR_MacroRun_0.Execute := FALSE;
					MacroState := C_RUN_DEMO_MACRO_83;
				END_IF;
			ELSE
				MacroState := C_RUN_DEMO_MACRO_83;
			END_IF	
		
		C_RUN_DEMO_MACRO_83:
			
			IF gMain.Status.ShuttlesPresent > 1 THEN
				MC_BR_MacroRun_0.Shuttle := ADR(gShuttleReference[1].Reference);
				MC_BR_MacroRun_0.Execute := TRUE;
				MC_BR_MacroRun_0.Name	:= ExistingMacroNames[1];
			
				IF(MC_BR_MacroRun_0.Acknowledge)THEN
					MC_BR_MacroRun_0.Execute := FALSE;
					MacroState := C_RE_RUN_85;
				END_IF;
			ELSE
				MacroState := C_RE_RUN_85;
			END_IF		
			
		C_RE_RUN_85:
			
			IF(gVisShuttle.ShuttleInfoVis[0].State <> mcACP6D_SH_STATE_MOTION)AND(gVisShuttle.ShuttleInfoVis[1].State <> mcACP6D_SH_STATE_MOTION)AND(gVisShuttle.ShuttleInfoVis[2].State <> mcACP6D_SH_STATE_MOTION)AND(gVisShuttle.ShuttleInfoVis[3].State <> mcACP6D_SH_STATE_MOTION)THEN
				MacroState := C_REMAKE_DEMO_MACRO_70;
			END_IF
		
			IF ReRun THEN
				RunMacro := TRUE;
			END_IF
			
		C_CLEARMACRO_90:
			
			MC_BR_MacroClear_0.Shuttle := ADR(MacroSh[inc]);
			MC_BR_MacroClear_0.Execute := TRUE;
			
			IF(MC_BR_MacroClear_0.Done)THEN
				MC_BR_MacroClear_0.Execute := FALSE;
				MacroState := C_WAIT_00;
			END_IF;
					
		C_RESET_100:
			
			IF(Cmd.Reset)THEN
				MacroState := C_WAIT_00;
				Cmd.Start := FALSE;
				Cmd.Reset := FALSE;
				Cmd.Stop := FALSE;
				Clear := FALSE;
			END_IF;
		
	END_CASE;
	
	MC_BR_AsmPowerOn_Acp6D_0();
	MC_BR_MacroCreate_Acp6D_0();
	MC_BR_MoveInPlane_Acp6D_0();
	MC_BR_MoveInPlaneAsync_Acp6D_0();
	MC_BR_Move6D_Acp6D_0();
	MC_BR_MoveArc_Acp6D_0();
	MC_BR_AsmReadStatus_0();
	MC_BR_MacroSave_0();
	MC_BR_MacroClear_0();
	MC_BR_MacroDelete_0();
	MC_BR_MacroRun_0();
	MC_BR_AsmGetShuttle_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

