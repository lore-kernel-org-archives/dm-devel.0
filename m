From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Sun, 02 Aug 2015 22:58:22 -0700
Message-ID: <1438581502.26596.24.camel@hasee>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org>
	<20150731192337.GA8907@redhat.com>
	<CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
	<20150731213831.GA16464@redhat.com> <1438412290.26596.14.camel@hasee>
	<20150801163356.GA21478@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20150801163356.GA21478-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oleg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Neil-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Al-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Sat, 2015-08-01 at 12:33 -0400, Mike Snitzer wrote:
> On Sat, Aug 01 2015 at  2:58am -0400,
> Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > On Fri, 2015-07-31 at 17:38 -0400, Mike Snitzer wrote:
> > > 
> > > OK, once setup, to run the 2 tests in question directly you'd do
> > > something like:
> > > 
> > > dmtest run --suite thin-provisioning -n discard_a_fragmented_device
> > > 
> > > dmtest run --suite thin-provisioning -n discard_fully_provisioned_device_benchmark
> > > 
> > > Again, these tests pass without this patchset.
> > 
> > It's caused by patch 4.

Typo. I mean patch 5.

> > When discard size >=4G, the bio->bi_iter.bi_size overflows.
> 
> Thanks for tracking this down!

blkdev_issue_write_same() has same problem.

> 
> > Below is the new patch.
> > 
> > Christoph,
> > Could you also help to review it?
> > 
> > Now we still do "misaligned" check in blkdev_issue_discard().
> > So the same code in blk_bio_discard_split() was removed.
> 
> But I don't agree with this approach.  One of the most meaningful
> benefits of late bio splitting is the upper layers shouldn't _need_ to
> depend on the intermediate devices' queue_limits being stacked properly.
> Your solution to mix discard granularity/alignment checks at the upper
> layer(s) but then split based on max_discard_sectors at the lower layer
> defeats that benefit for discards.
> 
> This will translate to all intermediate layers that might split
> discards needing to worry about granularity/alignment
> too (e.g. how dm-thinp will have to care because it must generate
> discard mappings with associated bios based on how blocks were mapped to
> thinp).

I think the important thing is the late splitting for regular bio.
For discard/write_same bio, how about just don't do late splitting?

That is:
1. remove "PATCH 5: block: remove split code in blkdev_issue_discard"
2. Add below changes to PATCH 1

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 1f5dfa0..90b085e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,59 +9,6 @@
 
 #include "blk.h"
 
-static struct bio *blk_bio_discard_split(struct request_queue *q,
-					 struct bio *bio,
-					 struct bio_set *bs)
-{
-	unsigned int max_discard_sectors, granularity;
-	int alignment;
-	sector_t tmp;
-	unsigned split_sectors;
-
-	/* Zero-sector (unknown) and one-sector granularities are the same.  */
-	granularity = max(q->limits.discard_granularity >> 9, 1U);
-
-	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	max_discard_sectors -= max_discard_sectors % granularity;
-
-	if (unlikely(!max_discard_sectors)) {
-		/* XXX: warn */
-		return NULL;
-	}
-
-	if (bio_sectors(bio) <= max_discard_sectors)
-		return NULL;
-
-	split_sectors = max_discard_sectors;
-
-	/*
-	 * If the next starting sector would be misaligned, stop the discard at
-	 * the previous aligned sector.
-	 */
-	alignment = (q->limits.discard_alignment >> 9) % granularity;
-
-	tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
-	tmp = sector_div(tmp, granularity);
-
-	if (split_sectors > tmp)
-		split_sectors -= tmp;
-
-	return bio_split(bio, split_sectors, GFP_NOIO, bs);
-}
-
-static struct bio *blk_bio_write_same_split(struct request_queue *q,
-					    struct bio *bio,
-					    struct bio_set *bs)
-{
-	if (!q->limits.max_write_same_sectors)
-		return NULL;
-
-	if (bio_sectors(bio) <= q->limits.max_write_same_sectors)
-		return NULL;
-
-	return bio_split(bio, q->limits.max_write_same_sectors, GFP_NOIO, bs);
-}
-
 static struct bio *blk_bio_segment_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs)
@@ -129,10 +76,8 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 {
 	struct bio *split;
 
-	if ((*bio)->bi_rw & REQ_DISCARD)
-		split = blk_bio_discard_split(q, *bio, bs);
-	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
-		split = blk_bio_write_same_split(q, *bio, bs);
+	if ((*bio)->bi_rw & REQ_DISCARD || (*bio)->bi_rw & REQ_WRITE_SAME)
+		split = NULL;
 	else
 		split = blk_bio_segment_split(q, *bio, q->bio_split);
 

> 
> Also, it is unfortunate that IO that doesn't have a payload is being
> artificially split simply because bio->bi_iter.bi_size is 32bits.

Indeed.
Will it be possible to make it 64bits? I guess no.

> 
> Mike
