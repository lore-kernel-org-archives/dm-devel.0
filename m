From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9] blkio-cgroup-v9: The new page_cgroup framework
Date: Wed, 22 Jul 2009 14:07:22 +0530
Message-ID: <20090722083722.GI24157@balbir.in.ibm.com>
References: <20090721155636.GB25127@balbir.in.ibm.com> <20090722102058.c1cf731b.kamezawa.hiroyu@jp.fujitsu.com> <20090722110739.e00c0f18.kamezawa.hiroyu@jp.fujitsu.com> <20090722.172843.193696974.ryov@valinux.co.jp>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753794AbZGVIh1@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090722.172843.193696974.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, agk@redhat.com
List-Id: dm-devel.ids

* Ryo Tsuruta <ryov@valinux.co.jp> [2009-07-22 17:28:43]:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > > Index: linux-2.6.31-rc3/include/linux/page_cgroup.h
> > > > > ===================================================================
> > > > > --- linux-2.6.31-rc3.orig/include/linux/page_cgroup.h
> > > > > +++ linux-2.6.31-rc3/include/linux/page_cgroup.h
> > > > > @@ -1,7 +1,7 @@
> > > > >  #ifndef __LINUX_PAGE_CGROUP_H
> > > > >  #define __LINUX_PAGE_CGROUP_H
> > > > > 
> > > > > -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > > > > +#ifdef CONFIG_CGROUP_PAGE
> > > > >  #include <linux/bit_spinlock.h>
> > > > >  /*
> > > > >   * Page Cgroup can be considered as an extended mem_map.
> > > > > @@ -12,9 +12,11 @@
> > > > >   */
> > > > >  struct page_cgroup {
> > > > >  	unsigned long flags;
> > > > > -	struct mem_cgroup *mem_cgroup;
> > > > >  	struct page *page;
> > > > > +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > > > > +	struct mem_cgroup *mem_cgroup;
> > > > >  	struct list_head lru;		/* per cgroup LRU list */
> > > > > +#endif
> > > > >  };
> > > > 
> > > > If CONFIG_CGROUP_MEM_RES_CTLR is not enabled and CGROUP_PAGE is
> > > > (assuming that the depends on below is refactored), what would this
> > > > change buy us? What is page_cgroup helping us track, the mem_cgroup is
> > > > factored out, so we are interested in the flags only?
> > > > 
> > > plz remove CONFIG. This jsut makes code complicated.
> > > or plz use your own infrastructure, not depends on page_cgroup.
> 
> Thanks for reviewing the patch.
> Do you mean that remove only CONFIG_CGROUP_MEM_RES_CTR in struct
> page_cgroup? Is it OK to define CONFIG_CGROUP_PAGE?
> 
> > BTW, you can't modify page_cgroup->flags bit without cmpxchg.
> > Then, patch [5/9] is completely broken, now because new bit is used
> > with atomic bit ops but without lock_page_cgroup(). (see mmotm)
> > 
> > Why struct page's flags bit can includes zone id etc...is just because
> > it's initalized before using. Anyway, this is "flags" bit. If you want
> > to modify multiple bit at once, plz use cmpxchg.
> > Then, I buy patch [8/9] and just skip this patch.
> 
> O.K. I'll use cmpxchg.
> 
> > But, following is more straightforward. (and what you do is not different
> > from this.)
> > ==
> > struct page {
> > 	.....
> > #ifdef CONFIG_BLOCKIO_CGROUP
> > 	void *blockio_cgroup;
> > #endif
> > }
> > ==
> 
> This increases the size of struct page. Could I get a consensus on
> this approach?
>


This defeats the entire purpose of page_cgroup, IMHO. You need to add
the cgroup pointer to page_cgroup or use css id's there.
 
> Thanks,
> Ryo Tsuruta
> 
> > Regards,
> > -Kame
> > 
> > 

-- 
	Balbir
