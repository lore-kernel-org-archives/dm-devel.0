From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority pp_alua/Makefile ...
Date: 15 Jun 2007 21:03:15 -0000
Message-ID: <20070615210315.14667.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-15 21:03:14

Modified files:
	path_priority/pp_alua: Makefile 
	path_priority/pp_balance_units: Makefile 
	path_priority/pp_emc: Makefile 
	path_priority/pp_hds_modular: Makefile 
	path_priority/pp_netapp: Makefile 
	path_priority/pp_rdac: Makefile 
	path_priority/pp_tpc: Makefile 

Log message:
	Did a some more makefile cleanup for bz # 243483

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_balance_units/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.1&r2=1.2.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_emc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.1&r2=1.4.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hds_modular/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.1&r2=1.2.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.1&r2=1.2.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_rdac/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_tpc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2

--- multipath-tools/path_priority/pp_alua/Makefile	2007/06/15 19:05:21	1.5.2.1
+++ multipath-tools/path_priority/pp_alua/Makefile	2007/06/15 21:03:13	1.5.2.2
@@ -43,10 +43,11 @@
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(EXEC).static
 	rm $(DESTDIR)$(mandir)/$(EXEC).8
 
 clean:	
-	rm -f *.o *.gz $(EXEC)
+	rm -f *.o *.gz $(EXEC) $(EXEC).static
 
 main.o:	main.c rtpg.h spc3.h
 
--- multipath-tools/path_priority/pp_balance_units/Makefile	2007/06/15 19:05:21	1.2.2.1
+++ multipath-tools/path_priority/pp_balance_units/Makefile	2007/06/15 21:03:14	1.2.2.2
@@ -26,6 +26,7 @@
 
 glibc: prepare $(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
@@ -40,6 +41,7 @@
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(EXEC).static
 
 clean:
-	rm -f core *.o $(EXEC) *.gz
+	rm -f core *.o $(EXEC) $(EXEC).static *.gz
--- multipath-tools/path_priority/pp_emc/Makefile	2007/06/15 19:05:21	1.4.2.1
+++ multipath-tools/path_priority/pp_emc/Makefile	2007/06/15 21:03:14	1.4.2.2
@@ -20,8 +20,9 @@
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(EXEC).static
 clean:	
-	rm -f *.o $(EXEC)
+	rm -f *.o $(EXEC) $(EXEC).static
 
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
--- multipath-tools/path_priority/pp_hds_modular/Makefile	2007/06/15 19:05:21	1.2.2.1
+++ multipath-tools/path_priority/pp_hds_modular/Makefile	2007/06/15 21:03:14	1.2.2.2
@@ -20,5 +20,6 @@
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(EXEC).static
 clean:	
-	rm -f *.o $(EXEC)
+	rm -f *.o $(EXEC) $(EXEC).static
--- multipath-tools/path_priority/pp_netapp/Makefile	2007/06/15 19:05:22	1.2.2.1
+++ multipath-tools/path_priority/pp_netapp/Makefile	2007/06/15 21:03:14	1.2.2.2
@@ -20,5 +20,6 @@
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(EXEC).static
 clean:	
-	rm -f *.o $(EXEC)
+	rm -f *.o $(EXEC) $(EXEC).static
--- multipath-tools/path_priority/pp_rdac/Attic/Makefile	2007/06/01 00:26:42	1.1.2.1
+++ multipath-tools/path_priority/pp_rdac/Attic/Makefile	2007/06/15 21:03:14	1.1.2.2
@@ -9,17 +9,21 @@
 
 glibc:	$(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+	$(CC) -static -o $(EXEC).static $(OBJS) $(LDFLAGS)
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(EXEC).static
+
 clean:
-	rm -f *.o $(EXEC)
+	rm -f *.o $(EXEC) $(EXEC).static
 
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
--- multipath-tools/path_priority/pp_tpc/Makefile	2007/06/15 19:05:22	1.1.2.1
+++ multipath-tools/path_priority/pp_tpc/Makefile	2007/06/15 21:03:14	1.1.2.2
@@ -20,5 +20,6 @@
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(bindir)/$(EXEC).static
 clean:	
-	rm -f *.o $(EXEC)
+	rm -f *.o $(EXEC) $(EXEC).static
