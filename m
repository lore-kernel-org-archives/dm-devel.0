From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 01/10] dm-table: Introduce DM_TARGET_ZONED_HM
	feature
Date: Mon, 8 May 2017 16:40:43 -0700
Message-ID: <20170508234052.32375-2-bart.vanassche@sandisk.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508234052.32375-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

The target drivers currently available will not operate correctly if a
table target maps onto a host-managed zoned block device.

To avoid problems, this patch introduces the new feature flag
DM_TARGET_ZONED_HM for a target driver to explicitly state that it
supports host-managed zoned block devices. This feature is checked
in dm_get_device() to prevent the addition to a table of a target
mapping to a host-managed zoned block device if the target type does
not have the feature enabled.

Note that as host-aware zoned block devices are backward compatible
with regular block devices, they can be used by any of the current
target types. This new feature is thus restricted to host-managed
zoned block devices.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-table.c         | 23 +++++++++++++++++++++++
 include/linux/device-mapper.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5f5eae4..6a7e200 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -389,6 +389,24 @@ dev_t dm_get_dev_t(const char *path)
 EXPORT_SYMBOL_GPL(dm_get_dev_t);
 
 /*
+ * Check if the target supports supports host-managed zoned block devices.
+ */
+static bool device_supported(struct dm_target *ti, struct dm_dev *dev)
+{
+	struct block_device *bdev = dev->bdev;
+	char b[BDEVNAME_SIZE];
+
+	if (bdev_zoned_model(bdev) == BLK_ZONED_HM &&
+	    !dm_target_zoned_hm(ti->type)) {
+		DMWARN("%s: Unsupported host-managed zoned block device %s",
+		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		return false;
+	}
+
+	return true;
+}
+
+/*
  * Add a device to the list, or just increment the usage count if
  * it's already present.
  */
@@ -427,6 +445,11 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 	}
 	atomic_inc(&dd->count);
 
+	if (!device_supported(ti, dd->dm_dev)) {
+		dm_put_device(ti, dd->dm_dev);
+		return -ENOTSUPP;
+	}
+
 	*result = dd->dm_dev;
 	return 0;
 }
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index f4c639c..afd25af 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -218,6 +218,12 @@ struct target_type {
 #define dm_target_is_wildcard(type)	((type)->features & DM_TARGET_WILDCARD)
 
 /*
+ * Indicates that a target supports host-managed zoned block devices.
+ */
+#define DM_TARGET_ZONED_HM		0x00000010
+#define dm_target_zoned_hm(type)	((type)->features & DM_TARGET_ZONED_HM)
+
+/*
  * Some targets need to be sent the same WRITE bio severals times so
  * that they can send copies of it to different devices.  This function
  * examines any supplied bio and returns the number of copies of it the
-- 
2.9.3
