From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 11/12] fs: don't reassign dirty inodes to
 default_backing_dev_info
Date: Mon, 23 Mar 2015 18:40:13 -0400
Message-ID: <20150323224012.GA29505@redhat.com>
References: <1421228561-16857-1-git-send-email-hch@lst.de>
 <1421228561-16857-12-git-send-email-hch@lst.de>
 <CAMM=eLe6Tt+g7dLcnn5a1fQboDknkasazsMiOFBziWPZemnYtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMM=eLe6Tt+g7dLcnn5a1fQboDknkasazsMiOFBziWPZemnYtg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>, linux-nfs@vger.kernel.org, linux-mm@kvack.org, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-mtd@lists.infradead.org, Tejun Heo <tj@kernel.org>, ceph-devel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Sat, Mar 21 2015 at 11:11am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Jan 14, 2015 at 4:42 AM, Christoph Hellwig <hch@lst.de> wrote:
> > If we have dirty inodes we need to call the filesystem for it, even if the
> > device has been removed and the filesystem will error out early.  The
> > current code does that by reassining all dirty inodes to the default
> > backing_dev_info when a bdi is unlinked, but that's pretty pointless given
> > that the bdi must always outlive the super block.
> >
> > Instead of stopping writeback at unregister time and moving inodes to the
> > default bdi just keep the current bdi alive until it is destroyed.  The
> > containing objects of the bdi ensure this doesn't happen until all
> > writeback has finished by erroring out.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Tejun Heo <tj@kernel.org>
> > ---
> >  mm/backing-dev.c | 91 +++++++++++++++-----------------------------------------
> >  1 file changed, 24 insertions(+), 67 deletions(-)
> 
> Hey Christoph,
> 
> Just a heads up: your commit c4db59d31e39ea067c32163ac961e9c80198fd37
> is suspected as the first bad commit in a bisect performed to track
> down the cause of DM crashes reported in this BZ:
> https://bugzilla.redhat.com/show_bug.cgi?id=1202449
> 
> I've yet to look closely at _why_ this commit but figured I'd share
> since this appears to be a 4.0-rcX regression.

FYI, here is the DM fix I've staged for 4.0-rc6.  I'll continue testing
the various DM targets before requesting Linus to pull.

From 63a4f065ece613b6d575b538234375b0e9c23bbc Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 23 Mar 2015 17:01:43 -0400
Subject: [PATCH] dm: fix add_disk() NULL pointer due to race with free_dev()

Commit c4db59d31e39 ("fs: don't reassign dirty inodes to
default_backing_dev_info") exposed DM to a latent race in free_dev() vs
add_disk() in relation to management of the device's minor number.

Fix this by refactoring free_dev() to match cleanup order of the
alloc_dev() error path.  Move cleanup of the gendisk, queue, and bdev
to _before_ the cleanup of the idr managed minor number.

Also, purely due to cleanup that fell out during the free_dev() audit:
- adjust dm_blk_close() to access the gendisk's private_data under
  the _minor_lock spinlock.
- move __dm_destroy()'s dm_get_live_table() call out from under the
  _minor_lock spinlock.

Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=1202449

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9b641b3..8001fe9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -433,7 +433,6 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 
 	dm_get(md);
 	atomic_inc(&md->open_count);
-
 out:
 	spin_unlock(&_minor_lock);
 
@@ -442,16 +441,20 @@ out:
 
 static void dm_blk_close(struct gendisk *disk, fmode_t mode)
 {
-	struct mapped_device *md = disk->private_data;
+	struct mapped_device *md;
 
 	spin_lock(&_minor_lock);
 
+	md = disk->private_data;
+	if (WARN_ON(!md))
+		goto out;
+
 	if (atomic_dec_and_test(&md->open_count) &&
 	    (test_bit(DMF_DEFERRED_REMOVE, &md->flags)))
 		queue_work(deferred_remove_workqueue, &deferred_remove_work);
 
 	dm_put(md);
-
+out:
 	spin_unlock(&_minor_lock);
 }
 
@@ -2241,7 +2244,6 @@ static void free_dev(struct mapped_device *md)
 	int minor = MINOR(disk_devt(md->disk));
 
 	unlock_fs(md);
-	bdput(md->bdev);
 	destroy_workqueue(md->wq);
 
 	if (md->kworker_task)
@@ -2252,19 +2254,22 @@ static void free_dev(struct mapped_device *md)
 		mempool_destroy(md->rq_pool);
 	if (md->bs)
 		bioset_free(md->bs);
-	blk_integrity_unregister(md->disk);
-	del_gendisk(md->disk);
+
 	cleanup_srcu_struct(&md->io_barrier);
 	free_table_devices(&md->table_devices);
-	free_minor(minor);
+	dm_stats_cleanup(&md->stats);
 
 	spin_lock(&_minor_lock);
 	md->disk->private_data = NULL;
 	spin_unlock(&_minor_lock);
-
+	if (blk_get_integrity(md->disk))
+		blk_integrity_unregister(md->disk);
+	del_gendisk(md->disk);
 	put_disk(md->disk);
 	blk_cleanup_queue(md->queue);
-	dm_stats_cleanup(&md->stats);
+	bdput(md->bdev);
+	free_minor(minor);
+
 	module_put(THIS_MODULE);
 	kfree(md);
 }
@@ -2642,8 +2647,9 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 
 	might_sleep();
 
-	spin_lock(&_minor_lock);
 	map = dm_get_live_table(md, &srcu_idx);
+
+	spin_lock(&_minor_lock);
 	idr_replace(&_minor_idr, MINOR_ALLOCED, MINOR(disk_devt(dm_disk(md))));
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
-- 
1.7.4.4

