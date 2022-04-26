
PROGRAM _INIT
	MC_BR_AsmPowerOn_Acp6D_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmReadStatus_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_AsmGetVirtualSh_0.Assembly		:= ADR(gAssembly6D_1);
	MC_BR_VirtualShCreate_0.Assembly	:= ADR(gAssembly6D_1);
	MC_BR_AsmGetVirtualSh_0.Assembly	:= ADR(gAssembly6D_1);
	VirtualShState := 0;
END_PROGRAM

PROGRAM _CYCLIC
	CASE VirtualShState OF
		0:
			ResetShGroupFubs;	
			IF(Cmd.Start)THEN
				VirtualShState := VirtualShState+1;
				MC_BR_AsmReadStatus_0.Enable := TRUE;
			END_IF;
		
		1:
			IF(MC_BR_AsmReadStatus_0.Valid)THEN
				IF(MC_BR_AsmReadStatus_0.AssemblyDisabled)THEN
					VirtualShState := VirtualShState+1;
				ELSIF(MC_BR_AsmReadStatus_0.AssemblyReady)THEN
					VirtualShState := VirtualShState+2;
				END_IF;
			END_IF;
			
		2:
			MC_BR_AsmPowerOn_Acp6D_0.Execute := TRUE;
			IF(MC_BR_AsmPowerOn_Acp6D_0.Done)THEN
				MC_BR_AsmPowerOn_Acp6D_0.Execute := FALSE;
				VirtualShState := VirtualShState+1;
			END_IF;
			
		3:
			MC_BR_VirtualShCreate_0.Execute := TRUE;
			
			IF(MC_BR_VirtualShCreate_0.Done)THEN
				VirtualShRef := MC_BR_VirtualShCreate_0.VirtualShuttle;
				MC_BR_VirtualShCreate_0.Execute := FALSE;
				VirtualShState := VirtualShState+1;
				i := 0;
			END_IF;
			
			
		4:
			MC_BR_AsmGetVirtualSh_0.Enable := TRUE;
			IF(MC_BR_AsmGetVirtualSh_0.Valid)THEN	
				IF(MC_BR_AsmGetVirtualSh_0.Next)THEN
					VirtualShRefArr[i] := MC_BR_AsmGetVirtualSh_0.VirtualShuttle;
					i := i+1;
					MC_BR_AsmGetVirtualSh_0.Next := FALSE;
				ELSE
					IF(i = 0)THEN
						VirtualShRefArr[i] := MC_BR_AsmGetVirtualSh_0.VirtualShuttle;
						i := i+1;
					END_IF;
					
					MC_BR_AsmGetVirtualSh_0.Next := TRUE;
				END_IF;
			ELSIF(MC_BR_AsmGetVirtualSh_0.Error)THEN
				MC_BR_AsmGetVirtualSh_0.Enable := FALSE;
				VirtualShState := VirtualShState+1;
			END_IF;
		
		
		5:
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
				VirtualShState := VirtualShState+1;
			END_IF;
		6:
			IF(Cmd.Reset)THEN
				VirtualShState := 0;
				Cmd.Start := FALSE;
				Cmd.Reset := FALSE;
				Cmd.Stop := FALSE;
			END_IF;
		
	END_CASE;
	

	MC_BR_MoveInPlane_0();
	MC_BR_AsmGetVirtualSh_0();
	MC_BR_VirtualShCreate_0();
	MC_BR_AsmReadStatus_0();
	MC_BR_AsmPowerOn_Acp6D_0();
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

