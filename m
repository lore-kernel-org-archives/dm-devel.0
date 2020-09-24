From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Date: Thu, 24 Sep 2020 02:10:06 +0100
Message-ID: <20200924011006.GT32101@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200924003902.GA10500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200924003902.GA10500@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 23, 2020 at 08:39:02PM -0400, Mike Snitzer wrote:
> On Thu, Jun 25 2020 at  7:31am -0400,
> Matthew Wilcox (Oracle) <willy@infradead.org> wrote:
> 
> > Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> > guarantees we will not sleep to reclaim memory.  Use it to simplify
> > dm-bufio's allocations.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  drivers/md/dm-bufio.c    | 30 ++++++++----------------------
> >  include/linux/sched.h    |  1 +
> >  include/linux/sched/mm.h | 12 ++++++++----
> >  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> 
> Hi,
> 
> Curious on the state of this patchset?  Not seeing it in next-20200923
> 
> The dm-bufio cleanup looks desirable.

I've been busy with THPs and haven't pushed this patchset for this window.
It's probably a bit late now we're at rc6, so I'll clean it up and push
it for 5.11?
