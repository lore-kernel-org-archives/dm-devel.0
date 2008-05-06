From: bmarzins@sourceware.org
Subject: multipath-tools devmap_name/Makefile kpartx/Ma ...
Date: 6 May 2008 19:49:41 -0000
Message-ID: <20080506194941.1784.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-05-06 19:49:39

Modified files:
	devmap_name    : Makefile 
	kpartx         : Makefile 
	multipath      : Makefile 
	path_priority/pp_alua: Makefile 
	path_priority/pp_balance_units: Makefile 
	path_priority/pp_emc: Makefile 
	path_priority/pp_hds_modular: Makefile 
	path_priority/pp_netapp: Makefile 

Log message:
	removed strip commands from Makefile

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/devmap_name/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.12&r2=1.12.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_balance_units/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_emc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.3&r2=1.3.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hds_modular/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1

--- multipath-tools/devmap_name/Makefile	2005/04/05 14:06:43	1.2
+++ multipath-tools/devmap_name/Makefile	2008/05/06 19:49:38	1.2.2.1
@@ -23,12 +23,10 @@
 
 glibc: prepare $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
-	$(STRIP) $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 	
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
-	$(STRIP) $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install:
--- multipath-tools/kpartx/Makefile	2007/10/22 18:44:31	1.5.2.2
+++ multipath-tools/kpartx/Makefile	2008/05/06 19:49:38	1.5.2.3
@@ -31,7 +31,6 @@
 	
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
-	$(STRIP) $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 $(MULTIPATHLIB)-$(BUILD).a:
--- multipath-tools/multipath/Makefile	2006/05/12 22:17:13	1.12
+++ multipath-tools/multipath/Makefile	2008/05/06 19:49:38	1.12.2.1
@@ -31,7 +31,6 @@
 	
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
-	$(STRIP) $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 $(CHECKERSLIB)-$(BUILD).a:
--- multipath-tools/path_priority/pp_alua/Makefile	2005/10/12 21:57:26	1.4
+++ multipath-tools/path_priority/pp_alua/Makefile	2008/05/06 19:49:38	1.4.2.1
@@ -36,7 +36,6 @@
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
-	$(STRIP) $(EXEC)
 
 install: $(EXEC)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
--- multipath-tools/path_priority/pp_balance_units/Makefile	2005/05/05 20:07:23	1.1
+++ multipath-tools/path_priority/pp_balance_units/Makefile	2008/05/06 19:49:38	1.1.2.1
@@ -27,11 +27,9 @@
 
 glibc: prepare $(OBJS)
 	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
-	$(STRIP) $(EXEC)
 	
 klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(CRT0) $(OBJS) $(KLIBC) $(LIBGCC)
-	$(STRIP) $(EXEC)
 
 $(MULTIPATHLIB)-$(BUILD).a:
 	make -C $(multipathdir) BUILD=$(BUILD) $(BUILD)
--- multipath-tools/path_priority/pp_emc/Makefile	2005/07/20 23:34:54	1.3
+++ multipath-tools/path_priority/pp_emc/Makefile	2008/05/06 19:49:38	1.3.2.1
@@ -14,7 +14,6 @@
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
-	$(STRIP) $(EXEC)
 
 install: $(EXEC)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
--- multipath-tools/path_priority/pp_hds_modular/Makefile	2006/04/24 23:51:28	1.1
+++ multipath-tools/path_priority/pp_hds_modular/Makefile	2008/05/06 19:49:38	1.1.2.1
@@ -14,7 +14,6 @@
 
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
-	$(STRIP) $(EXEC)
 
 install: $(EXEC)
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
--- multipath-tools/path_priority/pp_netapp/Makefile	2005/11/21 23:28:32	1.1
+++ multipath-tools/path_priority/pp_netapp/Makefile	2008/05/06 19:49:39	1.1.2.1
@@ -16,7 +16,7 @@
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
