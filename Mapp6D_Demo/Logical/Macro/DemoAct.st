
ACTION DemoAct: 

	// DEMO MACRO
	macroLine := 0;
	XY_MIN; 			// Min position on one segment 0.6 `
	XY_MAX; 			// Max position on one segment 0.240
	SEG_CENTER;			// Middle position 0.120
	
	// Calculate the min and max movement positions allowed
	
	
	IF inc = 0 THEN // System Top right 1st position
		FirstPosX := gAssemblyX_max;
		FirstPosY := gAssemblyY_max;
		SecondPosX := XY_MIN;
		SecondPosY := XY_MIN;
		CenterSegX := SEG_CENTER;
		CenterSegY := SEG_CENTER;
		PathCW := mcACP6D_PATH_Y_THEN_X;
		PathACW := mcACP6D_PATH_X_THEN_Y;
	ELSIF inc = 1 THEN // Bottom Left of system 1st position
		FirstPosX := XY_MIN;
		FirstPosY := XY_MIN;
		SecondPosX := gAssemblyX_max;
		SecondPosY := gAssemblyY_max;
		CenterSegX := gAssemblyX_max - HALF_SHUTTLE;
		CenterSegY := gAssemblyY_max - HALF_SHUTTLE;
		PathCW := mcACP6D_PATH_Y_THEN_X;
		PathACW := mcACP6D_PATH_X_THEN_Y;
	ELSIF inc = 2 THEN // Top left of system 1st position
		FirstPosX := XY_MIN;
		FirstPosY := gAssemblyY_max;
		SecondPosX := gAssemblyX_max;
		SecondPosY := XY_MIN;
		CenterSegX := gAssemblyX_max - HALF_SHUTTLE;
		CenterSegY := SEG_CENTER;
		PathCW := mcACP6D_PATH_X_THEN_Y;
		PathACW := mcACP6D_PATH_Y_THEN_X;
	ELSIF inc = 3 THEN // Bottom right of system 1st position
		FirstPosX := gAssemblyX_max;
		FirstPosY := XY_MIN;
		SecondPosX := XY_MIN;
		SecondPosY := gAssemblyY_max;
		CenterSegX := SEG_CENTER;
		CenterSegY := gAssemblyY_max - HALF_SHUTTLE;
		PathCW := mcACP6D_PATH_X_THEN_Y;
		PathACW := mcACP6D_PATH_Y_THEN_X;
	END_IF
	
	// Round edge twice total CWise
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := FirstPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := FirstPosY;
	DemoMacro[macroLine].MovePlane.Path := PathCW;
	
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := SecondPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := SecondPosY;
	DemoMacro[macroLine].MovePlane.Path := PathCW;
	
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := FirstPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := FirstPosY;
	DemoMacro[macroLine].MovePlane.Path := PathCW;
	
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := SecondPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := SecondPosY;
	DemoMacro[macroLine].MovePlane.Path := PathCW;
	
	macroLine := macroLine + 1;

	// Move to center and dance...
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.003;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.086;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := -0.015;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := -0.015;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;

	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.001;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := -0.086;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := 0.00;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := 0.00;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.004;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := -0.015;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := -0.015;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.004;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := -0.015;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := 0;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.004;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := 0;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := 0.015;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.004;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := 0.015;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := 0.015;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.004;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := 0.015;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := 0;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.004;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := 0.0;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := -0.015;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.004;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := -0.015;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := -0.015;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	// RESET Short Axes
	DemoMacro[macroLine].ShuttleID 					  := 1;
	DemoMacro[macroLine].CommandType 				  := C_MOVE_IN_6D_PLANE_020;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Z  := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Z  := 0.001;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rz := 0.3;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rz := 0.0;	
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Rx := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Rx := 0.0;
	DemoMacro[macroLine].Move6D.ShortAxis.Velocity.Ry := 0.1;
	DemoMacro[macroLine].Move6D.ShortAxis.Position.Ry := 0.0;
	DemoMacro[macroLine].Move6D.InPlane.Velocity      := 0.2;
	DemoMacro[macroLine].Move6D.InPlane.Acceleration  := 10;
	DemoMacro[macroLine].Move6D.InPlane.Position.X    := CenterSegX;
	DemoMacro[macroLine].Move6D.InPlane.Position.Y    := CenterSegY;
		
	macroLine := macroLine + 1;
	
	// Round edge twice total ACWise
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := SecondPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := SecondPosY;
	DemoMacro[macroLine].MovePlane.Path := PathACW;
	
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := FirstPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := FirstPosY;
	DemoMacro[macroLine].MovePlane.Path := PathACW;
	
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := SecondPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := SecondPosY;
	DemoMacro[macroLine].MovePlane.Path := PathACW;
	
	macroLine := macroLine + 1;
	
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := C_MOVE_IN_PLANE_010;
	DemoMacro[macroLine].MovePlane.Velocity := 2.0;
	DemoMacro[macroLine].MovePlane.Acceleration := 20.0;
	DemoMacro[macroLine].MovePlane.EndVelocity := 0.0;
	DemoMacro[macroLine].MovePlane.Position.X := FirstPosX;
	DemoMacro[macroLine].MovePlane.Position.Y := FirstPosY;
	DemoMacro[macroLine].MovePlane.Path := PathACW;
	
	macroLine := macroLine + 1;
		
	DemoMacro[macroLine].ShuttleID := 1;
	DemoMacro[macroLine].CommandType := 60;
	gMacro := DemoMacro;
	
END_ACTION
