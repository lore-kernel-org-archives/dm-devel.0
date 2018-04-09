From: Mike Snitzer <snitzer@redhat.com>
Subject: limits->max_sectors is getting set to 0,
 why/where? [was: Re: dm: kernel oops by divide error on v4.16+]
Date: Mon, 9 Apr 2018 11:51:20 -0400
Message-ID: <20180409155120.GA10990@redhat.com>
References: <20180408040005.GA19128@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180408040005.GA19128@ming.t460p>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Apr 08 2018 at 12:00am -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> Hi,
> 
> The following kernel oops(divide error) is triggered when running
> xfstest(generic/347) on ext4.
> 
> [  442.632954] run fstests generic/347 at 2018-04-07 18:06:44
> [  443.839480] divide error: 0000 [#1] PREEMPT SMP PTI
> [  443.840201] Dumping ftrace buffer:
> [  443.840692]    (ftrace buffer empty)
> [  443.841195] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio xfs libcrc32c dm_flakey isofs iTCO_wdt iTCO_vendor_support lpc_ich i2c_i801 i2c_core mfd_core ip_tables sr_mod cdrom sd_mod usb_storage ahci libahci libata nvme crc32c_intel nvme_core virtio_scsi qemu_fw_cfg dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_debug]
> [  443.845756] CPU: 1 PID: 29607 Comm: dmsetup Not tainted 4.16.0_f605ba97fb80_master+ #1
> [  443.846968] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-2.fc27 04/01/2014
> [  443.848147] RIP: 0010:pool_io_hints+0x77/0x153 [dm_thin_pool]
> [  443.848949] RSP: 0018:ffffc90001407af0 EFLAGS: 00010246
> [  443.849679] RAX: 0000000000000400 RBX: ffffc90001407b48 RCX: 0000000000000000
> [  443.850969] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [  443.852097] RBP: ffff88006ce028a0 R08: 00000000ffffffff R09: 0000000000000001
> [  443.853099] R10: ffffc90001407b20 R11: ffffea0001cfad60 R12: ffff88006de62000
> [  443.854404] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  443.856129] FS:  00007fb30462d840(0000) GS:ffff88007bc80000(0000) knlGS:0000000000000000
> [  443.857741] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  443.858576] CR2: 00007efc82a10440 CR3: 000000007e700006 CR4: 00000000007606e0
> [  443.859583] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  443.860587] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  443.861595] PKRU: 55555554
> [  443.861978] Call Trace:
> [  443.862344]  dm_calculate_queue_limits+0xb5/0x262 [dm_mod]
> [  443.863128]  dm_setup_md_queue+0xe2/0x131 [dm_mod]
> [  443.863819]  table_load+0x15e/0x2a7 [dm_mod]
> [  443.864425]  ? table_clear+0xc1/0xc1 [dm_mod]
> [  443.865079]  ctl_ioctl+0x295/0x374 [dm_mod]
> [  443.865679]  dm_ctl_ioctl+0xa/0xd [dm_mod]
> [  443.866262]  vfs_ioctl+0x1e/0x2b
> [  443.866721]  do_vfs_ioctl+0x515/0x53d
> [  443.867242]  ? ksys_semctl+0xb9/0x126
> [  443.867761]  ? __fput+0x17a/0x18d
> [  443.868236]  ksys_ioctl+0x3e/0x5d
> [  443.868707]  SyS_ioctl+0xa/0xd
> [  443.869144]  do_syscall_64+0x9d/0x15e
> [  443.869669]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  443.870381] RIP: 0033:0x7fb303ee8dc7
> [  443.870886] RSP: 002b:00007ffdc3c81478 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  443.871937] RAX: ffffffffffffffda RBX: 00007fb3041cbec0 RCX: 00007fb303ee8dc7
> [  443.872925] RDX: 0000563591b81c30 RSI: 00000000c138fd09 RDI: 0000000000000003
> [  443.873912] RBP: 0000000000000000 R08: 00007fb3042071c8 R09: 00007ffdc3c812e0
> [  443.874900] R10: 00007fb304206683 R11: 0000000000000246 R12: 0000000000000000
> [  443.875901] R13: 0000563591b81c60 R14: 0000563591b81c30 R15: 0000563591b81a80
> [  443.876905] Code: 72 41 eb 33 8d 41 ff 85 c8 75 03 89 43 24 8b 43 24 44 89 c1 48 0f bd c8 4c 89 c8 48 d3 e0 89 43 24 8b 73 24 41 8b 44 24 38 31 d2 <48> f7 f6 48 89 f1 85 d2 75 cf eb bf 31 d2 89 f8 48 f7 f1 48 85
> [  443.879519] RIP: pool_io_hints+0x77/0x153 [dm_thin_pool] RSP: ffffc90001407af0
> [  443.880549] ---[ end trace 56e7f9b41e671f53 ]---

I was able to reproduce (in my case RIP was pool_io_hints+0x45)

Which on my kernel, is:

crash> dis -l pool_io_hints+0x45
/root/snitm/git/linux/drivers/md/dm-thin.c: 2748
0xffffffffc0765165 <pool_io_hints+69>:  div    %rdi

Which is drivers/md/dm-thin.c:is_factor()'s return
!sector_div(block_size, n);

SO looking at pool_io_hints() it would seem limits->max_sectors is 0 for
this xfstests device... why would that be!?

Clearly pool_io_hints() could stand to be more defensive with a
!limits->max_sectors negative check but is it ever really valid for
max_sectors to be 0?

Pretty sure the ultimate bug is outside DM (but not seeing an obvious
place where block core would set max_sectors to 0, all blk-settings.c
uses min_not_zero(), etc).

Mike
