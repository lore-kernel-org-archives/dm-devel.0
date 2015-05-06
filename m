From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH 01/10] block: make generic_make_request handle arbitrarily
 sized bios
Date: Tue, 05 May 2015 23:08:20 -0700
Message-ID: <5549AFD4.5020803@kernel.org>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org> <1430203717-13307-2-git-send-email-mlin@kernel.org> <20150428114320.GA9790@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150428114320.GA9790@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

On 04/28/2015 04:43 AM, Christoph Hellwig wrote:
> This seems to lack support for QUEUE_FLAG_SG_GAPS to work around
> the retarded PPR format in the NVMe driver.  I'm actually not
> sure we have a way to reproduce them for BLOCK_PC requests, but I think
> we should make sure to properly handle them.

How about below incremental patch?

 block/bio.c       | 8 --------
 block/blk-merge.c | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ae31cdb..3f6bd9a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -743,14 +743,6 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 			bio->bi_iter.bi_size += len;
 			goto done;
 		}
-
-		/*
-		 * If the queue doesn't support SG gaps and adding this
-		 * offset would create a gap, disallow it.
-		 */
-		if (q->queue_flags & (1 << QUEUE_FLAG_SG_GAPS) &&
-		    bvec_gap_to_prev(prev, offset))
-			return 0;
 	}
 
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 9d565a0..32f6d6c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -78,6 +78,14 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 		if (sectors > queue_max_sectors(q))
 			goto split;
 
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, disallow it.
+		 */
+		if (q->queue_flags & (1 << QUEUE_FLAG_SG_GAPS) &&
+		    prev && bvec_gap_to_prev(&bvprv, bv.bv_offset))
+			goto split;
+
 		if (prev && blk_queue_cluster(q)) {
 			if (seg_size + bv.bv_len > queue_max_segment_size(q))
 				goto new_segment;
