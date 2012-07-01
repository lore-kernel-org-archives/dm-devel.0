From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [RFC PATCH] block: all callers should check
 blkdev_issue_flush's return
Date: Sun, 1 Jul 2012 00:28:38 -0700
Message-ID: <20120701072836.GA13247@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1340724445-3314-1-git-send-email-snitzer@redhat.com>
 <20120626155115.GA17242@infradead.org>
 <20120626155750.GA3494@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120626155750.GA3494@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tj@kernel.org, jmoyer@redhat.com, vgoyal@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 26, 2012 at 11:57:50AM -0400, Mike Snitzer wrote:
> On Tue, Jun 26 2012 at 11:51am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, Jun 26, 2012 at 11:27:25AM -0400, Mike Snitzer wrote:
> > > It is concerning that a FLUSH may fail but the blkdev_issue_flush
> > > callers assume it will always succeed.
> > > 
> > > Each blkdev_issue_flush caller should come to terms with the reality
> > > that a FLUSH may fail -- the file_operations' .fsync methods in
> > > particular.  nilfs2 is the only filesystem that checks
> > > blkdev_issue_flush's return.
> > 
> > Good spot, but it would be way better if you actually provided patches
> > to fix this instead of just adding more compiler warnings.
> 
> Alasdair pointed this issue out in response to me asserting that
> blkdev_issue_flush does return non-void.  But anyway, others knowing
> about this issue is half the battle. ;)
> 
> Most .fsync methods are straight-forward to convert but I'd prefer each
> filesystem maintainer actively audit all blkdev_issue_flush calls.

So send it out with maintainers on cc: and get Acks.  That way we have a
coherent patch series cleaning up the in-tree filesystems, rather than a
bunch of warnings for every compile until the maintainers notice.

Joel


-- 

"To announce that there must be no criticism of them president, or
 that we are to stand by the president, right or wrong, is not only
 unpatriotic and servile, but is morally treasonable to the American
 public."
	- Theodore Roosevelt

			http://www.jlbec.org/
			jlbec@evilplan.org
