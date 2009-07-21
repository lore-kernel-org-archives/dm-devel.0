From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9] blkio-cgroup-v9: The new page_cgroup
	framework
Date: Tue, 21 Jul 2009 21:26:36 +0530
Message-ID: <20090721155636.GB25127@balbir.in.ibm.com>
References: <20090721.230911.193692312.ryov@valinux.co.jp>
	<20090721.231004.226793074.ryov@valinux.co.jp>
	<20090721.231211.71098738.ryov@valinux.co.jp>
Reply-To: balbir@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090721.231211.71098738.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

* Ryo Tsuruta <ryov@valinux.co.jp> [2009-07-21 23:12:11]:

> This patch makes the page_cgroup framework be able to be used even if
> the compile option of the cgroup memory controller is off.
> So blkio-cgroup can use this framework without the memory controller.
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> 
> ---
>  include/linux/memcontrol.h  |    6 ++++++
>  include/linux/mmzone.h      |    4 ++--
>  include/linux/page_cgroup.h |    8 +++++---
>  init/Kconfig                |    4 ++++
>  mm/Makefile                 |    3 ++-
>  mm/memcontrol.c             |    6 ++++++
>  mm/page_cgroup.c            |    3 +--
>  7 files changed, 26 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6.31-rc3/include/linux/memcontrol.h
> ===================================================================
> --- linux-2.6.31-rc3.orig/include/linux/memcontrol.h
> +++ linux-2.6.31-rc3/include/linux/memcontrol.h
> @@ -37,6 +37,8 @@ struct mm_struct;
>   * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
>   */
> 
> +extern void __init_mem_page_cgroup(struct page_cgroup *pc);
> +
>  extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
>  				gfp_t gfp_mask);
>  /* for swap handling */
> @@ -121,6 +123,10 @@ void mem_cgroup_update_mapped_file_stat(
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct mem_cgroup;
> 
> +static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
> +{
> +}
> +
>  static inline int mem_cgroup_newpage_charge(struct page *page,
>  					struct mm_struct *mm, gfp_t gfp_mask)
>  {
> Index: linux-2.6.31-rc3/include/linux/mmzone.h
> ===================================================================
> --- linux-2.6.31-rc3.orig/include/linux/mmzone.h
> +++ linux-2.6.31-rc3/include/linux/mmzone.h
> @@ -605,7 +605,7 @@ typedef struct pglist_data {
>  	int nr_zones;
>  #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
>  	struct page *node_mem_map;
> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +#ifdef CONFIG_CGROUP_PAGE
>  	struct page_cgroup *node_page_cgroup;
>  #endif
>  #endif
> @@ -956,7 +956,7 @@ struct mem_section {
> 
>  	/* See declaration of similar field in struct zone */
>  	unsigned long *pageblock_flags;
> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +#ifdef CONFIG_CGROUP_PAGE
>  	/*
>  	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
>  	 * section. (see memcontrol.h/page_cgroup.h about this.)
> Index: linux-2.6.31-rc3/include/linux/page_cgroup.h
> ===================================================================
> --- linux-2.6.31-rc3.orig/include/linux/page_cgroup.h
> +++ linux-2.6.31-rc3/include/linux/page_cgroup.h
> @@ -1,7 +1,7 @@
>  #ifndef __LINUX_PAGE_CGROUP_H
>  #define __LINUX_PAGE_CGROUP_H
> 
> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +#ifdef CONFIG_CGROUP_PAGE
>  #include <linux/bit_spinlock.h>
>  /*
>   * Page Cgroup can be considered as an extended mem_map.
> @@ -12,9 +12,11 @@
>   */
>  struct page_cgroup {
>  	unsigned long flags;
> -	struct mem_cgroup *mem_cgroup;
>  	struct page *page;
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +	struct mem_cgroup *mem_cgroup;
>  	struct list_head lru;		/* per cgroup LRU list */
> +#endif
>  };

If CONFIG_CGROUP_MEM_RES_CTLR is not enabled and CGROUP_PAGE is
(assuming that the depends on below is refactored), what would this
change buy us? What is page_cgroup helping us track, the mem_cgroup is
factored out, so we are interested in the flags only?


> 
>  void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
> @@ -83,7 +85,7 @@ static inline void unlock_page_cgroup(st
>  	bit_spin_unlock(PCG_LOCK, &pc->flags);
>  }
> 
> -#else /* CONFIG_CGROUP_MEM_RES_CTLR */
> +#else /* CONFIG_CGROUP_PAGE */
>  struct page_cgroup;
> 
>  static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
> Index: linux-2.6.31-rc3/init/Kconfig
> ===================================================================
> --- linux-2.6.31-rc3.orig/init/Kconfig
> +++ linux-2.6.31-rc3/init/Kconfig
> @@ -614,6 +614,10 @@ config CGROUP_MEM_RES_CTLR_SWAP
> 
>  endif # CGROUPS
> 
> +config CGROUP_PAGE
> +	def_bool y

Should def_bool be "y"? Shouldn't the CGROUP_MEM_RES_CTLR select it.

> +	depends on CGROUP_MEM_RES_CTLR
> +
>  config MM_OWNER
>  	bool
> 
> Index: linux-2.6.31-rc3/mm/Makefile
> ===================================================================
> --- linux-2.6.31-rc3.orig/mm/Makefile
> +++ linux-2.6.31-rc3/mm/Makefile
> @@ -39,6 +39,7 @@ else
>  obj-$(CONFIG_SMP) += allocpercpu.o
>  endif
>  obj-$(CONFIG_QUICKLIST) += quicklist.o
> -obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
> +obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
> +obj-$(CONFIG_CGROUP_PAGE) += page_cgroup.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
> Index: linux-2.6.31-rc3/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.31-rc3.orig/mm/memcontrol.c
> +++ linux-2.6.31-rc3/mm/memcontrol.c
> @@ -129,6 +129,12 @@ struct mem_cgroup_lru_info {
>  	struct mem_cgroup_per_node *nodeinfo[MAX_NUMNODES];
>  };
> 
> +void __meminit __init_mem_page_cgroup(struct page_cgroup *pc)
> +{
> +	pc->mem_cgroup = NULL;
> +	INIT_LIST_HEAD(&pc->lru);
> +}
> +
>  /*
>   * The memory controller data structure. The memory controller controls both
>   * page cache and RSS per cgroup. We would eventually like to provide
> Index: linux-2.6.31-rc3/mm/page_cgroup.c
> ===================================================================
> --- linux-2.6.31-rc3.orig/mm/page_cgroup.c
> +++ linux-2.6.31-rc3/mm/page_cgroup.c
> @@ -14,9 +14,8 @@ static void __meminit
>  __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
>  {
>  	pc->flags = 0;
> -	pc->mem_cgroup = NULL;
>  	pc->page = pfn_to_page(pfn);
> -	INIT_LIST_HEAD(&pc->lru);
> +	__init_mem_page_cgroup(pc);
>  }
>  static unsigned long total_usage;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
	Balbir
