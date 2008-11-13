From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [dm-devel] Re: [PATCH 0/8] I/O bandwidth controller
 and BIO tracking
Date: Thu, 13 Nov 2008 16:26:23 +0900 (JST)
Message-ID: <20081113.162623.74628639.taka@valinux.co.jp>
References: <20081113.121019.104237699577193919.ryov@valinux.co.jp>
	<20081113153019.cc50d42c.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20081113153019.cc50d42c.kamezawa.hiroyu@jp.fujitsu.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp, menage@google.com, balbir@linux.vnet.ibm.com, fernando@oss.ntt.co.jp, xemul@openvz.org
List-Id: dm-devel.ids

Hi, Kamezawa-san,

> > Hi everyone,
> > 
> > This is a new release of dm-ioband and bio-cgroup. With this release,
> > the overhead of bio-cgroup is significantly reduced and the accuracy
> > of block I/O tracking is much improved. These patches are for
> > 2.6.28-rc2-mm1.
> > 
> 
> >From my point of view, a way to record bio_cgroup_id to page_cgroup is quite neat
> and nice.
> 
> My concern is "bio_cgroup_id". It's provided only for bio_cgroup.
> In this summer, I tried to add swap_cgroup_id only for mem+swap controller but
> commenters said "please provide "id and lookup" in cgroup layer, it should be useful."
> And I agree them. (and postponed it ;)

Yup, that sounds really good.

> Could you try "id" in cgroup layer ? How do you think, Paul and others ?

It seems to easy to implement this feature since what I need to do is
move the code from bio-group to there.
Okay, I'll start it if Paul agrees with this approach.

> That's my only concern and if I/O controller people decides to live with
> this bio tracking infrastracture,
> ==
>    page -> page_cgroup -> bio_cgroup_id
> ==
> I have no objections. And enqueue necessary changes to my queue.

It would be nice if you can include the following patch, which just makes
the page_cgroup infrastructure can be compiled in even when the cgroup
memory controller is compiled out.

> Thanks,
> -Kame

Thank you,
Hirokazu Takahashi.

 ---------------------------

This patch makes the page_cgroup framework be able to be used even if
the compile option of the cgroup memory controller is off.
So bio-cgroup can use this framework without the memory controller.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>

diff -dupr linux-2.6.28-rc2.bc0/include/linux/memcontrol.h linux-2.6.28-rc2/include/linux/memcontrol.h
--- linux-2.6.28-rc2.bc0/include/linux/memcontrol.h	2008-11-10 18:31:34.000000000 +0900
+++ linux-2.6.28-rc2/include/linux/memcontrol.h	2008-11-11 13:51:42.000000000 +0900
@@ -27,6 +27,9 @@ struct mm_struct;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
+extern void __init_mem_page_cgroup(struct page_cgroup *pc);
+#define  mem_cgroup_disabled() mem_cgroup_subsys.disabled
+
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 /* for swap handling */
@@ -81,6 +84,15 @@ extern long mem_cgroup_calc_reclaim(stru
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
+static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
+{
+}
+
+static inline int mem_cgroup_disabled(void)
+{
+	return 1;
+}
+
 static inline int mem_cgroup_newpage_charge(struct page *page,
 					struct mm_struct *mm, gfp_t gfp_mask)
 {
diff -dupr linux-2.6.28-rc2.bc0/include/linux/mmzone.h linux-2.6.28-rc2/include/linux/mmzone.h
--- linux-2.6.28-rc2.bc0/include/linux/mmzone.h	2008-11-10 18:50:50.000000000 +0900
+++ linux-2.6.28-rc2/include/linux/mmzone.h	2008-11-11 13:51:42.000000000 +0900
@@ -603,7 +603,7 @@ typedef struct pglist_data {
 	int nr_zones;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	struct page_cgroup *node_page_cgroup;
 #endif
 #endif
@@ -952,7 +952,7 @@ struct mem_section {
 
 	/* See declaration of similar field in struct zone */
 	unsigned long *pageblock_flags;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	/*
 	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
 	 * section. (see memcontrol.h/page_cgroup.h about this.)
diff -dupr linux-2.6.28-rc2.bc0/include/linux/page_cgroup.h linux-2.6.28-rc2/include/linux/page_cgroup.h
--- linux-2.6.28-rc2.bc0/include/linux/page_cgroup.h	2008-11-10 19:29:00.000000000 +0900
+++ linux-2.6.28-rc2/include/linux/page_cgroup.h	2008-11-11 14:46:47.000000000 +0900
@@ -1,7 +1,7 @@
 #ifndef __LINUX_PAGE_CGROUP_H
 #define __LINUX_PAGE_CGROUP_H
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 #include <linux/bit_spinlock.h>
 /*
  * Page Cgroup can be considered as an extended mem_map.
@@ -12,9 +12,11 @@
  */
 struct page_cgroup {
 	unsigned long flags;
-	struct mem_cgroup *mem_cgroup;
 	struct page *page;
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	struct mem_cgroup *mem_cgroup;
 	struct list_head lru;		/* per cgroup LRU list */
+#endif
 };
 
 void __init pgdat_page_cgroup_init(struct pglist_data *pgdat);
@@ -88,7 +90,7 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-#else /* CONFIG_CGROUP_MEM_RES_CTLR */
+#else /* CONFIG_CGROUP_PAGE */
 struct page_cgroup;
 
 static inline void pgdat_page_cgroup_init(struct pglist_data *pgdat)
diff -dupr linux-2.6.28-rc2.bc0/init/Kconfig linux-2.6.28-rc2/init/Kconfig
--- linux-2.6.28-rc2.bc0/init/Kconfig	2008-11-10 18:31:34.000000000 +0900
+++ linux-2.6.28-rc2/init/Kconfig	2008-11-11 14:46:47.000000000 +0900
@@ -425,6 +425,10 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
 
+config CGROUP_PAGE
+	def_bool y
+	depends on CGROUP_MEM_RES_CTLR
+
 config MM_OWNER
 	bool
 
diff -dupr linux-2.6.28-rc2.bc0/mm/Makefile linux-2.6.28-rc2/mm/Makefile
--- linux-2.6.28-rc2.bc0/mm/Makefile	2008-11-10 18:31:34.000000000 +0900
+++ linux-2.6.28-rc2/mm/Makefile	2008-11-11 14:46:47.000000000 +0900
@@ -34,5 +34,6 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o cpu_alloc.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_CGROUP_PAGE) += page_cgroup.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
diff -dupr linux-2.6.28-rc2.bc0/mm/memcontrol.c linux-2.6.28-rc2/mm/memcontrol.c
--- linux-2.6.28-rc2.bc0/mm/memcontrol.c	2008-11-10 18:31:34.000000000 +0900
+++ linux-2.6.28-rc2/mm/memcontrol.c	2008-11-11 14:48:17.000000000 +0900
@@ -157,6 +157,11 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 	0, /* FORCE */
 };
 
+void __meminit __init_mem_page_cgroup(struct page_cgroup *pc)
+{
+	pc->mem_cgroup = NULL;
+}
+
 /*
  * Always modified under lru lock. Then, not necessary to preempt_disable()
  */
diff -dupr linux-2.6.28-rc2.bc0/mm/page_cgroup.c linux-2.6.28-rc2/mm/page_cgroup.c
--- linux-2.6.28-rc2.bc0/mm/page_cgroup.c	2008-11-10 18:31:34.000000000 +0900
+++ linux-2.6.28-rc2/mm/page_cgroup.c	2008-11-11 14:46:47.000000000 +0900
@@ -8,13 +8,14 @@
 #include <linux/memory.h>
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
+#include <linux/memcontrol.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
 {
 	pc->flags = 0;
-	pc->mem_cgroup = NULL;
 	pc->page = pfn_to_page(pfn);
+	__init_mem_page_cgroup(pc);
 }
 static unsigned long total_usage;
 
@@ -69,7 +70,7 @@ void __init page_cgroup_init(void)
 
 	int nid, fail;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 
 	for_each_online_node(nid)  {
@@ -229,7 +230,7 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 
 	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
