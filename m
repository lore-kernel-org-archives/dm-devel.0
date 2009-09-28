From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 28 Sep 2009 18:28:49 -0000
Message-ID: <20090928182849.11617.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2009-09-28 18:28:48

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #504619.  MSA 1000s with new firmware can't list the vendor as HP or COMPAQ, same as with the old firmware.  Updated the default configuration to
	match this.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.15&r2=1.5.4.16
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.21&r2=1.20.2.22

--- multipath-tools/multipath.conf.defaults	2009/08/19 21:52:40	1.5.4.15
+++ multipath-tools/multipath.conf.defaults	2009/09/28 18:28:48	1.5.4.16
@@ -71,7 +71,7 @@
 #               path_checker            tur
 #        }
 #       device {
-#               vendor                  "HP"
+#               vendor                  "(COMPAQ|HP)"
 #               product                 "MSA VOLUME"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua %n"	
--- multipath-tools/libmultipath/hwtable.c	2009/08/31 17:17:10	1.20.2.21
+++ multipath-tools/libmultipath/hwtable.c	2009/09/28 18:28:48	1.20.2.22
@@ -108,7 +108,7 @@
 	},
 	{
 		/* MSA 1000/1500 with new firmware */
-		.vendor        = "HP",
+		.vendor        = "(COMPAQ|HP)",
 		.product       = "MSA VOLUME",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
