From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-4.2 2/3] block,
	dm: don't copy bios for	request clones
Date: Fri, 29 May 2015 18:55:45 +0200
Message-ID: <20150529165545.GB2682@lst.de>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
	<5565935A.4060408@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5565935A.4060408@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, May 27, 2015 at 09:50:18AM +0000, Junichi Nomura wrote:
> Can you test this scenario with your patch?
>   1. Set up a multipath device with fail-over mode
>   2. Write something to the multipath device.
>      After the clone request is sent to the primary path
>      and before the data goes to the disk, 
>      down the primary path
>      (e.g. echo offline > /sys/block/sdXX/device/state)
>   3. (dm-mpath will retry from the secondary path and
>       the write will eventually succeed)
>   4. Verify if the written data is really on the disk

Verified as not working correctly.  The patch below fixes it,
but it needs more testing and some comments:

diff --git a/block/blk-core.c b/block/blk-core.c
index aa819a5..54feaae 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -117,7 +117,13 @@ EXPORT_SYMBOL(blk_rq_init);
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
-	if (error && !(rq->cmd_flags & REQ_CLONE))
+	if (rq->cmd_flags & REQ_CLONE) {
+		if (!error && test_bit(BIO_UPTODATE, &bio->bi_flags))
+			bio_advance(bio, nbytes);
+		return;
+	}
+
+	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
@@ -128,8 +134,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	bio_advance(bio, nbytes);
 
 	/* don't actually finish bio if it's part of flush sequence */
-	if (bio->bi_iter.bi_size == 0 &&
-	    !(rq->cmd_flags & (REQ_FLUSH_SEQ|REQ_CLONE)))
+	if (bio->bi_iter.bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
 		bio_endio(bio, error);
 }
 
