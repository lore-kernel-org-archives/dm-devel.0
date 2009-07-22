From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/9] blkio-cgroup-v9: The new page_cgroup framework
Date: Wed, 22 Jul 2009 10:20:58 +0900
Message-ID: <20090722102058.c1cf731b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090721.230911.193692312.ryov@valinux.co.jp>
	<20090721.231004.226793074.ryov@valinux.co.jp>
	<20090721.231211.71098738.ryov@valinux.co.jp>
	<20090721155636.GB25127@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754340AbZGVBWr@vger.kernel.org>
In-Reply-To: <20090721155636.GB25127@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, agk@redhat.com
List-Id: dm-devel.ids

On Tue, 21 Jul 2009 21:26:36 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Ryo Tsuruta <ryov@valinux.co.jp> [2009-07-21 23:12:11]:
> 
> > This patch makes the page_cgroup framework be able to be used even if
> > the compile option of the cgroup memory controller is off.
> > So blkio-cgroup can use this framework without the memory controller.
> > 
> > Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> > Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> > 
> > ---
> >  include/linux/memcontrol.h  |    6 ++++++
> >  include/linux/mmzone.h      |    4 ++--
> >  include/linux/page_cgroup.h |    8 +++++---
> >  init/Kconfig                |    4 ++++
> >  mm/Makefile                 |    3 ++-
> >  mm/memcontrol.c             |    6 ++++++
> >  mm/page_cgroup.c            |    3 +--
> >  7 files changed, 26 insertions(+), 8 deletions(-)
> > 
> > Index: linux-2.6.31-rc3/include/linux/memcontrol.h
> > ===================================================================
> > --- linux-2.6.31-rc3.orig/include/linux/memcontrol.h
> > +++ linux-2.6.31-rc3/include/linux/memcontrol.h
> > @@ -37,6 +37,8 @@ struct mm_struct;
> >   * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
> >   */
> > 
> > +extern void __init_mem_page_cgroup(struct page_cgroup *pc);
> > +
> >  extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
> >  				gfp_t gfp_mask);
> >  /* for swap handling */
> > @@ -121,6 +123,10 @@ void mem_cgroup_update_mapped_file_stat(
> >  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
> >  struct mem_cgroup;
> > 
> > +static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
> > +{
> > +}
> > +
> >  static inline int mem_cgroup_newpage_charge(struct page *page,
> >  					struct mm_struct *mm, gfp_t gfp_mask)
> >  {
> > Index: linux-2.6.31-rc3/include/linux/mmzone.h
> > ===================================================================
> > --- linux-2.6.31-rc3.orig/include/linux/mmzone.h
> > +++ linux-2.6.31-rc3/include/linux/mmzone.h
> > @@ -605,7 +605,7 @@ typedef struct pglist_data {
> >  	int nr_zones;
> >  #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
> >  	struct page *node_mem_map;
> > -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > +#ifdef CONFIG_CGROUP_PAGE
> >  	struct page_cgroup *node_page_cgroup;
> >  #endif
> >  #endif
> > @@ -956,7 +956,7 @@ struct mem_section {
> > 
> >  	/* See declaration of similar field in struct zone */
> >  	unsigned long *pageblock_flags;
> > -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > +#ifdef CONFIG_CGROUP_PAGE
> >  	/*
> >  	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
> >  	 * section. (see memcontrol.h/page_cgroup.h about this.)
> > Index: linux-2.6.31-rc3/include/linux/page_cgroup.h
> > ===================================================================
> > --- linux-2.6.31-rc3.orig/include/linux/page_cgroup.h
> > +++ linux-2.6.31-rc3/include/linux/page_cgroup.h
> > @@ -1,7 +1,7 @@
> >  #ifndef __LINUX_PAGE_CGROUP_H
> >  #define __LINUX_PAGE_CGROUP_H
> > 
> > -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > +#ifdef CONFIG_CGROUP_PAGE
> >  #include <linux/bit_spinlock.h>
> >  /*
> >   * Page Cgroup can be considered as an extended mem_map.
> > @@ -12,9 +12,11 @@
> >   */
> >  struct page_cgroup {
> >  	unsigned long flags;
> > -	struct mem_cgroup *mem_cgroup;
> >  	struct page *page;
> > +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > +	struct mem_cgroup *mem_cgroup;
> >  	struct list_head lru;		/* per cgroup LRU list */
> > +#endif
> >  };
> 
> If CONFIG_CGROUP_MEM_RES_CTLR is not enabled and CGROUP_PAGE is
> (assuming that the depends on below is refactored), what would this
> change buy us? What is page_cgroup helping us track, the mem_cgroup is
> factored out, so we are interested in the flags only?
> 
plz remove CONFIG. This jsut makes code complicated.
or plz use your own infrastructure, not depends on page_cgroup.

Thanks,
-Kame
