From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/57] kpartx: Install rules file with correct
	prefix
Date: Wed, 27 Apr 2016 13:10:05 +0200
Message-ID: <1461755458-29225-5-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

We don't need to swizzle names in the spec file, the Makefile
should be doing it on itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 4ba38ba..501b277 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -28,8 +28,8 @@ install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)
 	$(INSTALL_PROGRAM) -m 755 kpartx_id $(DESTDIR)$(libudevdir)
-	$(INSTALL_PROGRAM) -d $(DESTDIR)/etc/udev/rules.d
-	$(INSTALL_PROGRAM) -m 644 kpartx.rules $(DESTDIR)/etc/udev/rules.d/
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)/rules.d
+	$(INSTALL_PROGRAM) -m 644 kpartx.rules $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
@@ -37,6 +37,8 @@ uninstall:
 	rm -f $(DESTDIR)$(bindir)/$(EXEC)
 	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm -f $(DESTDIR)$(libudevdir)/kpartx_id
+	rm -f $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
+	rm -f $(DESTDIR)$(libudevdir)/rules.d/67-kpartx-compat.rules
 
 clean:
 	rm -f core *.o $(EXEC) *.gz
-- 
2.6.6
