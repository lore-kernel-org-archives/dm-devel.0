From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
Date: Mon, 28 Jun 2010 08:29:55 -0400
Message-ID: <20100628122955.GA19497@redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-2-git-send-email-snitzer@redhat.com>
 <20100628193122L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100628193122L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Jun 28 2010 at  6:33am -0400,
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Sat, 26 Jun 2010 15:56:51 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> > means bio_has_data() will not be true until the SCSI layer adds the
> > payload to the discard request via blk_add_request_payload.
> > 
> > bio_{enable,disable}_inline_vecs are not expected to be widely used so
> > they were exported using EXPORT_SYMBOL_GPL.
> > 
> > This patch avoids the need for the following VM accounting fix for
> > discards: http://lkml.org/lkml/2010/6/23/361
> 
> Why do we need to avoid the above fix?

We don't _need_ to.  We avoid the need for it as a side-effect of the
cleanup that my patch provides.

> Surely, the above fix is hacky but much simpler than this patch.

My patch wasn't meant as an alternative to Tao Ma's patch.  Again, it
just obviates the need for it.

Your tolerance for "hacky" is difficult to understand.  On the one-hand
(PATCH 1/2) you have no tolerance for "hacky" fixes for leaks (that
introduce a short-term SCSI layering violation).  But in this case
you're perfectly fine with BIO_RW_DISCARD special casing?

Mike
