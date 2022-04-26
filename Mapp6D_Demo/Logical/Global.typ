
TYPE
	Ctrl_typ : 	STRUCT 
		Start : BOOL;
		Stop : BOOL;
		Reset : BOOL;
		Pause : BOOL;
	END_STRUCT;
	SysSettings_typ : 	STRUCT 
		DemoType : BOOL; (*False = 2 segs true 4 segs*)
	END_STRUCT;
	Jog_typ : 	STRUCT 
		Right : BOOL;
		Left : BOOL;
		Neg : BOOL;
		Pos : BOOL;
		ShuttleID : USINT;
		Degrees : REAL;
		ShortDistance : REAL;
		Distance : REAL;
		RyN : BOOL;
		RyP : BOOL;
		RxP : BOOL;
		RxN : BOOL;
		RzN : BOOL;
		RzP : BOOL;
		Down : BOOL;
		Up : BOOL;
		Zero : BOOL;
	END_STRUCT;
	Main_typ : 	STRUCT  (*Main control variable datatype*)
		Cmd : MainCmd_typ; (*Main commands*)
		Par : MainPar_typ; (*Main parameter*)
		Status : MainStatus_typ; (*Main status*)
	END_STRUCT;
	MainCmd_typ : 	STRUCT  (*Main commands type*)
		Power : BOOL; (*Power on the system*)
		Start : BOOL; (*Start a plane movement for the selected shuttle*)
		Pause : BOOL; (*Stop all shuttles in the system*)
		Resume : BOOL; (*Stop all shuttles in the system*)
		Stop : BOOL; (*Stop all shuttles in the system*)
		StopAll : BOOL; (*Stop all shuttles in the system*)
		Jog : Jog_typ;
		Land : BOOL;
		ResetAll : BOOL; (*Reset any active error*)
		ErrorReset : BOOL; (*Reset any active error*)
		Move6D : BOOL;
		Group : BOOL;
		Arc : BOOL;
		Weigh : BOOL;
		Tare : BOOL;
	END_STRUCT;
	MainPar_typ : 	STRUCT  (*Main parameter type*)
		SelectedIndex : UINT; (*Selected index in the global array of shuttle references*)
		JogShort : McAcp6DShortAxParType; (*Relevant motion parameter*)
		Jog : McAcp6DInPlaneParType; (*Relevant motion parameter*)
		Move6D : McAcp6DMove6DParType; (*Relevant motion parameter*)
		InPlane : McAcp6DInPlaneParType; (*Relevant motion parameter*)
		Arc : McAcp6DArcParType;
		ShortAxis : McAcp6DShortAx6DParType;
		ShrtVel : REAL;
		Accel : REAL;
		EndVelocity : REAL;
		Velocity : REAL;
	END_STRUCT;
	Position_typ : 	STRUCT 
		X : REAL; (*mm*)
		Y : REAL; (*mm*)
		Z : REAL; (*mm*)
		Rx : REAL; (*Deg*)
		Ry : REAL; (*Deg*)
		Rz : REAL; (*Deg*)
		Payload : REAL; (*g*)
	END_STRUCT;
	MainStatus_typ : 	STRUCT  (*Main status type*)
		SelectedShuttleID : UINT; (*ID of the shuttle which was selected in the array*)
		AsmPlcOpenState : McAcp6dPLCopenStateEnum; (*PlcOpen state of the assembly*)
		ControllerState : McAcp6DControllerStateEnum; (*Current State of the ACOPOS 6D controller*)
		Disabled : BOOL; (*System is disabled*)
		Ready : BOOL; (*System is ready*)
		Homing : BOOL; (*System is homing*)
		Stopping : BOOL; (*System is stopping*)
		StartUp : BOOL; (*System is starting up*)
		ErrorStop : BOOL; (*System has an error*)
		ShuttlesPresent : USINT; (*Number of shuttles present*)
		ShtPresent : ARRAY[0..3]OF BOOL;
		Weight : ARRAY[0..3]OF REAL;
		Position : McAcp6DShPositionType;
	END_STRUCT;
	ShuttleStartup_typ : 	STRUCT 
		initYPos : REAL;
		initXPos : REAL;
		nextStationSelector : STRING[80] := '0';
	END_STRUCT;
	MotorSegments_typ : 	STRUCT 
		visible : BOOL := TRUE;
		ID : STRING[80];
	END_STRUCT;
	ShuttleReferenceArray_typ : 	STRUCT 
		Reference : Mc6DShuttleType;
		ID : {REDUND_UNREPLICABLE} UINT;
	END_STRUCT;
	ShuttleInfo_typ : 	STRUCT 
		ID : USINT;
		State : McAcp6DShStateEnum;
		Force : McAcp6DShForceType;
		Position : McAcp6DShPositionType;
		inUse : BOOL; (*DryStation Bool*)
	END_STRUCT;
	ShStatus_typ : 	STRUCT 
		ShuttleInfo : ARRAY[0..MAX_NUM_SHUTTLES]OF ShuttleInfo_typ;
		ShuttleInfoVis : ARRAY[0..MAX_NUM_SHUTTLES]OF ShuttleInfo_typ;
	END_STRUCT;
END_TYPE
