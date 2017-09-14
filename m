From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 30/31] kpartx/del-part-nodes.rules: new udev
	file
Date: Thu, 14 Sep 2017 22:00:09 +0200
Message-ID: <20170914200010.19129-1-mwilck@suse.com>
References: <20170913212858.GQ3145@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170913212858.GQ3145@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

A new udev rules file "68-del-part-nodes.rules" is introduced,
based on code from Ben Marzinki. This code deletes partitions on
multipath member devices. The purpose of this is to avoid users
accidentally accessing partitions of member devices rather than of the
multipath devcice. The deletion is done only once for every disk
device. If the user wants to get the partitions back, he can run "partx
-a" or "partprobe" on the disk device.

This code could be extended to wipe partitions on member devices
of non-multipath dm targets if desired.

Means to deactivate this behavior are provided via kernel parameter
"dont_del_part_nodes", or a custom udev rules file setting the
"DONT_DEL_PART_NODES" environment variable.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/Makefile             |  2 ++
 kpartx/del-part-nodes.rules | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)
 create mode 100644 kpartx/del-part-nodes.rules

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 7b75032ef1ab..da1e1fbddce5 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -30,6 +30,7 @@ install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -m 755 kpartx_id $(DESTDIR)$(libudevdir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)/rules.d
 	$(INSTALL_PROGRAM) -m 644 kpartx.rules $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
+	$(INSTALL_PROGRAM) -m 644 del-part-nodes.rules $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
 
@@ -39,6 +40,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(libudevdir)/kpartx_id
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/67-kpartx-compat.rules
+	$(RM) $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
 
 clean:
 	$(RM) core *.o $(EXEC) *.gz
diff --git a/kpartx/del-part-nodes.rules b/kpartx/del-part-nodes.rules
new file mode 100644
index 000000000000..cee945d93a62
--- /dev/null
+++ b/kpartx/del-part-nodes.rules
@@ -0,0 +1,32 @@
+# These rules can delete partitions devnodes for slave devices
+# for certain aggregate devices such as multipath.
+# This is desirable to avoid confusion and keep the number
+# of device nodes and symlinks within limits.
+#
+# This is done only once on the first "add" or "change" event for
+# any given device.
+#
+# To suppress this, use the kernel parameter "dont_del_part_nodes",
+# or create an udev rule file that sets ENV{DONT_DEL_PART_NODES}="1".
+
+SUBSYSTEM!="block", GOTO="end_del_part_nodes"
+KERNEL!="sd*|dasd*|rbd*", GOTO="end_del_part_nodes"
+ACTION!="add|change", GOTO="end_del_part_nodes"
+
+IMPORT{cmdline}="dont_del_part_nodes"
+ENV{dont_del_part_nodes}=="1", GOTO="end_del_part_nodes"
+ENV{DONT_DEL_PART_NODES}=="1", GOTO="end_del_part_nodes"
+
+# dm-multipath
+ENV{DM_MULTIPATH_DEVICE_PATH}=="1", GOTO="del_part_nodes"
+
+# Other aggregate device types can be added here.
+
+GOTO="end_del_part_nodes"
+
+LABEL="del_part_nodes"
+IMPORT{db}="DM_DEL_PART_NODES"
+ENV{DM_DEL_PART_NODES}!="1", ENV{DM_DEL_PART_NODES}="1", \
+	RUN+="/usr/sbin/partx -d --nr 1-1024 $env{DEVNAME}"
+
+LABEL="end_del_part_nodes"
-- 
2.14.0
