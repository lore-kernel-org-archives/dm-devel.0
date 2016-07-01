From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/5] multipath-tools: link libmpathcmd.so with
	full path
Date: Fri,  1 Jul 2016 19:17:31 +0200
Message-ID: <1467393452-1032-5-git-send-email-xose.vazquez@gmail.com>
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
 libmpathcmd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 44c221d..20710df 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -17,7 +17,7 @@ $(LIBS): $(OBJS)
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
-	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(LN) $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(incdir)
 	$(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR)$(incdir)
 
-- 
2.7.4
