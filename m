From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: add support for splitting
	discard requests
Date: Sun, 27 Jun 2010 09:59:00 -0400
Message-ID: <20100627135853.GB3970@redhat.com>
References: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
	<1277584285-13774-2-git-send-email-snitzer@redhat.com>
	<20100627094700.GE12016@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100627094700.GE12016@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, dm-devel@redhat.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Sun, Jun 27 2010 at  5:47am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Sat, Jun 26, 2010 at 04:31:25PM -0400, Mike Snitzer wrote:
> > Enable the striped target to support discard requests by splitting a
> > single discard into N discards on a stripe chunk size boundary.
> > 
> > Follow on core block layer work to merge discards would be helpful.
> > 
> > This work relies on DM's clone_bio() always having BIO_RW_BARRIER set
> > for discard requests.  Without BIO_RW_BARRIER the block layer will spew
> > "blk: request botched" warnings for discards that were split by DM.
> > - this clearly needs further investigation!
> 
> Btw, you can get discard requests from the upper layer that do not
> have BIO_RW_BARRIER set, currently from the BLKDISCARD ioctl used by
> various mkfs tools, and also from the not yet merged xfs discard
> support.

Yes, I'm aware of the BLKDISCARD ioctl.  I added the 'else if' clause
which adds the BIO_RW_BARRIER flag specifically for that case.  Testing
showed the mkfs.ext4 uses the BLKDISCARD ioctl and it would result in
"blk: request botched" when operated against a striped DM target (that
was performing the discrad splitting).

> Can I assume it works fine with those?

Yes it works, with or without DM adding the BIO_RW_BARRIER flag, but
without the flag it'll spew "blk: request botched" and the block layer
will fix things up with this at the end of blk_update_request():

        /*
         * If total number of sectors is less than the first segment
         * size, something has gone terribly wrong.
         */
        if (blk_rq_bytes(req) < blk_rq_cur_bytes(req)) {
                printk(KERN_ERR "blk: request botched\n");
                req->__data_len = blk_rq_cur_bytes(req);
        }

Additional tracing showed blk_rq_bytes(req) was always 0 if DM didn't
set BIO_RW_BARRIER for split discard requests.  It could be that if
BIO_RW_BARRIER is set we'll exit early from blk_update_request to
avoid its "blk: request botched"?  I'll look closer.

> > -	clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
> > +	if (!bio_rw_flagged(bio, BIO_RW_DISCARD))
> > +		clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
> > +	else if (!bio_rw_flagged(bio, BIO_RW_BARRIER)) {
> > +		/* discard w/o barrier results in "blk: request botched" */
> > +		clone->bi_rw |= (1 << BIO_RW_BARRIER);
> > +	}
> 
> So previously we unconditionally cleared the BIO_RW_BARRIER bit in the clone. 

Yes.  I'd like to understand why from Mikulas.

> Maybe to make it clear reorder the if a bit and also just set the
> barrier bit unconditionally for discards, similar to how we
> unconditionally clear it otherwise:
> 
> 	if (bio_rw_flagged(bio, BIO_RW_DISCARD)) {
> 		/* discard w/o barrier results in "blk: request botched" */
> 		clone->bi_rw |= (1 << BIO_RW_BARRIER);
> 	} else {
> 		clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
> 	}
> 
> maybe even with a slightly longer comment explaining what's actually
> going on here, and a FIXME.

OK, your reorder is clearer.  As for a FIXME describing what's going on
here: I'll work to sort that out.. it is still unclear to me why the
BIO_RW_BARRIER flag silences the "blk: request botched" spew from
blk_update_request().

Thanks,
Mike
