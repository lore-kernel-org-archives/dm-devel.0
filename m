From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 13 Jan 2009 22:26:38 -0000
Message-ID: <20090113222638.14120.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2009-01-13 22:26:37

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 
	path_priority/pp_netapp: Makefile pp_netapp.c 

Log message:
	Fix for bz #478643
	This is just a backport of 282131.  It fixes some prio callout issues, and
	switches the name

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.9&r2=1.5.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.13&r2=1.16.2.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/pp_netapp.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1

--- multipath-tools/multipath.conf.defaults	2007/12/03 18:42:15	1.5.2.9
+++ multipath-tools/multipath.conf.defaults	2009/01/13 22:26:36	1.5.2.10
@@ -197,7 +197,7 @@
 #		product			"LUN"
 #		path_grouping_policy	group_by_prio
 #		getuid_callout          "/sbin/scsi_id -g -u -s"
-#		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
+#		prio_callout		"/sbin/mpath_prio_ontap /dev/%n"
 #		features		"1 queue_if_no_path"
 #		path_checker		readsector0
 #	}
@@ -206,7 +206,7 @@
 #		product			"Nseries"
 #		path_grouping_policy	group_by_prio
 #		getuid_callout          "/sbin/scsi_id -g -u -s"
-#		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
+#		prio_callout		"/sbin/mpath_prio_ontap /dev/%n"
 #		features		"1 queue_if_no_path"
 #		path_checker		readsector0
 #		failback		immediate
--- multipath-tools/libmultipath/hwtable.c	2007/12/03 18:42:15	1.16.2.13
+++ multipath-tools/libmultipath/hwtable.c	2009/01/13 22:26:37	1.16.2.14
@@ -70,10 +70,10 @@
 		   "/sbin/dasdview -j -f /dev/%n", NULL, "0", "0",
 		   "directio", FAILBACK_UNDEF, "S/390", 0, 0, 0);
 	r += store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO, DEFAULT_GETUID,
-		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
+		  "/sbin/mpath_prio_ontap /dev/%n", NULL,
 		  "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "Nseries", GROUP_BY_PRIO, DEFAULT_GETUID,
-		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
+		  "/sbin/mpath_prio_ontap /dev/%n", NULL,
 		  "1 queue_if_no_path", "readsector0", -FAILBACK_IMMEDIATE,
 		  NULL, 0, 0, 128);
 	r += store_hwe_ext(hw, "Pillar", "Axiom 500", GROUP_BY_PRIO,
--- multipath-tools/path_priority/pp_netapp/Makefile	2008/05/06 19:49:39	1.1.2.1
+++ multipath-tools/path_priority/pp_netapp/Makefile	2009/01/13 22:26:37	1.1.2.2
@@ -1,4 +1,5 @@
-EXEC		= mpath_prio_netapp
+EXEC		= mpath_prio_ontap
+LINK		= mpath_prio_netapp
 BUILD		= glibc
 OBJS		= pp_netapp.o
 
@@ -17,9 +18,11 @@
 
 install: $(EXEC)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	ln -sf $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/$(LINK)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(LINK)
 clean:	
 	rm -f *.o $(EXEC)
 
--- multipath-tools/path_priority/pp_netapp/pp_netapp.c	2005/11/21 23:28:32	1.1
+++ multipath-tools/path_priority/pp_netapp/pp_netapp.c	2009/01/13 22:26:37	1.1.2.1
@@ -29,7 +29,7 @@
 #define INQUIRY_CMDLEN	6
 #define DEFAULT_PRIO	10
 #define RESULTS_MAX	256
-#define SG_TIMEOUT	30000
+#define SG_TIMEOUT	60000
 
 
 static void dump_cdb(unsigned char *cdb, int size)
@@ -209,7 +209,7 @@
 
 	memset(&results, 0, sizeof (results));
 	rc = send_gva(dev, 0x41, results, &results_size);
-	if (rc == 0) {
+	if (rc >= 0) {
 		tot_len = results[0] << 24 | results[1] << 16 |
 			  results[2] << 8 | results[3];
 		if (tot_len <= 8) {
@@ -229,12 +229,16 @@
 			is_iscsi_hardware = 1;
 			goto prio_select;
 		}
+	} else {
+		return 0;
 	}
 	
  try_fcp_proxy:	
 	rc = get_proxy(dev);
 	if (rc >= 0) {
 		is_proxy = rc;
+	} else {
+		return 0;
 	}
 
  prio_select:
