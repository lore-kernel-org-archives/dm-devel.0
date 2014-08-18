From: Milan Broz <gmazyland@gmail.com>
Subject: Re: commit 298a9fa dm crypt: use per-bio data hard crash
 kernel ( the system freezes )
Date: Mon, 18 Aug 2014 17:37:25 +0200
Message-ID: <53F21DB5.9060003@gmail.com>
References: <53F0F7C7.2010501@winsoft.pl>
	<20140818151526.GA16744@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140818151526.GA16744@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, mpatocka@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, Krzysztof Kolasa <kkolasa@winsoft.pl>
List-Id: dm-devel.ids

On 08/18/2014 05:15 PM, Alasdair G Kergon wrote:
> On Sun, Aug 17, 2014 at 08:43:19PM +0200, Krzysztof Kolasa wrote:
>> Enter - create oops on console, system freezes
> 
> Can you supply the boot log including the oops details?
> (Upload a photo and send a link to it if you can't get it as text.)

Just run cryptsetup test suite...

Here on my VMWare, running Linux 3.17-rc1.

tests/tcrypt-compat-test, it oopses here:
...
tcrypt-images/tc_2-rmd160-lrw-aes-twofish <lockup>

Milan


Here is the OOPS (arch is i686 here, so 32bit).

(rest is report of spinlock lockup etc... let know if you need full log)

Aug 18 17:23:54 kernel: [  116.711774] NET: Registered protocol family 38
Aug 18 17:24:31 kernel: [  153.820497] loop: module loaded
Aug 18 17:25:09 kernel: [  191.598711] BUG: unable to handle kernel paging request at 20000000
Aug 18 17:25:09 kernel: [  191.598795] IP: [<e0fe2433>] clone_endio+0x13/0xe0 [dm_mod]
Aug 18 17:25:09 kernel: [  191.598856] *pde = 00000000 
Aug 18 17:25:09 kernel: [  191.598898] Oops: 0000 [#1] PREEMPT SMP 
Aug 18 17:25:09 kernel: [  191.598973] Modules linked in: dm_crypt loop ecb cast5_generic cast_common des_generic blowfish_generic blowfish_common serpent_sse2_i586 serpent_generic glue_helper twofish_generic twofish_i586 twofish_common cbc algif_skcipher af_alg rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel aesni_intel aes_i586 xts lrw gf128mul ablk_helper cryptd ata_piix
Aug 18 17:25:09 kernel: [  191.599563] CPU: 2 PID: 1745 Comm: kworker/2:2 Not tainted 3.17.0-rc1 #71
Aug 18 17:25:09 kernel: [  191.599920] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
Aug 18 17:25:09 kernel: [  191.599988] Workqueue: kcryptd kcryptd_crypt [dm_crypt]
Aug 18 17:25:09 kernel: [  191.600042] task: df35a010 ti: dce9c000 task.ti: dce9c000
Aug 18 17:25:09 kernel: [  191.600138] EIP: 0060:[<e0fe2433>] EFLAGS: 00010296 CPU: 2
Aug 18 17:25:09 kernel: [  191.600192] EIP is at clone_endio+0x13/0xe0 [dm_mod]
Aug 18 17:25:09 kernel: [  191.600233] EAX: 20000000 EBX: dcee1f7c ECX: e0fe2420 EDX: 00000000
Aug 18 17:25:09 kernel: [  191.600278] ESI: 00000000 EDI: dcee1f7c EBP: dce9de3c ESP: dce9de28
Aug 18 17:25:09 kernel: [  191.600322]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Aug 18 17:25:09 kernel: [  191.600365] CR0: 80050033 CR2: 20000000 CR3: 0181b000 CR4: 001407d0
Aug 18 17:25:09 kernel: [  191.600452] Stack:
Aug 18 17:25:09 kernel: [  191.600488]  dcee1f60 20000000 00000000 fffffffb dcee1f7c dce9de50 c1257b61 dcee1f2c
Aug 18 17:25:09 kernel: [  191.600676]  00000000 dcefd880 dce9de70 e142476c dcf19880 00000000 00000000 dcee1dc8
Aug 18 17:25:09 kernel: [  191.600863]  dcefd880 dcee1df0 dce9deac e142666f dce9deac 00000246 00000000 00000001
Aug 18 17:25:09 kernel: [  191.601049] Call Trace:
Aug 18 17:25:09 kernel: [  191.601092]  [<c1257b61>] bio_endio+0x61/0x90
Aug 18 17:25:09 kernel: [  191.601139]  [<e142476c>] crypt_dec_pending+0x8c/0xd0 [dm_crypt]
Aug 18 17:25:09 kernel: [  191.601196]  [<e142666f>] kcryptd_crypt+0x4bf/0x4f0 [dm_crypt]
Aug 18 17:25:09 kernel: [  191.601252]  [<c104cfb3>] ? process_one_work+0x103/0x390
Aug 18 17:25:09 kernel: [  191.601304]  [<c104d006>] process_one_work+0x156/0x390
Aug 18 17:25:09 kernel: [  191.601354]  [<c104cfb3>] ? process_one_work+0x103/0x390
Aug 18 17:25:09 kernel: [  191.601406]  [<c104d869>] worker_thread+0x39/0x440
Aug 18 17:25:09 kernel: [  191.601455]  [<c104d830>] ? execute_in_process_context+0x70/0x70
Aug 18 17:25:09 kernel: [  191.601510]  [<c1051363>] kthread+0xa3/0xc0
Aug 18 17:25:09 kernel: [  191.601557]  [<c106cc7d>] ? put_lock_stats.isra.21+0xd/0x30
Aug 18 17:25:09 kernel: [  191.601611]  [<c106eb6b>] ? trace_hardirqs_on+0xb/0x10
Aug 18 17:25:09 kernel: [  191.601664]  [<c1466281>] ret_from_kernel_thread+0x21/0x30
Aug 18 17:25:09 kernel: [  191.601716]  [<c10512c0>] ? kthread_create_on_node+0x160/0x160
Aug 18 17:25:09 kernel: [  191.601769] Code: 8c d2 fe e0 e8 01 d6 47 e0 0f 0b 8b 46 20 e9 43 ff ff ff 90 8d 74 26 00 55 89 e5 57 56 89 d6 53 89 c3 83 ec 08 8b 40 f0 89 45 f0 <8b> 00 89 45 ec 8b 43 f4 8b 50 04 8b 7a 2c 85 f6 75 0c f6 43 08
Aug 18 17:25:09 kernel: [  191.602837] EIP: [<e0fe2433>] clone_endio+0x13/0xe0 [dm_mod] SS:ESP 0068:dce9de28
Aug 18 17:25:09 kernel: [  191.602939] CR2: 0000000020000000
Aug 18 17:25:09 kernel: [  191.602983] ---[ end trace 42ce9ca7c3d57d56 ]---
Aug 18 17:25:09 kernel: [  191.603874] BUG: unable to handle kernel paging request at ffffffc8
Aug 18 17:25:09 kernel: [  191.603990] IP: [<c105184a>] kthread_data+0xa/0x10
Aug 18 17:25:09 kernel: [  191.604053] *pde = 0181d067 *pte = 00000000 
Aug 18 17:25:09 kernel: [  191.604126] Oops: 0000 [#2] PREEMPT SMP 
Aug 18 17:25:09 kernel: [  191.604211] Modules linked in: dm_crypt loop ecb cast5_generic cast_common des_generic blowfish_generic blowfish_common serpent_sse2_i586 serpent_generic glue_helper twofish_generic twofish_i586 twofish_common cbc algif_skcipher af_alg rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel aesni_intel aes_i586 xts lrw gf128mul ablk_helper cryptd ata_piix
Aug 18 17:25:09 kernel: [  191.609278] CPU: 2 PID: 1745 Comm: kworker/2:2 Tainted: G      D        3.17.0-rc1 #71
Aug 18 17:25:09 kernel: [  191.609433] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
Aug 18 17:25:09 kernel: [  191.609691] task: df35a010 ti: dce9c000 task.ti: dce9c000
Aug 18 17:25:09 kernel: [  191.609894] EIP: 0060:[<c105184a>] EFLAGS: 00010002 CPU: 2
Aug 18 17:25:09 kernel: [  191.610103] EIP is at kthread_data+0xa/0x10
Aug 18 17:25:09 kernel: [  191.610282] EAX: 00000000 EBX: 00000002 ECX: d647ca3b EDX: 00000002
Aug 18 17:25:09 kernel: [  191.610420] ESI: 00000002 EDI: dfa0c980 EBP: dce9dc38 ESP: dce9dc30
Aug 18 17:25:09 kernel: [  191.610504]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Aug 18 17:25:09 kernel: [  191.610673] CR0: 80050033 CR2: 00000014 CR3: 0181b000 CR4: 001407d0
Aug 18 17:25:09 kernel: [  191.610938] Stack:
Aug 18 17:25:09 kernel: [  191.611961]  c104dd6b dfa0c980 dce9dca8 c1461072 dce9dc4c c16cb000 df35a380 00000046
Aug 18 17:25:09 kernel: [  191.613402]  c1811980 df35a010 c162fe00 dce9dc64 c106eb6b dce9dc80 00000246 00000000
Aug 18 17:25:09 kernel: [  191.614842]  00000246 df35a010 de7c7340 df35a010 dce9dc8c c108178f 00000000 dce9dcb0
Aug 18 17:25:09 kernel: [  191.617394] Call Trace:
Aug 18 17:25:09 kernel: [  191.617476]  [<c104dd6b>] ? wq_worker_sleeping+0xb/0x80
Aug 18 17:25:09 kernel: [  191.617566]  [<c1461072>] __schedule+0x502/0x890
Aug 18 17:25:09 kernel: [  191.617745]  [<c106eb6b>] ? trace_hardirqs_on+0xb/0x10
Aug 18 17:25:09 kernel: [  191.617937]  [<c108178f>] ? call_rcu+0xf/0x20
Aug 18 17:25:09 kernel: [  191.618135]  [<c103b989>] ? release_task+0x239/0x3a0
Aug 18 17:25:09 kernel: [  191.618334]  [<c146141e>] schedule+0x1e/0x60
Aug 18 17:25:09 kernel: [  191.618517]  [<c103c14f>] do_exit+0x65f/0x8c0
Aug 18 17:25:09 kernel: [  191.618699]  [<c1004f0a>] oops_end+0x6a/0x90
Aug 18 17:25:09 kernel: [  191.618907]  [<c1032981>] no_context+0x101/0x220
Aug 18 17:25:09 kernel: [  191.619007]  [<c1032b3a>] __bad_area_nosemaphore+0x9a/0x150
Aug 18 17:25:09 kernel: [  191.619074]  [<c1032bfd>] bad_area_nosemaphore+0xd/0x10
Aug 18 17:25:09 kernel: [  191.619232]  [<c1033104>] __do_page_fault+0x224/0x580
Aug 18 17:25:09 kernel: [  191.621679]  [<e1243e70>] ? twofish_encrypt+0x20/0x20 [twofish_i586]
Aug 18 17:25:09 kernel: [  191.622046]  [<c1033460>] ? __do_page_fault+0x580/0x580
Aug 18 17:25:09 kernel: [  191.622401]  [<c1288e6f>] ? __this_cpu_preempt_check+0xf/0x20
Aug 18 17:25:09 kernel: [  191.622595]  [<c1033460>] ? __do_page_fault+0x580/0x580
Aug 18 17:25:09 kernel: [  191.622782]  [<c103346b>] do_page_fault+0xb/0x10
Aug 18 17:25:09 kernel: [  191.622959]  [<c1466e2f>] error_code+0x5f/0x64
Aug 18 17:25:09 kernel: [  191.623139]  [<e0fe2420>] ? dm_softirq_done+0x140/0x140 [dm_mod]
Aug 18 17:25:09 kernel: [  191.623269]  [<c1033460>] ? __do_page_fault+0x580/0x580
Aug 18 17:25:09 kernel: [  191.623347]  [<e0fe2433>] ? clone_endio+0x13/0xe0 [dm_mod]
Aug 18 17:25:09 kernel: [  191.623478]  [<c1257b61>] bio_endio+0x61/0x90
Aug 18 17:25:09 kernel: [  191.624020]  [<e142476c>] crypt_dec_pending+0x8c/0xd0 [dm_crypt]
Aug 18 17:25:09 kernel: [  191.624243]  [<e142666f>] kcryptd_crypt+0x4bf/0x4f0 [dm_crypt]
Aug 18 17:25:09 kernel: [  191.624452]  [<c104cfb3>] ? process_one_work+0x103/0x390
Aug 18 17:25:09 kernel: [  191.624660]  [<c104d006>] process_one_work+0x156/0x390
Aug 18 17:25:09 kernel: [  191.624858]  [<c104cfb3>] ? process_one_work+0x103/0x390
Aug 18 17:25:09 kernel: [  191.624994]  [<c104d869>] worker_thread+0x39/0x440
Aug 18 17:25:09 kernel: [  191.625095]  [<c104d830>] ? execute_in_process_context+0x70/0x70
Aug 18 17:25:09 kernel: [  191.625282]  [<c1051363>] kthread+0xa3/0xc0
Aug 18 17:25:09 kernel: [  191.625471]  [<c106cc7d>] ? put_lock_stats.isra.21+0xd/0x30
Aug 18 17:25:09 kernel: [  191.625662]  [<c106eb6b>] ? trace_hardirqs_on+0xb/0x10
Aug 18 17:25:09 kernel: [  191.626352]  [<c1466281>] ret_from_kernel_thread+0x21/0x30
Aug 18 17:25:09 kernel: [  191.626539]  [<c10512c0>] ? kthread_create_on_node+0x160/0x160
Aug 18 17:25:09 kernel: [  191.626725] Code: 00 55 64 a1 94 c6 6c c1 8b 80 44 03 00 00 89 e5 5d 8b 40 c0 c1 e8 02 83 e0 01 c3 8d b6 00 00 00 00 55 8b 80 44 03 00 00 89 e5 5d <8b> 40 c8 c3 66 90 55 b9 04 00 00 00 89 e5 83 ec 04 8b 90 44 03
Aug 18 17:25:09 kernel: [  191.636829] EIP: [<c105184a>] kthread_data+0xa/0x10 SS:ESP 0068:dce9dc30
Aug 18 17:25:09 kernel: [  191.637310] CR2: 00000000ffffffc8
Aug 18 17:25:09 kernel: [  191.637500] ---[ end trace 42ce9ca7c3d57d57 ]---
