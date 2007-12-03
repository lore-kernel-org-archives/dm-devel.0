From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_netapp Makefile
Date: 3 Dec 2007 23:11:52 -0000
Message-ID: <20071203231152.23975.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-12-03 23:11:51

Modified files:
	path_priority/pp_netapp: Makefile 

Log message:
	fix Makefile.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.4&r2=1.2.2.5

--- multipath-tools/path_priority/pp_netapp/Makefile	2007/10/10 16:52:41	1.2.2.4
+++ multipath-tools/path_priority/pp_netapp/Makefile	2007/12/03 23:11:51	1.2.2.5
@@ -17,11 +17,14 @@
 install: $(EXEC)
 	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
-	ln -sf $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/mpath_prio_netapp
-	ln -sf $(DESTDIR)$(bindir)/$(EXEC).static $(DESTDIR)$(bindir)/mpath_prio_netapp.static
+	ln -sf $(EXEC) $(DESTDIR)$(bindir)/mpath_prio_netapp
+	ln -sf $(EXEC).static $(DESTDIR)$(bindir)/mpath_prio_netapp.static
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(bindir)/$(EXEC).static
+	rm $(DESTDIR)$(bindir)/mpath_prio_netapp
+	rm $(DESTDIR)$(bindir)/mpath_prio_netapp.static
+
 clean:	
 	rm -f *.o $(EXEC) $(EXEC).static
