From: heinzm@sourceware.org
Subject: dmraid dmraid.spec
Date: 16 Mar 2010 18:22:37 -0000
Message-ID: <20100316182237.27489.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Changes by:	heinzm@sourceware.org	2010-03-16 18:22:37

Modified files:
	.              : dmraid.spec 

Log message:
	Changelog

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.13&r2=1.14

--- dmraid/dmraid.spec	2010/03/16 16:02:15	1.13
+++ dmraid/dmraid.spec	2010/03/16 18:22:37	1.14
@@ -1,13 +1,13 @@
 #
-# Copyright (C)  Heinz Mauelshagen, 2004-2009 Red Hat GmbH. All rights reserved.
+# Copyright (C)  Heinz Mauelshagen, 2004-2010 Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
 
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
-Version: 1.0.0.rc16t
-Release: 4%{?dist}
+Version: 1.0.0.rc16
+Release: 5%{?dist}
 License: GPLv2+
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
@@ -125,6 +125,10 @@
 %ghost /var/cache/logwatch/dmeventd/syslogpattern.txt
 
 %changelog
+* Tue Jan 12 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-5
+- Support DESTDIR in all Makefiles
+- Fix handling spares in RAID names in vendor metadata
+
 * Tue Jan 12 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-4
 - Change dmraid DSO version to "1" and allow for display of 
   extended internal library version
