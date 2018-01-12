From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 18:17:08 -0500
Message-ID: <20180112231708.GA6722@redhat.com>
References: <1515710256.2752.72.camel@sandisk.com>
 <20180112014232.GB25090@ming.t460p>
 <20180112015721.GB32298@redhat.com>
 <20180112033308.GC25090@ming.t460p>
 <20180112171840.GA4541@redhat.com>
 <1515778013.2396.3.camel@wdc.com>
 <20180112174000.GB5134@redhat.com>
 <1515779211.2396.11.camel@wdc.com>
 <20180112180635.GD5134@redhat.com>
 <1515783288.2396.37.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515783288.2396.37.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 12 2018 at  1:54pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
 
> The intention of commit 6077c2d706097c0 was to address the last mentioned
> case. It may be possible to move the delayed queue rerun from the
> dm_queue_rq() into dm_requeue_original_request(). But I think it would be
> wrong to rerun the queue immediately in case a SCSI target system returns
> "BUSY".

This is my 3rd reply to this email.. 3rd time's the charm? ;)

Here is a patch that will kick the hw queues via blk_mq_requeue_work(),
indirectly from dm-rq.c:__dm_mq_kick_requeue_list(), after a delay if
BLK_STS_RESOURCE is returned from the target.

Your thoughts on this patch as an alternative to commit 6077c2d7060 ?

Thanks,
Mike

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d8c7259..ab2cfdc 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1570,7 +1570,10 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	if (error && blk_path_error(error)) {
 		struct multipath *m = ti->private;
 
-		r = DM_ENDIO_REQUEUE;
+		if (r == BLK_STS_RESOURCE)
+			r = DM_ENDIO_DELAY_REQUEUE;
+		else
+			r = DM_ENDIO_REQUEUE;
 
 		if (pgpath)
 			fail_path(pgpath);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 6b01298..ab0ed2d 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -315,6 +315,10 @@ static void dm_done(struct request *clone, blk_status_t error, bool mapped)
 		/* The target wants to requeue the I/O */
 		dm_requeue_original_request(tio, false);
 		break;
+	case DM_ENDIO_DELAY_REQUEUE:
+		/* The target wants to requeue the I/O after a delay */
+		dm_requeue_original_request(tio, true);
+		break;
 	default:
 		DMWARN("unimplemented target endio return value: %d", r);
 		BUG();
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 9ba8453..da83f64 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -550,6 +550,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md,
 #define DM_ENDIO_DONE		0
 #define DM_ENDIO_INCOMPLETE	1
 #define DM_ENDIO_REQUEUE	2
+#define DM_ENDIO_DELAY_REQUEUE	3
 
 /*
  * Definitions of return values from target map function.
@@ -557,7 +558,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md,
 #define DM_MAPIO_SUBMITTED	0
 #define DM_MAPIO_REMAPPED	1
 #define DM_MAPIO_REQUEUE	DM_ENDIO_REQUEUE
-#define DM_MAPIO_DELAY_REQUEUE	3
+#define DM_MAPIO_DELAY_REQUEUE	DM_ENDIO_DELAY_REQUEUE
 #define DM_MAPIO_KILL		4
 
 #define dm_sector_div64(x, y)( \
