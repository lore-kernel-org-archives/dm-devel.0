From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 8/9] libmultipath: don't set max_sectors_kb on
	reloads
Date: Fri,  7 Apr 2017 01:16:37 -0500
Message-ID: <1491545798-22183-9-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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

Multipath was setting max_sectors_kb on the multipath device and all its
path devices both when the device was created, and when it was reloaded.
The problem with this is that while this would set max_sectors_kb on all
the devices under multipath, it couldn't set this on devices on top of
multipath.  This meant that if a user lowered max_sectors_kb on an
already existing multipath device with a LV on top of it, the LV could
send down IO that was too large for the new max_sectors_kb value,
because the LV was still using the old value.  The solution to this is
to only set max_sectors_kb to the configured value when the device is
originally created, not when it is later reloaded.  Since not all paths
may be present when the device is original created, on reloads multipath
still needs to make sure that the max_sectors_kb value on all the path
devices is the same as the value of the multipath device. But if this
value doesn't match the configuration value, that's o.k.

This means that the max_sectors_kb value for a multipath device won't
change after it have been initially created. All of the devices created
on top of the multipath device will inherit that value, and all of the
devices will use it all the way down, so IOs will never be mis-sized.

I also moved sysfs_set_max_sectors_kb to configure.c, since it is only
called from there, and it it makes use of static functions from there.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++--
 libmultipath/discovery.c | 23 -------------------
 libmultipath/discovery.h |  1 -
 3 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d955455..3eb1b7a 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -302,7 +302,6 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_max_sectors_kb(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
-	sysfs_set_max_sectors_kb(mpp);
 	put_multipath_config(conf);
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
@@ -432,6 +431,58 @@ is_mpp_known_to_udev(const struct multipath *mpp)
 	return ret;
 }
 
+static int
+sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
+{
+	struct pathgroup * pgp;
+	struct path *pp;
+	char buff[11];
+	int i, j, ret, err = 0;
+	struct udev_device *udd;
+	int max_sectors_kb;
+
+	if (mpp->max_sectors_kb == MAX_SECTORS_KB_UNDEF)
+		return 0;
+	max_sectors_kb = mpp->max_sectors_kb;
+	if (is_reload) {
+		if (!mpp->dmi && dm_get_info(mpp->alias, &mpp->dmi) != 0) {
+			condlog(1, "failed to get dm info for %s", mpp->alias);
+			return 1;
+		}
+		udd = get_udev_for_mpp(mpp);
+		if (!udd) {
+			condlog(1, "failed to get udev device to set max_sectors_kb for %s", mpp->alias);
+			return 1;
+		}
+		ret = sysfs_attr_get_value(udd, "queue/max_sectors_kb", buff,
+					   sizeof(buff));
+		udev_device_unref(udd);
+		if (ret <= 0) {
+			condlog(1, "failed to get current max_sectors_kb from %s", mpp->alias);
+			return 1;
+		}
+		if (sscanf(buff, "%u\n", &max_sectors_kb) != 1) {
+			condlog(1, "can't parse current max_sectors_kb from %s",
+				mpp->alias);
+			return 1;
+		}
+	}
+	snprintf(buff, 11, "%d", max_sectors_kb);
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot(pgp->paths, pp, j) {
+			ret = sysfs_attr_set_value(pp->udev,
+						   "queue/max_sectors_kb",
+						   buff, strlen(buff));
+			if (ret < 0) {
+				condlog(1, "failed setting max_sectors_kb on %s : %s", pp->dev, strerror(-ret));
+				err = 1;
+			}
+		}
+	}	
+	return err;
+}
+
 static void
 select_action (struct multipath * mpp, vector curmp, int force_reload)
 {
@@ -703,16 +754,19 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 			return DOMAP_RETRY;
 		}
 
+		sysfs_set_max_sectors_kb(mpp, 0);
 		r = dm_addmap_create(mpp, params);
 
 		lock_multipath(mpp, 0);
 		break;
 
 	case ACT_RELOAD:
+		sysfs_set_max_sectors_kb(mpp, 1);
 		r = dm_addmap_reload(mpp, params, 0);
 		break;
 
 	case ACT_RESIZE:
+		sysfs_set_max_sectors_kb(mpp, 1);
 		r = dm_addmap_reload(mpp, params, 1);
 		break;
 
@@ -728,8 +782,10 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		r = dm_rename(mpp->alias_old, mpp->alias,
 			      conf->partition_delim, mpp->skip_kpartx);
 		put_multipath_config(conf);
-		if (r)
+		if (r) {
+			sysfs_set_max_sectors_kb(mpp, 1);
 			r = dm_addmap_reload(mpp, params, 0);
+		}
 		break;
 
 	default:
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bfb46b1..8c51254 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -214,29 +214,6 @@ declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
 
-int
-sysfs_set_max_sectors_kb(struct multipath *mpp)
-{
-	struct path *pp;
-	char buff[11];
-	int i, ret, err = 0;
-
-	if (mpp->max_sectors_kb == MAX_SECTORS_KB_UNDEF)
-		return 0;
-	snprintf(buff, 11, "%d", mpp->max_sectors_kb);
-
-	vector_foreach_slot(mpp->paths, pp, i) {
-		ret = sysfs_attr_set_value(pp->udev, "queue/max_sectors_kb",
-					   buff, strlen(buff));
-		if (ret < 0) {
-			condlog(0, "failed setting max_sectors_kb on %s : %s",
-				pp->dev, strerror(-ret));
-			err = 1;
-		}
-	}
-	return err;
-}
-
 ssize_t
 sysfs_get_vpd (struct udev_device * udev, int pg,
 	       unsigned char * buff, size_t len)
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index d16a69a..0563bfd 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -50,7 +50,6 @@ ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev);
-int sysfs_set_max_sectors_kb(struct multipath *mpp);
 
 /*
  * discovery bitmask
-- 
1.8.3.1
