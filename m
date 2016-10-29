From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 09/10] add disable_changed_wwids option
Date: Fri, 28 Oct 2016 21:55:25 -0500
Message-ID: <1477709726-5442-10-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

If a LUN on a storage device gets remapped while in-use by multipath,
it's possible that the multipath device will continue writing to this
new LUN, causing corruption.  This is not multipath's fault (users
should go remapping in-use LUNs), but it's possible for multipath to
detect this and disable IO to the device. If disable_changed_wwids
is set to "yes", multipathd will detect when a LUN changes wwids when it
receives the uevent for this, and will disable access to the device
until the LUN is mapped back.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  1 +
 libmultipath/config.h    |  1 +
 libmultipath/defaults.h  |  1 +
 libmultipath/dict.c      |  4 ++++
 libmultipath/discovery.c | 15 +++++++--------
 libmultipath/discovery.h |  1 +
 libmultipath/structs.h   |  1 +
 multipathd/main.c        | 32 ++++++++++++++++++++++++++++++++
 8 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index bdcad80..a97b318 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -618,6 +618,7 @@ load_config (char * file)
 	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
 	conf->deferred_remove = DEFAULT_DEFERRED_REMOVE;
 	conf->skip_kpartx = DEFAULT_SKIP_KPARTX;
+	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index d59a993..dbdaa44 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -144,6 +144,7 @@ struct config {
 	int delayed_reconfig;
 	int uev_wait_timeout;
 	int skip_kpartx;
+	int disable_changed_wwids;
 	unsigned int version[3];
 
 	char * multipath_dir;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index a1fee9b..a72078f 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -36,6 +36,7 @@
 #define DEFAULT_FORCE_SYNC	0
 #define DEFAULT_PARTITION_DELIM	NULL
 #define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
+#define DEFAULT_DISABLE_CHANGED_WWIDS 0
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e0a3014..61b6910 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -412,6 +412,9 @@ declare_hw_snprint(skip_kpartx, print_yes_no_undef)
 declare_mp_handler(skip_kpartx, set_yes_no_undef)
 declare_mp_snprint(skip_kpartx, print_yes_no_undef)
 
+declare_def_handler(disable_changed_wwids, set_yes_no)
+declare_def_snprint(disable_changed_wwids, print_yes_no)
+
 static int
 def_config_dir_handler(struct config *conf, vector strvec)
 {
@@ -1395,6 +1398,7 @@ init_keywords(vector keywords)
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
 	install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
 	install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint_def_skip_kpartx);
+	install_keyword("disable_changed_wwids", &def_disable_changed_wwids_handler, &snprint_def_disable_changed_wwids);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bb3116d..756344f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1538,13 +1538,12 @@ get_prio (struct path * pp)
 }
 
 static int
-get_udev_uid(struct path * pp, char *uid_attribute)
+get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
 {
 	ssize_t len;
 	const char *value;
 
-	value = udev_device_get_property_value(pp->udev,
-					       uid_attribute);
+	value = udev_device_get_property_value(udev, uid_attribute);
 	if (!value || strlen(value) == 0)
 		value = getenv(uid_attribute);
 	if (value && strlen(value)) {
@@ -1625,8 +1624,8 @@ get_vpd_uid(struct path * pp)
 	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
 }
 
-static int
-get_uid (struct path * pp, int path_state)
+int
+get_uid (struct path * pp, int path_state, struct udev_device *udev)
 {
 	char *c;
 	const char *origin = "unknown";
@@ -1639,7 +1638,7 @@ get_uid (struct path * pp, int path_state)
 		put_multipath_config(conf);
 	}
 
-	if (!pp->udev) {
+	if (!udev) {
 		condlog(1, "%s: no udev information", pp->dev);
 		return 1;
 	}
@@ -1669,7 +1668,7 @@ get_uid (struct path * pp, int path_state)
 		int retrigger;
 
 		if (pp->uid_attribute) {
-			len = get_udev_uid(pp, pp->uid_attribute);
+			len = get_udev_uid(pp, pp->uid_attribute, udev);
 			origin = "udev";
 			if (len <= 0)
 				condlog(1,
@@ -1798,7 +1797,7 @@ pathinfo (struct path *pp, struct config *conf, int mask)
 	}
 
 	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
-		get_uid(pp, path_state);
+		get_uid(pp, path_state, pp->udev);
 		if (!strlen(pp->wwid)) {
 			pp->initialized = INIT_MISSING_UDEV;
 			pp->tick = conf->retrigger_delay;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 0f5b1e6..176eac1 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -49,6 +49,7 @@ ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
 		       size_t len);
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
+int get_uid(struct path * pp, int path_state, struct udev_device *udev);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 3a716d8..58508f6 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -217,6 +217,7 @@ struct path {
 	int fd;
 	int initialized;
 	int retriggers;
+	int wwid_changed;
 
 	/* configlet pointers */
 	struct hwentry * hwe;
diff --git a/multipathd/main.c b/multipathd/main.c
index dbb4554..bb96cca 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -958,6 +958,12 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
 	int ro, retval = 0;
 	struct path * pp;
+	struct config *conf;
+	int disable_changed_wwids;
+
+	conf = get_multipath_config();
+	disable_changed_wwids = conf->disable_changed_wwids;
+	put_multipath_config(conf);
 
 	ro = uevent_get_disk_ro(uev);
 
@@ -969,6 +975,25 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	if (pp) {
 		struct multipath *mpp = pp->mpp;
 
+		if (disable_changed_wwids &&
+		    (strlen(pp->wwid) || pp->wwid_changed)) {
+			char wwid[WWID_SIZE];
+
+			strcpy(wwid, pp->wwid);
+			get_uid(pp, pp->state, uev->udev);
+			if (strcmp(wwid, pp->wwid) != 0) {
+				condlog(0, "%s: path wwid changed from '%s' to '%s'. disallowing", uev->kernel, wwid, pp->wwid);
+				strcpy(pp->wwid, wwid);
+				if (!pp->wwid_changed) {
+					pp->wwid_changed = 1;
+					pp->tick = 1;
+					dm_fail_path(pp->mpp->alias, pp->dev_t);
+				}
+				goto out;
+			} else
+				pp->wwid_changed = 0;
+		}
+
 		if (pp->initialized == INIT_REQUESTED_UDEV)
 			retval = uev_add_path(uev, vecs);
 		else if (mpp && ro >= 0) {
@@ -983,6 +1008,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			}
 		}
 	}
+out:
 	lock_cleanup_pop(vecs->lock);
 	if (!pp)
 		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
@@ -1509,6 +1535,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	} else
 		checker_clear_message(&pp->checker);
 
+	if (pp->wwid_changed) {
+		condlog(2, "%s: path wwid has changed. Refusing to use",
+			pp->dev);
+		newstate = PATH_DOWN;
+	}
+
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
 		conf = get_multipath_config();
-- 
1.8.3.1
