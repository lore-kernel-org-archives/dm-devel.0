From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/5] multipath-tools: replace install with its
	variable in makefiles
Date: Fri,  1 Jul 2016 19:17:29 +0200
Message-ID: <1467393452-1032-3-git-send-email-xose.vazquez@gmail.com>
References: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/Makefile | 6 +++---
 mpathpersist/Makefile    | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 09d196e..6afd3a8 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -33,9 +33,9 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(incdir)
 	ln -sf $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
-	install -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
-	install -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
-	install -m 644 mpath_persist.h $(DESTDIR)$(incdir)
+	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
+	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
+	$(INSTALL_PROGRAM) -m 644 mpath_persist.h $(DESTDIR)$(incdir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 2cc625b..df81372 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -16,10 +16,10 @@ $(EXEC): $(OBJS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 	
 install:
-	install -d $(DESTDIR)$(bindir)
-	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/
-	install -d $(DESTDIR)$(mandir)
-	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	
 clean:
 	$(RM) *.o $(EXEC)
-- 
2.7.4
