From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] PROBLEM: SSD access time with dm-crypt is way too high
Date: Mon, 10 Jan 2011 12:19:25 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1101101216430.26990@hs20-bc2-1.build.redhat.com>
References: <1294580107.2076.89.camel@vpcz1maverick> <4D29C0A7.5010209@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <4D29C0A7.5010209@redhat.com>
Sender: linux-net-owner@vger.kernel.org
To: Michael Zugelder <michaelzugelder@googlemail.com>
Cc: linux-net@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Sun, 9 Jan 2011, Milan Broz wrote:

> On 01/09/2011 02:35 PM, Michael Zugelder wrote:
> 
> Hi,
> 
> > Just to be clear: This isn't about a dm-crypt encrypted disk being
> > slower that an unencrypted disk. It's about the access time of the same
> > encrypted disk rising to >= 10ms, which is at least an order of
> > magnitude for an SSD. I suspect with an HDD, the difference isn't much
> > noticeable.
> 
> yep, it was reported several times, thanks for that bisect.
> We will need to retest it with per-cpu dm-crypt patches
> (should be in linux-next soon) but I expect that this problem remains.
> 
> > I filed a bugreport on the Ubuntu bugtracker with a few pretty graphs,
> > vmstat and LatencyTOP output. If that would be useful, see
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/653611 .
> 
> (Maybe Ubuntu people can forward issue to upstream list next time?)
> 
> > A bisect between .32 and .33 revealed some more information. I arrived
> > at 79da064, which is a revert of fb1e753 (block: improve
> > queue_should_plug() by looking at IO depths), so I compiled fb1e753.
> > With this 2.6.31 kernel, the problem was gone. One step back to 1f98a13,
> > the access time was high again.
> > 
> > So, it seems that fb1e753 (block: improve queue_should_plug() by looking
> > at IO depths) improves dm-crypt access time on SSDs (by a factor of over
> > 40 here), but (as in the revert commit stated) reduces sequential
> > throughput in some cases. I applied fb1e753 to 2.6.37 and the access
> > time went down to the .32 value.
> > 
> > For me, it seems that dm-crypt interferes with queuing, which totally
> > destroys access time.
> 
> Yes, dm-crypt clones requests and process them in its own queue so there
> is some interference.
> 
> I am not sure if this is fixable by block layer only patch (like fb1e753),
> 
> Maybe dm-crypt should call unplug explicitly, flush crypt workqueue
> explicitly or something like that... dunno
> 
> Jens, do you have an idea how to improve it and not lose throughput?
> 
> Milan
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

Hi

Try this patch. I coded it long time ago, but it was forgotten somehow.

Mikulas

---

Unplug the queue when all IOs are finished.

If we don't unplug the queue, there will be 3ms delay (specified in
block/blk-settings.c, blk_queue_make_request) before the requests is submitted
to the device. So we must unplug the queue.

To avoid excessive unplugging, we must unplug only when we finish processing the
last request.

dm-crypt uses workqueue to queue the IOs. Unfortunatelly, the workqueue API
doesn't allow to query whether there are some more requests pending on the
queue. There API provides function to query "is this work queued on any
workqueue?", but it doesn't provide a function to query "is there any work
pending on this workqueue?".

There are two approaches that I considered:

1. make a special work for unplug. After queuing each IO's work, cancel the
unplug work and queue it again (so that it will always be queued as a last
entry). Unfortunatelly, canceling a work is rather slow operation so I decided
to not use this approach.

2. use a special pointer that points to the last IO. When the IO is finished
and the pointer matches this IO, we know that it was the last IO and we should
unplug. This patch implements this approach.

The pointer is not protected by any locks. So there may be race conditions with
it's manipulation (for example, on architectures with non-atomic memory writes,
simultaneous writes to the pointer may make it to point to garbage). However,
the pointer is never dereferenced, so this shouldn't cause crashes. The race
condition may only cause that unplug is missed and this triggers the 3ms delay.

Write requests are dispatched directly from kcryptd workqueue, so wee need an
unplug for it as well.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux-2.6.36-rc3-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.36-rc3-fast.orig/drivers/md/dm-crypt.c	2010-09-02 22:50:52.000000000 +0200
+++ linux-2.6.36-rc3-fast/drivers/md/dm-crypt.c	2010-09-02 22:59:01.000000000 +0200
@@ -107,6 +107,16 @@ struct crypt_config {
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
 
+  	/*
+	 * The last io submitted to io_queue and crypt_queue.
+	 * This pointers are not protected by any locks and thus must not be
+	 * dereferenced --- they may contain garbage. The only allowed operation
+	 * is to compare these pointers with current io being processed. If they
+	 * match, the block device queue should be unplugged.
+	 */
+	struct dm_crypt_io *io_queue_last_io;
+	struct dm_crypt_io *crypt_queue_last_io;
+
 	char *cipher;
 	char *cipher_mode;
 
@@ -731,17 +741,29 @@ static void kcryptd_io_write(struct dm_c
 static void kcryptd_io(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	struct crypt_config *cc = io->target->private;
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_io_read(io);
 	else
 		kcryptd_io_write(io);
+
+	/*
+	 * Neither io nor cc->io_queue_last_io may be dereferenced here.
+	 * This check just checks if it was the last io.
+	 */
+	if (io == cc->io_queue_last_io) {
+		struct request_queue *q = bdev_get_queue(cc->dev->bdev);
+		blk_unplug(q);
+		cc->io_queue_last_io = NULL;
+	}
 }
 
 static void kcryptd_queue_io(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
 
+	cc->io_queue_last_io = io;
 	INIT_WORK(&io->work, kcryptd_io);
 	queue_work(cc->io_queue, &io->work);
 }
@@ -915,17 +937,31 @@ static void kcryptd_async_done(struct cr
 static void kcryptd_crypt(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	struct crypt_config *cc = io->target->private;
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_crypt_read_convert(io);
 	else
 		kcryptd_crypt_write_convert(io);
+
+	/*
+	 * Neither io nor cc->crypt_queue_last_io may be dereferenced here.
+	 * This check just checks if it was the last writing io.
+	 */
+	if (io == cc->crypt_queue_last_io) {
+		struct request_queue *q = bdev_get_queue(cc->dev->bdev);
+		blk_unplug(q);
+		cc->crypt_queue_last_io = NULL;
+	}
 }
 
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
 
+	/* Write ios need unplugging in kcryptd work thread */
+	if (bio_data_dir(io->base_bio) == WRITE)
+		cc->crypt_queue_last_io = io;
 	INIT_WORK(&io->work, kcryptd_crypt);
 	queue_work(cc->crypt_queue, &io->work);
 }
