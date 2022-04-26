
ACTION RecoverAct: 

	MC_BR_ShRecover_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
	MC_BR_ShRecover_Acp6D_0.Execute := TRUE;
	
	IF MC_BR_ShRecover_Acp6D_0.Done THEN
		MC_BR_ShRecover_Acp6D_0.Execute := FALSE;
		MainStep          := MAIN_READY;
	ELSIF MC_BR_ShRecover_Acp6D_0.Error THEN
		MC_BR_ShRecover_Acp6D_0.Execute := FALSE;
		MainStep          := MAIN_ERROR;
	END_IF
	
	
	stateRecover
	
END_ACTION
