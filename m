From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: add a bi_error field to struct bio
Date: Thu, 11 Jun 2015 09:53:27 +0200
Message-ID: <20150611075327.GA2113@lst.de>
References: <1433338959-24808-1-git-send-email-hch@lst.de> <1433338959-24808-2-git-send-email-hch@lst.de> <20150604153106.GA31567@redhat.com> <20150610081138.GA3841@lst.de> <20150610152649.GA31140@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150610152649.GA31140@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 10, 2015 at 11:26:49AM -0400, Mike Snitzer wrote:
> Unfortunately by dropping the original error (e.g. -EREMOTEIO) on the
> floor (in the 'if (endio) {' branch) you're breaking the REQ_WRITE_SAME
> check.

I think this also happens in the old code before my patch, e.g.:

static void clone_endio(struct bio *bio, int error)
{
        int r = error;

	...

	if (endio) {
		r = endio(tio->ti, bio, error);
		...
	}

	if (unlikely(r == -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&

so we already check the return value that comes from the endio handler,
not any different from my patch.

In the original code r and error are basically always the same, execept
after this:

	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
		error = -EIO;

error might be -EIO and r might be 0. Now if we take the endio branch
we replace both error and r with the return value of endio for all
branches that don't immediately return or BUG().  For the non
endio branch we might check in REQ_WRITE_SAME branch, but r can
only be -EREMOTEIO if it got that value from error, so it doesn't
matter which one we test there.

Based on that I'm pretty sure my prep patch is transformation that
does not change behavior.
