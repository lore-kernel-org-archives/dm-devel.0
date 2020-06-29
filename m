From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Date: Mon, 29 Jun 2020 14:52:31 +0200
Message-ID: <20200629125231.GJ32461@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
	<20200625113122.7540-7-willy@infradead.org>
	<20200629050851.GC1492837@kernel.org>
	<20200629121816.GC25523@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200629121816.GC25523@casper.infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Mike Rapoport <rppt@kernel.org>
List-Id: dm-devel.ids

On Mon 29-06-20 13:18:16, Matthew Wilcox wrote:
> On Mon, Jun 29, 2020 at 08:08:51AM +0300, Mike Rapoport wrote:
> > > @@ -886,8 +868,12 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
> > >  			return NULL;
> > >  
> > >  		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
> > > +			unsigned noio_flag;
> > > +
> > >  			dm_bufio_unlock(c);
> > > -			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > > +			noio_flag = memalloc_noio_save();
> > 
> > I've read the series twice and I'm still missing the definition of
> > memalloc_noio_save().
> > 
> > And also it would be nice to have a paragraph about it in
> > Documentation/core-api/memory-allocation.rst
> 
> Documentation/core-api/gfp_mask-from-fs-io.rst:``memalloc_nofs_save``, ``memalloc_nofs_restore`` respectively ``memalloc_noio_save``,
> Documentation/core-api/gfp_mask-from-fs-io.rst:   :functions: memalloc_noio_save memalloc_noio_restore
> Documentation/core-api/gfp_mask-from-fs-io.rst:allows nesting so it is safe to call ``memalloc_noio_save`` or
 
The patch is adding memalloc_nowait* and I suspect Mike had that in
mind, which would be a fair request. Btw. we are missing memalloc_nocma*
documentation either - I was just reminded of its existence today...

-- 
Michal Hocko
SUSE Labs
