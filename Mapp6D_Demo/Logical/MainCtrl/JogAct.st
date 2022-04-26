
ACTION JogAct: 

	// Get the position of the sleected shuttle
	gMain.Par.Jog.Position.X := (gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.X);
	gMain.Par.Jog.Position.Y := (gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Y);
	// Set the jog velocity and Acceleration

	gMain.Cmd.Jog.ShuttleID :=	UINT_TO_USINT(gMain.Par.SelectedIndex); // Selected shuttle
	gMain.Par.Jog.EndVelocity :=  0.0;
	// Pitch and Yaw limit
	MTLookUpTable_0.InX := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z; 
	YawLimit := MTLookUpTable_0.Out;
	
	
	// Movement complete
	IF MC_BR_MoveInPlane_Acp6D_0.Done OR MC_BR_MoveShortAxis_Acp6D_0.Done THEN
		
		MC_BR_MoveShortAxis_Acp6D_0.Execute := FALSE;
		MC_BR_MoveInPlane_Acp6D_0.Execute 	   := FALSE;
	ELSIF EDGENEG(gMain.Cmd.Jog.Left OR gMain.Cmd.Jog.Right OR gMain.Cmd.Jog.Neg OR gMain.Cmd.Jog.Pos)THEN
		
		MC_BR_ShStop_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_ShStop_Acp6D_0.Execute := TRUE;
		
		// Move left the jog distance
	ELSIF gMain.Cmd.Jog.Left AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.X - gMain.Cmd.Jog.Distance) > 0.01)THEN
		
		MC_BR_MoveInPlane_Acp6D_0.Shuttle 	   := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveInPlane_Acp6D_0.Execute 	   := TRUE;
		gMain.Par.Jog.Position.X := 0.045;//(gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.X - gMain.Cmd.Jog.Distance);
			gMain.Par.Jog.Position.Y :=  gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Y;
		MC_BR_MoveInPlane_Acp6D_0.Parameters   :=  gMain.Par.Jog;
		MC_BR_MoveInPlane_Acp6D_0.CommandLabel := 90;
	
		// Move right the jog distance
	ELSIF gMain.Cmd.Jog.Right AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.X + gMain.Cmd.Jog.Distance) < 0.239) THEN
		
		MC_BR_MoveInPlane_Acp6D_0.Shuttle 	   := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveInPlane_Acp6D_0.Execute 	   := TRUE;
		gMain.Par.Jog.Position.X := gAssemblyX_max + 0.015;//0.195;//(gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.X + gMain.Cmd.Jog.Distance); 
		gMain.Par.Jog.Position.Y :=  gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Y;
		MC_BR_MoveInPlane_Acp6D_0.Parameters   :=  gMain.Par.Jog;
		MC_BR_MoveInPlane_Acp6D_0.CommandLabel := 91;
	
		// Move down the jog distance
	ELSIF gMain.Cmd.Jog.Neg AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Y - gMain.Cmd.Jog.Distance) > 0.01)THEN
		
		MC_BR_MoveInPlane_Acp6D_0.Shuttle 	   := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveInPlane_Acp6D_0.Execute 	   := TRUE;
	gMain.Par.Jog.Position.X :=  gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.X;
		gMain.Par.Jog.Position.Y := 0.045;//(gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Y - gMain.Cmd.Jog.Distance); 
		MC_BR_MoveInPlane_Acp6D_0.Parameters   :=  gMain.Par.Jog;
		MC_BR_MoveInPlane_Acp6D_0.CommandLabel := 92;
		
		// Move up the jog distance
	ELSIF gMain.Cmd.Jog.Pos AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Y + gMain.Cmd.Jog.Distance) < 0.479)THEN
		
		MC_BR_MoveInPlane_Acp6D_0.Shuttle 	   := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveInPlane_Acp6D_0.Execute 	   := TRUE;
		gMain.Par.Jog.Position.X :=  gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.X;
		gMain.Par.Jog.Position.Y := gAssemblyY_max + 0.015;//0.435;//(gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Y + gMain.Cmd.Jog.Distance); 
		MC_BR_MoveInPlane_Acp6D_0.Parameters   :=  gMain.Par.Jog;
		MC_BR_MoveInPlane_Acp6D_0.CommandLabel := 93;
			
	ELSIF gMain.Cmd.Jog.RzP AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz + (gMain.Cmd.Jog.Degrees * 0.017453293)) < 0.136)THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx;
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry; 
		gMain.Par.JogShort.Position.Z := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z; 
		gMain.Par.JogShort.Position.Rz := (gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz + (gMain.Cmd.Jog.Degrees * 0.017453293 )); 
			
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;	
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   :=  gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 94;	
		
	ELSIF gMain.Cmd.Jog.RzN AND(((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz - ((gMain.Cmd.Jog.Degrees * 0.017453293))) > -0.136))THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx;
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry; 
		gMain.Par.JogShort.Position.Z := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z; 
		gMain.Par.JogShort.Position.Rz := (gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz - (gMain.Cmd.Jog.Degrees * 0.017453293 )); // Convert deg to mRad
		
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   :=  gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 95;	

		
	ELSIF gMain.Cmd.Jog.RxP AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx + (0.1 * 0.017453293)) < YawLimit)THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx + (0.1 * 0.017453293);
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry; 
		gMain.Par.JogShort.Position.Z  := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z; 
		gMain.Par.JogShort.Position.Rz := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz; 
			
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;	
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   := gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 96;	
		
	ELSIF gMain.Cmd.Jog.RxN AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx -((0.1 * 0.017453293)) > -YawLimit))THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx  - (0.1 * 0.017453293);
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry; 
		gMain.Par.JogShort.Position.Z  := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z; 
		gMain.Par.JogShort.Position.Rz := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz; // Convert deg to mRad
		
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   := gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 97;		
		
	
	ELSIF gMain.Cmd.Jog.RyP AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry + (0.1 * 0.017453293)) < YawLimit)THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx;
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry + (0.1 * 0.017453293); 
		gMain.Par.JogShort.Position.Z  := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z; 
		gMain.Par.JogShort.Position.Rz := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz; 
			
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;	
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   := gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 98;	
		
	ELSIF gMain.Cmd.Jog.RyN AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry -((0.1 * 0.017453293)) > -YawLimit))THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx;
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry - (0.1 * 0.017453293); 
		gMain.Par.JogShort.Position.Z  := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z; 
		gMain.Par.JogShort.Position.Rz := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz; // Convert deg to mRad
		
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   := gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 99;	
		
	ELSIF gMain.Cmd.Jog.Up AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry + 0.0001) < 0.0041)THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx;
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry; 
		gMain.Par.JogShort.Position.Z  := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z + 0.0001; 
		gMain.Par.JogShort.Position.Rz := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz; 
			
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;	
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   := gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 100;	
		
	ELSIF gMain.Cmd.Jog.Down AND((gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z - 0.0001) > 0.0009)THEN
		
		gMain.Par.JogShort.Position.Rx := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rx;
		gMain.Par.JogShort.Position.Ry := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Ry; 
		gMain.Par.JogShort.Position.Z  := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Z - 0.0001; 
		gMain.Par.JogShort.Position.Rz := gVisShuttle.ShuttleInfo[gMain.Cmd.Jog.ShuttleID].Position.Rz; // Convert deg to mRad
		
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   := gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 101;		
		
	// Zero the short axes	
	ELSIF gMain.Cmd.Jog.Zero THEN
		
		gMain.Par.JogShort.Position.Rx := 0;
		gMain.Par.JogShort.Position.Ry := 0; 
		gMain.Par.JogShort.Position.Z  := 0.001; 
		gMain.Par.JogShort.Position.Rz := 0; // Convert deg to mRad
		
		MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;
		MC_BR_MoveShortAxis_Acp6D_0.Parameters   := gMain.Par.JogShort;
		MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 102;		
		
		// Clear the command if there is an obstacle
	ELSIF(gVisShuttle.ShuttleInfoVis[gMain.Cmd.Jog.ShuttleID].State = mcACP6D_SH_STATE_OBSTACLE)THEN
		
		MC_BR_MoveInPlane_Acp6D_0.Execute 	   := FALSE;
		MC_BR_MoveShortAxis_Acp6D_0.Execute := FALSE;
		MC_BR_ShStop_Acp6D_0.Shuttle := ADR(gShuttleReference[gMain.Cmd.Jog.ShuttleID].Reference);
		MC_BR_ShStop_Acp6D_0.Execute := TRUE;
		
	
		// Reset the comand if there is an error
	ELSIF MC_BR_MoveInPlane_Acp6D_0.Error OR MC_BR_MoveShortAxis_Acp6D_0.Error THEN	
		
		MC_BR_MoveInPlane_Acp6D_0.Execute 	   := FALSE;
		MC_BR_MoveShortAxis_Acp6D_0.Execute := FALSE;

	END_IF
	
	
	
	
	IF MC_BR_ShStop_Acp6D_0.Done THEN
			MC_BR_ShStop_Acp6D_0.Execute := FALSE;
	END_IF
	
	
END_ACTION
