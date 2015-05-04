From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH 07/10] block: kill merge_bvec_fn() completely
Date: Mon, 04 May 2015 00:47:39 -0700
Message-ID: <5547241B.1040903@kernel.org>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org>	<1430203717-13307-8-git-send-email-mlin@kernel.org> <20150429080919.342fddfd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429080919.342fddfd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On 04/28/2015 03:09 PM, NeilBrown wrote:
> On Mon, 27 Apr 2015 23:48:34 -0700 Ming Lin <mlin@kernel.org> wrote:
> 
>> From: Kent Overstreet <kent.overstreet@gmail.com>
>>
>> As generic_make_request() is now able to handle arbitrarily sized bios,
>> it's no longer necessary for each individual block driver to define its
>> own ->merge_bvec_fn() callback. Remove every invocation completely.
> 
> This patch it just a little premature I think.
> 
> md/raid5 still assumes read requests will mostly fit within a single chunk
> (which merge_bvec_fn encourages) so they can be serviced without using the
> stripe-cache.
> You've just broken that assumption.
> 
> I think 'chunk_aligned_read' needs to get a loop using bio_split, a bit like
> raid0, first.

How about below?

 drivers/md/raid5.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e42b624..2ddfa1e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4709,7 +4709,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 	add_bio_to_retry(raid_bi, conf);
 }
 
-static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
+static int __chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
@@ -4718,7 +4718,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	sector_t end_sector;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		pr_debug("chunk_aligned_read : non aligned\n");
+		pr_debug("__chunk_aligned_read : non aligned\n");
 		return 0;
 	}
 	/*
@@ -4793,6 +4793,35 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	}
 }
 
+static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
+{
+	struct bio *split;
+
+	do {
+		sector_t sector = raid_bio->bi_iter.bi_sector;
+		unsigned chunk_sects = mddev->chunk_sectors;
+
+		unsigned sectors = chunk_sects -
+			(likely(is_power_of_2(chunk_sects))
+			 ? (sector & (chunk_sects-1))
+			 : sector_div(sector, chunk_sects));
+
+		if (sectors < bio_sectors(raid_bio)) {
+			split = bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);
+			bio_chain(split, raid_bio);
+		} else
+			split = raid_bio;
+
+		if (!__chunk_aligned_read(mddev, split)) {
+			if (split != raid_bio)
+				generic_make_request(raid_bio);
+			return split;
+		}
+	} while (split != raid_bio);
+
+	return NULL;
+}
+
 /* __get_priority_stripe - get the next stripe to process
  *
  * Full stripe writes are allowed to pass preread active stripes up until
@@ -5071,7 +5100,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	 */
 	if (rw == READ && mddev->degraded == 0 &&
 	     mddev->reshape_position == MaxSector &&
-	     chunk_aligned_read(mddev,bi))
+	     (!(bi = chunk_aligned_read(mddev, bi))))
 		return;
 
 	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
