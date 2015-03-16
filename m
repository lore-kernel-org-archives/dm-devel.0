From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/78] Add multipath rules for systemd support
Date: Mon, 16 Mar 2015 13:35:56 +0100
Message-ID: <1426509425-15978-10-git-send-email-hare@suse.de>
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

Systemd and dracut rely on the DM_MULTIPATH_DEVICE_PATH setting
to mark the devices as used by multipathing. So add a ruleset
providing this setting.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/Makefile        |  2 ++
 multipath/multipath.rules | 13 +++++++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 multipath/multipath.rules

diff --git a/multipath/Makefile b/multipath/Makefile
index e295676..9f2e963 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -23,6 +23,7 @@ install:
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/40-multipath.rules
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
@@ -31,6 +32,7 @@ install:
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
 	rm $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
+	rm $(DESTDIR)$(libudevdir)/rules.d/40-multipath.rules
 	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
 
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
new file mode 100644
index 0000000..799fbb0
--- /dev/null
+++ b/multipath/multipath.rules
@@ -0,0 +1,13 @@
+# Set DM_MULTIPATH_DEVICE_PATH if the device should be handled by multipath
+SUBSYSTEM!="block", GOTO="end_mpath"
+
+ENV{MPATH_SBIN_PATH}="/sbin"
+TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
+
+SUBSYSTEM=="block", ACTION=="add|change", KERNEL!="dm-*", \
+	ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
+	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -v 0 -c $tempnode", \
+	ENV{DM_MULTIPATH_DEVICE_PATH}="1" \
+	ENV{SYSTEMD_READY}="0"
+
+LABEL="end_mpath"
-- 
1.8.4.5
