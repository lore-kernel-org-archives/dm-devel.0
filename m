From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/5] multipath-tools: don't create
	/usr/share/doc/mpathpersist/ from make install
Date: Thu, 30 Jun 2016 15:42:14 +0200
Message-ID: <1467294136-19275-4-git-send-email-xose.vazquez@gmail.com>
References: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
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

Useless, it's empty.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index dd02158..70b2974 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -32,7 +32,6 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(incdir)
-	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/share/doc/mpathpersist/
 	ln -sf $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	install -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
 	install -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
-- 
2.7.4
