From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 11 Sep 2009 15:19:51 -0000
Message-ID: <20090911151951.16467.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-09-11 15:19:51

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 
	multipathd     : main.c 
	path_priority/pp_netapp: Makefile 

Log message:
	Fix for bz #452340, #469845, and #493400
	
	Fix makefile install issue, multipathd umask, and update default configuration.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.12&r2=1.5.2.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.16&r2=1.16.2.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.7&r2=1.66.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1.2.2&r2=1.1.2.3

--- multipath-tools/multipath.conf.defaults	2009/01/17 00:46:51	1.5.2.12
+++ multipath-tools/multipath.conf.defaults	2009/09/11 15:19:50	1.5.2.13
@@ -56,7 +56,7 @@
 #       }
 #       device {
 #               vendor                  "(COMPAQ|HP)"
-#               product                 "HSV1[01]1|HSV2[01]0|HSV300"
+#               product                 "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0"
 #               path_grouping_policy    group_by_prio
 #               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
 #               path_checker            "tur"
--- multipath-tools/libmultipath/hwtable.c	2009/01/17 00:46:51	1.16.2.16
+++ multipath-tools/libmultipath/hwtable.c	2009/09/11 15:19:50	1.16.2.17
@@ -35,14 +35,14 @@
 	                   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n",
 	                   "0", "0", "tur", -FAILBACK_IMMEDIATE, NULL, 12, 0,
 	                   100);
-	r += store_hwe_ext(hw, "COMPAQ", "MSA|HSV1.0.*", GROUP_BY_PRIO,
-	                   DEFAULT_GETUID, "/sbin/mpath_prio_hp_sw /dev/%n",
-	                   "1 hp-sw", "0", "hp_sw", FAILBACK_UNDEF, NULL, 12, 0,
-	                   100);
-	r += store_hwe_ext(hw, "(COMPAQ|HP)", "HSV1[01]1|HSV2[01]0|HSV300",
+	r += store_hwe_ext(hw, "(COMPAQ|HP)", "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0",
 			   GROUP_BY_PRIO, DEFAULT_GETUID,
 			   "/sbin/mpath_prio_alua /dev/%n", "0", "0", "tur",
 			   -FAILBACK_IMMEDIATE, NULL, 12, 0, 100);
+	r += store_hwe_ext(hw, "COMPAQ", "MSA|HSV1.0.*", GROUP_BY_PRIO,
+                           DEFAULT_GETUID, "/sbin/mpath_prio_hp_sw /dev/%n",
+                           "1 hp-sw", "0", "hp_sw", FAILBACK_UNDEF, NULL, 12, 0,
+                           100);
 	r += store_hwe_ext(hw, "HP", "MSA2[02]12fc|MSA2012i", MULTIBUS, DEFAULT_GETUID,
 			   NULL, "0", "0", "tur", -FAILBACK_IMMEDIATE, NULL, 18,
 			   0, 100);
--- multipath-tools/multipathd/main.c	2009/09/01 20:38:40	1.66.2.7
+++ multipath-tools/multipathd/main.c	2009/09/11 15:19:50	1.66.2.8
@@ -1181,6 +1181,7 @@
 	add_handler(DISABLEQ+MAP, cli_disable_queueing);
 	add_handler(RESTOREQ+MAP, cli_restore_queueing);
 
+	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
 
 	return NULL;
@@ -1781,7 +1782,6 @@
 	close(in_fd);
 	close(out_fd);
 	chdir("/");
-	umask(0);
 	return 0;
 }
 
--- multipath-tools/path_priority/pp_netapp/Makefile	2009/01/13 22:26:37	1.1.2.2
+++ multipath-tools/path_priority/pp_netapp/Makefile	2009/09/11 15:19:51	1.1.2.3
@@ -18,7 +18,7 @@
 
 install: $(EXEC)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
-	ln -sf $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/$(LINK)
+	ln -sf $(EXEC) $(DESTDIR)$(bindir)/$(LINK)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
