From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7/7] md: Add support for data integrity to MD
Date: Wed,  1 Oct 2008 03:38:43 -0400
Message-ID: <1222846723-18213-8-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

If all subdevices support the same protection format the MD device is
flagged as capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/md.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 45521da..35542f2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1411,6 +1411,38 @@ static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
 
 static LIST_HEAD(pending_raid_disks);
 
+static void md_integrity_check(mdk_rdev_t *rdev, mddev_t *mddev)
+{
+	struct mdk_personality *pers = mddev->pers;
+	struct gendisk *disk = mddev->gendisk;
+	struct blk_integrity *bi_rdev = bdev_get_integrity(rdev->bdev);
+	struct blk_integrity *bi_mddev = blk_get_integrity(disk);
+
+	/* Data integrity passthrough not supported on RAID 4, 5 and 6 */
+	if (pers && pers->level >= 4 && pers->level <= 6)
+		return;
+
+	/* If rdev is integrity capable, register profile for mddev */
+	if (!bi_mddev && bi_rdev) {
+		if (blk_integrity_register(disk, bi_rdev))
+			printk(KERN_ERR "%s: %s Could not register integrity!\n",
+			       __func__, disk->disk_name);
+		else
+			printk(KERN_NOTICE "Enabling data integrity on %s\n",
+			       disk->disk_name);
+		return;
+	}
+
+	/* Check that mddev and rdev have matching profiles */
+	if (blk_integrity_compare(disk, rdev->bdev->bd_disk) < 0) {
+		printk(KERN_ERR "%s: %s/%s integrity mismatch!\n", __func__,
+		       disk->disk_name, rdev->bdev->bd_disk->disk_name);
+		printk(KERN_NOTICE "Disabling data integrity on %s\n",
+		       disk->disk_name);
+		blk_integrity_unregister(disk);
+	}
+}
+
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 {
 	char b[BDEVNAME_SIZE];
@@ -1471,6 +1503,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	}
 	list_add_rcu(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder, mddev->gendisk);
+	md_integrity_check(rdev, mddev);
 	return 0;
 
  fail:
@@ -3947,6 +3980,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
+	blk_integrity_unregister(disk);
 	md_new_event(mddev);
 	sysfs_notify(&mddev->kobj, NULL, "array_state");
 out:
-- 
1.6.0.2
