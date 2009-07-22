From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 3/9] blkio-cgroup-v9: The new page_cgroup
	framework
Date: Wed, 22 Jul 2009 18:30:11 +0900 (JST)
Message-ID: <20090722.183011.226792119.ryov@valinux.co.jp>
References: <20090722110739.e00c0f18.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722.172843.193696974.ryov@valinux.co.jp>
	<20090722173941.7608387e.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20090722173941.7608387e.kamezawa.hiroyu@jp.fujitsu.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 22 Jul 2009 17:28:43 +0900 (JST)
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> > > But, following is more straightforward. (and what you do is not different
> > > from this.)
> > > ==
> > > struct page {
> > > 	.....
> > > #ifdef CONFIG_BLOCKIO_CGROUP
> > > 	void *blockio_cgroup;
> > > #endif
> > > }
> > > ==
> > 
> > This increases the size of struct page. Could I get a consensus on
> > this approach?
> > 
> Just God knows ;)
> 
> To be honest, what I expected in these days for people of blockio cgroup is like
> following for getting room for themselves.
> 
> I'm now thinking to do this by myself and offer a room for you because
> terrible bugs have been gone now and I have time.

It is very nice for blkio-cgroup, it can make blkio-cgroup simple and
more faster to track down the owner of an I/O request.

Thanks,
Ryo Tsuruta

> Balbir, if you have no concerns, I'll clean up and send this to mmotm.
> (maybe softlimit accesses pc->page and I have to update this.)
> 
> Note: This is _not_ tested at all.
> 
> Thanks,
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> page cgroup has pointer to memmap it stands for.
> But, page_cgroup->page is not accessed in fast path and not necessary
> and not modified. Then, it's not to be maintained as pointer.
> 
> This patch removes "page" from page_cgroup and add
> page_cgroup_to_page() function. This uses some amount of FLAGS bit
> as struct page does.
> As side effect, nid, zid can be obtaind from page_cgroup itself.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/page_cgroup.h |   19 ++++++++++++++++---
>  mm/page_cgroup.c            |   42 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 48 insertions(+), 13 deletions(-)
> 
> Index: mmotm-2.6.31-Jul16/include/linux/page_cgroup.h
> ===================================================================
> --- mmotm-2.6.31-Jul16.orig/include/linux/page_cgroup.h
> +++ mmotm-2.6.31-Jul16/include/linux/page_cgroup.h
> @@ -13,7 +13,7 @@
>  struct page_cgroup {
>  	unsigned long flags;
>  	struct mem_cgroup *mem_cgroup;
> -	struct page *page;
> +	/* block io tracking will use extra unsigned long bytes */
>  	struct list_head lru;		/* per cgroup LRU list */
>  };
>  
> @@ -32,7 +32,12 @@ static inline void __init page_cgroup_in
>  #endif
>  
>  struct page_cgroup *lookup_page_cgroup(struct page *page);
> +struct page *page_cgroup_to_page(struct page_cgroup *page);
>  
> +/*
> + * TOP MOST (NODE_SHIFT+ZONE_SHIFT or SECTION_SHIFT bits of "flags" are used
> + * for detecting pfn as struct page does.
> + */
>  enum {
>  	/* flags for mem_cgroup */
>  	PCG_LOCK,  /* page cgroup is locked */
> @@ -71,14 +76,22 @@ CLEARPCGFLAG(AcctLRU, ACCT_LRU)
>  TESTPCGFLAG(AcctLRU, ACCT_LRU)
>  TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
>  
> +#ifdef NODE_NOT_IN_PAGE_FLAGS
>  static inline int page_cgroup_nid(struct page_cgroup *pc)
>  {
> -	return page_to_nid(pc->page);
> +	struct page *page= page_cgroup_to_page(pc);
> +	return page_to_nid(page);
>  }
> +#else
> +static inline int page_cgroup_nid(struct page_cgroup *pc)
> +{
> +	return (pc->flags >> NODES_PGSHIFT) & NODES_MASK;
> +}
> +#endif
>  
>  static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
>  {
> -	return page_zonenum(pc->page);
> +	return (pc->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
>  }
>  
>  static inline void lock_page_cgroup(struct page_cgroup *pc)
> Index: mmotm-2.6.31-Jul16/mm/page_cgroup.c
> ===================================================================
> --- mmotm-2.6.31-Jul16.orig/mm/page_cgroup.c
> +++ mmotm-2.6.31-Jul16/mm/page_cgroup.c
> @@ -13,9 +13,12 @@
>  static void __meminit
>  __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
>  {
> -	pc->flags = 0;
> +	unsigned long flags;
> +
>  	pc->mem_cgroup = NULL;
> -	pc->page = pfn_to_page(pfn);
> +	/* Copy NODE/ZONE/SECTION information from struct page */
> +	flags = pfn_to_page(pfn)->flags;
> +	pc->flags = flags & ~((1 << __NR_PAGEFLAGS) - 1);
>  	INIT_LIST_HEAD(&pc->lru);
>  }
>  static unsigned long total_usage;
> @@ -42,6 +45,18 @@ struct page_cgroup *lookup_page_cgroup(s
>  	return base + offset;
>  }
>  
> +struct page *page_cgroup_to_page(struct page_cgroup *pc)
> +{
> +	int nid = (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> +	unsigned long pfn, offset;
> +
> +	offset = pc - NODE_DATA(nid)->node_page_cgroup
> +	pfn = NODE_DATA(nid)->node_start_pfn + offset;
> +
> +	return pfn_to_page(pfn);
> +}
> +
> +
>  static int __init alloc_node_page_cgroup(int nid)
>  {
>  	struct page_cgroup *base, *pc;
> @@ -104,6 +119,18 @@ struct page_cgroup *lookup_page_cgroup(s
>  	return section->page_cgroup + pfn;
>  }
>  
> +struct page *page_cgroup_to_page(struct page_cgroup *pc)
> +{
> +	unsigned long pfn, sectionid;
> +	struct mem_section *section;
> +
> +	sectionid = (pc->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> +	section = __nr_to_section(sectionid);
> +
> +	pfn = pc - section->page_cgroup;
> +	return pfn_to_page(pfn);
> +}
> +
>  /* __alloc_bootmem...() is protected by !slab_available() */
>  static int __init_refok init_section_page_cgroup(unsigned long pfn)
>  {
> @@ -128,15 +155,10 @@ static int __init_refok init_section_pag
>  		}
>  	} else {
>  		/*
> - 		 * We don't have to allocate page_cgroup again, but
> -		 * address of memmap may be changed. So, we have to initialize
> -		 * again.
> + 		 * We don't have to allocate page_cgroup again, and we don't
> +		 * take care of address of memmap.
>  		 */
> -		base = section->page_cgroup + pfn;
> -		table_size = 0;
> -		/* check address of memmap is changed or not. */
> -		if (base->page == pfn_to_page(pfn))
> -			return 0;
> +		return 0;
>  	}
>  
>  	if (!base) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
