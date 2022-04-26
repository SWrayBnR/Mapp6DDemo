
PROGRAM _CYCLIC

	CASE zoneState OF
		
		0:
		// Create Zone
		10:
		//	MC_BR_ZoneCreate_Acp6D_0.Assembly := ;
			MC_BR_ZoneCreate_Acp6D_0.Execute := TRUE; 
			MC_BR_ZoneCreate_Acp6D_0.Parameters := ZonePars;
			
			ZonePars.BottomLeft.X := 0.0;
			ZonePars.BottomLeft.Y := 0.240;
			ZonePars.TopRight.X := 0.240;
			ZonePars.TopRight.Y := 0.240;
		//	ZonePars.Name :='1';
		//	ZonePars.ZoneType;
			zoneState := 0;
		// Power on Zone
		20:
		// Power off Zone
		30:
			MC_BR_ZonePowerOff_Acp6D_0.Zone := ADR(MC_BR_AsmGetZone_Acp6D_0.Zone);
			MC_BR_ZonePowerOff_Acp6D_0.Execute := 	TRUE;
				zoneState := 0;
		// Get Zone Info
		40:
			MC_BR_AsmGetZone_Acp6D_0.Enable := TRUE;
			zoneState := 0;
		//	MC_BR_AsmGetZone_Acp6D_0.Next := ;
		
	END_CASE

	MC_BR_ZoneCreate_Acp6D_0();
	MC_BR_AsmGetZone_Acp6D_0();
	MC_BR_ZonePowerOff_Acp6D_0();

	
END_PROGRAM
