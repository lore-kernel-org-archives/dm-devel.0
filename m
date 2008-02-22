From: heinzm@sourceware.org
Subject: dmraid README
Date: 22 Feb 2008 16:48:27 -0000
Message-ID: <20080222164827.20894.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2008-02-22 16:48:26

Modified files:
	.              : README 

Log message:
	initial 1.0.0.rc11 checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/README.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/README	2005/08/31 12:43:38	1.1
+++ dmraid/README	2008/02/22 16:48:26	1.2
@@ -1 +1,106 @@
-dmraid
+********************************************************************************
+*                                                                              *
+*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc11  2006.05.15   *
+*                                                                              *
+*   (C)opyright 2004-2006  Heinz Mauelshagen, Red Hat GmbH.                    *
+*   All rights reserved.                                                       *
+*                                                                              *
+********************************************************************************
+
+Feature set:
+------------
+This software discovers, activates, deactivates and displays properties
+of software RAID sets (eg, ATARAID) and contained DOS partitions.
+
+dmraid uses libdevmapper and the device-mapper kernel runtime to create
+devices with respective mappings for the ATARAID sets discovered.
+
+The following ATARAID types are supported:
+
+Adaptec HostRAID ASR
+Highpoint HPT37X
+Highpoint HPT45X
+Intel Software RAID
+JMicron JMB36x
+LSI Logic MegaRAID
+NVidia NForce
+Promise FastTrack
+Silicon Image Medley
+VIA Software RAID
+
+Beside hints, enhancement proposals and patches, I want to know, if the mappings
+the tool creates ("dmraid -tay") are correct for your ATARAID configuration.
+
+Thank you for your support of dmraid.
+
+
+License/Disclaimer:
+-------------------
+This software is released under the GPL/LGPL respectively.
+
+See file headers, LICENSE, LICENSE_GPL and LICENSE_LGPL for details.
+
+This is Alpha software and it can destroy your data!
+
+So please take backups and start accessing your data in dmraid
+activated ATARAID sets READ-ONLY first before you try to write it!
+
+
+Minimum prerequisites to run this software:
+-------------------------------------------
+
+o a recent mainline Linux 2.6 kernel (includes needed
+  device-mapper mirror changes)
+
+
+Additional minimum prerequisites to build this software:
+--------------------------------------------------------
+o device mapper userpace installed (http://sources.redhat.com/dm/)
+
+o the i386 rpm or source tarball for dmraid from
+  http://people.redhat.com/heinzm/sw/dmraid/
+
+
+Build/Install:
+--------------
+To install the rpm
+
+rpm -i [--nodeps] dmraid-1.0.0.rc10.i386.rpm
+
+- or -
+
+to build in an empty directory and install from source
+
+tar jxvf dmraid-1.0.0.rc10.tar.bz2
+./configure	# see ./configure --help for options
+make
+make install
+
+
+In case you want to dietize dmraid, you need to build device-mapper with
+'make CC="diet cc"' *and* install libdevmapper.a as /lib/libdevmapper_dietc.a.
+
+Run "./configure --enable-dietlibc" before make.
+
+
+Howto start:
+------------
+See "dmraid -h" for the synopsis and "man dmraid" for more details
+including some usage examples.
+
+Your first command is probably "dmraid -s".
+
+See TODO for known outstanding issues.
+
+See doc/dmraid_design.txt for design notes.
+
+See lib/format/template/ if you want to start your own metadata format
+handler implementation :)
+
+
+Contacts:
+---------
+The author can be reached at <Mauelshagen@RedHat.com>.
+
+For discussions, questions, patches, enhancement requests etc.,
+please subscribe and mail to <ataraid-list@redhat.com>.
