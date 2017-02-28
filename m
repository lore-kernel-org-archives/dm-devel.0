From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/33] libmultipath: fall back to search paths by
	devt
Date: Tue, 28 Feb 2017 17:23:03 +0100
Message-ID: <20170228162329.14517-8-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When removing path the device might already be gone from sysfs,
so we cannot lookup the device name. However, we still should
have the path vector available, so we should be trying to look
it up by using the device number.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 11 +++++++++--
 libmultipath/dmparser.c  | 11 +++++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4e99845e..e4186de1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -120,8 +120,15 @@ path_discover (vector pathvec, struct config * conf,
 
 	pp = find_path_by_dev(pathvec, (char *)devname);
 	if (!pp) {
-		return store_pathinfo(pathvec, conf,
-				      udevice, flag, NULL);
+		char devt[BLK_DEV_SIZE];
+		dev_t devnum = udev_device_get_devnum(udevice);
+
+		snprintf(devt, BLK_DEV_SIZE, "%d:%d",
+			 major(devnum), minor(devnum));
+		pp = find_path_by_devt(pathvec, devt);
+		if (!pp)
+			return store_pathinfo(pathvec, conf,
+					      udevice, flag, NULL);
 	}
 	return pathinfo(pp, conf, flag);
 }
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index b504961f..274eb947 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -330,12 +330,15 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 			if (devt2devname(devname, FILE_NAME_SIZE, word)) {
 				condlog(2, "%s: cannot find block device",
 					word);
-				FREE(word);
-				continue;
+				devname[0] = '\0';
 			}
 
-			if (pathvec)
-				pp = find_path_by_dev(pathvec, devname);
+			if (pathvec) {
+				if (strlen(devname))
+					pp = find_path_by_dev(pathvec, devname);
+				else
+					pp = find_path_by_devt(pathvec, word);
+			}
 
 			if (!pp) {
 				pp = alloc_path();
-- 
2.11.0
