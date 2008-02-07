From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority pp_alua/Makefile ...
Date: 7 Feb 2008 22:18:48 -0000
Message-ID: <20080207221848.23410.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-02-07 22:18:47

Modified files:
	path_priority/pp_alua: Makefile 
	path_priority/pp_balance_units: Makefile 
	path_priority/pp_emc: Makefile 
	path_priority/pp_hds_modular: Makefile 
	path_priority/pp_netapp: Makefile 
	path_priority/pp_rdac: Makefile 
	path_priority/pp_tpc: Makefile 

Log message:
	Fix for bz 428338.  Now all of multipath's non-static callouts are just links
	to the static ones. This fixes lockups that were happening when access to the
	root filesystem was lost for devices that needed priority callouts.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_balance_units/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.2&r2=1.2.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_emc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.2&r2=1.4.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hds_modular/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.2&r2=1.2.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.5&r2=1.2.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_rdac/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_tpc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3

--- multipath-tools/path_priority/pp_alua/Makefile	2007/06/15 21:03:13	1.5.2.2
+++ multipath-tools/path_priority/pp_alua/Makefile	2008/02/07 22:18:46	1.5.2.3
@@ -30,15 +30,14 @@
 all: $(BUILD)
 
 glibc:	$(OBJS)
-	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
 	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(BUILD) $(EXEC).8
-	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
-	$(INSTALL) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	$(INSTALL) -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
 	$(INSTALL) -m 644 $(EXEC).8 $(DESTDIR)$(mandir)/$(EXEC).8
 
 uninstall:
@@ -47,7 +46,7 @@
 	rm $(DESTDIR)$(mandir)/$(EXEC).8
 
 clean:	
-	rm -f *.o *.gz $(EXEC) $(EXEC).static
+	rm -f *.o *.gz $(EXEC).static
 
 main.o:	main.c rtpg.h spc3.h
 
--- multipath-tools/path_priority/pp_balance_units/Makefile	2007/06/15 21:03:14	1.2.2.2
+++ multipath-tools/path_priority/pp_balance_units/Makefile	2008/02/07 22:18:46	1.2.2.3
@@ -25,7 +25,6 @@
 	rm -f core *.o *.gz
 
 glibc: prepare $(OBJS)
-	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
 	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc: prepare $(OBJS)
@@ -36,12 +35,12 @@
 
 install:
 	install -d $(DESTDIR)$(bindir)
-	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
 
 clean:
-	rm -f core *.o $(EXEC) $(EXEC).static *.gz
+	rm -f core *.o $(EXEC).static *.gz
--- multipath-tools/path_priority/pp_emc/Makefile	2007/06/15 21:03:14	1.4.2.2
+++ multipath-tools/path_priority/pp_emc/Makefile	2008/02/07 22:18:46	1.4.2.3
@@ -8,21 +8,21 @@
 all: $(BUILD)
 
 glibc:	$(OBJS)
-	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
 	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
-install: $(EXEC)
-	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
-	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+install: $(BUILD)
+	install -d $(DESTDIR)$(bindir)
+	install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
 clean:	
-	rm -f *.o $(EXEC) $(EXEC).static
+	rm -f *.o $(EXEC).static
 
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
--- multipath-tools/path_priority/pp_hds_modular/Makefile	2007/06/15 21:03:14	1.2.2.2
+++ multipath-tools/path_priority/pp_hds_modular/Makefile	2008/02/07 22:18:46	1.2.2.3
@@ -8,18 +8,18 @@
 all: $(BUILD)
 
 glibc:	$(OBJS)
-	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
 	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
-install: $(EXEC)
-	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
-	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+install: $(BUILD)
+	install -d $(DESTDIR)$(bindir)
+	install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
 clean:	
-	rm -f *.o $(EXEC) $(EXEC).static
+	rm -f *.o $(EXEC).static
--- multipath-tools/path_priority/pp_netapp/Makefile	2007/12/03 23:11:51	1.2.2.5
+++ multipath-tools/path_priority/pp_netapp/Makefile	2008/02/07 22:18:46	1.2.2.6
@@ -8,16 +8,16 @@
 all: $(BUILD)
 
 glibc:	$(OBJS)
-	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
 	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
-install: $(EXEC)
-	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
-	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
-	ln -sf $(EXEC) $(DESTDIR)$(bindir)/mpath_prio_netapp
+install: $(BUILD)
+	install -d $(DESTDIR)$(bindir)
+	install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/mpath_prio_netapp
 	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/mpath_prio_netapp.static
 
 uninstall:
@@ -27,4 +27,4 @@
 	rm $(DESTDIR)$(bindir)/mpath_prio_netapp.static
 
 clean:	
-	rm -f *.o $(EXEC) $(EXEC).static
+	rm -f *.o $(EXEC).static
--- multipath-tools/path_priority/pp_rdac/Attic/Makefile	2007/06/15 21:03:14	1.1.2.2
+++ multipath-tools/path_priority/pp_rdac/Attic/Makefile	2008/02/07 22:18:47	1.1.2.3
@@ -8,22 +8,22 @@
 all: $(BUILD)
 
 glibc:	$(OBJS)
-	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
 	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
-install: $(EXEC)
-	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
-	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+install: $(BUILD)
+	install -d $(DESTDIR)$(bindir)
+	install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
 
 clean:
-	rm -f *.o $(EXEC) $(EXEC).static
+	rm -f *.o $(EXEC).static
 
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
--- multipath-tools/path_priority/pp_tpc/Makefile	2007/06/15 21:03:14	1.1.2.2
+++ multipath-tools/path_priority/pp_tpc/Makefile	2008/02/07 22:18:47	1.1.2.3
@@ -8,18 +8,18 @@
 all: $(BUILD)
 
 glibc:	$(OBJS)
-	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
 	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
-install: $(EXEC)
-	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
-	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+install: $(BUILD)
+	install -d $(DESTDIR)$(bindir)
+	install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
 clean:	
-	rm -f *.o $(EXEC) $(EXEC).static
+	rm -f *.o $(EXEC).static
