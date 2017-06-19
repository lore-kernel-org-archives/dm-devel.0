From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [dm-devel] dm integrity tests crash kernel (4.12-rc5)
Date: Mon, 19 Jun 2017 14:11:49 +0200
Message-ID: <d32598d1-2ae3-6b0a-690f-7d7dfa43899e@redhat.com>
References: <2b97933e-3f94-8510-cefd-13fae445400e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2b97933e-3f94-8510-cefd-13fae445400e@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, mpatocka@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

same log again, hopefully prettier format. Sorry:

[  330.980914] DEBUG_LOCKS_WARN_ON(current->hardirq_context)
[  330.980923] ------------[ cut here ]------------
[  330.982627] WARNING: CPU: 1 PID: 0 at kernel/locking/lockdep.c:2748 
trace_hardirqs_on_caller+0x107/0x180
[  330.984340] Modules linked in: dm_integrity async_xor xor async_tx 
dm_bufio dm_mod dax auth_rpcgss oid_registry nfsv4 dns_resolver nfs 
lockd grace sunrpc crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc 
aesni_intel aes_x86_64 crypto_simd glue_helper cryptd
[  330.989205] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.12.0-rc5 #1
[  330.990645] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.9.1-1.fc24 04/01/2014
[  330.992616] task: ffff88007c838000 task.stack: ffffc90000368000
[  330.994084] RIP: 0010:trace_hardirqs_on_caller+0x107/0x180
[  330.995361] RSP: 0018:ffff88007fd03e38 EFLAGS: 00010092
[  330.996594] RAX: 000000000000002d RBX: ffff8800322404e0 RCX: 
0000000000000000
[  330.998194] RDX: ffffffff810badd8 RSI: 0000000000000001 RDI: 
ffffffff810badf2
[  330.999801] RBP: ffff88007fd03e48 R08: 0000000000000001 R09: 
0000000000000000
[  331.001427] R10: 0000000000000000 R11: ffffffff810badbe R12: 
ffffffff81809ff7
[  331.003045] R13: ffff880032c4e700 R14: ffff880077cd9bc0 R15: 
0000000000000000
[  331.005616] FS:  0000000000000000(0000) GS:ffff88007fd00000(0000) 
knlGS:0000000000000000
[  331.008308] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  331.010107] CR2: 00000000025e7f50 CR3: 0000000039c7c000 CR4: 
00000000000406e0
[  331.011968] Call Trace:
[  331.012806]  <IRQ>
[  331.013684]  trace_hardirqs_on+0xd/0x10
[  331.014732]  _raw_spin_unlock_irq+0x27/0x30
[  331.015840]  submit_flush_bio+0x4e/0x80 [dm_integrity]
[  331.017157]  do_endio_flush+0x41/0x70 [dm_integrity]
[  331.018476]  dec_in_flight+0x59/0x110 [dm_integrity]
[  331.019767]  integrity_end_io+0x5e/0x70 [dm_integrity]
[  331.020965]  bio_endio+0x7c/0x1a0
[  331.021917]  blk_update_request+0x9f/0x3d0
[  331.023050]  blk_mq_end_request+0x15/0x60
[  331.024224]  lo_complete_rq+0x2b/0x80
[  331.025406]  __blk_mq_complete_request_remote+0xe/0x10
[  331.026813]  flush_smp_call_function_queue+0x4f/0x110
[  331.028173]  generic_smp_call_function_single_interrupt+0xe/0x20
[  331.029616]  smp_call_function_single_interrupt+0x22/0x30
[  331.031125]  call_function_single_interrupt+0x90/0xa0
[  331.032819] RIP: 0010:default_idle+0x1b/0x180
[  331.035740] RSP: 0018:ffffc9000036beb0 EFLAGS: 00000206 ORIG_RAX: 
ffffffffffffff04
[  331.039007] RAX: ffff88007c838000 RBX: ffff88007c838000 RCX: 
0000000000000001
[  331.041332] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
ffff88007c838000
[  331.043227] RBP: ffffc9000036bec0 R08: 0000000000000000 R09: 
0000000000000001
[  331.045066] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000001
[  331.047367] R13: ffff88007c838000 R14: 0000000000000000 R15: 
0000000000000000
[  331.049232]  </IRQ>
[  331.050297]  arch_cpu_idle+0xa/0x10
[  331.051505]  default_idle_call+0x1e/0x30
[  331.052874]  do_idle+0x15a/0x1c0
[  331.053836]  cpu_startup_entry+0x18/0x20
[  331.054997]  start_secondary+0xed/0xf0
[  331.056183]  secondary_startup_64+0x9f/0x9f
[  331.057503] Code: 41 5c 5d f3 c3 e8 ea 75 29 00 85 c0 74 f1 8b 35 b0 
92 ca 01 85 f6 75 e7 48 c7 c6 67 8e c1 81 48 c7 c7 43 6d c1 81 e8 dc b4 
0b 00 <0f> ff eb d0 be 01 00 00 00 48 89 df e8 48 fe ff ff 85 c0 75 90
[  331.062261] ---[ end trace fd21f79668c6a046 ]---
[  331.063745] ------------[ cut here ]------------
[  331.066503] kernel BUG at kernel/irq_work.c:135!
[  331.068374] invalid opcode: 0000 [#1] SMP
[  331.070144] Modules linked in: dm_integrity async_xor xor async_tx 
dm_bufio dm_mod dax auth_rpcgss oid_registry nfsv4 dns_resolver nfs 
lockd grace sunrpc crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc 
aesni_intel aes_x86_64 crypto_simd glue_helper cryptd
[  331.076302] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W 
4.12.0-rc5 #1
[  331.078639] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.9.1-1.fc24 04/01/2014
[  331.081124] task: ffff88007c838000 task.stack: ffffc90000368000
[  331.082646] RIP: 0010:irq_work_run_list+0x62/0x70
[  331.083892] RSP: 0018:ffff88007fd03f70 EFLAGS: 00010206
[  331.085469] RAX: ffff88007c838000 RBX: 0000000000000200 RCX: 
0000000000000002
[  331.087449] RDX: ffffffff813097bc RSI: 0000000000000001 RDI: 
ffff88007fd14cf8
[  331.089271] RBP: ffff88007fd03f90 R08: 0000000000000000 R09: 
0000000000000000
[  331.091093] R10: 0000000000000000 R11: ffffffff81309760 R12: 
0000000000000000
[  331.093018] R13: 0000000000000001 R14: 0000000000000000 R15: 
0000000000000000
[  331.094834] FS:  0000000000000000(0000) GS:ffff88007fd00000(0000) 
knlGS:0000000000000000
[  331.099328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  331.101766] CR2: 00000000025e7f50 CR3: 0000000039c7c000 CR4: 
00000000000406e0
[  331.103660] Call Trace:
[  331.104600]  <IRQ>
[  331.105484]  irq_work_run+0x18/0x40
[  331.106885]  flush_smp_call_function_queue+0xc6/0x110
[  331.108351]  generic_smp_call_function_single_interrupt+0xe/0x20
[  331.109955]  smp_call_function_single_interrupt+0x22/0x30
[  331.111585]  call_function_single_interrupt+0x90/0xa0
[  331.113044] RIP: 0010:default_idle+0x1b/0x180
[  331.114345] RSP: 0018:ffffc9000036beb0 EFLAGS: 00000206 ORIG_RAX: 
ffffffffffffff04
[  331.116727] RAX: ffff88007c838000 RBX: ffff88007c838000 RCX: 
0000000000000001
[  331.118583] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
ffff88007c838000
[  331.120402] RBP: ffffc9000036bec0 R08: 0000000000000000 R09: 
0000000000000001
[  331.122356] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000001
[  331.124185] R13: ffff88007c838000 R14: 0000000000000000 R15: 
0000000000000000
[  331.126006]  </IRQ>
[  331.128146]  arch_cpu_idle+0xa/0x10
[  331.129805]  default_idle_call+0x1e/0x30
[  331.131580]  do_idle+0x15a/0x1c0
[  331.133109]  cpu_startup_entry+0x18/0x20
[  331.134391]  start_secondary+0xed/0xf0
[  331.135669]  secondary_startup_64+0x9f/0x9f
[  331.137057] Code: 4c 89 e0 48 87 43 f8 ff 53 08 4c 89 f2 4c 89 e0 48 
83 e2 fc f0 48 0f b1 53 f8 4d 85 ed 4c 89 eb 75 cc 5b 41 5c 41 5d 41 5e 
5d c3 <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 c7 c7 f8 4c 01
[  331.142106] RIP: irq_work_run_list+0x62/0x70 RSP: ffff88007fd03f70
[  331.143767] ---[ end trace fd21f79668c6a047 ]---
[  331.145124] Kernel panic - not syncing: Fatal exception in interrupt
[  331.146940] Kernel Offset: disabled
[  331.148076] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt
