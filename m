From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH for-4.2 04/14] block: factor out
 blkdev_issue_discard_async
Date: Mon, 18 May 2015 01:27:56 -0700
Message-ID: <20150518082756.GB5439@infradead.org>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-5-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431637512-64245-5-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, May 14, 2015 at 05:05:02PM -0400, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>
> 
> Useful for callers who wish to manage the async completion of discard(s)
> without explicitly blocking waiting for completion.
> 
> blkdev_issue_discard() is updated to call blkdev_issue_discard_async()
> and DM thinp will make use of blkdev_issue_discard_async() in the
> upcoming "dm thin: range discard support" commit.

I think this is the wrong level of interface.  I think dm should just
submit the bios directly, which will also allow it to use bio_chain
properly instead of needing the inc_remaining hack.  Instead export
helpers that properly split up the discard chunk sectors without
touching the bio itself.  And with bio split on demand work even
that will hopefully go away soon.
