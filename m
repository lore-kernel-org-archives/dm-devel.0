From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory
 subsystem into two parts
Date: Tue, 05 Aug 2008 19:35:51 +0900 (JST)
Message-ID: <20080805.193551.14286210.taka@valinux.co.jp>
References: <20080804.175707.104036289.ryov@valinux.co.jp>
	<20080804.175748.189722512.ryov@valinux.co.jp>
	<48982A9D.2000803@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <48982A9D.2000803@gmail.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: righi.andrea@gmail.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp
List-Id: dm-devel.ids

Hi, Andrea,

> you can remove some ifdefs doing:

I think you don't have to care about this much, since one of the following
patches removes most of these ifdefs.

> #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> 	if (likely(!memcg)) {
> 		rcu_read_lock();
> 		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
> 		/*
> 		 * For every charge from the cgroup, increment reference count
> 		 */
> 		css_get(&mem->css);
> 		rcu_read_unlock();
> 	} else {
> 		mem = memcg;
> 		css_get(&memcg->css);
> 	}
> 	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
> 		if (!(gfp_mask & __GFP_WAIT))
> 			goto out;
> 
> 		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
> 			continue;
> 
> 		/*
> 		 * try_to_free_mem_cgroup_pages() might not give us a full
> 		 * picture of reclaim. Some pages are reclaimed and might be
> 		 * moved to swap cache or just unmapped from the cgroup.
> 		 * Check the limit again to see if the reclaim reduced the
> 		 * current usage of the cgroup before giving up
> 		 */
> 		if (res_counter_check_under_limit(&mem->res))
> 			continue;
> 
> 		if (!nr_retries--) {
> 			mem_cgroup_out_of_memory(mem, gfp_mask);
> 			goto out;
> 		}
> 	}
> 	pc->mem_cgroup = mem;
> #endif /* CONFIG_CGROUP_MEM_RES_CTLR */
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
