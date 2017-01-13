#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

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


######################################################################
# NOTES:
#	There are 2 levels of data structures within this
#	program:
#
#	(1) Mimage - an 8064 byte string stored in binary format
#		It must be converted to ASCII for reading and
#		writing to the radio.
#
#	(2) Arrays containing memory channel and configuration
#		information.
#
#
#	The memory image Mimage string becomes populated in these
#	scenarios:
#
#		- image data is read from the radio
#		- image data is read from a .tk3 or other file
#		- array data is encoded into the image
#			prior to writing the image to the radio
#
#	Some or all of the arrays become populated in these
#	scenarios:
#
#		- by parsing the memory image string
#		- by importing memory channel info from a .csv file
#		- by a user changing widget values in the GUI
#
# Most of the protocol and memory image layout information
# used in this software was obtained from Irwin Shapiro
# and a document entitled
# "Cloning ICOM Receivers, Using the ICOM IC-R2 Handheld
# Scanner as an example," by BlakkeKatte@yahoo.co.uk.
# It is available for download at http://uk.geocities.com/blakkekatte
#
######################################################################

######################################################################
# Write error messages to stderr if linux/unix, stdout otherwise
######################################################################

proc Tattle { msg } \
{
	global tcl_platform

	 set platform $tcl_platform(os) 
	 switch -glob $platform \
		{
		{[Ll]inux} \
			{
			puts stderr $msg
			}
		{unix} \
			{
			puts stderr $msg
			}
		default \
			{
			puts $msg
			}
		}

	return
}
############################################################
set Version "0.4"

set AboutMsg  "tk3
version $Version

Copyright 2001, 2002, Bob Parnass
Oswego, Illinois
USA
bob@parnass.com

Released under the GNU General Public License.

tk3 is a utility program for the
ICOM IC-R3 receiver.
This is beta software. If you find a defect,
please report it."

############################################################

# trace variable Sid r {puts stderr "Sid trace trap"}
set Pgm [lindex [split $argv0 "/"] end]
set Lfilename ""

if { [catch {set Libdir $env(tk3)} ] } \
	{
	Tattle "$Pgm: error: Environment variable tk3 must"
	Tattle "be set to the directory containing the library"
	Tattle "files for program $Pgm."
	exit 1
	}

set ScanFlag 0


# Sanity check for the Libdir environment variable.
if {$Libdir == ""}\
	{
	Tattle "$Pgm: error: Environment variable tk3 must"
	Tattle "be set to the directory containing the library"
	Tattle "files for program $Pgm."
	exit 1
	}

source [ file join $Libdir "misclib.tcl" ]
source [ file join $Libdir "mylib.tcl" ]
source [ file join $Libdir "api3.tcl" ]
source [ file join $Libdir "gui3.tcl" ]

SetUp


SetWinTitle

set lst [ InitStuff ]
set Rcfile [ lindex $lst 0 ]
set LabelFile [ lindex $lst 1 ]

FirstTimeCheck $Rcfile

# Set most global variables from configuration file.

PresetGlobals
ReadSetup
OverrideGlobals



set CancelXfer 0

set FileTypes \
	{
	{"IC-R3 data files"           {.csv .txt}     }
	}


# Create graphical widgets.

MakeGui

update idletasks
