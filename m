From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Date: Thu, 25 Jun 2020 21:34:42 +0100
Message-ID: <20200625203442.GG7703@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625184832.GP7606@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200625184832.GP7606@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>, Yafang Shao <laoar.shao@gmail.com>
List-Id: dm-devel.ids

On Thu, Jun 25, 2020 at 11:48:32AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 25, 2020 at 12:31:16PM +0100, Matthew Wilcox (Oracle) wrote:
> > I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
> > for an upcoming patch series, and Jens also wants it for non-blocking
> > io_uring.  It turns out we already have dm-bufio which could benefit
> > from memalloc_nowait, so it may as well go into the tree now.
> > 
> > The biggest problem is that we're basically out of PF_ flags, so we need
> > to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
> > out the PF_ flags are really supposed to be used for flags which are
> > accessed from other tasks, and the MEMALLOC flags are only going to
> > be used by this task.  So shuffling everything around frees up some PF
> > flags and generally makes the world a better place.
> 
> So, uh, how does this intersect with the patch "xfs: reintroduce
> PF_FSTRANS for transaction reservation recursion protection" that
> re-adds PF_TRANS because uh I guess we lost some subtlety or another at
> some point?

I don't know.  I read that thread, but I couldn't follow the argument.
