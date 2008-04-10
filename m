From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/3] dm-mpath: remove hwhcontext from dm_path
Date: Thu, 10 Apr 2008 15:51:08 -0400 (EDT)
Message-ID: <20080410.155108.112628266.k-ueda@ct.jp.nec.com>
References: <20080410.154819.71084314.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080410.154819.71084314.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch removes 'hwhcontext' from struct dm_path.
No functional change.

The hwhcontext should be moved to struct pgpath or somewhere
related to only multipath target, since hardware handler is
multipath target dependent.

However, only dm-mpath-hp-sw.c is using the hwhcontext now,
and using it is not necessary.  So just remove it.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath-hp-sw.c   |    7 +++----
 include/linux/device-mapper.h |    1 -
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: 2.6.25-rc8/drivers/md/dm-mpath-hp-sw.c
===================================================================
--- 2.6.25-rc8.orig/drivers/md/dm-mpath-hp-sw.c
+++ 2.6.25-rc8/drivers/md/dm-mpath-hp-sw.c
@@ -117,12 +117,12 @@ out:
  * 1. Make timeout configurable
  * 2. Preallocate request
  */
-static struct request *hp_sw_get_request(struct dm_path *path)
+static struct request *hp_sw_get_request(struct dm_path *path,
+					 struct hp_sw_context *h)
 {
 	struct request *req;
 	struct block_device *bdev = path->dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
-	struct hp_sw_context *h = path->hwhcontext;
 
 	req = blk_get_request(q, WRITE, GFP_NOIO);
 	if (!req)
@@ -170,10 +170,9 @@ static void hp_sw_pg_init(struct hw_hand
 	struct request *req;
 	struct hp_sw_context *h;
 
-	path->hwhcontext = hwh->context;
 	h = hwh->context;
 
-	req = hp_sw_get_request(path);
+	req = hp_sw_get_request(path, h);
 	if (!req) {
 		DMERR("%s path activation command - allocation fail",
 		      path->dev->name);
Index: 2.6.25-rc8/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc8.orig/include/linux/device-mapper.h
+++ 2.6.25-rc8/include/linux/device-mapper.h
@@ -149,7 +149,6 @@ struct dm_target {
 struct dm_path {
 	struct dm_dev *dev;	/* Read-only */
 	void *pscontext;	/* For path-selector use */
-	void *hwhcontext;	/* For hw-handler use */
 };
 
 int dm_register_target(struct target_type *t);
