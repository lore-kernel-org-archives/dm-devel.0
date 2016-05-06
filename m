From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
	interface	accessible again
Date: Fri, 6 May 2016 17:25:35 +0200
Message-ID: <20160506152535.GA6738@lst.de>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-3-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1462463665-85312-3-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, May 05, 2016 at 11:54:22AM -0400, Mike Snitzer wrote:
> Commit 326e1dbb57 ("block: remove management of bi_remaining when
> restoring original bi_end_io") made bio_inc_remaining() private to bio.c
> because the only use-case that made sense was confined to the
> bio_chain() interface.
> 
> Since that time DM thinp went on to use bio_chain() in its relatively
> complex implementation of async discard support.  That implementation,
> even when converted over to use the new async __blkdev_issue_discard()
> interface, depends on deferred completion of the original discard bio --
> which is most appropriately implemented using bio_inc_remaining().

Can you explain that code flow to me?  I still fail to why exactly
dm-thinp (and only dm-thinp) needs this.  Maybe start by pointing me
to the additional bio_endio that pairs with the bio_inc_remaining
call.

> All said, bio_inc_remaining() should really only be used in conjunction
> with bio_chain().  It isn't intended for generic bio reference counting.

It's obviously used outside bio_chain in dm-thinp, so this sentence
doesn't make too much sense to me.
