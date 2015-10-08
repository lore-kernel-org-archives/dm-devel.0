From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 06/18] change order of multipath.rules
Date: Thu,  8 Oct 2015 14:44:39 -0500
Message-ID: <1444333491-16265-7-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

At least for RedHat, the rule that calls scsi_id is
60-persistent-storage.rules, so the multipath rule needs to come
after this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/Makefile b/multipath/Makefile
index 7f18e9a..4b3de81 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -23,7 +23,7 @@ install:
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/62-multipath.rules
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
@@ -32,7 +32,7 @@ install:
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
-	rm $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
+	rm $(DESTDIR)$(libudevdir)/rules.d/62-multipath.rules
 	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
 
-- 
1.8.3.1
