From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/3] dm: add dm_bdev
Date: Fri,  8 Jul 2011 18:19:50 -0400
Message-ID: <1310163592-29683-2-git-send-email-snitzer@redhat.com>
References: <1310163592-29683-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1310163592-29683-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Dave Chinner <dchinner@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <thornber@redhat.com>

Allow targets to access to the block_device associated with a DM
mapped_device.  Export dm_disk() and dm_bdev() -- both are required by
the dm-thinp target.

Signed-off-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c               |   11 +++++++++--
 include/linux/device-mapper.h |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 538144b..99664eb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2632,13 +2632,20 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
 }
 
 /*
- * The gendisk is only valid as long as you have a reference
- * count on 'md'.
+ * The gendisk or block_device are only valid as long as you
+ * have a reference count on 'md'.
  */
 struct gendisk *dm_disk(struct mapped_device *md)
 {
 	return md->disk;
 }
+EXPORT_SYMBOL_GPL(dm_disk);
+
+struct block_device *dm_bdev(struct mapped_device *md)
+{
+	return md->bdev;
+}
+EXPORT_SYMBOL_GPL(dm_bdev);
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 3fa1f3d..3941602 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -295,6 +295,7 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist);
 const char *dm_device_name(struct mapped_device *md);
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
+struct block_device *dm_bdev(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 union map_info *dm_get_mapinfo(struct bio *bio);
-- 
1.7.1
