From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [dm-devel] Re: [PATCH 0/8] I/O bandwidth controller
 and BIO tracking
Date: Fri, 14 Nov 2008 08:15:32 +0900 (JST)
Message-ID: <20081114.081532.16574084.taka@valinux.co.jp>
References: <20081113153019.cc50d42c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081113.162623.74628639.taka@valinux.co.jp>
	<491C53CF.3010208@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <491C53CF.3010208@linux.vnet.ibm.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: balbir@linux.vnet.ibm.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, menage@google.com, fernando@oss.ntt.co.jp, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org
List-Id: dm-devel.ids

Hi, Balbir,

> Hirokazu Takahashi wrote:
> > Hi, Kamezawa-san,
> > 
> > This patch makes the page_cgroup framework be able to be used even if
> > the compile option of the cgroup memory controller is off.
> > So bio-cgroup can use this framework without the memory controller.
> > 
> > Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> > 
> > diff -dupr linux-2.6.28-rc2.bc0/include/linux/memcontrol.h linux-2.6.28-rc2/include/linux/memcontrol.h
> > --- linux-2.6.28-rc2.bc0/include/linux/memcontrol.h	2008-11-10 18:31:34.000000000 +0900
> > +++ linux-2.6.28-rc2/include/linux/memcontrol.h	2008-11-11 13:51:42.000000000 +0900
> > @@ -27,6 +27,9 @@ struct mm_struct;
> > 
> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > 
> > +extern void __init_mem_page_cgroup(struct page_cgroup *pc);
> > +#define  mem_cgroup_disabled() mem_cgroup_subsys.disabled
> > +
> >  extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
> >  				gfp_t gfp_mask);
> >  /* for swap handling */
> > @@ -81,6 +84,15 @@ extern long mem_cgroup_calc_reclaim(stru
> >  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
> >  struct mem_cgroup;
> > 
> > +static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
> > +{
> > +}
> > +
> > +static inline int mem_cgroup_disabled(void)
> > +{
> > +	return 1;
> > +}
> > +
> 
> With CONFIG_CGROUP_MEM_RES_CTLR not defined, page_cgroup init routines will just
> return, is that what bio page_cgroup needs?
> 
> -- 
> 	Balbir

One of the other patches includes the following code, which calls 
__init_bio_page_cgroup() to initialize bio-cgroup thing.

+++ linux-2.6.28-rc2/mm/page_cgroup.c	2008-11-12 11:20:33.000000000 +0900
@@ -9,6 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
 #include <linux/memcontrol.h>
+#include <linux/biotrack.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -16,6 +17,7 @@ __init_page_cgroup(struct page_cgroup *p
 	pc->flags = 0;
 	pc->page = pfn_to_page(pfn);
 	__init_mem_page_cgroup(pc);
+	__init_bio_page_cgroup(pc);
 }
 static unsigned long total_usage;
