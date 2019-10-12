From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 16/72] libmultipath: make path_discovery()
 pthread_cancel()-safe
Date: Sat, 12 Oct 2019 21:27:57 +0000
Message-ID: <20191012212703.12989-17-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The udev_enumerate and udev_device refs wouldn't be released
if the thread was cancelled. Fix it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 51 +++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e68b0e9f..d217ca92 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -140,19 +140,47 @@ path_discover (vector pathvec, struct config * conf,
 	return pathinfo(pp, conf, flag);
 }
 
+static void cleanup_udev_enumerate_ptr(void *arg)
+{
+	struct udev_enumerate *ue;
+
+	if (!arg)
+		return;
+	ue = *((struct udev_enumerate**) arg);
+	if (ue)
+		(void)udev_enumerate_unref(ue);
+}
+
+static void cleanup_udev_device_ptr(void *arg)
+{
+	struct udev_device *ud;
+
+	if (!arg)
+		return;
+	ud = *((struct udev_device**) arg);
+	if (ud)
+		(void)udev_device_unref(ud);
+}
+
 int
 path_discovery (vector pathvec, int flag)
 {
-	struct udev_enumerate *udev_iter;
+	struct udev_enumerate *udev_iter = NULL;
 	struct udev_list_entry *entry;
-	struct udev_device *udevice;
+	struct udev_device *udevice = NULL;
 	struct config *conf;
-	const char *devpath;
 	int num_paths = 0, total_paths = 0, ret;
 
+	pthread_cleanup_push(cleanup_udev_enumerate_ptr, &udev_iter);
+	pthread_cleanup_push(cleanup_udev_device_ptr, &udevice);
+	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
+
 	udev_iter = udev_enumerate_new(udev);
-	if (!udev_iter)
-		return -ENOMEM;
+	if (!udev_iter) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	if (udev_enumerate_add_match_subsystem(udev_iter, "block") < 0 ||
 	    udev_enumerate_add_match_is_initialized(udev_iter) < 0 ||
@@ -165,6 +193,8 @@ path_discovery (vector pathvec, int flag)
 	udev_list_entry_foreach(entry,
 				udev_enumerate_get_list_entry(udev_iter)) {
 		const char *devtype;
+		const char *devpath;
+
 		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
 		udevice = udev_device_new_from_syspath(udev, devpath);
@@ -175,19 +205,18 @@ path_discovery (vector pathvec, int flag)
 		devtype = udev_device_get_devtype(udevice);
 		if(devtype && !strncmp(devtype, "disk", 4)) {
 			total_paths++;
-			conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
 			if (path_discover(pathvec, conf,
 					  udevice, flag) == PATHINFO_OK)
 				num_paths++;
-			pthread_cleanup_pop(1);
 		}
-		udev_device_unref(udevice);
+		udevice = udev_device_unref(udevice);
 	}
 	ret = total_paths - num_paths;
-out:
-	udev_enumerate_unref(udev_iter);
 	condlog(4, "Discovered %d/%d paths", num_paths, total_paths);
+out:
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
 	return ret;
 }
 
-- 
2.23.0
