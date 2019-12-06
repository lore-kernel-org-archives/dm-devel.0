From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] dm clone: Flush destination device
 before committing metadata
Date: Fri, 6 Dec 2019 11:21:17 -0500
Message-ID: <20191206162117.GB3090@lobo>
References: <20191204140654.26214-1-ntsironis@arrikto.com>
	<20191204140654.26214-4-ntsironis@arrikto.com>
	<20191205194651.GC95063@lobo> <20191205200747.GA6447@redhat.com>
	<7f5b0f44-2d16-db40-6d16-08929d5bebfe@arrikto.com>
	<20191205220915.GA7024@redhat.com>
	<09f5d4a1-1405-5304-105c-6140cdffa46b@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <09f5d4a1-1405-5304-105c-6140cdffa46b@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: vkoukis@arrikto.com, dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On Thu, Dec 05 2019 at  5:42P -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> On 12/6/19 12:09 AM, Mike Snitzer wrote:
> > On Thu, Dec 05 2019 at  4:49pm -0500,
> > Nikos Tsironis <ntsironis@arrikto.com> wrote:
> > 
> > > For dm-thin, indeed, there is not much to gain by not using
> > > blkdev_issue_flush(), since we still allocate a new bio, indirectly, in
> > > the stack.
> > 
> > But thinp obviously could if there is actual benefit to avoiding this
> > flush bio allocation, via blkdev_issue_flush, every commit.
> > 
> 
> Yes, we could do the flush in thinp exactly the same way we do it in
> dm-clone. Add a struct bio field in struct pool_c and use that in the
> callback.
> 
> It would work since the callback is called holding a write lock on
> pmd->root_lock, so it's executed only by a single thread at a time.
> 
> I didn't go for it in my implementation, because I didn't like having to
> make that assumption in the callback, i.e., that it's executed under a
> lock and so it's safe to have the bio in struct pool_c.
> 
> In hindsight, maybe this was a bad call, since it's technically feasible
> to do it this way and we could just add a comment stating that the
> callback is executed atomically.
> 
> If you want I can send a new follow-on patch tomorrow implementing the
> flush in thinp the same way it's implemented in dm-clone.

I took care of it, here is the incremental:

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 73d191ddbb9f..57626c27a54b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -328,6 +328,7 @@ struct pool_c {
 	dm_block_t low_water_blocks;
 	struct pool_features requested_pf; /* Features requested during table load */
 	struct pool_features adjusted_pf;  /* Features used after adjusting for constituent devices */
+	struct bio flush_bio;
 };
 
 /*
@@ -3123,6 +3124,7 @@ static void pool_dtr(struct dm_target *ti)
 	__pool_dec(pt->pool);
 	dm_put_device(ti, pt->metadata_dev);
 	dm_put_device(ti, pt->data_dev);
+	bio_uninit(&pt->flush_bio);
 	kfree(pt);
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -3202,8 +3204,13 @@ static void metadata_low_callback(void *context)
 static int metadata_pre_commit_callback(void *context)
 {
 	struct pool_c *pt = context;
+	struct bio *flush_bio = &pt->flush_bio;
 
-	return blkdev_issue_flush(pt->data_dev->bdev, GFP_NOIO, NULL);
+	bio_reset(flush_bio);
+	bio_set_dev(flush_bio, pt->data_dev->bdev);
+	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
+
+	return submit_bio_wait(flush_bio);
 }
 
 static sector_t get_dev_size(struct block_device *bdev)
@@ -3374,6 +3381,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->data_dev = data_dev;
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
+	bio_init(&pt->flush_bio, NULL, 0);
 	ti->num_flush_bios = 1;
 
 	/*
