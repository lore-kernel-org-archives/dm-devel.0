From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 2/6] dm raid45 target: introduce memory cache
Date: Mon, 22 Jun 2009 13:13:08 +0200
Message-ID: <1245669188.7390.13.camel@o>
References: <4a368304.ChlIzzc+4MKVMZmr%heinzm@redhat.com>
	<E9C76B34-11CA-4533-8CEC-44A623C4AD77@redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E9C76B34-11CA-4533-8CEC-44A623C4AD77@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2009-06-19 at 11:45 -0500, Jonathan Brassow wrote:
> This patch looks good to me.  Just a couple questions about object
> accounting...

Jon,
see below.

> 
> 
>  brassow
> 
> On Jun 15, 2009, at 12:21 PM, heinzm@redhat.com wrote:
> 
> > +int dm_mem_cache_grow(struct dm_mem_cache_client *cl, unsigned
> > objects)
> > +{
> > + unsigned pages = objects * cl->chunks * cl->pages_per_chunk;
> > + struct page_list *pl, *last;
> > +
> > + BUG_ON(!pages);
> > + pl = alloc_cache_pages(pages);
> > + if (!pl)
> > + return -ENOMEM;
> > +
> > + last = pl;
> > + while (last->next)
> > + last = last->next;
> > +
> > + spin_lock_irq(&cl->lock);
> > + last->next = cl->free_list;
> > + cl->free_list = pl;
> > + cl->free_pages += pages;
> > + cl->total_pages += pages;
> > + cl->objects++;
> 
> 
> Should this be 'cl->objects += objects'?

Thanks, good catch.
The reason why this didn't cause trouble so far is, that the caller only
requested one object per call on allocate/free.

> 
> > + spin_unlock_irq(&cl->lock);
> > +
> > + mempool_resize(cl->objs_pool, cl->objects, GFP_NOIO);
> 
> 
> Do we need to check return value here?
> 
> > + return 0;
> > +}
> > +EXPORT_SYMBOL(dm_mem_cache_grow);
> > +
> > +/* Shrink a clients cache by an amount of pages */
> > +int dm_mem_cache_shrink(struct dm_mem_cache_client *cl, unsigned
> > objects)
> > +{
> > + int r;
> > + unsigned pages = objects * cl->chunks * cl->pages_per_chunk, p =
> > pages;
> > + unsigned long flags;
> > + struct page_list *last = NULL, *pl, *pos;
> > +
> > + BUG_ON(!pages);
> > +
> > + spin_lock_irqsave(&cl->lock, flags);
> > + pl = pos = cl->free_list;
> > + while (p-- && pos->next) {
> > + last = pos;
> > + pos = pos->next;
> > + }
> > +
> > + if (++p)
> > + r = -ENOMEM;
> > + else {
> > + r = 0;
> > + cl->free_list = pos;
> > + cl->free_pages -= pages;
> > + cl->total_pages -= pages;
> > + cl->objects--;
> 
> 
> 'cl->objects -= objects'?

Yes, likewise.

> 
> > + last->next = NULL;
> > + }
> > + spin_unlock_irqrestore(&cl->lock, flags);
> > +
> > + if (!r) {
> > + free_cache_pages(pl);
> > + mempool_resize(cl->objs_pool, cl->objects, GFP_NOIO);
> 
> 
> When shrinking, 'mempool_resize' will not fail... no need to check
> return value?

Yes.

> 
> > + }
> > +
> > + return r;
> > +}
> > +EXPORT_SYMBOL(dm_mem_cache_shrink);
> > +
> > +/*
> > + * Allocate/free a memory object
> > + *
> > + * Can be called from interrupt context
> > + */
> > +struct dm_mem_cache_object *dm_mem_cache_alloc(struct
> > dm_mem_cache_client *cl)
> > +{
> > + int r = 0;
> > + unsigned pages = cl->chunks * cl->pages_per_chunk;
> > + unsigned long flags;
> > + struct dm_mem_cache_object *obj;
> > +
> > + obj = mempool_alloc(cl->objs_pool, GFP_NOIO);
> > + if (!obj)
> > + return ERR_PTR(-ENOMEM);
> > +
> > + spin_lock_irqsave(&cl->lock, flags);
> > + if (pages > cl->free_pages)
> > + r = -ENOMEM;
> > + else
> > + cl->free_pages -= pages;
> > + spin_unlock_irqrestore(&cl->lock, flags);
> 
> 
> It's not important, but 'free_chunks' adjusts the 'cl->free_pages'
> count for us...  That made me look for where 'cl->free_pages' was
> adjusted in 'alloc_chunks', but that is done here.  Could we push this
> critical section into alloc_chunks and then just check the return code
> of that?

dm_mem_cache_alloc() adjusts cl->free_pages holding cl->lock before it
allocates the pages from the list via alloc_chunks(), where the cl->lock
is held very short to pop one page off the list in order to allow for
allocation parallelism with multiple thread in the allocator function
chain. Hence a dm_mem_cache_alloc() call can run in parallel with the
actual allocation of pages of another caller.

On the dm_mem_cache_free() side of things, again cl->lock is hold for a
short period of time to enhance parallelism.

All that not playing out performance-wise with this caller (yet) because
of single threaded allocate/free calls.

Heinz

> 
> > +
> > + if (r) {
> > + mempool_free(obj, cl->objs_pool);
> > + return ERR_PTR(r);
> > + }
> > +
> > + alloc_chunks(cl, obj);
> > + return obj;
> > +}
> > +EXPORT_SYMBOL(dm_mem_cache_alloc);
> > +
> > +void dm_mem_cache_free(struct dm_mem_cache_client *cl,
> > +        struct dm_mem_cache_object *obj)
> > +{
> > + free_chunks(cl, obj);
> > + mempool_free(obj, cl->objs_pool);
> > +}
> > +EXPORT_SYMBOL(dm_mem_cache_free);
> > +
> > +MODULE_DESCRIPTION(DM_NAME " dm memory cache");
> > +MODULE_AUTHOR("Heinz Mauelshagen <hjm@redhat.com>");
> > +MODULE_LICENSE("GPL");
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
