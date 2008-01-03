From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 3 Jan 2008 20:16:06 -0000
Message-ID: <20080103201606.8705.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-01-03 20:16:06

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Configure the Axiom 300 the same as the Axiom 500

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.7&r2=1.5.4.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.10&r2=1.20.2.11

--- multipath-tools/multipath.conf.defaults	2007/10/09 21:48:19	1.5.4.7
+++ multipath-tools/multipath.conf.defaults	2008/01/03 20:16:05	1.5.4.8
@@ -46,7 +46,7 @@
 #	}
 #       device {
 #               vendor                  "(COMPAQ|HP)"
-#               product                 "MSA1.*"
+#               product                 "(MSA|HSV)1.*"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"1 hp_sw"
@@ -57,7 +57,7 @@
 #       }
 #       device {
 #               vendor                  "(COMPAQ|HP)"
-#               product                 "HSV(1|2).*"
+#               product                 "HSV2.*"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua %n"	
 #		features		"0"
@@ -311,7 +311,7 @@
 #	}
 #	device {
 #		vendor			"Pillar"
-#		product			"Axiom 500"
+#		product			"Axiom [35]00"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua %d"	
 #		features		"0"
--- multipath-tools/libmultipath/hwtable.c	2008/01/02 23:38:43	1.20.2.10
+++ multipath-tools/libmultipath/hwtable.c	2008/01/03 20:16:06	1.20.2.11
@@ -434,7 +434,7 @@
 	 */
 	{
 		.vendor        = "Pillar",
-		.product       = "Axiom 500",
+		.product       = "Axiom [35]00",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua %d",
 		.features      = DEFAULT_FEATURES,
