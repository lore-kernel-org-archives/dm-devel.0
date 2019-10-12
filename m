From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 15/72] libmultipath: path_discovery: handle
	libudev errors
Date: Sat, 12 Oct 2019 21:27:55 +0000
Message-ID: <20191012212703.12989-16-martin.wilck@suse.com>
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

pass out if any libudev helpers return an error code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 72f455e8..e68b0e9f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -148,15 +148,19 @@ path_discovery (vector pathvec, int flag)
 	struct udev_device *udevice;
 	struct config *conf;
 	const char *devpath;
-	int num_paths = 0, total_paths = 0;
+	int num_paths = 0, total_paths = 0, ret;
 
 	udev_iter = udev_enumerate_new(udev);
 	if (!udev_iter)
 		return -ENOMEM;
 
-	udev_enumerate_add_match_subsystem(udev_iter, "block");
-	udev_enumerate_add_match_is_initialized(udev_iter);
-	udev_enumerate_scan_devices(udev_iter);
+	if (udev_enumerate_add_match_subsystem(udev_iter, "block") < 0 ||
+	    udev_enumerate_add_match_is_initialized(udev_iter) < 0 ||
+	    udev_enumerate_scan_devices(udev_iter) < 0) {
+		condlog(1, "%s: error setting up udev_enumerate: %m", __func__);
+		ret = -1;
+		goto out;
+	}
 
 	udev_list_entry_foreach(entry,
 				udev_enumerate_get_list_entry(udev_iter)) {
@@ -180,9 +184,11 @@ path_discovery (vector pathvec, int flag)
 		}
 		udev_device_unref(udevice);
 	}
+	ret = total_paths - num_paths;
+out:
 	udev_enumerate_unref(udev_iter);
 	condlog(4, "Discovered %d/%d paths", num_paths, total_paths);
-	return (total_paths - num_paths);
+	return ret;
 }
 
 #define declare_sysfs_get_str(fname)					\
-- 
2.23.0
