From: Eric Wheeler <linux-block@lists.ewheeler.net>
Subject: Re: WARNING: CPU: 0 PID: 29149 at
 kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
Date: Sun, 2 Jun 2019 00:40:51 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1906020035270.27699@mx.ewheeler.net>
References: <alpine.LRH.2.11.1905112314120.31149@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1905112314120.31149@mx.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

[+cc dm-devel 
  Please see below, this only seems to happen after a call 
  to cleanup_mapped_device() ]

On Sat, 11 May 2019, Eric Wheeler wrote:

> Hello all,
> 
> I'm getting backtraces like below.  GKH added a WARN_ON(!wq_online) to 
> catch uninitialized workqueues, here:
>   https://lkml.org/lkml/2019/4/30/608
> 
> Following the trace, it looks like blk_sync_queue() is calling 
> cancel_delayed_work_sync(&q->requeue_work), but the eventual call to 
> __cancel_work_timer() already checks wq_online before calling  
> __flush_work(work, true) --- so how is this happening?  
> 
> Could there be a race clearing wq_online that passes the `if (wq_online)` 
> check and then wq_online is cleared just before __flush_work checks the 
> WARN_ON? I'm guessing something else is at play here, that would be a 
> pretty tight race.
> 
> Any ideas on how this might come up?  This is running Linux 4.19.39
> 
> 0xffffffff810cb55f is in __flush_work (kernel/workqueue.c:2908).
> 2903	
> 2904	static bool __flush_work(struct work_struct *work, bool from_cancel)
> 2905	{
> 2906		struct wq_barrier barr;
> 2907	
> 2908		if (WARN_ON(!wq_online)) <<<<<<<<<<<<<<<<<<<<<<<<<
> 2909			return false;
> 2910	
> 2911		if (!from_cancel) {
> 2912			lock_map_acquire(&work->lockdep_map);
> 
> 
> [539029.072663] WARNING: CPU: 7 PID: 29959 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> [539029.073574] Modules linked in: dm_crypt btrfs xor zstd_decompress zstd_compress xxhash raid6_pq dm_snapshot drbd lru_cache xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_n
> at nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c ipt_REJECT nf_reject_ipv4 ebtable_filter ebtables ip6table_filter ip6_tables binfmt_misc bcache crc64 xt_comment iptable_filter netconsole bridge 802
> 1q garp stp mrp llc lz4 lz4_compress zram sunrpc x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass iTCO_wdt iTCO_vendor_support crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sg video pcspkr pcc_cpufreq lpc_ich mf
> d_core i2c_i801 ipmi_si ipmi_devintf ipmi_msghandler ip_tables ext4 mbcache jbd2 mgag200 i2c_algo_bit
> [539029.079749]  drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel i2c_core ixgbe ahci libahci mdio libata dca e1000e arcmsr dm_mirror dm_region_hash dm_log dm_mod
> [539029.081570] CPU: 7 PID: 29959 Comm: lvchange Tainted: G        W         4.19.39+ #12
> [539029.082472] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.2 02/20/2015
> [539029.083373] RIP: 0010:__flush_work.isra.29+0x19f/0x1b0
> [539029.084275] Code: 89 fb 66 0f 1f 44 00 00 31 c0 eb a9 48 89 df c6 07 00 0f 1f 40 00 fb 66 0f 1f 44 00 00 31 c0 eb 94 e8 85 21 fe ff 0f 0b eb 8b <0f> 0b 31 c0 eb 85 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
> [539029.086134] RSP: 0018:ffffc90025bb7b48 EFLAGS: 00010246
> [539029.087073] RAX: 0000000000000000 RBX: ffff8887cf1ce550 RCX: 0000000000000000
> [539029.088026] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8887cf1ce550
> [539029.088964] RBP: ffff8887cf1ce550 R08: 0000000000000000 R09: ffffc90025bb7be0
> [539029.089894] R10: 0000000000000001 R11: 0000000000000018 R12: 0000000000000000
> [539029.090817] R13: ffffc90025bb7be0 R14: ffff888135d70000 R15: ffffffffa0009e50
> [539029.091846] FS:  00007fb5b49b5880(0000) GS:ffff88880fbc0000(0000) knlGS:0000000000000000
> [539029.092792] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [539029.093731] CR2: 00007f23e1130000 CR3: 000000079eb30002 CR4: 00000000001626e0
> [539029.094681] Call Trace:
> [539029.095627]  ? complete+0x3b/0x50
> [539029.096573]  ? flush_workqueue_prep_pwqs+0xf4/0x120
> [539029.097533]  __cancel_work_timer+0x103/0x190
> [539029.098485]  ? try_to_del_timer_sync+0x4d/0x80
> [539029.099435]  blk_sync_queue+0x22/0x80
> [539029.100382]  blk_cleanup_queue+0xdc/0x160
> [539029.101349]  cleanup_mapped_device+0xb7/0xf0 [dm_mod]
> [539029.102326]  free_dev+0x38/0xd0 [dm_mod]
> [539029.103290]  dev_remove+0xd3/0x110 [dm_mod]
> [539029.104266]  ctl_ioctl+0x1d3/0x500 [dm_mod]
> [539029.105240]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
> [539029.106202]  do_vfs_ioctl+0xa9/0x620
> [539029.107156]  ksys_ioctl+0x60/0x90
> [539029.108104]  __x64_sys_ioctl+0x16/0x20
> [539029.109041]  do_syscall_64+0x5b/0x180
> [539029.109952]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [539029.110852] RIP: 0033:0x7fb5b35cb5d7
> [539029.111740] Code: 44 00 00 48 8b 05 b9 08 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 89 08 2d 00 f7 d8 64 89 01 48
> [539029.113595] RSP: 002b:00007ffe7b740c98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [539029.114539] RAX: ffffffffffffffda RBX: 0000560c6bae7520 RCX: 00007fb5b35cb5d7
> [539029.115490] RDX: 0000560c6d8f5060 RSI: 00000000c138fd04 RDI: 0000000000000005
> [539029.116439] RBP: 00007fb5b3d3c493 R08: 0000000000000000 R09: 00007fb5b3d3c5f0
> [539029.117381] R10: 0000000000000000 R11: 0000000000000246 R12: 0000560c6d8f5090
> [539029.118297] R13: 0000560c6d8f5060 R14: 0000560c6d8f5110 R15: 0000560c6d8f9c90
> [539029.119234] ---[ end trace 535c728d2066f9d5 ]---
> 
> 
> We got several of these per minute last night, but I've not seen any today:
> 
> 
> May 10 23:30:34 hv2 kernel: WARNING: CPU: 2 PID: 5913 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:30:55 hv2 kernel: WARNING: CPU: 2 PID: 5994 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:31:18 hv2 kernel: WARNING: CPU: 3 PID: 7281 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:31:42 hv2 kernel: WARNING: CPU: 7 PID: 9615 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:32:06 hv2 kernel: WARNING: CPU: 6 PID: 10586 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:32:58 hv2 kernel: WARNING: CPU: 2 PID: 13109 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:33:22 hv2 kernel: WARNING: CPU: 2 PID: 14611 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:33:55 hv2 kernel: WARNING: CPU: 4 PID: 16321 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:34:09 hv2 kernel: WARNING: CPU: 3 PID: 17152 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:34:21 hv2 kernel: WARNING: CPU: 3 PID: 17286 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:34:42 hv2 kernel: WARNING: CPU: 0 PID: 19369 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:35:01 hv2 kernel: WARNING: CPU: 2 PID: 20207 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:35:29 hv2 kernel: WARNING: CPU: 3 PID: 20953 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:35:55 hv2 kernel: WARNING: CPU: 2 PID: 23076 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:36:08 hv2 kernel: WARNING: CPU: 4 PID: 23882 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:36:31 hv2 kernel: WARNING: CPU: 0 PID: 24632 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:36:53 hv2 kernel: WARNING: CPU: 2 PID: 26193 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:37:11 hv2 kernel: WARNING: CPU: 0 PID: 27020 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:37:29 hv2 kernel: WARNING: CPU: 3 PID: 27711 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:37:43 hv2 kernel: WARNING: CPU: 4 PID: 29270 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:37:53 hv2 kernel: WARNING: CPU: 4 PID: 29326 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:38:04 hv2 kernel: WARNING: CPU: 0 PID: 30157 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:38:18 hv2 kernel: WARNING: CPU: 7 PID: 30215 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:38:28 hv2 kernel: WARNING: CPU: 2 PID: 30876 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:38:43 hv2 kernel: WARNING: CPU: 6 PID: 32436 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:39:13 hv2 kernel: WARNING: CPU: 6 PID: 829 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:40:12 hv2 kernel: WARNING: CPU: 7 PID: 8008 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:40:26 hv2 kernel: WARNING: CPU: 7 PID: 10866 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:40:38 hv2 kernel: WARNING: CPU: 0 PID: 12600 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:41:10 hv2 kernel: WARNING: CPU: 5 PID: 13528 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:41:27 hv2 kernel: WARNING: CPU: 2 PID: 14210 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:41:45 hv2 kernel: WARNING: CPU: 3 PID: 15806 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:42:01 hv2 kernel: WARNING: CPU: 0 PID: 15870 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:42:05 hv2 kernel: WARNING: CPU: 1 PID: 16755 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:42:09 hv2 kernel: WARNING: CPU: 2 PID: 16797 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:42:12 hv2 kernel: WARNING: CPU: 0 PID: 16828 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:42:20 hv2 kernel: WARNING: CPU: 3 PID: 16885 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:42:52 hv2 kernel: WARNING: CPU: 1 PID: 19082 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:43:13 hv2 kernel: WARNING: CPU: 1 PID: 19918 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:43:30 hv2 kernel: WARNING: CPU: 1 PID: 20616 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:43:47 hv2 kernel: WARNING: CPU: 0 PID: 22312 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:44:00 hv2 kernel: WARNING: CPU: 3 PID: 22381 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:44:25 hv2 kernel: WARNING: CPU: 5 PID: 23868 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:44:52 hv2 kernel: WARNING: CPU: 5 PID: 25860 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:45:08 hv2 kernel: WARNING: CPU: 7 PID: 26680 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:45:17 hv2 kernel: WARNING: CPU: 3 PID: 26735 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:45:22 hv2 kernel: WARNING: CPU: 0 PID: 27263 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:45:30 hv2 kernel: WARNING: CPU: 3 PID: 27415 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:45:49 hv2 kernel: WARNING: CPU: 4 PID: 29023 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:45:55 hv2 kernel: WARNING: CPU: 0 PID: 29108 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:45:59 hv2 kernel: WARNING: CPU: 2 PID: 29150 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:46:03 hv2 kernel: WARNING: CPU: 0 PID: 29183 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:46:07 hv2 kernel: WARNING: CPU: 7 PID: 29712 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:46:22 hv2 kernel: WARNING: CPU: 4 PID: 30160 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:46:36 hv2 kernel: WARNING: CPU: 2 PID: 30825 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:46:52 hv2 kernel: WARNING: CPU: 3 PID: 32387 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:47:02 hv2 kernel: WARNING: CPU: 1 PID: 32444 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:47:26 hv2 kernel: WARNING: CPU: 4 PID: 1427 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:47:41 hv2 kernel: WARNING: CPU: 3 PID: 2252 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:47:56 hv2 kernel: WARNING: CPU: 0 PID: 3075 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:48:15 hv2 kernel: WARNING: CPU: 3 PID: 3912 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:48:36 hv2 kernel: WARNING: CPU: 7 PID: 4584 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:48:59 hv2 kernel: WARNING: CPU: 7 PID: 6217 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:49:18 hv2 kernel: WARNING: CPU: 6 PID: 7112 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:49:26 hv2 kernel: WARNING: CPU: 7 PID: 8160 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:49:43 hv2 kernel: WARNING: CPU: 4 PID: 9057 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:50:11 hv2 kernel: WARNING: CPU: 5 PID: 14950 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:50:33 hv2 kernel: WARNING: CPU: 4 PID: 17457 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:50:40 hv2 kernel: WARNING: CPU: 2 PID: 18200 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:50:51 hv2 kernel: WARNING: CPU: 0 PID: 18485 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:51:04 hv2 kernel: WARNING: CPU: 5 PID: 19116 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:51:18 hv2 kernel: WARNING: CPU: 4 PID: 19943 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:51:35 hv2 kernel: WARNING: CPU: 3 PID: 20663 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:51:52 hv2 kernel: WARNING: CPU: 2 PID: 21544 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:52:03 hv2 kernel: WARNING: CPU: 6 PID: 22414 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:52:17 hv2 kernel: WARNING: CPU: 0 PID: 23289 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:52:28 hv2 kernel: WARNING: CPU: 5 PID: 23935 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:52:39 hv2 kernel: WARNING: CPU: 3 PID: 23995 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:52:53 hv2 kernel: WARNING: CPU: 3 PID: 24853 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:53:08 hv2 kernel: WARNING: CPU: 2 PID: 25678 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:53:20 hv2 kernel: WARNING: CPU: 2 PID: 26502 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:53:38 hv2 kernel: WARNING: CPU: 4 PID: 27161 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:53:52 hv2 kernel: WARNING: CPU: 1 PID: 27979 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:54:03 hv2 kernel: WARNING: CPU: 0 PID: 29149 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:54:14 hv2 kernel: WARNING: CPU: 7 PID: 29959 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:54:18 hv2 kernel: WARNING: CPU: 6 PID: 30008 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:54:22 hv2 kernel: WARNING: CPU: 1 PID: 30347 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> May 10 23:54:48 hv2 kernel: WARNING: CPU: 2 PID: 31495 at kernel/workqueue.c:2911 __flush_work.isra.29+0x19f/0x1b0
> 
> 
> --
> Eric Wheeler
> 
