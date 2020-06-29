From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Date: Mon, 29 Jun 2020 10:22:09 +0200
Message-ID: <20200629082209.GC32461@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
	<alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626230847.GI2005@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200626230847.GI2005@dread.disaster.area>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Sat 27-06-20 09:08:47, Dave Chinner wrote:
> On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> > prevents both filesystem recursion and i/o recursion.
> > 
> > Note that any I/O can recurse into a filesystem via the loop device, thus 
> > it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> > and PF_MEMALLOC_NOIO is not set.
> 
> Correct me if I'm wrong, but I think that will prevent swapping from
> GFP_NOFS memory reclaim contexts. IOWs, this will substantially
> change the behaviour of the memory reclaim system under sustained
> GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
> quite common, so I really don't think we want to telling memory
> reclaim "you can't do IO at all" when all we are trying to do is
> prevent recursion back into the same filesystem.
> 
> Given that the loop device IO path already operates under
> memalloc_noio context, (i.e. the recursion restriction is applied in
> only the context that needs is) I see no reason for making that a
> global reclaim limitation....
> 
> In reality, we need to be moving the other way with GFP_NOFS - to
> fine grained anti-recursion contexts, not more broad contexts.

Absolutely agreed! It is not really hard to see system struggling due to
heavy FS metadata workload while there are objects which could be
reclaimed.

> That is, GFP_NOFS prevents recursion into any filesystem, not just
> the one that we are actively operating on and needing to prevent
> recursion back into. We can safely have reclaim do relcaim work on
> other filesysetms without fear of recursion deadlocks, but the
> memory reclaim infrastructure does not provide that capability.(*)
> 
> e.g. if memalloc_nofs_save() took a reclaim context structure that
> the filesystem put the superblock, the superblock's nesting depth
> (because layering on loop devices can create cross-filesystem
> recursion dependencies), and any other filesyetm private data the
> fs wanted to add, we could actually have reclaim only avoid reclaim
> from filesytsems where there is a deadlock possiblity. e.g:
> 
> 	- superblock nesting depth is different, apply GFP_NOFS
> 	  reclaim unconditionally
> 	- superblock different apply GFP_KERNEL reclaim
> 	- superblock the same, pass context to filesystem to
> 	  decide if reclaim from the sueprblock is safe.
> 
> At this point, we get memory reclaim able to always be able to
> reclaim from filesystems that are not at risk of recursion
> deadlocks. Direct reclaim is much more likely to be able to make
> progress now because it is much less restricted in what it can
> reclaim. That's going to make direct relcaim faster and more
> efficient, and taht's the ultimate goal we are aiming to acheive
> here...

Yes, we have discussed something like that few years back at LSFMM IIRC.
The scoped NOFS/NOIO api was just a first step to reduce explicit
NOFS/NOIO usage with a hope that we will get no-recursion entry points
much more well defined and get rid of many instances where "this is a fs
code so it has to use NOFS gfp mask".

Some of that has happened and that is really great. On the other hand
many people still like to use that api as a workaround for an immediate
problem because no-recursion scopes are much harder to recognize unless
you are supper familiar with the specific fs/IO layer implementation.
So this is definitely not a project for somebody to go over all code and
just do the clean up.

Thanks!
-- 
Michal Hocko
SUSE Labs
