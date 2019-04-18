From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: [RFC] [PATCH V2 1/1] md/raid0: Introduce emergency stop
	for raid0 arrays
Date: Thu, 18 Apr 2019 19:04:48 -0300
Message-ID: <20190418220448.7219-2-gpiccoli@canonical.com>
References: <20190418220448.7219-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190418220448.7219-1-gpiccoli@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, linux-raid@vger.kernel.org
Cc: kernel@gpiccoli.net, gpiccoli@canonical.com, neilb@suse.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

Currently the raid0 driver is not provided with any health checking
mechanism to verify its members are fine. So, if suddenly a member
is removed, for example, a STOP_ARRAY ioctl will be triggered from
userspace, i.e., all the logic for stopping an array relies in the
userspace tools, like mdadm/udev. Particularly, if a raid0 array is
mounted, this stop procedure will fail, since mdadm tries to open
the md block device with O_EXCL flag, which isn't allowed if md is
mounted.

That leads to the following situation: if a raid0 array member is
removed and the array is mounted, some user writing to this array
won't realize errors are happening unless they check kernel log.
In other words, no -EIO is returned and writes (except direct I/Os)
appear normal. Meaning this user might think the wrote data is stored
in the array, but instead garbage was written since raid0 does stripping
and require all members to be working in order not corrupt data.

This patch propose a change in this behavior: to emergency stop a
raid0 array in case one of its members are gone. The check happens
when I/O is queued to raid0 driver, so the driver will confirm if
the block device it plans to read/write has its queue healthy; in
case it's not fine (like a dying or dead queue), raid0 driver will
invoke an emergency removal routine that will mark the md device as
broken and trigger a delayed stop procedure. Also, raid0 will start
refusing new BIOs from this point, returning -EIO.
The emergency stop routine will mark the md request queue as dying
too, as a "flag" to indicate failure in case of a nested raid0 array
configuration (a raid0 composed of raid0 devices).

The delayed stop procedure then will perform the basic stop of the
md device, and will take care in case it holds mounted filesystems,
allowing the stop of a mounted raid0 array - which is common in
other regular block devices like NVMe and SCSI.

This emergency stop mechanism only affects raid0 arrays.

Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---
 drivers/md/md.c    | 123 +++++++++++++++++++++++++++++++++++++++++----
 drivers/md/md.h    |   6 +++
 drivers/md/raid0.c |  14 ++++++
 3 files changed, 134 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 05ffffb8b769..5dc0ed7d37d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -94,6 +94,7 @@ EXPORT_SYMBOL(md_cluster_mod);
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 static struct workqueue_struct *md_wq;
 static struct workqueue_struct *md_misc_wq;
+static struct workqueue_struct *md_stop_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
@@ -446,7 +447,9 @@ static void md_end_flush(struct bio *fbio)
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&fi->flush_pending)) {
-		if (bio->bi_iter.bi_size == 0) {
+		if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
+			goto bail_flush;
+		} else if (bio->bi_iter.bi_size == 0) {
 			/* an empty barrier - all done */
 			bio_endio(bio);
 			mempool_free(fi, mddev->flush_pool);
@@ -456,6 +459,12 @@ static void md_end_flush(struct bio *fbio)
 		}
 	}
 
+bail_flush:
+	/* Prevents dangling bios to crash after raid0 emergency stop */
+	if (test_bit(MD_BROKEN, &mddev->flags) && !mddev->raid_disks) {
+		bio_uninit(fbio);
+		return;
+	}
 	mempool_free(fb, mddev->flush_bio_pool);
 	bio_put(fbio);
 }
@@ -465,6 +474,11 @@ void md_flush_request(struct mddev *mddev, struct bio *bio)
 	struct md_rdev *rdev;
 	struct flush_info *fi;
 
+	if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
+		bio_io_error(bio);
+		return;
+	}
+
 	fi = mempool_alloc(mddev->flush_pool, GFP_NOIO);
 
 	fi->bio = bio;
@@ -5202,6 +5216,17 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	return rv;
 }
 
+static void __md_free(struct mddev *mddev)
+{
+	if (mddev->gendisk)
+		del_gendisk(mddev->gendisk);
+	if (mddev->queue)
+		blk_cleanup_queue(mddev->queue);
+	if (mddev->gendisk)
+		put_disk(mddev->gendisk);
+	percpu_ref_exit(&mddev->writes_pending);
+}
+
 static void md_free(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
@@ -5209,13 +5234,8 @@ static void md_free(struct kobject *ko)
 	if (mddev->sysfs_state)
 		sysfs_put(mddev->sysfs_state);
 
-	if (mddev->gendisk)
-		del_gendisk(mddev->gendisk);
-	if (mddev->queue)
-		blk_cleanup_queue(mddev->queue);
-	if (mddev->gendisk)
-		put_disk(mddev->gendisk);
-	percpu_ref_exit(&mddev->writes_pending);
+	if (!test_bit(MD_BROKEN, &mddev->flags))
+		__md_free(mddev);
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
@@ -5238,7 +5258,9 @@ static void mddev_delayed_delete(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
 
-	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
+	if (!test_bit(MD_BROKEN, &mddev->flags))
+		sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
+
 	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
 }
@@ -5974,6 +5996,75 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	return err;
 }
 
+static void mddev_delayed_stop(struct work_struct *ws)
+{
+	struct mddev *mddev = container_of(ws, struct mddev, stop_work);
+	struct gendisk *disk = mddev->gendisk;
+	struct block_device *bdev;
+	struct md_rdev *rdev;
+	int i = 0;
+
+	mutex_lock(&mddev->open_mutex);
+	del_timer_sync(&mddev->safemode_timer);
+	__md_stop(mddev);
+	rdev_for_each(rdev, mddev)
+		if (rdev->raid_disk >= 0)
+			sysfs_unlink_rdev(mddev, rdev);
+	set_capacity(disk, 0);
+	mutex_unlock(&mddev->open_mutex);
+
+	mddev->changed = 1;
+	revalidate_disk(disk);
+	export_array(mddev);
+	mddev->hold_active = 0;
+
+	/* Make sure unbind_rdev_from_array() jobs are done */
+	flush_workqueue(md_misc_wq);
+
+	do {
+		bdev = bdget_disk(disk, i++);
+		if (bdev) {
+			struct super_block *sb = bdev->bd_super;
+
+			if (sb) {
+				sb->s_flags |= SB_RDONLY;
+				sb->s_bdi->capabilities = BDI_CAP_NO_ACCT_AND_WRITEBACK;
+			}
+			bdput(bdev);
+		}
+	} while (bdev);
+
+	md_clean(mddev);
+	set_bit(MD_BROKEN, &mddev->flags); /* md_clean() will clear this too */
+	md_new_event(mddev);
+	sysfs_notify_dirent_safe(mddev->sysfs_state);
+
+	__md_free(mddev);
+	mddev->gendisk = NULL;
+}
+
+void mddev_emergency_stop(struct mddev *mddev)
+{
+	/* Prevents races if raid0 driver detects errors in multiple requests
+	 * at the same time.
+	 */
+	mutex_lock(&mddev->open_mutex);
+	if (test_bit(MD_BROKEN, &mddev->flags))
+		return;
+
+	set_bit(MD_BROKEN, &mddev->flags);
+	mutex_unlock(&mddev->open_mutex);
+
+	/* Necessary to set md queue as dying here in case this md device is
+	 * a member of some other md array - nested removal will proceed then.
+	 */
+	blk_set_queue_dying(mddev->queue);
+
+	INIT_WORK(&mddev->stop_work, mddev_delayed_stop);
+	queue_work(md_stop_wq, &mddev->stop_work);
+}
+EXPORT_SYMBOL_GPL(mddev_emergency_stop);
+
 /* mode:
  *   0 - completely stop and dis-assemble array
  *   2 - stop but do not disassemble array
@@ -5985,6 +6076,13 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	struct md_rdev *rdev;
 	int did_freeze = 0;
 
+	/* If we already started the emergency removal procedure,
+	 * the STOP_ARRAY ioctl can race with the removal, leading to
+	 * dangling devices. Below check is to prevent this corner case.
+	 */
+	if (test_bit(MD_BROKEN, &mddev->flags))
+		return -EBUSY;
+
 	if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
 		did_freeze = 1;
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -9150,6 +9248,10 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
+	md_stop_wq = alloc_ordered_workqueue("md_stop", 0);
+	if (!md_stop_wq)
+		goto err_stop_wq;
+
 	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
 		goto err_md;
 
@@ -9171,6 +9273,8 @@ static int __init md_init(void)
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
+	destroy_workqueue(md_stop_wq);
+err_stop_wq:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
 	destroy_workqueue(md_wq);
@@ -9458,6 +9562,7 @@ static __exit void md_exit(void)
 		 * destroy_workqueue() below will wait for that to complete.
 		 */
 	}
+	destroy_workqueue(md_stop_wq);
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_wq);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c52afb52c776..eebccc318828 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -243,6 +243,9 @@ enum mddev_flags {
 	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
 				 * without explicitly holding reconfig_mutex.
 				 */
+	MD_BROKEN,		/* This is used in the emergency RAID-0 stop
+				 * in case one of its members gets removed.
+				 */
 };
 
 enum mddev_sb_flags {
@@ -411,6 +414,8 @@ struct mddev {
 
 	struct work_struct del_work;	/* used for delayed sysfs removal */
 
+	struct work_struct stop_work;	/* used for delayed emergency stop */
+
 	/* "lock" protects:
 	 *   flush_bio transition from NULL to !NULL
 	 *   rdev superblocks, events
@@ -715,6 +720,7 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 extern void md_handle_request(struct mddev *mddev, struct bio *bio);
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
+extern void mddev_emergency_stop(struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f3fb5bb8c82a..1054243be92b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -555,6 +555,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct strip_zone *zone;
+	struct block_device *bd;
 	struct md_rdev *tmp_dev;
 	sector_t bio_sector;
 	sector_t sector;
@@ -593,6 +594,19 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 
 	zone = find_zone(mddev->private, &sector);
 	tmp_dev = map_sector(mddev, zone, sector, &sector);
+	bd = tmp_dev->bdev;
+
+	if (unlikely((blk_queue_dead(bd->bd_queue) ||
+	    blk_queue_dying(bd->bd_queue)) &&
+	    !test_bit(MD_BROKEN, &mddev->flags))) {
+		mddev_emergency_stop(mddev);
+	}
+
+	if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
+		bio_io_error(bio);
+		return true;
+	}
+
 	bio_set_dev(bio, tmp_dev->bdev);
 	bio->bi_iter.bi_sector = sector + zone->dev_start +
 		tmp_dev->data_offset;
-- 
2.21.0
