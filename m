From: mwilck@suse.com
Subject: [PATCH 45/54] libmultipath: path_discover(): use
	find_path_by_devt()
Date: Thu,  9 Jul 2020 12:36:14 +0200
Message-ID: <20200709103623.8302-4-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

In path_discover(), it's actually expected that a the path to be discovered is
not already in pathvec. So, do search by devt in the first place rather than
searching twice.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e26aae2..5f4ebf0 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -125,27 +125,19 @@ static int
 path_discover (vector pathvec, struct config * conf,
 	       struct udev_device *udevice, int flag)
 {
-	struct path * pp;
-	const char * devname;
-
-	devname = udev_device_get_sysname(udevice);
-	if (!devname)
-		return PATHINFO_FAILED;
-
-	pp = find_path_by_dev(pathvec, devname);
-	if (!pp) {
-		char devt[BLK_DEV_SIZE];
-		dev_t devnum = udev_device_get_devnum(udevice);
+	struct path *pp;
+	char devt[BLK_DEV_SIZE];
+	dev_t devnum = udev_device_get_devnum(udevice);
 
-		snprintf(devt, BLK_DEV_SIZE, "%d:%d",
-			 major(devnum), minor(devnum));
-		pp = find_path_by_devt(pathvec, devt);
-		if (!pp)
-			return store_pathinfo(pathvec, conf,
-					      udevice, flag | DI_BLACKLIST,
-					      NULL);
-	}
-	return pathinfo(pp, conf, flag);
+	snprintf(devt, BLK_DEV_SIZE, "%d:%d",
+		 major(devnum), minor(devnum));
+	pp = find_path_by_devt(pathvec, devt);
+	if (!pp)
+		return store_pathinfo(pathvec, conf,
+				      udevice, flag | DI_BLACKLIST,
+				      NULL);
+	else
+		return pathinfo(pp, conf, flag);
 }
 
 static void cleanup_udev_enumerate_ptr(void *arg)
-- 
2.26.2
