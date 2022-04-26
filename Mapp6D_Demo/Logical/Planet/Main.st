
PROGRAM _INIT
	MC_BR_AsmPowerOn_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmReadStatus_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetVirtualSh_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_VirtualShCreate_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmGetVirtualSh_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmGetShuttle_0.Assembly		:= ADR(gAssembly6D_1);
	PlanetState := 0;
END_PROGRAM

PROGRAM _CYCLIC
	CASE PlanetState OF
		0:
			ResetPlanetFub;	
			IF(Cmd.Start)THEN
				PlanetState := PlanetState+1;
				MC_BR_AsmReadStatus_0.Enable := TRUE;
			END_IF;
		
		1:
			IF(MC_BR_AsmReadStatus_0.Valid)THEN
				IF(MC_BR_AsmReadStatus_0.AssemblyDisabled)THEN
					PlanetState := PlanetState+1;
				ELSIF(MC_BR_AsmReadStatus_0.AssemblyReady)THEN
					PlanetState := PlanetState+2;
				END_IF;
			END_IF;
			
		2:
			MC_BR_AsmPowerOn_Acp6D_0.Execute := TRUE;
			IF(MC_BR_AsmPowerOn_Acp6D_0.Done)THEN
				MC_BR_AsmPowerOn_Acp6D_0.Execute := FALSE;
				PlanetState := PlanetState+1;
			END_IF;
			
		3:
			MC_BR_VirtualShCreate_0.Execute := TRUE;
			
			IF(MC_BR_VirtualShCreate_0.Done)THEN
				VirtualShRef := MC_BR_VirtualShCreate_0.VirtualShuttle;
				MC_BR_VirtualShCreate_0.Execute := FALSE;
				PlanetState := PlanetState+1;
				i := 0;
			END_IF;
			
			
		4:
			MC_BR_AsmGetShuttle_0.Enable := TRUE;
			IF(MC_BR_AsmGetShuttle_0.Valid)THEN	
				IF(MC_BR_AsmGetShuttle_0.Next)THEN
					PlanetShRefArr[i] := MC_BR_AsmGetShuttle_0.Shuttle;
					i := i+1;
					MC_BR_AsmGetShuttle_0.Next := FALSE;
				ELSE
					IF(i = 0)THEN
						PlanetShRefArr[i] := MC_BR_AsmGetShuttle_0.Shuttle;
						i := i+1;
					END_IF;
					
					MC_BR_AsmGetShuttle_0.Next := TRUE;
				END_IF;
			ELSIF(MC_BR_AsmGetShuttle_0.Error)THEN
				MC_BR_AsmGetShuttle_0.Enable := FALSE;
				PlanetState := PlanetState+1;
			END_IF;
			
			
			
		5:
			MC_BR_ShPlanet_0.Shuttle := ADR(VirtualShRef);
			MC_BR_ShPlanet_0.Parameters.ShuttleList[0].Shuttle := ADR(PlanetShRefArr[0]);
			MC_BR_ShPlanet_0.Parameters.ShuttleList[1].Shuttle := ADR(PlanetShRefArr[1]);
			MC_BR_ShPlanet_0.Parameters.Option				   := mcACP6D_PLANET_ADD_SH;
			MC_BR_ShPlanet_0.Execute := TRUE;
			
			IF(MC_BR_ShPlanet_0.Done)THEN
				MC_BR_ShPlanet_0.Execute := FALSE;
				PlanetState := PlanetState +1;
			END_IF;
		
		6:
			MC_BR_MoveInPlane_0.Shuttle := ADR(VirtualShRef);
			MC_BR_MoveInPlane_0.Parameters.Acceleration := 10;
			MC_BR_MoveInPlane_0.Parameters.Velocity := 1;
			MC_BR_MoveInPlane_0.Parameters.EndVelocity := 0;
			MC_BR_MoveInPlane_0.Parameters.Mode := 1;
			MC_BR_MoveInPlane_0.Parameters.Path := 0;
			MC_BR_MoveInPlane_0.Parameters.Position.X := 0.12;
			MC_BR_MoveInPlane_0.Parameters.Position.Y := 0.12;
			MC_BR_MoveInPlane_0.Execute := TRUE;
			
			IF(MC_BR_MoveInPlane_0.Acknowledge)THEN
				MC_BR_MoveInPlane_0.Execute := FALSE;
				PlanetState := PlanetState+1;
			END_IF;
		7:
			IF(Cmd.Reset)THEN
				PlanetState := 0;
				Cmd.Start := FALSE;
				Cmd.Reset := FALSE;
				Cmd.Stop := FALSE;
			END_IF;
		
	END_CASE;
	

	MC_BR_MoveInPlane_0();
	MC_BR_AsmGetShuttle_0();
	MC_BR_VirtualShCreate_0();
	MC_BR_AsmReadStatus_0();
	MC_BR_AsmPowerOn_Acp6D_0();
	MC_BR_ShPlanet_0();
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

