From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/3] multipath-tools: install libs in a standard
	way
Date: Fri,  8 Jul 2016 18:28:19 +0200
Message-ID: <1467995301-14226-2-git-send-email-xose.vazquez@gmail.com>
References: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
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

Drop full path of libmpathpersist when linking,
and add a link for libmultipath.so

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/Makefile | 2 +-
 libmultipath/Makefile    | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index d22bcdd..2f91401 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -32,7 +32,7 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(incdir)
-	$(LN) $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 644 mpath_persist.h $(DESTDIR)$(incdir)
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index de13e47..a14d4b3 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -63,9 +63,11 @@ install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
+	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean:
 	$(RM) core *.a *.o *.gz *.so *.so.*
-- 
2.7.4
