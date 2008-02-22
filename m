From: heinzm@sourceware.org
Subject: dmraid CHANGELOG CREDITS KNOWN_BUGS LICENSE LI ...
Date: 22 Feb 2008 16:50:39 -0000
Message-ID: <20080222165039.24021.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2008-02-22 16:50:38

Added files:
	.              : CHANGELOG CREDITS KNOWN_BUGS LICENSE 
	                 LICENSE_GPL LICENSE_LGPL Makefile.in TODO 
	                 aclocal.m4 configure configure.in dmraid.spec 
	                 make.tmpl.in 

Log message:
	initial 1.0.0.rc11 checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CHANGELOG.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CREDITS.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/KNOWN_BUGS.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/LICENSE.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/LICENSE_GPL.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/LICENSE_LGPL.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/Makefile.in.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/TODO.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/aclocal.m4.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=NONE&r2=1.1

/cvs/dm/dmraid/CHANGELOG,v  -->  standard output
revision 1.1
--- dmraid/CHANGELOG
+++ -	2008-02-22 16:50:38.804389000 +0000
@@ -0,0 +1,498 @@
+
+Changelog from dmraid 1.0.0.rc10 to 1.0.0.rc11		2006.05.16
+
+FIXES:
+------
+o jm.c:	checksum() calculation
+
+o misc.c:
+	support "%d" in p_fmt and fix segfault with wrong format identifier
+
+o nv.c:	size fix in setup_rd()
+
+o activate.c:
+	- striped devices could end on non-chunk boundaries
+	- calc_region_size() calculated too small sizes causing large
+	  dirty logs in memory
+
+o isw.c: set raid5 type to left asymmetric
+
+o toollib.c: fixed 'No RAID...' message
+
+
+FEATURES:
+---------
+
+o support selection of RAID5 allocation algorithm in metadata format handlers
+
+
+MISCELANIOUS:
+-------------
+
+
+
+Changelog from dmraid 1.0.0.rc9 to 1.0.0.rc10		2006.02.17
+
+FIXES:
+------
+o metadata.c: want_set() didn't drop sets properly
+              (eg, jmicron_raid10 wanted and jmicron_raid1 not dropped)
+
+o scsi.c: avoid retrieving too much data (Al Viro)
+
+o sil.h: magic number fix (some arrays were not recognized)
+
+
+FEATURES:
+---------
+o added libdmraid_make_table() to activate.c to be used by installer
+
+o asr.[ch]: added Adaptec HostRAID support
+
+o jm.[ch]: added JMicron JMB36x support
+
+o added '--enable-libselinux' to configure for those who want
+  to build without it
+
+o bytorder.h: enhanced to support big endian conversion
+              on little endian arch
+
+o nv.c: support RAID5 with dm-raid45 target
+
+o pdc.h: support additional metadata offset
+
+o metadata.c: enhanced to support RAID4 and RAID5 mappings with dm-raid45 target
+
+
+MISCELANIOUS:
+-------------
+o misc.c: streamlined remove_white_space() (Al Viro)
+
+
+
+Changelog from dmraid 1.0.0.rc8 to 1.0.0.rc9		2005.09.23
+
+FIXES:
+------
+o via.c: checksum() calculation;
+	 stride size
+
+o toollib.c:  memory leak in _valid_format()
+
+o isw.c: avoid endianess conversion bug in to_cpu();
+         disk status check;
+	 version check to cover 1.2.02;
+	 isw_write() to store metadata in correct sequence
+
+o hpt37x.c, lsi.c, nv.c, pdc.c, sil.c via.c: streamlined grouping switch()
+
+o hpt45x.c: added missing RAID10 to capability string
+
+o sil.c: streamlined quorate()
+
+o misc.c: p_fmt() missed a free_string()
+
+
+FEATURES:
+---------
+o pdc.c: support RAID10
+
+o commands.c: added --separator option for selectable string
+	      separator character (used with --format etc.)
+
+o display.c: support customizable column output through field
+	     identifiers with -c option
+
+MISCELANIOUS:
+------------
+o metadata.c: use log_alloc_err()
+
+o format.h: introduced caps (RAID capabilities) member
+
+o format.c: introduced get_format_caps() and free_format_caps()
+	    to ease library use in installers (pjones@redhat.com)
+
+o display.c: streamlined log_devices()
+
+o toollib.c: stremalined collapse_delimiters()
+
+o isw.c: streamlined isw_read_extended() and setup_rd()
+
+o file.c: cleanup
+
+o add /var/lock/dmraid to rpm
+
+o avoid global variable format_names:
+  - change discover_raid_devices() interface
+  - saves code in toollib
+
+o added more info to format_error output
+
+o activate.c: display RAID string with unsupported mapping
+
+
+
+Changelog from dmraid 1.0.0.rc7 to 1.0.0.rc8		2005.05.19
+
+FIXES:
+------
+o nv.c: fixed stripe size
+
+o sil.c: avoid incarnation_no in name creation, because the Windows
+         driver changes it every time
+
+
+FEATURES:
+---------
+o added --ignorelocking option to avoid taking out locks in early boot
+  where no read/write access to /var is given
+
+
+MISCELANIOUS:
+------------
+o some cleanups in misc.c
+
+
+
+Changelog from dmraid 1.0.0.rc6 to 1.0.0.rc7		2005.04.07
+
+FIXES:
+------
+o pdc.c, hpt37x.c, hpt45x.c: fixed size in sectors() for RAID1
+
+
+MISCELANIOUS:
+------------
+
+o sil_valid() displays the area number where the checksum is invalid now.
+
+
+
+
+Changelog from dmraid 1.0.0-rc5f to 1.0.0.rc6		2005.02.28
+
+FIXES:
+------
+o sil status()
+
+o _sil_read() used LOG_NOTICE rather than LOG_INFO in order to
+  avoid messages about valid metadata areas being displayed
+  during "dmraid -vay".
+
+o isw, sil filed metadata offset on "-r -D" in sectors rather than in bytes.
+
+o isw needed dev_sort() to sort RAID devices in sets correctly.
+
+o pdc metadata format handler name creation. Lead to
+  wrong RAID set grouping logic in some configurations. 
+
+o dos.c: partition table code fixes by Paul Moore
+
+o _free_dev_pointers(): fixed potential OOB error
+
+o hpt37x_check: deal with raid_disks = 1 in mirror sets
+
+o pdc_check: status & 0x80 doesn't always show a failed device;
+  removed that check for now. Status definitions needed.
+
+o sil addition of RAID sets to global list of sets
+
+o sil spare device memory leak
+
+o group_set(): removal of RAID set in case of error
+
+o hpt37x: handle total_secs > device size
+
+o allow -p with -f
+
+o enhanced error message by checking target type against list of
+  registered target types
+
+
+FEATURES:
+---------
+
+o VIA metadata format handler
+
+o added RAID10 to lsi metadata format handler
+
+o "dmraid -rD": file device size into {devicename}_{formatname}.size
+
+o "dmraid -tay": pretty print multi-line tables ala "dmsetup table"
+
+o "dmraid -l": display supported RAID levels + manual update
+
+
+MISCELANIOUS:
+------------
+
+o more inline comments
+
+o libdmraid_init() now returns lib context
+
+o check_set() enhanced to do RAID set stack unrolling and
+  to check correct number of devices in sets; saves code in
+  metadata format handlers
+
+o introduced read_raid_dev() to further reduce metadata format handler code
+
+o optimized parse_table()
+
+o updated dmraid manual
+
+o devmapper.c: check target type registered before trying to load table record
+
+o misc.c: avoid find_percent().
+
+
+
+Changelog from dmraid 1.0.0-rc4 to 1.0.0-rc5f		2004.11.24
+
+FIXES:
+------
+o make suffix in hpt45x set names numeric
+
+o HPT37x metadata format handler RAID10 grouping logic
+
+o HPT37x/HPT45x avoid devision by zero bug
+  in case ->raid_disks is zero for spares
+
+o avoid devision by zero bug in case of stride = 0
+
+o SIL device names / checksums
+
+o calc_total_sectors() on unsymmetric mirrors
+
+o Partition name suffix to make GRUB happy
+
+o perform() could return an error without releasing a lock
+
+
+FEATURES:
+---------
+o added NVidia metadata format handler
+
+o quorate SIL metadata copies
+
+o sorting order of stacked subset enhanced
+  (RAID10; hpt37x, hpt45x, lsi, nvidia and sil)
+
+o started event methods implementation in metadata format handlers
+
+o output linefeed to .offset files for better readability (-r -D)
+
+o use /sys/block/*/removable to avoid acessing removable devices
+
+o display of spare devices with -r -c{0,2}
+
+o enhanced spare device handling
+
+o '-h' option doesn't need to stand alone any more
+
+o -s displays top level sets only. "-s -s" shows subsets as well.
+
+o -f allows partial qualification of format names now
+  (eg, "dmraid -f hpt -r" will search for hpt37x and hpt45x formats)
+
+
+MISCELANIOUS:
+------------
+o HPT37X shows subset name suffixes with -r
+
+o streamlined display.c
+
+o added lib_context* argument to alloc_disk_info() in order
+  to be able to display an error message on failure
+
+o factored basic RAID set allocation code out of
+  all metadata format handler into find_or_alloc_set()
+
+o factored RAID superset allocation code out of metadata format
+  handlers into join_superset()
+
+o streamlined endianess code using CVT* macros
+
+o streamlined free_set() code
+
+o check option enum valid
+
+o introduced various metadata extraction macros to streamline
+  related code (eg, RD(), RS())
+
+o optimized format handler pre-registration checks
+
+o avoid format handler type() method altogether by introducing
+  a RAID device type member
+
+o generalized list_add_sorted() which can be used to sort any
+  "struct list_head*" which voided list_add_dev_sorted()
+
+o find_set() modified to avoid global searches for stacked sets
+
+o converted get_scsi_serial to fallback using SG_IO,
+  SCSI_IOCTL_SEND_COMMAND and ATA identify
+
+o introduced p_fmt() for formated string pushs in order to
+  streamline activate.c; value return code of p_fmt()
+
+o moved some paths + filenames to lib_context
+
+o introduced RAID set flag for metadata format handlers 
+  which decide to maximize capacity in unsymetric RAID0 sets
+
+o factored out device information allocation of scan.c into metadata.c
+
+o introduced RAID device list to library context in order to remove
+  pointer from device info and be able to handle remaining RAID device
+  structures better on library cleanup
+
+o streamlined commands.c
+
+o changed column output delimiter to ':'
+
+o introduced various enums replacing integers
+
+
+Changelog from dmraid 1.0.0-rc3 to 1.0.0-rc4		2004.09.07
+
+FIXES:
+------
+o get_dm_serial fix for trailing blanks
+
+o infinite loop bug in makefile
+
+o unified RAID #defines
+
+o RAID disk erase size
+
+o avoided unnecessary read in isw_read()
+
+o segfault in build_set() on RAID set group failure
+
+o activation of partitions on Intel Software RAID
+
+o allow display if tables for active RAID sets (-t -ay)
+
+o discovering no RAID disks shouldn't return an error
+
+o free_set would have segfaulted on virgin RAID set structures
+
+o deep DOS partition chains (Paul Moore)
+
+o "dmraid -sa" displayed group RAID set with Intel Software RAID
+  when it shouldn't
+
+o return RAID super set pointer from hpt45x_group() and sil_group()
+  rather than sub set pointer
+
+
+FEATURES:
+---------
+
+o added offset output to all native metadata logs
+
+o started defining metadata format handler event method needed for
+  write updates to native metadata (eg, for mirror failure)
+
+o [de]activation of a single raid sets below a group one (isw)
+
+o support for multiple -c options (see "man dmraid"):
+  "dmraid -b -c{0,2}"
+  "dmraid -r -c{0,2}"
+  "dmraid -s -c{0,3}"
+
+
+
+Changelog from dmraid 1.0.0-rc2 to 1.0.0-rc3		2004.08.18
+
+FIXES:
+------
+o HPT37X mapping on first disk of set
+
+o dietlibc sscanf() use prevented activation
+
+o le*_to_cpu() for certain glibc environments (Luca Berra)
+
+o sysfs discovery (Luca Berra)
+
+o permissions to write on binary, which is needed
+  by newer strip versions (Luca Berra)
+
+o SCSI serial number string length bug
+
+o valgrinded memory leaks
+
+o updated design document
+
+o comments
+
+FEATURES:
+---------
+o added basic support for activation of LSI Logic MegaRAID/MegaIDE;
+  more reengineering of the metadata needed!
+
+o root check using certain options (eg, activation of RAID sets)
+
+o implemented locking abstraction
+
+o implemented writing device metadata offsets with "-r[D/E]"
+  for ease of manual restore
+
+o file based locking to avoid parallel tool runs competing
+  with each other for the same resources
+
+o streamlined library context
+
+o implemented access functions for library context
+
+o streamlined RAID set consistency checks
+
+o implemented log function and removed macros to shrink binary size further
+
+o removed superfluous disk geometry code
+
+o cleaned up metadata.c collapsing free_*() functions
+
+o slimmed down minimal binary (configure option DMRAID_MINI
+  for early boot environment)
+
+
+
+Changelog from dmraid 1.0.0-rc1 to 1.0.0-rc2		2004.07.15
+
+o Intel Software RAID discovery and activation support
+
+o allow more than one format handler name with --format
+
+o display "raid10" sets properly rather than just "mirror"
+
+o enhanced activate.c to handle partial activation of sets (eg, degraded RAID0)
+
+o enhanced command line option checks
+
+o implemented a library context for variables such as debug etc.
+
+o fixed memory leak in discover_partitions
+
+o fixed recursion in _find_set()
+
+o continued writing subsets in case we fail on one because of RAID1
+
+o format handler template update
+
+o fixed dietlibc build
+
+o fixed shared library configure
+
+o use default_list_set() instead of &raid_sets where possible
+
+o name change of list_head members to the more commonly used 'list'
+
+o renamed msdos partition format handler to dos
+
+o lots of inline comments corrected/updated
+
+o streamlined tools/*.[ch]
+
+o moved get.*level() and get_status to metadata.[ch] and changed level
+  name to type
/cvs/dm/dmraid/CREDITS,v  -->  standard output
revision 1.1
--- dmraid/CREDITS
+++ -	2008-02-22 16:50:38.893274000 +0000
@@ -0,0 +1,10 @@
+
+I'ld like to thank the following contributors for their help:
+
+o Carl-Daniel Hailfinger for raiddetect
+
+o Jane Liu for the NVidia RAID metadata format handler
+
+o Darrick J. Wong for the Adpatec HostRAID ASR metadata format handler
+
+o various helpful people who provided metadata samples
/cvs/dm/dmraid/KNOWN_BUGS,v  -->  standard output
revision 1.1
--- dmraid/KNOWN_BUGS
+++ -	2008-02-22 16:50:38.971587000 +0000
@@ -0,0 +1,7 @@
+
+KNOWN_BUGS in dmraid 1.0.0.rc11					2005.05.16
+
+o "dmraid --sets[a/i]" doesn't work properly. Use the short option -s.
+
+o DOS partition recognition fails to recognize all partitions in
+  certain cases; likely a size issue with the underlying RAID set
/cvs/dm/dmraid/LICENSE,v  -->  standard output
revision 1.1
--- dmraid/LICENSE
+++ -	2008-02-22 16:50:39.050704000 +0000
@@ -0,0 +1,20 @@
+  
+   Copyright (C) 2004-2006  Heinz Mauelshagen, Red Hat GmbH.
+   All rights reserved.
+  
+   This dmraid code is free software;
+   you can redistribute and/or modify it under the terms of
+   the GNU General Public License as published by the
+   Free Software Foundation; either version 2 of the License, or
+   (at your option) any later version.
+  
+   dmraid is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+   General Public License for more details.
+  
+   You should have received a copy of the GNU (Lesser) General Public
+   License along with this dmraid code; if not, write to the Free
+   Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
+   MA 02111-1307, USA
+
/cvs/dm/dmraid/LICENSE_GPL,v  -->  standard output
revision 1.1
--- dmraid/LICENSE_GPL
+++ -	2008-02-22 16:50:39.128567000 +0000
@@ -0,0 +1,340 @@
+		    GNU GENERAL PUBLIC LICENSE
+		       Version 2, June 1991
+
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.
+                       59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ Everyone is permitted to copy and distribute verbatim copies
+ of this license document, but changing it is not allowed.
+
+			    Preamble
+
+  The licenses for most software are designed to take away your
+freedom to share and change it.  By contrast, the GNU General Public
+License is intended to guarantee your freedom to share and change free
+software--to make sure the software is free for all its users.  This
+General Public License applies to most of the Free Software
+Foundation's software and to any other program whose authors commit to
+using it.  (Some other Free Software Foundation software is covered by
+the GNU Library General Public License instead.)  You can apply it to
+your programs, too.
+
+  When we speak of free software, we are referring to freedom, not
+price.  Our General Public Licenses are designed to make sure that you
+have the freedom to distribute copies of free software (and charge for
+this service if you wish), that you receive source code or can get it
+if you want it, that you can change the software or use pieces of it
+in new free programs; and that you know you can do these things.
+
+  To protect your rights, we need to make restrictions that forbid
+anyone to deny you these rights or to ask you to surrender the rights.
+These restrictions translate to certain responsibilities for you if you
+distribute copies of the software, or if you modify it.
+
+  For example, if you distribute copies of such a program, whether
+gratis or for a fee, you must give the recipients all the rights that
+you have.  You must make sure that they, too, receive or can get the
+source code.  And you must show them these terms so they know their
+rights.
+
+  We protect your rights with two steps: (1) copyright the software, and
+(2) offer you this license which gives you legal permission to copy,
+distribute and/or modify the software.
+
+  Also, for each author's protection and ours, we want to make certain
+that everyone understands that there is no warranty for this free
+software.  If the software is modified by someone else and passed on, we
+want its recipients to know that what they have is not the original, so
+that any problems introduced by others will not reflect on the original
+authors' reputations.
+
+  Finally, any free program is threatened constantly by software
+patents.  We wish to avoid the danger that redistributors of a free
+program will individually obtain patent licenses, in effect making the
+program proprietary.  To prevent this, we have made it clear that any
+patent must be licensed for everyone's free use or not licensed at all.
+
+  The precise terms and conditions for copying, distribution and
+modification follow.
+
+		    GNU GENERAL PUBLIC LICENSE
+   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+
+  0. This License applies to any program or other work which contains
+a notice placed by the copyright holder saying it may be distributed
+under the terms of this General Public License.  The "Program", below,
+refers to any such program or work, and a "work based on the Program"
+means either the Program or any derivative work under copyright law:
+that is to say, a work containing the Program or a portion of it,
+either verbatim or with modifications and/or translated into another
+language.  (Hereinafter, translation is included without limitation in
+the term "modification".)  Each licensee is addressed as "you".
+
+Activities other than copying, distribution and modification are not
+covered by this License; they are outside its scope.  The act of
+running the Program is not restricted, and the output from the Program
+is covered only if its contents constitute a work based on the
+Program (independent of having been made by running the Program).
+Whether that is true depends on what the Program does.
+
+  1. You may copy and distribute verbatim copies of the Program's
+source code as you receive it, in any medium, provided that you
+conspicuously and appropriately publish on each copy an appropriate
+copyright notice and disclaimer of warranty; keep intact all the
+notices that refer to this License and to the absence of any warranty;
+and give any other recipients of the Program a copy of this License
+along with the Program.
+
+You may charge a fee for the physical act of transferring a copy, and
+you may at your option offer warranty protection in exchange for a fee.
+
+  2. You may modify your copy or copies of the Program or any portion
+of it, thus forming a work based on the Program, and copy and
+distribute such modifications or work under the terms of Section 1
+above, provided that you also meet all of these conditions:
+
+    a) You must cause the modified files to carry prominent notices
+    stating that you changed the files and the date of any change.
+
+    b) You must cause any work that you distribute or publish, that in
+    whole or in part contains or is derived from the Program or any
+    part thereof, to be licensed as a whole at no charge to all third
+    parties under the terms of this License.
+
+    c) If the modified program normally reads commands interactively
+    when run, you must cause it, when started running for such
+    interactive use in the most ordinary way, to print or display an
+    announcement including an appropriate copyright notice and a
+    notice that there is no warranty (or else, saying that you provide
+    a warranty) and that users may redistribute the program under
+    these conditions, and telling the user how to view a copy of this
+    License.  (Exception: if the Program itself is interactive but
+    does not normally print such an announcement, your work based on
+    the Program is not required to print an announcement.)
+
+These requirements apply to the modified work as a whole.  If
+identifiable sections of that work are not derived from the Program,
+and can be reasonably considered independent and separate works in
+themselves, then this License, and its terms, do not apply to those
+sections when you distribute them as separate works.  But when you
+distribute the same sections as part of a whole which is a work based
+on the Program, the distribution of the whole must be on the terms of
+this License, whose permissions for other licensees extend to the
+entire whole, and thus to each and every part regardless of who wrote it.
+
+Thus, it is not the intent of this section to claim rights or contest
+your rights to work written entirely by you; rather, the intent is to
+exercise the right to control the distribution of derivative or
+collective works based on the Program.
+
+In addition, mere aggregation of another work not based on the Program
+with the Program (or with a work based on the Program) on a volume of
+a storage or distribution medium does not bring the other work under
+the scope of this License.
+
+  3. You may copy and distribute the Program (or a work based on it,
+under Section 2) in object code or executable form under the terms of
+Sections 1 and 2 above provided that you also do one of the following:
+
+    a) Accompany it with the complete corresponding machine-readable
+    source code, which must be distributed under the terms of Sections
+    1 and 2 above on a medium customarily used for software interchange; or,
+
+    b) Accompany it with a written offer, valid for at least three
+    years, to give any third party, for a charge no more than your
+    cost of physically performing source distribution, a complete
+    machine-readable copy of the corresponding source code, to be
+    distributed under the terms of Sections 1 and 2 above on a medium
+    customarily used for software interchange; or,
+
+    c) Accompany it with the information you received as to the offer
+    to distribute corresponding source code.  (This alternative is
+    allowed only for noncommercial distribution and only if you
+    received the program in object code or executable form with such
+    an offer, in accord with Subsection b above.)
+
+The source code for a work means the preferred form of the work for
+making modifications to it.  For an executable work, complete source
+code means all the source code for all modules it contains, plus any
+associated interface definition files, plus the scripts used to
+control compilation and installation of the executable.  However, as a
+special exception, the source code distributed need not include
+anything that is normally distributed (in either source or binary
+form) with the major components (compiler, kernel, and so on) of the
+operating system on which the executable runs, unless that component
+itself accompanies the executable.
+
+If distribution of executable or object code is made by offering
+access to copy from a designated place, then offering equivalent
+access to copy the source code from the same place counts as
+distribution of the source code, even though third parties are not
+compelled to copy the source along with the object code.
+
+  4. You may not copy, modify, sublicense, or distribute the Program
+except as expressly provided under this License.  Any attempt
+otherwise to copy, modify, sublicense or distribute the Program is
+void, and will automatically terminate your rights under this License.
+However, parties who have received copies, or rights, from you under
+this License will not have their licenses terminated so long as such
+parties remain in full compliance.
+
+  5. You are not required to accept this License, since you have not
+signed it.  However, nothing else grants you permission to modify or
+distribute the Program or its derivative works.  These actions are
+prohibited by law if you do not accept this License.  Therefore, by
+modifying or distributing the Program (or any work based on the
+Program), you indicate your acceptance of this License to do so, and
+all its terms and conditions for copying, distributing or modifying
+the Program or works based on it.
+
+  6. Each time you redistribute the Program (or any work based on the
+Program), the recipient automatically receives a license from the
+original licensor to copy, distribute or modify the Program subject to
+these terms and conditions.  You may not impose any further
+restrictions on the recipients' exercise of the rights granted herein.
+You are not responsible for enforcing compliance by third parties to
+this License.
+
+  7. If, as a consequence of a court judgment or allegation of patent
+infringement or for any other reason (not limited to patent issues),
+conditions are imposed on you (whether by court order, agreement or
+otherwise) that contradict the conditions of this License, they do not
+excuse you from the conditions of this License.  If you cannot
+distribute so as to satisfy simultaneously your obligations under this
+License and any other pertinent obligations, then as a consequence you
+may not distribute the Program at all.  For example, if a patent
+license would not permit royalty-free redistribution of the Program by
+all those who receive copies directly or indirectly through you, then
+the only way you could satisfy both it and this License would be to
+refrain entirely from distribution of the Program.
+
+If any portion of this section is held invalid or unenforceable under
+any particular circumstance, the balance of the section is intended to
+apply and the section as a whole is intended to apply in other
+circumstances.
+
+It is not the purpose of this section to induce you to infringe any
+patents or other property right claims or to contest validity of any
+such claims; this section has the sole purpose of protecting the
+integrity of the free software distribution system, which is
+implemented by public license practices.  Many people have made
+generous contributions to the wide range of software distributed
+through that system in reliance on consistent application of that
+system; it is up to the author/donor to decide if he or she is willing
+to distribute software through any other system and a licensee cannot
+impose that choice.
+
+This section is intended to make thoroughly clear what is believed to
+be a consequence of the rest of this License.
+
+  8. If the distribution and/or use of the Program is restricted in
+certain countries either by patents or by copyrighted interfaces, the
+original copyright holder who places the Program under this License
+may add an explicit geographical distribution limitation excluding
+those countries, so that distribution is permitted only in or among
+countries not thus excluded.  In such case, this License incorporates
+the limitation as if written in the body of this License.
+
+  9. The Free Software Foundation may publish revised and/or new versions
+of the General Public License from time to time.  Such new versions will
+be similar in spirit to the present version, but may differ in detail to
+address new problems or concerns.
+
+Each version is given a distinguishing version number.  If the Program
+specifies a version number of this License which applies to it and "any
+later version", you have the option of following the terms and conditions
+either of that version or of any later version published by the Free
+Software Foundation.  If the Program does not specify a version number of
+this License, you may choose any version ever published by the Free Software
+Foundation.
+
+  10. If you wish to incorporate parts of the Program into other free
+programs whose distribution conditions are different, write to the author
+to ask for permission.  For software which is copyrighted by the Free
+Software Foundation, write to the Free Software Foundation; we sometimes
+make exceptions for this.  Our decision will be guided by the two goals
+of preserving the free status of all derivatives of our free software and
+of promoting the sharing and reuse of software generally.
+
+			    NO WARRANTY
+
+  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
+FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
+OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
+PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
+OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
+TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
+PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
+REPAIR OR CORRECTION.
+
+  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
+WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
+REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
+INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
+OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
+TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
+YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
+PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGES.
+
+		     END OF TERMS AND CONDITIONS
+
+	    How to Apply These Terms to Your New Programs
+
+  If you develop a new program, and you want it to be of the greatest
+possible use to the public, the best way to achieve this is to make it
+free software which everyone can redistribute and change under these terms.
+
+  To do so, attach the following notices to the program.  It is safest
+to attach them to the start of each source file to most effectively
+convey the exclusion of warranty; and each file should have at least
+the "copyright" line and a pointer to where the full notice is found.
+
+    <one line to give the program's name and a brief idea of what it does.>
+    Copyright (C) <year>  <name of author>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+
+Also add information on how to contact you by electronic and paper mail.
+
+If the program is interactive, make it output a short notice like this
+when it starts in an interactive mode:
+
+    Gnomovision version 69, Copyright (C) year name of author
+    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
+    This is free software, and you are welcome to redistribute it
+    under certain conditions; type `show c' for details.
+
+The hypothetical commands `show w' and `show c' should show the appropriate
+parts of the General Public License.  Of course, the commands you use may
+be called something other than `show w' and `show c'; they could even be
+mouse-clicks or menu items--whatever suits your program.
+
+You should also get your employer (if you work as a programmer) or your
+school, if any, to sign a "copyright disclaimer" for the program, if
+necessary.  Here is a sample; alter the names:
+
+  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
+  `Gnomovision' (which makes passes at compilers) written by James Hacker.
+
+  <signature of Ty Coon>, 1 April 1989
+  Ty Coon, President of Vice
+
+This General Public License does not permit incorporating your program into
+proprietary programs.  If your program is a subroutine library, you may
+consider it more useful to permit linking proprietary applications with the
+library.  If this is what you want to do, use the GNU Library General
+Public License instead of this License.
/cvs/dm/dmraid/LICENSE_LGPL,v  -->  standard output
revision 1.1
--- dmraid/LICENSE_LGPL
+++ -	2008-02-22 16:50:39.209510000 +0000
@@ -0,0 +1,504 @@
+		  GNU LESSER GENERAL PUBLIC LICENSE
+		       Version 2.1, February 1999
+
+ Copyright (C) 1991, 1999 Free Software Foundation, Inc.
+     59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ Everyone is permitted to copy and distribute verbatim copies
+ of this license document, but changing it is not allowed.
+
+[This is the first released version of the Lesser GPL.  It also counts
+ as the successor of the GNU Library Public License, version 2, hence
+ the version number 2.1.]
+
+			    Preamble
+
+  The licenses for most software are designed to take away your
+freedom to share and change it.  By contrast, the GNU General Public
+Licenses are intended to guarantee your freedom to share and change
+free software--to make sure the software is free for all its users.
+
+  This license, the Lesser General Public License, applies to some
+specially designated software packages--typically libraries--of the
+Free Software Foundation and other authors who decide to use it.  You
+can use it too, but we suggest you first think carefully about whether
+this license or the ordinary General Public License is the better
+strategy to use in any particular case, based on the explanations below.
+
+  When we speak of free software, we are referring to freedom of use,
+not price.  Our General Public Licenses are designed to make sure that
+you have the freedom to distribute copies of free software (and charge
+for this service if you wish); that you receive source code or can get
+it if you want it; that you can change the software and use pieces of
+it in new free programs; and that you are informed that you can do
+these things.
+
+  To protect your rights, we need to make restrictions that forbid
+distributors to deny you these rights or to ask you to surrender these
+rights.  These restrictions translate to certain responsibilities for
+you if you distribute copies of the library or if you modify it.
+
+  For example, if you distribute copies of the library, whether gratis
+or for a fee, you must give the recipients all the rights that we gave
+you.  You must make sure that they, too, receive or can get the source
+code.  If you link other code with the library, you must provide
+complete object files to the recipients, so that they can relink them
+with the library after making changes to the library and recompiling
+it.  And you must show them these terms so they know their rights.
+
+  We protect your rights with a two-step method: (1) we copyright the
+library, and (2) we offer you this license, which gives you legal
+permission to copy, distribute and/or modify the library.
+
+  To protect each distributor, we want to make it very clear that
+there is no warranty for the free library.  Also, if the library is
+modified by someone else and passed on, the recipients should know
+that what they have is not the original version, so that the original
+author's reputation will not be affected by problems that might be
+introduced by others.
+
+  Finally, software patents pose a constant threat to the existence of
+any free program.  We wish to make sure that a company cannot
+effectively restrict the users of a free program by obtaining a
+restrictive license from a patent holder.  Therefore, we insist that
+any patent license obtained for a version of the library must be
+consistent with the full freedom of use specified in this license.
+
+  Most GNU software, including some libraries, is covered by the
+ordinary GNU General Public License.  This license, the GNU Lesser
+General Public License, applies to certain designated libraries, and
+is quite different from the ordinary General Public License.  We use
+this license for certain libraries in order to permit linking those
+libraries into non-free programs.
+
+  When a program is linked with a library, whether statically or using
+a shared library, the combination of the two is legally speaking a
+combined work, a derivative of the original library.  The ordinary
+General Public License therefore permits such linking only if the
+entire combination fits its criteria of freedom.  The Lesser General
+Public License permits more lax criteria for linking other code with
+the library.
+
+  We call this license the "Lesser" General Public License because it
+does Less to protect the user's freedom than the ordinary General
+Public License.  It also provides other free software developers Less
+of an advantage over competing non-free programs.  These disadvantages
+are the reason we use the ordinary General Public License for many
+libraries.  However, the Lesser license provides advantages in certain
+special circumstances.
+
+  For example, on rare occasions, there may be a special need to
+encourage the widest possible use of a certain library, so that it becomes
+a de-facto standard.  To achieve this, non-free programs must be
+allowed to use the library.  A more frequent case is that a free
+library does the same job as widely used non-free libraries.  In this
+case, there is little to gain by limiting the free library to free
+software only, so we use the Lesser General Public License.
+
+  In other cases, permission to use a particular library in non-free
+programs enables a greater number of people to use a large body of
+free software.  For example, permission to use the GNU C Library in
+non-free programs enables many more people to use the whole GNU
+operating system, as well as its variant, the GNU/Linux operating
+system.
+
+  Although the Lesser General Public License is Less protective of the
+users' freedom, it does ensure that the user of a program that is
+linked with the Library has the freedom and the wherewithal to run
+that program using a modified version of the Library.
+
+  The precise terms and conditions for copying, distribution and
+modification follow.  Pay close attention to the difference between a
+"work based on the library" and a "work that uses the library".  The
+former contains code derived from the library, whereas the latter must
+be combined with the library in order to run.
+
+		  GNU LESSER GENERAL PUBLIC LICENSE
+   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+
+  0. This License Agreement applies to any software library or other
+program which contains a notice placed by the copyright holder or
+other authorized party saying it may be distributed under the terms of
+this Lesser General Public License (also called "this License").
+Each licensee is addressed as "you".
+
+  A "library" means a collection of software functions and/or data
+prepared so as to be conveniently linked with application programs
+(which use some of those functions and data) to form executables.
+
+  The "Library", below, refers to any such software library or work
+which has been distributed under these terms.  A "work based on the
+Library" means either the Library or any derivative work under
+copyright law: that is to say, a work containing the Library or a
+portion of it, either verbatim or with modifications and/or translated
+straightforwardly into another language.  (Hereinafter, translation is
+included without limitation in the term "modification".)
+
+  "Source code" for a work means the preferred form of the work for
+making modifications to it.  For a library, complete source code means
+all the source code for all modules it contains, plus any associated
+interface definition files, plus the scripts used to control compilation
+and installation of the library.
+
+  Activities other than copying, distribution and modification are not
+covered by this License; they are outside its scope.  The act of
+running a program using the Library is not restricted, and output from
+such a program is covered only if its contents constitute a work based
+on the Library (independent of the use of the Library in a tool for
+writing it).  Whether that is true depends on what the Library does
+and what the program that uses the Library does.
+  
+  1. You may copy and distribute verbatim copies of the Library's
+complete source code as you receive it, in any medium, provided that
+you conspicuously and appropriately publish on each copy an
+appropriate copyright notice and disclaimer of warranty; keep intact
+all the notices that refer to this License and to the absence of any
+warranty; and distribute a copy of this License along with the
+Library.
+
+  You may charge a fee for the physical act of transferring a copy,
+and you may at your option offer warranty protection in exchange for a
+fee.
+
+  2. You may modify your copy or copies of the Library or any portion
+of it, thus forming a work based on the Library, and copy and
+distribute such modifications or work under the terms of Section 1
+above, provided that you also meet all of these conditions:
+
+    a) The modified work must itself be a software library.
+
+    b) You must cause the files modified to carry prominent notices
+    stating that you changed the files and the date of any change.
+
+    c) You must cause the whole of the work to be licensed at no
+    charge to all third parties under the terms of this License.
+
+    d) If a facility in the modified Library refers to a function or a
+    table of data to be supplied by an application program that uses
+    the facility, other than as an argument passed when the facility
+    is invoked, then you must make a good faith effort to ensure that,
+    in the event an application does not supply such function or
+    table, the facility still operates, and performs whatever part of
+    its purpose remains meaningful.
+
+    (For example, a function in a library to compute square roots has
+    a purpose that is entirely well-defined independent of the
+    application.  Therefore, Subsection 2d requires that any
+    application-supplied function or table used by this function must
+    be optional: if the application does not supply it, the square
+    root function must still compute square roots.)
+
+These requirements apply to the modified work as a whole.  If
+identifiable sections of that work are not derived from the Library,
+and can be reasonably considered independent and separate works in
+themselves, then this License, and its terms, do not apply to those
+sections when you distribute them as separate works.  But when you
+distribute the same sections as part of a whole which is a work based
+on the Library, the distribution of the whole must be on the terms of
+this License, whose permissions for other licensees extend to the
+entire whole, and thus to each and every part regardless of who wrote
+it.
+
+Thus, it is not the intent of this section to claim rights or contest
+your rights to work written entirely by you; rather, the intent is to
+exercise the right to control the distribution of derivative or
+collective works based on the Library.
+
+In addition, mere aggregation of another work not based on the Library
+with the Library (or with a work based on the Library) on a volume of
+a storage or distribution medium does not bring the other work under
+the scope of this License.
+
+  3. You may opt to apply the terms of the ordinary GNU General Public
+License instead of this License to a given copy of the Library.  To do
+this, you must alter all the notices that refer to this License, so
+that they refer to the ordinary GNU General Public License, version 2,
+instead of to this License.  (If a newer version than version 2 of the
+ordinary GNU General Public License has appeared, then you can specify
+that version instead if you wish.)  Do not make any other change in
+these notices.
+
+  Once this change is made in a given copy, it is irreversible for
+that copy, so the ordinary GNU General Public License applies to all
+subsequent copies and derivative works made from that copy.
+
+  This option is useful when you wish to copy part of the code of
+the Library into a program that is not a library.
+
+  4. You may copy and distribute the Library (or a portion or
+derivative of it, under Section 2) in object code or executable form
+under the terms of Sections 1 and 2 above provided that you accompany
+it with the complete corresponding machine-readable source code, which
+must be distributed under the terms of Sections 1 and 2 above on a
+medium customarily used for software interchange.
+
+  If distribution of object code is made by offering access to copy
+from a designated place, then offering equivalent access to copy the
+source code from the same place satisfies the requirement to
+distribute the source code, even though third parties are not
+compelled to copy the source along with the object code.
+
+  5. A program that contains no derivative of any portion of the
+Library, but is designed to work with the Library by being compiled or
+linked with it, is called a "work that uses the Library".  Such a
+work, in isolation, is not a derivative work of the Library, and
+therefore falls outside the scope of this License.
+
+  However, linking a "work that uses the Library" with the Library
+creates an executable that is a derivative of the Library (because it
+contains portions of the Library), rather than a "work that uses the
+library".  The executable is therefore covered by this License.
+Section 6 states terms for distribution of such executables.
+
+  When a "work that uses the Library" uses material from a header file
+that is part of the Library, the object code for the work may be a
+derivative work of the Library even though the source code is not.
+Whether this is true is especially significant if the work can be
+linked without the Library, or if the work is itself a library.  The
+threshold for this to be true is not precisely defined by law.
+
+  If such an object file uses only numerical parameters, data
+structure layouts and accessors, and small macros and small inline
+functions (ten lines or less in length), then the use of the object
+file is unrestricted, regardless of whether it is legally a derivative
+work.  (Executables containing this object code plus portions of the
+Library will still fall under Section 6.)
+
+  Otherwise, if the work is a derivative of the Library, you may
+distribute the object code for the work under the terms of Section 6.
+Any executables containing that work also fall under Section 6,
+whether or not they are linked directly with the Library itself.
+
+  6. As an exception to the Sections above, you may also combine or
+link a "work that uses the Library" with the Library to produce a
+work containing portions of the Library, and distribute that work
+under terms of your choice, provided that the terms permit
+modification of the work for the customer's own use and reverse
+engineering for debugging such modifications.
+
+  You must give prominent notice with each copy of the work that the
+Library is used in it and that the Library and its use are covered by
+this License.  You must supply a copy of this License.  If the work
+during execution displays copyright notices, you must include the
+copyright notice for the Library among them, as well as a reference
+directing the user to the copy of this License.  Also, you must do one
+of these things:
+
+    a) Accompany the work with the complete corresponding
+    machine-readable source code for the Library including whatever
+    changes were used in the work (which must be distributed under
+    Sections 1 and 2 above); and, if the work is an executable linked
+    with the Library, with the complete machine-readable "work that
+    uses the Library", as object code and/or source code, so that the
+    user can modify the Library and then relink to produce a modified
+    executable containing the modified Library.  (It is understood
+    that the user who changes the contents of definitions files in the
+    Library will not necessarily be able to recompile the application
+    to use the modified definitions.)
+
+    b) Use a suitable shared library mechanism for linking with the
+    Library.  A suitable mechanism is one that (1) uses at run time a
+    copy of the library already present on the user's computer system,
+    rather than copying library functions into the executable, and (2)
+    will operate properly with a modified version of the library, if
+    the user installs one, as long as the modified version is
+    interface-compatible with the version that the work was made with.
+
+    c) Accompany the work with a written offer, valid for at
+    least three years, to give the same user the materials
+    specified in Subsection 6a, above, for a charge no more
+    than the cost of performing this distribution.
+
+    d) If distribution of the work is made by offering access to copy
+    from a designated place, offer equivalent access to copy the above
+    specified materials from the same place.
+
+    e) Verify that the user has already received a copy of these
+    materials or that you have already sent this user a copy.
+
+  For an executable, the required form of the "work that uses the
+Library" must include any data and utility programs needed for
+reproducing the executable from it.  However, as a special exception,
+the materials to be distributed need not include anything that is
+normally distributed (in either source or binary form) with the major
+components (compiler, kernel, and so on) of the operating system on
+which the executable runs, unless that component itself accompanies
+the executable.
+
+  It may happen that this requirement contradicts the license
+restrictions of other proprietary libraries that do not normally
+accompany the operating system.  Such a contradiction means you cannot
+use both them and the Library together in an executable that you
+distribute.
+
+  7. You may place library facilities that are a work based on the
+Library side-by-side in a single library together with other library
+facilities not covered by this License, and distribute such a combined
+library, provided that the separate distribution of the work based on
+the Library and of the other library facilities is otherwise
+permitted, and provided that you do these two things:
+
+    a) Accompany the combined library with a copy of the same work
+    based on the Library, uncombined with any other library
+    facilities.  This must be distributed under the terms of the
+    Sections above.
+
+    b) Give prominent notice with the combined library of the fact
+    that part of it is a work based on the Library, and explaining
+    where to find the accompanying uncombined form of the same work.
+
+  8. You may not copy, modify, sublicense, link with, or distribute
+the Library except as expressly provided under this License.  Any
+attempt otherwise to copy, modify, sublicense, link with, or
+distribute the Library is void, and will automatically terminate your
+rights under this License.  However, parties who have received copies,
+or rights, from you under this License will not have their licenses
+terminated so long as such parties remain in full compliance.
+
+  9. You are not required to accept this License, since you have not
+signed it.  However, nothing else grants you permission to modify or
+distribute the Library or its derivative works.  These actions are
+prohibited by law if you do not accept this License.  Therefore, by
+modifying or distributing the Library (or any work based on the
+Library), you indicate your acceptance of this License to do so, and
+all its terms and conditions for copying, distributing or modifying
+the Library or works based on it.
+
+  10. Each time you redistribute the Library (or any work based on the
+Library), the recipient automatically receives a license from the
+original licensor to copy, distribute, link with or modify the Library
+subject to these terms and conditions.  You may not impose any further
+restrictions on the recipients' exercise of the rights granted herein.
+You are not responsible for enforcing compliance by third parties with
+this License.
+
+  11. If, as a consequence of a court judgment or allegation of patent
+infringement or for any other reason (not limited to patent issues),
+conditions are imposed on you (whether by court order, agreement or
+otherwise) that contradict the conditions of this License, they do not
+excuse you from the conditions of this License.  If you cannot
+distribute so as to satisfy simultaneously your obligations under this
+License and any other pertinent obligations, then as a consequence you
+may not distribute the Library at all.  For example, if a patent
+license would not permit royalty-free redistribution of the Library by
+all those who receive copies directly or indirectly through you, then
+the only way you could satisfy both it and this License would be to
+refrain entirely from distribution of the Library.
+
+If any portion of this section is held invalid or unenforceable under any
+particular circumstance, the balance of the section is intended to apply,
+and the section as a whole is intended to apply in other circumstances.
+
+It is not the purpose of this section to induce you to infringe any
+patents or other property right claims or to contest validity of any
+such claims; this section has the sole purpose of protecting the
+integrity of the free software distribution system which is
+implemented by public license practices.  Many people have made
+generous contributions to the wide range of software distributed
+through that system in reliance on consistent application of that
+system; it is up to the author/donor to decide if he or she is willing
+to distribute software through any other system and a licensee cannot
+impose that choice.
+
+This section is intended to make thoroughly clear what is believed to
+be a consequence of the rest of this License.
+
+  12. If the distribution and/or use of the Library is restricted in
+certain countries either by patents or by copyrighted interfaces, the
+original copyright holder who places the Library under this License may add
+an explicit geographical distribution limitation excluding those countries,
+so that distribution is permitted only in or among countries not thus
+excluded.  In such case, this License incorporates the limitation as if
+written in the body of this License.
+
+  13. The Free Software Foundation may publish revised and/or new
+versions of the Lesser General Public License from time to time.
+Such new versions will be similar in spirit to the present version,
+but may differ in detail to address new problems or concerns.
+
+Each version is given a distinguishing version number.  If the Library
+specifies a version number of this License which applies to it and
+"any later version", you have the option of following the terms and
+conditions either of that version or of any later version published by
+the Free Software Foundation.  If the Library does not specify a
+license version number, you may choose any version ever published by
+the Free Software Foundation.
+
+  14. If you wish to incorporate parts of the Library into other free
+programs whose distribution conditions are incompatible with these,
+write to the author to ask for permission.  For software which is
+copyrighted by the Free Software Foundation, write to the Free
+Software Foundation; we sometimes make exceptions for this.  Our
+decision will be guided by the two goals of preserving the free status
+of all derivatives of our free software and of promoting the sharing
+and reuse of software generally.
+
+			    NO WARRANTY
+
+  15. BECAUSE THE LIBRARY IS LICENSED FREE OF CHARGE, THERE IS NO
+WARRANTY FOR THE LIBRARY, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
+EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR
+OTHER PARTIES PROVIDE THE LIBRARY "AS IS" WITHOUT WARRANTY OF ANY
+KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
+IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
+LIBRARY IS WITH YOU.  SHOULD THE LIBRARY PROVE DEFECTIVE, YOU ASSUME
+THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
+
+  16. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN
+WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY
+AND/OR REDISTRIBUTE THE LIBRARY AS PERMITTED ABOVE, BE LIABLE TO YOU
+FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR
+CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
+LIBRARY (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
+RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
+FAILURE OF THE LIBRARY TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
+SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
+DAMAGES.
+
+		     END OF TERMS AND CONDITIONS
+
+           How to Apply These Terms to Your New Libraries
+
+  If you develop a new library, and you want it to be of the greatest
+possible use to the public, we recommend making it free software that
+everyone can redistribute and change.  You can do so by permitting
+redistribution under these terms (or, alternatively, under the terms of the
+ordinary General Public License).
+
+  To apply these terms, attach the following notices to the library.  It is
+safest to attach them to the start of each source file to most effectively
+convey the exclusion of warranty; and each file should have at least the
+"copyright" line and a pointer to where the full notice is found.
+
+    <one line to give the library's name and a brief idea of what it does.>
+    Copyright (C) <year>  <name of author>
+
+    This library is free software; you can redistribute it and/or
+    modify it under the terms of the GNU Lesser General Public
+    License as published by the Free Software Foundation; either
+    version 2.1 of the License, or (at your option) any later version.
+
+    This library is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+    Lesser General Public License for more details.
+
+    You should have received a copy of the GNU Lesser General Public
+    License along with this library; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+Also add information on how to contact you by electronic and paper mail.
+
+You should also get your employer (if you work as a programmer) or your
+school, if any, to sign a "copyright disclaimer" for the library, if
+necessary.  Here is a sample; alter the names:
+
+  Yoyodyne, Inc., hereby disclaims all copyright interest in the
+  library `Frob' (a library for tweaking knobs) written by James Random Hacker.
+
+  <signature of Ty Coon>, 1 April 1990
+  Ty Coon, President of Vice
+
+That's all there is to it!
+
+
/cvs/dm/dmraid/Makefile.in,v  -->  standard output
revision 1.1
--- dmraid/Makefile.in
+++ -	2008-02-22 16:50:39.293064000 +0000
@@ -0,0 +1,23 @@
+#
+# Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+
+SUBDIRS = include lib man tools
+
+TARGETS = tools/dmraid
+
+include make.tmpl
+
+tools: lib
+
+rpm:
+	rpmbuild -bb dmraid.spec
+
+srpm:
+	rpmbuild -bs dmraid.spec
/cvs/dm/dmraid/TODO,v  -->  standard output
revision 1.1
--- dmraid/TODO
+++ -	2008-02-22 16:50:39.371767000 +0000
@@ -0,0 +1,32 @@
+
+-- dmraid 1.0.0.rc11 TODO --					2006.05.15
+
+o more enhancements for RAID set consistency checks
+
+o neater -s output; something better than just paragraphs
+  for super- and subsets ?
+
+o higher RAID levels above 1; main restriction to support these is
+  the need for device-mapper targets which map RAID4 and RAID5
+  (Alpha patch for device-mapper RAID4/RAID5 target on my people page now)
+
+o MD metadata format handler
+
+o SNIA DDF metadata format handler
+
+o enhance metadata write feature in order to be able to store state changes
+  persistently; needs an event() method to inform the metadata handler about
+  state changes recognized eg, at the device-mapper interface layer
+
+o event daemon linked to libdmraid which keeps track of RAID device and set
+  state changes (eg, io errors) and decides about degration etc.;
+  dmeventd coded; needs library for dmraid access
+
+o more cleanup and enhance debug and verbose output
+
+o support other partitions than MSDOS on Software RAID devices or
+  use kpartx instead ?
+
+o regular expressions for metadata format, RAID device and RAID set selection
+
+o does dmraid need a config file ?
/cvs/dm/dmraid/aclocal.m4,v  -->  standard output
revision 1.1
--- dmraid/aclocal.m4
+++ -	2008-02-22 16:50:39.449270000 +0000
@@ -0,0 +1,75 @@
+# klibc.m4 serial 99
+## Copyright (C) 1995-2003 Free Software Foundation, Inc.
+## This file is free software, distributed under the terms of the GNU
+## General Public License.  As a special exception to the GNU General
+## Public License, this file may be distributed as part of a program
+## that contains a configuration script generated by Autoconf, under
+## the same distribution terms as the rest of that program.
+##
+## This file can can be used in projects which are not available under
+## the GNU General Public License or the GNU Library General Public
+## License but which still want to provide support for the GNU gettext
+## functionality.
+## Please note that the actual code of the GNU gettext library is covered
+## by the GNU Library General Public License, and the rest of the GNU
+## gettext package package is covered by the GNU General Public License.
+## They are *not* in the public domain.
+
+# Authors:
+#   Martin Schlemmer <azarah@nosferatu.za.org>, 2005.
+
+
+# AC_CHECK_KLIBC
+# --------------
+# Check if the user wants KLIBC support enabled.  If so, set KLIBC=yes and
+# fill in KLIBC_PREFIX, KLIBC_BINDIR, KLIBC_SBINDIR, KLIBC_LIBDIR and
+# KLIBC_INCLUDEDIR.  CC is also set to the proper klcc executable.
+# NOTE:  This should be called before AC_PROG_CC, and before header, function
+#        or type checks.
+AC_DEFUN([AC_CHECK_KLIBC],
+[AC_BEFORE([$0], [AC_PROG_CC])
+AC_REQUIRE([AC_CANONICAL_HOST])
+AC_ARG_ENABLE([klibc],
+              [AC_HELP_STRING([--enable-klibc],
+                              [Use this to link the tools to klibc. Set KLCC
+                               to the absolute file name of klcc if not in
+                               the PATH.])],
+              [KLIBC=$enableval], [KLIBC=no])
+
+if test "X$KLIBC" = Xyes; then
+  # Basic cross compiling support.  I do not think it is wise to use
+  # AC_CHECK_TOOL, because if we are cross compiling, we do not want
+  # just 'klcc' to be returned ...
+  if test "X$cross_compiling" = Xyes; then
+    AC_CHECK_PROGS([KLCC], [${host_alias}-klcc], [no])
+  else
+    AC_CHECK_PROGS([KLCC], [klcc], [no])
+  fi
+  if test "X$KLCC" = Xno; then
+    AC_MSG_ERROR([cannot find klibc frontend 'klcc'!])
+  fi
+
+  CC="$KLCC"
+  CFLAGS="-Os"
+  KLIBC_KCROSS="$($KLCC -print-klibc-kcross 2>/dev/null)"
+  KLIBC_PREFIX="$($KLCC -print-klibc-prefix 2>/dev/null)"
+  KLIBC_BIN_DIR="$($KLCC -print-klibc-bindir 2>/dev/null)"
+  KLIBC_SBIN_DIR="${KLIBC_PREFIX}/${KLIBC_KCROSS}sbin"
+  KLIBC_LIB_DIR="$($KLCC -print-klibc-libdir 2>/dev/null)"
+  KLIBC_INCLUDE_DIR="$($KLCC -print-klibc-includedir 2>/dev/null)"
+
+  # At least KLIBC_LIB_DIR should be valid, else klibc is too old or
+  # something went wrong
+  if test ! -d "$KLIBC_LIB_DIR"; then
+    AC_MSG_ERROR([your klibc installation is too old or not functional!])
+  fi
+fi
+
+AC_SUBST(KLIBC)
+AC_SUBST(KLIBC_PREFIX)
+AC_SUBST(KLIBC_BIN_DIR)
+AC_SUBST(KLIBC_SBIN_DIR)
+AC_SUBST(KLIBC_LIB_DIR)
+AC_SUBST(KLIBC_INCLUDE_DIR)
+])# AC_CHECK_KLIBC
+
/cvs/dm/dmraid/configure,v  -->  standard output
revision 1.1
--- dmraid/configure
+++ -	2008-02-22 16:50:39.526822000 +0000
@@ -0,0 +1,6318 @@
+#! /bin/sh
+# Guess values for system-dependent variables and create Makefiles.
+# Generated by GNU Autoconf 2.59.
+#
+# Copyright (C) 2003 Free Software Foundation, Inc.
+# This configure script is free software; the Free Software Foundation
+# gives unlimited permission to copy, distribute and modify it.
+## --------------------- ##
+## M4sh Initialization.  ##
+## --------------------- ##
+
+# Be Bourne compatible
+if test -n "${ZSH_VERSION+set}" && (emulate sh) >/dev/null 2>&1; then
+  emulate sh
+  NULLCMD=:
+  # Zsh 3.x and 4.x performs word splitting on ${1+"$@"}, which
+  # is contrary to our usage.  Disable this feature.
+  alias -g '${1+"$@"}'='"$@"'
+elif test -n "${BASH_VERSION+set}" && (set -o posix) >/dev/null 2>&1; then
+  set -o posix
+fi
+DUALCASE=1; export DUALCASE # for MKS sh
+
+# Support unset when possible.
+if ( (MAIL=60; unset MAIL) || exit) >/dev/null 2>&1; then
+  as_unset=unset
+else
+  as_unset=false
+fi
+
+
+# Work around bugs in pre-3.0 UWIN ksh.
+$as_unset ENV MAIL MAILPATH
+PS1='$ '
+PS2='> '
+PS4='+ '
+
+# NLS nuisances.
+for as_var in \
+  LANG LANGUAGE LC_ADDRESS LC_ALL LC_COLLATE LC_CTYPE LC_IDENTIFICATION \
+  LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER \
+  LC_TELEPHONE LC_TIME
+do
+  if (set +x; test -z "`(eval $as_var=C; export $as_var) 2>&1`"); then
+    eval $as_var=C; export $as_var
+  else
+    $as_unset $as_var
+  fi
+done
+
+# Required to use basename.
+if expr a : '\(a\)' >/dev/null 2>&1; then
+  as_expr=expr
+else
+  as_expr=false
+fi
+
+if (basename /) >/dev/null 2>&1 && test "X`basename / 2>&1`" = "X/"; then
+  as_basename=basename
+else
+  as_basename=false
+fi
+
+
+# Name of the executable.
+as_me=`$as_basename "$0" ||
+$as_expr X/"$0" : '.*/\([^/][^/]*\)/*$' \| \
+	 X"$0" : 'X\(//\)$' \| \
+	 X"$0" : 'X\(/\)$' \| \
+	 .     : '\(.\)' 2>/dev/null ||
+echo X/"$0" |
+    sed '/^.*\/\([^/][^/]*\)\/*$/{ s//\1/; q; }
+  	  /^X\/\(\/\/\)$/{ s//\1/; q; }
+  	  /^X\/\(\/\).*/{ s//\1/; q; }
+  	  s/.*/./; q'`
+
+
+# PATH needs CR, and LINENO needs CR and PATH.
+# Avoid depending upon Character Ranges.
+as_cr_letters='abcdefghijklmnopqrstuvwxyz'
+as_cr_LETTERS='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
+as_cr_Letters=$as_cr_letters$as_cr_LETTERS
+as_cr_digits='0123456789'
+as_cr_alnum=$as_cr_Letters$as_cr_digits
+
+# The user is always right.
+if test "${PATH_SEPARATOR+set}" != set; then
+  echo "#! /bin/sh" >conf$$.sh
+  echo  "exit 0"   >>conf$$.sh
+  chmod +x conf$$.sh
+  if (PATH="/nonexistent;."; conf$$.sh) >/dev/null 2>&1; then
+    PATH_SEPARATOR=';'
+  else
+    PATH_SEPARATOR=:
+  fi
+  rm -f conf$$.sh
+fi
+
+
+  as_lineno_1=$LINENO
+  as_lineno_2=$LINENO
+  as_lineno_3=`(expr $as_lineno_1 + 1) 2>/dev/null`
+  test "x$as_lineno_1" != "x$as_lineno_2" &&
+  test "x$as_lineno_3"  = "x$as_lineno_2"  || {
+  # Find who we are.  Look in the path if we contain no path at all
+  # relative or not.
+  case $0 in
+    *[\\/]* ) as_myself=$0 ;;
+    *) as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  test -r "$as_dir/$0" && as_myself=$as_dir/$0 && break
+done
+
+       ;;
+  esac
+  # We did not find ourselves, most probably we were run as `sh COMMAND'
+  # in which case we are not to be found in the path.
+  if test "x$as_myself" = x; then
+    as_myself=$0
+  fi
+  if test ! -f "$as_myself"; then
+    { echo "$as_me: error: cannot find myself; rerun with an absolute path" >&2
+   { (exit 1); exit 1; }; }
+  fi
+  case $CONFIG_SHELL in
+  '')
+    as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in /bin$PATH_SEPARATOR/usr/bin$PATH_SEPARATOR$PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for as_base in sh bash ksh sh5; do
+	 case $as_dir in
+	 /*)
+	   if ("$as_dir/$as_base" -c '
+  as_lineno_1=$LINENO
+  as_lineno_2=$LINENO
+  as_lineno_3=`(expr $as_lineno_1 + 1) 2>/dev/null`
+  test "x$as_lineno_1" != "x$as_lineno_2" &&
+  test "x$as_lineno_3"  = "x$as_lineno_2" ') 2>/dev/null; then
+	     $as_unset BASH_ENV || test "${BASH_ENV+set}" != set || { BASH_ENV=; export BASH_ENV; }
+	     $as_unset ENV || test "${ENV+set}" != set || { ENV=; export ENV; }
+	     CONFIG_SHELL=$as_dir/$as_base
+	     export CONFIG_SHELL
+	     exec "$CONFIG_SHELL" "$0" ${1+"$@"}
+	   fi;;
+	 esac
+       done
+done
+;;
+  esac
+
+  # Create $as_me.lineno as a copy of $as_myself, but with $LINENO
+  # uniformly replaced by the line number.  The first 'sed' inserts a
+  # line-number line before each line; the second 'sed' does the real
+  # work.  The second script uses 'N' to pair each line-number line
+  # with the numbered line, and appends trailing '-' during
+  # substitution so that $LINENO is not a special case at line end.
+  # (Raja R Harinath suggested sed '=', and Paul Eggert wrote the
+  # second 'sed' script.  Blame Lee E. McMahon for sed's syntax.  :-)
+  sed '=' <$as_myself |
+    sed '
+      N
+      s,$,-,
+      : loop
+      s,^\(['$as_cr_digits']*\)\(.*\)[$]LINENO\([^'$as_cr_alnum'_]\),\1\2\1\3,
+      t loop
+      s,-$,,
+      s,^['$as_cr_digits']*\n,,
+    ' >$as_me.lineno &&
+  chmod +x $as_me.lineno ||
+    { echo "$as_me: error: cannot create $as_me.lineno; rerun with a POSIX shell" >&2
+   { (exit 1); exit 1; }; }
+
+  # Don't try to exec as it changes $[0], causing all sort of problems
+  # (the dirname of $[0] is not the place where we might find the
+  # original and so on.  Autoconf is especially sensible to this).
+  . ./$as_me.lineno
+  # Exit status is that of the last command.
+  exit
+}
+
+
+case `echo "testing\c"; echo 1,2,3`,`echo -n testing; echo 1,2,3` in
+  *c*,-n*) ECHO_N= ECHO_C='
+' ECHO_T='	' ;;
+  *c*,*  ) ECHO_N=-n ECHO_C= ECHO_T= ;;
+  *)       ECHO_N= ECHO_C='\c' ECHO_T= ;;
+esac
+
+if expr a : '\(a\)' >/dev/null 2>&1; then
+  as_expr=expr
+else
+  as_expr=false
+fi
+
+rm -f conf$$ conf$$.exe conf$$.file
+echo >conf$$.file
+if ln -s conf$$.file conf$$ 2>/dev/null; then
+  # We could just check for DJGPP; but this test a) works b) is more generic
+  # and c) will remain valid once DJGPP supports symlinks (DJGPP 2.04).
+  if test -f conf$$.exe; then
+    # Don't use ln at all; we don't have any links
+    as_ln_s='cp -p'
+  else
+    as_ln_s='ln -s'
+  fi
+elif ln conf$$.file conf$$ 2>/dev/null; then
+  as_ln_s=ln
+else
+  as_ln_s='cp -p'
+fi
+rm -f conf$$ conf$$.exe conf$$.file
+
+if mkdir -p . 2>/dev/null; then
+  as_mkdir_p=:
+else
+  test -d ./-p && rmdir ./-p
+  as_mkdir_p=false
+fi
+
+as_executable_p="test -f"
+
+# Sed expression to map a string onto a valid CPP name.
+as_tr_cpp="eval sed 'y%*$as_cr_letters%P$as_cr_LETTERS%;s%[^_$as_cr_alnum]%_%g'"
+
+# Sed expression to map a string onto a valid variable name.
+as_tr_sh="eval sed 'y%*+%pp%;s%[^_$as_cr_alnum]%_%g'"
+
+
+# IFS
+# We need space, tab and new line, in precisely that order.
+as_nl='
+'
+IFS=" 	$as_nl"
+
+# CDPATH.
+$as_unset CDPATH
+
+
+# Name of the host.
+# hostname on some systems (SVR3.2, Linux) returns a bogus exit status,
+# so uname gets run too.
+ac_hostname=`(hostname || uname -n) 2>/dev/null | sed 1q`
+
+exec 6>&1
+
+#
+# Initializations.
+#
+ac_default_prefix=/usr/local
+ac_config_libobj_dir=.
+cross_compiling=no
+subdirs=
+MFLAGS=
+MAKEFLAGS=
+SHELL=${CONFIG_SHELL-/bin/sh}
+
+# Maximum number of lines to put in a shell here document.
+# This variable seems obsolete.  It should probably be removed, and
+# only ac_max_sed_lines should be used.
+: ${ac_max_here_lines=38}
+
+# Identity of this package.
+PACKAGE_NAME=
+PACKAGE_TARNAME=
+PACKAGE_VERSION=
+PACKAGE_STRING=
+PACKAGE_BUGREPORT=
+
+ac_unique_file="lib/device/dev-io.h"
+# Factoring default headers for most tests.
+ac_includes_default="\
+#include <stdio.h>
+#if HAVE_SYS_TYPES_H
+# include <sys/types.h>
+#endif
+#if HAVE_SYS_STAT_H
+# include <sys/stat.h>
+#endif
+#if STDC_HEADERS
+# include <stdlib.h>
+# include <stddef.h>
+#else
+# if HAVE_STDLIB_H
+#  include <stdlib.h>
+# endif
+#endif
+#if HAVE_STRING_H
+# if !STDC_HEADERS && HAVE_MEMORY_H
+#  include <memory.h>
+# endif
+# include <string.h>
+#endif
+#if HAVE_STRINGS_H
+# include <strings.h>
+#endif
+#if HAVE_INTTYPES_H
+# include <inttypes.h>
+#else
+# if HAVE_STDINT_H
+#  include <stdint.h>
+# endif
+#endif
+#if HAVE_UNISTD_H
+# include <unistd.h>
+#endif"
+
+ac_default_prefix=/usr
+ac_subst_vars='SHELL PATH_SEPARATOR PACKAGE_NAME PACKAGE_TARNAME PACKAGE_VERSION PACKAGE_STRING PACKAGE_BUGREPORT exec_prefix prefix program_transform_name bindir sbindir libexecdir datadir sysconfdir sharedstatedir localstatedir libdir includedir oldincludedir infodir mandir build_alias host_alias target_alias DEFS ECHO_C ECHO_N ECHO_T LIBS build build_cpu build_vendor build_os host host_cpu host_vendor host_os target target_cpu target_vendor target_os AWK INSTALL_PROGRAM INSTALL_SCRIPT INSTALL_DATA LN_S SET_MAKE RANLIB ac_ct_RANLIB KLCC KLIBC KLIBC_PREFIX KLIBC_BIN_DIR KLIBC_SBIN_DIR KLIBC_LIB_DIR KLIBC_INCLUDE_DIR CC CFLAGS LDFLAGS CPPFLAGS ac_ct_CC EXEEXT OBJEXT CPP EGREP CLDFLAGS DEBUG DEBUG_MALLOC DMRAID_TEST DMRAID_VERSION DMRAID_LIB_VERSION DIETLIBC GROUP JOBS LD_DEPS FLAVOUR LIBS
 ELINUX LIBSEPOL LIB_SO OWNER SOFLAG STATIC_LINK LIBOBJS LTLIBOBJS'
+ac_subst_files=''
+
+# Initialize some variables set by options.
+ac_init_help=
+ac_init_version=false
+# The variables have the same names as the options, with
+# dashes changed to underlines.
+cache_file=/dev/null
+exec_prefix=NONE
+no_create=
+no_recursion=
+prefix=NONE
+program_prefix=NONE
+program_suffix=NONE
+program_transform_name=s,x,x,
+silent=
+site=
+srcdir=
+verbose=
+x_includes=NONE
+x_libraries=NONE
+
+# Installation directory options.
+# These are left unexpanded so users can "make install exec_prefix=/foo"
+# and all the variables that are supposed to be based on exec_prefix
+# by default will actually change.
+# Use braces instead of parens because sh, perl, etc. also accept them.
+bindir='${exec_prefix}/bin'
+sbindir='${exec_prefix}/sbin'
+libexecdir='${exec_prefix}/libexec'
+datadir='${prefix}/share'
+sysconfdir='${prefix}/etc'
+sharedstatedir='${prefix}/com'
+localstatedir='${prefix}/var'
+libdir='${exec_prefix}/lib'
+includedir='${prefix}/include'
+oldincludedir='/usr/include'
+infodir='${prefix}/info'
+mandir='${prefix}/man'
+
+ac_prev=
+for ac_option
+do
+  # If the previous option needs an argument, assign it.
+  if test -n "$ac_prev"; then
+    eval "$ac_prev=\$ac_option"
+    ac_prev=
+    continue
+  fi
+
+  ac_optarg=`expr "x$ac_option" : 'x[^=]*=\(.*\)'`
+
+  # Accept the important Cygnus configure options, so we can diagnose typos.
+
+  case $ac_option in
+
+  -bindir | --bindir | --bindi | --bind | --bin | --bi)
+    ac_prev=bindir ;;
+  -bindir=* | --bindir=* | --bindi=* | --bind=* | --bin=* | --bi=*)
+    bindir=$ac_optarg ;;
+
+  -build | --build | --buil | --bui | --bu)
+    ac_prev=build_alias ;;
+  -build=* | --build=* | --buil=* | --bui=* | --bu=*)
+    build_alias=$ac_optarg ;;
+
+  -cache-file | --cache-file | --cache-fil | --cache-fi \
+  | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
+    ac_prev=cache_file ;;
+  -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
+  | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* | --c=*)
+    cache_file=$ac_optarg ;;
+
+  --config-cache | -C)
+    cache_file=config.cache ;;
+
+  -datadir | --datadir | --datadi | --datad | --data | --dat | --da)
+    ac_prev=datadir ;;
+  -datadir=* | --datadir=* | --datadi=* | --datad=* | --data=* | --dat=* \
+  | --da=*)
+    datadir=$ac_optarg ;;
+
+  -disable-* | --disable-*)
+    ac_feature=`expr "x$ac_option" : 'x-*disable-\(.*\)'`
+    # Reject names that are not valid shell variable names.
+    expr "x$ac_feature" : ".*[^-_$as_cr_alnum]" >/dev/null &&
+      { echo "$as_me: error: invalid feature name: $ac_feature" >&2
+   { (exit 1); exit 1; }; }
+    ac_feature=`echo $ac_feature | sed 's/-/_/g'`
+    eval "enable_$ac_feature=no" ;;
+
+  -enable-* | --enable-*)
+    ac_feature=`expr "x$ac_option" : 'x-*enable-\([^=]*\)'`
+    # Reject names that are not valid shell variable names.
+    expr "x$ac_feature" : ".*[^-_$as_cr_alnum]" >/dev/null &&
+      { echo "$as_me: error: invalid feature name: $ac_feature" >&2
+   { (exit 1); exit 1; }; }
+    ac_feature=`echo $ac_feature | sed 's/-/_/g'`
+    case $ac_option in
+      *=*) ac_optarg=`echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"`;;
+      *) ac_optarg=yes ;;
+    esac
+    eval "enable_$ac_feature='$ac_optarg'" ;;
+
+  -exec-prefix | --exec_prefix | --exec-prefix | --exec-prefi \
+  | --exec-pref | --exec-pre | --exec-pr | --exec-p | --exec- \
+  | --exec | --exe | --ex)
+    ac_prev=exec_prefix ;;
+  -exec-prefix=* | --exec_prefix=* | --exec-prefix=* | --exec-prefi=* \
+  | --exec-pref=* | --exec-pre=* | --exec-pr=* | --exec-p=* | --exec-=* \
+  | --exec=* | --exe=* | --ex=*)
+    exec_prefix=$ac_optarg ;;
+
+  -gas | --gas | --ga | --g)
+    # Obsolete; use --with-gas.
+    with_gas=yes ;;
+
+  -help | --help | --hel | --he | -h)
+    ac_init_help=long ;;
+  -help=r* | --help=r* | --hel=r* | --he=r* | -hr*)
+    ac_init_help=recursive ;;
+  -help=s* | --help=s* | --hel=s* | --he=s* | -hs*)
+    ac_init_help=short ;;
+
+  -host | --host | --hos | --ho)
+    ac_prev=host_alias ;;
+  -host=* | --host=* | --hos=* | --ho=*)
+    host_alias=$ac_optarg ;;
+
+  -includedir | --includedir | --includedi | --included | --include \
+  | --includ | --inclu | --incl | --inc)
+    ac_prev=includedir ;;
+  -includedir=* | --includedir=* | --includedi=* | --included=* | --include=* \
+  | --includ=* | --inclu=* | --incl=* | --inc=*)
+    includedir=$ac_optarg ;;
+
+  -infodir | --infodir | --infodi | --infod | --info | --inf)
+    ac_prev=infodir ;;
+  -infodir=* | --infodir=* | --infodi=* | --infod=* | --info=* | --inf=*)
+    infodir=$ac_optarg ;;
+
+  -libdir | --libdir | --libdi | --libd)
+    ac_prev=libdir ;;
+  -libdir=* | --libdir=* | --libdi=* | --libd=*)
+    libdir=$ac_optarg ;;
+
+  -libexecdir | --libexecdir | --libexecdi | --libexecd | --libexec \
+  | --libexe | --libex | --libe)
+    ac_prev=libexecdir ;;
+  -libexecdir=* | --libexecdir=* | --libexecdi=* | --libexecd=* | --libexec=* \
+  | --libexe=* | --libex=* | --libe=*)
+    libexecdir=$ac_optarg ;;
+
+  -localstatedir | --localstatedir | --localstatedi | --localstated \
+  | --localstate | --localstat | --localsta | --localst \
+  | --locals | --local | --loca | --loc | --lo)
+    ac_prev=localstatedir ;;
+  -localstatedir=* | --localstatedir=* | --localstatedi=* | --localstated=* \
+  | --localstate=* | --localstat=* | --localsta=* | --localst=* \
+  | --locals=* | --local=* | --loca=* | --loc=* | --lo=*)
+    localstatedir=$ac_optarg ;;
+
+  -mandir | --mandir | --mandi | --mand | --man | --ma | --m)
+    ac_prev=mandir ;;
+  -mandir=* | --mandir=* | --mandi=* | --mand=* | --man=* | --ma=* | --m=*)
+    mandir=$ac_optarg ;;
+
+  -nfp | --nfp | --nf)
+    # Obsolete; use --without-fp.
+    with_fp=no ;;
+
+  -no-create | --no-create | --no-creat | --no-crea | --no-cre \
+  | --no-cr | --no-c | -n)
+    no_create=yes ;;
+
+  -no-recursion | --no-recursion | --no-recursio | --no-recursi \
+  | --no-recurs | --no-recur | --no-recu | --no-rec | --no-re | --no-r)
+    no_recursion=yes ;;
+
+  -oldincludedir | --oldincludedir | --oldincludedi | --oldincluded \
+  | --oldinclude | --oldinclud | --oldinclu | --oldincl | --oldinc \
+  | --oldin | --oldi | --old | --ol | --o)
+    ac_prev=oldincludedir ;;
+  -oldincludedir=* | --oldincludedir=* | --oldincludedi=* | --oldincluded=* \
+  | --oldinclude=* | --oldinclud=* | --oldinclu=* | --oldincl=* | --oldinc=* \
+  | --oldin=* | --oldi=* | --old=* | --ol=* | --o=*)
+    oldincludedir=$ac_optarg ;;
+
+  -prefix | --prefix | --prefi | --pref | --pre | --pr | --p)
+    ac_prev=prefix ;;
+  -prefix=* | --prefix=* | --prefi=* | --pref=* | --pre=* | --pr=* | --p=*)
+    prefix=$ac_optarg ;;
+
+  -program-prefix | --program-prefix | --program-prefi | --program-pref \
+  | --program-pre | --program-pr | --program-p)
+    ac_prev=program_prefix ;;
+  -program-prefix=* | --program-prefix=* | --program-prefi=* \
+  | --program-pref=* | --program-pre=* | --program-pr=* | --program-p=*)
+    program_prefix=$ac_optarg ;;
+
+  -program-suffix | --program-suffix | --program-suffi | --program-suff \
+  | --program-suf | --program-su | --program-s)
+    ac_prev=program_suffix ;;
+  -program-suffix=* | --program-suffix=* | --program-suffi=* \
+  | --program-suff=* | --program-suf=* | --program-su=* | --program-s=*)
+    program_suffix=$ac_optarg ;;
+
+  -program-transform-name | --program-transform-name \
+  | --program-transform-nam | --program-transform-na \
+  | --program-transform-n | --program-transform- \
+  | --program-transform | --program-transfor \
+  | --program-transfo | --program-transf \
+  | --program-trans | --program-tran \
+  | --progr-tra | --program-tr | --program-t)
+    ac_prev=program_transform_name ;;
+  -program-transform-name=* | --program-transform-name=* \
+  | --program-transform-nam=* | --program-transform-na=* \
+  | --program-transform-n=* | --program-transform-=* \
+  | --program-transform=* | --program-transfor=* \
+  | --program-transfo=* | --program-transf=* \
+  | --program-trans=* | --program-tran=* \
+  | --progr-tra=* | --program-tr=* | --program-t=*)
+    program_transform_name=$ac_optarg ;;
+
+  -q | -quiet | --quiet | --quie | --qui | --qu | --q \
+  | -silent | --silent | --silen | --sile | --sil)
+    silent=yes ;;
+
+  -sbindir | --sbindir | --sbindi | --sbind | --sbin | --sbi | --sb)
+    ac_prev=sbindir ;;
+  -sbindir=* | --sbindir=* | --sbindi=* | --sbind=* | --sbin=* \
+  | --sbi=* | --sb=*)
+    sbindir=$ac_optarg ;;
+
+  -sharedstatedir | --sharedstatedir | --sharedstatedi \
+  | --sharedstated | --sharedstate | --sharedstat | --sharedsta \
+  | --sharedst | --shareds | --shared | --share | --shar \
+  | --sha | --sh)
+    ac_prev=sharedstatedir ;;
+  -sharedstatedir=* | --sharedstatedir=* | --sharedstatedi=* \
+  | --sharedstated=* | --sharedstate=* | --sharedstat=* | --sharedsta=* \
+  | --sharedst=* | --shareds=* | --shared=* | --share=* | --shar=* \
+  | --sha=* | --sh=*)
+    sharedstatedir=$ac_optarg ;;
+
+  -site | --site | --sit)
+    ac_prev=site ;;
+  -site=* | --site=* | --sit=*)
+    site=$ac_optarg ;;
+
+  -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
+    ac_prev=srcdir ;;
+  -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
+    srcdir=$ac_optarg ;;
+
+  -sysconfdir | --sysconfdir | --sysconfdi | --sysconfd | --sysconf \
+  | --syscon | --sysco | --sysc | --sys | --sy)
+    ac_prev=sysconfdir ;;
+  -sysconfdir=* | --sysconfdir=* | --sysconfdi=* | --sysconfd=* | --sysconf=* \
+  | --syscon=* | --sysco=* | --sysc=* | --sys=* | --sy=*)
+    sysconfdir=$ac_optarg ;;
+
+  -target | --target | --targe | --targ | --tar | --ta | --t)
+    ac_prev=target_alias ;;
+  -target=* | --target=* | --targe=* | --targ=* | --tar=* | --ta=* | --t=*)
+    target_alias=$ac_optarg ;;
+
+  -v | -verbose | --verbose | --verbos | --verbo | --verb)
+    verbose=yes ;;
+
+  -version | --version | --versio | --versi | --vers | -V)
+    ac_init_version=: ;;
+
+  -with-* | --with-*)
+    ac_package=`expr "x$ac_option" : 'x-*with-\([^=]*\)'`
+    # Reject names that are not valid shell variable names.
+    expr "x$ac_package" : ".*[^-_$as_cr_alnum]" >/dev/null &&
+      { echo "$as_me: error: invalid package name: $ac_package" >&2
+   { (exit 1); exit 1; }; }
+    ac_package=`echo $ac_package| sed 's/-/_/g'`
+    case $ac_option in
+      *=*) ac_optarg=`echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"`;;
+      *) ac_optarg=yes ;;
+    esac
+    eval "with_$ac_package='$ac_optarg'" ;;
+
+  -without-* | --without-*)
+    ac_package=`expr "x$ac_option" : 'x-*without-\(.*\)'`
+    # Reject names that are not valid shell variable names.
+    expr "x$ac_package" : ".*[^-_$as_cr_alnum]" >/dev/null &&
+      { echo "$as_me: error: invalid package name: $ac_package" >&2
+   { (exit 1); exit 1; }; }
+    ac_package=`echo $ac_package | sed 's/-/_/g'`
+    eval "with_$ac_package=no" ;;
+
+  --x)
+    # Obsolete; use --with-x.
+    with_x=yes ;;
+
+  -x-includes | --x-includes | --x-include | --x-includ | --x-inclu \
+  | --x-incl | --x-inc | --x-in | --x-i)
+    ac_prev=x_includes ;;
+  -x-includes=* | --x-includes=* | --x-include=* | --x-includ=* | --x-inclu=* \
+  | --x-incl=* | --x-inc=* | --x-in=* | --x-i=*)
+    x_includes=$ac_optarg ;;
+
+  -x-libraries | --x-libraries | --x-librarie | --x-librari \
+  | --x-librar | --x-libra | --x-libr | --x-lib | --x-li | --x-l)
+    ac_prev=x_libraries ;;
+  -x-libraries=* | --x-libraries=* | --x-librarie=* | --x-librari=* \
+  | --x-librar=* | --x-libra=* | --x-libr=* | --x-lib=* | --x-li=* | --x-l=*)
+    x_libraries=$ac_optarg ;;
+
+  -*) { echo "$as_me: error: unrecognized option: $ac_option
+Try \`$0 --help' for more information." >&2
+   { (exit 1); exit 1; }; }
+    ;;
+
+  *=*)
+    ac_envvar=`expr "x$ac_option" : 'x\([^=]*\)='`
+    # Reject names that are not valid shell variable names.
+    expr "x$ac_envvar" : ".*[^_$as_cr_alnum]" >/dev/null &&
+      { echo "$as_me: error: invalid variable name: $ac_envvar" >&2
+   { (exit 1); exit 1; }; }
+    ac_optarg=`echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"`
+    eval "$ac_envvar='$ac_optarg'"
+    export $ac_envvar ;;
+
+  *)
+    # FIXME: should be removed in autoconf 3.0.
+    echo "$as_me: WARNING: you should use --build, --host, --target" >&2
+    expr "x$ac_option" : ".*[^-._$as_cr_alnum]" >/dev/null &&
+      echo "$as_me: WARNING: invalid host type: $ac_option" >&2
+    : ${build_alias=$ac_option} ${host_alias=$ac_option} ${target_alias=$ac_option}
+    ;;
+
+  esac
+done
+
+if test -n "$ac_prev"; then
+  ac_option=--`echo $ac_prev | sed 's/_/-/g'`
+  { echo "$as_me: error: missing argument to $ac_option" >&2
+   { (exit 1); exit 1; }; }
+fi
+
+# Be sure to have absolute paths.
+for ac_var in exec_prefix prefix
+do
+  eval ac_val=$`echo $ac_var`
+  case $ac_val in
+    [\\/$]* | ?:[\\/]* | NONE | '' ) ;;
+    *)  { echo "$as_me: error: expected an absolute directory name for --$ac_var: $ac_val" >&2
+   { (exit 1); exit 1; }; };;
+  esac
+done
+
+# Be sure to have absolute paths.
+for ac_var in bindir sbindir libexecdir datadir sysconfdir sharedstatedir \
+	      localstatedir libdir includedir oldincludedir infodir mandir
+do
+  eval ac_val=$`echo $ac_var`
+  case $ac_val in
+    [\\/$]* | ?:[\\/]* ) ;;
+    *)  { echo "$as_me: error: expected an absolute directory name for --$ac_var: $ac_val" >&2
+   { (exit 1); exit 1; }; };;
+  esac
+done
+
+# There might be people who depend on the old broken behavior: `$host'
+# used to hold the argument of --host etc.
+# FIXME: To remove some day.
+build=$build_alias
+host=$host_alias
+target=$target_alias
+
+# FIXME: To remove some day.
+if test "x$host_alias" != x; then
+  if test "x$build_alias" = x; then
+    cross_compiling=maybe
+    echo "$as_me: WARNING: If you wanted to set the --build type, don't use --host.
+    If a cross compiler is detected then cross compile mode will be used." >&2
+  elif test "x$build_alias" != "x$host_alias"; then
+    cross_compiling=yes
+  fi
+fi
+
+ac_tool_prefix=
+test -n "$host_alias" && ac_tool_prefix=$host_alias-
+
+test "$silent" = yes && exec 6>/dev/null
+
+
+# Find the source files, if location was not specified.
+if test -z "$srcdir"; then
+  ac_srcdir_defaulted=yes
+  # Try the directory containing this script, then its parent.
+  ac_confdir=`(dirname "$0") 2>/dev/null ||
+$as_expr X"$0" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
+	 X"$0" : 'X\(//\)[^/]' \| \
+	 X"$0" : 'X\(//\)$' \| \
+	 X"$0" : 'X\(/\)' \| \
+	 .     : '\(.\)' 2>/dev/null ||
+echo X"$0" |
+    sed '/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{ s//\1/; q; }
+  	  /^X\(\/\/\)[^/].*/{ s//\1/; q; }
+  	  /^X\(\/\/\)$/{ s//\1/; q; }
+  	  /^X\(\/\).*/{ s//\1/; q; }
+  	  s/.*/./; q'`
+  srcdir=$ac_confdir
+  if test ! -r $srcdir/$ac_unique_file; then
+    srcdir=..
+  fi
+else
+  ac_srcdir_defaulted=no
+fi
+if test ! -r $srcdir/$ac_unique_file; then
+  if test "$ac_srcdir_defaulted" = yes; then
+    { echo "$as_me: error: cannot find sources ($ac_unique_file) in $ac_confdir or .." >&2
+   { (exit 1); exit 1; }; }
+  else
+    { echo "$as_me: error: cannot find sources ($ac_unique_file) in $srcdir" >&2
+   { (exit 1); exit 1; }; }
+  fi
+fi
+(cd $srcdir && test -r ./$ac_unique_file) 2>/dev/null ||
+  { echo "$as_me: error: sources are in $srcdir, but \`cd $srcdir' does not work" >&2
+   { (exit 1); exit 1; }; }
+srcdir=`echo "$srcdir" | sed 's%\([^\\/]\)[\\/]*$%\1%'`
+ac_env_build_alias_set=${build_alias+set}
+ac_env_build_alias_value=$build_alias
+ac_cv_env_build_alias_set=${build_alias+set}
+ac_cv_env_build_alias_value=$build_alias
+ac_env_host_alias_set=${host_alias+set}
+ac_env_host_alias_value=$host_alias
+ac_cv_env_host_alias_set=${host_alias+set}
+ac_cv_env_host_alias_value=$host_alias
+ac_env_target_alias_set=${target_alias+set}
+ac_env_target_alias_value=$target_alias
+ac_cv_env_target_alias_set=${target_alias+set}
+ac_cv_env_target_alias_value=$target_alias
+ac_env_CC_set=${CC+set}
+ac_env_CC_value=$CC
+ac_cv_env_CC_set=${CC+set}
+ac_cv_env_CC_value=$CC
+ac_env_CFLAGS_set=${CFLAGS+set}
+ac_env_CFLAGS_value=$CFLAGS
+ac_cv_env_CFLAGS_set=${CFLAGS+set}
+ac_cv_env_CFLAGS_value=$CFLAGS
+ac_env_LDFLAGS_set=${LDFLAGS+set}
+ac_env_LDFLAGS_value=$LDFLAGS
+ac_cv_env_LDFLAGS_set=${LDFLAGS+set}
+ac_cv_env_LDFLAGS_value=$LDFLAGS
+ac_env_CPPFLAGS_set=${CPPFLAGS+set}
+ac_env_CPPFLAGS_value=$CPPFLAGS
+ac_cv_env_CPPFLAGS_set=${CPPFLAGS+set}
+ac_cv_env_CPPFLAGS_value=$CPPFLAGS
+ac_env_CPP_set=${CPP+set}
+ac_env_CPP_value=$CPP
+ac_cv_env_CPP_set=${CPP+set}
+ac_cv_env_CPP_value=$CPP
+
+#
+# Report the --help message.
+#
+if test "$ac_init_help" = "long"; then
+  # Omit some internal or obsolete options to make the list less imposing.
+  # This message is too long to be a string in the A/UX 3.1 sh.
+  cat <<_ACEOF
+\`configure' configures this package to adapt to many kinds of systems.
+
+Usage: $0 [OPTION]... [VAR=VALUE]...
+
+To assign environment variables (e.g., CC, CFLAGS...), specify them as
+VAR=VALUE.  See below for descriptions of some of the useful variables.
+
+Defaults for the options are specified in brackets.
+
+Configuration:
+  -h, --help              display this help and exit
+      --help=short        display options specific to this package
+      --help=recursive    display the short help of all the included packages
+  -V, --version           display version information and exit
+  -q, --quiet, --silent   do not print \`checking...' messages
+      --cache-file=FILE   cache test results in FILE [disabled]
+  -C, --config-cache      alias for \`--cache-file=config.cache'
+  -n, --no-create         do not create output files
+      --srcdir=DIR        find the sources in DIR [configure dir or \`..']
+
+_ACEOF
+
+  cat <<_ACEOF
+Installation directories:
+  --prefix=PREFIX         install architecture-independent files in PREFIX
+			  [$ac_default_prefix]
+  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
+			  [PREFIX]
+
+By default, \`make install' will install all the files in
+\`$ac_default_prefix/bin', \`$ac_default_prefix/lib' etc.  You can specify
+an installation prefix other than \`$ac_default_prefix' using \`--prefix',
+for instance \`--prefix=\$HOME'.
+
+For better control, use the options below.
+
+Fine tuning of the installation directories:
+  --bindir=DIR           user executables [EPREFIX/bin]
+  --sbindir=DIR          system admin executables [EPREFIX/sbin]
+  --libexecdir=DIR       program executables [EPREFIX/libexec]
+  --datadir=DIR          read-only architecture-independent data [PREFIX/share]
+  --sysconfdir=DIR       read-only single-machine data [PREFIX/etc]
+  --sharedstatedir=DIR   modifiable architecture-independent data [PREFIX/com]
+  --localstatedir=DIR    modifiable single-machine data [PREFIX/var]
+  --libdir=DIR           object code libraries [EPREFIX/lib]
+  --includedir=DIR       C header files [PREFIX/include]
+  --oldincludedir=DIR    C header files for non-gcc [/usr/include]
+  --infodir=DIR          info documentation [PREFIX/info]
+  --mandir=DIR           man documentation [PREFIX/man]
+_ACEOF
+
+  cat <<\_ACEOF
+
+System types:
+  --build=BUILD     configure for building on BUILD [guessed]
+  --host=HOST       cross-compile to build programs to run on HOST [BUILD]
+  --target=TARGET   configure for building compilers for TARGET [HOST]
+_ACEOF
+fi
+
+if test -n "$ac_init_help"; then
+
+  cat <<\_ACEOF
+
+Optional Features:
+  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
+  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
+  --enable-klibc          Use this to link the tools to klibc. Set KLCC to the
+                          absolute file name of klcc if not in the PATH.
+  --enable-debug          Enable debugging
+  --enable-debug_malloc   Enable malloc debugging
+  --enable-dietlibc       Use this to link the tools to dietlibc
+  --enable-jobs=NUM       Number of jobs to run simultaneously
+  --enable-libselinux     Use this to link the tools to libselinux
+  --enable-libsepol       Use this to link the tools to libsepol
+  --enable-mini           Use this to create a minimal binrary suitable
+                          for early boot environments
+  --disable-native_log    Disable native metadata logging. Default is enabled
+  --enable-static_link    Use this to link the tools to the dmraid and devmapper
+                          libraries statically.  Default is dynamic linking
+  --enable-shared_lib     Use this to generate shared libdmraid and link the
+                          tools to it. Default is static libdmraid
+  --disable-testing       Disable testing with mapped devices
+
+Optional Packages:
+  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
+  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
+  --with-user=USER        Set the owner of installed files
+  --with-group=GROUP      Set the group owner of installed files
+
+Some influential environment variables:
+  CC          C compiler command
+  CFLAGS      C compiler flags
+  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
+              nonstandard directory <lib dir>
+  CPPFLAGS    C/C++ preprocessor flags, e.g. -I<include dir> if you have
+              headers in a nonstandard directory <include dir>
+  CPP         C preprocessor
+
+Use these variables to override the choices made by `configure' or to help
+it to find libraries and programs with nonstandard names/locations.
+
+_ACEOF
+fi
+
+if test "$ac_init_help" = "recursive"; then
+  # If there are subdirs, report their specific --help.
+  ac_popdir=`pwd`
+  for ac_dir in : $ac_subdirs_all; do test "x$ac_dir" = x: && continue
+    test -d $ac_dir || continue
+    ac_builddir=.
+
+if test "$ac_dir" != .; then
+  ac_dir_suffix=/`echo "$ac_dir" | sed 's,^\.[\\/],,'`
+  # A "../" for each directory in $ac_dir_suffix.
+  ac_top_builddir=`echo "$ac_dir_suffix" | sed 's,/[^\\/]*,../,g'`
+else
+  ac_dir_suffix= ac_top_builddir=
+fi
+
+case $srcdir in
+  .)  # No --srcdir option.  We are building in place.
+    ac_srcdir=.
+    if test -z "$ac_top_builddir"; then
+       ac_top_srcdir=.
+    else
+       ac_top_srcdir=`echo $ac_top_builddir | sed 's,/$,,'`
+    fi ;;
+  [\\/]* | ?:[\\/]* )  # Absolute path.
+    ac_srcdir=$srcdir$ac_dir_suffix;
+    ac_top_srcdir=$srcdir ;;
+  *) # Relative path.
+    ac_srcdir=$ac_top_builddir$srcdir$ac_dir_suffix
+    ac_top_srcdir=$ac_top_builddir$srcdir ;;
+esac
+
+# Do not use `cd foo && pwd` to compute absolute paths, because
+# the directories may not exist.
+case `pwd` in
+.) ac_abs_builddir="$ac_dir";;
+*)
+  case "$ac_dir" in
+  .) ac_abs_builddir=`pwd`;;
+  [\\/]* | ?:[\\/]* ) ac_abs_builddir="$ac_dir";;
+  *) ac_abs_builddir=`pwd`/"$ac_dir";;
+  esac;;
+esac
+case $ac_abs_builddir in
+.) ac_abs_top_builddir=${ac_top_builddir}.;;
+*)
+  case ${ac_top_builddir}. in
+  .) ac_abs_top_builddir=$ac_abs_builddir;;
+  [\\/]* | ?:[\\/]* ) ac_abs_top_builddir=${ac_top_builddir}.;;
+  *) ac_abs_top_builddir=$ac_abs_builddir/${ac_top_builddir}.;;
+  esac;;
+esac
+case $ac_abs_builddir in
+.) ac_abs_srcdir=$ac_srcdir;;
+*)
+  case $ac_srcdir in
+  .) ac_abs_srcdir=$ac_abs_builddir;;
+  [\\/]* | ?:[\\/]* ) ac_abs_srcdir=$ac_srcdir;;
+  *) ac_abs_srcdir=$ac_abs_builddir/$ac_srcdir;;
+  esac;;
+esac
+case $ac_abs_builddir in
+.) ac_abs_top_srcdir=$ac_top_srcdir;;
+*)
+  case $ac_top_srcdir in
+  .) ac_abs_top_srcdir=$ac_abs_builddir;;
+  [\\/]* | ?:[\\/]* ) ac_abs_top_srcdir=$ac_top_srcdir;;
+  *) ac_abs_top_srcdir=$ac_abs_builddir/$ac_top_srcdir;;
+  esac;;
+esac
+
+    cd $ac_dir
+    # Check for guested configure; otherwise get Cygnus style configure.
+    if test -f $ac_srcdir/configure.gnu; then
+      echo
+      $SHELL $ac_srcdir/configure.gnu  --help=recursive
+    elif test -f $ac_srcdir/configure; then
+      echo
+      $SHELL $ac_srcdir/configure  --help=recursive
+    elif test -f $ac_srcdir/configure.ac ||
+	   test -f $ac_srcdir/configure.in; then
+      echo
+      $ac_configure --help
+    else
+      echo "$as_me: WARNING: no configuration information is in $ac_dir" >&2
+    fi
+    cd $ac_popdir
+  done
+fi
+
+test -n "$ac_init_help" && exit 0
+if $ac_init_version; then
+  cat <<\_ACEOF
+
+Copyright (C) 2003 Free Software Foundation, Inc.
+This configure script is free software; the Free Software Foundation
+gives unlimited permission to copy, distribute and modify it.
+_ACEOF
+  exit 0
+fi
+exec 5>config.log
+cat >&5 <<_ACEOF
+This file contains any messages produced by compilers while
+running configure, to aid debugging if configure makes a mistake.
+
+It was created by $as_me, which was
+generated by GNU Autoconf 2.59.  Invocation command line was
+
+  $ $0 $@
+
+_ACEOF
+{
+cat <<_ASUNAME
+## --------- ##
+## Platform. ##
+## --------- ##
+
+hostname = `(hostname || uname -n) 2>/dev/null | sed 1q`
+uname -m = `(uname -m) 2>/dev/null || echo unknown`
+uname -r = `(uname -r) 2>/dev/null || echo unknown`
+uname -s = `(uname -s) 2>/dev/null || echo unknown`
+uname -v = `(uname -v) 2>/dev/null || echo unknown`
+
+/usr/bin/uname -p = `(/usr/bin/uname -p) 2>/dev/null || echo unknown`
+/bin/uname -X     = `(/bin/uname -X) 2>/dev/null     || echo unknown`
+
+/bin/arch              = `(/bin/arch) 2>/dev/null              || echo unknown`
+/usr/bin/arch -k       = `(/usr/bin/arch -k) 2>/dev/null       || echo unknown`
+/usr/convex/getsysinfo = `(/usr/convex/getsysinfo) 2>/dev/null || echo unknown`
+hostinfo               = `(hostinfo) 2>/dev/null               || echo unknown`
+/bin/machine           = `(/bin/machine) 2>/dev/null           || echo unknown`
+/usr/bin/oslevel       = `(/usr/bin/oslevel) 2>/dev/null       || echo unknown`
+/bin/universe          = `(/bin/universe) 2>/dev/null          || echo unknown`
+
+_ASUNAME
+
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  echo "PATH: $as_dir"
+done
+
+} >&5
+
+cat >&5 <<_ACEOF
+
+
+## ----------- ##
+## Core tests. ##
+## ----------- ##
+
+_ACEOF
+
+
+# Keep a trace of the command line.
+# Strip out --no-create and --no-recursion so they do not pile up.
+# Strip out --silent because we don't want to record it for future runs.
+# Also quote any args containing shell meta-characters.
+# Make two passes to allow for proper duplicate-argument suppression.
+ac_configure_args=
+ac_configure_args0=
+ac_configure_args1=
+ac_sep=
+ac_must_keep_next=false
+for ac_pass in 1 2
+do
+  for ac_arg
+  do
+    case $ac_arg in
+    -no-create | --no-c* | -n | -no-recursion | --no-r*) continue ;;
+    -q | -quiet | --quiet | --quie | --qui | --qu | --q \
+    | -silent | --silent | --silen | --sile | --sil)
+      continue ;;
+    *" "*|*"	"*|*[\[\]\~\#\$\^\&\*\(\)\{\}\\\|\;\<\>\?\"\']*)
+      ac_arg=`echo "$ac_arg" | sed "s/'/'\\\\\\\\''/g"` ;;
+    esac
+    case $ac_pass in
+    1) ac_configure_args0="$ac_configure_args0 '$ac_arg'" ;;
+    2)
+      ac_configure_args1="$ac_configure_args1 '$ac_arg'"
+      if test $ac_must_keep_next = true; then
+	ac_must_keep_next=false # Got value, back to normal.
+      else
+	case $ac_arg in
+	  *=* | --config-cache | -C | -disable-* | --disable-* \
+	  | -enable-* | --enable-* | -gas | --g* | -nfp | --nf* \
+	  | -q | -quiet | --q* | -silent | --sil* | -v | -verb* \
+	  | -with-* | --with-* | -without-* | --without-* | --x)
+	    case "$ac_configure_args0 " in
+	      "$ac_configure_args1"*" '$ac_arg' "* ) continue ;;
+	    esac
+	    ;;
+	  -* ) ac_must_keep_next=true ;;
+	esac
+      fi
+      ac_configure_args="$ac_configure_args$ac_sep'$ac_arg'"
+      # Get rid of the leading space.
+      ac_sep=" "
+      ;;
+    esac
+  done
+done
+$as_unset ac_configure_args0 || test "${ac_configure_args0+set}" != set || { ac_configure_args0=; export ac_configure_args0; }
+$as_unset ac_configure_args1 || test "${ac_configure_args1+set}" != set || { ac_configure_args1=; export ac_configure_args1; }
+
+# When interrupted or exit'd, cleanup temporary files, and complete
+# config.log.  We remove comments because anyway the quotes in there
+# would cause problems or look ugly.
+# WARNING: Be sure not to use single quotes in there, as some shells,
+# such as our DU 5.0 friend, will then `close' the trap.
+trap 'exit_status=$?
+  # Save into config.log some information that might help in debugging.
+  {
+    echo
+
+    cat <<\_ASBOX
+## ---------------- ##
+## Cache variables. ##
+## ---------------- ##
+_ASBOX
+    echo
+    # The following way of writing the cache mishandles newlines in values,
+{
+  (set) 2>&1 |
+    case `(ac_space='"'"' '"'"'; set | grep ac_space) 2>&1` in
+    *ac_space=\ *)
+      sed -n \
+	"s/'"'"'/'"'"'\\\\'"'"''"'"'/g;
+	  s/^\\([_$as_cr_alnum]*_cv_[_$as_cr_alnum]*\\)=\\(.*\\)/\\1='"'"'\\2'"'"'/p"
+      ;;
+    *)
+      sed -n \
+	"s/^\\([_$as_cr_alnum]*_cv_[_$as_cr_alnum]*\\)=\\(.*\\)/\\1=\\2/p"
+      ;;
+    esac;
+}
+    echo
+
+    cat <<\_ASBOX
+## ----------------- ##
+## Output variables. ##
+## ----------------- ##
+_ASBOX
+    echo
+    for ac_var in $ac_subst_vars
+    do
+      eval ac_val=$`echo $ac_var`
+      echo "$ac_var='"'"'$ac_val'"'"'"
+    done | sort
+    echo
+
+    if test -n "$ac_subst_files"; then
+      cat <<\_ASBOX
+## ------------- ##
+## Output files. ##
+## ------------- ##
+_ASBOX
+      echo
+      for ac_var in $ac_subst_files
+      do
+	eval ac_val=$`echo $ac_var`
+	echo "$ac_var='"'"'$ac_val'"'"'"
+      done | sort
+      echo
+    fi
+
+    if test -s confdefs.h; then
+      cat <<\_ASBOX
+## ----------- ##
+## confdefs.h. ##
+## ----------- ##
+_ASBOX
+      echo
+      sed "/^$/d" confdefs.h | sort
+      echo
+    fi
+    test "$ac_signal" != 0 &&
+      echo "$as_me: caught signal $ac_signal"
+    echo "$as_me: exit $exit_status"
+  } >&5
+  rm -f core *.core &&
+  rm -rf conftest* confdefs* conf$$* $ac_clean_files &&
+    exit $exit_status
+     ' 0
+for ac_signal in 1 2 13 15; do
+  trap 'ac_signal='$ac_signal'; { (exit 1); exit 1; }' $ac_signal
+done
+ac_signal=0
+
+# confdefs.h avoids OS command line length limits that DEFS can exceed.
+rm -rf conftest* confdefs.h
+# AIX cpp loses on an empty file, so make sure it contains at least a newline.
+echo >confdefs.h
+
+# Predefined preprocessor variables.
+
+cat >>confdefs.h <<_ACEOF
+#define PACKAGE_NAME "$PACKAGE_NAME"
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define PACKAGE_TARNAME "$PACKAGE_TARNAME"
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define PACKAGE_VERSION "$PACKAGE_VERSION"
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define PACKAGE_STRING "$PACKAGE_STRING"
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define PACKAGE_BUGREPORT "$PACKAGE_BUGREPORT"
+_ACEOF
+
+
+# Let the site file select an alternate cache file if it wants to.
+# Prefer explicitly selected file to automatically selected ones.
+if test -z "$CONFIG_SITE"; then
+  if test "x$prefix" != xNONE; then
+    CONFIG_SITE="$prefix/share/config.site $prefix/etc/config.site"
+  else
+    CONFIG_SITE="$ac_default_prefix/share/config.site $ac_default_prefix/etc/config.site"
+  fi
+fi
+for ac_site_file in $CONFIG_SITE; do
+  if test -r "$ac_site_file"; then
+    { echo "$as_me:$LINENO: loading site script $ac_site_file" >&5
+echo "$as_me: loading site script $ac_site_file" >&6;}
+    sed 's/^/| /' "$ac_site_file" >&5
+    . "$ac_site_file"
+  fi
+done
+
+if test -r "$cache_file"; then
+  # Some versions of bash will fail to source /dev/null (special
+  # files actually), so we avoid doing that.
+  if test -f "$cache_file"; then
+    { echo "$as_me:$LINENO: loading cache $cache_file" >&5
+echo "$as_me: loading cache $cache_file" >&6;}
+    case $cache_file in
+      [\\/]* | ?:[\\/]* ) . $cache_file;;
+      *)                      . ./$cache_file;;
+    esac
+  fi
+else
+  { echo "$as_me:$LINENO: creating cache $cache_file" >&5
+echo "$as_me: creating cache $cache_file" >&6;}
+  >$cache_file
+fi
+
+# Check that the precious variables saved in the cache have kept the same
+# value.
+ac_cache_corrupted=false
+for ac_var in `(set) 2>&1 |
+	       sed -n 's/^ac_env_\([a-zA-Z_0-9]*\)_set=.*/\1/p'`; do
+  eval ac_old_set=\$ac_cv_env_${ac_var}_set
+  eval ac_new_set=\$ac_env_${ac_var}_set
+  eval ac_old_val="\$ac_cv_env_${ac_var}_value"
+  eval ac_new_val="\$ac_env_${ac_var}_value"
+  case $ac_old_set,$ac_new_set in
+    set,)
+      { echo "$as_me:$LINENO: error: \`$ac_var' was set to \`$ac_old_val' in the previous run" >&5
+echo "$as_me: error: \`$ac_var' was set to \`$ac_old_val' in the previous run" >&2;}
+      ac_cache_corrupted=: ;;
+    ,set)
+      { echo "$as_me:$LINENO: error: \`$ac_var' was not set in the previous run" >&5
+echo "$as_me: error: \`$ac_var' was not set in the previous run" >&2;}
+      ac_cache_corrupted=: ;;
+    ,);;
+    *)
+      if test "x$ac_old_val" != "x$ac_new_val"; then
+	{ echo "$as_me:$LINENO: error: \`$ac_var' has changed since the previous run:" >&5
+echo "$as_me: error: \`$ac_var' has changed since the previous run:" >&2;}
+	{ echo "$as_me:$LINENO:   former value:  $ac_old_val" >&5
+echo "$as_me:   former value:  $ac_old_val" >&2;}
+	{ echo "$as_me:$LINENO:   current value: $ac_new_val" >&5
+echo "$as_me:   current value: $ac_new_val" >&2;}
+	ac_cache_corrupted=:
+      fi;;
+  esac
+  # Pass precious variables to config.status.
+  if test "$ac_new_set" = set; then
+    case $ac_new_val in
+    *" "*|*"	"*|*[\[\]\~\#\$\^\&\*\(\)\{\}\\\|\;\<\>\?\"\']*)
+      ac_arg=$ac_var=`echo "$ac_new_val" | sed "s/'/'\\\\\\\\''/g"` ;;
+    *) ac_arg=$ac_var=$ac_new_val ;;
+    esac
+    case " $ac_configure_args " in
+      *" '$ac_arg' "*) ;; # Avoid dups.  Use of quotes ensures accuracy.
+      *) ac_configure_args="$ac_configure_args '$ac_arg'" ;;
+    esac
+  fi
+done
+if $ac_cache_corrupted; then
+  { echo "$as_me:$LINENO: error: changes in the environment can compromise the build" >&5
+echo "$as_me: error: changes in the environment can compromise the build" >&2;}
+  { { echo "$as_me:$LINENO: error: run \`make distclean' and/or \`rm $cache_file' and start over" >&5
+echo "$as_me: error: run \`make distclean' and/or \`rm $cache_file' and start over" >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+ac_aux_dir=
+for ac_dir in autoconf $srcdir/autoconf; do
+  if test -f $ac_dir/install-sh; then
+    ac_aux_dir=$ac_dir
+    ac_install_sh="$ac_aux_dir/install-sh -c"
+    break
+  elif test -f $ac_dir/install.sh; then
+    ac_aux_dir=$ac_dir
+    ac_install_sh="$ac_aux_dir/install.sh -c"
+    break
+  elif test -f $ac_dir/shtool; then
+    ac_aux_dir=$ac_dir
+    ac_install_sh="$ac_aux_dir/shtool install -c"
+    break
+  fi
+done
+if test -z "$ac_aux_dir"; then
+  { { echo "$as_me:$LINENO: error: cannot find install-sh or install.sh in autoconf $srcdir/autoconf" >&5
+echo "$as_me: error: cannot find install-sh or install.sh in autoconf $srcdir/autoconf" >&2;}
+   { (exit 1); exit 1; }; }
+fi
+ac_config_guess="$SHELL $ac_aux_dir/config.guess"
+ac_config_sub="$SHELL $ac_aux_dir/config.sub"
+ac_configure="$SHELL $ac_aux_dir/configure" # This should be Cygnus configure.
+
+
+# Make sure we can run config.sub.
+$ac_config_sub sun4 >/dev/null 2>&1 ||
+  { { echo "$as_me:$LINENO: error: cannot run $ac_config_sub" >&5
+echo "$as_me: error: cannot run $ac_config_sub" >&2;}
+   { (exit 1); exit 1; }; }
+
+echo "$as_me:$LINENO: checking build system type" >&5
+echo $ECHO_N "checking build system type... $ECHO_C" >&6
+if test "${ac_cv_build+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_cv_build_alias=$build_alias
+test -z "$ac_cv_build_alias" &&
+  ac_cv_build_alias=`$ac_config_guess`
+test -z "$ac_cv_build_alias" &&
+  { { echo "$as_me:$LINENO: error: cannot guess build type; you must specify one" >&5
+echo "$as_me: error: cannot guess build type; you must specify one" >&2;}
+   { (exit 1); exit 1; }; }
+ac_cv_build=`$ac_config_sub $ac_cv_build_alias` ||
+  { { echo "$as_me:$LINENO: error: $ac_config_sub $ac_cv_build_alias failed" >&5
+echo "$as_me: error: $ac_config_sub $ac_cv_build_alias failed" >&2;}
+   { (exit 1); exit 1; }; }
+
+fi
+echo "$as_me:$LINENO: result: $ac_cv_build" >&5
+echo "${ECHO_T}$ac_cv_build" >&6
+build=$ac_cv_build
+build_cpu=`echo $ac_cv_build | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\1/'`
+build_vendor=`echo $ac_cv_build | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\2/'`
+build_os=`echo $ac_cv_build | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\3/'`
+
+
+echo "$as_me:$LINENO: checking host system type" >&5
+echo $ECHO_N "checking host system type... $ECHO_C" >&6
+if test "${ac_cv_host+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_cv_host_alias=$host_alias
+test -z "$ac_cv_host_alias" &&
+  ac_cv_host_alias=$ac_cv_build_alias
+ac_cv_host=`$ac_config_sub $ac_cv_host_alias` ||
+  { { echo "$as_me:$LINENO: error: $ac_config_sub $ac_cv_host_alias failed" >&5
+echo "$as_me: error: $ac_config_sub $ac_cv_host_alias failed" >&2;}
+   { (exit 1); exit 1; }; }
+
+fi
+echo "$as_me:$LINENO: result: $ac_cv_host" >&5
+echo "${ECHO_T}$ac_cv_host" >&6
+host=$ac_cv_host
+host_cpu=`echo $ac_cv_host | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\1/'`
+host_vendor=`echo $ac_cv_host | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\2/'`
+host_os=`echo $ac_cv_host | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\3/'`
+
+
+echo "$as_me:$LINENO: checking target system type" >&5
+echo $ECHO_N "checking target system type... $ECHO_C" >&6
+if test "${ac_cv_target+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_cv_target_alias=$target_alias
+test "x$ac_cv_target_alias" = "x" &&
+  ac_cv_target_alias=$ac_cv_host_alias
+ac_cv_target=`$ac_config_sub $ac_cv_target_alias` ||
+  { { echo "$as_me:$LINENO: error: $ac_config_sub $ac_cv_target_alias failed" >&5
+echo "$as_me: error: $ac_config_sub $ac_cv_target_alias failed" >&2;}
+   { (exit 1); exit 1; }; }
+
+fi
+echo "$as_me:$LINENO: result: $ac_cv_target" >&5
+echo "${ECHO_T}$ac_cv_target" >&6
+target=$ac_cv_target
+target_cpu=`echo $ac_cv_target | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\1/'`
+target_vendor=`echo $ac_cv_target | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\2/'`
+target_os=`echo $ac_cv_target | sed 's/^\([^-]*\)-\([^-]*\)-\(.*\)$/\3/'`
+
+
+# The aliases save the names the user supplied, while $host etc.
+# will get canonicalized.
+test -n "$target_alias" &&
+  test "$program_prefix$program_suffix$program_transform_name" = \
+    NONENONEs,x,x, &&
+  program_prefix=${target_alias}-
+
+for ac_prog in gawk mawk nawk awk
+do
+  # Extract the first word of "$ac_prog", so it can be a program name with args.
+set dummy $ac_prog; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_AWK+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$AWK"; then
+  ac_cv_prog_AWK="$AWK" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_AWK="$ac_prog"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+AWK=$ac_cv_prog_AWK
+if test -n "$AWK"; then
+  echo "$as_me:$LINENO: result: $AWK" >&5
+echo "${ECHO_T}$AWK" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+  test -n "$AWK" && break
+done
+
+# Find a good install program.  We prefer a C program (faster),
+# so one script is as good as another.  But avoid the broken or
+# incompatible versions:
+# SysV /etc/install, /usr/sbin/install
+# SunOS /usr/etc/install
+# IRIX /sbin/install
+# AIX /bin/install
+# AmigaOS /C/install, which installs bootblocks on floppy discs
+# AIX 4 /usr/bin/installbsd, which doesn't work without a -g flag
+# AFS /usr/afsws/bin/install, which mishandles nonexistent args
+# SVR4 /usr/ucb/install, which tries to use the nonexistent group "staff"
+# OS/2's system install, which has a completely different semantic
+# ./install, which can be erroneously created by make from ./install.sh.
+echo "$as_me:$LINENO: checking for a BSD-compatible install" >&5
+echo $ECHO_N "checking for a BSD-compatible install... $ECHO_C" >&6
+if test -z "$INSTALL"; then
+if test "${ac_cv_path_install+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  # Account for people who put trailing slashes in PATH elements.
+case $as_dir/ in
+  ./ | .// | /cC/* | \
+  /etc/* | /usr/sbin/* | /usr/etc/* | /sbin/* | /usr/afsws/bin/* | \
+  ?:\\/os2\\/install\\/* | ?:\\/OS2\\/INSTALL\\/* | \
+  /usr/ucb/* ) ;;
+  *)
+    # OSF1 and SCO ODT 3.0 have their own names for install.
+    # Don't use installbsd from OSF since it installs stuff as root
+    # by default.
+    for ac_prog in ginstall scoinst install; do
+      for ac_exec_ext in '' $ac_executable_extensions; do
+	if $as_executable_p "$as_dir/$ac_prog$ac_exec_ext"; then
+	  if test $ac_prog = install &&
+	    grep dspmsg "$as_dir/$ac_prog$ac_exec_ext" >/dev/null 2>&1; then
+	    # AIX install.  It has an incompatible calling convention.
+	    :
+	  elif test $ac_prog = install &&
+	    grep pwplus "$as_dir/$ac_prog$ac_exec_ext" >/dev/null 2>&1; then
+	    # program-specific install script used by HP pwplus--don't use.
+	    :
+	  else
+	    ac_cv_path_install="$as_dir/$ac_prog$ac_exec_ext -c"
+	    break 3
+	  fi
+	fi
+      done
+    done
+    ;;
+esac
+done
+
+
+fi
+  if test "${ac_cv_path_install+set}" = set; then
+    INSTALL=$ac_cv_path_install
+  else
+    # As a last resort, use the slow shell script.  We don't cache a
+    # path for INSTALL within a source directory, because that will
+    # break other packages using the cache if that directory is
+    # removed, or if the path is relative.
+    INSTALL=$ac_install_sh
+  fi
+fi
+echo "$as_me:$LINENO: result: $INSTALL" >&5
+echo "${ECHO_T}$INSTALL" >&6
+
+# Use test -z because SunOS4 sh mishandles braces in ${var-val}.
+# It thinks the first close brace ends the variable substitution.
+test -z "$INSTALL_PROGRAM" && INSTALL_PROGRAM='${INSTALL}'
+
+test -z "$INSTALL_SCRIPT" && INSTALL_SCRIPT='${INSTALL}'
+
+test -z "$INSTALL_DATA" && INSTALL_DATA='${INSTALL} -m 644'
+
+echo "$as_me:$LINENO: checking whether ln -s works" >&5
+echo $ECHO_N "checking whether ln -s works... $ECHO_C" >&6
+LN_S=$as_ln_s
+if test "$LN_S" = "ln -s"; then
+  echo "$as_me:$LINENO: result: yes" >&5
+echo "${ECHO_T}yes" >&6
+else
+  echo "$as_me:$LINENO: result: no, using $LN_S" >&5
+echo "${ECHO_T}no, using $LN_S" >&6
+fi
+
+echo "$as_me:$LINENO: checking whether ${MAKE-make} sets \$(MAKE)" >&5
+echo $ECHO_N "checking whether ${MAKE-make} sets \$(MAKE)... $ECHO_C" >&6
+set dummy ${MAKE-make}; ac_make=`echo "$2" | sed 'y,:./+-,___p_,'`
+if eval "test \"\${ac_cv_prog_make_${ac_make}_set+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.make <<\_ACEOF
+all:
+	@echo 'ac_maketemp="$(MAKE)"'
+_ACEOF
+# GNU make sometimes prints "make[1]: Entering...", which would confuse us.
+eval `${MAKE-make} -f conftest.make 2>/dev/null | grep temp=`
+if test -n "$ac_maketemp"; then
+  eval ac_cv_prog_make_${ac_make}_set=yes
+else
+  eval ac_cv_prog_make_${ac_make}_set=no
+fi
+rm -f conftest.make
+fi
+if eval "test \"`echo '$ac_cv_prog_make_'${ac_make}_set`\" = yes"; then
+  echo "$as_me:$LINENO: result: yes" >&5
+echo "${ECHO_T}yes" >&6
+  SET_MAKE=
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+  SET_MAKE="MAKE=${MAKE-make}"
+fi
+
+if test -n "$ac_tool_prefix"; then
+  # Extract the first word of "${ac_tool_prefix}ranlib", so it can be a program name with args.
+set dummy ${ac_tool_prefix}ranlib; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_RANLIB+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$RANLIB"; then
+  ac_cv_prog_RANLIB="$RANLIB" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_RANLIB="${ac_tool_prefix}ranlib"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+RANLIB=$ac_cv_prog_RANLIB
+if test -n "$RANLIB"; then
+  echo "$as_me:$LINENO: result: $RANLIB" >&5
+echo "${ECHO_T}$RANLIB" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+fi
+if test -z "$ac_cv_prog_RANLIB"; then
+  ac_ct_RANLIB=$RANLIB
+  # Extract the first word of "ranlib", so it can be a program name with args.
+set dummy ranlib; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_ac_ct_RANLIB+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$ac_ct_RANLIB"; then
+  ac_cv_prog_ac_ct_RANLIB="$ac_ct_RANLIB" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_ac_ct_RANLIB="ranlib"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+  test -z "$ac_cv_prog_ac_ct_RANLIB" && ac_cv_prog_ac_ct_RANLIB=":"
+fi
+fi
+ac_ct_RANLIB=$ac_cv_prog_ac_ct_RANLIB
+if test -n "$ac_ct_RANLIB"; then
+  echo "$as_me:$LINENO: result: $ac_ct_RANLIB" >&5
+echo "${ECHO_T}$ac_ct_RANLIB" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+  RANLIB=$ac_ct_RANLIB
+else
+  RANLIB="$ac_cv_prog_RANLIB"
+fi
+
+
+
+
+# Check whether --enable-klibc or --disable-klibc was given.
+if test "${enable_klibc+set}" = set; then
+  enableval="$enable_klibc"
+  KLIBC=$enableval
+else
+  KLIBC=no
+fi;
+
+if test "X$KLIBC" = Xyes; then
+  # Basic cross compiling support.  I do not think it is wise to use
+  # AC_CHECK_TOOL, because if we are cross compiling, we do not want
+  # just 'klcc' to be returned ...
+  if test "X$cross_compiling" = Xyes; then
+    for ac_prog in ${host_alias}-klcc
+do
+  # Extract the first word of "$ac_prog", so it can be a program name with args.
+set dummy $ac_prog; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_KLCC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$KLCC"; then
+  ac_cv_prog_KLCC="$KLCC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_KLCC="$ac_prog"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+KLCC=$ac_cv_prog_KLCC
+if test -n "$KLCC"; then
+  echo "$as_me:$LINENO: result: $KLCC" >&5
+echo "${ECHO_T}$KLCC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+  test -n "$KLCC" && break
+done
+test -n "$KLCC" || KLCC="no"
+
+  else
+    for ac_prog in klcc
+do
+  # Extract the first word of "$ac_prog", so it can be a program name with args.
+set dummy $ac_prog; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_KLCC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$KLCC"; then
+  ac_cv_prog_KLCC="$KLCC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_KLCC="$ac_prog"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+KLCC=$ac_cv_prog_KLCC
+if test -n "$KLCC"; then
+  echo "$as_me:$LINENO: result: $KLCC" >&5
+echo "${ECHO_T}$KLCC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+  test -n "$KLCC" && break
+done
+test -n "$KLCC" || KLCC="no"
+
+  fi
+  if test "X$KLCC" = Xno; then
+    { { echo "$as_me:$LINENO: error: cannot find klibc frontend 'klcc'!" >&5
+echo "$as_me: error: cannot find klibc frontend 'klcc'!" >&2;}
+   { (exit 1); exit 1; }; }
+  fi
+
+  CC="$KLCC"
+  CFLAGS="-Os"
+  KLIBC_KCROSS="$($KLCC -print-klibc-kcross 2>/dev/null)"
+  KLIBC_PREFIX="$($KLCC -print-klibc-prefix 2>/dev/null)"
+  KLIBC_BIN_DIR="$($KLCC -print-klibc-bindir 2>/dev/null)"
+  KLIBC_SBIN_DIR="${KLIBC_PREFIX}/${KLIBC_KCROSS}sbin"
+  KLIBC_LIB_DIR="$($KLCC -print-klibc-libdir 2>/dev/null)"
+  KLIBC_INCLUDE_DIR="$($KLCC -print-klibc-includedir 2>/dev/null)"
+
+  # At least KLIBC_LIB_DIR should be valid, else klibc is too old or
+  # something went wrong
+  if test ! -d "$KLIBC_LIB_DIR"; then
+    { { echo "$as_me:$LINENO: error: your klibc installation is too old or not functional!" >&5
+echo "$as_me: error: your klibc installation is too old or not functional!" >&2;}
+   { (exit 1); exit 1; }; }
+  fi
+fi
+
+
+
+
+
+
+
+
+
+ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+if test -n "$ac_tool_prefix"; then
+  # Extract the first word of "${ac_tool_prefix}gcc", so it can be a program name with args.
+set dummy ${ac_tool_prefix}gcc; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_CC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$CC"; then
+  ac_cv_prog_CC="$CC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_CC="${ac_tool_prefix}gcc"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+CC=$ac_cv_prog_CC
+if test -n "$CC"; then
+  echo "$as_me:$LINENO: result: $CC" >&5
+echo "${ECHO_T}$CC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+fi
+if test -z "$ac_cv_prog_CC"; then
+  ac_ct_CC=$CC
+  # Extract the first word of "gcc", so it can be a program name with args.
+set dummy gcc; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_ac_ct_CC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$ac_ct_CC"; then
+  ac_cv_prog_ac_ct_CC="$ac_ct_CC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_ac_ct_CC="gcc"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+ac_ct_CC=$ac_cv_prog_ac_ct_CC
+if test -n "$ac_ct_CC"; then
+  echo "$as_me:$LINENO: result: $ac_ct_CC" >&5
+echo "${ECHO_T}$ac_ct_CC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+  CC=$ac_ct_CC
+else
+  CC="$ac_cv_prog_CC"
+fi
+
+if test -z "$CC"; then
+  if test -n "$ac_tool_prefix"; then
+  # Extract the first word of "${ac_tool_prefix}cc", so it can be a program name with args.
+set dummy ${ac_tool_prefix}cc; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_CC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$CC"; then
+  ac_cv_prog_CC="$CC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_CC="${ac_tool_prefix}cc"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+CC=$ac_cv_prog_CC
+if test -n "$CC"; then
+  echo "$as_me:$LINENO: result: $CC" >&5
+echo "${ECHO_T}$CC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+fi
+if test -z "$ac_cv_prog_CC"; then
+  ac_ct_CC=$CC
+  # Extract the first word of "cc", so it can be a program name with args.
+set dummy cc; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_ac_ct_CC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$ac_ct_CC"; then
+  ac_cv_prog_ac_ct_CC="$ac_ct_CC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_ac_ct_CC="cc"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+ac_ct_CC=$ac_cv_prog_ac_ct_CC
+if test -n "$ac_ct_CC"; then
+  echo "$as_me:$LINENO: result: $ac_ct_CC" >&5
+echo "${ECHO_T}$ac_ct_CC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+  CC=$ac_ct_CC
+else
+  CC="$ac_cv_prog_CC"
+fi
+
+fi
+if test -z "$CC"; then
+  # Extract the first word of "cc", so it can be a program name with args.
+set dummy cc; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_CC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$CC"; then
+  ac_cv_prog_CC="$CC" # Let the user override the test.
+else
+  ac_prog_rejected=no
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    if test "$as_dir/$ac_word$ac_exec_ext" = "/usr/ucb/cc"; then
+       ac_prog_rejected=yes
+       continue
+     fi
+    ac_cv_prog_CC="cc"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+if test $ac_prog_rejected = yes; then
+  # We found a bogon in the path, so make sure we never use it.
+  set dummy $ac_cv_prog_CC
+  shift
+  if test $# != 0; then
+    # We chose a different compiler from the bogus one.
+    # However, it has the same basename, so the bogon will be chosen
+    # first if we set CC to just the basename; use the full file name.
+    shift
+    ac_cv_prog_CC="$as_dir/$ac_word${1+' '}$@"
+  fi
+fi
+fi
+fi
+CC=$ac_cv_prog_CC
+if test -n "$CC"; then
+  echo "$as_me:$LINENO: result: $CC" >&5
+echo "${ECHO_T}$CC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+fi
+if test -z "$CC"; then
+  if test -n "$ac_tool_prefix"; then
+  for ac_prog in cl
+  do
+    # Extract the first word of "$ac_tool_prefix$ac_prog", so it can be a program name with args.
+set dummy $ac_tool_prefix$ac_prog; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_CC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$CC"; then
+  ac_cv_prog_CC="$CC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_CC="$ac_tool_prefix$ac_prog"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+CC=$ac_cv_prog_CC
+if test -n "$CC"; then
+  echo "$as_me:$LINENO: result: $CC" >&5
+echo "${ECHO_T}$CC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+    test -n "$CC" && break
+  done
+fi
+if test -z "$CC"; then
+  ac_ct_CC=$CC
+  for ac_prog in cl
+do
+  # Extract the first word of "$ac_prog", so it can be a program name with args.
+set dummy $ac_prog; ac_word=$2
+echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6
+if test "${ac_cv_prog_ac_ct_CC+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test -n "$ac_ct_CC"; then
+  ac_cv_prog_ac_ct_CC="$ac_ct_CC" # Let the user override the test.
+else
+as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if $as_executable_p "$as_dir/$ac_word$ac_exec_ext"; then
+    ac_cv_prog_ac_ct_CC="$ac_prog"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+
+fi
+fi
+ac_ct_CC=$ac_cv_prog_ac_ct_CC
+if test -n "$ac_ct_CC"; then
+  echo "$as_me:$LINENO: result: $ac_ct_CC" >&5
+echo "${ECHO_T}$ac_ct_CC" >&6
+else
+  echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6
+fi
+
+  test -n "$ac_ct_CC" && break
+done
+
+  CC=$ac_ct_CC
+fi
+
+fi
+
+
+test -z "$CC" && { { echo "$as_me:$LINENO: error: no acceptable C compiler found in \$PATH
+See \`config.log' for more details." >&5
+echo "$as_me: error: no acceptable C compiler found in \$PATH
+See \`config.log' for more details." >&2;}
+   { (exit 1); exit 1; }; }
+
+# Provide some information about the compiler.
+echo "$as_me:$LINENO:" \
+     "checking for C compiler version" >&5
+ac_compiler=`set X $ac_compile; echo $2`
+{ (eval echo "$as_me:$LINENO: \"$ac_compiler --version </dev/null >&5\"") >&5
+  (eval $ac_compiler --version </dev/null >&5) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }
+{ (eval echo "$as_me:$LINENO: \"$ac_compiler -v </dev/null >&5\"") >&5
+  (eval $ac_compiler -v </dev/null >&5) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }
+{ (eval echo "$as_me:$LINENO: \"$ac_compiler -V </dev/null >&5\"") >&5
+  (eval $ac_compiler -V </dev/null >&5) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }
+
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+ac_clean_files_save=$ac_clean_files
+ac_clean_files="$ac_clean_files a.out a.exe b.out"
+# Try to create an executable without -o first, disregard a.out.
+# It will help us diagnose broken compilers, and finding out an intuition
+# of exeext.
+echo "$as_me:$LINENO: checking for C compiler default output file name" >&5
+echo $ECHO_N "checking for C compiler default output file name... $ECHO_C" >&6
+ac_link_default=`echo "$ac_link" | sed 's/ -o *conftest[^ ]*//'`
+if { (eval echo "$as_me:$LINENO: \"$ac_link_default\"") >&5
+  (eval $ac_link_default) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; then
+  # Find the output, starting from the most likely.  This scheme is
+# not robust to junk in `.', hence go to wildcards (a.*) only as a last
+# resort.
+
+# Be careful to initialize this variable, since it used to be cached.
+# Otherwise an old cache value of `no' led to `EXEEXT = no' in a Makefile.
+ac_cv_exeext=
+# b.out is created by i960 compilers.
+for ac_file in a_out.exe a.exe conftest.exe a.out conftest a.* conftest.* b.out
+do
+  test -f "$ac_file" || continue
+  case $ac_file in
+    *.$ac_ext | *.xcoff | *.tds | *.d | *.pdb | *.xSYM | *.bb | *.bbg | *.o | *.obj )
+	;;
+    conftest.$ac_ext )
+	# This is the source file.
+	;;
+    [ab].out )
+	# We found the default executable, but exeext='' is most
+	# certainly right.
+	break;;
+    *.* )
+	ac_cv_exeext=`expr "$ac_file" : '[^.]*\(\..*\)'`
+	# FIXME: I believe we export ac_cv_exeext for Libtool,
+	# but it would be cool to find out if it's true.  Does anybody
+	# maintain Libtool? --akim.
+	export ac_cv_exeext
+	break;;
+    * )
+	break;;
+  esac
+done
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+{ { echo "$as_me:$LINENO: error: C compiler cannot create executables
+See \`config.log' for more details." >&5
+echo "$as_me: error: C compiler cannot create executables
+See \`config.log' for more details." >&2;}
+   { (exit 77); exit 77; }; }
+fi
+
+ac_exeext=$ac_cv_exeext
+echo "$as_me:$LINENO: result: $ac_file" >&5
+echo "${ECHO_T}$ac_file" >&6
+
+# Check the compiler produces executables we can run.  If not, either
+# the compiler is broken, or we cross compile.
+echo "$as_me:$LINENO: checking whether the C compiler works" >&5
+echo $ECHO_N "checking whether the C compiler works... $ECHO_C" >&6
+# FIXME: These cross compiler hacks should be removed for Autoconf 3.0
+# If not cross compiling, check that we can run a simple program.
+if test "$cross_compiling" != yes; then
+  if { ac_try='./$ac_file'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+    cross_compiling=no
+  else
+    if test "$cross_compiling" = maybe; then
+	cross_compiling=yes
+    else
+	{ { echo "$as_me:$LINENO: error: cannot run C compiled programs.
+If you meant to cross compile, use \`--host'.
+See \`config.log' for more details." >&5
+echo "$as_me: error: cannot run C compiled programs.
+If you meant to cross compile, use \`--host'.
+See \`config.log' for more details." >&2;}
+   { (exit 1); exit 1; }; }
+    fi
+  fi
+fi
+echo "$as_me:$LINENO: result: yes" >&5
+echo "${ECHO_T}yes" >&6
+
+rm -f a.out a.exe conftest$ac_cv_exeext b.out
+ac_clean_files=$ac_clean_files_save
+# Check the compiler produces executables we can run.  If not, either
+# the compiler is broken, or we cross compile.
+echo "$as_me:$LINENO: checking whether we are cross compiling" >&5
+echo $ECHO_N "checking whether we are cross compiling... $ECHO_C" >&6
+echo "$as_me:$LINENO: result: $cross_compiling" >&5
+echo "${ECHO_T}$cross_compiling" >&6
+
+echo "$as_me:$LINENO: checking for suffix of executables" >&5
+echo $ECHO_N "checking for suffix of executables... $ECHO_C" >&6
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; then
+  # If both `conftest.exe' and `conftest' are `present' (well, observable)
+# catch `conftest.exe'.  For instance with Cygwin, `ls conftest' will
+# work properly (i.e., refer to `conftest.exe'), while it won't with
+# `rm'.
+for ac_file in conftest.exe conftest conftest.*; do
+  test -f "$ac_file" || continue
+  case $ac_file in
+    *.$ac_ext | *.xcoff | *.tds | *.d | *.pdb | *.xSYM | *.bb | *.bbg | *.o | *.obj ) ;;
+    *.* ) ac_cv_exeext=`expr "$ac_file" : '[^.]*\(\..*\)'`
+	  export ac_cv_exeext
+	  break;;
+    * ) break;;
+  esac
+done
+else
+  { { echo "$as_me:$LINENO: error: cannot compute suffix of executables: cannot compile and link
+See \`config.log' for more details." >&5
+echo "$as_me: error: cannot compute suffix of executables: cannot compile and link
+See \`config.log' for more details." >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+rm -f conftest$ac_cv_exeext
+echo "$as_me:$LINENO: result: $ac_cv_exeext" >&5
+echo "${ECHO_T}$ac_cv_exeext" >&6
+
+rm -f conftest.$ac_ext
+EXEEXT=$ac_cv_exeext
+ac_exeext=$EXEEXT
+echo "$as_me:$LINENO: checking for suffix of object files" >&5
+echo $ECHO_N "checking for suffix of object files... $ECHO_C" >&6
+if test "${ac_cv_objext+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.o conftest.obj
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; then
+  for ac_file in `(ls conftest.o conftest.obj; ls conftest.*) 2>/dev/null`; do
+  case $ac_file in
+    *.$ac_ext | *.xcoff | *.tds | *.d | *.pdb | *.xSYM | *.bb | *.bbg ) ;;
+    *) ac_cv_objext=`expr "$ac_file" : '.*\.\(.*\)'`
+       break;;
+  esac
+done
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+{ { echo "$as_me:$LINENO: error: cannot compute suffix of object files: cannot compile
+See \`config.log' for more details." >&5
+echo "$as_me: error: cannot compute suffix of object files: cannot compile
+See \`config.log' for more details." >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+rm -f conftest.$ac_cv_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_objext" >&5
+echo "${ECHO_T}$ac_cv_objext" >&6
+OBJEXT=$ac_cv_objext
+ac_objext=$OBJEXT
+echo "$as_me:$LINENO: checking whether we are using the GNU C compiler" >&5
+echo $ECHO_N "checking whether we are using the GNU C compiler... $ECHO_C" >&6
+if test "${ac_cv_c_compiler_gnu+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+int
+main ()
+{
+#ifndef __GNUC__
+       choke me
+#endif
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_compiler_gnu=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_compiler_gnu=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+ac_cv_c_compiler_gnu=$ac_compiler_gnu
+
+fi
+echo "$as_me:$LINENO: result: $ac_cv_c_compiler_gnu" >&5
+echo "${ECHO_T}$ac_cv_c_compiler_gnu" >&6
+GCC=`test $ac_compiler_gnu = yes && echo yes`
+ac_test_CFLAGS=${CFLAGS+set}
+ac_save_CFLAGS=$CFLAGS
+CFLAGS="-g"
+echo "$as_me:$LINENO: checking whether $CC accepts -g" >&5
+echo $ECHO_N "checking whether $CC accepts -g... $ECHO_C" >&6
+if test "${ac_cv_prog_cc_g+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_prog_cc_g=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_prog_cc_g=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_prog_cc_g" >&5
+echo "${ECHO_T}$ac_cv_prog_cc_g" >&6
+if test "$ac_test_CFLAGS" = set; then
+  CFLAGS=$ac_save_CFLAGS
+elif test $ac_cv_prog_cc_g = yes; then
+  if test "$GCC" = yes; then
+    CFLAGS="-g -O2"
+  else
+    CFLAGS="-g"
+  fi
+else
+  if test "$GCC" = yes; then
+    CFLAGS="-O2"
+  else
+    CFLAGS=
+  fi
+fi
+echo "$as_me:$LINENO: checking for $CC option to accept ANSI C" >&5
+echo $ECHO_N "checking for $CC option to accept ANSI C... $ECHO_C" >&6
+if test "${ac_cv_prog_cc_stdc+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_cv_prog_cc_stdc=no
+ac_save_CC=$CC
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <stdarg.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+/* Most of the following tests are stolen from RCS 5.7's src/conf.sh.  */
+struct buf { int x; };
+FILE * (*rcsopen) (struct buf *, struct stat *, int);
+static char *e (p, i)
+     char **p;
+     int i;
+{
+  return p[i];
+}
+static char *f (char * (*g) (char **, int), char **p, ...)
+{
+  char *s;
+  va_list v;
+  va_start (v,p);
+  s = g (p, va_arg (v,int));
+  va_end (v);
+  return s;
+}
+
+/* OSF 4.0 Compaq cc is some sort of almost-ANSI by default.  It has
+   function prototypes and stuff, but not '\xHH' hex character constants.
+   These don't provoke an error unfortunately, instead are silently treated
+   as 'x'.  The following induces an error, until -std1 is added to get
+   proper ANSI mode.  Curiously '\x00'!='x' always comes out true, for an
+   array size at least.  It's necessary to write '\x00'==0 to get something
+   that's true only with -std1.  */
+int osf4_cc_array ['\x00' == 0 ? 1 : -1];
+
+int test (int i, double x);
+struct s1 {int (*f) (int a);};
+struct s2 {int (*f) (double a);};
+int pairnames (int, char **, FILE *(*)(struct buf *, struct stat *, int), int, int);
+int argc;
+char **argv;
+int
+main ()
+{
+return f (e, argv, 0) != argv[0]  ||  f (e, argv, 1) != argv[1];
+  ;
+  return 0;
+}
+_ACEOF
+# Don't try gcc -ansi; that turns off useful extensions and
+# breaks some systems' header files.
+# AIX			-qlanglvl=ansi
+# Ultrix and OSF/1	-std1
+# HP-UX 10.20 and later	-Ae
+# HP-UX older versions	-Aa -D_HPUX_SOURCE
+# SVR4			-Xc -D__EXTENSIONS__
+for ac_arg in "" -qlanglvl=ansi -std1 -Ae "-Aa -D_HPUX_SOURCE" "-Xc -D__EXTENSIONS__"
+do
+  CC="$ac_save_CC $ac_arg"
+  rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_prog_cc_stdc=$ac_arg
+break
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext
+done
+rm -f conftest.$ac_ext conftest.$ac_objext
+CC=$ac_save_CC
+
+fi
+
+case "x$ac_cv_prog_cc_stdc" in
+  x|xno)
+    echo "$as_me:$LINENO: result: none needed" >&5
+echo "${ECHO_T}none needed" >&6 ;;
+  *)
+    echo "$as_me:$LINENO: result: $ac_cv_prog_cc_stdc" >&5
+echo "${ECHO_T}$ac_cv_prog_cc_stdc" >&6
+    CC="$CC $ac_cv_prog_cc_stdc" ;;
+esac
+
+# Some people use a C++ compiler to compile C.  Since we use `exit',
+# in C++ we need to declare it.  In case someone uses the same compiler
+# for both compiling C and C++ we need to have the C++ compiler decide
+# the declaration of exit, since it's the most demanding environment.
+cat >conftest.$ac_ext <<_ACEOF
+#ifndef __cplusplus
+  choke me
+#endif
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  for ac_declaration in \
+   '' \
+   'extern "C" void std::exit (int) throw (); using std::exit;' \
+   'extern "C" void std::exit (int); using std::exit;' \
+   'extern "C" void exit (int) throw ();' \
+   'extern "C" void exit (int);' \
+   'void exit (int);'
+do
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_declaration
+#include <stdlib.h>
+int
+main ()
+{
+exit (42);
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  :
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+continue
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_declaration
+int
+main ()
+{
+exit (42);
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  break
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+done
+rm -f conftest*
+if test -n "$ac_declaration"; then
+  echo '#ifdef __cplusplus' >>confdefs.h
+  echo $ac_declaration      >>confdefs.h
+  echo '#endif'             >>confdefs.h
+fi
+
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+
+
+
+
+
+
+
+
+ac_header_dirent=no
+for ac_hdr in dirent.h sys/ndir.h sys/dir.h ndir.h; do
+  as_ac_Header=`echo "ac_cv_header_dirent_$ac_hdr" | $as_tr_sh`
+echo "$as_me:$LINENO: checking for $ac_hdr that defines DIR" >&5
+echo $ECHO_N "checking for $ac_hdr that defines DIR... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <$ac_hdr>
+
+int
+main ()
+{
+if ((DIR *) 0)
+return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  eval "$as_ac_Header=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+eval "$as_ac_Header=no"
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_hdr" | $as_tr_cpp` 1
+_ACEOF
+
+ac_header_dirent=$ac_hdr; break
+fi
+
+done
+# Two versions of opendir et al. are in -ldir and -lx on SCO Xenix.
+if test $ac_header_dirent = dirent.h; then
+  echo "$as_me:$LINENO: checking for library containing opendir" >&5
+echo $ECHO_N "checking for library containing opendir... $ECHO_C" >&6
+if test "${ac_cv_search_opendir+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_func_search_save_LIBS=$LIBS
+ac_cv_search_opendir=no
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char opendir ();
+int
+main ()
+{
+opendir ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_search_opendir="none required"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+if test "$ac_cv_search_opendir" = no; then
+  for ac_lib in dir; do
+    LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
+    cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char opendir ();
+int
+main ()
+{
+opendir ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_search_opendir="-l$ac_lib"
+break
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+  done
+fi
+LIBS=$ac_func_search_save_LIBS
+fi
+echo "$as_me:$LINENO: result: $ac_cv_search_opendir" >&5
+echo "${ECHO_T}$ac_cv_search_opendir" >&6
+if test "$ac_cv_search_opendir" != no; then
+  test "$ac_cv_search_opendir" = "none required" || LIBS="$ac_cv_search_opendir $LIBS"
+
+fi
+
+else
+  echo "$as_me:$LINENO: checking for library containing opendir" >&5
+echo $ECHO_N "checking for library containing opendir... $ECHO_C" >&6
+if test "${ac_cv_search_opendir+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_func_search_save_LIBS=$LIBS
+ac_cv_search_opendir=no
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char opendir ();
+int
+main ()
+{
+opendir ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_search_opendir="none required"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+if test "$ac_cv_search_opendir" = no; then
+  for ac_lib in x; do
+    LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
+    cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char opendir ();
+int
+main ()
+{
+opendir ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_search_opendir="-l$ac_lib"
+break
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+  done
+fi
+LIBS=$ac_func_search_save_LIBS
+fi
+echo "$as_me:$LINENO: result: $ac_cv_search_opendir" >&5
+echo "${ECHO_T}$ac_cv_search_opendir" >&6
+if test "$ac_cv_search_opendir" != no; then
+  test "$ac_cv_search_opendir" = "none required" || LIBS="$ac_cv_search_opendir $LIBS"
+
+fi
+
+fi
+
+ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+echo "$as_me:$LINENO: checking how to run the C preprocessor" >&5
+echo $ECHO_N "checking how to run the C preprocessor... $ECHO_C" >&6
+# On Suns, sometimes $CPP names a directory.
+if test -n "$CPP" && test -d "$CPP"; then
+  CPP=
+fi
+if test -z "$CPP"; then
+  if test "${ac_cv_prog_CPP+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+      # Double quotes because CPP needs to be expanded
+    for CPP in "$CC -E" "$CC -E -traditional-cpp" "/lib/cpp"
+    do
+      ac_preproc_ok=false
+for ac_c_preproc_warn_flag in '' yes
+do
+  # Use a header file that comes with gcc, so configuring glibc
+  # with a fresh cross-compiler works.
+  # Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+  # <limits.h> exists even on freestanding compilers.
+  # On the NeXT, cc -E runs the code through the compiler's parser,
+  # not just through cpp. "Syntax error" is here to catch this case.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+		     Syntax error
+_ACEOF
+if { (eval echo "$as_me:$LINENO: \"$ac_cpp conftest.$ac_ext\"") >&5
+  (eval $ac_cpp conftest.$ac_ext) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null; then
+  if test -s conftest.err; then
+    ac_cpp_err=$ac_c_preproc_warn_flag
+    ac_cpp_err=$ac_cpp_err$ac_c_werror_flag
+  else
+    ac_cpp_err=
+  fi
+else
+  ac_cpp_err=yes
+fi
+if test -z "$ac_cpp_err"; then
+  :
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  # Broken: fails on valid input.
+continue
+fi
+rm -f conftest.err conftest.$ac_ext
+
+  # OK, works on sane cases.  Now check whether non-existent headers
+  # can be detected and how.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <ac_nonexistent.h>
+_ACEOF
+if { (eval echo "$as_me:$LINENO: \"$ac_cpp conftest.$ac_ext\"") >&5
+  (eval $ac_cpp conftest.$ac_ext) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null; then
+  if test -s conftest.err; then
+    ac_cpp_err=$ac_c_preproc_warn_flag
+    ac_cpp_err=$ac_cpp_err$ac_c_werror_flag
+  else
+    ac_cpp_err=
+  fi
+else
+  ac_cpp_err=yes
+fi
+if test -z "$ac_cpp_err"; then
+  # Broken: success on invalid input.
+continue
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  # Passes both tests.
+ac_preproc_ok=:
+break
+fi
+rm -f conftest.err conftest.$ac_ext
+
+done
+# Because of `break', _AC_PREPROC_IFELSE's cleaning code was skipped.
+rm -f conftest.err conftest.$ac_ext
+if $ac_preproc_ok; then
+  break
+fi
+
+    done
+    ac_cv_prog_CPP=$CPP
+
+fi
+  CPP=$ac_cv_prog_CPP
+else
+  ac_cv_prog_CPP=$CPP
+fi
+echo "$as_me:$LINENO: result: $CPP" >&5
+echo "${ECHO_T}$CPP" >&6
+ac_preproc_ok=false
+for ac_c_preproc_warn_flag in '' yes
+do
+  # Use a header file that comes with gcc, so configuring glibc
+  # with a fresh cross-compiler works.
+  # Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+  # <limits.h> exists even on freestanding compilers.
+  # On the NeXT, cc -E runs the code through the compiler's parser,
+  # not just through cpp. "Syntax error" is here to catch this case.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+		     Syntax error
+_ACEOF
+if { (eval echo "$as_me:$LINENO: \"$ac_cpp conftest.$ac_ext\"") >&5
+  (eval $ac_cpp conftest.$ac_ext) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null; then
+  if test -s conftest.err; then
+    ac_cpp_err=$ac_c_preproc_warn_flag
+    ac_cpp_err=$ac_cpp_err$ac_c_werror_flag
+  else
+    ac_cpp_err=
+  fi
+else
+  ac_cpp_err=yes
+fi
+if test -z "$ac_cpp_err"; then
+  :
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  # Broken: fails on valid input.
+continue
+fi
+rm -f conftest.err conftest.$ac_ext
+
+  # OK, works on sane cases.  Now check whether non-existent headers
+  # can be detected and how.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <ac_nonexistent.h>
+_ACEOF
+if { (eval echo "$as_me:$LINENO: \"$ac_cpp conftest.$ac_ext\"") >&5
+  (eval $ac_cpp conftest.$ac_ext) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null; then
+  if test -s conftest.err; then
+    ac_cpp_err=$ac_c_preproc_warn_flag
+    ac_cpp_err=$ac_cpp_err$ac_c_werror_flag
+  else
+    ac_cpp_err=
+  fi
+else
+  ac_cpp_err=yes
+fi
+if test -z "$ac_cpp_err"; then
+  # Broken: success on invalid input.
+continue
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  # Passes both tests.
+ac_preproc_ok=:
+break
+fi
+rm -f conftest.err conftest.$ac_ext
+
+done
+# Because of `break', _AC_PREPROC_IFELSE's cleaning code was skipped.
+rm -f conftest.err conftest.$ac_ext
+if $ac_preproc_ok; then
+  :
+else
+  { { echo "$as_me:$LINENO: error: C preprocessor \"$CPP\" fails sanity check
+See \`config.log' for more details." >&5
+echo "$as_me: error: C preprocessor \"$CPP\" fails sanity check
+See \`config.log' for more details." >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+
+
+echo "$as_me:$LINENO: checking for egrep" >&5
+echo $ECHO_N "checking for egrep... $ECHO_C" >&6
+if test "${ac_cv_prog_egrep+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if echo a | (grep -E '(a|b)') >/dev/null 2>&1
+    then ac_cv_prog_egrep='grep -E'
+    else ac_cv_prog_egrep='egrep'
+    fi
+fi
+echo "$as_me:$LINENO: result: $ac_cv_prog_egrep" >&5
+echo "${ECHO_T}$ac_cv_prog_egrep" >&6
+ EGREP=$ac_cv_prog_egrep
+
+
+echo "$as_me:$LINENO: checking for ANSI C header files" >&5
+echo $ECHO_N "checking for ANSI C header files... $ECHO_C" >&6
+if test "${ac_cv_header_stdc+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <float.h>
+
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_header_stdc=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_header_stdc=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+
+if test $ac_cv_header_stdc = yes; then
+  # SunOS 4.x string.h does not declare mem*, contrary to ANSI.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <string.h>
+
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "memchr" >/dev/null 2>&1; then
+  :
+else
+  ac_cv_header_stdc=no
+fi
+rm -f conftest*
+
+fi
+
+if test $ac_cv_header_stdc = yes; then
+  # ISC 2.0.2 stdlib.h does not declare free, contrary to ANSI.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <stdlib.h>
+
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "free" >/dev/null 2>&1; then
+  :
+else
+  ac_cv_header_stdc=no
+fi
+rm -f conftest*
+
+fi
+
+if test $ac_cv_header_stdc = yes; then
+  # /bin/cc in Irix-4.0.5 gets non-ANSI ctype macros unless using -ansi.
+  if test "$cross_compiling" = yes; then
+  :
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <ctype.h>
+#if ((' ' & 0x0FF) == 0x020)
+# define ISLOWER(c) ('a' <= (c) && (c) <= 'z')
+# define TOUPPER(c) (ISLOWER(c) ? 'A' + ((c) - 'a') : (c))
+#else
+# define ISLOWER(c) \
+		   (('a' <= (c) && (c) <= 'i') \
+		     || ('j' <= (c) && (c) <= 'r') \
+		     || ('s' <= (c) && (c) <= 'z'))
+# define TOUPPER(c) (ISLOWER(c) ? ((c) | 0x40) : (c))
+#endif
+
+#define XOR(e, f) (((e) && !(f)) || (!(e) && (f)))
+int
+main ()
+{
+  int i;
+  for (i = 0; i < 256; i++)
+    if (XOR (islower (i), ISLOWER (i))
+	|| toupper (i) != TOUPPER (i))
+      exit(2);
+  exit (0);
+}
+_ACEOF
+rm -f conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  :
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_header_stdc=no
+fi
+rm -f core *.core gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+fi
+fi
+echo "$as_me:$LINENO: result: $ac_cv_header_stdc" >&5
+echo "${ECHO_T}$ac_cv_header_stdc" >&6
+if test $ac_cv_header_stdc = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define STDC_HEADERS 1
+_ACEOF
+
+fi
+
+# On IRIX 5.3, sys/types and inttypes.h are conflicting.
+
+
+
+
+
+
+
+
+
+for ac_header in sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h \
+		  inttypes.h stdint.h unistd.h
+do
+as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
+echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+
+#include <$ac_header>
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  eval "$as_ac_Header=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+eval "$as_ac_Header=no"
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+
+done
+
+
+
+
+
+for ac_header in fcntl.h sys/ioctl.h unistd.h
+do
+as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+else
+  # Is the header compilable?
+echo "$as_me:$LINENO: checking $ac_header usability" >&5
+echo $ECHO_N "checking $ac_header usability... $ECHO_C" >&6
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+#include <$ac_header>
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_header_compiler=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_header_compiler=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+echo "${ECHO_T}$ac_header_compiler" >&6
+
+# Is the header present?
+echo "$as_me:$LINENO: checking $ac_header presence" >&5
+echo $ECHO_N "checking $ac_header presence... $ECHO_C" >&6
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <$ac_header>
+_ACEOF
+if { (eval echo "$as_me:$LINENO: \"$ac_cpp conftest.$ac_ext\"") >&5
+  (eval $ac_cpp conftest.$ac_ext) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null; then
+  if test -s conftest.err; then
+    ac_cpp_err=$ac_c_preproc_warn_flag
+    ac_cpp_err=$ac_cpp_err$ac_c_werror_flag
+  else
+    ac_cpp_err=
+  fi
+else
+  ac_cpp_err=yes
+fi
+if test -z "$ac_cpp_err"; then
+  ac_header_preproc=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  ac_header_preproc=no
+fi
+rm -f conftest.err conftest.$ac_ext
+echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+echo "${ECHO_T}$ac_header_preproc" >&6
+
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
+    (
+      cat <<\_ASBOX
+## ------------------------------------------ ##
+## Report this to the AC_PACKAGE_NAME lists.  ##
+## ------------------------------------------ ##
+_ASBOX
+    ) |
+      sed "s/^/$as_me: WARNING:     /" >&2
+    ;;
+esac
+echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  eval "$as_ac_Header=\$ac_header_preproc"
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+
+fi
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+
+done
+
+if test x$KLIBC != xyes; then
+
+for ac_header in malloc.h
+do
+as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+else
+  # Is the header compilable?
+echo "$as_me:$LINENO: checking $ac_header usability" >&5
+echo $ECHO_N "checking $ac_header usability... $ECHO_C" >&6
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+#include <$ac_header>
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_header_compiler=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_header_compiler=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+echo "${ECHO_T}$ac_header_compiler" >&6
+
+# Is the header present?
+echo "$as_me:$LINENO: checking $ac_header presence" >&5
+echo $ECHO_N "checking $ac_header presence... $ECHO_C" >&6
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <$ac_header>
+_ACEOF
+if { (eval echo "$as_me:$LINENO: \"$ac_cpp conftest.$ac_ext\"") >&5
+  (eval $ac_cpp conftest.$ac_ext) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null; then
+  if test -s conftest.err; then
+    ac_cpp_err=$ac_c_preproc_warn_flag
+    ac_cpp_err=$ac_cpp_err$ac_c_werror_flag
+  else
+    ac_cpp_err=
+  fi
+else
+  ac_cpp_err=yes
+fi
+if test -z "$ac_cpp_err"; then
+  ac_header_preproc=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  ac_header_preproc=no
+fi
+rm -f conftest.err conftest.$ac_ext
+echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+echo "${ECHO_T}$ac_header_preproc" >&6
+
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
+    (
+      cat <<\_ASBOX
+## ------------------------------------------ ##
+## Report this to the AC_PACKAGE_NAME lists.  ##
+## ------------------------------------------ ##
+_ASBOX
+    ) |
+      sed "s/^/$as_me: WARNING:     /" >&2
+    ;;
+esac
+echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  eval "$as_ac_Header=\$ac_header_preproc"
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+
+fi
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+
+done
+
+fi
+
+echo "$as_me:$LINENO: checking for an ANSI C-conforming const" >&5
+echo $ECHO_N "checking for an ANSI C-conforming const... $ECHO_C" >&6
+if test "${ac_cv_c_const+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+int
+main ()
+{
+/* FIXME: Include the comments suggested by Paul. */
+#ifndef __cplusplus
+  /* Ultrix mips cc rejects this.  */
+  typedef int charset[2];
+  const charset x;
+  /* SunOS 4.1.1 cc rejects this.  */
+  char const *const *ccp;
+  char **p;
+  /* NEC SVR4.0.2 mips cc rejects this.  */
+  struct point {int x, y;};
+  static struct point const zero = {0,0};
+  /* AIX XL C 1.02.0.0 rejects this.
+     It does not let you subtract one const X* pointer from another in
+     an arm of an if-expression whose if-part is not a constant
+     expression */
+  const char *g = "string";
+  ccp = &g + (g ? g-g : 0);
+  /* HPUX 7.0 cc rejects these. */
+  ++ccp;
+  p = (char**) ccp;
+  ccp = (char const *const *) p;
+  { /* SCO 3.2v4 cc rejects this.  */
+    char *t;
+    char const *s = 0 ? (char *) 0 : (char const *) 0;
+
+    *t++ = 0;
+  }
+  { /* Someone thinks the Sun supposedly-ANSI compiler will reject this.  */
+    int x[] = {25, 17};
+    const int *foo = &x[0];
+    ++foo;
+  }
+  { /* Sun SC1.0 ANSI compiler rejects this -- but not the above. */
+    typedef const int *iptr;
+    iptr p = 0;
+    ++p;
+  }
+  { /* AIX XL C 1.02.0.0 rejects this saying
+       "k.c", line 2.27: 1506-025 (S) Operand must be a modifiable lvalue. */
+    struct s { int j; const int *ap[3]; };
+    struct s *b; b->j = 5;
+  }
+  { /* ULTRIX-32 V3.1 (Rev 9) vcc rejects this */
+    const int foo = 10;
+  }
+#endif
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_c_const=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_c_const=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_c_const" >&5
+echo "${ECHO_T}$ac_cv_c_const" >&6
+if test $ac_cv_c_const = no; then
+
+cat >>confdefs.h <<\_ACEOF
+#define const
+_ACEOF
+
+fi
+
+echo "$as_me:$LINENO: checking for inline" >&5
+echo $ECHO_N "checking for inline... $ECHO_C" >&6
+if test "${ac_cv_c_inline+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_cv_c_inline=no
+for ac_kw in inline __inline__ __inline; do
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#ifndef __cplusplus
+typedef int foo_t;
+static $ac_kw foo_t static_foo () {return 0; }
+$ac_kw foo_t foo () {return 0; }
+#endif
+
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_c_inline=$ac_kw; break
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+done
+
+fi
+echo "$as_me:$LINENO: result: $ac_cv_c_inline" >&5
+echo "${ECHO_T}$ac_cv_c_inline" >&6
+
+
+case $ac_cv_c_inline in
+  inline | yes) ;;
+  *)
+    case $ac_cv_c_inline in
+      no) ac_val=;;
+      *) ac_val=$ac_cv_c_inline;;
+    esac
+    cat >>confdefs.h <<_ACEOF
+#ifndef __cplusplus
+#define inline $ac_val
+#endif
+_ACEOF
+    ;;
+esac
+
+echo "$as_me:$LINENO: checking for off_t" >&5
+echo $ECHO_N "checking for off_t... $ECHO_C" >&6
+if test "${ac_cv_type_off_t+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if ((off_t *) 0)
+  return 0;
+if (sizeof (off_t))
+  return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_type_off_t=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_type_off_t=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_type_off_t" >&5
+echo "${ECHO_T}$ac_cv_type_off_t" >&6
+if test $ac_cv_type_off_t = yes; then
+  :
+else
+
+cat >>confdefs.h <<_ACEOF
+#define off_t long
+_ACEOF
+
+fi
+
+echo "$as_me:$LINENO: checking for pid_t" >&5
+echo $ECHO_N "checking for pid_t... $ECHO_C" >&6
+if test "${ac_cv_type_pid_t+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if ((pid_t *) 0)
+  return 0;
+if (sizeof (pid_t))
+  return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_type_pid_t=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_type_pid_t=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_type_pid_t" >&5
+echo "${ECHO_T}$ac_cv_type_pid_t" >&6
+if test $ac_cv_type_pid_t = yes; then
+  :
+else
+
+cat >>confdefs.h <<_ACEOF
+#define pid_t int
+_ACEOF
+
+fi
+
+echo "$as_me:$LINENO: checking for size_t" >&5
+echo $ECHO_N "checking for size_t... $ECHO_C" >&6
+if test "${ac_cv_type_size_t+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if ((size_t *) 0)
+  return 0;
+if (sizeof (size_t))
+  return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_type_size_t=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_type_size_t=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_type_size_t" >&5
+echo "${ECHO_T}$ac_cv_type_size_t" >&6
+if test $ac_cv_type_size_t = yes; then
+  :
+else
+
+cat >>confdefs.h <<_ACEOF
+#define size_t unsigned
+_ACEOF
+
+fi
+
+
+echo "$as_me:$LINENO: checking for struct stat.st_rdev" >&5
+echo $ECHO_N "checking for struct stat.st_rdev... $ECHO_C" >&6
+if test "${ac_cv_member_struct_stat_st_rdev+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static struct stat ac_aggr;
+if (ac_aggr.st_rdev)
+return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_member_struct_stat_st_rdev=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static struct stat ac_aggr;
+if (sizeof ac_aggr.st_rdev)
+return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_member_struct_stat_st_rdev=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_member_struct_stat_st_rdev=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_member_struct_stat_st_rdev" >&5
+echo "${ECHO_T}$ac_cv_member_struct_stat_st_rdev" >&6
+if test $ac_cv_member_struct_stat_st_rdev = yes; then
+
+cat >>confdefs.h <<_ACEOF
+#define HAVE_STRUCT_STAT_ST_RDEV 1
+_ACEOF
+
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_ST_RDEV 1
+_ACEOF
+
+fi
+
+
+echo "$as_me:$LINENO: checking whether time.h and sys/time.h may both be included" >&5
+echo $ECHO_N "checking whether time.h and sys/time.h may both be included... $ECHO_C" >&6
+if test "${ac_cv_header_time+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <sys/time.h>
+#include <time.h>
+
+int
+main ()
+{
+if ((struct tm *) 0)
+return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_header_time=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_header_time=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_header_time" >&5
+echo "${ECHO_T}$ac_cv_header_time" >&6
+if test $ac_cv_header_time = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define TIME_WITH_SYS_TIME 1
+_ACEOF
+
+fi
+
+
+if test x$KLIBC != xyes; then
+	case "$host_os" in
+		linux*)
+			CFLAGS=-O2
+			CLDFLAGS="-Wl,--version-script,.export.sym"
+			LD_DEPS=".export.sym"
+			SOFLAG="-shared" ;;
+	esac
+fi
+
+
+
+
+# Check whether --with-user or --without-user was given.
+if test "${with_user+set}" = set; then
+  withval="$with_user"
+   OWNER="$withval"
+else
+   OWNER="root"
+fi;
+
+
+# Check whether --with-group or --without-group was given.
+if test "${with_group+set}" = set; then
+  withval="$with_group"
+   GROUP="$withval"
+else
+   GROUP="root"
+fi;
+
+echo $ac_n "checking whether to enable debugging""... $ac_c" 1>&6
+# Check whether --enable-debug or --disable-debug was given.
+if test "${enable_debug+set}" = set; then
+  enableval="$enable_debug"
+  \
+DEBUG=yes
+else
+  DEBUG=no
+fi;
+echo "$ac_t""$DEBUG" 1>&6
+
+echo $ac_n "checking whether to enable malloc debugging""... $ac_c" 1>&6
+# Check whether --enable-debug_malloc or --disable-debug_malloc was given.
+if test "${enable_debug_malloc+set}" = set; then
+  enableval="$enable_debug_malloc"
+  \
+DEBUG_MALLOC=yes
+else
+  DEBUG_MALLOC=no
+fi;
+echo "$ac_t""$DEBUG" 1>&6
+
+# Check whether --enable-dietlibc or --disable-dietlibc was given.
+if test "${enable_dietlibc+set}" = set; then
+  enableval="$enable_dietlibc"
+  DIETLIBC=yes
+else
+  DIETLIBC=no
+fi;
+
+if test x$DIETLIBC = xyes; then
+	if test x$KLIBC = xyes; then
+		{ { echo "$as_me:$LINENO: error: You can' enable both dietlibc and klibc!" >&5
+echo "$as_me: error: You can' enable both dietlibc and klibc!" >&2;}
+   { (exit 1); exit 1; }; }
+		exit 1
+	fi
+        CC="diet gcc"
+	FLAVOUR="dietlibc "
+fi
+
+# Check whether --enable-jobs or --disable-jobs was given.
+if test "${enable_jobs+set}" = set; then
+  enableval="$enable_jobs"
+  JOBS=-j$enableval
+else
+  JOBS=-j1
+fi;
+
+# Check whether --enable-libselinux or --disable-libselinux was given.
+if test "${enable_libselinux+set}" = set; then
+  enableval="$enable_libselinux"
+  LIBSELINUX=$enableval
+else
+  LIBSELINUX=no
+fi;
+
+# Check whether --enable-libsepol or --disable-libsepol was given.
+if test "${enable_libsepol+set}" = set; then
+  enableval="$enable_libsepol"
+  LIBSEPOL=$enableval
+else
+  LIBSEPOL=no
+fi;
+
+# Check whether --enable-mini or --disable-mini was given.
+if test "${enable_mini+set}" = set; then
+  enableval="$enable_mini"
+  DMRAID_MINI=$enableval
+else
+  DMRAID_MINI=no
+fi;
+
+echo $ac_n "checking whether to disable native metadata logging""... $ac_c" 1>&6
+# Check whether --enable-native_log or --disable-native_log was given.
+if test "${enable_native_log+set}" = set; then
+  enableval="$enable_native_log"
+  \
+DMRAID_NATIVE_LOG=$enableval
+else
+  DMRAID_NATIVE_LOG=yes
+fi;
+echo "$ac_t""$DMRAID_NATIVE_LOG" 1>&6
+
+# Check whether --enable-static_link or --disable-static_link was given.
+if test "${enable_static_link+set}" = set; then
+  enableval="$enable_static_link"
+  STATIC_LINK=$enableval
+else
+  STATIC_LINK=no
+fi;
+
+# Check whether --enable-shared_lib or --disable-shared_lib was given.
+if test "${enable_shared_lib+set}" = set; then
+  enableval="$enable_shared_lib"
+  LIB_SO=$enableval
+else
+  LIB_SO=no
+fi;
+
+echo $ac_n "checking whether to disable testing with mapped devices""... $ac_c" 1>&6
+# Check whether --enable-testing or --disable-testing was given.
+if test "${enable_testing+set}" = set; then
+  enableval="$enable_testing"
+  \
+DMRAID_TEST=no
+else
+  DMRAID_TEST=yes
+fi;
+
+echo "$ac_t""$DEBUG" 1>&6
+
+if test x$LIB_SO = xyes; then
+	FLAVOUR="shared "
+fi
+
+if test x$STATIC_LINK = xyes; then
+	FLAVOUR="static "
+	if test x$LIB_SO = xyes; then
+		{ { echo "$as_me:$LINENO: error: You can' enable both shared_lib and static_link!" >&5
+echo "$as_me: error: You can' enable both shared_lib and static_link!" >&2;}
+   { (exit 1); exit 1; }; }
+		exit 1
+	fi
+fi
+
+if test x$DMRAID_MINI = xyes; then
+        CFLAGS="$CFLAGS -DDMRAID_MINI"
+	FLAVOUR="${FLAVOUR}mini "
+else
+	if test x$DMRAID_NATIVE_LOG = xno; then
+		FLAVOUR="${FLAVOUR}no_native_log "
+	else
+        	CFLAGS="$CFLAGS -DDMRAID_NATIVE_LOG"
+	fi
+fi
+
+if test x$DEBUG = xyes; then
+	FLAVOUR="${FLAVOUR}debug "
+fi
+
+if test x$DEBUG_MALLOC = xyes; then
+	FLAVOUR="${FLAVOUR}debug_malloc "
+fi
+
+if [ "x$exec_prefix" = xNONE -a "x$prefix" = xNONE ];
+ then  exec_prefix="";
+fi;
+
+if test $ac_cv_c_compiler_gnu = yes; then
+    echo "$as_me:$LINENO: checking whether $CC needs -traditional" >&5
+echo $ECHO_N "checking whether $CC needs -traditional... $ECHO_C" >&6
+if test "${ac_cv_prog_gcc_traditional+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+    ac_pattern="Autoconf.*'x'"
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sgtty.h>
+Autoconf TIOCGETP
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "$ac_pattern" >/dev/null 2>&1; then
+  ac_cv_prog_gcc_traditional=yes
+else
+  ac_cv_prog_gcc_traditional=no
+fi
+rm -f conftest*
+
+
+  if test $ac_cv_prog_gcc_traditional = no; then
+    cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <termio.h>
+Autoconf TCGETA
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "$ac_pattern" >/dev/null 2>&1; then
+  ac_cv_prog_gcc_traditional=yes
+fi
+rm -f conftest*
+
+  fi
+fi
+echo "$as_me:$LINENO: result: $ac_cv_prog_gcc_traditional" >&5
+echo "${ECHO_T}$ac_cv_prog_gcc_traditional" >&6
+  if test $ac_cv_prog_gcc_traditional = yes; then
+    CC="$CC -traditional"
+  fi
+fi
+
+echo "$as_me:$LINENO: checking return type of signal handlers" >&5
+echo $ECHO_N "checking return type of signal handlers... $ECHO_C" >&6
+if test "${ac_cv_type_signal+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <signal.h>
+#ifdef signal
+# undef signal
+#endif
+#ifdef __cplusplus
+extern "C" void (*signal (int, void (*)(int)))(int);
+#else
+void (*signal ()) ();
+#endif
+
+int
+main ()
+{
+int i;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_type_signal=void
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_type_signal=int
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_type_signal" >&5
+echo "${ECHO_T}$ac_cv_type_signal" >&6
+
+cat >>confdefs.h <<_ACEOF
+#define RETSIGTYPE $ac_cv_type_signal
+_ACEOF
+
+
+
+for ac_func in vprintf
+do
+as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
+echo "$as_me:$LINENO: checking for $ac_func" >&5
+echo $ECHO_N "checking for $ac_func... $ECHO_C" >&6
+if eval "test \"\${$as_ac_var+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Define $ac_func to an innocuous variant, in case <limits.h> declares $ac_func.
+   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
+#define $ac_func innocuous_$ac_func
+
+/* System header to define __stub macros and hopefully few prototypes,
+    which can conflict with char $ac_func (); below.
+    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+    <limits.h> exists even on freestanding compilers.  */
+
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+
+#undef $ac_func
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char $ac_func ();
+/* The GNU C library defines this for functions which it implements
+    to always fail with ENOSYS.  Some functions are actually named
+    something starting with __ and the normal name is an alias.  */
+#if defined (__stub_$ac_func) || defined (__stub___$ac_func)
+choke me
+#else
+char (*f) () = $ac_func;
+#endif
+#ifdef __cplusplus
+}
+#endif
+
+int
+main ()
+{
+return f != $ac_func;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  eval "$as_ac_var=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+eval "$as_ac_var=no"
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_var'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_var'}'`" >&6
+if test `eval echo '${'$as_ac_var'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_func" | $as_tr_cpp` 1
+_ACEOF
+
+echo "$as_me:$LINENO: checking for _doprnt" >&5
+echo $ECHO_N "checking for _doprnt... $ECHO_C" >&6
+if test "${ac_cv_func__doprnt+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Define _doprnt to an innocuous variant, in case <limits.h> declares _doprnt.
+   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
+#define _doprnt innocuous__doprnt
+
+/* System header to define __stub macros and hopefully few prototypes,
+    which can conflict with char _doprnt (); below.
+    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+    <limits.h> exists even on freestanding compilers.  */
+
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+
+#undef _doprnt
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char _doprnt ();
+/* The GNU C library defines this for functions which it implements
+    to always fail with ENOSYS.  Some functions are actually named
+    something starting with __ and the normal name is an alias.  */
+#if defined (__stub__doprnt) || defined (__stub____doprnt)
+choke me
+#else
+char (*f) () = _doprnt;
+#endif
+#ifdef __cplusplus
+}
+#endif
+
+int
+main ()
+{
+return f != _doprnt;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_func__doprnt=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_cv_func__doprnt=no
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: $ac_cv_func__doprnt" >&5
+echo "${ECHO_T}$ac_cv_func__doprnt" >&6
+if test $ac_cv_func__doprnt = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_DOPRNT 1
+_ACEOF
+
+fi
+
+fi
+done
+
+
+
+
+
+for ac_func in mkdir rmdir uname
+do
+as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
+echo "$as_me:$LINENO: checking for $ac_func" >&5
+echo $ECHO_N "checking for $ac_func... $ECHO_C" >&6
+if eval "test \"\${$as_ac_var+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Define $ac_func to an innocuous variant, in case <limits.h> declares $ac_func.
+   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
+#define $ac_func innocuous_$ac_func
+
+/* System header to define __stub macros and hopefully few prototypes,
+    which can conflict with char $ac_func (); below.
+    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+    <limits.h> exists even on freestanding compilers.  */
+
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+
+#undef $ac_func
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char $ac_func ();
+/* The GNU C library defines this for functions which it implements
+    to always fail with ENOSYS.  Some functions are actually named
+    something starting with __ and the normal name is an alias.  */
+#if defined (__stub_$ac_func) || defined (__stub___$ac_func)
+choke me
+#else
+char (*f) () = $ac_func;
+#endif
+#ifdef __cplusplus
+}
+#endif
+
+int
+main ()
+{
+return f != $ac_func;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  eval "$as_ac_var=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+eval "$as_ac_var=no"
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_var'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_var'}'`" >&6
+if test `eval echo '${'$as_ac_var'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_func" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+done
+
+
+if test x$READLINE = xyes; then
+	echo "$as_me:$LINENO: checking for library containing tgetent" >&5
+echo $ECHO_N "checking for library containing tgetent... $ECHO_C" >&6
+if test "${ac_cv_search_tgetent+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_func_search_save_LIBS=$LIBS
+ac_cv_search_tgetent=no
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char tgetent ();
+int
+main ()
+{
+tgetent ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_search_tgetent="none required"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+if test "$ac_cv_search_tgetent" = no; then
+  for ac_lib in ncurses curses termcap termlib; do
+    LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
+    cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any gcc2 internal prototype to avoid an error.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+/* We use char because int might match the return type of a gcc2
+   builtin and then its argument prototype would still apply.  */
+char tgetent ();
+int
+main ()
+{
+tgetent ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (eval echo "$as_me:$LINENO: \"$ac_link\"") >&5
+  (eval $ac_link) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest$ac_exeext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_search_tgetent="-l$ac_lib"
+break
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+fi
+rm -f conftest.err conftest.$ac_objext \
+      conftest$ac_exeext conftest.$ac_ext
+  done
+fi
+LIBS=$ac_func_search_save_LIBS
+fi
+echo "$as_me:$LINENO: result: $ac_cv_search_tgetent" >&5
+echo "${ECHO_T}$ac_cv_search_tgetent" >&6
+if test "$ac_cv_search_tgetent" != no; then
+  test "$ac_cv_search_tgetent" = "none required" || LIBS="$ac_cv_search_tgetent $LIBS"
+
+else
+  { { echo "$as_me:$LINENO: error: termcap could not be found which is required for the
+--enable-readline option (which is enabled by default).  Either disable readline
+support with --disable-readline or download and install termcap from:
+	ftp.gnu.org/gnu/termcap
+Note: if you are using precompiled packages you will also need the development
+  package as well (which may be called termcap-devel or something similar).
+Note: (n)curses also seems to work as a substitute for termcap.  This was
+  not found either - but you could try installing that as well.
+" >&5
+echo "$as_me: error: termcap could not be found which is required for the
+--enable-readline option (which is enabled by default).  Either disable readline
+support with --disable-readline or download and install termcap from:
+	ftp.gnu.org/gnu/termcap
+Note: if you are using precompiled packages you will also need the development
+  package as well (which may be called termcap-devel or something similar).
+Note: (n)curses also seems to work as a substitute for termcap.  This was
+  not found either - but you could try installing that as well.
+" >&2;}
+   { (exit 1); exit 1; }; }
+	exit
+
+fi
+
+fi
+
+if test x$KLIBC != xyes; then
+
+for ac_header in getopt.h
+do
+as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+else
+  # Is the header compilable?
+echo "$as_me:$LINENO: checking $ac_header usability" >&5
+echo $ECHO_N "checking $ac_header usability... $ECHO_C" >&6
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+#include <$ac_header>
+_ACEOF
+rm -f conftest.$ac_objext
+if { (eval echo "$as_me:$LINENO: \"$ac_compile\"") >&5
+  (eval $ac_compile) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } &&
+	 { ac_try='test -z "$ac_c_werror_flag"
+			 || test ! -s conftest.err'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; } &&
+	 { ac_try='test -s conftest.$ac_objext'
+  { (eval echo "$as_me:$LINENO: \"$ac_try\"") >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_header_compiler=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+ac_header_compiler=no
+fi
+rm -f conftest.err conftest.$ac_objext conftest.$ac_ext
+echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+echo "${ECHO_T}$ac_header_compiler" >&6
+
+# Is the header present?
+echo "$as_me:$LINENO: checking $ac_header presence" >&5
+echo $ECHO_N "checking $ac_header presence... $ECHO_C" >&6
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <$ac_header>
+_ACEOF
+if { (eval echo "$as_me:$LINENO: \"$ac_cpp conftest.$ac_ext\"") >&5
+  (eval $ac_cpp conftest.$ac_ext) 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null; then
+  if test -s conftest.err; then
+    ac_cpp_err=$ac_c_preproc_warn_flag
+    ac_cpp_err=$ac_cpp_err$ac_c_werror_flag
+  else
+    ac_cpp_err=
+  fi
+else
+  ac_cpp_err=yes
+fi
+if test -z "$ac_cpp_err"; then
+  ac_header_preproc=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  ac_header_preproc=no
+fi
+rm -f conftest.err conftest.$ac_ext
+echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+echo "${ECHO_T}$ac_header_preproc" >&6
+
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
+    (
+      cat <<\_ASBOX
+## ------------------------------------------ ##
+## Report this to the AC_PACKAGE_NAME lists.  ##
+## ------------------------------------------ ##
+_ASBOX
+    ) |
+      sed "s/^/$as_me: WARNING:     /" >&2
+    ;;
+esac
+echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6
+if eval "test \"\${$as_ac_Header+set}\" = set"; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  eval "$as_ac_Header=\$ac_header_preproc"
+fi
+echo "$as_me:$LINENO: result: `eval echo '${'$as_ac_Header'}'`" >&5
+echo "${ECHO_T}`eval echo '${'$as_ac_Header'}'`" >&6
+
+fi
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+ CFLAGS="$CFLAGS -DHAVE_GETOPTLONG"
+fi
+
+done
+
+fi
+
+if test "-f tools/VERSION"; then
+  DMRAID_VERSION="`cat tools/VERSION`"
+else
+  DMRAID_VERSION="Unknown"
+fi
+
+if test "-f lib/version.h"; then
+  DMRAID_LIB_VERSION="`sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[^_].*"\(.*\)"/\2/p' lib/version.h`"
+else
+  DMRAID_LIB_VERSION="Unknown"
+fi
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+                                                                      ac_config_files="$ac_config_files include/Makefile lib/Makefile man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
+cat >confcache <<\_ACEOF
+# This file is a shell script that caches the results of configure
+# tests run on this system so they can be shared between configure
+# scripts and configure runs, see configure's option --config-cache.
+# It is not useful on other systems.  If it contains results you don't
+# want to keep, you may remove or edit it.
+#
+# config.status only pays attention to the cache file if you give it
+# the --recheck option to rerun configure.
+#
+# `ac_cv_env_foo' variables (set or unset) will be overridden when
+# loading this file, other *unset* `ac_cv_foo' will be assigned the
+# following values.
+
+_ACEOF
+
+# The following way of writing the cache mishandles newlines in values,
+# but we know of no workaround that is simple, portable, and efficient.
+# So, don't put newlines in cache variables' values.
+# Ultrix sh set writes to stderr and can't be redirected directly,
+# and sets the high bit in the cache file unless we assign to the vars.
+{
+  (set) 2>&1 |
+    case `(ac_space=' '; set | grep ac_space) 2>&1` in
+    *ac_space=\ *)
+      # `set' does not quote correctly, so add quotes (double-quote
+      # substitution turns \\\\ into \\, and sed turns \\ into \).
+      sed -n \
+	"s/'/'\\\\''/g;
+	  s/^\\([_$as_cr_alnum]*_cv_[_$as_cr_alnum]*\\)=\\(.*\\)/\\1='\\2'/p"
+      ;;
+    *)
+      # `set' quotes correctly as required by POSIX, so do not add quotes.
+      sed -n \
+	"s/^\\([_$as_cr_alnum]*_cv_[_$as_cr_alnum]*\\)=\\(.*\\)/\\1=\\2/p"
+      ;;
+    esac;
+} |
+  sed '
+     t clear
+     : clear
+     s/^\([^=]*\)=\(.*[{}].*\)$/test "${\1+set}" = set || &/
+     t end
+     /^ac_cv_env/!s/^\([^=]*\)=\(.*\)$/\1=${\1=\2}/
+     : end' >>confcache
+if diff $cache_file confcache >/dev/null 2>&1; then :; else
+  if test -w $cache_file; then
+    test "x$cache_file" != "x/dev/null" && echo "updating cache $cache_file"
+    cat confcache >$cache_file
+  else
+    echo "not updating unwritable cache $cache_file"
+  fi
+fi
+rm -f confcache
+
+test "x$prefix" = xNONE && prefix=$ac_default_prefix
+# Let make expand exec_prefix.
+test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'
+
+# VPATH may cause trouble with some makes, so we remove $(srcdir),
+# ${srcdir} and @srcdir@ from VPATH if srcdir is ".", strip leading and
+# trailing colons and then remove the whole line if VPATH becomes empty
+# (actually we leave an empty line to preserve line numbers).
+if test "x$srcdir" = x.; then
+  ac_vpsub='/^[	 ]*VPATH[	 ]*=/{
+s/:*\$(srcdir):*/:/;
+s/:*\${srcdir}:*/:/;
+s/:*@srcdir@:*/:/;
+s/^\([^=]*=[	 ]*\):*/\1/;
+s/:*$//;
+s/^[^=]*=[	 ]*$//;
+}'
+fi
+
+# Transform confdefs.h into DEFS.
+# Protect against shell expansion while executing Makefile rules.
+# Protect against Makefile macro expansion.
+#
+# If the first sed substitution is executed (which looks for macros that
+# take arguments), then we branch to the quote section.  Otherwise,
+# look for a macro that doesn't take arguments.
+cat >confdef2opt.sed <<\_ACEOF
+t clear
+: clear
+s,^[	 ]*#[	 ]*define[	 ][	 ]*\([^	 (][^	 (]*([^)]*)\)[	 ]*\(.*\),-D\1=\2,g
+t quote
+s,^[	 ]*#[	 ]*define[	 ][	 ]*\([^	 ][^	 ]*\)[	 ]*\(.*\),-D\1=\2,g
+t quote
+d
+: quote
+s,[	 `~#$^&*(){}\\|;'"<>?],\\&,g
+s,\[,\\&,g
+s,\],\\&,g
+s,\$,$$,g
+p
+_ACEOF
+# We use echo to avoid assuming a particular line-breaking character.
+# The extra dot is to prevent the shell from consuming trailing
+# line-breaks from the sub-command output.  A line-break within
+# single-quotes doesn't work because, if this script is created in a
+# platform that uses two characters for line-breaks (e.g., DOS), tr
+# would break.
+ac_LF_and_DOT=`echo; echo .`
+DEFS=`sed -n -f confdef2opt.sed confdefs.h | tr "$ac_LF_and_DOT" ' .'`
+rm -f confdef2opt.sed
+
+
+ac_libobjs=
+ac_ltlibobjs=
+for ac_i in : $LIBOBJS; do test "x$ac_i" = x: && continue
+  # 1. Remove the extension, and $U if already installed.
+  ac_i=`echo "$ac_i" |
+	 sed 's/\$U\././;s/\.o$//;s/\.obj$//'`
+  # 2. Add them.
+  ac_libobjs="$ac_libobjs $ac_i\$U.$ac_objext"
+  ac_ltlibobjs="$ac_ltlibobjs $ac_i"'$U.lo'
+done
+LIBOBJS=$ac_libobjs
+
+LTLIBOBJS=$ac_ltlibobjs
+
+
+
+: ${CONFIG_STATUS=./config.status}
+ac_clean_files_save=$ac_clean_files
+ac_clean_files="$ac_clean_files $CONFIG_STATUS"
+{ echo "$as_me:$LINENO: creating $CONFIG_STATUS" >&5
+echo "$as_me: creating $CONFIG_STATUS" >&6;}
+cat >$CONFIG_STATUS <<_ACEOF
+#! $SHELL
+# Generated by $as_me.
+# Run this file to recreate the current configuration.
+# Compiler output produced by configure, useful for debugging
+# configure, is in config.log if it exists.
+
+debug=false
+ac_cs_recheck=false
+ac_cs_silent=false
+SHELL=\${CONFIG_SHELL-$SHELL}
+_ACEOF
+
+cat >>$CONFIG_STATUS <<\_ACEOF
+## --------------------- ##
+## M4sh Initialization.  ##
+## --------------------- ##
+
+# Be Bourne compatible
+if test -n "${ZSH_VERSION+set}" && (emulate sh) >/dev/null 2>&1; then
+  emulate sh
+  NULLCMD=:
+  # Zsh 3.x and 4.x performs word splitting on ${1+"$@"}, which
+  # is contrary to our usage.  Disable this feature.
+  alias -g '${1+"$@"}'='"$@"'
+elif test -n "${BASH_VERSION+set}" && (set -o posix) >/dev/null 2>&1; then
+  set -o posix
+fi
+DUALCASE=1; export DUALCASE # for MKS sh
+
+# Support unset when possible.
+if ( (MAIL=60; unset MAIL) || exit) >/dev/null 2>&1; then
+  as_unset=unset
+else
+  as_unset=false
+fi
+
+
+# Work around bugs in pre-3.0 UWIN ksh.
+$as_unset ENV MAIL MAILPATH
+PS1='$ '
+PS2='> '
+PS4='+ '
+
+# NLS nuisances.
+for as_var in \
+  LANG LANGUAGE LC_ADDRESS LC_ALL LC_COLLATE LC_CTYPE LC_IDENTIFICATION \
+  LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER \
+  LC_TELEPHONE LC_TIME
+do
+  if (set +x; test -z "`(eval $as_var=C; export $as_var) 2>&1`"); then
+    eval $as_var=C; export $as_var
+  else
+    $as_unset $as_var
+  fi
+done
+
+# Required to use basename.
+if expr a : '\(a\)' >/dev/null 2>&1; then
+  as_expr=expr
+else
+  as_expr=false
+fi
+
+if (basename /) >/dev/null 2>&1 && test "X`basename / 2>&1`" = "X/"; then
+  as_basename=basename
+else
+  as_basename=false
+fi
+
+
+# Name of the executable.
+as_me=`$as_basename "$0" ||
+$as_expr X/"$0" : '.*/\([^/][^/]*\)/*$' \| \
+	 X"$0" : 'X\(//\)$' \| \
+	 X"$0" : 'X\(/\)$' \| \
+	 .     : '\(.\)' 2>/dev/null ||
+echo X/"$0" |
+    sed '/^.*\/\([^/][^/]*\)\/*$/{ s//\1/; q; }
+  	  /^X\/\(\/\/\)$/{ s//\1/; q; }
+  	  /^X\/\(\/\).*/{ s//\1/; q; }
+  	  s/.*/./; q'`
+
+
+# PATH needs CR, and LINENO needs CR and PATH.
+# Avoid depending upon Character Ranges.
+as_cr_letters='abcdefghijklmnopqrstuvwxyz'
+as_cr_LETTERS='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
+as_cr_Letters=$as_cr_letters$as_cr_LETTERS
+as_cr_digits='0123456789'
+as_cr_alnum=$as_cr_Letters$as_cr_digits
+
+# The user is always right.
+if test "${PATH_SEPARATOR+set}" != set; then
+  echo "#! /bin/sh" >conf$$.sh
+  echo  "exit 0"   >>conf$$.sh
+  chmod +x conf$$.sh
+  if (PATH="/nonexistent;."; conf$$.sh) >/dev/null 2>&1; then
+    PATH_SEPARATOR=';'
+  else
+    PATH_SEPARATOR=:
+  fi
+  rm -f conf$$.sh
+fi
+
+
+  as_lineno_1=$LINENO
+  as_lineno_2=$LINENO
+  as_lineno_3=`(expr $as_lineno_1 + 1) 2>/dev/null`
+  test "x$as_lineno_1" != "x$as_lineno_2" &&
+  test "x$as_lineno_3"  = "x$as_lineno_2"  || {
+  # Find who we are.  Look in the path if we contain no path at all
+  # relative or not.
+  case $0 in
+    *[\\/]* ) as_myself=$0 ;;
+    *) as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  test -r "$as_dir/$0" && as_myself=$as_dir/$0 && break
+done
+
+       ;;
+  esac
+  # We did not find ourselves, most probably we were run as `sh COMMAND'
+  # in which case we are not to be found in the path.
+  if test "x$as_myself" = x; then
+    as_myself=$0
+  fi
+  if test ! -f "$as_myself"; then
+    { { echo "$as_me:$LINENO: error: cannot find myself; rerun with an absolute path" >&5
+echo "$as_me: error: cannot find myself; rerun with an absolute path" >&2;}
+   { (exit 1); exit 1; }; }
+  fi
+  case $CONFIG_SHELL in
+  '')
+    as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in /bin$PATH_SEPARATOR/usr/bin$PATH_SEPARATOR$PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for as_base in sh bash ksh sh5; do
+	 case $as_dir in
+	 /*)
+	   if ("$as_dir/$as_base" -c '
+  as_lineno_1=$LINENO
+  as_lineno_2=$LINENO
+  as_lineno_3=`(expr $as_lineno_1 + 1) 2>/dev/null`
+  test "x$as_lineno_1" != "x$as_lineno_2" &&
+  test "x$as_lineno_3"  = "x$as_lineno_2" ') 2>/dev/null; then
+	     $as_unset BASH_ENV || test "${BASH_ENV+set}" != set || { BASH_ENV=; export BASH_ENV; }
+	     $as_unset ENV || test "${ENV+set}" != set || { ENV=; export ENV; }
+	     CONFIG_SHELL=$as_dir/$as_base
+	     export CONFIG_SHELL
+	     exec "$CONFIG_SHELL" "$0" ${1+"$@"}
+	   fi;;
+	 esac
+       done
+done
+;;
+  esac
+
+  # Create $as_me.lineno as a copy of $as_myself, but with $LINENO
+  # uniformly replaced by the line number.  The first 'sed' inserts a
+  # line-number line before each line; the second 'sed' does the real
+  # work.  The second script uses 'N' to pair each line-number line
+  # with the numbered line, and appends trailing '-' during
+  # substitution so that $LINENO is not a special case at line end.
+  # (Raja R Harinath suggested sed '=', and Paul Eggert wrote the
+  # second 'sed' script.  Blame Lee E. McMahon for sed's syntax.  :-)
+  sed '=' <$as_myself |
+    sed '
+      N
+      s,$,-,
+      : loop
+      s,^\(['$as_cr_digits']*\)\(.*\)[$]LINENO\([^'$as_cr_alnum'_]\),\1\2\1\3,
+      t loop
+      s,-$,,
+      s,^['$as_cr_digits']*\n,,
+    ' >$as_me.lineno &&
+  chmod +x $as_me.lineno ||
+    { { echo "$as_me:$LINENO: error: cannot create $as_me.lineno; rerun with a POSIX shell" >&5
+echo "$as_me: error: cannot create $as_me.lineno; rerun with a POSIX shell" >&2;}
+   { (exit 1); exit 1; }; }
+
+  # Don't try to exec as it changes $[0], causing all sort of problems
+  # (the dirname of $[0] is not the place where we might find the
+  # original and so on.  Autoconf is especially sensible to this).
+  . ./$as_me.lineno
+  # Exit status is that of the last command.
+  exit
+}
+
+
+case `echo "testing\c"; echo 1,2,3`,`echo -n testing; echo 1,2,3` in
+  *c*,-n*) ECHO_N= ECHO_C='
+' ECHO_T='	' ;;
+  *c*,*  ) ECHO_N=-n ECHO_C= ECHO_T= ;;
+  *)       ECHO_N= ECHO_C='\c' ECHO_T= ;;
+esac
+
+if expr a : '\(a\)' >/dev/null 2>&1; then
+  as_expr=expr
+else
+  as_expr=false
+fi
+
+rm -f conf$$ conf$$.exe conf$$.file
+echo >conf$$.file
+if ln -s conf$$.file conf$$ 2>/dev/null; then
+  # We could just check for DJGPP; but this test a) works b) is more generic
+  # and c) will remain valid once DJGPP supports symlinks (DJGPP 2.04).
+  if test -f conf$$.exe; then
+    # Don't use ln at all; we don't have any links
+    as_ln_s='cp -p'
+  else
+    as_ln_s='ln -s'
+  fi
+elif ln conf$$.file conf$$ 2>/dev/null; then
+  as_ln_s=ln
+else
+  as_ln_s='cp -p'
+fi
+rm -f conf$$ conf$$.exe conf$$.file
+
+if mkdir -p . 2>/dev/null; then
+  as_mkdir_p=:
+else
+  test -d ./-p && rmdir ./-p
+  as_mkdir_p=false
+fi
+
+as_executable_p="test -f"
+
+# Sed expression to map a string onto a valid CPP name.
+as_tr_cpp="eval sed 'y%*$as_cr_letters%P$as_cr_LETTERS%;s%[^_$as_cr_alnum]%_%g'"
+
+# Sed expression to map a string onto a valid variable name.
+as_tr_sh="eval sed 'y%*+%pp%;s%[^_$as_cr_alnum]%_%g'"
+
+
+# IFS
+# We need space, tab and new line, in precisely that order.
+as_nl='
+'
+IFS=" 	$as_nl"
+
+# CDPATH.
+$as_unset CDPATH
+
+exec 6>&1
+
+# Open the log real soon, to keep \$[0] and so on meaningful, and to
+# report actual input values of CONFIG_FILES etc. instead of their
+# values after options handling.  Logging --version etc. is OK.
+exec 5>>config.log
+{
+  echo
+  sed 'h;s/./-/g;s/^.../## /;s/...$/ ##/;p;x;p;x' <<_ASBOX
+## Running $as_me. ##
+_ASBOX
+} >&5
+cat >&5 <<_CSEOF
+
+This file was extended by $as_me, which was
+generated by GNU Autoconf 2.59.  Invocation command line was
+
+  CONFIG_FILES    = $CONFIG_FILES
+  CONFIG_HEADERS  = $CONFIG_HEADERS
+  CONFIG_LINKS    = $CONFIG_LINKS
+  CONFIG_COMMANDS = $CONFIG_COMMANDS
+  $ $0 $@
+
+_CSEOF
+echo "on `(hostname || uname -n) 2>/dev/null | sed 1q`" >&5
+echo >&5
+_ACEOF
+
+# Files that config.status was made for.
+if test -n "$ac_config_files"; then
+  echo "config_files=\"$ac_config_files\"" >>$CONFIG_STATUS
+fi
+
+if test -n "$ac_config_headers"; then
+  echo "config_headers=\"$ac_config_headers\"" >>$CONFIG_STATUS
+fi
+
+if test -n "$ac_config_links"; then
+  echo "config_links=\"$ac_config_links\"" >>$CONFIG_STATUS
+fi
+
+if test -n "$ac_config_commands"; then
+  echo "config_commands=\"$ac_config_commands\"" >>$CONFIG_STATUS
+fi
+
+cat >>$CONFIG_STATUS <<\_ACEOF
+
+ac_cs_usage="\
+\`$as_me' instantiates files from templates according to the
+current configuration.
+
+Usage: $0 [OPTIONS] [FILE]...
+
+  -h, --help       print this help, then exit
+  -V, --version    print version number, then exit
+  -q, --quiet      do not print progress messages
+  -d, --debug      don't remove temporary files
+      --recheck    update $as_me by reconfiguring in the same conditions
+  --file=FILE[:TEMPLATE]
+		   instantiate the configuration file FILE
+
+Configuration files:
+$config_files
+
+Report bugs to <bug-autoconf@gnu.org>."
+_ACEOF
+
+cat >>$CONFIG_STATUS <<_ACEOF
+ac_cs_version="\\
+config.status
+configured by $0, generated by GNU Autoconf 2.59,
+  with options \\"`echo "$ac_configure_args" | sed 's/[\\""\`\$]/\\\\&/g'`\\"
+
+Copyright (C) 2003 Free Software Foundation, Inc.
+This config.status script is free software; the Free Software Foundation
+gives unlimited permission to copy, distribute and modify it."
+srcdir=$srcdir
+INSTALL="$INSTALL"
+_ACEOF
+
+cat >>$CONFIG_STATUS <<\_ACEOF
+# If no file are specified by the user, then we need to provide default
+# value.  By we need to know if files were specified by the user.
+ac_need_defaults=:
+while test $# != 0
+do
+  case $1 in
+  --*=*)
+    ac_option=`expr "x$1" : 'x\([^=]*\)='`
+    ac_optarg=`expr "x$1" : 'x[^=]*=\(.*\)'`
+    ac_shift=:
+    ;;
+  -*)
+    ac_option=$1
+    ac_optarg=$2
+    ac_shift=shift
+    ;;
+  *) # This is not an option, so the user has probably given explicit
+     # arguments.
+     ac_option=$1
+     ac_need_defaults=false;;
+  esac
+
+  case $ac_option in
+  # Handling of the options.
+_ACEOF
+cat >>$CONFIG_STATUS <<\_ACEOF
+  -recheck | --recheck | --rechec | --reche | --rech | --rec | --re | --r)
+    ac_cs_recheck=: ;;
+  --version | --vers* | -V )
+    echo "$ac_cs_version"; exit 0 ;;
+  --he | --h)
+    # Conflict between --help and --header
+    { { echo "$as_me:$LINENO: error: ambiguous option: $1
+Try \`$0 --help' for more information." >&5
+echo "$as_me: error: ambiguous option: $1
+Try \`$0 --help' for more information." >&2;}
+   { (exit 1); exit 1; }; };;
+  --help | --hel | -h )
+    echo "$ac_cs_usage"; exit 0 ;;
+  --debug | --d* | -d )
+    debug=: ;;
+  --file | --fil | --fi | --f )
+    $ac_shift
+    CONFIG_FILES="$CONFIG_FILES $ac_optarg"
+    ac_need_defaults=false;;
+  --header | --heade | --head | --hea )
+    $ac_shift
+    CONFIG_HEADERS="$CONFIG_HEADERS $ac_optarg"
+    ac_need_defaults=false;;
+  -q | -quiet | --quiet | --quie | --qui | --qu | --q \
+  | -silent | --silent | --silen | --sile | --sil | --si | --s)
+    ac_cs_silent=: ;;
+
+  # This is an error.
+  -*) { { echo "$as_me:$LINENO: error: unrecognized option: $1
+Try \`$0 --help' for more information." >&5
+echo "$as_me: error: unrecognized option: $1
+Try \`$0 --help' for more information." >&2;}
+   { (exit 1); exit 1; }; } ;;
+
+  *) ac_config_targets="$ac_config_targets $1" ;;
+
+  esac
+  shift
+done
+
+ac_configure_extra_args=
+
+if $ac_cs_silent; then
+  exec 6>/dev/null
+  ac_configure_extra_args="$ac_configure_extra_args --silent"
+fi
+
+_ACEOF
+cat >>$CONFIG_STATUS <<_ACEOF
+if \$ac_cs_recheck; then
+  echo "running $SHELL $0 " $ac_configure_args \$ac_configure_extra_args " --no-create --no-recursion" >&6
+  exec $SHELL $0 $ac_configure_args \$ac_configure_extra_args --no-create --no-recursion
+fi
+
+_ACEOF
+
+
+
+
+
+cat >>$CONFIG_STATUS <<\_ACEOF
+for ac_config_target in $ac_config_targets
+do
+  case "$ac_config_target" in
+  # Handling of arguments.
+  "include/Makefile" ) CONFIG_FILES="$CONFIG_FILES include/Makefile" ;;
+  "lib/Makefile" ) CONFIG_FILES="$CONFIG_FILES lib/Makefile" ;;
+  "man/Makefile" ) CONFIG_FILES="$CONFIG_FILES man/Makefile" ;;
+  "tools/Makefile" ) CONFIG_FILES="$CONFIG_FILES tools/Makefile" ;;
+  "tools/version.h" ) CONFIG_FILES="$CONFIG_FILES tools/version.h" ;;
+  "Makefile" ) CONFIG_FILES="$CONFIG_FILES Makefile" ;;
+  "make.tmpl" ) CONFIG_FILES="$CONFIG_FILES make.tmpl" ;;
+  *) { { echo "$as_me:$LINENO: error: invalid argument: $ac_config_target" >&5
+echo "$as_me: error: invalid argument: $ac_config_target" >&2;}
+   { (exit 1); exit 1; }; };;
+  esac
+done
+
+# If the user did not use the arguments to specify the items to instantiate,
+# then the envvar interface is used.  Set only those that are not.
+# We use the long form for the default assignment because of an extremely
+# bizarre bug on SunOS 4.1.3.
+if $ac_need_defaults; then
+  test "${CONFIG_FILES+set}" = set || CONFIG_FILES=$config_files
+fi
+
+# Have a temporary directory for convenience.  Make it in the build tree
+# simply because there is no reason to put it here, and in addition,
+# creating and moving files from /tmp can sometimes cause problems.
+# Create a temporary directory, and hook for its removal unless debugging.
+$debug ||
+{
+  trap 'exit_status=$?; rm -rf $tmp && exit $exit_status' 0
+  trap '{ (exit 1); exit 1; }' 1 2 13 15
+}
+
+# Create a (secure) tmp directory for tmp files.
+
+{
+  tmp=`(umask 077 && mktemp -d -q "./confstatXXXXXX") 2>/dev/null` &&
+  test -n "$tmp" && test -d "$tmp"
+}  ||
+{
+  tmp=./confstat$$-$RANDOM
+  (umask 077 && mkdir $tmp)
+} ||
+{
+   echo "$me: cannot create a temporary directory in ." >&2
+   { (exit 1); exit 1; }
+}
+
+_ACEOF
+
+cat >>$CONFIG_STATUS <<_ACEOF
+
+#
+# CONFIG_FILES section.
+#
+
+# No need to generate the scripts if there are no CONFIG_FILES.
+# This happens for instance when ./config.status config.h
+if test -n "\$CONFIG_FILES"; then
+  # Protect against being on the right side of a sed subst in config.status.
+  sed 's/,@/@@/; s/@,/@@/; s/,;t t\$/@;t t/; /@;t t\$/s/[\\\\&,]/\\\\&/g;
+   s/@@/,@/; s/@@/@,/; s/@;t t\$/,;t t/' >\$tmp/subs.sed <<\\CEOF
+s,@SHELL@,$SHELL,;t t
+s,@PATH_SEPARATOR@,$PATH_SEPARATOR,;t t
+s,@PACKAGE_NAME@,$PACKAGE_NAME,;t t
+s,@PACKAGE_TARNAME@,$PACKAGE_TARNAME,;t t
+s,@PACKAGE_VERSION@,$PACKAGE_VERSION,;t t
+s,@PACKAGE_STRING@,$PACKAGE_STRING,;t t
+s,@PACKAGE_BUGREPORT@,$PACKAGE_BUGREPORT,;t t
+s,@exec_prefix@,$exec_prefix,;t t
+s,@prefix@,$prefix,;t t
+s,@program_transform_name@,$program_transform_name,;t t
+s,@bindir@,$bindir,;t t
+s,@sbindir@,$sbindir,;t t
+s,@libexecdir@,$libexecdir,;t t
+s,@datadir@,$datadir,;t t
+s,@sysconfdir@,$sysconfdir,;t t
+s,@sharedstatedir@,$sharedstatedir,;t t
+s,@localstatedir@,$localstatedir,;t t
+s,@libdir@,$libdir,;t t
+s,@includedir@,$includedir,;t t
+s,@oldincludedir@,$oldincludedir,;t t
+s,@infodir@,$infodir,;t t
+s,@mandir@,$mandir,;t t
+s,@build_alias@,$build_alias,;t t
+s,@host_alias@,$host_alias,;t t
+s,@target_alias@,$target_alias,;t t
+s,@DEFS@,$DEFS,;t t
+s,@ECHO_C@,$ECHO_C,;t t
+s,@ECHO_N@,$ECHO_N,;t t
+s,@ECHO_T@,$ECHO_T,;t t
+s,@LIBS@,$LIBS,;t t
+s,@build@,$build,;t t
+s,@build_cpu@,$build_cpu,;t t
+s,@build_vendor@,$build_vendor,;t t
+s,@build_os@,$build_os,;t t
+s,@host@,$host,;t t
+s,@host_cpu@,$host_cpu,;t t
+s,@host_vendor@,$host_vendor,;t t
+s,@host_os@,$host_os,;t t
+s,@target@,$target,;t t
+s,@target_cpu@,$target_cpu,;t t
+s,@target_vendor@,$target_vendor,;t t
+s,@target_os@,$target_os,;t t
+s,@AWK@,$AWK,;t t
+s,@INSTALL_PROGRAM@,$INSTALL_PROGRAM,;t t
+s,@INSTALL_SCRIPT@,$INSTALL_SCRIPT,;t t
+s,@INSTALL_DATA@,$INSTALL_DATA,;t t
+s,@LN_S@,$LN_S,;t t
+s,@SET_MAKE@,$SET_MAKE,;t t
+s,@RANLIB@,$RANLIB,;t t
+s,@ac_ct_RANLIB@,$ac_ct_RANLIB,;t t
+s,@KLCC@,$KLCC,;t t
+s,@KLIBC@,$KLIBC,;t t
+s,@KLIBC_PREFIX@,$KLIBC_PREFIX,;t t
+s,@KLIBC_BIN_DIR@,$KLIBC_BIN_DIR,;t t
+s,@KLIBC_SBIN_DIR@,$KLIBC_SBIN_DIR,;t t
+s,@KLIBC_LIB_DIR@,$KLIBC_LIB_DIR,;t t
+s,@KLIBC_INCLUDE_DIR@,$KLIBC_INCLUDE_DIR,;t t
+s,@CC@,$CC,;t t
+s,@CFLAGS@,$CFLAGS,;t t
+s,@LDFLAGS@,$LDFLAGS,;t t
+s,@CPPFLAGS@,$CPPFLAGS,;t t
+s,@ac_ct_CC@,$ac_ct_CC,;t t
+s,@EXEEXT@,$EXEEXT,;t t
+s,@OBJEXT@,$OBJEXT,;t t
+s,@CPP@,$CPP,;t t
+s,@EGREP@,$EGREP,;t t
+s,@CLDFLAGS@,$CLDFLAGS,;t t
+s,@DEBUG@,$DEBUG,;t t
+s,@DEBUG_MALLOC@,$DEBUG_MALLOC,;t t
+s,@DMRAID_TEST@,$DMRAID_TEST,;t t
+s,@DMRAID_VERSION@,$DMRAID_VERSION,;t t
+s,@DMRAID_LIB_VERSION@,$DMRAID_LIB_VERSION,;t t
+s,@DIETLIBC@,$DIETLIBC,;t t
+s,@GROUP@,$GROUP,;t t
+s,@JOBS@,$JOBS,;t t
+s,@LD_DEPS@,$LD_DEPS,;t t
+s,@FLAVOUR@,$FLAVOUR,;t t
+s,@LIBSELINUX@,$LIBSELINUX,;t t
+s,@LIBSEPOL@,$LIBSEPOL,;t t
+s,@LIB_SO@,$LIB_SO,;t t
+s,@OWNER@,$OWNER,;t t
+s,@SOFLAG@,$SOFLAG,;t t
+s,@STATIC_LINK@,$STATIC_LINK,;t t
+s,@LIBOBJS@,$LIBOBJS,;t t
+s,@LTLIBOBJS@,$LTLIBOBJS,;t t
+CEOF
+
+_ACEOF
+
+  cat >>$CONFIG_STATUS <<\_ACEOF
+  # Split the substitutions into bite-sized pieces for seds with
+  # small command number limits, like on Digital OSF/1 and HP-UX.
+  ac_max_sed_lines=48
+  ac_sed_frag=1 # Number of current file.
+  ac_beg=1 # First line for current file.
+  ac_end=$ac_max_sed_lines # Line after last line for current file.
+  ac_more_lines=:
+  ac_sed_cmds=
+  while $ac_more_lines; do
+    if test $ac_beg -gt 1; then
+      sed "1,${ac_beg}d; ${ac_end}q" $tmp/subs.sed >$tmp/subs.frag
+    else
+      sed "${ac_end}q" $tmp/subs.sed >$tmp/subs.frag
+    fi
+    if test ! -s $tmp/subs.frag; then
+      ac_more_lines=false
+    else
+      # The purpose of the label and of the branching condition is to
+      # speed up the sed processing (if there are no `@' at all, there
+      # is no need to browse any of the substitutions).
+      # These are the two extra sed commands mentioned above.
+      (echo ':t
+  /@[a-zA-Z_][a-zA-Z_0-9]*@/!b' && cat $tmp/subs.frag) >$tmp/subs-$ac_sed_frag.sed
+      if test -z "$ac_sed_cmds"; then
+	ac_sed_cmds="sed -f $tmp/subs-$ac_sed_frag.sed"
+      else
+	ac_sed_cmds="$ac_sed_cmds | sed -f $tmp/subs-$ac_sed_frag.sed"
+      fi
+      ac_sed_frag=`expr $ac_sed_frag + 1`
+      ac_beg=$ac_end
+      ac_end=`expr $ac_end + $ac_max_sed_lines`
+    fi
+  done
+  if test -z "$ac_sed_cmds"; then
+    ac_sed_cmds=cat
+  fi
+fi # test -n "$CONFIG_FILES"
+
+_ACEOF
+cat >>$CONFIG_STATUS <<\_ACEOF
+for ac_file in : $CONFIG_FILES; do test "x$ac_file" = x: && continue
+  # Support "outfile[:infile[:infile...]]", defaulting infile="outfile.in".
+  case $ac_file in
+  - | *:- | *:-:* ) # input from stdin
+	cat >$tmp/stdin
+	ac_file_in=`echo "$ac_file" | sed 's,[^:]*:,,'`
+	ac_file=`echo "$ac_file" | sed 's,:.*,,'` ;;
+  *:* ) ac_file_in=`echo "$ac_file" | sed 's,[^:]*:,,'`
+	ac_file=`echo "$ac_file" | sed 's,:.*,,'` ;;
+  * )   ac_file_in=$ac_file.in ;;
+  esac
+
+  # Compute @srcdir@, @top_srcdir@, and @INSTALL@ for subdirectories.
+  ac_dir=`(dirname "$ac_file") 2>/dev/null ||
+$as_expr X"$ac_file" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
+	 X"$ac_file" : 'X\(//\)[^/]' \| \
+	 X"$ac_file" : 'X\(//\)$' \| \
+	 X"$ac_file" : 'X\(/\)' \| \
+	 .     : '\(.\)' 2>/dev/null ||
+echo X"$ac_file" |
+    sed '/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{ s//\1/; q; }
+  	  /^X\(\/\/\)[^/].*/{ s//\1/; q; }
+  	  /^X\(\/\/\)$/{ s//\1/; q; }
+  	  /^X\(\/\).*/{ s//\1/; q; }
+  	  s/.*/./; q'`
+  { if $as_mkdir_p; then
+    mkdir -p "$ac_dir"
+  else
+    as_dir="$ac_dir"
+    as_dirs=
+    while test ! -d "$as_dir"; do
+      as_dirs="$as_dir $as_dirs"
+      as_dir=`(dirname "$as_dir") 2>/dev/null ||
+$as_expr X"$as_dir" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
+	 X"$as_dir" : 'X\(//\)[^/]' \| \
+	 X"$as_dir" : 'X\(//\)$' \| \
+	 X"$as_dir" : 'X\(/\)' \| \
+	 .     : '\(.\)' 2>/dev/null ||
+echo X"$as_dir" |
+    sed '/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{ s//\1/; q; }
+  	  /^X\(\/\/\)[^/].*/{ s//\1/; q; }
+  	  /^X\(\/\/\)$/{ s//\1/; q; }
+  	  /^X\(\/\).*/{ s//\1/; q; }
+  	  s/.*/./; q'`
+    done
+    test ! -n "$as_dirs" || mkdir $as_dirs
+  fi || { { echo "$as_me:$LINENO: error: cannot create directory \"$ac_dir\"" >&5
+echo "$as_me: error: cannot create directory \"$ac_dir\"" >&2;}
+   { (exit 1); exit 1; }; }; }
+
+  ac_builddir=.
+
+if test "$ac_dir" != .; then
+  ac_dir_suffix=/`echo "$ac_dir" | sed 's,^\.[\\/],,'`
+  # A "../" for each directory in $ac_dir_suffix.
+  ac_top_builddir=`echo "$ac_dir_suffix" | sed 's,/[^\\/]*,../,g'`
+else
+  ac_dir_suffix= ac_top_builddir=
+fi
+
+case $srcdir in
+  .)  # No --srcdir option.  We are building in place.
+    ac_srcdir=.
+    if test -z "$ac_top_builddir"; then
+       ac_top_srcdir=.
+    else
+       ac_top_srcdir=`echo $ac_top_builddir | sed 's,/$,,'`
+    fi ;;
+  [\\/]* | ?:[\\/]* )  # Absolute path.
+    ac_srcdir=$srcdir$ac_dir_suffix;
+    ac_top_srcdir=$srcdir ;;
+  *) # Relative path.
+    ac_srcdir=$ac_top_builddir$srcdir$ac_dir_suffix
+    ac_top_srcdir=$ac_top_builddir$srcdir ;;
+esac
+
+# Do not use `cd foo && pwd` to compute absolute paths, because
+# the directories may not exist.
+case `pwd` in
+.) ac_abs_builddir="$ac_dir";;
+*)
+  case "$ac_dir" in
+  .) ac_abs_builddir=`pwd`;;
+  [\\/]* | ?:[\\/]* ) ac_abs_builddir="$ac_dir";;
+  *) ac_abs_builddir=`pwd`/"$ac_dir";;
+  esac;;
+esac
+case $ac_abs_builddir in
+.) ac_abs_top_builddir=${ac_top_builddir}.;;
+*)
+  case ${ac_top_builddir}. in
+  .) ac_abs_top_builddir=$ac_abs_builddir;;
+  [\\/]* | ?:[\\/]* ) ac_abs_top_builddir=${ac_top_builddir}.;;
+  *) ac_abs_top_builddir=$ac_abs_builddir/${ac_top_builddir}.;;
+  esac;;
+esac
+case $ac_abs_builddir in
+.) ac_abs_srcdir=$ac_srcdir;;
+*)
+  case $ac_srcdir in
+  .) ac_abs_srcdir=$ac_abs_builddir;;
+  [\\/]* | ?:[\\/]* ) ac_abs_srcdir=$ac_srcdir;;
+  *) ac_abs_srcdir=$ac_abs_builddir/$ac_srcdir;;
+  esac;;
+esac
+case $ac_abs_builddir in
+.) ac_abs_top_srcdir=$ac_top_srcdir;;
+*)
+  case $ac_top_srcdir in
+  .) ac_abs_top_srcdir=$ac_abs_builddir;;
+  [\\/]* | ?:[\\/]* ) ac_abs_top_srcdir=$ac_top_srcdir;;
+  *) ac_abs_top_srcdir=$ac_abs_builddir/$ac_top_srcdir;;
+  esac;;
+esac
+
+
+  case $INSTALL in
+  [\\/$]* | ?:[\\/]* ) ac_INSTALL=$INSTALL ;;
+  *) ac_INSTALL=$ac_top_builddir$INSTALL ;;
+  esac
+
+  if test x"$ac_file" != x-; then
+    { echo "$as_me:$LINENO: creating $ac_file" >&5
+echo "$as_me: creating $ac_file" >&6;}
+    rm -f "$ac_file"
+  fi
+  # Let's still pretend it is `configure' which instantiates (i.e., don't
+  # use $as_me), people would be surprised to read:
+  #    /* config.h.  Generated by config.status.  */
+  if test x"$ac_file" = x-; then
+    configure_input=
+  else
+    configure_input="$ac_file.  "
+  fi
+  configure_input=$configure_input"Generated from `echo $ac_file_in |
+				     sed 's,.*/,,'` by configure."
+
+  # First look for the input files in the build tree, otherwise in the
+  # src tree.
+  ac_file_inputs=`IFS=:
+    for f in $ac_file_in; do
+      case $f in
+      -) echo $tmp/stdin ;;
+      [\\/$]*)
+	 # Absolute (can't be DOS-style, as IFS=:)
+	 test -f "$f" || { { echo "$as_me:$LINENO: error: cannot find input file: $f" >&5
+echo "$as_me: error: cannot find input file: $f" >&2;}
+   { (exit 1); exit 1; }; }
+	 echo "$f";;
+      *) # Relative
+	 if test -f "$f"; then
+	   # Build tree
+	   echo "$f"
+	 elif test -f "$srcdir/$f"; then
+	   # Source tree
+	   echo "$srcdir/$f"
+	 else
+	   # /dev/null tree
+	   { { echo "$as_me:$LINENO: error: cannot find input file: $f" >&5
+echo "$as_me: error: cannot find input file: $f" >&2;}
+   { (exit 1); exit 1; }; }
+	 fi;;
+      esac
+    done` || { (exit 1); exit 1; }
+_ACEOF
+cat >>$CONFIG_STATUS <<_ACEOF
+  sed "$ac_vpsub
+$extrasub
+_ACEOF
+cat >>$CONFIG_STATUS <<\_ACEOF
+:t
+/@[a-zA-Z_][a-zA-Z_0-9]*@/!b
+s,@configure_input@,$configure_input,;t t
+s,@srcdir@,$ac_srcdir,;t t
+s,@abs_srcdir@,$ac_abs_srcdir,;t t
+s,@top_srcdir@,$ac_top_srcdir,;t t
+s,@abs_top_srcdir@,$ac_abs_top_srcdir,;t t
+s,@builddir@,$ac_builddir,;t t
+s,@abs_builddir@,$ac_abs_builddir,;t t
+s,@top_builddir@,$ac_top_builddir,;t t
+s,@abs_top_builddir@,$ac_abs_top_builddir,;t t
+s,@INSTALL@,$ac_INSTALL,;t t
+" $ac_file_inputs | (eval "$ac_sed_cmds") >$tmp/out
+  rm -f $tmp/stdin
+  if test x"$ac_file" != x-; then
+    mv $tmp/out $ac_file
+  else
+    cat $tmp/out
+    rm -f $tmp/out
+  fi
+
+done
+_ACEOF
+
+cat >>$CONFIG_STATUS <<\_ACEOF
+
+{ (exit 0); exit 0; }
+_ACEOF
+chmod +x $CONFIG_STATUS
+ac_clean_files=$ac_clean_files_save
+
+
+# configure is writing to config.log, and then calls config.status.
+# config.status does its own redirection, appending to config.log.
+# Unfortunately, on DOS this fails, as config.log is still kept open
+# by configure, so config.status won't be able to write to it; its
+# output is simply discarded.  So we exec the FD to /dev/null,
+# effectively closing config.log, so it can be properly (re)opened and
+# appended to by config.status.  When coming back to configure, we
+# need to make the FD available again.
+if test "$no_create" != yes; then
+  ac_cs_success=:
+  ac_config_status_args=
+  test "$silent" = yes &&
+    ac_config_status_args="$ac_config_status_args --quiet"
+  exec 5>/dev/null
+  $SHELL $CONFIG_STATUS $ac_config_status_args || ac_cs_success=false
+  exec 5>>config.log
+  # Use ||, not &&, to avoid exiting from the if with $? = 1, which
+  # would make configure fail if this is the last instruction.
+  $ac_cs_success || { (exit 1); exit 1; }
+fi
+
/cvs/dm/dmraid/configure.in,v  -->  standard output
revision 1.1
--- dmraid/configure.in
+++ -	2008-02-22 16:50:39.664893000 +0000
@@ -0,0 +1,244 @@
+#
+# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+# configure.in for dmraid
+
+dnl Process this file with autoconf to produce a configure script.
+AC_INIT(lib/device/dev-io.h)
+
+dnl setup the directory where autoconf has auxilary files
+AC_CONFIG_AUX_DIR(autoconf) 
+
+dnl Get system type
+AC_CANONICAL_SYSTEM
+
+dnl Checks for programs.
+AC_PROG_AWK
+AC_PROG_INSTALL
+AC_PROG_LN_S
+AC_PROG_MAKE_SET
+AC_PROG_RANLIB
+
+dnl Enables linking to klibc
+dnl We need to do this before header checks, as we need to set CC
+AC_CHECK_KLIBC
+
+dnl Checks for CC
+dnl This should be done after klibc check, as CC is changed
+AC_PROG_CC
+
+dnl Checks for header files.
+AC_HEADER_DIRENT
+AC_HEADER_STDC
+AC_CHECK_HEADERS(fcntl.h sys/ioctl.h unistd.h)
+if test x$KLIBC != xyes; then
+	AC_CHECK_HEADERS(malloc.h)
+fi
+
+dnl Checks for typedefs, structures, and compiler characteristics.
+AC_C_CONST
+AC_C_INLINE
+AC_TYPE_OFF_T
+AC_TYPE_PID_T
+AC_TYPE_SIZE_T
+AC_STRUCT_ST_RDEV
+AC_HEADER_TIME
+
+dnl Set system type flags
+dnl We do not want this with klibc
+if test x$KLIBC != xyes; then
+	case "$host_os" in
+		linux*)
+			CFLAGS=-O2
+			CLDFLAGS="-Wl,--version-script,.export.sym"
+			LD_DEPS=".export.sym"
+			SOFLAG="-shared" ;;
+	esac
+fi
+
+dnl -- prefix is /usr by default, the exec_prefix default is setup later
+AC_PREFIX_DEFAULT(/usr)
+
+dnl -- setup the ownership of the files
+AC_ARG_WITH(user,
+  [  --with-user=USER        Set the owner of installed files ],
+  [ OWNER="$withval" ],
+  [ OWNER="root" ])
+
+dnl -- setup the group ownership of the files
+AC_ARG_WITH(group,
+  [  --with-group=GROUP      Set the group owner of installed files ],
+  [ GROUP="$withval" ],
+  [ GROUP="root" ])
+
+echo $ac_n "checking whether to enable debugging""... $ac_c" 1>&6
+dnl Enable Debugging
+AC_ARG_ENABLE(debug, [  --enable-debug          Enable debugging],  \
+DEBUG=yes, DEBUG=no)
+echo "$ac_t""$DEBUG" 1>&6
+
+echo $ac_n "checking whether to enable malloc debugging""... $ac_c" 1>&6
+dnl Enable malloc debugging
+AC_ARG_ENABLE(debug_malloc, [  --enable-debug_malloc   Enable malloc debugging],  \
+DEBUG_MALLOC=yes, DEBUG_MALLOC=no)
+echo "$ac_t""$DEBUG" 1>&6
+
+dnl Enables linking to dietlibc
+AC_ARG_ENABLE(dietlibc, [  --enable-dietlibc       Use this to link the tools to dietlibc ], DIETLIBC=yes, DIETLIBC=no)
+
+if test x$DIETLIBC = xyes; then
+	if test x$KLIBC = xyes; then
+		AC_MSG_ERROR(You can' enable both dietlibc and klibc!)
+		exit 1
+	fi
+        CC="diet gcc"
+	FLAVOUR="dietlibc "
+fi
+
+AC_ARG_ENABLE(jobs,  [  --enable-jobs=NUM       Number of jobs to run simultaneously], JOBS=-j$enableval, JOBS=-j1)
+
+dnl Enables linking to libselinux
+AC_ARG_ENABLE(libselinux, [  --enable-libselinux     Use this to link the tools to libselinux ], LIBSELINUX=$enableval, LIBSELINUX=no)
+
+dnl Enables linking to libselinux
+AC_ARG_ENABLE(libsepol, [  --enable-libsepol       Use this to link the tools to libsepol ], LIBSEPOL=$enableval, LIBSEPOL=no)
+
+dnl Enables mini binary
+AC_ARG_ENABLE(mini, [  --enable-mini           Use this to create a minimal binrary suitable
+                          for early boot environments],  DMRAID_MINI=$enableval, DMRAID_MINI=no)
+
+echo $ac_n "checking whether to disable native metadata logging""... $ac_c" 1>&6
+dnl Disable native metadata logging
+AC_ARG_ENABLE(native_log, [  --disable-native_log    Disable native metadata logging. Default is enabled],  \
+DMRAID_NATIVE_LOG=$enableval, DMRAID_NATIVE_LOG=yes)
+echo "$ac_t""$DMRAID_NATIVE_LOG" 1>&6
+
+dnl Enables staticly linked tools
+AC_ARG_ENABLE(static_link, [  --enable-static_link    Use this to link the tools to the dmraid and devmapper
+                          libraries statically.  Default is dynamic linking],  STATIC_LINK=$enableval, STATIC_LINK=no)
+
+dnl Enables shared libdmraid
+AC_ARG_ENABLE(shared_lib,
+                           [  --enable-shared_lib     Use this to generate shared libdmraid and link the
+                          tools to it. Default is static libdmraid],  LIB_SO=$enableval, LIB_SO=no)
+
+echo $ac_n "checking whether to disable testing with mapped devices""... $ac_c" 1>&6
+dnl Disable testing with mapped devices
+AC_ARG_ENABLE(testing, [  --disable-testing       Disable testing with mapped devices],  \
+DMRAID_TEST=no, DMRAID_TEST=yes)
+
+echo "$ac_t""$DEBUG" 1>&6
+
+if test x$LIB_SO = xyes; then
+	FLAVOUR="shared "
+fi
+
+if test x$STATIC_LINK = xyes; then
+	FLAVOUR="static "
+	if test x$LIB_SO = xyes; then
+		AC_MSG_ERROR(You can' enable both shared_lib and static_link!)
+		exit 1
+	fi
+fi
+
+if test x$DMRAID_MINI = xyes; then
+        CFLAGS="$CFLAGS -DDMRAID_MINI"
+	FLAVOUR="${FLAVOUR}mini "
+else
+	if test x$DMRAID_NATIVE_LOG = xno; then
+		FLAVOUR="${FLAVOUR}no_native_log "
+	else
+        	CFLAGS="$CFLAGS -DDMRAID_NATIVE_LOG"
+	fi
+fi
+
+if test x$DEBUG = xyes; then
+	FLAVOUR="${FLAVOUR}debug "
+fi
+
+if test x$DEBUG_MALLOC = xyes; then
+	FLAVOUR="${FLAVOUR}debug_malloc "
+fi
+
+dnl Mess with default exec_prefix
+if [[ "x$exec_prefix" = xNONE -a "x$prefix" = xNONE ]];
+ then  exec_prefix="";
+fi;
+
+dnl Checks for library functions.
+AC_PROG_GCC_TRADITIONAL
+AC_TYPE_SIGNAL
+AC_FUNC_VPRINTF
+AC_CHECK_FUNCS(mkdir rmdir uname)
+
+dnl check for termcap (Shamelessly copied from parted 1.4.17)
+if test x$READLINE = xyes; then
+	AC_SEARCH_LIBS(tgetent, ncurses curses termcap termlib, ,
+		AC_MSG_ERROR(
+termcap could not be found which is required for the
+--enable-readline option (which is enabled by default).  Either disable readline
+support with --disable-readline or download and install termcap from:
+	ftp.gnu.org/gnu/termcap
+Note: if you are using precompiled packages you will also need the development
+  package as well (which may be called termcap-devel or something similar).
+Note: (n)curses also seems to work as a substitute for termcap.  This was
+  not found either - but you could try installing that as well.
+)
+	exit
+	)
+fi
+
+dnl Klibc do not currently support getopt_long, but the test passes anyhow as
+dnl it calls gcc -E without considering CFLAGS ...
+if test x$KLIBC != xyes; then
+	dnl Check for getopt
+	AC_CHECK_HEADERS(getopt.h, CFLAGS="$CFLAGS -DHAVE_GETOPTLONG")
+fi
+
+if test "-f tools/VERSION"; then
+  DMRAID_VERSION="`cat tools/VERSION`"
+else
+  DMRAID_VERSION="Unknown"
+fi
+
+if test "-f lib/version.h"; then
+  DMRAID_LIB_VERSION="`sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[[^_]].*"\(.*\)"/\2/p' lib/version.h`"
+else
+  DMRAID_LIB_VERSION="Unknown"
+fi
+
+AC_SUBST(CC)
+AC_SUBST(CFLAGS)
+AC_SUBST(CLDFLAGS)
+AC_SUBST(DEBUG)
+AC_SUBST(DEBUG_MALLOC)
+AC_SUBST(DMRAID_TEST)
+AC_SUBST(DMRAID_VERSION)
+AC_SUBST(DMRAID_LIB_VERSION)
+AC_SUBST(DIETLIBC)
+AC_SUBST(GROUP)
+AC_SUBST(JOBS)
+AC_SUBST(LD_DEPS)
+AC_SUBST(FLAVOUR)
+AC_SUBST(LIBS)
+AC_SUBST(LIBSELINUX)
+AC_SUBST(LIBSEPOL)
+AC_SUBST(LIB_SO)
+AC_SUBST(OWNER)
+AC_SUBST(SOFLAG)
+AC_SUBST(STATIC_LINK)
+
+dnl First and last lines should not contain files to generate in order to 
+dnl keep utility scripts running properly
+AC_OUTPUT( 								\
+include/Makefile						 	\
+lib/Makefile							 	\
+man/Makefile								\
+tools/Makefile								\
+tools/version.h								\
+Makefile								\
+make.tmpl                                                               \
+)
/cvs/dm/dmraid/dmraid.spec,v  -->  standard output
revision 1.1
--- dmraid/dmraid.spec
+++ -	2008-02-22 16:50:39.744535000 +0000
@@ -0,0 +1,181 @@
+#
+# Copyright (C)  Heinz Mauelshagen, 2004-2006 Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+Summary: dmraid (Device-mapper RAID tool and library)
+Name: dmraid
+Version: 1.0.0.rc11
+Release: 1
+License: GPL
+Group: System Environment/Base
+URL: http://people.redhat.com/heinzm/sw/dmraid
+BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
+Source: ftp://people.redhat.com/heinzm/sw/dmraid/src/dmraid-%{version}.tar.bz2
+
+ExcludeArch:	s390
+ExcludeArch:	s390x
+
+%define dmraid_build_dso 0
+
+%description
+DMRAID supports RAID device discovery, RAID set activation and display of
+properties for ATARAID on Linux >= 2.4 using device-mapper.
+
+%package -n dmraid-devel
+Summary: Development libraries and headers for dmraid.
+Group: Development/Libraries
+
+%description -n dmraid-devel
+dmraid-devel provides a library interface for RAID device discovery,
+RAID set activation and display of properties for ATARAID volumes.
+
+%prep
+%setup -q -n dmraid/%{version}
+
+%build
+%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-static_link
+make DESTDIR=$RPM_BUILD_ROOT
+mv tools/dmraid tools/dmraid.static
+make clean
+%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --disable-static_link
+%if "%{dmraid_build_dso}" == "1"
+(cd lib ; make DESTDIR=$RPM_BUILD_ROOT libdmraid.so)
+make DESTDIR=$RPM_BUILD_ROOT
+%else
+make DESTDIR=$RPM_BUILD_ROOT
+%endif
+
+%install
+rm -rf $RPM_BUILD_ROOT
+install -m 755 -d $RPM_BUILD_ROOT{%{_libdir},/sbin,%{_sbindir},%{_bindir},%{_libdir},%{_includedir}/dmraid/,/var/lock/dmraid}
+make DESTDIR=$RPM_BUILD_ROOT install
+install -m 755 tools/dmraid.static $RPM_BUILD_ROOT/sbin/dmraid.static
+install -m 644 include/dmraid/*.h $RPM_BUILD_ROOT%{_includedir}/dmraid/
+
+# install the static library
+install -m 755 lib/libdmraid.a $RPM_BUILD_ROOT%{_libdir}
+
+# if requested, install the dso
+%if "%{dmraid_build_dso}" == "1"
+install -m 755 lib/libdmraid.so \
+	$RPM_BUILD_ROOT%{_libdir}/libdmraid.so.%{version}
+(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid.so.%{version} libdmraid.so)
+%endif
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+%files
+%defattr(-,root,root)
+%doc CHANGELOG CREDITS KNOWN_BUGS LICENSE LICENSE_GPL LICENSE_LGPL README TODO doc/dmraid_design.txt
+/%{_mandir}/man8/*
+/sbin/*
+%if "%{dmraid_build_dso}" == "1"
+%{_libdir}/libdmraid.so.*
+%endif
+
+%files -n dmraid-devel
+%defattr(-,root,root)
+%dir %{_includedir}/dmraid
+%{_includedir}/dmraid/*
+%{_libdir}/libdmraid.a
+
+%if "%{dmraid_build_dso}" == "1"
+%{_libdir}/libdmraid.so
+%endif
+
+%changelog
+* Fri Feb 17 2006 Heinz Mauelshagen <jheinzm@redhat.com> - 1.0.0.rc9-FC5_5.3
+- add doc/dmraid_design.txt to %doc (#181885)
+- add --enable-libselinux to configure
+- not build yet
+
+* Fri Feb 10 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc9-FC5_5.2
+- bump again for double-long bug on ppc(64)
+
+* Tue Feb 07 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc9-FC5_5.1
+- rebuilt for new gcc4.1 snapshot and glibc changes
+
+* Sun Jan 22 2006 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_5
+- Add selinux build deps
+- Don't set owner during make install
+
+* Fri Dec  9 2005 Jesse Keating <jkeating@redhat.com> 1.0.0.rc9-FC5_4.1
+- rebuilt
+
+* Sun Dec  3 2005 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_4
+- rebuild for device-mapper-1.02.02-2
+
+* Fri Dec  2 2005 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_3
+- rebuild for device-mapper-1.02.02-1
+
+* Thu Nov 10 2005 Peter Jones <pjones@redhat.com> 1.0.0.rc9-FC5_2
+- update to 1.0.0.rc9
+- make "make install" do the right thing with the DSO
+- eliminate duplicate definitions in the headers
+- export more symbols in the DSO
+- add api calls to retrieve dm tables
+- fix DESTDIR for 'make install' 
+- add api calls to identify degraded devices
+- remove several arch excludes
+
+* Sat Oct 15 2005 Florian La Roche <laroche@redhat.com>
+- add -lselinux -lsepol for new device-mapper deps
+
+* Fri May 20 2005 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc8-FC4_2
+- specfile change to build static and dynamic binray into one package
+- rebuilt
+
+* Thu May 19 2005 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc8-FC4_1
+- nv.c: fixed stripe size
+- sil.c: avoid incarnation_no in name creation, because the Windows
+         driver changes it every time
+- added --ignorelocking option to avoid taking out locks in early boot
+  where no read/write access to /var is given
+
+* Wed Mar 16 2005 Elliot Lee <sopwith@redhat.com>
+- rebuilt
+
+* Tue Mar 15 2005 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc6.1-4_FC4
+- VIA metadata format handler
+- added RAID10 to lsi metadata format handler
+- "dmraid -rD": file device size into {devicename}_{formatname}.size
+- "dmraid -tay": pretty print multi-line tables ala "dmsetup table"
+- "dmraid -l": display supported RAID levels + manual update
+- _sil_read() used LOG_NOTICE rather than LOG_INFO in order to
+  avoid messages about valid metadata areas being displayed
+  during "dmraid -vay".
+- isw, sil filed metadata offset on "-r -D" in sectors rather than in bytes.
+- isw needed dev_sort() to sort RAID devices in sets correctly.
+- pdc metadata format handler name creation. Lead to
+  wrong RAID set grouping logic in some configurations.
+- pdc RAID1 size calculation fixed (rc6.1)
+- dos.c: partition table code fixes by Paul Moore
+- _free_dev_pointers(): fixed potential OOB error
+- hpt37x_check: deal with raid_disks = 1 in mirror sets
+- pdc_check: status & 0x80 doesn't always show a failed device;
+  removed that check for now. Status definitions needed.
+- sil addition of RAID sets to global list of sets
+- sil spare device memory leak
+- group_set(): removal of RAID set in case of error
+- hpt37x: handle total_secs > device size
+- allow -p with -f
+- enhanced error message by checking target type against list of
+  registered target types
+
+* Fri Jan 21 2005 Alasdair Kergon <agk@redhat.com> 1.0.0.rc5f-2
+- Rebuild to pick up new libdevmapper.
+
+* Fri Nov 26 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0.rc5f
+- specfile cleanup
+
+* Tue Aug 20 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0-rc4-pre1
+- Removed make flag after fixing make.tmpl.in
+
+* Tue Aug 18 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0-rc3
+- Added make flag to prevent make 3.80 from looping infinitely
+
+* Thu Jun 17 2004 Heinz Mauelshagen <heinzm@redhat.com> 1.0.0-pre1
+- Created
/cvs/dm/dmraid/make.tmpl.in,v  -->  standard output
revision 1.1
--- dmraid/make.tmpl.in
+++ -	2008-02-22 16:50:39.825101000 +0000
@@ -0,0 +1,156 @@
+#
+# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+SHELL = /bin/sh
+
+@SET_MAKE@
+
+CC = @CC@
+RANLIB = @RANLIB@
+SHELL = /bin/sh
+INSTALL = @INSTALL@
+LN_S = @LN_S@
+LIBS = @LIBS@
+CFLAGS += @CFLAGS@
+CLDFLAGS += @CLDFLAGS@
+LDFLAGS += @LDFLAGS@
+LD_DEPS += @LD_DEPS@
+SOFLAG += @SOFLAG@
+
+# Setup directory variables
+prefix = $(DESTDIR)@prefix@
+exec_prefix = $(DESTDIR)@exec_prefix@
+bindir = @bindir@
+ifeq ("@KLIBC@", "no")
+  libdir = @libdir@
+  sbindir = @sbindir@
+  includedir = @includedir@
+  infodir = @infodir@
+  mandir = @mandir@
+else
+  libdir = $(DESTDIR)@KLIBC_LIB_DIR@
+  sbindir = $(DESTDIR)@KLIBC_SBIN_DIR@
+  includedir = $(DESTDIR)@KLIBC_INCLUDE_DIR@
+  infodir = @infodir@
+  mandir = @mandir@
+endif
+
+
+# setup misc variables
+# define the ownership variables for the binaries and man pages
+OWNER = @OWNER@
+GROUP = @GROUP@
+DMRAID_LIB_VERSION = @DMRAID_LIB_VERSION@
+
+# The number of jobs to run, if blank, defaults to the make standard
+ifndef MAKEFLAGS
+MAKEFLAGS = @JOBS@
+endif
+
+SUFFIXES=.c .o .so .a
+
+CFLAGS+=-fPIC -Wall -Wundef -Wcast-align -Wwrite-strings -Winline
+
+ifeq ("@KLIBC@", "yes")
+  # These ones make klibc compiles very loud
+  CFLAGS+=-Wshadow -Wmissing-prototypes -Wmissing-declarations -Wnested-externs
+endif
+
+ifeq ("@DMRAID_TEST@", "yes")
+  CFLAGS+=-DDMRAID_TEST
+endif
+
+ifeq ("@DEBUG@", "yes")
+  CFLAGS+=-g -fno-omit-frame-pointer -DDEBUG
+else
+  ifeq ("@KLIBC@", "no")
+    CFLAGS+=-O2
+  else
+    CFLAGS+=-Os
+  endif
+endif
+
+ifeq ("@DEBUG_MALLOC@", "yes")
+  CFLAGS+=-DDEBUG_MALLOC
+endif
+
+CFLAGS+=-D_LARGEFILE64_SOURCE
+
+INCLUDES+=-I. -I$(top_srcdir)/include -I$(top_srcdir)/lib
+
+STRIP=
+
+ifdef DESTDIR
+  INCLUDES+=-I$(DESTDIR)/usr/include
+endif
+
+DEPS=$(top_srcdir)/make.tmpl $(top_srcdir)/tools/VERSION Makefile
+
+OBJECTS=$(SOURCES:%.c=%.o)
+
+SUBDIRS.install := $(SUBDIRS:=.install)
+SUBDIRS.remove := $(SUBDIRS:=.remove)
+SUBDIRS.clean := $(SUBDIRS:=.clean)
+SUBDIRS.distclean := $(SUBDIRS:=.distclean)
+
+.PHONY: all install distclean clean
+.PHONY: $(SUBDIRS) $(SUBDIRS.install) $(SUBDIRS.clean) $(SUBDIRS.distclean)
+.PHONY: $(SUBDIRS.remove)
+
+all: $(SUBDIRS) $(TARGETS)
+
+install: all $(SUBDIRS.install)
+
+remove: $(SUBDIRS.remove)
+
+$(SUBDIRS):
+	$(MAKE) -C $@
+
+$(SUBDIRS.install): $(SUBDIRS)
+	$(MAKE) -C $(@:.install=) install
+
+$(SUBDIRS.remove): $(SUBDIRS)
+	$(MAKE) -C $(@:.remove=) remove
+
+$(SUBDIRS.clean):
+	-$(MAKE) -C $(@:.clean=) clean
+
+$(SUBDIRS.distclean):
+	-$(MAKE) -C $(@:.distclean=) distclean
+
+$(TARGETS): $(OBJECTS)
+
+%.o: %.c
+	$(CC) -MM -MF ${@:%.o=%.d} $(INCLUDES) $(CFLAGS) $<; \
+	$(CC) -c $(INCLUDES) $(CFLAGS) $< -o $@
+
+%.so: $(OBJECTS) .export.sym
+
+%.so: $(OBJECTS)
+	$(CC) -shared -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) \
+	-Wl,--version-script,.export.sym $(OBJECTS) -o $@
+
+$(LIB_STATIC): $(OBJECTS)
+	$(RM) $@
+	$(AR) r $@ $(OBJECTS)
+	$(RANLIB) $@
+
+clean: $(SUBDIRS.clean)
+	$(RM) $(OBJECTS) $(TARGETS) $(CLEAN_TARGETS) $(SOURCES:%.c=%.d)
+
+distclean: $(SUBDIRS.distclean)
+	$(RM) $(OBJECTS) $(TARGETS) $(CLEAN_TARGETS) $(SOURCES:%.c=%.d) \
+	      cscope.out \
+	      config.cache config.log config.status \
+	      Makefile make.tmpl core tools/version.h
+
+ifneq ($(MAKECMDGOALS),clean)
+  ifneq ($(MAKECMDGOALS),distclean)
+    ifdef SOURCES
+       -include $(SOURCES:.c=.d)
+    endif
+  endif
+endif
