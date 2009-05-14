From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
 handling
Date: Thu, 14 May 2009 10:25:04 +0800
Message-ID: <4A0B8100.1090007@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com> <20090513155900.GA15623@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762509AbZENC0W@vger.kernel.org>
In-Reply-To: <20090513155900.GA15623@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> Hi Gui,
> 
> It might make sense to also store the device name or device major and
> minor number in io_group while creating the io group. This will help us
> to display io.disk_time and io.disk_sector statistics per device instead
> of aggregate.
> 
> I am attaching a patch I was playing around with to display per device
> statistics instead of aggregate one. So if user has specified the per
> device rule.
> 
> Thanks
> Vivek
> 
> 
> o Currently the statistics exported through cgroup are aggregate of statistics
>   on all devices for that cgroup. Instead of aggregate, make these per device.
> 
> o Also export another statistics io.disk_dequeue. This keeps a count of how
>   many times a particular group got out of race for the disk. This is a
>   debugging aid to keep a track how often we could create continuously
>   backlogged queues.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/elevator-fq.c |  127 +++++++++++++++++++++++++++++++++-------------------
>  block/elevator-fq.h |    3 +
>  2 files changed, 85 insertions(+), 45 deletions(-)
> 
> Index: linux14/block/elevator-fq.h
> ===================================================================
> --- linux14.orig/block/elevator-fq.h	2009-05-13 11:40:32.000000000 -0400
> +++ linux14/block/elevator-fq.h	2009-05-13 11:40:57.000000000 -0400
> @@ -250,6 +250,9 @@ struct io_group {
>  
>  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
>  	unsigned short iocg_id;
> +	dev_t	dev;
> +	/* How many times this group has been removed from active tree */
> +	unsigned long dequeue;
>  #endif
>  };
>  
> Index: linux14/block/elevator-fq.c
> ===================================================================
> --- linux14.orig/block/elevator-fq.c	2009-05-13 11:40:53.000000000 -0400
> +++ linux14/block/elevator-fq.c	2009-05-13 11:40:57.000000000 -0400
> @@ -12,6 +12,7 @@
>  #include "elevator-fq.h"
>  #include <linux/blktrace_api.h>
>  #include <linux/biotrack.h>
> +#include <linux/seq_file.h>
>  
>  /* Values taken from cfq */
>  const int elv_slice_sync = HZ / 10;
> @@ -758,6 +759,18 @@ int __bfq_deactivate_entity(struct io_en
>  	BUG_ON(sd->active_entity == entity);
>  	BUG_ON(sd->next_active == entity);
>  
> +#ifdef CONFIG_DEBUG_GROUP_IOSCHED
> +	{
> +		struct io_group *iog = io_entity_to_iog(entity);
> +		/*
> +		 * Keep track of how many times a group has been removed
> +		 * from active tree because it did not have any active
> +		 * backlogged ioq under it
> +		 */
> +		if (iog)
> +			iog->dequeue++;
> +	}
> +#endif
>  	return ret;
>  }
>  
> @@ -1126,90 +1139,103 @@ STORE_FUNCTION(weight, 0, WEIGHT_MAX);
>  STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
>  #undef STORE_FUNCTION
>  
> -/*
> - * traverse through all the io_groups associated with this cgroup and calculate
> - * the aggr disk time received by all the groups on respective disks.
> - */
> -static u64 calculate_aggr_disk_time(struct io_cgroup *iocg)
> +static int io_cgroup_disk_time_read(struct cgroup *cgroup,
> +				struct cftype *cftype, struct seq_file *m)
>  {
> +	struct io_cgroup *iocg;
>  	struct io_group *iog;
>  	struct hlist_node *n;
> -	u64 disk_time = 0;
> +
> +	if (!cgroup_lock_live_group(cgroup))
> +		return -ENODEV;
> +
> +	iocg = cgroup_to_io_cgroup(cgroup);
>  
>  	rcu_read_lock();
> +	spin_lock_irq(&iocg->lock);
>  	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>  		/*
>  		 * There might be groups which are not functional and
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
> -		if (rcu_dereference(iog->key))
> -			disk_time += iog->entity.total_service;
> +		if (rcu_dereference(iog->key)) {
> +			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +					MINOR(iog->dev),
> +					iog->entity.total_service);

  Hi Vivek,

  I think it's easier for users if device name is also shown here.

> +		}
>  	}
> +	spin_unlock_irq(&iocg->lock);
>  	rcu_read_unlock();
>  
> -	return disk_time;
> +	cgroup_unlock();
> +
> +	return 0;
>  }
>  

-- 
Regards
Gui Jianfeng
