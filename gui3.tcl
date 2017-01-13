###################################################################
# This file is part of tk3, a utility program for the
# ICOM IC-R3 receiver.
# 
#    Copyright (C) 2001, 2002, Bob Parnass
#					AJ9S
# 
# tk3 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2 of the License,
# or (at your option) any later version.
# 
# tk3 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with tk3; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307  USA
###################################################################


proc MakeGui { } \
{
	global Cht
	global Chvector
	global GlobalParam
	global ReadRadioFlag
	global TemplateSavedFlag

	set GlobalParam(TemplateFilename) untitled.tr3

	set TemplateSavedFlag no
	set ReadRadioFlag no

	# Set custom font and colors.

	SetAppearance

	set msg [OpenDevice]
	
	if { $msg != ""} \
		{
		tk_dialog .opnerror "tk3 error" \
			$msg error 0 OK
		exit
		}
	
	
	###############################################################
	# Menu bar along the top edge.
	###############################################################
	set fr_menubar [MakeMenuBar .mb]
	set mf [frame .mainframe]
	set fr_line1 [frame $mf.line1]
	set fr_lim [frame $mf.lim]
	frame $mf.chtable
	set Cht $mf.chtable
	
	set fr_misc [MakeMiscFrame $fr_line1.omsg]
	set fr_display [MakeDisplayFrame $fr_line1.dis]
	set fr_title [MakeTitleFrame $fr_line1.title]
	pack $fr_title -side right -fill y
	pack $fr_misc $fr_display -side left -fill y


	###############################################################
	# VFO controls window
	###############################################################
	toplevel .vfo
	set fr_vfo .vfo.ctls
	frame $fr_vfo -relief groove

	set fr_search [MakeSearchFrame $fr_vfo.search]
	set fr_bandstack [MakeBandStackFrame $fr_vfo.bandstack]

	pack $fr_search $fr_bandstack \
		-side left \
		-fill both -expand true

	pack $fr_vfo
	
	# Prevent user from closing the VFO controls window unless
	# he elects to exit the entire program.
	wm protocol .vfo WM_DELETE_WINDOW {ExitApplication}
	wm title .vfo "tk3 VFO Settings"
	


	###############################################################
	# TV controls window
	###############################################################
	toplevel .tv
	set fr_tv .tv.ctls
	frame $fr_tv -relief groove

	set fr_amtv [MakeAMTVFrame $fr_tv.amtv]
	set fr_amtvmem [MakeAMTVMemFrame $fr_tv.amtvmem]
	set fr_fmtvmem [MakeFMTVMemFrame $fr_tv.fmtvmem]

	pack $fr_amtv $fr_amtvmem $fr_fmtvmem \
		-side left \
		-fill both -expand true

	pack $fr_tv
	
	# Prevent user from closing the VFO controls window unless
	# he elects to exit the entire program.
	wm protocol .tv WM_DELETE_WINDOW {ExitApplication}
	wm title .tv "Television Settings "
	


	###############################################################
	# Secondary controls window
	###############################################################
	toplevel .controls
	set ctls .controls.ctls
	frame $ctls -relief groove

	set fr_com [MakeCommFrame $ctls.com]

	pack $fr_com -side left -fill both -expand true
	
	toplevel .mc
	set Cht .mc
	# set fr_bankscan [MakeBankScanFrame $Cht.bankscan]
	set fr_links [MakeLinkedScanFrame $Cht.links]
	
	# Prevent user from closing the channel list window unless
	# he elects to exit the entire program.
	wm protocol $Cht WM_DELETE_WINDOW {ExitApplication}
	wm title $Cht "tk3 Memory Channels"
	wm iconify $Cht
	
	
	
	set Chvector ""
	
	pack $fr_menubar -side top -fill x -pady 3 -padx 3
	pack $fr_line1 -side top -fill x -pady 3 -padx 3
	pack $fr_lim -side top -fill x -pady 3 -padx 3
	
	
	pack $ctls -side top -fill both -expand true -padx 3 -pady 3
	pack .mainframe -side top -fill both -expand true
	
	update idletasks
	
	###############################################################
	#  Ask the window manager to catch the delete window
	#  event.
	###############################################################
	wm protocol . WM_DELETE_WINDOW {ExitApplication}
	
	# Prevent user from shrinking or expanding main window.
	wm minsize . [winfo width .] [winfo height .]
	# wm maxsize . [winfo width .] [winfo height .]
	
	wm protocol .controls WM_DELETE_WINDOW {ExitApplication}
	wm title .controls "tk3 Secondary Controls"
	
	
	# Prevent user from overshrinking or expanding controls window.
	wm minsize .controls [winfo width .controls] [winfo height .controls]
	wm maxsize .controls [winfo width .controls] [winfo height .controls]
	
	
	# Prevent user from shrinking or expanding window.
	wm minsize .vfo [winfo width .vfo] [winfo height .vfo]
	# wm maxsize .vfo [winfo width .vfo] [winfo height .vfo]

	return
}


###################################################################
# Alter color and font appearance based on user preferences.
###################################################################
proc SetAppearance { } \
{
	global GlobalParam

	if {$GlobalParam(Font) != "" } \
		{
		# Designate a custom font for most widgets.
		option add *font $GlobalParam(Font)
		}

	if {$GlobalParam(BackGroundColor) != "" } \
		{
		# Designate a custom background color for most widgets.
		option add *background $GlobalParam(BackGroundColor)
		}

	if {$GlobalParam(ForeGroundColor) != "" } \
		{
		# Designate a custom foreground color for most widgets.
		option add *foreground $GlobalParam(ForeGroundColor)
		}

	if {$GlobalParam(TroughColor) != "" } \
		{
		# Designate a custom slider trough color
		# for most scale widgets.
		option add *troughColor $GlobalParam(TroughColor)
		}

	return
}



##########################################################
# Check if the configuration file exists.
# If it exits, return 1.
#
# Otherwise, prompt the user to select the
# serial port.
##########################################################

proc FirstTimeCheck { Rcfile } \
{
	global AboutMsg
	global GlobalParam
	global Libdir
	global tcl_platform

	if { [file readable $Rcfile] == 1 } \
		{
		return 0
		}

	tk_dialog .about "About tk3" \
		$AboutMsg info 0 OK

	# No readable config file found.
	# Treat this as the first time the user has run the program.

	# Create a new window with radio buttions and
	# an entry field so user can designate the proper
	# serial port.

	set msg "Please identify the serial port to which\n"
	set msg [append msg "your IC-R2 receiver is connected."]

	toplevel .serialport
	set sp .serialport

	label $sp.intro -text $msg

	frame $sp.rbframe
	set fr $sp.rbframe

	if { $tcl_platform(platform) == "windows" } \
		{
		# For Windows.
		radiobutton $fr.com1 -text COM1: -variable port \
			-value {COM1:}
		radiobutton $fr.com2 -text COM2: -variable port \
			-value {COM2:} 
		radiobutton $fr.com3 -text COM3: -variable port \
			-value {COM3:} 
		radiobutton $fr.com4 -text COM4: -variable port \
			-value {COM4:} 

		pack $fr.com1 $fr.com2 $fr.com3 $fr.com4 \
			-side top -padx 3 -pady 3 -anchor w

		} \
	else \
		{
		# For unix, mac, etc..
		radiobutton $fr.s0 -text /dev/ttyS0 -variable port \
			-value {/dev/ttyS0} 
		radiobutton $fr.s1 -text /dev/ttyS1 -variable port \
			-value {/dev/ttyS1} 
		radiobutton $fr.s2 -text /dev/ttyS2 -variable port \
			-value {/dev/ttyS2} 
		radiobutton $fr.s3 -text /dev/ttyS3 -variable port \
			-value {/dev/ttyS3} 
		radiobutton $fr.s4 -text /dev/ttyS4 -variable port \
			-value {/dev/ttyS4} 
		radiobutton $fr.s5 -text /dev/ttyS5 -variable port \
			-value {/dev/ttyS5} 

		pack \
			$fr.s0 $fr.s1 $fr.s2 \
			$fr.s3 $fr.s4 $fr.s5 \
			-side top -padx 3 -pady 3 -anchor w

		}

	radiobutton $fr.other -text "other (enter below)" \
		-variable port \
		-value other

	entry $fr.ent -width 30 -textvariable otherport

	pack $fr.other $fr.ent \
		-side top -padx 3 -pady 3 -anchor w

	button $sp.ok -text "OK" \
		-command \
			{ \
			global GlobalParam

			if {$port == "other"} \
				{
				set GlobalParam(Device) $otherport
				} \
			else \
				{
				set GlobalParam(Device) $port
				}
			# puts stderr "entered $GlobalParam(Device)"
			}

	button $sp.exit -text "Exit" \
		-command { exit }

	pack $sp.intro -side top -padx 3 -pady 3
	pack $fr -side top -padx 3 -pady 3
	pack $sp.ok $sp.exit -side left -padx 3 -pady 3 -expand true



	bind $fr.ent <Key-Return> \
		{
		global GlobalParam
		set GlobalParam(Device) $otherport
		}

	wm title $sp "Select serial port"
	wm protocol $sp WM_DELETE_WINDOW {exit}

	set errorflag true

	while { $errorflag == "true" } \
		{
		tkwait variable GlobalParam(Device)

		if { $tcl_platform(platform) != "unix" } \
			{
			set errorflag false
			break
			}

		# The following tests do not work properly
		# in Windows. That is why we won't perform
		# the serial port tests when running Windows version.

		if { ([file readable $GlobalParam(Device)] != 1) \
			|| ([file writable $GlobalParam(Device)] != 1)}\
			{
			# Device must be readable, writable

			bell
			tk_dialog .badport "Serial port problem" \
				"Serial port problem" error 0 OK
			} \
		else \
			{
			set errorflag false
			}
		}

	destroy $sp
	return 1
}

##########################################################
# ExitApplication
#
# This procedure can do any cleanup necessary before
# exiting the program.
#
# Disable computer control of the radio, then quit.
##########################################################
proc ExitApplication { } \
{
	global Lid
	global Lfilename
	global TemplateSavedFlag
	global ReadRadioFlag

	if { ($ReadRadioFlag == "yes") \
		&&  ($TemplateSavedFlag == "no") } \
		{
		set msg "You did not save the template data"
		append msg " in a file."

		set result [tk_dialog .sav "Warning" \
			$msg \
			warning 0 Cancel Exit ]

		if {$result == 0} \
			{
			return
			}
		}

	SaveSetup
	DisableCControl

	if { [info exists Lfilename] } \
		{
		if { $Lfilename != "" } \
			{
			# Close log file.
			close $Lid
			}
		}
	exit
}


##########################################################
# NoExitApplication
#
# This procedure prevents the user from
# killing the window.
##########################################################
proc NoExitApplication { } \
{

	set response [tk_dialog .quitit "Exit?" \
		"Do not close this window." \
		warning 0 OK ]

	return
}
##########################################################
#
# Scroll_Set manages optional scrollbars.
#
# From "Practical Programming in Tcl and Tk,"
# second edition, by Brent B. Welch.
# Example 27-2
#
##########################################################

proc Scroll_Set {scrollbar geoCmd offset size} {
	if {$offset != 0.0 || $size != 1.0} {
		eval $geoCmd;# Make sure it is visible
		$scrollbar set $offset $size
	} else {
		set manager [lindex $geoCmd 0]
		$manager forget $scrollbar								;# hide it
	}
}


##########################################################
#
# Listbox with optional scrollbars.
#
#
# Inputs: basename of configuration file
#
# From "Practical Programming in Tcl and Tk,"
# second edition, by Brent B. Welch.
# Example 27-3
#
##########################################################

proc Scrolled_Listbox { f args } {
	frame $f
	listbox $f.list \
		-font {courier 12} \
		-xscrollcommand [list Scroll_Set $f.xscroll \
			[list grid $f.xscroll -row 1 -column 0 -sticky we]] \
		-yscrollcommand [list Scroll_Set $f.yscroll \
			[list grid $f.yscroll -row 0 -column 1 -sticky ns]]
	eval {$f.list configure} $args
	scrollbar $f.xscroll -orient horizontal \
		-command [list $f.list xview]
	scrollbar $f.yscroll -orient vertical \
		-command [list $f.list yview]
	grid $f.list $f.yscroll -sticky news
	grid $f.xscroll -sticky news

	grid rowconfigure $f 0 -weight 1
	grid columnconfigure $f 0 -weight 1

	return $f.list
}


##########################################################
#
# Create a scrollable frame.
#
#
# From "Effective Tcl/Tk Programming,"
# by Mark Harrison and Michael McLennan.
# Page 121.
#
##########################################################

proc ScrollformCreate { win } \
{

	frame $win -class Scrollform -relief groove -borderwidth 3
	scrollbar $win.sbar -command "$win.vport yview"
	pack $win.sbar -side right -fill y

	canvas $win.vport -yscrollcommand "$win.sbar set"
	pack $win.vport -side left -fill both -expand true

	frame $win.vport.form
	$win.vport create window 0 0 -anchor nw \
		-window $win.vport.form

	bind $win.vport.form <Configure> "ScrollFormResize $win"
	return $win
}

proc ScrollFormResize { win } \
{
	set bbox [ $win.vport bbox all ]
	set wid [ winfo width $win.vport.form ]
	$win.vport configure -width $wid \
		-scrollregion $bbox -yscrollincrement 0.1i
}

proc ScrollFormInterior { win } \
{
	return "$win.vport.form"
}


##########################################################
# Contruct the top row of pulldown menus
##########################################################
proc MakeMenuBar { f } \
{
	global AboutMsg
	global Device
	global FileTypes
	global GlobalParam
	global Pgm
	global Version

	# File pull down menu
	frame $f -relief groove -borderwidth 3

	menubutton $f.file -text "File" -menu $f.file.m \
		-underline 0
	menubutton $f.view -text "View" -menu $f.view.m \
		-underline 0
	menubutton $f.data -text "Data" -menu $f.data.m \
		-underline 0
	menubutton $f.radio -text "Radio" -menu $f.radio.m \
		-underline 0
	menubutton $f.help -text "Help" -menu $f.help.m \
		-underline 0
	
	
	menu $f.view.m
	AddView $f.view.m

	menu $f.data.m
	AddData $f.data.m
	
	menu $f.help.m
	$f.help.m add command -label "Tcl info" \
		-underline 0 \
		-command { \
			tk_dialog .about "Tcl info" \
				[HelpTclInfo] info 0 OK
			}

	$f.help.m add command -label "License" \
		-underline 0 \
		-command { \
			set helpfile [format "%s/COPYING" $Libdir ]
			set win [textdisplay_create "Notice"]
			textdisplay_file $win $helpfile
			}
	
	$f.help.m add command -label "About tk3" \
		-underline 0 \
		-command { \
			tk_dialog .about "About tk3" \
				$AboutMsg info 0 OK
			}
	
	menu $f.file.m -tearoff no

	$f.file.m add command -label "Open ..." \
		-underline 0 \
		-command {OpenTemplate .mainframe}
	
	$f.file.m add command -label "Save" \
		-underline 0 \
		-command {SaveTemplate .mainframe 0}

	$f.file.m add command -label "Save As ..." \
		-underline 0 \
		-command {SaveTemplate .mainframe 1}

	$f.file.m add separator

	set msg "Import memory channels from CSV file ..."
	$f.file.m add command -label $msg \
		-underline 0 \
		-command {\
			global Cht
			ImportCSV $Cht
			}

#	set msg "Import memory channels from Percon ICF file ..."
#	$f.file.m add command -label $msg \
#		-underline 0 \
#		-command {\
#			global Cht
#			ImportICF $Cht
#			}

	set msg "Export memory channels to CSV file ..."
	$f.file.m add command -label $msg \
		-underline 0 \
		-command {ExportChannels .mainframe}

	$f.file.m add separator

	$f.file.m add command -label "Exit" \
		-underline 1 \
		-command { ExitApplication}
	
	menu $f.radio.m -tearoff no
	AddRadio $f.radio.m


	pack $f.file $f.view $f.data $f.radio -side left -padx 10
	pack $f.help -side right
	
	update
	return $f
}



proc MakeScrollPane {w x y} {
   frame $w -class ScrollPane -width $x -height $y
   canvas $w.c -xscrollcommand [list $w.x set] -yscrollcommand [list $w.y set]
   scrollbar $w.x -orient horizontal -command [list $w.c xview]
   scrollbar $w.y -orient vertical   -command [list $w.c yview]
   set f [frame $w.c.content -borderwidth 0 -highlightthickness 0]
   $w.c create window 0 0 -anchor nw -window $f
   grid $w.c $w.y -sticky nsew
   grid $w.x      -sticky nsew
   grid rowconfigure    $w 0 -weight 1
   grid columnconfigure $w 0 -weight 1
   # This binding makes the scroll-region of the canvas behave correctly as
   # you place more things in the content frame.
   bind $f <Configure> [list Scrollpane_cfg $w %w %h]
   $w.c configure -borderwidth 0 -highlightthickness 0
   return $f
}
proc Scrollpane_cfg {w wide high} {
   set newSR [list 0 0 $wide $high]
	return
   if {![string equals [$w cget -scrollregion] $newSR]} {
      $w configure -scrollregion $newSR
   }
}



##########################################################
# Add widgets to the view menu
##########################################################
proc AddView { m } \
{
	global GlobalParam


	# Change font.

	if {$GlobalParam(Font) == ""} \
		{
		set msg "Change Font"
		} \
	else \
		{
		set msg [format "Change Font (%s)" $GlobalParam(Font)]
		}

	$m add command -label $msg -command \
		{
		set ft [font_select]
		if {$ft != ""} \
			{
			set GlobalParam(Font) $ft

			set msg "The change will take effect next "
			set msg [append msg "time you start tk3."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Restore Original Font" -command \
		{
		set GlobalParam(Font) ""
		set msg "The change will take effect next "
		set msg [append msg "time you start tk3."]

		tk_dialog .wcf "Change Appearance" $msg info 0 OK
		}

	$m add separator

	$m add command -label "Change Panel Color" -command \
		{
		set col [tk_chooseColor -initialcolor #d9d9d9]
		if {$col != ""} \
			{
			set GlobalParam(BackGroundColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk3."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Change Lettering Color" -command \
		{
		set col [tk_chooseColor -initialcolor black]
		if {$col != ""} \
			{
			set GlobalParam(ForeGroundColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk3."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Change Slider Trough Color" -command \
		{
		set col [tk_chooseColor -initialcolor #c3c3c3]
		if {$col != ""} \
			{
			set GlobalParam(TroughColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk3."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add separator


	# Helpful tips balloons


	$m add  checkbutton \
		-label "Balloon Help Windows" \
                -variable GlobalParam(BalloonHelpWindows) \
                -onvalue on  -offvalue off 


	return
}


##########################################################
# Add widgets to the Data menu
##########################################################
proc AddData { m } \
{
	global GlobalParam


	set hint ""
	append hint "The Encode Image operation "
	append hint "is designed for use when "
	append hint "testing tk3."
	balloonhelp_for $m $hint

	$m add command -label "Validate data" \
		-command \
			{
			if {[ValidateData] == 0} \
				{
				tk_dialog .info "Valiate data" \
				"The data is ok." info 0 OK
				}
			}

	$m add command -label "Check for duplicate frequencies" \
		-command { CkDuplicate }

	$m add command -label "Encode Image" \
		-command { \
			if {[ValidateData] == 0} \
				{
				MakeWait
				EncodeImage
				KillWait
				}
			}

	$m add separator
	

	$m add command -label "Sort Channels ..." \
		-command \
			{
			MakeSortFrame
			}


	$m add command -label "Clear All Channels" \
		-command { ClearAllChannels }

	return
}



##########################################################
# Add choices to the Radio menu
##########################################################
proc AddRadio { m } \
{
	global GlobalParam
	global Libdir


	$m add command -label "Read from radio ..." \
		-command { \
			Radio2Template .mainframe
			update
			}
	
	$m add command -label "Write to radio ..." \
		-command { \
			Image2Radio .mainframe
			update
			}
	
	
	$m add separator
	$m add command -label "Interrogate radio for model info ..." \
		-command { \
			global GlobalParam

			set s [GetModelInfo]
			binary scan $s "H*" x
			set GlobalParam(RadioVersion) $x
			update
			}
	

	$m add separator

	$m add radiobutton -label "Model with 10 kHz BCB steps" \
		-variable GlobalParam(WhichModel) \
		-value 10

	$m add radiobutton -label "Model with 9 kHz BCB steps" \
		-variable GlobalParam(WhichModel) \
		-value 9


	$m add separator


	$m add  checkbutton \
		-label "Debug" \
                -variable GlobalParam(Debug) \
                -onvalue "1" \
                -offvalue "0"

	return $m
}


##########################################################
#
# Create a progress gauge widget.
#
#
# From "Effective Tcl/Tk Programming,"
# by Mark Harrison and Michael McLennan.
# Page 125.
#
##########################################################
proc gauge_create {win {color ""}} \
{
	frame $win -class Gauge

	# set len [option get $win length Length]
	set len 300

	canvas $win.display -borderwidth 0 -background white \
		-highlightthickness 0 -width $len -height 20
	pack $win.display -expand yes -padx 10
	if {$color == ""} \
		{
		set color [option get $win color Color]
		}


	$win.display create rectangle 0 0 0 20 \
		-outline "" -fill $color -tags bar
	$win.display create text [expr {0.5 * $len}] 10 \
		-anchor c -text "0%" -tags value
	return $win
}

proc gauge_value {win val} \
{
	if {$val < 0 || $val > 100} \
		{
		error "bad value \"$val\": should be 0-100"
		}
	set msg [format "%.0f%%" $val]
	$win.display itemconfigure value -text $msg

	set w [expr {0.01 * $val * [winfo width $win.display]}]
	set h [winfo height $win.display]
	$win.display coords bar 0 0 $w $h

	update
}

proc MakeWaitWindow {f cnflag color} \
{
	global CancelXfer

	set CancelXfer 0

	frame $f
	button $f.cancel -text Cancel -command {\
		global CancelXfer; set CancelXfer 1; puts "Canceled"}

	gauge_create $f.g PaleGreen
	option add *Gauge.borderWidth 2 widgetDefault
	option add *Gauge.relief sunken widgetDefault
	option add *Gauge.length 300 widgetDefault
	option add *Gauge.color gray widgetDefault

	pack $f.g -expand yes -fill both \
		-padx 10 -pady 10

	if {$cnflag} \
		{
		pack $f.cancel -side top -padx 3 -pady 3
		}

	

	pack $f
	return $f.g
}

##########################################################
#
# Copy data from radio to template image (a lengthy string).
#
##########################################################
proc Radio2Template { f }\
{
	global Cht
	global FileTypes
	global GlobalParam
	global Home
	global MemFreq
	global MemMode
	global ReadRadioFlag


	set msg ""
	append msg "Instructions (read all steps):\n"
	append msg "1) Ensure the radio is connected to your computer"
	append msg " and powered on.\n"


	set result [tk_dialog .info "Read from VR-120" \
		$msg \
		info 0 OK Cancel ]

	if {$result} \
		{
		return
		}

	# Read memory image from radio.
	if {[ReadImage]} \
		{
		set ReadRadioFlag no

		set msg "Error while reading from radio."
		tk_dialog .error $msg $msg error 0 OK
		return
		}
		
	set GlobalParam(Populated) 1
	DecodeImage
	ShowChannels $Cht

	set msg "Transfer Complete.\n"
	append msg "Look at the radio display "
	append msg "to view a status message."

	tk_dialog .belch "Read IC-R2" \
		$msg info 0 OK

	set ReadRadioFlag yes

	return
}

##########################################################
# Write memory image to a template file.
##########################################################
proc SaveTemplate { f asflag } \
{
	global GlobalParam
	global TemplateSavedFlag
	global ReadRadioFlag
	global Mimage
	global Nmessages

	if {[string length $Mimage] <= 0} \
		{
		set msg "You must first read template data from"
		append msg " the radio before saving it in a"
		append msg " template file."
		append msg " (Use the Radio menu for reading"
		append msg " from the radio.)"

		tk_dialog .error "No template data" \
			$msg error 0 OK
		return
		}

	set mitypes \
		{
		{"IC-R3 template files"           {.tr3}     }
		}

	set filename $GlobalParam(TemplateFilename)

	if { ($GlobalParam(TemplateFilename) == "") \
		|| ($asflag) } \
		{
		set filename \
			[Mytk_getSaveFile $f \
			$GlobalParam(MemoryFileDir) \
			.tr3 \
			"Save IC-R2 data to template file" \
			$mitypes]
		}



	if { $filename != "" }\
		{

		if {[ValidateData]} {return}
		MakeWait
		EncodeImage

		# Truncate memory image to the proper length.
		# We want to ignore the several FF records
		# which may have been appended
		# at the end of the image.

		set n [expr {($Nmessages * 32) - 1}]
		set Mimage [string range $Mimage 0 $n]

		KillWait

		set GlobalParam(TemplateFilename) $filename
		SetWinTitle

		set GlobalParam(MemoryFileDir) \
			[ Dirname $GlobalParam(TemplateFilename) ]

		set fid [open $GlobalParam(TemplateFilename) "w"]
		fconfigure $fid -translation binary
		puts -nonewline $fid $Mimage
		close $fid
		set TemplateSavedFlag yes
		}

	return
}


##########################################################
# Read memory image from a template file.
##########################################################
proc OpenTemplate { f } \
{
	global BytesPerMessage
	global Cht
	global GlobalParam
	global Mimage
	global Nmessages

	set mitypes \
		{
		{"IC-R3 template files"           {.tr3}     }
		{"Butel ARC3 files"           {.ic3 .IC3}      }
		{"Percon web files"           {.ICF .icf}      }
		}

	set GlobalParam(TemplateFilename) [Mytk_getOpenFile \
		$f $GlobalParam(MemoryFileDir) \
		"Open template file" $mitypes]


	if { $GlobalParam(TemplateFilename) != "" }\
		{
		set GlobalParam(MemoryFileDir) \
			[ Dirname $GlobalParam(TemplateFilename) ]


		if [ catch { open $GlobalParam(TemplateFilename) "r"} fid] \
			{
			# error
			tk_dialog .error "tk3" \
				"Cannot open file $file" \
				error 0 OK
			set GlobalParam(TemplateFilename) ""
			return
			} 


		if { [regexp -nocase {\.r3$} \
			$GlobalParam(TemplateFilename)] } \
			{
			# User wants to read a Goran Valaski
			# IC-R2 Programming Utility .R2 file.
			fconfigure $fid -translation binary
			set GlobalParam(TemplateFilename) ""
			set code [ReadR2File $fid]
			} \
		elseif { [regexp -nocase {\.ic3$} \
			$GlobalParam(TemplateFilename)] } \
			{
			# User wants to read a Butel ARC3 .IC3 file.
			fconfigure $fid -translation binary
			set GlobalParam(TemplateFilename) ""
			set code [ReadIC2File $fid]
			} \
		elseif { [regexp -nocase {\.icf$} \
			$GlobalParam(TemplateFilename)] } \
			{
			# User wants to read a Percon .ICF file.
			set GlobalParam(TemplateFilename) ""
			set code [ReadICFFile $fid]
			} \
		else \
			{
			# User specified a .tr3 file.
			fconfigure $fid -translation binary
			set nbytes [expr {$Nmessages * $BytesPerMessage / 2}]
			set Mimage [read $fid $nbytes]
			set code 0
			}

		close $fid
		SetWinTitle
		if {$code == 0} \
			{
			set GlobalParam(Populated) 1
			DecodeImage
			ShowChannels $Cht
			}
		}

	return
}


##########################################################
# Import data from a .ICF (ICOM Clone Format) file
##########################################################
proc ImportICF { f }\
{
	global Cht
	global GlobalParam
	global Icf2Hex
	global Mimage


	if {[info exists Mimage] == 0} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before importing channels.\n"

		tk_dialog .importinfo "tk3" \
			$msg info 0 OK
		return
		}


	set filetypes \
		{
		{"ICOM clone format files"     {.ICF .icf}     }
		}


	set filename [Mytk_getOpenFile $f \
		$GlobalParam(MemoryFileDir) \
		"Import data from ICF file" $filetypes]

	if {$filename == ""} then {return ""}

	set GlobalParam(MemoryFileDir) [ Dirname $filename ]

	if [ catch { open $filename "r"} fid] \
		{
		# error
		tk_dialog .error "tk3" \
			"Cannot open file $file" \
			error 0 OK

		return
		} 

	# Read entire .ICF file at one time.
	set allicf [read $fid]

	set line ""
	set i 0

	set Mimage ""
	# For each line in the .csv file.
	foreach line [split $allicf "\n" ] \
		{
		update

		incr i

		# Skip the first 2 lines in the file.


		if { $i > 2 } then\
			{
			set nchar [string len $line]

			# for each char in the line

#			puts -nonewline stderr "$i) "
			# set c [string range $line $j $j]
			set buf [string range $line 6 $nchar]
#			puts -nonewline stderr "$newc"

			# Translate to binary
			set buf [string toupper $buf]
			set pbuf [PackString $buf]
			append Mimage $pbuf
			}
#		puts -nonewline stderr "\n"
		}
		
	set GlobalParam(TemplateFilename) ""
	SetWinTitle
	DecodeImage
	ShowChannels $Cht
	close $fid

	return
}


##########################################################
# Read data from a .ICF (ICOM Clone Format) file
##########################################################
proc ReadICFFile { fid }\
{
	global Cht
	global GlobalParam
	global Icf2Hex
	global Mimage


	if {$fid == ""} then {return ""}


	# Read entire .ICF file at one time.
	set allicf [read $fid]

	set line ""
	set i 0

	set Mimage ""
	# For each line in the .csv file.
	foreach line [split $allicf "\n" ] \
		{
		update

		incr i

		# Skip the first 2 lines in the file.


		if { $i > 2 } then\
			{
			set nchar [string len $line]

			# for each char in the line

#			puts -nonewline stderr "$i) "
			# set c [string range $line $j $j]
			set buf [string range $line 6 $nchar]
#			puts -nonewline stderr "$newc"

			# Translate to binary
			set buf [string toupper $buf]
			set pbuf [PackString $buf]
			append Mimage $pbuf
			}
#		puts -nonewline stderr "\n"
		}
		
	set GlobalParam(TemplateFilename) ""

	return 0
}


##########################################################
# Import memory channels from a .csv file
##########################################################
proc ImportCSV { f }\
{
	global GlobalParam
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global Mimage


	if {[info exists Mimage] == 0} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before importing channels.\n"

		tk_dialog .importinfo "tk3" \
			$msg info 0 OK
		return
		}


	set filetypes \
		{
		{"IC-R3 memory channel files"     {.csv .txt}     }
		}


	set filename [Mytk_getOpenFile $f \
		$GlobalParam(MemoryFileDir) \
		"Import channels" $filetypes]

	if {$filename == ""} then {return ""}

	set GlobalParam(MemoryFileDir) [ Dirname $filename ]

	if [ catch { open $filename "r"} fid] \
		{
		# error
		tk_dialog .error "tk3" \
			"Cannot open file $file" \
			error 0 OK

		return
		} 

	# Read entire .csv file at one time.
	set allchannels [read $fid]
#	for {set ch 0} {$ch < 400} {incr ch} \
#		{
#		set MemFreq($ch) 0
#		set MemMode($ch) NFM
#		set MemOffset($ch) 0.0
#		set MemDuplex($ch) ""
#		set MemStep($ch) 5
#		set MemSkip($ch) ""
#		set MemToneFlag($ch) ""
#		set MemToneCode($ch) 0.0
#		incr ch
#		}

	set line ""
	set i 0

	# For each line in the .csv file.
	foreach line [split $allchannels "\n" ] \
		{
		update

		incr i
		if { $i > 1 } then\
			{
			# Delete double quote characters.
			regsub -all "\"" $line "" bline
			set line $bline

			if {$line == ""} then {continue}
			
			set msg [ParseCsvLine $line]
			if {$msg != ""} \
				{
				set response [ErrorInFile \
					$msg $line $filename]
				if {$response == 0} then {continue} \
				else {ExitApplication}
				}
			}
		}
		
	ShowChannels $f
	close $fid

	return
}

proc ParseCsvLine {line} \
{
	global Ctcss
	global GlobalParam
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global Mode
	global Skip
	global Step

	if {$line == ""} {return error}
	set mlist [split $line ","]

	set n [llength $mlist] 
	set m [ expr {10 - $n} ]

	# Add empty fields to the end of the line
	# if there are too few fields.

	for {set i 0} {$i < $m} {incr i} \
		{
		append line ","
		}

	set mlist [split $line ","]

#	if { [llength $mlist] < 4 } \
#		{
#		return "Missing one or more fields."
#		}

	set bn [lindex $mlist 0]
	set i [lindex $mlist 1]
	set ch [expr {($bn * 50) + $i}]
	set freq [lindex $mlist 2]
	set mode [lindex $mlist 3]
	set step [lindex $mlist 4]
	set offset [lindex $mlist 5]
	set duplex [lindex $mlist 6]
	set toneflag [lindex $mlist 7]
	set ctcss [lindex $mlist 8]
	set skip [lindex $mlist 9]
	set label [lindex $mlist 10]



	if { ($bn < 0) || ($bn > 7) } \
		{
		return "Invalid bank $bn."
		}

	if { ($i < 0) || ($i > 49) } \
		{
		return "Invalid channel $i."
		}

	
	if { ($freq < $GlobalParam(LowestFreq)) \
		|| ($freq > $GlobalParam(HighestFreq)) } \
		{
		return "Invalid frequency $freq."
		}

	set nmode [string toupper $mode]
	if {$nmode == ""} \
		{
		set nmode NFM
		}
	if { [info exists Mode($nmode)] == 0 } \
		{
		return "Invalid mode $mode."
		}

	set nstep $step
	if {$nstep == ""} \
		{
		set nstep 5
		}
	if {[info exists Step($nstep)] == 0 } \
		{
		return "Invalid step $step."
		}

	if {$offset == ""} \
		{
		set noffset 0.000
		} \
	else \
		{
		set noffset [format "%.3f" $offset]
		}

	if { ($noffset < 0.0) || ($noffset > 159.995) } \
		{
		return "Invalid offset $offset."
		}

	if {($duplex != "") && ($duplex != "+") && ($duplex != "-")} \
		{
		return "Invalid duplex flag $duplex."
		}

	set ntoneflag 0
	if {$toneflag != ""} \
		{
		set ntoneflag 1
		}

	set nctcss $ctcss

	if {$ctcss == ""} \
		{
		set nctcss 0.0
		} \
	elseif { [regexp {\.} $ctcss] == 0} \
		{
		# CTCSS code is probably an integer
		# so append .0 to it.
		set nctcss [format "%s.0" $ctcss]
		}

	if { [info exists Ctcss($nctcss)] == 0 } \
		{
		return "Invalid CTCSS code $ctcss."
		}

	# Must be null, a space, skip, or pskip to be valid.
	if {($skip == "") && ($skip == " ")} \
		{
		if { [info exists Skip($nskip)] == 0 } \
			{
			return "Invalid skip value $skip."
			}
		}

	set MemFreq($ch) $freq
	set MemMode($ch) $nmode
	set MemStep($ch) $nstep
	set MemOffset($ch) $noffset
	set MemDuplex($ch) $duplex
	set MemToneFlag($ch) $ntoneflag
	set MemToneCode($ch) $nctcss
	set MemSkip($ch) $skip

	# Check for non-ascii chars.
	set rc [regexp {^[ A-Za-z0-9\-\+\*]*$} $label]
	if {$rc == 0} then {set label ""}

	set MemLabel($ch) [string range $label 0 5]

	return ""
}


##########################################################
# Read memory image from an open Goran Valaski .r2 file
#
# Inputs:
#		fid	-file descriptor
##########################################################
proc ReadR2File { fid }\
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Pgm


	# Read the first part of .r2 file one record at a time.

	set image ""

	for {set i 0} {$i < $Nmessages} {incr i} \
		{
		set line [read $fid 46]
		set len [string length $line]
		if {$len != 46} \
			{
			set msg "$Pgm: "
			append msg "Corruption in .r2 file"
			puts stderr $msg

			tk_dialog .error "tk3" \
				"Corrupted .r2 file" \
				error 0 OK

			return -1
			}

		set cc [string index $line 4]

		if { [string compare -nocase -length 1 $cc \xE4] } \
			{
			set msg "$Pgm: "
			append msg "Corruption in ARC .r2 file"
			puts stderr $msg

			tk_dialog .error "tk3" \
				"Corrupted ARC2 .r2 file" \
				error 0 OK

			return -1
			}
	

		set pline [PackString [string range $line 5 44]]
		set plen [string length $pline]

		set dbuf [string range $pline 0 18] 
		set cksum [string range $pline 19 19] 
		set ccksum [CalcCheckSum $dbuf]
	
		binary scan $cksum "H*" icksum
		scan $icksum "%x" cksum
	
#		puts stderr [format "CHECKSUM file: %s, calculated: %s\n" \
#				$cksum $ccksum]
	
		if {$cksum != $ccksum} \
			{
			set msg [format \
				"%s: error, checksum mismatch, radio: %s, calculated: %s\n" \
				$Pgm $cksum $ccksum]
			Tattle $msg
			tk_dialog .error "Checksum error while reading file" \
				$msg error 0 OK
			return -1
			}


		# Strip off memory address and count bytes.
		set buf [string range $dbuf 3 end]
		# set buf [string range $pline 5 44]

#		set abuf "$i) "
#		append abuf [DumpBinary $buf]
#		puts stderr $abuf

		append image $buf
		}

	set Mimage $image
	return 0
}


##########################################################
# Read memory image from an open Butel ARC2 .IC2 file
#
# Inputs:
#		fid	-file descriptor
##########################################################
proc ReadIC2File { fid }\
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Pgm


	# Read the first part of .r2 file one line at a time.

	set image ""

	for {set i 0} {$i < $Nmessages} {incr i} \
		{
		set len [gets $fid line]
		if {$len < 40} \
			{
			set msg "$Pgm: "
			append msg "Corruption in ARC .IC2 file"
			puts stderr $msg

			tk_dialog .error "tk3" \
				"Corrupted ARC2 .IC2 file" \
				error 0 OK

			return -1
			}

		set line [string range $line 0 39]
		set pline [binary format "H40" $line]
		set plen [string length $pline]

		set dbuf [string range $pline 0 18] 


		set cksum [string range $pline 19 19] 
		set ccksum [CalcCheckSum $dbuf]
	
		binary scan $cksum "H*" icksum
		scan $icksum "%x" cksum
	
#		puts stderr [format "CHECKSUM file: %s, calculated: %s\n" \
#				$cksum $ccksum]
	
		if {$cksum != $ccksum} \
			{
			set msg [format \
				"%s: error, checksum mismatch, radio: %s, calculated: %s\n" \
				$Pgm $cksum $ccksum]
			Tattle $msg
			tk_dialog .error "Checksum error while reading file" \
				$msg error 0 OK
			return -1
			}


		# Strip off memory address and count bytes.
		set buf [string range $dbuf 3 end]
		# set buf [string range $pline 5 44]

#		set abuf "$i) "
#		append abuf [DumpBinary $buf]
#		puts stderr $abuf

		append image $buf
		}

	set Mimage $image
	return 0
}


##########################################################
# Show memory channels in a window.
##########################################################
proc ShowChannels { f }\
{
	global Chb
	global Chvector
	global GlobalParam
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global RMode

	set Chvector ""

	set prevbn -1

	for {set bn 0} {$bn < 8} {incr bn} \
		{
		set ch [expr {$bn * 50}]
		for {set i 0} {$i < 50} {incr i} \
			{
			if {$bn != $prevbn} \
				{
				if {$bn == 7} \
					{
					set s [format "----- BANK SKIP --------" $bn]
					} \
				else \
					{
					set s [format "----- BANK %d --------" $bn]
					}
				lappend Chvector $s
				set prevbn $bn
				}
	
			if {$MemFreq($ch) > 0.0}  \
				{
				if { $MemOffset($ch) < .001 } \
					{
					set offset ""
					} \
				else \
					{
					set offset [format "%7.3f" \
						$MemOffset($ch)]
					}

				if { $MemToneFlag($ch) == 1} \
					{
					set toneflag t
					set tonecode $MemToneCode($ch)
					} \
				else \
					{
					# Tone is off, so
					# hide CTCSS the code.
					set toneflag ""
					set tonecode ""
					}
				set mode [string toupper $MemMode($ch)]
				set s [format "%3d %11.5f %-3s %5s %7s %1s %1s %5s %-5s %-6s" \
					$i $MemFreq($ch) \
					$mode \
					$MemStep($ch) \
					$offset \
					$MemDuplex($ch) \
					$toneflag \
					$tonecode \
					$MemSkip($ch) \
					$MemLabel($ch)
					]
				lappend Chvector $s
				}
			incr ch
			}
		}
		
	catch {destroy $f.lch}
	set Chb [ List_channels $f.lch $Chvector 30 ]
	wm deiconify $f
	$Chb activate 1
	pack $f.links -side left -anchor w -fill y
	pack $f.lch -side top

	wm maxsize .vfo [winfo width .vfo] [winfo height .vfo]

	return
}

##########################################################
# Export memory channels to a .csv file
##########################################################
proc ExportChannels { f }\
{
	global FileTypes
	global GlobalParam
	global Home
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global Mimage
	global Ofilename


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0) } \
		{
		set msg "You must read data from the radio"
		append msg " before exporting channels."
		append msg " (See the Radio menu.)"
		tk_dialog .info "tk3" $msg info 0 OK
		return
		}


	set Ofilename [Mytk_getSaveFile $f \
		$GlobalParam(MemoryFileDir) \
		.csv \
		"Export memory channels to .csv file" \
		$FileTypes]


	if {$Ofilename != ""} \
		{
		# puts stderr "ExportChannels: Ofilename $Ofilename"
		set GlobalParam(MemoryFileDir) [ Dirname $Ofilename ]

		set fid [open $Ofilename "w"]


		tk_dialog .belch "Export" \
			"Export Complete" info 0 OK

		# Write first line as the field names.
		puts -nonewline $fid [format "Bank,Ch,MHz,Mode,Step,"]
		puts $fid [format "Offset,Duplex,TSQL,CTCSS,Skip,Label"]

		for {set bn 0} {$bn < 8} {incr bn} \
			{
			set ch [expr {$bn * 50}]
			for {set i 0} {$i < 50} {incr i} \
				{
				if {$MemFreq($ch) <= .000001} \
					{
					incr ch
					continue
					}

				if {$MemToneFlag($ch)} \
					{
					set toneflag t
					} \
				else \
					{
					set toneflag ""
					}

				set skip $MemSkip($ch)
				if {$skip == " "} \
					{
					set skip ""
					}
	
				set s [format "%d,%d,%s,%s,%s,%s,%s,%s,%s,%s," \
					$bn $i $MemFreq($ch) \
					$MemMode($ch) \
					$MemStep($ch) \
					$MemOffset($ch) \
					$MemDuplex($ch) \
					$toneflag \
					$MemToneCode($ch) \
					$skip ]

				if {$MemLabel($ch) != ""} \
					{
					append s [format "\"%s\"" \
						$MemLabel($ch)]
					}
	
				puts $fid $s
				incr ch
				}
			}

		close $fid
		}
	return
}

proc FileExistsDialog { file } \
{
	set result [tk_dialog .fed "Warning" \
		"File $file already exists. Overwrite file?" \
		warning 0 Cancel Overwrite ]

	puts "result is $result"
	return $result
}


##########################################################
# Copy memory image to the radio
##########################################################
proc Image2Radio { f }\
{
	global FileTypes
	global Mimage
	global ReadRadioFlag

	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		# No image to write.
		set msg "You must first read template data from"
		append msg " the radio or a file before"
		append msg " writing it to the radio."

		tk_dialog .error "Write to VR-120" $msg error 0 OK
		}

	if {$ReadRadioFlag == "yes"} \
		{
		# We read an image from the radio.
		# Cannot read from and write to the radio
		# during the same session or else the radio
		# complains. (Reason unknown.)
		#
		# Tell user to save the image file, exit
		# the program, restart the program, read
		# the image file, then write to the radio.

		set msg ""
		append msg "You cannot read from the radio "
		append msg "and write to the radio during the same "
		append msg "session.\n\n"
		append msg "Please:\n"
		append msg "1) Save the memory image in a file,\n"
		append msg "using File --> Save As ...\n"
		append msg "2) Exit this program.\n"
		append msg "3) Restart this program.\n"
		append msg "4) Open the image file you saved "
		append msg "previously, using File --> Open ...\n "
		append msg "5) Then, you can write the image "
		append msg "to the radio."

		tk_dialog .belch "Write blocked warning" \
			$msg warning 0 OK
		return
		}

	if {[ValidateData]} {return}
	MakeWait
	EncodeImage
	KillWait

	set msg ""
	append msg "Instructions:\n"
	append msg "1) Ensure the radio is connected to"
	append msg " your computer and radio power is on.\n"

	set result [tk_dialog .info "Write to radio" \
		$msg \
		info 0 OK Cancel ]

	if {$result} \
		{
		# User canceled the write.
		return
		}

	set wcode [WriteImage]
	if {$wcode == 1} \
		{
		set msg "Error while writing to the radio."
		tk_dialog .error "Write error" $msg error 0 OK
		KillWait
		} \
	elseif {$wcode == 2} \
		{
		set msg "Error, cannot read radio version info."
		tk_dialog .error "Write error" $msg error 0 OK
		KillWait
		} \
	else \
		{
		set msg "Transfer Complete.\n"
		append msg "Look at the radio display "
		append msg "to view a status message."
		tk_dialog .belch "Transfer Complete" \
			$msg info 0 OK
		}

	return
}

###################################################################
# Return 1 if frequency is in range 0 - 2000 exclusive.
###################################################################
proc FreqInRange { f units } \
{
	if {$units == "mhz" } \
		{
		if { $f > 0 && $f < 2000.0 } \
			{
			return 1
			}
		} \
	elseif {$units == "khz" } \
		{
		if { $f > 0 && $f < 2000000.0 } \
			{
			return 1
			}
		}
	return 0
}

###################################################################
# Return 1 if string 's' is a valid frequency.
# Return 0 otherwise.
#
# Units should be khz or mhz
###################################################################
proc CheckFreqValid { s units }\
{
	if {$s == ""} then {return 0}

	# Check for non-digit and non decimal point chars.
	set rc [regexp {^[0-9.]*$} $s]
	if {$rc == 0} then {return 0}


	# All digits.
	set rc [regexp {^[0-9]*$} $s]
	if {$rc == 1} \
		{
		return [FreqInRange $s $units]
		}

	if {$s == "."} then {return 0}

	# Check for Two or more decimal points
	set tmp $s
	set tmp [split $s "."]
	set n [llength $tmp]
	if { $n >= 3 } then {return 0}
	
	return [FreqInRange $s $units]
}


###################################################################
# Set default receiver parameters
###################################################################
proc SetUp { } \
{
	global env
	global GlobalParam
	global RootDir
	global tcl_platform


	if { [regexp "Darwin" $tcl_platform(os) ] } \
		{
		# For Mac OS X.
		set RootDir ":"
		} \
	else \
		{
		set RootDir "/"
		}

	set GlobalParam(Debug) 0
	# set GlobalParam(Device) /dev/ttyS1
	set GlobalParam(Ifilename) {}
	set GlobalParam(MemoryFileDir) $RootDir
	set GlobalParam(PreviousFreq) 0.0

	return
}



###################################################################
# 
# Define receiver parameters before we read the
# global parameter configuration file in case they are missing
# from the configuration file.
# This avoids a tcl error if we tried to refer to an
# undefined variable.
#
# These initial definitions will be overridden with
# definitions from the configuration file.
#
###################################################################

proc PresetGlobals { } \
{
	global GlobalParam
	global Mode
	global Rcfile
	global RootDir
	global tcl_platform

	set GlobalParam(BalloonHelpWindows) on

	set GlobalParam(Attenuator) 0
	set GlobalParam(AutoOff) OFF
	set GlobalParam(BackGroundColor) ""
	set GlobalParam(BankScan) 0
	set GlobalParam(BankSort) -1
	set GlobalParam(BatterySaver) 1
	set GlobalParam(Beep) VOL
	set GlobalParam(Debug) 0
	set GlobalParam(Dial) 1MHz
	set GlobalParam(DialAccel) 1
	set GlobalParam(Font) ""
	set GlobalParam(ForeGroundColor) ""
	set GlobalParam(FrequencySkip) 1
	set GlobalParam(Lamp) AUTO
	set GlobalParam(LimitSearch) 0
	set GlobalParam(Lock) 0
	set GlobalParam(LockEffect) NORMAL
	set GlobalParam(MemoryFileDir) $RootDir
	set GlobalParam(Mode) $Mode(NFM)
	set GlobalParam(Monitor) PUSH
	set GlobalParam(Pause) 10
	set GlobalParam(PowerSave) 1
	set GlobalParam(RadioVersion) ""
	set GlobalParam(Resume) 2
	set GlobalParam(SetMenuItem) 0
	set GlobalParam(SortBank) -1
	set GlobalParam(SortType) "label"
	set GlobalParam(TroughColor) ""
	set GlobalParam(TuningStep) 5
	set GlobalParam(VFOSearch) ALL
	set GlobalParam(VFOFreq) 162.4000
	set GlobalParam(WhichModel) 10
	set GlobalParam(WXFreq) 162.55
	set GlobalParam(WXMode) AUTO

	return
}


###################################################################
# Set global variables after reading the global
# configuration file so these settings override
# whatever values were in the configuration file.
###################################################################

proc OverrideGlobals { } \
{
	global env
	global GlobalParam
	global RootDir
	global tcl_platform


	set GlobalParam(BypassAllEncoding) 0
	set GlobalParam(FileVersion) "                "
	set GlobalParam(Ifilename) {}
	set GlobalParam(LowestFreq) .005
	set GlobalParam(HighestFreq) 2999.995
	set GlobalParam(NmsgsRead) 0
	set GlobalParam(Populated) 0
	set GlobalParam(SortBank) 0
	set GlobalParam(SortType) freq
	set GlobalParam(TemplateFilename) {}
	set GlobalParam(TermMsg) {}
	set GlobalParam(UserComment) "                "
	set GlobalParam(UserPort) 0

	# Note on MacOS X:
	# The initial directory passed to the file chooser widget.
	# The problem here is that osx's tcl is utterly busted.
	# The _only_ pathname it accepts is ':' - no other ones work.
	# Now this isn't as bad as you might think because
	# the native macos file selector widget persistantly
	# remembers the last place you opened/saved a file
	# for a particular application. So the logic to
	# remember this is simply redundant on macos anyway...
	# Presumably they'll fix this someday and we can take
	# out the hack.
	# - Ben Mesander

	if { [regexp "Darwin" $tcl_platform(os) ] } \
		{
		# kluge for MacOS X.

		set GlobalParam(LogFileDir) $RootDir
		set GlobalParam(MemoryFileDir) $RootDir

		if {$GlobalParam(Ifilename) != ""} \
			{
			set GlobalParam(Ifilename) $RootDir
			}
		}

	return
}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeImage { } \
{
	global MemFreq
	global MemDuplex
	global MemMode
	global MemOffset
	global MemStep
	global MemToneCode
	global MemToneFlag

	MakeWait
	update idletasks


	for {set bn 0} {$bn < 8} {incr bn} \
		{
		set ch [expr {$bn * 50}]
		for {set i 0} {$i < 50} {incr i} \
			{
			set MemFreq($ch) 0
			set MemDuplex($ch) ""
			set MemMode($ch) NFM
			set MemOffset($ch) 0
			set MemStep($ch) 5
			set MemToneCode($ch) ""
			set MemToneFlag($ch) 0
			incr ch
			}
		}

	DecodeMisc
	DecodeMemories
	DecodeTV
	DecodeSearchBanks
	DecodeBandStack
#	DecodeDWBanks

	update idletasks
	KillWait
	update idletasks
	return
}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeMisc { } \
{
	global GlobalParam
	global ImageAddr
	global Mimage
	global Priority
	global PriorityMode
	global RAutoOff
	global RDial
	global RBatterySaver
	global RMode
	global RMonitor
	global RLamp
	global RLockEffect
	global RFstep
	global RPause
	global RResume
	global RStep



	# Parse file version
	scan $ImageAddr(FileVersion) "%x" first
	set last [expr {$first + 15}]
	set GlobalParam(FileVersion) \
		[string range $Mimage $first $last]

	# Parse user comment 
	scan $ImageAddr(UserComment) "%x" first
	set last [expr {$first + 15}]
	set GlobalParam(UserComment) \
		[string range $Mimage $first $last]


#	# Parse dial acceleration flag
#	scan $ImageAddr(DialAccel) "%x" first
#	set byte [string range $Mimage $first $first]
#	set GlobalParam(DialAccel) [Char2Int $byte]
#

	# Parse power save flag
	scan $ImageAddr(PowerSave) "%x" first
	set byte [string range $Mimage $first $first]
	set GlobalParam(PowerSave) [Char2Int $byte]

#	# Parse bank scan flag
#	scan $ImageAddr(BankScan) "%x" first
#	set byte [string range $Mimage $first $first]
#	set GlobalParam(BankScan) [Char2Int $byte]

	# Parse frequency skip scan flag
	scan $ImageAddr(FrequencySkip) "%x" first
	set byte [string range $Mimage $first $first]
	set GlobalParam(FrequencySkip) [Char2Int $byte]


	# Parse beep tone
	scan $ImageAddr(Beep) "%x" first
	set byte [string range $Mimage $first $first]
	set n [Char2Int $byte]

	if { ($n > 0) && ($n <= 32) } \
		{
		set GlobalParam(Beep) [expr {$n - 1}]
		} \
	else \
		{
		set GlobalParam(Beep) VOL
		} 



	# Parse Auto Power Off
	scan $ImageAddr(AutoOff) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RAutoOff($n)] } \
		{
		set GlobalParam(AutoOff) $RAutoOff($n)
		} \
	else \
		{
		set GlobalParam(AutoOff) OFF
		}


#	# Parse Dial
#	scan $ImageAddr(DialStep) "%x" first
#	set s [string range $Mimage $first $first]
#	set n [Char2Int $s]
#	if { [info exists RDial($n)] } \
#		{
#		set GlobalParam(Dial) $RDial($n)
#		} \
#	else \
#		{
#		set GlobalParam(Dial) 1MHz
#		}

	scan $ImageAddr(Lamp) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RLamp($n)] } \
		{
		set GlobalParam(Lamp) $RLamp($n)
		} \
	else \
		{
		set GlobalParam(Lamp) AUTO
		}


	scan $ImageAddr(Pause) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RPause($n)] } \
		{
		set GlobalParam(Pause) $RPause($n)
		} \
	else \
		{
		set GlobalParam(Pause) 2
		}


	scan $ImageAddr(Resume) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RResume($n)] } \
		{
		set GlobalParam(Resume) $RResume($n)
		} \
	else \
		{
		set GlobalParam(Resume) 2
		}


	# Monitor key
	scan $ImageAddr(Monitor) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RMonitor($n)] } \
		{
		set GlobalParam(Monitor) $RMonitor($n)
		} \
	else \
		{
		set GlobalParam(Monitor) PUSH
		}



	# Parse Lock function effect
	scan $ImageAddr(LockEffect) "%x" first
	set s [string range $Mimage $first $first]
	set n [Char2Int $s]
	if { [info exists RLockEffect($n)] } \
		{
		set GlobalParam(LockEffect) $RLockEffect($n)
		} \
	else \
		{
		set GlobalParam(LockEffect) NORMAL
		}


	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
# NOTES:
#	Each memory channel is represented by 8 consecutive bytes.
#	The first 3 bytes contain the frequency digits in hex.
#	The most significant nibble in the first byte is 0-E.
#	Frequencies of 1000 MHz and higher start with a letter.
#
#	The fourth byte is a little strange. It contains both the
#	simplex/duplex flag and part of the offset
#
#	
###################################################################
proc DecodeMemories { } \
{
	global CtcssBias
	global Mimage
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global ImageAddr
	global RCtcss
	global RMode
	global RSkip
	global RStep


	# Parse memory channel frequencies.
	scan $ImageAddr(MemoryFreqs) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [BCD2Freq4 $s]

		set MemFreq($ch) $f
		incr first 16
		incr last 16
		}


	# Parse memory channel offset frequencies.
	scan $ImageAddr(MemoryOffset) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [BCD2Offset $s]

		set MemOffset($ch) $f
		incr first 16
		incr last 16
		}


	# Parse memory channel duplex/simplex flag.
	scan $ImageAddr(MemoryDuplex) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set byte [string range $Mimage $first $first]
		set n [GetBitField $byte 2 3]

		if {$n == 0}\
			{
			set MemDuplex($ch) ""
			} \
		elseif {$n == 1} \
			{
			set MemDuplex($ch) ""
			} \
		elseif {$n == 2} \
			{
			set MemDuplex($ch) "-"
			} \
		else \
			{
			set MemDuplex($ch) "+"
			}

		incr first 16
		incr last 16
		}



	# Parse memory channel mode.
	scan $ImageAddr(MemoryModes) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set byte [string range $Mimage $first $first]

		set a [GetBit $byte 0]
		set b [GetBit $byte 1]

		set n [expr {$a + $a + $b}]
		set MemMode($ch) $RMode($n)

		incr first 16
		incr last 16
		}


	# Parse memory channel tone flag.
	scan $ImageAddr(MemoryToneFlag) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set byte [string range $Mimage $first $first]

		set MemToneFlag($ch) [GetBitField $byte 2 3]

		incr first 16
		incr last 16
		}

	# Parse memory CTCSS tone code.
	scan $ImageAddr(MemoryToneCode) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set byte [string range $Mimage $first $first]


		set n [GetBitField $byte 2 7]
		# fix me
		incr n $CtcssBias
		if { [info exists RCtcss($n)] } \
			{
			set MemToneCode($ch) $RCtcss($n)
			} \
		else \
			{
			set MemToneCode($ch) "0.0"
			}

		incr first 16
		incr last 16
		}


	# Parse skip field.
	scan $ImageAddr(MemorySkip) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set byte [string range $Mimage $first $first]


		set n [GetBitField $byte 0 1]
		if { [info exists RSkip($n)] } \
			{
			set MemSkip($ch) $RSkip($n)
			} \
		else \
			{
			set MemSkip($ch) " "
			}

		incr first 16
		incr last 16
		}


	# Parse memory channel step size.
	scan $ImageAddr(MemorySteps) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set byte [string range $Mimage $first $first]


		set n [GetBitField $byte 4 7]
		if { [info exists RStep($n)] } \
			{
			set MemStep($ch) $RStep($n)
			} \
		else \
			{
			set MemStep($ch) ?
			}

		incr first 16
		incr last 16
		}



	# Parse memory channel labels.
	scan $ImageAddr(MemoryLabels) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set last [expr {$first + 5}]
		set s [string range $Mimage $first $last]

		# Check for non-ascii chars.
		set rc [regexp {^[ A-Za-z0-9\-\+\*]*$} $s]
		if {$rc == 0} then {set s ""}

		set s [string trimright $s " "]
		set MemLabel($ch) $s
		incr first 16
		incr last 16
		}

	return
}


###################################################################
#
# Parse TV data from inside the memory image and store it
# in global arrays.
#
# NOTES:
#	Each TV memory channel freq is represented by 4
#	consecutive bytes.
#	
###################################################################
proc DecodeTV { } \
{
	global ImageAddr
	global Mimage
	global AMTV
	global AMTVMem
	global FMTVMem
	global RTVOffset


	# Parse AM channel allocation frequencies.
	scan $ImageAddr(AMTV) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [BCD2FreqTV $s]
		set AMTV($ch,freq) $f
		incr first 4
		incr last 4
		}


	# Parse AM channel offset flag for each channel.
	scan $ImageAddr(AMTV) "%x" first

	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set b [string index $Mimage $first]
		set AMTV($ch,offsetflag) [GetBit $b 0]
		incr first 4
		}



	# Parse AM channel offset value for each channel.
	scan $ImageAddr(AMTV) "%x" first

	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set b [string index $Mimage $first]
		set n [GetBitField $b 1 2]

		if {[info exists RTVOffset($n)]} \
			{
			set AMTV($ch,offset) $RTVOffset($n)
			} \
		else \
			{
			set AMTV($ch,offset) -3MHz
			}

		incr first 4
		}




	# Parse AM channel skip flag for each channel.
	scan $ImageAddr(AMTVSkip) "%x" first

	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set q [expr { $ch/8} ]
		set whichbyte [ expr { $first + floor($q) } ]
		set whichbyte [ expr { int($whichbyte) } ]

		set whichbit [ expr { fmod($ch,8) } ]
		set whichbit [ expr { int($whichbit) } ]
		set whichbit [ expr { 7 - $whichbit } ]

		set b [string index $Mimage $whichbyte]
		set AMTV($ch,skip) [GetBit $b $whichbit]
#		puts stderr "ch: $ch, whichbyte: $whichbyte, whichbit: $whichbit"
		
		}



	# Parse AM memory frequencies.
	scan $ImageAddr(AMTVMem) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [BCD2FreqTV $s]
		set AMTVMem($ch) $f
		incr first 4
		incr last 4
		}



	# Parse FM memory frequencies.
	scan $ImageAddr(FMTVMem) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 50} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [BCD2Freq4 $s]
		set FMTVMem($ch,freq) $f
		incr first 4
		incr last 4
		}


	# Parse FM memory reverse flag.
	# This determines whether to display the picture 
	# with positive or negative polarity
	scan $ImageAddr(FMTVMemRev) "%x" first

	for {set ch 0} {$ch < 50} {incr ch} \
		{
		set s [string index $Mimage $first]
		set FMTVMem($ch,rev) [GetBit $s 0]

		incr first
		}



	# Parse FM memory subcarrier value.
	# Subcarrier range is -63 to +63.
	# The value is stored in a 7-bit field
	# as the subcarrier + 63, which is 0 - 126.

	scan $ImageAddr(FMTVMemSub) "%x" first

	for {set ch 0} {$ch < 50} {incr ch} \
		{
		set b [string index $Mimage $first]
		set n [GetBitField $b 1 7]
		set FMTVMem($ch,sub) [expr {$n - 63}]

		incr first
		}



	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeSearchBanks { } \
{
	global LimitScan
	global Mimage
	global MemFreq
	global MemMode
	global ImageAddr
	global RMode
	global RStep


	# Parse lower limit frequencies.
	scan $ImageAddr(SearchFreqFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set last [expr {$first + 3}]
		set s [string range $Mimage $first $last]

		set f [BCD2Freq4 $s]

		set LimitScan($bn,lower) $f
		incr first 32
		}


	# Parse upper limit frequencies.
	scan $ImageAddr(SearchFreqSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set last [expr {$first + 3}]
		set s [string range $Mimage $first $last]

		set f [BCD2Freq4 $s]

		set LimitScan($bn,upper) $f
		incr first 32
		}

	# Parse lower edge modes.
	scan $ImageAddr(SearchModeFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set last $first
		set s [string range $Mimage $first $last]

		set a [GetBit $s 0]
		set b [GetBit $s 1]

		set n [expr {$a + $a + $b}]

		if { [info exists RMode($n)] } \
			{
			set LimitScan($bn,lmode) $RMode($n)
			} \
		else \
			{
			set LimitScan($bn,lmode) ?
			}

		incr first 32
		}



	# Parse upper edge modes.
	scan $ImageAddr(SearchModeSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set last $first
		set s [string range $Mimage $first $last]

		set a [GetBit $s 0]
		set b [GetBit $s 1]

		set n [expr {$a + $a + $b}]

		if { [info exists RMode($n)] } \
			{
			set LimitScan($bn,umode) $RMode($n)
			} \
		else \
			{
			set LimitScan($bn,umode) ?
			}

		incr first 32
		}


	# Parse lower scan edge step size.
	scan $ImageAddr(SearchStepFirst) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		set n [GetBitField $byte 4 7]
		if { [info exists RStep($n)] } \
			{
			set LimitScan($bn,lstep) $RStep($n)
			} \
		else \
			{
			set LimitScan($bn,lstep) ?
			}

		incr first 32
		incr last 32
		}


	# Parse upper scan edge step size.
	scan $ImageAddr(SearchStepSecond) "%x" first

	for {set bn 0} {$bn < 25} {incr bn} \
		{
		set byte [string range $Mimage $first $first]

		set n [GetBitField $byte 4 7]
		if { [info exists RStep($n)] } \
			{
			set LimitScan($bn,ustep) $RStep($n)
			} \
		else \
			{
			set LimitScan($bn,ustep) ?
			}

		incr first 32
		incr last 32
		}


	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeBandStack { } \
{
	global CtcssBias
	global GlobalParam
	global ImageAddr
	global Mimage
	global BandStack
	global RCtcss
	global RMode
	global RSkip
	global RStep


	# Parse BandStack frequencies.
	scan $ImageAddr(BandStackFreq) "%x" first

	for {set bn 0} {$bn < 11} {incr bn} \
		{
		set last [expr {$first + 3}]
		set s [string range $Mimage $first $last]

		set f [BCD2Freq4 $s]

		set BandStack($bn,freq) $f

		incr first 10
		}


	# Parse BandStack modes.
	scan $ImageAddr(BandStackModes) "%x" first

	for {set bn 0} {$bn < 11} {incr bn} \
		{
		set s [string range $Mimage $first $first]

		set a [GetBit $s 0]
		set b [GetBit $s 1]
		set n [expr {$a + $a + $b}]

		if { [info exists RMode($n)] } \
			{
			set BandStack($bn,mode) $RMode($n)
			} \
		else \
			{
			set BandStack($bn,mode) "?"
			}
		incr first 10
		}


	# Parse bandstack offset frequencies.
	scan $ImageAddr(BandStackOffset) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set s [string range $Mimage $first $last]

		set f [BCD2Offset $s]

		set BandStack($ch,offset) $f
		incr first 10
		incr last 10
		}


	# Parse bandstack duplex/simplex flag.
	scan $ImageAddr(BandStackDuplex) "%x" first

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set byte [string range $Mimage $first $first]
		set n [GetBitField $byte 0 3]

		if {$n == 0}\
			{
			set BandStack($ch,duplex) ""
			} \
		elseif {$n == 1} \
			{
			set BandStack($ch,duplex) ""
			} \
		elseif {$n == 2} \
			{
			set BandStack($ch,duplex) "-"
			} \
		else \
			{
			set BandStack($ch,duplex) "+"
			}

		incr first 10
		incr last 10
		}

	# Parse bandstack tone flag.
	scan $ImageAddr(BandStackToneFlag) "%x" first

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set byte [string range $Mimage $first $first]

		set BandStack($ch,toneflag) [GetBitField $byte 2 3]

		incr first 10
		incr last 10
		}



	# Parse bandstack CTCSS tone code.
	scan $ImageAddr(BandStackToneCode) "%x" first

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set byte [string range $Mimage $first $first]


		set n [GetBitField $byte 2 7]
		# fix me
		incr n $CtcssBias
		if { [info exists RCtcss($n)] } \
			{
			set BandStack($ch,tonecode) $RCtcss($n)
			} \
		else \
			{
			set BandStack($ch,tonecode) "0.0"
			}

		incr first 10
		incr last 10
		}


	# Parse bandstack skip field.
	scan $ImageAddr(BandStackSkip) "%x" first

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set byte [string range $Mimage $first $first]

		set n [GetBitField $byte 0 1]
		if { [info exists RSkip($n)] } \
			{
			set BandStack($ch,skip) $RSkip($n)
			} \
		else \
			{
			set BandStack($ch,skip) " "
			}

		incr first 10
		incr last 10
		}


	# Parse bandstack step size.
	scan $ImageAddr(BandStackSteps) "%x" first

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set byte [string range $Mimage $first $first]


		set n [GetBitField $byte 4 7]
		if { [info exists RStep($n)] } \
			{
			set BandStack($ch,step) $RStep($n)
			} \
		else \
			{
			set BandStack($ch,step) ?
			}

		incr first 10
		incr last 10
		}

	return
}

###################################################################
# Decode a 4 byte BCD frequency.
#
# Returns:	frequency in MHz
###################################################################

proc BCD2Freq4 { s } \
{
	global GlobalParam
	

	# Note: Icom packs two digits per byte, one per nibble.
	# An important exception is the most significant nibble
	# in the most significant byte.
	#
	# If bit 1 = 1, then
	# then the frequency resolution is 100 Hz.

	# Frequency digit pairs.


	# set abuf ""
	# append abuf [DumpBinary $s]
	# puts stderr "s: $abuf"

	if {[string length $s] == 0} \
		{
		return "0.0000"
		}

	binary scan $s "H8" as
	if {$GlobalParam(WhichModel) == 10} \
		{
		set rc [regexp {f} $as]
		if {$rc} {return "0.0000"}
		} \
	else \
		{
		if { $as == "ffffffff" } {return "0.0000"} \
		else \
			{
			set rc [regexp {ffffff$} $as]
			if {$rc} \
				{
				# The last 3 bytes are ff
				# which means
				# 9 kHz spacing and 
				# freqency is .495 - 1.620 MHz

				# Multiply value in first byte
				# by .009 and add it to .495

				set b [string index $s 0]
				binary scan $b "H2" imult
				scan $imult "%x" mult
				set f [expr {($mult * .009) + .495}]
				set f [format "%.4f" $f]
				return $f
				}
			}
		}


	set b [string index $s 0]

	# 100 Hz flag:
	#	1 = yes
	#	0 = no
	binary scan $b "H2" byte
	# puts stderr "byte: $b"

	set hzflag [GetBit $b 1]

	set d0 [GetBitField [string index $s 0] 2 3]
	set d1 [GetBitField [string index $s 0] 4 7]
	set d2 [GetBitField [string index $s 1] 0 3]
	set d3 [GetBitField [string index $s 1] 4 7]
	set d4 [GetBitField [string index $s 2] 0 3]
	set d5 [GetBitField [string index $s 2] 4 7]
	set d6 [GetBitField [string index $s 3] 0 3]
	set d7 [GetBitField [string index $s 3] 4 7]

	set f [format "%d%d%d%d.%d%d%d%d" $d0 $d1 $d2 $d3 $d4 \
		$d5 $d6 $d7 ]
		
	set f [string trimleft $f 0]

	# puts stderr "returning $f hzflag: $hzflag"
	return $f
}



###################################################################
# Decode a 4 byte BCD television frequency.
#
# Returns:	frequency in MHz
###################################################################

proc BCD2FreqTV { s } \
{
	global GlobalParam
	

	# Note: Icom packs two digits per byte, one per nibble.
	# An important exception is the most significant nibble
	# in the most significant byte.
	#

	# Frequency digit pairs.


	# set abuf ""
	# append abuf [DumpBinary $s]
	# puts stderr "s: $abuf"

	if {[string length $s] == 0} \
		{
		return "0.0000"
		}

	binary scan $s "H8" as
	set rc [regexp {f} $as]
	if {$rc} {return "0.0000"}


	set b [string index $s 0]

	set d0 [GetBitField [string index $s 0] 3 3]
	set d1 [GetBitField [string index $s 0] 4 7]
	set d2 [GetBitField [string index $s 1] 0 3]
	set d3 [GetBitField [string index $s 1] 4 7]
	set d4 [GetBitField [string index $s 2] 0 3]
	set d5 [GetBitField [string index $s 2] 4 7]
	set d6 [GetBitField [string index $s 3] 0 3]
	set d7 [GetBitField [string index $s 3] 4 7]

	set f [format "%d%d%d%d.%d%d%d%d" $d0 $d1 $d2 $d3 $d4 \
		$d5 $d6 $d7 ]
		
	set f [string trimleft $f 0]

	# puts stderr "returning $f hzflag: $hzflag"
	return $f
}




###################################################################
# Decode a 4 byte BCD offset frequency.
#
# Returns:	frequency in MHz
###################################################################

proc BCD2Offset { s } \
{
	global GlobalParam
	

	# Note: Icom packs two digits per byte, one per nibble.
	# An important exception is the most significant nibble
	# in the most significant byte.
	#
	# If bit 1 = 1, then
	# then the frequency resolution is 100 Hz.

	# Frequency digit pairs.


#	set abuf ""
#	append abuf [DumpBinary $s]
#	puts stderr "s: $abuf"

	if {[string length $s] == 0} \
		{
		return "0.0000"
		}

	if { [GetBit $s 0] } \
		{
		return "0.0000"
		}

	binary scan $s "H8" as
	set rc [regexp {f} $as]
	if {$rc} {return "0.0000"}


	set b [string index $s 0]

	# 100 Hz flag:
	#	1 = yes
	#	0 = no
	binary scan $b "H2" byte
	# puts stderr "byte: $b"

	set hzflag [GetBit $b 1]

	set d0 [GetBitField [string index $s 0] 2 3]
	set d1 [GetBitField [string index $s 0] 4 7]
	set d2 [GetBitField [string index $s 1] 0 3]
	set d3 [GetBitField [string index $s 1] 4 7]
	set d4 [GetBitField [string index $s 2] 0 3]
	set d5 [GetBitField [string index $s 2] 4 7]
	set d6 [GetBitField [string index $s 3] 0 3]
	set d7 [GetBitField [string index $s 3] 4 7]

	set f [format "%d%d%d.%d%d%d%d" $d1 $d2 $d3 $d4 \
		$d5 $d6 $d7 ]
		
	set f [string trimleft $f 0]

	# puts stderr "returning $f hzflag: $hzflag"
	return $f
}



###################################################################
# Encode a frequency (MHz) to IC-R3 4-byte binary string.
# The most significant bit of the most significant byte
# is a flag which indicates that the 100s of Hz is nonzero,
# e.g., 470.3125 MHz
#
# Notes:
#	If the radio is a model with 9 kHz spacing in the AM BCB,
#	special treatment for frequencies in the range
#	of .495 - 1.620 MHz.
#	In that case, the last 3 bytes must be set to hex ff.
#	The first byte contains a number, which when multiplied
#	by .009 and added to .495 equals the frequency in MHz.
###################################################################

proc Freq2BCD4 { f } \
{
	global GlobalParam

	set rc [regexp {^[0-9]*$} $f]
	if {$rc == 0} \
		{
		set rc [regexp {^[0-9]*[\.][0-9]*$} $f]
		if {$rc == 0} \
			{
			# puts stderr "Freq2BCD4: bad frequency: $f"
			set f 0.0
			}
		}
	if {$GlobalParam(WhichModel) == 9} \
		{
		# Check that f consists of all digits and an
		# optional decimal point.
		if {$f < .495} \
			{
			# puts stderr "Freq2BCD4: bad frequency: $f"
			set f 0
			} \
		elseif {$f <= 1.620} \
			{
			set ff [ expr { ($f - .495) / .009 } ]
			set fi [ expr {int($ff)} ]
			set s [format "%02x" $fi]
			set bf [binary format "H2H2H2H2" $s ff ff ff]
			# set abuf [DumpBinary $bf]
			# puts stderr "f: $f, abuf: $abuf"
			return $bf
			}
		}



	if { ($f > $GlobalParam(HighestFreq)) \
		|| ($f < $GlobalParam(LowestFreq)) } \
		{
		# puts stderr "Freq2BCD4: bad frequency: $f"
		set f 0.0
		}


	# Reformat into an 8-digit string of hundreds of Hz.
	# Example: Want to represent 162.55 MHz as 01625500

	set sf [format "%.4f" $f]
	set sf [PadLeft0 9 $sf]
	regsub  {\.} $sf {} sf
#	puts stderr "f: $f, sf: $sf"

	if {$sf == "00000000"} \
		{
		set sf ffffffff
		}
	set bf [binary format "H8" $sf]

	if {[string index $sf 7] != "0"} \
		{
		# Set 100 Hz bit flag
		set b [string index $bf 0]
		set b [SetBit $b 0]
		set bf [string replace $bf 0 0 $b]
		}

	return $bf
}


###################################################################
# Encode a TV frequency (MHz) to IC-R3 4-byte binary string.
# It must be less than 2000 MHz.
#
###################################################################

proc Freq2BCD4TV { f } \
{
	global GlobalParam

	set rc [regexp {^[0-9]*$} $f]
	if {$rc == 0} \
		{
		set rc [regexp {^[0-9]*[\.][0-9]*$} $f]
		if {$rc == 0} \
			{
			# puts stderr "Freq2BCD4TV: bad frequency: $f"
			set f 0.0
			}
		}


	if { ($f >= 2000.0) \
		|| ($f < 0.0) } \
		{
		# puts stderr "Freq2BCD4TV: bad frequency: $f"
		set f 0.0
		}


	# Reformat into an 8-digit string kHz.
	# Example: Want to represent 162.55 MHz as 01625500

	set sf [format "%.3f" $f]
	append sf 0
	set sf [PadLeft0 9 $sf]
	regsub  {\.} $sf {} sf
#	puts stderr "f: $f, sf: $sf"

	if {$sf == "00000000"} \
		{
		set sf ffffffff
		}
	set bf [binary format "H8" $sf]

	# set abuf [DumpBinary $bf]
	# puts stderr "$f, abuf: $abuf"
	return $bf
}




###################################################################
# Encode an offset (MHz) to IC-R3 4-byte binary string.
# The most significant bit of the most significant byte
# is a flag which indicates that the 100s of Hz is nonzero,
# e.g., 470.3125 MHz
#
# Inputs:
#		f	-frequency in MHz (0.005 <= f < 1000.0 MHz)
#		dir	-direction; null, -, +
###################################################################

proc Offset2BCD4 { f d } \
{
	global GlobalParam

	# Check that f consists of all digits and an
	# optional decimal point.

	set rc [regexp {^[0-9]*$} $f]
	if {$rc == 0} \
		{
		set rc [regexp {^[0-9]*[\.][0-9]*$} $f]
		if {$rc == 0} \
			{
			# puts stderr "Offset2BCD4: bad frequency: $f"
			set f 0.0
			}
		}


	if { ($f >= 1000) \
		|| ($f < .005) } \
		{
		# puts stderr "Offset2BCD4: bad frequency: $f"
		set f 0.0
		}


	# Reformat into an 7-digit string of hundreds of Hz.
	# Example: Want to represent 162.55 MHz as 1625500

	set sf [format "%.4f" $f]
	set sf [PadLeft0 9 $sf]
	regsub  {\.} $sf {} sf
#	puts stderr "f: $f, sf: $sf"

	if {$sf == "00000000"} \
		{
		# set sf fffffffff
		}
	set bf [binary format "H8" $sf]

	if {[string index $sf 7] != "0"} \
		{
		# Set 100 Hz bit flag
		set b [string index $bf 0]
		set b [SetBit $b 0]
		set bf [string replace $bf 0 0 $b]
		}

	if {$d == "+"} \
		{
		set dn 3
		} \
	elseif {$d == "-"} \
		{
		set dn 2
		} \
	else \
		{
		set dn 0
		}

	# Set the duplex flag bits in the left nibble according to the
	# simplex/duplex+/duplex- value

	set b [string index $bf 0]
	set b [SetBitField $b 2 3 $dn]
	set bf [string replace $bf 0 0 $b]

	return $bf
}



###################################################################
# Create widgets for the name of this program.
###################################################################
proc MakeTitleFrame { f }\
{
	global DisplayFontSize 
	global Version

	frame $f -relief flat -borderwidth 3

	# set s [format "tk3 v%s" $Version]
	set s [format "tk3"]

	label $f.lab -text $s \
		-background blue \
		-foreground white \
		-relief raised \
		-borderwidth 3 \
		-font $DisplayFontSize 

	set s ""
	append s [format "Version %s\n" $Version]
	append s "Experimental Utility\n"
	append s "for the ICOM IC-R3 Receiver"

	label $f.use -text $s \
		-background black \
		-foreground white \
		-relief raised \
		-borderwidth 3

	pack $f.lab $f.use -side top -padx 0 -pady 0 \
		-fill y -fill x -expand true

	return $f
}


###################################################################
# Create frame for display parameters. 
###################################################################
proc MakeDisplayFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Display, Keypad Settings" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeDispWidgets  $f.b
	pack $f.b -side top -expand true -fill both

	return $f
}

proc MakeDispWidgets {f} \
{
	global GlobalParam


        label $f.lmonitor -text "Monitor key" -borderwidth 3
	tk_optionMenu $f.monitor GlobalParam(Monitor) PUSH HOLD
	

        label $f.llockeffect -text "Lock function effect" -borderwidth 3
	tk_optionMenu $f.lockeffect GlobalParam(LockEffect) \
		NORMAL NO_SQL NO_VOL ALL


        label $f.llamp -text "Lamp" -borderwidth 3
	tk_optionMenu $f.lamp GlobalParam(Lamp) OFF ON AUTO

        label $f.lbeep -text "Confirmation beep" -borderwidth 3
	tk_optionMenu $f.beep GlobalParam(Beep) \
		VOL \
		0 1 2 3 4 5 6 7 8 9 \
		10 11 12 13 14 15 16 17 18 19 \
		20 21 22 23 24 25 26 27 28 29 \
		30 31



	grid $f.lmonitor -row 4 -column 0 -sticky w
	grid $f.monitor -row 4 -column 1 -sticky e

	grid $f.llockeffect -row 6 -column 0 -sticky w
	grid $f.lockeffect -row 6 -column 1 -sticky e

	grid $f.llamp -row 8 -column 0 -sticky w
	grid $f.lamp -row 8 -column 1 -sticky e
	grid $f.lbeep -row 12 -column 0 -sticky w
	grid $f.beep -row 12 -column 1 -sticky e


	return

}


###################################################################
# Create 25 search banks. 
###################################################################
proc MakeSearchFrame { f }\
{
	global GlobalParam


	frame $f -relief groove -borderwidth 3

	frame $f.rb -relief groove -borderwidth 3
	set r $f.rb


        label $r.ldial -text "Fast dial step" -borderwidth 3
	tk_optionMenu $r.dial GlobalParam(Dial) 100kHz 1MHz 10MHz

	# checkbutton $r.dialaccel -text "Dial acceleration" 
	checkbutton $r.dialaccel -text "" \
		-variable GlobalParam(DialAccel) \
		-onvalue 1 -offvalue 0

        label $r.ldialaccel -text "Dial acceleration" -borderwidth 3

        label $r.lvfosearch -text "VFO Search" -borderwidth 3
	$r.lvfosearch configure -foreground yellow

	tk_optionMenu $r.vfosearch GlobalParam(VFOSearch) \
		BAND ALL \
		PROG0 PROG1 PROG2 PROG3 PROG4 PROG5 \
		PROG6 PROG7 PROG8 PROG9 \
		PROG10 PROG11 PROG12 PROG13 PROG14 PROG15 \
		PROG16 PROG17 PROG18 PROG19 \
		PROG20 PROG21 PROG22 PROG23 PROG24

	grid $r.ldial -row 8 -column 1 -sticky w
	grid $r.dial -row 8 -column 2 -sticky ew
	grid $r.ldialaccel -row 12 -column 1 -sticky w
	grid $r.dialaccel -row 12 -column 2 -sticky e

	# pack $r.lvfosearch $r.vfosearch -side left
	pack $r -side top -padx 3 -pady 3

	label $f.lab -text "\nLimit Search Banks" -borderwidth 3
	pack $f.lab -side top -padx 3 -pady 3


	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]

	for {set i 0} {$i < 25} {incr i} \
		{
		MakeSearchBank $w $i
		}

	pack $f.b -side top -fill both -expand true -padx 3 -pady 3

	return $f
}



###################################################################
# Create one a set of widgets for one search bank. 
###################################################################
proc MakeSearchBank { f bn }\
{
	global LimitScan
	global GlobalParam

	label $f.lab$bn -text "PROG$bn" -borderwidth 3

	entry $f.lower$bn -width 10 \
		-textvariable LimitScan($bn,lower) \
		-background white 

	tk_optionMenu $f.lmodemenu$bn LimitScan($bn,lmode) \
		AUTO NFM WFM AM

	tk_optionMenu $f.lstep$bn LimitScan($bn,lstep) \
		AUTO 5 6.25 10 12.5 15 20 25 30 50 100

	entry $f.upper$bn -width 10 \
		-textvariable LimitScan($bn,upper) \
		-background white 

	tk_optionMenu $f.umodemenu$bn LimitScan($bn,umode) \
		AUTO NFM WFM AM

	tk_optionMenu $f.ustep$bn LimitScan($bn,ustep) \
		AUTO 5 6.25 10 12.5 15 20 25 30 50 100

	grid $f.lab$bn -row $bn -column 1
	grid $f.lower$bn -row $bn -column 2
	grid $f.lmodemenu$bn -row $bn -column 3 -sticky ew
	grid $f.lstep$bn -row $bn -column 4 -sticky ew
	grid $f.upper$bn -row $bn -column 5
	grid $f.umodemenu$bn -row $bn -column 6 -sticky ew
	grid $f.ustep$bn -row $bn -column 7 -sticky ew

	return $f
}


###################################################################
# Create AM TV channel frequencies.
###################################################################
proc MakeAMTVFrame { f }\
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	set msg1 "AM TV Channels\n(1999.995 MHz max)"
	label $f.lab -text $msg1 -borderwidth 3
	pack $f.lab -side top -padx 3 -pady 3


	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]

	for {set i 0} {$i < 83} {incr i} \
		{
		MakeAMTVChan $w $i
		}

	pack $f.b -side top -fill both -expand true -padx 3 -pady 3

	return $f
}



###################################################################
# Create one a set of widgets for tv channel freq. 
###################################################################
proc MakeAMTVChan { f bn }\
{
	global AMTV
	global GlobalParam

	set j $bn
	incr j

	label $f.lab$bn -text "$j" -borderwidth 3

	entry $f.f$bn -width 10 \
		-textvariable AMTV($bn,freq) -background white 

	checkbutton $f.offsetflag$bn -text "Offset" \
		-variable AMTV($bn,offsetflag) \
		-onvalue 1 -offvalue 0

	tk_optionMenu $f.offset$bn AMTV($bn,offset) \
		"+3MHz" "+2MHz" "-3MHz" "-2MHz"


	checkbutton $f.skip$bn -text "Skip" \
		-variable AMTV($bn,skip) \
		-onvalue 1 -offvalue 0

	grid $f.lab$bn -row $bn -column 1
	grid $f.f$bn -row $bn -column 2
	grid $f.offsetflag$bn -row $bn -column 3
	grid $f.offset$bn -row $bn -column 4
	grid $f.skip$bn -row $bn -column 5

	return $f
}



###################################################################
# Create AM TV memories.
###################################################################
proc MakeAMTVMemFrame { f }\
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	label $f.lab -text "\nAM TV Memories" -borderwidth 3
	pack $f.lab -side top -padx 3 -pady 3


	frame $f.w -relief groove -borderwidth 3
	set w $f.w

	for {set i 0} {$i < 10} {incr i} \
		{
		MakeAMTVMem $w $i
		}

	pack $f.w -side top -fill both -expand true -padx 3 -pady 3

	return $f
}



###################################################################
# Create one a set of widgets for tv memory. 
###################################################################
proc MakeAMTVMem { f bn }\
{
	global AMTVMem
	global LimitScan


	label $f.lab$bn -text "$bn" -borderwidth 3

	entry $f.f$bn -width 10 \
		-textvariable AMTVMem($bn) -background white 


	grid $f.lab$bn -row $bn -column 1
	grid $f.f$bn -row $bn -column 2

	return $f
}



###################################################################
# Create FM TV memories.
###################################################################
proc MakeFMTVMemFrame { f }\
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	set msg1 "FM TV Memories"
	set msg2 "900 - 1300, 2250 - 2450.095 MHz"
	set msg3 "Subcarrier range is -63 to 63"
	label $f.lab1 -text $msg1 -borderwidth 3
	label $f.lab2 -text $msg2 -borderwidth 3
	label $f.lab3 -text $msg3 -borderwidth 3
	pack $f.lab1 $f.lab2 $f.lab3 -side top -padx 3


	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]

	for {set i 0} {$i < 50} {incr i} \
		{
		MakeFMTVMem $w $i
		}

	pack $f.b -side top -fill both -expand true -padx 3 -pady 3

	return $f
}



###################################################################
# Create one a set of widgets for tv memory. 
###################################################################
proc MakeFMTVMem { f bn }\
{
	global FMTVMem
	global LimitScan
	global GlobalParam

	label $f.lab$bn -text "$bn" -borderwidth 3

	entry $f.f$bn -width 10 \
		-textvariable FMTVMem($bn,freq) \
		-background white 


	checkbutton $f.rev$bn -text "Reverse video" \
		-variable FMTVMem($bn,rev) \
		-onvalue 1 -offvalue 0

	label $f.lsub$bn -text " Subcarrier" -borderwidth 3
	entry $f.sub$bn -width 5 \
		-textvariable FMTVMem($bn,sub) \
		-background white 

	grid $f.lab$bn -row $bn -column 6
	grid $f.f$bn -row $bn -column 12
	grid $f.lsub$bn -row $bn -column 18
	grid $f.sub$bn -row $bn -column 24
	grid $f.rev$bn -row $bn -column 40

	return $f
}



###################################################################
# Create frame for misc parameters. 
###################################################################
proc MakeMiscFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Misc. Settings" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeMiscWidgets  $f.b
	pack $f.b -side top -expand true -fill both

	return $f
}


###################################################################
# Create widgets for misc. parameters. 
###################################################################
proc MakeMiscWidgets { f } \
{
	global GlobalParam
	global Priority
	global PriorityMode

	checkbutton $f.battery -text "Power Save" \
		-variable GlobalParam(PowerSave) \
		-onvalue 1 -offvalue 0


        label $f.lautooff -text "Auto power off (min.)" -borderwidth 3
        tk_optionMenu $f.autooff GlobalParam(AutoOff) \
                OFF 30 60 90 120

        label $f.lpause -text "Scan Pause (sec.)" -borderwidth 3
        tk_optionMenu $f.pause GlobalParam(Pause) \
                2 4 6 8 10 12 14 16 18 20 HOLD

        label $f.labresume -text "Scan Resume (sec.)" -borderwidth 3
        tk_optionMenu $f.resume GlobalParam(Resume) \
                0 1 2 3 4 5 HOLD


	checkbutton $f.atten -text "Attenuator" \
		-variable GlobalParam(Attenuator) \
		-onvalue 1 -offvalue 0

	checkbutton $f.fskipscan -text "Frequency Skip" \
		-variable GlobalParam(FrequencySkip) \
		-onvalue 1 -offvalue 0

	$f.atten configure -foreground yellow

        grid $f.battery -row 4 -column 0 -sticky w -columnspan 2

	grid $f.lautooff  -row 8 -column 0 -sticky w
	grid $f.autooff -row 8 -column 1 -sticky ew



	grid $f.lpause  -row 10 -column 0 -sticky w
	grid $f.pause -row 10 -column 1 -sticky ew

	grid $f.labresume  -row 14 -column 0 -sticky w
	grid $f.resume -row 14 -column 1 -sticky ew

#       grid $f.atten  -row 12 -column 0 -sticky w -columnspan 2

        grid $f.fskipscan -row 20 -column 0 -sticky w -columnspan 2

	return $f
}


###################################################################
# Create frame for Communications parameters. 
###################################################################
proc MakeCommFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Debugging Information" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeCommWidgets  $f.b

	set hint ""
	append hint "Serial Communications fields "
	append hint "are useful for testing tk3. "
	balloonhelp_for $f $hint


	pack $f.b -side top -expand true -fill y

	return $f
}


###################################################################
# Create widgets for Communications params. 
###################################################################
proc MakeCommWidgets { f } \
{
	global GlobalParam

	label $f.labpre -text "Radio Version" -borderwidth 3
	entry $f.pre -width 26 \
		-textvariable GlobalParam(RadioVersion) \
		-background yellow 

	label $f.lfileversion -text "File Version" -borderwidth 3
	entry $f.fileversion -width 26 \
		-textvariable GlobalParam(FileVersion) \
		-background yellow 

	label $f.lusercomment -text "User comment" -borderwidth 3
	entry $f.usercomment -width 26 \
		-textvariable GlobalParam(UserComment) \
		-background yellow 

	label $f.ltermmsg -text "Termination Message" -borderwidth 3
	entry $f.termmsg -width 36 \
		-textvariable GlobalParam(TermMsg) \
		-background yellow 



	label $f.labnmsgs -text "Number Messages Read" -borderwidth 3
	entry $f.nmsgs -width 5 \
		-textvariable GlobalParam(NmsgsRead) \
		-background yellow 

	checkbutton $f.bypassall -text "Bypass All Encoding" \
		-variable GlobalParam(BypassAllEncoding) \
		-onvalue 1 -offvalue 0



	grid $f.labpre  -row 0 -column 0 -sticky w
	grid $f.pre	-row 0 -column 1 -sticky e

	grid $f.lfileversion  -row 4 -column 0 -sticky w
	grid $f.fileversion	-row 4 -column 1 -sticky e

	grid $f.lusercomment  -row 8 -column 0 -sticky w
	grid $f.usercomment	-row 8 -column 1 -sticky e

	grid $f.labnmsgs -row 12 -column 0 -sticky w
	grid $f.nmsgs	-row 12 -column 1 -sticky e

	grid $f.ltermmsg -row 14 -column 0 -sticky w
	grid $f.termmsg	-row 14 -column 1 -sticky e

	grid $f.bypassall	-row 16 -column 0 -columnspan 2

	return $f
}



###################################################################
# Create widgets for Linked Scan Banks. 
###################################################################
proc MakeLinkedScanFrame { f }\
{
	global GlobalParam

	frame $f -relief sunken -borderwidth 3

#	checkbutton $f.bs -text "Bank\nScan" \
#		-variable GlobalParam(BankScan) \
#		-onvalue 0 -offvalue 1
#
#	$f.bs configure -foreground yellow
#
#	set hint ""
#	set hint [append hint "Bank Scan restricts the radio "]
#	set hint [append hint "to scan a channel bank or "]
#	set hint [append hint "a set of channel banks (choose below) "]
#	set hint [append hint "instead of scanning all banks. "]
#	balloonhelp_for $f.bs $hint
#
#
#	pack $f.bs -side top

	return $f
}


###################################################################
# Create widgets for BandStack Memories. 
###################################################################
proc MakeBandStackFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Bandstacking Registers" -borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3

	for {set i 0} {$i < 11} {incr i} \
		{
		MakeBandStackBank $f.b $i
		}

	pack $f.b -side top -padx 3 -pady 3

	set hint ""
	append hint "Bandstacking registers "
	append hint "remember the last VFO frequency and mode "
	append hint "setting for each band.\n"
	append hint "They also determine the mode and step size for "
	append hint "limit searches."
	balloonhelp_for $f.b $hint

	return $f
}


###################################################################
# Create one a set of widgets for one BandStack bank. 
###################################################################
proc MakeBandStackBank { f bn }\
{
	global Band
	global BandStack
	global GlobalParam

	set msg [format "%.3f - %.3f" \
		$Band(USA,$bn,low) $Band(USA,$bn,high)]

	label $f.lab$bn -text $msg -borderwidth 3

	entry $f.freq$bn -width 10 \
		-textvariable BandStack($bn,freq) \
		-background white 

	tk_optionMenu $f.bsmodemenu$bn BandStack($bn,mode) \
		AUTO NFM WFM AM

	tk_optionMenu $f.bsstep$bn BandStack($bn,step) \
		AUTO 5 6.25 10 12.5 15 20 25 30 50 100


	grid $f.lab$bn -row $bn -column 1 -sticky w
	grid $f.freq$bn -row $bn -column 2
	grid $f.bsmodemenu$bn -row $bn -sticky ew -column 3
	grid $f.bsstep$bn -row $bn -sticky ew -column 4

	return $f
}


###################################################################
# Encode the information from the data structures into
# the memory image string which can be written to the VR-120.
#
# We don't understand the meaning of all the bytes in
# the memory image.  Therefore, the
# image string must already exist and we will only
# change the bytes which we understand.
#
###################################################################
proc EncodeImage { } \
{
	global GlobalParam
	global Mimage

	if {$GlobalParam(BypassAllEncoding)} \
		{
		puts stderr "EncodeImage: skip encoding"
		return 0
		}

	# puts stderr "EncodeImage: encoding"
	if { ([info exists Mimage] == 0) } \
		{
		puts stderr "EncodeImage: image does not exist"
		return error
		}

	set image $Mimage

	set image [EncodeMisc $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeMemories $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeTV $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeSearchBanks $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeBandStack $image]
	if { [string length $image] == 0} {return error}


	set Mimage $image

	return 0
}



###################################################################
# Encode misc
# information into a memory image.
###################################################################
proc EncodeMisc { image } \
{
	global AutoOff
	global BatterySaver
	global Dial
	global Fstep
	global ImageAddr
	global GlobalParam
	global Lamp
	global LockEffect
	global Mimage
	global Mode
	global Monitor
	global Pause
	global Priority
	global PriorityMode
	global Resume
	global Step



	# Pause
	scan $ImageAddr(Pause) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $Pause($GlobalParam(Pause))]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]

	# Resume
	scan $ImageAddr(Resume) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $Resume($GlobalParam(Resume))]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]


	# Monitor flag
	scan $ImageAddr(Monitor) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $Monitor($GlobalParam(Monitor))]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]

	# Frequency Skip scan flag
	scan $ImageAddr(FrequencySkip) "%x" first
	set b [string range $image $first $first]
	set s [format "%02x" $GlobalParam(FrequencySkip)]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]


	# encode Beep tone
	scan $ImageAddr(Beep) "%x" first
	set b [string range $image $first $first]

	if { ($GlobalParam(Beep) >= 0) \
		&& ($GlobalParam(Beep) <= 31) } \
		{
		set n [expr {$GlobalParam(Beep) + 1}]
		} \
	else \
		{
		set n 0
		}

	set n [format "%02x" $n]
	set b [binary format "H2" $n]
	set image [string replace $image $first $first $b]


	# encode Auto Power Off
	scan $ImageAddr(AutoOff) "%x" first
	set byte [string index $image $first]
	set n [format "%02x" $AutoOff($GlobalParam(AutoOff))]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]

#	# encode Dial fast step
#	scan $ImageAddr(DialStep) "%x" first
#	set byte [string index $image $first]
#	set n [format "%02x" $Dial($GlobalParam(Dial))]
#	set newbyte [binary format "H2" $n]
#	set image [string replace $image $first $first $newbyte]

	# encode Lamp
	scan $ImageAddr(Lamp) "%x" first
	set byte [string index $image $first]
	set n [format "%02x" $Lamp($GlobalParam(Lamp))]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]


#	# Set VFO/Limit Search bit
#	scan $ImageAddr(FlagByte0) "%x" first
#	set byte [string index $image $first]
#	set newbyte [AssignBit $byte 3 $GlobalParam(LimitSearch)]
#	set image [string replace $image $first $first $newbyte]
#
#	# Fast Tuning Step is stored in one byte
#	scan $ImageAddr(FastTuningStep) "%x" first
#	set s $GlobalParam(FastTuningStep)
#	set s [format "%02x" $Fstep($s)]
#	set b [binary format "H2" $s]
#	set image [string replace $image $first $first $b]



	# encode Lock function effect
	scan $ImageAddr(LockEffect) "%x" first
	set byte [string index $image $first]
	set n [format "%02x" $LockEffect($GlobalParam(LockEffect))]
	set newbyte [binary format "H2" $n]
	set image [string replace $image $first $first $newbyte]


	# encode Power Saver
	scan $ImageAddr(PowerSave) "%x" first
	set s [format "%02x" $GlobalParam(PowerSave)]
	set b [binary format "H2" $s]
	set image [string replace $image $first $first $b]


	return $image
}

###################################################################
# Encode the memory channel frequency, mode, and preferential
# flag information into a memory image.
###################################################################

proc EncodeMemories { image } \
{
	global Ctcss
	global CtcssBias
	global ImageAddr
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global Mode
	global Skip
	global Step

	global Mimage
	global ImageAddr

	# Encode channel frequency.
	scan $ImageAddr(MemoryFreqs) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set b [ Freq2BCD4 $MemFreq($ch) ]

		set image [string replace $image $first $last $b]

		incr first 16
		incr last 16
		}

	# Encode channel offset frequencies.
	# and duplex/simple flags.
	scan $ImageAddr(MemoryOffset) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set b [ Offset2BCD4 $MemOffset($ch) $MemDuplex($ch) ]

		set image [string replace $image $first $last $b]

		incr first 16
		incr last 16
		}



	# Encode channel mode and CTCSS code.
	scan $ImageAddr(MemoryModes) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set b [ string index $image $first ]

		# Mode
		set m $Mode($MemMode($ch))
		set b [SetBitField $b 0 1 $m]

		# CTCSS code
		set ccode $MemToneCode($ch)
		if { [info exists Ctcss($ccode)] == 0 } \
			{
			set n 0
			} \
		else \
			{
			set n [expr {$Ctcss($ccode) - $CtcssBias}]
			}

		set b [SetBitField $b 2 7 $n]

		set image [string replace $image $first $first $b]

		incr first 16
		}



	# Encode channel Skip, Tone Squelch Flag, Tuning Step.
	scan $ImageAddr(MemorySkip) "%x" first

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set b [ string index $image $first ]

		# Skip type
		if { [info exists Skip($MemSkip($ch))] == 0 } \
			{
			set m 0
			} \
		else \
			{
			set m $Skip($MemSkip($ch))
			}

		set b [SetBitField $b 0 1 $m]

		# Tone Squelch flag
		set m $MemToneFlag($ch)
		set b [SetBitField $b 2 3 $m]

		# Tuning Step

		if { [info exists Step($MemStep($ch))] == 0 } \
			{
			set m 0
			} \
		else \
			{
			set m $Step($MemStep($ch))
			}
		set b [SetBitField $b 4 7 $m]

		set image [string replace $image $first $first $b]

		incr first 16
		}


	# Encode memory labels.
	scan $ImageAddr(MemoryLabels) "%x" first
	set last [expr {$first + 5}]

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		set b [format "%-6s" $MemLabel($ch)]

		set image [string replace $image $first $last $b]

		incr first 16
		incr last 16
		}




	# Encode empty memory channels
	set allff [Padff 16]

	scan $ImageAddr(MemoryFreqs) "%x" first
	set last [expr {$first + 15}]

	for {set ch 0} {$ch < 400} {incr ch} \
		{
		if {$MemFreq($ch) < 0.001} \
			{
			set image [string replace $image \
				$first $last $allff]
			}
		incr first 16
		incr last 16
		}

	return $image
}


###################################################################
# Encode the TV memory channel frequency
# information into a memory image.
###################################################################

proc EncodeTV { image } \
{
        global AMTV
        global AMTVMem
        global FMTVMem
	global Mimage
	global ImageAddr
	global TVOffset


	# Encode AM TV channel allocation frequency.
	scan $ImageAddr(AMTV) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set b [ Freq2BCD4TV $AMTV($ch,freq) ]

		set image [string replace $image $first $last $b]

		incr first 4
		incr last 4
		}



	# Encode AM TV channel offset flag.
	scan $ImageAddr(AMTV) "%x" first
	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set b [ string index $image $first ]
		set b [AssignBit $b 0 $AMTV($ch,offsetflag)]

		set image [string replace $image $first $first $b]

		incr first 4
		}



	# Encode AM TV channel offset amount.
	scan $ImageAddr(AMTV) "%x" first
	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set b [ string index $image $first ]

		set n $AMTV($ch,offset)
		if {[info exists TVOffset($n)]} \
			{
			set n $TVOffset($n)
			set b [SetBitField $b 1 2 $n]
			} \
		else \
			{
			set b [SetBitField $b 1 2 0]
			}

		set image [string replace $image $first $first $b]

		incr first 4
		}



	# Encode AM channel skip flag for each channel.
	scan $ImageAddr(AMTVSkip) "%x" first

	for {set ch 0} {$ch < 83} {incr ch} \
		{
		set q [expr { $ch/8} ]
		set whichbyte [ expr { $first + floor($q) } ]
		set whichbyte [ expr { int($whichbyte) } ]

		set whichbit [ expr { fmod($ch,8) } ]
		set whichbit [ expr { int($whichbit) } ]
		set whichbit [ expr { 7 - $whichbit } ]

		set b [string index $image $whichbyte]
		set b [AssignBit $b $whichbit $AMTV($ch,skip)]
#		puts stderr "ch: $ch, whichbyte: $whichbyte, whichbit: $whichbit"
		
		set image [string replace $image \
			$whichbyte $whichbyte $b]
		}



	# Encode AM memory frequency.
	scan $ImageAddr(AMTVMem) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set b [ Freq2BCD4 $AMTVMem($ch) ]

		set image [string replace $image $first $last $b]

		incr first 4
		incr last 4
		}


	# Encode FM memory frequency.
	scan $ImageAddr(FMTVMem) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 50} {incr ch} \
		{
		set b [ Freq2BCD4 $FMTVMem($ch,freq) ]

		set image [string replace $image $first $last $b]

		incr first 4
		incr last 4
		}



	# Encode FM TV memory video reverse flag.
	scan $ImageAddr(FMTVMemRev) "%x" first
	for {set ch 0} {$ch < 50} {incr ch} \
		{
		set b [ string index $image $first ]
		set b [AssignBit $b 0 $FMTVMem($ch,rev)]

		set image [string replace $image $first $first $b]

		incr first
		}



	# Encode FM TV memory subcarrier value.
	scan $ImageAddr(FMTVMemSub) "%x" first
	for {set ch 0} {$ch < 50} {incr ch} \
		{
		if { $FMTVMem($ch,freq) < .001 }  {continue}

		set n $FMTVMem($ch,sub)
		set n [expr {$n + 63}]

		set b [ string index $image $first ]
		set b [SetBitField $b 1 7 $n]

		set image [string replace $image $first $first $b]

		incr first
		}


	return $image
}


###################################################################
# Encode the Band Stack Memory channel frequency and mode
# information into a memory image.
###################################################################

proc EncodeBandStack { image } \
{

	global BandStack
	global Ctcss
	global CtcssBias
	global ImageAddr
	global MemDuplex
	global MemFreq
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global Mode
	global Skip
	global Step

	global Mimage
	global ImageAddr

	# Encode BandStack frequency.
	scan $ImageAddr(BandStackFreq) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set b [ Freq2BCD4 $BandStack($ch,freq) ]

		set image [string replace $image $first $last $b]

		incr first 10
		incr last 10
		}

#	# Encode BandStack offset frequencies.
#	# and duplex/simple flags.
#	scan $ImageAddr(BandStackOffset) "%x" first
#	set last [expr {$first + 3}]
#
#	for {set ch 0} {$ch < 11} {incr ch} \
#		{
#		set b [ Offset2BCD4 $BandStack($ch,offset) \
#			$BandStack($ch,duplex) ]
#
#		set image [string replace $image $first $last $b]
#
#		incr first 10
#		incr last 10
#		}
#
#

	# Encode BandStack mode and CTCSS code.
	scan $ImageAddr(BandStackModes) "%x" first

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set b [ string index $image $first ]

		# Mode
		set m $Mode($BandStack($ch,mode))
		set b [SetBitField $b 0 1 $m]

#		# CTCSS code
#		set ccode $BandStack($ch,tonecode)
#		if { [info exists Ctcss($ccode)] == 0 } \
#			{
#			set n 0
#			} \
#		else \
#			{
#			set n [expr {$Ctcss($ccode) - $CtcssBias}]
#			}
#
#		set b [SetBitField $b 2 7 $n]

		set image [string replace $image $first $first $b]

		incr first 10
		}



	# Encode BandStack Skip, Tone Squelch Flag, Tuning Step.
	scan $ImageAddr(BandStackSkip) "%x" first

	for {set ch 0} {$ch < 11} {incr ch} \
		{
		set b [ string index $image $first ]

#		# Skip type
#		if { [info exists Skip($BandStack($ch,skip))] == 0 } \
#			{
#			set m 0
#			} \
#		else \
#			{
#			set m $Skip($BandStack($ch,skip))
#			}
#
#		set b [SetBitField $b 0 1 $m]
#
#		# Tone Squelch flag
#		set m $BandStack($ch,toneflag)
#		set b [SetBitField $b 2 3 $m]

		# Tuning Step

		if { [info exists Step($BandStack($ch,step))] == 0 } \
			{
			set m 0
			} \
		else \
			{
			set m $Step($BandStack($ch,step))
			}
		set b [SetBitField $b 4 7 $m]

		set image [string replace $image $first $first $b]

		incr first 10
		}



	return $image
}


###################################################################
# Encode the limit search bank frequencies and modes
# information into a memory image.
###################################################################

proc EncodeSearchBanks { image } \
{
	global Ctcss
	global CtcssBias
	global ImageAddr
	global LimitScan
	global Mode
	global Skip
	global Step

	global Mimage
	global ImageAddr

	# Encode lower frequency.
	scan $ImageAddr(SearchFreqFirst) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		set b [ Freq2BCD4 $LimitScan($ch,lower) ]

		set image [string replace $image $first $last $b]

		incr first 32
		incr last 32
		}


	# Encode upper frequency.
	scan $ImageAddr(SearchFreqSecond) "%x" first
	set last [expr {$first + 3}]

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		set b [ Freq2BCD4 $LimitScan($ch,upper) ]

		set image [string replace $image $first $last $b]

		incr first 32
		incr last 32
		}

#	# Encode channel offset frequencies.
#	# and duplex/simplex flags.
#	scan $ImageAddr(MemoryOffset) "%x" first
#	set last [expr {$first + 2}]
#
#	for {set ch 0} {$ch < 400} {incr ch} \
#		{
#		set b [ Offset2BCD $MemOffset($ch) $MemDuplex($ch) ]
#
#		set image [string replace $image $first $last $b]
#
#		incr first 8
#		incr last 8
#		}
#


	# Encode lower search limit mode.
	scan $ImageAddr(SearchModeFirst) "%x" first

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		set b [ string index $image $first ]

		# Mode
		set m $Mode($LimitScan($ch,lmode))
		set b [SetBitField $b 0 1 $m]
		set image [string replace $image $first $first $b]

		incr first 32
		}


	# Encode upper search limit mode.
	scan $ImageAddr(SearchModeSecond) "%x" first

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		set b [ string index $image $first ]

		# Mode
		set m $Mode($LimitScan($ch,umode))
		set b [SetBitField $b 0 1 $m]
		set image [string replace $image $first $first $b]

		incr first 32
		}



	# Encode lower search limit Tuning Step.
	scan $ImageAddr(SearchStepFirst) "%x" first

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		set b [ string index $image $first ]

		# Tuning Step

		if { [info exists Step($LimitScan($ch,lstep))] == 0 } \
			{
			set m 0
			} \
		else \
			{
			set m $Step($LimitScan($ch,lstep))
			}
		set b [SetBitField $b 4 7 $m]

		set image [string replace $image $first $first $b]

		incr first 32
		}


	# Encode upper search limit Tuning Step.
	scan $ImageAddr(SearchStepSecond) "%x" first

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		set b [ string index $image $first ]

		# Tuning Step

		if { [info exists Step($LimitScan($ch,ustep))] == 0 } \
			{
			set m 0
			} \
		else \
			{
			set m $Step($LimitScan($ch,ustep))
			}
		set b [SetBitField $b 4 7 $m]

		set image [string replace $image $first $first $b]

		incr first 32
		}



	# Encode empty search limits
	set allff [Padff 16]

	scan $ImageAddr(SearchFreqFirst) "%x" first
	set last [expr {$first + 15}]

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		if {$LimitScan($ch,lower) < 0.001} \
			{
			set image [string replace $image \
				$first $last $allff]
			}
		incr first 32
		incr last 32
		}


	scan $ImageAddr(SearchFreqSecond) "%x" first
	set last [expr {$first + 15}]

	for {set ch 0} {$ch < 25} {incr ch} \
		{
		if {$LimitScan($ch,upper) < 0.001} \
			{
			set image [string replace $image \
				$first $last $allff]
			}
		incr first 32
		incr last 32
		}


	return $image
}


###################################################################
# Pop up a window which says "Please wait..."
###################################################################
proc MakeWait { } \
{
	global DisplayFontSize


	toplevel .wait

	set w .wait
	wm title $w "tk3 running"

	label $w.lab -font $DisplayFontSize -text "Please wait ..."

	pack $w.lab

	update idletasks
	waiter 500
	return
}

###################################################################
# Kill the window which says "Please wait..."
###################################################################
proc KillWait { } \
{
	catch {destroy .wait}
	update idletasks
}

###################################################################
# ValidateData tests the data.
# It pops up a window with error and/or warning messages.
# If there are warnings but no errors, the user can elect
# to continue or cancel the current operation.
#
# Returns:
#	0	- continue
#	1	- cancel the current operation
###################################################################
proc ValidateData { } \
{
	global Band
	global BandStack
	global Emsg
	global AMTV
	global AMTVMem
	global FMTVMem
	global GlobalParam
	global MemFreq
	global MemMode
	global LimitScan
	global Priority
	global PriorityMode
	global Skip


	if {[info exists MemFreq(0)] == 0} \
		{
		set msg "You must open a file\n"
		append msg " or read data from the radio\n"
		append msg "before validating.\n"

		tk_dialog .nodata "No data" \
			$msg info 0 OK
		return 1
		}


	set Emsg ""
	set nerror 0
	set nwarning 0

	# Memory channels.
	set ch 0
	for {set bn 0} {$bn < 8} {incr bn} \
		{
		for {set i 0} {$i < 40} {incr i} \
			{
			set m "Bank $bn Ch. $i"
			set f $MemFreq($ch)
	
			set code [ValidateFreq $f $m]
			if {$code == "error"} { incr nerror } \
			elseif {$code == "warning"} { incr nwarning }
	
			set f $MemMode($ch)
			set code [ValidateMode $f $m]
			if {$code == "error"} { incr nerror }
	
			if { [expr {$nerror + $nwarning}] > 5} {break}
			incr ch
			}
		}

#	puts stderr "ValidateData: done with memories"



	# Limit scan
	for {set i 0} {$i < 25} {incr i} \
		{
		set m "Limit Scan bank PROG$i lower"
		set f $LimitScan($i,lower)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set m "Limit Scan bank PROG$i upper"
		set f $LimitScan($i,upper)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}



	# BandStack frequencies
	for {set i 0} {$i < 11} {incr i} \
		{
		set m "Band Stacking "
		append m "$Band(USA,$i,low) - $Band(USA,$i,high)"
		set f $BandStack($i,freq)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}




	# AM TV channel frequencies
	for {set i 0} {$i < 83} {incr i} \
		{
		set j $i
		incr j
		set m "AM TV channel $j:"
		set f $AMTV($i,freq)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}


	# AM TV Memory frequencies
	for {set i 0} {$i < 10} {incr i} \
		{
		set m "AM TV Memory $i:"
		set f $AMTVMem($i)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}


	# FM TV Memory frequencies
	for {set i 0} {$i < 50} {incr i} \
		{
		set m "FM TV Memory $i:"
		set f $FMTVMem($i,freq)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}

	# FM TV memory subcarrier value
	for {set i 0} {$i < 50} {incr i} \
		{
		set m "FM TV memory $i:"
		if { $FMTVMem($i,freq) < .001 } {continue}
			
		set sub $FMTVMem($i,sub)
		if {($sub < -63) || ($sub > 63)} \
			{
			incr nerror
			append Emsg "\nError: $m subcarrier must"
			append Emsg " be in range -63 to 63.\n"
			}
		if { [expr {$nerror + $nwarning}] > 5} {break}
		}

	if {$nerror} \
		{
		tk_dialog .baddata1 "tk3 Invalid data" \
			$Emsg error 0 OK
		# puts stderr "ValidateData: returning 1"
		return 1
		}
	if {$nwarning} \
		{
		set response [tk_dialog .baddata2 \
			"tk3 Data warning" \
			$Emsg error 0 Cancel Continue]

		if {$response == 0} then {return 1} \
		else {return 0}
		}

	
	return 0
}

###################################################################
# Check a frequency for validity.
# Append the error or warning message to a global string.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateFreq {f m} \
{
	global Emsg
	global GlobalParam

	set code 0
	set msg ""

	if {( ($f != "") && ($f != 0.0) ) \
		&& (($f < $GlobalParam(LowestFreq)) \
		|| ($f > $GlobalParam(HighestFreq)))} \
		{
		append msg "\nError: $m frequency ($f) is out"
		append msg " of range.\n"
		set code error
		}


	append Emsg $msg
	return $code
}

###################################################################
# Return 1 if a string consists of 2 hex digits.
###################################################################
proc IsHex { s } \
{
	# Check for non-digit and non decimal point chars.
	set rc [regexp -nocase {^[0-9a-f][0-9a-f]$} $s]
	if {$rc} \
		{
		return 1
		} \
	else \
		{
		return 0
		}
}

###################################################################
# Check a mode for validity.
# Append the error message to a global string.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateMode {mode m} \
{
	global Emsg
	global Mode

	set code 0

	if { [info exists Mode($mode)] == 0} \
		{
		append Emsg "\nError: $m mode ($mode) is invalid.\n"
		set code error
		} 

	return $code
}

###################################################################
# Set title of the main window so it contains the
# current template file name.
###################################################################
proc SetWinTitle { } \
{
	global GlobalParam

	if { ( [info exists GlobalParam(TemplateFilename)] == 0 ) \
		|| ($GlobalParam(TemplateFilename) == "") } \
		{
		set filename untitled.tr3
		} \
	else \
		{
		set filename $GlobalParam(TemplateFilename)
		}

	set s [format "%s - tk3" $filename]
	wm title . $s

	return
}


# Prevent user from shrinking or expanding window.

proc FixSize { w } \
{
	wm minsize $w [winfo width $w] [winfo height $w]
	wm maxsize $w [winfo width $w] [winfo height $w]

	return
}

proc DecodeFlagByte3 { image } \
{
	global GlobalParam
	global ImageAddr

	# Parse 1A11
	scan $ImageAddr(FlagByte3) "%x" first
	set s [string range $image $first $first]
	set t [Char2Int $s]
	set GlobalParam(1A11) [format "%02x" $t]
	update idletasks

	return
}

######################################################################
#					Bob Parnass
#					DATE:
#
# USAGE:	SortaBank first last
#
# INPUTS:
#		first	-starting channel to sort
#		last	-ending channel to sort
#
# RETURNS:
#		0	-ok
#		-1	-error
#
#
# PURPOSE:	Sort a range of memory channels based on frequency.
#
# DESCRIPTION:
#
######################################################################
proc SortaBank { first last } \
{
	global GlobalParam
	global MemDuplex
	global MemFreq
	global MemLabel
	global MemMode
	global MemOffset
	global MemSkip
	global MemStep
	global MemToneCode
	global MemToneFlag
	global Mimage


	if {[info exists Mimage] == 0} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before sorting channels.\n"

		tk_dialog .nodata "No data" \
			$msg info 0 OK
		return -1
		}


	if {$GlobalParam(SortType) == "freq"} \
		{
		set inlist [Bank2List MemFreq $first $last]
		set vorder [SortFreqList $inlist]
		} \
	else \
		{
		set inlist [Bank2List MemLabel $first $last]
		set vorder [SortLabelList $inlist]
		}


	set inlist [Bank2List MemFreq $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemFreq($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemMode $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemMode($i) [lindex $slist $j]
		if {$MemMode($i) == ""} \
			{
			set MemMode($i) NFM
			}
		}

	set inlist [Bank2List MemDuplex $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemDuplex($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemOffset $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemOffset($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemSkip $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemSkip($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemToneCode $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemToneCode($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemToneFlag $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemToneFlag($i) [lindex $slist $j]
		}


	set inlist [Bank2List MemStep $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemStep($i) [lindex $slist $j]
		}


	set inlist [Bank2List MemLabel $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemLabel($i) [lindex $slist $j]
		}


	return 0
}


proc ClearAllChannels { } \
{
	global Cht
	global GlobalParam
	global Mimage
	global MemFreq
	global MemSkip
	global NBanks
	global NChanPerBank


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		# No image to write.
		set msg "You must first read template data from"
		append msg " the radio or open a file before"
		append msg " clearing memories."

		tk_dialog .error "Clear all channels" $msg error 0 OK
		return
		}


	set msg "Warning: This operation will clear all "
	append msg "memory channels."

	set result [tk_dialog .clearall "Warning" \
		$msg warning 0 Cancel "Clear Memories" ]

	if {$result == 0} {return}

	set n [expr {$NBanks * $NChanPerBank}]

	for {set ch 0} {$ch < $n} {incr ch} \
		{
		set MemFreq($ch) 0.0
		}

	ShowChannels $Cht
	return

}

#
####################################################################
## Create a list of duplicate frequencies.
##
## Check for the same frequency stored in more than
## one memory channel.
##
## Returns:
##	A sorted list of duplicate frequencies.
##	Each element consists of an informative text string containing
##	the frequency and the bank and channel numbers which
##	contain that frequency.
##
####################################################################
#proc ListDuplicate { } \
#{
#	global MemFreq
#	global NBanks
#	global NChanPerBank
#
#	# For each non-zero frequency contained in any memory
#	# channel, create a list of channels which are
#	# programmed with that frequency.
# 
#	for {set bn 0} {$bn < $NBanks} {incr bn} \
#		{
#		set ch [expr {$bn * 50}]
#		for {set i 0} {$i < $NChanPerBank} {incr i} \
#			{
#			if { ([info exists MemFreq($ch)]) } \
#				{
#				set f $MemFreq($ch)
#				if {$f > .001} \
#					{
#					set s [format "(bank %2d, ch %2d) " $bn $i]
#					lappend ChList($f) $s
#					set FreqExists($f) 1
#					}
#				}
#			incr ch
#			}
#		}
#
#	set duplist [list]
#
#	foreach f [ array names FreqExists ] \
#		{
#		set m ""
#		# puts stderr "$f, channels: $ChList($f)"
#		if { [llength $ChList($f)] > 1 } \
#			{
#			# Frequency is a duplicate.
#			append m [format "%10s: " $f]
#			set n [llength $ChList($f)]
#
#			for {set i 0} {$i < $n} {incr i} \
#				{
#				append m [lindex $ChList($f) $i]
#				}
#			lappend duplist $m 
#			}
#		}
#	set duplist [lsort $duplist]
#	return $duplist
#}
#
####################################################################
## Display a popup window of duplicate frequencies.
####################################################################
#proc CkDuplicate { } \
#{
#	global Mimage
#
#	if {[info exists Mimage] == 0} \
#		{
#		set msg "You must open a file\n"
#		append msg " or read data from the radio before\n"
#		append msg " checking for duplicate frequencies.\n"
#
#		tk_dialog .nodata "No data" \
#			$msg info 0 OK
#		return -1
#		}
#
#
#
#	set duplist [ListDuplicate]
#	if { [llength $duplist] } \
#		{
#		catch {destroy .dup}
#		toplevel .dup
#
#		label .dup.lab -text "Duplicate Frequencies in Memory"
#
#		set dupes [ List_channels .dup.f \
#			$duplist 30 ]
#
#		button .dup.dismiss -text "Dismiss" \
#			-command "destroy .dup"
#
#		wm title .dup "Duplicate Frequencies"
#		pack .dup.lab .dup.f .dup.dismiss -side top \
#			-padx 3 -pady 3
#		wm deiconify .dup
#		$dupes activate 1
#		}
#	return
#}
