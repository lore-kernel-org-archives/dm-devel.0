From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/11] multipath: do not install rules file
Date: Thu, 17 Jan 2013 15:59:32 +0100
Message-ID: <1358434773-2002-11-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
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

multipathd now uses libudev, so the rules file is not required.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/Makefile        |    3 ---
 multipath/multipath.rules |    7 -------
 2 files changed, 10 deletions(-)
 delete mode 100644 multipath/multipath.rules

diff --git a/multipath/Makefile b/multipath/Makefile
index f748417..593c78d 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -21,15 +21,12 @@ $(EXEC): $(OBJS)
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
-	$(INSTALL_PROGRAM) -d $(DESTDIR)/etc/udev/rules.d
-	$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)/etc/udev/rules.d/
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5.gz $(DESTDIR)$(man5dir)
 
 uninstall:
-	rm $(DESTDIR)/etc/udev/rules.d/multipath.rules
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
deleted file mode 100644
index ac97749..0000000
--- a/multipath/multipath.rules
+++ /dev/null
@@ -1,7 +0,0 @@
-#
-# udev rules for multipathing.
-# The persistent symlinks are created with the kpartx rules
-#
-
-# socket for uevents
-SUBSYSTEM=="block", RUN+="socket:/org/kernel/dm/multipath_event"
-- 
1.7.10.4
