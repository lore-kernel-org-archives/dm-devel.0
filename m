From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] iscsi: do not wait for IOs in dm shrinker
Date: Mon, 23 Mar 2020 11:58:49 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2003231148560.30812@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200304163953.578311-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200304163953.578311-1-krisman@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Tahsin Erdogan <tahsin@google.com>, snitzer@redhat.com, Khazhismel Kumykov <khazhy@google.com>, dm-devel@redhat.com, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

Hi

There are other cases where the kernel could issue or wait on I/O in a 
shrinker (for example in inode shrinker). Instead of fixing all these 
cases, you should fix the process giscsid to not issue an I/O when it is 
not safe.

For example, the lvm and dmeventd processes lock themselves in memory 
using mlock, to make sure that they won't generate I/Os when some device 
mapper targets are suspended - so you should use a similar thing in iscsi.

Another possibility is to set the flag PF_MEMALLOC_NOIO for the giscsid 
process - that will imply that all allocations done by this process have 
the GFP_NOIO flag set.

If still think that no shrinkers should issue I/O anytime, you should 
change the shrinker API (i.e. don't pass the gfp mask to shrinkers) and 
get this patch through the memory management maintainers.

Mikulas


On Wed, 4 Mar 2020, Gabriel Krisman Bertazi wrote:

> From: Tahsin Erdogan <tahsin@google.com>
> 
> If something goes wrong with an iscsi session, the problem is reported
> to giscsid via a netlink message. Then, giscsid tries to add a new device
> and destroy the old one. During old device destruction, the pending ios
> get completed with an error. Without destroying the device the io
> operations are stuck forever.
> 
> If dm shrinker is invoked with __GFP_IO, shrinker gets blocked waiting for
> the pending ios to complete. So, if the giscsid repair path ends up
> doing a memory allocation with __GFP_IO enabled, it could end up in a
> deadlock because the iscsi io cannot be completed until giscsid can do its
> job and giscsid cannot do its job until the io completes.
> 
> Even worse, the deadlock can also occur even if giscsid avoids __GFP_IO
> in all paths. For instance, if giscsid tries to grab a mutex held by
> another thread and that thread invokes the shrinker we again may enter a
> deadlock. Here is a scenario stitched from multiple bugs that
> demonstrates how the deadlock can occur:
> 
> iSCSI-write
>         holding: rx_queue_mutex
>         waiting: uevent_sock_mutex
> 
>         kobject_uevent_env+0x1bd/0x419
>         kobject_uevent+0xb/0xd
>         device_add+0x48a/0x678
>         scsi_add_host_with_dma+0xc5/0x22d
>         iscsi_host_add+0x53/0x55
>         iscsi_sw_tcp_session_create+0xa6/0x129
>         iscsi_if_rx+0x100/0x1247
>         netlink_unicast+0x213/0x4f0
>         netlink_sendmsg+0x230/0x3c0
> 
> iscsi_fail iscsi_conn_failure
>         waiting: rx_queue_mutex
> 
>         schedule_preempt_disabled+0x325/0x734
>         __mutex_lock_slowpath+0x18b/0x230
>         mutex_lock+0x22/0x40
>         iscsi_conn_failure+0x42/0x149
>         worker_thread+0x24a/0xbc0
> 
> EventManager_
>         holding: uevent_sock_mutex
>         waiting: dm_bufio_client->lock
> 
>         dm_bufio_lock+0xe/0x10
>         shrink+0x34/0xf7
>         shrink_slab+0x177/0x5d0
>         do_try_to_free_pages+0x129/0x470
>         try_to_free_mem_cgroup_pages+0x14f/0x210
>         memcg_kmem_newpage_charge+0xa6d/0x13b0
>         __alloc_pages_nodemask+0x4a3/0x1a70
>         fallback_alloc+0x1b2/0x36c
>         __kmalloc_node_track_caller+0xb9/0x10d0
>         __alloc_skb+0x83/0x2f0
>         kobject_uevent_env+0x26b/0x419
>         dm_kobject_uevent+0x70/0x79
>         dev_suspend+0x1a9/0x1e7
>         ctl_ioctl+0x3e9/0x411
>         dm_ctl_ioctl+0x13/0x17
>         do_vfs_ioctl+0xb3/0x460
>         SyS_ioctl+0x5e/0x90
> 
> MemcgReclaimerD"
>         holding: dm_bufio_client->lock
>         waiting: stuck io to finish (needs iscsi_fail thread to progress)
> 
>         schedule at ffffffffbd603618
>         io_schedule at ffffffffbd603ba4
>         do_io_schedule at ffffffffbdaf0d94
>         __wait_on_bit at ffffffffbd6008a6
>         out_of_line_wait_on_bit at ffffffffbd600960
>         wait_on_bit.constprop.10 at ffffffffbdaf0f17
>         __make_buffer_clean at ffffffffbdaf18ba
>         __cleanup_old_buffer at ffffffffbdaf192f
>         shrink at ffffffffbdaf19fd
>         do_shrink_slab at ffffffffbd6ec000
>         shrink_slab at ffffffffbd6ec24a
>         do_try_to_free_pages at ffffffffbd6eda09
>         try_to_free_mem_cgroup_pages at ffffffffbd6ede7e
>         mem_cgroup_resize_limit at ffffffffbd7024c0
>         mem_cgroup_write at ffffffffbd703149
>         cgroup_file_write at ffffffffbd6d9c6e
>         sys_write at ffffffffbd6662ea
>         system_call_fastpath at ffffffffbdbc34a2
> 
> Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> ---
>  drivers/md/dm-bufio.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 2d519c223562..4c4f80e894b6 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -1516,18 +1516,16 @@ static void drop_buffers(struct dm_bufio_client *c)
>   * We may not be able to evict this buffer if IO pending or the client
>   * is still using it.  Caller is expected to know buffer is too old.
>   *
> - * And if GFP_NOFS is used, we must not do any I/O because we hold
> - * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
> - * rerouted to different bufio client.
> + * We must not do any I/O because we hold dm_bufio_clients_lock and we
> + * would risk deadlock if the I/O gets rerouted to different bufio
> + * client.
>   */
> -static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)
> +static bool __try_evict_buffer(struct dm_buffer *b)
>  {
> -	if (!(gfp & __GFP_FS)) {
> -		if (test_bit(B_READING, &b->state) ||
> -		    test_bit(B_WRITING, &b->state) ||
> -		    test_bit(B_DIRTY, &b->state))
> -			return false;
> -	}
> +	if (test_bit(B_READING, &b->state) ||
> +	    test_bit(B_WRITING, &b->state) ||
> +	    test_bit(B_DIRTY, &b->state))
> +		return false;
>  
>  	if (b->hold_count)
>  		return false;
> @@ -1549,8 +1547,7 @@ static unsigned long get_retain_buffers(struct dm_bufio_client *c)
>  	return retain_bytes;
>  }
>  
> -static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
> -			    gfp_t gfp_mask)
> +static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan)
>  {
>  	int l;
>  	struct dm_buffer *b, *tmp;
> @@ -1561,7 +1558,7 @@ static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
>  
>  	for (l = 0; l < LIST_SIZE; l++) {
>  		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
> -			if (__try_evict_buffer(b, gfp_mask))
> +			if (__try_evict_buffer(b))
>  				freed++;
>  			if (!--nr_to_scan || ((count - freed) <= retain_target))
>  				return freed;
> @@ -1578,12 +1575,10 @@ dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  	unsigned long freed;
>  
>  	c = container_of(shrink, struct dm_bufio_client, shrinker);
> -	if (sc->gfp_mask & __GFP_FS)
> -		dm_bufio_lock(c);
> -	else if (!dm_bufio_trylock(c))
> +	if (!dm_bufio_trylock(c))
>  		return SHRINK_STOP;
>  
> -	freed  = __scan(c, sc->nr_to_scan, sc->gfp_mask);
> +	freed  = __scan(c, sc->nr_to_scan);
>  	dm_bufio_unlock(c);
>  	return freed;
>  }
> @@ -1811,7 +1806,7 @@ static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
>  		if (!older_than(b, age_hz))
>  			break;
>  
> -		if (__try_evict_buffer(b, 0))
> +		if (__try_evict_buffer(b))
>  			count--;
>  
>  		cond_resched();
> -- 
> 2.25.0
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
