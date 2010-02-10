From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 10 Feb 2010 04:11:19 -0000
Message-ID: <20100210041119.19436.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-02-10 04:11:18

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 
	multipath      : multipath.conf.5 

Log message:
	Fix for bz 545822 and 554830.  Change to the Invista default configuration, and
	a fix for a typo in the multipath.conf file

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.19&r2=1.5.4.20
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.26&r2=1.20.2.27
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.5.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3

--- multipath-tools/multipath.conf.defaults	2010/01/26 05:50:44	1.5.4.19
+++ multipath-tools/multipath.conf.defaults	2010/02/10 04:11:18	1.5.4.20
@@ -245,7 +245,7 @@
 #               features                "0"
 #               hardware_handler        "0"
 #               path_selector           "round-robin 0"
-#               path_grouping_policy    failover
+#               path_grouping_policy    multibus
 #               rr_weight               uniform
 #               no_path_retry           5
 #               rr_min_io               1000
--- multipath-tools/libmultipath/hwtable.c	2010/01/26 05:50:45	1.20.2.26
+++ multipath-tools/libmultipath/hwtable.c	2010/02/10 04:11:18	1.20.2.27
@@ -309,7 +309,7 @@
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = FAILOVER,
+		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 5,
--- multipath-tools/multipath/Attic/multipath.conf.5	2009/05/15 21:01:27	1.1.2.2
+++ multipath-tools/multipath/Attic/multipath.conf.5	2010/02/10 04:11:18	1.1.2.3
@@ -251,7 +251,7 @@
 is shutdown. Default is
 .I yes
 .TP
-.B binding_file
+.B bindings_file
 Sets the location for the multipath bindings file that is used with
 the user_friendly_names option. Default is
 .I /etc/multipath_bindings
