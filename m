From: heinzm@sourceware.org
Subject: dmraid autoconf/config.guess autoconf/config.s ...
Date: 22 Feb 2008 16:57:45 -0000
Message-ID: <20080222165745.26825.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2008-02-22 16:57:37

Added files:
	autoconf       : config.guess config.sub install-sh 
	doc            : dmraid_design.txt 
	include        : Makefile.in 
	include/dmraid : display.h dmraid.h format.h lib_context.h 
	                 list.h locking.h metadata.h misc.h 
	lib            : .export.sym Makefile.in internal.h version.h 
	lib/activate   : activate.c activate.h devmapper.c devmapper.h 
	lib/datastruct : byteorder.h 
	lib/device     : ata.c ata.h dev-io.h scan.c scsi.c scsi.h 
	lib/display    : display.c 
	lib/format     : README format.c ondisk.h register.h 
	lib/format/ataraid: README asr.c asr.h hpt37x.c hpt37x.h 
	                    hpt45x.c hpt45x.h isw.c isw.h jm.c jm.h 
	                    lsi.c lsi.h nv.c nv.h pdc.c pdc.h sil.c 
	                    sil.h via.c via.h 
	lib/format/partition: dos.c dos.h 
	lib/format/template: README template.c template.h 
	lib/locking    : locking.c 
	lib/log        : log.c log.h 
	lib/metadata   : metadata.c 
	lib/misc       : file.c init.c lib_context.c misc.c workaround.c 
	lib/mm         : dbg_malloc.c dbg_malloc.h 
	man            : Makefile.in dmraid.8 
	tools          : Makefile.in VERSION commands.c commands.h 
	                 dmraid.c toollib.c toollib.h version.h.in 

Log message:
	initial 1.0.0.rc11 checkin (missing files)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/autoconf/config.guess.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/autoconf/config.sub.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/autoconf/install-sh.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/doc/dmraid_design.txt.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/Makefile.in.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/display.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/dmraid.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/format.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/lib_context.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/list.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/locking.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/metadata.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/misc.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/.export.sym.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/internal.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/activate.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/devmapper.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/activate/devmapper.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/datastruct/byteorder.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/ata.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/ata.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/dev-io.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scan.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scsi.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scsi.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/display/display.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/README.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/format.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ondisk.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/register.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/README.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt37x.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt37x.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt45x.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt45x.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/nv.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/nv.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/via.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/via.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/partition/dos.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/partition/dos.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/template/README.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/template/template.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/template/template.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/locking/locking.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/log/log.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/log/log.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/file.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/init.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/lib_context.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/misc.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/workaround.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/mm/dbg_malloc.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/mm/dbg_malloc.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/Makefile.in.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/dmraid.8.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/dmraid.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/toollib.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/toollib.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/version.h.in.diff?cvsroot=dm&r1=NONE&r2=1.1

/cvs/dm/dmraid/autoconf/config.guess,v  -->  standard output
revision 1.1
--- dmraid/autoconf/config.guess
+++ -	2008-02-22 16:57:37.811092000 +0000
@@ -0,0 +1,1404 @@
+#! /bin/sh
+# Attempt to guess a canonical system name.
+#   Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
+#   2000, 2001, 2002, 2003 Free Software Foundation, Inc.
+
+timestamp='2003-06-17'
+
+# This file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# As a special exception to the GNU General Public License, if you
+# distribute this file as part of a program that contains a
+# configuration script generated by Autoconf, you may include it under
+# the same distribution terms that you use for the rest of that program.
+
+# Originally written by Per Bothner <per@bothner.com>.
+# Please send patches to <config-patches@gnu.org>.  Submit a context
+# diff and a properly formatted ChangeLog entry.
+#
+# This script attempts to guess a canonical system name similar to
+# config.sub.  If it succeeds, it prints the system name on stdout, and
+# exits with 0.  Otherwise, it exits with 1.
+#
+# The plan is that this can be called by configure scripts if you
+# don't specify an explicit build system type.
+
+me=`echo "$0" | sed -e 's,.*/,,'`
+
+usage="\
+Usage: $0 [OPTION]
+
+Output the configuration name of the system \`$me' is run on.
+
+Operation modes:
+  -h, --help         print this help, then exit
+  -t, --time-stamp   print date of last modification, then exit
+  -v, --version      print version number, then exit
+
+Report bugs and patches to <config-patches@gnu.org>."
+
+version="\
+GNU config.guess ($timestamp)
+
+Originally written by Per Bothner.
+Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001
+Free Software Foundation, Inc.
+
+This is free software; see the source for copying conditions.  There is NO
+warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
+
+help="
+Try \`$me --help' for more information."
+
+# Parse command line
+while test $# -gt 0 ; do
+  case $1 in
+    --time-stamp | --time* | -t )
+       echo "$timestamp" ; exit 0 ;;
+    --version | -v )
+       echo "$version" ; exit 0 ;;
+    --help | --h* | -h )
+       echo "$usage"; exit 0 ;;
+    -- )     # Stop option processing
+       shift; break ;;
+    - )	# Use stdin as input.
+       break ;;
+    -* )
+       echo "$me: invalid option $1$help" >&2
+       exit 1 ;;
+    * )
+       break ;;
+  esac
+done
+
+if test $# != 0; then
+  echo "$me: too many arguments$help" >&2
+  exit 1
+fi
+
+trap 'exit 1' 1 2 15
+
+# CC_FOR_BUILD -- compiler used by this script. Note that the use of a
+# compiler to aid in system detection is discouraged as it requires
+# temporary files to be created and, as you can see below, it is a
+# headache to deal with in a portable fashion.
+
+# Historically, `CC_FOR_BUILD' used to be named `HOST_CC'. We still
+# use `HOST_CC' if defined, but it is deprecated.
+
+# Portable tmp directory creation inspired by the Autoconf team.
+
+set_cc_for_build='
+trap "exitcode=\$?; (rm -f \$tmpfiles 2>/dev/null; rmdir \$tmp 2>/dev/null) && exit \$exitcode" 0 ;
+trap "rm -f \$tmpfiles 2>/dev/null; rmdir \$tmp 2>/dev/null; exit 1" 1 2 13 15 ;
+: ${TMPDIR=/tmp} ;
+ { tmp=`(umask 077 && mktemp -d -q "$TMPDIR/cgXXXXXX") 2>/dev/null` && test -n "$tmp" && test -d "$tmp" ; } ||
+ { test -n "$RANDOM" && tmp=$TMPDIR/cg$$-$RANDOM && (umask 077 && mkdir $tmp) ; } ||
+ { tmp=$TMPDIR/cg-$$ && (umask 077 && mkdir $tmp) && echo "Warning: creating insecure temp directory" >&2 ; } ||
+ { echo "$me: cannot create a temporary directory in $TMPDIR" >&2 ; exit 1 ; } ;
+dummy=$tmp/dummy ;
+tmpfiles="$dummy.c $dummy.o $dummy.rel $dummy" ;
+case $CC_FOR_BUILD,$HOST_CC,$CC in
+ ,,)    echo "int x;" > $dummy.c ;
+	for c in cc gcc c89 c99 ; do
+	  if ($c -c -o $dummy.o $dummy.c) >/dev/null 2>&1 ; then
+	     CC_FOR_BUILD="$c"; break ;
+	  fi ;
+	done ;
+	if test x"$CC_FOR_BUILD" = x ; then
+	  CC_FOR_BUILD=no_compiler_found ;
+	fi
+	;;
+ ,,*)   CC_FOR_BUILD=$CC ;;
+ ,*,*)  CC_FOR_BUILD=$HOST_CC ;;
+esac ;'
+
+# This is needed to find uname on a Pyramid OSx when run in the BSD universe.
+# (ghazi@noc.rutgers.edu 1994-08-24)
+if (test -f /.attbin/uname) >/dev/null 2>&1 ; then
+	PATH=$PATH:/.attbin ; export PATH
+fi
+
+UNAME_MACHINE=`(uname -m) 2>/dev/null` || UNAME_MACHINE=unknown
+UNAME_RELEASE=`(uname -r) 2>/dev/null` || UNAME_RELEASE=unknown
+UNAME_SYSTEM=`(uname -s) 2>/dev/null`  || UNAME_SYSTEM=unknown
+UNAME_VERSION=`(uname -v) 2>/dev/null` || UNAME_VERSION=unknown
+
+# Note: order is significant - the case branches are not exclusive.
+
+case "${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}:${UNAME_VERSION}" in
+    *:NetBSD:*:*)
+	# NetBSD (nbsd) targets should (where applicable) match one or
+	# more of the tupples: *-*-netbsdelf*, *-*-netbsdaout*,
+	# *-*-netbsdecoff* and *-*-netbsd*.  For targets that recently
+	# switched to ELF, *-*-netbsd* would select the old
+	# object file format.  This provides both forward
+	# compatibility and a consistent mechanism for selecting the
+	# object file format.
+	#
+	# Note: NetBSD doesn't particularly care about the vendor
+	# portion of the name.  We always set it to "unknown".
+	sysctl="sysctl -n hw.machine_arch"
+	UNAME_MACHINE_ARCH=`(/sbin/$sysctl 2>/dev/null || \
+	    /usr/sbin/$sysctl 2>/dev/null || echo unknown)`
+	case "${UNAME_MACHINE_ARCH}" in
+	    armeb) machine=armeb-unknown ;;
+	    arm*) machine=arm-unknown ;;
+	    sh3el) machine=shl-unknown ;;
+	    sh3eb) machine=sh-unknown ;;
+	    *) machine=${UNAME_MACHINE_ARCH}-unknown ;;
+	esac
+	# The Operating System including object format, if it has switched
+	# to ELF recently, or will in the future.
+	case "${UNAME_MACHINE_ARCH}" in
+	    arm*|i386|m68k|ns32k|sh3*|sparc|vax)
+		eval $set_cc_for_build
+		if echo __ELF__ | $CC_FOR_BUILD -E - 2>/dev/null \
+			| grep __ELF__ >/dev/null
+		then
+		    # Once all utilities can be ECOFF (netbsdecoff) or a.out (netbsdaout).
+		    # Return netbsd for either.  FIX?
+		    os=netbsd
+		else
+		    os=netbsdelf
+		fi
+		;;
+	    *)
+	        os=netbsd
+		;;
+	esac
+	# The OS release
+	# Debian GNU/NetBSD machines have a different userland, and
+	# thus, need a distinct triplet. However, they do not need
+	# kernel version information, so it can be replaced with a
+	# suitable tag, in the style of linux-gnu.
+	case "${UNAME_VERSION}" in
+	    Debian*)
+		release='-gnu'
+		;;
+	    *)
+		release=`echo ${UNAME_RELEASE}|sed -e 's/[-_].*/\./'`
+		;;
+	esac
+	# Since CPU_TYPE-MANUFACTURER-KERNEL-OPERATING_SYSTEM:
+	# contains redundant information, the shorter form:
+	# CPU_TYPE-MANUFACTURER-OPERATING_SYSTEM is used.
+	echo "${machine}-${os}${release}"
+	exit 0 ;;
+    amiga:OpenBSD:*:*)
+	echo m68k-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    arc:OpenBSD:*:*)
+	echo mipsel-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    hp300:OpenBSD:*:*)
+	echo m68k-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    mac68k:OpenBSD:*:*)
+	echo m68k-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    macppc:OpenBSD:*:*)
+	echo powerpc-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    mvme68k:OpenBSD:*:*)
+	echo m68k-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    mvme88k:OpenBSD:*:*)
+	echo m88k-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    mvmeppc:OpenBSD:*:*)
+	echo powerpc-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    pmax:OpenBSD:*:*)
+	echo mipsel-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    sgi:OpenBSD:*:*)
+	echo mipseb-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    sun3:OpenBSD:*:*)
+	echo m68k-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    wgrisc:OpenBSD:*:*)
+	echo mipsel-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    *:OpenBSD:*:*)
+	echo ${UNAME_MACHINE}-unknown-openbsd${UNAME_RELEASE}
+	exit 0 ;;
+    alpha:OSF1:*:*)
+	if test $UNAME_RELEASE = "V4.0"; then
+		UNAME_RELEASE=`/usr/sbin/sizer -v | awk '{print $3}'`
+	fi
+	# According to Compaq, /usr/sbin/psrinfo has been available on
+	# OSF/1 and Tru64 systems produced since 1995.  I hope that
+	# covers most systems running today.  This code pipes the CPU
+	# types through head -n 1, so we only detect the type of CPU 0.
+	ALPHA_CPU_TYPE=`/usr/sbin/psrinfo -v | sed -n -e 's/^  The alpha \(.*\) processor.*$/\1/p' | head -n 1`
+	case "$ALPHA_CPU_TYPE" in
+	    "EV4 (21064)")
+		UNAME_MACHINE="alpha" ;;
+	    "EV4.5 (21064)")
+		UNAME_MACHINE="alpha" ;;
+	    "LCA4 (21066/21068)")
+		UNAME_MACHINE="alpha" ;;
+	    "EV5 (21164)")
+		UNAME_MACHINE="alphaev5" ;;
+	    "EV5.6 (21164A)")
+		UNAME_MACHINE="alphaev56" ;;
+	    "EV5.6 (21164PC)")
+		UNAME_MACHINE="alphapca56" ;;
+	    "EV5.7 (21164PC)")
+		UNAME_MACHINE="alphapca57" ;;
+	    "EV6 (21264)")
+		UNAME_MACHINE="alphaev6" ;;
+	    "EV6.7 (21264A)")
+		UNAME_MACHINE="alphaev67" ;;
+	    "EV6.8CB (21264C)")
+		UNAME_MACHINE="alphaev68" ;;
+	    "EV6.8AL (21264B)")
+		UNAME_MACHINE="alphaev68" ;;
+	    "EV6.8CX (21264D)")
+		UNAME_MACHINE="alphaev68" ;;
+	    "EV6.9A (21264/EV69A)")
+		UNAME_MACHINE="alphaev69" ;;
+	    "EV7 (21364)")
+		UNAME_MACHINE="alphaev7" ;;
+	    "EV7.9 (21364A)")
+		UNAME_MACHINE="alphaev79" ;;
+	esac
+	# A Vn.n version is a released version.
+	# A Tn.n version is a released field test version.
+	# A Xn.n version is an unreleased experimental baselevel.
+	# 1.2 uses "1.2" for uname -r.
+	echo ${UNAME_MACHINE}-dec-osf`echo ${UNAME_RELEASE} | sed -e 's/^[VTX]//' | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'`
+	exit 0 ;;
+    Alpha*:OpenVMS:*:*)
+	echo alpha-hp-vms
+	exit 0 ;;
+    Alpha\ *:Windows_NT*:*)
+	# How do we know it's Interix rather than the generic POSIX subsystem?
+	# Should we change UNAME_MACHINE based on the output of uname instead
+	# of the specific Alpha model?
+	echo alpha-pc-interix
+	exit 0 ;;
+    21064:Windows_NT:50:3)
+	echo alpha-dec-winnt3.5
+	exit 0 ;;
+    Amiga*:UNIX_System_V:4.0:*)
+	echo m68k-unknown-sysv4
+	exit 0;;
+    *:[Aa]miga[Oo][Ss]:*:*)
+	echo ${UNAME_MACHINE}-unknown-amigaos
+	exit 0 ;;
+    *:[Mm]orph[Oo][Ss]:*:*)
+	echo ${UNAME_MACHINE}-unknown-morphos
+	exit 0 ;;
+    *:OS/390:*:*)
+	echo i370-ibm-openedition
+	exit 0 ;;
+    arm:RISC*:1.[012]*:*|arm:riscix:1.[012]*:*)
+	echo arm-acorn-riscix${UNAME_RELEASE}
+	exit 0;;
+    SR2?01:HI-UX/MPP:*:* | SR8000:HI-UX/MPP:*:*)
+	echo hppa1.1-hitachi-hiuxmpp
+	exit 0;;
+    Pyramid*:OSx*:*:* | MIS*:OSx*:*:* | MIS*:SMP_DC-OSx*:*:*)
+	# akee@wpdis03.wpafb.af.mil (Earle F. Ake) contributed MIS and NILE.
+	if test "`(/bin/universe) 2>/dev/null`" = att ; then
+		echo pyramid-pyramid-sysv3
+	else
+		echo pyramid-pyramid-bsd
+	fi
+	exit 0 ;;
+    NILE*:*:*:dcosx)
+	echo pyramid-pyramid-svr4
+	exit 0 ;;
+    DRS?6000:unix:4.0:6*)
+	echo sparc-icl-nx6
+	exit 0 ;;
+    DRS?6000:UNIX_SV:4.2*:7*)
+	case `/usr/bin/uname -p` in
+	    sparc) echo sparc-icl-nx7 && exit 0 ;;
+	esac ;;
+    sun4H:SunOS:5.*:*)
+	echo sparc-hal-solaris2`echo ${UNAME_RELEASE}|sed -e 's/[^.]*//'`
+	exit 0 ;;
+    sun4*:SunOS:5.*:* | tadpole*:SunOS:5.*:*)
+	echo sparc-sun-solaris2`echo ${UNAME_RELEASE}|sed -e 's/[^.]*//'`
+	exit 0 ;;
+    i86pc:SunOS:5.*:*)
+	echo i386-pc-solaris2`echo ${UNAME_RELEASE}|sed -e 's/[^.]*//'`
+	exit 0 ;;
+    sun4*:SunOS:6*:*)
+	# According to config.sub, this is the proper way to canonicalize
+	# SunOS6.  Hard to guess exactly what SunOS6 will be like, but
+	# it's likely to be more like Solaris than SunOS4.
+	echo sparc-sun-solaris3`echo ${UNAME_RELEASE}|sed -e 's/[^.]*//'`
+	exit 0 ;;
+    sun4*:SunOS:*:*)
+	case "`/usr/bin/arch -k`" in
+	    Series*|S4*)
+		UNAME_RELEASE=`uname -v`
+		;;
+	esac
+	# Japanese Language versions have a version number like `4.1.3-JL'.
+	echo sparc-sun-sunos`echo ${UNAME_RELEASE}|sed -e 's/-/_/'`
+	exit 0 ;;
+    sun3*:SunOS:*:*)
+	echo m68k-sun-sunos${UNAME_RELEASE}
+	exit 0 ;;
+    sun*:*:4.2BSD:*)
+	UNAME_RELEASE=`(sed 1q /etc/motd | awk '{print substr($5,1,3)}') 2>/dev/null`
+	test "x${UNAME_RELEASE}" = "x" && UNAME_RELEASE=3
+	case "`/bin/arch`" in
+	    sun3)
+		echo m68k-sun-sunos${UNAME_RELEASE}
+		;;
+	    sun4)
+		echo sparc-sun-sunos${UNAME_RELEASE}
+		;;
+	esac
+	exit 0 ;;
+    aushp:SunOS:*:*)
+	echo sparc-auspex-sunos${UNAME_RELEASE}
+	exit 0 ;;
+    # The situation for MiNT is a little confusing.  The machine name
+    # can be virtually everything (everything which is not
+    # "atarist" or "atariste" at least should have a processor
+    # > m68000).  The system name ranges from "MiNT" over "FreeMiNT"
+    # to the lowercase version "mint" (or "freemint").  Finally
+    # the system name "TOS" denotes a system which is actually not
+    # MiNT.  But MiNT is downward compatible to TOS, so this should
+    # be no problem.
+    atarist[e]:*MiNT:*:* | atarist[e]:*mint:*:* | atarist[e]:*TOS:*:*)
+        echo m68k-atari-mint${UNAME_RELEASE}
+	exit 0 ;;
+    atari*:*MiNT:*:* | atari*:*mint:*:* | atarist[e]:*TOS:*:*)
+	echo m68k-atari-mint${UNAME_RELEASE}
+        exit 0 ;;
+    *falcon*:*MiNT:*:* | *falcon*:*mint:*:* | *falcon*:*TOS:*:*)
+        echo m68k-atari-mint${UNAME_RELEASE}
+	exit 0 ;;
+    milan*:*MiNT:*:* | milan*:*mint:*:* | *milan*:*TOS:*:*)
+        echo m68k-milan-mint${UNAME_RELEASE}
+        exit 0 ;;
+    hades*:*MiNT:*:* | hades*:*mint:*:* | *hades*:*TOS:*:*)
+        echo m68k-hades-mint${UNAME_RELEASE}
+        exit 0 ;;
+    *:*MiNT:*:* | *:*mint:*:* | *:*TOS:*:*)
+        echo m68k-unknown-mint${UNAME_RELEASE}
+        exit 0 ;;
+    powerpc:machten:*:*)
+	echo powerpc-apple-machten${UNAME_RELEASE}
+	exit 0 ;;
+    RISC*:Mach:*:*)
+	echo mips-dec-mach_bsd4.3
+	exit 0 ;;
+    RISC*:ULTRIX:*:*)
+	echo mips-dec-ultrix${UNAME_RELEASE}
+	exit 0 ;;
+    VAX*:ULTRIX*:*:*)
+	echo vax-dec-ultrix${UNAME_RELEASE}
+	exit 0 ;;
+    2020:CLIX:*:* | 2430:CLIX:*:*)
+	echo clipper-intergraph-clix${UNAME_RELEASE}
+	exit 0 ;;
+    mips:*:*:UMIPS | mips:*:*:RISCos)
+	eval $set_cc_for_build
+	sed 's/^	//' << EOF >$dummy.c
+#ifdef __cplusplus
+#include <stdio.h>  /* for printf() prototype */
+	int main (int argc, char *argv[]) {
+#else
+	int main (argc, argv) int argc; char *argv[]; {
+#endif
+	#if defined (host_mips) && defined (MIPSEB)
+	#if defined (SYSTYPE_SYSV)
+	  printf ("mips-mips-riscos%ssysv\n", argv[1]); exit (0);
+	#endif
+	#if defined (SYSTYPE_SVR4)
+	  printf ("mips-mips-riscos%ssvr4\n", argv[1]); exit (0);
+	#endif
+	#if defined (SYSTYPE_BSD43) || defined(SYSTYPE_BSD)
+	  printf ("mips-mips-riscos%sbsd\n", argv[1]); exit (0);
+	#endif
+	#endif
+	  exit (-1);
+	}
+EOF
+	$CC_FOR_BUILD -o $dummy $dummy.c \
+	  && $dummy `echo "${UNAME_RELEASE}" | sed -n 's/\([0-9]*\).*/\1/p'` \
+	  && exit 0
+	echo mips-mips-riscos${UNAME_RELEASE}
+	exit 0 ;;
+    Motorola:PowerMAX_OS:*:*)
+	echo powerpc-motorola-powermax
+	exit 0 ;;
+    Motorola:*:4.3:PL8-*)
+	echo powerpc-harris-powermax
+	exit 0 ;;
+    Night_Hawk:*:*:PowerMAX_OS | Synergy:PowerMAX_OS:*:*)
+	echo powerpc-harris-powermax
+	exit 0 ;;
+    Night_Hawk:Power_UNIX:*:*)
+	echo powerpc-harris-powerunix
+	exit 0 ;;
+    m88k:CX/UX:7*:*)
+	echo m88k-harris-cxux7
+	exit 0 ;;
+    m88k:*:4*:R4*)
+	echo m88k-motorola-sysv4
+	exit 0 ;;
+    m88k:*:3*:R3*)
+	echo m88k-motorola-sysv3
+	exit 0 ;;
+    AViiON:dgux:*:*)
+        # DG/UX returns AViiON for all architectures
+        UNAME_PROCESSOR=`/usr/bin/uname -p`
+	if [ $UNAME_PROCESSOR = mc88100 ] || [ $UNAME_PROCESSOR = mc88110 ]
+	then
+	    if [ ${TARGET_BINARY_INTERFACE}x = m88kdguxelfx ] || \
+	       [ ${TARGET_BINARY_INTERFACE}x = x ]
+	    then
+		echo m88k-dg-dgux${UNAME_RELEASE}
+	    else
+		echo m88k-dg-dguxbcs${UNAME_RELEASE}
+	    fi
+	else
+	    echo i586-dg-dgux${UNAME_RELEASE}
+	fi
+ 	exit 0 ;;
+    M88*:DolphinOS:*:*)	# DolphinOS (SVR3)
+	echo m88k-dolphin-sysv3
+	exit 0 ;;
+    M88*:*:R3*:*)
+	# Delta 88k system running SVR3
+	echo m88k-motorola-sysv3
+	exit 0 ;;
+    XD88*:*:*:*) # Tektronix XD88 system running UTekV (SVR3)
+	echo m88k-tektronix-sysv3
+	exit 0 ;;
+    Tek43[0-9][0-9]:UTek:*:*) # Tektronix 4300 system running UTek (BSD)
+	echo m68k-tektronix-bsd
+	exit 0 ;;
+    *:IRIX*:*:*)
+	echo mips-sgi-irix`echo ${UNAME_RELEASE}|sed -e 's/-/_/g'`
+	exit 0 ;;
+    ????????:AIX?:[12].1:2)   # AIX 2.2.1 or AIX 2.1.1 is RT/PC AIX.
+	echo romp-ibm-aix      # uname -m gives an 8 hex-code CPU id
+	exit 0 ;;              # Note that: echo "'`uname -s`'" gives 'AIX '
+    i*86:AIX:*:*)
+	echo i386-ibm-aix
+	exit 0 ;;
+    ia64:AIX:*:*)
+	if [ -x /usr/bin/oslevel ] ; then
+		IBM_REV=`/usr/bin/oslevel`
+	else
+		IBM_REV=${UNAME_VERSION}.${UNAME_RELEASE}
+	fi
+	echo ${UNAME_MACHINE}-ibm-aix${IBM_REV}
+	exit 0 ;;
+    *:AIX:2:3)
+	if grep bos325 /usr/include/stdio.h >/dev/null 2>&1; then
+		eval $set_cc_for_build
+		sed 's/^		//' << EOF >$dummy.c
+		#include <sys/systemcfg.h>
+
+		main()
+			{
+			if (!__power_pc())
+				exit(1);
+			puts("powerpc-ibm-aix3.2.5");
+			exit(0);
+			}
+EOF
+		$CC_FOR_BUILD -o $dummy $dummy.c && $dummy && exit 0
+		echo rs6000-ibm-aix3.2.5
+	elif grep bos324 /usr/include/stdio.h >/dev/null 2>&1; then
+		echo rs6000-ibm-aix3.2.4
+	else
+		echo rs6000-ibm-aix3.2
+	fi
+	exit 0 ;;
+    *:AIX:*:[45])
+	IBM_CPU_ID=`/usr/sbin/lsdev -C -c processor -S available | sed 1q | awk '{ print $1 }'`
+	if /usr/sbin/lsattr -El ${IBM_CPU_ID} | grep ' POWER' >/dev/null 2>&1; then
+		IBM_ARCH=rs6000
+	else
+		IBM_ARCH=powerpc
+	fi
+	if [ -x /usr/bin/oslevel ] ; then
+		IBM_REV=`/usr/bin/oslevel`
+	else
+		IBM_REV=${UNAME_VERSION}.${UNAME_RELEASE}
+	fi
+	echo ${IBM_ARCH}-ibm-aix${IBM_REV}
+	exit 0 ;;
+    *:AIX:*:*)
+	echo rs6000-ibm-aix
+	exit 0 ;;
+    ibmrt:4.4BSD:*|romp-ibm:BSD:*)
+	echo romp-ibm-bsd4.4
+	exit 0 ;;
+    ibmrt:*BSD:*|romp-ibm:BSD:*)            # covers RT/PC BSD and
+	echo romp-ibm-bsd${UNAME_RELEASE}   # 4.3 with uname added to
+	exit 0 ;;                           # report: romp-ibm BSD 4.3
+    *:BOSX:*:*)
+	echo rs6000-bull-bosx
+	exit 0 ;;
+    DPX/2?00:B.O.S.:*:*)
+	echo m68k-bull-sysv3
+	exit 0 ;;
+    9000/[34]??:4.3bsd:1.*:*)
+	echo m68k-hp-bsd
+	exit 0 ;;
+    hp300:4.4BSD:*:* | 9000/[34]??:4.3bsd:2.*:*)
+	echo m68k-hp-bsd4.4
+	exit 0 ;;
+    9000/[34678]??:HP-UX:*:*)
+	HPUX_REV=`echo ${UNAME_RELEASE}|sed -e 's/[^.]*.[0B]*//'`
+	case "${UNAME_MACHINE}" in
+	    9000/31? )            HP_ARCH=m68000 ;;
+	    9000/[34]?? )         HP_ARCH=m68k ;;
+	    9000/[678][0-9][0-9])
+		if [ -x /usr/bin/getconf ]; then
+		    sc_cpu_version=`/usr/bin/getconf SC_CPU_VERSION 2>/dev/null`
+                    sc_kernel_bits=`/usr/bin/getconf SC_KERNEL_BITS 2>/dev/null`
+                    case "${sc_cpu_version}" in
+                      523) HP_ARCH="hppa1.0" ;; # CPU_PA_RISC1_0
+                      528) HP_ARCH="hppa1.1" ;; # CPU_PA_RISC1_1
+                      532)                      # CPU_PA_RISC2_0
+                        case "${sc_kernel_bits}" in
+                          32) HP_ARCH="hppa2.0n" ;;
+                          64) HP_ARCH="hppa2.0w" ;;
+			  '') HP_ARCH="hppa2.0" ;;   # HP-UX 10.20
+                        esac ;;
+                    esac
+		fi
+		if [ "${HP_ARCH}" = "" ]; then
+		    eval $set_cc_for_build
+		    sed 's/^              //' << EOF >$dummy.c
+
+              #define _HPUX_SOURCE
+              #include <stdlib.h>
+              #include <unistd.h>
+
+              int main ()
+              {
+              #if defined(_SC_KERNEL_BITS)
+                  long bits = sysconf(_SC_KERNEL_BITS);
+              #endif
+                  long cpu  = sysconf (_SC_CPU_VERSION);
+
+                  switch (cpu)
+              	{
+              	case CPU_PA_RISC1_0: puts ("hppa1.0"); break;
+              	case CPU_PA_RISC1_1: puts ("hppa1.1"); break;
+              	case CPU_PA_RISC2_0:
+              #if defined(_SC_KERNEL_BITS)
+              	    switch (bits)
+              		{
+              		case 64: puts ("hppa2.0w"); break;
+              		case 32: puts ("hppa2.0n"); break;
+              		default: puts ("hppa2.0"); break;
+              		} break;
+              #else  /* !defined(_SC_KERNEL_BITS) */
+              	    puts ("hppa2.0"); break;
+              #endif
+              	default: puts ("hppa1.0"); break;
+              	}
+                  exit (0);
+              }
+EOF
+		    (CCOPTS= $CC_FOR_BUILD -o $dummy $dummy.c 2>/dev/null) && HP_ARCH=`$dummy`
+		    test -z "$HP_ARCH" && HP_ARCH=hppa
+		fi ;;
+	esac
+	if [ ${HP_ARCH} = "hppa2.0w" ]
+	then
+	    # avoid double evaluation of $set_cc_for_build
+	    test -n "$CC_FOR_BUILD" || eval $set_cc_for_build
+	    if echo __LP64__ | (CCOPTS= $CC_FOR_BUILD -E -) | grep __LP64__ >/dev/null
+	    then
+		HP_ARCH="hppa2.0w"
+	    else
+		HP_ARCH="hppa64"
+	    fi
+	fi
+	echo ${HP_ARCH}-hp-hpux${HPUX_REV}
+	exit 0 ;;
+    ia64:HP-UX:*:*)
+	HPUX_REV=`echo ${UNAME_RELEASE}|sed -e 's/[^.]*.[0B]*//'`
+	echo ia64-hp-hpux${HPUX_REV}
+	exit 0 ;;
+    3050*:HI-UX:*:*)
+	eval $set_cc_for_build
+	sed 's/^	//' << EOF >$dummy.c
+	#include <unistd.h>
+	int
+	main ()
+	{
+	  long cpu = sysconf (_SC_CPU_VERSION);
+	  /* The order matters, because CPU_IS_HP_MC68K erroneously returns
+	     true for CPU_PA_RISC1_0.  CPU_IS_PA_RISC returns correct
+	     results, however.  */
+	  if (CPU_IS_PA_RISC (cpu))
+	    {
+	      switch (cpu)
+		{
+		  case CPU_PA_RISC1_0: puts ("hppa1.0-hitachi-hiuxwe2"); break;
+		  case CPU_PA_RISC1_1: puts ("hppa1.1-hitachi-hiuxwe2"); break;
+		  case CPU_PA_RISC2_0: puts ("hppa2.0-hitachi-hiuxwe2"); break;
+		  default: puts ("hppa-hitachi-hiuxwe2"); break;
+		}
+	    }
+	  else if (CPU_IS_HP_MC68K (cpu))
+	    puts ("m68k-hitachi-hiuxwe2");
+	  else puts ("unknown-hitachi-hiuxwe2");
+	  exit (0);
+	}
+EOF
+	$CC_FOR_BUILD -o $dummy $dummy.c && $dummy && exit 0
+	echo unknown-hitachi-hiuxwe2
+	exit 0 ;;
+    9000/7??:4.3bsd:*:* | 9000/8?[79]:4.3bsd:*:* )
+	echo hppa1.1-hp-bsd
+	exit 0 ;;
+    9000/8??:4.3bsd:*:*)
+	echo hppa1.0-hp-bsd
+	exit 0 ;;
+    *9??*:MPE/iX:*:* | *3000*:MPE/iX:*:*)
+	echo hppa1.0-hp-mpeix
+	exit 0 ;;
+    hp7??:OSF1:*:* | hp8?[79]:OSF1:*:* )
+	echo hppa1.1-hp-osf
+	exit 0 ;;
+    hp8??:OSF1:*:*)
+	echo hppa1.0-hp-osf
+	exit 0 ;;
+    i*86:OSF1:*:*)
+	if [ -x /usr/sbin/sysversion ] ; then
+	    echo ${UNAME_MACHINE}-unknown-osf1mk
+	else
+	    echo ${UNAME_MACHINE}-unknown-osf1
+	fi
+	exit 0 ;;
+    parisc*:Lites*:*:*)
+	echo hppa1.1-hp-lites
+	exit 0 ;;
+    C1*:ConvexOS:*:* | convex:ConvexOS:C1*:*)
+	echo c1-convex-bsd
+        exit 0 ;;
+    C2*:ConvexOS:*:* | convex:ConvexOS:C2*:*)
+	if getsysinfo -f scalar_acc
+	then echo c32-convex-bsd
+	else echo c2-convex-bsd
+	fi
+        exit 0 ;;
+    C34*:ConvexOS:*:* | convex:ConvexOS:C34*:*)
+	echo c34-convex-bsd
+        exit 0 ;;
+    C38*:ConvexOS:*:* | convex:ConvexOS:C38*:*)
+	echo c38-convex-bsd
+        exit 0 ;;
+    C4*:ConvexOS:*:* | convex:ConvexOS:C4*:*)
+	echo c4-convex-bsd
+        exit 0 ;;
+    CRAY*Y-MP:*:*:*)
+	echo ymp-cray-unicos${UNAME_RELEASE} | sed -e 's/\.[^.]*$/.X/'
+	exit 0 ;;
+    CRAY*[A-Z]90:*:*:*)
+	echo ${UNAME_MACHINE}-cray-unicos${UNAME_RELEASE} \
+	| sed -e 's/CRAY.*\([A-Z]90\)/\1/' \
+	      -e y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/ \
+	      -e 's/\.[^.]*$/.X/'
+	exit 0 ;;
+    CRAY*TS:*:*:*)
+	echo t90-cray-unicos${UNAME_RELEASE} | sed -e 's/\.[^.]*$/.X/'
+	exit 0 ;;
+    CRAY*T3E:*:*:*)
+	echo alphaev5-cray-unicosmk${UNAME_RELEASE} | sed -e 's/\.[^.]*$/.X/'
+	exit 0 ;;
+    CRAY*SV1:*:*:*)
+	echo sv1-cray-unicos${UNAME_RELEASE} | sed -e 's/\.[^.]*$/.X/'
+	exit 0 ;;
+    *:UNICOS/mp:*:*)
+	echo nv1-cray-unicosmp${UNAME_RELEASE} | sed -e 's/\.[^.]*$/.X/' 
+	exit 0 ;;
+    F30[01]:UNIX_System_V:*:* | F700:UNIX_System_V:*:*)
+	FUJITSU_PROC=`uname -m | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'`
+        FUJITSU_SYS=`uname -p | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz' | sed -e 's/\///'`
+        FUJITSU_REL=`echo ${UNAME_RELEASE} | sed -e 's/ /_/'`
+        echo "${FUJITSU_PROC}-fujitsu-${FUJITSU_SYS}${FUJITSU_REL}"
+        exit 0 ;;
+    i*86:BSD/386:*:* | i*86:BSD/OS:*:* | *:Ascend\ Embedded/OS:*:*)
+	echo ${UNAME_MACHINE}-pc-bsdi${UNAME_RELEASE}
+	exit 0 ;;
+    sparc*:BSD/OS:*:*)
+	echo sparc-unknown-bsdi${UNAME_RELEASE}
+	exit 0 ;;
+    *:BSD/OS:*:*)
+	echo ${UNAME_MACHINE}-unknown-bsdi${UNAME_RELEASE}
+	exit 0 ;;
+    *:FreeBSD:*:*|*:GNU/FreeBSD:*:*)
+	# Determine whether the default compiler uses glibc.
+	eval $set_cc_for_build
+	sed 's/^	//' << EOF >$dummy.c
+	#include <features.h>
+	#if __GLIBC__ >= 2
+	LIBC=gnu
+	#else
+	LIBC=
+	#endif
+EOF
+	eval `$CC_FOR_BUILD -E $dummy.c 2>/dev/null | grep ^LIBC=`
+	echo ${UNAME_MACHINE}-unknown-freebsd`echo ${UNAME_RELEASE}|sed -e 's/[-(].*//'`${LIBC:+-$LIBC}
+	exit 0 ;;
+    i*:CYGWIN*:*)
+	echo ${UNAME_MACHINE}-pc-cygwin
+	exit 0 ;;
+    i*:MINGW*:*)
+	echo ${UNAME_MACHINE}-pc-mingw32
+	exit 0 ;;
+    i*:PW*:*)
+	echo ${UNAME_MACHINE}-pc-pw32
+	exit 0 ;;
+    x86:Interix*:[34]*)
+	echo i586-pc-interix${UNAME_RELEASE}|sed -e 's/\..*//'
+	exit 0 ;;
+    [345]86:Windows_95:* | [345]86:Windows_98:* | [345]86:Windows_NT:*)
+	echo i${UNAME_MACHINE}-pc-mks
+	exit 0 ;;
+    i*:Windows_NT*:* | Pentium*:Windows_NT*:*)
+	# How do we know it's Interix rather than the generic POSIX subsystem?
+	# It also conflicts with pre-2.0 versions of AT&T UWIN. Should we
+	# UNAME_MACHINE based on the output of uname instead of i386?
+	echo i586-pc-interix
+	exit 0 ;;
+    i*:UWIN*:*)
+	echo ${UNAME_MACHINE}-pc-uwin
+	exit 0 ;;
+    p*:CYGWIN*:*)
+	echo powerpcle-unknown-cygwin
+	exit 0 ;;
+    prep*:SunOS:5.*:*)
+	echo powerpcle-unknown-solaris2`echo ${UNAME_RELEASE}|sed -e 's/[^.]*//'`
+	exit 0 ;;
+    *:GNU:*:*)
+	echo `echo ${UNAME_MACHINE}|sed -e 's,[-/].*$,,'`-unknown-gnu`echo ${UNAME_RELEASE}|sed -e 's,/.*$,,'`
+	exit 0 ;;
+    i*86:Minix:*:*)
+	echo ${UNAME_MACHINE}-pc-minix
+	exit 0 ;;
+    arm*:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	exit 0 ;;
+    cris:Linux:*:*)
+	echo cris-axis-linux-gnu
+	exit 0 ;;
+    ia64:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	exit 0 ;;
+    m68*:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	exit 0 ;;
+    mips:Linux:*:*)
+	eval $set_cc_for_build
+	sed 's/^	//' << EOF >$dummy.c
+	#undef CPU
+	#undef mips
+	#undef mipsel
+	#if defined(__MIPSEL__) || defined(__MIPSEL) || defined(_MIPSEL) || defined(MIPSEL)
+	CPU=mipsel
+	#else
+	#if defined(__MIPSEB__) || defined(__MIPSEB) || defined(_MIPSEB) || defined(MIPSEB)
+	CPU=mips
+	#else
+	CPU=
+	#endif
+	#endif
+EOF
+	eval `$CC_FOR_BUILD -E $dummy.c 2>/dev/null | grep ^CPU=`
+	test x"${CPU}" != x && echo "${CPU}-unknown-linux-gnu" && exit 0
+	;;
+    mips64:Linux:*:*)
+	eval $set_cc_for_build
+	sed 's/^	//' << EOF >$dummy.c
+	#undef CPU
+	#undef mips64
+	#undef mips64el
+	#if defined(__MIPSEL__) || defined(__MIPSEL) || defined(_MIPSEL) || defined(MIPSEL)
+	CPU=mips64el
+	#else
+	#if defined(__MIPSEB__) || defined(__MIPSEB) || defined(_MIPSEB) || defined(MIPSEB)
+	CPU=mips64
+	#else
+	CPU=
+	#endif
+	#endif
+EOF
+	eval `$CC_FOR_BUILD -E $dummy.c 2>/dev/null | grep ^CPU=`
+	test x"${CPU}" != x && echo "${CPU}-unknown-linux-gnu" && exit 0
+	;;
+    ppc:Linux:*:*)
+	echo powerpc-unknown-linux-gnu
+	exit 0 ;;
+    ppc64:Linux:*:*)
+	echo powerpc64-unknown-linux-gnu
+	exit 0 ;;
+    alpha:Linux:*:*)
+	case `sed -n '/^cpu model/s/^.*: \(.*\)/\1/p' < /proc/cpuinfo` in
+	  EV5)   UNAME_MACHINE=alphaev5 ;;
+	  EV56)  UNAME_MACHINE=alphaev56 ;;
+	  PCA56) UNAME_MACHINE=alphapca56 ;;
+	  PCA57) UNAME_MACHINE=alphapca56 ;;
+	  EV6)   UNAME_MACHINE=alphaev6 ;;
+	  EV67)  UNAME_MACHINE=alphaev67 ;;
+	  EV68*) UNAME_MACHINE=alphaev68 ;;
+        esac
+	objdump --private-headers /bin/sh | grep ld.so.1 >/dev/null
+	if test "$?" = 0 ; then LIBC="libc1" ; else LIBC="" ; fi
+	echo ${UNAME_MACHINE}-unknown-linux-gnu${LIBC}
+	exit 0 ;;
+    parisc:Linux:*:* | hppa:Linux:*:*)
+	# Look for CPU level
+	case `grep '^cpu[^a-z]*:' /proc/cpuinfo 2>/dev/null | cut -d' ' -f2` in
+	  PA7*) echo hppa1.1-unknown-linux-gnu ;;
+	  PA8*) echo hppa2.0-unknown-linux-gnu ;;
+	  *)    echo hppa-unknown-linux-gnu ;;
+	esac
+	exit 0 ;;
+    parisc64:Linux:*:* | hppa64:Linux:*:*)
+	echo hppa64-unknown-linux-gnu
+	exit 0 ;;
+    s390:Linux:*:* | s390x:Linux:*:*)
+	echo ${UNAME_MACHINE}-ibm-linux
+	exit 0 ;;
+    sh64*:Linux:*:*)
+    	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	exit 0 ;;
+    sh*:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	exit 0 ;;
+    sparc:Linux:*:* | sparc64:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	exit 0 ;;
+    x86_64:Linux:*:*)
+	echo x86_64-unknown-linux-gnu
+	exit 0 ;;
+    i*86:Linux:*:*)
+	# The BFD linker knows what the default object file format is, so
+	# first see if it will tell us. cd to the root directory to prevent
+	# problems with other programs or directories called `ld' in the path.
+	# Set LC_ALL=C to ensure ld outputs messages in English.
+	ld_supported_targets=`cd /; LC_ALL=C ld --help 2>&1 \
+			 | sed -ne '/supported targets:/!d
+				    s/[ 	][ 	]*/ /g
+				    s/.*supported targets: *//
+				    s/ .*//
+				    p'`
+        case "$ld_supported_targets" in
+	  elf32-i386)
+		TENTATIVE="${UNAME_MACHINE}-pc-linux-gnu"
+		;;
+	  a.out-i386-linux)
+		echo "${UNAME_MACHINE}-pc-linux-gnuaout"
+		exit 0 ;;
+	  coff-i386)
+		echo "${UNAME_MACHINE}-pc-linux-gnucoff"
+		exit 0 ;;
+	  "")
+		# Either a pre-BFD a.out linker (linux-gnuoldld) or
+		# one that does not give us useful --help.
+		echo "${UNAME_MACHINE}-pc-linux-gnuoldld"
+		exit 0 ;;
+	esac
+	# Determine whether the default compiler is a.out or elf
+	eval $set_cc_for_build
+	sed 's/^	//' << EOF >$dummy.c
+	#include <features.h>
+	#ifdef __ELF__
+	# ifdef __GLIBC__
+	#  if __GLIBC__ >= 2
+	LIBC=gnu
+	#  else
+	LIBC=gnulibc1
+	#  endif
+	# else
+	LIBC=gnulibc1
+	# endif
+	#else
+	#ifdef __INTEL_COMPILER
+	LIBC=gnu
+	#else
+	LIBC=gnuaout
+	#endif
+	#endif
+EOF
+	eval `$CC_FOR_BUILD -E $dummy.c 2>/dev/null | grep ^LIBC=`
+	test x"${LIBC}" != x && echo "${UNAME_MACHINE}-pc-linux-${LIBC}" && exit 0
+	test x"${TENTATIVE}" != x && echo "${TENTATIVE}" && exit 0
+	;;
+    i*86:DYNIX/ptx:4*:*)
+	# ptx 4.0 does uname -s correctly, with DYNIX/ptx in there.
+	# earlier versions are messed up and put the nodename in both
+	# sysname and nodename.
+	echo i386-sequent-sysv4
+	exit 0 ;;
+    i*86:UNIX_SV:4.2MP:2.*)
+        # Unixware is an offshoot of SVR4, but it has its own version
+        # number series starting with 2...
+        # I am not positive that other SVR4 systems won't match this,
+	# I just have to hope.  -- rms.
+        # Use sysv4.2uw... so that sysv4* matches it.
+	echo ${UNAME_MACHINE}-pc-sysv4.2uw${UNAME_VERSION}
+	exit 0 ;;
+    i*86:OS/2:*:*)
+	# If we were able to find `uname', then EMX Unix compatibility
+	# is probably installed.
+	echo ${UNAME_MACHINE}-pc-os2-emx
+	exit 0 ;;
+    i*86:XTS-300:*:STOP)
+	echo ${UNAME_MACHINE}-unknown-stop
+	exit 0 ;;
+    i*86:atheos:*:*)
+	echo ${UNAME_MACHINE}-unknown-atheos
+	exit 0 ;;
+    i*86:LynxOS:2.*:* | i*86:LynxOS:3.[01]*:* | i*86:LynxOS:4.0*:*)
+	echo i386-unknown-lynxos${UNAME_RELEASE}
+	exit 0 ;;
+    i*86:*DOS:*:*)
+	echo ${UNAME_MACHINE}-pc-msdosdjgpp
+	exit 0 ;;
+    i*86:*:4.*:* | i*86:SYSTEM_V:4.*:*)
+	UNAME_REL=`echo ${UNAME_RELEASE} | sed 's/\/MP$//'`
+	if grep Novell /usr/include/link.h >/dev/null 2>/dev/null; then
+		echo ${UNAME_MACHINE}-univel-sysv${UNAME_REL}
+	else
+		echo ${UNAME_MACHINE}-pc-sysv${UNAME_REL}
+	fi
+	exit 0 ;;
+    i*86:*:5:[78]*)
+	case `/bin/uname -X | grep "^Machine"` in
+	    *486*)	     UNAME_MACHINE=i486 ;;
+	    *Pentium)	     UNAME_MACHINE=i586 ;;
+	    *Pent*|*Celeron) UNAME_MACHINE=i686 ;;
+	esac
+	echo ${UNAME_MACHINE}-unknown-sysv${UNAME_RELEASE}${UNAME_SYSTEM}${UNAME_VERSION}
+	exit 0 ;;
+    i*86:*:3.2:*)
+	if test -f /usr/options/cb.name; then
+		UNAME_REL=`sed -n 's/.*Version //p' </usr/options/cb.name`
+		echo ${UNAME_MACHINE}-pc-isc$UNAME_REL
+	elif /bin/uname -X 2>/dev/null >/dev/null ; then
+		UNAME_REL=`(/bin/uname -X|grep Release|sed -e 's/.*= //')`
+		(/bin/uname -X|grep i80486 >/dev/null) && UNAME_MACHINE=i486
+		(/bin/uname -X|grep '^Machine.*Pentium' >/dev/null) \
+			&& UNAME_MACHINE=i586
+		(/bin/uname -X|grep '^Machine.*Pent *II' >/dev/null) \
+			&& UNAME_MACHINE=i686
+		(/bin/uname -X|grep '^Machine.*Pentium Pro' >/dev/null) \
+			&& UNAME_MACHINE=i686
+		echo ${UNAME_MACHINE}-pc-sco$UNAME_REL
+	else
+		echo ${UNAME_MACHINE}-pc-sysv32
+	fi
+	exit 0 ;;
+    pc:*:*:*)
+	# Left here for compatibility:
+        # uname -m prints for DJGPP always 'pc', but it prints nothing about
+        # the processor, so we play safe by assuming i386.
+	echo i386-pc-msdosdjgpp
+        exit 0 ;;
+    Intel:Mach:3*:*)
+	echo i386-pc-mach3
+	exit 0 ;;
+    paragon:*:*:*)
+	echo i860-intel-osf1
+	exit 0 ;;
+    i860:*:4.*:*) # i860-SVR4
+	if grep Stardent /usr/include/sys/uadmin.h >/dev/null 2>&1 ; then
+	  echo i860-stardent-sysv${UNAME_RELEASE} # Stardent Vistra i860-SVR4
+	else # Add other i860-SVR4 vendors below as they are discovered.
+	  echo i860-unknown-sysv${UNAME_RELEASE}  # Unknown i860-SVR4
+	fi
+	exit 0 ;;
+    mini*:CTIX:SYS*5:*)
+	# "miniframe"
+	echo m68010-convergent-sysv
+	exit 0 ;;
+    mc68k:UNIX:SYSTEM5:3.51m)
+	echo m68k-convergent-sysv
+	exit 0 ;;
+    M680?0:D-NIX:5.3:*)
+	echo m68k-diab-dnix
+	exit 0 ;;
+    M68*:*:R3V[567]*:*)
+	test -r /sysV68 && echo 'm68k-motorola-sysv' && exit 0 ;;
+    3[34]??:*:4.0:3.0 | 3[34]??A:*:4.0:3.0 | 3[34]??,*:*:4.0:3.0 | 3[34]??/*:*:4.0:3.0 | 4400:*:4.0:3.0 | 4850:*:4.0:3.0 | SKA40:*:4.0:3.0 | SDS2:*:4.0:3.0 | SHG2:*:4.0:3.0)
+	OS_REL=''
+	test -r /etc/.relid \
+	&& OS_REL=.`sed -n 's/[^ ]* [^ ]* \([0-9][0-9]\).*/\1/p' < /etc/.relid`
+	/bin/uname -p 2>/dev/null | grep 86 >/dev/null \
+	  && echo i486-ncr-sysv4.3${OS_REL} && exit 0
+	/bin/uname -p 2>/dev/null | /bin/grep entium >/dev/null \
+	  && echo i586-ncr-sysv4.3${OS_REL} && exit 0 ;;
+    3[34]??:*:4.0:* | 3[34]??,*:*:4.0:*)
+        /bin/uname -p 2>/dev/null | grep 86 >/dev/null \
+          && echo i486-ncr-sysv4 && exit 0 ;;
+    m68*:LynxOS:2.*:* | m68*:LynxOS:3.0*:*)
+	echo m68k-unknown-lynxos${UNAME_RELEASE}
+	exit 0 ;;
+    mc68030:UNIX_System_V:4.*:*)
+	echo m68k-atari-sysv4
+	exit 0 ;;
+    TSUNAMI:LynxOS:2.*:*)
+	echo sparc-unknown-lynxos${UNAME_RELEASE}
+	exit 0 ;;
+    rs6000:LynxOS:2.*:*)
+	echo rs6000-unknown-lynxos${UNAME_RELEASE}
+	exit 0 ;;
+    PowerPC:LynxOS:2.*:* | PowerPC:LynxOS:3.[01]*:* | PowerPC:LynxOS:4.0*:*)
+	echo powerpc-unknown-lynxos${UNAME_RELEASE}
+	exit 0 ;;
+    SM[BE]S:UNIX_SV:*:*)
+	echo mips-dde-sysv${UNAME_RELEASE}
+	exit 0 ;;
+    RM*:ReliantUNIX-*:*:*)
+	echo mips-sni-sysv4
+	exit 0 ;;
+    RM*:SINIX-*:*:*)
+	echo mips-sni-sysv4
+	exit 0 ;;
+    *:SINIX-*:*:*)
+	if uname -p 2>/dev/null >/dev/null ; then
+		UNAME_MACHINE=`(uname -p) 2>/dev/null`
+		echo ${UNAME_MACHINE}-sni-sysv4
+	else
+		echo ns32k-sni-sysv
+	fi
+	exit 0 ;;
+    PENTIUM:*:4.0*:*) # Unisys `ClearPath HMP IX 4000' SVR4/MP effort
+                      # says <Richard.M.Bartel@ccMail.Census.GOV>
+        echo i586-unisys-sysv4
+        exit 0 ;;
+    *:UNIX_System_V:4*:FTX*)
+	# From Gerald Hewes <hewes@openmarket.com>.
+	# How about differentiating between stratus architectures? -djm
+	echo hppa1.1-stratus-sysv4
+	exit 0 ;;
+    *:*:*:FTX*)
+	# From seanf@swdc.stratus.com.
+	echo i860-stratus-sysv4
+	exit 0 ;;
+    *:VOS:*:*)
+	# From Paul.Green@stratus.com.
+	echo hppa1.1-stratus-vos
+	exit 0 ;;
+    mc68*:A/UX:*:*)
+	echo m68k-apple-aux${UNAME_RELEASE}
+	exit 0 ;;
+    news*:NEWS-OS:6*:*)
+	echo mips-sony-newsos6
+	exit 0 ;;
+    R[34]000:*System_V*:*:* | R4000:UNIX_SYSV:*:* | R*000:UNIX_SV:*:*)
+	if [ -d /usr/nec ]; then
+	        echo mips-nec-sysv${UNAME_RELEASE}
+	else
+	        echo mips-unknown-sysv${UNAME_RELEASE}
+	fi
+        exit 0 ;;
+    BeBox:BeOS:*:*)	# BeOS running on hardware made by Be, PPC only.
+	echo powerpc-be-beos
+	exit 0 ;;
+    BeMac:BeOS:*:*)	# BeOS running on Mac or Mac clone, PPC only.
+	echo powerpc-apple-beos
+	exit 0 ;;
+    BePC:BeOS:*:*)	# BeOS running on Intel PC compatible.
+	echo i586-pc-beos
+	exit 0 ;;
+    SX-4:SUPER-UX:*:*)
+	echo sx4-nec-superux${UNAME_RELEASE}
+	exit 0 ;;
+    SX-5:SUPER-UX:*:*)
+	echo sx5-nec-superux${UNAME_RELEASE}
+	exit 0 ;;
+    SX-6:SUPER-UX:*:*)
+	echo sx6-nec-superux${UNAME_RELEASE}
+	exit 0 ;;
+    Power*:Rhapsody:*:*)
+	echo powerpc-apple-rhapsody${UNAME_RELEASE}
+	exit 0 ;;
+    *:Rhapsody:*:*)
+	echo ${UNAME_MACHINE}-apple-rhapsody${UNAME_RELEASE}
+	exit 0 ;;
+    *:Darwin:*:*)
+	case `uname -p` in
+	    *86) UNAME_PROCESSOR=i686 ;;
+	    powerpc) UNAME_PROCESSOR=powerpc ;;
+	esac
+	echo ${UNAME_PROCESSOR}-apple-darwin${UNAME_RELEASE}
+	exit 0 ;;
+    *:procnto*:*:* | *:QNX:[0123456789]*:*)
+	UNAME_PROCESSOR=`uname -p`
+	if test "$UNAME_PROCESSOR" = "x86"; then
+		UNAME_PROCESSOR=i386
+		UNAME_MACHINE=pc
+	fi
+	echo ${UNAME_PROCESSOR}-${UNAME_MACHINE}-nto-qnx${UNAME_RELEASE}
+	exit 0 ;;
+    *:QNX:*:4*)
+	echo i386-pc-qnx
+	exit 0 ;;
+    NSR-[DGKLNPTVW]:NONSTOP_KERNEL:*:*)
+	echo nsr-tandem-nsk${UNAME_RELEASE}
+	exit 0 ;;
+    *:NonStop-UX:*:*)
+	echo mips-compaq-nonstopux
+	exit 0 ;;
+    BS2000:POSIX*:*:*)
+	echo bs2000-siemens-sysv
+	exit 0 ;;
+    DS/*:UNIX_System_V:*:*)
+	echo ${UNAME_MACHINE}-${UNAME_SYSTEM}-${UNAME_RELEASE}
+	exit 0 ;;
+    *:Plan9:*:*)
+	# "uname -m" is not consistent, so use $cputype instead. 386
+	# is converted to i386 for consistency with other x86
+	# operating systems.
+	if test "$cputype" = "386"; then
+	    UNAME_MACHINE=i386
+	else
+	    UNAME_MACHINE="$cputype"
+	fi
+	echo ${UNAME_MACHINE}-unknown-plan9
+	exit 0 ;;
+    *:TOPS-10:*:*)
+	echo pdp10-unknown-tops10
+	exit 0 ;;
+    *:TENEX:*:*)
+	echo pdp10-unknown-tenex
+	exit 0 ;;
+    KS10:TOPS-20:*:* | KL10:TOPS-20:*:* | TYPE4:TOPS-20:*:*)
+	echo pdp10-dec-tops20
+	exit 0 ;;
+    XKL-1:TOPS-20:*:* | TYPE5:TOPS-20:*:*)
+	echo pdp10-xkl-tops20
+	exit 0 ;;
+    *:TOPS-20:*:*)
+	echo pdp10-unknown-tops20
+	exit 0 ;;
+    *:ITS:*:*)
+	echo pdp10-unknown-its
+	exit 0 ;;
+    SEI:*:*:SEIUX)
+        echo mips-sei-seiux${UNAME_RELEASE}
+	exit 0 ;;
+esac
+
+#echo '(No uname command or uname output not recognized.)' 1>&2
+#echo "${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}:${UNAME_VERSION}" 1>&2
+
+eval $set_cc_for_build
+cat >$dummy.c <<EOF
+#ifdef _SEQUENT_
+# include <sys/types.h>
+# include <sys/utsname.h>
+#endif
+main ()
+{
+#if defined (sony)
+#if defined (MIPSEB)
+  /* BFD wants "bsd" instead of "newsos".  Perhaps BFD should be changed,
+     I don't know....  */
+  printf ("mips-sony-bsd\n"); exit (0);
+#else
+#include <sys/param.h>
+  printf ("m68k-sony-newsos%s\n",
+#ifdef NEWSOS4
+          "4"
+#else
+	  ""
+#endif
+         ); exit (0);
+#endif
+#endif
+
+#if defined (__arm) && defined (__acorn) && defined (__unix)
+  printf ("arm-acorn-riscix"); exit (0);
+#endif
+
+#if defined (hp300) && !defined (hpux)
+  printf ("m68k-hp-bsd\n"); exit (0);
+#endif
+
+#if defined (NeXT)
+#if !defined (__ARCHITECTURE__)
+#define __ARCHITECTURE__ "m68k"
+#endif
+  int version;
+  version=`(hostinfo | sed -n 's/.*NeXT Mach \([0-9]*\).*/\1/p') 2>/dev/null`;
+  if (version < 4)
+    printf ("%s-next-nextstep%d\n", __ARCHITECTURE__, version);
+  else
+    printf ("%s-next-openstep%d\n", __ARCHITECTURE__, version);
+  exit (0);
+#endif
+
+#if defined (MULTIMAX) || defined (n16)
+#if defined (UMAXV)
+  printf ("ns32k-encore-sysv\n"); exit (0);
+#else
+#if defined (CMU)
+  printf ("ns32k-encore-mach\n"); exit (0);
+#else
+  printf ("ns32k-encore-bsd\n"); exit (0);
+#endif
+#endif
+#endif
+
+#if defined (__386BSD__)
+  printf ("i386-pc-bsd\n"); exit (0);
+#endif
+
+#if defined (sequent)
+#if defined (i386)
+  printf ("i386-sequent-dynix\n"); exit (0);
+#endif
+#if defined (ns32000)
+  printf ("ns32k-sequent-dynix\n"); exit (0);
+#endif
+#endif
+
+#if defined (_SEQUENT_)
+    struct utsname un;
+
+    uname(&un);
+
+    if (strncmp(un.version, "V2", 2) == 0) {
+	printf ("i386-sequent-ptx2\n"); exit (0);
+    }
+    if (strncmp(un.version, "V1", 2) == 0) { /* XXX is V1 correct? */
+	printf ("i386-sequent-ptx1\n"); exit (0);
+    }
+    printf ("i386-sequent-ptx\n"); exit (0);
+
+#endif
+
+#if defined (vax)
+# if !defined (ultrix)
+#  include <sys/param.h>
+#  if defined (BSD)
+#   if BSD == 43
+      printf ("vax-dec-bsd4.3\n"); exit (0);
+#   else
+#    if BSD == 199006
+      printf ("vax-dec-bsd4.3reno\n"); exit (0);
+#    else
+      printf ("vax-dec-bsd\n"); exit (0);
+#    endif
+#   endif
+#  else
+    printf ("vax-dec-bsd\n"); exit (0);
+#  endif
+# else
+    printf ("vax-dec-ultrix\n"); exit (0);
+# endif
+#endif
+
+#if defined (alliant) && defined (i860)
+  printf ("i860-alliant-bsd\n"); exit (0);
+#endif
+
+  exit (1);
+}
+EOF
+
+$CC_FOR_BUILD -o $dummy $dummy.c 2>/dev/null && $dummy && exit 0
+
+# Apollos put the system type in the environment.
+
+test -d /usr/apollo && { echo ${ISP}-apollo-${SYSTYPE}; exit 0; }
+
+# Convex versions that predate uname can use getsysinfo(1)
+
+if [ -x /usr/convex/getsysinfo ]
+then
+    case `getsysinfo -f cpu_type` in
+    c1*)
+	echo c1-convex-bsd
+	exit 0 ;;
+    c2*)
+	if getsysinfo -f scalar_acc
+	then echo c32-convex-bsd
+	else echo c2-convex-bsd
+	fi
+	exit 0 ;;
+    c34*)
+	echo c34-convex-bsd
+	exit 0 ;;
+    c38*)
+	echo c38-convex-bsd
+	exit 0 ;;
+    c4*)
+	echo c4-convex-bsd
+	exit 0 ;;
+    esac
+fi
+
+cat >&2 <<EOF
+$0: unable to guess system type
+
+This script, last modified $timestamp, has failed to recognize
+the operating system you are using. It is advised that you
+download the most up to date version of the config scripts from
+
+    ftp://ftp.gnu.org/pub/gnu/config/
+
+If the version you run ($0) is already up to date, please
+send the following data and any information you think might be
+pertinent to <config-patches@gnu.org> in order to provide the needed
+information to handle your system.
+
+config.guess timestamp = $timestamp
+
+uname -m = `(uname -m) 2>/dev/null || echo unknown`
+uname -r = `(uname -r) 2>/dev/null || echo unknown`
+uname -s = `(uname -s) 2>/dev/null || echo unknown`
+uname -v = `(uname -v) 2>/dev/null || echo unknown`
+
+/usr/bin/uname -p = `(/usr/bin/uname -p) 2>/dev/null`
+/bin/uname -X     = `(/bin/uname -X) 2>/dev/null`
+
+hostinfo               = `(hostinfo) 2>/dev/null`
+/bin/universe          = `(/bin/universe) 2>/dev/null`
+/usr/bin/arch -k       = `(/usr/bin/arch -k) 2>/dev/null`
+/bin/arch              = `(/bin/arch) 2>/dev/null`
+/usr/bin/oslevel       = `(/usr/bin/oslevel) 2>/dev/null`
+/usr/convex/getsysinfo = `(/usr/convex/getsysinfo) 2>/dev/null`
+
+UNAME_MACHINE = ${UNAME_MACHINE}
+UNAME_RELEASE = ${UNAME_RELEASE}
+UNAME_SYSTEM  = ${UNAME_SYSTEM}
+UNAME_VERSION = ${UNAME_VERSION}
+EOF
+
+exit 1
+
+# Local variables:
+# eval: (add-hook 'write-file-hooks 'time-stamp)
+# time-stamp-start: "timestamp='"
+# time-stamp-format: "%:y-%02m-%02d"
+# time-stamp-end: "'"
+# End:
/cvs/dm/dmraid/autoconf/config.sub,v  -->  standard output
revision 1.1
--- dmraid/autoconf/config.sub
+++ -	2008-02-22 16:57:37.920041000 +0000
@@ -0,0 +1,1504 @@
+#! /bin/sh
+# Configuration validation subroutine script.
+#   Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
+#   2000, 2001, 2002, 2003 Free Software Foundation, Inc.
+
+timestamp='2003-06-17'
+
+# This file is (in principle) common to ALL GNU software.
+# The presence of a machine in this file suggests that SOME GNU software
+# can handle that machine.  It does not imply ALL GNU software can.
+#
+# This file is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330,
+# Boston, MA 02111-1307, USA.
+
+# As a special exception to the GNU General Public License, if you
+# distribute this file as part of a program that contains a
+# configuration script generated by Autoconf, you may include it under
+# the same distribution terms that you use for the rest of that program.
+
+# Please send patches to <config-patches@gnu.org>.  Submit a context
+# diff and a properly formatted ChangeLog entry.
+#
+# Configuration subroutine to validate and canonicalize a configuration type.
+# Supply the specified configuration type as an argument.
+# If it is invalid, we print an error message on stderr and exit with code 1.
+# Otherwise, we print the canonical config type on stdout and succeed.
+
+# This file is supposed to be the same for all GNU packages
+# and recognize all the CPU types, system types and aliases
+# that are meaningful with *any* GNU software.
+# Each package is responsible for reporting which valid configurations
+# it does not support.  The user should be able to distinguish
+# a failure to support a valid configuration from a meaningless
+# configuration.
+
+# The goal of this file is to map all the various variations of a given
+# machine specification into a single specification in the form:
+#	CPU_TYPE-MANUFACTURER-OPERATING_SYSTEM
+# or in some cases, the newer four-part form:
+#	CPU_TYPE-MANUFACTURER-KERNEL-OPERATING_SYSTEM
+# It is wrong to echo any other type of specification.
+
+me=`echo "$0" | sed -e 's,.*/,,'`
+
+usage="\
+Usage: $0 [OPTION] CPU-MFR-OPSYS
+       $0 [OPTION] ALIAS
+
+Canonicalize a configuration name.
+
+Operation modes:
+  -h, --help         print this help, then exit
+  -t, --time-stamp   print date of last modification, then exit
+  -v, --version      print version number, then exit
+
+Report bugs and patches to <config-patches@gnu.org>."
+
+version="\
+GNU config.sub ($timestamp)
+
+Copyright (C) 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001
+Free Software Foundation, Inc.
+
+This is free software; see the source for copying conditions.  There is NO
+warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
+
+help="
+Try \`$me --help' for more information."
+
+# Parse command line
+while test $# -gt 0 ; do
+  case $1 in
+    --time-stamp | --time* | -t )
+       echo "$timestamp" ; exit 0 ;;
+    --version | -v )
+       echo "$version" ; exit 0 ;;
+    --help | --h* | -h )
+       echo "$usage"; exit 0 ;;
+    -- )     # Stop option processing
+       shift; break ;;
+    - )	# Use stdin as input.
+       break ;;
+    -* )
+       echo "$me: invalid option $1$help"
+       exit 1 ;;
+
+    *local*)
+       # First pass through any local machine types.
+       echo $1
+       exit 0;;
+
+    * )
+       break ;;
+  esac
+done
+
+case $# in
+ 0) echo "$me: missing argument$help" >&2
+    exit 1;;
+ 1) ;;
+ *) echo "$me: too many arguments$help" >&2
+    exit 1;;
+esac
+
+# Separate what the user gave into CPU-COMPANY and OS or KERNEL-OS (if any).
+# Here we must recognize all the valid KERNEL-OS combinations.
+maybe_os=`echo $1 | sed 's/^\(.*\)-\([^-]*-[^-]*\)$/\2/'`
+case $maybe_os in
+  nto-qnx* | linux-gnu* | freebsd*-gnu* | netbsd*-gnu* | storm-chaos* | os2-emx* | rtmk-nova*)
+    os=-$maybe_os
+    basic_machine=`echo $1 | sed 's/^\(.*\)-\([^-]*-[^-]*\)$/\1/'`
+    ;;
+  *)
+    basic_machine=`echo $1 | sed 's/-[^-]*$//'`
+    if [ $basic_machine != $1 ]
+    then os=`echo $1 | sed 's/.*-/-/'`
+    else os=; fi
+    ;;
+esac
+
+### Let's recognize common machines as not being operating systems so
+### that things like config.sub decstation-3100 work.  We also
+### recognize some manufacturers as not being operating systems, so we
+### can provide default operating systems below.
+case $os in
+	-sun*os*)
+		# Prevent following clause from handling this invalid input.
+		;;
+	-dec* | -mips* | -sequent* | -encore* | -pc532* | -sgi* | -sony* | \
+	-att* | -7300* | -3300* | -delta* | -motorola* | -sun[234]* | \
+	-unicom* | -ibm* | -next | -hp | -isi* | -apollo | -altos* | \
+	-convergent* | -ncr* | -news | -32* | -3600* | -3100* | -hitachi* |\
+	-c[123]* | -convex* | -sun | -crds | -omron* | -dg | -ultra | -tti* | \
+	-harris | -dolphin | -highlevel | -gould | -cbm | -ns | -masscomp | \
+	-apple | -axis)
+		os=
+		basic_machine=$1
+		;;
+	-sim | -cisco | -oki | -wec | -winbond)
+		os=
+		basic_machine=$1
+		;;
+	-scout)
+		;;
+	-wrs)
+		os=-vxworks
+		basic_machine=$1
+		;;
+	-chorusos*)
+		os=-chorusos
+		basic_machine=$1
+		;;
+ 	-chorusrdb)
+ 		os=-chorusrdb
+		basic_machine=$1
+ 		;;
+	-hiux*)
+		os=-hiuxwe2
+		;;
+	-sco5)
+		os=-sco3.2v5
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-sco4)
+		os=-sco3.2v4
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-sco3.2.[4-9]*)
+		os=`echo $os | sed -e 's/sco3.2./sco3.2v/'`
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-sco3.2v[4-9]*)
+		# Don't forget version if it is 3.2v4 or newer.
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-sco*)
+		os=-sco3.2v2
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-udk*)
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-isc)
+		os=-isc2.2
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-clix*)
+		basic_machine=clipper-intergraph
+		;;
+	-isc*)
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-pc/'`
+		;;
+	-lynx*)
+		os=-lynxos
+		;;
+	-ptx*)
+		basic_machine=`echo $1 | sed -e 's/86-.*/86-sequent/'`
+		;;
+	-windowsnt*)
+		os=`echo $os | sed -e 's/windowsnt/winnt/'`
+		;;
+	-psos*)
+		os=-psos
+		;;
+	-mint | -mint[0-9]*)
+		basic_machine=m68k-atari
+		os=-mint
+		;;
+esac
+
+# Decode aliases for certain CPU-COMPANY combinations.
+case $basic_machine in
+	# Recognize the basic CPU types without company name.
+	# Some are omitted here because they have special meanings below.
+	1750a | 580 \
+	| a29k \
+	| alpha | alphaev[4-8] | alphaev56 | alphaev6[78] | alphapca5[67] \
+	| alpha64 | alpha64ev[4-8] | alpha64ev56 | alpha64ev6[78] | alpha64pca5[67] \
+	| arc | arm | arm[bl]e | arme[lb] | armv[2345] | armv[345][lb] | avr \
+	| c4x | clipper \
+	| d10v | d30v | dlx | dsp16xx \
+	| fr30 | frv \
+	| h8300 | h8500 | hppa | hppa1.[01] | hppa2.0 | hppa2.0[nw] | hppa64 \
+	| i370 | i860 | i960 | ia64 \
+	| ip2k \
+	| m32r | m68000 | m68k | m88k | mcore \
+	| mips | mipsbe | mipseb | mipsel | mipsle \
+	| mips16 \
+	| mips64 | mips64el \
+	| mips64vr | mips64vrel \
+	| mips64orion | mips64orionel \
+	| mips64vr4100 | mips64vr4100el \
+	| mips64vr4300 | mips64vr4300el \
+	| mips64vr5000 | mips64vr5000el \
+	| mipsisa32 | mipsisa32el \
+	| mipsisa32r2 | mipsisa32r2el \
+	| mipsisa64 | mipsisa64el \
+	| mipsisa64sb1 | mipsisa64sb1el \
+	| mipsisa64sr71k | mipsisa64sr71kel \
+	| mipstx39 | mipstx39el \
+	| mn10200 | mn10300 \
+	| msp430 \
+	| ns16k | ns32k \
+	| openrisc | or32 \
+	| pdp10 | pdp11 | pj | pjl \
+	| powerpc | powerpc64 | powerpc64le | powerpcle | ppcbe \
+	| pyramid \
+	| sh | sh[1234] | sh[23]e | sh[34]eb | shbe | shle | sh[1234]le | sh3ele \
+	| sh64 | sh64le \
+	| sparc | sparc64 | sparc86x | sparclet | sparclite | sparcv9 | sparcv9b \
+	| strongarm \
+	| tahoe | thumb | tic4x | tic80 | tron \
+	| v850 | v850e \
+	| we32k \
+	| x86 | xscale | xstormy16 | xtensa \
+	| z8k)
+		basic_machine=$basic_machine-unknown
+		;;
+	m6811 | m68hc11 | m6812 | m68hc12)
+		# Motorola 68HC11/12.
+		basic_machine=$basic_machine-unknown
+		os=-none
+		;;
+	m88110 | m680[12346]0 | m683?2 | m68360 | m5200 | v70 | w65 | z8k)
+		;;
+
+	# We use `pc' rather than `unknown'
+	# because (1) that's what they normally are, and
+	# (2) the word "unknown" tends to confuse beginning users.
+	i*86 | x86_64)
+	  basic_machine=$basic_machine-pc
+	  ;;
+	# Object if more than one company name word.
+	*-*-*)
+		echo Invalid configuration \`$1\': machine \`$basic_machine\' not recognized 1>&2
+		exit 1
+		;;
+	# Recognize the basic CPU types with company name.
+	580-* \
+	| a29k-* \
+	| alpha-* | alphaev[4-8]-* | alphaev56-* | alphaev6[78]-* \
+	| alpha64-* | alpha64ev[4-8]-* | alpha64ev56-* | alpha64ev6[78]-* \
+	| alphapca5[67]-* | alpha64pca5[67]-* | arc-* \
+	| arm-*  | armbe-* | armle-* | armeb-* | armv*-* \
+	| avr-* \
+	| bs2000-* \
+	| c[123]* | c30-* | [cjt]90-* | c4x-* | c54x-* | c55x-* | c6x-* \
+	| clipper-* | cydra-* \
+	| d10v-* | d30v-* | dlx-* \
+	| elxsi-* \
+	| f30[01]-* | f700-* | fr30-* | frv-* | fx80-* \
+	| h8300-* | h8500-* \
+	| hppa-* | hppa1.[01]-* | hppa2.0-* | hppa2.0[nw]-* | hppa64-* \
+	| i*86-* | i860-* | i960-* | ia64-* \
+	| ip2k-* \
+	| m32r-* \
+	| m68000-* | m680[012346]0-* | m68360-* | m683?2-* | m68k-* \
+	| m88110-* | m88k-* | mcore-* \
+	| mips-* | mipsbe-* | mipseb-* | mipsel-* | mipsle-* \
+	| mips16-* \
+	| mips64-* | mips64el-* \
+	| mips64vr-* | mips64vrel-* \
+	| mips64orion-* | mips64orionel-* \
+	| mips64vr4100-* | mips64vr4100el-* \
+	| mips64vr4300-* | mips64vr4300el-* \
+	| mips64vr5000-* | mips64vr5000el-* \
+	| mipsisa32-* | mipsisa32el-* \
+	| mipsisa32r2-* | mipsisa32r2el-* \
+	| mipsisa64-* | mipsisa64el-* \
+	| mipsisa64sb1-* | mipsisa64sb1el-* \
+	| mipsisa64sr71k-* | mipsisa64sr71kel-* \
+	| mipstx39-* | mipstx39el-* \
+	| msp430-* \
+	| none-* | np1-* | nv1-* | ns16k-* | ns32k-* \
+	| orion-* \
+	| pdp10-* | pdp11-* | pj-* | pjl-* | pn-* | power-* \
+	| powerpc-* | powerpc64-* | powerpc64le-* | powerpcle-* | ppcbe-* \
+	| pyramid-* \
+	| romp-* | rs6000-* \
+	| sh-* | sh[1234]-* | sh[23]e-* | sh[34]eb-* | shbe-* \
+	| shle-* | sh[1234]le-* | sh3ele-* | sh64-* | sh64le-* \
+	| sparc-* | sparc64-* | sparc86x-* | sparclet-* | sparclite-* \
+	| sparcv9-* | sparcv9b-* | strongarm-* | sv1-* | sx?-* \
+	| tahoe-* | thumb-* \
+	| tic30-* | tic4x-* | tic54x-* | tic55x-* | tic6x-* | tic80-* \
+	| tron-* \
+	| v850-* | v850e-* | vax-* \
+	| we32k-* \
+	| x86-* | x86_64-* | xps100-* | xscale-* | xstormy16-* \
+	| xtensa-* \
+	| ymp-* \
+	| z8k-*)
+		;;
+	# Recognize the various machine names and aliases which stand
+	# for a CPU type and a company and sometimes even an OS.
+	386bsd)
+		basic_machine=i386-unknown
+		os=-bsd
+		;;
+	3b1 | 7300 | 7300-att | att-7300 | pc7300 | safari | unixpc)
+		basic_machine=m68000-att
+		;;
+	3b*)
+		basic_machine=we32k-att
+		;;
+	a29khif)
+		basic_machine=a29k-amd
+		os=-udi
+		;;
+	adobe68k)
+		basic_machine=m68010-adobe
+		os=-scout
+		;;
+	alliant | fx80)
+		basic_machine=fx80-alliant
+		;;
+	altos | altos3068)
+		basic_machine=m68k-altos
+		;;
+	am29k)
+		basic_machine=a29k-none
+		os=-bsd
+		;;
+	amd64)
+		basic_machine=x86_64-pc
+		;;
+	amdahl)
+		basic_machine=580-amdahl
+		os=-sysv
+		;;
+	amiga | amiga-*)
+		basic_machine=m68k-unknown
+		;;
+	amigaos | amigados)
+		basic_machine=m68k-unknown
+		os=-amigaos
+		;;
+	amigaunix | amix)
+		basic_machine=m68k-unknown
+		os=-sysv4
+		;;
+	apollo68)
+		basic_machine=m68k-apollo
+		os=-sysv
+		;;
+	apollo68bsd)
+		basic_machine=m68k-apollo
+		os=-bsd
+		;;
+	aux)
+		basic_machine=m68k-apple
+		os=-aux
+		;;
+	balance)
+		basic_machine=ns32k-sequent
+		os=-dynix
+		;;
+	c90)
+		basic_machine=c90-cray
+		os=-unicos
+		;;
+	convex-c1)
+		basic_machine=c1-convex
+		os=-bsd
+		;;
+	convex-c2)
+		basic_machine=c2-convex
+		os=-bsd
+		;;
+	convex-c32)
+		basic_machine=c32-convex
+		os=-bsd
+		;;
+	convex-c34)
+		basic_machine=c34-convex
+		os=-bsd
+		;;
+	convex-c38)
+		basic_machine=c38-convex
+		os=-bsd
+		;;
+	cray | j90)
+		basic_machine=j90-cray
+		os=-unicos
+		;;
+	crds | unos)
+		basic_machine=m68k-crds
+		;;
+	cris | cris-* | etrax*)
+		basic_machine=cris-axis
+		;;
+	da30 | da30-*)
+		basic_machine=m68k-da30
+		;;
+	decstation | decstation-3100 | pmax | pmax-* | pmin | dec3100 | decstatn)
+		basic_machine=mips-dec
+		;;
+	decsystem10* | dec10*)
+		basic_machine=pdp10-dec
+		os=-tops10
+		;;
+	decsystem20* | dec20*)
+		basic_machine=pdp10-dec
+		os=-tops20
+		;;
+	delta | 3300 | motorola-3300 | motorola-delta \
+	      | 3300-motorola | delta-motorola)
+		basic_machine=m68k-motorola
+		;;
+	delta88)
+		basic_machine=m88k-motorola
+		os=-sysv3
+		;;
+	dpx20 | dpx20-*)
+		basic_machine=rs6000-bull
+		os=-bosx
+		;;
+	dpx2* | dpx2*-bull)
+		basic_machine=m68k-bull
+		os=-sysv3
+		;;
+	ebmon29k)
+		basic_machine=a29k-amd
+		os=-ebmon
+		;;
+	elxsi)
+		basic_machine=elxsi-elxsi
+		os=-bsd
+		;;
+	encore | umax | mmax)
+		basic_machine=ns32k-encore
+		;;
+	es1800 | OSE68k | ose68k | ose | OSE)
+		basic_machine=m68k-ericsson
+		os=-ose
+		;;
+	fx2800)
+		basic_machine=i860-alliant
+		;;
+	genix)
+		basic_machine=ns32k-ns
+		;;
+	gmicro)
+		basic_machine=tron-gmicro
+		os=-sysv
+		;;
+	go32)
+		basic_machine=i386-pc
+		os=-go32
+		;;
+	h3050r* | hiux*)
+		basic_machine=hppa1.1-hitachi
+		os=-hiuxwe2
+		;;
+	h8300hms)
+		basic_machine=h8300-hitachi
+		os=-hms
+		;;
+	h8300xray)
+		basic_machine=h8300-hitachi
+		os=-xray
+		;;
+	h8500hms)
+		basic_machine=h8500-hitachi
+		os=-hms
+		;;
+	harris)
+		basic_machine=m88k-harris
+		os=-sysv3
+		;;
+	hp300-*)
+		basic_machine=m68k-hp
+		;;
+	hp300bsd)
+		basic_machine=m68k-hp
+		os=-bsd
+		;;
+	hp300hpux)
+		basic_machine=m68k-hp
+		os=-hpux
+		;;
+	hp3k9[0-9][0-9] | hp9[0-9][0-9])
+		basic_machine=hppa1.0-hp
+		;;
+	hp9k2[0-9][0-9] | hp9k31[0-9])
+		basic_machine=m68000-hp
+		;;
+	hp9k3[2-9][0-9])
+		basic_machine=m68k-hp
+		;;
+	hp9k6[0-9][0-9] | hp6[0-9][0-9])
+		basic_machine=hppa1.0-hp
+		;;
+	hp9k7[0-79][0-9] | hp7[0-79][0-9])
+		basic_machine=hppa1.1-hp
+		;;
+	hp9k78[0-9] | hp78[0-9])
+		# FIXME: really hppa2.0-hp
+		basic_machine=hppa1.1-hp
+		;;
+	hp9k8[67]1 | hp8[67]1 | hp9k80[24] | hp80[24] | hp9k8[78]9 | hp8[78]9 | hp9k893 | hp893)
+		# FIXME: really hppa2.0-hp
+		basic_machine=hppa1.1-hp
+		;;
+	hp9k8[0-9][13679] | hp8[0-9][13679])
+		basic_machine=hppa1.1-hp
+		;;
+	hp9k8[0-9][0-9] | hp8[0-9][0-9])
+		basic_machine=hppa1.0-hp
+		;;
+	hppa-next)
+		os=-nextstep3
+		;;
+	hppaosf)
+		basic_machine=hppa1.1-hp
+		os=-osf
+		;;
+	hppro)
+		basic_machine=hppa1.1-hp
+		os=-proelf
+		;;
+	i370-ibm* | ibm*)
+		basic_machine=i370-ibm
+		;;
+# I'm not sure what "Sysv32" means.  Should this be sysv3.2?
+	i*86v32)
+		basic_machine=`echo $1 | sed -e 's/86.*/86-pc/'`
+		os=-sysv32
+		;;
+	i*86v4*)
+		basic_machine=`echo $1 | sed -e 's/86.*/86-pc/'`
+		os=-sysv4
+		;;
+	i*86v)
+		basic_machine=`echo $1 | sed -e 's/86.*/86-pc/'`
+		os=-sysv
+		;;
+	i*86sol2)
+		basic_machine=`echo $1 | sed -e 's/86.*/86-pc/'`
+		os=-solaris2
+		;;
+	i386mach)
+		basic_machine=i386-mach
+		os=-mach
+		;;
+	i386-vsta | vsta)
+		basic_machine=i386-unknown
+		os=-vsta
+		;;
+	iris | iris4d)
+		basic_machine=mips-sgi
+		case $os in
+		    -irix*)
+			;;
+		    *)
+			os=-irix4
+			;;
+		esac
+		;;
+	isi68 | isi)
+		basic_machine=m68k-isi
+		os=-sysv
+		;;
+	m88k-omron*)
+		basic_machine=m88k-omron
+		;;
+	magnum | m3230)
+		basic_machine=mips-mips
+		os=-sysv
+		;;
+	merlin)
+		basic_machine=ns32k-utek
+		os=-sysv
+		;;
+	mingw32)
+		basic_machine=i386-pc
+		os=-mingw32
+		;;
+	miniframe)
+		basic_machine=m68000-convergent
+		;;
+	*mint | -mint[0-9]* | *MiNT | *MiNT[0-9]*)
+		basic_machine=m68k-atari
+		os=-mint
+		;;
+	mips3*-*)
+		basic_machine=`echo $basic_machine | sed -e 's/mips3/mips64/'`
+		;;
+	mips3*)
+		basic_machine=`echo $basic_machine | sed -e 's/mips3/mips64/'`-unknown
+		;;
+	mmix*)
+		basic_machine=mmix-knuth
+		os=-mmixware
+		;;
+	monitor)
+		basic_machine=m68k-rom68k
+		os=-coff
+		;;
+	morphos)
+		basic_machine=powerpc-unknown
+		os=-morphos
+		;;
+	msdos)
+		basic_machine=i386-pc
+		os=-msdos
+		;;
+	mvs)
+		basic_machine=i370-ibm
+		os=-mvs
+		;;
+	ncr3000)
+		basic_machine=i486-ncr
+		os=-sysv4
+		;;
+	netbsd386)
+		basic_machine=i386-unknown
+		os=-netbsd
+		;;
+	netwinder)
+		basic_machine=armv4l-rebel
+		os=-linux
+		;;
+	news | news700 | news800 | news900)
+		basic_machine=m68k-sony
+		os=-newsos
+		;;
+	news1000)
+		basic_machine=m68030-sony
+		os=-newsos
+		;;
+	news-3600 | risc-news)
+		basic_machine=mips-sony
+		os=-newsos
+		;;
+	necv70)
+		basic_machine=v70-nec
+		os=-sysv
+		;;
+	next | m*-next )
+		basic_machine=m68k-next
+		case $os in
+		    -nextstep* )
+			;;
+		    -ns2*)
+		      os=-nextstep2
+			;;
+		    *)
+		      os=-nextstep3
+			;;
+		esac
+		;;
+	nh3000)
+		basic_machine=m68k-harris
+		os=-cxux
+		;;
+	nh[45]000)
+		basic_machine=m88k-harris
+		os=-cxux
+		;;
+	nindy960)
+		basic_machine=i960-intel
+		os=-nindy
+		;;
+	mon960)
+		basic_machine=i960-intel
+		os=-mon960
+		;;
+	nonstopux)
+		basic_machine=mips-compaq
+		os=-nonstopux
+		;;
+	np1)
+		basic_machine=np1-gould
+		;;
+	nv1)
+		basic_machine=nv1-cray
+		os=-unicosmp
+		;;
+	nsr-tandem)
+		basic_machine=nsr-tandem
+		;;
+	op50n-* | op60c-*)
+		basic_machine=hppa1.1-oki
+		os=-proelf
+		;;
+	or32 | or32-*)
+		basic_machine=or32-unknown
+		os=-coff
+		;;
+	OSE68000 | ose68000)
+		basic_machine=m68000-ericsson
+		os=-ose
+		;;
+	os68k)
+		basic_machine=m68k-none
+		os=-os68k
+		;;
+	pa-hitachi)
+		basic_machine=hppa1.1-hitachi
+		os=-hiuxwe2
+		;;
+	paragon)
+		basic_machine=i860-intel
+		os=-osf
+		;;
+	pbd)
+		basic_machine=sparc-tti
+		;;
+	pbb)
+		basic_machine=m68k-tti
+		;;
+	pc532 | pc532-*)
+		basic_machine=ns32k-pc532
+		;;
+	pentium | p5 | k5 | k6 | nexgen | viac3)
+		basic_machine=i586-pc
+		;;
+	pentiumpro | p6 | 6x86 | athlon | athlon_*)
+		basic_machine=i686-pc
+		;;
+	pentiumii | pentium2 | pentiumiii | pentium3)
+		basic_machine=i686-pc
+		;;
+	pentium4)
+		basic_machine=i786-pc
+		;;
+	pentium-* | p5-* | k5-* | k6-* | nexgen-* | viac3-*)
+		basic_machine=i586-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	pentiumpro-* | p6-* | 6x86-* | athlon-*)
+		basic_machine=i686-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	pentiumii-* | pentium2-* | pentiumiii-* | pentium3-*)
+		basic_machine=i686-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	pentium4-*)
+		basic_machine=i786-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	pn)
+		basic_machine=pn-gould
+		;;
+	power)	basic_machine=power-ibm
+		;;
+	ppc)	basic_machine=powerpc-unknown
+		;;
+	ppc-*)	basic_machine=powerpc-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	ppcle | powerpclittle | ppc-le | powerpc-little)
+		basic_machine=powerpcle-unknown
+		;;
+	ppcle-* | powerpclittle-*)
+		basic_machine=powerpcle-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	ppc64)	basic_machine=powerpc64-unknown
+		;;
+	ppc64-*) basic_machine=powerpc64-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	ppc64le | powerpc64little | ppc64-le | powerpc64-little)
+		basic_machine=powerpc64le-unknown
+		;;
+	ppc64le-* | powerpc64little-*)
+		basic_machine=powerpc64le-`echo $basic_machine | sed 's/^[^-]*-//'`
+		;;
+	ps2)
+		basic_machine=i386-ibm
+		;;
+	pw32)
+		basic_machine=i586-unknown
+		os=-pw32
+		;;
+	rom68k)
+		basic_machine=m68k-rom68k
+		os=-coff
+		;;
+	rm[46]00)
+		basic_machine=mips-siemens
+		;;
+	rtpc | rtpc-*)
+		basic_machine=romp-ibm
+		;;
+	s390 | s390-*)
+		basic_machine=s390-ibm
+		;;
+	s390x | s390x-*)
+		basic_machine=s390x-ibm
+		;;
+	sa29200)
+		basic_machine=a29k-amd
+		os=-udi
+		;;
+	sb1)
+		basic_machine=mipsisa64sb1-unknown
+		;;
+	sb1el)
+		basic_machine=mipsisa64sb1el-unknown
+		;;
+	sei)
+		basic_machine=mips-sei
+		os=-seiux
+		;;
+	sequent)
+		basic_machine=i386-sequent
+		;;
+	sh)
+		basic_machine=sh-hitachi
+		os=-hms
+		;;
+	sh64)
+		basic_machine=sh64-unknown
+		;;
+	sparclite-wrs | simso-wrs)
+		basic_machine=sparclite-wrs
+		os=-vxworks
+		;;
+	sps7)
+		basic_machine=m68k-bull
+		os=-sysv2
+		;;
+	spur)
+		basic_machine=spur-unknown
+		;;
+	st2000)
+		basic_machine=m68k-tandem
+		;;
+	stratus)
+		basic_machine=i860-stratus
+		os=-sysv4
+		;;
+	sun2)
+		basic_machine=m68000-sun
+		;;
+	sun2os3)
+		basic_machine=m68000-sun
+		os=-sunos3
+		;;
+	sun2os4)
+		basic_machine=m68000-sun
+		os=-sunos4
+		;;
+	sun3os3)
+		basic_machine=m68k-sun
+		os=-sunos3
+		;;
+	sun3os4)
+		basic_machine=m68k-sun
+		os=-sunos4
+		;;
+	sun4os3)
+		basic_machine=sparc-sun
+		os=-sunos3
+		;;
+	sun4os4)
+		basic_machine=sparc-sun
+		os=-sunos4
+		;;
+	sun4sol2)
+		basic_machine=sparc-sun
+		os=-solaris2
+		;;
+	sun3 | sun3-*)
+		basic_machine=m68k-sun
+		;;
+	sun4)
+		basic_machine=sparc-sun
+		;;
+	sun386 | sun386i | roadrunner)
+		basic_machine=i386-sun
+		;;
+	sv1)
+		basic_machine=sv1-cray
+		os=-unicos
+		;;
+	symmetry)
+		basic_machine=i386-sequent
+		os=-dynix
+		;;
+	t3e)
+		basic_machine=alphaev5-cray
+		os=-unicos
+		;;
+	t90)
+		basic_machine=t90-cray
+		os=-unicos
+		;;
+	tic54x | c54x*)
+		basic_machine=tic54x-unknown
+		os=-coff
+		;;
+	tic55x | c55x*)
+		basic_machine=tic55x-unknown
+		os=-coff
+		;;
+	tic6x | c6x*)
+		basic_machine=tic6x-unknown
+		os=-coff
+		;;
+	tx39)
+		basic_machine=mipstx39-unknown
+		;;
+	tx39el)
+		basic_machine=mipstx39el-unknown
+		;;
+	toad1)
+		basic_machine=pdp10-xkl
+		os=-tops20
+		;;
+	tower | tower-32)
+		basic_machine=m68k-ncr
+		;;
+	udi29k)
+		basic_machine=a29k-amd
+		os=-udi
+		;;
+	ultra3)
+		basic_machine=a29k-nyu
+		os=-sym1
+		;;
+	v810 | necv810)
+		basic_machine=v810-nec
+		os=-none
+		;;
+	vaxv)
+		basic_machine=vax-dec
+		os=-sysv
+		;;
+	vms)
+		basic_machine=vax-dec
+		os=-vms
+		;;
+	vpp*|vx|vx-*)
+		basic_machine=f301-fujitsu
+		;;
+	vxworks960)
+		basic_machine=i960-wrs
+		os=-vxworks
+		;;
+	vxworks68)
+		basic_machine=m68k-wrs
+		os=-vxworks
+		;;
+	vxworks29k)
+		basic_machine=a29k-wrs
+		os=-vxworks
+		;;
+	w65*)
+		basic_machine=w65-wdc
+		os=-none
+		;;
+	w89k-*)
+		basic_machine=hppa1.1-winbond
+		os=-proelf
+		;;
+	xps | xps100)
+		basic_machine=xps100-honeywell
+		;;
+	ymp)
+		basic_machine=ymp-cray
+		os=-unicos
+		;;
+	z8k-*-coff)
+		basic_machine=z8k-unknown
+		os=-sim
+		;;
+	none)
+		basic_machine=none-none
+		os=-none
+		;;
+
+# Here we handle the default manufacturer of certain CPU types.  It is in
+# some cases the only manufacturer, in others, it is the most popular.
+	w89k)
+		basic_machine=hppa1.1-winbond
+		;;
+	op50n)
+		basic_machine=hppa1.1-oki
+		;;
+	op60c)
+		basic_machine=hppa1.1-oki
+		;;
+	romp)
+		basic_machine=romp-ibm
+		;;
+	rs6000)
+		basic_machine=rs6000-ibm
+		;;
+	vax)
+		basic_machine=vax-dec
+		;;
+	pdp10)
+		# there are many clones, so DEC is not a safe bet
+		basic_machine=pdp10-unknown
+		;;
+	pdp11)
+		basic_machine=pdp11-dec
+		;;
+	we32k)
+		basic_machine=we32k-att
+		;;
+	sh3 | sh4 | sh[34]eb | sh[1234]le | sh[23]ele)
+		basic_machine=sh-unknown
+		;;
+	sh64)
+		basic_machine=sh64-unknown
+		;;
+	sparc | sparcv9 | sparcv9b)
+		basic_machine=sparc-sun
+		;;
+	cydra)
+		basic_machine=cydra-cydrome
+		;;
+	orion)
+		basic_machine=orion-highlevel
+		;;
+	orion105)
+		basic_machine=clipper-highlevel
+		;;
+	mac | mpw | mac-mpw)
+		basic_machine=m68k-apple
+		;;
+	pmac | pmac-mpw)
+		basic_machine=powerpc-apple
+		;;
+	*-unknown)
+		# Make sure to match an already-canonicalized machine name.
+		;;
+	*)
+		echo Invalid configuration \`$1\': machine \`$basic_machine\' not recognized 1>&2
+		exit 1
+		;;
+esac
+
+# Here we canonicalize certain aliases for manufacturers.
+case $basic_machine in
+	*-digital*)
+		basic_machine=`echo $basic_machine | sed 's/digital.*/dec/'`
+		;;
+	*-commodore*)
+		basic_machine=`echo $basic_machine | sed 's/commodore.*/cbm/'`
+		;;
+	*)
+		;;
+esac
+
+# Decode manufacturer-specific aliases for certain operating systems.
+
+if [ x"$os" != x"" ]
+then
+case $os in
+        # First match some system type aliases
+        # that might get confused with valid system types.
+	# -solaris* is a basic system type, with this one exception.
+	-solaris1 | -solaris1.*)
+		os=`echo $os | sed -e 's|solaris1|sunos4|'`
+		;;
+	-solaris)
+		os=-solaris2
+		;;
+	-svr4*)
+		os=-sysv4
+		;;
+	-unixware*)
+		os=-sysv4.2uw
+		;;
+	-gnu/linux*)
+		os=`echo $os | sed -e 's|gnu/linux|linux-gnu|'`
+		;;
+	# First accept the basic system types.
+	# The portable systems comes first.
+	# Each alternative MUST END IN A *, to match a version number.
+	# -sysv* is not here because it comes later, after sysvr4.
+	-gnu* | -bsd* | -mach* | -minix* | -genix* | -ultrix* | -irix* \
+	      | -*vms* | -sco* | -esix* | -isc* | -aix* | -sunos | -sunos[34]*\
+	      | -hpux* | -unos* | -osf* | -luna* | -dgux* | -solaris* | -sym* \
+	      | -amigaos* | -amigados* | -msdos* | -newsos* | -unicos* | -aof* \
+	      | -aos* \
+	      | -nindy* | -vxsim* | -vxworks* | -ebmon* | -hms* | -mvs* \
+	      | -clix* | -riscos* | -uniplus* | -iris* | -rtu* | -xenix* \
+	      | -hiux* | -386bsd* | -netbsd* | -openbsd* | -freebsd* | -riscix* \
+	      | -lynxos* | -bosx* | -nextstep* | -cxux* | -aout* | -elf* | -oabi* \
+	      | -ptx* | -coff* | -ecoff* | -winnt* | -domain* | -vsta* \
+	      | -udi* | -eabi* | -lites* | -ieee* | -go32* | -aux* \
+	      | -chorusos* | -chorusrdb* \
+	      | -cygwin* | -pe* | -psos* | -moss* | -proelf* | -rtems* \
+	      | -mingw32* | -linux-gnu* | -uxpv* | -beos* | -mpeix* | -udk* \
+	      | -interix* | -uwin* | -mks* | -rhapsody* | -darwin* | -opened* \
+	      | -openstep* | -oskit* | -conix* | -pw32* | -nonstopux* \
+	      | -storm-chaos* | -tops10* | -tenex* | -tops20* | -its* \
+	      | -os2* | -vos* | -palmos* | -uclinux* | -nucleus* \
+	      | -morphos* | -superux* | -rtmk* | -rtmk-nova* | -windiss* \
+	      | -powermax* | -dnix* | -nx6 | -nx7 | -sei*)
+	# Remember, each alternative MUST END IN *, to match a version number.
+		;;
+	-qnx*)
+		case $basic_machine in
+		    x86-* | i*86-*)
+			;;
+		    *)
+			os=-nto$os
+			;;
+		esac
+		;;
+	-nto-qnx*)
+		;;
+	-nto*)
+		os=`echo $os | sed -e 's|nto|nto-qnx|'`
+		;;
+	-sim | -es1800* | -hms* | -xray | -os68k* | -none* | -v88r* \
+	      | -windows* | -osx | -abug | -netware* | -os9* | -beos* \
+	      | -macos* | -mpw* | -magic* | -mmixware* | -mon960* | -lnews*)
+		;;
+	-mac*)
+		os=`echo $os | sed -e 's|mac|macos|'`
+		;;
+	-linux*)
+		os=`echo $os | sed -e 's|linux|linux-gnu|'`
+		;;
+	-sunos5*)
+		os=`echo $os | sed -e 's|sunos5|solaris2|'`
+		;;
+	-sunos6*)
+		os=`echo $os | sed -e 's|sunos6|solaris3|'`
+		;;
+	-opened*)
+		os=-openedition
+		;;
+	-wince*)
+		os=-wince
+		;;
+	-osfrose*)
+		os=-osfrose
+		;;
+	-osf*)
+		os=-osf
+		;;
+	-utek*)
+		os=-bsd
+		;;
+	-dynix*)
+		os=-bsd
+		;;
+	-acis*)
+		os=-aos
+		;;
+	-atheos*)
+		os=-atheos
+		;;
+	-386bsd)
+		os=-bsd
+		;;
+	-ctix* | -uts*)
+		os=-sysv
+		;;
+	-nova*)
+		os=-rtmk-nova
+		;;
+	-ns2 )
+		os=-nextstep2
+		;;
+	-nsk*)
+		os=-nsk
+		;;
+	# Preserve the version number of sinix5.
+	-sinix5.*)
+		os=`echo $os | sed -e 's|sinix|sysv|'`
+		;;
+	-sinix*)
+		os=-sysv4
+		;;
+	-triton*)
+		os=-sysv3
+		;;
+	-oss*)
+		os=-sysv3
+		;;
+	-svr4)
+		os=-sysv4
+		;;
+	-svr3)
+		os=-sysv3
+		;;
+	-sysvr4)
+		os=-sysv4
+		;;
+	# This must come after -sysvr4.
+	-sysv*)
+		;;
+	-ose*)
+		os=-ose
+		;;
+	-es1800*)
+		os=-ose
+		;;
+	-xenix)
+		os=-xenix
+		;;
+	-*mint | -mint[0-9]* | -*MiNT | -MiNT[0-9]*)
+		os=-mint
+		;;
+	-aros*)
+		os=-aros
+		;;
+	-kaos*)
+		os=-kaos
+		;;
+	-none)
+		;;
+	*)
+		# Get rid of the `-' at the beginning of $os.
+		os=`echo $os | sed 's/[^-]*-//'`
+		echo Invalid configuration \`$1\': system \`$os\' not recognized 1>&2
+		exit 1
+		;;
+esac
+else
+
+# Here we handle the default operating systems that come with various machines.
+# The value should be what the vendor currently ships out the door with their
+# machine or put another way, the most popular os provided with the machine.
+
+# Note that if you're going to try to match "-MANUFACTURER" here (say,
+# "-sun"), then you have to tell the case statement up towards the top
+# that MANUFACTURER isn't an operating system.  Otherwise, code above
+# will signal an error saying that MANUFACTURER isn't an operating
+# system, and we'll never get to this point.
+
+case $basic_machine in
+	*-acorn)
+		os=-riscix1.2
+		;;
+	arm*-rebel)
+		os=-linux
+		;;
+	arm*-semi)
+		os=-aout
+		;;
+    c4x-* | tic4x-*)
+        os=-coff
+        ;;
+	# This must come before the *-dec entry.
+	pdp10-*)
+		os=-tops20
+		;;
+	pdp11-*)
+		os=-none
+		;;
+	*-dec | vax-*)
+		os=-ultrix4.2
+		;;
+	m68*-apollo)
+		os=-domain
+		;;
+	i386-sun)
+		os=-sunos4.0.2
+		;;
+	m68000-sun)
+		os=-sunos3
+		# This also exists in the configure program, but was not the
+		# default.
+		# os=-sunos4
+		;;
+	m68*-cisco)
+		os=-aout
+		;;
+	mips*-cisco)
+		os=-elf
+		;;
+	mips*-*)
+		os=-elf
+		;;
+	or32-*)
+		os=-coff
+		;;
+	*-tti)	# must be before sparc entry or we get the wrong os.
+		os=-sysv3
+		;;
+	sparc-* | *-sun)
+		os=-sunos4.1.1
+		;;
+	*-be)
+		os=-beos
+		;;
+	*-ibm)
+		os=-aix
+		;;
+	*-wec)
+		os=-proelf
+		;;
+	*-winbond)
+		os=-proelf
+		;;
+	*-oki)
+		os=-proelf
+		;;
+	*-hp)
+		os=-hpux
+		;;
+	*-hitachi)
+		os=-hiux
+		;;
+	i860-* | *-att | *-ncr | *-altos | *-motorola | *-convergent)
+		os=-sysv
+		;;
+	*-cbm)
+		os=-amigaos
+		;;
+	*-dg)
+		os=-dgux
+		;;
+	*-dolphin)
+		os=-sysv3
+		;;
+	m68k-ccur)
+		os=-rtu
+		;;
+	m88k-omron*)
+		os=-luna
+		;;
+	*-next )
+		os=-nextstep
+		;;
+	*-sequent)
+		os=-ptx
+		;;
+	*-crds)
+		os=-unos
+		;;
+	*-ns)
+		os=-genix
+		;;
+	i370-*)
+		os=-mvs
+		;;
+	*-next)
+		os=-nextstep3
+		;;
+	*-gould)
+		os=-sysv
+		;;
+	*-highlevel)
+		os=-bsd
+		;;
+	*-encore)
+		os=-bsd
+		;;
+	*-sgi)
+		os=-irix
+		;;
+	*-siemens)
+		os=-sysv4
+		;;
+	*-masscomp)
+		os=-rtu
+		;;
+	f30[01]-fujitsu | f700-fujitsu)
+		os=-uxpv
+		;;
+	*-rom68k)
+		os=-coff
+		;;
+	*-*bug)
+		os=-coff
+		;;
+	*-apple)
+		os=-macos
+		;;
+	*-atari*)
+		os=-mint
+		;;
+	*)
+		os=-none
+		;;
+esac
+fi
+
+# Here we handle the case where we know the os, and the CPU type, but not the
+# manufacturer.  We pick the logical manufacturer.
+vendor=unknown
+case $basic_machine in
+	*-unknown)
+		case $os in
+			-riscix*)
+				vendor=acorn
+				;;
+			-sunos*)
+				vendor=sun
+				;;
+			-aix*)
+				vendor=ibm
+				;;
+			-beos*)
+				vendor=be
+				;;
+			-hpux*)
+				vendor=hp
+				;;
+			-mpeix*)
+				vendor=hp
+				;;
+			-hiux*)
+				vendor=hitachi
+				;;
+			-unos*)
+				vendor=crds
+				;;
+			-dgux*)
+				vendor=dg
+				;;
+			-luna*)
+				vendor=omron
+				;;
+			-genix*)
+				vendor=ns
+				;;
+			-mvs* | -opened*)
+				vendor=ibm
+				;;
+			-ptx*)
+				vendor=sequent
+				;;
+			-vxsim* | -vxworks* | -windiss*)
+				vendor=wrs
+				;;
+			-aux*)
+				vendor=apple
+				;;
+			-hms*)
+				vendor=hitachi
+				;;
+			-mpw* | -macos*)
+				vendor=apple
+				;;
+			-*mint | -mint[0-9]* | -*MiNT | -MiNT[0-9]*)
+				vendor=atari
+				;;
+			-vos*)
+				vendor=stratus
+				;;
+		esac
+		basic_machine=`echo $basic_machine | sed "s/unknown/$vendor/"`
+		;;
+esac
+
+echo $basic_machine$os
+exit 0
+
+# Local variables:
+# eval: (add-hook 'write-file-hooks 'time-stamp)
+# time-stamp-start: "timestamp='"
+# time-stamp-format: "%:y-%02m-%02d"
+# time-stamp-end: "'"
+# End:
/cvs/dm/dmraid/autoconf/install-sh,v  -->  standard output
revision 1.1
--- dmraid/autoconf/install-sh
+++ -	2008-02-22 16:57:38.022902000 +0000
@@ -0,0 +1,286 @@
+#!/bin/sh
+# install - install a program, script, or datafile
+
+scriptversion=2003-06-13.21
+
+# This originates from X11R5 (mit/util/scripts/install.sh), which was
+# later released in X11R6 (xc/config/util/install.sh) with the
+# following copyright and license.
+#
+# Copyright (C) 1994 X Consortium
+#
+# Permission is hereby granted, free of charge, to any person obtaining a copy
+# of this software and associated documentation files (the "Software"), to
+# deal in the Software without restriction, including without limitation the
+# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+# sell copies of the Software, and to permit persons to whom the Software is
+# furnished to do so, subject to the following conditions:
+#
+# The above copyright notice and this permission notice shall be included in
+# all copies or substantial portions of the Software.
+#
+# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
+# X CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
+# AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNEC-
+# TION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+#
+# Except as contained in this notice, the name of the X Consortium shall not
+# be used in advertising or otherwise to promote the sale, use or other deal-
+# ings in this Software without prior written authorization from the X Consor-
+# tium.
+#
+#
+# FSF changes to this file are in the public domain.
+#
+# Calling this script install-sh is preferred over install.sh, to prevent
+# `make' implicit rules from creating a file called install from it
+# when there is no Makefile.
+#
+# This script is compatible with the BSD install script, but was written
+# from scratch.  It can only install one file at a time, a restriction
+# shared with many OS's install programs.
+
+# set DOITPROG to echo to test this script
+
+# Don't use :- since 4.3BSD and earlier shells don't like it.
+doit="${DOITPROG-}"
+
+# put in absolute paths if you don't have them in your path; or use env. vars.
+
+mvprog="${MVPROG-mv}"
+cpprog="${CPPROG-cp}"
+chmodprog="${CHMODPROG-chmod}"
+chownprog="${CHOWNPROG-chown}"
+chgrpprog="${CHGRPPROG-chgrp}"
+stripprog="${STRIPPROG-strip}"
+rmprog="${RMPROG-rm}"
+mkdirprog="${MKDIRPROG-mkdir}"
+
+transformbasename=
+transform_arg=
+instcmd="$mvprog"
+chmodcmd="$chmodprog 0755"
+chowncmd=
+chgrpcmd=
+stripcmd=
+rmcmd="$rmprog -f"
+mvcmd="$mvprog"
+src=
+dst=
+dir_arg=
+
+usage="Usage: $0 [OPTION]... SRCFILE DSTFILE
+   or: $0 -d DIR1 DIR2...
+
+In the first form, install SRCFILE to DSTFILE, removing SRCFILE by default.
+In the second, create the directory path DIR.
+
+Options:
+-b=TRANSFORMBASENAME
+-c         copy source (using $cpprog) instead of moving (using $mvprog).
+-d         create directories instead of installing files.
+-g GROUP   $chgrp installed files to GROUP.
+-m MODE    $chmod installed files to MODE.
+-o USER    $chown installed files to USER.
+-s         strip installed files (using $stripprog).
+-t=TRANSFORM
+--help     display this help and exit.
+--version  display version info and exit.
+
+Environment variables override the default commands:
+  CHGRPPROG CHMODPROG CHOWNPROG CPPROG MKDIRPROG MVPROG RMPROG STRIPPROG
+"
+
+while test -n "$1"; do
+  case $1 in
+    -b=*) transformbasename=`echo $1 | sed 's/-b=//'`
+        shift
+        continue;;
+
+    -c) instcmd=$cpprog
+        shift
+        continue;;
+
+    -d) dir_arg=true
+        shift
+        continue;;
+
+    -g) chgrpcmd="$chgrpprog $2"
+        shift
+        shift
+        continue;;
+
+    --help) echo "$usage"; exit 0;;
+
+    -m) chmodcmd="$chmodprog $2"
+        shift
+        shift
+        continue;;
+
+    -o) chowncmd="$chownprog $2"
+        shift
+        shift
+        continue;;
+
+    -s) stripcmd=$stripprog
+        shift
+        continue;;
+
+    -t=*) transformarg=`echo $1 | sed 's/-t=//'`
+        shift
+        continue;;
+
+    --version) echo "$0 $scriptversion"; exit 0;;
+
+    *)  if test -z "$src"; then
+          src=$1
+        else
+          # this colon is to work around a 386BSD /bin/sh bug
+          :
+          dst=$1
+        fi
+        shift
+        continue;;
+  esac
+done
+
+if test -z "$src"; then
+  echo "$0: no input file specified." >&2
+  exit 1
+fi
+
+if test -n "$dir_arg"; then
+  dst=$src
+  src=
+
+  if test -d "$dst"; then
+    instcmd=:
+    chmodcmd=
+  else
+    instcmd=$mkdirprog
+  fi
+else
+  # Waiting for this to be detected by the "$instcmd $src $dsttmp" command
+  # might cause directories to be created, which would be especially bad
+  # if $src (and thus $dsttmp) contains '*'.
+  if test ! -f "$src" && test ! -d "$src"; then
+    echo "$0: $src does not exist." >&2
+    exit 1
+  fi
+
+  if test -z "$dst"; then
+    echo "$0: no destination specified." >&2
+    exit 1
+  fi
+
+  # If destination is a directory, append the input filename; won't work
+  # if double slashes aren't ignored.
+  if test -d "$dst"; then
+    dst=$dst/`basename "$src"`
+  fi
+fi
+
+## this sed command emulates the dirname command
+dstdir=`echo "$dst" | sed -e 's,[^/]*$,,;s,/$,,;s,^$,.,'`
+
+# Make sure that the destination directory exists.
+# (this part is taken from Noah Friedman's mkinstalldirs script.)
+
+# Skip lots of stat calls in the usual case.
+if test ! -d "$dstdir"; then
+  defaultIFS='
+	'
+  IFS="${IFS-$defaultIFS}"
+
+  oIFS=$IFS
+  # Some sh's can't handle IFS=/ for some reason.
+  IFS='%'
+  set - `echo "$dstdir" | sed -e 's@/@%@g' -e 's@^%@/@'`
+  IFS=$oIFS
+
+  pathcomp=
+
+  while test $# -ne 0 ; do
+    pathcomp=$pathcomp$1
+    shift
+    test -d "$pathcomp" || $mkdirprog "$pathcomp"
+    pathcomp=$pathcomp/
+  done
+fi
+
+if test -n "$dir_arg"; then
+  $doit $instcmd "$dst" \
+    && { test -z "$chowncmd" || $doit $chowncmd "$dst"; } \
+    && { test -z "$chgrpcmd" || $doit $chgrpcmd "$dst"; } \
+    && { test -z "$stripcmd" || $doit $stripcmd "$dst"; } \
+    && { test -z "$chmodcmd" || $doit $chmodcmd "$dst"; }
+
+else
+  # If we're going to rename the final executable, determine the name now.
+  if test -z "$transformarg"; then
+    dstfile=`basename "$dst"`
+  else
+    dstfile=`basename "$dst" $transformbasename \
+             | sed $transformarg`$transformbasename
+  fi
+
+  # don't allow the sed command to completely eliminate the filename.
+  test -z "$dstfile" && dstfile=`basename "$dst"`
+
+  # Make a couple of temp file names in the proper directory.
+  dsttmp=$dstdir/_inst.$$_
+  rmtmp=$dstdir/_rm.$$_
+
+  # Trap to clean up those temp files at exit.
+  trap 'status=$?; rm -f "$dsttmp" "$rmtmp" && exit $status' 0
+  trap '(exit $?); exit' 1 2 13 15
+
+  # Move or copy the file name to the temp name
+  $doit $instcmd "$src" "$dsttmp" &&
+
+  # and set any options; do chmod last to preserve setuid bits.
+  #
+  # If any of these fail, we abort the whole thing.  If we want to
+  # ignore errors from any of these, just make sure not to ignore
+  # errors from the above "$doit $instcmd $src $dsttmp" command.
+  #
+  { test -z "$chowncmd" || $doit $chowncmd "$dsttmp"; } \
+    && { test -z "$chgrpcmd" || $doit $chgrpcmd "$dsttmp"; } \
+    && { test -z "$stripcmd" || $doit $stripcmd "$dsttmp"; } \
+    && { test -z "$chmodcmd" || $doit $chmodcmd "$dsttmp"; } &&
+
+  # Now remove or move aside any old file at destination location.  We
+  # try this two ways since rm can't unlink itself on some systems and
+  # the destination file might be busy for other reasons.  In this case,
+  # the final cleanup might fail but the new file should still install
+  # successfully.
+  {
+    if test -f "$dstdir/$dstfile"; then
+      $doit $rmcmd -f "$dstdir/$dstfile" 2>/dev/null \
+      || $doit $mvcmd -f "$dstdir/$dstfile" "$rmtmp" 2>/dev/null \
+      || {
+	  echo "$0: cannot unlink or rename $dstdir/$dstfile" >&2
+	  (exit 1); exit
+      }
+    else
+      :
+    fi
+  } &&
+
+  # Now rename the file to the real destination.
+  $doit $mvcmd "$dsttmp" "$dstdir/$dstfile"
+fi &&
+
+# The final little trick to "correctly" pass the exit status to the exit trap.
+{
+  (exit 0); exit
+}
+
+# Local variables:
+# eval: (add-hook 'write-file-hooks 'time-stamp)
+# time-stamp-start: "scriptversion="
+# time-stamp-format: "%:y-%02m-%02d.%02H"
+# time-stamp-end: "$"
+# End:
/cvs/dm/dmraid/doc/dmraid_design.txt,v  -->  standard output
revision 1.1
--- dmraid/doc/dmraid_design.txt
+++ -	2008-02-22 16:57:38.128560000 +0000
@@ -0,0 +1,283 @@
+
+dmraid tool design document v1.0.0-rc5f		Heinz Mauelshagen 2004.11.05
+----------------------------------------------------------------------------
+
+The dmraid tool supports RAID devices (RDs) such as ATARAID with
+device-mapper (dm) in Linux 2.6 avoiding the need to install a
+vendor specific (binary) driver to access them.
+
+It supports multiple on-disk RAID metadata formats and is open for
+extension with new ones.
+
+Initially dmraid aims to support activation of RDs and doesn't support
+*updates* of the ondisk metadata (eg, to record disk failures)
+It can optionally erase on disk metadata in case of multiple format
+signatures on a device.
+
+See future enhancements at the end.
+
+
+Functional requirements:
+------------------------
+
+1. dmraid must be able to read multiple vendor specific ondisk
+   RAID metadata formats:
+
+   o ATARAID
+     - Highpoint 37x/45x
+     - Intel Software RAID
+     - LSI Logic MegaRaid
+     - Promise FastTrak
+     - Silicon Image Medley
+
+2. dmraid shall be open to future extensions by other ondisk RAID formats,
+   eg. SNIA DDF
+   (http://www.snia.org/tech_activities/ddftwg/DDFTrial-UseDraft_0_45.pdf)
+
+3. dmraid shall generate the necessary dm table(s) defining
+   the needed mappings to address the RAID data.
+
+4. Device discovery, activation, deactivation and
+   property display shall be supported.
+
+5. Spanning of disks, RAID0, RAID1 and RAID10 shall be supported
+   (in order to be able to support SNIA DDF, higher raid levels need
+    implementing in form of respective dm targets; eg, RAID5);
+   Some vendors do have support for RAID5 already which is outside the scope
+   of dmraid because of the lag of a RAID5 target in device-mapper!
+
+6. Activation of MSDOS partitions in RAID sets shall be supported.
+
+
+Feature set definition:
+-----------------------
+
+Feature set summarizes as: Discover, Activate, Deactivate, Display.
+
+
+o Discover (1-n RD)
+
+  1 scan active disk devices identifying RD.
+
+  2 try to find an RD signature and if recognized,
+    add the device to the list of RDs found.
+
+  3 Abstract the metadata describing the RD layout and translate the vendor
+    specific format into it.
+
+
+o Activate (1-n RD)
+
+  1 group devices into abstracted RAID sets (RS) conforming to
+    their respective layout (SPAN, RAID0, RAID1, RAID10).
+  
+  2 generate dm mapping tables for a/those RS(s) derived from the abstracted
+    information about RS(s) and RD(s).
+  
+  3 create multiple/a dm device(s) for each RS to activate and 
+    load the generated table(s) into the device.
+
+  4 Recusively discover and activate MSDOS partitions in active RAID sets.
+
+
+o Deactivate (1-n RD)
+
+  1 remove the dm device(s) making up an RS; can be a stacked hierachy of
+    devices (eg, RAID10: RAID1 on top of n RAID0 devices).
+
+
+o Display (1-n RD)
+
+  1 display RS and RD properties
+    (eg, display information kept with RS(s) such as size and type)
+
+
+
+Technical specification:
+------------------------
+
+All functions returning int or a pointer return 0/NULL on failure.
+
+o RAID metadata format handler
+
+  Tool calls the following function to register a vendor specific
+  format handler; in case of success, a new instance with methods is
+  accessible to the high level metadata handling functions (see below):
+
+  - int register_format_handler(struct lib_context *lc,
+				struct dmraid_format *fmt);
+
+    x returns !0 on successfull format handler registration
+
+  - Format handler methods:
+
+    x struct raid_dev *(read)(struct lib_context *lc, struct dev_info* di);
+
+      - returns 'struct raid_dev *' describing the RD (eg, offset, length)
+
+    x int (*write)(struct lib_context *lc, struct raid_dev* rd, int erase);
+
+      - returns != 0 successfully written the vendor specific metadata
+        back to the respective RD rd (optionally erasing the
+	metadata area(s) in case erase != 0)
+
+    x struct raid_set (*group)(struct lib_context *lc,
+				 struct raid_dev *raid_dev)
+
+      - returns pointer to RAID set structure on success
+
+    x int (*check)(struct lib_context *lc, struct raid_set *raid_set)
+
+      - returns != 0 in case raid set is consistent
+
+    x void (*log)(struct lib_context *lc, struct raid_dev *rd)
+
+      - display metadata in native format (ie. all vendor specific
+	metadata fields) for RD rd
+
+
+o Discover
+
+  1 retrieve block device information from sysfs for all disk
+    devices by scanning /SYSFS_MOUNTPOINT/block/[sh]d*;
+    keep information about the device path and size which is the base
+    to find the RAID signature on the device in a linked list
+    of type 'struct dev_info *'.
+
+  2 walk the list and try to read RD metadata signature off the device
+    trying vendor specific read methods (eg, Highpoint...) in turn;
+    library exposes interface to register format handlers for vendor
+    specific RAID formats in order to be open for future extensions
+    (see register_format_handler() above).
+
+    Tool calls the following high level function which hides
+    the iteration through all the registered format handler methods:
+
+    x void discover_devices(struct lib_context *lc)
+
+      - returns != 0 in case it discovered all supported disks (IDE, SCSI)
+	and added them to a list
+
+    x void discover_raid_devices(struct lib_context *lc,
+				 char **fmt_names,
+				 char **devices);
+
+      - discovers all suported RDs using the list filled by
+ 	discover_devices() and adds them to a list
+
+    x void discover_partitions(struct lib_context *lc);
+
+      - discovers all MSDOS partitions in active RAID sets and builds
+	RAID sets with one linear device hanging off for activation.
+
+    x int count_devices(struct lib_context *lc, enum dev_type type);
+
+      - returns number of devices found by discover_devices() and
+	discover_raid_devices() of specified type (eg, DEVICE, RAID, ...)
+
+    x int perform(struct lib_context *lc, char **argv);
+
+      - returns != 0 on success performing various actions
+	(ie. activation/deacivation of RAID sets, displaying properties, ...)
+
+o Activate 1
+
+    Tool calls the following high level function which hide
+    the details of the RAID set assembly:
+
+    x int group_set(struct lib_context *lc, char *name);
+
+      - returns != 0 on successfully grouping an RS/RSs
+
+o Activate 2+3
+
+  - don't activate non-RAID1 devices which have an invalid set check result
+    and display an error
+  - create the ASCII dm mapping table by iterating through the list
+    of RD in a particular set, retrieving the layout (SPAN, ...)
+    the device path, the offset into the device and the length to map
+    and the stripe size in case of RAID
+  - create a unique device_name
+  - call device-mapper library to create the mapped device and load
+    the mapping table using this function:
+
+    x int activate_set(struct lib_context *lc, void *rs)
+
+      - returns != 0 in case of successfull RAID set activation
+
+o Activate 4
+  - activate MSDOS partitioned RAID sets as in 2+3
+
+
+o Deactivate
+
+  - check if a partitioned RAID set is active and deactivate it first
+
+  - check if the RAID set is active and call device-mapper library to
+    remove the mapped device (recursively in case of a mapped-device hierarchy)
+    using this function:
+
+    x int deactivate_set(struct lib_context *lc, void *rs)
+
+      - returns != 0 in case of successfull RAID set deactivation
+
+
+o Display
+
+  - list all block devices found
+  - list all (in)active RD
+  - display properties of a particular/all RD devices
+    (eg, members of the set by block device name and offset/length mapped
+     to those...)
+
+    x void display_devices(struct lib_context *lc, enum dev_type type);
+
+      - display devices of dev_type 'type' (eg, RAID, DEVICE, ...)
+
+    x void display_set(struct lib_context *lc, void *rs,
+		       enum active_type type, int top);
+
+      - display RS of active_type 'type' (ACTIVE, INACTIVE, ALL)
+
+
+Code directory tree:
+--------------------
+
+dmraid ---/doc
+	+-/include
+	+-/lib ---/activate
+	|	|-/datastruct
+	|	|-/device
+	|	|-/display
+	|	|-/format ---/ataraid
+	|	|	   +-/partition
+	|	|          +-/template
+	|	|-/locking
+	|	|-/log
+	|	|-/misc
+	|	|-/metadata
+	|	+-/mm
+	+-/man
+	+-/tools
+
+
+Future enhancements:
+--------------------
+
+o enhance write support to update ondisk metadata
+  - to restore metadata backups
+  - to record disk failures
+
+o support to log state (eg, sector failures) in standard/vendor ondisk logs;
+  needs above write support
+
+o status daemon to monitor RAID set sanity
+  (eg, disk failure, hot spare rebuild, ...) and
+  frontend with CLI
+
+
+Open questions:
+---------------
+
+o do we need to prioritize on device-mapper targets for higher RAID levels
+  (in particular we'ld need RAID3+5 to support some ATARAID formats) ?
/cvs/dm/dmraid/include/Makefile.in,v  -->  standard output
revision 1.1
--- dmraid/include/Makefile.in
+++ -	2008-02-22 16:57:38.215747000 +0000
@@ -0,0 +1,31 @@
+#
+# Copyright (C) 2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+
+HEADERS=$(wildcard dmraid/*.h)
+
+all:
+
+include $(top_srcdir)/make.tmpl
+
+.PHONY: install_dmraid_headers remove_dmraid_headers
+
+install_dmraid_headers: $(HEADERS)
+	@echo "Installing $(HEADERS) in $(includedir)/dmraid"
+	mkdir -p $(includedir)/dmraid
+	$(INSTALL) $(STRIP) $(HEADERS) $(includedir)/dmraid
+
+install: install_dmraid_headers
+
+remove_dmraid_headers:
+	@echo "Removing $(HEADERS) from $(includedir)/dmraid"
+	rm -f $(includedir)/dmraid
+
+remove:        remove_dmraid_headers
+
+clean:
/cvs/dm/dmraid/include/dmraid/display.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/display.h
+++ -	2008-02-22 16:57:38.299803000 +0000
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _DISPLAY_H_
+#define _DISPLAY_H_
+
+enum dev_type {
+	DEVICE = 0x01,	/* ALL devices */
+	RAID   = 0x02,	/* RAID devices */
+	NATIVE = 0x04,	/* Native metadata of RAID devices */
+	SET    = 0x08,	/* RAID sets */
+};
+
+enum active_type {
+	D_ALL      = 0x01,	/* All devices */
+	D_ACTIVE   = 0x02,	/* Active devices only */
+	D_INACTIVE = 0x04,	/* Inactive devices only */
+};
+
+extern void display_devices(struct lib_context *lc, enum dev_type type);
+extern void display_set(struct lib_context *lc, void *rs,
+			enum active_type active, int top);
+extern void display_table(struct lib_context *lc, char *rs_name, char *table);
+extern int list_formats(struct lib_context *lc, int arg);
+
+#endif
/cvs/dm/dmraid/include/dmraid/dmraid.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/dmraid.h
+++ -	2008-02-22 16:57:38.384392000 +0000
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _DMRAID_H_
+#define _DMRAID_H_
+
+#include <stdint.h>
+#include <stdlib.h>
+#include <sys/types.h>
+
+/* FIXME: avoid more library internals. */
+#include <dmraid/lib_context.h>
+#include <dmraid/display.h>
+#include <dmraid/format.h>
+#include <dmraid/metadata.h>
+
+/*
+ * Library init/exit
+ */
+extern struct lib_context *libdmraid_init(int argc, char **argv);
+extern void libdmraid_exit(struct lib_context *lc);
+
+/*
+ * Retrieve version identifiers.
+ */
+extern int dm_version(struct lib_context *lc, char *version, size_t size);
+extern const char *libdmraid_date(struct lib_context *lc);
+extern const char *libdmraid_version(struct lib_context *lc);
+
+/*
+ * Dealing with formats.
+ */
+extern int check_valid_format(struct lib_context *lc, char *fmt);
+
+/*
+ * Dealing with devices.
+ */
+extern unsigned int count_devices(struct lib_context *lc, enum dev_type type);
+extern int discover_devices(struct lib_context *lc, char **devnodes);
+extern void discover_raid_devices(struct lib_context *lc, char **devices);
+extern void discover_partitions(struct lib_context *lc);
+
+/*
+ * Erase ondisk metadata.
+ */
+extern int erase_metadata(struct lib_context *lc);
+
+/*
+ * Dealing with RAID sets.
+ */
+extern const char *get_set_type(struct lib_context *lc, void *rs);
+extern const char *get_set_name(struct lib_context *lc, void *rs);
+extern int group_set(struct lib_context *lc, char *name);
+extern char *libdmraid_make_table(struct lib_context *lc, struct raid_set *rs);
+
+enum activate_type {
+	A_ACTIVATE,
+	A_DEACTIVATE,
+};
+
+extern void process_sets(struct lib_context *lc,
+			 int (*func)(struct lib_context *lc, void *rs, int arg),
+			 int arg, enum set_type type);
+extern int change_set(struct lib_context *lc, enum activate_type what,
+		      void *rs);
+
+/*
+ * Memory allocation
+ */
+#ifdef	DEBUG_MALLOC
+
+extern void *_dbg_malloc(size_t size, struct lib_context *lc,
+			 const char *who, unsigned int line);
+extern void *_dbg_realloc(void *ptr, size_t size, struct lib_context *lc,
+			  const char *who, unsigned int line);
+extern void *_dbg_strdup(void *ptr, struct lib_context *lc,
+			 const char *who, unsigned int line);
+extern void _dbg_free(void *ptr, struct lib_context *lc,
+		      const char *who, unsigned int line);
+
+#define	dbg_malloc(size)	_dbg_malloc((size), lc, __func__, __LINE__)
+#define	dbg_realloc(ptr, size)	_dbg_realloc((ptr), (size), lc, \
+					     __func__, __LINE__)
+#define	dbg_strdup(ptr)		_dbg_strdup((ptr), lc, __func__, __LINE__)
+#define	dbg_strndup(ptr, len)	_dbg_strndup((ptr), len, lc, __func__, __LINE__)
+#define	dbg_free(ptr)		_dbg_free((ptr), lc, __func__, __LINE__)
+
+#else
+
+extern void *_dbg_malloc(size_t size);
+extern void *_dbg_realloc(void *ptr, size_t size);
+extern void *_dbg_strdup(void *ptr);
+extern void *_dbg_strndup(void *ptr, size_t len);
+extern void _dbg_free(void *ptr);
+
+#define	dbg_malloc	_dbg_malloc
+#define	dbg_realloc	_dbg_realloc
+#define	dbg_strdup	_dbg_strdup
+#define	dbg_strndup	_dbg_strndup
+#define	dbg_free	_dbg_free
+
+#endif /* #ifdef DEBUG_MALLOC */
+
+#endif
/cvs/dm/dmraid/include/dmraid/format.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/format.h
+++ -	2008-02-22 16:57:38.468937000 +0000
@@ -0,0 +1,217 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_FORMAT_H_
+#define	_FORMAT_H_
+
+#ifdef FORMAT_HANDLER
+#undef FORMAT_HANDLER
+
+#include <sys/types.h>
+#include <dmraid/list.h>
+#include <dmraid/metadata.h>
+
+/* Metadata format handler types. */
+enum fmt_type {
+	FMT_RAID,
+	FMT_PARTITION,
+};
+
+/*
+ * Various structures for data whipped with the different event types.
+ */
+/* Event: I/O error */
+struct event_io {
+	struct raid_set *rs;	/* RAID set of I/O error. */
+	struct raid_dev *rd;	/* RAID device of I/O error. */
+	uint64_t sector;	/* Sector of the I/O error. */
+};
+
+/* Event: RAID device add/remove */
+enum rd_action {
+	rd_add,
+	rd_remove,
+};
+
+struct event_rd {
+	struct raid_set *rs;
+	struct raid_dev *rd;
+	enum rd_action	action;
+};
+
+/*
+ * List of event handler functions to call for the metadata format handler.
+ *
+ * Return 1 for event taken, RAID device write necessary.
+ * Return 0 for error and/or write unnecessary.
+ */
+struct event_handlers {
+	/* Handle IO error */
+	int (*io)(struct lib_context *lc, struct event_io *e_io);
+
+	/* Handle RAID device add/remove. */
+	int (*rd)(struct lib_context *lc, struct event_rd *e_rd);
+};
+
+/*
+ * Virtual interface definition of a metadata format handler.
+ */
+struct dmraid_format {
+	const char *name;	/* Format name */
+	const char *descr;	/* Format description */
+	const char *caps;	/* Capabilities (RAID levels supported) */
+	enum fmt_type format;	/* Format type (RAID, partition) */
+
+	/*
+	 * Read RAID metadata off a device and unify it.
+	 */
+	struct raid_dev* (*read)(struct lib_context *lc, struct dev_info* di);
+
+	/*
+	 * Write RAID metadata to a device deunifying it
+	 * or erase ondisk metadata if erase != 0.
+	 */
+	int (*write)(struct lib_context *lc, struct raid_dev* rd, int erase);
+
+	/*
+	 * Group a RAID device into a set.
+	 */
+	struct raid_set* (*group)(struct lib_context *lc, struct raid_dev *rd);
+
+	/*
+	 * Check consistency of the RAID set metadata.
+	 */
+	int (*check)(struct lib_context *lc, struct raid_set *rs);
+
+	/*
+	 * Event handlers (eg, I/O error).
+	 */
+	struct event_handlers *events;
+
+	/*
+	 * Display RAID disk metadata native.
+	 */
+	void (*log)(struct lib_context *lc, struct raid_dev *rd);
+};
+
+/* Chain of registered format handlers (needed for library context). */
+struct format_list {
+	struct list_head list;
+	struct dmraid_format *fmt;
+};
+
+int register_format_handlers(struct lib_context *lc);
+extern void unregister_format_handlers(struct lib_context *lc);
+
+
+/*
+ * Format core function used by (all) metadata format handlers.
+ */
+#define	NO_CHECK_RD	NULL
+extern int check_raid_set(struct lib_context *lc, struct raid_set *rs,
+			  unsigned int (*f_devices)(struct raid_dev *rd,
+						    void *context),
+			  void *f_devices_context,
+			  int (*f_check)(struct lib_context *lc,
+					 struct raid_set *rs,
+					 struct raid_dev *rd, void *context),
+			  void *f_check_context,
+			  const char *handler);
+extern int check_valid_format(struct lib_context *lc, char *fmt);
+extern int init_raid_set(struct lib_context *lc, struct raid_set *rs,
+			 struct raid_dev *rd, unsigned int stride,
+			 unsigned int type, const char *handler);
+extern const char **get_format_caps(struct lib_context *lc,
+				    struct dmraid_format *fmt);
+extern void free_format_caps(struct lib_context *lc, const char **caps);
+
+union read_info {
+	void *ptr;
+	uint32_t u32;
+	uint64_t u64;
+};
+
+struct raid_dev *read_raid_dev(
+	struct lib_context *lc,
+	struct dev_info *di,
+	void* (*f_read_metadata)(struct lib_context *lc, struct dev_info *di,
+				 size_t *size, uint64_t *offset,
+				 union read_info *info),
+	size_t size, uint64_t offset,
+	void (*f_to_cpu)(void *meta),
+	int (*f_is_meta)(struct lib_context *lc, struct dev_info *di,
+			 void *meta),
+	void (*f_file_metadata)(struct lib_context *lc, struct dev_info *di,
+				void *meta),
+	int (*f_setup_rd)(struct lib_context *lc, struct raid_dev *rd,
+			  struct dev_info *di, void *meta,
+			  union read_info *info),
+	const char *handler);
+
+extern void *alloc_meta_areas(struct lib_context *lc, struct raid_dev *rd,
+			      const char *who, unsigned int n);
+extern void *alloc_private(struct lib_context *lc, const char *who,
+			   size_t size);
+extern void *alloc_private_and_read(struct lib_context *lc, const char *who,
+				    size_t size, char *path, loff_t offset);
+extern struct raid_set *join_superset(
+	struct lib_context *lc,
+	char *(*f_name)(struct lib_context *lc, struct raid_dev *rd,
+			unsigned int subset),
+	void (*f_create)(struct raid_set *super, void *private),
+	int (*f_set_sort)(struct list_head *pos, struct list_head *new),
+	struct raid_set *rs, struct raid_dev *rd
+);
+extern int register_format_handler(struct lib_context *lc,
+				   struct dmraid_format *fmt);
+extern int write_metadata(struct lib_context *lc, const char *handler,
+			  struct raid_dev *rd, int meta_index, int erase);
+extern int log_zero_sectors(struct lib_context *lc, char *path,
+			    const char *handler);
+
+#define	to_disk	to_cpu
+
+#define struct_offset(s, member) ((unsigned short) &((struct s *) 0)->member)
+
+/* Print macros used in log methods. */
+
+/* Undefine this to avoid offsets in metadata logging. */
+#define	NATIVE_LOG_OFFSET
+#ifdef	NATIVE_LOG_OFFSET
+#define	P_FMT	"0x%03x "
+#define	P_OFF(x, basevar, y...) \
+	((unsigned long) &x - (unsigned long) basevar), y
+#else
+#define	P_FMT
+#define	P_OFF(x, basevar, y...)	y
+#endif
+
+#define	P(format, basevar, x, y...) \
+	do { log_print(lc, P_FMT format, P_OFF(x, basevar, y)); } while(0)
+
+#define	P2(format, basevar, i, x) \
+	do { P(format, basevar, x, i, x); } while(0)
+#define	DP(format, basevar, x) \
+	do { P(format, basevar, x, x); } while(0)
+
+/*
+ * RAID device, set and vendor metadata retrieval macros.
+ */
+#define	DEVS(rs)	(!list_empty(&((struct raid_set *) (rs))->devs))
+#define	SETS(rs)	(!list_empty(&((struct raid_set *) (rs))->sets))
+
+#define	META(rd, type)	((struct type*) ((struct raid_dev*) (rd))->meta_areas->area)
+#define	RD(pos)		(list_entry(pos, struct raid_dev, devs))
+#define	RS(pos)		(list_entry(pos, struct raid_set, list))
+#define RD_RS(rs)	(RD((((struct raid_set*) (rs))->devs.next)))
+#define RS_RS(rs)	((struct raid_set*) (rs)->sets.next)
+
+#define	HANDLER_LEN	sizeof(HANDLER)
+
+#endif /* ifdef FORMAT_HANDLER */
+
+#endif
/cvs/dm/dmraid/include/dmraid/lib_context.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/lib_context.h
+++ -	2008-02-22 16:57:38.559556000 +0000
@@ -0,0 +1,127 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _LIB_CONTEXT_H_
+#define _LIB_CONTEXT_H_
+
+#include <dmraid/list.h>
+#include <dmraid/locking.h>
+#include <dmraid/misc.h>
+
+enum lc_lists {
+	LC_FORMATS = 0,	/* Metadata format handlers. */
+	LC_DISK_INFOS,	/* Disks discovered. */
+	LC_RAID_DEVS,	/* Raid devices discovered. */
+	LC_RAID_SETS,	/* Raid sets grouped. */
+	/* Add new lists below here ! */
+	LC_LISTS_SIZE,	/* Must be the last enumerator. */
+};
+
+/* List access macros. */
+#define	LC_FMT(lc)	(lc_list((lc), LC_FORMATS))
+#define	LC_DI(lc)	(lc_list((lc), LC_DISK_INFOS))
+#define	LC_RD(lc)	(lc_list((lc), LC_RAID_DEVS))
+#define	LC_RS(lc)	(lc_list((lc), LC_RAID_SETS))
+
+enum lc_options {
+	LC_COLUMN = 0,
+	LC_DEBUG,
+	LC_DUMP,
+	LC_FORMAT,
+	LC_GROUP,
+	LC_SETS,
+	LC_TEST,
+	LC_VERBOSE,
+	LC_IGNORELOCKING,
+	LC_SEPARATOR,
+	LC_DEVICES,	  /* Add new options below this one ! */
+	LC_OPTIONS_SIZE,  /* Must be the last enumerator. */
+};
+
+/* Options access macros. */
+/* Return option counter. */
+#define	OPT_COLUMN(lc)		(lc_opt(lc, LC_COLUMN))
+#define	OPT_DEBUG(lc)		(lc_opt(lc, LC_DEBUG))
+#define	OPT_DEVICES(lc)		(lc_opt(lc, LC_DEVICES))
+#define	OPT_DUMP(lc)		(lc_opt(lc, LC_DUMP))
+#define	OPT_GROUP(lc)		(lc_opt(lc, LC_GROUP))
+#define	OPT_FORMAT(lc)		(lc_opt(lc, LC_FORMAT))
+#define	OPT_IGNORELOCKING(lc)	(lc_opt(lc, LC_IGNORELOCKING))
+#define	OPT_SEPARATOR(lc)	(lc_opt(lc, LC_SEPARATOR))
+#define	OPT_SETS(lc)		(lc_opt(lc, LC_SETS))
+#define	OPT_TEST(lc)		(lc_opt(lc, LC_TEST))
+#define	OPT_VERBOSE(lc)		(lc_opt(lc, LC_VERBOSE))
+
+/* Return option value. */
+#define	OPT_STR(lc, o)		(lc->options[o].arg.str)
+#define	OPT_STR_COLUMN(lc)	OPT_STR(lc, LC_COLUMN)
+#define	OPT_STR_FORMAT(lc)	OPT_STR(lc, LC_FORMAT)
+#define	OPT_STR_SEPARATOR(lc)	OPT_STR(lc, LC_SEPARATOR)
+
+struct lib_version {
+	const char *text;
+	const char *date;
+	struct {
+		unsigned int major;
+		unsigned int minor;
+		unsigned int sub_minor;
+		const char *suffix;
+	} v;
+};
+
+struct lib_options {
+	int opt;
+	union {
+		const char *str;
+		uint64_t u64;
+		uint64_t u32;
+	} arg;
+};
+
+struct lib_context {
+	struct lib_version version;
+	char *cmd;
+
+	/* Option counters used throughout the library. */
+	struct lib_options options[LC_OPTIONS_SIZE];
+
+	/*
+	 * Lists for:
+	 *
+	 *	o metadata format handlers the library supports
+	 * 	o block devices discovered
+	 * 	o RAID devices discovered
+	 * 	o RAID sets grouped
+	 */
+	struct list_head lists[LC_LISTS_SIZE];
+
+	char *locking_name;		/* Locking mechanism selector. */
+	struct	locking *lock;		/* Resource locking. */
+
+	mode_t	mode;			/* File/directrory create modes. */
+
+	struct {
+		const char *error;	/* For error mappings. */
+	} path;
+};
+
+extern struct lib_context *alloc_lib_context(char **argv);
+extern void free_lib_context(struct lib_context *lc);
+extern int lc_opt(struct lib_context *lc, enum lc_options o);
+const char *lc_opt_arg(struct lib_context *lc, enum lc_options o);
+const char *lc_stralloc_opt(struct lib_context *lc, enum lc_options o,
+			   char *arg);
+const char *lc_strcat_opt(struct lib_context *lc, enum lc_options o,
+			  char *arg, const char delim);
+extern int lc_inc_opt(struct lib_context *lc, int o);
+extern struct list_head *lc_list(struct lib_context *lc, int l);
+
+extern const char *libdmraid_date(struct lib_context *lc);
+extern const char *libdmraid_version(struct lib_context *lc);
+
+
+#endif
/cvs/dm/dmraid/include/dmraid/list.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/list.h
+++ -	2008-02-22 16:57:38.647160000 +0000
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _LIST_H
+#define _LIST_H
+
+/*
+ * Double-linked list definitons and macros.
+ */
+
+struct list_head {
+	struct list_head *next;
+	struct list_head *prev;
+};
+
+#define INIT_LIST_HEAD(a)	do { (a)->next = (a)->prev = a; } while(0)
+
+#define list_empty(pos)	((pos)->next == pos)
+
+static inline void __list_add(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	prev->next = new;
+}
+
+/* Add an element 'new' after position 'pos' to a list. */
+#define list_add(new, pos)	__list_add(new, pos, (pos)->next)
+
+/* Add an element 'new' before position 'pos' to a list. */
+#define list_add_tail(new, pos)	__list_add(new, (pos)->prev, pos)
+
+/* Delete an element 'pos' from the list. */
+#define	list_del(pos) { \
+	(pos)->next->prev = (pos)->prev; \
+	(pos)->prev->next = (pos)->next; \
+	(pos)->next = (pos)->prev = 0; \
+}
+
+/* Pointer to a struct 'type' derived from 'pos' and list_head* 'member'. */
+#define list_entry(pos, type, member) \
+	((type*) ((char*)pos - (unsigned long)(&((type*)0)->member)))
+
+/* Walk a list. */
+#define list_for_each(pos, head) \
+	for (pos = (head)->next; pos != head; pos = pos->next)
+
+/* Walk a list by entry. */
+#define list_for_each_entry(entry, head, member) \
+        for (entry = list_entry((head)->next, typeof(*entry), member); \
+             &entry->member != (head); \
+             entry = list_entry(entry->member.next, typeof(*entry), member))
+
+/*
+ * Walk a list using a temporary pointer,
+ * so that elements can be deleted safely.
+ */
+#define list_for_each_safe(pos, n, head) \
+        for (pos = (head)->next, n = pos->next; \
+             pos != (head); \
+             pos = n, n = pos->next)
+
+#endif
/cvs/dm/dmraid/include/dmraid/locking.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/locking.h
+++ -	2008-02-22 16:57:38.727484000 +0000
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_LOCKING_H
+#define	_LOCKING_H
+
+/* I want to be prepared for finer grained locking... */
+struct resource {
+	char *name;
+};
+
+/* Locking abstraction. */
+struct lib_context;
+struct locking {
+	const char *name;
+	int (*lock)(struct lib_context *lc, struct resource *res);
+	void (*unlock)(struct lib_context *lc, struct resource *res);
+	void *private; /* Private context. */
+};
+
+extern int init_locking(struct lib_context *lc);
+extern int lock_resource(struct lib_context *lc, struct resource *res);
+extern void unlock_resource(struct lib_context *lc, struct resource *res);
+
+#endif
/cvs/dm/dmraid/include/dmraid/metadata.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/metadata.h
+++ -	2008-02-22 16:57:38.809297000 +0000
@@ -0,0 +1,254 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_META_H_
+#define	_META_H_
+
+#include <dmraid/list.h>
+#include <stdint.h>
+
+/*
+ * Unified RAID set types.
+ */
+enum type {
+	t_undef     = 0x01,
+	t_group     = 0x02, /* To group subsets (eg, Intel Software RAID). */
+	t_partition = 0x04, /* FIXME: remove in favour of kpartx ? */
+	t_spare     = 0x08,
+	t_linear    = 0x10,
+	t_raid0     = 0x20,
+	t_raid1     = 0x40,
+	/*
+	 * Higher RAID types below not supported (yet)
+	 * because of device-mapper constraints.
+	 */
+	t_raid4     = 0x80,
+	t_raid5_ls  = 0x100,
+	t_raid5_rs  = 0x200,
+	t_raid5_la  = 0x400,
+	t_raid5_ra  = 0x800,
+	t_raid6     = 0x1000,
+};
+
+/* Check macros for types. */
+#define	T_UNDEF(r)	((r)->type & t_undef)
+#define	T_GROUP(r)	((r)->type & t_group)
+#define	T_PARTITION(r)	((r)->type & t_partition)
+#define	T_SPARE(r)	((r)->type & t_spare)
+#define	T_LINEAR(r)	((r)->type & t_linear)
+#define	T_RAID0(r)	((r)->type & t_raid0)
+#define	T_RAID1(r)	((r)->type & t_raid1)
+#define	T_RAID4(r)	((r)->type & t_raid4)
+#define	T_RAID5(r)	(((r)->type & t_raid5_ls) || \
+			((r)->type & t_raid5_rs) || \
+			((r)->type & t_raid5_la) || \
+			((r)->type & t_raid5_ra))
+#define	T_RAID6(r)	((r)->type & t_raid6)
+
+
+/* Types for count_devs(). */
+enum count_type {
+	ct_all = 0,
+	ct_dev,
+	ct_spare,
+};
+
+/*
+ * Mapping struct for RAID type unification.
+ *
+ * Format handler allocates an array and inserts mappings
+ * from format specific types to the unified ones above.
+ */
+struct types {
+	unsigned int type; /* Must be long enough for vendor definition. */
+	enum type    unified_type;
+};
+
+/* RAID disk/set status. */
+enum status {
+	s_undef		= 0x01,
+	s_broken	= 0x02,	/* Completely broken (not accessible). */
+	s_inconsistent	= 0x04,	/* RAID disk/set inconsistent (needs
+				   synchronization or reconfiguration). */
+	/* FIXME: is s_nosync sufficient or do I need s_upgrade (eg, NVidia) */
+	s_nosync	= 0x08,	/* RAID disk/set *not* in sync
+				   (needs synchronization). */
+	s_ok		= 0x10,	/* Fully operational. */
+	s_setup		= 0x20,	/* Only during RAID setup transition. */
+};
+
+/* Check macros for states. */
+#define	S_UNDEF(status)		((status) & s_undef)
+#define	S_BROKEN(status)	((status) & s_broken)
+#define	S_INCONSISTENT(status)	((status) & s_inconsistent)
+#define	S_NOSYNC(status)	((status) & s_nosync)
+#define	S_OK(status)		((status) & s_ok)
+#define	S_SETUP(status)		((status) & s_setup)
+
+
+/* find_*() function enums */
+enum find {
+	FIND_TOP,	/* Search top level RAID sets only. */
+	FIND_ALL,	/* Decend all RAID set trees. */
+};
+
+/* Device information. */
+struct dev_info {
+	struct list_head list;	/* Global chain of discovered devices. */
+
+	char *path;	  /* Actual device node path. */
+	char *serial;	  /* ATA/SCSI serial number. */
+	uint64_t sectors; /* Device size. */
+};
+
+/* Metadata areas and size stored on a RAID device. */
+struct meta_areas {
+	uint64_t	offset;	/* on disk metadata offset in sectors. */
+	size_t		size;	/* on disk metadata size in bytes. */
+	void		*area;	/* pointer to format specific metadata. */
+};
+
+/*
+ * Abstracted RAID device.
+ *
+ * A RAID device is a member of a RAID set and can only
+ * exist at the lowest level of a RAID set stack (eg, for RAID10).
+ */
+struct raid_dev {
+	struct list_head list;		/* Global chain of RAID devices. */
+	struct list_head devs;		/* Chain of devices belonging to set. */
+
+	char		*name;		/* Metadata format handler generated
+					   name of set this device belongs to.*/
+
+	struct dev_info  *di;		/* Pointer to dev_info. */
+	struct dmraid_format *fmt;	/* Format handler for this device. */
+
+	enum status status;		/* Status of device. */
+	enum type type;			/* Type of device. */
+
+	uint64_t	offset;		/* Data offset on device. */
+	uint64_t	sectors;	/* Length of the segment to map. */
+
+	unsigned int	areas;		/* # of metadata areas on the device. */
+	struct meta_areas *meta_areas;	/* Dynamic array of metadata areas. */
+
+	/*
+	 * For format handler use (eg, to keep references between calls).
+	 * 
+	 * WARNING: non pointer members need to get zeroed before exit,
+	 *	    because the metadata layer frees private->ptr on cleanup.
+	 */
+	union {
+		void *ptr;
+		uint32_t n32;
+		uint64_t n64;
+	} private;
+};
+
+/*
+ * Abstracted (hierarchical) RAID set.
+ *
+ * Can be used to form a tree of subsets with arbitrary depths.
+ * Defines RAID attributes for the set as a whole (eg: RAID0, Status).
+ */
+enum flags {
+	f_maximize	= 0x01,	/* If set, maximize set capacity,
+				   if not set, limit to smallest device. */
+	f_partitions	= 0x02,	/* Set has partitions. */
+};
+
+#define	F_MAXIMIZE(rs)		((rs)->flags & f_maximize)
+#define	F_PARTITIONS(rs)	((rs)->flags & f_partitions)
+
+struct raid_set {
+	struct list_head list;		/* Chain of independent sets. */
+
+	/*
+	 * List of subsets (eg, RAID10) which make up RAID set stacks.
+	 *
+	 * Lowest level identified by list_empty() here.
+	 */
+	struct list_head sets;
+
+	/*
+	 * List of RAID devices making up a set.
+	 *
+	 * Higher RAID sets in a stack will have list_empty() here.
+	 *
+	 * Lowest level will hold device definitions
+	 * for arbitrary block devices here.
+	 */
+	struct list_head devs;
+	unsigned int total_devs;	/* The number of devices expected */
+	unsigned int found_devs;	/* The number of devices found */
+
+	char *name;			/* Name of the set. */
+
+	unsigned int stride;		/* Stride size. */
+	enum type type;			/* Unified raid type. */
+	enum flags flags;		/* Set flags. */
+	enum status status;		/* Status of set. */
+};
+
+extern struct dmraid_format *get_format(struct raid_set *rs);
+extern const char *get_type(struct lib_context *lc, enum type type);
+extern const char *get_dm_type(struct lib_context *lc, enum type type);
+extern const char *get_set_type(struct lib_context *lc, void *rs);
+extern const char *get_status(struct lib_context *lc, enum status status);
+extern uint64_t total_sectors(struct lib_context *lc, struct raid_set *rs);
+extern struct dev_info *alloc_dev_info(struct lib_context *lc, char *path);
+extern void free_dev_info(struct lib_context *lc, struct dev_info *di);
+extern struct raid_dev *alloc_raid_dev(struct lib_context *lc, const char *who);
+extern void free_raid_dev(struct lib_context *lc, struct raid_dev **rd);
+extern void list_add_sorted(struct lib_context *lc,
+		     struct list_head *to, struct list_head *new,
+		     int (*sort)(struct list_head *pos,
+				 struct list_head *new));
+extern struct raid_set *alloc_raid_set(struct lib_context *lc, const char *who);
+extern unsigned int count_sets(struct lib_context *lc, struct list_head *list);
+extern unsigned int count_devs(struct lib_context *lc, struct raid_set *rs,
+			enum count_type type);
+extern void free_raid_set(struct lib_context *lc, struct raid_set *rs);
+extern struct raid_set *find_set(struct lib_context *lc, struct list_head *list,
+			  const char *name, enum find where);
+extern struct raid_set *find_or_alloc_raid_set(struct lib_context *lc,
+					char *name, enum find where,
+					struct raid_dev *rd,
+					struct list_head *list,
+					void (*create) (struct raid_set *super,
+							void *private),
+					void *private);
+#define	NO_RD		NULL
+#define	NO_LIST		NULL
+#define	NO_CREATE	NULL
+#define	NO_CREATE_ARG	NULL
+extern const char *get_set_name(struct lib_context *lc, void *rs);
+extern int group_set(struct lib_context *lc, char *name);
+
+enum set_type {
+	SETS,
+	PARTITIONS,
+};
+
+extern void process_sets(struct lib_context *lc,
+		  int (*func)(struct lib_context *lc, void *rs, int arg),
+		  int arg, enum set_type type);
+extern int write_set(struct lib_context *lc, void *rs);
+extern int partitioned_set(struct lib_context *lc, void *rs);
+extern int base_partitioned_set(struct lib_context *lc, void *rs);
+extern void discover_raid_devices(struct lib_context *lc, char **devices);
+extern void discover_partitions(struct lib_context *lc);
+extern unsigned int count_devices(struct lib_context *lc, enum dev_type type);
+extern enum type rd_type(struct types *types, unsigned int type);
+extern void file_metadata(struct lib_context *lc, const char *handler,
+		   char *path, void *data, size_t size, uint64_t offset);
+extern void file_dev_size(struct lib_context *lc, const char *handler,
+		   struct dev_info *di);
+extern int erase_metadata(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/include/dmraid/misc.h,v  -->  standard output
revision 1.1
--- dmraid/include/dmraid/misc.h
+++ -	2008-02-22 16:57:38.894256000 +0000
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _MISC_H_
+#define _MISC_H_
+
+extern struct lib_context *libdmraid_init(int argc, char **argv);
+extern void libdmraid_exit(struct lib_context *lc);
+
+extern void sysfs_workaround(struct lib_context *lc);
+extern void mk_alpha(struct lib_context *lc, char *str, size_t len);
+extern char *get_basename(struct lib_context *lc, char *str);
+extern char *get_dirname(struct lib_context *lc, char *str);
+extern char *remove_white_space(struct lib_context *lc, char *str, size_t len);
+extern char *remove_delimiter(char *ptr, char c);
+extern void add_delimiter(char **ptr, char c);
+
+extern int mk_dir(struct lib_context *lc, const char *dir);
+
+extern int read_file(struct lib_context *lc, const char *who, char *path,
+		     void *buffer, size_t size, loff_t offset);
+extern int write_file(struct lib_context *lc, const char *who, char *path,
+		      void *buffer, size_t size, loff_t offset);
+
+extern int yes_no_prompt(struct lib_context *lc, const char *prompt, ...);
+
+extern void free_string(struct lib_context *lc, char **string);
+extern int p_fmt(struct lib_context *lc, char **string, const char *fmt, ...);
+
+static inline uint64_t round_down(uint64_t what, unsigned int by)
+{
+	return what & ~((uint64_t) by - 1);
+}
+
+static inline uint64_t round_up(uint64_t what, unsigned int by)
+{
+	uint64_t t = round_down(what, by);
+
+	return t == what ? t : t + by;
+}
+
+static inline uint64_t div_up(uint64_t what, unsigned int by)
+{
+	return round_up(what, by) / by;
+}
+
+#endif
/cvs/dm/dmraid/lib/.export.sym,v  -->  standard output
revision 1.1
--- dmraid/lib/.export.sym
+++ -	2008-02-22 16:57:38.987669000 +0000
@@ -0,0 +1,51 @@
+Base {
+	global:
+		add_delimiter;
+		change_set;
+		check_valid_format;
+		collapse_delimiter;
+		count_devices;
+		count_devs;
+		count_sets;
+		_dbg_free;
+		_dbg_malloc;
+		_dbg_realloc;
+		_dbg_strdup;
+		discover_devices;
+		discover_partitions;
+		discover_raid_devices;
+		display_devices;
+		display_set;
+		dm_version;
+		erase_metadata;
+		find_set;
+		get_dm_type;
+		get_set_type;
+		get_set_name;
+		get_status;
+		get_type;
+		group_set;
+		init_locking;
+		lc_inc_opt;
+		lc_list;
+		lc_opt;
+		lc_stralloc_opt;
+		lc_strcat_opt;
+		libdmraid_exit;
+		libdmraid_init;
+		libdmraid_date;
+		libdmraid_version;
+		libdmraid_make_table;
+		list_formats;
+		lock_resource;
+		log_alloc_err;
+		plog;
+		process_sets;
+		remove_delimiter;
+		remove_white_space;
+		total_sectors;
+		unlock_resource;
+
+	local:
+		*;
+};
/cvs/dm/dmraid/lib/Makefile.in,v  -->  standard output
revision 1.1
--- dmraid/lib/Makefile.in
+++ -	2008-02-22 16:57:39.075357000 +0000
@@ -0,0 +1,89 @@
+#
+# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+
+SOURCES=\
+	activate/activate.c \
+	activate/devmapper.c \
+	device/ata.c \
+	device/scan.c \
+	device/scsi.c \
+	display/display.c \
+	format/format.c \
+	locking/locking.c \
+	log/log.c \
+	metadata/metadata.c \
+	misc/file.c \
+	misc/init.c \
+	misc/lib_context.c \
+	misc/misc.c \
+	misc/workaround.c \
+	mm/dbg_malloc.c \
+	format/ataraid/asr.c \
+	format/ataraid/hpt37x.c \
+	format/ataraid/hpt45x.c \
+	format/ataraid/isw.c \
+	format/ataraid/jm.c \
+	format/ataraid/lsi.c \
+	format/ataraid/nv.c \
+	format/ataraid/pdc.c \
+	format/ataraid/sil.c \
+	format/ataraid/via.c \
+	format/ataraid/asr.c \
+	format/partition/dos.c
+
+OBJECTS=$(SOURCES:%.c=%.o)
+
+LIB_STATIC=$(top_srcdir)/lib/libdmraid.a
+
+TARGETS=$(LIB_STATIC)
+INSTALL_TARGETS= $(LIB_STATIC)
+
+ifeq ("@KLIBC@", "no")
+  ifeq ("@LIB_SO@", "yes")
+    LIB_SHARED=$(top_srcdir)/lib/libdmraid.so
+    TARGETS += $(LIB_SHARED)
+    INSTALL_TARGETS += $(LIB_SHARED)
+  endif
+endif
+
+all:
+	@echo "$(TARGETS) $(INSTALL_TARGETS)"
+
+include $(top_srcdir)/make.tmpl
+
+.PHONY: install_dmraid_libs remove_dmraid_libs
+
+install_dmraid_libs: $(INSTALL_TARGETS)
+	@echo "Installing $(INSTALL_TARGETS) in $(libdir)"; \
+	mkdir -p $(libdir); \
+	for f in $(INSTALL_TARGETS); \
+	do \
+		n=$$(basename $${f}) ; \
+		if [[ "$$n" =~ '.so$$' ]]; then \
+			$(INSTALL) -m 555 $(STRIP) \
+				$$f $(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
+			$(LN_S) -f $${n}.@DMRAID_LIB_VERSION@ $(libdir)/$${n}; \
+		else \
+			$(INSTALL) -m 555 $(STRIP) $$f $(libdir)/$${n}; \
+		fi \
+	done
+
+install: install_dmraid_libs
+
+remove_dmraid_libs:
+	@echo "Removing $(INSTALL_TARGETS) from $(libdir)"; \
+	for f in $(INSTALL_TARGETS); \
+	do \
+		n=$$(basename $${f}) ; \
+		rm -f $(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
+		rm -f $(libdir)/$${n}; \
+	done
+
+remove:	remove_dmraid_libs
/cvs/dm/dmraid/lib/internal.h,v  -->  standard output
revision 1.1
--- dmraid/lib/internal.h
+++ -	2008-02-22 16:57:39.157284000 +0000
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_INTERNAL_H_
+#define	_INTERNAL_H_
+
+#ifndef _GNU_SOURCE
+#define _GNU_SORUCE
+#endif
+
+#include <ctype.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <dmraid/lib_context.h>
+#include <dmraid/list.h>
+#include <dmraid/locking.h>
+#include "log/log.h"
+#include "mm/dbg_malloc.h"
+#include <dmraid/misc.h>
+#include <dmraid/display.h>
+#include "device/dev-io.h"
+#define FORMAT_HANDLER
+#include <dmraid/format.h>
+#include <dmraid/metadata.h>
+#include "activate/activate.h"
+
+#ifndef	u_int16_t
+#define	u_int16_t	uint16_t
+#endif
+
+#ifndef	u_int32_t
+#define	u_int32_t	uint32_t
+#endif
+
+#ifndef	u_int64_t
+#define	u_int64_t	uint64_t
+#endif
+
+#define min(a, b) a < b ? a : b
+#define max(a, b) a > b ? a : b
+#define ARRAY_SIZE(a)   (sizeof(a) / sizeof(*a))
+#define ARRAY_END(a)   (a + ARRAY_SIZE(a))
+
+#endif
/cvs/dm/dmraid/lib/version.h,v  -->  standard output
revision 1.1
--- dmraid/lib/version.h
+++ -	2008-02-22 16:57:39.236706000 +0000
@@ -0,0 +1,12 @@
+#ifndef	DMRAID_LIB_VERSION
+
+#define	DMRAID_LIB_VERSION		"1.0.0.rc11"
+
+#define	DMRAID_LIB_MAJOR_VERSION	1
+#define	DMRAID_LIB_MINOR_VERSION	0
+#define	DMRAID_LIB_SUBMINOR_VERSION	0
+#define	DMRAID_LIB_VERSION_SUFFIX	"rc11"
+
+#define	DMRAID_LIB_DATE			"(2006.05.15)"
+
+#endif
/cvs/dm/dmraid/lib/activate/activate.c,v  -->  standard output
revision 1.1
--- dmraid/lib/activate/activate.c
+++ -	2008-02-22 16:57:39.319354000 +0000
@@ -0,0 +1,689 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Activate/Deactivate code for hierarchical RAID Sets.
+ */
+
+#include "internal.h"
+#include "devmapper.h"
+
+static int valid_rd(struct raid_dev *rd)
+{
+	return S_OK(rd->status) && !T_SPARE(rd);
+}
+
+static int valid_rs(struct raid_set *rs)
+{
+	return S_OK(rs->status) && !T_SPARE(rs);
+}
+
+/* Return rounded size in case of unbalanced mappings */
+static uint64_t maximize(struct raid_set *rs, uint64_t sectors,
+			 uint64_t last, uint64_t min)
+{
+	return sectors > min ? min(last, sectors) : last;
+}
+
+/* Find smallest set/disk larger than given minimum. */
+static uint64_t _smallest(struct lib_context *lc,
+			  struct raid_set *rs, uint64_t min)
+{
+	uint64_t ret = ~0;
+	struct raid_set *r;
+	struct raid_dev *rd;
+
+	list_for_each_entry(r, &rs->sets, list)
+		ret = maximize(r, total_sectors(lc, r), ret, min);
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (!T_SPARE(rd))
+			ret = maximize(rs, rd->sectors, ret, min);
+	}
+
+	return ret == (uint64_t) ~0 ? 0 : ret;
+}
+
+/*
+ * Definitions of mappings.
+ */
+
+/* Undefined/-supported mapping. */
+static int _dm_un(struct lib_context *lc, char **table,
+		  struct raid_set *rs, const char *what)
+{
+	LOG_ERR(lc, 0, "Un%sed RAID type %s[%u] on %s", what,
+		get_set_type(lc, rs), rs->type, rs->name);
+}
+
+static int dm_undef(struct lib_context *lc, char **table, struct raid_set *rs)
+{
+	return _dm_un(lc, table, rs, "defin");
+}
+
+static int dm_unsup(struct lib_context *lc, char **table, struct raid_set *rs)
+{
+	return _dm_un(lc, table, rs, "support");
+}
+
+
+/* "Spare mapping". */
+static int dm_spare(struct lib_context *lc, char **table, struct raid_set *rs)
+{
+	LOG_ERR(lc, 0, "spare set");
+}
+
+/* Push path and offset onto a table. */
+static int _dm_path_offset(struct lib_context *lc, char **table,
+			   int valid, const char *path, uint64_t offset)
+{
+	return p_fmt(lc, table, " %s %U",
+		     valid ? path : lc->path.error, offset);
+}
+
+/*
+ * Create dm table for linear mapping.
+ */
+static int _dm_linear(struct lib_context *lc, char **table, int valid,
+		      const char *path, uint64_t start, uint64_t sectors,
+		      uint64_t offset)
+{
+	return p_fmt(lc, table, "%U %U %s", start, sectors,
+		     get_dm_type(lc, t_linear)) ?
+		     _dm_path_offset(lc, table, valid, path, offset) : 0;
+}
+
+static int dm_linear(struct lib_context *lc, char **table,
+		     struct raid_set *rs)
+{
+	unsigned int segments = 0;
+	uint64_t start = 0, sectors = 0;
+	struct raid_dev *rd;
+	struct raid_set *r;
+
+	/* Stacked linear sets. */
+	list_for_each_entry(r, &rs->sets, list) {
+		if (!T_SPARE(r)) {
+			int ret;
+			char *path;
+
+			if (!(path = mkdm_path(lc, r->name)))
+				goto err;
+	
+			sectors = total_sectors(lc, r);
+			ret = _dm_linear(lc, table, valid_rs(r), path,
+					 start, sectors, 0);
+			dbg_free(path);
+			segments++;
+			start += sectors;
+	
+			if (!ret ||
+			    (r->sets.next != &rs->sets &&
+			     !p_fmt(lc, table, "\n")))
+				goto err;
+		}
+	}
+
+	/* Devices of a linear set. */
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (!T_SPARE(rd)) {
+			if (!_dm_linear(lc, table, valid_rd(rd), rd->di->path,
+					start, rd->sectors, rd->offset))
+				goto err;
+	
+			segments++;
+			start += rd->sectors;
+
+			if (rd->devs.next != &rs->devs &&
+			    !p_fmt(lc, table, "\n"))
+				goto err;
+		}
+	}
+
+	return segments ? 1 : 0;
+
+   err:
+	return log_alloc_err(lc, __func__);
+}
+
+/*
+ * Create dm table for a partition mapping.
+ *
+ * Partitioned RAID set with 1 RAID device
+ * defining a linear partition mapping.
+ */
+static int dm_partition(struct lib_context *lc, char **table,
+			struct raid_set *rs)
+{
+	return dm_linear(lc, table, rs);
+}
+
+/*
+ * Create dm table for striped mapping taking
+ * different disk sizes and the stride size into acccount.
+ *
+ * If metadata format handler requests a maximized mapping,
+ * more than one mapping table record will be created and
+ * stride boundaries will get paid attention to.
+ *
+ * Eg, 3 disks of 80, 100, 120 GB capacity:
+ *
+ * 0     240GB striped /dev/sda 0 /dev/sdb 0 /dev/sdc 0 
+ * 240GB 40GB  striped /dev/sdb 80GB /dev/sdc 80GB
+ * 280GB 20GB  linear /dev/sdc 100GB
+ *
+ */
+/* Push begin of line onto a RAID0 table. */
+static int _dm_raid0_bol(struct lib_context *lc, char **table,
+			 uint64_t min, uint64_t last_min,
+			 unsigned int n, unsigned int stride)
+{
+	return p_fmt(lc, table,
+		     n > 1 ? "%U %U %s %u %u" : "%U %U %s",
+		     last_min * n, (min - last_min) * n,
+		     get_dm_type(lc, n > 1 ? t_raid0 : t_linear),
+		     n, stride);
+}
+
+/* Push end of line onto a RAID0 table. */
+static int _dm_raid0_eol(struct lib_context *lc,
+			 char **table, struct raid_set *rs,
+			 unsigned int *stripes, uint64_t last_min)
+{
+	struct raid_set *r;
+	struct raid_dev *rd;
+
+	/* Stacked striped sets. */
+	list_for_each_entry(r, &rs->sets, list) {
+		if (total_sectors(lc, r) > last_min) {
+			int ret;
+			char *path;
+
+			if (!(path = mkdm_path(lc, r->name)))
+				goto err;
+
+			ret = _dm_path_offset(lc, table, valid_rs(r),
+					      path, last_min);
+			dbg_free(path);
+
+			if (!ret)
+				goto err;
+
+			(*stripes)++;
+		}
+	}
+	
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (!T_SPARE(rd) &&
+		    rd->sectors > last_min &&
+		    !_dm_path_offset(lc, table, valid_rd(rd), rd->di->path,
+				     rd->offset + last_min))
+			goto err;
+
+		(*stripes)++;
+	}
+
+	return 1;
+
+   err:
+	return 0;
+}
+
+/* Count RAID sets/devices larger than given minimum size. */
+static unsigned int _dm_raid_devs(struct lib_context *lc,
+				  struct raid_set *rs, uint64_t min)
+{
+	unsigned int ret = 0;
+	struct raid_set *r;
+	struct raid_dev *rd;
+
+	/* Stacked sets. */
+	list_for_each_entry(r, &rs->sets, list) {
+		if (!T_SPARE(r) && total_sectors(lc, r) > min)
+			ret++;
+	}
+	
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (!T_SPARE(rd) && rd->sectors > min)
+			ret++;
+	}
+
+	return ret;
+}
+	
+static int dm_raid0(struct lib_context *lc, char **table,
+		    struct raid_set *rs)
+{
+	unsigned int stripes = 0;
+	uint64_t min, last_min = 0;
+
+	for (; (min = _smallest(lc, rs, last_min)); last_min = min) {
+		if (last_min && !p_fmt(lc, table, "\n"))
+			goto err;
+
+		if (!_dm_raid0_bol(lc, table, round_down(min, rs->stride),
+				   last_min, _dm_raid_devs(lc, rs, last_min),
+				   rs->stride) ||
+		    !_dm_raid0_eol(lc, table, rs, &stripes, last_min))
+			goto err;
+
+		if (!F_MAXIMIZE(rs))
+			break;
+	}
+
+	return stripes ? 1 : 0;
+
+   err:
+	return log_alloc_err(lc, __func__);
+}
+
+/*
+ * Create dm table for mirrored mapping.
+ */
+
+/* Calculate dirty log region size. */
+static unsigned int calc_region_size(struct lib_context *lc, uint64_t sectors)
+{
+	const unsigned int mb_128 = 128*2*1024;
+	unsigned int max, region_size;
+
+	if ((max = sectors / 1024) > mb_128)
+		max = mb_128;
+
+	for (region_size = 128; region_size < max; region_size <<= 1);
+
+	return region_size >> 1;
+}
+
+static unsigned int get_rds(struct raid_set *rs, int valid)
+{
+	unsigned int ret = 0;
+	struct raid_dev *rd;
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (valid) {
+			if (valid_rd(rd))
+				ret++;
+		} else
+			ret++;
+	}
+
+	return ret;
+}
+
+static unsigned int get_dm_devs(struct raid_set *rs, int valid)
+{
+	unsigned int ret = 0;
+	struct raid_set *r;
+
+	/* Stacked mirror sets. */
+	list_for_each_entry(r, &rs->sets, list) {
+		if (valid) {
+			if (valid_rs(r))
+				ret++;
+		} else
+			ret++;
+	}
+
+	ret+= get_rds(rs, valid);
+
+	return ret;
+}
+
+/* Push begin of line onto a RAID1 table. */
+/* FIXME: persistent dirty log. */
+static int _dm_raid1_bol(struct lib_context *lc, char **table,
+			 struct raid_set *rs,
+			 uint64_t sectors, unsigned int mirrors)
+{
+	return (p_fmt(lc, table, "0 %U %s core 2 %u %s %u",
+		      sectors, get_dm_type(lc, t_raid1),
+		      calc_region_size(lc, sectors),
+		      (S_INCONSISTENT(rs->status) || S_NOSYNC(rs->status)) ?
+		      "sync" : "nosync", mirrors));
+}
+
+static int dm_raid1(struct lib_context *lc, char **table, struct raid_set *rs)
+{
+	uint64_t sectors = 0;
+	unsigned int mirrors = get_dm_devs(rs, 1);
+	struct raid_set *r;
+	struct raid_dev *rd;
+
+	switch (mirrors) {
+	case 0:
+		return 0;
+
+	case 1:
+		/*
+		 * In case we only have one mirror left,
+		 * a linear mapping will do.
+		 */
+		log_err(lc, "creating degraded mirror mapping for \"%s\"",
+			rs->name);
+		return dm_linear(lc, table, rs);
+	}
+		
+	if (!(sectors = _smallest(lc, rs, 0)))
+		LOG_ERR(lc, 0, "can't find smallest mirror!");
+
+	if (!_dm_raid1_bol(lc, table, rs, sectors, mirrors))
+		goto err;
+
+	/* Stacked mirror sets. */
+	list_for_each_entry(r, &rs->sets, list) {
+		if (valid_rs(r)) {
+			int ret;
+			char *path;
+
+			if (!(path = mkdm_path(lc, r->name)))
+				goto err;
+
+			ret = _dm_path_offset(lc, table, 1, path, 0);
+			dbg_free(path);
+
+			if (!ret)
+				goto err;
+		}
+	}
+
+	/* Lowest level mirror devices */
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (valid_rd(rd) &&
+		    !_dm_path_offset(lc, table, 1, rd->di->path, rd->offset))
+			goto err;
+	}
+
+	return 1;
+
+   err:
+	return log_alloc_err(lc, __func__);
+}
+
+/*
+ * Create dm table for RAID5 mapping.
+ */
+
+/* Push begin of line onto a RAID5 table. */
+/* FIXME: persistent dirty log. */
+static int _dm_raid45_bol(struct lib_context *lc, char **table,
+			 struct raid_set *rs,
+			 uint64_t sectors, unsigned int members)
+{
+	return p_fmt(lc, table, "0 %U %s core 2 %u %s %s 1 %u %u -1",
+		     sectors, get_dm_type(lc, rs->type),
+		     calc_region_size(lc, total_sectors(lc, rs) / _dm_raid_devs(lc, rs, 0)),
+		     (S_INCONSISTENT(rs->status) || S_NOSYNC(rs->status)) ?
+		     "sync" : "nosync",
+		     get_type(lc, rs->type), rs->stride, members);
+}
+
+static int dm_raid45(struct lib_context *lc, char **table, struct raid_set *rs)
+{
+	uint64_t sectors = 0;
+	unsigned int members = get_dm_devs(rs, 0);
+	struct raid_dev *rd;
+	struct raid_set *r;
+
+	if (!(sectors = _smallest(lc, rs, 0)))
+		LOG_ERR(lc, 0, "can't find smallest RAID4/5 member!");
+
+	/* Adjust sectors with chunk size: only whole chunks count */
+	sectors = sectors / rs->stride * rs->stride;
+
+	/*
+	 * Multiply size of smallest member by the number of data
+	 * devices to get the total sector count for the mapping.
+	 */
+	sectors *= members - 1;
+
+	if (!_dm_raid45_bol(lc, table, rs, sectors, members))
+		goto err;
+
+	/* Stacked RAID sets (for RAID50 etc.) */
+	list_for_each_entry(r, &rs->sets, list) {
+		int ret;
+		char *path;
+
+		if (!(path = mkdm_path(lc, r->name)))
+			goto err;
+
+		ret = _dm_path_offset(lc, table, valid_rs(r), path, 0);
+		dbg_free(path);
+
+		if (!ret)
+			goto err;
+	}
+
+	/* Lowest level RAID devices */
+	list_for_each_entry(rd, &rs->devs, devs) {
+		    if (!_dm_path_offset(lc, table, valid_rd(rd), rd->di->path,
+					 rd->offset))
+			goto err;
+	}
+
+	return 1;
+
+   err:
+	return log_alloc_err(lc, __func__);
+}
+
+/*
+ * Activate/deactivate (sub)sets.
+ */
+
+/*
+ * Array of handler functions for the various types.
+ */
+static struct type_handler {
+	const enum type type;
+	int(*f)(struct lib_context *lc, char **table, struct raid_set *rs);
+} type_handler[] = {
+	{ t_undef, dm_undef }, /* Needs to stay here! */
+	{ t_partition, dm_partition },
+	{ t_spare, dm_spare },
+	{ t_linear, dm_linear },
+	{ t_raid0, dm_raid0 },
+	{ t_raid1, dm_raid1 },
+	{ t_raid4, dm_raid45 },
+	{ t_raid5_ls, dm_raid45 },
+	{ t_raid5_rs, dm_raid45 },
+	{ t_raid5_la, dm_raid45 },
+	{ t_raid5_ra, dm_raid45 },
+	/* RAID types below not supported (yet) */
+	{ t_raid6, dm_unsup },
+};
+
+/* Retrieve type handler from array. */
+static struct type_handler *handler(struct raid_set *rs)
+{
+	struct type_handler *th = type_handler;
+
+	do {
+		if (rs->type == th->type)
+			return th;
+	} while (th++ < ARRAY_END(type_handler));
+
+	return type_handler;
+}
+
+/* Return mapping table */
+char *libdmraid_make_table(struct lib_context *lc, struct raid_set *rs)
+{
+	char *ret = NULL;
+
+	if (T_GROUP(rs))
+		return NULL;
+
+	if (!(handler(rs))->f(lc, &ret, rs))
+		LOG_ERR(lc, NULL, "no mapping possible for RAID set %s",
+			rs->name);
+
+	return ret;
+}
+
+
+enum dm_what { DM_ACTIVATE, DM_REGISTER};
+
+/* Register devices of the RAID set with the dmeventd. */
+/* REMOVEME: dummy functions once linking to the real ones. */
+#define	ALL_EVENTS 0xffffffff
+static int dm_register_for_event(char *a, char *b, int c)
+{
+	return 1;
+}
+
+static int dm_unregister_for_event(char *a, char *b, int c)
+{
+	return 1;
+}
+
+static int do_device(struct lib_context *lc, struct raid_set *rs,
+		     int (*f)()) // char *, char *, enum event_type))
+{
+	int ret = 0;
+	struct raid_dev *rd;
+
+	if (OPT_TEST(lc))
+		return 1;
+
+	return 1; /* REMOVEME: */
+
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (!(ret = f("dmraid", rd->di->path, ALL_EVENTS)))
+			break;
+	}
+
+	return ret ? 1 : 0;
+}
+
+static int register_devices(struct lib_context *lc, struct raid_set *rs)
+{
+	return do_device(lc, rs, dm_register_for_event);
+}
+
+/* Unregister devices of the RAID set with the dmeventd. */
+static int unregister_devices(struct lib_context *lc, struct raid_set *rs)
+{
+	return do_device(lc, rs, dm_unregister_for_event);
+}
+
+/* Activate a single set. */
+static int activate_subset(struct lib_context *lc, struct raid_set *rs,
+			   enum dm_what what)
+{
+	int ret = 0;
+	char *table = NULL;
+
+	if (T_GROUP(rs))
+		return 1;
+
+	if (what == DM_REGISTER)
+		return register_devices(lc, rs);
+
+	/* Call type handler */
+	if ((ret = (handler(rs))->f(lc, &table, rs))) {
+		if (OPT_TEST(lc))
+			display_table(lc, rs->name, table);
+		else
+			ret = dm_create(lc, rs, table);
+	} else
+		log_err(lc, "no mapping possible for RAID set %s", rs->name);
+
+	free_string(lc, &table);
+
+	return ret;
+}
+
+/* Activate a RAID set recursively (eg, RAID1 on top of RAID0). */
+static int activate_set(struct lib_context *lc, struct raid_set *rs,
+			enum dm_what what)
+{
+	struct raid_set *r;
+
+	if (!OPT_TEST(lc) &&
+	    what == DM_ACTIVATE &&
+	    dm_status(lc, rs)) {
+		log_print(lc, "RAID set \"%s\" already active", rs->name);
+		return 1;
+	}
+
+	/* Recursively walk down the chain of stacked RAID sets */
+	list_for_each_entry(r, &rs->sets, list) {
+		/* Activate set below this one */
+		if (!activate_set(lc, r, what) && !T_GROUP(rs))
+			return 0;
+	}
+
+	return activate_subset(lc, rs, what);
+}
+
+/* Deactivate a single set (one level of a device stack). */
+static int deactivate_superset(struct lib_context *lc, struct raid_set *rs,
+			       enum dm_what what)
+{
+	int ret = 1, status;
+
+	if (what == DM_REGISTER)
+		return unregister_devices(lc, rs);
+		
+	status = dm_status(lc, rs);
+	if (OPT_TEST(lc))
+		log_print(lc, "%s [%sactive]", rs->name, status ? "" : "in");
+	else if (status)
+		ret = dm_remove(lc, rs);
+	else {
+		log_print(lc, "RAID set \"%s\" is not active", rs->name);
+		ret = 1;
+	}
+
+	return ret;
+}
+
+/* Deactivate a RAID set. */
+static int deactivate_set(struct lib_context *lc, struct raid_set *rs,
+			  enum dm_what what)
+{
+	struct raid_set *r;
+
+	/*
+	 * Deactivate myself if not a group set,
+	 * which gets never activated itself.
+	 */
+	if (!T_GROUP(rs) &&
+	    !deactivate_superset(lc, rs, what))
+		return 0;
+
+	/* Deactivate any subsets recursively. */
+	list_for_each_entry(r, &rs->sets, list) {
+		if (!deactivate_set(lc, r, what))
+			return 0;
+	}
+
+	return 1;
+}
+
+
+/* External (de)activate interface. */
+int change_set(struct lib_context *lc, enum activate_type what, void *v)
+{
+	int ret = 0;
+	struct raid_set *rs = v;
+
+	switch (what) {
+	case A_ACTIVATE:
+		ret = activate_set(lc, rs, DM_ACTIVATE) &&
+		      activate_set(lc, rs, DM_REGISTER);
+		break;
+
+	case A_DEACTIVATE:
+		ret = deactivate_set(lc, rs, DM_REGISTER) &&
+		      deactivate_set(lc, rs, DM_ACTIVATE);
+	}
+
+	return ret;
+}
/cvs/dm/dmraid/lib/activate/activate.h,v  -->  standard output
revision 1.1
--- dmraid/lib/activate/activate.h
+++ -	2008-02-22 16:57:39.411945000 +0000
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _ACTIVATE_H_
+#define _ACTIVATE_H_
+
+enum activate_type {
+	A_ACTIVATE,
+	A_DEACTIVATE,
+};
+
+int change_set(struct lib_context *lc, enum activate_type what, void *rs);
+
+#endif
/cvs/dm/dmraid/lib/activate/devmapper.c,v  -->  standard output
revision 1.1
--- dmraid/lib/activate/devmapper.c
+++ -	2008-02-22 16:57:39.495418000 +0000
@@ -0,0 +1,235 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * dmraid device-mapper lib interface functions.
+ */
+
+#include <libdevmapper.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <dirent.h>
+#include <errno.h>
+#include <unistd.h>
+
+#include "internal.h"
+#include "devmapper.h"
+
+/* Make up a dm path. */
+char *mkdm_path(struct lib_context *lc, const char *name)
+{
+	char *ret;
+	const char *dir = dm_dir();
+
+	if ((ret = dbg_malloc(strlen(dir) + strlen(name) + 2)))
+		sprintf(ret, "%s/%s", dir, name);
+	else
+		log_alloc_err(lc, __func__);
+
+	return ret;
+}
+
+/* Device-mapper NULL log function. */
+static void dmraid_log(int level, const char *file, int line,
+		       const char *f, ...)
+{
+	return;
+}
+
+/* Init device-mapper library. */
+static void _init_dm(void)
+{
+	dm_log_init(dmraid_log);
+}
+
+/* Cleanup at exit. */
+static void _exit_dm(struct dm_task *dmt)
+{
+	if (dmt)
+		dm_task_destroy(dmt);
+
+	dm_lib_release();
+	dm_lib_exit();
+}
+
+/*
+ * Retrieve list of registered mapping targets.
+ *
+ * dm-library must get inititalized by caller.
+ */
+static struct dm_versions *get_target_list(void)
+{
+	struct dm_task *dmt;
+
+	return (dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)) &&
+	       dm_task_run(dmt) ? dm_task_get_versions(dmt) : NULL;
+}
+
+/* Check a target's name against registered ones. */
+static int valid_ttype(struct lib_context *lc, char *ttype,
+		       struct dm_versions *targets)
+{
+	struct dm_versions *t, *last;
+
+	/*
+	 * If we don't have the list of target types registered
+	 * with the device-mapper core -> carry on and potentially
+	 * fail on target addition.
+	 */
+	if (!targets)
+		return 1;
+
+	/* Walk registered mapping target name list. */
+	t = targets;
+	do {
+		if (!strcmp(ttype, t->name))
+			return 1;
+
+		last = t;
+		t = (void*) t + t->next;
+	} while (last != t);
+
+	LOG_ERR(lc, 0, "device-mapper target type \"%s\" not in kernel", ttype);
+}
+
+/*
+ * Parse a mapping table and create the appropriate targets or
+ * check that a target type is registered with the device-mapper core.
+ */
+static int handle_table(struct lib_context *lc, struct dm_task *dmt,
+			char *table, struct dm_versions *targets)
+{
+	int line = 0, n, ret = 0;
+	uint64_t start, size;
+	char *nl = table, *p, ttype[32];
+
+	do {
+		p = nl;
+		line++;
+
+		/*
+		 * Not using sscanf string allocation
+		 * because it's not available in dietlibc.
+		 */
+		*ttype = 0;
+		if (sscanf(p, "%" PRIu64 " %" PRIu64 " %31s %n",
+			   &start, &size, ttype, &n) < 3)
+			LOG_ERR(lc, 0, "Invalid format in table line %d", line);
+
+		if (!(ret = valid_ttype(lc, ttype, targets)))
+			break;
+
+		nl = remove_delimiter((p += n), '\n');
+		if (dmt)
+			ret = dm_task_add_target(dmt, start, size, ttype, p);
+
+		add_delimiter(&nl, '\n');
+	} while (nl && ret);
+
+	return ret;
+}
+
+/* Parse a mapping table and create the appropriate targets. */
+static int parse_table(struct lib_context *lc, struct dm_task *dmt, char *table)
+{
+	return handle_table(lc, dmt, table, NULL);
+}
+
+/* Check if a target type is not registered with the kernel after a failure. */
+static int check_table(struct lib_context *lc, char *table)
+{
+	return handle_table(lc, NULL, table, get_target_list());
+}
+
+/* Create a mapped device. */
+int dm_create(struct lib_context *lc, struct raid_set *rs, char *table)
+{
+	int ret = 0;
+	struct dm_task *dmt;
+
+	_init_dm();
+
+	/* Create <dev_name> */
+	ret = (dmt = dm_task_create(DM_DEVICE_CREATE)) &&
+	       dm_task_set_name(dmt, rs->name) &&
+	       parse_table(lc, dmt, table) &&
+	       dm_task_run(dmt);
+
+	/*
+	 * In case device creation failed, check if target
+	 * isn't registered with the device-mapper core
+	 */
+	if (!ret)
+		check_table(lc, table);
+
+	_exit_dm(dmt);
+
+	return ret;
+}
+
+/* Remove a mapped device. */
+int dm_remove(struct lib_context *lc, struct raid_set *rs)
+{
+	int ret;
+	struct dm_task *dmt;
+
+	_init_dm();
+
+	/* remove <dev_name> */
+	ret = (dmt = dm_task_create(DM_DEVICE_REMOVE)) &&
+	       dm_task_set_name(dmt, rs->name) &&
+	       dm_task_run(dmt);
+
+	_exit_dm(dmt);
+
+	return ret;
+}
+
+/* Retrieve status of a mapped device. */
+/* FIXME: more status for device monitoring... */
+int dm_status(struct lib_context *lc, struct raid_set *rs)
+{
+	int ret;
+	struct dm_task *dmt;
+	struct dm_info info;
+
+	_init_dm();
+
+	/* Status <dev_name>. */
+	ret = (dmt = dm_task_create(DM_DEVICE_STATUS)) &&
+	       dm_task_set_name(dmt, rs->name) &&
+	       dm_task_run(dmt) &&
+	       dm_task_get_info(dmt, &info) &&
+	       info.exists;
+
+	_exit_dm(dmt);
+
+	return ret;
+}
+
+/* Retrieve device-mapper driver version. */
+int dm_version(struct lib_context *lc, char *version, size_t size)
+{
+	int ret;
+	struct dm_task *dmt;
+
+	/* Be prepared for device-mapper not in kernel. */
+	strncpy(version, "unknown", size);
+
+	_init_dm();
+
+	ret = (dmt = dm_task_create(DM_DEVICE_VERSION)) &&
+	       dm_task_run(dmt) &&
+	       dm_task_get_driver_version(dmt, version, size);
+
+	_exit_dm(dmt);
+
+	return ret;
+}
/cvs/dm/dmraid/lib/activate/devmapper.h,v  -->  standard output
revision 1.1
--- dmraid/lib/activate/devmapper.h
+++ -	2008-02-22 16:57:39.574643000 +0000
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _DEVMAPPER_H_
+#define _DEVMAPPER_H
+
+char *mkdm_path(struct lib_context *lc, const char *name);
+int dm_create(struct lib_context *lc, struct raid_set *rs, char *table);
+int dm_remove(struct lib_context *lc, struct raid_set *rs);
+int dm_status(struct lib_context *lc, struct raid_set *rs);
+int dm_version(struct lib_context *lc, char *version, size_t size);
+
+#endif
/cvs/dm/dmraid/lib/datastruct/byteorder.h,v  -->  standard output
revision 1.1
--- dmraid/lib/datastruct/byteorder.h
+++ -	2008-02-22 16:57:39.656066000 +0000
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/* Cheers utils.h */
+
+#ifndef _BYTEORDER_H
+#define _BYTEORDER_H
+
+#ifdef __KLIBC__
+#include <endian.h>
+#endif
+
+#ifdef	DM_BYTEORDER_SWAB
+
+static inline uint64_t le64_to_cpu(uint64_t x)
+{
+	return((((uint64_t)x & 0x00000000000000ffULL) << 56) | 
+	       (((uint64_t)x & 0x000000000000ff00ULL) << 40) | 
+	       (((uint64_t)x & 0x0000000000ff0000ULL) << 24) | 
+	       (((uint64_t)x & 0x00000000ff000000ULL) <<  8) |
+	       (((uint64_t)x & 0x000000ff00000000ULL) >>  8) | 
+	       (((uint64_t)x & 0x0000ff0000000000ULL) >> 24) | 
+	       (((uint64_t)x & 0x00ff000000000000ULL) >> 40) | 
+	       (((uint64_t)x & 0xff00000000000000ULL) >> 56));
+}
+
+static inline int32_t le32_to_cpu(int32_t x)
+{
+	return((((u_int32_t)x & 0x000000ffU) << 24) | 
+	       (((u_int32_t)x & 0x0000ff00U) <<  8) | 
+	       (((u_int32_t)x & 0x00ff0000U) >>  8) | 
+	       (((u_int32_t)x & 0xff000000U) >> 24));
+}
+
+static inline int16_t le16_to_cpu(int16_t x)
+{
+	return((((u_int16_t)x & 0x00ff) << 8) | 
+	       (((u_int16_t)x & 0xff00) >> 8));
+}
+
+#define	CVT64(x)	do { x = le64_to_cpu(x); } while(0)
+#define	CVT32(x)	do { x = le32_to_cpu(x); } while(0)
+#define	CVT16(x)	do { x = le16_to_cpu(x); } while(0)
+
+#else
+
+#define CVT64(x)
+#define	CVT32(x)
+#define	CVT16(x)
+
+#undef	DM_BYTEORDER_SWAB
+
+#endif /* #ifdef DM_BYTEORDER_SWAB */
+
+#endif
/cvs/dm/dmraid/lib/device/ata.c,v  -->  standard output
revision 1.1
--- dmraid/lib/device/ata.c
+++ -	2008-02-22 16:57:39.734699000 +0000
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/* Thx scsiinfo. */
+
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <mm/dbg_malloc.h>
+
+#include "dev-io.h"
+#include "ata.h"
+
+int get_ata_serial(struct lib_context *lc, int fd, struct dev_info *di)
+{
+	int ret = 0;
+	const int cmd_offset = 4;
+	unsigned char *buf;
+	struct ata_identify *ata_ident;
+
+	if ((buf = dbg_malloc(cmd_offset + sizeof(*ata_ident)))) {
+		buf[0] = ATA_IDENTIFY_DEVICE;
+		buf[3] = 1;
+		if (!ioctl(fd, HDIO_DRIVE_CMD, buf)) {
+			ata_ident = (struct ata_identify*) &buf[cmd_offset];
+			if ((di->serial = dbg_strdup(remove_white_space(lc, (char*) ata_ident->serial, ATA_SERIAL_LEN))))
+				ret = 1;
+		}
+	
+		dbg_free(buf);
+	}
+
+	return ret;
+}
/cvs/dm/dmraid/lib/device/ata.h,v  -->  standard output
revision 1.1
--- dmraid/lib/device/ata.h
+++ -	2008-02-22 16:57:39.814157000 +0000
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/* Thx scsiinfo */
+
+#ifndef	_ATA_H_
+#define	_ATA_H_
+
+struct ata_identify {
+	unsigned short dummy[10];
+#define	ATA_SERIAL_LEN	20
+	unsigned char  serial[ATA_SERIAL_LEN];
+	unsigned short dummy1[3];
+	unsigned char  fw_rev[8];
+	unsigned char  model[40];
+	unsigned short dummy2[33];
+	unsigned short major_rev_num;
+	unsigned short minor_rev_num;
+	unsigned short command_set_1;
+	unsigned short command_set_2;
+	unsigned short command_set_extension;
+	unsigned short cfs_enable_1;
+	unsigned short dummy3;
+	unsigned short csf_default;
+	unsigned short dummy4[168];
+};
+
+#ifndef ATA_IDENTIFY_DEVICE
+#define ATA_IDENTIFY_DEVICE 0xEC
+#endif
+#ifndef HDIO_DRIVE_CMD
+#define HDIO_DRIVE_CMD    0x031F
+#endif
+
+struct lib_context;
+int get_ata_serial(struct lib_context *lc, int fd, struct dev_info *di);
+
+#endif
/cvs/dm/dmraid/lib/device/dev-io.h,v  -->  standard output
revision 1.1
--- dmraid/lib/device/dev-io.h
+++ -	2008-02-22 16:57:39.894030000 +0000
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_DEV_IO_H_
+#define	_DEV_IO_H_
+
+#include <linux/hdreg.h>
+#include <sys/stat.h>
+#include "internal.h"
+
+#define BLKGETSIZE	_IO(0x12, 0x60) /* get block device size */
+#define BLKSSZGET	_IO(0x12, 0x68) /* get block device sector size */
+
+#define	DMRAID_SECTOR_SIZE	512
+
+int discover_devices(struct lib_context *lc, char **devnodes);
+int removable_device(struct lib_context *lc, char *dev_path);
+
+#endif
/cvs/dm/dmraid/lib/device/scan.c,v  -->  standard output
revision 1.1
--- dmraid/lib/device/scan.c
+++ -	2008-02-22 16:57:39.977011000 +0000
@@ -0,0 +1,336 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifdef __KLIBC__
+# define __KERNEL_STRICT_NAMES
+# include <dirent.h>
+# include <paths.h>
+#else
+# include <dirent.h>
+# include <mntent.h>
+#endif
+
+#include <stdlib.h>
+#include <linux/hdreg.h>
+#include <sys/ioctl.h>
+#include "internal.h"
+#include "ata.h"
+#include "scsi.h"
+
+/*
+ * subdirectory below sysfs moint point holding the 
+ * subdirectory hierarchies of all block devices.
+ */
+#define	BLOCK 		"/block"
+
+/* Find sysfs mount point */
+#ifndef	_PATH_MOUNTS
+#define	_PATH_MOUNTS	"/proc/mounts"
+#endif
+
+static char *find_sysfs_mp(struct lib_context *lc)
+{
+#ifndef __KLIBC__
+	char *ret = NULL;
+	FILE *mfile;
+	struct mntent *ment;
+
+	/* Try /proc/mounts first and failback to /etc/mtab. */
+	if (!(mfile = setmntent(_PATH_MOUNTS, "r"))) {
+		if (!(mfile = setmntent(_PATH_MOUNTED, "r")))
+			LOG_ERR(lc, NULL, "Unable to open %s or %s",
+				_PATH_MOUNTS, _PATH_MOUNTED);
+	}
+
+	while ((ment = getmntent(mfile))) {
+		if (!strcmp(ment->mnt_type, "sysfs")) {
+			ret = ment->mnt_dir;
+			break;
+		}
+	};
+
+	endmntent(mfile);
+
+	return ret;
+#else
+	return (char*) "/sys";
+#endif
+}
+
+/* Make up an absolute sysfs path given a relative one. */
+static char *mk_sysfs_path(struct lib_context *lc, char const *path) {
+	static char *ret = NULL, *sysfs_mp;
+
+	if (!(sysfs_mp = find_sysfs_mp(lc)))
+		LOG_ERR(lc, NULL, "finding sysfs mount point");
+
+	if ((ret = dbg_malloc(strlen(sysfs_mp) + strlen(path) + 1)))
+		sprintf(ret, "%s%s", sysfs_mp, path);
+	else
+		log_alloc_err(lc, __func__);
+
+	return ret;
+}
+
+/* Test with sparse mapped devices. */
+#ifdef	DMRAID_TEST
+static int dm_test_device(struct lib_context *lc, char *path)
+{
+	struct stat s;
+
+	return !lstat(path, &s) &&
+	       S_ISLNK(s.st_mode) &&
+	       !strncmp(get_basename(lc, path), "dm-", 3);
+}
+
+/* Fake a SCSI serial number by reading it from a file. */
+static int get_dm_test_serial(struct lib_context *lc,
+			      struct dev_info *di, char *path)
+{
+	int ret = 1;
+	char *serial, buffer[32];
+	const char *dot_serial = ".serial";
+	FILE *f;
+
+	if (!(serial = dbg_malloc(strlen(path) + strlen(dot_serial) + 1)))
+		return log_alloc_err(lc, __func__);
+
+	sprintf(serial, "%s%s", path, dot_serial);
+	if ((f = fopen(serial, "r")) &&
+	    fgets(buffer, 31, f) &&
+	    !(di->serial = dbg_strdup(remove_white_space(lc, buffer,
+							 strlen(buffer)))))
+		ret = 0;
+
+	dbg_free(serial);
+	if (f)
+		fclose(f);
+	else
+		log_warn(lc, "missing dm serial file for %s", di->path);
+
+	return ret;
+#undef	DOT_SERIAL
+}
+#endif
+
+/*
+ * Ioctl for sector, optionally for device size
+ * and get device serial number.
+ */
+static int get_device_serial(struct lib_context *lc, int fd,
+			     struct dev_info *di)
+{
+	/*
+	 * In case new generic SCSI ioctl fails,
+	 * try ATA and fall back to old SCSI ioctl.
+	 */
+	return get_scsi_serial(lc, fd, di, SG) || /* SG: generic scsi ioctl. */
+	       get_ata_serial(lc, fd, di) ||	  /* Get ATA serial number. */
+	       get_scsi_serial(lc, fd, di, OLD);  /* OLD: Old scsi ioctl. */
+}
+
+static int di_ioctl(struct lib_context *lc, int fd, struct dev_info *di)
+{
+	unsigned int sector_size = 0;
+	unsigned long size;
+
+	/* Fetch sector size. */
+	if (ioctl(fd, BLKSSZGET, &sector_size))
+		sector_size = DMRAID_SECTOR_SIZE;
+
+	if (sector_size != DMRAID_SECTOR_SIZE)
+		LOG_ERR(lc, 0, "unsupported sector size %d on %s.",
+			sector_size, di->path);
+
+	/* Use size device ioctl in case we didn't get the size from sysfs. */
+	if (!di->sectors && !ioctl(fd, BLKGETSIZE, &size))
+		di->sectors = size;
+
+#ifdef	DMRAID_TEST
+	/* Test with sparse mapped devices. */
+	if (dm_test_device(lc, di->path))
+		return get_dm_test_serial(lc, di, di->path);
+	else
+#endif
+	return get_device_serial(lc, fd, di);
+}
+
+/* Are we interested in this device ? */
+static int interested(struct lib_context *lc, char *path)
+{
+	char *name = get_basename(lc, path);
+
+	/*
+	 * Whole IDE and SCSI disks only.
+	 */
+	return (!isdigit(name[strlen(name) - 1]) &&
+	       (*(name + 1) == 'd' && (*name == 'h' || *name == 's')))
+
+#ifdef	DMRAID_TEST
+	/*
+	 * Include dm devices for testing.
+	 */
+		|| dm_test_device(lc, path)
+#endif
+	;
+}
+
+/* Ask sysfs, if a device is removable. */
+int removable_device(struct lib_context *lc, char *dev_path)
+{
+	int ret = 0;
+	char buf[2], *name, *sysfs_path, *sysfs_file;
+	const char *sysfs_removable = "removable";
+	FILE *f;
+
+	if (!(sysfs_path = mk_sysfs_path(lc, BLOCK)))
+		return 0;
+
+	name = get_basename(lc, dev_path);
+	if (!(sysfs_file = dbg_malloc(strlen(sysfs_path) + strlen(name) +
+				      strlen(sysfs_removable) + 3))) {
+		log_alloc_err(lc, __func__);
+		goto out;
+	}
+
+	sprintf(sysfs_file, "%s/%s/%s", sysfs_path, name, sysfs_removable);
+	if ((f = fopen(sysfs_file, "r"))) {
+		/* Using fread for klibc compatibility. */
+		if (fread(buf, sizeof(char), sizeof(buf) - 1, f) &&
+		    *buf == '1') {
+			log_notice(lc, "skipping removable device %s",
+				   dev_path);
+			ret = 1;
+		}
+
+		fclose(f);
+	}
+
+	dbg_free(sysfs_file);
+
+   out:
+	dbg_free(sysfs_path);
+
+	return ret;
+}
+
+/*
+ * Read the size in sectors from the sysfs "size" file.
+ * Avoid access to removable devices.
+ */
+static int sysfs_get_size(struct lib_context *lc, struct dev_info *di,
+			  const char *path, char *name)
+{
+	int ret = 0;
+	char buf[22], *sysfs_file;
+	const char *sysfs_size = "size";
+	FILE *f;
+
+	if (!(sysfs_file = dbg_malloc(strlen(path) + strlen(name) +
+				      strlen(sysfs_size) + 3)))
+		return log_alloc_err(lc, __func__);
+
+	sprintf(sysfs_file, "%s/%s/%s", path, name, sysfs_size);
+	if ((f = fopen(sysfs_file, "r"))) {
+		/* Use fread+sscanf for klibc compatibility. */
+		if (fread(buf, sizeof(char), sizeof buf - 1, f) &&
+		    (ret = sscanf(buf, "%" PRIu64, &di->sectors)) != 1) {
+			ret = 0;
+			log_err(lc, "reading disk size for %s from sysfs",
+				di->path);
+		}
+
+		fclose(f);
+	} else
+		log_err(lc, "opening %s", sysfs_file);
+
+	dbg_free(sysfs_file);
+
+	return ret;
+}
+
+static int get_size(struct lib_context *lc, char *path,
+		    char *name, int sysfs)
+{
+	int fd, ret = 0;
+	char *dev_path;
+	struct dev_info *di = NULL;
+
+	if (!(dev_path = dbg_malloc(strlen(_PATH_DEV) + strlen(name) + 1)))
+		return log_alloc_err(lc, __func__);
+
+	sprintf(dev_path, "%s%s", _PATH_DEV, name);
+	if (!interested(lc, dev_path)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (removable_device(lc, dev_path) ||
+	    !(di = alloc_dev_info(lc, dev_path)) ||
+	    (sysfs && !sysfs_get_size(lc, di, path, name)) ||
+	    (fd = open(dev_path, O_RDONLY)) == -1)
+		goto out;
+
+	if (di_ioctl(lc, fd, di)) {
+		list_add(&di->list, LC_DI(lc));
+		ret = 1;
+	}
+
+	close(fd);
+
+   out:
+	dbg_free(dev_path);
+
+	if (!ret && di)
+		free_dev_info(lc, di);
+
+	return ret;
+}
+
+/*
+ * Find disk devices in sysfs or directly
+ * in /dev (for Linux 2.4) and keep information.
+ */
+int discover_devices(struct lib_context *lc, char **devnodes)
+{
+	int sysfs, ret = 0;
+	char *path, *p;
+	DIR *d;
+	struct dirent *de;
+
+	if ((p = mk_sysfs_path(lc, BLOCK))) {
+		sysfs = 1;
+		path = p;
+	} else {
+		sysfs = 0;
+		path = (char*) _PATH_DEV;
+		log_print(lc, "carrying on with %s", path);
+	}
+
+	if (!(d = opendir(path))) {
+		log_err(lc, "opening path %s", path);
+		goto out;
+	}
+
+	if (devnodes && *devnodes) {
+		while (*devnodes)
+			get_size(lc, path, get_basename(lc, *devnodes++),
+				 sysfs);
+	} else {
+		while ((de = readdir(d)))
+			get_size(lc, path, de->d_name, sysfs);
+	}
+
+	closedir(d);
+	ret = 1;
+
+  out:
+	if (p)
+		dbg_free(p);
+
+	return ret;
+}
/cvs/dm/dmraid/lib/device/scsi.c,v  -->  standard output
revision 1.1
--- dmraid/lib/device/scsi.c
+++ -	2008-02-22 16:57:40.065183000 +0000
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <mm/dbg_malloc.h>
+#include <scsi/scsi_ioctl.h>
+
+/* FIXME: sg header mess. */
+#include <scsi/sg.h>
+#include <scsi/scsi.h>
+
+#include "dev-io.h"
+#include "scsi.h"
+
+/* Thx scsiinfo. */
+
+/* Initialize SCSI inquiry command block (used both with SG and old ioctls). */
+static void set_cmd(unsigned char *cmd, size_t len)
+{
+	cmd[0] = 0x12;	/* INQUIRY */
+	cmd[1] = 1;
+	cmd[2] = 0x80;	/* page code: SCSI serial */
+	cmd[3] = 0;
+	cmd[4] = (unsigned char) (len & 0xff);
+	cmd[5] = 0;
+}
+
+/*
+ * SCSI SG_IO ioctl to get serial number of a unit.
+ */
+static int sg_inquiry(int fd, unsigned char *response, size_t response_len)
+{
+	unsigned char cmd[6];
+	struct sg_io_hdr io_hdr;
+
+	set_cmd(cmd, response_len);
+
+	/* Initialize generic (SG) SCSI ioctl header. */
+	memset(&io_hdr, 0, sizeof(io_hdr));
+	io_hdr.interface_id	= 'S';
+	io_hdr.cmdp		= cmd;
+	io_hdr.cmd_len		= sizeof(cmd);
+	io_hdr.sbp		= NULL;
+	io_hdr.mx_sb_len	= 0;
+	io_hdr.dxfer_direction	= SG_DXFER_FROM_DEV;
+	io_hdr.dxferp		= response;
+	io_hdr.dxfer_len	= response_len;
+	io_hdr.timeout		= 6000; /* [ms] */
+
+	return ioctl(fd, SG_IO, &io_hdr) ? 0 : 1;
+}
+
+/*
+ * Old SCSI ioctl as fallback to get serial number of a unit.
+ */
+static int old_inquiry(int fd, unsigned char *response, size_t response_len)
+{
+	unsigned int *i = (unsigned int*) response;
+
+	i[0] = 0; /* input data length */
+	i[1] = response_len; /* output buffer length */
+	set_cmd((unsigned char*) &i[2], response_len); 
+
+	return ioctl(fd, SCSI_IOCTL_SEND_COMMAND, response) ? 0 : 1;
+}
+
+/*
+ * Retrieve SCSI serial number.
+ */
+#define	MAX_RESPONSE_LEN	255
+int get_scsi_serial(struct lib_context *lc, int fd, struct dev_info *di,
+		    enum ioctl_type type)
+{
+	int ret = 0;
+	size_t actual_len;
+	unsigned char *response;
+	/*
+	 * Define ioctl function and offset into response buffer of serial
+	 * string length field (serial string follows length field immediately)
+	 */
+	struct {
+		int (*ioctl_func)(int, unsigned char*, size_t);
+		unsigned int start;
+	} param[] = {
+		{ sg_inquiry ,  3 },
+		{ old_inquiry, 11 },
+	}, *p = (SG == type) ? param : param + 1;
+
+	if (!(response = dbg_malloc(MAX_RESPONSE_LEN)))
+		return 0;
+
+	actual_len = p->start + 1;
+	if ((ret = (p->ioctl_func(fd, response, actual_len)))) {
+		size_t serial_len = (size_t) response[p->start];
+
+		if (serial_len > actual_len) {
+			actual_len += serial_len;
+			ret = p->ioctl_func(fd, response, actual_len);
+		}
+
+		ret = ret && (di->serial = dbg_strdup(remove_white_space(lc, (char*) &response[p->start + 1], serial_len)));
+	}
+
+	dbg_free(response);
+
+	return ret;
+}
/cvs/dm/dmraid/lib/device/scsi.h,v  -->  standard output
revision 1.1
--- dmraid/lib/device/scsi.h
+++ -	2008-02-22 16:57:40.146618000 +0000
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_SCSI_H_
+#define	_SCSI_H_
+
+/* Ioctl types possible (SG = SCSI generic, OLD = old SCSI command ioctl. */
+enum ioctl_type {
+	SG,
+	OLD,
+};
+
+int get_scsi_serial(struct lib_context *lc, int fd,
+		    struct dev_info *di, enum ioctl_type type);
+
+#endif
/cvs/dm/dmraid/lib/display/display.c,v  -->  standard output
revision 1.1
--- dmraid/lib/display/display.c
+++ -	2008-02-22 16:57:40.244819000 +0000
@@ -0,0 +1,371 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+#include "activate/devmapper.h"
+
+#define	ARRAY_LIMIT(array, idx) \
+	((idx) < ARRAY_SIZE(array) ? (idx) : ARRAY_SIZE(array) - 1)
+
+struct log_handler {
+	const char *field;
+	const unsigned char minlen;
+	void (*log_func)(struct lib_context*, void *arg);
+	void *arg;
+};
+
+static void log_string(struct lib_context *lc, void *arg)
+{
+	log_print_nnl(lc, "%s", (char*) arg);
+}
+
+static void log_uint64(struct lib_context *lc, void *arg)
+{
+	log_print_nnl(lc, "%" PRIu64, *((uint64_t*) arg));
+}
+
+static void log_uint(struct lib_context *lc, void *arg)
+{
+	log_print_nnl(lc, "%u", *((unsigned int*) arg));
+}
+
+/* Log a structure member by field name. */
+static int log_field(struct lib_context *lc, const struct log_handler *lh,
+		     size_t lh_size, char *field)
+{
+	const struct log_handler *h;
+
+	for (h = lh; h < lh + lh_size; h++) {
+		size_t len = strlen(field);
+
+		if (!strncmp(field, h->field,
+			     len > h->minlen ? len : h->minlen)) {
+			h->log_func(lc, h->arg);
+			return 1;
+		}
+	}
+
+	log_print_nnl(lc, "*ERR*");
+
+	return 1;
+}
+
+/* Log a list of structure members by field name. */
+static void log_fields(struct lib_context *lc, const struct log_handler *lh,
+		       size_t lh_size) {
+	int logged = 0, last_logged = 0;
+	const char delim = *OPT_STR_SEPARATOR(lc);
+	char *p, *sep, *sep_sav;
+
+	if (!(sep_sav = dbg_strdup((char*) OPT_STR_COLUMN(lc)))) {
+		log_alloc_err(lc, __func__);
+		return;
+	}
+
+	sep = sep_sav;
+	do {
+		sep = remove_delimiter((p = sep), delim);
+		if (last_logged)
+			log_print_nnl(lc, "%c", delim);
+
+		last_logged = log_field(lc, lh, lh_size, p);
+		logged += last_logged;
+		add_delimiter(&sep, delim);
+	} while (sep);
+
+	dbg_free(sep_sav);
+	if (logged)
+		log_print(lc, "");
+}
+
+/* Display information about a block device */
+static void log_disk(struct lib_context *lc, struct list_head *pos)
+{
+	struct dev_info *di = list_entry(pos, typeof(*di), list);
+
+	if (OPT_STR_COLUMN(lc)) {
+		const struct log_handler log_handlers[] = {
+			{ "devpath", 1, log_string, di->path},
+			{ "path", 1, log_string, di->path},
+			{ "sectors", 3, log_uint64, &di->sectors},
+			{ "serialnumber", 3, log_string,
+			  di->serial ? (void*) di->serial : (void*) "N/A"},
+			{ "size", 2, log_uint64, &di->sectors},
+		};
+
+		log_fields(lc, log_handlers, ARRAY_SIZE(log_handlers));
+	} else {
+		const char *fmt[] = {
+			"%s: %12" PRIu64 " total, \"%s\"",
+			"%s",
+			"%s:%" PRIu64 ":\"%s\"",
+		};
+	
+		log_print(lc, fmt[ARRAY_LIMIT(fmt, OPT_COLUMN(lc))],
+			  di->path, di->sectors,
+			  di->serial ? di->serial : "N/A");
+	}
+}
+
+/* Turn NULL (= "unknown") into a displayable string. */
+static const char *check_null(const char *str)
+{
+	return str ? str : "unknown";
+}
+
+/* Log native RAID device information. */
+static void log_rd_native(struct lib_context *lc, struct list_head *pos)
+{
+	struct raid_dev *rd = list_entry(pos, typeof(*rd), list);
+
+	if (rd->fmt->log) {
+		rd->fmt->log(lc, rd);
+		log_print(lc, "");
+	} else
+		log_print(lc, "\"%s\" doesn't support native logging of RAID "
+			  "device information", rd->fmt->name);
+}
+
+/* Display information about a RAID device */
+static void log_rd(struct lib_context *lc, struct list_head *pos)
+{
+	struct raid_dev *rd = list_entry(pos, typeof(*rd), list);
+
+	if (OPT_STR_COLUMN(lc)) {
+		const struct log_handler log_handlers[] = {
+			{ "dataoffset", 2, log_uint64, &rd->offset},
+			{ "devpath", 2, log_string, rd->di->path },
+			{ "format", 1, log_string, (void*) rd->fmt->name },
+			{ "offset", 1, log_uint64, &rd->offset},
+			{ "path", 1, log_string, rd->di->path },
+			{ "raidname", 1, log_string, rd->name },
+			{ "type", 1, log_string,
+			  (void*) check_null(get_type(lc, rd->type)) },
+			{ "sectors", 2, log_uint64, &rd->sectors},
+			{ "size", 2, log_uint64, &rd->sectors},
+			{ "status", 2, log_string,
+			  (void*) check_null(get_status(lc, rd->status)) },
+		};
+
+		log_fields(lc, log_handlers, ARRAY_SIZE(log_handlers));
+	} else {
+		const char *fmt[] = {
+			"%s: %s, \"%s\", %s, %s, %" PRIu64 " sectors, "
+			"data@ %" PRIu64,
+			"%s",
+			"%s:%s:%s:%s:%s:%" PRIu64 ":%" PRIu64,
+		};
+	
+		log_print(lc, fmt[ARRAY_LIMIT(fmt, OPT_COLUMN(lc))],
+			  rd->di->path, rd->fmt->name, rd->name,
+			  check_null(get_type(lc, rd->type)),
+			  check_null(get_status(lc, rd->status)),
+			  rd->sectors, rd->offset);
+	}
+}
+
+/* Dispatch log functions. */
+static void log_devices(struct lib_context *lc, enum dev_type type)
+{
+	struct list_head *pos;
+	struct {
+		enum dev_type type;
+		struct list_head *list;
+		void (*log)(struct lib_context *, struct list_head *);
+	} types[] = {
+		{ DEVICE, LC_DI(lc), log_disk },
+		{ NATIVE, LC_RD(lc), log_rd_native },
+		{ RAID,   LC_RD(lc), log_rd },
+	}, *t = types;
+
+	do {
+		if (t->type == type) {
+			list_for_each(pos, t->list)
+				t->log(lc, pos);
+
+			return;
+		}
+	} while (t++ < ARRAY_END(types));
+
+	LOG_ERR(lc, , "%s: unknown device type", __func__);
+}
+
+/* Display information about a dmraid format handler */
+static void log_format(struct lib_context *lc, struct dmraid_format *fmt)
+{
+	log_print_nnl(lc, "%-7s : %s", fmt->name, fmt->descr);
+	if (fmt->caps)
+		log_print_nnl(lc, " (%s)", fmt->caps);
+
+	log_print(lc, "");
+}
+
+/* Pretty print a mapping table. */
+void display_table(struct lib_context *lc, char *rs_name, char *table)
+{
+	char *nl = table, *p;
+
+	do {
+		nl = remove_delimiter((p = nl), '\n');
+		log_print(lc, "%s: %s", rs_name, p);
+		add_delimiter(&nl, '\n');
+	} while (nl);
+}
+
+/* Display information about devices depending on device type. */
+void display_devices(struct lib_context *lc, enum dev_type type)
+{
+	int devs;
+
+	if ((devs = count_devices(lc, type))) {
+		log_info(lc, "%s device%s discovered:\n",
+			 (type & (RAID|NATIVE)) ? "RAID" : "Block",
+			  devs == 1 ? "" : "s");
+
+		log_devices(lc, type);
+	}
+}
+
+/* Retrieve format name from (hierarchical) raid set. */
+static void *get_format_name(struct raid_set *rs)
+{
+	struct dmraid_format *fmt = get_format(rs);
+
+	return (void*) check_null(fmt ? fmt->name : NULL);
+}
+
+static void log_rs(struct lib_context *lc, struct raid_set *rs)
+{
+	unsigned int devs = 0, spares = 0, subsets = 0;
+	uint64_t sectors = 0;
+
+	if (T_GROUP(rs) && !OPT_GROUP(lc))
+		return;
+	
+	sectors = total_sectors(lc, rs);
+	subsets = count_sets(lc, &rs->sets);
+	devs    = count_devs(lc, rs, ct_dev);
+	spares  = count_devs(lc, rs, ct_spare);
+	
+	if (OPT_STR_COLUMN(lc)) {
+		const struct log_handler log_handlers[] = {
+			{ "devices", 1, log_uint, &devs },
+			{ "format", 1, log_string, get_format_name(rs) },
+			{ "raidname", 1, log_string, rs->name },
+			{ "sectors", 2, log_uint64, &sectors },
+			{ "size", 2, log_uint64, &sectors },
+			{ "spares", 2, log_uint, &spares },
+			{ "status", 3, log_string,
+			   (void*) check_null(get_status(lc, rs->status)) },
+			{ "stride", 3, log_uint, &rs->stride },
+			{ "subsets", 2, log_uint, &subsets },
+			{ "type", 1, log_string,
+			   (void*) check_null(get_set_type(lc, rs)) },
+		};
+
+		log_fields(lc, log_handlers, ARRAY_SIZE(log_handlers));
+	} else {
+		const char *fmt[] = {
+			"name   : %s\n"
+			"size   : %" PRIu64 "\n"
+			"stride : %u\n"
+			"type   : %s\n"
+			"status : %s\n"
+			"subsets: %u\n"
+			"devs   : %u\n"
+			"spares : %u",
+			"%s",
+			"%s:%" PRIu64 ":%u:%s:%s:%u:%u:%u",
+		};
+		unsigned int o = ARRAY_LIMIT(fmt, lc_opt(lc, LC_COLUMN));
+	
+		log_print(lc, fmt[o],
+			  rs->name, sectors, rs->stride,
+			  check_null(get_set_type(lc, rs)),
+			  check_null(get_status(lc, rs->status)),
+			  subsets, devs, spares);
+	
+	}
+
+	if (OPT_COLUMN(lc) > 2) {
+		struct raid_dev *rd;
+	
+		list_for_each_entry(rd, &rs->devs, devs)
+			log_rd(lc, &rd->list);
+	}
+}
+
+static int group_active(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_set *r;
+
+	list_for_each_entry(r, &rs->sets, list) {
+		if (dm_status(lc, r))
+			return 1;
+	}
+
+	return 0;
+}
+
+/* FIXME: Spock, do something better (neater). */
+void display_set(struct lib_context *lc, void *v,
+		 enum active_type active, int top)
+{
+	struct raid_set *rs = v;
+	struct raid_set *r;
+	int dmstatus = T_GROUP(rs) ? group_active(lc, rs) : dm_status(lc, rs);
+
+	if (((active & D_ACTIVE) && !dmstatus) ||
+	    ((active & D_INACTIVE) && dmstatus))
+		return;
+
+	if (!OPT_COLUMN(lc)) {
+		if (T_GROUP(rs) && !OPT_GROUP(lc))
+			log_print(lc, "*** Group superset %s", rs->name);
+		else {
+			log_print(lc, "%s %s%s%set",
+		  		top ? "-->" : "***",
+		  		S_INCONSISTENT(rs->status) ?
+				"*Inconsistent* " : "",
+		  		dm_status(lc, rs) ? "Active " : "",
+		  		SETS(rs) ? "Supers" : (top ? "Subs" : "S"));
+		}
+	}
+
+	log_rs(lc, rs);
+
+	/* Optionally display subsets. */
+	if (T_GROUP(rs) || /* Always display for GROUP sets. */
+	    OPT_SETS(lc) > 1 ||
+	    OPT_COLUMN(lc) > 2) {
+		list_for_each_entry(r, &rs->sets, list)
+			display_set(lc, r, active, ++top);
+	}
+}
+
+/*
+ * Display information about supported RAID metadata formats
+ * (ie. registered format handlers)
+ */
+static void _list_formats(struct lib_context *lc, enum fmt_type type)
+{
+	struct format_list *fmt_list;
+
+	list_for_each_entry(fmt_list, LC_FMT(lc), list) {
+		if (type == fmt_list->fmt->format)
+			log_format(lc, fmt_list->fmt);
+	}
+}
+
+int list_formats(struct lib_context *lc, int arg)
+{
+	log_info(lc, "supported metadata formats:");
+	_list_formats(lc, FMT_RAID);
+	_list_formats(lc, FMT_PARTITION);
+
+	return 1;
+}
/cvs/dm/dmraid/lib/format/README,v  -->  standard output
revision 1.1
--- dmraid/lib/format/README
+++ -	2008-02-22 16:57:40.348899000 +0000
@@ -0,0 +1,7 @@
+
+This directory is the top for class-subdrectories containing dmraid
+metadata format handlers. Itself holds the format handler core with
+the handler registry.
+
+See template/README and template/template.[ch] for a metadata format
+handler template which shall (hopefully) help to implement your own.
/cvs/dm/dmraid/lib/format/format.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/format.c
+++ -	2008-02-22 16:57:40.520505000 +0000
@@ -0,0 +1,543 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+#include "ondisk.h"
+
+/*
+ * Metadata format handler registry.
+ */
+
+/*
+ * Used for development.
+ *
+ * Comment next line out to avoid pre-registration
+ * checks on metadata format handlers.
+ */
+#define	CHECK_FORMAT_HANDLER
+#ifdef	CHECK_FORMAT_HANDLER
+/*
+ * Check that mandatory members of a metadata form handler are present.
+ * 
+ * We can only use log_err and log_print here, because debug and verbose
+ * options are checked for later during initialization...
+ */
+
+/*
+ * Because we have a bunch of members to check,
+ * let's define them as an array.
+ */
+#define offset(member)	struct_offset(dmraid_format, member)
+
+struct format_member {
+	const unsigned short offset;
+	const unsigned char all;
+	const unsigned char method;
+	const char *msg;
+} __attribute__ ((packed));
+
+static struct format_member format_member[] = {
+	{ offset(name),   1, 0, "name" },
+	{ offset(descr),  1, 0, "description" },
+	{ offset(caps),   0, 0, "capabilities" },
+	{ offset(read),   1, 1, "read" },
+	{ offset(write),  0, 1, "write" },
+	{ offset(group),  1, 1, "group" },
+	{ offset(check),  1, 1, "check" },
+	{ offset(events), 0, 0, "events array" },
+#ifdef	NATIVE_LOG
+	{ offset(log),    0, 1, "log" },
+#endif
+};
+#undef	offset
+
+static int check_member(struct lib_context *lc, struct dmraid_format *fmt,
+			struct format_member *member)
+{
+	if ((!member->all && fmt->format != FMT_RAID) ||
+	    *((unsigned long*) (((unsigned char*) fmt) + member->offset)))
+		return 0;
+
+	LOG_ERR(lc, 1, "%s: missing metadata format handler %s%s",
+		fmt->name, member->msg, member->method ? " method" : "");
+}
+
+static int check_format_handler(struct lib_context *lc,
+				struct dmraid_format *fmt)
+{
+	unsigned int error = 0;
+	struct format_member *fm = format_member;
+
+	if (!fmt)
+		BUG(lc, 0, "NULL metadata format handler");
+
+	while (fm < ARRAY_END(format_member))
+		error += check_member(lc, fmt, fm++);
+
+	return !error;
+}
+#endif /* CHECK_FORMAT_HANDLER */
+
+/*
+ * Register a RAID metadata format handler.
+ */
+int register_format_handler(struct lib_context *lc, struct dmraid_format *fmt)
+{
+	struct format_list *fl;
+
+#ifdef	CHECK_FORMAT_HANDLER
+	if (!check_format_handler(lc, fmt))
+		return 0;
+#undef	CHECK_FORMAT_HANDLER
+#endif
+	if ((fl = dbg_malloc(sizeof(*fl)))) {
+		fl->fmt = fmt;
+		list_add_tail(&fl->list, LC_FMT(lc));
+	}
+
+	return fl ? 1 : 0;
+}
+
+/*
+ * (Un)Register all format handlers.
+ *
+ * I use an array because of the growing number...
+ */
+static struct register_fh {
+	int (*func)(struct lib_context *lc);
+} register_fh[] = {
+#include "register.h"
+	{ NULL },
+};
+
+void unregister_format_handlers(struct lib_context *lc)
+{
+	struct list_head *elem, *tmp;
+
+	list_for_each_safe(elem, tmp, LC_FMT(lc)) {
+		list_del(elem);
+		dbg_free(list_entry(elem, struct format_list, list));
+	}
+}
+
+int register_format_handlers(struct lib_context *lc)
+{
+	int ret = 1;
+	struct register_fh *fh;
+
+	for (fh = register_fh; fh->func; fh++) {
+		if ((ret = fh->func(lc)))
+			continue;
+
+		/* Clean up in case of error. */
+		log_err(lc, "registering format");
+		unregister_format_handlers(lc);
+		break;
+	}
+
+	return ret;
+}
+/* END metadata format handler registry. */
+
+
+/*
+ * Other metadata format handler support functions.
+ */
+
+/* Allocate private space in format handlers (eg, for on-disk metadata). */
+void *alloc_private(struct lib_context *lc, const char *who, size_t size)
+{
+	void *ret;
+
+	if (!(ret = dbg_malloc(size)))
+		log_err(lc, "allocating %s metadata", who);
+
+	return ret;
+}
+
+/* Allocate private space in format handlers and read data off device. */
+void *alloc_private_and_read(struct lib_context *lc, const char *who,
+			     size_t size, char *path, loff_t offset)
+{
+	void *ret;
+
+	if ((ret = alloc_private(lc, who, size))) {
+		if (!read_file(lc, who, path, ret, size, offset)) {
+			dbg_free(ret);
+			ret = NULL;
+		}
+	}
+
+	return ret;
+}
+
+
+/* Allocate metadata sector array in format handlers. */
+void *alloc_meta_areas(struct lib_context *lc, struct raid_dev *rd,
+		       const char *who, unsigned int n)
+{
+	void *ret;
+
+	if ((ret = alloc_private(lc, who, n * sizeof(*rd->meta_areas))))
+		rd->areas = n;
+
+	return ret;
+}
+
+/* Simple metadata write function for format handlers. */
+static int _write_metadata(struct lib_context *lc, const char *handler,
+			   struct raid_dev *rd, int idx, int erase)
+{
+	int ret = 0;
+	void *p, *tmp;
+
+	if (idx >= rd->areas)
+		goto out;
+
+	p = tmp = rd->meta_areas[idx].area;
+	if (erase &&
+	    !(p = alloc_private(lc, handler, rd->meta_areas[idx].size)))
+		goto out;
+
+	ret = write_file(lc, handler, rd->di->path, (void*) p,
+			 rd->meta_areas[idx].size,
+			 rd->meta_areas[idx].offset << 9);
+
+	log_level(lc, ret ? _PLOG_DEBUG : _PLOG_ERR, 
+		  "writing metadata to %s, offset %" PRIu64 " sectors, "
+		  "size %zu bytes returned %d",
+		  rd->di->path, rd->meta_areas[idx].offset,
+		  rd->meta_areas[idx].size, ret); 
+
+	if (p != tmp)
+		dbg_free(p);
+
+  out:
+	return ret;
+}
+
+int write_metadata(struct lib_context *lc, const char *handler,
+		   struct raid_dev *rd, int idx, int erase)
+{
+	unsigned int i;
+
+	if (idx > -1)
+		return _write_metadata(lc, handler, rd, idx, erase);
+
+	for (i = 0; i < rd->areas; i++) {
+		if (!_write_metadata(lc, handler, rd, i, erase))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Check devices in a RAID set.
+ *
+ * a. spares in a mirror set need to be large enough.
+ * b. # of devices correct.
+ */
+static void _check_raid_set(struct lib_context *lc, struct raid_set *rs,
+		       unsigned int (*f_devices)(struct raid_dev *rd,
+						 void *context),
+		       void *f_devices_context,
+		       int (*f_check)(struct lib_context *lc,
+				      struct raid_set *rs,
+				      struct raid_dev *rd,
+				      void *context),
+		       void *f_check_context,
+		       const char *handler)
+{
+	unsigned int devs;
+	uint64_t sectors;
+	struct raid_dev *rd;
+
+	if (!DEVS(rs))
+		return;
+
+	sectors = total_sectors(lc, rs);
+	rs->total_devs = devs = count_devs(lc, rs, ct_dev);
+	list_for_each_entry(rd, &rs->devs, devs) {
+		unsigned int devices = f_devices(rd, f_devices_context);
+		/* FIXME: error if the metadatas aren't all the same? */
+		rs->found_devs = devices;
+
+		log_dbg(lc, "checking %s device \"%s\"", handler, rd->di->path);
+		if (T_SPARE(rd) &&
+		    rs->type == t_raid1 &&	/* FIXME: rs->type check ? */
+		    rd->sectors != sectors) {
+			rd->status = s_inconsistent;
+			log_err(lc, "%s: size mismatch in set \"%s\", spare "
+				"\"%s\"", handler, rs->name, rd->di->path);
+			continue;
+		}
+
+		if (devs != devices &&
+		    f_check &&
+		    !f_check(lc, rs, rd, f_check_context)) {
+			rd->status = s_broken;
+			log_err(lc, "%s: wrong # of devices in RAID "
+				"set \"%s\" [%u/%u] on %s",
+	   			handler, rs->name, devs, devices, rd->di->path);
+		} else
+			rd->status = s_ok;
+	}
+}
+
+/*
+ * Update RAID set state based on operational subsets/devices.
+ *
+ * In case of a RAID set hierachy, check availability of subsets
+ * and set superset to broken in case *all* subsets are broken.
+ * If at least one is still available, set to inconsistent.
+ *
+ * In case of lowest level RAID sets, check consistence of devices
+ * and make the above decision at the device level.
+ */
+static void _set_rs_status(struct lib_context *lc, struct raid_set *rs,
+			   unsigned int i, unsigned int operational)
+{
+	if (operational == i)
+		rs->status = s_ok;
+	else if (operational)
+		rs->status = s_inconsistent;
+	else
+		rs->status = s_broken;
+
+	log_dbg(lc, "set status of set \"%s\" to %u", rs->name, rs->status);
+}
+
+static int set_rs_status(struct lib_context *lc, struct raid_set *rs)
+{
+	unsigned int i = 0, operational = 0;
+	struct raid_set *r;
+	struct raid_dev *rd;
+
+	/* Set status of subsets. */
+	list_for_each_entry(r, &rs->sets, list) {
+		/* Check subsets to set status of superset. */
+		i++;
+		if (S_OK(r->status) || S_INCONSISTENT(r->status))
+			operational++;
+	}
+	
+	/* Check status of devices... */
+	list_for_each_entry(rd, &rs->devs, devs) {
+		i++;
+		if (S_OK(rd->status))
+			operational++;
+	}
+	
+	_set_rs_status(lc, rs, i, operational);
+
+	return S_BROKEN(rs->status) ? 0 : 1;
+}
+
+/*
+ * Check stack of RAID sets.
+ *
+ * This tiny helper function avoids coding recursive
+ * RAID set stack unrolling in every metadata format handler.
+ */
+int check_raid_set(struct lib_context *lc, struct raid_set *rs,
+		   unsigned int (*f_devices)(struct raid_dev *rd,
+					     void *context),
+		   void *f_devices_context,
+		   int (*f_check)(struct lib_context *lc, struct raid_set *r,
+				  struct raid_dev *rd, void *context),
+		   void *f_check_context,
+		   const char *handler)
+{
+	struct raid_set *r;
+
+	list_for_each_entry(r, &rs->sets, list)
+		check_raid_set(lc, r, f_devices, f_devices_context,
+			       f_check, f_check_context, handler);
+
+	/* Never check group RAID sets. */
+	if (!T_GROUP(rs))
+		_check_raid_set(lc, rs, f_devices, f_devices_context,
+				f_check, f_check_context, handler);
+
+	return set_rs_status(lc, rs);
+}
+
+/* Initialize a RAID sets type and stride. */
+int init_raid_set(struct lib_context *lc, struct raid_set *rs,
+		  struct raid_dev *rd, unsigned int stride,
+		  unsigned int type, const char *handler)
+{
+	if (T_UNDEF(rd))
+		LOG_ERR(lc, 0, "%s: RAID type %u not supported", handler, type);
+
+	if (T_SPARE(rs) || T_UNDEF(rs))
+		rs->type = rd->type;
+	else if (!T_SPARE(rd) && rs->type != rd->type)
+		log_err(lc, "%s: RAID type mismatch in \"%s\" on  %s",
+			handler, rs->name, rd->di->path);
+
+	if (rs->stride) {
+		if (rs->stride != stride)
+			LOG_ERR(lc, 0,
+				"%s: stride inconsistency detected on \"%s\"",
+				handler, rd->di->path);
+	} else
+		rs->stride = stride;
+
+	return 1;
+}
+
+/* Discover RAID metadata and setup RAID device. */
+struct raid_dev *read_raid_dev(
+	struct lib_context *lc,
+	struct dev_info *di,
+	void* (*f_read_metadata)(struct lib_context *lc, struct dev_info *di,
+				 size_t *size, uint64_t *offset,
+				 union read_info *info),
+	size_t size, uint64_t offset,
+	void (*f_to_cpu)(void *meta),
+	int (*f_is_meta)(struct lib_context *lc, struct dev_info *di,
+			 void *meta),
+	void (*f_file_metadata)(struct lib_context *lc, struct dev_info *di,
+				void *meta),
+	int (*f_setup_rd)(struct lib_context *lc, struct raid_dev *rd,
+			  struct dev_info *di, void *meta,
+			  union read_info *info),
+	const char *handler)
+{
+	struct raid_dev *rd = NULL;
+	void *meta;
+	union read_info info;
+
+	/*
+	 * In case the metadata format handler provides a special
+	 * metadata read function, use that. If not, allocate and
+	 * read size from offset.
+	 */
+	meta = f_read_metadata ? f_read_metadata(lc, di, &size, &offset,
+						 &info) :
+				 alloc_private_and_read(lc, handler, size,
+							di->path, offset);
+	if (!meta)
+		goto out;
+
+	/* If endianess conversion function provided -> call it. */
+	if (f_to_cpu)
+		f_to_cpu(meta);
+
+	/* Optionally check that metadata is valid. */
+	if (f_is_meta && !f_is_meta(lc, di, meta))
+		goto bad;
+
+	/* If metadata file function provided -> call it else default filing. */
+	if (f_file_metadata)
+		f_file_metadata(lc, di, meta);
+	else {
+		file_metadata(lc, handler, di->path, meta, size, offset);
+		file_dev_size(lc, handler, di);
+	}
+
+	/* Allocate RAID device structure. */
+	if (!(rd = alloc_raid_dev(lc, handler)))
+		goto bad;
+
+	/* Use metadata format handler setup function on it. */
+	if (f_setup_rd(lc, rd, di, meta, &info))
+		goto out;
+
+	log_err(lc, "%s: setting up RAID device %s", handler, di->path);
+	free_raid_dev(lc, &rd);
+	goto out;
+
+   bad:
+	dbg_free(meta);
+   out:
+	return rd;
+}
+
+/* Check if format identifier is valid. */
+int check_valid_format(struct lib_context *lc, char *name)
+{
+	struct format_list *fl;
+
+	/* FIXME: support wildcards. */
+	list_for_each_entry(fl, LC_FMT(lc), list) {
+		if (!strncmp(name, fl->fmt->name, strlen(name)))
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Set up a format capabilities (ie, RAID levels) string array.
+ */
+const char **get_format_caps(struct lib_context *lc, struct dmraid_format *fmt)
+{
+	int i;
+	char *caps, *p;
+	const char **ret = NULL, delim = ',';
+
+	if (fmt->caps && (caps = dbg_strdup((char*) fmt->caps))) {
+		/* Count capabilities delimiters. */
+		for (i = 0, p = caps; (p = remove_delimiter(p, delim)); i++)
+			add_delimiter(&p, delim);
+
+		if ((ret = dbg_malloc(sizeof(*ret) * (i + 2)))) {
+			for (i = 0, p = caps - 1; p;
+			     (p = remove_delimiter(p, delim)))
+				ret[i++] = ++p;
+		} else
+			dbg_free(caps);
+	}
+
+	return ret;
+}
+
+void free_format_caps(struct lib_context *lc, const char **caps)
+{
+	if (caps) {
+		dbg_free((char*) *caps);
+		dbg_free(caps);
+	}
+}
+
+/*
+ * Allocate a RAID superset and link the subset to it.
+ */
+struct raid_set *join_superset(struct lib_context *lc,
+			       char *(*f_name)(struct lib_context *lc,
+					       struct raid_dev *rd,
+					       unsigned int subset),
+			       void (*f_create)(struct raid_set *super,
+					        void *private),
+			       int (*f_set_sort)(struct list_head *pos,
+						 struct list_head *new),
+			       struct raid_set *rs,
+			       struct raid_dev *rd)
+{
+	char *n;
+	struct raid_set *ret = NULL;
+
+	if ((n = f_name(lc, rd, 0))) {
+		if ((ret = find_or_alloc_raid_set(lc, n, FIND_TOP, NO_RD,
+						  LC_RS(lc), f_create, rd)) &&
+		    !find_set(lc, &ret->sets, rs->name, FIND_TOP))
+			list_add_sorted(lc, &ret->sets, &rs->list, f_set_sort);
+
+		dbg_free(n);
+	}
+
+	return ret;
+}
+
+/* Display 'zero sectors on RAID' device error. */
+int log_zero_sectors(struct lib_context *lc, char *path, const char *handler)
+{
+	LOG_ERR(lc, 0, "%s: zero sectors on %s", handler, path);
+}
/cvs/dm/dmraid/lib/format/ondisk.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ondisk.h
+++ -	2008-02-22 16:57:40.630250000 +0000
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _ONDISK_H_
+#define	_ONDISK_H_
+
+#include "ataraid/asr.h"
+#include "ataraid/hpt37x.h"
+#include "ataraid/hpt45x.h"
+#include "ataraid/isw.h"
+#include "ataraid/jm.h"
+#include "ataraid/lsi.h"
+#include "ataraid/nv.h"
+#include "ataraid/pdc.h"
+#include "ataraid/via.h"
+#include "ataraid/sil.h"
+#include "ataraid/asr.h"
+
+#include "partition/dos.h"
+
+#endif
/cvs/dm/dmraid/lib/format/register.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/register.h
+++ -	2008-02-22 16:57:40.709286000 +0000
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * List of format handler register functions
+ */
+
+#ifndef	_REGISTER_H_
+#define	_REGISTER_H_
+
+#define	xx(type)	{ register_ ## type },
+
+	/* Metadata format handlers. */
+	xx(asr)
+	xx(hpt37x)
+	xx(hpt45x)
+	xx(isw)
+	xx(jm)
+	xx(lsi)
+	xx(nv)
+	xx(pdc)
+	xx(sil)
+	xx(via)
+
+	/* DOS partition type handler. */
+	xx(dos)
+
+#undef	xx
+#endif
/cvs/dm/dmraid/lib/format/ataraid/README,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/README
+++ -	2008-02-22 16:57:40.787423000 +0000
@@ -0,0 +1,20 @@
+
+This directory contains metadata format handlers for various ATARAID cards.
+
+Some useful metadata offsets/lengths (in 512 byte sector sizes):
+----------------------------------------------------------------
+
+Highpoint 45x *doesn't* zero the one on-disk metadata at -11,
+length 1 on drive removal.
+
+Intel Software RAID has metadata at -2 (conditionally -n), length in
+metadata structure member mpbSize.
+
+LSI Logic MegaRAID has metadata at -1, length 1.
+
+NVidea NForce has metadata at -2, length 1.
+
+Silicon Image Medley zeroes all 4 on-disk metadata areas
+(at -1, -512, -1024, -1536; length 4) on drive removal.
+
+VIA has metadata at -1, length 1.
/cvs/dm/dmraid/lib/format/ataraid/asr.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/asr.c
+++ -	2008-02-22 16:57:40.867817000 +0000
@@ -0,0 +1,873 @@
+/*
+ * Adaptec HostRAID ASR format interpreter for dmraid.
+ * Copyright (C) 2005-2006 IBM, All rights reserved.
+ * Written by Darrick Wong <djwong@us.ibm.com>
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <errno.h>
+#include <netinet/in.h>
+
+#define	HANDLER	"asr"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "asr.h"
+
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+#define SPARE_ARRAY	".asr_spares"
+
+static int asr_write(struct lib_context *lc,  struct raid_dev *rd, int erase);
+
+/* Map ASR disk status to dmraid status */
+static enum status disk_status(struct asr_raid_configline *disk) {
+	if (disk == NULL)
+		return s_undef;
+
+	switch (disk->raidstate) {
+	case LSU_COMPONENT_STATE_OPTIMAL:
+		return s_ok;
+
+	case LSU_COMPONENT_STATE_DEGRADED:
+	case LSU_COMPONENT_STATE_FAILED:
+		return s_broken;
+
+	case LSU_COMPONENT_STATE_UNINITIALIZED:
+	case LSU_COMPONENT_STATE_UNCONFIGURED:
+		return s_inconsistent;
+
+	case LSU_COMPONENT_SUBSTATE_BUILDING:
+	case LSU_COMPONENT_SUBSTATE_REBUILDING:
+	case LSU_COMPONENT_STATE_REPLACED:
+		return s_nosync;
+
+	default:
+		return s_undef;
+	}
+}
+		
+/* Extract config line from metadata */
+static struct asr_raid_configline *get_config(struct asr *asr, uint32_t magic)
+{
+	unsigned int i;
+	
+	for (i = 0; i < asr->rt->elmcnt; i++) {
+		if (asr->rt->ent[i].raidmagic == magic)
+			return asr->rt->ent + i;
+	}
+
+	return NULL;
+}
+
+/* Get this disk's configuration */
+static struct asr_raid_configline *this_disk(struct asr *asr)
+{
+	return get_config(asr, asr->rb.drivemagic);
+}
+
+/* Make up RAID device name. */
+static size_t _name(struct lib_context *lc, struct asr *asr, char *str,
+		    size_t len)
+{
+	struct asr_raid_configline *cl = this_disk(asr);
+
+	if (cl)
+		return snprintf(str, len, "%s_%s", HANDLER, cl->name);
+
+	LOG_ERR(lc, 0, "%s: Could not find device in config table!", handler);
+}
+
+/* Figure out a name for the RAID device. */
+static char *name(struct lib_context *lc, struct asr *asr)
+{
+	size_t len;
+	char *ret;
+
+	if ((ret = dbg_malloc((len = _name(lc, asr, NULL, 0) + 1)))) {
+		_name(lc, asr, ret, len);
+		/* Why do we call mk_alpha?  This makes labels like
+		 * "OS-u320-15k" become "OS-udca-bek", which is confusing.
+		 * mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN); */
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/* Stride size */
+static inline unsigned int stride(struct asr_raid_configline *cl)
+{
+	return cl ? cl->strpsize: 0;
+}
+
+/* Mapping of template types to generic types */
+/*
+ * FIXME: This needs more examination.  Does HostRAID do linear
+ * combination?  The BIOS implies that it only does RAID 0, 1 and 10.
+ * The emd driver implied support for RAID3/4/5, but dm doesn't
+ * do any of those right now (RAID4 and RAID5 are in the works).
+ */
+static struct types types[] = {
+	{ ASR_RAID0,   t_raid0 },
+	{ ASR_RAID1,   t_raid1 },
+	{ ASR_RAIDSPR, t_spare },
+        { 0, t_undef}
+};
+
+/* Map the ASR raid type codes into dmraid type codes. */
+static enum type type(struct asr_raid_configline *cl)
+{
+	return cl ? rd_type(types, (unsigned int) cl->raidtype) : t_undef;
+}
+
+/*
+ * Read an ASR RAID device.  Fields are big endian, so
+ * need to convert them if we're on a LE machine (i386, etc).
+ */
+#define ASR_BLOCK	0x01
+#define ASR_TABLE	0x02
+#define ASR_EXTTABLE 	0x04
+
+#if	BYTE_ORDER == LITTLE_ENDIAN
+static void cvt_configline(struct asr_raid_configline *cl)
+{
+	CVT16(cl->raidcnt);
+	CVT16(cl->raidseq);
+	CVT32(cl->raidmagic);
+	CVT32(cl->raidid);
+	CVT32(cl->loffset);
+	CVT32(cl->lcapcty);
+	CVT16(cl->strpsize);
+	CVT16(cl->biosInfo);
+	CVT32(cl->lsu);
+	CVT16(cl->blockStorageTid);
+	CVT32(cl->curAppBlock);
+	CVT32(cl->appBurstCount);
+}
+
+static void to_cpu(void *meta, unsigned int cvt)
+{
+	int i;
+	struct asr *asr = meta;
+	int elmcnt = asr->rt->elmcnt;
+
+	int use_old_elmcnt = (asr->rt->ridcode == RVALID2);
+
+	if (cvt & ASR_BLOCK) {
+		CVT32(asr->rb.b0idcode);
+		CVT16(asr->rb.biosInfo);
+		CVT32(asr->rb.fstrsvrb);
+		CVT16(asr->rb.svBlockStorageTid);
+		CVT16(asr->rb.svtid);
+		CVT32(asr->rb.drivemagic);
+		CVT32(asr->rb.fwTestMagic);
+		CVT32(asr->rb.fwTestSeqNum);
+		CVT32(asr->rb.smagic);
+		CVT32(asr->rb.raidtbl);
+	}
+
+	if (cvt & ASR_TABLE) {
+		CVT32(asr->rt->ridcode);
+		CVT32(asr->rt->rversion);
+		CVT16(asr->rt->maxelm);
+		CVT16(asr->rt->elmcnt);
+		if (!use_old_elmcnt)
+			elmcnt = asr->rt->elmcnt;
+		CVT16(asr->rt->elmsize);
+		CVT32(asr->rt->raidFlags);
+		CVT32(asr->rt->timestamp);
+		CVT16(asr->rt->rchksum);
+		CVT32(asr->rt->sparedrivemagic);
+		CVT32(asr->rt->raidmagic);
+		CVT32(asr->rt->verifyDate);
+		CVT32(asr->rt->recreateDate);
+
+		/* Convert the first seven config lines */
+		for (i = 0; i < (elmcnt < 7 ? elmcnt : 7); i++) 
+			cvt_configline(asr->rt->ent + i);
+		
+	}
+
+	if (cvt & ASR_EXTTABLE) {
+		for (i = 7; i < elmcnt; i++) {
+			cvt_configline(asr->rt->ent + i);
+		}
+	}
+}
+
+#else
+# define to_cpu(x, y)
+#endif
+
+/* Compute the checksum of RAID metadata */
+static unsigned int compute_checksum(struct asr *asr)
+{
+	uint8_t *ptr;
+	unsigned int i, checksum;
+
+	/* Compute checksum. */
+	ptr = (uint8_t*) asr->rt->ent;
+	checksum = 0;
+	for (i = 0; i < sizeof(*asr->rt->ent) * asr->rt->elmcnt; i++)
+		checksum += ptr[i];
+
+	return checksum & 0xFFFF;
+}
+
+/* Read extended metadata areas */
+static int read_extended(struct lib_context *lc, struct dev_info *di,
+			 struct asr *asr)
+{
+	unsigned int remaining, i, chk;
+	int j;
+
+	log_info(lc, "%s: reading extended data", di->path);
+	
+	/* Read the RAID table. */
+	if (!read_file(lc, handler, di->path, asr->rt, ASR_DISK_BLOCK_SIZE,
+		       (uint64_t) asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE))
+		LOG_ERR(lc, 0, "%s: Could not read metadata.", handler);
+
+	/* Convert it */
+	to_cpu(asr, ASR_TABLE);
+	
+	/* Is this ok? */
+	if (asr->rt->ridcode != RVALID2)
+		LOG_ERR(lc, 0, "%s: Invalid magic number in RAID table; "
+			"saw 0x%X, expected 0x%X.", handler, asr->rt->ridcode,
+			RVALID2);
+
+	/* Have we a valid element count? */
+	if (asr->rt->elmcnt >= asr->rt->maxelm)
+		LOG_ERR(lc, 0, "%s: Invalid RAID config table count.\n",
+			handler);
+
+	/* Is each element the right size? */
+	if (asr->rt->elmsize != sizeof(struct asr_raid_configline))
+		LOG_ERR(lc, 0, "%s: RAID config line is the wrong size.\n",
+			handler);
+
+	/* Figure out how much else we need to read. */
+	if (asr->rt->elmcnt > 7) {
+		remaining = asr->rt->elmsize * (asr->rt->elmcnt - 7);
+		if (!read_file(lc, handler, di->path, asr->rt->ent + 7,
+			       remaining, (uint64_t)(asr->rb.raidtbl + 1) *
+			       ASR_DISK_BLOCK_SIZE))
+			return 0;
+
+		to_cpu(asr, ASR_EXTTABLE);
+	}
+
+	chk = compute_checksum(asr);
+	if (chk != asr->rt->rchksum)
+		LOG_ERR(lc, 0,"%s: Invalid RAID config table checksum "
+			       "(0x%X vs. 0x%X).",
+			handler, chk, asr->rt->rchksum);
+	
+	/* Process the name of each line of the config line. */
+	for (i = 0; i < asr->rt->elmcnt; i++) {
+		/* 
+		 * Weird quirks of the name field of the config line:
+		 *
+		 * - SATA HostRAID w/ ICH5 on IBM x226: The name field is null
+		 *   in the drive config lines.  The zeroeth item does have a
+		 *   name, however.
+		 * - Spares on SCSI HostRAID on IBM x226: The name field for
+		 *   all config lines is null.
+		 * 
+		 * So, we'll assume that we can copy the name from the zeroeth
+		 * element in the array.  The twisted logic doesn't seem to
+		 * have a problem with either of the above cases, though
+		 * attaching spares is going to be a tad tricky (primarily
+		 * because there doesn't seem to be a way to attach a spare to
+		 * a particular array; presumably the binary driver knows how
+		 * or just grabs a disk out of the spare pool.
+		 *
+		 * (Yes, the binary driver _does_ just grab a disk from the
+		 * global spare pool.  We must teach dm about this...?)
+		 *
+		 * This is nuts.
+		 */
+		if (!asr->rt->ent[i].name)
+			memcpy(asr->rt->ent[i].name, asr->rt->ent[0].name, 16);
+
+		/* Now truncate trailing whitespace in the name. */
+		for (j = 15; j >= 0; j--) {
+			if (asr->rt->ent[i].name[j] != ' ')
+				break;
+		}
+		asr->rt->ent[i].name[j + 1] = 0;
+	}
+
+	return 1;
+}
+
+static int is_asr(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct asr *asr = meta;
+
+	/*
+	 * Check our magic numbers and that the version == v8.
+	 * We don't support anything other than that right now.
+	 */
+	if (asr->rb.b0idcode == B0RESRVD &&
+	    asr->rb.smagic == SVALID) {
+		if (asr->rb.resver == RBLOCK_VER)
+			return 1;
+		
+		LOG_ERR(lc, 0,
+			"%s: ASR v%d detected, but we only support v8.\n",
+			handler, asr->rb.resver);
+	}
+
+	return 0;
+}
+
+/*
+ * Attempt to interpret ASR metadata from a block device.  This function
+ * returns either NULL (not an ASR) or a pointer to a descriptor struct.
+ * Note that the struct should be fully converted to the correct endianness
+ * by the time this function returns.
+ *
+ * WARNING: If you take disks out of an ASR HostRAID array and plug them in
+ * to a normal SCSI controller, the array will still show up!  Even if you
+ * scribble over the disks!  I assume that the a320raid binary driver only
+ * does its HostRAID magic if your controller is in RAID mode... but dmraid
+ * lacks this sort of visibility as to where its block devices come from.
+ * This is EXTREMELY DANGEROUS if you aren't careful!
+ */
+static void *read_metadata_areas(struct lib_context *lc, struct dev_info *di,
+				 size_t *sz, uint64_t *offset,
+				 union read_info *info)
+{
+	size_t size = ASR_DISK_BLOCK_SIZE;
+	uint64_t asr_sboffset = ASR_CONFIGOFFSET;
+	struct asr *asr;
+	struct asr_raid_configline *cl;
+
+	/*
+	 * Read the ASR reserved block on each disk.  This is the very
+	 * last sector of the disk, and we're really only interested in
+	 * the two magic numbers, the version, and the pointer to the
+	 * RAID table.  Everything else appears to be unused in v8.
+	 */
+	if (!(asr = alloc_private(lc, handler, sizeof(struct asr))))
+		goto bad0;
+	
+	if (!(asr->rt = alloc_private(lc, handler, sizeof(struct asr_raidtable))))
+		goto bad1;
+
+	if (!read_file(lc, handler, di->path, &asr->rb, size, asr_sboffset))
+		goto bad2;
+
+	/*
+	 * Convert metadata and read in 
+	 */
+	to_cpu(asr, ASR_BLOCK);
+
+	/* Check Signature and read optional extended metadata. */
+	if (!is_asr(lc, di, asr) ||
+	    !read_extended(lc, di, asr))
+		goto bad2;
+
+	/*
+	 * Now that we made sure that we have all the metadata, we exit.
+	 */
+	cl = this_disk(asr);
+	if (cl->raidstate == LSU_COMPONENT_STATE_FAILED)
+		goto bad2;
+
+	goto out;
+
+   bad2:
+	dbg_free(asr->rt);
+   bad1:
+	asr->rt = NULL;
+	dbg_free(asr);
+   bad0:
+	asr = NULL;
+
+   out:
+	return (void*) asr;
+}
+
+/*
+ * "File the metadata areas" -- I think this function is supposed to declare
+ * which parts of the drive are metadata and thus off-limits to dmraid.
+ */
+static void file_metadata_areas(struct lib_context *lc, struct dev_info *di,
+				void *meta)
+{
+	struct asr *asr = meta;
+
+	/* Register the raid tables. */
+	file_metadata(lc, handler, di->path, asr->rt,
+		      ASR_DISK_BLOCK_SIZE * 17,
+		      (uint64_t)asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE);
+
+	/* Record the device size if -D was specified. */
+	file_dev_size(lc, handler, di);
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+
+static struct raid_dev *asr_read(struct lib_context *lc,
+					struct dev_info *di)
+{
+	/*
+	 * NOTE: Everything called after read_metadata_areas assumes that
+	 * the reserved block, raid table and config table have been
+	 * converted to the appropriate endianness.
+	 */
+	return read_raid_dev(lc, di, read_metadata_areas, 0, 0, NULL, NULL,
+			     file_metadata_areas, setup_rd, handler);
+}
+
+static int set_sort(struct list_head *dont, struct list_head *care)
+{
+	return 0;
+}
+
+/*
+ * Compose a 64-bit ID for device sorting.
+ * Is hba:ch:lun:id ok?  It seems to be the way the binary driver
+ * does it...
+ */
+static inline uint64_t compose_id(struct asr_raid_configline *cl)
+{
+	return    ((uint64_t) cl->raidhba  << 48)
+		| ((uint64_t) cl->raidchnl << 40)
+		| ((uint64_t) cl->raidlun  << 32)
+		| (uint64_t) cl->raidid;
+}
+
+/* Sort ASR devices by for a RAID set. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return compose_id(this_disk(META(RD(new), asr))) <
+	       compose_id(this_disk(META(RD(pos), asr)));
+}
+
+/*
+ * Find the top-level RAID set for an ASR context.
+ */
+static int find_toplevel(struct lib_context *lc, struct asr *asr)
+{
+	int i, toplevel = -1;
+
+	for (i = 0; i < asr->rt->elmcnt; i++) {
+		if (asr->rt->ent[i].raidlevel == FWL)
+		{
+			toplevel = i;
+		}
+		else if (asr->rt->ent[i].raidlevel == FWL_2)
+		{
+			toplevel = i;
+			break;
+		}
+	}
+	
+	return toplevel;
+}
+
+/*
+ * Find the logical drive configuration that goes with this
+ * physical disk configuration.
+ */
+static struct asr_raid_configline *find_logical(struct asr *asr)
+{
+	int i, j;
+
+	/* This MUST be done backwards! */
+	for (i = asr->rt->elmcnt - 1; i > -1; i--) {
+		if (asr->rt->ent[i].raidmagic == asr->rb.drivemagic)
+		{
+			for (j = i - 1; j > -1; j--) {
+				if (asr->rt->ent[j].raidlevel == FWL)
+				{
+					return &asr->rt->ent[j];
+				}
+			}
+		}
+	}
+
+	return NULL;
+}
+
+/* Wrapper for name() */
+static char *js_name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	return name(lc, META(rd, asr));
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct asr *asr = META(rd, asr);
+	struct asr_raid_configline *cl = this_disk(asr);
+	struct asr_raid_configline *fwl = find_logical(asr);
+
+	/* Ignore if we've already marked this disk broken(?) */
+	if (rd->status & s_broken)
+		return 0;
+	
+	log_err(lc, "I/O error on device %s at sector %lu.",
+		e_io->rd->di->path, e_io->sector);
+
+	/* Mark the array as degraded and the disk as failed. */
+	rd->status = s_broken;
+	cl->raidstate = LSU_COMPONENT_STATE_FAILED;
+	fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
+	/* FIXME: Do we have to mark a parent too? */
+
+	/* Indicate that this is indeed a failure. */
+	return 1;
+}
+
+/* 
+ * Add an ASR device to a RAID set.  This involves finding the raid set to
+ * which this disk belongs, and then attaching it.  Note that there are other
+ * complications, such as two-layer arrays (RAID10).
+ */
+#define BUFSIZE 128
+static struct raid_set *asr_group(struct lib_context *lc, struct raid_dev *rd)
+{
+	int top_idx;
+	struct asr *asr = META(rd, asr);
+	struct asr_raid_configline *cl = this_disk(asr);
+	struct asr_raid_configline *fwl;
+	struct raid_set *set, *sset;
+	char buf[BUFSIZE];
+
+	if (T_SPARE(rd)) {
+		/*
+		 * If this drive really _is_ attached to a specific
+		 * RAID set, then just attach it.  Really old HostRAID cards
+		 * do this... but I don't have any hardware to test this.
+		 */
+		/*
+		 * FIXME: dmraid ignores spares attached to RAID arrays.
+		 * For now, we'll let it get sucked into the ASR spare pool. 
+		 * If we need it, we'll reconfigure it; if not, nobody touches
+		 * it.
+		 *
+		set = find_set(lc, name(lc, asr), FIND_TOP, rd, LC_RS(lc),
+			       NO_CREATE, NO_CREATE_ARG);
+		 */
+
+		/* Otherwise, make a global spare pool. */
+		set = find_or_alloc_raid_set(lc, (char*)SPARE_ARRAY,
+			FIND_TOP, rd, LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
+
+		/*
+		 * Setting the type to t_spare guarantees that dmraid won't
+		 * try to set up a real device-mapper mapping.
+		 */
+		set->type = t_spare;
+
+		/* Add the disk to the set. */
+		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
+		return set;
+	}
+
+	/* Find the top level FWL/FWL2 for this device. */
+	top_idx = find_toplevel(lc, asr);
+	if (top_idx < 0) {
+		LOG_ERR(lc, NULL, "Can't find a logical array config "
+			"for disk %x\n",
+			asr->rb.drivemagic);
+	}
+
+	/* This is a simple RAID0/1 array.  Find the set. */
+	if (asr->rt->ent[top_idx].raidlevel == FWL)
+	{
+		set = find_or_alloc_raid_set(lc, name(lc, asr),
+			FIND_TOP, rd, LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
+
+		set->stride = stride(cl);
+		set->status = s_ok;
+		set->type = type(find_logical(asr));
+
+		/* Add the disk to the set. */
+		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
+		
+		return set;
+	}
+
+	/*
+	 * This is a two-level RAID array.  Attach the disk to the disk's
+	 * parent set; create it if necessary.  Then, find the top-level set
+	 * and use join_superset to attach the parent set to the top set.
+	 */
+	if (asr->rt->ent[top_idx].raidlevel == FWL_2)
+	{
+		/* First compute the name of the disk's direct parent. */
+		fwl = find_logical(asr);
+		snprintf(buf, BUFSIZE, ".asr_%s_%x_donotuse",
+			 fwl->name, fwl->raidmagic);
+		
+		/* Now find said parent. */
+		set = find_or_alloc_raid_set(lc, buf,
+			FIND_ALL, rd, NO_LIST, NO_CREATE, NO_CREATE_ARG);
+
+		if (!set)
+			LOG_ERR(lc, NULL, "Error creating RAID set.\n");
+
+		set->stride = stride(cl);
+		set->status = s_ok;
+		set->type = type(fwl);
+
+		/* Add the disk to the set. */
+		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
+		
+		/* Find the top level set. */
+		sset = join_superset(lc, js_name, NO_CREATE,
+				     set_sort, set, rd);
+
+		if (!sset)
+			LOG_ERR(lc, NULL, "Error creating top RAID set.\n");
+
+		sset->stride = stride(cl);
+		sset->status = s_ok;
+		sset->type = type(&asr->rt->ent[top_idx]);
+
+		return sset;
+	}
+
+	/* If we land here, something's seriously wrong. */
+	LOG_ERR(lc, NULL, "Top level array config is not FWL/FWL2?\n");
+}
+
+/* Write metadata. */
+static int asr_write(struct lib_context *lc,  struct raid_dev *rd, int erase)
+{
+	int ret, i, j;
+        struct asr *asr = META(rd, asr);
+	int elmcnt = asr->rt->elmcnt;
+
+	/* Untruncate trailing whitespace in the name. */
+	for (i = 0; i < elmcnt; i++) {
+		for (j = 15; j >= 0; j--) {
+			if (asr->rt->ent[i].name[j] == 0)
+				break;
+		}
+		asr->rt->ent[i].name[j] = ' ';
+	}
+
+	/* Compute checksum */
+	asr->rt->rchksum = compute_checksum(asr);
+
+	/* Convert back to disk format */
+        to_disk(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
+
+	/* Write data */
+        ret = write_metadata(lc, handler, rd, -1, erase);
+	
+	/* Go back to CPU format */
+        to_cpu(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
+ 
+	/* Truncate trailing whitespace in the name. */
+	for (i = 0; i < elmcnt; i++) {
+		for (j = 15; j >= 0; j--) {
+			if (asr->rt->ent[i].name[j] != ' ')
+				break;
+		}
+		asr->rt->ent[i].name[j + 1] = 0;
+	}
+
+        return ret;
+}
+
+/*
+ * Check integrity of a RAID set.
+ */
+
+/* Retrieve the number of devices that should be in this set. */
+static unsigned int device_count(struct raid_dev *rd, void *context)
+{
+	/* Get the logical drive */
+	struct asr_raid_configline *cl = find_logical(META(rd, asr));
+	return (cl ? cl->raidcnt : 0);
+}
+
+/* Check a RAID device */
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context)
+{
+	/* FIXME: Assume non-broken means ok. */
+	return (rd->type != s_broken);
+}
+
+/* Start the recursive RAID set check. */
+static int asr_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, device_count, NULL, check_rd,
+			      NULL, handler);
+}
+
+static struct event_handlers asr_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+/* Dump a reserved block */
+static void dump_rb(struct lib_context *lc, struct asr_reservedblock *rb)
+{
+	DP("block magic:\t\t0x%X", rb, rb->b0idcode);
+	DP("sb0flags:\t\t\t0x%X", rb, rb->sb0flags);
+	DP("jbodEnable:\t\t%d", rb, rb->jbodEnable);
+	DP("biosInfo:\t\t\t0x%X", rb, rb->biosInfo);
+	DP("drivemagic:\t\t0x%X", rb, rb->drivemagic);
+	DP("svBlockStorageTid:\t0x%X", rb, rb->svBlockStorageTid);
+	DP("svtid:\t\t\t0x%X", rb, rb->svtid);
+	DP("resver:\t\t\t%d", rb, rb->resver);
+	DP("smagic:\t\t\t0x%X", rb, rb->smagic);
+	DP("raidtbl @ sector:\t\t%d", rb, rb->raidtbl);
+}
+
+/* Dump a raid config line */
+static void dump_cl(struct lib_context *lc, struct asr_raid_configline *cl)
+{
+	DP("config ID:\t\t0x%X", cl, cl->raidmagic);
+	DP("  name:\t\t\t\"%s\"", cl, cl->name);
+	DP("  raidcount:\t\t%d", cl, cl->raidcnt);
+	DP("  sequence #:\t\t%d", cl, cl->raidseq);
+	DP("  level:\t\t\t%d", cl, cl->raidlevel);
+	DP("  type:\t\t\t%d", cl, cl->raidtype);
+	DP("  state:\t\t\t%d", cl, cl->raidstate);
+	DP("  flags:\t\t\t0x%X", cl, cl->flags);
+	DP("  refcount:\t\t%d", cl, cl->refcnt);
+	DP("  hba:\t\t\t%d", cl, cl->raidhba);
+	DP("  channel:\t\t%d", cl, cl->raidchnl);
+	DP("  lun:\t\t\t%d", cl, cl->raidlun);
+	DP("  id:\t\t\t%d", cl, cl->raidid);
+	DP("  offset:\t\t\t%d", cl, cl->loffset);
+	DP("  capacity:\t\t%d", cl, cl->lcapcty);
+	P("  stripe size:\t\t%d KB",
+	  cl, cl->strpsize, cl->strpsize * ASR_DISK_BLOCK_SIZE / 1024);
+	DP("  BIOS info:\t\t%d", cl, cl->biosInfo);
+	DP("  phys/log lun:\t\t%d", cl, cl->lsu);
+	DP("  addedDrives:\t\t%d", cl, cl->addedDrives);
+	DP("  appSleepRate:\t\t%d", cl, cl->appSleepRate);
+	DP("  blockStorageTid:\t%d", cl, cl->blockStorageTid);
+	DP("  curAppBlock:\t\t%d", cl, cl->curAppBlock);
+	DP("  appBurstCount:\t\t%d", cl, cl->appBurstCount);
+}
+
+/* Dump a raid config table */
+static void dump_rt(struct lib_context *lc, struct asr_raidtable *rt)
+{
+	unsigned int i;
+
+	DP("ridcode:\t\t\t0x%X", rt, rt->ridcode);
+	DP("table ver:\t\t%d", rt, rt->rversion);
+	DP("max configs:\t\t%d", rt, rt->maxelm);
+	DP("configs:\t\t\t%d", rt, rt->elmcnt);
+	DP("config sz:\t\t%d", rt, rt->elmsize);
+	DP("checksum:\t\t\t0x%X", rt, rt->rchksum);
+	DP("raid flags:\t\t0x%X", rt, rt->raidFlags);
+	DP("timestamp:\t\t0x%X", rt, rt->timestamp);
+	P("irocFlags:\t\t%X%s", rt, rt->irocFlags, rt->irocFlags,
+	  rt->irocFlags & ASR_IF_BOOTABLE ? " (bootable)" : "");
+	DP("dirt, rty:\t\t%d", rt, rt->dirty);
+	DP("action prio:\t\t%d", rt, rt->actionPriority);
+	DP("spareid:\t\t\t%d", rt, rt->spareid);
+	DP("sparedrivemagic:\t\t0x%X", rt, rt->sparedrivemagic);
+	DP("raidmagic:\t\t0x%X", rt, rt->raidmagic);
+	DP("verifydate:\t\t0x%X", rt, rt->verifyDate);
+	DP("recreatedate:\t\t0x%X", rt, rt->recreateDate);
+
+	log_print(lc, "\nRAID config table:");
+	for (i = 0; i < rt->elmcnt; i++)
+		dump_cl(lc, &rt->ent[i]);
+}
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about the RAID device.
+ */
+static void asr_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct asr *asr = META(rd, asr);
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	dump_rb(lc, &asr->rb);
+	dump_rt(lc, asr->rt);
+}
+#endif
+
+static struct dmraid_format asr_format = {
+	.name	= HANDLER,
+	.descr	= "Adaptec HostRAID ASR",
+	.caps	= "0,1,10",
+	.format = FMT_RAID,
+	.read	= asr_read,
+	.write	= asr_write,
+	.group	= asr_group,
+	.check	= asr_check,
+	.events	= &asr_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= asr_log,
+#endif
+};
+
+/* Register this format handler with the format core */
+int register_asr(struct lib_context *lc)
+{
+	return register_format_handler(lc, &asr_format);
+}
+
+/*
+ * Set up a RAID device from what we've assembled out of the metadata.
+ */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct asr *asr = meta;
+	struct meta_areas *ma;
+	struct asr_raid_configline *cl = this_disk(asr);
+
+	if (!cl)
+		LOG_ERR(lc, 0, "%s: Could not find current disk!\n",
+			handler);		
+
+	/* We need two metadata areas */
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 2)))
+		return 0;
+
+	/* First area: raid reserved block. */
+	ma = rd->meta_areas;
+	ma->offset = ASR_CONFIGOFFSET >> 9;
+	ma->size = ASR_DISK_BLOCK_SIZE;
+	ma->area = (void*) asr;
+
+	/* Second area: raid table. */
+	ma++;
+	ma->offset = asr->rb.raidtbl;
+	ma->size = ASR_DISK_BLOCK_SIZE * 16;
+	ma->area = (void*) asr->rt;
+
+	/* Now set up the rest of the metadata info */
+        rd->di = di;
+	rd->fmt = &asr_format;
+
+	rd->status = disk_status(cl);
+	rd->type   = type(cl);
+
+	rd->offset = ASR_DATAOFFSET;
+	rd->sectors = cl->lcapcty;
+
+	return (rd->name = name(lc, asr)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/asr.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/asr.h
+++ -	2008-02-22 16:57:40.952303000 +0000
@@ -0,0 +1,388 @@
+/*
+ * Copyright (c) 2005-2006 IBM (actual code changes by Darrick Wong)
+ * 
+ * Copyright (c) 2001, 2002, 2004 Adaptec Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#ifndef _ASR_H
+#define _ASR_H
+
+/* Beginning of stuff that Darrick Wong added */
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+/* ASR metadata offset in bytes */
+#define	ASR_CONFIGOFFSET	((di->sectors - 1) << 9)
+
+/* Data offset in sectors */
+#define	ASR_DATAOFFSET		0
+
+/* Assume block size is 512.  So much for CD dmraid... */
+#define ASR_DISK_BLOCK_SIZE	512
+
+/* End of stuff that Darrick Wong added */
+
+/* Begining of stuff copied verbatim from Adaptec's emd driver. */
+
+/*
+ * This is a metadata versioning mechanism, but rather a versioning
+ * mechansim for Adaptec-sponsored changes to md.  (i.e. more of a driver
+ * version)
+ */
+#define	MD_ADAPTEC_MAJOR_VERSION	0
+#define	MD_ADAPTEC_MINOR_VERSION	0
+#define	MD_ADAPTEC_PATCHLEVEL_VERSION	13
+
+#define FW_RESERVED_BLOCKS  0x800
+
+#define MAX_SLEEPRATE_ENTRIES 10
+
+/* define lsu levels */
+#define LSU_LEVEL_PHYSICAL	1	/* Firmware Physical */
+#define LSU_LEVEL_LOGICAL	2	/* Firmware Logical */
+
+/* define RAID drive substates */
+#define FWP		0	/* Firmware Physical */
+#define FWL		1	/* Firmware Logical */
+#define OSI		2	/* Operating System Intermediate */
+#define FWL_2		3	/* Dual Level */
+
+#define ASR_RAID0		0
+#define ASR_RAID1		1
+#define ASR_RAID4		4
+#define ASR_RAID5		5
+#define ASR_RAIDRED		0xFF
+#define ASR_RAIDSPR		0xFE
+
+/*** RAID CONFIGURATION TABLE STRUCTURE ***/
+
+#define RVALID2			0x900765C4   /* Version 2+ RAID table ID code
+						signature */
+#define RCTBL_MAX_ENTRIES	127
+#define HBA_RCTBL_MAX_ENTRIES	255
+#define RTBLBLOCKS		16	     /* Size of drive's raid table
+						in blocks */
+
+/* flag bits */
+#define RCTBLCHNG					0x80	/* Set on comp OR log (NOT AND) if tbl updates needed */
+#define	COPYDIR						0x40
+#define	MIRCOPY						0x20
+#define INITIAL_BUILD_COMPLETED				0x10
+#define SMART_DISABLED					0x08
+#define WRITEBACK					0x04
+#define PREDICTIVE_ENABLE				0x02
+#define RAID_ENTRY_FLAGS_ALARM_OFF_M			0x01
+
+struct asr_raid_configline
+{
+	uint16_t	raidcnt;    /* Component count of an OSL/FWL array */
+	uint16_t	raidseq;    /* Sequence # of component to look for */
+	uint32_t	raidmagic;  /* Magic # of component to look for */
+	uint8_t		raidlevel;  /* Array level = OSL/FWL/OSI/FWP */
+	uint8_t		raidtype;   /* Array type = RAID0/1/3/5, RAIDRED,
+				       RAIDSPR */
+	uint8_t		raidstate;  /* State of logical or physical drive */
+
+	uint8_t		flags;      /* misc flags set bit positions above */
+
+	uint8_t		refcnt;     /* Number of references to this log entry */
+	uint8_t		raidhba;    /* -- not used -- Host bus adapter number
+				       or RAIDID */
+	uint8_t		raidchnl;   /* Channel number */
+	uint8_t		raidlun;    /* SCSI LUN of log/phys drv */
+	uint32_t	raidid;     /* SCSI ID of log/phys drv */
+	uint32_t	loffset;    /* Offset of data for this comp in the
+				       array */
+	uint32_t	lcapcty;    /* Capacity of log drv or space used on
+				       phys */
+	uint16_t	strpsize;   /* Stripe size in blocks of this drive */
+	uint16_t	biosInfo;   /* bios info - set by
+				       I2O_EXEC_BIOS_INFO_SET */
+	uint32_t	lsu;        /* Pointer to phys/log lun of this entry */
+	uint8_t		addedDrives;
+	uint8_t		appSleepRate;
+	uint16_t	blockStorageTid;
+	uint32_t	curAppBlock;
+	uint32_t	appBurstCount;
+	uint8_t		name[16];   /* Full name of the array. */
+} __attribute__ ((packed));
+
+struct asr_raidtable
+{
+/* raid Flag defines 32 bits 0 - FFFFFFFF */
+#define RAID_FLAGS_ALARM_OFF_M 0x00000001
+	uint32_t	ridcode;	/* RAID table signature - 0x900765C4 */
+	uint32_t	rversion;	/* Version of the RAID config table */
+	uint16_t	maxelm;		/* Maximum number of elements */
+	uint16_t	elmcnt;		/* Element Count (number used) */
+	uint16_t	elmsize;	/* Size of an individual raidCLine */
+	uint16_t	rchksum;	/* RAID table check sum
+					   (no rconfTblV2)*/
+	uint32_t	res1;		/* Reserved */
+	uint16_t	res2;		/* was bldRate - Time in 1/10s
+					   between idle build bursts */
+	uint16_t	res3;		/* was bldAmount - Block to build
+					   during a build burst */
+	uint32_t	raidFlags;
+	uint32_t	timestamp;	/* used for iROC. A stamp to find
+					   which is latest */
+	uint8_t		irocFlags;
+#define	ASR_IF_VERIFY_WITH_AUTOFIX	0x01
+#define ASR_IF_BOOTABLE			0x80
+	uint8_t		dirty;		/* Records "open state" for array */
+#define ARRAY_STATE_OK		0x00
+#define ARRAY_STATE_DIRTY	0x03
+	uint8_t		actionPriority;
+	uint8_t		spareid;	/* Stored in member disk meta data
+					   to declare the ID of dedicated
+					   spare to show up. */
+	uint32_t	sparedrivemagic;/* drivemagic (in RB) of the spare
+					   at above ID. */
+	uint32_t	raidmagic;	/* used to identify spare drive with
+					   its mirror set. */
+	uint32_t 	verifyDate;	/* used by iomgr */
+	uint32_t	recreateDate;	/* used by iomgr */
+	uint8_t		res4[12];	/* Reserved */
+	struct asr_raid_configline ent[RCTBL_MAX_ENTRIES];
+} __attribute__ ((packed));
+
+
+#define RBLOCK_VER  8           /* Version of the reserved block */
+#define B0RESRVD    0x37FC4D1E  /* Signature of the reserved block */
+#define SVALID      0x4450544D  /* ASCII code for "DPTM" DPT Mirror */
+
+struct asr_reservedblock
+{
+	uint32_t	b0idcode;	/* 0x00 - ID code signifying block 0
+					   reserved */
+	uint8_t		lunsave[8];	/* 0x04 - NOT USED - LUN mappings for
+					   all drives */
+	uint16_t	sdtype;		/* 0x0C - NOT USED - drive type in
+					   boot prom */
+	uint16_t	ssavecyl;	/* 0x0E - NOT USED - Set Parameters
+					   cylinders */
+	uint8_t		ssavehed;	/* 0x10 - NOT USED - Set Parameters
+					   heads */
+	uint8_t		ssavesec;	/* 0x11 - NOT USED - Set Parameters
+					   sectors */
+	uint8_t		sb0flags;	/* 0x12 - flags saved in reserved
+					   block */
+	uint8_t		jbodEnable;	/* 0x13 - jbod enable -- DEC drive
+					   hiding */
+	uint8_t		lundsave;	/* 0x14 - NOT USED - LUNMAP disable
+					   flags */
+	uint8_t		svpdirty;	/* 0x15 - NOT USED - saved percentage
+					   dirty */
+	uint16_t	biosInfo;	/* 0x16 - bios info - set by
+					   I2O_EXEC_BIOS_INFO_SET */
+	uint16_t	svwbskip;	/* 0x18 - NOT USED - saved write-back
+					   skip value */
+	uint16_t	svwbcln;	/* 0x1A - NOT USED - saved maximum
+					   clean blocks in write-back */
+	uint16_t	svwbmax;	/* 0x1C - NOT USED - saved maximum
+					   write-back length */
+	uint16_t	res3;		/* 0x1E - unused (was write-back burst
+					   block count) */
+	uint16_t	svwbmin;	/* 0x20 - NOT USED - saved minimum
+					   block count to write */
+	uint16_t	res4;		/* 0x22 - unused (was minimum
+					   look-ahead length) */
+	uint16_t	svrcacth;	/* 0x24 - NOT USED - saved read cache
+					   threshold */
+	uint16_t	svwcacth;	/* 0x26 - NOT USED - saved write
+					    cache threshold */
+	uint16_t	svwbdly;	/* 0x28 - NOT USED - saved write-back
+					   delay */
+	uint8_t		svsdtime;	/* 0x2A - NOT USED - saved spin down
+					   time */
+	uint8_t		res5;		/* 0x2B - unused */
+	uint16_t	firmval;	/* 0x2C - NOT USED - firmware on
+					   drive  (dw) */
+	uint16_t	firmbln;	/* 0x2E - NOT USED - length in blocks
+					   for firmware */
+	uint32_t	firmblk;	/* 0x30 - NOT USED - starting block
+					   for firmware */
+	uint32_t	fstrsvrb;	/* 0x34 - 1st block reserved by
+					   Storage Manager */
+	uint16_t	svBlockStorageTid;	/* 0x38 - */
+	uint16_t	svtid;		/* 0x3A - */
+	uint8_t		svseccfl;	/* 0x3C - NOT USED - reserved block
+					   scsi bus ecc flags */
+	uint8_t		res6;		/* 0x3D - unused */
+	uint8_t		svhbanum;	/* 0x3E - NOT USED - HBA's unique
+					   RAID number */
+	uint8_t		resver;		/* 0x3F - reserved block version
+					   number */
+	uint32_t	drivemagic;	/* 0x40 - Magic number of this drive -
+					   used w/ RCTBLs */
+	uint8_t		reserved[20];	/* 0x44 - unused */
+	uint8_t		testnum;	/* 0x58 - NOT USED - diagnostic test
+					   number */
+	uint8_t		testflags;	/* 0x59 - NOT USED - diagnostic test
+					   flags */
+	uint16_t	maxErrorCount;	/* 0x5A - NOT USED - diagnostic test
+					   maximum error count */
+	uint32_t	count;		/* 0x5C - NOT USED - diagnostic test
+					   cycles - # of iterations */
+	uint32_t	startTime;	/* 0x60 - NOT USED - diagnostic test
+					   absolute test start time in
+					   seconds */
+	uint32_t	interval;	/* 0x64 - NOT USED - diagnostic test
+					   interval in seconds */
+	uint8_t		tstxt0;		/* 0x68 - not used - originally
+					   diagnostic test exclusion period
+					   start hour */
+	uint8_t		tstxt1;		/* 0x69 - not used - originally
+					   diagnostic test exclusion period
+					   end hour */
+	uint8_t		serNum[32];	/* 0x6A - reserved */
+	uint8_t		res8[102];	/* 0x8A - reserved */
+	uint32_t	fwTestMagic;	/* 0xF0 - test magic number - used by
+					   FW Test for automated tests */
+	uint32_t	fwTestSeqNum;	/* 0xF4 - test sequence number - used
+					   by FW Test for automated tests */
+	uint8_t		fwTestRes[8];	/* 0xF6 - reserved by FW Test for
+					   automated tests */
+	uint32_t	smagic;		/* 0x100 - magic value saying software
+					   half is valid */
+	uint32_t	raidtbl;	/* 0x104 - pointer to first block of
+					   raid table */
+	uint16_t	raidline;	/* 0x108 - line number of this raid
+					   table entry - only if version <7 */
+	uint8_t		res9[0xF6];	/* 0x10A - reserved for software stuff*/
+} __attribute__ ((packed));
+
+
+
+#define ARRAY_NEW       0x00
+#define ARRAY_EQUAL     0x01
+#define ARRAY_SEQ_LESS  0x02
+#define ARRAY_SEQ_GREAT 0x03
+
+#define LOCK_PRIORITY      10	/* Uses 10, 11, 12 - For all three channels */
+
+
+/* B0FLAGS flag bits: */
+
+#define SMARTENA		7	/* SMART emulation enabled */
+#define CLRERROR		4	/* Clear stage of Interpret Format
+					   not completed */
+#define FMTERROR		3	/* Format stage of Interpret Format
+					   not completed */
+#define WRTTHRU			2	/* write throughs */
+#define CACHEDIS		0	/* cache disable bit */
+#define PREDICTIVE_ENABLE	0x02
+
+#define ID_MAP_PHYSICAL_M	1	/* Logical Map Physical */
+#define ID_MAP_LOGICAL_M	2	/* Either Dual Level or Single Level
+					   Logical*/
+
+#define MAX_LSU_COUNT			256
+
+#define MAX_LSU_COMPONENTS		64
+#define MAX_LSU_INQUIRY_DATA		64
+#define MAX_LSU_SERIAL_NUMBER		8
+#define STD_INQUIRY_SIZE		48
+
+#define MAX_LSU_BAD_BLOCKS		8
+
+/* lsuType definitions */
+#define LT_UNCONFIGURED_M		0x00
+#define LT_RAID0_M			0x01
+#define LT_RAID1_M			0x02
+#define LT_RAID3_M			0x08
+#define LT_RAID4_M			0x10
+#define LT_RAID5_M			0x20
+#define LT_REDIR_M			0x40
+#define LT_SPARE_M			0x80
+
+#define	LSU_RAID_LEVEL_0		LT_RAID0_M
+#define	LSU_RAID_LEVEL_1		LT_RAID1_M
+#define	LSU_RAID_LEVEL_3		LT_RAID3_M
+#define	LSU_RAID_LEVEL_4		LT_RAID4_M
+#define	LSU_RAID_LEVEL_5		LT_RAID5_M
+#define LSU_RAID_REDIRECT		LT_REDIR_M
+#define	LSU_RAID_SPARE			LT_SPARE_M
+
+/* raidState definitions */
+#define LS_OPTIMAL_M			0x00
+#define LS_DEGRADED_M			0x01
+#define LS_REBUILDING_M			0x02
+#define LS_MORPHING_M			0x03
+#define LS_DEAD_M			0x04
+#define LS_WARNING_M			0x05
+
+#define LS_VERIFYING_M			0x0A
+#define LSU_ARRAY_SUBSTATE_WITH_FIX	0x10
+
+#define LS_BUILDING_M			0x0B
+#define LS_CREATED_M			0x54
+#define LS_DIAGNOSING_M			0xFD
+
+
+/* arrayState definitions */
+#define LSU_ARRAY_STATE_OPTIMAL			0x00
+#define LSU_ARRAY_STATE_DEGRADED		0x01
+/* etc. */
+
+/* component raidState definitions */
+#define MAIN_STATE				0x0F
+#define LSU_COMPONENT_STATE_OPTIMAL		0x00
+#define LSU_COMPONENT_STATE_DEGRADED		0x01
+#define LSU_COMPONENT_STATE_UNCONFIGURED	0x02
+#define LSU_COMPONENT_STATE_FAILED		0x03
+#define LSU_COMPONENT_STATE_REPLACED		0x04
+#define LSU_COMPONENT_STATE_UNINITIALIZED	0x0A
+
+#define LSU_COMPONENT_SUBSTATE_BUILDING		0x10  /* drive is being built
+							 for first time */
+#define LSU_COMPONENT_SUBSTATE_REBUILDING	0x20  /* drive is being
+							 rebuilt */
+#define LSU_ARRAY_SUBSTATE_AWAIT_FORMAT		0x50
+/* etc. */
+
+/* Beginning of other stuff that Darrick Wong added */
+
+struct asr {
+	struct asr_reservedblock rb;
+	struct asr_raidtable *rt;
+};
+
+#endif /* FORMAT_HANDLER */
+
+int register_asr(struct lib_context *lc);
+
+#endif /* _ASR_H */
/cvs/dm/dmraid/lib/format/ataraid/hpt37x.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/hpt37x.c
+++ -	2008-02-22 16:57:41.082281000 +0000
@@ -0,0 +1,413 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Highpoint 37X ATARAID metadata format handler.
+ *
+ * hpt37x_read(), hpt37x_group() and group_rd() profited from
+ * Carl-Daniel Hailfinger's raiddetect code.
+ */
+#define	HANDLER "hpt37x"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "hpt37x.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/* Make up RAID set name from magic_[01] numbers */
+/* FIXME: better name ? */
+static size_t _name(struct hpt37x *hpt, char *str, size_t len,
+		    unsigned int subset)
+{
+	const char *fmt;
+
+	if (hpt->magic_0)
+		fmt = (subset &&
+		       (hpt->type == HPT37X_T_RAID01_RAID0 ||
+		        hpt->type == HPT37X_T_RAID01_RAID1)) ?
+		       "hpt37x_%u-%u" : "hpt37x_%u";
+	else
+		fmt = "hpt37x_SPARE";
+
+	/* FIXME: hpt->order not zero-based. */
+	return snprintf(str, len, fmt,
+			hpt->magic_1 ? hpt->magic_1 : hpt->magic_0, hpt->order);
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	char *ret;
+	struct hpt37x *hpt = META(rd, hpt37x);
+
+	if ((ret = dbg_malloc((len = _name(hpt, NULL, 0, subset) + 1)))) {
+		_name(hpt, ret, len, subset);
+		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
+			 (strrchr(ret, '-') ? 3 : 1));
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/*
+ * Retrieve status of device.
+ * FIXME: is this sufficient to cover all state ?
+ */
+static enum status status(struct hpt37x *hpt)
+{
+	return hpt->magic == HPT37X_MAGIC_BAD ? s_broken : s_ok;
+}
+
+/* Mapping of HPT 37X types to generic types. */
+static struct types types[] = {
+	{ HPT37X_T_SINGLEDISK, t_linear},
+	{ HPT37X_T_SPAN, t_linear},
+	{ HPT37X_T_RAID0, t_raid0},
+	{ HPT37X_T_RAID1, t_raid1},
+	{ HPT37X_T_RAID01_RAID0, t_raid0},
+	{ HPT37X_T_RAID01_RAID1, t_raid1},
+	/* FIXME: support RAID 3+5 */
+	{ 0, t_undef}
+};
+
+/* Neutralize disk type. */
+static enum type type(struct hpt37x *hpt)
+{
+	return hpt->magic_0 ?
+	       rd_type(types, (unsigned int) hpt->type) : t_spare;
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD(new), hpt37x))->disk_number <
+	       (META(RD(pos), hpt37x))->disk_number;
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD_RS(RS(new)), hpt37x))->order <
+	       (META(RD_RS(RS(pos)), hpt37x))->order;
+}
+
+/*
+ * Read a Highpoint 37X RAID device.
+ */
+/* Endianess conversion. */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct hpt37x *hpt = meta;
+	struct hpt37x_errorlog *l;
+
+	CVT32(hpt->magic);
+	CVT32(hpt->magic_0);
+	CVT32(hpt->magic_1);
+	CVT32(hpt->order);
+	CVT32(hpt->total_secs);
+	CVT32(hpt->disk_mode);
+	CVT32(hpt->boot_mode);
+
+	for (l = hpt->errorlog;
+	     l < hpt->errorlog + hpt->error_log_entries;
+	     l++) {
+		CVT32(l->timestamp);
+		CVT32(l->lba);
+	}
+}
+#endif
+
+/* Magic check. */
+static int is_hpt37x(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct hpt37x *hpt = meta;
+
+	return (hpt->magic == HPT37X_MAGIC_OK ||
+		hpt->magic == HPT37X_MAGIC_BAD) &&
+		hpt->disk_number < 8;
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *hpt37x_read(struct lib_context *lc, struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct hpt37x), HPT37X_CONFIGOFFSET,
+			     to_cpu, is_hpt37x, NULL, setup_rd, handler);
+}
+
+/*
+ * Write a Highpoint 37X RAID device.
+ */
+static int hpt37x_write(struct lib_context *lc,
+			struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct hpt37x *hpt = META(rd, hpt37x);
+
+	to_disk(hpt);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(hpt);
+#endif
+
+	return ret;
+}
+
+/*
+ * Group the RAID disk into a set.
+ *
+ * Check device hierarchy and create sub sets appropriately.
+ *
+ */
+static unsigned int stride(struct hpt37x *hpt)
+{
+	return hpt->raid0_shift ? 1 << hpt->raid0_shift : 0;
+}
+
+static int mismatch(struct lib_context *lc, struct raid_dev *rd, char magic)
+{
+	LOG_ERR(lc, 0, "%s: magic_%c mismatch on %s",
+		handler, magic, rd->di->path);
+}
+
+static void super_created(struct raid_set *ss, void *private)
+{
+	struct hpt37x *hpt = META(private, hpt37x);
+
+	ss->type   = hpt->type == HPT37X_T_RAID01_RAID0 ? t_raid1 : t_raid0;
+	ss->stride = stride(hpt);
+}
+
+/* FIXME: handle spares in mirrors and check that types are correct. */
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct hpt37x *h, *hpt = META(rd, hpt37x);
+
+	if (!init_raid_set(lc, rs, rd, stride(hpt), hpt->type, handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+	h = DEVS(rs) ? META(RD_RS(rs), hpt37x) : NULL;
+
+	switch (hpt->type) {
+	case HPT37X_T_SINGLEDISK:
+	case HPT37X_T_SPAN:
+	case HPT37X_T_RAID0:
+	case HPT37X_T_RAID1:
+		if (h && h->magic_0 != hpt->magic_0)
+			return mismatch(lc, rd, '0');
+
+		if (!find_set(lc, NULL, rs->name, FIND_TOP))
+			list_add_tail(&rs->list, LC_RS(lc));
+
+		break;
+
+	case HPT37X_T_RAID01_RAID0:
+	case HPT37X_T_RAID01_RAID1:
+		if (h && h->magic_1 != hpt->magic_1)
+			return mismatch(lc, rd, '1');
+
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Add a Highpoint RAID device to a set.
+ */
+static struct raid_set *hpt37x_group(struct lib_context *lc,
+				       struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	if (T_SPARE(rd))
+		return NULL;
+
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+/*
+ * Check a Highpoint 37X RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	return (META(rd, hpt37x))->raid_disks;
+}
+
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context)
+{
+	/*
+	 * FIXME: raid_disks member wrong ?
+	 *	  (eg, Peter Jonas RAID1 metadata, 2 disks and raid_disks = 1)
+	 */
+	return T_RAID1(rd);
+}
+
+static int hpt37x_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL, check_rd, NULL, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct hpt37x *hpt = META(rd, hpt37x);
+
+	/* Avoid write trashing. */
+	if (status(hpt) & s_broken)
+		return 0;
+
+	hpt->magic = HPT37X_MAGIC_BAD;
+
+	return 1;
+}
+
+static struct event_handlers hpt37x_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about an HPT37X RAID device.
+ */
+static void hpt37x_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct hpt37x *hpt = META(rd, hpt37x);
+	struct hpt37x_errorlog *el;
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	DP("magic: 0x%x", hpt, hpt->magic);
+	DP("magic_0: 0x%x", hpt, hpt->magic_0);
+	DP("magic_1: 0x%x", hpt, hpt->magic_1);
+	DP("order: %u", hpt, hpt->order);
+	DP("raid_disks: %u", hpt, hpt->raid_disks);
+	DP("raid0_shift: %u", hpt, hpt->raid0_shift);
+	DP("type: %u", hpt, hpt->type);
+	DP("disk_number: %u", hpt, hpt->disk_number);
+	DP("total_secs: %u", hpt, hpt->total_secs);
+	DP("disk_mode: 0x%x", hpt, hpt->disk_mode);
+	DP("boot_mode: 0x%x", hpt, hpt->boot_mode);
+	DP("boot_disk: %u", hpt, hpt->boot_disk);
+	DP("boot_protect: %u", hpt, hpt->boot_protect);
+	DP("error_log_entries: %u", hpt, hpt->error_log_entries);
+	DP("error_log_index: %u", hpt, hpt->error_log_index);
+	if (hpt->error_log_entries)
+		log_print(lc, "error_log:");
+
+	for (el = hpt->errorlog; el < hpt->errorlog + 32; el++) {
+		if (!el->timestamp)
+			break;
+
+		DP("timestamp: %u", hpt, el->timestamp);
+		DP("reason: %u", hpt, el->reason);
+		DP("disk: %u", hpt, el->disk);
+		DP("status: %u", hpt, el->status);
+		DP("sectors: %u", hpt, el->sectors);
+		DP("lba: %u", hpt, el->lba);
+       };
+}
+#endif
+
+static struct dmraid_format hpt37x_format = {
+	.name	= HANDLER,
+	.descr	= "Highpoint HPT37X",
+	.caps	= "S,0,1,10,01",
+	.format = FMT_RAID,
+	.read	= hpt37x_read,
+	.write	= hpt37x_write,
+	.group	= hpt37x_group,
+	.check	= hpt37x_check,
+	.events	= &hpt37x_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= hpt37x_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_hpt37x(struct lib_context *lc)
+{
+	return register_format_handler(lc, &hpt37x_format);
+}
+
+/* Calculate RAID device size in sectors depending on RAID type. */
+static uint64_t sectors(struct raid_dev *rd, struct hpt37x *hpt)
+{
+	uint64_t ret = 0;
+	struct dev_info *di = rd->di;
+
+	switch (rd->type) {
+	case t_raid0:
+		ret = hpt->total_secs / (hpt->raid_disks ? hpt->raid_disks : 1);
+		break;
+
+	case t_raid1:
+		ret = hpt->total_secs;
+		break;
+
+	default:
+		ret = di->sectors;
+	}
+
+	/* Subtract offset sectors on drives > 0. */
+	return ret - rd->offset;
+}
+
+/* Derive the RAID device contents from the Highpoint ones. */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct hpt37x *hpt = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = HPT37X_CONFIGOFFSET >> 9;
+	rd->meta_areas->size = sizeof(*hpt);
+	rd->meta_areas->area = (void*) hpt;
+
+	rd->di  = di;
+	rd->fmt = &hpt37x_format;
+
+	rd->status = status(hpt);
+	rd->type   = type(hpt);
+
+	/* Data offset from start of device; first device is special */
+	rd->offset  = hpt->disk_number ? HPT37X_DATAOFFSET : 0;
+        if (!(rd->sectors = sectors(rd, hpt)))
+		return log_zero_sectors(lc, di->path, handler);
+
+        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/hpt37x.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/hpt37x.h
+++ -	2008-02-22 16:57:41.165768000 +0000
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2000,2001 Søren Schmidt <sos@FreeBSD.org>
+ * All rights reserved.
+ *
+ * dmraid modifications:
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer,
+ *    without modification, immediately at the beginning of the file.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR `AS IS'' AND ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
+ * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef	_HPT37X_H_
+#define	_HPT37X_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+/* HPT 37x config data byte offset on disk */
+#define HPT37X_CONFIGOFFSET	(9 << 9) /* 9 sectors */
+#define HPT37X_DATAOFFSET	10	/* Data offset in sectors */
+
+/* Ondisk metadata for Highpoint ATARAID */
+struct hpt37x {
+       uint8_t  filler1[32];
+
+       uint32_t       magic;
+#define HPT37X_MAGIC_OK   0x5a7816f0
+#define HPT37X_MAGIC_BAD  0x5a7816fd  
+
+       uint32_t       magic_0;	/* Set identifier */
+       uint32_t       magic_1;	/* Array identifier */
+
+       uint32_t       order;  
+#define HPT_O_MIRROR   0x01  
+#define HPT_O_STRIPE   0x02
+#define HPT_O_OK       0x04
+
+       uint8_t        raid_disks;
+       uint8_t        raid0_shift; 
+
+       uint8_t        type;
+#define HPT37X_T_RAID0		0x00 
+#define HPT37X_T_RAID1		0x01
+#define HPT37X_T_RAID01_RAID0	0x02
+#define HPT37X_T_SPAN		0x03
+#define HPT37X_T_RAID_3		0x04   
+#define HPT37X_T_RAID_5		0x05
+#define HPT37X_T_SINGLEDISK	0x06
+#define HPT37X_T_RAID01_RAID1	0x07
+
+       uint8_t        disk_number;
+       uint32_t       total_secs; 
+       uint32_t       disk_mode;  
+       uint32_t       boot_mode;
+       uint8_t        boot_disk; 
+       uint8_t        boot_protect;
+       uint8_t        error_log_entries;
+       uint8_t        error_log_index;  
+       struct hpt37x_errorlog
+       {
+	       uint32_t       timestamp;
+	       uint8_t        reason;   
+#define HPT_R_REMOVED          0xfe      
+#define HPT_R_BROKEN           0xff      
+
+	       uint8_t        disk;
+	       uint8_t        status;
+	       uint8_t        sectors;
+	       uint32_t       lba;
+       } errorlog[32];
+       uint8_t        filler[60];
+} __attribute__ ((packed));
+#endif
+
+int register_hpt37x(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/hpt45x.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/hpt45x.c
+++ -	2008-02-22 16:57:41.269910000 +0000
@@ -0,0 +1,359 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Highpoint 45X ATARAID metadata format handler.
+ *
+ * hpt45x_read(), hpt45x_group() and group_rd() profited from
+ * Carl-Daniel Hailfinger's raiddetect code.
+ */
+#define	HANDLER "hpt45x"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "hpt45x.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/* Make up RAID set name from magic_0 number */
+/* FIXME: better name ? */
+static size_t _name(struct hpt45x *hpt, char *str, size_t len,
+		    unsigned int subset)
+{
+	const char *fmt;
+
+	if (hpt->magic_0)
+		fmt = subset ? "hpt45x_%u-%u" : "hpt45x_%u";
+	else
+		fmt = "hpt45x_SPARE";
+
+	return snprintf(str, len, fmt, hpt->magic_0, hpt->raid1_disk_number);
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	char *ret;
+	struct hpt45x *hpt = META(rd, hpt45x);
+
+	if ((ret = dbg_malloc((len = _name(hpt, NULL, 0, subset) + 1)))) {
+		_name(hpt, ret, len, subset);
+		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
+			 (strrchr(ret, '-') ? 3 : 1));
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/*
+ * Retrieve status of device.
+ * FIXME: is this sufficient to cover all state ?
+ */
+static enum status status(struct hpt45x *hpt)
+{
+	return hpt->magic == HPT45X_MAGIC_BAD ? s_broken : s_ok;
+}
+
+/* Mapping of HPT 45X types to generic types */
+static struct types types[] = {
+	{ HPT45X_T_SPAN, t_linear},
+	{ HPT45X_T_RAID0, t_raid0},
+	{ HPT45X_T_RAID1, t_raid1},
+/* FIXME: handle RAID 3+5 */
+	{ 0, t_undef}
+};
+
+/* Neutralize disk type */
+static enum type type(struct hpt45x *hpt)
+{
+	return hpt->magic_0 ? rd_type(types, (unsigned int) hpt->type) :
+	       t_spare;
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD(new), hpt45x))->disk_number <
+	       (META(RD(pos), hpt45x))->disk_number;
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD_RS(RS(new)), hpt45x))->raid1_disk_number <
+	       (META(RD_RS(RS(pos)), hpt45x))->raid1_disk_number;
+}
+
+/*
+ * Group the RAID disk into a HPT45X set.
+ *
+ * Check device hierarchy and create super set appropriately.
+ */
+static unsigned int stride(unsigned int shift)
+{
+	return shift ? 1 << shift : 0;
+}
+
+static void super_created(struct raid_set *super, void *private)
+{
+	super->type   = t_raid1;
+	super->stride = stride(META((private), hpt45x)->raid1_shift);
+}
+
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct hpt45x *hpt = META(rd, hpt45x);
+
+	if (!init_raid_set(lc, rs, rd, stride(hpt->raid0_shift),
+			   hpt->type, handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	switch (hpt->type) {
+	case HPT45X_T_SPAN:
+	case HPT45X_T_RAID1:
+  no_raid10:
+		if (!find_set(lc, NULL, rs->name, FIND_TOP))
+			list_add_tail(&rs->list, LC_RS(lc));
+
+		break;
+
+	case HPT45X_T_RAID0:
+		if (hpt->raid1_type != HPT45X_T_RAID1)
+			goto no_raid10;
+		/*
+		 * RAID10:
+		 *
+		 * We've got a striped raid set with a mirror on top
+		 * when we get here.
+		 * Let's find and optionally allocate the mirror set on top.
+		 */
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Add a Highpoint RAID device to a set.
+ */
+static struct raid_set *hpt45x_group(struct lib_context *lc,
+				       struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	if (T_SPARE(rd))
+		return NULL;
+
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+/*
+ * Read a Highpoint 45X RAID device.
+ */
+/* Endianess conversion. */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct hpt45x *hpt = meta;
+
+	CVT32(hpt->magic);
+	CVT32(hpt->magic_0);
+	CVT32(hpt->magic_1);
+	CVT32(hpt->total_secs);
+}
+#endif
+
+/* Magic check. */
+static int is_hpt45x(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct hpt45x *hpt = meta;
+
+	return (hpt->magic == HPT45X_MAGIC_OK ||
+		hpt->magic == HPT45X_MAGIC_BAD) &&
+		hpt->disk_number < 8;
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *hpt45x_read(struct lib_context *lc,
+				      struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct hpt45x), HPT45X_CONFIGOFFSET,
+			     to_cpu, is_hpt45x, NULL, setup_rd, handler);
+}
+
+/*
+ * Write a Highpoint 45X RAID device.
+ */
+static int hpt45x_write(struct lib_context *lc,
+			struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct hpt45x *hpt = META(rd, hpt45x);
+
+	to_disk(hpt);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(hpt);
+#endif
+	return ret;
+}
+
+/*
+ * Check a Highpoint 45X RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	return (META(rd, hpt45x))->raid_disks;
+}
+
+static int hpt45x_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL,
+			      NO_CHECK_RD, NULL, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct hpt45x *hpt = META(rd, hpt45x);
+
+	/* Avoid write trashing. */
+	if (S_BROKEN(status(hpt)))
+		return 0;
+
+	hpt->magic = HPT45X_MAGIC_BAD;
+
+	return 1;
+}
+
+static struct event_handlers hpt45x_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about an HPT45X RAID device.
+ */
+static void hpt45x_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	unsigned int i;
+	struct hpt45x *hpt = META(rd, hpt45x);
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	DP("magic: 0x%x", hpt, hpt->magic);
+	DP("magic_0: 0x%x", hpt, hpt->magic_0);
+	DP("magic_1: 0x%x", hpt, hpt->magic_1);
+	DP("total_secs: %u", hpt, hpt->total_secs);
+	DP("type: %u", hpt, hpt->type);
+	DP("raid_disks: %u", hpt, hpt->raid_disks);
+	DP("disk_number: %u", hpt, hpt->disk_number);
+	DP("raid0_shift: %u", hpt, hpt->raid0_shift);
+	for (i = 0; i < 3; i++)
+		P2("dummy[%u]: 0x%x", hpt, i, hpt->dummy[i]);
+	DP("raid1_type: %u", hpt, hpt->raid1_type);
+	DP("raid1_raid_disks: %u", hpt, hpt->raid1_raid_disks);
+	DP("raid1_disk_number: %u", hpt, hpt->raid1_disk_number);
+	DP("raid1_shift: %u", hpt, hpt->raid1_shift);
+
+	for (i = 0; i < 3; i++)
+		P2("dummy1[%u]: 0x%x", hpt, i, hpt->dummy1[i]);
+}
+#endif
+
+static struct dmraid_format hpt45x_format = {
+	.name	= HANDLER,
+	.descr	= "Highpoint HPT45X",
+	.caps	= "S,0,1,10",
+	.format = FMT_RAID,
+	.read	= hpt45x_read,
+	.write	= hpt45x_write,
+	.group	= hpt45x_group,
+	.check	= hpt45x_check,
+	.events	= &hpt45x_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= hpt45x_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_hpt45x(struct lib_context *lc)
+{
+	return register_format_handler(lc, &hpt45x_format);
+}
+
+/* Calculate RAID device size in sectors depending on RAID type. */
+static uint64_t sectors(struct raid_dev *rd, void *meta)
+{
+	struct hpt45x *hpt = meta;
+
+	switch (rd->type) {
+	case t_raid0:
+		return hpt->total_secs /
+		       (hpt->raid_disks ? hpt->raid_disks : 1);
+
+	case t_raid1:
+		return hpt->total_secs;
+
+	default:
+		return rd->meta_areas->offset;
+	}
+}
+
+/* Set the RAID device contents up derived from the Highpoint ones */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct hpt45x *hpt = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = HPT45X_CONFIGOFFSET >> 9;
+	rd->meta_areas->size = sizeof(*hpt);
+	rd->meta_areas->area = (void*) hpt;
+
+	rd->di = di;
+	rd->fmt = &hpt45x_format;
+
+	rd->status = status(hpt);
+	rd->type   = type(hpt);
+
+	rd->offset = HPT45X_DATAOFFSET;
+	if (!(rd->sectors = sectors(rd, hpt)))
+		return log_zero_sectors(lc, di->path, handler);
+
+	return (rd->name = name(lc, rd, hpt->raid1_type == HPT45X_T_RAID1)) ?
+	       1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/hpt45x.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/hpt45x.h
+++ -	2008-02-22 16:57:41.351114000 +0000
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_HPT45X_H_
+#define	_HPT45X_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+/* Highpoint 45x config data sector offset off end of disk */
+#define HPT45X_CONFIGOFFSET	((di->sectors - 11) << 9)
+#define HPT45X_DATAOFFSET	0 /* Data offset in sectors */
+
+/* Ondisk metadata for Highpoint 45X ATARAID */
+struct hpt45x {
+	uint32_t	magic;		/* 0x0 - 0x03 */
+#define HPT45X_MAGIC_OK   0x5a7816f3
+#define HPT45X_MAGIC_BAD  0x5a7816fd
+
+	uint32_t	magic_0;	/* 0x04 - 0x07 Set identifier */
+	uint32_t	magic_1;	/* 0x08 - 0x0A (Sub-)Array identifier */
+
+	uint32_t	total_secs; 	/* 0x0B - 0x0F */
+
+	uint8_t	type;		/* 0x10 */
+#define HPT45X_T_SPAN	0x04
+#define HPT45X_T_RAID0	0x05
+#define HPT45X_T_RAID1	0x06
+
+	uint8_t	raid_disks;	/* 0x11 */
+	uint8_t	disk_number;	/* 0x12 */
+	uint8_t	raid0_shift; 	/* 0x13 */
+
+	uint32_t	dummy[3];	/* 0x14 - 0x1F */
+
+	uint8_t	raid1_type;		/* 0x20 */
+	uint8_t	raid1_raid_disks;	/* 0x21 */
+	uint8_t	raid1_disk_number;	/* 0x22 */
+	uint8_t	raid1_shift;		/* 0x23 */
+
+	uint32_t	dummy1[3];	/* 0x24 - 0x2F */
+} __attribute__ ((packed));
+#endif
+
+int register_hpt45x(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/isw.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/isw.c
+++ -	2008-02-22 16:57:41.430673000 +0000
@@ -0,0 +1,801 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Intel Software RAID metadata format handler.
+ *
+ * isw_read() etc. profited from Carl-Daniel Hailfinger's raiddetect code.
+ *
+ * Profited from the Linux 2.4 iswraid driver by
+ * Boji Tony Kannanthanam and Martins Krikis.
+ */
+#define	HANDLER	"isw"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "isw.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/*
+ * Make up RAID set name from family_num and volume name.
+ */
+static size_t _name(struct isw *isw, struct isw_dev *dev,
+		     char *str, size_t len)
+{
+	return snprintf(str, len, dev ? "isw_%u_%s" : "isw_%u",
+			isw->family_num, (char*) dev->volume);
+}
+
+static char *name(struct lib_context *lc, struct isw *isw, struct isw_dev *dev)
+{
+        size_t len;
+        char *ret;
+
+        if ((ret = dbg_malloc((len = _name(isw, dev, NULL, 0) + 1)))) {
+                _name(isw, dev, ret, len);
+		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
+			 (dev ? strlen((char*) dev->volume) - 2 : 1));
+        } else
+		log_alloc_err(lc, handler);
+
+        return ret;
+}
+
+/* Find a disk table slot by serial number. */
+static struct isw_disk *_get_disk(struct isw *isw, struct dev_info *di)
+{
+	if (di->serial) {
+		struct isw_disk *disk = isw->disk;
+
+		do {
+			if (!strncmp(di->serial, (const char*) disk->serial,
+				     MAX_RAID_SERIAL_LEN))
+				return disk;
+		} while (++disk < isw->disk + isw->num_disks);
+	}
+
+	return NULL;
+}
+
+static struct isw_disk *get_disk(struct lib_context *lc,
+				 struct dev_info *di, struct isw *isw)
+{
+	struct isw_disk *disk;
+
+	if ((disk = _get_disk(isw, di)))
+		return disk;
+
+	LOG_ERR(lc, NULL, "%s: Error finding disk table slot for %s",
+		handler, di->path);
+}
+
+/*
+ * Retrieve status of device.
+ *
+ * FIXME: is this sufficient to cover all state ?
+ */
+static enum status __status(unsigned int status)
+{
+	return ((status & (CONFIGURED_DISK|USABLE_DISK)) &&
+		!(FAILED_DISK & status)) ?
+	       s_ok : s_broken;
+}
+
+static enum status status(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct isw_disk *disk;
+
+	if ((disk = get_disk(lc, rd->di, META(rd, isw))))
+		return __status(disk->status);
+
+	return s_undef;
+}
+
+/*
+ * Mapping of Intel types to generic types.
+ */
+static struct types types[] = {
+        { ISW_T_RAID0, t_raid0},
+        { ISW_T_RAID1, t_raid1},
+        { ISW_T_RAID5, t_raid5_la},
+        { 0, t_undef},
+};
+
+/* Neutralize disk type. */
+static enum type type(struct raid_dev *rd)
+{
+	struct isw_dev *dev = rd->private.ptr;
+
+	return dev ? rd_type(types, (unsigned int) dev->vol.map.raid_level) :
+		     t_group;
+}
+
+/*
+ * Generate checksum of Raid metadata for mpb_size/sizeof(u32) words
+ * (checksum field itself ignored for this calculation).
+ */
+static uint32_t _checksum(struct isw *isw)
+{
+	uint32_t end = isw->mpb_size / sizeof(end),
+		 *p = (uint32_t*) isw, ret = 0;
+
+	while (end--)
+		ret += *p++;
+
+	return ret - isw->check_sum;
+}
+
+/* Calculate next isw device offset. */
+static struct isw_dev *advance_dev(struct isw_dev *dev,
+				   struct isw_map *map, size_t add)
+{
+	return (struct isw_dev*) ((uint8_t*) dev +
+				  (map->num_members - 1) * 
+				  sizeof(map->disk_ord_tbl) + add);
+}
+
+/* Advance to the next isw_dev from a given one. */
+static struct isw_dev *advance_raiddev(struct isw_dev *dev)
+{
+	struct isw_vol *vol = &dev->vol;
+	struct isw_map *map = &vol->map;
+
+	/* Correction: yes, it sits here! */
+	dev = advance_dev(dev, map, sizeof(*dev));
+
+	if (vol->migr_state) /* need to add space for another map */
+		dev = advance_dev(dev, map, sizeof(*map));
+
+	return dev;
+}
+
+/* Return isw_dev by table index. */
+static struct isw_dev *raiddev(struct isw *isw, unsigned int i)
+{
+	struct isw_dev *dev = (struct isw_dev*) (isw->disk + isw->num_disks);
+
+	while (i--)
+		dev = advance_raiddev(dev);
+
+	return dev;
+}
+
+/*
+ * Read an Intel RAID device
+ */
+/* Endianess conversion. */
+enum convert { FULL, FIRST, LAST };
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu(x, y)
+#else
+/*
+ * We can differ from the read_raid_dev template here,
+ * because we don't get called from there.
+ */
+static void to_cpu(struct isw *isw, enum convert cvt)
+{
+	unsigned int i, j;
+	struct isw_disk *dsk;
+	struct isw_dev *dev;
+
+	if (cvt == FIRST || cvt == FULL) {
+		CVT32(isw->check_sum);
+		CVT32(isw->mpb_size);
+		CVT32(isw->family_num);
+		CVT32(isw->generation_num);
+	}
+
+	if (cvt == FIRST)
+		return;
+
+	for (dsk = isw->disk; dsk < &isw->disk[isw->num_disks]; dsk++) {
+		CVT32(dsk->totalBlocks);
+		CVT32(dsk->scsiId);
+		CVT32(dsk->status);
+	}
+
+	for (i = 0; i < isw->num_raid_devs; i++) {
+		dev = raiddev(isw, i);
+
+		/* RAID device. */
+		CVT32(dev->SizeLow);
+		CVT32(dev->SizeHigh);
+		CVT32(dev->status);
+		CVT32(dev->reserved_blocks);
+
+		/* RAID volume has 8 bit members only. */
+	
+		/* RAID map. */
+		CVT32(dev->vol.map.pba_of_lba0);
+		CVT32(dev->vol.map.blocks_per_member);
+		CVT32(dev->vol.map.num_data_stripes);
+		CVT16(dev->vol.map.blocks_per_strip);
+
+		for (j = 0; j < dev->vol.map.num_members; j++)
+			CVT16(dev->vol.map.disk_ord_tbl[j]);
+	}
+}
+#endif
+
+static int is_isw(struct lib_context *lc, struct dev_info *di, struct isw *isw)
+{
+	if (strncmp((const char *) isw->sig, MPB_SIGNATURE, sizeof(MPB_SIGNATURE) - 1))
+		return 0;
+
+	/* Check version info, older versions supported */
+	if (strncmp((const char*) isw->sig + sizeof(MPB_SIGNATURE) - 1,
+		    MPB_VERSION_RAID2, sizeof(MPB_VERSION_RAID2) - 1) > 0)
+		log_print(lc, "%s: untested metadata version %s found on %s",
+			  handler, isw->sig + sizeof(MPB_SIGNATURE) - 1,
+			  di->path);
+
+	return 1;
+}
+
+static void isw_file_metadata(struct lib_context *lc, struct dev_info *di,
+			      void *meta)
+{
+	struct isw *isw = meta;
+
+	/* Get the rounded up value for the metadata size */
+	size_t size = round_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE);
+
+	file_metadata(lc, handler, di->path,
+		      meta + (size / ISW_DISK_BLOCK_SIZE > 1 ?
+			      ISW_DISK_BLOCK_SIZE : 0),
+		      size, (di->sectors - (size / ISW_DISK_BLOCK_SIZE)) << 9);
+	file_dev_size(lc, handler, di);
+}
+
+static int isw_read_extended(struct lib_context *lc, struct dev_info *di,
+			     struct isw **isw,
+			     uint64_t *isw_sboffset, size_t *size)
+{
+	struct isw *isw_tmp;
+
+	/* Get the rounded up value for the metadata blocks */
+	size_t blocks = div_up((*isw)->mpb_size, ISW_DISK_BLOCK_SIZE);
+
+	/* No extended metadata to read ? */
+	if (blocks < 2)
+		return 1;
+
+	/*
+	 * Allocate memory for the extended Intel superblock
+	 * and read it in. Reserve one more disk block in order
+	 * to be able to file the metadata in the proper sequence.
+	 * (ie, sectors 1, 2-n, 1 in core so that the filing can start at 2).
+	 */
+	*size = blocks * ISW_DISK_BLOCK_SIZE;
+	*isw_sboffset -= *size - ISW_DISK_BLOCK_SIZE;
+
+	if ((isw_tmp = alloc_private(lc, handler,
+				     *size + ISW_DISK_BLOCK_SIZE))) {
+		/* Read extended metadata to offset ISW_DISK_BLOCK_SIZE */
+		if (read_file(lc, handler, di->path,
+			      (void*) isw_tmp + ISW_DISK_BLOCK_SIZE,
+			      *size - ISW_DISK_BLOCK_SIZE, *isw_sboffset))
+			/* Copy in first metadata sector. */
+			memcpy(isw_tmp, *isw, ISW_DISK_BLOCK_SIZE);
+		else {
+			dbg_free(isw_tmp);
+			isw_tmp = NULL;
+		}
+	}
+
+	dbg_free(*isw);
+	*isw = isw_tmp;
+
+	return isw_tmp ? 1 : 0;
+}
+
+/* Check for RAID disk ok. */
+static int disk_ok(struct lib_context *lc, struct dev_info *di, struct isw *isw)
+{
+	struct isw_disk *disk = get_disk(lc, di, isw);
+
+	return disk && __status(disk->status) == s_ok;
+}
+
+static void *isw_read_metadata(struct lib_context *lc, struct dev_info *di,
+			       size_t *sz, uint64_t *offset,
+			       union read_info *info)
+{
+	size_t size = ISW_DISK_BLOCK_SIZE;
+	uint64_t isw_sboffset = ISW_CONFIGOFFSET;
+	struct isw *isw;
+
+	if (!(isw = alloc_private_and_read(lc, handler, size,
+					   di->path, isw_sboffset)))
+		goto out;
+
+	/*
+	 * Convert start of metadata only, because we might need to
+	 * read extended metadata located ahead of it first.
+	 */
+	to_cpu(isw, FIRST);
+
+	/* Check Signature and read optional extended metadata. */
+	if (!is_isw(lc, di, isw) ||
+	    !isw_read_extended(lc, di, &isw, &isw_sboffset, &size))
+		goto bad;
+
+	/*
+	 * Now that we made sure, that we've got all the
+	 * metadata, we can convert it completely.
+	 */
+	to_cpu(isw, LAST);
+
+	if (disk_ok(lc, di, isw)) {
+		*sz = size;
+		*offset = isw_sboffset;
+		info->u64 = isw_sboffset;
+		goto out;
+	}
+	
+   bad:
+	dbg_free(isw);
+	isw = NULL;
+
+   out:
+	return (void*) isw;
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *isw_read(struct lib_context *lc, struct dev_info *di)
+{
+	return read_raid_dev(lc, di, isw_read_metadata, 0, 0, NULL, NULL,
+			     isw_file_metadata, setup_rd, handler);
+}
+
+/*
+ * Write an Intel Software RAID device.
+ */
+static int isw_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+{
+	int ret;
+	struct isw *isw = META(rd, isw);
+
+	to_disk(isw, FULL);
+
+	/*
+	 * Copy 1st metadata sector to after the extended ones
+	 * and increment metadata area pointer by one block, so
+	 * that the metadata is filed in the proper sequence.
+	 */
+	memcpy((void*) isw + rd->meta_areas->size, isw, ISW_DISK_BLOCK_SIZE);
+	rd->meta_areas->area += ISW_DISK_BLOCK_SIZE;
+
+	ret = write_metadata(lc, handler, rd, -1, erase);
+
+	/* Correct metadata area pointer. */
+	rd->meta_areas->area -= ISW_DISK_BLOCK_SIZE;
+
+	to_cpu(isw, FULL);
+
+	return ret;
+}
+
+/*
+ * Group an Intel SW RAID disk into potentially
+ * multiple RAID sets and RAID disks.
+ */
+/* Check state if isw device map. */
+static int _check_map_state(struct lib_context *lc, struct raid_dev *rd,
+			    struct isw_dev *dev)
+{
+	/* FIXME: FAILED_MAP etc. */
+	switch (dev->vol.map.map_state) {
+	case ISW_T_STATE_NORMAL:
+	case ISW_T_STATE_UNINITIALIZED:
+		break;
+
+	default:
+		LOG_ERR(lc, 0, "%s: unsupported map state 0x%x on %s for %s",
+			handler, dev->vol.map.map_state, rd->di->path,
+			(char*) dev->volume);
+	}
+
+	return 1;
+}
+
+/* Create a RAID device to map a volumes segment. */
+static struct raid_dev *_create_rd(struct lib_context *lc, struct raid_dev *rd,
+				   struct isw *isw, struct isw_dev *dev)
+{
+	struct raid_dev *r;
+
+	if (!_check_map_state(lc, rd, dev) ||
+	    !(r = alloc_raid_dev(lc, handler)))
+		return NULL;
+
+	if (!(r->private.ptr = alloc_private(lc, handler, sizeof(*dev))))
+		goto free;
+
+	memcpy(r->private.ptr, dev, sizeof(*dev));
+	if ((r->type = type(r)) == t_undef) {
+		log_err(lc, "%s: RAID type %u not supported",
+			handler, (unsigned int) dev->vol.map.raid_level);
+		goto free;
+	}
+
+        if (!(r->name = name(lc, isw, dev)))
+		goto free;
+
+	r->di = rd->di;
+	r->fmt = rd->fmt;
+	
+	r->offset  = dev->vol.map.pba_of_lba0;
+	r->sectors = dev->vol.map.blocks_per_member;
+
+	goto out;
+
+   free:
+	free_raid_dev(lc, &r);
+   out:
+	return r;
+}
+
+/* Find an Intel RAID set or create it. */
+static void create_rs(struct raid_set *rs, void* private)
+{
+	rs->stride = ((struct isw_dev*) private)->vol.map.blocks_per_strip;
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	struct isw *isw = RD(new)->private.ptr;
+	
+	return _get_disk(isw, RD(new)->di) < _get_disk(isw, RD(pos)->di);
+}
+
+/*
+ * rs_group contains the top-level group RAID set (type: t_group) on entry
+ * and shall be returned on success (or NULL on error).
+ */
+static struct raid_set *group_rd(struct lib_context *lc,
+				   struct raid_set *rs_group,
+				   struct raid_dev *rd_meta)
+{
+	unsigned int d;
+	void *private;
+	struct isw *isw = META(rd_meta, isw);
+	struct isw_dev *dev;
+	struct raid_dev *rd;
+	struct raid_set *rs;
+
+	/* Loop the device/volume table. */
+	for (d = 0; d < isw->num_raid_devs; d++) {
+		dev = raiddev(isw, d);
+
+		if (!(rd = _create_rd(lc, rd_meta, isw, dev)))
+			return NULL;
+
+		if (!(rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL,
+				      		  rd, &rs_group->sets,
+						  create_rs, dev))) {
+			free_raid_dev(lc, &rd);
+			return NULL;
+		}
+
+		/* Save and set to enable dev_sort(). */
+		private = rd->private.ptr;
+		rd->private.ptr = isw;
+
+		list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+		/* Restore. */
+		rd->private.ptr = private;
+	}
+
+	return rs_group;
+}
+
+/* Add an Intel SW RAID device to a set */
+static struct raid_set *isw_group(struct lib_context *lc,
+				    struct raid_dev *rd_meta)
+{
+	struct raid_set *rs_group;
+
+	if (T_SPARE(rd_meta))
+		return NULL;
+
+	/*
+	 * Once we get here, an Intel SW RAID disk containing a metadata area
+	 * with a volume table has been discovered by isw_read.
+	 */
+	/* Check if a top level group RAID set already exists. */
+	if (!(rs_group = find_or_alloc_raid_set(lc, rd_meta->name, FIND_TOP,
+				      		rd_meta, LC_RS(lc),
+						NO_CREATE, NO_CREATE_ARG)))
+		return NULL;
+
+	/*
+	 * Add the whole underlying (meta) RAID device to the group set.
+	 * Sorting is no problem here, because RAID sets and devices will
+	 * be created for all the Volumes of an ISW set and those need sorting.
+	 */
+	rd_meta->private.ptr = rd_meta->meta_areas->area;
+	list_add_sorted(lc, &rs_group->devs, &rd_meta->devs, dev_sort);
+	rd_meta->private.ptr = NULL;
+
+	/*
+	 * We need to run through the volume table and create a RAID set and
+	 * RAID devices hanging off it for every volume,
+	 * so that the activate code is happy.
+	 *
+	 * A pointer to the top-level group RAID set
+	 * gets returned or NULL on error.
+	 */
+	return group_rd(lc, rs_group, rd_meta);
+}
+
+/*
+ * Check an Intel SW RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	return ((struct isw_dev*) rd->private.ptr)->vol.map.num_members;
+}
+
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context)
+{
+	struct isw_dev *dev = rd->private.ptr;
+
+	/* FIXME: more status checks ? */
+	if (dev->status)
+		LOG_ERR(lc, 0, "%s device for volume \"%s\" broken on %s "
+			"in RAID set \"%s\"",
+			handler, dev->volume, rd->di->path, rs->name);
+
+	return 1;
+}
+
+static int _isw_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL, check_rd, NULL, handler);
+}
+
+static int isw_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return T_GROUP(rs) ? _isw_check(lc, rs) : 0;
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct isw *isw = META(rd, isw);
+	struct isw_disk *disk;
+
+	if (!(disk = get_disk(lc, rd->di, isw)))
+		LOG_ERR(lc, 0, "%s: disk", handler);
+
+	/* Avoid write trashing. */
+	if (S_BROKEN(status(lc, rd)))
+		return 0;
+
+	disk->status &= ~USABLE_DISK;
+	disk->status |= FAILED_DISK;
+
+	return 1;
+}
+
+static struct event_handlers isw_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about an ISW RAID device.
+ */
+static void isw_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	unsigned int d, i;
+	struct isw *isw = META(rd, isw);
+	struct isw_disk *disk;
+	struct isw_dev *dev;
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	P("sig: \"%*s\"", isw, isw->sig, MAX_SIGNATURE_LENGTH, isw->sig);
+	DP("check_sum: %u", isw, isw->check_sum);
+	DP("mpb_size: %u", isw, isw->mpb_size);
+	DP("family_num: %u", isw, isw->family_num);
+	DP("generation_num: %u", isw, isw->generation_num);
+	DP("reserved[0]: %u", isw, isw->reserved[0]);
+	DP("reserved[1]: %u", isw, isw->reserved[1]);
+	DP("num_disks: %u", isw, isw->num_disks);
+	DP("num_raid_devs: %u", isw, isw->num_raid_devs);
+	DP("fill[0]: %u", isw, isw->fill[0]);
+	DP("fill[1]: %u", isw, isw->fill[1]);
+
+	for (i = 0; i < ISW_FILLERS; i++) {
+		if (isw->filler[i])
+        		P("filler[%i]: %u", isw,
+			  isw->filler[i], i, isw->filler[i]);
+	}
+
+	/* Disk table. */
+	for (d = 0, disk = isw->disk; d < isw->num_disks; d++, disk++) {
+		if (!disk->totalBlocks)
+			continue;
+
+		P("disk[%u].serial: \"%*s\"", isw,
+		  disk->serial, d, MAX_RAID_SERIAL_LEN, disk->serial);
+		P("disk[%u].totalBlocks: %u", isw,
+		  disk->totalBlocks, d, disk->totalBlocks);
+		P("disk[%u].scsiId: 0x%x", isw, disk->scsiId, d, disk->scsiId);
+		P("disk[%u].status: 0x%x", isw, disk->status, d, disk->status);
+		for (i = 0; i < ISW_DISK_FILLERS; i++) {
+			if (disk->filler[i])
+                		P("disk[%u].filler[%u]: %u", isw,
+				  disk->filler[i], d, i, disk->filler[i]);
+		}
+	}
+
+	/* RAID device/volume table. */
+	for (d = 0; d < isw->num_raid_devs; d++) {
+		dev = raiddev(isw, d);
+
+		/* RAID device */
+		P("isw_dev[%u].volume: \"%*s\"", isw,
+		  dev->volume, d, MAX_RAID_SERIAL_LEN, dev->volume);
+		P("isw_dev[%u].SizeHigh: %u", isw,
+		  dev->SizeHigh, d, dev->SizeHigh);
+		P("isw_dev[%u].SizeLow: %u", isw,
+		  dev->SizeLow, d, dev->SizeLow);
+		P("isw_dev[%u].status: 0x%x", isw, dev->status, d, dev->status);
+		P("isw_dev[%u].reserved_blocks: %u", isw,
+		  dev->reserved_blocks, d, dev->reserved_blocks);
+
+		for (i = 0; i < ISW_DEV_FILLERS; i++) {
+			if (dev->filler[i])
+                		P("isw_dev[%u].filler[%u]: %u", isw,
+				  dev->filler[i], d, i, dev->filler[i]);
+		}
+
+		/* RAID volume */
+		for (i = 0; i < 2; i++) {
+			if (dev->vol.reserved[i])
+                		P("isw_dev[%u].vol.reserved[%u]: %u", isw,
+				  dev->vol.reserved[i], d, i,
+				  dev->vol.reserved[i]);
+		}
+
+		P("isw_dev[%u].vol.migr_state: %u", isw,
+		  dev->vol.migr_state, d, dev->vol.migr_state);
+		P("isw_dev[%u].vol.migr_type: %u", isw,
+		  dev->vol.migr_type, d, dev->vol.migr_type);
+		P("isw_dev[%u].vol.dirty: %u", isw,
+		  dev->vol.dirty, d, dev->vol.dirty);
+		P("isw_dev[%u].vol.fill[0]: %u", isw,
+		  dev->vol.fill[0], d, dev->vol.fill[0]);
+
+		for (i = 0; i < 5; i++) {
+			if (dev->vol.filler[i])
+                		P("isw_dev[%u].vol.filler[%u]: %u", isw,
+				  dev->vol.filler[i], d, i,
+				  dev->vol.filler[i]);
+		}
+
+		/* RAID map */
+		P("isw_dev[%u].vol.map.pba_of_lba0: %u", isw,
+		  dev->vol.map.pba_of_lba0, d,
+		  dev->vol.map.pba_of_lba0);
+		P("isw_dev[%u].vol.map.blocks_per_member: %u", isw,
+		  dev->vol.map.blocks_per_member, d,
+		  dev->vol.map.blocks_per_member);
+		P("isw_dev[%u].vol.map.num_data_stripes: %u", isw,
+		  dev->vol.map.num_data_stripes, d,
+		  dev->vol.map.num_data_stripes);
+		P("isw_dev[%u].vol.map.blocks_per_strip: %u", isw,
+		  dev->vol.map.blocks_per_strip, d,
+		  dev->vol.map.blocks_per_strip);
+		P("isw_dev[%u].vol.map.map_state: %u", isw,
+		  dev->vol.map.map_state, d,
+		  dev->vol.map.map_state);
+		P("isw_dev[%u].vol.map.raid_level: %u", isw,
+		  dev->vol.map.raid_level, d,
+		  dev->vol.map.raid_level);
+		P("isw_dev[%u].vol.map.num_members: %u", isw,
+		  dev->vol.map.num_members, d,
+		  dev->vol.map.num_members);
+
+		for (i = 0; i < 3; i++) {
+			if (dev->vol.map.reserved[i])
+                		P("isw_dev[%u].vol.map.reserved[%u]: %u", isw,
+				  dev->vol.map.reserved[i], d, i,
+				  dev->vol.map.reserved[i]);
+		}
+
+		for (i = 0; i < 7; i++) {
+			if (dev->vol.map.filler[i])
+                		P("isw_dev[%u].vol.map.filler[%u]: %u", isw,
+				  dev->vol.map.filler[i], d, i,
+				  dev->vol.map.filler[i]);
+		}
+
+		for (i = 0; i < isw->num_disks; i++) {
+			P("isw_dev[%u].vol.map.disk_ord_tbl[%u]: 0x%x", isw,
+			  dev->vol.map.disk_ord_tbl[i], d, i,
+			  dev->vol.map.disk_ord_tbl[i]);
+		}
+	}
+}
+#endif
+
+static struct dmraid_format isw_format = {
+	.name	= HANDLER,
+	.descr	= "Intel Software RAID",
+	.caps	= "0,1",
+	.format = FMT_RAID,
+	.read	= isw_read,
+	.write	= isw_write,
+	.group	= isw_group,
+	.check	= isw_check,
+	.events	= &isw_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= isw_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_isw(struct lib_context *lc)
+{
+	return register_format_handler(lc, &isw_format);
+}
+
+/*
+ * Set the RAID device contents up derived from the Intel ones.
+ *
+ * This is the first one we get with here and we potentially need to
+ * create many in isw_group() in case of multiple Intel SW RAID devices
+ * on this RAID disk.
+ */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct isw *isw = meta;
+
+	/* Superblock checksum */
+	if (isw->check_sum != _checksum(isw))
+		LOG_ERR(lc, 0, "%s: extended superblock for %s "
+			       "has wrong checksum",
+			handler, di->path);
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = info->u64 >> 9;
+	rd->meta_areas->size = round_up(isw->mpb_size, ISW_DISK_BLOCK_SIZE);
+	rd->meta_areas->area = (void*) isw;
+
+	rd->di = di;
+	rd->fmt = &isw_format;
+
+	rd->offset = ISW_DATAOFFSET;
+	rd->sectors = info->u64 >> 9;
+
+	rd->status = status(lc, rd);
+	rd->type   = t_group;
+
+        return (rd->name = name(lc, isw, NULL)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/isw.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/isw.h
+++ -	2008-02-22 16:57:41.520770000 +0000
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2003,2004,2005 Intel Corporation. 
+ *
+ * dmraid extensions:
+ * Copyright (C) 2004,2005 Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2.1, or (at your option)
+ * any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * (for example /usr/src/linux/COPYING); if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Authors: Boji Tony Kannanthanam 
+ *          < boji dot t dot kannanthanam at intel dot com >
+ *          Martins Krikis
+ *          < martins dot krikis at intel dot com >
+ */
+
+/*
+ * Intel Software Raid metadata definitions.
+ */
+
+#ifndef _ISW_H_
+#define _ISW_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+/* Intel metadata offset in bytes */
+#define	ISW_CONFIGOFFSET	((di->sectors - 2) << 9)
+#define	ISW_DATAOFFSET		0	/* Data offset in sectors */
+
+#define MPB_SIGNATURE	     "Intel Raid ISM Cfg Sig. "
+#define MPB_VERSION_RAID2                             "1.2.02"
+#define MAX_SIGNATURE_LENGTH  32
+#define MAX_RAID_SERIAL_LEN   16
+#define ISW_DISK_BLOCK_SIZE  512
+#define TYPICAL_MPBSIZE 1024
+
+/* Disk configuration info. */
+struct isw_disk {
+	int8_t serial[MAX_RAID_SERIAL_LEN];/* 0xD8 - 0xE7 ascii serial number */
+	uint32_t totalBlocks;	/* 0xE8 - 0xEB total blocks */
+	uint32_t scsiId;	/* 0xEC - 0xEF scsi ID */
+	uint32_t status;	/* 0xF0 - 0xF3 */
+#define SPARE_DISK      0x01  /* Spare */
+#define CONFIGURED_DISK 0x02  /* Member of some RaidDev */
+#define FAILED_DISK     0x04  /* Permanent failure */
+#define USABLE_DISK     0x08  /* Fully usable unless FAILED_DISK is set */
+
+#define	ISW_DISK_FILLERS	5
+	uint32_t filler[ISW_DISK_FILLERS]; /* 0xF4 - 0x107 MPB_DISK_FILLERS for future expansion */
+};
+
+/* RAID map configuration infos. */
+struct isw_map {
+	uint32_t pba_of_lba0;		// start address of partition
+	uint32_t blocks_per_member;	// blocks per member
+	uint32_t num_data_stripes;	// number of data stripes
+	uint16_t blocks_per_strip;
+	uint8_t  map_state;		// Normal, Uninitialized, Degraded, Failed
+#define	ISW_T_STATE_NORMAL		0
+#define	ISW_T_STATE_UNINITIALIZED	1
+	uint8_t  raid_level;
+#define	ISW_T_RAID0	0
+#define	ISW_T_RAID1	1
+#define	ISW_T_RAID5	5		// since metadata version 1.2.02 ?
+	uint8_t  num_members;		// number of member disks
+	uint8_t  reserved[3];
+	uint32_t filler[7];		// expansion area
+	uint32_t disk_ord_tbl[1];	/* disk_ord_tbl[num_members],
+					   top byte special */
+} __attribute__ ((packed));
+
+struct isw_vol {
+	uint32_t reserved[2];
+	uint8_t  migr_state;		// Normal or Migrating
+	uint8_t  migr_type;		// Initializing, Rebuilding, ...
+	uint8_t  dirty;
+	uint8_t  fill[1];
+	uint32_t filler[5];
+	struct isw_map map;
+	// here comes another one if migr_state
+} __attribute__ ((packed));
+
+struct isw_dev {
+	uint8_t	volume[MAX_RAID_SERIAL_LEN];
+	uint32_t SizeLow;
+	uint32_t SizeHigh;
+	uint32_t status;	/* Persistent RaidDev status */
+	uint32_t reserved_blocks; /* Reserved blocks at beginning of volume */
+#define	ISW_DEV_FILLERS	12
+	uint32_t filler[ISW_DEV_FILLERS];
+	struct isw_vol vol;
+} __attribute__ ((packed));
+
+struct isw {
+	int8_t sig[MAX_SIGNATURE_LENGTH];/* 0x0 - 0x1F */
+	uint32_t check_sum;		/* 0x20 - 0x23  MPB Checksum */
+	uint32_t mpb_size;		/* 0x24 - 0x27 Size of MPB */
+	uint32_t family_num;		/* 0x28 - 0x2B Checksum from first time this config was written */
+	/* 0x2C - 0x2F  Incremented each time this array's MPB is written */
+	uint32_t generation_num;
+	uint32_t reserved[2];		/* 0x30 - 0x37 */
+	uint8_t num_disks;		/* 0x38 Number of configured disks */
+	uint8_t num_raid_devs;		/* 0x39 Number of configured volumes */
+	uint8_t fill[2];		/* 0x3A - 0x3B */
+#define	ISW_FILLERS	39
+	uint32_t filler[ISW_FILLERS];	/* 0x3C - 0xD7 RAID_MPB_FILLERS */
+	struct isw_disk disk[1];	/* 0xD8 diskTbl[numDisks] */
+	// here comes isw_dev[num_raid_devs]
+} __attribute__ ((packed));
+
+#endif
+
+int register_isw(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/jm.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/jm.c
+++ -	2008-02-22 16:57:41.607120000 +0000
@@ -0,0 +1,379 @@
+/*
+ * Copyright (C) 2006  Heinz Mauelshagen, Red Hat GmbH.
+ *                     All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * JMicron ATARAID metadata format handler.
+ */
+#define	HANDLER "jmicron"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "jm.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/* RAID set name */
+static int member(struct jm *jm);
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	struct jm *jm = META(rd, jm);
+	char buf[2], *ret, *name = (char *) jm->name;
+
+	/* Name always 0 terminated ? */
+	if ((len = strlen(name)) > JM_NAME_LEN)
+		len = JM_NAME_LEN;
+
+	len += sizeof(HANDLER) + 2;
+	if (jm->mode == JM_T_RAID01)
+		len++;
+
+	if ((ret = dbg_malloc(len))) {
+		if (jm->mode == JM_T_RAID01 && subset)
+			sprintf(buf, "-%u", member(jm) / 2);
+		else
+			*buf = 0;
+
+		sprintf(ret, "%s_%s%s", HANDLER, name, buf);
+	}
+
+	return ret;
+}
+
+/*
+ * Retrieve status of device.
+ * FIXME: is this sufficient to cover all state ?
+ */
+static enum status status(struct jm *jm)
+{
+	return jm->attribute & ~(JM_MOUNT|JM_BOOTABLE|JM_BADSEC|JM_ACTIVE|JM_UNSYNC|JM_NEWEST) ? s_broken : s_ok;
+}
+
+/* Mapping of JM types to generic types */
+static struct types types[] = {
+	{ JM_T_JBOD, t_linear},
+	{ JM_T_RAID0, t_raid0},
+	{ JM_T_RAID01, t_raid1},
+	{ JM_T_RAID1, t_raid1},
+	{ 0, t_undef}
+};
+
+/* Neutralize disk type */
+static enum type type(struct jm *jm)
+{
+	return rd_type(types, (unsigned int) jm->mode);
+}
+
+/* Calculate checksum on metadata */
+static int checksum(struct jm *jm)
+{
+	int count = 64;
+	uint16_t *p = (uint16_t*) jm, sum = 0;
+
+        while (count--)
+		sum += *p++;
+
+	return sum;
+}
+
+static inline unsigned int segment(uint32_t m)
+{
+	return (unsigned int) (m & JM_SEG_MASK);
+}
+
+static inline unsigned int disk(unsigned int m)
+{
+	return (unsigned int) (m & JM_HDD_MASK);
+}
+
+static int member(struct jm *jm)
+{
+	unsigned int i = JM_MEMBERS;
+
+	while (i--) {
+		if (disk(jm->member[i]) == disk(jm->identity))
+			return i;
+	}
+
+	return -1;
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return member(META(RD(new), jm)) < member(META(RD(pos), jm));
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return member(META(RD_RS(RS(pos)), jm)) > 1;
+}
+
+static unsigned int stride(unsigned int shift)
+{
+	return 1 << (shift + 1);
+}
+
+static void super_created(struct raid_set *super, void *private)
+{
+	super->type   = t_raid0;
+	super->stride = stride(META((private), jm)->block);
+}
+
+/*
+ * Group the RAID disk into a JM set.
+ *
+ * Check device hierarchy and create super set appropriately.
+ */
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct jm *jm = META(rd, jm);
+
+	if (!init_raid_set(lc, rs, rd, stride(jm->block), jm->mode, handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	switch (jm->mode) {
+	case JM_T_JBOD:
+	case JM_T_RAID0:
+	case JM_T_RAID1:
+		if (!find_set(lc, NULL, rs->name, FIND_TOP))
+			list_add_tail(&rs->list, LC_RS(lc));
+
+		break;
+
+	case JM_T_RAID01:
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Add a JMicron RAID device to a set.
+ */
+static struct raid_set *jm_group(struct lib_context *lc,
+				       struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	if (T_SPARE(rd))
+		return NULL;
+
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+/*
+ * Read a JMicron RAID device.
+ */
+/* Endianess conversion. */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	unsigned int i;
+	struct jm *jm = meta;
+
+	CVT16(jm->version);
+	CVT16(jm->checksum);
+	CVT32(jm->identity);
+
+	CVT32(jm->segment.base);
+	CVT32(jm->segment.range);
+	CVT16(jm->segment.range2);
+
+	CVT16(jm->attribute);
+
+	for (i = 0; i < JM_SPARES; i++)
+		CVT32(jm->spare[i]);
+
+	for (i = 0; i < JM_MEMBERS; i++)
+		CVT32(jm->member[i]);
+}
+#endif
+
+/* Magic check. */
+static int is_jm(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct jm *jm = meta;
+
+	return !strncmp((const char*) jm->signature,
+			JM_SIGNATURE, JM_SIGNATURE_LEN)
+	       && !checksum(jm);
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *jm_read(struct lib_context *lc,
+				      struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct jm), JM_CONFIGOFFSET,
+			     to_cpu, is_jm, NULL, setup_rd, handler);
+}
+
+/*
+ * Write a JMicron RAID device.
+ */
+static int jm_write(struct lib_context *lc,
+			struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct jm *jm = META(rd, jm);
+
+	to_disk(jm);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(jm);
+#endif
+	return ret;
+}
+
+/*
+ * Check a JMicron RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	unsigned int r = JM_MEMBERS;
+	struct jm *jm = META(rd, jm);
+
+	while (r-- && !jm->member[r]);
+
+	return ++r;
+}
+
+static int jm_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL,
+			      NO_CHECK_RD, NULL, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct jm *jm = META(rd, jm);
+
+	/* Avoid write trashing. */
+	if (S_BROKEN(status(jm)))
+		return 0;
+
+	jm->checksum = 1; /* FIXME: how to flag a JMicron disk bad? */
+
+	return 1;
+}
+
+static struct event_handlers jm_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about an JM RAID device.
+ */
+static void jm_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	unsigned int i;
+	struct jm *jm = META(rd, jm);
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	P("signature: %c%c", jm, jm->signature,
+	  jm->signature[0], jm->signature[1]);
+	P("version: %u%u", jm, jm->version,
+	  JM_MAJOR_VERSION(jm), JM_MINOR_VERSION(jm));
+	DP("checksum: %u", jm, jm->checksum);
+	DP("identity: 0x%x", jm, jm->identity);
+	DP("base: %u", jm, jm->segment.base);
+	DP("range: %u", jm, jm->segment.range);
+	DP("range2: %u", jm, jm->segment.range2);
+	DP("name: \"%s\"", jm, jm->name);
+	DP("name: %u", jm, jm->mode);
+	DP("block: %u", jm, jm->block);
+	DP("attribute: %u", jm, jm->attribute);
+	for (i = 0; i < JM_SPARES; i++)
+		P2("spare[%d]: 0x%x", jm, i, jm->spare[i]);
+	for (i = 0; i < JM_MEMBERS; i++)
+		P2("member[%d]: 0x%x", jm, i, jm->member[i]);
+}
+#endif
+
+static struct dmraid_format jm_format = {
+	.name	= HANDLER,
+	.descr	= "JMicron ATARAID",
+	.caps	= "S,0,1",
+	.format = FMT_RAID,
+	.read	= jm_read,
+	.write	= jm_write,
+	.group	= jm_group,
+	.check	= jm_check,
+	.events	= &jm_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= jm_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_jm(struct lib_context *lc)
+{
+	return register_format_handler(lc, &jm_format);
+}
+
+/* Calculate RAID device size in sectors depending on RAID type. */
+static inline uint64_t sectors(struct jm *jm)
+{
+	/* range * 32MB[sectors] + range2 */
+	return jm->segment.range * 32*2048 + jm->segment.range2;
+}
+
+/* Set the RAID device contents up derived from the JMicron ones */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct jm *jm = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = JM_CONFIGOFFSET >> 9;
+	rd->meta_areas->size = sizeof(*jm);
+	rd->meta_areas->area = (void*) jm;
+
+	rd->di = di;
+	rd->fmt = &jm_format;
+
+	rd->status = status(jm);
+	rd->type   = type(jm);
+
+	rd->offset = jm->segment.base;
+	if (!(rd->sectors = sectors(jm)))
+		return log_zero_sectors(lc, di->path, handler);
+
+	return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/jm.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/jm.h
+++ -	2008-02-22 16:57:41.712131000 +0000
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2006  Heinz Mauelshagen, Red Hat GmbH.
+ *                     All rights reserved.
+ *
+ * Based on metadata specs kindly provided by JMicron
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_JMICRON_H_
+#define	_JMICRON_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+/* JMicron config data sector offset off end of disk */
+#define JM_CONFIGOFFSET	((di->sectors - 1) << 9)
+
+/* Ondisk metadata for JMicron ATARAID */
+struct jm {
+#define JM_SIGNATURE "JM"
+#define JM_SIGNATURE_LEN	2
+	int8_t		signature[JM_SIGNATURE_LEN];	/* 0x0 - 0x01 */
+
+	uint16_t	version;	/* 0x03 - 0x04 JMicron version */
+#define	JM_MINOR_VERSION(jm)	(jm->version & 0xFF)
+#define	JM_MAJOR_VERSION(jm)	(jm->version >> 8)
+
+	uint16_t	checksum;	/* 0x04 - 0x05 */
+	uint8_t		filler[10];
+
+	uint32_t	identity;	/* 0x10 - 0x13 */
+
+	struct {
+		uint32_t	base;	/* 0x14 - 0x17 */
+		uint32_t	range;	/* 0x18 - 0x1B range */
+		uint16_t	range2;	/* 0x1C - 0x1D range2 */
+	} segment;
+
+#define	JM_NAME_LEN	16
+	int8_t		name[JM_NAME_LEN];	/* 0x20 - 0x2F */
+
+	uint8_t		mode;		/* 0x30 RAID level */
+#define	JM_T_RAID0	0
+#define	JM_T_RAID1	1
+#define	JM_T_RAID01	2	/* RAID 0+1 (striped with mirrors underneath) */
+#define	JM_T_JBOD	3
+#define	JM_T_RAID5	5
+
+	uint8_t		block;		/* 0x31 stride size (2=4K, 3=8K, ...) */
+	uint16_t	attribute;	/* 0x32 - 0x33 */ 
+#define	JM_MOUNT	0x01
+#define	JM_BOOTABLE	0x02
+#define	JM_BADSEC	0x03
+#define	JM_ACTIVE	0x05
+#define	JM_UNSYNC	0x06
+#define	JM_NEWEST	0x07
+
+	uint8_t		filler1[4];
+
+#define	JM_SPARES	2
+#define	JM_MEMBERS	8
+	uint32_t	spare[JM_SPARES];	/* 0x38 - 0x3F */
+	uint32_t	member[JM_MEMBERS];	/* 0x40 - 0x5F */
+#define	JM_HDD_MASK	0xFFFFFFF0
+#define	JM_SEG_MASK	0x0F
+
+	uint8_t		filler2[0x20];
+} __attribute__ ((packed));
+
+#endif
+
+int register_jm(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/lsi.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/lsi.c
+++ -	2008-02-22 16:57:41.827473000 +0000
@@ -0,0 +1,359 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *			    All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * LSI Logic MegaRAID (and MegaIDE ?) ATARAID metadata format handler.
+ *
+ * Needs more metadata reengineering and grouping logic coding.
+ *
+ */
+
+#define	HANDLER	"lsi"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "lsi.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/* Make up RAID device name. */
+/* FIXME: senseful name ;) */
+static unsigned int get_disk_slot(struct lsi *lsi)
+{
+	return lsi->set_number * 2 + lsi->disk_number;
+}
+
+static struct lsi_disk *get_disk(struct lsi *lsi)
+{
+	return lsi->disks + get_disk_slot(lsi);
+}
+
+static size_t _name(struct lsi *lsi, char *str, size_t len, unsigned int subset)
+{
+	return snprintf(str, len,
+			subset ? "lsi_%u%u-%u" : "lsi_%u%u",
+ 			lsi->set_id, lsi->set_number,
+			(get_disk(lsi))->raid10_mirror);
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	char *ret;
+	struct lsi *lsi = META(rd, lsi);
+
+	subset = subset && (lsi->type == LSI_T_RAID10);
+	if ((ret = dbg_malloc((len = _name(lsi, NULL, 0, subset) + 1)))) {
+		_name(lsi, ret, len, subset);
+		mk_alpha(lc, ret + HANDLER_LEN, strlen(ret) - HANDLER_LEN -
+			 (subset ? 2 : 0));
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/* Mapping of LSI Logic types to generic types */
+static struct types types[] = {
+	{ LSI_T_RAID0, t_raid0 },
+	{ LSI_T_RAID1, t_raid1 },
+	{ LSI_T_RAID10, t_raid0 },
+        { 0, t_undef}
+};
+
+/* Neutralize disk type */
+static enum type type(struct lsi *lsi)
+{
+	return rd_type(types, (unsigned int) lsi->type);
+}
+
+/* LSI device status. */
+/* FIXME: add flesh. */
+static int status(struct lsi *lsi)
+{
+	return s_ok;
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	struct lsi *p = META(RD(pos), lsi), *n = META(RD(new), lsi);
+
+	switch (n->type) {
+	case LSI_T_RAID10:
+		return (get_disk(n))->raid10_stripe < 
+		       (get_disk(p))->raid10_stripe;
+
+	default: /* RAID0 + RAID01 */
+		return get_disk_slot(n) < get_disk_slot(p);
+	}
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	struct lsi *p = META(RD_RS(pos), lsi), *n = META(RD_RS(new), lsi);
+
+	return n->disks[get_disk_slot(n)].raid10_mirror <
+	       p->disks[get_disk_slot(p)].raid10_mirror;
+}
+
+/*
+ * Read an LSI Logic RAID device
+ */
+/* Endianess conversion. */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct lsi *lsi = meta;
+	struct lsi_disk *disk;
+
+	CVT16(lsi->stride);
+
+	for (disk = lsi->disks; disk < &lsi->disks[LSI_MAX_DISKS]; disk++) {
+		CVT16(disk->magic_0);
+		CVT16(disk->magic_1);
+	}
+
+	CVT32(lsi->set_id);
+}
+#endif
+
+static int is_lsi(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	return !strncmp((const char*) ((struct lsi *) meta)->magic_name,
+	       LSI_MAGIC_NAME, LSI_MAGIC_NAME_LEN);
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *lsi_read(struct lib_context *lc, struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct lsi), LSI_CONFIGOFFSET, 
+			     to_cpu, is_lsi, NULL, setup_rd, handler);
+}
+
+/*
+ * Write a LSI Logic RAID device.
+ */
+static int lsi_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct lsi *lsi = META(rd, lsi);
+
+	to_disk(lsi);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(lsi);
+#endif
+	return ret;
+}
+
+/*
+ * Group the RAID disk into a set.
+ *
+ * FIXME: this needs more work together with the metadata reengineering.
+ */
+static void super_created(struct raid_set *ss, void *private)
+{
+	ss->type   = t_raid1;
+	ss->stride = META(private, lsi)->stride;
+}
+
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct lsi *lsi = META(rd, lsi);
+
+	if (!init_raid_set(lc, rs, rd, lsi->stride, type(lsi), handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	switch (lsi->type) {
+	case LSI_T_RAID0:
+	case LSI_T_RAID1:
+		if (!find_set(lc, NULL, rs->name, FIND_TOP))
+			list_add_tail(&rs->list, LC_RS(lc));
+		break;
+
+	case LSI_T_RAID10:
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+static struct raid_set *lsi_group(struct lib_context *lc,
+				    struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	if (T_SPARE(rd))
+		return NULL;
+
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+/* Figure total number of disks depending on RAID type. */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	switch ((META(rd, lsi))->type) {
+	case LSI_T_RAID10:
+		return 4;
+
+	case LSI_T_RAID0:
+	case LSI_T_RAID1:
+		return 2;
+	}
+
+	return 0;
+}
+
+/*
+ * Check an LSI RAID set.
+ *
+ * FIXME: more sanity checks!!!
+ */
+static int lsi_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL,
+			      NO_CHECK_RD, NULL, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct lsi *lsi = META(rd, lsi);
+
+	/* Avoid write trashing. */
+	if (status(lsi) & s_broken)
+		return 0;
+
+	// FIXME: lsi->? = BAD;
+
+	return 1;
+}
+
+static struct event_handlers lsi_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/* Log native information about an LSI Logic RAID device. */
+static void lsi_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	unsigned int i;
+	struct lsi *lsi = META(rd, lsi);
+	struct lsi_disk *disk;
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	DP("magic_name: %s", lsi, lsi->magic_name);
+	P("dummy: %u, 0x%x", lsi, lsi->dummy, lsi->dummy, lsi->dummy);
+	DP("seqno: %u", lsi, lsi->seqno);
+	P("dummy2: %u, 0x%x", lsi, lsi->dummy2, lsi->dummy2, lsi->dummy2);
+	P("dummy3: %u, 0x%x", lsi, lsi->dummy3, lsi->dummy3, lsi->dummy3);
+	DP("type: %u", lsi, lsi->type);
+	P("dummy4: %u, 0x%x", lsi, lsi->dummy4, lsi->dummy4, lsi->dummy4);
+	DP("stride: %u", lsi, lsi->stride);
+
+	for (disk = lsi->disks, i = 0; i < LSI_MAX_DISKS; disk++, i++) {
+		P("disks[%u].raid10_stripe: %u", lsi, disk, i,
+		  disk->raid10_stripe);
+		P("disks[%u].raid10_mirror: %u", lsi, disk, i,
+		  disk->raid10_mirror);
+		P("disks[%u].unknown: %u, 0x%x", lsi, disk, i,
+		  disk->unknown, disk->unknown);
+		P("disks[%u].magic_0: 0x%x, %x, %x", lsi,
+		  disk->magic_0, i, disk->magic_0,
+		  (unsigned char) (((char*) &disk->magic_0)[0]),
+		  (unsigned char) (((char*) &disk->magic_0)[1]));
+		P("disks[%u].magic_1: 0x%x, %x, %x", lsi,
+		  disk->magic_1, i, disk->magic_1,
+		  (unsigned char) (((char*) &disk->magic_1)[0]),
+		  (unsigned char) (((char*) &disk->magic_1)[1]));
+		P("disks[%u].disk_number: %u", lsi, disk->disk_number,
+		  i, disk->disk_number);
+		P("disks[%u].set_number: %u", lsi, disk->set_number,
+		  i, disk->set_number);
+		P("disks[%u].unknown1: %u, 0x%u", lsi, disk->unknown1,
+		  i, disk->unknown1, disk->unknown1);
+	}
+
+	DP("disk_number: %u", lsi, lsi->disk_number);
+	DP("set_number: %u", lsi, lsi->set_number);
+	DP("set_id: %u", lsi, lsi->set_id);
+}
+#endif
+
+static struct dmraid_format lsi_format = {
+	.name	= HANDLER,
+	.descr	= "LSI Logic MegaRAID",
+	.caps	= "0,1,10",
+	.format = FMT_RAID,
+	.read	= lsi_read,
+	.write	= lsi_write,
+	.group	= lsi_group,
+	.check	= lsi_check,
+	.events	= &lsi_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= lsi_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_lsi(struct lib_context *lc)
+{
+	return register_format_handler(lc, &lsi_format);
+}
+
+/* Set the RAID device contents up derived from the LSI ones */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct lsi *lsi = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = LSI_CONFIGOFFSET >> 9;
+	rd->meta_areas->size   = sizeof(*lsi);
+	rd->meta_areas->area   = (void*) lsi;
+
+        rd->di = di;
+	rd->fmt = &lsi_format;
+
+	rd->status = status(lsi);
+	rd->type   = type(lsi);
+
+	rd->offset = LSI_DATAOFFSET;
+	/* FIXME: propper size ? */
+	rd->sectors = rd->meta_areas->offset;
+
+        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/lsi.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/lsi.h
+++ -	2008-02-22 16:57:41.943455000 +0000
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_LSI_H_
+#define	_LSI_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+/*
+ * FIXME: this needs more reengineering still.
+ */
+
+#include <stdint.h>
+
+#define	LSI_CONFIGOFFSET	((di->sectors - 1) << 9)
+#define	LSI_DATAOFFSET		0
+
+struct lsi_disk {
+	uint16_t raid10_stripe:4;
+	uint16_t raid10_mirror:4;
+	uint16_t unknown:8;
+	uint16_t magic_0;
+	uint16_t magic_1;
+	uint8_t disk_number;
+	uint8_t set_number;
+	uint8_t unknown1[8];
+} __attribute__ ((packed));
+
+struct lsi {
+#define	LSI_MAGIC_NAME	"$XIDE$"
+#define	LSI_MAGIC_NAME_LEN	(sizeof(LSI_MAGIC_NAME) - 1)
+	uint8_t magic_name[LSI_MAGIC_NAME_LEN];	/* 0x0 - 0x05 */
+	uint8_t  dummy;		/* 0x06 */
+	uint8_t  seqno;		/* 0x07 */
+	uint32_t dummy2;		/* 0x08 - 0x0B */
+	uint32_t dummy3;		/* 0x0C - 0x0F */
+	uint8_t  type;			/* 0x10 */
+#define LSI_T_RAID0	1
+#define LSI_T_RAID1	2
+#define LSI_T_RAID10	3
+
+	uint8_t dummy4;		/* 0x11 */
+	uint16_t stride;		/* 0x12 - 0x13 */
+	uint8_t filler[0x20-0x14];	/* 0x14 - 0x1F */
+#define	LSI_MAX_DISKS	4
+	struct lsi_disk disks[LSI_MAX_DISKS];/* 0x20 - 0x5F */
+#define	LSI_DISK(lsi)		(lsi->set_number * 2 + lsi->disk_number)
+#define LSI_MAGIC_0(lsi)	(lsi->disks[LSI_DISK(lsi)].magic_0)
+#define LSI_MAGIC_1(lsi)	(lsi->disks[LSI_DISK(lsi)].magic_1)
+#define LSI_DISK_NUMBER(lsi)	(lsi->disks[LSI_DISK(lsi)].disk_number)
+#define LSI_SET_NUMBER(lsi)	(lsi->disks[LSI_DISK(lsi)].set_number)
+#undef	LSI_DISK
+
+	uint8_t filler1[0x1F0-0x60];	/* 0x70 - 0x1EF */
+
+	uint8_t disk_number;		/* 0x1F0 */
+	uint8_t set_number;		/* 0x1F1 */
+	uint32_t set_id;		/* 0x1F2 - 0x1F5 */
+
+	uint8_t filler2[0x200-0x1F6];	/* 0x1F6 - 0x200 */
+} __attribute__ ((packed));
+#endif
+
+int register_lsi(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/nv.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/nv.c
+++ -	2008-02-22 16:57:42.023077000 +0000
@@ -0,0 +1,432 @@
+/*
+ * Copyright (C) 2004      NVidia Corporation. All rights reserved.
+ * Copyright (C) 2004,2005 Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * NVidia NVRAID metadata format handler.
+ */
+#define	HANDLER "nvidia"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "nv.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/*
+ * Make up RAID device name from array signature.
+ *
+ * The subset parameter indicates the requirement to create
+ * name suffixes in case the RAID set is hierarchical.
+ */
+static unsigned int _subset(struct nv *nv)
+{
+	return nv->unitNumber >= nv->array.stripeWidth;
+}
+
+static size_t _name(struct nv *nv, char *str, size_t len, unsigned int subset)
+{
+	unsigned int i = NV_SIGNATURES;
+	uint32_t sum = 0;
+
+	while (i--)
+		sum += nv->array.signature[i];
+
+	return snprintf(str, len, subset ? "%s_%.8x-%u" : "%s_%.8x",
+			handler, sum, _subset(nv));
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	char *ret;
+	struct nv *nv = META(rd, nv);
+
+	subset &= NVRAID_1_0(nv);
+	if ((ret = dbg_malloc((len = _name(nv, NULL, 0, subset) + 1)))) {
+		_name(nv, ret, len, subset);
+		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN - subset - 1);
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/* Mapping of nv types to generic types */
+static struct types types[] = {
+	{ NV_LEVEL_JBOD, t_linear },
+	{ NV_LEVEL_0, t_raid0 },
+	{ NV_LEVEL_1, t_raid1 },
+	{ NV_LEVEL_1_0, t_raid0 },	/* Treat as 0 here, add mirror later */
+	{ NV_LEVEL_3, t_raid4 },
+	{ NV_LEVEL_5_SYM, t_raid5_ls },
+        { NV_LEVEL_UNKNOWN, t_spare},	/* FIXME: UNKNOWN = spare ? */
+	/* FIXME: The ones below don't really map to anything ?? */
+	{ NV_LEVEL_10, t_undef },
+	{ NV_LEVEL_5, t_undef },    /* Asymmetric RAID 5 is not used */
+};
+
+static enum status status(struct nv *nv)
+{
+	if (NV_BROKEN(nv))
+		return s_broken;
+	
+	switch(nv->array.raidJobCode) {
+	case NV_IDLE:
+		return s_ok;
+
+	case NV_SCDB_INIT_RAID:
+	case NV_SCDB_SYNC_RAID:
+		return s_nosync;
+
+	case NV_SCDB_REBUILD_RAID:
+	case NV_SCDB_UPGRADE_RAID:
+		return s_inconsistent;
+	}
+
+	return s_broken; 
+}
+
+/* Neutralize disk type using generic metadata type mapping function. */
+static enum type type(struct nv *nv)
+{
+	uint8_t stripeWidth = nv->array.stripeWidth;
+
+	/*
+	 * FIXME: is there a direct way to decide what
+	 * 	  a spare is (eg, NV_LEVEL_UNKNOWN) ?
+	 */
+	switch(NV_RAIDLEVEL(nv)) {
+	case NV_LEVEL_1_0:
+	case NV_LEVEL_10:
+	case NV_LEVEL_1:
+		stripeWidth *= 2;
+		break;
+
+	case NV_LEVEL_5_SYM:
+		stripeWidth += 1;
+		break;
+		
+			default:
+		break;
+	}
+
+	if (nv->array.totalVolumes >= stripeWidth &&
+	    nv->unitNumber         >= stripeWidth)
+		return t_spare;
+
+	return rd_type(types, (unsigned int) NV_RAIDLEVEL(nv));
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD(new), nv))->unitNumber <
+	       (META(RD(pos), nv))->unitNumber;
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return _subset((META(RD_RS(RS(new)), nv))) <
+	       _subset((META(RD_RS(RS(pos)), nv)));
+}
+
+/*
+ * Read a Template RAID device
+ */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct nv *nv = meta;
+	unsigned int i = NV_SIGNATURES;
+	struct nv_array_base *array = &nv->array;
+
+	CVT32(nv->size);
+	CVT32(nv->chksum);
+	CVT16(nv->version);
+	CVT32(nv->capacity);
+	CVT32(nv->sectorSize);
+	CVT32(nv->unitFlags);
+	CVT32(array->version);
+
+	while (i--);
+		CVT32(array->signature[i]);
+
+	CVT32(array->raidLevel);
+	CVT32(array->stripeBlockSize);
+	CVT32(array->stripeBlockByteSize);
+	CVT32(array->stripeBlockPower);
+	CVT32(array->stripeMask);
+	CVT32(array->stripeSize);
+	CVT32(array->stripeByteSize);
+	CVT32(array->raidJobMark);
+	CVT32(array->originalLevel);
+	CVT32(array->originalCapacity);
+	CVT32(array->flags);
+}
+#endif
+
+/* Check the metadata checksum. */
+static int checksum(struct nv *nv)
+{
+	uint32_t sum = 0;
+	unsigned int s = nv->size;
+
+	if (s != sizeof(*nv) / sizeof(sum))
+		return 0;
+
+	while (s--) 
+		sum += ((uint32_t*) nv)[s];
+
+	/* Ignore chksum member itself. */
+	return nv->chksum - sum == nv->chksum;
+}
+
+static int is_nv(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct nv *nv = meta;
+
+	if (strncmp((char*) nv->vendor, NV_ID_STRING, sizeof(NV_ID_STRING) - 1))
+		return 0;
+
+	if (checksum(nv))
+		return 1;
+
+	LOG_ERR(lc, 0, "%s: bad checksum on %s", handler, di->path);
+}
+	
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *nv_read(struct lib_context *lc, struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct nv), NV_CONFIGOFFSET,
+			     to_cpu, is_nv, NULL, setup_rd, handler);
+}
+
+/* Write private RAID metadata to device */
+static int nv_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct nv *nv = META(rd, nv);
+
+	to_disk(nv);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(nv);
+#endif
+	return ret;
+}
+
+static void super_created(struct raid_set *ss, void *private)
+{
+	ss->type   = t_raid1;
+	ss->stride = META(private, nv)->array.stripeBlockSize;
+}
+
+/* FIXME: handle spares in mirrors and check that types are correct. */
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct nv *nv = META(rd, nv);
+
+	if (!init_raid_set(lc, rs, rd, nv->array.stripeBlockSize,
+			   NV_RAIDLEVEL(nv), handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	switch (NV_RAIDLEVEL(nv)) {
+	case NV_LEVEL_JBOD:
+	case NV_LEVEL_0:
+	case NV_LEVEL_1:
+	case NV_LEVEL_5_SYM:
+		if (!find_set(lc, NULL, rs->name, FIND_TOP))
+			list_add_tail(&rs->list, LC_RS(lc));
+
+		break;
+
+	case NV_LEVEL_1_0:
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Add an NVidia RAID device to a set. */
+static struct raid_set *nv_group(struct lib_context *lc,
+				       struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	/* Spares are grouped with sets. */
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+/*
+ * Check integrity of an NVidia RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	struct nv *nv = META(rd, nv);
+
+	return nv->array.totalVolumes / (NVRAID_1_0(nv) ? 2 : 1);
+}
+
+static int nv_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL,
+			      NO_CHECK_RD, NULL, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct nv *nv = META(rd, nv);
+
+	/* Avoid write trashing. */
+	if (status(nv) & s_broken)
+		return 0;
+
+	NV_SET_BROKEN(nv);
+	log_err(lc, "%s: signature recalculation missing!", handler);
+
+	return 1;
+}
+
+static struct event_handlers nv_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about the RAID device.
+ */
+static void nv_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	unsigned int i, j;
+#define	LEN	NV_PRODUCTIDS + 1
+	char buffer[LEN];
+	struct nv *nv = META(rd, nv);
+	struct nv_array_base *a = &nv->array;
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	P("%*s", nv, nv->vendor, NV_ID_LENGTH, nv->vendor);
+	DP("size: %u", nv, nv->size);
+	DP("chksum: %u", nv, nv->chksum);
+	DP("version: %u", nv, nv->version);
+	DP("unitNumber: %u", nv, nv->unitNumber);
+	DP("reserved: %u", nv, nv->reserved);
+	DP("capacity: %u", nv, nv->capacity);
+	DP("sectorSize: %u", nv, nv->sectorSize);
+
+	for (i = 0; i < NV_PRODUCTIDS; i++)
+		buffer[i] = nv->productID[i];
+
+	buffer[i] = '\0';
+	P("productID: %s", nv, nv->productID, buffer);
+
+	for (i = j = 0; i < NV_PRODUCTREVISIONS; i++) {
+		if (nv->productRevision[i])
+			buffer[j++] = nv->productRevision[i];
+	}
+
+	buffer[j] = '\0';
+	P("productRevision: %s", nv, nv->productRevision, buffer);
+	DP("unitFlags: %u", nv, nv->unitFlags);
+	DP("array->version: %u", nv, a->version);
+
+	for (i = 0; i < NV_SIGNATURES; i++)
+		P("array->signature[%d]: %u",
+		  nv, a->signature[i], i, a->signature[i]);
+
+	DP("array->raidJobCode: %u", nv, a->raidJobCode);
+	DP("array->stripeWidth: %u", nv, a->stripeWidth);
+	DP("array->totalVolumes: %u", nv, a->totalVolumes);
+	DP("array->originalWidth: %u", nv, a->originalWidth);
+	DP("array->raidLevel: %u", nv, a->raidLevel);
+	DP("array->stripeBlockSize: %u", nv, a->stripeBlockSize);
+	DP("array->stripeBlockByteSize: %u", nv, a->stripeBlockByteSize);
+	DP("array->stripeBlockPower: %u", nv, a->stripeBlockPower);
+	DP("array->stripeMask: %u", nv, a->stripeMask);
+	DP("array->stripeSize: %u", nv, a->stripeSize);
+	DP("array->stripeByteSize: %u", nv, a->stripeByteSize);
+	DP("array->raidJobMark %u", nv, a->raidJobMark);
+	DP("array->originalLevel %u", nv, a->originalLevel);
+	DP("array->originalCapacity %u", nv, a->originalCapacity);
+	DP("array->flags 0x%x", nv, a->flags);
+}
+#endif
+
+static struct dmraid_format nv_format = {
+	.name	= HANDLER,
+	.descr	= "NVidia RAID",
+	.caps	= "S,0,1,10,5",
+	.format = FMT_RAID,
+	.read	= nv_read,
+	.write	= nv_write,
+	.group	= nv_group,
+	.check	= nv_check,
+	.events	= &nv_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= nv_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_nv(struct lib_context *lc)
+{
+	return register_format_handler(lc, &nv_format);
+}
+
+/* Set the RAID device contents up derived from the NV ones */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct nv *nv = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = NV_CONFIGOFFSET >> 9;
+	rd->meta_areas->size = sizeof(*nv);
+	rd->meta_areas->area = (void*) nv;
+
+        rd->di = di;
+	rd->fmt = &nv_format;
+
+	rd->status = status(nv);
+	rd->type   = type(nv);
+
+	rd->offset = NV_DATAOFFSET;
+	rd->sectors = rd->meta_areas->offset;
+
+        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/nv.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/nv.h
+++ -	2008-02-22 16:57:42.118627000 +0000
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2004,2005  NVidia Corporation. All rights reserved.
+ *
+ * dmraid extensions:
+ * Copyright (C) 2004,2005 Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * (for example /usr/src/linux/COPYING); if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef	_NV_H_
+#define	_NV_H_
+
+#ifdef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+#define	NV_CONFIGOFFSET		((di->sectors - 2) << 9)
+#define	NV_DATAOFFSET		0
+
+#define NV_ID_LENGTH		8
+#define NV_ID_STRING		"NVIDIA"
+#define NV_VERSION		100 
+#define NV_SECTOR_SIZE		512
+#define NV_PRODUCT_ID_LEN	16 /* Product ID size in bytes */
+
+typedef uint32_t lba_t;
+
+/* Array info */
+struct nv_array_base {
+	uint32_t version;	/* Version of this struct               */
+				/* 0x640000 + sizeof(nv_array_base) */
+#define NV_SIGNATURES	4
+	uint32_t signature[NV_SIGNATURES]; /* Unique signature for array */
+
+	uint8_t  raidJobCode;	/* State of array */ 
+#define NV_IDLE			0
+#define NV_SCDB_INIT_RAID	2
+#define NV_SCDB_REBUILD_RAID	3
+#define NV_SCDB_UPGRADE_RAID	4
+#define NV_SCDB_SYNC_RAID	5
+
+	uint8_t  stripeWidth;	/* Array stripe width */
+	uint8_t  totalVolumes;	/* Total # of disks in array, including spare */
+	uint8_t  originalWidth;	/* Stripe width before morph */
+
+	uint32_t raidLevel;	/* Array RAID level */
+#define	NV_RAIDLEVEL(nv)	((nv)->array.raidLevel)
+#define NV_LEVEL_UNKNOWN		0x00
+#define NV_LEVEL_JBOD			0xFF
+#define NV_LEVEL_0			0x80
+#define NV_LEVEL_1			0x81
+#define NV_LEVEL_3			0x83
+#define NV_LEVEL_5			0x85
+#define NV_LEVEL_10			0x8a
+#define NV_LEVEL_1_0			0x8180
+#define NVRAID_1_0(nv)	(NV_RAIDLEVEL((nv)) == NV_LEVEL_1_0)
+#define NV_LEVEL_5_SYM_FLAG		0x10
+#define NV_LEVEL_5_SYM		(NV_LEVEL_5|NV_LEVEL_5_SYM_FLAG)
+
+	lba_t    stripeBlockSize;	/* Array stripe block size in sectors */
+	uint32_t stripeBlockByteSize;	/* stripeBlockSize in bytes */
+	uint32_t stripeBlockPower;	/* Array stripe block size in log2 */
+	lba_t    stripeMask;	/* stripeBlockSize - 1 */
+	lba_t    stripeSize;	/* stripeBlockSize * stripeWidth */
+	uint32_t stripeByteSize;	/* stripeSize in bytes */
+	lba_t    raidJobMark;	/* Ignored if array is idle, otherwise the */
+                           	/* LBA where job is finished               */
+	uint32_t originalLevel;	/* RAID level before morph */
+	lba_t    originalCapacity;	/* Array capacity before morph */
+
+	uint32_t flags;		/* Flags for array */
+#define NV_ARRAY_FLAG_BOOT		(0x00000001) /* BIOS use only */
+#define NV_ARRAY_FLAG_ERROR		(0x00000002) /* Degraded or offling */
+#define NV_ARRAY_FLAG_PARITY_VALID	(0x00000004) /* RAID-3/5 parity valid */
+#define	NV_BROKEN(n)		(n->array.flags & NV_ARRAY_FLAG_ERROR)
+#define	NV_SET_BROKEN(n)	(n->array.flags |= NV_ARRAY_FLAG_ERROR)
+} __attribute__ ((packed));
+
+/* Ondisk metadata */
+struct nv {
+	uint8_t  vendor[NV_ID_LENGTH]; /* 0x00 - 0x07 ID string */
+	uint32_t size;		/* 0x08 - 0x0B Size of metadata in dwords */
+	uint32_t chksum;	/* 0x0C - 0x0F Checksum of this struct */
+	uint16_t version;	/* 0x10 - 0x11 NV version */
+	uint8_t  unitNumber;	/* 0x12 Disk index in array */
+	uint8_t  reserved;	/* 0x13 */
+	lba_t    capacity;	/* 0x14 - 0x17 Array capacity in sectors */ 
+	uint32_t sectorSize;	/* 0x18 - 0x1B Sector size */
+#define	NV_PRODUCTIDS	16
+				/* 0x1C - 0x2B Array product ID */
+	uint8_t  productID[NV_PRODUCTIDS];
+				/*             Match INQUIRY data */
+#define	NV_PRODUCTREVISIONS	4
+				/* 0x2C - 0x2F Array product revision */
+	uint8_t  productRevision[NV_PRODUCTREVISIONS];
+				/*             Match INQUIRY data */
+	uint32_t unitFlags;	/* 0x30 - 0x33 Flags for this disk */
+	struct nv_array_base array;      /* Array information */
+} __attribute__ ((packed));
+#endif
+
+/* Prototype of the register function for this metadata format handler */
+int register_nv(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/pdc.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/pdc.c
+++ -	2008-02-22 16:57:42.201893000 +0000
@@ -0,0 +1,478 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Promise FastTrak ATARAID metadata format handler.
+ *
+ * pdc_read() and pdc_group() profited from
+ * Carl-Daniel Hailfinger's raiddetect code.
+ */
+#define	HANDLER	"pdc"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "pdc.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/*
+ * Make up Promise RAID device name.
+ */
+static unsigned int set_number(struct pdc *pdc)
+{
+	return pdc->raid.disk_number >= (pdc->raid.total_disks / 2);
+}
+
+static size_t _name(struct pdc *pdc, char *str, size_t len, int subset)
+{
+	return snprintf(str, len, subset ? "pdc_%u-%u" : "pdc_%u",
+			pdc->raid.magic_1, set_number(pdc));
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	struct pdc *pdc = META(rd, pdc);
+	size_t len;
+	char *ret = NULL;
+
+	if ((ret = dbg_malloc((len = _name(pdc, ret, 0, subset) + 1)))) {
+		_name(pdc, ret, len, subset);
+		mk_alpha(lc, ret + HANDLER_LEN,
+			 len - HANDLER_LEN - (subset ? 2 : 0));
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/*
+ * Retrieve status of device.
+ *
+ * FIXME: need to identify state definitions.
+ */
+static enum status status(struct pdc *pdc)
+{
+	return PDC_BROKEN(pdc) ? s_broken : s_ok;
+}
+
+/*
+ * Mapping of Promise types to generic types.
+ */
+#define	PDC_T_RAID10	0x2	/* Not defind by Promise (yet). */
+static struct types types[] = {
+        { PDC_T_SPAN,   t_linear},
+        { PDC_T_RAID0,  t_raid0},
+        { PDC_T_RAID1,  t_raid1},
+        { PDC_T_RAID10, t_raid0},
+        { 0, t_undef}
+};
+
+static int is_raid10(struct pdc *pdc)
+{
+	return pdc->raid.type == PDC_T_RAID10 ||
+	       (pdc->raid.type == PDC_T_RAID1 && pdc->raid.total_disks > 3);
+}
+
+/* Neutralize disk type */
+static enum type type(struct pdc *pdc)
+{
+	if (is_raid10(pdc))
+		pdc->raid.type = PDC_T_RAID10;
+
+	return rd_type(types, (unsigned int) pdc->raid.type);
+}
+
+/* Calculate checksum on Promise metadata. */
+static uint32_t checksum(struct pdc *pdc)
+{
+	unsigned int i = 511, sum = 0;
+	uint32_t *p = (uint32_t*) pdc;
+
+	while (i--)
+		sum += *p++;
+
+	return sum == pdc->checksum;
+}
+
+/* Calculate metadata offset. */
+/*
+ * Read a Promise FastTrak RAID device
+ */
+/* Endianess conversion. */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct pdc *pdc = meta;
+	struct pdc_disk *disk;
+
+	CVT32(pdc->magic_0);
+	CVT32(pdc->magic_1);
+	CVT32(pdc->raid.flags);
+	CVT32(pdc->raid.magic_0);
+	CVT32(pdc->raid.disk_secs);
+	CVT32(pdc->raid.total_secs);
+	CVT16(pdc->raid.cylinders);
+	CVT32(pdc->raid.magic_1);
+
+	for (disk = pdc->raid.disk;
+	     disk < pdc->raid.disk + pdc->raid.total_disks;
+	     disk++) {
+		CVT32(disk->magic_0);
+		CVT32(disk->disk_number);
+	}
+}
+#endif
+
+/* Read and try to discover Promise signature. */
+static void *pdc_read_metadata(struct lib_context *lc, struct dev_info *di,
+			       size_t *size, uint64_t *offset,
+			       union read_info *info)
+{
+	/* Assume certain sectors off the end of the RAID device. */
+	static unsigned int *s, sectors[] = {
+		PDC_CONFIGOFFSETS, 0,
+	};
+	struct pdc *ret;
+
+	if ((ret = alloc_private(lc, handler, sizeof(*ret)))) {
+		for (s = sectors; *s; s++) {
+			if (read_file(lc, handler, di->path, ret, sizeof(*ret),
+				      (di->sectors - *s) << 9) &&
+			    !strncmp((const char*) ret->promise_id, PDC_MAGIC,
+				     PDC_ID_LENGTH)) {
+				info->u32 = *s;
+				return (void*) ret;
+			}
+		}
+
+		dbg_free(ret);
+	}
+
+	return NULL;
+}
+
+/* Magic check. */
+static int is_pdc(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct pdc *pdc = meta;
+
+	/*
+	 * No we've got the PDC magic string veryfied, we can
+	 * check that the rest of the metadata is valid.
+	 */
+	if (pdc->magic_0 == pdc->raid.magic_0 &&
+	    pdc->raid.total_disks &&
+	    pdc->raid.total_disks < PDC_MAXDISKS)
+		return 1;
+
+
+	LOG_ERR(lc, 0, "%s: identifying %s, magic_0: 0x%x/0x%x, "
+		"magic_1: 0x%x/0x%x, total_disks: %u",
+		handler, di->path,
+		pdc->magic_0, pdc->raid.magic_0,
+		pdc->magic_1, pdc->raid.magic_1, pdc->raid.total_disks);
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *pdc_read(struct lib_context *lc, struct dev_info *di)
+{ 
+	return read_raid_dev(lc, di, pdc_read_metadata, 0, 0, to_cpu, is_pdc,
+			     NULL, setup_rd, handler);
+}
+
+/*
+ * Write a Promise FastTrak RAID device.
+ */
+static int pdc_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct pdc *pdc = META(rd, pdc);
+
+	to_disk(pdc);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(pdc);
+#endif
+	return ret;
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD(new), pdc))->raid.disk_number <
+	       (META(RD(pos), pdc))->raid.disk_number;
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return !set_number(META(RD_RS(RS(new)), pdc));
+}
+
+/*
+ * Group the RAID disk into a Promise set.
+ */
+static unsigned int stride(struct pdc *pdc)
+{
+	return pdc->raid.raid0_shift ? 1 << pdc->raid.raid0_shift : 0;
+}
+
+static void super_created(struct raid_set *super, void *private)
+{
+	super->type   = t_raid1;
+	super->stride = stride(META((private), pdc));
+}
+
+/* Add a PDC RAID device to a set. */
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct pdc *pdc = META(rd, pdc);
+
+	if (!init_raid_set(lc, rs, rd, stride(pdc), pdc->raid.type, handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	switch (pdc->raid.type) {
+	case PDC_T_SPAN:
+	case PDC_T_RAID0:
+	case PDC_T_RAID1:
+		if (!find_set(lc, NULL, rs->name, FIND_TOP))
+			list_add_tail(&rs->list, LC_RS(lc));
+
+		break;
+
+	case PDC_T_RAID10:
+		/*
+		 * RAID10:
+		 *
+		 * We've got a striped raid set with a mirror on top
+		 * when we get here.
+		 * Let's find and optionally allocate the mirror set on top.
+		 */
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+static struct raid_set *pdc_group(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	if (T_SPARE(rd))
+		return NULL;
+
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+/*
+ * Check a PDC RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	struct pdc *pdc = META(rd, pdc);
+
+	if (context && pdc->raid.type != PDC_T_SPAN)
+		*((uint64_t*) context) += rd->sectors;
+
+	return pdc->raid.total_disks;
+}
+
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context)
+{
+      return *((uint64_t*) context) >= (META(rd, pdc))->raid.total_secs;
+}
+
+static int pdc_check(struct lib_context *lc, struct raid_set *rs)
+{
+	uint64_t total_secs = 0;
+
+	/*
+	 * Calculate total_secs in 1st check_raid_set() run and
+	 * check the device sizes against that in the 2nd run.
+	 */
+	return check_raid_set(lc, rs, devices, &total_secs,
+			      NO_CHECK_RD, NULL, handler) &&
+	       check_raid_set(lc, rs, devices, NULL,
+			      check_rd, &total_secs, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct pdc *pdc = META(rd, pdc);
+
+	/* Avoid write trashing. */
+	if (status(pdc) & s_broken)
+		return 0;
+
+	PDC_SET_BROKEN(pdc);
+
+	return 1;
+}
+
+static struct event_handlers pdc_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/* Log native information about a Promise RAID device. */
+static void pdc_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	unsigned int i;
+	struct pdc *pdc = META(rd, pdc);
+	struct pdc_disk *disk;
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	DP("promise_id: \"%s\"", pdc, pdc->promise_id);
+	DP("unknown_0: 0x%x", pdc, pdc->unknown_0);
+	DP("magic_0: 0x%x", pdc, pdc->magic_0);
+	DP("unknown_1: 0x%x", pdc, pdc->unknown_1);
+	DP("magic_1: 0x%x", pdc, pdc->magic_1);
+	DP("unknown_2: 0x%x", pdc, pdc->unknown_2);
+	DP("raid.flags: 0x%x", pdc, pdc->raid.flags);
+	DP("raid.unknown_0: 0x%x", pdc, pdc->raid.unknown_0);
+	DP("raid.disk_number: %u", pdc, pdc->raid.disk_number);
+	DP("raid.channel: %u", pdc, pdc->raid.channel);
+	DP("raid.device: %u", pdc, pdc->raid.device);
+	DP("raid.magic_0: 0x%x", pdc, pdc->raid.magic_0);
+	DP("raid.unknown_1: 0x%x", pdc, pdc->raid.unknown_1);
+	DP("raid.unknown_2: 0x%x", pdc, pdc->raid.unknown_2);
+	DP("raid.disk_secs: %u", pdc, pdc->raid.disk_secs);
+	DP("raid.unknown_3: 0x%x", pdc, pdc->raid.unknown_3);
+	DP("raid.unknown_4: 0x%x", pdc, pdc->raid.unknown_4);
+	DP("raid.status: 0x%x", pdc, pdc->raid.status);
+	DP("raid.type: 0x%x", pdc, pdc->raid.type);
+	DP("raid.total_disks: %u", pdc, pdc->raid.total_disks);
+	DP("raid.raid0_shift: %u", pdc, pdc->raid.raid0_shift);
+	DP("raid.raid0_disks: %u", pdc, pdc->raid.raid0_disks);
+	DP("raid.array_number: %u", pdc, pdc->raid.array_number);
+	DP("raid.total_secs: %u", pdc, pdc->raid.total_secs);
+	DP("raid.cylinders: %u", pdc, pdc->raid.cylinders);
+	DP("raid.heads: %u", pdc, pdc->raid.heads);
+	DP("raid.sectors: %u", pdc, pdc->raid.sectors);
+	DP("raid.magic_1: 0x%x", pdc, pdc->raid.magic_1);
+	DP("raid.unknown_5: 0x%x", pdc, pdc->raid.unknown_5);
+
+	for (disk = pdc->raid.disk, i = 0;
+	     i < pdc->raid.total_disks;
+	     disk++, i++) {
+		P2("raid.disk[%d].unknown_0: 0x%x", pdc, i, disk->unknown_0);
+		P2("raid.disk[%d].channel: %u", pdc, i, disk->channel);
+		P2("raid.disk[%d].device: %u", pdc, i, disk->device);
+		P2("raid.disk[%d].magic_0: 0x%x", pdc, i, disk->magic_0);
+		P2("raid.disk[%d].disk_number: %u", pdc, i, disk->disk_number);
+	}
+
+	P("checksum: 0x%x %s", pdc, pdc->checksum, pdc->checksum,
+	   checksum(pdc) ? "Ok" : "BAD");
+}
+#endif
+
+static struct dmraid_format pdc_format = {
+	.name	= HANDLER,
+	.descr	= "Promise FastTrack",
+	.caps	= "S,0,1,10",
+	.format = FMT_RAID,
+	.read	= pdc_read,
+	.write	= pdc_write,
+	.group	= pdc_group,
+	.check	= pdc_check,
+	.events	= &pdc_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= pdc_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_pdc(struct lib_context *lc)
+{
+	return register_format_handler(lc, &pdc_format);
+}
+
+/* Calculate RAID device size in sectors depending on RAID type. */
+static uint64_t sectors(struct raid_dev *rd, unsigned int meta_sector)
+{
+	struct pdc *pdc = META(rd, pdc);
+
+	switch (pdc->raid.type) {
+	case PDC_T_RAID10:
+               return pdc->raid.total_secs / (pdc->raid.total_disks / 2);
+
+	case PDC_T_RAID1:
+               return pdc->raid.total_secs;
+
+	case PDC_T_RAID0:
+               return pdc->raid.total_secs / pdc->raid.total_disks;
+
+	case PDC_T_SPAN:
+	       return rd->di->sectors - meta_sector;
+	}
+
+	return 0;
+}
+
+/* Set the RAID device contents up derived from the PDC ones */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	unsigned int meta_sector;
+	struct pdc *pdc = meta;
+
+	if (!checksum(pdc))
+		LOG_ERR(lc, 0, "%s: invalid checksum on %s", handler, di->path);
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	meta_sector = info->u32;
+	rd->meta_areas->offset = di->sectors - meta_sector;
+	rd->meta_areas->size = sizeof(*pdc);
+	rd->meta_areas->area = (void*) pdc;
+
+        rd->di = di;
+	rd->fmt = &pdc_format;
+
+	rd->status = status(pdc);
+	/*
+	 * Type needs to be set before sectors(), because we need
+	 * to set the RAID10 type used there!
+	 */
+	rd->type   = type(pdc);
+
+	rd->offset = PDC_DATAOFFSET;
+	if (!(rd->sectors = sectors(rd, meta_sector)))
+		return log_zero_sectors(lc, di->path, handler);
+
+        return (rd->name = name(lc, rd, is_raid10(pdc))) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/pdc.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/pdc.h
+++ -	2008-02-22 16:57:42.284835000 +0000
@@ -0,0 +1,81 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_PDC_H_
+#define	_PDC_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+#define PDC_CONFIGOFFSETS	63,255,256,16,399,735
+#define	PDC_DATAOFFSET 0
+
+/* Ondisk metadata for Promise Fastrack */
+struct pdc {
+#define PDC_ID_LENGTH	24
+	uint8_t promise_id[PDC_ID_LENGTH];	/* 0x00 - 0x17 */
+#define PDC_MAGIC        "Promise Technology, Inc."
+
+	uint32_t unknown_0;			/* 0x18 - 0x1B */
+	uint32_t magic_0;			/* 0x1C - 0x1F */
+	uint32_t unknown_1;			/* 0x20 - 0x23 */
+	uint32_t magic_1;			/* 0x24 - 0x27 */
+	uint16_t unknown_2;			/* 0x28 - 0x2B */
+	uint8_t filler1[470];			/* 0x2C - 0x1FF */
+	struct {
+		uint32_t flags;			/* 0x200 - 0x203 */
+		uint8_t unknown_0;		/* 0x204 */
+		uint8_t disk_number;		/* 0x205 */
+		uint8_t channel;		/* 0x206 */
+		uint8_t device;			/* 0x207 */
+		uint32_t magic_0;		/* 0x208 - 0x20B */
+		uint32_t unknown_1;		/* 0x20C - 0x20F */
+		uint32_t unknown_2;		/* 0x210 - 0x213 */
+		uint32_t disk_secs;		/* 0x214 - 0x217 */
+		uint32_t unknown_3;		/* 0x218 - 0x21B */
+		uint16_t unknown_4;		/* 0x21C - 0x21D */
+		uint8_t status;			/* 0x21E */
+/* FIXME: bit 0x80 doesn't seem to indicate error as previously assumed. */
+// #define	PDC_BROKEN(pdc)		((pdc)->raid.status &  0x80)
+#define	PDC_BROKEN(pdc)		((pdc)->raid.status &  0x00)
+#define	PDC_SET_BROKEN(pdc)	((pdc)->raid.status |= 0x80)
+		uint8_t type;			/* 0x21F */
+#define	PDC_T_RAID0	0x0
+#define	PDC_T_RAID1	0x1
+#define	PDC_T_SPAN	0x8
+		uint8_t total_disks;		/* 0x220 */
+		uint8_t raid0_shift;		/* 0x221 */
+		uint8_t raid0_disks;		/* 0x222 */
+		uint8_t array_number;		/* 0x223 */
+		uint32_t total_secs;		/* 0x224 - 0x227 */
+		uint16_t cylinders;		/* 0x228 - 0x229 */
+		uint8_t heads;			/* 0x22A */
+		uint8_t sectors;		/* 0x22B */
+		uint32_t magic_1;		/* 0x22C - 0x2EF */
+		uint32_t unknown_5;		/* 0x230 - 0x233 */
+		struct pdc_disk {
+			uint16_t unknown_0;	/* 0x234 - 0x235 */
+			uint8_t channel;	/* 0x236 */
+			uint8_t device;		/* 0x237 */
+			uint32_t magic_0;	/* 0x238 - 0x23B */
+			uint32_t disk_number;	/* 0x23C - 0x23F */
+		} disk[8];
+	} raid;
+
+	uint32_t filler2[346];			/* 0x294 - */
+	uint32_t checksum;
+} __attribute__ ((packed));
+
+#define	PDC_MAXDISKS	8
+
+#endif
+
+int register_pdc(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/sil.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/sil.c
+++ -	2008-02-22 16:57:42.375226000 +0000
@@ -0,0 +1,602 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Silicon Image Medley ATARAID metadata format handler.
+ */
+#define	HANDLER	"sil"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "sil.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/* Make up RAID device name from some 'magic' numbers */
+/* FIXME: better name ? */
+static size_t _name(struct sil *sil, char *str, size_t len, unsigned int subset)
+{
+	return snprintf(str, len,
+			subset ? "sil_%02u%02u%02u%02u%02u%02u-%u" :
+				 "sil_%02u%02u%02u%02u%02u%02u",
+			sil->year, sil->month, sil->day,
+			sil->hour, sil->minutes % 60, sil->seconds % 60,
+			sil->type == SIL_T_RAID1 ? sil->mirrored_set_number :
+						   sil->striped_set_number);
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	char *ret;
+	struct sil *sil = META(rd, sil);
+
+	subset = subset && sil->type == SIL_T_RAID10;
+	if ((ret = dbg_malloc((len = _name(sil, NULL, 0, subset) + 1)))) {
+		_name(sil, ret, len, subset);
+		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
+			 (strrchr(ret, '-') ? 3 : 1));
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/*
+ * Retrieve status of device.
+ * FIXME: is this sufficient to cover all state ?
+ */
+static enum status status(struct sil *sil)
+{
+	switch (sil->mirrored_set_state) {
+	case SIL_OK:
+	case SIL_MIRROR_SYNC:
+		return s_ok;
+
+	case SIL_MIRROR_NOSYNC:
+		return s_nosync;
+	}
+
+	return s_broken;
+}
+
+/* Mapping of SIL 680 types to generic types */
+static struct types types[] = {
+        { SIL_T_SPARE,  t_spare},
+        { SIL_T_RAID0,  t_raid0},
+        { SIL_T_RAID5, 	t_raid5_ls},
+        { SIL_T_RAID1,  t_raid1},
+        { SIL_T_RAID10, t_raid0},
+        { 0,            t_undef}
+};
+
+/* Neutralize disk type */
+static enum type type(struct sil *sil)
+{
+	return rd_type(types, (unsigned int) sil->type);
+}
+
+/* Calculate checksum on metadata */
+static int checksum(struct sil *sil)
+{
+	int sum = 0;
+	unsigned int count = struct_offset(sil, checksum1) / 2;
+	uint16_t *p = (uint16_t*) sil;
+
+        while (count--)
+		sum += *p++;
+
+	return (-sum & 0xFFFF) == sil->checksum1;
+}
+
+/*
+ * Read a Silicon Image RAID device
+ */
+/* Endianess conversion. */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct sil *sil = meta;
+
+	CVT32(sil->magic);
+	CVT32(sil->array_sectors_low);
+	CVT32(sil->array_sectors_high);
+	CVT32(sil->thisdisk_sectors);
+	CVT16(sil->product_id);
+	CVT16(sil->vendor_id);
+	CVT16(sil->minor_ver);
+	CVT16(sil->major_ver);
+	CVT16(sil->raid0_stride);
+	CVT32(sil->rebuild_ptr_low);
+	CVT32(sil->rebuild_ptr_high);
+	CVT32(sil->incarnation_no);
+	CVT16(sil->checksum1);
+	CVT16(sil->checksum2);
+}
+#endif
+
+#define	AREAS	4
+#define SIL_META_AREA(i)	(SIL_CONFIGOFFSET - (i * 512 << 9))
+
+static inline int is_sil(struct sil *sil)
+{
+	return SIL_MAGIC_OK(sil) && sil->disk_number < 8;
+}
+
+static int sil_valid(struct lib_context *lc, struct dev_info *di,
+		     void *meta, unsigned int area)
+{
+	struct sil *sil = meta;
+
+	if (!is_sil(sil))
+		return 0;
+
+	if (sil->major_ver != 2)
+		log_warn(lc, "%s: major version %u in area %u; format handler "
+			 "tested on version 2 only",
+			 handler, sil->major_ver, area);
+
+	if (!checksum(sil))
+		LOG_ERR(lc, 0, "%s: invalid metadata checksum in area %u on %s",
+			handler, area, di->path);
+
+	if (di->sectors < sil->thisdisk_sectors)
+		LOG_ERR(lc, 0,
+			"%s: invalid disk size in metadata area %u on %s",
+			handler, area, di->path);
+
+	return 1;
+}
+
+static void free_sils(struct sil **sils, unsigned int i)
+{
+	for (; i < AREAS; i++)
+		dbg_free(sils[i]);
+
+	dbg_free(sils);
+}
+
+static void *sil_read_metadata(struct lib_context *lc, struct dev_info *di,
+			       size_t *size, uint64_t *offset,
+			       union read_info *info)
+{
+	unsigned int i, valid;
+	char str[9] = { 0, };
+	struct sil *sil, **sils;
+
+	if (!(sils = dbg_malloc(AREAS * sizeof(*sils))))
+		goto out;
+
+	memset(sils, 0, AREAS * sizeof(*sils));
+
+	/* Read the 4 metadata areas. */
+	for (i = valid = 0; i < AREAS; i++) {
+		if (!(sil = alloc_private_and_read(lc, handler, sizeof(*sil),
+						   di->path, SIL_META_AREA(i))))
+			goto bad;
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+		to_cpu(sil);
+#endif
+		/* Create string with list of valid areas. */
+		if (sil_valid(lc, di, sil, i + 1)) {
+			sils[valid] = sil;
+			sprintf(&str[strlen(str)], "%s%u",
+			        valid++ ? "," : "", i + 1);
+		} else
+			dbg_free(sil);
+	}
+
+	if (valid) {
+		log_notice(lc, "%s: area%s %s[%u] %s valid",
+			   handler, valid ? "s" : "", str, AREAS,
+			   valid == 1 ? "is" : "are");
+		goto out;
+	}
+	
+   bad:
+	free_sils(sils, 0);
+	sils = NULL;
+
+   out:
+	return (void*) sils;
+}
+
+static int _file_name(char *str, size_t len, char *n, int i)
+{
+	return snprintf(str, len, "%s_%d", n, i) + 1;
+}
+
+static char *file_name(struct lib_context *lc, char *n, int i)
+{
+	size_t len;
+	char *ret;
+
+	if ((ret = dbg_malloc((len = _file_name(NULL, 0, n, i)))))
+		_file_name(ret, len, n, i);
+	else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/* File all metadata areas. */
+static void sil_file_metadata(struct lib_context *lc, struct dev_info *di,
+			      void *meta)
+{
+	unsigned int i;
+	char *n;
+	struct sil **sils = meta;
+	
+	for (i = 0; i < AREAS; i++) {
+		if (!(n = file_name(lc, di->path, i)))
+			break;
+
+		file_metadata(lc, handler, n, sils[i],
+			      sizeof(**sils), SIL_META_AREA(i));
+		dbg_free(n);
+	}
+
+	file_dev_size(lc, handler, di);
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *sil_read(struct lib_context *lc, struct dev_info *di)
+{
+	return read_raid_dev(lc, di, sil_read_metadata, 0, 0, NULL, NULL,
+			     sil_file_metadata, setup_rd, handler);
+
+}
+
+/*
+ * Write a Silicon Image RAID device.
+ */
+static int sil_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct sil *sil = META(rd, sil);
+
+	to_disk(sil);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(sil);
+#endif
+	return ret;
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD(new), sil))->disk_number <
+	       (META(RD(pos), sil))->disk_number;
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD_RS(RS(new)), sil))->mirrored_set_number <
+	       (META(RD_RS(RS(pos)), sil))->mirrored_set_number;
+}
+
+/*
+ * Group the RAID disk into a SIL set.
+ *
+ * Check device hierarchy and create super set appropriately.
+ */
+static void super_created(struct raid_set *ss, void *private)
+{
+	ss->type   = t_raid1;
+	ss->stride = META(private, sil)->raid0_stride;
+}
+
+/* FIXME: handle spares. */
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct sil *sil = META(rd, sil);
+
+	if (!init_raid_set(lc, rs, rd, sil->raid0_stride, sil->type, handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	switch (sil->type) {
+	case SIL_T_RAID0:
+	case SIL_T_RAID1:
+	case SIL_T_RAID5:
+		if (!(find_set(lc, NULL, rs->name, FIND_TOP)))
+			list_add_tail(&rs->list, LC_RS(lc));
+
+		break;
+
+	case SIL_T_RAID10:
+		/*
+		 * We've got a striped raid set with a mirror set on top
+		 * when we get here.
+		 * Let's find and optionally allocate the mirror set.
+		 */
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Add a SIL RAID device to a set */
+static struct raid_set *sil_group(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	if (T_SPARE(rd))
+		return NULL;
+
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+/*
+ * Check a SIL RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	int ret;
+	struct sil *sil = META(rd, sil);
+
+	switch (sil->type) {
+	case SIL_T_RAID0:
+	case SIL_T_RAID10:
+		ret = sil->drives_per_striped_set;
+		break;
+
+	case SIL_T_RAID1:
+		ret = sil->drives_per_mirrored_set;
+		break;
+
+	default:
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int sil_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL,
+			      NO_CHECK_RD, NULL, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct sil *sil = META(rd, sil);
+
+	/* Avoid write trashing. */
+	if (status(sil) & s_broken)
+		return 0;
+
+	sil->member_status = 0;
+
+	return 1;
+}
+
+static struct event_handlers sil_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about a Silicon Image  RAID device.
+ */
+static void sil_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	char *tt;
+	struct sil *sil = META(rd, sil);
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	DP("unknown0: \"%42s\"", sil, sil->unknown0);
+	DP("ascii_version: \"%8s\"", sil, sil->ascii_version);
+	DP("diskname: \"%32s\"", sil, sil->diskname);
+	DP("unknown1: \"%22s\"", sil, sil->unknown1);
+	DP("magic: 0x%x", sil, sil->magic);
+	DP("unknown1a: \"%8s\"", sil, sil->unknown1a);
+	DP("array_sectors_low: %u", sil, sil->array_sectors_low);
+	DP("array_sectors_high: %u", sil, sil->array_sectors_high);
+	DP("unknown2: \"%4s\"", sil, sil->unknown2);
+	DP("thisdisk_sectors: %u", sil, sil->thisdisk_sectors);
+	DP("product_id: %u", sil, sil->product_id);
+	DP("vendor_id: %u", sil, sil->vendor_id);
+	DP("minor_ver: %u", sil, sil->minor_ver);
+	DP("major_ver: %u", sil, sil->major_ver);
+	DP("seconds: %u", sil, sil->seconds % 60);
+	DP("seconds(full): 0x%x", sil, sil->seconds);
+	DP("minutes: %u", sil, sil->minutes % 60);
+	DP("minutes(full): 0x%x", sil, sil->minutes);
+	DP("hour: %u", sil, sil->hour);
+	DP("day: %u", sil, sil->day);
+	DP("month: %u", sil, sil->month);
+	DP("year: %u", sil, sil->year);
+	DP("raid0_stride: %u", sil, sil->raid0_stride);
+	DP("disk_number: %u", sil, sil->disk_number);
+	DP("type: %u", sil, sil->type);
+	DP("drives_per_striped_set: %d", sil, sil->drives_per_striped_set);
+	DP("striped_set_number: %d", sil, sil->striped_set_number);
+	DP("drives_per_mirrored_set: %d", sil, sil->drives_per_mirrored_set);
+	DP("mirrored_set_number: %d", sil, sil->mirrored_set_number);
+	DP("rebuild_ptr_low: %u", sil, sil->rebuild_ptr_low);
+	DP("rebuild_ptr_high: %u", sil, sil->rebuild_ptr_high);
+	DP("incarnation_no: %u", sil, sil->incarnation_no);
+	DP("member_status: %u", sil, sil->member_status);
+	DP("mirrored_set_state: %u", sil, sil->mirrored_set_state);
+	DP("reported_device_location: %u", sil, sil->reported_device_location);
+	DP("idechannel: %u", sil, sil->idechannel);
+	DP("auto_rebuild: %u", sil, sil->auto_rebuild);
+
+	if ((tt = dbg_strndup(sil->text_type, 16))) {
+		P("text_type: \"%s\"", sil, sil->text_type, tt);
+		dbg_free(tt);
+	}
+
+	DP("checksum1: %u", sil, sil->checksum1);
+	DP("checksum2: %u", sil, sil->checksum2);
+}
+#endif
+
+static struct dmraid_format sil_format = {
+	.name	= HANDLER,
+	.descr	= "Silicon Image(tm) Medley(tm)",
+	.caps	= "0,1,10",
+	.format = FMT_RAID,
+	.read	= sil_read,
+	.write	= sil_write,
+	.group	= sil_group,
+	.check	= sil_check,
+	.events	= &sil_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= sil_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_sil(struct lib_context *lc)
+{
+	return register_format_handler(lc, &sil_format);
+}
+
+/* Set the RAID device contents up derived from the SIL ones. */
+static int stripes(struct sil *sil)
+{
+	return sil->drives_per_striped_set > -1 &&
+	       sil->disk_number < sil->drives_per_striped_set;
+}
+
+static uint64_t sectors(struct raid_dev *rd)
+{
+	uint64_t array_sectors, ret = 0;
+	struct sil *sil = META(rd, sil);
+
+	array_sectors = (((uint64_t) sil->array_sectors_high) << 32) +
+			 sil->array_sectors_low;
+
+	switch (sil->type) {
+	case SIL_T_SPARE:
+		/* Cook them up... */
+		ret = rd->di->sectors - (AREAS - 1) * 512 -
+		      ((rd->di->sectors & 1) ? 1 : 2);
+		break;
+
+	case SIL_T_RAID0:
+		if (stripes(sil))
+			ret = array_sectors / sil->drives_per_striped_set;
+		break;
+
+	case SIL_T_RAID1:
+	case SIL_T_RAID10:
+		ret = array_sectors;
+		break;
+
+	default:
+		/* Cook them up... */
+		ret = rd->di->sectors - (AREAS - 1) * 512 -
+		      ((rd->di->sectors & 1) ? 1 : 2);
+		break;
+	}
+
+	return ret;
+}
+
+/* Quorate SIL metadata copies. */
+static struct sil *quorate(struct lib_context *lc, struct dev_info *di,
+			   struct sil *sils[])
+{
+	unsigned int areas = 0, i, j;
+	struct sil *sil;
+	
+	/* Count valid metadata areas. */
+	while (areas < AREAS && sils[areas++]);
+
+	if (areas == AREAS)
+		goto out;
+
+	log_err(lc, "%s: only %u/%u metadata areas found on %s, %sing...",
+		handler, areas, AREAS, di->path, areas > 1 ? "elect" : "pick");
+
+	/* Identify maximum identical copies. */
+	for (i = 0; i < areas; i++) {
+		for (j = i + 1, sil = sils[i]; j < areas; j++) {
+			if (!memcmp(sil, sils[j], sizeof(*sil)))
+				goto end;
+		}
+	}
+
+   end:
+	if (i) {
+		sil = sils[0];
+		sils[0] = sils[i];
+		sils[i] = sil;
+	}
+
+   out:
+	return sils[0];
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	unsigned int i;
+	struct meta_areas *ma;
+	struct sil *sil, **sils = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, AREAS)))
+		goto bad;
+
+	sil = quorate(lc, di, sils);	/* Quorate one copy+save a pointer.*/
+	free_sils(sils, 1);		/* Free the other copies. */
+
+	for (i = 0, ma = rd->meta_areas; i < rd->areas; i++, ma++) {
+		ma->offset = SIL_META_AREA(i) >> 9;
+		ma->size = sizeof(*sil);
+		ma->area = (void*) sil;
+	}
+
+	rd->di = di;
+	rd->fmt = &sil_format;
+
+	rd->offset = SIL_DATAOFFSET;
+	if (!(rd->sectors = sectors(rd)))
+		return log_zero_sectors(lc, di->path, handler);
+
+	rd->status = status(sil);
+	rd->type   = type(sil);
+
+        return (rd->name = name(lc, rd, sil->type == SIL_T_RAID10)) ? 1 : 0;
+
+   bad:
+	free_sils(sils, 0);
+
+	return 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/sil.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/sil.h
+++ -	2008-02-22 16:57:42.455990000 +0000
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_SIL_H_
+#define	_SIL_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+#define SIL_CONFIGOFFSET        ((di->sectors - 1) << 9)
+#define SIL_DATAOFFSET          0       /* Data offset in sectors */
+
+struct sil {
+        uint8_t	unknown0[0x2E];		/* 0x4 - 0x2D */
+        uint8_t	ascii_version[0x36 - 0x2E];/* 0x2E - 0x35 */
+	int8_t		diskname[0x56 - 0x36];	/* 0x36 - 0x55 */
+	int8_t		unknown1[0x60 - 0x56];	/* 0x56 - 0x59 */	
+	uint32_t	magic;			/* 0x60 - 0x63 */
+#define	SIL_MAGIC	0x3000000
+#define	SIL_MAGIC_OK(sil)	((sil->magic & 0x3ffffff) == SIL_MAGIC)
+	int8_t		unknown1a[0x6C - 0x64];	/* 0x64 - 0x6B */	
+	uint32_t	array_sectors_low;	/* 0x6C - 0x6F */
+	uint32_t	array_sectors_high;	/* 0x70 - 0x73 */
+	int8_t		unknown2[0x78 - 0x74];	/* 0x74 - 0x77 */
+	uint32_t	thisdisk_sectors;	/* 0x78 - 0x7B */
+	int8_t		unknown3[0x100 - 0x7C];	/* 0x7C - 0xFF */
+	int8_t		unknown4[0x104 - 0x100];/* 0x100 - 0x103 */
+	uint16_t	product_id;		/* 0x104 + 0x105 */
+	uint16_t	vendor_id;		/* 0x106 + 0x107 */
+        uint16_t	minor_ver;		/* 0x108 + 0x109 */
+        uint16_t	major_ver;		/* 0x10A + 0x10B */
+	uint8_t	seconds;		/* 0x10C */
+	uint8_t	minutes;		/* 0x10D */
+	uint8_t	hour;			/* 0x10E */
+	uint8_t	day;			/* 0x10F */
+	uint8_t	month;			/* 0x110 */
+	uint8_t	year;			/* 0x111 */
+	uint16_t	raid0_stride;		/* 0x112 + 0x113 */
+	int8_t		unknown6[0x116 - 0x114];/* 0x114 + 0x115 */
+	uint8_t	disk_number;		/* 0x116 */
+	uint8_t	type;			/* 0x117 */
+#define	SIL_T_RAID0	0
+#define	SIL_T_RAID1	1
+#define	SIL_T_RAID10	2
+#define	SIL_T_RAID5	16
+#define	SIL_T_SPARE	3
+	int8_t		drives_per_striped_set;	/* 0x118 */
+	int8_t		striped_set_number;	/* 0x119 */
+        int8_t		drives_per_mirrored_set;/* 0x11A */
+        int8_t		mirrored_set_number;	/* 0x11B */
+	uint32_t	rebuild_ptr_low;	/* 0x11C - 0x12F */
+	uint32_t	rebuild_ptr_high;	/* 0x120 - 0x123 */
+	uint32_t	incarnation_no;		/* 0x124 - 0x127 */
+        uint8_t	member_status;		/* 0x128 */
+        uint8_t	mirrored_set_state;	/* 0x129 */
+#define	SIL_OK			0
+#define	SIL_MIRROR_NOSYNC	1
+#define	SIL_MIRROR_SYNC		2
+        uint8_t	reported_device_location;/* 0x12A */
+        uint8_t	idechannel;		/* 0x12B */
+        uint8_t	auto_rebuild;		/* 0x12C */
+#define	SIL_MIRROR_NOAUTOREBUILD	0
+	uint8_t		unknown8;		/* 0x12D */
+	uint8_t		text_type[0x13E - 0x12E]; /* 0x12E - 0x13D */
+	uint16_t	checksum1;		/* 0x13E + 0x13F */	
+	int8_t		assumed_zeros[0x1FE - 0x140];/* 0x140 - 0x1FD */
+	uint16_t	checksum2;		/* 0x1FE + 0x1FF */
+} __attribute__ ((packed));
+#endif
+
+int register_sil(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/ataraid/via.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/via.c
+++ -	2008-02-22 16:57:42.538899000 +0000
@@ -0,0 +1,413 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file DISCLAIMER at the top of this source tree for license information.
+ */
+
+/*
+ * VIA metadata format handler.
+ */
+#define	HANDLER	"via"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "via.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+
+static const char *handler = HANDLER;
+
+static int _subset(struct via *via)
+{
+	return VIA_T_RAID01_MIRROR(via);
+}
+
+/* Make up VIA RAID device name suffix from the serial_checksum array. */
+static uint32_t sum_serial(struct via *via)
+{
+	unsigned int i = VIA_MAX_DISKS;
+	uint32_t ret = via->array.disk_array_ex; /* FIXME: correct ? */
+
+	while (i--)
+		ret += via->serial_checksum[i];
+
+	return ret;
+}
+
+static char *_name_suffix(struct via *via)
+{
+	size_t len;
+	uint32_t sum = sum_serial(via);
+	char *ret;
+
+	if ((ret = dbg_malloc((len = snprintf(NULL, 0, "%u", sum) + 1))))
+		snprintf(ret, len, "%u", sum);
+
+	return ret;
+}
+
+/* Make up RAID device name. */
+static size_t _name(struct lib_context *lc, struct via *via, char *str,
+		     size_t len, char *suffix, unsigned int subset)
+{
+	return snprintf(str, len,
+			subset ? "via_%s-%u" : "via_%s", suffix, _subset(via));
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	char *ret, *suffix;
+	struct via *via = META(rd, via);
+
+	if (!(suffix = _name_suffix(via)))
+		return NULL;
+
+	subset = subset && (VIA_RAID_TYPE(via) == VIA_T_RAID01);
+	if ((ret = dbg_malloc((len = _name(lc, via, NULL, 0,
+					   suffix, subset) + 1)))) {
+		_name(lc, via, ret, len, suffix, subset);
+		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN -
+			 (subset ? 3 : 1));
+	} else
+		log_alloc_err(lc, handler);
+
+	dbg_free(suffix);
+
+	return ret;
+}
+
+/*
+ * Retrieve status of device.
+ * FIXME: is this sufficient to cover all state ?
+ */
+static enum status status(struct via *via)
+{
+	if (via->array.disk.tolerance)
+		return s_broken;
+
+	return via->array.disk.in_disk_array ? s_ok : s_undef;
+}
+
+/* Mapping of via types to generic types */
+static struct types types[] = {
+	{ VIA_T_SPAN,  t_linear },
+	{ VIA_T_RAID0, t_raid0 },
+	{ VIA_T_RAID1, t_raid1 },
+	{ VIA_T_RAID01, t_raid0 },
+        { 0, t_undef}
+};
+
+/* Neutralize disk type using generic metadata type mapping function */
+static enum type type(struct via *via)
+{
+	return rd_type(types, (unsigned int) VIA_RAID_TYPE(via));
+}
+
+/*
+ * Read a VIA RAID device
+ */
+/* Endianess conversion */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct via *via = meta;
+	unsigned int i = VIA_MAX_DISKS;
+
+	CVT16(via->signature);
+	CVT16(via->array.disk.bootable);
+	CVT32(via->array.capacity_low);
+	CVT32(via->array.capacity_high);
+	CVT32(via->array.serial_checksum);
+
+	while (i--)
+		CVT32(via->serial_checksum[i]);
+
+}
+#endif
+
+/* 8 bit checksum on first 50 bytes of metadata. */
+static uint8_t checksum(struct via *via)
+{
+	uint8_t i = 50, sum = 0;
+	
+	while (i--)
+		sum += ((uint8_t*) via)[i];
+
+printf("sum=%u via->checksum=%u\n", sum, via->checksum);
+	return sum == via->checksum;
+}
+
+static int is_via(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct via *via = meta;
+
+	if (via->signature != VIA_SIGNATURE)
+		return 0;
+
+	if (!checksum(via))
+		LOG_ERR(lc, 0, "%s: invalid checksum on %s", handler, di->path);
+
+	if (via->version_number > 1)
+		log_info(lc, "%s: version %u; format handler specified for "
+			 "version 0+1 only", handler, via->version_number);
+	
+	return 1;
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *via_read(struct lib_context *lc, struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct via), VIA_CONFIGOFFSET,
+			     to_cpu, is_via, NULL, setup_rd, handler);
+}
+
+/* Decide about ordering sequence of RAID device. */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	struct via *p = META(RD(pos), via);
+	struct via *n = META(RD(new), via);
+
+	switch (VIA_RAID_TYPE(p)) {
+	case VIA_T_RAID1:
+		return VIA_T_RAID1_SOURCE(n);
+
+	default: /* span, RAID0 + RAID01 */
+		return VIA_T_RAID_INDEX(n) < VIA_T_RAID_INDEX(p);
+	}
+}
+
+/* Decide about ordering sequence of RAID subset. */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return _subset(META(RD_RS(RS(new)), via)) <
+	       _subset(META(RD_RS(RS(pos)), via));
+}
+
+static void super_created(struct raid_set *ss, void *private)
+{
+	ss->type = t_raid1;
+	ss->stride = VIA_STRIDE(META(private, via));
+}
+
+/* FIXME: handle spares in mirrors and check that types are correct. */
+static int group_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_set **ss, struct raid_dev *rd)
+{
+	struct via *via = META(rd, via);
+
+	if (!init_raid_set(lc, rs, rd, VIA_STRIDE(via),
+			   VIA_RAID_TYPE(via), handler))
+		return 0;
+
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	switch (VIA_RAID_TYPE(via)) {
+	case VIA_T_SPAN:
+	case VIA_T_RAID0:
+	case VIA_T_RAID1:
+		if (!find_set(lc, NULL, rs->name, FIND_TOP))
+			list_add_tail(&rs->list, LC_RS(lc));
+
+		break;
+
+	case VIA_T_RAID01:
+		/* Sort RAID disk into appropriate subset. */
+		if (!(*ss = join_superset(lc, name, super_created,
+					  set_sort, rs, rd)))
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Add a VIA RAID device to a set */
+static struct raid_set *via_group(struct lib_context *lc,
+					 struct raid_dev *rd)
+{
+	struct raid_set *rs, *ss = NULL;
+
+	if (T_SPARE(rd))
+		return NULL;
+
+	if ((rs = find_or_alloc_raid_set(lc, rd->name, FIND_ALL, rd,
+					 NO_LIST, NO_CREATE, NO_CREATE_ARG)))
+		return group_rd(lc, rs, &ss, rd) ? (ss ? ss : rs) : NULL;
+
+	return NULL;
+}
+
+static int via_write(struct lib_context *lc, struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct via *via = META(rd, via);
+
+	to_disk(via);
+#endif
+	ret = write_metadata(lc, handler, rd, -1, erase);
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(via);
+#endif
+
+	return ret;
+}
+
+/*
+ * Check a VIA RAID set.
+ *
+ * FIXME: more sanity checks.
+ */
+/* Figure total number of disks depending on RAID type. */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	struct via *via = META(rd, via);
+
+	return VIA_RAID_TYPE(via) == VIA_T_RAID1 ? 2 : VIA_RAID_DISKS(via);
+}
+
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context)
+{
+	struct via *via = META(rd, via);
+
+	log_dbg(lc, "checking %s device \"%s\"", handler, rd->di->path);
+	if (VIA_ARRAY_INDEX(via) != VIA_ARRAY_INDEX(via))
+		LOG_ERR(lc, 0, "%s: array index wrong on %s for set \"%s\"",
+			handler, rd->di->path, rs->name);
+
+	if (VIA_RAID_TYPE(via) != VIA_RAID_TYPE(via))
+		LOG_ERR(lc, 0, "%s: RAID type wrong on %s for set \"%s\"",
+			handler, rd->di->path, rs->name);
+
+	return 1;
+}
+
+static int via_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return check_raid_set(lc, rs, devices, NULL, check_rd, NULL, handler);
+}
+
+/*
+ * IO error event handler.
+ */
+static int event_io(struct lib_context *lc, struct event_io *e_io)
+{
+	struct raid_dev *rd = e_io->rd;
+	struct via *via = META(rd, via);
+
+	/* Avoid write trashing. */
+	if (status(via) & s_broken)
+		return 0;
+
+	via->array.disk.tolerance = 1;
+
+	return 1;
+}
+
+static struct event_handlers via_event_handlers = {
+	.io = event_io,
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about the RAID device.
+ */
+static void via_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	unsigned int i;
+	struct via *via = META(rd, via);
+
+	log_print(lc, "%s (%s):", rd->di->path, handler);
+	DP("signature: 0x%x", via, via->signature);
+	DP("version_number: %u", via, via->version_number);
+	P("array.disk.bootable: %u", via, via->array.disk,
+	  via->array.disk.bootable);
+	P("array.disk.enable_enhanced: %u", via, via->array.disk,
+	  via->array.disk.enable_enhanced);
+	P("array.disk.in_disk_array: %u", via, via->array.disk,
+	  via->array.disk.in_disk_array);
+	P("array.disk.raid_type: %u", via, via->array.disk,
+	  VIA_RAID_TYPE(via));
+	P("array.disk.array_index: %u", via, via->array.disk,
+	  VIA_ARRAY_INDEX(via));
+
+	P("array.disk.raid_type_info: %u", via, via->array.disk,
+	  via->array.disk.raid_type_info);
+	P("array.disk.raid_type_info(INDEX): %u", via, via->array.disk,
+	  VIA_T_RAID_INDEX(via));
+	P("array.disk.raid_type_info(MIRROR): %u", via, via->array.disk,
+	  VIA_T_RAID01_MIRROR(via));
+	P("array.disk.raid_type_info(DIRTY): %u", via, via->array.disk,
+	  VIA_T_RAID01_DIRTY(via));
+
+	P("array.disk.tolerance: %u", via, via->array.disk,
+	  via->array.disk.tolerance);
+	DP("array.disk_array_ex: 0x%x", via, via->array.disk_array_ex);
+	DP("array.capacity_low: %u", via, via->array.capacity_low);
+	DP("array.capacity_high: %u", via, via->array.capacity_high);
+	DP("array.serial_checksum: %u", via, via->array.serial_checksum);
+
+	for (i = 0; i < VIA_MAX_DISKS; i++)
+		P2("serial_checksum[%u]: %u", via, i, via->serial_checksum[i]);
+
+	DP("checksum: %u", via, via->checksum);
+}
+#endif
+
+static struct dmraid_format via_format = {
+	.name	= HANDLER,
+	.descr	= "VIA Software RAID",
+	.caps	= "S,0,1,10",
+	.format = FMT_RAID,
+	.read	= via_read,
+	.write	= via_write,
+	.group	= via_group,
+	.check	= via_check,
+	.events	= &via_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= via_log,
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_via(struct lib_context *lc)
+{
+	return register_format_handler(lc, &via_format);
+}
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct via *via = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = VIA_CONFIGOFFSET >> 9;
+	rd->meta_areas->size = sizeof(*via);
+	rd->meta_areas->area = (void*) via;
+
+        rd->di = di;
+	rd->fmt = &via_format;
+
+	rd->status = status(via);
+	rd->type   = type(via);
+
+	rd->offset = VIA_DATAOFFSET;
+	rd->sectors = rd->meta_areas->offset;
+
+        return (rd->name = name(lc, rd, 1)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/ataraid/via.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/ataraid/via.h
+++ -	2008-02-22 16:57:42.636569000 +0000
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file DISCLAIMER at the top of this source tree for license information.
+ */
+
+#ifndef	_VIA_H_
+#define	_VIA_H_
+
+#ifdef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+/* VIA metadata and data  offsets. */
+#define	VIA_CONFIGOFFSET	((di->sectors - 1) << 9)
+#define	VIA_DATAOFFSET		0
+
+#define	VIA_MAX_DISKS		8
+
+struct disk {
+	uint16_t	bootable:1;		/* BIOS boot */
+	uint16_t	enable_enhanced:1;	/* Unused */
+	uint16_t	in_disk_array:1;	/* Used/Spare */
+	uint16_t	raid_type:4;
+#define	VIA_T_RAID0	0
+#define	VIA_T_RAID1	1
+#define	VIA_T_SPAN	8
+#define	VIA_T_RAID01	9
+#define VIA_RAID_TYPE(x)	((x)->array.disk.raid_type)
+	uint16_t	array_index:3;
+#define VIA_ARRAY_INDEX(x)	((x)->array.disk.array_index)
+	uint16_t	raid_type_info:5;
+/* SPAN + RAID 0 */
+#define	VIA_T_RAID_INDEX(x) ((x)->array.disk.raid_type_info & 0x7)
+
+/* RAID 1 */
+#define	VIA_T_RAID1_SOURCE(x) (((x)->array.disk.raid_type_info & 0x3) == 0)
+#define	VIA_T_RAID1_SPARE(x)  (((x)->array.disk.raid_type_info & 0x3) == 1)
+#define	VIA_T_RAID1_MIRROR(x) (((x)->array.disk.raid_type_info & 0x3) == 2)
+#define	VIA_T_RAID1_DIRTY(x)  (((x)->array.disk.raid_type_info & 0x4) >> 2)
+
+/* RAID 0+1 */
+// #define	VIA_T_RAID01_INDEX(x)	VIA_T_RAID_INDEX(x)
+#define	VIA_T_RAID01_MIRROR(x)	(((x)->array.disk.raid_type_info & 0x8) >> 3)
+#define	VIA_T_RAID01_DIRTY(x)	(((x)->array.disk.raid_type_info & 0x10) >> 4)
+
+/* SPAN */
+#define	VIA_T_SPAN_INDEX(x)	((x)->array.disk.raid_type_info & 0x7)
+	uint16_t	tolerance:1;
+} __attribute__ ((packed));
+
+struct array {
+	struct disk	disk;
+	uint8_t		disk_array_ex;
+#define	VIA_RAID_DISKS(x)	((x)->array.disk_array_ex & 0x7)
+#define	VIA_BROKEN(x)		(((x)->array.disk_array_ex & 0x8) >> 4)
+#define	VIA_STRIDE(x)		(8 << (((x)->array.disk_array_ex & 0xF0) >> 4))
+	uint32_t	capacity_low;
+	uint32_t	capacity_high;
+	uint32_t	serial_checksum;
+} __attribute__ ((packed));
+
+struct via {
+	uint16_t	signature;
+#define	VIA_SIGNATURE	0xAA55
+	uint8_t		version_number;
+	struct array	array;
+	uint32_t	serial_checksum[8];
+	uint8_t		checksum;
+} __attribute__ ((packed));
+#endif
+
+/* Prototype of the register function for this metadata format handler */
+int register_via(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/partition/dos.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/partition/dos.c
+++ -	2008-02-22 16:57:42.720563000 +0000
@@ -0,0 +1,406 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * DOS partition format handler.
+ *
+ * dos_read() and dos_group influenced by libparted.
+ */
+#define	HANDLER	"dos"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "dos.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+
+static const char *handler = HANDLER;
+
+/* Make up RAID device name. */
+static size_t _name(struct lib_context *lc, struct raid_dev *rd,
+		    unsigned short partition, char *str, size_t len,
+		    unsigned char type)
+{
+	return snprintf(str, len, type ? "%s%u" : "%s",
+			get_basename(lc, rd->di->path), partition);
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		   unsigned int part, unsigned char type)
+{
+	size_t len;
+	char *ret;
+
+	if ((ret = dbg_malloc((len = _name(lc, rd, part, NULL, 0, type) + 1))))
+		_name(lc, rd, part, ret, len, type);
+	else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/*
+ * Read a DOS partiton.
+ */
+/* Endianess conversion. */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu	NULL
+#else
+static void to_cpu(void *meta)
+{
+	struct dos *dos = meta;
+	struct dos_partition *part = dos->partitions;
+
+	for (part = dos->partitions; part < dos->partitions + 4; part++) {
+		CVT32(part->start);
+		CVT32(part->length);
+	}
+
+	CVT16(dos->magic);
+}
+#endif
+
+static int is_dos(struct lib_context *lc, struct dev_info *di, void *meta)
+{
+	struct dos *dos = meta;
+	struct dos_partition *part;
+
+	if (dos->magic != DOS_MAGIC)
+		return 0;
+
+	for (part = dos->partitions; part < &dos->partitions[4]; part++) {
+		if (part->type == PARTITION_GPT)
+			return 0;
+	}
+
+	return 1;
+}
+
+static void dos_file_metadata(struct lib_context *lc, struct dev_info *di,
+			      void *meta)
+{
+	if (OPT_DUMP(lc))
+		log_print(lc, "%s: filing metadata not supported (use fdisk "
+			  "and friends)", handler);
+}
+
+/* Allocate a DOS partition sector struct and read the data. */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *dos_read(struct lib_context *lc, struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct dos), DOS_CONFIGOFFSET,
+			     to_cpu, is_dos, dos_file_metadata,
+			     setup_rd, handler);
+}
+
+/* Support functions for dos_group to read the partition table(s). */
+static int part_is_extended (struct dos_partition *part)
+{
+	return part->type == PARTITION_EXT ||
+	       part->type == PARTITION_EXT_LBA ||
+	       part->type == PARTITION_LINUX_EXT;
+}
+
+/* Get a partition start offset relative to a base location. */
+static uint64_t get_part_start(const struct dos_partition *raw_part,
+			     uint64_t offset)
+{
+	return (uint64_t) raw_part->start + offset;
+}
+
+/* RAID set allocation support function. */
+static struct raid_set *_alloc_raid_set(struct lib_context *lc,
+					struct raid_dev *rd)
+{
+	struct raid_set *rs;
+
+	if ((rs = find_set(lc, NULL, rd->name, FIND_TOP)))
+		LOG_ERR(lc, NULL, "%s: RAID set %s already exists",
+			handler, rs->name);
+
+	if (!(rs = alloc_raid_set(lc, handler)))
+		return NULL;
+
+	rs->status = rd->status;
+	rs->type   = rd->type;
+
+       	if (!(rs->name = dbg_strdup(rd->name))) {
+		dbg_free(rs);
+		rs = NULL;
+		log_alloc_err(lc, handler);
+	}
+
+	return rs;
+}
+
+/*
+ * Allocate a DOS RAID device and a set.
+ * Set the device up and add it to the set.
+ */
+static int _create_rs_and_rd(struct lib_context *lc, struct raid_dev *rd,
+			     struct dos_partition *raw_part, uint64_t sector,
+			     unsigned int part)
+{
+	struct raid_dev *r;
+	struct raid_set *rs;
+
+	if (!(r = alloc_raid_dev(lc, handler)))
+		return 0;
+
+	if (!(r->di = alloc_dev_info(lc, rd->di->path)))
+		goto free_raid_dev;
+
+        if (!(r->name = name(lc, rd, part, 1)))
+		goto free_di;
+
+	r->fmt = rd->fmt;
+	r->status = rd->status;
+	r->type = rd->type;
+
+	if ((uint64_t) raw_part->start > sector)
+		sector = 0;
+
+	r->offset = get_part_start(raw_part, sector);
+	r->sectors = (uint64_t) raw_part->length;
+
+	if (!(rs = _alloc_raid_set(lc, r)))
+		goto free_di;
+
+	list_add_tail(&r->devs, &rs->devs);
+	list_add_tail(&rs->list, LC_RS(lc));
+
+	return 1;
+
+  free_di:
+	free_dev_info(lc, r->di);
+  free_raid_dev:
+	free_raid_dev(lc, &r);
+
+	return 0;
+}
+
+/*
+ * RAID set grouping.
+ *
+ * In this case it is not really about grouping, more about providing
+ * the propper input to the activation layer by creating a RAID set per
+ * partition and a RAID device hanging off it mapping the partition linearly.
+ *
+ * Partition code inspired by libparted and squeezed for this purpose (lemon).
+ */
+/* FIXME: Check for position of partition */
+static int is_partition(struct dos_partition *p, uint64_t start_sector)
+{
+	return p->type != PARTITION_EMPTY && p->length && p->start;
+}
+
+static int group_rd_extended(struct lib_context *lc, struct raid_dev *rd,
+			     uint64_t start_sector, uint64_t *extended_root,
+			     unsigned int part)
+{
+	int ret = 0;
+	uint64_t new_start_sector;
+	struct dos *dos;
+	struct dos_partition *p1, *p2;
+
+	/* Allocate and read a logical partition table. */
+	if (!(dos = alloc_private_and_read(lc, handler, sizeof(*dos),
+					   rd->di->path, start_sector << 9)))
+		return 0;
+
+	/* Weird: empty extended partitions are filled with 0xF6 by PM. */
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	to_cpu(dos);
+#endif
+	if (dos->magic == PARTITION_MAGIC_MAGIC)
+		goto out;
+	
+	/* Check magic to see if this is a real partition table. */
+	if (dos->magic != DOS_MAGIC)
+		goto out;
+
+	/*
+	 * Logical partition tables only have two entries,
+	 * one for the partition and one for the next partition table.
+	 */
+	 
+	/*
+	 * An entry pointing to the present logical partition.
+	 * It is an offset from the present partition table location.
+	 */
+	p1 = &dos->partitions[0];
+	
+	/*
+	 * An entry pointing to the next logical partition table.
+	 * It is an offset from the main extended partition start.
+	 */
+	p2 = &dos->partitions[1];
+
+	/* If it is a partition, add it to the set */
+	if (is_partition(p1, start_sector) &&
+	    !_create_rs_and_rd(lc, rd, p1, start_sector, part++))
+		goto out;
+
+	/*
+	 * Recurse into the logical partition chain.
+	 * Save start of main extended partition since
+	 * logical partition tables in the extended partition
+	 * are at offsets from this.
+	 */
+	if (!*extended_root)
+		*extended_root = start_sector;
+	new_start_sector = get_part_start(p2, *extended_root);
+	
+	if (is_partition(p2, start_sector) &&
+	    !group_rd_extended(lc, rd, new_start_sector, extended_root, part))
+		goto out;
+
+	ret = 1;
+
+  out:
+	dbg_free(dos);
+	return ret;
+}
+
+/* Handle primary partitions. */
+static int group_rd(struct lib_context *lc, struct raid_dev *rd,
+		    uint64_t start_sector)
+{
+	unsigned int i;
+	uint64_t part_start, part_end,
+		 extended_part_start = 0, extended_root = 0;
+	struct dos *dos = META(rd, dos);
+	struct dos_partition *raw_table_entry;
+
+	/*
+	 * Walk the 4 array entries in the primary partition table.
+	 *
+	 * Finish all primary partitions before going on to
+	 * the extended partition. Hopefully, for now you only
+	 * have one extended partition!
+	 */
+	for (i = 0; i < 4; i++) {
+		raw_table_entry = &dos->partitions[i];
+		if (!is_partition(raw_table_entry, start_sector))
+			continue;
+
+		/* Add partition start from partition table to
+		 * start of drive.
+		 */
+		part_start = get_part_start(raw_table_entry, start_sector);
+		part_end   = part_start + raw_table_entry->length;
+		
+		/* Avoid infinite recursion (mostly). */
+		if (part_start == start_sector ||
+		    part_end > rd->sectors)
+			continue;
+
+		/*
+		 * If we have an extended partition, save
+		 * partition start as a flag for later use.
+		 * Else go put partition in set.
+		 */
+		if (part_is_extended(raw_table_entry))
+			extended_part_start = part_start;
+		else if (!_create_rs_and_rd(lc, rd, raw_table_entry,
+					    start_sector, i + 1))
+			return 0;
+	}
+	
+	/* When we are finished with all the primary partitions,
+	 * go do the extended partition if we have one.
+	 * It always starts with partition 5.
+	 */
+	return extended_part_start ?
+	       group_rd_extended(lc, rd, extended_part_start,
+				 &extended_root, 5) : 1;
+}
+
+/* Add a DOS RAID device to a set */
+static struct raid_set *dos_group(struct lib_context *lc,
+				    struct raid_dev *rd)
+{
+	/*
+	 * Once we get here, a DOS partition table
+	 * has been discovered by dos_read.
+	 *
+	 * We need to run through the (nested) partition tables and create
+	 * a RAID set and a linear RAID device hanging off it for every primary
+	 * and logical partition, so that the activate code is happy.
+	 *
+	 * We start with start_sector = 0 because all primary partitions are
+	 * located at offsets from the start of the drive. This COULD be changed
+	 * to something else for some strange partitioning scheme because the
+	 * code will handle it.
+	 */
+	return group_rd(lc, rd, 0) ? (struct raid_set*) 1 : NULL;
+}
+
+/*
+ * Check integrity of a DOS RAID set.
+ */
+static int dos_check(struct lib_context *lc, struct raid_set *rs)
+{
+	return 1; /* Nice, eh ? */
+}
+
+static struct dmraid_format dos_format = {
+	.name	= HANDLER,
+	.descr	= "DOS partitions on SW RAIDs",
+	.caps	= NULL, /* Not supported */
+	.format = FMT_PARTITION,
+	.read	= dos_read,
+	.write	= NULL, /* Not supported */
+	.group	= dos_group,
+	.check	= dos_check,
+	.events	= NULL, /* Not supported */
+#ifdef DMRAID_NATIVE_LOG
+	.log	= NULL, /* Not supported */
+#endif
+};
+
+/* Register this format handler with the format core. */
+int register_dos(struct lib_context *lc)
+{
+	return register_format_handler(lc, &dos_format);
+}
+
+/*
+ * Set the RAID device contents up derived from the DOS ones
+ *
+ * For a DOS partition we essentially just save the
+ * partition table sector and let dos_group do the rest...
+ */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct dos *dos = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = DOS_CONFIGOFFSET >> 9;
+	rd->meta_areas->size = sizeof(*dos);
+	rd->meta_areas->area = (void*) dos;
+
+        rd->di  = di;
+	rd->fmt = &dos_format;
+
+        rd->status = s_ok; /* Always :-) */
+	rd->type   = t_partition;
+
+	rd->offset   = DOS_DATAOFFSET;
+	rd->sectors  = di->sectors;
+
+        return (rd->name = name(lc, rd, 0, 0)) ? 1 : 0;
+}
/cvs/dm/dmraid/lib/format/partition/dos.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/partition/dos.h
+++ -	2008-02-22 16:57:42.804765000 +0000
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * DOS partition defintion.
+ *
+ * Profited from libparted.
+ */
+
+#ifndef	_DOS_H_
+#define	_DOS_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+#include <stdint.h>
+
+#define	DOS_CONFIGOFFSET	0
+#define	DOS_DATAOFFSET		0
+
+struct chs {
+        uint8_t         head;
+        uint8_t         sector;
+        uint8_t         cylinder;
+} __attribute__ ((packed));
+
+struct dos_partition {
+        uint8_t		boot_ind;	/* 00:  0x80 - active */
+	struct chs	chs_start;	/* 01: */
+	uint8_t		type;		/* 04: partition type */
+#define PARTITION_EMPTY		0x00
+#define PARTITION_EXT		0x05
+#define PARTITION_EXT_LBA	0x0f
+#define PARTITION_LINUX_EXT	0x85
+#define PARTITION_GPT		0xee
+	struct chs	chs_end;	/* 05: */
+	uint32_t	start;		/* 08: starting sector from 0 */
+	uint32_t	length;		/* 0c: nr of sectors in partition */
+} __attribute__ ((packed));
+
+struct dos {
+	uint8_t			boot_code [446];
+	struct dos_partition	partitions [4];
+	uint16_t		magic;
+#define	DOS_MAGIC	0xAA55
+#define	PARTITION_MAGIC_MAGIC	0xF6F6
+} __attribute__ ((packed));
+
+#endif /* FORMAT_HANDLER */
+
+/* Prototype of the register function for this metadata format handler */
+int register_dos(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/format/template/README,v  -->  standard output
revision 1.1
--- dmraid/lib/format/template/README
+++ -	2008-02-22 16:57:42.892880000 +0000
@@ -0,0 +1,13 @@
+This directory contains a dmraid library format handler template.
+
+See template.h for a basic header defining the ondisk metadata structures
+and template.c showing the basic code structure of a format handler.
+Watch the CODEME remarks for coding areas to cover.
+You probably want to look at lib/format/ataraid/*.[ch] as well ;)
+
+Put your format handler .h and .c files into an appropriate (new)
+subdirectory (eg, another ATARAID format handler goes into lib/format/ataraid),
+add your register function to lib/format/register.h, add your header file
+to lib/format/ondisk.h and add the .c file to SOURCES in lib/Makefile.in
+(don't forget to run configure before make).
+
/cvs/dm/dmraid/lib/format/template/template.c,v  -->  standard output
revision 1.1
--- dmraid/lib/format/template/template.c
+++ -	2008-02-22 16:57:42.978877000 +0000
@@ -0,0 +1,230 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Template to implement metadata format handlers.
+ */
+
+#define	HANDLER	"template"
+
+#include "internal.h"
+#define	FORMAT_HANDLER
+#include "template.h"
+
+#if	BYTE_ORDER != LITTLE_ENDIAN
+#  define	DM_BYTEORDER_SWAB
+#  include	<datastruct/byteorder.h>
+#endif
+
+static const char *handler = HANDLER;
+
+/* Make up RAID device name. */
+/* CODEME: implement creation of senseful name for the RAID device */
+static size_t _name(struct template *template, char *str, size_t len,
+		    unsigned int subset)
+{
+	return snprintf(str, len, "template");
+}
+
+static char *name(struct lib_context *lc, struct raid_dev *rd,
+		  unsigned int subset)
+{
+	size_t len;
+	char *ret;
+	struct template *template = META(rd, template);
+
+	if ((ret = dbg_malloc((len = _name(template, NULL, 0, subset) + 1)))) {
+		_name(template, ret, len, subset);
+		mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN);
+	} else
+		log_alloc_err(lc, handler);
+
+	return ret;
+}
+
+/* Mapping of template types to generic types */
+/*
+ * CODEME: mappings of template private level types to generic ones 
+ * (see metadata.h for generic ones)
+ */
+static struct types types[] = {
+	{ TEMPLATE_T_SPAN,  t_linear },
+	{ TEMPLATE_T_RAID0, t_raid0 },
+        { 0, t_undef}
+};
+
+/* Neutralize disk type using generic metadata type mapping function */
+static enum type template_type(struct lib_context *lc, struct raid_dev *rd)
+{
+	return rd_type(types, (unsigned int) (META(rd, template))->type);
+}
+
+/*
+ * Read a Template RAID device
+ */
+/* CODEME: endianess conversion */
+#if	BYTE_ORDER == LITTLE_ENDIAN
+#  define	to_cpu(x)
+#else
+static void to_cpu(struct template *template)
+{
+	CVT32(template->something);
+	...
+}
+#endif
+
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info);
+static struct raid_dev *template_read(struct lib_context *lc,
+					struct dev_info *di)
+{
+	return read_raid_dev(lc, di, NULL,
+			     sizeof(struct template), TEMPLATE_CONFIGOFFSET,
+			     NULL, NULL, NULL, handler);
+}
+
+/*
+ * Decide about ordering sequence of RAID device.
+ * (Called by list_add_sorted().
+ */
+static int dev_sort(struct list_head *pos, struct list_head *new)
+{
+	return (META(RD(new), template))->disk_number <
+	       (META(RD(pos), template))->disk_number;
+}
+
+/*
+ * Decide about ordering sequence of RAID device.
+ * (Called by join_superset().
+ */
+static int set_sort(struct list_head *pos, struct list_head *new)
+{
+	return _subset(META(RD_RS(RS(new)), via)) <
+	       _subset(META(RD_RS(RS(pos)), via));
+}
+
+/* Add a Template RAID device to a set */
+static struct raid_set *template_group(struct lib_context *lc,
+					 struct raid_dev *rd)
+{
+	if (T_SPARE(rd))
+		return NULL;
+
+	/* CODEME: add grouping logic
+	 *
+	 * This involves list_add_sorted() and in case of
+	 * stacked RAID sets, join_superset() calls as well.
+	 */
+	log_err(lc, "%s: implement grouping logic for RAID set", handler);
+	return NULL;
+}
+
+/* CODEME: Write private RAID metadata to device */
+static int template_write(struct lib_context *lc,
+			  struct raid_dev *rd, int erase)
+{
+	int ret;
+#if	BYTE_ORDER != LITTLE_ENDIAN
+	struct template *template = META(rd, template);
+#endif
+
+	/* CODEME: in case there's more complex metadata areas */
+	to_disk(template);
+	ret = write_metadata(lc, handler, rd, -1, erase);
+	to_cpu(template);
+	return ret;
+}
+
+/*
+ * Check integrity of a RAID set.
+ */
+static unsigned int devices(struct raid_dev *rd, void *context)
+{
+	LOG_ERR(lc, 0, "%s: implement RAID device # function", handler);
+}
+
+static int check_rd(struct lib_context *lc, struct raid_set *rs,
+		    struct raid_dev *rd, void *context);
+{
+	LOG_ERR(lc, 0, "%s: implement RAID device integrity checks", handler);
+}
+
+static int template_check(struct lib_context *lc, struct raid_set *rs)
+{
+	/* CODEME: implement */
+	return check_raid_set(lc, rs, devices, devices_context,
+			      check_rd, check_rd_context, handler);
+}
+
+static struct event_handlers template_event_handlers = {
+	.io = event_io,	/* CODEME: */
+	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
+};
+
+#ifdef DMRAID_NATIVE_LOG
+/*
+ * Log native information about the RAID device.
+ */
+static void template_log(struct lib_context *lc, struct raid_dev *rd)
+{
+	struct template *template = META(rd, template);
+
+	/* CODEME: implement (use P(), ... macors from format.h */
+	log_print(lc, "%s: implement displaying metadata variables", handler);
+}
+#endif
+
+static struct dmraid_format template_format = {
+	.name	= HANDLER,
+	.descr	= "Template RAID",
+	.caps	= "(Insert RAID levels here)",
+	.format = FMT_RAID,
+	.read	= template_read,
+	.write	= template_write,
+	.group	= template_group,
+	.check	= template_check,
+	.events	= &template_event_handlers,
+#ifdef DMRAID_NATIVE_LOG
+	.log	= template_log,
+#endif
+};
+
+/* Register this format handler with the format core */
+int register_template(struct lib_context *lc)
+{
+	return register_format_handler(lc, &template_format);
+}
+
+/* CODEME: Set the RAID device contents up derived from the TEMPLATE ones */
+static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
+		    struct dev_info *di, void *meta, union read_info *info)
+{
+	struct template *template = meta;
+
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
+		return 0;
+
+	rd->meta_areas->offset = TEMPLATE_CONFIGOFFSET >> 9;
+	rd->meta_areas->size = sizeof(*template);
+	rd->meta_areas->area = (void*) template;
+
+        rd->di = di;
+	rd->fmt = &template_format;
+
+	rd->status = s_ok; /* CODEME: derive from metadata. */
+	rd->type   = template_type(template);
+
+	rd->offset = TEMPLATE_DATAOFFSET;
+	/* CODEME: correct sectors. */
+	rd->sectors = rd->meta_areas->offset;
+
+
+        if ((rd->name = name(lc, rd, 1)))
+		return 1;
+
+	return 0;
+}
/cvs/dm/dmraid/lib/format/template/template.h,v  -->  standard output
revision 1.1
--- dmraid/lib/format/template/template.h
+++ -	2008-02-22 16:57:43.061577000 +0000
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_TEMPLATE_H_
+#define	_TEMPLATE_H_
+
+#ifdef	FORMAT_HANDLER
+#undef	FORMAT_HANDLER
+
+/* CODEME: code ondisk metadata definitions */
+
+#include <stdint.h>
+
+#define	TEMPLATE_CONFIGOFFSET	((di->sectors - 1) << 9)
+#define	TEMPLATE_DATAOFFSET		0
+
+struct template {
+	uint8_t magic_name[8];	/* metadata has a 'magic' name ? */
+#define	TEMPLATE_MAGIC_NAME	"TEMPLATE"
+
+	uint32_t magic;		/* and/or metadata has a 'magic' number ? */
+#define	TEMPLATE_MAGIC_OK	0xABCDEF
+
+	uint8_t	type;		/* RAID level */
+#define	TEMPLATE_T_SPAN	0
+#define	TEMPLATE_T_RAID0 1
+
+	uint8_t disk_number;	/* Absolute disk number in set. */
+	/* etc. */
+
+	.......			/* members for numbers of disks, whatever... */
+} __attribute__ ((packed));
+#endif
+
+/* Prototype of the register function for this metadata format handler */
+int register_template(struct lib_context *lc);
+
+#endif
/cvs/dm/dmraid/lib/locking/locking.c,v  -->  standard output
revision 1.1
--- dmraid/lib/locking/locking.c
+++ -	2008-02-22 16:57:43.158050000 +0000
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <errno.h>
+
+#ifndef __KLIBC__
+# include <sys/file.h>
+#endif
+
+#include "internal.h"
+
+/* File locking private data. */
+static const char *lock_file = "/var/lock/dmraid/.lock";
+static int lf = -1;
+
+/* flock file. */
+static int lock(struct lib_context *lc, struct resource *res)
+{
+	/* Already locked. */
+	if (lf > -1)
+		return 1;
+
+	log_warn(lc, "locking %s", lock_file);
+	if ((lf = open(lock_file, O_CREAT | O_APPEND | O_RDWR, 0777)) < 0)
+		LOG_ERR(lc, 0, "opening lockfile %s", lock_file);
+
+	if (flock(lf, LOCK_EX)) {
+		close(lf);
+		lf = -1;
+		LOG_ERR(lc, 0, "flock lockfile %s", lock_file);
+	}
+
+	return 1;
+}
+
+/* Unlock file. */
+static void unlock(struct lib_context *lc, struct resource *res)
+{
+	/* Not locked! */
+	if (lf == -1)
+		return;
+
+	log_warn(lc, "unlocking %s", lock_file);
+	unlink(lock_file);
+	if (flock(lf, LOCK_NB | LOCK_UN))
+		log_err(lc, "flock lockfile %s", lock_file);
+
+	if (close(lf))
+		log_err(lc, "close lockfile %s", lock_file);
+
+	lf = -1;
+}
+
+/* File base locking interface. */
+static struct locking file_locking = {
+	.name	 = "file",
+	.lock 	 = lock,
+	.unlock	 = unlock,
+};
+
+static int init_file_locking(struct lib_context *lc)
+{
+	int ret = 0;
+	char *dir;
+
+	if (!(dir = get_dirname(lc, (char*) lock_file)))
+		return 0;
+
+	if (!mk_dir(lc, dir))
+		goto out;
+
+	/* Fail on read-only file system. */
+	if (access(dir, R_OK | W_OK) && errno == EROFS)
+		goto out;
+
+	lc->lock = &file_locking;
+	ret = 1;
+
+   out:
+	dbg_free(dir);
+
+	return ret;
+}
+
+/*
+ * External locking interface.
+ */
+
+/* Initialize locking. */
+int init_locking(struct lib_context *lc)
+{
+	if (OPT_IGNORELOCKING(lc))
+		return 1;
+
+	if (lc->locking_name)
+		BUG(lc, 0, "no locking selection yet");
+
+	return init_file_locking(lc);
+}
+
+/* Hide locking. */
+int lock_resource(struct lib_context *lc, struct resource *res)
+{
+	return OPT_IGNORELOCKING(lc) ? 1 : lc->lock->lock(lc, res);
+}
+
+/* Hide unlocking. */
+void unlock_resource(struct lib_context *lc, struct resource *res)
+{
+	return OPT_IGNORELOCKING(lc) ? 1 : lc->lock->unlock(lc, res);
+}
/cvs/dm/dmraid/lib/log/log.c,v  -->  standard output
revision 1.1
--- dmraid/lib/log/log.c
+++ -	2008-02-22 16:57:43.247896000 +0000
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <stdarg.h>
+#include "internal.h"
+
+static const char *_prefixes[] = {
+	NULL,
+	"INFO",
+	"NOTICE",
+	"WARN",
+	"DEBUG",
+	"ERROR",
+	"FATAL",
+};
+
+static const char *_prefix(int level)
+{
+	return level < ARRAY_SIZE(_prefixes) ? _prefixes[level] : "UNDEF";
+}
+
+void plog(struct lib_context *lc, int level, int lf, const char *file,
+	  int line, const char *format, ...)
+{
+	int o = LC_VERBOSE, l = level;
+	FILE *f = stdout;
+	va_list ap;
+
+ 	if (level == _PLOG_DEBUG) {
+		o = LC_DEBUG;
+		l -= _PLOG_WARN;
+	}
+
+	if (level == _PLOG_ERR || level == _PLOG_FATAL)
+		f = stderr;
+	/* Checking lc here to allow early calls without a context. */
+	else if (lc && lc_opt(lc, o) < l)
+		return;
+
+	if (_prefix(level))
+		fprintf(f, "%s: ", _prefix(level));
+
+	va_start(ap, format);
+	vfprintf(f, format, ap);
+	va_end(ap);
+
+	if (lf)
+		fputc('\n', f);
+}
+
+/* This is used so often in the metadata format handlers and elsewhere. */
+int log_alloc_err(struct lib_context *lc, const char *who)
+{
+	LOG_ERR(lc, 0, "%s: allocating", who);
+}
/cvs/dm/dmraid/lib/log/log.h,v  -->  standard output
revision 1.1
--- dmraid/lib/log/log.h
+++ -	2008-02-22 16:57:43.364058000 +0000
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _LOG_H_
+#define _LOG_H_
+
+#include <stdio.h>
+
+/* Compatibility type for logging. */
+#define	PRIzu	"zu"
+
+/* Log levels. */
+#define _PLOG_INFO 1
+#define _PLOG_NOTICE 2
+#define _PLOG_WARN 3
+#define _PLOG_DEBUG 4
+#define _PLOG_ERR 5
+#define _PLOG_FATAL 6
+
+struct lib_context;
+void plog(struct lib_context *lc, int level, int lf, const char *file,
+	  int line, const char *format, ...);
+int log_alloc_err(struct lib_context *lc, const char *who);
+
+#  ifdef DMRAID_MINI
+
+#define log_info(lc, x...)
+#define log_info_nnl(lc, x...)
+#define log_notice(lc, x...)
+#define log_notice_nnl(lc, x...)
+#define log_warn(lc, x...)
+#define log_warn_nn(lc, x...)
+#define log_debug(lc, x...)
+#define log_debug_nnl(lc, x...)
+#define log_dbg(lc, x...)
+#define log_dbg_nnl(lc, x...)
+
+#  else
+
+#define _log_info(lc, lf, x...) plog(lc, _PLOG_INFO, lf, __FILE__, __LINE__, x)
+#define log_info(lc, x...) _log_info(lc, 1, x)
+#define log_info_nnl(lc, x...) _log_info(lc, 0, x)
+
+#define _log_notice(lc, lf, x...) \
+	plog(lc, _PLOG_NOTICE, lf, __FILE__, __LINE__, x)
+#define log_notice(lc, x...) _log_notice(lc, 1, x)
+#define log_notice_nnl(lc, x...) _log_notice(lc, 0, x)
+
+#define _log_warn(lc, lf, x...) plog(lc, _PLOG_WARN, lf, __FILE__, __LINE__, x)
+#define log_warn(lc, x...) _log_warn(lc, 1, x)
+#define log_warn_nnl(lc, x...) _log_warn(lc, 0, x)
+
+#define _log_debug(lc, lf, x...) \
+	plog(lc, _PLOG_DEBUG, lf, __FILE__, __LINE__, x)
+#define log_debug(lc, x...) _log_debug(lc, 1, x)
+#define log_debug_nnl(lc, x...) _log_debug(lc, 0, x)
+#define log_dbg(lc, x...) log_debug(lc, x)
+#define log_dbg_nnl(lc, x...) log_debug_nnl(lc, x)
+
+#  endif
+
+#define	log_level(lc, level, x...) plog(lc, level, 1, __FILE__, __LINE__, x)
+#define	log_level_nnl(lc, level, x...) plog(lc, level, 0, __FILE__, __LINE__, x)
+
+#define _log_error(lc, lf, x...) plog(lc, _PLOG_ERR, lf, __FILE__, __LINE__, x)
+#define log_error(lc, x...) _log_error(lc, 1, x)
+#define log_error_nnl(lc, x...) _log_error(lc, 0, x)
+#define log_err(lc, x...) log_error(lc, x)
+#define log_err_nnl(lc, x...) log_error_nnl(lc, x)
+
+#define _log_fatal(lc, lf, x...) \
+	plog(lc, _PLOG_FATAL, lf, __FILE__, __LINE__, x)
+#define log_fatal(lc, x...) _log_fatal(lc, 1, x)
+#define log_fatal_nnl(lc, x...) _log_fatal(lc, 0, x)
+
+
+#define	LOG_ERR(lc, ret, x...)	do { log_err(lc, x); return ret; } while (0)
+#define	BUG(lc, ret, x...)	do { LOG_ERR(lc, ret, x); } while (0)
+
+#define _log_print(lc, lf, x...) plog(lc, 0, lf, __FILE__, __LINE__, x)
+#define log_print(lc, x...)	_log_print(lc, 1, x)
+#define log_print_nnl(lc, x...)	_log_print(lc, 0, x)
+#define	LOG_PRINT(lc, ret, x...) do { log_print(lc, x); return ret; } while (0)
+#define	LOG_PRINT_NNL(lc, ret, x...) \
+	do { _log_print(lc, lc, 0, x); return ret; } while (0)
+
+#endif
/cvs/dm/dmraid/lib/metadata/metadata.c,v  -->  standard output
revision 1.1
--- dmraid/lib/metadata/metadata.c
+++ -	2008-02-22 16:57:43.478101000 +0000
@@ -0,0 +1,1086 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+#include "activate/devmapper.h"
+
+/*
+ * Type -> ascii definitions.
+ *
+ * dsp_ascii : the string used for display purposes (eg, "dmraid -s").
+ * dm_ascii  :         "       in device-mapper tables as the target keyword.
+ */
+static const struct {
+	const enum type type;
+	const char *dsp_ascii;
+	const char *dm_ascii;
+} ascii_type[] = {
+	/* enum        text         dm-target id */
+	{ t_undef,     NULL,        NULL },
+	{ t_group,     "GROUP",	    NULL },
+	{ t_partition, "partition", NULL },
+	{ t_spare,     "spare",     NULL },
+	{ t_linear,    "linear",    "linear" },
+	{ t_raid0,     "stripe",    "striped" },
+	{ t_raid1,     "mirror",    "mirror" },
+	{ t_raid4,     "raid4",     "raid45" },
+	{ t_raid5_ls,  "raid5_ls",  "raid45" },
+	{ t_raid5_rs,  "raid5_rs",  "raid45" },
+	{ t_raid5_la,  "raid5_la",  "raid45" },
+	{ t_raid5_ra,  "raid5_ra",  "raid45" },
+	{ t_raid6,     "raid6",     NULL },
+};
+
+static const char *stacked_ascii_type[][5] = {
+	{ "raid10", "raid30", "raid40", "raid50", "raid60" },
+	{ "raid01", "raid03", "raid04", "raid05", "raid06" },
+};
+
+/*
+ * State definitions.
+ */
+static const struct {
+	const enum status status;
+	const char *ascii;
+} ascii_status[] = {
+	{ s_undef,        NULL },
+	{ s_setup,        "setup" },
+	{ s_broken,       "broken" },
+	{ s_inconsistent, "inconsistent" },
+	{ s_nosync,       "nosync" },
+	{ s_ok,           "ok" },
+};
+
+/* Fetch the respective ASCII string off the types array. */
+static unsigned int get_type_index(enum type type)
+{
+	unsigned int ret = ARRAY_SIZE(ascii_type);
+
+	while (ret-- && !(type & ascii_type[ret].type));
+
+	return ret;
+}
+
+const char *get_type(struct lib_context *lc, enum type type)
+{
+	return ascii_type[get_type_index(type)].dsp_ascii;
+}
+
+const char *get_dm_type(struct lib_context *lc, enum type type)
+{
+	return ascii_type[get_type_index(type)].dm_ascii;
+}
+
+/* Return the RAID type of a stacked RAID set (eg, raid10). */
+static const char *get_stacked_type(void *v)
+{
+	struct raid_set *rs = v;
+	unsigned int t = (T_RAID0(rs) ? get_type_index((RS_RS(rs))->type) :
+					get_type_index(rs->type))
+			 - get_type_index(t_raid1);
+
+	return stacked_ascii_type[T_RAID0(rs) ? 1 : 0][t];
+}
+
+/* Check, if a RAID set is stacked (ie, hierachical). */
+static inline int is_stacked(struct raid_set *rs)
+{
+	return !T_GROUP(rs) && SETS(rs);
+}
+
+/* Return the ASCII type for a RAID set. */
+const char *get_set_type(struct lib_context *lc, void *v)
+{
+	struct raid_set *rs = v;
+
+	/* Check, if a RAID set is stacked. */
+	return is_stacked(rs) ? get_stacked_type(rs) : get_type(lc, rs->type);
+}
+
+/* Fetch the respective ASCII string off the state array. */
+const char *get_status(struct lib_context *lc, enum status status)
+{
+	unsigned int i = ARRAY_SIZE(ascii_status);
+
+	while (i-- && !(status & ascii_status[i].status));
+
+	return ascii_status[i].ascii;
+}
+
+/*
+ * Calculate the size of the set by recursively summing
+ * up the size of the devices in the subsets.
+ *
+ * Pay attention to RAID > 0 types.
+ */
+static uint64_t add_sectors(struct raid_set *rs, uint64_t sectors,
+			    uint64_t add)
+{
+	add = round_down(add, rs->stride);
+
+	if (T_RAID1(rs)) {
+		if (!sectors || sectors > add)
+			sectors = add;
+	} else
+		sectors += add;
+
+	return sectors;
+}
+
+/* FIXME: proper calculation of unsymetric sets ? */
+static uint64_t smallest_disk(struct raid_set *rs)
+{
+	uint64_t ret = ~0;
+	struct raid_dev *rd;
+
+	list_for_each_entry(rd, &rs->devs, devs)
+		ret = min(ret, rd->sectors);
+
+	return ret;
+}
+
+/* Count subsets of a set. */
+static unsigned int count_subsets(struct lib_context *lc, struct raid_set *rs)
+{
+	unsigned ret = 0;
+	struct raid_set *r;
+
+	list_for_each_entry(r, &rs->sets, list)
+		ret++;
+
+	return ret;
+}
+
+/* Calculate total sectors of a (hierarchical) RAID set. */
+uint64_t total_sectors(struct lib_context *lc, struct raid_set *rs)
+{
+        uint64_t sectors = 0;
+        struct raid_dev *rd;
+
+	/* Stacked RAID sets. */
+	if (!T_GROUP(rs)) {
+        	struct raid_set *r;
+
+		list_for_each_entry(r, &rs->sets, list)
+			sectors = add_sectors(rs, sectors,
+					      total_sectors(lc, r));
+	}
+
+	/* RAID device additions taking size maximization into account. */
+	if (DEVS(rs)) {
+		uint64_t min = F_MAXIMIZE(rs) ? 0 : smallest_disk(rs);
+
+		list_for_each_entry(rd, &rs->devs, devs) {
+			if (!T_SPARE(rd))
+				sectors = add_sectors(rs, sectors,
+						      F_MAXIMIZE(rs) ?
+						      rd->sectors : min);
+		}
+	}
+
+	/* Size correction for higher RAID levels */
+	if (T_RAID4(rs) || T_RAID5(rs) || T_RAID6(rs)) {
+		unsigned int i = count_subsets(lc, rs);
+		uint64_t sub = sectors / (i ? i : count_devs(lc, rs, ct_dev));
+
+		sectors -= sub;
+		if (T_RAID6(rs))
+			sectors -= sub;
+	}
+
+        return sectors;
+}
+
+/* Check if a RAID device should be counted. */
+static unsigned int _count_dev(struct raid_dev *rd, enum count_type type)
+{
+	return ((type == ct_dev && !T_SPARE(rd)) ||
+		(type == ct_spare && T_SPARE(rd)) ||
+		type == ct_all) ? 1 : 0;
+}
+
+/* Count devices in a set recursively. */
+unsigned int count_devs(struct lib_context *lc, struct raid_set *rs,
+			enum count_type count_type)
+{
+	unsigned int ret = 0;
+	struct raid_set *r;
+	struct raid_dev *rd;
+
+	list_for_each_entry(r, &rs->sets, list) {
+		if (!T_GROUP(rs))
+			ret += count_devs(lc, r, count_type);
+	}
+
+	list_for_each_entry(rd, &rs->devs, devs)
+		ret += _count_dev(rd, count_type);
+
+	return ret;
+}
+
+/*
+ * Create list of unique memory pointers of a RAID device and free them.
+ *
+ * This prevents me from having a destructor method in the metadata
+ * format handlers so far. If life becomes more complex, I might need
+ * one though...
+ */
+static void _free_dev_pointers(struct lib_context *lc, struct raid_dev *rd)
+{
+	int area, i, idx = 0;
+	void **p;
+
+	/* Count private and area pointers. */
+	if (!(area = (rd->private.ptr ? 1 : 0) + rd->areas))
+		return;
+
+	/* Allocate and initialize temporary pointer list. */
+	if (!(p = dbg_malloc(area * sizeof(*p))))
+		LOG_ERR(lc, , "allocating pointer array");
+
+	/* Add private pointer to list. */
+	if (rd->private.ptr)
+		p[idx++] = rd->private.ptr;
+
+	/* Add metadata area pointers to list. */
+	for (area = 0; area < rd->areas; area++) {
+		/* Handle multiple pointers to the same memory. */
+		for (i = 0; i < idx; i++) {
+			if (p[i] == rd->meta_areas[area].area)
+				break;
+		}
+	
+		if (i == idx)
+			p[idx++] = rd->meta_areas[area].area;
+	}
+
+	if (rd->meta_areas)
+		dbg_free(rd->meta_areas);
+
+	/* Free all RAID device pointers. */
+	while (idx--)
+		dbg_free(p[idx]);
+	
+	dbg_free(p);
+}
+
+/* Allocate dev_info struct and keep the device path */
+struct dev_info *alloc_dev_info(struct lib_context *lc, char *path)
+{
+	struct dev_info *di;
+
+	if ((di = dbg_malloc(sizeof(*di)))) {
+		if ((di->path = dbg_strdup(path)))
+			INIT_LIST_HEAD(&di->list);
+		else {
+			dbg_free(di);
+			di = NULL;
+			log_alloc_err(lc, __func__);
+		}
+	}
+
+	return di;
+}
+
+/* Free dev_info structure */
+static void _free_dev_info(struct lib_context *lc, struct dev_info *di)
+{
+	if (di->serial)
+		dbg_free(di->serial);
+
+	dbg_free(di->path);
+	dbg_free(di);
+}
+
+static inline void _free_dev_infos(struct lib_context *lc)
+{
+	struct list_head *elem, *tmp;
+
+	list_for_each_safe(elem, tmp, LC_DI(lc)) {
+		list_del(elem);
+		_free_dev_info(lc, list_entry(elem, struct dev_info, list));
+	}
+}
+
+/*
+ * Free dev_info structure or all registered
+ * dev_info structures in case di = NULL.
+ */
+void free_dev_info(struct lib_context *lc, struct dev_info *di)
+{
+	di ? _free_dev_info(lc, di) : _free_dev_infos(lc);
+}
+
+/* Allocate/Free RAID device (member of a RAID set). */
+struct raid_dev *alloc_raid_dev(struct lib_context *lc, const char *who)
+{
+	struct raid_dev *ret;
+
+	if ((ret = dbg_malloc(sizeof(*ret)))) {
+		INIT_LIST_HEAD(&ret->list);
+		INIT_LIST_HEAD(&ret->devs);
+		ret->status = s_setup;
+	} else
+		log_alloc_err(lc, who);
+
+	return ret;
+}
+
+static void _free_raid_dev(struct lib_context *lc, struct raid_dev **rd)
+{
+	struct raid_dev *r = *rd;
+
+	/* Remove if on global list. */
+	if (!list_empty(&r->list))
+		list_del(&r->list);
+
+	/*
+	 * Create list of memory pointers allocated by
+	 * the metadata format handler and free them.
+	 */
+	_free_dev_pointers(lc, r);
+
+	dbg_free(r->name);
+	dbg_free(r);
+	*rd = NULL;
+}
+
+static inline void _free_raid_devs(struct lib_context *lc)
+{
+	struct list_head *elem, *tmp;
+	struct raid_dev *rd;
+
+	list_for_each_safe(elem, tmp, LC_RD(lc)) {
+		rd = list_entry(elem, struct raid_dev, list);
+		_free_raid_dev(lc, &rd);
+	}
+}
+
+/* Free RAID device structure or all registered RAID devices if rd == NULL. */
+void free_raid_dev(struct lib_context *lc, struct raid_dev **rd)
+{
+	rd ? _free_raid_dev(lc, rd) : _free_raid_devs(lc);
+}
+
+/* Allocate/Free RAID set. */
+struct raid_set *alloc_raid_set(struct lib_context *lc, const char *who)
+{
+	struct raid_set *ret;
+
+	if ((ret = dbg_malloc(sizeof(*ret)))) {
+		INIT_LIST_HEAD(&ret->list);
+		INIT_LIST_HEAD(&ret->sets);
+		INIT_LIST_HEAD(&ret->devs);
+		ret->status = s_setup;
+		ret->type   = t_undef;
+	} else
+		log_alloc_err(lc, who);
+
+	return ret;
+}
+
+/* Free a single RAID set structure and its RAID devices. */
+static void _free_raid_set(struct lib_context *lc, struct raid_set *rs)
+{
+	struct raid_dev *rd;
+	struct list_head *elem, *tmp;
+
+	log_dbg(lc, "freeing devices of RAID set \"%s\"", rs->name);
+	list_for_each_safe(elem, tmp, &rs->devs) {
+		list_del(elem);
+		rd = RD(elem);
+
+		log_dbg(lc, "freeing device \"%s\", path \"%s\"",
+			rd->name, rd->di->path);
+
+		/* FIXME: remove partition code in favour of kpartx ? */
+		/*
+		 * Special case for partitioned sets.
+		 *
+		 * We don't hook dev_info structures for partitioned
+		 * sets up the global list, so delete them here.
+		 */
+		if (partitioned_set(lc, rs))
+			free_dev_info(lc, rd->di);
+
+		/*
+		 * We don't hook raid_dev structures for GROUP
+		 * sets up the global list, so delete them here.
+		 */
+		if (list_empty(&rd->list))
+			free_raid_dev(lc, &rd);
+	}
+
+	list_del(&rs->list);
+	dbg_free(rs->name);
+	dbg_free(rs);
+}
+
+/* Remove a set or all sets (in case rs = NULL) recursively. */
+void free_raid_set(struct lib_context *lc, struct raid_set *rs)
+{
+	struct list_head *elem, *tmp;
+
+	list_for_each_safe(elem, tmp, rs ? &rs->sets : LC_RS(lc))
+		free_raid_set(lc, RS(elem));
+
+	if (rs)
+		_free_raid_set(lc, rs);
+	else if (!list_empty(LC_RS(lc)))
+		log_fatal(lc, "lib context RAID set list not empty");
+}
+
+/* Return != 0 in case of a partitioned RAID set type. */
+int partitioned_set(struct lib_context *lc, void *rs)
+{
+	return T_PARTITION((struct raid_set*) rs);
+}
+
+/* Return != 0 in case of a partitioned base RAID set. */
+int base_partitioned_set(struct lib_context *lc, void *rs)
+{
+	return ((struct raid_set*) rs)->flags & f_partitions;
+}
+
+/* Return RAID set name. */
+const char *get_set_name(struct lib_context *lc, void *rs)
+{
+	return ((struct raid_set*) rs)->name;
+}
+
+/*
+ * Find RAID set by name.
+ *
+ * Search top level RAID set list only if where = FIND_TOP.
+ * Recursive if where = FIND_ALL.
+ */
+static struct raid_set *_find_set(struct lib_context *lc,
+				  struct list_head *list,
+				  const char *name, enum find where)
+{
+	struct raid_set *r, *ret = NULL;
+
+	log_dbg(lc, "%s: searching %s", __func__, name);
+	list_for_each_entry(r, list, list) {
+		if (!strcmp(r->name, name)) {
+			ret = r;
+			goto out;
+		}
+	}
+
+	if (where == FIND_ALL) {
+		list_for_each_entry(r, list, list) {
+			if ((ret = _find_set(lc, &r->sets, name, where)))
+				break;
+		}
+	}
+
+  out:
+	log_dbg(lc, "_find_set: %sfound %s", ret ? "" : "not ", name);
+
+	return ret;
+}
+
+struct raid_set *find_set(struct lib_context *lc,
+			  struct list_head *list,
+			  const char *name, enum find where)
+{
+	return _find_set(lc, list ? list : LC_RS(lc), name, where);
+}
+
+struct raid_set *find_or_alloc_raid_set(struct lib_context *lc,
+				char *name, enum find where,
+				struct raid_dev *rd,
+				struct list_head *list,
+				void (*f_create) (struct raid_set *super,
+						  void *private),
+				void *private)
+{
+	struct raid_set *rs;
+
+	if ((rs = find_set(lc, NULL, name, where)))
+		goto out;
+
+	if (!(rs = alloc_raid_set(lc, __func__)))
+		goto out;
+
+	if (!(rs->name = dbg_strdup(name)))
+		goto err;
+
+	if (rd && ((rs->type = rd->type), T_SPARE(rd)))
+		rs->type = t_undef;
+
+	/* If caller hands a list in, add to it. */
+	if (list)
+		list_add_tail(&rs->list, list);
+
+	/* Call any create callback. */
+	if (f_create)
+		f_create(rs, private);
+
+   out:
+	return rs;
+
+   err:
+	dbg_free(rs);
+	log_alloc_err(lc, __func__);
+
+	return NULL;
+}
+
+/* Return # of raid sets build */
+unsigned int count_sets(struct lib_context *lc, struct list_head *list)
+{
+	int ret = 0;
+	struct list_head *elem;
+
+	list_for_each(elem, list)
+		ret++;
+
+	return ret;
+}
+
+/*
+ * Count devices found
+ */
+static unsigned int _count_devices(struct lib_context *lc, enum dev_type type)
+{
+	unsigned int ret = 0;
+	struct list_head *elem, *list;
+
+	if (DEVICE & type)
+		list = LC_DI(lc);
+	else if (((RAID|NATIVE) & type))
+		list = LC_RD(lc);
+	else
+		return 0;
+	
+	list_for_each(elem, list)
+			ret++;
+
+	return ret;
+}
+
+unsigned int count_devices(struct lib_context *lc, enum dev_type type)
+{
+	return type == SET ? count_sets(lc, LC_RS(lc)) :
+			     _count_devices(lc, type);
+}
+
+/*
+ * Read RAID metadata off a device by trying
+ * all/selected registered format handlers in turn.
+ */
+static int _want_format(struct dmraid_format *fmt, const char *format,
+			enum fmt_type type)
+{
+	return fmt->format != type ||
+	       (format && strncmp(format, fmt->name, strlen(format))) ? 0 : 1;
+}
+
+static struct raid_dev *_dmraid_read(struct lib_context *lc,
+				       struct dev_info *di,
+				       struct dmraid_format *fmt)
+{
+	struct raid_dev *rd;
+
+	log_notice(lc, "%s: %-7s discovering", di->path, fmt->name);
+	if ((rd = fmt->read(lc, di))) {
+		log_notice(lc, "%s: %s metadata discovered",
+			   di->path, fmt->name);
+		rd->fmt = fmt;
+	}
+
+	return rd;
+}
+
+static struct raid_dev *dmraid_read(struct lib_context *lc,
+				      struct dev_info *di, char const *format,
+				      enum fmt_type type)
+{
+	struct format_list *fl;
+	struct raid_dev *rd = NULL, *rd_tmp;
+
+	/* FIXME: dropping multiple formats ? */
+	list_for_each_entry(fl, LC_FMT(lc), list) {
+		if (_want_format(fl->fmt, format, type) &&
+		    (rd_tmp = _dmraid_read(lc, di, fl->fmt))) {
+			if (rd) {
+				log_print(lc, "%s: \"%s\" and \"%s\" formats "
+					  "discovered (using %s)!",
+					  di->path, rd_tmp->fmt->name,
+					  rd->fmt->name, rd->fmt->name);
+				free_raid_dev(lc, &rd_tmp);
+			} else
+				rd = rd_tmp;
+		}
+	}
+
+	return rd;
+}
+
+/*
+ * Write RAID metadata to a device.
+ */
+static int dmraid_write(struct lib_context *lc,
+			struct raid_dev *rd, int erase)
+{
+	int ret = 0;
+	struct dmraid_format *fmt = rd->fmt;
+
+	if (fmt->write) {
+		log_notice(lc, "%sing metadata %s %s",
+			   erase ? "Eras" : "Writ",
+			   erase ? "on" : "to",
+			   rd->di->path);
+		ret = fmt->write(lc, rd, erase);
+	} else
+		log_err(lc, "format \"%s\" doesn't support writing metadata",
+			fmt->name);
+
+	return ret;
+}
+
+/*
+ * Group RAID device into a RAID set.
+ */
+static inline struct raid_set *dmraid_group(struct lib_context *lc,
+					    struct raid_dev *rd)
+{
+	return rd->fmt->group(lc, rd);
+}
+
+/* Check that device names are members of the devices list. */
+static int _want_device(struct dev_info *di, char **devices)
+{
+	char **dev;
+
+	if (!devices || !*devices)
+		return 1;
+
+	for (dev = devices; *dev; dev++) {
+		if (!strcmp(*dev, di->path))
+			return 1;
+	}
+
+	return 0;
+}
+
+/* Discover RAID devices. */
+void discover_raid_devices(struct lib_context *lc, char **devices)
+{
+	struct dev_info *di;
+	char *names = NULL;
+	const char delim = *OPT_STR_SEPARATOR(lc);
+
+	/* In case we've got format identifiers -> duplicate string for loop. */
+	if (OPT_FORMAT(lc) &&
+	    (!(names = dbg_strdup((char*) OPT_STR_FORMAT(lc))))) {
+		log_alloc_err(lc, __func__);
+		return;
+	}
+
+	/* Walk the list of discovered block devices. */
+	list_for_each_entry(di, LC_DI(lc), list) {
+		if (_want_device(di, devices)) {
+			char *p, *sep = names;
+			struct raid_dev *rd;
+
+			do {
+				p = sep;
+				sep = remove_delimiter(sep, delim);
+
+				if ((rd = dmraid_read(lc, di, p, FMT_RAID)))
+					list_add_tail(&rd->list, LC_RD(lc));
+
+				add_delimiter(&sep, delim);
+			} while (sep);
+		}
+	}
+
+	if (names)
+		dbg_free(names);
+}
+
+/*
+ * Discover partitions on RAID sets.
+ *
+ * FIXME: remove partition code in favour of kpartx ?
+ */
+static void _discover_partitions(struct lib_context *lc,
+				 struct list_head *rs_list)
+{
+	char *path;
+	struct dev_info *di;
+	struct raid_dev *rd;
+	struct raid_set *rs, *r;
+
+	list_for_each_entry(rs, rs_list, list) {
+		/*
+		 * t_group type RAID sets are never active!
+		 * (They are containers for subsets to activate)
+		 *
+		 * Recurse into them.
+		 */
+		if (T_GROUP(rs)) {
+			_discover_partitions(lc, &rs->sets);
+			return;
+		}
+
+		/*
+		 * Skip all "container" sets, which are not active.
+		 */
+		if (base_partitioned_set(lc, rs) ||
+		    partitioned_set(lc, rs) ||
+		    !dm_status(lc, rs))
+			continue;
+
+		log_notice(lc, "discovering partitions on \"%s\"", rs->name);
+		if (!(path = mkdm_path(lc, rs->name)))
+			return;
+
+		/* Allocate a temporary disk info struct for dmraid_read(). */
+		di = alloc_dev_info(lc, path);
+		dbg_free(path);
+		if (!di)
+			return;
+
+		di->sectors = total_sectors(lc, rs);
+		if (!(rd = dmraid_read(lc, di, NULL, FMT_PARTITION))) {
+			free_dev_info(lc, di);
+			continue;
+		}
+
+		/*
+		 * WARNING: partition group function returns
+		 * a dummy pointer because of the creation of multiple
+		 * RAID sets (one per partition) it does.
+		 *
+		 * We don't want to access that 'pointer'!
+		 */
+		if ((r = dmraid_group(lc, rd))) {
+			log_notice(lc, "created partitioned RAID set(s) for %s",
+				   di->path);
+			rs->flags |= f_partitions;
+		} else
+			log_err(lc, "adding %s to RAID set", di->path);
+
+		/*
+		 * Free the RD. We don't need it any more, because we
+		 * don't support writing partition tables.
+		 */
+		free_dev_info(lc, di);
+		free_raid_dev(lc, &rd);
+	}
+}
+
+void discover_partitions(struct lib_context *lc)
+{
+	_discover_partitions(lc, LC_RS(lc));
+}
+
+/*
+ * Group RAID set(s)
+ *
+ *	name = NULL  : build all sets
+ *	name = String: build just the one set
+ */
+static void want_set(struct lib_context *lc, struct raid_set *rs, char *name)
+{
+	if (name) {
+		size_t len1 = strlen(rs->name), len2 = strlen(name);
+
+		if (len2 > len1 ||
+		    strncmp(rs->name, name, min(len1, len2))) {
+			log_notice(lc, "dropping unwanted RAID set \"%s\"",
+				   rs->name);
+			free_raid_set(lc, rs);
+		}
+	}
+}
+
+/* Get format handler of RAID set. */
+struct dmraid_format *get_format(struct raid_set *rs)
+{
+	/* Decend RAID set hierarchy. */
+	while (SETS(rs))
+		rs = RS_RS(rs);
+
+	return DEVS(rs) ? (RD_RS(rs))->fmt : NULL;
+}
+
+/* Check metadata consistency of raid sets. */
+static void check_raid_sets(struct lib_context *lc)
+{
+	struct list_head *elem, *tmp;
+	struct raid_set *rs;
+	struct dmraid_format *fmt;
+
+	list_for_each_safe(elem, tmp, LC_RS(lc)) {
+		if (!(fmt = get_format((rs = RS(elem)))))
+			continue;
+
+		if (!fmt->check(lc, rs)) {
+			/*
+			 * FIXME: check needed if degraded activation
+			 *        is sensible.
+			 */
+			if (T_RAID1(rs))
+				log_err(lc, "keeping degraded mirror "
+					"set \"%s\"", rs->name);
+			else {
+				log_err(lc, "removing inconsistent RAID "
+					"set \"%s\"", rs->name);
+				free_raid_set(lc, rs);
+			}
+		}
+	}
+
+	return;
+}
+
+int group_set(struct lib_context *lc, char *name)
+{
+	struct raid_dev *rd;
+	struct raid_set *rs;
+
+	if (name && find_set(lc, NULL, name, FIND_TOP))
+		LOG_ERR(lc, 0, "RAID set %s already exists", name);
+
+	list_for_each_entry(rd, LC_RD(lc), list) {
+		/* FIXME: optimize dropping of unwanted RAID sets. */
+		if ((rs = dmraid_group(lc, rd))) {
+			log_notice(lc, "added %s to RAID set \"%s\"",
+				   rd->di->path, rs->name);
+			want_set(lc, rs, name);
+			continue;
+		}
+
+		if (!T_SPARE(rd))
+			log_err(lc, "adding %s to RAID set \"%s\"",
+				rd->di->path, rd->name);
+
+		/* Need to find the set and remove it. */
+		if ((rs = find_set(lc, NULL, rd->name, FIND_ALL))) {
+			log_err(lc, "removing RAID set \"%s\"", rs->name);
+			free_raid_set(lc, rs);
+		}
+	}
+
+	/* Check sanity of grouped RAID sets. */
+	check_raid_sets(lc);
+
+	return 1;
+}
+
+/* Process function on RAID set(s) */
+static void process_set(struct lib_context *lc, void *rs,
+			int (*func)(struct lib_context *lc, void *rs, int arg),
+			int arg)
+{
+	if (!partitioned_set(lc, rs))
+		func(lc, rs, arg);
+}
+
+/* FIXME: remove partition code in favour of kpartx ? */
+static void
+process_partitioned_set(struct lib_context *lc, void *rs,
+			int (*func)(struct lib_context *lc, void *rs, int arg),
+			int arg)
+{
+	if (partitioned_set(lc, rs) && !base_partitioned_set(lc, rs))
+		func(lc, rs, arg);
+}
+
+void process_sets(struct lib_context *lc,
+		  int (*func)(struct lib_context *lc, void *rs, int arg),
+		  int arg, enum set_type type)
+{
+	struct raid_set *rs;
+	void (*p)(struct lib_context *l, void *r,
+		  int (*f)(struct lib_context *lc, void *rs, int arg), int a) =
+		(type == PARTITIONS) ? process_partitioned_set : process_set;
+
+	list_for_each_entry(rs, LC_RS(lc), list)
+		p(lc, rs, func, arg);
+}
+
+/* Write RAID set metadata to devices. */
+int write_set(struct lib_context *lc, void *v)
+{
+	int ret = 1;
+	struct raid_set *r, *rs = v;
+	struct raid_dev *rd;
+
+	/* Decend hierarchy */
+	list_for_each_entry(r, &rs->sets, list) {
+		/*
+		 * FIXME: does it make sense to try the rest of the subset
+		 *	  in case we fail writing one ?
+		 */
+		if (!write_set(lc, (void*) r))
+			log_err(lc, "writing RAID subset \"%s\", continuing",
+				r->name);
+	}
+
+	/* Write metadata to the RAID devices of a set. */
+	list_for_each_entry(rd, &rs->devs, devs) {
+		/*
+		 * FIXME: does it make sense to try the rest of the
+		 *	  devices in case we fail writing one ?
+		 */
+		if (!dmraid_write(lc, rd, 0)) {
+			log_err(lc, "writing RAID device \"%s\", continuing",
+				rd->di->path);
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+/* Erase ondisk metadata. */
+int erase_metadata(struct lib_context *lc)
+{
+	int ret = 1;
+	struct raid_dev *rd;
+
+	list_for_each_entry(rd, LC_RD(lc), list) {
+		if (yes_no_prompt(lc, "Do you really want to erase \"%s\" "
+				  "ondisk metadata on %s",
+				  rd->fmt->name, rd->di->path) &&
+		    !dmraid_write(lc, rd, 1)) {
+			log_err(lc, "erasing ondisk metadata on %s",
+				rd->di->path);
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Support function for metadata format handlers:
+ *
+ * Return neutralized RAID type for given mapping array (linear, raid0, ...)
+ */
+enum type rd_type(struct types *t, unsigned int type)
+{
+	for (; t->type != type && t->unified_type != t_undef; t++);
+
+	return t->unified_type;
+}
+
+/*
+ * Support function for metadata format handlers.
+ *
+ * Sort a an element into a list by optionally
+ * using a metadata format handler helper function.
+ */
+void list_add_sorted(struct lib_context *lc,
+		     struct list_head *to, struct list_head *new,
+		     int (*f_sort)(struct list_head *pos,
+				   struct list_head *new))
+{
+	struct list_head *pos;
+
+	list_for_each(pos, to) {
+		/*
+		 * Add in at the beginning of the list
+		 * (ie., after HEAD or the first entry we found),
+		 * or where the metadata format handler sort
+		 * function tells us to.
+		 */
+		if (!f_sort || f_sort(pos, new))
+			break;
+	}
+
+	/*
+	 * If we get here we either had an empty list or the sort
+	 * function hit or not -> add where pos tells us to.
+	 */
+	list_add_tail(new, pos);
+}
+
+/*
+ * Support function for format handlers:
+ *
+ * File RAID metadata and offset on device for analysis.
+ */
+/* FIXME: all files into one directory ? */
+static size_t __name(struct lib_context *lc, char *str, size_t len, char *path,
+		     const char *suffix, const char *handler)
+{
+	return snprintf(str, len, "%s_%s.%s",
+			get_basename(lc, path), handler, suffix) + 1;
+}
+
+static char *_name(struct lib_context *lc, char *path,
+		  const char *suffix, const char *handler)
+{
+	size_t len;
+	char *ret;
+
+	if ((ret = dbg_malloc((len = __name(lc, NULL, 0, path,
+					    suffix, handler)))))
+		__name(lc, ret, len, path, suffix, handler);
+	else
+		log_alloc_err(lc, __func__);
+
+	return ret;
+}
+
+static int file_data(struct lib_context *lc, const char *handler,
+		     char *path, void *data, size_t size)
+{
+	int ret = 0;
+	char *name;
+
+	if ((name = _name(lc, path, "dat", handler))) {
+		log_notice(lc, "writing metadata file \"%s\"", name);
+		ret = write_file(lc, handler, name, data, size, 0);
+		dbg_free(name);
+	}
+
+	return ret;
+}
+
+static void file_number(struct lib_context *lc, const char *handler,
+			char *path, uint64_t number, const char *suffix)
+{
+	char *name, s_number[32];
+	
+	if ((name = _name(lc, path, suffix, handler))) {
+		log_notice(lc, "writing %s to file \"%s\"", suffix, name);
+		write_file(lc, handler, name, (void*) s_number,
+		           snprintf(s_number, sizeof(s_number),
+			   "%" PRIu64 "\n", number),
+				 0);
+		dbg_free(name);
+	}
+}
+
+/*
+ * File vendor RAID metadata.
+ */
+void file_metadata(struct lib_context *lc, const char *handler,
+		   char *path, void *data, size_t size, uint64_t offset)
+{
+	if (OPT_DUMP(lc) &&
+	    file_data(lc, handler, path, data, size))
+		file_number(lc, handler, path, offset, "offset");
+}
+
+/*
+ * File RAID device size.
+ */
+void file_dev_size(struct lib_context *lc, const char *handler,
+		   struct dev_info *di)
+{
+	if (OPT_DUMP(lc))
+		file_number(lc, handler, di->path, di->sectors, "size");
+}
/cvs/dm/dmraid/lib/misc/file.c,v  -->  standard output
revision 1.1
--- dmraid/lib/misc/file.c
+++ -	2008-02-22 16:57:43.597523000 +0000
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <errno.h>
+#include "internal.h"
+
+/* Create directory recusively. */
+static int mk_dir_recursive(struct lib_context *lc, const char *dir)
+{
+	int ret = 1;
+        char *orig, *s;
+	const char delim = '/';
+
+        if (!(orig = s = dbg_strdup((char*) dir)))
+		return log_alloc_err(lc, __func__);
+
+        /* Create parent directories */
+        log_notice(lc, "creating directory %s", dir);
+	do {
+		s = remove_delimiter(s + 1, delim);
+		if (mkdir(orig, 0777) && errno != EEXIST) {
+			log_err(lc, "mkdir %s", orig);
+			ret = 0;
+			break;
+		}
+
+		add_delimiter(&s, delim);
+	} while (s);
+
+	dbg_free(orig);
+
+        return ret;
+}
+
+/* Create directory. */
+int mk_dir(struct lib_context *lc, const char *dir)
+{
+	struct stat info;
+
+	/* If it doesn't exist yet, make it. */
+	if (stat(dir, &info))
+		return mk_dir_recursive(lc, dir);
+
+	if (S_ISDIR(info.st_mode))
+		return 1;
+
+	LOG_ERR(lc, 0, "directory %s not found", dir);
+}
+
+static int rw_file(struct lib_context *lc, const char *who, int flags,
+		   char *path, void *buffer, size_t size, loff_t offset)
+{
+	int fd, ret = 0;
+	loff_t o;
+	struct {
+		ssize_t (*func)();
+		const char *what;
+	} rw_spec[] = {
+		{ read,  "read" },
+		{ write, "writ" },
+	}, *rw = rw_spec + ((flags & O_WRONLY) ? 1 : 0);
+
+	if ((fd = open(path, flags, lc->mode)) == -1)
+		LOG_ERR(lc, 0, "opening \"%s\"", path);
+
+#ifdef __KLIBC__
+#define	DMRAID_LSEEK	lseek
+#else
+#define	DMRAID_LSEEK	lseek64
+#endif
+	if (offset && (o = DMRAID_LSEEK(fd, offset, SEEK_SET)) == (loff_t) -1)
+		log_err(lc, "%s: seeking device \"%s\" to %" PRIu64,
+			who, path, offset);
+	else if (rw->func(fd, buffer, size) != size)
+		log_err(lc, "%s: %sing %s[%s]", who, rw->what,
+			path, strerror(errno));
+	else
+		ret = 1;
+
+	close(fd);
+
+	return ret;
+}
+
+int read_file(struct lib_context *lc, const char *who, char *path,
+	      void *buffer, size_t size, loff_t offset)
+{
+	return rw_file(lc, who, O_RDONLY, path, buffer, size, offset);
+}
+
+int write_file(struct lib_context *lc, const char *who, char *path,
+	       void *buffer, size_t size, loff_t offset)
+{
+	/* O_CREAT|O_TRUNC are noops on a devnode. */
+	return rw_file(lc, who, O_WRONLY|O_CREAT|O_TRUNC, path,
+		       buffer, size, offset);
+}
/cvs/dm/dmraid/lib/misc/init.c,v  -->  standard output
revision 1.1
--- dmraid/lib/misc/init.c
+++ -	2008-02-22 16:57:43.738543000 +0000
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include "internal.h"
+
+/* Library initialization. */
+struct lib_context *libdmraid_init(int argc, char **argv)
+{
+	struct lib_context *lc;
+
+	if ((lc = alloc_lib_context(argv))) {
+		if (!register_format_handlers(lc)) {
+			libdmraid_exit(lc);
+			lc = NULL;
+		} else
+			/* FIXME: do we need this forever ? */
+			sysfs_workaround(lc);
+	}
+
+	return lc;
+}
+
+/* Library exit processing. */
+void libdmraid_exit(struct lib_context *lc)
+{
+	free_raid_set(lc, NULL);	/* Free all RAID sets. */
+	free_raid_dev(lc, NULL);	/* Free all RAID devices. */
+	free_dev_info(lc, NULL);	/* Free all disk infos. */
+	unregister_format_handlers(lc);	/* Unregister all format handlers. */
+	free_lib_context(lc);		/* Release library context. */
+}
/cvs/dm/dmraid/lib/misc/lib_context.c,v  -->  standard output
revision 1.1
--- dmraid/lib/misc/lib_context.c
+++ -	2008-02-22 16:57:43.841458000 +0000
@@ -0,0 +1,189 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <stdarg.h>
+#include "internal.h"
+#include "version.h"
+
+/* Options access functions. */
+static inline int lc_opt_ok(enum lc_options o)
+{
+	return o < LC_OPTIONS_SIZE;
+}
+
+int lc_opt(struct lib_context *lc, enum lc_options o)
+{
+	return lc_opt_ok(o) ? lc->options[o].opt : 0;
+}
+
+static int _inc_opt(struct lib_context *lc, int o)
+{
+	return lc->options[o].opt < UCHAR_MAX ? ++lc->options[o].opt :
+					       lc->options[o].opt;
+}
+
+int lc_inc_opt(struct lib_context *lc, int o)
+{
+	return lc_opt_ok(o) ? _inc_opt(lc, o) : 0;
+}
+
+const char *lc_strcat_opt(struct lib_context *lc, enum lc_options o,
+			  char *arg, const char delim)
+{
+	char *ret = NULL;
+
+	if (lc_opt_ok(o)) {
+		char *a = (char*) OPT_STR(lc, o);
+		size_t end = (a ? strlen(a) : 0),
+		       len = end + strlen(arg) + ((delim && end) ? 1 : 0) + 1;
+
+		/* Dup new one. */
+		if ((ret = dbg_realloc(a, len))) {
+			if (delim && end)
+				ret[end++] = delim;
+
+			ret[end] = 0;
+			strcat(ret, arg);
+			OPT_STR(lc, o) = ret;
+		} else {
+			dbg_free((char*) OPT_STR(lc, o));
+			OPT_STR(lc, o) = ret;
+			log_alloc_err(lc, __func__);
+		}
+	}
+
+	return ret;
+}
+
+const char *lc_stralloc_opt(struct lib_context *lc, enum lc_options o,
+			    char *arg)
+{
+	if (lc_opt_ok(o)) {
+		/* Free any already allocated one. */
+		if (OPT_STR(lc, o))
+			dbg_free((char*) OPT_STR(lc, o));
+
+		/* Dup new one. */
+		if ((OPT_STR(lc, o) = dbg_strdup(arg)))
+			return OPT_STR(lc, o);
+
+		log_alloc_err(lc, __func__);
+	}
+
+	return NULL;
+}
+
+const char *lc_opt_arg(struct lib_context *lc, enum lc_options o)
+{
+	return lc_opt_ok(o) ? lc->options[o].arg.str : NULL;
+}
+
+struct list_head *lc_list(struct lib_context *lc, int l)
+{
+	return l < ARRAY_SIZE(lc->lists) ? lc->lists + l : NULL;
+}
+
+/*
+ * Library context initialization functions.
+ */
+static void init_options(struct lib_context *lc, void *arg)
+{
+	lc_inc_opt(lc, LC_SEPARATOR);
+	lc->options[LC_SEPARATOR].arg.str = dbg_strdup((char*) ",");
+}
+
+static void init_cmd(struct lib_context *lc, void *arg)
+{
+	lc->cmd = get_basename(lc, ((char**) arg)[0]);
+}
+
+static void init_lists(struct lib_context *lc, void *arg)
+{
+	unsigned int i = LC_LISTS_SIZE;
+
+	while (i--)
+		INIT_LIST_HEAD(lc->lists + i);
+}
+
+static void init_mode(struct lib_context *lc, void *arg)
+{
+	lc->mode = 0600;
+}
+
+static void init_paths(struct lib_context *lc, void *arg)
+{
+	lc->path.error = "/dev/zero";
+}
+
+/* FIXME: add lib flavour info (e.g., DEBUG). */
+static void init_version(struct lib_context *lc, void *arg)
+{
+	lc->version.text	= DMRAID_LIB_VERSION;
+	lc->version.date	= DMRAID_LIB_DATE;
+	lc->version.v.major	= DMRAID_LIB_MAJOR_VERSION;
+	lc->version.v.minor	= DMRAID_LIB_MINOR_VERSION;
+	lc->version.v.sub_minor	= DMRAID_LIB_SUBMINOR_VERSION;
+	lc->version.v.suffix	= DMRAID_LIB_VERSION_SUFFIX;
+}
+
+/* Put init functions into an array because of the potentially growing list. */
+struct init_fn {
+	void (*func)(struct lib_context *lc, void *arg);
+} init_fn[] = {
+	{ init_options },
+	{ init_cmd },
+	{ init_lists },
+	{ init_mode },
+	{ init_paths },
+	{ init_version },
+};
+
+struct lib_context *alloc_lib_context(char **argv)
+{
+	struct lib_context *lc;
+	struct init_fn *f;
+
+	if ((lc = dbg_malloc(sizeof(*lc)))) {
+		for (f = init_fn; f < ARRAY_END(init_fn); f++)
+			f->func(lc, argv);
+#ifdef	DEBUG_MALLOC
+		/*
+		 * Set DEBUG flag in case of memory debugging so that we
+		 * see messages even before the command line gets parsed.
+		 */
+		lc_inc_opt(lc, LC_DEBUG);
+#endif
+
+	} else
+		fprintf(stderr, "allocating library context\n");
+
+	return lc;
+}
+
+void free_lib_context(struct lib_context *lc)
+{
+	int o;
+
+	for (o = 0; o < LC_OPTIONS_SIZE; o++) {
+		if (lc->options[o].arg.str)
+			dbg_free ((char*) lc->options[o].arg.str);
+	}
+
+	dbg_free(lc);
+}
+
+/* Return library date (ASCII). */
+const char *libdmraid_date(struct lib_context *lc)
+{
+	return lc->version.date;
+}
+
+/* Return library version (ASCII). */
+const char *libdmraid_version(struct lib_context *lc)
+{
+	return lc->version.text;
+}
/cvs/dm/dmraid/lib/misc/misc.c,v  -->  standard output
revision 1.1
--- dmraid/lib/misc/misc.c
+++ -	2008-02-22 16:57:43.936402000 +0000
@@ -0,0 +1,224 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <stdarg.h>
+#include "internal.h"
+
+/* Prompt for a yes/no answer */
+int yes_no_prompt(struct lib_context *lc, const char *prompt, ...)
+{
+	int c = '\n';
+	va_list ap;
+
+	/* Use getc() for klibc compatibility. */
+	do {
+		if (c == '\n') {
+			va_start(ap, prompt);
+			vprintf(prompt, ap);
+			va_end(ap);
+			log_print_nnl(lc, " ? [y/n] :");
+		}
+	} while ((c = tolower(getc(stdin))) && c != 'y' && c != 'n');
+
+	/* Ignore rest. */
+	while (getc(stdin) != '\n');
+
+	return c == 'y';
+}
+
+/* Return the basename of a path. */
+char *get_basename(struct lib_context *lc, char *str)
+{
+	char *ret = strrchr(str, '/');
+
+	return ret ? ++ret : str;
+}
+
+/* Return the dirname of a path. */
+char *get_dirname(struct lib_context *lc, char *str)
+{
+	char *ret = strrchr(str, '/');
+	size_t len = ret ? ret - str : strlen(str);
+
+	if ((ret = dbg_malloc(len + 1)))
+		strncpy(ret, str, len);
+
+	return ret;
+}
+
+/* Convert a numeric string to alpha. */
+void mk_alpha(struct lib_context *lc, char *str, size_t len)
+{
+	for (; len && *str; len--, str++) {
+		if (isdigit(*str))
+			*str += 'a' - '0';
+	}
+}
+
+/* Remove any whitespace from a string. */
+char *remove_white_space(struct lib_context *lc, char *str, size_t size)
+{
+	int c;
+	char *in = str, *out = str;
+
+	in[size] = 0;
+	while ((c = *in++)) {
+		if (!isspace(c))
+			*out++ = c;
+	}
+	*out = 0;
+
+	return str;
+
+}
+
+/* Remove/add a delimiter character. */
+char *remove_delimiter(char *ptr, char c)
+{
+	char *ret = NULL;
+
+	if (ptr && (ret = strchr(ptr, (int) c)))
+		*ret = 0;
+
+	return ret; 
+}
+
+void add_delimiter(char **ptr, char c)
+{
+	if (ptr && *ptr) {
+		**ptr = c;
+		(*ptr)++;
+	}
+}
+
+/* Grow a string. */
+static int grow_string(struct lib_context *lc, char **string, const char *s)
+{
+	size_t len;
+	char *tmp = *string;
+
+ 	len = strlen(s) + (tmp ? strlen(tmp) + 1 : 1);
+	if ((*string = dbg_realloc(tmp, len))) {
+		if (!tmp)
+			**string = '\0';
+	} else if (tmp)
+		dbg_free(tmp);
+	
+	return *string ? 1 : 0;
+}
+
+/* Free a string. */
+void free_string(struct lib_context *lc, char **string)
+{
+	if (*string) {
+		dbg_free(*string);
+		*string = NULL;
+	}
+}
+
+/* Push a string onto the end of another. */
+static int p_str(struct lib_context *lc, char **string, const char *s)
+{
+	int ret;
+
+	if ((ret = grow_string(lc, string, s)))
+		strcat (*string, s);
+
+	return ret;
+}
+
+/* Push a string defined by a start and end pointer onto the end of another. */
+static int p_str_str(struct lib_context *lc, char **string,
+		     char *begin, char *end)
+{
+	if (end == begin)
+		return 1;
+
+	*end = 0;
+
+	return p_str(lc, string, begin);
+}
+
+/* Push an uint64_t in ascii onto the end of a string. */
+static int p_u64(struct lib_context *lc, char **string, const uint64_t u)
+{
+	char buffer[22];
+
+	sprintf(buffer, "%" PRIu64, u);
+
+	return p_str(lc, string, buffer);
+}
+
+/* Push an uint_t in ascii onto the end of a string. */
+static int p_u(struct lib_context *lc, char **string, const unsigned int u)
+{
+	return p_u64(lc, string, (uint64_t) u);
+}
+
+/* Push an uint_t in ascii onto the end of a string. */
+static int p_d(struct lib_context *lc, char **string, const int d)
+{
+	char buffer[12];
+
+	sprintf(buffer, "%d", d);
+
+	return p_str(lc, string, buffer);
+}
+
+/* Push a format string defined list of arguments onto a string. */
+int p_fmt(struct lib_context *lc, char **string, const char *fmt, ...)
+{
+	int ret = 1;
+	char *b, *f, *f_sav;
+	va_list ap;
+	
+	if (!(f = f_sav = dbg_strdup((char *) fmt)))
+		return 0;
+
+	va_start(ap, fmt);
+	while (ret && *(b = f++)) {
+		if (!(f = strchr(b, '%'))) {
+			/* No '%' -> just print string. */
+			ret = p_str(lc, string, b);
+			break;
+		}
+
+		if (!(ret = p_str_str(lc, string, b, f)))
+			break;
+
+		switch (*++f) {
+		case 'd':
+			ret = p_d(lc, string, va_arg(ap, int));
+			break;
+
+		case 's':
+			ret = p_str(lc, string, va_arg(ap, char *));
+			break;
+	
+		case 'u':
+			ret = p_u(lc, string, va_arg(ap, unsigned int));
+			break;
+
+		case 'U':
+			ret = p_u64(lc, string, va_arg(ap, uint64_t));
+			break;
+
+		default:
+			log_err(lc, "%s: unknown format identifier %%%c",
+				__func__, *f);
+			free_string(lc, string);
+			ret = 0;
+		}
+
+		f++;
+	}
+
+	va_end(ap);
+	dbg_free(f_sav);
+
+	return ret;
+}
/cvs/dm/dmraid/lib/misc/workaround.c,v  -->  standard output
revision 1.1
--- dmraid/lib/misc/workaround.c
+++ -	2008-02-22 16:57:44.048902000 +0000
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <paths.h>
+#include "internal.h"
+
+/*
+ * OUCH (nasty hack).
+ *
+ * Need to open /dev/hd? in turn in order to
+ * populate /sys/block in case of IDE module
+ * load because of asynchronuous registration !?
+ */
+void sysfs_workaround(struct lib_context *lc)
+{
+	int d, fd;
+	size_t len;
+	char *dev;
+
+	if (!(dev = dbg_malloc(sizeof(_PATH_DEV) + 4)))
+		LOG_ERR(lc, , "sysfs workaround");
+
+	sprintf(dev, "%shd?", _PATH_DEV);
+	for (len = strlen(dev) - 1, d = 'a'; d <= 'z'; d++) {
+		dev[len] = (char) d;
+
+		if (!removable_device(lc, dev) &&
+		    (fd = open (dev, O_RDONLY)) != -1)
+			close (fd);
+	}
+
+	dbg_free(dev);
+}
/cvs/dm/dmraid/lib/mm/dbg_malloc.c,v  -->  standard output
revision 1.1
--- dmraid/lib/mm/dbg_malloc.c
+++ -	2008-02-22 16:57:44.139828000 +0000
@@ -0,0 +1,116 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#include <string.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <stdint.h>
+#include "dbg_malloc.h"
+#include "log/log.h"
+
+static void *__dbg_malloc(size_t size, int init)
+{
+	void *ret = malloc(size);
+
+	if (init && ret)
+		memset(ret, 0, size);
+
+	return ret;
+}
+
+#ifdef	DEBUG_MALLOC
+
+void *_dbg_malloc(size_t size, struct lib_context *lc,
+		  const char *who, unsigned int line)
+{
+	void *ret = __dbg_malloc(size, 1);
+
+	log_dbg(lc, "%s: dbg_malloc(%zu) at line %u returned 0x%x",
+		(char*) who, size, line, (unsigned long) ret);
+
+	return ret;
+}
+
+void *_dbg_realloc(void *ptr, size_t size, struct lib_context *lc,
+		   const char *who, unsigned int line)
+{
+	void *ret = realloc(ptr, size);
+
+	log_dbg(lc, "%s: dbg_realloc(0x%x, %zu) at line %u returned 0x%x",
+		(char*) who, (unsigned long) ptr, size, line,
+		(unsigned long) ret);
+
+	return ret;
+}
+
+void *_dbg_strndup(void *ptr, size_t len, struct lib_context *lc,
+		   const char *who, unsigned int line)
+{
+	char *ret;
+
+	if ((ret = __dbg_malloc(len + 1, 0))) {
+		ret[len] = 0;
+		strncpy(ret, ptr, len);
+	}
+
+	log_dbg(lc, "%s: dbg_strndup(0x%x) at line %u returned 0x%x",
+		(char*) who, (unsigned long) ptr, line, (unsigned long) ret);
+
+	return ret;
+
+}
+
+void *_dbg_strdup(void *ptr, struct lib_context *lc,
+		  const char *who, unsigned int line)
+{
+	return _dbg_strndup(ptr, strlen(ptr), lc, who, line);
+}
+
+
+void _dbg_free(void *ptr, struct lib_context *lc,
+	       const char *who, unsigned int line)
+{
+	log_dbg(lc, "%s: dbg_free(0x%x) at line %u",
+		(char*) who, (unsigned long) ptr, line);
+	free(ptr);
+}
+
+#else
+
+void *_dbg_malloc(size_t size)
+{
+	return __dbg_malloc(size, 1);
+}
+
+void *_dbg_realloc(void *ptr, size_t size)
+{
+	return realloc(ptr, size);
+}
+
+void *_dbg_strndup(void *ptr, size_t len)
+{
+	char *ret;
+
+	if ((ret = __dbg_malloc(len + 1, 0))) {
+		ret[len] = 0;
+		strncpy(ret, ptr, len);
+	}
+
+	return ret;
+}
+
+void *_dbg_strdup(void *ptr)
+{
+	return _dbg_strndup(ptr, strlen(ptr));
+}
+
+void _dbg_free(void *ptr)
+{
+	free(ptr);
+}
+
+#endif /* #ifdef DEBUG_MALLOC */
/cvs/dm/dmraid/lib/mm/dbg_malloc.h,v  -->  standard output
revision 1.1
--- dmraid/lib/mm/dbg_malloc.h
+++ -	2008-02-22 16:57:44.228438000 +0000
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _DBG_MALLOC_H_
+#define _DBG_MALLOC_H_
+
+#include <stdio.h>
+#include <sys/types.h>
+
+#ifdef	DEBUG_MALLOC
+
+struct lib_context;
+void *_dbg_malloc(size_t size, struct lib_context *lc,
+		  const char *who, unsigned int line);
+void *_dbg_realloc(void *ptr, size_t size, struct lib_context *lc,
+		   const char *who, unsigned int line);
+void *_dbg_strdup(void *ptr, struct lib_context *lc,
+		  const char *who, unsigned int line);
+void *_dbg_strndup(void *ptr, size_t len, struct lib_context *lc,
+		   const char *who, unsigned int line);
+void _dbg_free(void *ptr, struct lib_context *lc,
+	       const char *who, unsigned int line);
+
+#define	dbg_malloc(size)	_dbg_malloc((size), lc, __func__, __LINE__)
+#define	dbg_realloc(ptr, size)	_dbg_realloc((ptr), (size), lc, \
+					     __func__, __LINE__)
+#define	dbg_strdup(ptr)		_dbg_strdup((ptr), lc, __func__, __LINE__)
+#define	dbg_strndup(ptr, len)	_dbg_strdup((ptr), len, lc, __func__, __LINE__)
+#define	dbg_free(ptr)		_dbg_free((ptr), lc, __func__, __LINE__)
+
+#else
+
+void *_dbg_malloc(size_t size);
+void *_dbg_realloc(void *ptr, size_t size);
+void *_dbg_strdup(void *ptr);
+void *_dbg_strndup(void *ptr, size_t len);
+void _dbg_free(void *ptr);
+
+#define	dbg_malloc	_dbg_malloc
+#define	dbg_realloc	_dbg_realloc
+#define	dbg_strdup	_dbg_strdup
+#define	dbg_strndup	_dbg_strndup
+#define	dbg_free	_dbg_free
+
+#endif /* #ifdef DEBUG_MALLOC */
+
+#endif
/cvs/dm/dmraid/man/Makefile.in,v  -->  standard output
revision 1.1
--- dmraid/man/Makefile.in
+++ -	2008-02-22 16:57:44.336224000 +0000
@@ -0,0 +1,36 @@
+#
+# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+
+MAN8=dmraid.8
+MAN8DIR=${mandir}/man8
+
+include $(top_srcdir)/make.tmpl
+
+.PHONY:	install_dmraid_man remove_dmraid_man
+
+install_dmraid_man:
+	@echo "Installing $(MAN8) in $(MAN8DIR)"; \
+	mkdir -p $(MAN8DIR); \
+	for f in $(MAN8); \
+	do \
+	   $(RM) $(MAN8DIR)/$$f; \
+	   @INSTALL@ -D -m 444 $$f $(MAN8DIR)/$$f; \
+	done
+
+install:	install_dmraid_man
+
+remove_dmraid_man:
+	@echo "Removing $(MAN8) in $(MAN8DIR)"; \
+	for f in $(MAN8); \
+	do \
+	   $(RM) $(MAN8DIR)/$$f; \
+	done
+
+remove:	remove_dmraid_man
/cvs/dm/dmraid/man/dmraid.8,v  -->  standard output
revision 1.1
--- dmraid/man/dmraid.8
+++ -	2008-02-22 16:57:44.506125000 +0000
@@ -0,0 +1,414 @@
+.TH DMRAID 8 "DMRAID TOOL" "Heinz Mauelshagen" \" -*- nroff -*-
+.SH NAME
+dmraid \- discover and activate software (ATA)RAID
+.SH SYNOPSIS
+.B dmraid
+ {-a|--activate} {y|n|yes|no} 
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-f|--format FORMAT[,FORMAT...]]
+ [-p|--no_partitions]
+ [--separator SEPARATOR]
+ [-t|--test]
+ [RAID-set...]
+
+.B dmraid
+ {-b|--block_devices}
+ [-c|--display_columns][FIELD[,FIELD...]]...
+ [-d|--debug]... [-v|--verbose]...
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-h|--help}
+
+.B dmraid
+ {-l|--list_formats}
+ [-d|--debug]... [-v|--verbose]...
+
+.B dmraid
+ {-n|--native_log}
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-f|--format FORMAT[,FORMAT...]]
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-r|--raid_devices}
+ [-c|--display_columns][FIELD[,FIELD...]]...
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-D|--dump_metadata]
+ [-f|--format FORMAT[,FORMAT...]]
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-r|--raid_devices}
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-E|--erase_metadata]
+ [-f|--format FORMAT[,FORMAT...]]
+ [--separator SEPARATOR]
+ [device-path...]
+
+.B dmraid
+ {-s|--sets}...[a|i|active|inactive]
+ [-c|--display_columns][FIELD[,FIELD...]]...
+ [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]
+ [-f|--format FORMAT[,FORMAT...]]
+ [-g|--display_group]
+ [--separator SEPARATOR]
+ [RAID-set...]
+
+.B dmraid
+ {-V/--version}
+
+.SH DESCRIPTION
+dmraid discovers block and software RAID devices (eg, ATARAID)
+by using multiple different metadata format handlers which
+support various formats (eg, Highpoint 37x series).
+It offers activating RAID sets made up by 2 or more
+discovered RAID devices, display properties of devices and sets (see option
+.B -l
+for supported metadata formats).
+Block device access to activated RAID sets occurs via device-mapper nodes
+/dev/mapper/RaidSetName.
+RaidSetName starts with the format name (see
+.B -l
+option) which can be used to access all RAID sets of a specific format
+easily with certain options (eg,
+.B -a
+below).
+
+.SS OPTIONS
+.TP
+.I \-a, \-\-activate {y|n} [RAID set...]
+Activates or deactivates all or particular software RAID set.
+In case metadata format handlers are chosen with
+.B -f
+, only RAID sets with such format(s) can be activated or deactivated.
+Useful if devices have multiple metadata signatures.
+When activating RAID sets,
+.B -p
+disables the activation of partitions on them.
+RAID set names given on command line don't need to be fully specified
+(eg, "dmraid -ay sil" would activate all discovered Silicon Image Medley
+RAID sets).
+
+.TP
+.I {-b|--block_devices} [device-path...]
+List all or particular discovered block devices with their
+properties (size, serial number).
+Add
+.B -c
+to display block device names only and
+.B -cc
+for CSV column output of block device properties.
+See description of
+.B -c
+below for FIELD identifiers.
+
+.TP
+.I [-d|--debug]...
+Enable debugging output. Opion can be given multiple times
+increasing the debug output level.
+
+.TP
+.I [-c|--display_columns][FIELD[,FIELD...]]...
+Display properties of block devices, RAID sets and devices in column(s).
+Optional list specifying which FIELDs to display.
+.br
+For
+.B -b:
+.br
+d[evpath]|p[ath], sec[tors]|si[ze], ser[ialnumber].
+.br
+For
+.B -r:
+.br
+de[vpath]|p[ath], f[ormat], r[aidname], t[ype], st[atus], se[ctors]|si[ze], da[taoffset]|o[ffset].
+.br
+For
+.B -s:
+.br
+f[ormat], r[aidname], t[ype], sta[tus], str[ide], se[ctors]|si[ze], su[bsets], d[evices], sp[ares].
+.br
+.TP
+.I [-f|--format FORMAT[,FORMAT...]]
+Use metadata format handler(s) to discover RAID devices.
+See
+.B -l
+for a list of supported format handler names. This is useful to
+select particular formats in case multiple metadata signatures are found
+on a device. A comma seperated list of format names can be specified which 
+may not contain white space.
+
+.TP
+.I {-h|--help}
+Display help text.
+
+.TP
+.I {-i|--ignorelocking}
+Don't take out any locks. Useful in early boot where no read/write
+access to /var is available.
+
+.TP
+.I {-l|--list_formats}
+List all available metadata format handlers with their names and
+descriptions. Supported RAID levels are listed in parenthesis:
+.br
+
+S: Span (concatination)
+.br
+0: RAID0 (stripe)
+.br
+1: RAID1 (mirror)
+.br
+10: RAID10 (mirror on top of stripes)
+.br
+01: RAID10 (stripe on top of mirrors)
+
+.TP
+.I {-n|--native_log} [device-path...]
+Display metadata in native, vendor-specific format.
+In case a metadata format handler is chosen with
+.B -f
+only RAID devices with such format will be displayed in native format.
+If device-path(s) is/are given on the command line, native metadata output
+is restricted to those listed.
+
+.TP
+.I {-r|--raid_devices} [device-path...]
+List all discovered RAID devices with format, RAID level, sectors used
+and data offset into the device.
+In case a metadata format handler is chosen with
+.B -f
+, only RAID devices with such format can be discovered. Useful if devices
+have multiple metadata signatures.
+If 
+.B -D
+is added to
+.B -r
+the RAID metadata gets dumped into files named devicename_formatname.dat.
+The offset in sectors where the metadata is located on the device is written
+into files named devicename_formatname.offset and the size of the device
+into files named devicename_formatname.size.
+
+If 
+.B -E
+is added to
+.B -r
+the RAID metadata on the devices gets conditionally erased.
+Useful to erase old metadata after new one of different type has been
+stored on a device in order to avoid discovering both. If you enter
+.B -E
+option
+.B -D
+will be enforced in order to have a fallback in case the wrong metadata
+got erased.
+Manual copying back onto the device is needed to recover from erasing
+the wrong metadata using the dumped files devicename_formatname.dat
+and devicename_formatname.offset.
+Eg, to restore all *.dat files in the working directory to the respective devices:
+
+.br
+for f in *.dat
+.br
+do
+.br
+	dd if=$f of=/dev/${f%%_*} \\
+.br
+	seek=`cat ${f%%dat}offset` bs=1
+.br
+done
+.br
+
+If device-path(s) is/are given on the command line, the above actions
+are restricted to those listed.
+Add
+.B -c
+to display RAID device names only and
+.B -cc
+for CSV column output of RAID device properties.
+See description of
+.B -c
+above for FIELD identifiers.
+
+.TP
+.I --separator SEPARATOR
+Use SEPARATOR as a delimiter for all options taking or displaying lists.
+
+.TP
+.I -s... [a|i] [RAID-set...]
+Display properties of RAID sets. Multiple RAID set names can be given
+on the command line which don't need to be fully specified (eg, "dmraid -s hpt"
+would display all discovered Highpoint RAID sets). Enter
+.B -s
+twice to display RAID subsets too.
+Add
+.B -c
+to display names of RAID sets only,
+.B -cc
+for CSV column output of RAID set properties and
+.B -ccc
+for inclusion of block devices in the listing. Doesn't imply
+.B -s -s
+to show RAID subsets (implied for group sets, e.g. isw).
+Add
+.B -g
+to include information about group RAID sets (as with Intel Software
+RAID) in the listing.
+See description of
+.B -c
+above for FIELD identifiers.
+
+.TP
+.I [-v|--verbose]...
+Enable verbose runtime information output. Opion can be given multiple times
+increasing the verbosity level.
+
+.SH EXAMPLES
+"dmraid -l" lists all supported metadata formats with their names along with
+some descriptive information, eg:
+.br
+hpt37x : (+) Highpoint HPT37X
+.br
+hpt45x : (+) Highpoint HPT45X
+.br
+isw    : (+) Intel Software RAID
+.br
+lsi    : (0) LSI Logic MegaRAID
+.br
+nvidia : (+) NVidia RAID
+.br
+pdc    : (+) Promise FastTrack
+.br
+sil    : (+) Silicon Image(tm) Medley(tm)
+.br
+via    : (+) VIA Software RAID
+.br
+dos    : (+) DOS partitions on SW RAIDs
+.br
+(0): Discover, (+): Discover+Activate
+
+"dmraid -ay" activates all software RAID sets discovered.
+
+"dmraid -an" deactivates all active software RAID sets which are not open
+(eg, mounted filesystem on them).
+
+"dmraid -ay -f pdc" (pdc looked up from "dmraid -l") activates all
+software RAID sets with Promise format discovered and ignores all other
+supported formats.
+
+"dmraid -r" discovers all software RAID devices supported on your system, eg:
+.br
+/dev/dm-46: hpt45x, "hpt45x_chidjhaiaa-0", striped, ok, 320172928 sectors, data@ 0
+.br
+/dev/dm-50: hpt45x, "hpt45x_chidjhaiaa-0", striped, ok, 320172928 sectors, data@ 0
+.br
+/dev/dm-54: hpt45x, "hpt45x_chidjhaiaa-1", striped, ok, 320172928 sectors, data@ 0
+.br
+/dev/dm-58: hpt45x, "hpt45x_chidjhaiaa-1", striped, ok, 320172928 sectors, data@ 0
+
+
+"dmraid -s -s hpt45x_chidjhaiaa" displays properties of
+set "hpt45x_chidjhaiaa", eg:
+.br
+*** Superset
+.br
+name   : hpt45x_chidjhaiaa
+.br
+size   : 640345856
+.br
+stride : 128
+.br
+type   : raid10
+.br
+status : ok
+.br
+subsets: 2
+.br
+dev    : 4
+.br
+spare  : 0
+.br
+---> Subset
+.br
+name   : hpt45x_chidjhaiaa-0
+.br
+size   : 640345856
+.br
+stride : 128
+.br
+type   : stripe
+.br
+status : ok
+.br
+subsets: 0
+.br
+dev    : 2
+.br
+spare  : 0
+.br
+---> Subset
+.br
+name   : hpt45x_chidjhaiaa-1
+.br
+size   : 640345856
+.br
+stride : 128
+.br
+type   : stripe
+.br
+status : ok
+.br
+subsets: 0
+.br
+dev    : 2
+.br
+spare  : 0
+.br
+
+"dmraid -s -ccs hpt45" displays properties in column format of all sets
+and subsets with hpt45* format, eg:
+.br
+hpt45x_chidjhaiaa,640345856,128,raid10,ok,4,0
+.br
+hpt45x_chidjhaiaa-a,640345856,128,stripe,ok,2,0
+.br
+hpt45x_chidjhaiaa-b,640345856,128,stripe,ok,2,0
+
+"dmraid -r --sep : -cpath:size" display paths and sizes in sectors for
+RAID devices in column format using ':' as a delimiter, eg:
+.br
+/dev/dm-8:320173055
+.br
+/dev/dm-12:320173055
+.br
+/dev/dm-22:320173055
+.br
+/dev/dm-26:320173055
+.br
+/dev/dm-30:586114703
+.br
+/dev/dm-34:586114703
+.br
+/dev/dm-38:586114703
+.br
+/dev/dm-42:586114703
+.br
+/dev/dm-46:156301487
+.br
+/dev/dm-50:156301487
+.br
+/dev/dm-54:390624896
+.br
+/dev/dm-58:390624896
+.br
+/dev/dm-62:390624896
+.br
+/dev/dm-66:390624896
+
+.SH DIAGNOSTICS
+dmraid returns an exit code of 0 for success or 1 for error.
+
+.SH AUTHOR
+Heinz Mauelshagen <Mauelshagen@RedHat.com>
/cvs/dm/dmraid/tools/Makefile.in,v  -->  standard output
revision 1.1
--- dmraid/tools/Makefile.in
+++ -	2008-02-22 16:57:45.039868000 +0000
@@ -0,0 +1,75 @@
+#
+# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+#
+# See file LICENSE at the top of this source tree for license information.
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+DIETLIBC = @DIETLIBC@
+KIBC = @KLIBC@
+
+INCLUDES += -I $(src_dir)
+
+SOURCES=\
+	dmraid.c \
+	commands.c \
+	toollib.c
+
+TARGETS=\
+	dmraid
+
+DMRAIDLIBS=-ldmraid
+
+include $(top_srcdir)/make.tmpl
+
+ifeq ("@KLIBC@", "yes")
+	DMRAIDLIBS += -ldevmapper_klibc
+else
+	ifeq ("@DIETLIBC@", "yes")
+		DMRAIDLIBS += -ldevmapper_dietc
+	else
+		DMRAIDLIBS += -ldevmapper
+	endif
+
+	ifeq ("@LIBSELINUX@", "yes")
+		DMRAIDLIBS += -lselinux
+	endif
+
+	ifeq ("@LIBSEPOL@", "yes")
+		DMRAIDLIBS += -lsepol
+	endif
+endif
+
+# We just link klibc static and get it over with
+ifeq ("@KLIBC@", "no")
+	ifeq ("@STATIC_LINK@", "no")
+		LDFLAGS += -rdynamic
+	else
+		LDFLAGS += -static
+	endif
+endif
+
+
+.PHONY: install_dmraid_tools remove_dmraid_tools
+
+dmraid:	$(OBJECTS) $(top_srcdir)/lib/libdmraid.a
+	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) -L$(top_srcdir)/lib \
+	      -L$(DESTDIR)/lib $(DMRAIDLIBS) $(LIBS)
+
+install_dmraid_tools: $(TARGETS)
+	@echo "Installing $(TARGETS) in $(sbindir)"; \
+	mkdir -p $(sbindir); \
+	$(INSTALL) $(STRIP) $(TARGETS) $(sbindir)
+
+install: install_dmraid_tools
+
+remove_dmraid_tools:
+	@echo "Removing $(TARGETS) from $(sbindir)"; \
+	for f in $(TARGETS); \
+	do \
+		rm -f $(sbindir)/$$f; \
+	done
+
+remove:	remove_dmraid_tools
/cvs/dm/dmraid/tools/VERSION,v  -->  standard output
revision 1.1
--- dmraid/tools/VERSION
+++ -	2008-02-22 16:57:45.162011000 +0000
@@ -0,0 +1 @@
+1.0.0.rc11 (2006.05.15)
/cvs/dm/dmraid/tools/commands.c,v  -->  standard output
revision 1.1
--- dmraid/tools/commands.c
+++ -	2008-02-22 16:57:45.303788000 +0000
@@ -0,0 +1,791 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifdef HAVE_GETOPTLONG
+# define _GNU_SOURCE
+# include <getopt.h>
+#endif
+
+#include <string.h>
+#include <unistd.h>
+#include <dmraid/dmraid.h>
+#include "../lib/log/log.h"
+#include "commands.h"
+#include "toollib.h"
+#include "version.h"
+
+/* Action flags */
+enum action action = UNDEF;
+
+/*
+ * Command line options.
+ */
+static char const *short_opts = "a:hip"
+#ifndef	DMRAID_MINI
+				"bc::dDEf:gl"
+#ifdef	DMRAID_NATIVE_LOG
+				"n"
+#endif
+				"rs::tv"
+#endif
+				"V";
+
+#ifdef HAVE_GETOPTLONG
+static struct option long_opts[] = {
+	{"activate", required_argument, NULL, 'a'},
+	{"format", required_argument, NULL, 'f'},
+	{"no_partitions", no_argument, NULL, 'p'},
+# ifndef DMRAID_MINI
+	{"block_devices", no_argument, NULL, 'b'},
+	{"display_columns", optional_argument, NULL, 'c'},
+	{"debug", no_argument, NULL, 'd'},
+	{"dump_metadata", no_argument, NULL, 'D'},
+	{"erase_metadata", no_argument, NULL, 'E'},
+	{"display_group", no_argument, NULL, 'g'},
+# endif
+	{"help", no_argument, NULL, 'h'},
+	{"ignorelocking", no_argument, NULL, 'i'},
+# ifndef DMRAID_MINI
+	{"list_formats", no_argument, NULL, 'l'},
+#  ifdef DMRAID_NATIVE_LOG
+	{"native_log", no_argument, NULL, 'n'},
+#  endif
+	{"raid_devices", no_argument, NULL, 'r'},
+	{"sets", optional_argument, NULL, 's'},
+	{"separator", required_argument, NULL, SEPARATOR}, /* long only. */
+	{"test", no_argument, NULL, 't'},
+	{"verbose", no_argument, NULL, 'v'},
+# endif
+	{"version", no_argument, NULL, 'V'},
+	{NULL, no_argument, NULL, 0}
+};
+#endif /* #ifdef HAVE_GETOPTLONG */
+
+/* Definitions of option strings and actions for check_optarg(). */
+struct optarg_def {
+	const char *str;
+	const enum action action;
+};
+
+/* Check option argument. */
+static int check_optarg(struct lib_context *lc, const char option,
+			struct optarg_def *def)
+{
+	size_t len;
+	struct optarg_def *d;
+
+	if (optarg)
+		str_tolower(optarg);
+	else
+		return 1;
+
+	for (d = def, len = strlen(optarg); d->str; d++) {
+		if (!strncmp(optarg, d->str, len)) {
+			action |= d->action;
+			return 1;
+		}
+	}
+
+	LOG_ERR(lc, 0, "Invalid option argument for -%c", option);
+}
+
+/* Check activate/deactivate option arguments. */
+static int check_activate(struct lib_context *lc, int arg)
+{
+	struct optarg_def def[] = {
+		{ "yes", ACTIVATE },
+		{ "no",  DEACTIVATE },
+		{ NULL,  UNDEF },
+	};
+
+	return check_optarg(lc, 'a', def);
+}
+
+#ifndef	DMRAID_MINI
+/* Check active/inactive option arguments. */
+static int check_active(struct lib_context *lc, int arg)
+{
+	struct optarg_def def[] = {
+		{ "active",   ACTIVE },
+		{ "inactive", INACTIVE },
+		{ NULL,  UNDEF },
+	};
+
+	lc_inc_opt(lc, LC_SETS);
+
+	return check_optarg(lc, 's', def);
+}
+
+/* Check and store option arguments. */
+static int check_identifiers(struct lib_context *lc, int o)
+{
+	if (optarg) {
+		const char delim = *OPT_STR_SEPARATOR(lc);
+		char *p = optarg;
+
+		p = remove_white_space(lc, p, strlen(p));
+		p = collapse_delimiter(lc, p, strlen(p), delim);
+		if (!lc_strcat_opt(lc, o, p, delim))
+			return 0;
+	}
+
+	lc_inc_opt(lc, o);
+
+	return 1;
+}
+
+/* Check and store option argument/output field separator. */
+static int check_separator(struct lib_context *lc, int arg)
+{
+	if (strlen(optarg) != 1)
+		LOG_ERR(lc, 0, "Invalid separator \"%s\"", optarg);
+
+	return lc_stralloc_opt(lc, LC_SEPARATOR, optarg) ? 1 : 0;
+}
+#endif
+
+/* Display help information */
+static int help(struct lib_context *lc, int arg)
+{
+	char *c = lc->cmd;
+
+#ifdef	DMRAID_MINI
+	log_print(lc, "%s: Device-Mapper Software RAID tool "
+		  "[Early Boot Version]\n", c);
+	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} [-i|--ignorelocking]\n"
+		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[-p|--no_partitions]\n"
+		  "\t[--separator SEPARATOR]\n"
+		  "\t[RAID-set...]\n", c);
+	log_print(lc, "%s\t{-h|--help}\n", c);
+	log_print(lc, "%s\t{-V/--version}\n", c);
+#else
+	log_print(lc, "%s: Device-Mapper Software RAID tool\n", c);
+	log_print(lc, "* = [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]\n");
+	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} *\n"
+		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[-p|--no_partitions]\n"
+		  "\t[--separator SEPARATOR]\n"
+		  "\t[-t|--test]\n"
+		  "\t[RAID-set...]\n", c);
+	log_print(lc, "%s\t{-b|--block_devices} *\n"
+		  "\t[-c|--display_columns][FIELD[,FIELD...]]...\n"
+		  "\t[device-path...]\n", c);
+	log_print(lc, "%s\t{-h|--help}\n", c);
+	log_print(lc, "%s\t{-l|--list_formats} *\n", c);
+#  ifdef	DMRAID_NATIVE_LOG
+	log_print(lc, "%s\t{-n|--native_log} *\n"
+		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[--separator SEPARATOR]\n"
+		  "\t[device-path...]\n", c);
+#  endif
+	log_print(lc, "%s\t{-r|--raid_devices} *\n"
+		  "\t[-c|--display_columns][FIELD[,FIELD...]]...\n"
+		  "\t[-D|--dump_metadata]\n"
+		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[--separator SEPARATOR]\n"
+		  "\t[device-path...]\n", c);
+	log_print(lc, "%s\t{-r|--raid_devices} *\n"
+		  "\t{-E|--erase_metadata}\n"
+		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[--separator SEPARATOR]\n"
+		  "\t[device-path...]\n", c);
+	log_print(lc, "%s\t{-s|--sets}...[a|i|active|inactive] *\n"
+		  "\t[-c|--display_columns][FIELD[,FIELD...]]...\n"
+		  "\t[-f|--format FORMAT[,FORMAT...]]\n"
+		  "\t[-g|--display_group]\n"
+		  "\t[--separator SEPARATOR]\n"
+		  "\t[RAID-set...]\n", c);
+	log_print(lc, "%s\t{-V/--version}\n", c);
+#endif
+
+	return 1;
+}
+
+/*
+ * Action flag definitions for set_action()
+ *
+ * 'Early' options can be handled directly in set_action() by calling
+ * the functions registered here (set on_set member).
+ */
+static struct actions actions[] = {
+	/* [De]activate option. */
+	{ 'a',
+	  UNDEF, /* Set in check_activate() by mandatory option argument. */
+	  UNDEF,
+	  ACTIVATE|DEACTIVATE|FORMAT|HELP|IGNORELOCKING|NOPARTITIONS|SEPARATOR
+#ifndef DMRAID_MINI
+	  |DBG|TEST|VERBOSE
+#endif
+ 	  , ARGS,
+	  check_activate,
+	  0,
+	},
+
+	/* Format option. */
+	{ 'f',
+	  FORMAT,
+	  ACTIVATE|DEACTIVATE
+#ifndef DMRAID_MINI
+#  ifdef DMRAID_NATIVE_LOG
+	  |NATIVE_LOG
+#  endif
+	  |RAID_DEVICES|RAID_SETS,
+	  ACTIVE|INACTIVE|COLUMN|DBG|DUMP|ERASE|GROUP|HELP|
+	  IGNORELOCKING|NOPARTITIONS|SEPARATOR|TEST|VERBOSE
+#else
+	  , UNDEF
+#endif
+	  , ARGS,
+#ifndef DMRAID_MINI
+	  check_identifiers,
+#else
+	  NULL,
+#endif
+	  LC_FORMAT,
+	},
+
+	/* Partition option. */
+	{ 'p',
+	  NOPARTITIONS,
+	  ACTIVATE|DEACTIVATE,
+	  FORMAT|HELP|IGNORELOCKING|SEPARATOR
+#ifndef DMRAID_MINI
+	  |DBG|TEST|VERBOSE
+#endif
+	  , ARGS,
+	  NULL,
+	  0,
+	},
+
+#ifndef	DMRAID_MINI
+	/* Block devices option. */
+	{ 'b',
+	  BLOCK_DEVICES,
+	  UNDEF,
+	  COLUMN|DBG|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
+	  ARGS,
+	  lc_inc_opt,
+	  LC_DEVICES,
+	},
+
+	/* Columns display option. */
+	{ 'c',
+	  COLUMN,
+	  BLOCK_DEVICES|RAID_DEVICES|RAID_SETS,
+	  ACTIVE|INACTIVE|DBG|DUMP|FORMAT|GROUP|HELP|IGNORELOCKING
+	  |SEPARATOR|VERBOSE,
+	  ARGS,
+	  check_identifiers,
+	  LC_COLUMN,
+	},
+
+	/* Debug option. */
+	{ 'd',
+	  DBG,
+	  ALL_FLAGS,
+	  ALL_FLAGS,
+	  ARGS,
+	  lc_inc_opt,
+	  LC_DEBUG,
+	},
+
+	/* Dump metadata option. */
+	{ 'D',
+	  DUMP,
+	  RAID_DEVICES,
+	  COLUMN|DBG|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
+	  ARGS,
+	  lc_inc_opt,
+	  LC_DUMP,
+	},
+
+	/* Erase metadata option. */
+	{ 'E',
+	  ERASE,
+	  RAID_DEVICES,
+	  COLUMN|DBG|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
+	  ARGS,
+	  NULL,
+	  0,
+	},
+
+	/* RAID groups option. */
+	{ 'g',
+	  GROUP,
+	  RAID_SETS,
+	  ACTIVE|INACTIVE|DBG|COLUMN|FORMAT|HELP|IGNORELOCKING
+	  |SEPARATOR|VERBOSE,
+	  ARGS,
+	  lc_inc_opt,
+	  LC_GROUP,
+	},
+
+#endif
+	/* Help option. */
+	{ 'h',
+	  HELP,
+	  UNDEF,
+	  ALL_FLAGS,
+	  ARGS,
+	  help,
+	  0, 
+	},
+
+	/* ignorelocking option. */
+	{ 'i',
+	  IGNORELOCKING,
+	  UNDEF,
+	  ALL_FLAGS,
+	  ARGS,
+	  lc_inc_opt,
+	  LC_IGNORELOCKING,
+	},
+
+#ifndef	DMRAID_MINI
+	/* List metadata format handlers option. */
+	{ 'l',
+	  LIST_FORMATS,
+	  UNDEF,
+	  DBG|HELP|IGNORELOCKING|VERBOSE,
+	  NO_ARGS,
+	  NULL,
+	  0,
+	},
+
+#  ifdef DMRAID_NATIVE_LOG
+	/* Native log option. */
+	{ 'n',
+	  NATIVE_LOG,
+	  UNDEF,
+	  DBG|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
+	  ARGS,
+	  NULL,
+	  0,
+	},
+
+#  endif
+	/* Display RAID devices option. */
+	{ 'r',
+	  RAID_DEVICES,
+	  UNDEF,
+	  COLUMN|DBG|DUMP|ERASE|FORMAT|HELP|IGNORELOCKING|SEPARATOR|VERBOSE,
+	  ARGS,
+	  NULL,
+	  0,
+	},
+
+	/* Display RAID sets option. */
+	{ 's',
+	  RAID_SETS,
+	  UNDEF,
+	  ACTIVE|INACTIVE|COLUMN|DBG|FORMAT|GROUP|HELP|IGNORELOCKING
+	  |SEPARATOR|VERBOSE,
+	  ARGS,
+	  check_active,
+	  0,
+	},
+
+	/* Display RAID sets option. */
+	{ SEPARATOR,
+	  SEPARATOR,
+	  COLUMN|FORMAT,
+	  ALL_FLAGS,
+	  ARGS,
+	  check_separator,
+	  0,
+	},
+
+
+	/* Test run option. */
+	{ 't',
+	  TEST,
+	  ACTIVATE|DEACTIVATE,
+	  ACTIVATE|DEACTIVATE|DBG|FORMAT|HELP|IGNORELOCKING|
+	  NOPARTITIONS|VERBOSE,
+	  ARGS,
+	  lc_inc_opt,
+	  LC_TEST,
+	},
+
+	/* Verbose option. */
+	{ 'v',
+	  VERBOSE,
+	  ALL_FLAGS,
+	  ALL_FLAGS,
+	  ARGS,
+	  lc_inc_opt,
+	  LC_VERBOSE,
+	},
+#endif /* #ifndef DMRAID_MINI */
+
+	/* Version option. */
+	{ 'V',
+	  VERSION,
+	  UNDEF,
+#ifdef DMRAID_MINI
+	  HELP,IGNORELOCKING,
+#else
+	  DBG|HELP|IGNORELOCKING|VERBOSE,
+#endif
+	  NO_ARGS,
+	  NULL,
+	  0,
+	},
+};
+
+/*
+ * Set action flag and call optional function.
+ */
+static int set_action(struct lib_context *lc, int o)
+{
+	struct actions *a;
+
+	for (a = actions; a < ARRAY_END(actions); a++) {
+		if (o == a->option) {
+			action |= a->action;	/* Set action flag. */
+			a->allowed |= a->action;/* Merge to allowed flags. */
+			a->allowed |= a->needed;
+			if (a->f_set)	/* Optionally call function. */
+				return a->f_set(lc, a->arg);
+
+			break;
+		}
+	}
+
+	return 1;
+}
+
+/* Check for invalid option combinations */
+static int check_actions(struct lib_context *lc, char **argv)
+{
+	struct actions *a;
+
+	for (a = actions; a < ARRAY_END(actions); a++) {
+		if (a->action & action) {
+			if (a->needed != UNDEF &&
+			    !(a->needed & action))
+				LOG_ERR(lc, 0,
+					"option missing/invalid option "
+					"combination with -%c",
+					a->option);
+
+			if (~a->allowed & action)
+				LOG_ERR(lc, 0, "Invalid option combination"
+					   " (-h for help)");
+
+			if (a->args == NO_ARGS && argv[optind])
+				LOG_ERR(lc, 0,
+					"No arguments allowed with -%c\n",
+					a->option);
+		}
+	}
+
+	if (!action)
+		LOG_ERR(lc, 0, "Options missing\n");
+
+#ifndef DMRAID_MINI
+	if ((action & (DBG|VERBOSE)) == action)
+		LOG_ERR(lc, 0, "More options needed with -d/-v");
+
+	if (action & ERASE) {
+		action |= DUMP;
+		lc_inc_opt(lc, LC_DUMP);
+	}
+#endif
+
+	return 1;
+}
+
+/* Check for invalid option argumengts. */
+static int check_actions_arguments(struct lib_context *lc)
+{
+	if (valid_format(lc, OPT_STR_FORMAT(lc)))
+		return 1;
+
+	LOG_ERR(lc, 0, "Invalid format for -f at (see -l)");
+}
+
+/* Parse and handle the command line arguments */
+int handle_args(struct lib_context *lc, int argc, char ***argv)
+{
+	int o, ret = 0;
+#ifdef HAVE_GETOPTLONG
+	int opt_idx;
+#endif
+
+	if (argc < 2)
+		LOG_ERR(lc, 0, "No arguments/options given (-h for help)\n");
+
+#ifdef HAVE_GETOPTLONG
+	/* Walk the options (and option arguments) */
+	while ((o = getopt_long(argc, *argv, short_opts,
+				long_opts, &opt_idx)) != -1) {
+#else
+	while ((o = getopt(argc, *argv, short_opts)) != -1) {
+#endif
+		/* Help already displayed -> exit ok. */
+		if ((ret = set_action(lc, o)) && (HELP & action))
+			return 1;
+
+		if (!ret || o == ':' || o == '?')
+			return 0;
+	}
+
+	/* Force deactivation of stacked partition devices. */
+	/* FIXME: remove partiton code in favour of kpartx ? */
+	if (DEACTIVATE & action)
+		action &= ~NOPARTITIONS;
+
+	if ((ret = check_actions(lc, *argv)) && OPT_FORMAT(lc))
+		ret = check_actions_arguments(lc);
+
+	*argv += optind;
+
+	return ret;
+}
+
+static int version(struct lib_context *lc, int arg)
+{
+	char v[80];
+
+	dm_version(lc, v, sizeof(v));
+	log_print(lc, "%s version:\t\t%s\n"
+		      "%s library version:\t%s %s\n"
+		      "device-mapper version:\t%s",
+		      lc->cmd, DMRAID_VERSION,
+		      lc->cmd, libdmraid_version(lc), libdmraid_date(lc), v);
+
+	return 1;
+}
+
+/*********************************************************************
+ * Perform pre/post functions for requested actions.
+ */
+/* Post Activate/Deactivate RAID set. */
+#ifndef DMRAID_MINI
+/* Pre and post display_set() functions. */
+static int _display_sets_arg(int arg)
+{
+	return (action & ACTIVE) ?
+	       D_ACTIVE : ((action & INACTIVE) ? D_INACTIVE : D_ALL);
+}
+
+static int _display_set(struct lib_context *lc, void *rs, int type)
+{
+	display_set(lc, rs, type, 0);
+
+	return 1;
+}
+
+static int _display_sets(struct lib_context *lc, int type)
+{
+	process_sets(lc, _display_set, type, SETS);
+
+	return 1;
+}
+
+static int _display_devices(struct lib_context *lc, int type)
+{
+	display_devices(lc, type);
+
+	return 1;
+}
+
+static int _erase(struct lib_context *lc, int arg)
+{
+	return erase_metadata(lc);
+}
+#endif
+
+/* Retrieve and build metadata. */
+static int get_metadata(struct lib_context *lc, struct prepost *p, char **argv)
+{
+	if (!(M_DEVICE & p->metadata))
+		return 1;
+
+	if (!discover_devices(lc, OPT_DEVICES(lc) ? argv : NULL))
+		LOG_ERR(lc, 0, "failed to discover devices");
+
+	if(!count_devices(lc, DEVICE)) {
+		log_print(lc, "no block devices found");
+		return 1;
+	}
+
+	if (!(M_RAID & p->metadata))
+		return 1;
+
+#ifndef	DMRAID_MINI
+	/* Discover RAID disks and keep RAID metadata (eg, hpt45x) */
+	discover_raid_devices(lc, 
+# ifdef	DMRAID_NATIVE_LOG
+		    ((NATIVE_LOG|RAID_DEVICES) & action) ? argv : NULL);
+# else
+		    (RAID_DEVICES & action) ? argv : NULL);
+# endif
+#else
+	discover_raid_devices(lc, NULL);
+#endif
+	if (!count_devices(lc, RAID)) {
+		format_error(lc, "disks", argv);
+		return 1;
+	}
+
+	if (M_SET & p->metadata) {
+		/* Group RAID sets. */
+		build_sets(lc, argv);
+		if (!count_devices(lc, SET)) {
+			format_error(lc, "sets", argv);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+/*
+ * Function abstraction which takes pre- and post-function calls
+ * to prepare an argument in pre() to be used by post().
+ *
+ * perform() is the call handler for all functions which need metadata
+ * as displaying, erasing and activation/deactivation of RAID sets.
+ *
+ * The necessary metadata describing disks, RAID devices and RAID sets
+ * gets automatically generated by this function.
+ *
+ * A lock gets taken out in case of metadata accesses in order to
+ * prevent multiple tool runs from occurring in parallel.
+ * For now I just lock globally, which will change when I get to monitoring
+ * of RAID sets, where finer grained locks on RAID sets need to be taken out.
+ */
+
+/*
+ * Definition of pre- and post functions to perform.
+ */
+struct prepost prepost[] = {
+	/* (De)activate RAID set. */
+	{ ACTIVATE|DEACTIVATE,
+	  M_DEVICE|M_RAID|M_SET,
+	  ROOT,
+	  LOCK,
+	  NULL,
+	  0,
+	  activate_or_deactivate_sets,
+	},
+
+#ifndef DMRAID_MINI
+	/* Display block devices. */
+	{ BLOCK_DEVICES,
+	  M_DEVICE,
+	  ROOT,
+	  NO_LOCK,
+	  NULL,
+	  DEVICE,
+	  _display_devices,
+	},
+
+	/* Erase metadata. */
+	{ ERASE,
+	  M_DEVICE|M_RAID, 
+	  ROOT,
+	  LOCK,
+	  NULL,
+	  0,
+	  _erase,
+	},
+
+	/* List metadata format handlers. */
+	{ LIST_FORMATS,
+	  M_NONE, 
+	  ANY_ID,
+	  NO_LOCK,
+	  NULL,
+	  0,
+	  list_formats,
+	},
+
+#  ifdef DMRAID_NATIVE_LOG
+	/* Native metadata log. */
+	{ NATIVE_LOG,
+	  M_DEVICE|M_RAID, 
+	  ROOT,
+	  LOCK,
+	  NULL,
+	  NATIVE,
+	  _display_devices,
+	},
+#  endif
+
+	/* Display RAID devices. */
+	{ RAID_DEVICES,
+	  M_DEVICE|M_RAID,
+	  ROOT,
+	  LOCK,
+	  NULL,
+	  RAID,
+	  _display_devices,
+	},
+
+	/* Display RAID sets. */
+	{ RAID_SETS,
+	  M_DEVICE|M_RAID|M_SET,
+	  ROOT,
+	  LOCK,
+	  _display_sets_arg,
+	  0,
+	  _display_sets,
+	},
+#endif
+
+	/* Display version. */
+	{ VERSION,
+	  M_NONE,
+	  ANY_ID,
+	  NO_LOCK,
+	  NULL,
+	  0,
+	  version,
+	},
+};
+
+static int _perform(struct lib_context *lc, struct prepost *p,
+		    char **argv)
+{
+	int ret = 0;
+
+	if (ROOT == p->id && geteuid())
+		LOG_ERR(lc, 0, "you must be root");
+	
+	/* Lock against parallel runs. Resource NULL for now. */
+	if (LOCK == p->lock && !lock_resource(lc, NULL))
+		LOG_ERR(lc, 0, "lock failure");
+	
+	if (get_metadata(lc, p, argv))
+		ret = p->post(lc, p->pre ? p->pre(p->arg) : p->arg);
+	
+	if (LOCK == p->lock)
+		unlock_resource(lc, NULL);
+	
+	return ret;
+}
+
+int perform(struct lib_context *lc, char **argv)
+{
+	struct prepost *p;
+
+	/* Special case, because help can be asked for at any time. */
+	if (HELP & action)
+		return 1;
+
+	/* Find appropriate action. */
+	for (p = prepost; p < ARRAY_END(prepost); p++) {
+		if (p->action & action)
+			return _perform(lc, p, argv);
+	}
+
+	return 0;
+}
/cvs/dm/dmraid/tools/commands.h,v  -->  standard output
revision 1.1
--- dmraid/tools/commands.h
+++ -	2008-02-22 16:57:45.431432000 +0000
@@ -0,0 +1,112 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef	_COMMANDS_H
+#define	_COMMANDS_H
+
+#include <dmraid/lib_context.h>
+
+#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(*a))
+#define ARRAY_END(a)	(a + ARRAY_SIZE(a))
+
+/* Options actions dmraid performs. */
+enum action {
+	UNDEF		= 0x0,
+	ACTIVATE	= 0x1,
+	DEACTIVATE	= 0x2,
+	FORMAT		= 0x4,
+#ifndef	DMRAID_MINI
+	BLOCK_DEVICES	= 0x8,
+	COLUMN		= 0x10,
+	DBG		= 0x20,
+	DUMP		= 0x40,
+	ERASE		= 0x80,
+	GROUP		= 0x100,
+#endif
+	HELP		= 0x200,
+#ifndef	DMRAID_MINI
+	LIST_FORMATS	= 0x400,
+#  ifdef	DMRAID_NATIVE_LOG
+	NATIVE_LOG	= 0x800,
+#  endif
+#endif
+	NOPARTITIONS	= 0x1000,
+#ifndef	DMRAID_MINI
+	RAID_DEVICES	= 0x2000,
+	RAID_SETS	= 0x4000,
+	TEST		= 0x8000,
+	VERBOSE		= 0x10000,
+	ACTIVE		= 0x20000,
+	INACTIVE	= 0x40000,
+	SEPARATOR	= 0x80000,
+#endif
+	VERSION		= 0x100000,
+	IGNORELOCKING	= 0x200000,
+};
+
+#define	ALL_FLAGS	((enum action) -1)
+
+/* Arguments allowed ? */
+enum args {
+	NO_ARGS,
+	ARGS,
+};
+
+/*
+ * Action flag definitions for set_action().
+ *
+ * 'Early' options can be handled directly in set_action() by calling
+ * the functions registered here (f_set member) handing in arg.
+ */
+struct actions {
+	int option;		/* Option character/value. */
+	enum action action;	/* Action flag for this option or UNDEF. */
+	enum action needed;	/* Mandatory options or UNDEF if alone */
+	enum action allowed;	/* Allowed flags (ie, other options allowed) */
+
+	enum args args;		/* Arguments allowed ? */
+
+	/* Function to call on hit or NULL */
+	int (*f_set)(struct lib_context *lc, int arg);
+	int arg;		/* Argument for above function call */
+};
+
+/* Define which metadata is needed before we can call post functions. */
+enum metadata_need {
+	M_NONE	 = 0x00,
+	M_DEVICE = 0x01,
+	M_RAID	 = 0x02,
+	M_SET	 = 0x04,
+};
+
+enum id {
+	ROOT,
+	ANY_ID,
+};
+
+enum lock {
+	LOCK,
+	NO_LOCK,
+};
+
+/* 
+ * Pre and Post functions to perform for an option.
+ */
+struct prepost {
+	enum action action;
+	enum metadata_need metadata;
+	enum id id;
+	enum lock lock;
+	int (*pre)(int arg);
+	int arg;
+	int (*post)(struct lib_context *lc, int arg);
+};
+
+int handle_args(struct lib_context *lc, int argc, char ***argv);
+int perform(struct lib_context *lc, char **argv);
+
+#endif
/cvs/dm/dmraid/tools/dmraid.c,v  -->  standard output
revision 1.1
--- dmraid/tools/dmraid.c
+++ -	2008-02-22 16:57:45.524844000 +0000
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * See commands.[ch] for the perform() function call abstraction below.
+ */
+
+#include <dmraid/dmraid.h>
+#include "commands.h"
+#include "toollib.h"
+#include "version.h"
+
+int main(int argc, char **argv)
+{
+	int ret = 0;
+	struct lib_context *lc;
+
+	/* Initialize library (creates a context to use it). */
+	if ((lc = libdmraid_init(argc, argv))) {
+		/*
+		 * Parse command line arguments and run 'early'
+		 * functions for options which set library context
+		 * variables (eg, --debug).
+		 *
+		 * Initialize locking afterwards, so that the
+		 * '--ignorelocking' option can be recognized.
+		 *
+		 * If both are ok -> perform the required action.
+		 */
+		ret = handle_args(lc, argc, &argv) &&
+		      init_locking(lc) &&
+		      perform(lc, argv);
+
+		/* Cleanup the library context. */
+		libdmraid_exit(lc);
+	}
+
+	/* Set standard exit code. */
+	exit (ret ? EXIT_SUCCESS : EXIT_FAILURE);
+}
/cvs/dm/dmraid/tools/toollib.c,v  -->  standard output
revision 1.1
--- dmraid/tools/toollib.c
+++ -	2008-02-22 16:57:45.615319000 +0000
@@ -0,0 +1,150 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+/*
+ * Tool library
+ */
+
+#include <dmraid/dmraid.h>
+#include "../lib/log/log.h"
+#include <ctype.h>
+
+#ifndef __KLIBC__
+# include <getopt.h>
+#endif
+
+#include <stdlib.h>
+#include <string.h>
+#include "commands.h"
+#include "toollib.h"
+
+/* [De]activate a RAID set. */
+static int _change_set(struct lib_context *lc, void *rs, int arg)
+{
+	if (change_set(lc,
+		       (ACTIVATE & action) ? A_ACTIVATE : A_DEACTIVATE,
+		       rs)) {
+		log_info(lc, "%sctivating %s RAID set \"%s\"",
+			 action & ACTIVATE ? "A": "Dea",
+			 get_set_type(lc, rs), get_set_name(lc, rs));
+		return 1;
+	}
+
+	return 0;
+}
+
+/* [De]activate RAID sets. */
+/* FIXME: remove partition code in favour of kpartx ? */
+static void process_partitions(struct lib_context *lc)
+{
+	discover_partitions(lc);
+	process_sets(lc, _change_set, 0, PARTITIONS);
+}
+
+int activate_or_deactivate_sets(struct lib_context *lc, int arg)
+{
+	/* Discover partitions to deactivate RAID sets for and work on them. */
+	if (DEACTIVATE & action)
+		process_partitions(lc);
+
+	process_sets(lc, _change_set, arg, SETS);
+
+	/* Discover partitions to activate RAID sets for and work on them. */
+	if ((ACTIVATE & action) && !(NOPARTITIONS & action))
+		process_partitions(lc);
+
+	return 1;
+}
+
+/* Build all sets or the ones given. */
+void build_sets(struct lib_context *lc, char **sets)
+{
+	int o = 0;
+
+	do {
+		if (!group_set(lc, sets[o]))
+			log_err(lc, "building set");
+
+		if (!sets[o])
+			break;
+	} while (sets[++o]);
+}
+
+/* Convert a character string to lower case. */
+void str_tolower(char *s)
+{
+	for (; *s; s++)
+		*s = tolower(*s);
+}
+
+/*
+ * Check if selected or all formats shall be used to read the metadata.
+*/
+/* Collapse a delimiter into one. */
+char *collapse_delimiter(struct lib_context *lc, char *str,
+			 size_t size, const char delim)
+{
+	size_t len;
+	char *p = str;
+
+	while ((p = strchr(p, delim))) {
+		if (p == str || p[1] == delim || !p[1])
+			memmove(p, p + 1, (len = str + size - p)), p[len] = 0;
+		else
+			p++;
+	}
+
+	return str;
+}
+
+int valid_format(struct lib_context *lc, const char *fmt)
+{
+	int ret = 1;
+	char *p, *p_sav, *sep;
+	const char delim = *OPT_STR_SEPARATOR(lc);
+
+ 	if (!(p_sav = dbg_strdup((char*) fmt)))
+		return log_alloc_err(lc, __func__);
+
+	sep = p_sav;
+	do {
+		sep = remove_delimiter((p = sep), delim);
+		log_notice(lc, "checking format identifier %s", p);
+
+		if (!(ret = check_valid_format(lc, p)))
+			break;
+
+		add_delimiter(&sep, delim);
+	} while (sep);
+
+	dbg_free(p_sav);
+
+	return ret;
+}
+
+void format_error(struct lib_context *lc, const char *error, char **argv)
+{
+	log_print_nnl(lc, "No RAID %s", error);
+
+	if (OPT_FORMAT(lc))
+		log_print_nnl(lc, " with format: \"%s\"",
+			      OPT_STR_FORMAT(lc));
+
+
+	if (argv && *argv) {
+		log_print_nnl(lc, " and with names: \"");
+		while (*argv) {
+			log_print_nnl(lc, "%s", *argv++);
+			if (*argv)
+				log_print_nnl(lc, "%s", OPT_STR_SEPARATOR(lc));
+			else
+				log_print_nnl(lc, "\"");
+		}
+	}
+
+	log_print(lc, "");
+}
/cvs/dm/dmraid/tools/toollib.h,v  -->  standard output
revision 1.1
--- dmraid/tools/toollib.h
+++ -	2008-02-22 16:57:45.715427000 +0000
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ *                          All rights reserved.
+ *
+ * See file LICENSE at the top of this source tree for license information.
+ */
+
+#ifndef _TOOLLIB_H_
+#define _TOOLLIB_H_
+
+extern enum action action;
+
+int  activate_or_deactivate_sets(struct lib_context *lc, int arg);
+void build_sets(struct lib_context *lc, char **sets);
+void format_error(struct lib_context *lc, const char *error, char **argv);
+void str_tolower(char *s);
+char *collapse_delimiter(struct lib_context *lc, char *str,
+			 size_t size, const char delim);
+int  valid_format(struct lib_context *lc, const char *fmt);
+
+#endif
/cvs/dm/dmraid/tools/version.h.in,v  -->  standard output
revision 1.1
--- dmraid/tools/version.h.in
+++ -	2008-02-22 16:57:45.816478000 +0000
@@ -0,0 +1,3 @@
+#ifndef	DMRAID_VERSION
+#define	DMRAID_VERSION	"@DMRAID_VERSION@ @FLAVOUR@"
+#endif
