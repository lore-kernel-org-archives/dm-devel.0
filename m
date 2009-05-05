From: bmarzins@sourceware.org
Subject: multipath-tools ./Makefile.inc ./multipath.con ...
Date: 5 May 2009 22:02:32 -0000
Message-ID: <20090505220232.3766.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-05-05 22:02:31

Modified files:
	.              : Makefile.inc multipath.conf.annotated 
	libmultipath   : hwtable.c 
	multipath      : Makefile 
Added files:
	multipath      : multipath.conf.5 

Log message:
	Fixes for bzs #462776, #481227, #485296, and #489030
	These are all fixes to either config files or documentation.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.inc.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.11&r2=1.18.2.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.17&r2=1.20.2.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.5.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17&r2=1.17.2.1

--- multipath-tools/Makefile.inc	2006/06/06 18:32:43	1.3
+++ multipath-tools/Makefile.inc	2009/05/05 22:02:30	1.3.2.1
@@ -26,6 +26,7 @@
 checkersdir = $(TOPDIR)/libcheckers
 multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
+man5dir      = $(prefix)/usr/share/man/man5
 rcdir	    = $(prefix)/etc/init.d
 
 GZIP        = /bin/gzip -9 -c
--- multipath-tools/multipath.conf.annotated	2009/04/29 04:41:32	1.18.2.11
+++ multipath-tools/multipath.conf.annotated	2009/05/05 22:02:30	1.18.2.12
@@ -28,7 +28,9 @@
 #	#
 #	# name    : polling_interval
 #	# scope   : multipathd
-#	# desc    : interval between two path checks in seconds
+#	# desc    : How often a path's state is checked, in seconds.  For
+#	#           paths that are usable, the time between checks will
+#	#           gradually increase to (4 * polling_interval).
 #	# default : 5
 #	#
 #	polling_interval 10
--- multipath-tools/libmultipath/hwtable.c	2009/04/03 15:09:02	1.20.2.17
+++ multipath-tools/libmultipath/hwtable.c	2009/05/05 22:02:31	1.20.2.18
@@ -338,9 +338,9 @@
 		.checker_name  = RDAC,
 	},
 	{
-		/* IBM DS3400 */
+		/* IBM DS4100 */
 		.vendor        = "IBM",
-		.product       = "1726-4xx",
+		.product       = "1724",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = "1 queue_if_no_path",
@@ -354,7 +354,23 @@
 		.checker_name  = RDAC,
 	},
 	{
-		/* IBM DS4100 / FAStT100 */
+		/* IBM DS3200, IBM DS3300, IBM DS3400 */
+		.vendor        = "IBM",
+		.product       = "1726",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 300,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	{
+		/* IBM DS4400 / DS4500 / FAStT100 */
 		.vendor        = "IBM",
 		.product       = "1742",
 		.getuid        = DEFAULT_GETUID,
@@ -370,6 +386,22 @@
 		.checker_name  = RDAC,
 	},
 	{
+		/* IBM DS4700 */
+		.vendor        = "IBM",
+		.product       = "1814",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	{
 		/* IBM DS4800 */
 		.vendor        = "IBM",
 		.product       = "1815",
@@ -386,6 +418,22 @@
 		.checker_name  = RDAC,
 	},
 	{
+		/* IBM DS5000 */
+		.vendor        = "IBM",
+		.product       = "1818",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	{
 		/* IBM Netfinity Fibre Channel RAID Controller Unit */
 		.vendor        = "IBM",
 		.product       = "3526",
@@ -741,6 +789,27 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = READSECTOR0,
 	},
+	/*
+	 * Compellent Technologies, Inc.
+	 *
+	 * Maintainer : Jim Lester, Compellent
+	 * Mail : jim.lester@compellent.com
+	 */
+	{
+		.vendor        = "COMPELNT",
+		.product       = "Compellent Vol",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
 	/* 
 	 * GNBD devices
 	 *
--- multipath-tools/multipath/Makefile	2006/11/30 23:25:13	1.17
+++ multipath-tools/multipath/Makefile	2009/05/05 22:02:31	1.17.2.1
@@ -41,6 +41,8 @@
 	install -m 644 multipath.rules $(DESTDIR)/etc/udev/rules.d/40-multipath.rules
 	install -d $(DESTDIR)$(mandir)
 	install -m 644 $(EXEC).8 $(DESTDIR)$(mandir)
+	install -d $(DESTDIR)$(man5dir)
+	install -m 644 $(EXEC).5 $(DESTDIR)$(man5dir)
 	@if [ ! -e $(DESTDIR)/etc/multipath.conf ]; then \
 		install -m 644 multipath.conf.redhat  $(DESTDIR)/etc/multipath.conf; \
 	fi
@@ -53,6 +55,7 @@
 	rm $(DESTDIR)$(bindir)/mpath_wait
 	rm $(DESTDIR)$(bindir)/mpath_ctl
 	rm $(DESTDIR)$(mandir)/$(EXEC).8
+	rm $(DESTDIR)$(mandir)/$(EXEC).conf.5
 
 clean:
 	$(MAKE) -C $(multipathdir) clean
