From: damien.lemoal@wdc.com
Subject: [PATCH v2 01/10] dm-table: Introduce DM_TARGET_ZONED_HM feature
Date: Tue,  2 May 2017 02:53:05 +0900
Message-ID: <20170501175314.10922-2-damien.lemoal@wdc.com>
References: <20170501175314.10922-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170501175314.10922-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
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
---
 drivers/md/dm-table.c         | 23 +++++++++++++++++++++++
 include/linux/device-mapper.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3ad16d9..06d3b7b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -388,6 +388,24 @@ dev_t dm_get_dev_t(const char *path)
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
@@ -426,6 +444,11 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
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
index a7e6903..b3c2408 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -214,6 +214,12 @@ struct target_type {
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
