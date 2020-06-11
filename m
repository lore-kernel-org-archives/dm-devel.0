From: Ivan Babrou <ivan@cloudflare.com>
Subject: BUG: KASAN: use-after-free in tasklet_action_common on boot
Date: Thu, 11 Jun 2020 10:47:12 -0700
Message-ID: <CABWYdi0FgAGcc2pprF2EYB=-ctw5UZQLbtfQqnKqd0GoiMNFuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: kernel-team <kernel-team@cloudflare.com>, agk@redhat.com, snitzer@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Hello,

We're seeing the following KASAN complaint on some nodes. These use
AMD CPUs and NVMe storage, and we don't see the same issue on older
Intel machines with SATA drives.

[Thu Jun 11 14:14:44 2020] systemd[1]: Detected architecture x86-64.
[Thu Jun 11 14:15:12 2020] device-mapper: uevent: version 1.0.3
[Thu Jun 11 14:15:12 2020] device-mapper: ioctl: 4.41.0-ioctl
(2019-09-16) initialised: dm-devel@redhat.com
[Thu Jun 11 14:15:14 2020] NET: Registered protocol family 38
[Thu Jun 11 14:15:16 2020]
==================================================================
[Thu Jun 11 14:15:16 2020] BUG: KASAN: use-after-free in
tasklet_action_common.constprop.0
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/bitops.h:75
/cfsetup_build/build/linux-5.4.46/include/asm-generic/bitops-instrumented.h:57
/cfsetup_build/build/linux-5.4.46/include/linux/interrupt.h:623
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:524)
[Thu Jun 11 14:15:16 2020] Write of size 8 at addr ffff88bdd8725f48 by
task swapper/92/0

[Thu Jun 11 14:15:16 2020] CPU: 92 PID: 0 Comm: swapper/92 Not tainted
5.4.46-cloudflare-kasan-2020.6.10 #1
[Thu Jun 11 14:15:16 2020] Hardware name: GIGABYTE
R162-Z12-CD/MZ12-HD4-CD, BIOS R08a 01/21/2020
[Thu Jun 11 14:15:16 2020] Call Trace:
[Thu Jun 11 14:15:16 2020]  <IRQ>
[Thu Jun 11 14:15:16 2020] dump_stack
(/cfsetup_build/build/linux-5.4.46/lib/dump_stack.c:120)
[Thu Jun 11 14:15:16 2020] print_address_description.constprop.0
(/cfsetup_build/build/linux-5.4.46/mm/kasan/report.c:375)
[Thu Jun 11 14:15:16 2020] __kasan_report.cold
(/cfsetup_build/build/linux-5.4.46/mm/kasan/report.c:514)
[Thu Jun 11 14:15:16 2020] ? clone_endio+0xd1/0x710 dm_mod
[Thu Jun 11 14:15:16 2020] ? tasklet_action_common.constprop.0
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/bitops.h:75
/cfsetup_build/build/linux-5.4.46/include/asm-generic/bitops-instrumented.h:57
/cfsetup_build/build/linux-5.4.46/include/linux/interrupt.h:623
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:524)
[Thu Jun 11 14:15:16 2020] ? tasklet_action_common.constprop.0
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/bitops.h:75
/cfsetup_build/build/linux-5.4.46/include/asm-generic/bitops-instrumented.h:57
/cfsetup_build/build/linux-5.4.46/include/linux/interrupt.h:623
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:524)
[Thu Jun 11 14:15:16 2020] kasan_report
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/smap.h:69
/cfsetup_build/build/linux-5.4.46/mm/kasan/common.c:635)
[Thu Jun 11 14:15:16 2020] ? tasklet_action_common.constprop.0
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/bitops.h:75
/cfsetup_build/build/linux-5.4.46/include/asm-generic/bitops-instrumented.h:57
/cfsetup_build/build/linux-5.4.46/include/linux/interrupt.h:623
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:524)
[Thu Jun 11 14:15:16 2020] check_memory_region
(/cfsetup_build/build/linux-5.4.46/mm/kasan/generic.c:185
/cfsetup_build/build/linux-5.4.46/mm/kasan/generic.c:191)
[Thu Jun 11 14:15:16 2020] tasklet_action_common.constprop.0
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/bitops.h:75
/cfsetup_build/build/linux-5.4.46/include/asm-generic/bitops-instrumented.h:57
/cfsetup_build/build/linux-5.4.46/include/linux/interrupt.h:623
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:524)
[Thu Jun 11 14:15:16 2020] __do_softirq
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/jump_label.h:25
/cfsetup_build/build/linux-5.4.46/include/linux/jump_label.h:200
/cfsetup_build/build/linux-5.4.46/include/trace/events/irq.h:142
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:293)
[Thu Jun 11 14:15:16 2020] irq_exit
(/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:373
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:413)
[Thu Jun 11 14:15:16 2020] do_IRQ
(/cfsetup_build/build/linux-5.4.46/arch/x86/kernel/irq.c:267
(discriminator 42))
[Thu Jun 11 14:15:16 2020] common_interrupt
(/cfsetup_build/build/linux-5.4.46/arch/x86/entry/entry_64.S:610)
[Thu Jun 11 14:15:16 2020]  </IRQ>
[Thu Jun 11 14:15:16 2020] RIP: 0010:cpuidle_enter_state
(/cfsetup_build/build/linux-5.4.46/drivers/cpuidle/cpuidle.c:249)
[Thu Jun 11 14:15:16 2020] Code: 24 0f 1f 44 00 00 31 ff e8 34 cf ab
fe 80 7c 24 08 00 74 12 9c 58 f6 c4 02 0f 85 b7 07 00 00 31 ff e8 fb
78 bc fe fb 45 85 e4 <0f> 89 ef 02 00 00 48 8d 7b 14 48 b8 00 00 00 00
00 fc ff df 48 89
All code
========
   0: 24 0f                and    $0xf,%al
   2: 1f                    (bad)
   3: 44 00 00              add    %r8b,(%rax)
   6: 31 ff                xor    %edi,%edi
   8: e8 34 cf ab fe        callq  0xfffffffffeabcf41
   d: 80 7c 24 08 00        cmpb   $0x0,0x8(%rsp)
  12: 74 12                je     0x26
  14: 9c                    pushfq
  15: 58                    pop    %rax
  16: f6 c4 02              test   $0x2,%ah
  19: 0f 85 b7 07 00 00    jne    0x7d6
  1f: 31 ff                xor    %edi,%edi
  21: e8 fb 78 bc fe        callq  0xfffffffffebc7921
  26: fb                    sti
  27: 45 85 e4              test   %r12d,%r12d
  2a:* 0f 89 ef 02 00 00    jns    0x31f <-- trapping instruction
  30: 48 8d 7b 14          lea    0x14(%rbx),%rdi
  34: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
  3b: fc ff df
  3e: 48                    rex.W
  3f: 89                    .byte 0x89

Code starting with the faulting instruction
===========================================
   0: 0f 89 ef 02 00 00    jns    0x2f5
   6: 48 8d 7b 14          lea    0x14(%rbx),%rdi
   a: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
  11: fc ff df
  14: 48                    rex.W
  15: 89                    .byte 0x89
[Thu Jun 11 14:15:16 2020] RSP: 0018:ffff88bfeaeafd80 EFLAGS: 00000202
ORIG_RAX: ffffffffffffffde
[Thu Jun 11 14:15:16 2020] RAX: dffffc0000000000 RBX: ffff889fdcfc0800
RCX: 000000000000001f
[Thu Jun 11 14:15:16 2020] RDX: 1ffff117fdce6555 RSI: 0000000037a6f9a0
RDI: ffff88bfee732aa8
[Thu Jun 11 14:15:16 2020] RBP: ffffffff9288d660 R08: 00000128214f54ce
R09: ffff889fe9e23000
[Thu Jun 11 14:15:16 2020] R10: ffff889fe9e23099 R11: 00000058eb5113bb
R12: 0000000000000002
[Thu Jun 11 14:15:16 2020] R13: 0000000000000002 R14: ffffffff9288d738
R15: 00000000000000c0
[Thu Jun 11 14:15:16 2020] ? menu_enable_device
(/cfsetup_build/build/linux-5.4.46/drivers/cpuidle/governors/menu.c:558)
[Thu Jun 11 14:15:16 2020] cpuidle_enter
(/cfsetup_build/build/linux-5.4.46/include/linux/compiler.h:226
/cfsetup_build/build/linux-5.4.46/drivers/cpuidle/cpuidle.c:346)
[Thu Jun 11 14:15:16 2020] ? call_cpuidle
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/bitops.h:207
/cfsetup_build/build/linux-5.4.46/include/asm-generic/bitops-instrumented.h:238
/cfsetup_build/build/linux-5.4.46/include/linux/thread_info.h:84
/cfsetup_build/build/linux-5.4.46/include/linux/sched/idle.h:55
/cfsetup_build/build/linux-5.4.46/kernel/sched/idle.c:106)
[Thu Jun 11 14:15:16 2020] do_idle
(/cfsetup_build/build/linux-5.4.46/kernel/sched/idle.c:205
/cfsetup_build/build/linux-5.4.46/kernel/sched/idle.c:263)
[Thu Jun 11 14:15:16 2020] ? arch_cpu_idle_exit (??:?)
[Thu Jun 11 14:15:16 2020] ? __kthread_bind_mask
(/cfsetup_build/build/linux-5.4.46/kernel/kthread.c:407
/cfsetup_build/build/linux-5.4.46/kernel/kthread.c:395)
[Thu Jun 11 14:15:16 2020] cpu_startup_entry
(/cfsetup_build/build/linux-5.4.46/kernel/sched/idle.c:354
(discriminator 1))
[Thu Jun 11 14:15:16 2020] start_secondary
(/cfsetup_build/build/linux-5.4.46/arch/x86/kernel/smpboot.c:272)
[Thu Jun 11 14:15:16 2020] ? set_cpu_sibling_map
(/cfsetup_build/build/linux-5.4.46/arch/x86/kernel/smpboot.c:212)
[Thu Jun 11 14:15:16 2020] secondary_startup_64
(/cfsetup_build/build/linux-5.4.46/arch/x86/kernel/head_64.S:241)

[Thu Jun 11 14:15:16 2020] Allocated by task 0:
[Thu Jun 11 14:15:16 2020] (stack is not available)

[Thu Jun 11 14:15:16 2020] Freed by task 0:
[Thu Jun 11 14:15:16 2020] save_stack
(/cfsetup_build/build/linux-5.4.46/mm/kasan/common.c:55
/cfsetup_build/build/linux-5.4.46/mm/kasan/common.c:70)
[Thu Jun 11 14:15:16 2020] __kasan_slab_free
(/cfsetup_build/build/linux-5.4.46/mm/kasan/common.c:473)
[Thu Jun 11 14:15:16 2020] slab_free_freelist_hook
(/cfsetup_build/build/linux-5.4.46/mm/slub.c:1457)
[Thu Jun 11 14:15:16 2020] kmem_cache_free
(/cfsetup_build/build/linux-5.4.46/mm/slub.c:3014
/cfsetup_build/build/linux-5.4.46/mm/slub.c:3030)
[Thu Jun 11 14:15:16 2020] dec_pending+0x21f/0x930 dm_mod
[Thu Jun 11 14:15:16 2020] clone_endio+0x1bd/0x710 dm_mod
[Thu Jun 11 14:15:16 2020] tasklet_action_common.constprop.0
(/cfsetup_build/build/linux-5.4.46/include/asm-generic/bitops-instrumented.h:56
/cfsetup_build/build/linux-5.4.46/include/linux/interrupt.h:623
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:524)
[Thu Jun 11 14:15:16 2020] __do_softirq
(/cfsetup_build/build/linux-5.4.46/arch/x86/include/asm/jump_label.h:25
/cfsetup_build/build/linux-5.4.46/include/linux/jump_label.h:200
/cfsetup_build/build/linux-5.4.46/include/trace/events/irq.h:142
/cfsetup_build/build/linux-5.4.46/kernel/softirq.c:293)

[Thu Jun 11 14:15:16 2020] The buggy address belongs to the object at
ffff88bdd8725f00
which belongs to the cache bio-5 of size 1144
[Thu Jun 11 14:15:16 2020] The buggy address is located 72 bytes inside of
1144-byte region [ffff88bdd8725f00, ffff88bdd8726378)
[Thu Jun 11 14:15:16 2020] The buggy address belongs to the page:
[Thu Jun 11 14:15:16 2020] page:ffffea00f761c800 refcount:1 mapcount:0
mapping:ffff889dce1d2000 index:0x0 compound_mapcount: 0
[Thu Jun 11 14:15:16 2020] flags: 0xeffff800010200(slab|head)
[Thu Jun 11 14:15:16 2020] raw: 00effff800010200 dead000000000100
dead000000000122 ffff889dce1d2000
[Thu Jun 11 14:15:16 2020] raw: 0000000000000000 0000000080190019
00000001ffffffff 0000000000000000
[Thu Jun 11 14:15:16 2020] page dumped because: kasan: bad access detected

[Thu Jun 11 14:15:16 2020] Memory state around the buggy address:
[Thu Jun 11 14:15:16 2020]  ffff88bdd8725e00: fc fc fc fc fc fc fc fc
fc fc fc fc fc fc fc fc
[Thu Jun 11 14:15:16 2020]  ffff88bdd8725e80: fc fc fc fc fc fc fc fc
fc fc fc fc fc fc fc fc
[Thu Jun 11 14:15:16 2020] >ffff88bdd8725f00: fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb fb
[Thu Jun 11 14:15:16 2020]                                               ^
[Thu Jun 11 14:15:16 2020]  ffff88bdd8725f80: fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb fb
[Thu Jun 11 14:15:16 2020]  ffff88bdd8726000: fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb fb
[Thu Jun 11 14:15:16 2020]
==================================================================
[Thu Jun 11 14:15:16 2020] Disabling lock debugging due to kernel taint
[Thu Jun 11 14:15:25 2020] XFS (dm-0): Mounting V5 Filesystem
[Thu Jun 11 14:15:25 2020] XFS (dm-0): Ending clean mount
