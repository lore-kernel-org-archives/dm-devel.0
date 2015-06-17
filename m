From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: 3.12.y: srcu warning during free_dev() with dm-multipath
Date: Wed, 17 Jun 2015 18:26:57 +0200
Message-ID: <55819FD1.4010306@profitbricks.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
List-Id: dm-devel.ids

Hi dm developers,

we hit the srcu warning in cleanup_srcu_struct() when removing
dm-multipath devices. We run v3.12.40 but there is no change compared to
v3.12.44 in drivers/md/dm.c or kernel/srcu.c.

Would the following upstream commit fix this?

63a4f06 dm: fix add_disk() NULL pointer due to race with free_dev()

Thanks,
Sebastian


===============
Details:

> WARNING: CPU: 36 PID: 3772 at kernel/srcu.c:285 cleanup_srcu_struct+0x8d/0x90()
> CPU: 36 PID: 3772 Comm: multipathd Tainted: G           O 3.12.40-2 #1
> 0000000000000009 ffff882803213bc8 ffffffff817138b0 0000000000000007
> 0000000000000000 ffff882803213c08 ffffffff81045fb7 ffff8827035a0870
> 0000000000000001 ffffffff81cbf760 ffff8827fea77808 ffff8827fea77800
> Call Trace:
>  [<ffffffff817138b0>] dump_stack+0x46/0x58
>  [<ffffffff81045fb7>] warn_slowpath_common+0x87/0xb0
>  [<ffffffff81045ff5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff8106bd5d>] cleanup_srcu_struct+0x8d/0x90
>  [<ffffffff81594986>] __dm_destroy+0x176/0x240
>  [<ffffffff8159550e>] dm_destroy+0xe/0x10
>  [<ffffffff8159ae9f>] dev_remove+0x9f/0x100
>  [<ffffffff8159ae00>] ? __hash_remove+0xd0/0xd0
>  [<ffffffff8159b2f6>] ctl_ioctl+0x246/0x4d0
>  [<ffffffff81032c19>] ? physflat_send_IPI_mask+0x9/0x10
>  [<ffffffff8159b58e>] dm_ctl_ioctl+0xe/0x20
>  [<ffffffff8116d587>] do_vfs_ioctl+0x87/0x510
>  [<ffffffff8105478a>] ? recalc_sigpending+0x1a/0x60
>  [<ffffffff81055362>] ? __set_task_blocked+0x32/0x80
>  [<ffffffff8116daa1>] SyS_ioctl+0x91/0xb0
>  [<ffffffff81721a02>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8c8c7b2a24a51f9c ]---

> (gdb) list *__dm_destroy+0x172
> 0xffffffff8159fc72 is in __dm_destroy (drivers/md/dm.c:2140).
> 2135            mempool_destroy(md->io_pool);
> 2136        if (md->bs)
> 2137            bioset_free(md->bs);
> 2138        blk_integrity_unregister(md->disk);
> 2139        del_gendisk(md->disk);
> 2140        cleanup_srcu_struct(&md->io_barrier);
> 2141        free_minor(minor);
> 2142    
> 2143        spin_lock(&_minor_lock);
> 2144        md->disk->private_data = NULL;

This is located in the function free_dev() in fact.

> (gdb) list *cleanup_srcu_struct+0x89
> 0xffffffff8106f2c9 is in cleanup_srcu_struct (kernel/srcu.c:285).
> 280     * Must invoke this after you are finished using a given srcu_struct that
> 281     * was initialized via init_srcu_struct(), else you leak memory.
> 282     */
> 283    void cleanup_srcu_struct(struct srcu_struct *sp)
> 284    {
> 285        if (WARN_ON(srcu_readers_active(sp)))
> 286            return; /* Leakage unless caller handles error. */
> 287        free_percpu(sp->per_cpu_ref);
> 288        sp->per_cpu_ref = NULL;
> 289    }
