From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-4.2 04/14] block: factor out
 blkdev_issue_discard_async
Date: Tue, 19 May 2015 01:32:00 -0700
Message-ID: <20150519083200.GA31648@infradead.org>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-5-git-send-email-snitzer@redhat.com>
 <20150518082756.GB5439@infradead.org>
 <20150518133223.GC13998@redhat.com>
 <20150518161721.GA28385@infradead.org>
 <20150518191830.GA15656@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150518191830.GA15656@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 18, 2015 at 03:18:30PM -0400, Mike Snitzer wrote:
> > And besides that generic high level sentiment I think the interface
> > for blkdev_issue_discard_async is simply wrong.  Either you want to keep
> > the internals private and just expose a completion callback that gets
> > your private data and an error, or you want to build your own bios as
> > suggested above.  But not one that is mostly opaque except for allowing
> > the caller to hook into the submission process and thus taking over I/O
> > completion.
> 
> I'll see what I can come up with.

Another option would be to help with reviewing and testing this
series: http://thread.gmane.org/gmane.linux.kernel/1947453

If we can get thast one in the submitter doesn't have to care
about aligning or splitting discard (or any other) bios.
