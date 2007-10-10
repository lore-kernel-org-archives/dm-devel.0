From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_netapp Makefile
Date: 10 Oct 2007 16:52:42 -0000
Message-ID: <20071010165242.11324.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-10-10 16:52:41

Modified files:
	path_priority/pp_netapp: Makefile 

Log message:
	O.k. mpath_prio_netapp is now a symlink to mpath_prio_ontap.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.3&r2=1.2.2.4

--- multipath-tools/path_priority/pp_netapp/Makefile	2007/10/09 21:48:20	1.2.2.3
+++ multipath-tools/path_priority/pp_netapp/Makefile	2007/10/10 16:52:41	1.2.2.4
@@ -1,4 +1,4 @@
-EXEC		= mpath_prio_netapp
+EXEC		= mpath_prio_ontap
 BUILD		= glibc
 OBJS		= pp_netapp.o
 
@@ -17,7 +17,8 @@
 install: $(EXEC)
 	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
-	ln -s $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/mpath_prio_ontap
+	ln -sf $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/mpath_prio_netapp
+	ln -sf $(DESTDIR)$(bindir)/$(EXEC).static $(DESTDIR)$(bindir)/mpath_prio_netapp.static
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
