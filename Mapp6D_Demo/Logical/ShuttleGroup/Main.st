
PROGRAM _INIT
	MC_BR_ShGroupCreate_0.Assembly := ADR(gAssembly6D_1);
	MC_BR_AsmPowerOn_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmReadStatus_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetShuttle_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetShGroup_0.Assembly		:= ADR(gAssembly6D_1);
	ShGroupState := 0;
END_PROGRAM

PROGRAM _CYCLIC
	CASE ShGroupState OF
		0:
			ResetShGroupFubs;	
			IF(Cmd.Start)THEN
				ShGroupState := ShGroupState+1;
				MC_BR_AsmReadStatus_0.Enable := TRUE;
			END_IF;
		
		1:
			IF(MC_BR_AsmReadStatus_0.Valid)THEN
				IF(MC_BR_AsmReadStatus_0.AssemblyDisabled)THEN
					ShGroupState := ShGroupState+1;
				ELSIF(MC_BR_AsmReadStatus_0.AssemblyReady)THEN
					ShGroupState := ShGroupState+2;
				END_IF;
			END_IF;
			
		2:
			MC_BR_AsmPowerOn_Acp6D_0.Execute := TRUE;
			IF(MC_BR_AsmPowerOn_Acp6D_0.Done)THEN
				MC_BR_AsmPowerOn_Acp6D_0.Execute := FALSE;
				ShGroupState := ShGroupState+1;
			END_IF;
			
		3:
			MC_BR_ShGroupCreate_0.Execute := TRUE;
			
			IF(MC_BR_ShGroupCreate_0.Done)THEN
				ShGroupRef := MC_BR_ShGroupCreate_0.ShuttleGroup;
				MC_BR_ShGroupCreate_0.Execute := FALSE;
				ShGroupState := ShGroupState+1;
				i := 0;
			END_IF;
			
			
		4:
			MC_BR_AsmGetShuttle_0.Enable := TRUE;
			IF(MC_BR_AsmGetShuttle_0.Valid)THEN	
				IF(MC_BR_AsmGetShuttle_0.Next)THEN
					ShRefArr[i] := MC_BR_AsmGetShuttle_0.Shuttle;
					i := i+1;
					MC_BR_AsmGetShuttle_0.Next := FALSE;
				ELSE
					IF(i = 0)THEN
						ShRefArr[i] := MC_BR_AsmGetShuttle_0.Shuttle;
						i := i+1;
					END_IF;
					
					MC_BR_AsmGetShuttle_0.Next := TRUE;
				END_IF;
			ELSIF(MC_BR_AsmGetShuttle_0.Error)THEN
				MC_BR_AsmGetShuttle_0.Enable := FALSE;
				ShGroupState := ShGroupState+1;
			END_IF;
		
					
		
		5:
			MC_BR_ShGroupAddShuttle_0.ShuttleGroup := ADR(ShGroupRef);
			FOR i := 0 TO MAX_NUM_SH BY 1 DO
				IF(ShRefArr[i].controlif>0)THEN
					MC_BR_ShGroupAddShuttle_0.Parameters.ShuttleList[i].Shuttle := ADR(ShRefArr[i]);
				END_IF;
			END_FOR;
			MC_BR_ShGroupAddShuttle_0.Execute := TRUE;
			
			IF(MC_BR_ShGroupAddShuttle_0.Done)THEN
				MC_BR_ShGroupAddShuttle_0.Execute := FALSE;
				ShGroupState := ShGroupState+1;
			END_IF;
			
		
		6:
			IF(Cmd.Reset)THEN
				ShGroupState := 0;
				Cmd.Start := FALSE;
				Cmd.Reset := FALSE;
				Cmd.Stop := FALSE;
			END_IF;
		
	END_CASE;
	
	MC_BR_ShGroupClear_0.ShuttleGroup 		:= ADR(ShGroupRef);
	MC_BR_ShGroupGetInfo_0.ShuttleGroup	:= ADR(ShGroupRef);
	MC_BR_ShGroupCoupleCtrl_0.ShuttleGroup	:= ADR(ShGroupRef);
	MC_BR_ShGroupBuffer_0.ShuttleGroup		:= ADR(ShGroupRef);
	MC_BR_ShGroupDelete_0.ShuttleGroup		:= ADR(ShGroupRef);
	
	
	MC_BR_ShGroupDelete_0();
	MC_BR_AsmGetShGroup_0();
	MC_BR_ShGroupBuffer_0();
	MC_BR_ShGroupCoupleCtrl_0();
	MC_BR_ShGroupGetInfo_0();
	MC_BR_ShGroupClear_0();
	MC_BR_ShGroupAddShuttle_0();
	MC_BR_AsmGetShuttle_0();
	MC_BR_ShGroupCreate_0();
	MC_BR_AsmReadStatus_0();
	MC_BR_AsmPowerOn_Acp6D_0();
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

