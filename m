From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 06/12] md, dm, scsi, nvme,
 libnvdimm: drop blk_integrity_unregister() at shutdown
Date: Thu, 15 Oct 2015 16:00:12 -0400
Message-ID: <20151015200012.20721.16024.stgit@dwillia2-desk3.jf.intel.com>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: axboe@fb.com, linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, James Bottomley <JBottomley@Odin.com>, NeilBrown <neilb@suse.com>, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

Now that the integrity profile is statically allocated there is no work
to do when shutting down an integrity enabled block device.

Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <JBottomley@Odin.com>
Acked-by: NeilBrown <neilb@suse.com>
Acked-by: Keith Busch <keith.busch@intel.com>
Acked-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/dm.c         |    2 --
 drivers/md/md.c         |    1 -
 drivers/nvdimm/btt.c    |    1 -
 drivers/nvme/host/pci.c |    5 +----
 drivers/scsi/sd.c       |    1 -
 5 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6264781dc69a..f4d953e10e2f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2233,8 +2233,6 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
 		spin_unlock(&_minor_lock);
-		if (blk_get_integrity(md->disk))
-			blk_integrity_unregister(md->disk);
 		del_gendisk(md->disk);
 		put_disk(md->disk);
 	}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2af9d590e1a0..7d07caceb349 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5539,7 +5539,6 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-	blk_integrity_unregister(disk);
 	md_new_event(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 254239746020..eae93ab8ffcd 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1279,7 +1279,6 @@ static int btt_blk_init(struct btt *btt)
 
 static void btt_blk_cleanup(struct btt *btt)
 {
-	blk_integrity_unregister(btt->btt_disk);
 	del_gendisk(btt->btt_disk);
 	put_disk(btt->btt_disk);
 	blk_cleanup_queue(btt->btt_queue);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d5d877716fd6..65190e51aa47 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2405,11 +2405,8 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 
 	if (kill)
 		blk_set_queue_dying(ns->queue);
-	if (ns->disk->flags & GENHD_FL_UP) {
-		if (blk_get_integrity(ns->disk))
-			blk_integrity_unregister(ns->disk);
+	if (ns->disk->flags & GENHD_FL_UP)
 		del_gendisk(ns->disk);
-	}
 	if (kill || !blk_queue_dying(ns->queue)) {
 		blk_mq_abort_requeue_list(ns->queue);
 		blk_cleanup_queue(ns->queue);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f370228bf31..9e85211ea1d1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3068,7 +3068,6 @@ static void scsi_disk_release(struct device *dev)
 	ida_remove(&sd_index_ida, sdkp->index);
 	spin_unlock(&sd_index_lock);
 
-	blk_integrity_unregister(disk);
 	disk->private_data = NULL;
 	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);

