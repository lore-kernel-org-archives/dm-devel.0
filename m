From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH for-4.2 04/14] block: factor out
 blkdev_issue_discard_async
Date: Mon, 18 May 2015 09:17:21 -0700
Message-ID: <20150518161721.GA28385@infradead.org>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-5-git-send-email-snitzer@redhat.com>
 <20150518082756.GB5439@infradead.org>
 <20150518133223.GC13998@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150518133223.GC13998@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 18, 2015 at 09:32:23AM -0400, Mike Snitzer wrote:
> The proposed blkdev_issue_discard_async interface allows DM (or any
> caller) to not have to concern itself with how discard(s) gets issued.
> 
> It leaves all the details of how large a discard can be, etc to block
> core.  The entire point of doing things this way is to _not_ pollute DM
> with code that breaks up a discard into N bios based on the discard
> limits of the underlying device.
> 
> What you're suggesting sounds a lot like having DM open code
> blkdev_issue_discard() -- blkdev_issue_discard_async() was engineered to
> avoid that completely.

Parts of it anyway.  The splitting logic can still be factored into
helpers to keep the nasty details out of DM.  But except for that I
think async discards should be handled exactly like async reads, writes
or flushes.

And besides that generic high level sentiment I think the interface
for blkdev_issue_discard_async is simply wrong.  Either you want to keep
the internals private and just expose a completion callback that gets
your private data and an error, or you want to build your own bios as
suggested above.  But not one that is mostly opaque except for allowing
the caller to hook into the submission process and thus taking over I/O
completion.
