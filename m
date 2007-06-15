From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority pp_alua/Makefile ...
Date: 15 Jun 2007 19:05:23 -0000
Message-ID: <20070615190523.3969.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-15 19:05:22

Modified files:
	path_priority/pp_alua: Makefile 
	path_priority/pp_balance_units: Makefile 
	path_priority/pp_emc: Makefile 
	path_priority/pp_hds_modular: Makefile 
	path_priority/pp_netapp: Makefile 
	path_priority/pp_tpc: Makefile 

Log message:
	Applied Bryn's patch for 243483 (multipath-tools-0.4.7.rhel5.2-ppstatic.patch)
	multipath now builds static versions of the path_priority callouts

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_balance_units/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_emc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hds_modular/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_tpc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1

--- multipath-tools/path_priority/pp_alua/Makefile	2006/06/06 18:32:44	1.5
+++ multipath-tools/path_priority/pp_alua/Makefile	2007/06/15 19:05:21	1.5.2.1
@@ -31,11 +31,13 @@
 
 glibc:	$(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(BUILD) $(EXEC).8
+	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	$(INSTALL) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 	$(INSTALL) -m 644 $(EXEC).8 $(DESTDIR)$(mandir)/$(EXEC).8
 
--- multipath-tools/path_priority/pp_balance_units/Makefile	2006/06/06 18:32:44	1.2
+++ multipath-tools/path_priority/pp_balance_units/Makefile	2007/06/15 19:05:21	1.2.2.1
@@ -35,6 +35,7 @@
 
 install:
 	install -d $(DESTDIR)$(bindir)
+	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 
 uninstall:
--- multipath-tools/path_priority/pp_emc/Makefile	2006/06/06 18:32:44	1.4
+++ multipath-tools/path_priority/pp_emc/Makefile	2007/06/15 19:05:21	1.4.2.1
@@ -9,11 +9,13 @@
 
 glibc:	$(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
+	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
--- multipath-tools/path_priority/pp_hds_modular/Makefile	2006/06/06 18:32:44	1.2
+++ multipath-tools/path_priority/pp_hds_modular/Makefile	2007/06/15 19:05:21	1.2.2.1
@@ -9,11 +9,13 @@
 
 glibc:	$(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
+	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
--- multipath-tools/path_priority/pp_netapp/Makefile	2006/06/06 18:32:44	1.2
+++ multipath-tools/path_priority/pp_netapp/Makefile	2007/06/15 19:05:22	1.2.2.1
@@ -9,11 +9,13 @@
 
 glibc:	$(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
+	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
--- multipath-tools/path_priority/pp_tpc/Makefile	2006/06/06 18:46:38	1.1
+++ multipath-tools/path_priority/pp_tpc/Makefile	2007/06/15 19:05:22	1.1.2.1
@@ -9,11 +9,13 @@
 
 glibc:	$(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
+	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
