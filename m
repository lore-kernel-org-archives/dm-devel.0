From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 7/7] fix udev rules for failed multipath
	devices
Date: Mon, 13 Feb 2017 22:06:53 -0600
Message-ID: <1487045213-15776-8-git-send-email-bmarzins@redhat.com>
References: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
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
Cc: Peter Rajnoha <prajnoha@redhat.com>
List-Id: dm-devel.ids

11-dm-mpath.rules was only correctly dealing with the case where the
multipath device was unusable because the last path had failed.  If
instead, the last working path was removed from the device on a table
reload, it was not correctly marking the device as unusable. One problem
with fixing this is that when the device table is reloaded,
device-mapper doesn't know if the path devices are usable or not.  To
deal with this, multipath now flags reloads with no usable paths with
DM_SUBSYSTEM_UDEV_FLAG2.

11-dm-mpath.rules now checks for both PATH_FAILED events and reloads
with no valid paths. and disables the other rules.

Cc: Peter Rajnoha <prajnoha@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c    |  3 +-
 libmultipath/devmapper.h    |  6 ++++
 multipath/11-dm-mpath.rules | 67 +++++++++++++++++++++++++++++++--------------
 3 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4f8ef13..1b43c44 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -373,7 +373,8 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	int r;
 	uint16_t udev_flags = (flush ? 0 : MPATH_UDEV_RELOAD_FLAG) |
 			      ((mpp->skip_kpartx == SKIP_KPARTX_ON)?
-			       MPATH_UDEV_NO_KPARTX_FLAG : 0);
+			       MPATH_UDEV_NO_KPARTX_FLAG : 0) |
+			      ((mpp->nr_active)? 0 : MPATH_UDEV_NO_PATHS_FLAG);
 
 	/*
 	 * DM_DEVICE_RELOAD cannot wait on a cookie, as
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 411177d..3ea4329 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -18,6 +18,12 @@
 #define MPATH_UDEV_NO_KPARTX_FLAG 0
 #endif
 
+#ifdef DM_SUBSYSTEM_UDEV_FLAG2
+#define MPATH_UDEV_NO_PATHS_FLAG DM_SUBSYSTEM_UDEV_FLAG2
+#else
+#define MPATH_UDEV_NO_PATHS_FLAG 0
+#endif
+
 void dm_init(int verbosity);
 int dm_prereq (void);
 int dm_drv_version (unsigned int * version, char * str);
diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 5559af3..b131a10 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -2,39 +2,66 @@ ACTION!="add|change", GOTO="mpath_end"
 ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
 ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 
+IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
+IMPORT{db}="MPATH_DEVICE_READY"
+
+# If this uevent didn't come from dm, don't try to update the
+# device state
+ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
+
+ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
+
+# multipath sets DM_SUBSYSTEM_UDEV_FLAG2 when it reloads a
+# table with no active devices. If this happens, mark the
+# device not ready
+ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0",\
+	GOTO="mpath_action"
+
+# If the last path has failed mark the device not ready
+ENV{DM_ACTION}=="PATH_FAILED", ENV{DM_NR_VALID_PATHS}=="0",\
+	ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
+
+# Don't mark a device ready on a PATH_FAILED event. even if
+# DM_NR_VALID_PATHS is greater than 0. Just keep the existing
+# value
+ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
+
+# This event is either a PATH_REINSTATED or a table reload where
+# there are active paths. Mark the device ready
+ENV{MPATH_DEVICE_READY}=""
+
+LABEL="mpath_action"
+# DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
+# Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
+# paths are lost/recovered. For any stack above the mpath device, this is not
+# something that should be reacted upon since it would be useless extra work.
+# It's exactly mpath's job to provide *seamless* device access to any of the
+# paths that are available underneath.
+ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_ACTIVATION}="0"
+
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
-ENV{DM_NR_VALID_PATHS}!="?*", IMPORT{db}="DM_NR_VALID_PATHS"
-ENV{DM_NR_VALID_PATHS}!="0", GOTO="mpath_blkid_end"
-ENV{ID_FS_TYPE}!="?*", IMPORT{db}="ID_FS_TYPE"
-ENV{ID_FS_USAGE}!="?*", IMPORT{db}="ID_FS_USAGE"
-ENV{ID_FS_UUID}!="?*", IMPORT{db}="ID_FS_UUID"
-ENV{ID_FS_ENC}!="?*", IMPORT{db}="ID_FS_UUID_ENC"
-ENV{ID_FS_VERSION}!="?*", IMPORT{db}="ID_FS_VERSION"
-LABEL="mpath_blkid_end"
+ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
 
 # Also skip all foreign rules if no path is available.
 # Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
 # and restore it back once we have at least one path available.
-IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
-ENV{DM_ACTION}=="PATH_FAILED",\
-	ENV{DM_NR_VALID_PATHS}=="0",\
+ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}!="0",\
 	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="",\
 	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}",\
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
-ENV{DM_ACTION}=="PATH_REINSTATED",\
-	ENV{DM_NR_VALID_PATHS}=="1",\
+ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
 	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="",\
 	ENV{DM_ACTIVATION}="1"
 
-# DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
-# Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
-# paths are lost/recovered. For any stack above the mpath device, this is not
-# something that should be reacted upon since it would be useless extra work.
-# It's exactly mpath's job to provide *seamless* device access to any of the
-# paths that are available underneath.
-ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_ACTIVATION}="0"
+LABEL="scan_import"
+ENV{DM_NOSCAN}!="1", GOTO="mpath_end"
+ENV{ID_FS_TYPE}!="?*", IMPORT{db}="ID_FS_TYPE"
+ENV{ID_FS_USAGE}!="?*", IMPORT{db}="ID_FS_USAGE"
+ENV{ID_FS_UUID}!="?*", IMPORT{db}="ID_FS_UUID"
+ENV{ID_FS_ENC}!="?*", IMPORT{db}="ID_FS_UUID_ENC"
+ENV{ID_FS_VERSION}!="?*", IMPORT{db}="ID_FS_VERSION"
 
 LABEL="mpath_end"
-- 
1.8.3.1
