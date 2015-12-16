From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2 0/2] Introduce the bulk IV mode for improving the
 crypto engine efficiency
Date: Wed, 16 Dec 2015 09:08:47 +0100
Message-ID: <56711C0F.8030105@gmail.com>
References: <cover.1450233399.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450233399.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, broonie@kernel.org, arnd@arndb.de, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 12/16/2015 04:18 AM, Baolin Wang wrote:
> From the dm-crypt performance report, we found it shows low efficiency
> with crypto engine for some mode (like ecb or xts mode). Because in dm
> crypt, it will map the IO data buffer with scatterlist, and send the
> scatterlist of one bio to the encryption engine, if send more scatterlists
> with bigger size at one time, that helps the engine palys best performance,
> which means a high encryption speed. 
> 
> But now the dm-crypt only map one segment (always one sector) of one bio
> with one scatterlist to the crypto engine at one time. which is more
> time-consuming and ineffective for the crypto engine. Especially for some
> modes which don't need different IV for each sector, we can map the whole
> bio with multiple scatterlists to improve the engine performance.
> 
> But this optimization is not support some ciphers and IV modes which should
> do sector by sector and need different IV for each sector.
> 
> Change since v1:
>  - Introduce one different IV mode.
>  - Change the conditions for bulk mode.

I tried the patchset on 32bit Intel VM and kernel immediately OOPsed (just tried aes-ecb)...

Crash log below.

Milan


[   40.989759] BUG: unable to handle kernel NULL pointer dereference at   (null)
[   40.990736] IP: [<f8710d26>] crypt_sg_entry+0x186/0x270 [dm_crypt]
[   40.990800] *pde = 00000000 
[   40.990844] Oops: 0000 [#1] PREEMPT SMP 
[   40.990961] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   40.991412] CPU: 2 PID: 6 Comm: kworker/u8:0 Not tainted 4.4.0-rc5+ #44
[   40.991460] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   40.991531] Workqueue: kcryptd kcryptd_crypt [dm_crypt]
[   40.991587] task: f4c04180 ti: f4c06000 task.ti: f4c06000
[   40.991629] EIP: 0060:[<f8710d26>] EFLAGS: 00010246 CPU: 2
[   40.991672] EIP is at crypt_sg_entry+0x186/0x270 [dm_crypt]
[   40.991725] EAX: 00001000 EBX: 00001000 ECX: f73e85c0 EDX: 00000000
[   40.991772] ESI: 00000000 EDI: 00001000 EBP: f4c07e28 ESP: f4c07de8
[   40.991819]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   40.991862] CR0: 8005003b CR2: 00000000 CR3: 018c1000 CR4: 001406d0
[   40.991949] Stack:
[   40.991976]  f49967c8 00000000 00000000 00000000 00000000 01000058 00000000 f73e85c0
[   40.992173]  00000000 f4baf170 00001000 f4ba7290 00000000 f4baf030 f4baf170 f4baf0c0
[   40.992387]  f4c07e60 f8710e8a f4baf170 f4c07e4c f4baf170 f4baf114 f4baf160 f8713fe8
[   40.992599] Call Trace:
[   40.992647]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   40.992715]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   40.992781]  [<c1056e23>] process_one_work+0x153/0x420
[   40.992842]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   40.992905]  [<c1057127>] worker_thread+0x37/0x470
[   40.992964]  [<c10570f0>] ? process_one_work+0x420/0x420
[   40.993026]  [<c105c326>] kthread+0x96/0xb0
[   40.993083]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   40.993146]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
[   40.993207] Code: c2 01 31 f6 85 db 75 d1 89 55 e0 85 ff 0f 85 41 ff ff ff 8b 55 d8 8d 65 f4 89 d0 5b 5e 5f 5d c3 90 8d 74 26 00 8b 55 c8 8b 4d dc <8b> 02 89 4d dc 89 45 c8 c1 e8 1a c1 e0 04 8b 80 80 a2 0b c2 83
[   40.995405] EIP: [<f8710d26>] crypt_sg_entry+0x186/0x270 [dm_crypt] SS:ESP 0068:f4c07de8
[   40.995604] CR2: 0000000000000000
[   40.995703] ---[ end trace d78b89aae913dc1f ]---
[   40.995825] ------------[ cut here ]------------
[   40.995930] WARNING: CPU: 2 PID: 6 at kernel/softirq.c:150 __local_bh_enable_ip+0x88/0xd0()
[   40.996118] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul
[   40.996352] BUG: unable to handle kernel NULL pointer dereference at   (null)
[   40.996354] IP: [<f8710d26>] crypt_sg_entry+0x186/0x270 [dm_crypt]
[   40.996357] *pde = 00000000 
[   40.996359] Oops: 0000 [#2] PREEMPT SMP 
[   40.996361] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   40.996368] CPU: 3 PID: 53 Comm: kworker/u8:1 Tainted: G      D         4.4.0-rc5+ #44
[   40.996369] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   40.996371] Workqueue: kcryptd kcryptd_crypt [dm_crypt]
[   40.996372] task: f489c0c0 ti: f489e000 task.ti: f489e000
[   40.996373] EIP: 0060:[<f8710d26>] EFLAGS: 00010246 CPU: 3
[   40.996375] EIP is at crypt_sg_entry+0x186/0x270 [dm_crypt]
[   40.996375] EAX: 00001000 EBX: 00001000 ECX: f71e3a20 EDX: 00000000
[   40.996376] ESI: 00000000 EDI: 00010000 EBP: f489fe28 ESP: f489fde8
[   40.996377]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   40.996377] CR0: 8005003b CR2: 00000000 CR3: 33c26000 CR4: 001406d0
[   40.996410] Stack:
[   40.996411]  f49967c8 00000000 00000000 00000000 00000000 01000058 00000000 f71e3a20
[   40.996413]  00000000 f4bed370 00001000 f4b2e7c0 00000000 f4bed230 f4bed370 f4bed2c0
[   40.996415]  f489fe60 f8710e8a f4bed370 f489fe4c f4bed370 f4bed314 f4bed360 f8713fe8
[   40.996418] Call Trace:
[   40.996421]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   40.996423]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   40.996426]  [<c1056e23>] process_one_work+0x153/0x420
[   40.996428]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   40.996430]  [<c1057127>] worker_thread+0x37/0x470
[   40.996432]  [<c10570f0>] ? process_one_work+0x420/0x420
[   40.996433]  [<c105c326>] kthread+0x96/0xb0
[   40.996436]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   40.996438]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
[   40.996439] Code: c2 01 31 f6 85 db 75 d1 89 55 e0 85 ff 0f 85 41 ff ff ff 8b 55 d8 8d 65 f4 89 d0 5b 5e 5f 5d c3 90 8d 74 26 00 8b 55 c8 8b 4d dc <8b> 02 89 4d dc 89 45 c8 c1 e8 1a c1 e0 04 8b 80 80 a2 0b c2 83
[   40.996453] EIP: [<f8710d26>] crypt_sg_entry+0x186/0x270 [dm_crypt] SS:ESP 0068:f489fde8
[   40.996455] CR2: 0000000000000000
[   40.996456] ---[ end trace d78b89aae913dc20 ]---
[   40.996459] ------------[ cut here ]------------
[   40.996461] WARNING: CPU: 3 PID: 53 at kernel/softirq.c:150 __local_bh_enable_ip+0x88/0xd0()
[   40.996461] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   40.996465] CPU: 3 PID: 53 Comm: kworker/u8:1 Tainted: G      D         4.4.0-rc5+ #44
[   40.996466] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   40.996469]  00000000 00000000 f489fc64 c12a98f2 00000000 f489fc7c c1042757 c10455a8
[   40.996471]  00000201 c10bf91e f489c0c0 f489fc8c c10427ff 00000009 00000000 f489fc9c
[   40.996473]  c10455a8 c16d07e0 c16d0660 f489fca8 c14e49ca f489c0c0 f489fcbc c10bf91e
[   40.996475] Call Trace:
[   40.996477]  [<c12a98f2>] dump_stack+0x4b/0x79
[   40.996479]  [<c1042757>] warn_slowpath_common+0x67/0xa0
[   40.996480]  [<c10455a8>] ? __local_bh_enable_ip+0x88/0xd0
[   40.996482]  [<c10bf91e>] ? cgroup_exit+0x4e/0xc0
[   40.996484]  [<c10427ff>] warn_slowpath_null+0xf/0x20
[   40.996486]  [<c10455a8>] __local_bh_enable_ip+0x88/0xd0
[   40.996488]  [<c14e49ca>] _raw_spin_unlock_bh+0x2a/0x30
[   40.996490]  [<c10bf91e>] cgroup_exit+0x4e/0xc0
[   40.996491]  [<c1043674>] do_exit+0x224/0x920
[   40.996494]  [<c1092065>] ? kmsg_dump+0x105/0x180
[   40.996496]  [<c1004f21>] oops_end+0x61/0x90
[   40.996498]  [<c1038965>] no_context+0xf5/0x210
[   40.996500]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   40.996501]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   40.996502]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   40.996504]  [<c1064022>] ? try_to_wake_up+0x182/0x340
[   40.996505]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996507]  [<c103924b>] do_page_fault+0xb/0x10
[   40.996508]  [<c14e601f>] error_code+0x5f/0x64
[   40.996509]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996510]  [<f8710d26>] ? crypt_sg_entry+0x186/0x270 [dm_crypt]
[   40.996511]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   40.996512]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   40.996514]  [<c1056e23>] process_one_work+0x153/0x420
[   40.996515]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   40.996516]  [<c1057127>] worker_thread+0x37/0x470
[   40.996517]  [<c10570f0>] ? process_one_work+0x420/0x420
[   40.996518]  [<c105c326>] kthread+0x96/0xb0
[   40.996519]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   40.996520]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
[   40.996521] ---[ end trace d78b89aae913dc21 ]---
[   40.996547] BUG: unable to handle kernel paging request at ffffffc8
[   40.996548] IP: [<c105c75a>] kthread_data+0xa/0x10
[   40.996551] *pde = 018c3067 *pte = 00000000 
[   40.996552] Oops: 0000 [#3] PREEMPT SMP 
[   40.996554] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   40.996560] CPU: 3 PID: 53 Comm: kworker/u8:1 Tainted: G      D W       4.4.0-rc5+ #44
[   40.996560] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   40.996564] task: f489c0c0 ti: f489e000 task.ti: f489e000
[   40.996565] EIP: 0060:[<c105c75a>] EFLAGS: 00010002 CPU: 3
[   40.996566] EIP is at kthread_data+0xa/0x10
[   40.996567] EAX: 00000000 EBX: 00000003 ECX: 18a6743d EDX: 00000003
[   40.996567] ESI: f489c0c0 EDI: c18b6e00 EBP: f489fc80 ESP: f489fc78
[   40.996568]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   40.996568] CR0: 8005003b CR2: 00000014 CR3: 33c26000 CR4: 001406d0
[   40.996594] Stack:
[   40.996595]  c1057e5b f489c478 f489fcb0 c14e0083 00000003 f5fb6e10 f5fb6e00 c129283a
[   40.996597]  00000000 f5fb6e00 f489c0c0 f48a0000 f489f9b8 f489fce0 f489fcbc c14e0612
[   40.996598]  f489c0c0 f489fcf4 c1043a2e f489c3cc f57e8040 00000001 00000002 f489c3cc
[   40.996600] Call Trace:
[   40.996602]  [<c1057e5b>] ? wq_worker_sleeping+0xb/0x90
[   40.996603]  [<c14e0083>] __schedule+0x6a3/0xad0
[   40.996605]  [<c129283a>] ? put_io_context_active+0xaa/0xd0
[   40.996607]  [<c14e0612>] schedule+0x32/0x80
[   40.996609]  [<c1043a2e>] do_exit+0x5de/0x920
[   40.996610]  [<c1004f21>] oops_end+0x61/0x90
[   40.996612]  [<c1038965>] no_context+0xf5/0x210
[   40.996614]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   40.996616]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   40.996617]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   40.996619]  [<c1064022>] ? try_to_wake_up+0x182/0x340
[   40.996621]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996622]  [<c103924b>] do_page_fault+0xb/0x10
[   40.996623]  [<c14e601f>] error_code+0x5f/0x64
[   40.996625]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996627]  [<f8710d26>] ? crypt_sg_entry+0x186/0x270 [dm_crypt]
[   40.996629]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   40.996630]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   40.996631]  [<c1056e23>] process_one_work+0x153/0x420
[   40.996632]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   40.996633]  [<c1057127>] worker_thread+0x37/0x470
[   40.996634]  [<c10570f0>] ? process_one_work+0x420/0x420
[   40.996635]  [<c105c326>] kthread+0x96/0xb0
[   40.996636]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   40.996637]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
[   40.996638] Code: 00 3b 5f 34 74 0f 89 f8 e8 04 83 48 00 83 c4 78 5b 5e 5f 5d c3 8b 4f 28 eb bf 8d b4 26 00 00 00 00 55 8b 80 64 03 00 00 89 e5 5d <8b> 40 c8 c3 66 90 55 b9 04 00 00 00 89 e5 83 ec 04 8b 90 64 03
[   40.996652] EIP: [<c105c75a>] kthread_data+0xa/0x10 SS:ESP 0068:f489fc78
[   40.996654] CR2: 00000000ffffffc8
[   40.996655] ---[ end trace d78b89aae913dc22 ]---
[   40.996655] Fixing recursive fault but reboot is needed!
[   40.996656] BUG: scheduling while atomic: kworker/u8:1/53/0x00000003
[   40.996657] INFO: lockdep is turned off.
[   40.996657] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   40.996660] irq event stamp: 11388
[   40.996661] hardirqs last  enabled at (11387): [<c14e4a62>] _raw_spin_unlock_irq+0x22/0x50
[   40.996662] hardirqs last disabled at (11388): [<c14e489d>] _raw_spin_lock_irq+0xd/0x60
[   40.996664] softirqs last  enabled at (11314): [<c10fcddc>] wb_wakeup_delayed+0x4c/0x60
[   40.996666] softirqs last disabled at (11310): [<c10fcdb6>] wb_wakeup_delayed+0x26/0x60
[   40.996667] Preemption disabled at:[<c1004f21>] oops_end+0x61/0x90
[   40.996668] 
[   40.996669] CPU: 3 PID: 53 Comm: kworker/u8:1 Tainted: G      D W       4.4.0-rc5+ #44
[   40.996670] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   40.996674]  00000000 00000000 f489fb00 c12a98f2 f489c0c0 f489fb0c c106059f f48a0000
[   40.996677]  f489fb3c c14e0168 00000003 00000009 f5fb6e00 f489fb40 00000000 f5fb6e00
[   40.996680]  f489c0c0 f48a0000 00000009 f489c0c0 f489fb48 c14e0612 f489c0c0 f489fb84
[   40.996683] Call Trace:
[   40.996685]  [<c12a98f2>] dump_stack+0x4b/0x79
[   40.996687]  [<c106059f>] __schedule_bug+0x5f/0xb0
[   40.996688]  [<c14e0168>] __schedule+0x788/0xad0
[   40.996690]  [<c14e0612>] schedule+0x32/0x80
[   40.996691]  [<c1043b7b>] do_exit+0x72b/0x920
[   40.996692]  [<c1092065>] ? kmsg_dump+0x105/0x180
[   40.996693]  [<c1004f21>] oops_end+0x61/0x90
[   40.996694]  [<c1038965>] no_context+0xf5/0x210
[   40.996695]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   40.996697]  [<c106a54a>] ? update_curr+0x9a/0x130
[   40.996698]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996699]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   40.996700]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   40.996701]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996702]  [<c103924b>] do_page_fault+0xb/0x10
[   40.996703]  [<c14e601f>] error_code+0x5f/0x64
[   40.996704]  [<c106007b>] ? ttwu_stat+0x5b/0x200
[   40.996705]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996706]  [<c105c75a>] ? kthread_data+0xa/0x10
[   40.996707]  [<c1057e5b>] ? wq_worker_sleeping+0xb/0x90
[   40.996708]  [<c14e0083>] __schedule+0x6a3/0xad0
[   40.996709]  [<c129283a>] ? put_io_context_active+0xaa/0xd0
[   40.996710]  [<c14e0612>] schedule+0x32/0x80
[   40.996711]  [<c1043a2e>] do_exit+0x5de/0x920
[   40.996712]  [<c1004f21>] oops_end+0x61/0x90
[   40.996713]  [<c1038965>] no_context+0xf5/0x210
[   40.996715]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   40.996716]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   40.996717]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   40.996718]  [<c1064022>] ? try_to_wake_up+0x182/0x340
[   40.996719]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996720]  [<c103924b>] do_page_fault+0xb/0x10
[   40.996721]  [<c14e601f>] error_code+0x5f/0x64
[   40.996722]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   40.996723]  [<f8710d26>] ? crypt_sg_entry+0x186/0x270 [dm_crypt]
[   40.996724]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   40.996726]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   40.996727]  [<c1056e23>] process_one_work+0x153/0x420
[   40.996728]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   40.996729]  [<c1057127>] worker_thread+0x37/0x470
[   40.996730]  [<c10570f0>] ? process_one_work+0x420/0x420
[   40.996731]  [<c105c326>] kthread+0x96/0xb0
[   40.996733]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   40.996735]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
[   41.023333]  crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   41.023559] CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: G      D W       4.4.0-rc5+ #44
[   41.023649] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   41.023757]  00000000 00000000 f4c07c64 c12a98f2 00000000 f4c07c7c c1042757 c10455a8
[   41.023963]  00000201 c10bf91e f4c04180 f4c07c8c c10427ff 00000009 00000000 f4c07c9c
[   41.024168]  c10455a8 c16d07e0 c16d0660 f4c07ca8 c14e49ca f4c04180 f4c07cbc c10bf91e
[   41.024373] Call Trace:
[   41.024421]  [<c12a98f2>] dump_stack+0x4b/0x79
[   41.024477]  [<c1042757>] warn_slowpath_common+0x67/0xa0
[   41.024537]  [<c10455a8>] ? __local_bh_enable_ip+0x88/0xd0
[   41.024599]  [<c10bf91e>] ? cgroup_exit+0x4e/0xc0
[   41.024655]  [<c10427ff>] warn_slowpath_null+0xf/0x20
[   41.024714]  [<c10455a8>] __local_bh_enable_ip+0x88/0xd0
[   41.024775]  [<c14e49ca>] _raw_spin_unlock_bh+0x2a/0x30
[   41.024834]  [<c10bf91e>] cgroup_exit+0x4e/0xc0
[   41.024890]  [<c1043674>] do_exit+0x224/0x920
[   41.024945]  [<c1092065>] ? kmsg_dump+0x105/0x180
[   41.025002]  [<c1004f21>] oops_end+0x61/0x90
[   41.025057]  [<c1038965>] no_context+0xf5/0x210
[   41.025113]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   41.025176]  [<c10b5f0b>] ? __module_text_address+0xb/0x60
[   41.025236]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   41.025295]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   41.025353]  [<c1004d0e>] ? print_context_stack+0x4e/0xb0
[   41.025412]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.025471]  [<c103924b>] do_page_fault+0xb/0x10
[   41.025527]  [<c14e601f>] error_code+0x5f/0x64
[   41.025582]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.025642]  [<f8710d26>] ? crypt_sg_entry+0x186/0x270 [dm_crypt]
[   41.025705]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   41.025768]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   41.025831]  [<c1056e23>] process_one_work+0x153/0x420
[   41.026756]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   41.026816]  [<c1057127>] worker_thread+0x37/0x470
[   41.026873]  [<c10570f0>] ? process_one_work+0x420/0x420
[   41.026932]  [<c105c326>] kthread+0x96/0xb0
[   41.026987]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   41.027047]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
[   41.027106] ---[ end trace d78b89aae913dc23 ]---
[   41.027229] BUG: unable to handle kernel paging request at ffffffc8
[   41.027349] IP: [<c105c75a>] kthread_data+0xa/0x10
[   41.027455] *pde = 018c3067 *pte = 00000000 
[   41.027568] Oops: 0000 [#4] PREEMPT SMP 
[   41.027755] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   41.029586] CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: G      D W       4.4.0-rc5+ #44
[   41.029826] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   41.030943] task: f4c04180 ti: f4c06000 task.ti: f4c06000
[   41.031137] EIP: 0060:[<c105c75a>] EFLAGS: 00010002 CPU: 2
[   41.031341] EIP is at kthread_data+0xa/0x10
[   41.031536] EAX: 00000000 EBX: 00000002 ECX: 18c2e78b EDX: 00000002
[   41.031687] ESI: f4c04180 EDI: c18b6e00 EBP: f4c07c80 ESP: f4c07c78
[   41.031802]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   41.031955] CR0: 8005003b CR2: 00000014 CR3: 018c1000 CR4: 001406d0
[   41.032207] Stack:
[   41.032410]  c1057e5b f4c04538 f4c07cb0 c14e0083 00000002 f5e65e10 f5e65e00 c129283a
[   41.032772]  00000000 f5e65e00 f4c04180 f4c08000 f4c079b8 f4c07ce0 f4c07cbc c14e0612
[   41.035807]  f4c04180 f4c07cf4 c1043a2e f4c0448c f57e8040 00000001 00000002 f4c0448c
[   41.037146] Call Trace:
[   41.037353]  [<c1057e5b>] ? wq_worker_sleeping+0xb/0x90
[   41.037556]  [<c14e0083>] __schedule+0x6a3/0xad0
[   41.037759]  [<c129283a>] ? put_io_context_active+0xaa/0xd0
[   41.038744]  [<c14e0612>] schedule+0x32/0x80
[   41.038883]  [<c1043a2e>] do_exit+0x5de/0x920
[   41.039067]  [<c1004f21>] oops_end+0x61/0x90
[   41.039263]  [<c1038965>] no_context+0xf5/0x210
[   41.039455]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   41.039655]  [<c10b5f0b>] ? __module_text_address+0xb/0x60
[   41.039850]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   41.040025]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   41.040222]  [<c1004d0e>] ? print_context_stack+0x4e/0xb0
[   41.040373]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.040543]  [<c103924b>] do_page_fault+0xb/0x10
[   41.040765]  [<c14e601f>] error_code+0x5f/0x64
[   41.040984]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.041210]  [<f8710d26>] ? crypt_sg_entry+0x186/0x270 [dm_crypt]
[   41.041435]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   41.041650]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   41.042746]  [<c1056e23>] process_one_work+0x153/0x420
[   41.042928]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   41.043123]  [<c1057127>] worker_thread+0x37/0x470
[   41.043337]  [<c10570f0>] ? process_one_work+0x420/0x420
[   41.043450]  [<c105c326>] kthread+0x96/0xb0
[   41.043529]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   41.043653]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
[   41.043831] Code: 00 3b 5f 34 74 0f 89 f8 e8 04 83 48 00 83 c4 78 5b 5e 5f 5d c3 8b 4f 28 eb bf 8d b4 26 00 00 00 00 55 8b 80 64 03 00 00 89 e5 5d <8b> 40 c8 c3 66 90 55 b9 04 00 00 00 89 e5 83 ec 04 8b 90 64 03
[   41.055486] EIP: [<c105c75a>] kthread_data+0xa/0x10 SS:ESP 0068:f4c07c78
[   41.055692] CR2: 00000000ffffffc8
[   41.055803] ---[ end trace d78b89aae913dc24 ]---
[   41.055917] Fixing recursive fault but reboot is needed!
[   41.056038] BUG: scheduling while atomic: kworker/u8:0/6/0x00000003
[   41.056162] INFO: lockdep is turned off.
[   41.056353] Modules linked in: dm_crypt loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel ata_piix aesni_intel aes_i586 lrw ablk_helper cryptd
[   41.056783] irq event stamp: 17002
[   41.056833] hardirqs last  enabled at (17001): [<c108d686>] __raw_spin_lock_init+0x16/0x50
[   41.056944] hardirqs last disabled at (17002): [<c14e601b>] error_code+0x5b/0x64
[   41.057103] softirqs last  enabled at (16962): [<c10bf868>] cgroup_post_fork+0x68/0xd0
[   41.057335] softirqs last disabled at (16960): [<c10bf822>] cgroup_post_fork+0x22/0xd0
[   41.057522] Preemption disabled at:[<c1004f21>] oops_end+0x61/0x90
[   41.057719] 
[   41.057819] CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: G      D W       4.4.0-rc5+ #44
[   41.058887] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[   41.059066]  00000000 00000000 f4c07b00 c12a98f2 f4c04180 f4c07b0c c106059f f4c08000
[   41.059774]  f4c07b3c c14e0168 00000002 00000009 f5e65e00 f4c07b40 00000000 f5e65e00
[   41.060519]  f4c04180 f4c08000 00000009 f4c04180 f4c07b48 c14e0612 f4c04180 f4c07b84
[   41.060728] Call Trace:
[   41.060776]  [<c12a98f2>] dump_stack+0x4b/0x79
[   41.060833]  [<c106059f>] __schedule_bug+0x5f/0xb0
[   41.060891]  [<c14e0168>] __schedule+0x788/0xad0
[   41.060979]  [<c14e0612>] schedule+0x32/0x80
[   41.061067]  [<c1043b7b>] do_exit+0x72b/0x920
[   41.061148]  [<c1092065>] ? kmsg_dump+0x105/0x180
[   41.061250]  [<c1004f21>] oops_end+0x61/0x90
[   41.061306]  [<c1038965>] no_context+0xf5/0x210
[   41.061362]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   41.061425]  [<c106a54a>] ? update_curr+0x9a/0x130
[   41.061482]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.061542]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   41.061602]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   41.061661]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.061720]  [<c103924b>] do_page_fault+0xb/0x10
[   41.061789]  [<c14e601f>] error_code+0x5f/0x64
[   41.062866]  [<c106007b>] ? ttwu_stat+0x5b/0x200
[   41.063053]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.063247]  [<c105c75a>] ? kthread_data+0xa/0x10
[   41.063434]  [<c1057e5b>] ? wq_worker_sleeping+0xb/0x90
[   41.063625]  [<c14e0083>] __schedule+0x6a3/0xad0
[   41.063818]  [<c129283a>] ? put_io_context_active+0xaa/0xd0
[   41.064043]  [<c14e0612>] schedule+0x32/0x80
[   41.064762]  [<c1043a2e>] do_exit+0x5de/0x920
[   41.064944]  [<c1004f21>] oops_end+0x61/0x90
[   41.065133]  [<c1038965>] no_context+0xf5/0x210
[   41.065313]  [<c1038b1c>] __bad_area_nosemaphore+0x9c/0x150
[   41.065505]  [<c10b5f0b>] ? __module_text_address+0xb/0x60
[   41.065692]  [<c1038bdd>] bad_area_nosemaphore+0xd/0x10
[   41.066731]  [<c1038e0f>] __do_page_fault+0x6f/0x4a0
[   41.066848]  [<c1004d0e>] ? print_context_stack+0x4e/0xb0
[   41.067012]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.067231]  [<c103924b>] do_page_fault+0xb/0x10
[   41.067500]  [<c14e601f>] error_code+0x5f/0x64
[   41.067689]  [<c1039240>] ? __do_page_fault+0x4a0/0x4a0
[   41.067881]  [<f8710d26>] ? crypt_sg_entry+0x186/0x270 [dm_crypt]
[   41.068069]  [<f8710e8a>] crypt_convert_io+0x7a/0x360 [dm_crypt]
[   41.068259]  [<f87131e5>] kcryptd_crypt+0x395/0x3da [dm_crypt]
[   41.068417]  [<c1056e23>] process_one_work+0x153/0x420
[   41.068534]  [<c1056dd0>] ? process_one_work+0x100/0x420
[   41.068709]  [<c1057127>] worker_thread+0x37/0x470
[   41.068917]  [<c10570f0>] ? process_one_work+0x420/0x420
[   41.069118]  [<c105c326>] kthread+0x96/0xb0
[   41.069307]  [<c14e5389>] ret_from_kernel_thread+0x21/0x38
[   41.069434]  [<c105c290>] ? kthread_worker_fn+0xf0/0xf0
