From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle arbitrarily
 sized bios
Date: Fri, 22 May 2015 00:51:03 -0700
Message-ID: <555EDFE7.2020304@kernel.org>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org> <1430980461-5235-2-git-send-email-mlin@kernel.org> <x49twv9kevg.fsf@segfault.boston.devel.redhat.com> <20150518172259.GA8116@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150518172259.GA8116@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On 05/18/2015 10:22 AM, Christoph Hellwig wrote:
> On Mon, May 18, 2015 at 12:52:03PM -0400, Jeff Moyer wrote:
>>> +	return bio_split(bio, split_sectors, GFP_NOIO, bs);
>>
>> Much of this function is cut-n-paste from blk-lib.c.  Is there any way
>> to factor it out?
> 
> The code in blk-lib.c can go away now that any driver that cares
> does the split.

How about below?

From 23aec71f3e44a21aece46f7939715e022b7d3daa Mon Sep 17 00:00:00 2001
From: Ming Lin <mlin@kernel.org>
Date: Fri, 22 May 2015 00:46:56 -0700
Subject: [PATCH] block: remove split code in blkdev_issue_discard

The split code in blkdev_issue_discard() can go away now
that any driver that cares does the split.

Signed-off-by: Ming Lin <mlin@kernel.org>
---
 block/blk-lib.c | 73 +++++++++++----------------------------------------------
 1 file changed, 14 insertions(+), 59 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 7688ee3..3bf3c4a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -43,34 +43,17 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
-	unsigned int max_discard_sectors, granularity;
-	int alignment;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
 	struct blk_plug plug;
 
-	if (!q)
+	if (!q || !nr_sects)
 		return -ENXIO;
 
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
-	/* Zero-sector (unknown) and one-sector granularities are the same.  */
-	granularity = max(q->limits.discard_granularity >> 9, 1U);
-	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
-
-	/*
-	 * Ensure that max_discard_sectors is of the proper
-	 * granularity, so that requests stay aligned after a split.
-	 */
-	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	max_discard_sectors -= max_discard_sectors % granularity;
-	if (unlikely(!max_discard_sectors)) {
-		/* Avoid infinite loop below. Being cautious never hurts. */
-		return -EOPNOTSUPP;
-	}
-
 	if (flags & BLKDEV_DISCARD_SECURE) {
 		if (!blk_queue_secdiscard(q))
 			return -EOPNOTSUPP;
@@ -82,52 +65,24 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	bb.wait = &wait;
 
 	blk_start_plug(&plug);
-	while (nr_sects) {
-		unsigned int req_sects;
-		sector_t end_sect, tmp;
 
-		bio = bio_alloc(gfp_mask, 1);
-		if (!bio) {
-			ret = -ENOMEM;
-			break;
-		}
+	bio = bio_alloc(gfp_mask, 1);
+	if (!bio) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-		req_sects = min_t(sector_t, nr_sects, max_discard_sectors);
-
-		/*
-		 * If splitting a request, and the next starting sector would be
-		 * misaligned, stop the discard at the previous aligned sector.
-		 */
-		end_sect = sector + req_sects;
-		tmp = end_sect;
-		if (req_sects < nr_sects &&
-		    sector_div(tmp, granularity) != alignment) {
-			end_sect = end_sect - alignment;
-			sector_div(end_sect, granularity);
-			end_sect = end_sect * granularity + alignment;
-			req_sects = end_sect - sector;
-		}
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_end_io = bio_batch_end_io;
+	bio->bi_bdev = bdev;
+	bio->bi_private = &bb;
 
-		bio->bi_iter.bi_sector = sector;
-		bio->bi_end_io = bio_batch_end_io;
-		bio->bi_bdev = bdev;
-		bio->bi_private = &bb;
+	bio->bi_iter.bi_size = nr_sects << 9;
 
-		bio->bi_iter.bi_size = req_sects << 9;
-		nr_sects -= req_sects;
-		sector = end_sect;
+	atomic_inc(&bb.done);
+	submit_bio(type, bio);
 
-		atomic_inc(&bb.done);
-		submit_bio(type, bio);
-
-		/*
-		 * We can loop for a long time in here, if someone does
-		 * full device discards (like mkfs). Be nice and allow
-		 * us to schedule out to avoid softlocking if preempt
-		 * is disabled.
-		 */
-		cond_resched();
-	}
+out:
 	blk_finish_plug(&plug);
 
 	/* Wait for bios in-flight */
-- 
1.9.1
