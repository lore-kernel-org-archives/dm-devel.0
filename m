From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/9] multipath-tools: remove incdir from Makefiles
Date: Fri,  7 Apr 2017 01:16:31 -0500
Message-ID: <1491545798-22183-3-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Makefile.in defines both incdir and includedir, and they are both the
same. This patch removes incdir, and makes all the Makefiles use
includedir.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc             | 1 -
 libmpathcmd/Makefile     | 6 +++---
 libmpathpersist/Makefile | 6 +++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 740081e..c8b1142 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -55,7 +55,6 @@ man8dir		= $(prefix)/usr/share/man/man8
 man5dir		= $(prefix)/usr/share/man/man5
 man3dir		= $(prefix)/usr/share/man/man3
 syslibdir	= $(prefix)/$(LIB)
-incdir		= $(prefix)/usr/include
 libdir		= $(prefix)/$(LIB)/multipath
 unitdir		= $(prefix)/$(SYSTEMDPATH)/systemd/system
 mpathpersistdir	= $(TOPDIR)/libmpathpersist
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index b8e29cb..9cda94c 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -16,13 +16,13 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
-	$(INSTALL_PROGRAM) -d $(DESTDIR)$(incdir)
-	$(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR)$(incdir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(includedir)
+	$(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR)$(includedir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
-	$(RM) $(DESTDIR)$(incdir)/mpath_cmd.h
+	$(RM) $(DESTDIR)$(includedir)/mpath_cmd.h
 
 clean:
 	$(RM) core *.a *.o *.so *.so.* *.gz
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 96da639..857c8d8 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -24,17 +24,17 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
-	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(incdir)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(includedir)
 	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
-	$(INSTALL_PROGRAM) -m 644 mpath_persist.h $(DESTDIR)$(incdir)
+	$(INSTALL_PROGRAM) -m 644 mpath_persist.h $(DESTDIR)$(includedir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz
 	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz
-	$(RM) $(DESTDIR)$(incdir)/mpath_persist.h
+	$(RM) $(DESTDIR)$(includedir)/mpath_persist.h
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean:
-- 
1.8.3.1
