From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 3/4] rbd: check for exclusive lock enabled
Date: Wed, 31 Aug 2016 16:44:29 -0500
Message-ID: <1472679870-25654-4-git-send-email-mchristi@redhat.com>
References: <1472679870-25654-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1472679870-25654-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Only attach the checker if the rbd image has the exclusive lock
enabled.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/rbd.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 6542bdb..175c4a6 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -33,6 +33,8 @@ typedef int (thread_fn)(struct rbd_checker_context *ct, char *msg);
 
 #define RBD_MSG(msg, fmt, args...) snprintf(msg, CHECKER_MSG_LEN, fmt, ##args);
 
+#define RBD_FEATURE_EXCLUSIVE_LOCK	(1 << 2)
+
 struct rbd_checker_context {
 	int rbd_bus_id;
 	char *client_addr;
@@ -65,8 +67,9 @@ int libcheck_init(struct checker * c)
 	struct udev_device *bus_dev;
 	struct udev *udev;
 	struct stat sb;
-	const char *block_name, *addr, *config_info;
+	const char *block_name, *addr, *config_info, *features_str;
 	const char *image, *pool, *snap, *username;
+	uint64_t features = 0;
 	char sysfs_path[PATH_SIZE];
 	int ret;
 
@@ -119,6 +122,15 @@ int libcheck_init(struct checker * c)
 	if (!ct->client_addr)
 		goto free_dev;
 
+	features_str = udev_device_get_sysattr_value(bus_dev, "features");
+	if (!features_str)
+		goto free_addr;
+	features = strtoll(features_str, NULL, 16);
+	if (!(features & RBD_FEATURE_EXCLUSIVE_LOCK)) {
+		condlog(3, "Exclusive lock not set.");
+		goto free_addr;
+	}
+
 	config_info = udev_device_get_sysattr_value(bus_dev, "config_info");
 	if (!config_info)
 		goto free_addr;
-- 
2.7.2
