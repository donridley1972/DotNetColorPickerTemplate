

   MEMBER('DotNetColorPickerDemo.clw')                     ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('DOTNETCOLORPICKERDEMO001.INC'),ONCE        !Local module procedure declarations
MainOLE:2EventHandler  PROCEDURE(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent),LONG
MainOLE:2PropChange    PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
MainOLE:2PropEdit      PROCEDURE(SIGNED OLEControlFEQ,STRING EditedProperty),LONG
MainOLEEventHandler    PROCEDURE(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent),LONG
MainOLEPropChange      PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
MainOLEPropEdit        PROCEDURE(SIGNED OLEControlFEQ,STRING EditedProperty),LONG
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE 

Window               WINDOW('.NET Color Picker Demo'),AT(,,470,289),FONT('Segoe UI',9),AUTO,ICON(ICON:Clarion), |
  GRAY,SYSTEM,IMM
                       BUTTON('Close'),AT(431,268),USE(?Close)
                       OLE,AT(2,1,169,281),USE(?OLE:2)
                       END
                       OLE,AT(175,1,294,148),USE(?OLE)
                       END
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Close
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  SELF.Open(Window)                                        ! Open window
  Do DefineListboxStyle
  ?OLE:2{PROP:Create} = 'ClaColorPicker'
  OCXRegisterEventProc(?OLE:2,MainOLE:2EventHandler)
  OCXRegisterPropChange(?OLE:2,MainOLE:2PropChange)
  OCXRegisterPropEdit(?OLE:2,MainOLE:2PropEdit)
  ?OLE{PROP:Create} = 'ClaColorPickerSxS'
  OCXRegisterEventProc(?OLE,MainOLEEventHandler)
  OCXRegisterPropChange(?OLE,MainOLEPropChange)
  OCXRegisterPropEdit(?OLE,MainOLEPropEdit)
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue

!---------------------------------------------------
MainOLE:2EventHandler FUNCTION(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent)
  CODE
  RETURN(True)
!---------------------------------------------------
MainOLE:2PropChange PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
  CODE
!---------------------------------------------------
MainOLE:2PropEdit FUNCTION(SIGNED OLEControlFEQ,STRING EditedProperty)
  CODE
  RETURN(0)
!---------------------------------------------------
MainOLEEventHandler FUNCTION(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent)
! The order doesn't look right but it's correct :-)
ColorGrp        GROUP
B               BYTE
G               BYTE
R               BYTE
A               BYTE
                END
ColorLng        Long,Over(ColorGrp)
  CODE
    Case OLEEvent 
        Of 301
        If OcxGetParamCount(ref)
            ! OcxGetParam(ref, 1) = STRING  Alpha,Red,Green,Blue
            ! OcxGetParam(ref, 2) = LONG Color as Argb
        End
    End  
  RETURN(True)
!---------------------------------------------------
MainOLEPropChange PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
  CODE
!---------------------------------------------------
MainOLEPropEdit FUNCTION(SIGNED OLEControlFEQ,STRING EditedProperty)
  CODE
  RETURN(0)
