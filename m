From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Date: Thu, 25 Jun 2020 15:34:20 +0200
Message-ID: <20200625133420.GN1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200625124017.GL1320@dhcp22.suse.cz>
 <20200625131055.GC7703@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200625131055.GC7703@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Thu 25-06-20 14:10:55, Matthew Wilcox wrote:
> On Thu, Jun 25, 2020 at 02:40:17PM +0200, Michal Hocko wrote:
> > On Thu 25-06-20 12:31:22, Matthew Wilcox wrote:
> > > Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> > > guarantees we will not sleep to reclaim memory.  Use it to simplify
> > > dm-bufio's allocations.
> > 
> > memalloc_nowait is a good idea! I suspect the primary usecase would be
> > vmalloc.
> 
> That's funny.  My use case is allocating page tables in an RCU protected
> page fault handler.  Jens' use case is allocating page cache.  This one
> is a vmalloc consumer (which is also indirectly page table allocation).
> 
> > > @@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
> > >  	 */
> > >  	while (1) {
> > >  		if (dm_bufio_cache_size_latch != 1) {
> > > -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > > +			unsigned nowait_flag = memalloc_nowait_save();
> > > +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > > +			memalloc_nowait_restore(nowait_flag);
> > 
> > This looks confusing though. I am not familiar with alloc_buffer and
> > there is quite some tweaking around __GFP_NORETRY in alloc_buffer_data
> > which I do not follow but GFP_KERNEL just struck my eyes. So why cannot
> > we have 
> > 		alloc_buffer(GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
> 
> Actually, I wanted to ask about the proliferation of __GFP_NOMEMALLOC
> in the block layer.  Am I right in thinking it really has no effect
> unless GFP_ATOMIC is set?

It does have an effect as an __GFP_MEMALLOC resp PF_MEMALLOC inhibitor.

> It seems like a magic flag that some driver
> developers are sprinkling around randomly, so we probably need to clarify
> the documentation on it.

Would the following make more sense?
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 67a0774e080b..014aa7a6d36a 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -116,8 +116,9 @@ struct vm_area_struct;
  * Usage of a pre-allocated pool (e.g. mempool) should be always considered
  * before using this flag.
  *
- * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
- * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
+ * %__GFP_NOMEMALLOC is used to inhibit __GFP_MEMALLOC resp. process scope
+ * variant of it PF_MEMALLOC. So use this flag if the caller of the allocation
+ * context might contain one or the other.
  */
 #define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)
 #define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)

> What I was trying to do was just use the memalloc_nofoo API to control
> what was going on and then the driver can just use GFP_KERNEL.  I should
> probably have completed that thought before sending the patches out.

Yes the effect will be the same but it just really hit my eyes as this
was in the same diff. IMHO GFP_NOWAIT would be easier to grasp but
nothing I would dare to insist on.
-- 
Michal Hocko
SUSE Labs
