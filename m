From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH -stable] block: destroy bdi before blockdev is unregistered.
Date: Tue, 28 Apr 2015 12:41:18 -0400
Message-ID: <CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
References: <20150414171537.GH25394@azat> <20150423160551.45345f96@notabene.brown>
 <20150427141222.5dac22f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150427141222.5dac22f1@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@fb.com>, Azat Khuzhin <a3at.mail@gmail.com>, Christoph Hellwig <hch@lst.de>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 27, 2015 at 12:12 AM, NeilBrown <neilb@suse.de> wrote:
>
> Because of the peculiar way that md devices are created (automatically
> when the device node is opened), a new device can be created and
> registered immediately after the
>         blk_unregister_region(disk_devt(disk), disk->minors);
> call in del_gendisk().
>
> Therefore it is important that all visible artifacts of the previous
> device are removed before this call.  In particular, the 'bdi'.
>
> Since:
> commit c4db59d31e39ea067c32163ac961e9c80198fd37
> Author: Christoph Hellwig <hch@lst.de>
>     fs: don't reassign dirty inodes to default_backing_dev_info
>
> moved the
>    device_unregister(bdi->dev);
> call from bdi_unregister() to bdi_destroy() it has been quite easy to
> lose a race and have a new (e.g.) "md127" be created after the
> blk_unregister_region() call and before bdi_destroy() is ultimately
> called by the final 'put_disk', which must come after del_gendisk().
>
> The new device finds that the bdi name is already registered in sysfs
> and complains
>
>> [ 9627.630029] WARNING: CPU: 18 PID: 3330 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5a/0x70()
>> [ 9627.630032] sysfs: cannot create duplicate filename '/devices/virtual/bdi/9:127'
>
> We can fix this by moving the bdi_destroy() call out of
> blk_release_queue() (which can happen very late when a refcount
> reaches zero) and into blk_cleanup_queue() - which happens exactly when the md
> device driver calls it.
>
> Then it is only necessary for md to call blk_cleanup_queue() before
> del_gendisk().  As loop.c devices are also created on demand by
> opening the device node, we make the same change there.
>
> Fixes: c4db59d31e39ea067c32163ac961e9c80198fd37
> Reported-by: Azat Khuzhin <a3at.mail@gmail.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org (v4.0)
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> --
> Hi Jens,
>  if you could check this and forward on to Linus I'd really appreciate it.
>
> Thanks,
> NeilBrown
>
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index fd154b94447a..7871603f0a29 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -552,6 +552,8 @@ void blk_cleanup_queue(struct request_queue *q)
>                 q->queue_lock = &q->__queue_lock;
>         spin_unlock_irq(lock);
>
> +       bdi_destroy(&q->backing_dev_info);
> +
>         /* @q is and will stay empty, shutdown and put */
>         blk_put_queue(q);
>  }
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index faaf36ade7eb..2b8fd302f677 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -522,8 +522,6 @@ static void blk_release_queue(struct kobject *kobj)
>
>         blk_trace_shutdown(q);
>
> -       bdi_destroy(&q->backing_dev_info);
> -
>         ida_simple_remove(&blk_queue_ida, q->id);
>         call_rcu(&q->rcu_head, blk_free_queue_rcu);
>  }
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index ae3fcb4199e9..d7173cb1ea76 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1620,8 +1620,8 @@ out:
>
>  static void loop_remove(struct loop_device *lo)
>  {
> -       del_gendisk(lo->lo_disk);
>         blk_cleanup_queue(lo->lo_queue);
> +       del_gendisk(lo->lo_disk);
>         blk_mq_free_tag_set(&lo->tag_set);
>         put_disk(lo->lo_disk);
>         kfree(lo);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d4f31e195e26..593a02476c78 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4818,12 +4818,12 @@ static void md_free(struct kobject *ko)
>         if (mddev->sysfs_state)
>                 sysfs_put(mddev->sysfs_state);
>
> +       if (mddev->queue)
> +               blk_cleanup_queue(mddev->queue);
>         if (mddev->gendisk) {
>                 del_gendisk(mddev->gendisk);
>                 put_disk(mddev->gendisk);
>         }
> -       if (mddev->queue)
> -               blk_cleanup_queue(mddev->queue);
>
>         kfree(mddev);
>  }

I've taken this patch into consideration relative to DM, please see:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=5dac86fb79697e93297edb6a316b429236d00137

Point is in my private snitzer/wip branch DM now calls
blk_cleanup_queue() before del_gendisk().

With your patch:
1) blk_cleanup_queue -> bdi_destroy -> bdi->dev = NULL;
2) del_gendisk -> bdi_unregister -> WARN_ON_ONCE(!bdi->dev)

So, in testing with DM I'm hitting bdi_unregister's WARN_ON(), are you
seeing this WARN_ON?

[  385.134474] WARNING: CPU: 3 PID: 11231 at mm/backing-dev.c:372
bdi_unregister+0x36/0x40()
[  385.143593] Modules linked in: dm_service_time dm_multipath
target_core_iblock tcm_loop target_core_mod sg iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi core
temp kvm_intel kvm ixgbe igb crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel mdio aesni_intel ptp pps_core
glue_helper ipmi_si i7core_edac iTCO_wdt lrw
dca iTCO_vendor_support edac_core i2c_i801 pcspkr gf128mul
ipmi_msghandler acpi_power_meter shpchp lpc_ich ablk_helper cryptd
mfd_core acpi_cpufreq xfs libcrc32c sr_mo
d cdrom mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit
drm_kms_helper ata_generic ttm pata_acpi sd_mod ata_piix drm
iomemory_vsl(POE) libata megaraid_sas i2c_c
ore skd dm_mirror dm_region_hash dm_log dm_mod
[  385.213736] CPU: 3 PID: 11231 Comm: dmsetup Tainted: P          IOE
  4.1.0-rc1.snitm+ #55
[  385.222958] Hardware name: FUJITSU
PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1
     05/24/2011
[  385.237602]  0000000000000000 000000006cf7a5f2 ffff88031bfcfb68
ffffffff8167b7e6
[  385.245897]  0000000000000000 0000000000000000 ffff88031bfcfba8
ffffffff8107bd5a
[  385.254193]  0000000000000000 ffff88032c4b6c00 0000000000000000
0000000000000000
[  385.262488] Call Trace:
[  385.265218]  [<ffffffff8167b7e6>] dump_stack+0x45/0x57
[  385.270955]  [<ffffffff8107bd5a>] warn_slowpath_common+0x8a/0xc0
[  385.277660]  [<ffffffff8107be8a>] warn_slowpath_null+0x1a/0x20
[  385.284171]  [<ffffffff8119e216>] bdi_unregister+0x36/0x40
[  385.290295]  [<ffffffff812fb8c1>] del_gendisk+0x131/0x2b0
[  385.296326]  [<ffffffffa0000eba>] cleanup_mapped_device+0xda/0x130 [dm_mod]
[  385.304101]  [<ffffffffa000283b>] __dm_destroy+0x19b/0x260 [dm_mod]
[  385.311099]  [<ffffffffa00040c3>] dm_destroy+0x13/0x20 [dm_mod]
[  385.317709]  [<ffffffffa0009d0e>] dev_remove+0x11e/0x180 [dm_mod]
[  385.324516]  [<ffffffffa0009bf0>] ? dev_suspend+0x250/0x250 [dm_mod]
[  385.331614]  [<ffffffffa000a3e5>] ctl_ioctl+0x255/0x500 [dm_mod]
[  385.338319]  [<ffffffff8128c8d8>] ? SYSC_semtimedop+0x298/0xea0
[  385.344931]  [<ffffffffa000a6a3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
[  385.351733]  [<ffffffff8120d038>] do_vfs_ioctl+0x2f8/0x4f0
[  385.357857]  [<ffffffff811207e4>] ? __audit_syscall_entry+0xb4/0x110
[  385.364950]  [<ffffffff8102367c>] ? do_audit_syscall_entry+0x6c/0x70
[  385.372041]  [<ffffffff8120d2b1>] SyS_ioctl+0x81/0xa0
[  385.377679]  [<ffffffff81025046>] ? syscall_trace_leave+0xc6/0x120
[  385.384578]  [<ffffffff81682f2e>] system_call_fastpath+0x12/0x71
[  385.391282] ---[ end trace af60d8ac7157d319 ]---
