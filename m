From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [dm-devel] Re: [PATCH 0/8] I/O bandwidth controller and BIO tracking
Date: Thu, 13 Nov 2008 21:50:31 +0530
Message-ID: <491C53CF.3010208@linux.vnet.ibm.com>
References: <20081113.121019.104237699577193919.ryov@valinux.co.jp> <20081113153019.cc50d42c.kamezawa.hiroyu@jp.fujitsu.com> <20081113.162623.74628639.taka@valinux.co.jp>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752787AbYKMQU5@vger.kernel.org>
In-Reply-To: <20081113.162623.74628639.taka@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: kamezawa.hiroyu@jp.fujitsu.com, Paul Menage <menage@google.com>, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, fernando@oss.ntt.co.jp, xemul@openvz.org
List-Id: dm-devel.ids

Hirokazu Takahashi wrote:
> Hi, Kamezawa-san,
> 
> This patch makes the page_cgroup framework be able to be used even if
> the compile option of the cgroup memory controller is off.
> So bio-cgroup can use this framework without the memory controller.
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> 
> diff -dupr linux-2.6.28-rc2.bc0/include/linux/memcontrol.h linux-2.6.28-rc2/include/linux/memcontrol.h
> --- linux-2.6.28-rc2.bc0/include/linux/memcontrol.h	2008-11-10 18:31:34.000000000 +0900
> +++ linux-2.6.28-rc2/include/linux/memcontrol.h	2008-11-11 13:51:42.000000000 +0900
> @@ -27,6 +27,9 @@ struct mm_struct;
> 
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> 
> +extern void __init_mem_page_cgroup(struct page_cgroup *pc);
> +#define  mem_cgroup_disabled() mem_cgroup_subsys.disabled
> +
>  extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
>  				gfp_t gfp_mask);
>  /* for swap handling */
> @@ -81,6 +84,15 @@ extern long mem_cgroup_calc_reclaim(stru
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct mem_cgroup;
> 
> +static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
> +{
> +}
> +
> +static inline int mem_cgroup_disabled(void)
> +{
> +	return 1;
> +}
> +

With CONFIG_CGROUP_MEM_RES_CTLR not defined, page_cgroup init routines will just
return, is that what bio page_cgroup needs?

-- 
	Balbir
