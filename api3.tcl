####################################################################
# This file is part of tk3, a utility program for the
# ICOM IC-R3 receiver.
# 
#    Copyright (C) 2001, 2002, Bob Parnass
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
####################################################################

set RadioAddress	EE
set RadioAddressHex	\xEE
set PCAddress		EF
set PCAddressHex	\xEF

set Nmessages		504
set BytesPerMessage	32
set NBanks		8
set NChanPerBank	50
set VNChanPerBank	50
set ChanNumberRepeat	yes
set HasLabels           yes

###################################################################
# Starting address (in hexadecimal) for each field in
# the memory image.
###################################################################

set ImageAddr(MemoryFreqs)		00  ;# to C7F
set ImageAddr(MemoryDuplex)		04
set ImageAddr(MemoryOffset)		04
set ImageAddr(MemoryModes)		08
set ImageAddr(MemoryToneCode)		08
set ImageAddr(MemoryToneFlag)		09
set ImageAddr(MemorySkip)		09
set ImageAddr(MemorySteps)		09
set ImageAddr(MemoryLabels)		0A  ;# 6 chars each
set ImageAddr(SearchFreqFirst)		1900
set ImageAddr(SearchModeFirst)		1908
set ImageAddr(SearchStepFirst)		1909
set ImageAddr(SearchFreqSecond)		1910
set ImageAddr(SearchModeSecond)		1918
set ImageAddr(SearchStepSecond)		1919
set ImageAddr(BandStackFreq)		1C20 ;# 1F40, 10 of them
set ImageAddr(BandStackDuplex)		1C24
set ImageAddr(BandStackOffset)		1C24
set ImageAddr(BandStackModes)		1C28 ;# 10 of them
set ImageAddr(BandStackToneCode)	1C28
set ImageAddr(BandStackSkip)		1C29
set ImageAddr(BandStackToneFlag)	1C29
set ImageAddr(BandStackSteps)		1C29
set ImageAddr(AMTV)			1C98 ;# AM TV channels 1-83
set ImageAddr(AMTVMem)			1DE4 ;# AM TV memories 0 -9
set ImageAddr(FMTVMem)			1E0C ;# FM TV memories 0 - 49
set ImageAddr(FMTVMemRev)		1ED4 ;# FM TV reverse video
set ImageAddr(FMTVMemSub)		1ED4 ;# FM TV subcarriers 0 - 49
set ImageAddr(AMTVSkip)			1F10 ;# 1 bit for each channel
set ImageAddr(Resume)			1F22
set ImageAddr(Pause)			1F23
set ImageAddr(FrequencySkip)		1F24
set ImageAddr(Beep)			1F26
set ImageAddr(Lamp)			1F27
set ImageAddr(AutoOff)			1F28
set ImageAddr(PowerSave)		1F29
set ImageAddr(Monitor)			1F2A
set ImageAddr(LockEffect)		1F2D
set ImageAddr(UserComment)		1F60
set ImageAddr(FileVersion)		1F70

set ImageAddr(DialStep)			0E60
set ImageAddr(BankScan)			0E65
set ImageAddr(DialAccel)		0E6D


set Band(USA,0,low)		.495
set Band(USA,0,high)		1.620
set Band(USA,1,low)		1.625
set Band(USA,1,high)		29.995
set Band(USA,2,low)		30.000
set Band(USA,2,high)		75.995
set Band(USA,3,low)		76.000	;# Euro models
set Band(USA,3,high)		107.995	;# Euro models
set Band(USA,4,low)		108.000
set Band(USA,4,high)		135.995
set Band(USA,5,low)		136.000
set Band(USA,5,high)		255.095
set Band(USA,6,low)		255.100
set Band(USA,6,high)		382.095
set Band(USA,7,low)		382.100
set Band(USA,7,high)		769.795
set Band(USA,8,low)		769.800
set Band(USA,8,high)		960.095
set Band(USA,9,low)		960.100
set Band(USA,9,high)		1399.995
set Band(USA,10,low)		1400.000
set Band(USA,10,high)		2450.095

##########################################################
# Translation tables
##########################################################

set LockEffect(NORMAL)	0
set LockEffect(NO_SQL)	1
set LockEffect(NO_VOL)	2
set LockEffect(ALL)	3

set RLockEffect(0)	NORMAL
set RLockEffect(1)	NO_SQL
set RLockEffect(2)	NO_VOL
set RLockEffect(3)	ALL


set TVOffset(+3MHz)	0
set TVOffset(+2MHz)	1
set TVOffset(-3MHz)	2
set TVOffset(-2MHz)	3

set RTVOffset(0)	+3MHz
set RTVOffset(1)	+2MHz
set RTVOffset(2)	-3MHz
set RTVOffset(3)	-2MHz

# Lamp operation
set Lamp(OFF)	0
set Lamp(ON)	1
set Lamp(AUTO)	2

set RLamp(0)	OFF
set RLamp(1)	ON
set RLamp(2)	AUTO

# Dial select
set Dial(100kHz)	0
set Dial(1MHz)		1
set Dial(10MHz)		2

set RDial(0)	100kHz
set RDial(1)	1MHz
set RDial(2)	10MHz

# Monitor key
set Monitor(PUSH)	0
set Monitor(HOLD)	1

set RMonitor(0)	PUSH
set RMonitor(1)	HOLD

# Auto Power Off

set AutoOff(OFF)	0
set AutoOff(30)		1	
set AutoOff(60)		2
set AutoOff(90)		3
set AutoOff(120)	4

set RAutoOff(0)		OFF
set RAutoOff(1)		30
set RAutoOff(2)		60
set RAutoOff(3)		90
set RAutoOff(4)		120


# Scan Pause
set Pause(2)	0
set Pause(4)	1
set Pause(6)	2
set Pause(8)	3
set Pause(10)	4
set Pause(12)	5
set Pause(14)	6
set Pause(16)	7
set Pause(18)	8
set Pause(20)	9
set Pause(HOLD)	10

set RPause(0)	2
set RPause(1)	4
set RPause(2)	6
set RPause(3)	8
set RPause(4)	10
set RPause(5)	12
set RPause(6)	14
set RPause(7)	16
set RPause(8)	18
set RPause(9)	20
set RPause(10)	HOLD



# Scan Resume
set Resume(0)		0
set Resume(1)		1
set Resume(2)		2
set Resume(3)		3
set Resume(4)		4
set Resume(5)		5
set Resume(HOLD)	6

set RResume(0)	0
set RResume(1)	1
set RResume(2)	2
set RResume(3)	3
set RResume(4)	4
set RResume(5)	5
set RResume(6)	HOLD


set Step(5)		"0"
set Step(6.25)		"1"
set Step(10)		"2"
set Step(12.5)		"3"
set Step(15)		"4"
set Step(20)		"5"
set Step(25)		"6"
set Step(30)		"7"
set Step(50)		"8"
set Step(100)		"9"
set Step(AUTO)		"10"

set RStep(0)		"5"
set RStep(1)		"6.25"
set RStep(2)		"10"
set RStep(3)		"12.5"
set RStep(4)		"15"
set RStep(5)		"20"
set RStep(6)		"25"
set RStep(7)		"30"
set RStep(8)		"50"
set RStep(9)		"100"
set RStep(10)		"AUTO"

set Mode(M0) "0"
set Mode(M7) "7"
set Mode(M8) "8"
set Mode(M9) "9"
set Mode(MA) "A"
set Mode(MB) "B"
set Mode(MC) "C"
set Mode(MD) "D"
set Mode(ME) "E"
set Mode(MF) "F"

set Mode(NFM) "0"
set Mode(WFM) "1"
set Mode(AM) "2"
set Mode(AUTO) "3"

set RMode(0) NFM
set RMode(1) WFM
set RMode(2) AM
set RMode(3) AUTO

set Skip(scan)	0
set Skip(pskip)	1
set Skip(skip)	2

set RSkip(0)	" "
set RSkip(1)	pskip
set RSkip(2)	skip

##########################################################
# Encoding in a .ICF file.
##########################################################
set Icf2Hex(g)	0
set Icf2Hex(h)	1
set Icf2Hex(i)	2
set Icf2Hex(j)	3
set Icf2Hex(k)	4
set Icf2Hex(l)	5
set Icf2Hex(m)	6
set Icf2Hex(n)	7
set Icf2Hex(o)	8
set Icf2Hex(p)	9
set Icf2Hex(x)	a
set Icf2Hex(y)	b
set Icf2Hex(z)	c
set Icf2Hex({)	d
set Icf2Hex(|)	e
set Icf2Hex(})	f

set Hex2Digit(30)	0
set Hex2Digit(31)	1
set Hex2Digit(32)	2
set Hex2Digit(33)	3
set Hex2Digit(34)	4
set Hex2Digit(35)	5
set Hex2Digit(36)	6
set Hex2Digit(37)	7
set Hex2Digit(38)	8
set Hex2Digit(39)	9
set Hex2Digit(41)	A
set Hex2Digit(42)	B
set Hex2Digit(43)	C
set Hex2Digit(44)	D
set Hex2Digit(45)	E
set Hex2Digit(46)	F

set Digit2Hex(0)	30
set Digit2Hex(1)	31
set Digit2Hex(2)	32
set Digit2Hex(3)	33
set Digit2Hex(4)	34
set Digit2Hex(5)	35
set Digit2Hex(6)	36
set Digit2Hex(7)	37
set Digit2Hex(8)	38
set Digit2Hex(9)	39
set Digit2Hex(A)	41
set Digit2Hex(B)	42
set Digit2Hex(C)	43
set Digit2Hex(D)	44
set Digit2Hex(E)	45
set Digit2Hex(F)	46

# CTCSS codes (there are 50 codes total)
set CtcssBias		0

set Ctcss(0.0)		0
set Ctcss(67.0)		0
set Ctcss(69.3)		1
set Ctcss(71.9)		2
set Ctcss(74.4)		3
set Ctcss(77.0)		4
set Ctcss(79.7)		5

set Ctcss(82.5)		6
set Ctcss(85.4)		7
set Ctcss(88.5)		8
set Ctcss(91.5)		9
set Ctcss(94.8)		10
set Ctcss(97.4)		11
set Ctcss(100.0)	12
set Ctcss(103.5)	13
set Ctcss(107.2)	14
set Ctcss(110.9)	15

set Ctcss(114.8)	16
set Ctcss(118.8)	17
set Ctcss(123.0)	18
set Ctcss(127.3)	19
set Ctcss(131.8)	20
set Ctcss(136.5)	21
set Ctcss(141.3)	22
set Ctcss(146.2)	23
set Ctcss(151.4)	24
set Ctcss(156.7)	25

set Ctcss(159.8)	26
set Ctcss(162.2)	27
set Ctcss(165.5)	28
set Ctcss(167.9)	29
set Ctcss(171.3)	30
set Ctcss(173.8)	31
set Ctcss(177.3)	32
set Ctcss(179.9)	33
set Ctcss(183.5)	34
set Ctcss(186.2)	35

set Ctcss(189.9)	36
set Ctcss(192.8)	37
set Ctcss(196.6)	38
set Ctcss(199.5)	39
set Ctcss(203.5)	40
set Ctcss(206.5)	41
set Ctcss(210.7)	42
set Ctcss(218.1)	43
set Ctcss(225.7)	44
set Ctcss(229.1)	45

set Ctcss(233.6)	46
set Ctcss(241.8)	47
set Ctcss(250.3)	48
set Ctcss(254.1)	49


set RCtcss(0)	67.0
set RCtcss(1)	69.3
set RCtcss(2)	71.9
set RCtcss(3)	74.4
set RCtcss(4)	77.0
set RCtcss(5)	79.7
set RCtcss(6)	82.5
set RCtcss(7)	85.4
set RCtcss(8)	88.5
set RCtcss(9)	91.5

set RCtcss(10)	94.8
set RCtcss(11)	97.4
set RCtcss(12)	100.0
set RCtcss(13)	103.5
set RCtcss(14)	107.2
set RCtcss(15)	110.9
set RCtcss(16)	114.8
set RCtcss(17)	118.8
set RCtcss(18)	123.0
set RCtcss(19)	127.3

set RCtcss(20)	131.8
set RCtcss(21)	136.5
set RCtcss(22)	141.3
set RCtcss(23)	146.2
set RCtcss(24)	151.4
set RCtcss(25)	156.7
set RCtcss(26)	159.8
set RCtcss(27)	162.2
set RCtcss(28)	165.5
set RCtcss(29)	167.9

set RCtcss(30)	171.3
set RCtcss(31)	173.8
set RCtcss(32)	177.3
set RCtcss(33)	179.9
set RCtcss(34)	183.5
set RCtcss(35)	186.2
set RCtcss(36)	189.9
set RCtcss(37)	192.8
set RCtcss(38)	196.6
set RCtcss(39)	199.5

set RCtcss(40)	203.5
set RCtcss(41)	206.5
set RCtcss(42)	210.7
set RCtcss(43)	218.1
set RCtcss(44)	225.7
set RCtcss(45)	229.1
set RCtcss(46)	233.6
set RCtcss(46)	241.8
set RCtcss(48)	250.3
set RCtcss(49)	254.1

##########################################################
#
# Initialize a few global variables.
#
# Return the pathname to a configuration file in the user's
# HOME directory
#
# Returns:
#	list of 2 elements:
#		-name of configuration file
#		-name of label file
#
##########################################################
proc InitStuff { } \
{
	global argv0
	global DisplayFontSize
	global env
	global Home
	global Pgm
	global RootDir
	global tcl_platform


	set platform $tcl_platform(platform) 
	switch -glob $platform \
		{
		{unix} \
			{
			set Home $env(HOME)
			set rcfile [format "%s/.tk3rc" $Home]
			set labelfile [format "%s/.tk3la" $Home]

			set DisplayFontSize "Courier 56 bold"
			}
		{macintosh} \
			{

			# Configuration file should be
			# named $HOME/.tk3rc

			# Use forward slashes within Tcl/Tk
			# instead of colons.

			set Home $env(HOME)
			regsub -all {:} $Home "/" Home
			set rcfile [format "%s/.tk3rc" $Home]
			set labelfile [format "%s/.tk3la" $Home]

			# The following font line may need changing.
			set DisplayFontSize "Courier 56 bold"
			}
		{windows} \
			{

			# Configuration file should be
			# named $tk3/tk3.ini
			# Use forward slashes within Tcl/Tk
			# instead of backslashes.

			set Home $env(tk3)
			regsub -all {\\} $Home "/" Home
			set rcfile [format "%s/tk3.ini" $Home]
			set labelfile [format "%s/tk3.lab" $Home]

			set DisplayFontSize "Courier 28 bold"
			}
		default \
			{
			puts "Operating System $platform not supported."
			exit 1
			}
		}
	set Home $env(HOME)
	# set Pgm [string last "/" $argv0]


	set lst [list $rcfile $labelfile]
	return $lst
}

###################################################################
# Disable computer control of radio.
###################################################################
proc DisableCControl { } \
{
	global Sid

	after 500

	close $Sid
	return
}

##########################################################
# Copy memory image to radio
#
# Returns:
#	0	-ok
#	1	-error
#	2	-error, cannot read radio version info
##########################################################
proc WriteImage { }\
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Sid

	set totmsgs $Nmessages


	set s [GetModelInfo]
	binary scan $s "H*" x
	set GlobalParam(RadioVersion) $x

	if {$GlobalParam(RadioVersion) == ""} \
		{
		# Error while asking radio for version info.
		return 2
		}
	# Create and display progress bar.
	toplevel .pbw
	wm title .pbw "Writing to radio"
	grab set .pbw
	set p [MakeWaitWindow .pbw.g 0 PaleGreen]
	set pc 0
	gauge_value $p $pc
	update


	set db 0


	# Write "clone in mode" command, including
	# radio version information.

	SendCloneIn

	set bptr 0
	set maddr 0

	# For each message.
	for {set i 0} {$i < $Nmessages} {incr i} \
		{
		# Variable line containes info in the format it
		# will be written to the radio.
		set line ""

		# Variable bline contains packed hex gulp.
		set bline ""

		# A message sent to the radio consists of:
		# E4 - Payload Data Command code
		# Memory Gulp (unpacked so 2 bytes represent 1 byte):
		#
		# memory address (4 bytes unpacked)
		# number of bytes (2 bytes unpacked)
		# image data (32 bytes unpacked)

		append line [binary format "H2" E4 ]

		# Memory address
		set hmaddr [format "%04x" $maddr]
		set bmaddr [binary format "H4" $hmaddr]
		append bline $bmaddr

		# Byte count
		set hn [binary format "H2" 10]
		append bline $hn

		# Copy the next chunk of the image

		set end [expr {$bptr + 15}]
		set s [string range $Mimage $bptr $end]
		append bline $s

		#
		# Calulate and append the checksum byte
		#

		# Checksum is decimal.
		set cksum [CalcCheckSum $bline]

		# Convert checksum to hexadecimal.
		set hcksum [format "%02x" $cksum]

		set bcksum [binary format "H2" $hcksum ]

		append bline $bcksum

		# Unpack the binary stuff.
		# This makes it twice as long.

		set msg [DumpBinary $bline]

		# puts stderr "WriteImage: before packing:\n$msg\n"
		set ubuf [UnpackString $bline]
		append line $ubuf

		SendCmd $Sid $line

		# Read back the message we just sent to "clean out"
		# the serial buffers.
		# If we don't do this, WindowsXP will hang after
		# the download to the radio is completed.


		if { [ReadEcho $line] } \
			{
			# Error.
			# We did not read back what we wrote.
			puts stderr "WriteImage: Error while reading echo from message $i."
			# Data xfer suceeded.
			# Zap the progress bar.
			grab release .pbw
			catch {destroy .pbw}

			return 1
			}

		incr bptr 16
		incr maddr 16

		# Update progress bar widget.
		set pc [ expr $i * 100 / $totmsgs ]
		if {$pc >= 100.0} \
			{
			set pc 99
			}
		gauge_value $p $pc
		}


	SendTermination
	if {[GetTerminationResult]} \
		{
		# Data xfer failed.
		# Zap the progress bar.
		grab release .pbw
		catch {destroy .pbw}

		# Data xfer suceeded.
		# Zap the progress bar.
		grab release .pbw
		catch {destroy .pbw}
		return 1
		}

	# Data xfer suceeded.
	# Zap the progress bar.
	grab release .pbw
	catch {destroy .pbw}

	return 0
}


##########################################################
# Copy memory image from radio
##########################################################
proc ReadImage { } \
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Pgm
	global Sid

	set code 0


	set s [GetModelInfo]
	binary scan $s "H*" x
	set GlobalParam(RadioVersion) $x

	if {$GlobalParam(RadioVersion) == ""} \
		{
		# Error while asking radio for version info.
		return 2
		}

	# Create and display progress bar.
	toplevel .pbw
	wm title .pbw "Reading IC-R2"
	grab set .pbw
	set p [MakeWaitWindow .pbw.g 0 PaleGreen]
	set pc 0
	gauge_value $p $pc
	update


	set Mimage ""

	SendCloneOut

	# For each message.
	for {set i 0} {$i < 1000} {incr i} \
		{
		set line [ReadXferRx]
		set len [string length $line]

#		puts stderr "ReadImage: i= $i, len= $len"

		# Update progress bar widget.
		set pc [ expr {$i * 100 / $Nmessages} ]
		if {$pc >= 100.0} \
			{
			set pc 99
			}
		gauge_value $p $pc

		set cc [string range $line 0 0]
		binary scan $cc "H2" s
		# Examine the command code byte.
		if { [string compare -nocase -length 1 $cc \xe5] == 0} \
			{
			# This was a termination message.
			# There is no more data to read.
			set code 0
			set GlobalParam(TermMsg) [DumpBinary $line]
			break
			}

		if {$len != 41} \
			{
			# Error while reading from radio.
			set code -1
			break
			}

		# Got a data record.
		# Temorarily convert it from funky unpacked
		# format to binary format.
		# Then, perform a checksum calculation on it.

		set pline [PackString [string range $line 1 42]]
		set plen [string length $pline]

		# puts stderr "ReadXferRx: line length is: $len"
	
		set dbuf [string range $pline 0 18] 
		set cksum [string range $pline 19 19] 
		set ccksum [CalcCheckSum $dbuf]
	
		binary scan $cksum "H*" icksum
		scan $icksum "%x" cksum
	
		# puts stderr [format "CHECKSUM radio: %s, calculated: %s\n" \
				$cksum $ccksum]
	
		if {$cksum != $ccksum} \
			{
			set msg [format \
				"%s: error, checksum mismatch, radio: %s, calculated: %s\n" \
				$Pgm $cksum $ccksum]
			Tattle $msg
			tk_dialog .error "Checksum error while reading" \
				$msg error 0 OK
			exit
			}


		# Strip off memory address and count bytes.
		set buf [string range $dbuf 3 end]
		append Mimage $buf
		}

	set GlobalParam(NmsgsRead) $i


	# Zap the progress bar.
	grab release .pbw
	destroy .pbw

	return $code
}



###################################################################
# this takes a string and converts the
# first character in it to an integer
#   in the range 0-255
#
# if the string is empty, returns an empty string
###################################################################

proc Char2Int { c } \
{
	set tmp ""

	set n [binary scan $c "c" tmp]

	if { ($n == 1) && ($tmp < 0) } \
		{
		# Force negative number to be positive

		set tmp [expr $tmp + 256]
		}
	return "$tmp"
}


###################################################################
# Calculate the 2s complement modulo 256 checksum byte for a string by
# summing all the ascii character values,
# getting the 2s complement, then modulo 256.
###################################################################

proc CalcCheckSum { s } \
{

	set len [string length $s]
	set sum 0

	binary scan $s "H*" x

#	regsub -all ".." $x { \0} x
#	puts stderr "CalcCheckSum: $x"

	for {set i 0} {$i < $len} {incr i} \
		{
         	set c [string index $s $i]
         	set tmp [Char2Int $c]

		# set xtmp [format "%x" $tmp]
		# puts stderr "CalcCheckSum: $i (of $len): xtmp = $xtmp"

         	set sum [expr {$sum + $tmp}]
		}

#	set xsum [format "%x" $sum]
#	puts stderr "CalcCheckSum: xsum = $xsum"
#
	set sum [expr {0 - $sum}]

#	set ysum [format "%x" $sum]
#	puts stderr "CalcCheckSum: ysum = $ysum"

	set sum [expr $sum % 256]

#	set zsum [format "%x" $sum]
#	puts stderr "CalcCheckSum: zsum = $zsum"

	return $sum
 }

###################################################################
# Create a string of "n" bytes where each byte is \xff (255 decimal).
###################################################################

proc Padff { n } \
{
	set ffrecd ""
	set byte [binary format "H2" ff]

	for {set i 0} {$i < $n} {incr i} \
		{
		append ffrecd $byte
		}
	return $ffrecd
}



##########################################################
# Open the serial port.
# Notes:
#	This procedure sets the global variable Sid.
#
# Returns:
#	"" -ok
#	else -error message
##########################################################

proc OpenDevice {} \
{
	global Pgm
	global GlobalParam
	global Sid
	global tcl_platform


	 set platform $tcl_platform(platform) 
	 switch -glob $platform \
		{
		{unix} \
			{
			set Sid [open $GlobalParam(Device) "r+"]
			}
		{macintosh} \
			{
			set Sid [open $GlobalParam(Device) "r+"]
			}
		{windows} \
			{
			set Sid [open $GlobalParam(Device) RDWR]
			}
		default \
			{
			set msg "$Pgm error: Platform $platform not supported."
			Tattle $msg
			return $msg
			}
		}


	# Set up the serial port parameters (similar to stty)
	if [catch {fconfigure $Sid \
		-buffering full \
		-translation binary \
		-mode 9600,n,8,1 -blocking 1}] \
		{
		set msg "$Pgm error: "
		set msg [append msg "Cannot configure serial port\n"]
		set msg [append msg "$GlobalParam(Device)"]
		Tattle $msg
		return $msg
		}
	return "" 
}

###################################################################
# Return the preamble for messages sent from computer to radio.
###################################################################
proc MsgPreamble { } \
{
	global RadioAddress
	global PCAddress

	# byte 0 = FE
	# byte 1 = FE
	# byte 2 = (radio's unique address)
	# byte 3 = (computer's address)

	set preamble [ binary format "H2H2H2H2" fe fe \
		$RadioAddress $PCAddress ]

	return $preamble
}


###################################################################
#
# Send "command" to radio.
# Write command to error stream if Debug flag is set.
#
###################################################################
proc SendCmd { Sid command } \
{
	global GlobalParam


	set cmd [MsgPreamble]
	append cmd $command
	append cmd [binary format "H2" fd]


	if { $GlobalParam(Debug) > 0 } \
		{
		binary scan $cmd "H*" s

		# Insert a space between each pair of hex digits
		# to improve readability.

		regsub -all ".." $s { \0} s
		set msg ""
		set msg [ append msg "---> " $s]
		Tattle $msg
		}

	# Write data to serial port.

	puts -nonewline $Sid $cmd
	flush $Sid
	return
}

###################################################################
# Interrogate radio for version/model/user information
#
# Returns:
#	- a version of IC-R3 we have.
#	- empty string if error occurred.
#
# Notes:
#	A USA version IC-R3 returns this string:
#	23040001
###################################################################
proc GetModelInfo { } \
{
	global GlobalParam
	global Sid

	set cmd [ binary format "H2H2H2H2H2" E0 00 00 00 00 ]

	SendCmd $Sid $cmd

	while {1} \
		{
		# Read messages until we find the
		# one which matches this request.

		set line [ReadRx]

		set len [string length $line]
		set cn [string range $line 0 0]
		binary scan $cn "H*" cn

		# If this is a response to our request.
		if {$cn == "e1"} {break}

		# If we got an NG message from the radio.
		if {$cn == "fa"} {break}
		}

	set len [string length $line]

	# Check if radio sent NG msg. 
	if {$len == 1}  \
		{
		set line ""
		} \
	else \
		{
		set line [string range $line 1 4 ]
		}

	binary scan $line "H*" x
	set GlobalParam(RadioVersion) $x
#	puts stderr "GetModelInfo: RadioVersion= $x"
	return $line
}

###################################################################
# Read a CI-V message from the serial port.
#
# Inputs:
#	any	- 0 means ignore messages with a "from address"
#		field which indicates the message is from
#		this computer.
#		- 1 means return any message
#
# Strip off the 2 address bytes.
#
# Returns: the message without the address fields.
###################################################################
proc ReadRx { {any 0} } \
{
	global GlobalParam

	global RadioAddressHex
	global PCAddressHex

	set ignored "ignoring previous echo msg from the radio."

	set line {} 

	while { 1 } \
		{
		# Read message from the bus.

		set line [ReadCIV]

		if { [string length $line] == 0} \
			{
			# Got a read error.
			break
			}

		# Examine the address bytes.
		set to [string range $line 0 0]
		set from [string range $line 1 1]

		if { ([string compare -nocase -length 1 \
			$to $PCAddressHex] != 0) \
			&& ([string compare -nocase -length 1 \
			$to $RadioAddressHex] != 0)} \
			{
			puts stderr "ReadRx: UNKNOWN MESSAGE"
			continue;
			}

		if { $any == 0 } \
			{
			if { [string compare -nocase -length 1 \
				$from $PCAddressHex] == 0} \
				{
				# This message is from us,

				# so ignore it and read again.
				continue
				} \
			} 

		# Strip of the address bytes.
		set line [string range $line 2 end]
		set len [string length $line]

		break
		}
	return $line
}


###################################################################
# Read a CI-V data transfer message from the serial port.
#
# INPUTS:
#	any	- 0 means ignore messages with a "from address"
#		field which indicates the message is from
#		this computer.
#		- 1 means return any message
#
# DESCRIPTION:
#	Read a data transfer message.
#	Calculate a checksum and compare it to the
#		checksum in the message.
#	Return an empty message if there is an error.
#	Strip off the 2 address bytes.
#
# Returns: the data transfer message without the address fields.
###################################################################
proc ReadXferRx { {any 0} } \
{
	global GlobalParam

	global RadioAddressHex
	global PCAddressHex

	set ignored "ignoring previous echo msg from the radio."

	set line {} 

	while { 1 } \
		{
		# Read message from the bus.

		set line [ReadCIV]

		if { [string length $line] == 0} \
			{
			# Got a read error.
			return ""
			}

		# Examine the address bytes.
		set to [string range $line 0 0]
		set from [string range $line 1 1]

		if { ([string compare -nocase -length 1 \
			$to $PCAddressHex] != 0) \
			&& ([string compare -nocase -length 1 \
			$to $RadioAddressHex] != 0)} \
			{
			puts stderr "ReadRx: UNKNOWN MESSAGE"
			continue;
			}

		if { $any == 0 } \
			{
			if { [string compare -nocase -length 1 \
				$from $PCAddressHex] == 0} \
				{
				# This message is from us,

				# so ignore it and read again.
				continue
				} \
			} 
		# Got a message.
		break
		}


###

	# Strip of the from and to address bytes.
	set line [string range $line 2 end]

	return $line
}


###################################################################
# Read a CI-V message from the serial port.
#
# Returns:
#		The message unless there was an error.
#		The empty string if there was an error.
###################################################################
proc ReadCIV { } \
{
	global GlobalParam
	global Sid


	set collision_error false

	# Skip the 2 byte "fe fe" preamble
	read $Sid 1
	read $Sid 1

	set line ""


	while { 1 } \
		{
		set b [read $Sid 1]

		# A byte of hexadecimal fc means there was an
		# error, usually a collision.

		# Note: I have observered that the radio
		# usually sends 3 consecutive fc bytes after
		# a CIV collision.   Because fc should never appear
		# in the IC-R75 data stream, we consider it 
		# an error whenever we see even a single fc byte.
		#        - Bob Parnass, 2/12/2002

		if { [string compare -nocase -length 1 $b \xfc] == 0} \
			{
			# Got an error, but continue reading bytes
			# until we get an end of message byte fe.

			set collision_error true
			set line [append line $b]
			} \
		elseif { [string compare -nocase -length 1 $b \xfd] == 0} \
			{
			# Got the end of message code byte.
			break
			} \
		elseif { [string compare -nocase -length 1 $b \xfe] == 0} \
			{
			; # Ignore leading preamble bytes.
			} \
		else \
			{
			set line [append line $b]
			}
		}

	if { $GlobalParam(Debug) > 0 } \
		{
		set msg "<--- "
		binary scan $line "H*" x

		regsub -all ".." $x { \0} x

		set msg [append msg $x]
		Tattle $msg
		}

	if { $collision_error == "true" } \
		{
		puts stderr "ReadCIV: collison error."
		set line ""
		}
	return $line
}

###################################################################
# 
# Convert an ASCII string to binary.
# The ASCII string uses two consecutive bytes, e.g., E3, to represent
# one byte of the binary string, e.g. \xE3.
#
# INPUT:	unpacked string
# RETURNS:	packed string
###################################################################

proc PackString { in } \
{
	global Hex2Digit

	set len [string length $in]

	set out ""
#	puts stderr "len $len, anum: "

	for {set i 0} {$i < $len} {incr i 2} \
		{
		set j $i 
		set left [string range $in $j $j]
		incr j 
		set right [string range $in $j $j]

		binary scan $left "H2" ileft
		set dleft $Hex2Digit($ileft)

		binary scan $right "H2" iright
		set dright $Hex2Digit($iright)

		set s ""
		append s $dleft $dright
#		puts -nonewline stderr "$s "
		set hnum [binary format "H2" $s]

		append out $hnum

		# binary scan $left "H*" cl
		# binary scan $right "H*" cr

		# puts stderr "cl= $cl, cr= $cr, num= $num, ileft= $ileft, iright= $iright"
		}
	return $out
}


###################################################################
# 
# Convert a binary string to an ASCII string.
# The ASCII string uses two consecutive bytes, e.g., E3, to represent
# one byte of the binary string, e.g. \xE3.
#
# INPUT:	packed string
# RETURNS:	unpacked string
###################################################################

proc UnpackString { in } \
{
	global Digit2Hex

	set len [string length $in]

	set out ""

	for {set i 0} {$i < $len} {incr i} \
		{
         	set c [string index $in $i]
		binary scan $c "H2" s
		set s [string toupper $s]
         	set left [string index $s 0]
         	set right [string index $s 1]


		set dleft $Digit2Hex($left)
		set dright $Digit2Hex($right)
#		puts stderr "s= $s, $dleft $dright"

		append out [binary format "H2H2" $dleft $dright]
		}
	return $out
}

###################################################################
# Send the radio a command to accept memory data.
###################################################################
proc SendCloneIn { } \
{
	global GlobalParam
	global Sid


	set cmd [ binary format "H2" E3 ]
	append cmd [ binary format "H*" $GlobalParam(RadioVersion) ]

	SendCmd $Sid $cmd

	# Read the echo

	if { [ReadEcho $cmd] } \
		{
		# Error.
		# We did not read back what we wrote.
		puts stderr "SendCloneIn: Error while reading echo."
		}
	return
}


###################################################################
# Send the radio a command to send memory data to computer.
###################################################################
proc SendCloneOut { } \
{
	global GlobalParam
	global Sid


	set cmd [ binary format "H2" E2 ]
	append cmd [ binary format "H*" \
		$GlobalParam(RadioVersion) ]

	SendCmd $Sid $cmd

	# Read the echo

	if { [ReadEcho $cmd] } \
		{
		# Error.
		# We did not read back what we wrote.
		puts stderr "SendCloneOut: Error while reading echo."

		}
	return
}


###################################################################
# Send the radio a data termination command.
###################################################################
proc SendTermination { } \
{
	global GlobalParam
	global Sid


	set cmd [ binary format "H2" E5 ]
	append cmd "Icom Inc."

	SendCmd $Sid $cmd
	if { [ReadEcho $cmd] } \
		{
		# Error.
		# We did not read back what we wrote.
		puts stderr "SendTermination: Error while reading echo"
		}
	return
}


###################################################################
# Interrogate radio for version/model/user information
#
# Returns:
#	- 0 = no errors
#	- otherwise, error
#
# Notes:
###################################################################
proc GetTerminationResult { } \
{
	global GlobalParam
	global Sid


	while {1} \
		{
		# Read messages until we find the
		# one which matches request.

		set line [ReadRx]

		set len [string length $line]
		set cn [string range $line 0 0]
		binary scan $cn "H*" cn

		# If this is a termination result....
		if {$cn == "e6"} {break}
		}
	set x [string range $line 1 1 ]

	set code -1
	if { [string compare -nocase -length 1 $x \x00] == 0} \
		{
		set code 0
		} 
	return $code
}

proc DumpBinary { bstring } \
{
	binary scan $bstring "H*" s

	# Insert a space between each pair of hex digits
	# to improve readability.

	regsub -all ".." $s { \0} s
	return $s
}

proc ReadEcho { sent } \
{
	global Pgm

	set echo [ReadRx 1]
	if { [string compare $sent $echo] } \
		{
		# Error.
		# We did not read back what we wrote.
		puts stderr "$Pgm: Error while reading echo from message $i."
		return 1

		}
	return 0
}
