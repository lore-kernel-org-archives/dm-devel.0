From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 3/3] dm: prevent DAX mounts if not supported
Date: Tue, 26 Jun 2018 16:30:41 -0600
Message-ID: <20180626223041.15653-4-ross.zwisler@linux.intel.com>
References: <20180626223041.15653-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180626223041.15653-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: dm-devel.ids

Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
flag is set on the device's request queue to decide whether or not the
device supports filesystem DAX.  Really we should be using
bdev_dax_supported() like filesystems do at mount time.  This performs
other tests like checking to make sure the dax_direct_access() path works.

We also explicitly clear QUEUE_FLAG_DAX on the DM device's request queue if
any of the underlying devices do not support DAX.  This makes the handling
of QUEUE_FLAG_DAX consistent with the setting/clearing of most other flags
in dm_table_set_restrictions().

Now that bdev_dax_supported() explicitly checks for QUEUE_FLAG_DAX, this
will ensure that filesystems built upon DM devices will only be able to
mount with DAX if all underlying devices also support DAX.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/md/dm-table.c | 7 ++++---
 drivers/md/dm.c       | 3 +--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 938766794c2e..3d0e2c198f06 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -885,9 +885,7 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
 static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
 			       sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return q && blk_queue_dax(q);
+	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
 }
 
 static bool dm_table_supports_dax(struct dm_table *t)
@@ -1907,6 +1905,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 
 	if (dm_table_supports_dax(t))
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
+	else
+		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
+
 	if (dm_table_supports_dax_write_cache(t))
 		dax_write_cache(t->md->dax_dev, true);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e65429a29c06..bef5a3f243ed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1056,8 +1056,7 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (len < 1)
 		goto out;
 	nr_pages = min(len, nr_pages);
-	if (ti->type->direct_access)
-		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
+	ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
 
  out:
 	dm_put_live_table(md, srcu_idx);
-- 
2.14.4
