From: WGH <wgh@torlan.ru>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 23:29:35 +0300
Message-ID: <f724132c-802d-8b22-fab1-7b0c09e8a5dd@torlan.ru>
References: <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <20180803133102.GA3092@redhat.com> <20180803152034.GD32066@thunk.org>
 <20180803183932.GA3258@redhat.com>
 <CA+55aFwGGjs_imFFkEPJ4g99Kseam=4Qppv4G6Q=ZfZXdzF7Vw@mail.gmail.com>
 <20180803190617.GA4498@redhat.com>
 <CA+55aFzSM6qhZpM4CCpRNR_LWNCbLyRtQQ3hnPwnRrBdDkwWUw@mail.gmail.com>
 <a5feeaa7-e043-3987-cf23-4090e3eeec4a@torlan.ru>
 <CA+55aFza3_+poqmw34ev+a_jZ1Tz0rxjTu7YfnU4HX-SU52abQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------08D3D26552869C678A565F6E"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFza3_+poqmw34ev+a_jZ1Tz0rxjTu7YfnU4HX-SU52abQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------08D3D26552869C678A565F6E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 08/04/2018 08:04 PM, Linus Torvalds wrote:
> Anyway, just out of curiosity, what was the traceback?
>
> I'm not entirely happy with that patch either (even after the obvious
> fix to add the "1" argument), but it does seem like the minimal
> temporary workaround for now.

Here it is.


--------------08D3D26552869C678A565F6E
Content-Type: text/x-log;
 name="traceback.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="traceback.log"

[   68.313024] ------------[ cut here ]------------
[   68.313030] dm-3
[   68.313049] WARNING: CPU: 1 PID: 77 at block/blk-core.c:2180 generic_make_request_checks+0x4ac/0x600
[   68.313054] Modules linked in: nf_tables xt_cgroup xt_owner kvm_intel iwlmvm kvm irqbypass iwlwifi
[   68.313068] CPU: 1 PID: 77 Comm: kworker/1:1 Not tainted 4.17.9-gentoo #3
[   68.313071] Hardware name: LENOVO 20B6A019RT/20B6A019RT, BIOS GJET91WW (2.41 ) 09/21/2016
[   68.313077] Workqueue: ksnaphd do_metadata
[   68.313083] RIP: 0010:generic_make_request_checks+0x4ac/0x600
[   68.313087] RSP: 0018:ffffc900002e7ba8 EFLAGS: 00010282
[   68.313091] RAX: 0000000000000000 RBX: ffff8801ef6da300 RCX: ffffffff82636218
[   68.313094] RDX: 0000000000000001 RSI: 0000000000000086 RDI: ffffffff82cf57cc
[   68.313097] RBP: ffff880211c2b150 R08: 0000000000000004 R09: 0000000000000307
[   68.313100] R10: ffffc900002e7c80 R11: ffffffff82cf780d R12: 0000000000000000
[   68.313103] R13: 0000000000000001 R14: 0000000000001000 R15: ffff8801ef6da300
[   68.313107] FS:  0000000000000000(0000) GS:ffff88021f240000(0000) knlGS:0000000000000000
[   68.313111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.313114] CR2: 000056166d9e8520 CR3: 0000000003a0a006 CR4: 00000000001606e0
[   68.313117] Call Trace:
[   68.313126]  ? scsi_init_sgtable+0x42/0x80
[   68.313134]  ? kmem_cache_alloc+0x170/0x1a0
[   68.313140]  generic_make_request+0x64/0x400
[   68.313146]  ? submit_bio+0x6c/0x140
[   68.313150]  ? bio_alloc_bioset+0xa9/0x1f0
[   68.313155]  submit_bio+0x6c/0x140
[   68.313160]  ? vm_get_page+0x20/0x50
[   68.313165]  dispatch_io+0x287/0x430
[   68.313171]  ? bio_next_page+0xb0/0xb0
[   68.313175]  ? bio_get_page+0x40/0x40
[   68.313180]  ? cpumask_next+0x16/0x20
[   68.313185]  sync_io+0xc3/0x120
[   68.313191]  dm_io+0x1f8/0x220
[   68.313196]  ? bio_next_page+0xb0/0xb0
[   68.313200]  ? bio_get_page+0x40/0x40
[   68.313204]  ? cpumask_next+0x16/0x20
[   68.313209]  do_metadata+0x1d/0x30
[   68.313216]  process_one_work+0x1b9/0x3e0
[   68.313222]  worker_thread+0x2b/0x3c0
[   68.313227]  ? wq_update_unbound_numa+0x10/0x10
[   68.313232]  kthread+0x113/0x130
[   68.313237]  ? kthread_create_worker_on_cpu+0x70/0x70
[   68.313242]  ret_from_fork+0x35/0x40
[   68.313246] Code: 3e fc ff ff 45 8b a4 24 4c 03 00 00 48 8d 74 24 08 48 89 df c6 05 3a 49 35 01 01 e8 df 68 01 00 48 89 c7 44 89 e6 e8 c4 a0 cd ff <0f> 0b 4c 8b 63 08 e9 0c fc ff ff 80 3d 18 49 35 01 00 0f 85 29 
[   68.313300] ---[ end trace 2a4da4181ebee969 ]---

--------------08D3D26552869C678A565F6E--
