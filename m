From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 2/2] dm: add support for splitting
	discard requests
Date: Sun, 27 Jun 2010 11:47:00 +0200
Message-ID: <20100627094700.GE12016@lst.de>
References: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
	<1277584285-13774-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1277584285-13774-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Sat, Jun 26, 2010 at 04:31:25PM -0400, Mike Snitzer wrote:
> Enable the striped target to support discard requests by splitting a
> single discard into N discards on a stripe chunk size boundary.
> 
> Follow on core block layer work to merge discards would be helpful.
> 
> This work relies on DM's clone_bio() always having BIO_RW_BARRIER set
> for discard requests.  Without BIO_RW_BARRIER the block layer will spew
> "blk: request botched" warnings for discards that were split by DM.
> - this clearly needs further investigation!

Btw, you can get discard requests from the upper layer that do not
have BIO_RW_BARRIER set, currently from the BLKDISCARD ioctl used by
various mkfs tools, and also from the not yet merged xfs discard
support.

Can I assume it works fine with those?

> -	clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
> +	if (!bio_rw_flagged(bio, BIO_RW_DISCARD))
> +		clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
> +	else if (!bio_rw_flagged(bio, BIO_RW_BARRIER)) {
> +		/* discard w/o barrier results in "blk: request botched" */
> +		clone->bi_rw |= (1 << BIO_RW_BARRIER);
> +	}

So previously we unconditionally cleared the BIO_RW_BARRIER bit in the clone.

Maybe to make it cleared reorder the if a bit and also just set the
barrier bit unconditionally for discards, similar to how we
unconditionally clear it otherwise:

	if (bio_rw_flagged(bio, BIO_RW_DISCARD)) {
		/* discard w/o barrier results in "blk: request botched" */
		clone->bi_rw |= (1 << BIO_RW_BARRIER);
	} else {
		clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
	}

maybe even with a slightly longer comment explaining what's actually
going on here, and a FIXME.
