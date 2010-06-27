From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard requests
Date: Sun, 27 Jun 2010 11:39:55 +0200
Message-ID: <20100627093955.GD12016@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1277582211-10725-2-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Sat, Jun 26, 2010 at 03:56:51PM -0400, Mike Snitzer wrote:
> Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> means bio_has_data() will not be true until the SCSI layer adds the
> payload to the discard request via blk_add_request_payload.
> 
> bio_{enable,disable}_inline_vecs are not expected to be widely used so
> they were exported using EXPORT_SYMBOL_GPL.

Why do we need them exported at all?  Also some comments on these
functions would be useful.

Otherwise it looks good to me.
