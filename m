From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Re: device mapper not reporting no-barrier-support?
Date: Tue, 26 Feb 2008 17:17:42 +0100
Message-ID: <20080226161741.GN6704@kernel.dk>
References: <20080225132615.GA21990@1und1.de> <20080225152050.94788622.akpm@linux-foundation.org> <20080226013656.GE1788@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762262AbYBZQR4@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080226013656.GE1788@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Anders Henke <anders.henke@1und1.de>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 26 2008, Alasdair G Kergon wrote:
> On Mon, Feb 25, 2008 at 03:20:50PM -0800, Andrew Morton wrote:
> > On Mon, 25 Feb 2008 14:26:15 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> > > I'm currently stuck between Kernel LVM and DRBD, as I'm using Kernel
> > > 2.6.24.2 with DRBD 8.2.5 on top of an LVM2 device (LV).
> > > -LVM2/device mapper doesn't support write barriers
> 
> That's right.
> 
> > > -DRBD uses blkdev_issue_flush() to flush its metadata to disk.
> 
> Which won't work if device-mapper is underneath.
> 
> > >  On a no-barrier-device, DRBD should receive EOPNOTSUPP, but
> > >  it really does receive an EIO. Promptly, DRBD gives the
> > >  error message "drbd0: local disk flush failed with status -5".
> > > I've posted a lengty summary of my findings to
> > > http://lists.linbit.com/pipermail/drbd-user/2008-February/008665.html
> > > ... that DRBD does catch the EOPNOTSUPP for blkdev_issue_flush and
> > > BIO_RW_BARRIER, but the lvm implementation of blkdev_issue_flush in
> > > 2.6.24.2 aparently does return EIO for blkdev_issue_flush.
> > I'd say it's a DM bug.
> 
> The dm code is unchanged, but look at the limited endio handling in
> ll_rw_blk.c:
> 
> static void bio_end_empty_barrier(struct bio *bio, int err)
> {
>         if (err)
>                 clear_bit(BIO_UPTODATE, &bio->bi_flags);
> 
>         complete(bio->bi_private);
> }
> 
> int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
> {
> ...
>         wait_for_completion(&wait);
>         if (error_sector)
>                 *error_sector = bio->bi_sector;
>         ret = 0;
>         if (!bio_flagged(bio, BIO_UPTODATE))
>                 ret = -EIO;

You are right, the return value got broken there. Does this make it
return -EOPNOTSUPP properly for you?

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 6901eed..55c5f1f 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -259,8 +259,11 @@ int blk_do_ordered(struct request_queue *q, struct request **rqp)
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
 {
-	if (err)
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	}
 
 	complete(bio->bi_private);
 }
@@ -309,7 +312,9 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 		*error_sector = bio->bi_sector;
 
 	ret = 0;
-	if (!bio_flagged(bio, BIO_UPTODATE))
+	if (bio_flagged(bio, BIO_EOPNOTSUPP))
+		ret = -EOPNOTSUPP;
+	else if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
 
 	bio_put(bio);

-- 
Jens Axboe
