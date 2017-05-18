From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-verity OOPSes on kernel 4.12rc
Date: Thu, 18 May 2017 09:18:32 +0200
Message-ID: <a5989b0e-af62-c782-f20b-c3c95c282437@gmail.com>
References: <2c50482c-e515-297e-288b-8a4bce093838@redhat.com>
	<6a0bb9db-6270-aafd-4618-71963e7d97b1@gmail.com>
	<CAOtvUMd8z90UE3w+oABJ3_970H5gMbQoH8E8kHHs4+i=dKX9LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOtvUMd8z90UE3w+oABJ3_970H5gMbQoH8E8kHHs4+i=dKX9LA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: device-mapper development <dm-devel@redhat.com>, Marian Csontos <mcsontos@redhat.com>
List-Id: dm-devel.ids

On 05/18/2017 08:55 AM, Gilad Ben-Yossef wrote:
> On Thu, May 18, 2017 at 9:37 AM, Milan Broz <gmazyland@gmail.com> wrote:
>> Hi Gilad,
>>
>> seems this OOPs is caused by async crypto hash changes in 4.12 for dm-verity.
>>
> 
> Oy, that is not good.
> 
>> Could you please check if it is some known problem?
>>
> 
> I am not aware of any problem but of course I will try to reproduce an debug.
> 
>> Fedora rawhide x86_64 (with 4.12rc patches) crashes always,
>> running verity-compat-test from cryptsetup testsuite is enough to trigger this.
>>
>> I am not able to reproduce it on other distro but I guess it is just
>> some kernel debugging switch that is enabled in Fedora by default.
>>
> 
> hmm... looking at the trace - there seems to be buffer io errors *before* the
> BUG assert.  That is surprising for a KVM run.
> 
> Also the code path triggering this I believe is when we read hash blocks.
> Possibly this is triggered by an IO request failing and than we continue
> with trying to hash the block. This is just a guess... I will take a look.

Thanks!

FYI, I am able to reproduce it on 32bit kernel as well,
git from Linus' tree updated today.

All I need to add is some kernel debug instrumentation, these options:
+CONFIG_DEBUG_LIST=y
+CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_SG=y

then it crashes:

: kernel BUG at ./include/linux/scatterlist.h:140!
: invalid opcode: 0000 [#1] PREEMPT SMP
: Modules linked in: dm_verity reed_solomon dm_bufio loop dm_mod crc32_pclmul crc32c_intel pcbc aesni_intel aes_i586 crypto_simd cryptd ata_piix
: CPU: 3 PID: 3331 Comm: kworker/u8:6 Not tainted 4.12.0-rc1+ #187
: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
: Workqueue: kverityd verity_work [dm_verity]
: task: d89a2380 task.stack: d8a26000
: EIP: sg_init_one+0x80/0xa0
: EFLAGS: 00010246 CPU: 3
: EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: d8a27d7c
: ESI: d8a27d7c EDI: 00000000 EBP: d8a27d70 ESP: d8a27d60
:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
: CR0: 80050033 CR2: bfd71bcc CR3: 18d33000 CR4: 001406d0
: Call Trace:
:  verity_hash_update.isra.1+0x28/0xb0 [dm_verity]
:  verity_hash_init+0x84/0xe0 [dm_verity]
:  verity_hash+0x2e/0x70 [dm_verity]
:  verity_verify_level+0x122/0x1b0 [dm_verity]
:  verity_hash_for_block+0xab/0xf0 [dm_verity]
:  verity_work+0x6d/0x1b1 [dm_verity]
:  ? sched_clock_cpu+0x19/0x130
:  process_one_work+0x1c7/0x5c0
:  worker_thread+0x39/0x380
:  kthread+0xd6/0x110
:  ? process_one_work+0x5c0/0x5c0
:  ? kthread_worker_fn+0x100/0x100
:  ret_from_fork+0x21/0x2c
: Code: c3 81 3e 21 43 65 87 75 2a 83 e1 01 75 2d 8b 45 f0 09 d3 89 7e 0c 89 5e 04 89 46 08 83 c4 04 5b 5e 5f 5d c3 8d b4 26 00 00 00 00 <0f> 0b 8d b6 00 00 00 00 0f 0b 8d b6 00 00 00 00 0f 0b 8d b4 26
: EIP: sg_init_one+0x80/0xa0 SS:ESP: 0068:d8a27d60
: ---[ end trace 9b16cafae4c60e01 ]---


>>> kernel:
>>>
>>> 4.12.0-0.rc1.git1.1.fc27.x86_64
>>> - latest 4.12 build in rawhide
>>>
>>> cryptsetup commit:
>>>
>>> d9a528922b5d1a15c72936ea2e5e87ce2d31bc3d
>>> - HEAD of wip-luks2 branch as of 2017-05-16
>>>
>>> ...
>>> [ 1057.722305] buffer_io_error: 146 callbacks suppressed
>>> [ 1057.723514] Buffer I/O error on dev dm-2, logical block 128, async
>>> page read
>>> [ 1058.364790] ------------[ cut here ]------------
>>> [ 1058.366235] kernel BUG at ./include/linux/scatterlist.h:140!
>>> [ 1058.367567] invalid opcode: 0000 [#1] SMP
>>> [ 1058.368545] Modules linked in: wp512 cast5_generic cast_common
>>> des3_ede_x86_64 des_generic blowfish_generic blowfish_x86_64
>>> blowfish_common xfs libcrc32c vfat fat twofish_generic
>>> twofish_x86_64_3way twofish_x86_64 twofish_common serpent_sse2_x86_64
>>> serpent_generic ablk_helper dm_verity reed_solomon dm_crypt loop
>>> crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ppdev
>>> virtio_net joydev virtio_balloon acpi_cpufreq tpm_tis tpm_tis_core
>>> parport_pc tpm i2c_piix4 parport virtio_blk cirrus drm_kms_helper ttm
>>> serio_raw drm virtio_pci virtio_ring virtio ata_generic pata_acpi [last
>>> unloaded: scsi_debug]
>>> [ 1058.368545] CPU: 0 PID: 61 Comm: kworker/u4:1 Not tainted
>>> 4.12.0-0.rc1.git1.1.fc27.x86_64 #1
>>> [ 1058.368545] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
>>> [ 1058.368545] Workqueue: kverityd verity_work [dm_verity]
>>> [ 1058.368545] task: ffff97ba361cb100 task.stack: ffffa5b240738000
>>> [ 1058.368545] RIP: 0010:sg_init_one+0x8c/0xa0
>>> [ 1058.368545] RSP: 0018:ffffa5b24073bb30 EFLAGS: 00010246
>>> [ 1058.368545] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
>>> ffffa5b24073bb80
>>> [ 1058.368545] RDX: 0000684600000000 RSI: 0000000087654321 RDI:
>>> 0000000080000000
>>> [ 1058.368545] RBP: ffffa5b24073bb48 R08: ffffa5b24073bb58 R09:
>>> 0000000000000000
>>> [ 1058.368545] R10: ffffa5b24073bb58 R11: 0000000000000000 R12:
>>> 0000000000000000
>>> [ 1058.368545] R13: ffffa5b24073bb58 R14: ffffa5b24073bbe8 R15:
>>> ffff97ba743fe400
>>> [ 1058.368545] FS:  0000000000000000(0000) GS:ffff97ba77800000(0000)
>>> knlGS:0000000000000000
>>> [ 1058.368545] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 1058.368545] CR2: 00007ffcec50aef0 CR3: 0000000061a00000 CR4:
>>> 00000000000006f0
>>> [ 1058.368545] Call Trace:
>>> [ 1058.368545]  verity_hash_update.isra.10+0x38/0xd0 [dm_verity]
>>> [ 1058.368545]  verity_hash_init+0x85/0x100 [dm_verity]
>>> [ 1058.368545]  verity_hash+0x40/0xa0 [dm_verity]
>>> [ 1058.368545]  verity_verify_level+0x113/0x1b0 [dm_verity]
>>> [ 1058.368545]  verity_hash_for_block+0xe7/0xf0 [dm_verity]
>>> [ 1058.368545]  verity_verify_io+0x79/0x1d0 [dm_verity]
>>> [ 1058.368545]  ? __lock_is_held+0x65/0xb0
>>> [ 1058.368545]  ? process_one_work+0x1d0/0x6a0
>>> [ 1058.368545]  verity_work+0x16/0x23 [dm_verity]
>>> [ 1058.368545]  process_one_work+0x253/0x6a0
>>> [ 1058.368545]  worker_thread+0x4d/0x3b0
>>> [ 1058.368545]  kthread+0x133/0x150
>>> [ 1058.368545]  ? process_one_work+0x6a0/0x6a0
>>> [ 1058.368545]  ? kthread_create_on_node+0x70/0x70
>>> [ 1058.368545]  ret_from_fork+0x31/0x40
>>> [ 1058.368545] Code: ca 75 2c 49 8b 55 08 f6 c2 01 75 25 83 e2 03 81 e3
>>> ff 0f 00 00 45 89 65 14 48 09 d0 41 89 5d 10 49 89 45 08 5b 41 5c 41 5d
>>> 5d c3 <0f> 0b 0f 0b 0f 0b 0f 0b 48 8b 15 a5 b6 95 00 eb a3 0f 1f 00 55
>>> [ 1058.368545] RIP: sg_init_one+0x8c/0xa0 RSP: ffffa5b24073bb30
>>> [ 1058.451674] ---[ end trace 6f39ab0b3842519c ]---
>>>
>>
> Cheers,
> Gilad
> 
