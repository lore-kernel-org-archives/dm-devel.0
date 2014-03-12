From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath devices are not getting created for
	readonly devices
Date: Wed, 12 Mar 2014 12:34:54 +0100
Message-ID: <1394624094-118695-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Currently we cannot create device-mapper tables for multipath devices
whenever the underlying devices are read-only.
This patch modifies the device-mapper to set the 'READ-ONLY' flag
automatically whenever a read-only device is added to the table.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-table.c | 11 ++++++++++-
 drivers/md/dm.c       | 17 +++++++++++++++--
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6a7f2b8..44ea2b3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -443,11 +443,20 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		dd->dm_dev.mode = mode;
 		dd->dm_dev.bdev = NULL;
 
-		if ((r = open_dev(dd, dev, t->md))) {
+		r = open_dev(dd, dev, t->md);
+		if (r == -EROFS) {
+			dd->dm_dev.mode &= ~FMODE_WRITE;
+			r = open_dev(dd, dev, t->md);
+		}
+		if (r) {
 			kfree(dd);
 			return r;
 		}
 
+		/* Modify the table mode, too */
+		if (dd->dm_dev.mode != mode)
+			t->mode = dd->dm_dev.mode;
+
 		format_dev_t(dd->dm_dev.name, dev);
 
 		atomic_set(&dd->count, 0);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8c53b09..0f7b441 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -384,16 +384,25 @@ int dm_deleting_md(struct mapped_device *md)
 static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mapped_device *md;
+	int retval = 0;
 
 	spin_lock(&_minor_lock);
 
 	md = bdev->bd_disk->private_data;
-	if (!md)
+	if (!md) {
+		retval = -ENXIO;
 		goto out;
+	}
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md)) {
 		md = NULL;
+		retval = -ENXIO;
+		goto out;
+	}
+	if (get_disk_ro(md->disk) && (mode & FMODE_WRITE)) {
+		md = NULL;
+		retval = -EROFS;
 		goto out;
 	}
 
@@ -403,7 +412,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 out:
 	spin_unlock(&_minor_lock);
 
-	return md ? 0 : -ENXIO;
+	return retval;
 }
 
 static void dm_blk_close(struct gendisk *disk, fmode_t mode)
@@ -2156,6 +2165,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		set_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
 	else
 		clear_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
+	if (!(dm_table_get_mode(t) & FMODE_WRITE))
+		set_disk_ro(md->disk, 1);
+	else
+		set_disk_ro(md->disk, 0);
 	dm_sync_table(md);
 
 	return old_map;
-- 
1.7.12.4
