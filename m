From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [PATCH] dm: use noio when sending kobject event
Date: Wed, 08 Jul 2020 14:26:45 -0400
Message-ID: <873661g8wq.fsf@collabora.com>
References: <alpine.LRH.2.02.2007081222500.4103@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2007081222500.4103@file01.intranet.prod.int.rdu2.redhat.com>
	(Mikulas Patocka's message of "Wed, 8 Jul 2020 12:25:20 -0400 (EDT)")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tahsin Erdogan <tahsin@google.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

Mikulas Patocka <mpatocka@redhat.com> writes:

> kobject_uevent may allocate memory and it may be called while there are dm
> devices suspended. The allocation may recurse into a suspended device,
> causing a deadlock. We must set the noio flag when sending a uevent.

If I understand it correctly, considering the deadlock you shared, this
doesn't solve the entire issue. For instance, kobject_uevent_env on the
GFP_NOIO thread waits on uevent_sock_mutex, and another thread with
GFP_IO holding the mutex might have triggered the shrinker from inside
kobject_uevent_net_broadcast.  I believe 7e7cd796f277 ("scsi: iscsi: Fix
deadlock on recovery path during GFP_IO reclaim") solved the one you
shared and other similar cases for iSCSI in a different way.

I know this is similar to the log I shared on an earlier patch. Are you
able to reproduce the deadlock with the above patch applied?

That said, I think this patch is an improvement as we shouldn't be using
GFP_IO in this path to begin with, so please add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>


> This is the observed deadlock:
>
> iSCSI-write
>      holding: rx_queue_mutex
>      waiting: uevent_sock_mutex
>
>      kobject_uevent_env+0x1bd/0x419
>      kobject_uevent+0xb/0xd
>      device_add+0x48a/0x678
>      scsi_add_host_with_dma+0xc5/0x22d
>      iscsi_host_add+0x53/0x55
>      iscsi_sw_tcp_session_create+0xa6/0x129
>      iscsi_if_rx+0x100/0x1247
>      netlink_unicast+0x213/0x4f0
>      netlink_sendmsg+0x230/0x3c0
>
> iscsi_fail iscsi_conn_failure
>      waiting: rx_queue_mutex
>
>      schedule_preempt_disabled+0x325/0x734
>      __mutex_lock_slowpath+0x18b/0x230
>      mutex_lock+0x22/0x40
>      iscsi_conn_failure+0x42/0x149
>      worker_thread+0x24a/0xbc0
>
> EventManager_
>      holding: uevent_sock_mutex
>      waiting: dm_bufio_client->lock
>
>      dm_bufio_lock+0xe/0x10
>      shrink+0x34/0xf7
>      shrink_slab+0x177/0x5d0
>      do_try_to_free_pages+0x129/0x470
>      try_to_free_mem_cgroup_pages+0x14f/0x210
>      memcg_kmem_newpage_charge+0xa6d/0x13b0
>      __alloc_pages_nodemask+0x4a3/0x1a70
>      fallback_alloc+0x1b2/0x36c
>      __kmalloc_node_track_caller+0xb9/0x10d0
>      __alloc_skb+0x83/0x2f0
>      kobject_uevent_env+0x26b/0x419
>      dm_kobject_uevent+0x70/0x79
>      dev_suspend+0x1a9/0x1e7
>      ctl_ioctl+0x3e9/0x411
>      dm_ctl_ioctl+0x13/0x17
>      do_vfs_ioctl+0xb3/0x460
>      SyS_ioctl+0x5e/0x90
>
> MemcgReclaimerD
>      holding: dm_bufio_client->lock
>      waiting: stuck io to finish (needs iscsi_fail thread to progress)
>
>      schedule at ffffffffbd603618
>      io_schedule at ffffffffbd603ba4
>      do_io_schedule at ffffffffbdaf0d94
>      __wait_on_bit at ffffffffbd6008a6
>      out_of_line_wait_on_bit at ffffffffbd600960
>      wait_on_bit.constprop.10 at ffffffffbdaf0f17
>      __make_buffer_clean at ffffffffbdaf18ba
>      __cleanup_old_buffer at ffffffffbdaf192f
>      shrink at ffffffffbdaf19fd
>      do_shrink_slab at ffffffffbd6ec000
>      shrink_slab at ffffffffbd6ec24a
>      do_try_to_free_pages at ffffffffbd6eda09
>      try_to_free_mem_cgroup_pages at ffffffffbd6ede7e
>      mem_cgroup_resize_limit at ffffffffbd7024c0
>      mem_cgroup_write at ffffffffbd703149
>      cgroup_file_write at ffffffffbd6d9c6e
>      sys_write at ffffffffbd6662ea
>      system_call_fastpath at ffffffffbdbc34a2
>
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Khazhismel Kumykov <khazhy@google.com>
> Reported-by: Tahsin Erdogan <tahsin@google.com>
> Reported-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Cc: stable@vger.kernel.org
>
> ---
>  drivers/md/dm.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2020-06-29 14:50:22.000000000 +0200
> +++ linux-2.6/drivers/md/dm.c	2020-07-08 18:17:55.000000000 +0200
> @@ -12,6 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/sched/mm.h>
>  #include <linux/sched/signal.h>
>  #include <linux/blkpg.h>
>  #include <linux/bio.h>
> @@ -2926,17 +2927,25 @@ EXPORT_SYMBOL_GPL(dm_internal_resume_fas
>  int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
>  		       unsigned cookie)
>  {
> +	int r;
> +	unsigned noio_flag;
>  	char udev_cookie[DM_COOKIE_LENGTH];
>  	char *envp[] = { udev_cookie, NULL };
>  
> +	noio_flag = memalloc_noio_save();
> +
>  	if (!cookie)
> -		return kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
> +		r = kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
>  	else {
>  		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
>  			 DM_COOKIE_ENV_VAR_NAME, cookie);
> -		return kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
> -					  action, envp);
> +		r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
> +				       action, envp);
>  	}
> +
> +	memalloc_noio_restore(noio_flag);
> +
> +	return r;
>  }
>  
>  uint32_t dm_next_uevent_seq(struct mapped_device *md)
>

-- 
Gabriel Krisman Bertazi
