From: Aaro Koskinen <aaro.koskinen@nsn.com>
Subject: [PATCH] libmpathpersist: don't use absolute path in link
	target
Date: Tue, 18 Nov 2014 13:27:36 +0200
Message-ID: <1416310056-17351-1-git-send-email-aaro.koskinen@nsn.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
Cc: Aaro Koskinen <aaro.koskinen@nsn.com>
List-Id: dm-devel.ids

Don't use absolute path in link target. DESTDIR usually points to a
temporary staging directory e.g. when packaging and it should not appear
in symlinks.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
---
 libmpathpersist/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index c4ec1c5..ef8f12b 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -32,7 +32,7 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/include/
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/share/doc/mpathpersist/
-	ln -sf $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	ln -sf $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	install -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)	
 	install -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)	
 	install -m 644 mpath_persist.h $(DESTDIR)/usr/include/
-- 
2.1.1
