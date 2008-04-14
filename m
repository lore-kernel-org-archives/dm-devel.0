From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make dm_set_device_limits() static
Date: Mon, 14 Apr 2008 21:41:47 +0300
Message-ID: <20080414184147.GW6695@cs181133002.pp.htv.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch makes the needlessly global dm_set_device_limits() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 drivers/md/dm-table.c         |    4 ++--
 include/linux/device-mapper.h |    5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

bb081f9ddde6ca766b8c1cd1077f203d0a082cdb diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a999211..ce27283 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -491,7 +491,8 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
 	return 0;
 }
 
-void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
+static void dm_set_device_limits(struct dm_target *ti,
+				 struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct io_restrictions *rs = &ti->limits;
@@ -541,7 +542,6 @@ void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 
 	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 }
-EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
 int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
 		  sector_t len, int mode, struct dm_dev **result)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8fc199b..4c4b3a6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -75,11 +75,6 @@ typedef int (*dm_ioctl_fn) (struct dm_target *ti, struct inode *inode,
 void dm_error(const char *message);
 
 /*
- * Combine device limits.
- */
-void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev);
-
-/*
  * Constructors should call these functions to ensure destination devices
  * are opened/closed correctly.
  * FIXME: too many arguments.
