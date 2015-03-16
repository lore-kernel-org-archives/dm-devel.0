From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/78] Install multipath rule under
	'56-multipath.rules'
Date: Mon, 16 Mar 2015 13:36:10 +0100
Message-ID: <1426509425-15978-24-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The multipath rule needs to be inserted between the
sg3_utils rules for it to be able to intercept
symlink generation.

References: bnc#873151

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/Makefile b/multipath/Makefile
index 9f2e963..7f18e9a 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -23,7 +23,7 @@ install:
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/40-multipath.rules
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
@@ -32,7 +32,7 @@ install:
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
-	rm $(DESTDIR)$(libudevdir)/rules.d/40-multipath.rules
+	rm $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
 	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
 
-- 
1.8.4.5
