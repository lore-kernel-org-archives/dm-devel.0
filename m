From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 26 Oct 2011 04:55:19 -0000
Message-ID: <20111026045519.16977.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-10-26 04:55:18

Modified files:
	libmultipath   : hwtable.c 

Log message:
	fix for bz#742906. Add more HP P2000 product strings.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.35&r2=1.20.2.36

--- multipath-tools/libmultipath/hwtable.c	2011/03/07 05:19:38	1.20.2.35
+++ multipath-tools/libmultipath/hwtable.c	2011/10/26 04:55:18	1.20.2.36
@@ -173,7 +173,7 @@
 	{
                  /* HP P2000 product family */
                 .vendor        = "HP",
-                .product       = "P2000 G3 FC",
+                .product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
                 .getuid        = DEFAULT_GETUID,
                 .getprio       = "/sbin/mpath_prio_alua /dev/%n",
                 .features      = DEFAULT_FEATURES,
