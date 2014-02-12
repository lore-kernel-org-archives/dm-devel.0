From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/2] New udev rules to deal with stacked devices
Date: Wed, 12 Feb 2014 11:15:16 -0600
Message-ID: <1392225317-13898-2-git-send-email-bmarzins@redhat.com>
References: <1392225317-13898-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1392225317-13898-1-git-send-email-bmarzins@redhat.com>
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
Cc: Peter Rajnoha <prajnoha@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This new rules file sets some DM_* udev environment variables to keep
device mapper for doing unnecessary work on multipath device uevents.
Previously, devices with no valid paths were being scanned. Also devices
were being rescanned on uevents caused by paths being added or removed.
These are now avoided.

Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc                |  1 +
 multipath/11-dm-mpath.rules | 34 ++++++++++++++++++++++++++++++++++
 multipath/Makefile          |  3 +++
 3 files changed, 38 insertions(+)
 create mode 100644 multipath/11-dm-mpath.rules

diff --git a/Makefile.inc b/Makefile.inc
index f445160..0669d32 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -31,6 +31,7 @@ prefix      =
 exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
 libudevdir  = ${prefix}/lib/udev
+udevrulesdir = $(libudevdir)/rules.d
 multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
 man5dir     = $(prefix)/usr/share/man/man5
diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
new file mode 100644
index 0000000..69c24b5
--- /dev/null
+++ b/multipath/11-dm-mpath.rules
@@ -0,0 +1,34 @@
+ACTION!="add|change", GOTO="mpath_end"
+ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
+ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
+
+# Do not initiate scanning if no path is available,
+# otherwise there would be a hang or IO error on access.
+# We'd like to avoid this, especially within udev processing.
+ENV{DM_NR_VALID_PATHS}!="?*", IMPORT{db}="DM_NR_VALID_PATHS"
+ENV{DM_NR_VALID_PATHS}=="0", ENV{DM_NOSCAN}="1"
+
+# Also skip all foreign rules if no path is available.
+# Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
+# and restore it back once we have at least one path available.
+IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
+ENV{DM_ACTION}=="PATH_FAILED",\
+	ENV{DM_NR_VALID_PATHS}=="0",\
+	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="",\
+	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}",\
+	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+ENV{DM_ACTION}=="PATH_REINSTATED",\
+	ENV{DM_NR_VALID_PATHS}=="1",\
+	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
+	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="",\
+	ENV{DM_ACTIVATION}="1"
+
+# DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
+# Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
+# paths are lost/recovered. For any stack above the mpath device, this is not
+# something that should be reacted upon since it would be useless extra work.
+# It's exactly mpath's job to provide *seamless* device access to any of the
+# paths that are available underneath.
+ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_ACTIVATION}="0"
+
+LABEL="mpath_end"
diff --git a/multipath/Makefile b/multipath/Makefile
index 5e5958d..e295676 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -21,6 +21,8 @@ $(EXEC): $(OBJS)
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
+	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
@@ -28,6 +30,7 @@ install:
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
 	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
 
-- 
1.8.4.2
