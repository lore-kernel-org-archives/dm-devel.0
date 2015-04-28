From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Kernel v4.1-rc1 + MQ dm-multipath + MQ SRP oops
Date: Tue, 28 Apr 2015 17:54:57 -0400
Message-ID: <20150428215456.GA18306@redhat.com>
References: <553F7474.70905@sandisk.com>
 <20150428135258.GA16267@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150428135258.GA16267@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Tue, Apr 28 2015 at  9:52am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Apr 28 2015 at  7:52am -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > Hello,
> > 
> > Earlier today I started testing an SRP initiator patch series on top
> > of Linux kernel v4.1-rc1. Although that patch series works reliably
> > on top of kernel v4.0, a test during which I triggered
> > scsi_remove_host() + relogin (for p in
> > /sys/class/srp_remote_ports/*; do echo 1 >$p/delete & done; wait;
> > srp_daemon -oaec) triggered the following kernel oops:
> > 
> > device-mapper: multipath: Failing path 8:0.
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
> > IP: [<ffffffffa045f8e9>] free_rq_clone+0x29/0xb0 [dm_mod]
> ...
>  
> > In case anyone wants to see the translation of the crash address:
> > 
> > (gdb) list *(free_rq_clone+0x29)
> > 0x919 is in free_rq_clone (drivers/md/dm.c:1092).
> > 1087            struct dm_rq_target_io *tio = clone->end_io_data;
> > 1088            struct mapped_device *md = tio->md;
> > 1089
> > 1090            blk_rq_unprep_clone(clone);
> > 1091
> > 1092            if (clone->q->mq_ops)
> > 1093                    tio->ti->type->release_clone_rq(clone);
> > 1094            else if (!md->queue->mq_ops)
> > 1095                    /* request_fn queue stacked on request_fn
> > queue(s) */
> > 1096                    free_clone_request(md, clone);
> 
> I saw a crash like this yesterday with 4.1-rc1 (definitely due to
> clone->q being NULL) but I didn't get a full backtrace over serial
> console so I cannot be sure it is exactly like yours.
> 
> In my case I was using hch's lio-utils based test setup that he
> documented here:
> https://www.redhat.com/archives/dm-devel/2015-April/msg00138.html
> 
> But I got the crash the first time I ran this script:
> multipathd -F
> tcm_loop --unload
> tcm_node --freedev iblock_0/array

Turns out that after running hch's script, with multipathd having setup
an mpath device ontop of tcm_loop, if I just do:

tcm_loop --unload

(tcm_loop appears to allow me to remove the devices out from underneath dm-multipath)

I get:

[  463.168175] sd 10:0:1:0: alua: Detached
[  463.172808] sd 10:0:1:0: [sdk] Synchronizing SCSI cache
[  463.211388] device-mapper: multipath: Failing path 8:144.
[  463.211494] sd 9:0:0:0: alua: Detached
[  463.211621] sd 9:0:0:0: [sdj] Synchronizing SCSI cache
[  463.227362] blk_update_request: I/O error, dev dm-13, sector 32
[  463.234238] BUG: unable to handle kernel NULL pointer dereference at 00000000000000d8
[  463.242990] IP: [<ffffffffa0000bd7>] free_rq_clone+0x17/0x90 [dm_mod]
[  463.250188] PGD 0
[  463.252437] Oops: 0000 [#1] SMP
[  463.256051] Modules linked in: tcm_loop dm_service_time dm_multipath target_core_iblock target_core_mod sg iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi core
temp kvm_intel kvm ixgbe igb crct10dif_pclmul crc32_pclmul crc32c_intel mdio ptp ghash_clmulni_intel pps_core aesni_intel dca ipmi_si iTCO_wdt glue_helper lrw gf128mul
 shpchp ablk_helper ipmi_msghandler cryptd iTCO_vendor_support lpc_ich mfd_core i7core_edac pcspkr edac_core i2c_i801 acpi_power_meter acpi_cpufreq xfs libcrc32c sr_mo
d cdrom sd_mod mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ata_generic ttm pata_acpi ata_piix drm libata iomemory_vsl(POE) megaraid_sas i2c_c
ore skd dm_mirror dm_region_hash dm_log dm_mod [last unloaded: tcm_loop]
[  463.328610] CPU: 3 PID: 29 Comm: ksoftirqd/3 Tainted: P        W IOE   4.1.0-rc1.snitm+ #55
[  463.337923] Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
[  463.352566] task: ffff880330c60000 ti: ffff880330c5c000 task.ti: ffff880330c5c000
[  463.360911] RIP: 0010:[<ffffffffa0000bd7>]  [<ffffffffa0000bd7>] free_rq_clone+0x17/0x90 [dm_mod]
[  463.370817] RSP: 0018:ffff880330c5fd58  EFLAGS: 00010297
[  463.376740] RAX: ffff8803301f0000 RBX: ffff8803301f0000 RCX: dead000000200200
[  463.384698] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880310bb8000
[  463.392654] RBP: ffff880330c5fd68 R08: ffffffffa04cf970 R09: ffff880321bf4d80
[  463.400610] R10: 0000000000000d71 R11: 000000000000bc00 R12: ffff880310bb8000
[  463.408568] R13: ffff88032aa1db50 R14: ffff88032bcae800 R15: 0000000000000000
[  463.416524] FS:  0000000000000000(0000) GS:ffff8803332c0000(0000) knlGS:0000000000000000
[  463.425548] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  463.431955] CR2: 00000000000000d8 CR3: 000000000198a000 CR4: 00000000000007e0
[  463.439910] Stack:
[  463.442150]  00000000fffffffb ffff880310bb8000 ffff880330c5fda8 ffffffffa0001837
[  463.450434]  ffff8803332d7540 ffff88032aa1dbc8 ffff88032aa1db50 ffff880330c5fdc0
[  463.458719]  0000000000000100 0000000000000000 ffff880330c5fdf8 ffffffff812f1c10
[  463.467001] Call Trace:
[  463.469730]  [<ffffffffa0001837>] dm_softirq_done+0x137/0x250 [dm_mod]
[  463.477010]  [<ffffffff812f1c10>] blk_done_softirq+0x90/0xc0
[  463.483321]  [<ffffffff81080264>] __do_softirq+0xf4/0x2d0
[  463.489340]  [<ffffffff81080469>] run_ksoftirqd+0x29/0x50
[  463.495360]  [<ffffffff8109eddf>] smpboot_thread_fn+0x12f/0x180
[  463.501963]  [<ffffffff8109ecb0>] ? sort_range+0x30/0x30
[  463.507886]  [<ffffffff8109b448>] kthread+0xd8/0xf0
[  463.513323]  [<ffffffff8109b370>] ? kthread_create_on_node+0x1b0/0x1b0
[  463.520604]  [<ffffffff81683322>] ret_from_fork+0x42/0x70
[  463.526624]  [<ffffffff8109b370>] ? kthread_create_on_node+0x1b0/0x1b0
[  463.533921] Code: a4 62 67 e1 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 54 53 48 8b 57 30 48 8b 9f 60 01 00 00 <48> 83 ba d8 00
00 00 00 4c 8b 23 74 2c 48 8b 53 08 48 8b 52 08
[  463.555555] RIP  [<ffffffffa0000bd7>] free_rq_clone+0x17/0x90 [dm_mod]
[  463.562846]  RSP <ffff880330c5fd58>
[  463.566733] CR2: 00000000000000d8
[  463.570426] ---[ end trace 4f71f94089df7bda ]---
[  465.155661] INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.541 msecs
[  469.833245] Kernel panic - not syncing: Fatal exception in interrupt
[  469.833257] ------------[ cut here ]------------

> Rough first experience with LIO ;)  So I just chalked it up to tcm_loop
> or something not being careful about device lifetime.

Think this is an issue where the cloned request doesn't have a reference
on the underlying device (with above I'm testing with old request_fn
_not_ blk-mq dm-mpath).

Christoph, if I do use blk-mq dm-multpath with:
echo Y > /sys/module/dm_mod/parameters/use_blk_mq

Then run your script; I'm able to reproduce the failure you reported as
soon as I run:

# tcm_loop --unload
sas_target_naa: naa.6001405ac0a3d2eb
sas_target_tpgt: tpgt_1
sas_target_lun: lun_0
Succesfully deleted local virtual SCSI Logical Unit from SAS Target Port
Successfully deleted virtual SCSI I_T Nexus between TCM and Linux/SCSI HBA
Successfully removed NAA based SAS Target Address: /sys/kernel/config/target/loopback/naa.6001405ac0a3d2eb//sys/kernel/config/target/loopback/naa.6001405ac0a3d2eb/tpgt_1
sas_target_naa: naa.6001405b0a839d09
sas_target_tpgt: tpgt_0
sas_target_lun: lun_0

Falls over much like you saw but then ultimately crashes with the same
as above:

[  232.179074] WARNING: CPU: 9 PID: 2836 at lib/list_debug.c:36 __list_add+0x92/0xc0()
...
[  232.443124] kobject (ffff880035625fd0): tried to init an initialized object, something is seriously wrong.
...
[  232.621489] sysfs: cannot create duplicate filename '/devices/virtual/block/dm-13/mq'
...
[  234.514036] NULL pointer dereference at 00000000000000d8
[  234.520168] IP: [<ffffffffa0000bd7>] free_rq_clone+0x17/0x90 [dm_mod]
[  234.527363] PGD 0
[  234.529610] Oops: 0000 [#1] SMP

Basically, the dm-mq error path needs proper testing (multipathd's
reloading of the associated blk-mq request-based DM table is causing
these list_add and duplicate object problems; will hopefully be easy
enough to fix).

But as for the NULL pointer crash, in both cases the underlying paths
are being ripped out from under dm-multipath.  That just should not be
possible while IO is still in-flight/completing.
