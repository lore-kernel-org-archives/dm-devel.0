From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/31] libmultipath: add get_udev_device
Date: Sun,  3 Sep 2017 00:38:39 +0200
Message-ID: <20170902223900.7339-11-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This factors out the functionality of retrieving the
udev_device from different device types from get_refwwid.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 35 +++++++++++++++++++++++++++++++++++
 libmultipath/configure.h |  1 +
 2 files changed, 36 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 74b6f52a..7326132b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1106,6 +1106,41 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 	return 0;
 }
 
+struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type)
+{
+	struct udev_device *ud = NULL;
+	const char *base;
+
+	if (dev == NULL || *dev == '\0')
+		return NULL;
+
+	switch (dev_type) {
+	case DEV_DEVNODE:
+	case DEV_DEVMAP:
+		/* This should be GNU basename, compiler will warn if not */
+		base = basename(dev);
+		if (*base == '\0')
+			break;
+		ud = udev_device_new_from_subsystem_sysname(udev, "block",
+							    base);
+		break;
+	case DEV_DEVT:
+		ud = udev_device_new_from_devnum(udev, 'b', parse_devt(dev));
+		break;
+	case DEV_UEVENT:
+		ud = udev_device_new_from_environment(udev);
+		break;
+	default:
+		condlog(0, "Internal error: get_udev_device called with invalid type %d\n",
+			dev_type);
+		break;
+	}
+	if (ud == NULL)
+		condlog(2, "get_udev_device: failed to look up %s with type %d",
+			dev, dev_type);
+	return ud;
+}
+
 /*
  * returns:
  * 0 - success
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index fd7f581d..0ffc28ef 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -36,3 +36,4 @@ int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name);
+struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
-- 
2.14.0
