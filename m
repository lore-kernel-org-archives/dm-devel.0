From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/8] libmpathcmd: Do not install header file as
	executable
Date: Fri,  3 Jun 2016 08:40:38 +0200
Message-ID: <1464936038-709-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Our build system complained that the mpath_cmd.h header file is
installed as executable.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathcmd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 0304ecc..6fca165 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -19,7 +19,7 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	ln -sf $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(incdir)
-	$(INSTALL_PROGRAM) -m 755 mpath_cmd.h $(DESTDIR)$(incdir)
+	$(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR)$(incdir)
 
 uninstall:
 	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
-- 
2.6.6
