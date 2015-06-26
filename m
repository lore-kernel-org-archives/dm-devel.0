From: Vincent Donnefort <vdonnefort@gmail.com>
Subject: dm-dedup: freeze and panic
Date: Fri, 26 Jun 2015 12:02:32 +0200
Message-ID: <20150626100231.GA20278@ns3274321.ip-5-39-88.eu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tarasov@vasily.name
Cc: dm-devel@redhat.com, simon.guinot@sequanux.org
List-Id: dm-devel.ids

Vasily,

I'm currently testing dm-dedup from the "dm-dedup-v3.19.3" branch
on the git remote git://git.fsl.cs.sunysb.edu/linux-dmdedup.git.

I'm encountering some random freeze/panic. Here's the commands I'm
using and the panic which may appear:

$ echo "0 314569779 dedup /dev/sda1 /dev/sda2 4096 md5 cowbtree 100" |
dmsetup create mydedup
$ mke2fs -t ext4 /dev/mapper/mydedup

[   16.338987] Unable to handle kernel paging request at virtual address e1b42a5c
[   16.346248] pgd = df7f0000
[   16.348968] [e1b42a5c] *pgd=00000000
[   16.352577] Internal error: Oops: 15 [#1] ARM
[   16.356954] Modules linked in:
[   16.360039] CPU: 0 PID: 65 Comm: klogd Not tainted 3.19.3-00163-ge64d974-dirty #455
[   16.367729] Hardware name: Marvell Armada 370/XP (Device Tree)
[   16.373589] task: df7f6e80 ti: ded70000 task.ti: ded70000
[   16.379018] PC is at __free_pages+0x10/0x4c
[   16.383228] LR is at my_endio+0x60/0x80
[   16.387084] pc : [<c00842a8>]    lr : [<c0400404>]    psr: a0000113
[   16.387084] sp : ded71e00  ip : 00000000  fp : df723708
[   16.398613] r10: 00000000  r9 : 00000000  r8 : 00000000
[   16.403862] r7 : 00001000  r6 : df747d00  r5 : 00001000  r4 : 00000000
[   16.410419] r3 : dfb79000  r2 : e1b42a5c  r1 : 00000000  r0 : e1b42a4c
[   16.416977] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   16.424144] Control: 10c5387d  Table: 1f7f0019  DAC: 00000015
[   16.429916] Process klogd (pid: 65, stack limit = 0xded70238)
[   16.435689] Stack: (0xded71e00 to 0xded72000)
[   16.440071] 1e00: dec5eac0 00001000 c02a95a4 c02a952c 00001000 00000000 dec5eac0 c02aee04
[   16.448288] 1e20: df7f6e80 00000000 df747d00 df6ec000 decbe400 df723708 00000000 00000000
[   16.456505] 1e40: 00000000 c035d16c df747d00 00000000 decbe400 00000000 00000000 00000000
[   16.464723] 1e60: 00001000 c035e8c4 00000bb8 00000005 df6fd418 df67b000 c0744350 ded71ea0
[   16.472940] 1e80: c08db550 00000100 c08db540 c0744350 00000004 c08db500 00000004 c02b5428
[   16.481158] 1ea0: ded71ea0 ded71ea0 00000000 c001fdb4 df7f7210 df40a36c c08db540 0000000a
[   16.489375] 1ec0: ffff9132 00404100 df40a35c c08b4830 00000000 00000000 df406000 00000001
[   16.497593] 1ee0: ded70000 00000000 000bfa3f c0020170 c08b4830 c004e23c c0ebbf80 000003ff
[   16.505811] 1f00: ded71f28 c0ebbf80 c000e4e4 c00085ec c005ca68 c005ca68 60000013 ffffffff
[   16.514029] 1f20: ded71f5c c0011700 00000000 c073c134 00000010 00000000 ded71f90 befe3c10
[   16.522247] 1f40: 0000000c 0000004e c000e4e4 ded70000 00000000 000bfa3f d5555555 ded71f70
[   16.530464] 1f60: c005ca68 c005ca68 60000013 ffffffff fbad8000 c005caa0 00000010 00000000
[   16.538681] 1f80: 14035449 00000121 00000000 c00559c4 00000000 c0433cec 00000000 befe3c94
[   16.546900] 1fa0: 000c2008 c000e360 befe3c94 000c2008 befe3c10 00000000 0000003e fbad8000
[   16.555119] 1fc0: befe3c94 000c2008 0000000c 0000004e 00000000 befe3cd8 000a3db8 000bfa3f
[   16.563336] 1fe0: 00000000 befe3c0c b6ef08e8 b6ef091c 60000010 befe3c10 00000000 00000000
[   16.571559] [<c00842a8>] (__free_pages) from [<c0400404>] (my_endio+0x60/0x80)
[   16.578830] [<c0400404>] (my_endio) from [<c02a952c>] (bio_endio+0x80/0xd0)
[   16.585833] [<c02a952c>] (bio_endio) from [<c02aee04>] (blk_update_request+0xc4/0x378)
[   16.593799] [<c02aee04>] (blk_update_request) from [<c035d16c>] (scsi_end_request+0x20/0x170)
[   16.602370] [<c035d16c>] (scsi_end_request) from [<c035e8c4>] (scsi_io_completion+0x84/0x530)
[   16.610938] [<c035e8c4>] (scsi_io_completion) from [<c02b5428>] (blk_done_softirq+0x6c/0x88)
[   16.619425] [<c02b5428>] (blk_done_softirq) from [<c001fdb4>] (__do_softirq+0xd8/0x224)
[   16.627470] [<c001fdb4>] (__do_softirq) from [<c0020170>] (irq_exit+0xa0/0xf0)
[   16.634733] [<c0020170>] (irq_exit) from [<c004e23c>] (__handle_domain_irq+0x50/0xa4)
[   16.642603] [<c004e23c>] (__handle_domain_irq) from [<c00085ec>] (armada_370_xp_handle_irq+0x48/0x58)
[   16.651877] [<c00085ec>] (armada_370_xp_handle_irq) from [<c0011700>] (__irq_svc+0x40/0x54)
[   16.660265] Exception stack(0xded71f28 to 0xded71f70)
[   16.665343] 1f20:                   00000000 c073c134 00000010 00000000 ded71f90 befe3c10
[   16.673561] 1f40: 0000000c 0000004e c000e4e4 ded70000 00000000 000bfa3f d5555555 ded71f70
[   16.681776] 1f60: c005ca68 c005ca68 60000013 ffffffff
[   16.686865] [<c0011700>] (__irq_svc) from [<c005ca68>] (getnstimeofday64+0x8/0x2c)
[   16.694475] [<c005ca68>] (getnstimeofday64) from [<c005caa0>] (do_gettimeofday+0x14/0x44)
[   16.702694] [<c005caa0>] (do_gettimeofday) from [<c00559c4>] (SyS_gettimeofday+0x1c/0xb8)
[   16.710912] [<c00559c4>] (SyS_gettimeofday) from [<c000e360>] (ret_fast_syscall+0x0/0x34)
[   16.719129] Code: e92d0030 e2802010 e1a04001 f5d2f000 (e192cf9f) 
[   16.725255] ---[ end trace d8c1eb600c427385 ]---
[   16.729895] Kernel panic - not syncing: Fatal exception in interrupt
[   16.736280] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

I also tried

$ dd if=/dev/urandom of=/dev/mapper/mydedup bs=4K count=1024

which leads to the same result.

-- 
Vincent.
