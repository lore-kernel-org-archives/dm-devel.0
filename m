From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 21 Jan 2011 16:57:45 -0000
Message-ID: <20110121165745.25363.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2011-01-21 16:57:44

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Remove old config entry, and update multipath.conf.defaults

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.13&r2=1.5.2.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.18&r2=1.16.2.19

--- multipath-tools/multipath.conf.defaults	2009/09/11 15:19:50	1.5.2.13
+++ multipath-tools/multipath.conf.defaults	2011/01/21 16:57:43	1.5.2.14
@@ -87,9 +87,9 @@
 #               vendor                  "HP"
 #               product                 "HSVX700"
 #               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
-#		hardware_handler	"1 alua"
-#               path_checker            tur
+#               prio_callout            "/sbin/mpath_prio_hp_sw /dev/%n"
+#		hardware_handler	"0"
+#               path_checker            hp_sw
 #		failback		immediate
 #               no_path_retry           12
 #		rr_min_io		100
--- multipath-tools/libmultipath/hwtable.c	2010/10/27 18:55:55	1.16.2.18
+++ multipath-tools/libmultipath/hwtable.c	2011/01/21 16:57:44	1.16.2.19
@@ -54,10 +54,6 @@
 			   GROUP_BY_PRIO, DEFAULT_GETUID,
 			   "/sbin/mpath_prio_alua /dev/%n", "0", "0", "tur",
 			   -FAILBACK_IMMEDIATE, NULL, 18, 0, 100);
-        r += store_hwe_ext(hw, "HP", "HSVX700",
-			   GROUP_BY_PRIO, DEFAULT_GETUID,
-			   "/sbin/mpath_prio_alua /dev/%n", "1 alua", "0",
-			   "tur", -FAILBACK_IMMEDIATE, NULL, 12, 0, 100);
 	r += store_hwe_ext(hw, "HP", "MSA2000s*", MULTIBUS, "/sbin/cciss_id %n",
 	                   NULL, "0", "0", "cciss_tur", FAILBACK_UNDEF, NULL,
 	                   12, 0, 0);
