From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] block,
 dm: don't copy bios for request clones
Date: Sun, 26 Apr 2015 07:20:23 -0700
Message-ID: <20150426142020.GB7085@infradead.org>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
	<553BD948.5040302@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <553BD948.5040302@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Sat, Apr 25, 2015 at 08:13:28PM +0200, Hannes Reinecke wrote:
> I seem to remember having sent a similar patch about a year ago;

This one?
http://www.redhat.com/archives/dm-devel/2014-June/msg00023.html

> which then got shot down due to the missing partial completion
> handling.

It got shot down because it passed the upper level request down,
which is a non-no for blk-mq.

> Anyway; we've discussed this at LSF in Boston, haven't we?
> AFAICR we've found that having to resubmit the entire command
> in the case of partial completion is okay with the storage
> vendors, so this patch is a viable way of handling things.

Yes.  But even if it wasn't for some reason we could inspect blk_rq_bytes()
on the clone and do a partial completion on the original request, but
I'd prefer to avoid special casing this case if we can avoid it.

> _But_ I really would like to have a consensus here that this
> _is_ the correct way of handling partial request; because
> if that is the case then we should adopt this strategy
> throughout the SCSI layer (ie in scsi_io_completion())
> and document the fact.

SCSI is a very different case, we do regularly get patial completions
from arrays, and we need to handle them efficiently in the normal
I/O path.  The only case where we will resubmit completed I/O in
dm-mpath is when we got a successfull partial completion in SCSI,
and then a following completions returns an error that causes a
failover.  I don't think there is a need to micro-optimize this case.
