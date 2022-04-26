
ACTION WeighAct: 


	CASE stateWeigh OF
	
		0:
			IF gMain.Status.ShuttlesPresent > 0 THEN		
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[0].Shuttle := ADR(gShuttleReference[0].Reference);
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[0].X := 0.06;
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[0].Y := 0.06;
			END_IF
			
			IF gMain.Status.ShuttlesPresent > 1 THEN
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[1].Shuttle := ADR(gShuttleReference[1].Reference);
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[1].X := gAssemblyX_max;
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[1].Y := gAssemblyY_max;
			END_IF
			
			IF gMain.Status.ShuttlesPresent > 2 THEN
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[2].Shuttle := ADR(gShuttleReference[2].Reference);
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[2].X := gAssemblyX_max;
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[2].Y := 0.060;
			END_IF
			
			IF gMain.Status.ShuttlesPresent > 3 THEN
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[3].Shuttle := ADR(gShuttleReference[3].Reference);
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[3].X := 0.060;
				MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.AsyncPar[3].Y := gAssemblyY_max;
			END_IF
	
			MC_BR_MoveInPlaneAsync_Acp6D_0.Execute 	   := TRUE;	
			MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.Acceleration := gMain.Par.Accel;
			MC_BR_MoveInPlaneAsync_Acp6D_0.Parameters.Velocity := gMain.Par.Velocity;
			
			IF MC_BR_MoveInPlaneAsync_Acp6D_0.Done THEN
				MC_BR_MoveInPlaneAsync_Acp6D_0.Execute 	   := FALSE;
				stateWeigh := 10;
			END_IF
			
		10:
			MC_BR_MoveShortAxis_Acp6D_0.Parameters.Position.Rx := 0;
			MC_BR_MoveShortAxis_Acp6D_0.Parameters.Position.Ry := 0; 
			MC_BR_MoveShortAxis_Acp6D_0.Parameters.Position.Z  := 0.001; 
			MC_BR_MoveShortAxis_Acp6D_0.Parameters.Position.Rz := 0; // Convert deg to mRad
		
			MC_BR_MoveShortAxis_Acp6D_0.Shuttle 	 := ADR(gShuttleReference[gMain.Par.SelectedIndex].Reference);
			MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := TRUE;
			MC_BR_MoveShortAxis_Acp6D_0.CommandLabel := 102;
			
			IF MC_BR_MoveShortAxis_Acp6D_0.Done THEN
				MC_BR_MoveShortAxis_Acp6D_0.Execute 	 := FALSE;
				stateWeigh := 20;
			END_IF
		
		20:	
			// Timer for settling time
			TON_0.IN := TRUE;
			TON_0.PT := t#1s;
			IF TON_0.Q THEN
				TON_0.IN := FALSE;
				stateWeigh := 25;
				j := 0;
			END_IF
			
		25:
			IF j <=(gMain.Status.ShuttlesPresent - 1) THEN
				MC_BR_ShGetPayload_Acp6D_0.Shuttle := ADR(gShuttleReference[j].Reference);
				MC_BR_ShGetPayload_Acp6D_0.Execute := TRUE;
					
				IF MC_BR_ShGetPayload_Acp6D_0.Done THEN			
					TareWeight[j] := (MC_BR_ShGetPayload_Acp6D_0.Payload * 1000);
					j := j+1;
					MC_BR_ShGetPayload_Acp6D_0.Execute := FALSE;
					IF j = (gMain.Status.ShuttlesPresent) THEN
						stateWeigh := 30;
						j := 0;
					END_IF
				END_IF
			END_IF
			
	
		30:
			
			IF j <=(gMain.Status.ShuttlesPresent - 1) THEN
				MC_BR_ShGetPayload_Acp6D_0.Shuttle := ADR(gShuttleReference[j].Reference);
				MC_BR_ShGetPayload_Acp6D_0.Execute := TRUE;
					
				IF MC_BR_ShGetPayload_Acp6D_0.Done THEN			
					IF m < 500 THEN
						AverageWeightShtl[j,m] := (MC_BR_ShGetPayload_Acp6D_0.Payload * 1000)- TareWeight[j];;
						m := m +1;
					ELSE
						m := 0;
					END_IF					
		
					j := j+1;
					MC_BR_ShGetPayload_Acp6D_0.Execute := FALSE;
					IF j = (gMain.Status.ShuttlesPresent) THEN
						stateWeigh := 40;
						j := 0;
					END_IF
				END_IF
			END_IF	
	
		
			// calculate average for each shuttle
			FOR l := 0 TO 3 DO
				// Make sure the sum is zeroed
				AverageWeightShtSum[l] := 0;
				// Sum all the values for each shuttle
				FOR k := 0 TO 499 DO
					AverageWeightShtSum[l] :=	AverageWeightShtSum[l] + AverageWeightShtl[l,k];
				END_FOR
			END_FOR
			// Calculate the average
			gMain.Status.Weight[j] :=	AverageWeightShtSum[j]/500; 
			
		40:
	
			IF (visSelectedTab <> 2)THEN
				MainStep                                :=    MAIN_READY;
				stateWeigh := 0;
			ELSIF(gMain.Cmd.Tare)THEN
				stateWeigh := 25;
			ELSE
				stateWeigh := 30;
			END_IF
	
	END_CASE
	


	
END_ACTION
