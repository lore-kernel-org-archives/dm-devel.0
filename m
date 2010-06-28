From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
Date: Mon, 28 Jun 2010 08:37:42 -0400
Message-ID: <20100628123742.GB19497@redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-2-git-send-email-snitzer@redhat.com>
 <4C2896C6.9030607@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C2896C6.9030607@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Jun 28 2010 at  8:34am -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-06-26 21:56, Mike Snitzer wrote:
> > Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> > means bio_has_data() will not be true until the SCSI layer adds the
> > payload to the discard request via blk_add_request_payload.
> 
> Sorry, this looks horrible.

Your judgment isn't giving me much to work with... not sure where I go
with "horrible".

> What is the point of this?!

Enables discard requests with _not_ return true for bio_has_data().

> > bio_{enable,disable}_inline_vecs are not expected to be widely used so
> > they were exported using EXPORT_SYMBOL_GPL.
> 
> Never export anything that doesn't have an in-kernel modular user.

Yeap, v2 removed the exports.

> > This patch avoids the need for the following VM accounting fix for
> > discards: http://lkml.org/lkml/2010/6/23/361
> > NOTE: Jens, you said you applied Tao Ma's fix but I cannot see it in
> > your linux-2.6-block's for-next or for-2.6.36... as such I didn't revert
> > it in this patch.
> 
> It's in the for-linus branch, that is stuff headed for the current
> kernel.

OK.

Mike
