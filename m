From: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Linux 4.1-rc1: dm crash / regression
Date: Wed, 29 Apr 2015 14:15:20 +0300
Message-ID: <20150429111520.GA1200@ak-desktop.emea.nsn-net.net>
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
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I'm getting below kernel crash with 4.1-rc1 during boot on MIPS QEMU. I
tried bisection, and it points to:

022333427a8aa4ccb318a9db90cea4e69ca1826b is the first bad commit
commit 022333427a8aa4ccb318a9db90cea4e69ca1826b
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue Mar 10 23:49:26 2015 -0400

    dm: optimize dm_mq_queue_rq to _not_ use kthread if using pure blk-mq

Let me know if you need further info...

A.

[   27.431405] CPU 0 Unable to handle kernel paging request at virtual address 00000000000000c0, epc == ffffffffc000e304, ra == ffffffffc000e300
[   27.432497] Oops[#1]:
[   27.432855] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 4.1.0-rc1-mipsqemu-distro.git-v1.6-9-g8891106 #1
[   27.433376] task: 98000000ffce91f0 ti: 98000000ffd34000 task.ti: 98000000ffd34000
[   27.433799] $ 0   : 0000000000000000 000000001400a4e0 0000000000000000 0000000000000000
[   27.434535] $ 4   : 0000000000000000 0000000000005723 0000000000000000 0000000004208040
[   27.435024] $ 8   : ffffffffc0036898 0000000000000001 fffffffffffffffc 98000000feab6208
[   27.435491] $12   : 98000000ffd37ce8 000000000000a400 6db6db6db6db0000 ffffffff80c20000
[   27.435719] $16   : 98000000fbe49c38 98000000feb65050 98000000ffe89c00 98000000ffe89c00
[   27.436027] $20   : 0000000000000100 0000000000000004 ffffffff80bf6600 0000000000000000
[   27.436557] $24   : 0000000000000001 ffffffff801de758                                  
[   27.437367] $28   : 98000000ffd34000 98000000ffd37d00 ffffffff806c6458 ffffffffc000e300
[   27.438206] Hi    : 0000000000000004
[   27.438679] Lo    : 666666666666666d
[   27.439938] epc   : ffffffffc000e304 free_rq_clone+0x44/0xe0 [dm_mod]
[   27.440644]     Not tainted
[   27.441067] ra    : ffffffffc000e300 free_rq_clone+0x40/0xe0 [dm_mod]
[   27.441775] Status: 1400a4e3	KX SX UX KERNEL EXL IE 
[   27.442655] Cause : 00800008
[   27.443007] BadVA : 00000000000000c0
[   27.443324] PrId  : 000182a0 (MIPS 20Kc)
[   27.443842] Modules linked in: dm_service_time dm_multipath dm_mod autofs4
[   27.445092] Process ksoftirqd/0 (pid: 3, threadinfo=98000000ffd34000, task=98000000ffce91f0, tls=0000000000000000)
[   27.446277] Stack : 98000000fbe49c38 98000000fbe49ae0 0000000000000000 ffffffffc000e7dc
	  fffffffffffffffb 98000000fe9df400 ffffffff806c6490 0000000000000004
	  ffffffff80bf6620 0000000000000005 0000000000000010 ffffffff803388dc
	  98000000ffd37d60 98000000ffd37d60 0000000000000001 ffffffff80136894
	  000000000000000a 00000000ffff9587 0000000004208040 0000000000000000
	  98000000ffca9580 ffffffff806bb960 0000000000000001 0000000000000001
	  0000000000000002 ffffffff806e7a40 0000000000000000 0000000000000000
	  0000000000000000 ffffffff80136af8 0000000000800400 ffffffff8015604c
	  98000000ffca9600 ffffffff80bf0000 ffffffff80640000 98000000ffca9580
	  ffffffff80155e90 ffffffff80152440 0000000000000001 0000000000000000
	  ...
[   27.454581] Call Trace:
[   27.454980] [<ffffffffc000e304>] free_rq_clone+0x44/0xe0 [dm_mod]
[   27.456113] [<ffffffffc000e7dc>] dm_softirq_done+0x194/0x2c0 [dm_mod]
[   27.457006] [<ffffffff803388dc>] blk_done_softirq+0xac/0xc0
[   27.457717] [<ffffffff80136894>] __do_softirq+0x174/0x368
[   27.458384] [<ffffffff80136af8>] run_ksoftirqd+0x70/0xa8
[   27.459032] [<ffffffff8015604c>] smpboot_thread_fn+0x1bc/0x1c8
[   27.459765] [<ffffffff80152440>] kthread+0xe0/0xf8
[   27.460368] [<ffffffff80105768>] ret_from_kernel_thread+0x14/0x1c
[   27.461293] 
[   27.461605] 
Code: 0040f809  de320000  de020030 <dc4200c0> 1040000f  00000000  de220008  dc420008  dc420050 
[   27.466903] ---[ end trace 0d7247d4c52efd19 ]---
