From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: do not assign error to md->kworker_task
Date: Tue, 18 Oct 2016 14:11:19 -0400
Message-ID: <20161018181119.GA20945@redhat.com>
References: <1476753409-16111-1-git-send-email-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476753409-16111-1-git-send-email-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Oct 17 2016 at  9:16pm -0400,
Tahsin Erdogan <tahsin@google.com> wrote:

> cleanup_mapped_device() calls kthread_stop() if kworker_task is
> non-NULL. Currently the assigned value could be a valid task struct or
> an error code. Do not assign in case of error.
> 
> Example failure when kthread_run() returns -ENOMEM:
> 
> [   22.255939] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
> [   22.258847] IP: [<ffffffff802973a4>] kthread_stop+0x34/0x260
> [   22.260130] PGD 78a23067 PUD 78b56067 PMD 0
> [   22.260130] Oops: 0002 [#1] SMP
> [   22.260130] CPU: 1 PID: 1849 Comm: dmsetup Tainted: G        W 4.8.0+ #3
> [   22.260130] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [   22.260130] task: ffff880078966400 task.stack: ffffc90001898000
> [   22.260130] RIP: 0010:[<ffffffff802973a4>]  [<ffffffff802973a4>] kthread_stop+0x34/0x260
> [   22.260130] RSP: 0018:ffffc9000189bc40  EFLAGS: 00010202
> [   22.260130] RAX: 0000000000000001 RBX: fffffffffffffff4 RCX: 0000000000000003
> [   22.260130] RDX: ffff88007fd18600 RSI: 0000000000000001 RDI: ffffffff81037080
> [   22.260130] RBP: ffffc9000189bc50 R08: 0000000000000000 R09: 0000000000000000
> [   22.260130] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> [   22.260130] R13: 0000000000000001 R14: ffff880077f539d8 R15: 0000000000000004
> [   22.260130] FS:  00007fc9ef2e2840(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
> [   22.260130] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   22.260130] CR2: 000000000000000c CR3: 0000000077fa2000 CR4: 00000000000006e0
> [   22.260130] Stack:
> [   22.260130]  ffff880077f53800 0000000000000000 ffffc9000189bc68 ffffffff808b26fa
> [   22.260130]  ffff880077f53800 ffffc9000189bcb0 ffffffff808b3c58 0000000000000000
> [   22.260130]  00000000808b534b ffffc9000189bd20 ffff880077f53800 0000000000000000
> [   22.260130] Call Trace:
> [   22.260130]  [<ffffffff808b26fa>] cleanup_mapped_device+0x2a/0xe0
> [   22.260130]  [<ffffffff808b3c58>] __dm_destroy+0x1a8/0x2b0
> [   22.260130]  [<ffffffff808b4b6e>] dm_destroy+0xe/0x10
> [   22.260130]  [<ffffffff808b9f49>] dev_remove+0xd9/0x120
> [   22.260130]  [<ffffffff808b9e70>] ? dev_suspend+0x210/0x210
> [   22.260130]  [<ffffffff808ba576>] ctl_ioctl+0x206/0x500
> [   22.260130]  [<ffffffff808ba87e>] dm_ctl_ioctl+0xe/0x20
> [   22.260130]  [<ffffffff803bca40>] do_vfs_ioctl+0x90/0x6b0
> [   22.260130]  [<ffffffff80b11fd7>] ?  entry_SYSCALL_64_fastpath+0x5/0xad
> [   22.260130]  [<ffffffff802bd974>] ?  trace_hardirqs_on_caller+0xf4/0x1c0
> [   22.260130]  [<ffffffff803bd0d4>] SyS_ioctl+0x74/0x80
> [   22.260130]  [<ffffffff80b11fea>] entry_SYSCALL_64_fastpath+0x18/0xad
> [   22.260130] Code: e5 41 54 85 c0 53 48 89 fb 0f 8f bb 01 00 00 65 8b
> 05 a1 2d d7 7f 89 c0 48 0f a3 05 9f 94 e8 00 0f 92 c0 84 c0 0f 85 a3 00
> 00 00 <f0> ff 43 18 48 89 df e8 10 f8 ff ff 48 85 c0 49 89 c4 74 29 f0
> [   22.260130] RIP  [<ffffffff802973a4>] kthread_stop+0x34/0x260
> [   22.260130]  RSP <ffffc9000189bc40>
> [   22.260130] CR2: 000000000000000c
> [   22.301062] ---[ end trace 22b4f4f62c04f3cf ]---
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks for the patch but I elected to fix this issue a slightly
different way, please see this commit staged for 4.9-rcX:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.9&id=937fa62e8a00d0b4bc2c0a40567d7c88ab2b2e8d

(also, your mail reminds me that I _really_ need to fix
get_maintainer.pl to _not_ pull in linux-raid and shli for DM-specific
changes!)
