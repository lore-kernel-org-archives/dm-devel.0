From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Kernel BUG at dm-cache-policy-mq.c
Date: Thu, 19 Nov 2015 10:49:52 -0500
Message-ID: <20151119154952.GA11675@redhat.com>
References: <CANvPVN3Ak2Hb35T0moMfA3m9BP0sZVEwdMdWUkDihEbLpnPjBg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CANvPVN3Ak2Hb35T0moMfA3m9BP0sZVEwdMdWUkDihEbLpnPjBg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ciprian Hacman <ciprian.hacman@sematext.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 19 2015 at  4:32am -0500,
Ciprian Hacman <ciprian.hacman@sematext.com> wrote:

> Hi,
> 
> One more issue from me. As I said in my previous email, we are configuring
> lvm with SSD caching and EBS volumes on some of our boxes in AWS. The OS
> for those nodes is Ubuntu 15.10 (4.2.0-16-generic).
> 
> We already had 2 nodes down and seems to be related to the lvm caching
> part. On one of the nodes we found this in the logs:

<snip>

Please send any kernel issues to dm-devel@redhat.com in the future.

 
> Nov 17 17:03:26 localhost kernel: [1650439.548785] ------------[ cut here
> ]------------
> Nov 17 17:03:26 localhost kernel: [1650439.552225] kernel BUG at
> /build/linux-AxjFAn/linux-4.2.0/drivers/md/dm-cache-policy-mq.c:1079!
> Nov 17 17:03:26 localhost kernel: [1650439.552561] invalid opcode: 0000
> [#1] SMP
> Nov 17 17:03:26 localhost kernel: [1650439.552561] Modules linked in: isofs
> binfmt_misc xt_CHECKSUM iptable_mangle ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> nf_nat_ipv4 nf_nat nf_conntrack xt_tcpudp bridge stp llc iptable_filter
> ip_tables x_tables dm_cache_mq dm_cache dm_persistent_data dm_bio_prison
> dm_bufio libcrc32c ppdev xen_fbfront syscopyarea sysfillrect sysimgblt
> fb_sys_fops serio_raw parport_pc parport autofs4 raid10 raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
> raid1 multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> raid0 aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
> psmouse floppy
> Nov 17 17:03:26 localhost kernel: [1650439.552561] CPU: 1 PID: 68058 Comm:
> java Not tainted 4.2.0-16-generic #19-Ubuntu
> Nov 17 17:03:26 localhost kernel: [1650439.552561] Hardware name: Xen HVM
> domU, BIOS 4.2.amazon 05/06/2015
> Nov 17 17:03:26 localhost kernel: [1650439.552561] task: ffff880190241b80
> ti: ffff8806f3cf4000 task.ti: ffff8806f3cf4000
> Nov 17 17:03:26 localhost kernel: [1650439.552561] RIP:
> 0010:[<ffffffffc0182257>]  [<ffffffffc0182257>]
> __mq_set_clear_dirty+0x47/0x80 [dm_cache_mq]
> Nov 17 17:03:26 localhost kernel: [1650439.552561] RSP:
> 0018:ffff8806f3cf7730  EFLAGS: 00010246
> Nov 17 17:03:26 localhost kernel: [1650439.552561] RAX: 0000000000000000
> RBX: ffff88076a236080 RCX: ffffc90020f6aff8
> Nov 17 17:03:26 localhost kernel: [1650439.552561] RDX: 0000000000f7b83e
> RSI: ffffc9001fd39000 RDI: 0000000000000016
> Nov 17 17:03:26 localhost kernel: [1650439.552561] RBP: ffff8806f3cf7748
> R08: 0000000000000000 R09: ffff8801adb6c7c8
> Nov 17 17:03:26 localhost kernel: [1650439.552561] R10: ffff88032fd31bb0
> R11: ffff88076a22c858 R12: ffff88076a236000
> Nov 17 17:03:26 localhost kernel: [1650439.552561] R13: 0000000000000001
> R14: 000000000045c6ae R15: 0000000000000000
> Nov 17 17:03:26 localhost kernel: [1650439.552561] FS:
>  00007fccc4b27700(0000) GS:ffff88076f640000(0000) knlGS:0000000000000000
> Nov 17 17:03:26 localhost kernel: [1650439.552561] CS:  0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Nov 17 17:03:26 localhost kernel: [1650439.552561] CR2: 00007fce83a55000
> CR3: 00000005b3d2b000 CR4: 00000000001406e0
> Nov 17 17:03:26 localhost kernel: [1650439.552561] Stack:
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  ffff88076a236080
> ffff88076a236000 0000000000f7b83e ffff8806f3cf7778
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  ffffffffc0182317
> 0000000000000000 000000000045c6ae ffff880476c014e0
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  ffff88076744f800
> ffff8806f3cf7788 ffffffffc01a9862 ffff8806f3cf7818
> Nov 17 17:03:26 localhost kernel: [1650439.552561] Call Trace:
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffffc0182317>]
> mq_set_dirty+0x37/0x50 [dm_cache_mq]
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffffc01a9862>]
> set_dirty+0x32/0x40 [dm_cache]
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffffc01ab3c9>]
> remap_cell_to_cache_dirty+0x1d9/0x240 [dm_cache]
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffffc01ab900>]
> cache_map+0x330/0x4d0 [dm_cache]
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffffc01a8eb0>] ?
> cache_resume+0x30/0x30 [dm_cache]
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8166b2ee>]
> __map_bio+0x3e/0x100
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8166d235>]
> __split_and_process_bio+0x285/0x3f0
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8166d40d>]
> dm_make_request+0x6d/0xc0
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff813952a6>]
> generic_make_request+0xd6/0x110
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff810c3d61>] ?
> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff81395356>]
> submit_bio+0x76/0x170
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8138f51b>] ?
> __bio_add_page.part.16+0x10b/0x270
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8128c311>]
> ext4_io_submit+0x31/0x50
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8128c4c8>]
> ext4_bio_write_page+0x168/0x410
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff81283351>]
> mpage_submit_page+0x61/0x80
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff812835d6>]
> mpage_map_and_submit_buffers+0x156/0x290
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff81288874>]
> ext4_writepages+0x624/0xce0
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff811903be>]
> do_writepages+0x1e/0x30
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8118335c>]
> __filemap_fdatawrite_range+0xcc/0x100
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8118349a>]
> filemap_write_and_wait_range+0x2a/0x70
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8127f831>]
> ext4_sync_file+0xe1/0x2f0
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8122fc9b>]
> vfs_fsync_range+0x4b/0xb0
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff8122fd5d>]
> do_fsync+0x3d/0x70
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff81230023>]
> SyS_fdatasync+0x13/0x20
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  [<ffffffff817ef9f2>]
> entry_SYSCALL_64_fastpath+0x16/0x75
> Nov 17 17:03:26 localhost kernel: [1650439.552561] Code: 89 f2 49 8b b4 24
> 80 0d 00 00 e8 c5 f5 ff ff 48 85 c0 74 17 49 3b 84 24 f8 00 00 00 48 89 c3
> 72 0a 49 3b 84 24 00 01 00 00 72 02 <0f> 0b 48 89 c6 4c 89 e7 41 83 e5 01
> e8 08 ef ff ff 0f b6 43 28
> Nov 17 17:03:26 localhost kernel: [1650439.552561] RIP
>  [<ffffffffc0182257>] __mq_set_clear_dirty+0x47/0x80 [dm_cache_mq]
> Nov 17 17:03:26 localhost kernel: [1650439.552561]  RSP <ffff8806f3cf7730>
> Nov 17 17:03:26 localhost kernel: [1650439.740854] ---[ end trace
> 98483c1d54cc426e ]---
> 
> 
> Is this something that has been seen before?
> Would switching to RHEL/CentOS 7 make any difference?

AFAIK, this issue was already fixed with the 4.2 release, via commit
fb4100ae7f31 ("dm cache: fix race when issuing a POLICY_REPLACE
operation")

But if ubuntu's kernel trully is based on the upstream 4.2 kernel then
maybe there is something else going on...
