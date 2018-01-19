From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 14/16] multipath.rules:
	find_multipaths+ignore_wwids logic
Date: Fri, 19 Jan 2018 01:29:14 +0100
Message-ID: <20180119002916.10323-15-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Solve the problem that, when the first path to a device appears,
we don't know if more paths are going to follow.

These rules apply only if both find_multipaths and ignore_wwids are
set in multipath.conf.

multipath -u sets DM_MULTIPATH_DEVICE_PATH=2 if a device is "maybe"
a multipath member (not blacklisted, only one path seen).
In that case, pretend to be a multipath member and disallow further
processing by systemd (allowing multipathd some time to grab the path),
and check again after some time. If the path is still not multipathed by then,
pass it on to systemd for further processing. Ensure that this happens only
once. The timeout values FIND_MULTIPATHS_BOOT_TMO (time to wait since system
boot) and FIND_MULTIPATHS_PATH_TMO (time to wait after detection of first
path) can be configured in udev rules that are run before "multipath.rules".
The earlier timeout wins, thus if the first path is detected after
FIND_MULTIPATHS_BOOT_TMO has expired, the timer will expire immediately.
---
 multipath/multipath.rules | 59 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 5b3c3c9c1135..6b4a418d0009 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -19,9 +19,64 @@ LABEL="test_dev"
 ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
+# find_multipaths + ignore_wwids logic, part 1
+#
+# Recover environment on next uevent after waiting for the timer.
+# This happens only once because DM_MULTIPATH_SAVED_FS_TYPE will be empty
+# on subsequent events.
+
+IMPORT{db}="DM_MULTIPATH_WAIT_DONE"
+IMPORT{db}="DM_MULTIPATH_SAVED_FS_TYPE"
+ENV{DM_MULTIPATH_WAIT_DONE}!="1", GOTO="skip_restore"
+ENV{DM_MULTIPATH_SAVED_FS_TYPE}=="", GOTO="skip_restore"
+
+# Reset if it's our dummy value, see below
+ENV{DM_MULTIPATH_SAVED_FS_TYPE}=="dm_multipath_unkown", ENV{DM_MULTIPATH_SAVED_FS_TYPE}=""
+ENV{ID_FS_TYPE}="$env{DM_MULTIPATH_SAVED_FS_TYPE}"
+ENV{DM_MULTIPATH_SAVED_FS_TYPE}=""
+ENV{DM_MULTIPATH_DEVICE_PATH}=""
+ENV{SYSTEMD_READY}=""
+
+# Special case:
+# An "add" event happened while we were waiting for the timer.
+# This happens during "coldplug" after switching root FS, if a timer
+# started during initramfs processing was interrupted. We may not have
+# waited long enough: try again.
+ACTION=="add", ENV{DM_MULTIPATH_WAIT_DONE}=""
+
+LABEL="skip_restore"
+
 # multipath -u sets DM_MULTIPATH_DEVICE_PATH
-ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT="$env{MPATH_SBIN_PATH}/multipath -u %k"
+ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
 ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
-	ENV{SYSTEMD_READY}="0"
+	ENV{SYSTEMD_READY}="0", GOTO="end_mpath"
+
+# find_multipaths + ignore_wwids logic, part 2
+#
+# multipath -u sets DM_MULTIPATH_DEVICE_PATH=2 if a device is "maybe"
+# a multipath member (not blacklisted, only one path seen).
+# In that case, pretend to be a multipath member (allowing multipathd
+# some time to grab the path), and check again after some time.
+# If the path is still not multipathed by then, pass it on to systemd
+# for further processing.
+# DM_MULTIPATH_WAIT_DONE ensures that this happens only once.
+# (But see "special case" exception above).
+
+ENV{DM_MULTIPATH_WAIT_DONE}=="1", GOTO="end_mpath"
+ENV{DM_MULTIPATH_DEVICE_PATH}!="2", GOTO="end_mpath"
+
+# Default timeout values for the timer. Use early udev rules files to customize.
+# Timeouts are in seconds after system boot, and seconds after first path
+# discovery, respectively. The earlier timeout wins.
+ENV{FIND_MULTIPATHS_BOOT_TMO}!="?*", ENV{FIND_MULTIPATHS_BOOT_TMO}="180"
+ENV{FIND_MULTIPATHS_PATH_TMO}!="?*", ENV{FIND_MULTIPATHS_PATH_TMO}="30"
+
+ENV{DM_MULTIPATH_WAIT_DONE}="1"
+ENV{DM_MULTIPATH_SAVED_FS_TYPE}="$env{ID_FS_TYPE}"
+ENV{DM_MULTIPATH_SAVED_FS_TYPE}=="", ENV{DM_MULTIPATH_SAVED_FS_TYPE}="dm_multipath_unkown"
+ENV{ID_FS_TYPE}="maybe_mpath_member"
+ENV{DM_MULTIPATH_DEVICE_PATH}="1"
+ENV{SYSTEMD_READY}="0"
+RUN+="/usr/bin/systemd-run --action change --on-boot $env{FIND_MULTIPATHS_BOOT_TMO} --on-active $env{FIND_MULTIPATHS_PATH_TMO} /usr/bin/udevadm trigger $sys$devpath"
 
 LABEL="end_mpath"
-- 
2.15.1
