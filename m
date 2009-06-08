From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: oops in kmpathd
Date: Mon, 8 Jun 2009 13:59:03 +0200
Message-ID: <20090608115902.GA10429@schmichrtp.de.ibm.com>
References: <448b15030906031108w2eb66669l6a16b5be9c2fcb3d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <448b15030906031108w2eb66669l6a16b5be9c2fcb3d@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 03, 2009 at 11:08:21AM -0700, David Strand wrote:
> I am running kernel 2.6.29, and saw this kernel oops in kmpathd today.
> Some ports to an FC switch we're activated, and new devices we're
> being found when this occured. It seems to be difficult to duplicate;
> any ideas?
> 
> Jun  2 17:47:13 cs02 kernel: BUG: unable to handle kernel NULL pointer
> dereference at 000000b7
> Jun  2 17:47:13 cs02 kernel: IP: [<f7345f74>] 0xf7345f74
> Jun  2 17:47:13 cs02 kernel: *pde = 00000000
> Jun  2 17:47:14 cs02 kernel: Oops: 0002 [#1] SMP
> Jun  2 17:47:14 cs02 kernel: last sysfs file:
> /sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/host0/rport-0:0-5/target0:0:5/0:0:5:0/block/sdf/dev
> Jun  2 17:47:14 cs02 kernel: Modules linked in: bonding
> Jun  2 17:47:14 cs02 kernel:
> Jun  2 17:47:14 cs02 kernel: Pid: 595, comm: kmpathd/0 Not tainted
> (2.6.29 #2) Sossaman/Lindhrst Allagash Reference Board
> Jun  2 17:47:14 cs02 kernel: EIP: 0060:[<f7345f74>] EFLAGS: 00010282 CPU: 0
> Jun  2 17:47:14 cs02 kernel: EIP is at 0xf7345f74
> Jun  2 17:47:14 cs02 kernel: EAX: f705eb80 EBX: f662d880 ECX: 00000000
> EDX: 000000b7
> Jun  2 17:47:14 cs02 kernel: ESI: f662df80 EDI: 00000282 EBP: f5a7e4f0
> ESP: f7345f78
> Jun  2 17:47:14 cs02 kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Jun  2 17:47:14 cs02 kernel: Process kmpathd/0 (pid: 595, ti=f7344000
> task=f705eb80 task.ti=f7344000)
> Jun  2 17:47:14 cs02 kernel: Stack:
> Jun  2 17:47:14 cs02 kernel: f69fd400 f69fd400 f5a7e4f4 c0137923
> 00000246 f7345fb4 00000001 f69fd410
> Jun  2 17:47:14 cs02 kernel: c03422c0 f69fd410 f69fd418 f69fd400
> f69fd400 f69fd410 c0137cc7 00000000
> Jun  2 17:47:14 cs02 kernel: f705eb80 c013b3a0 f7345fc0 f7345fc0
> c0137c80 f69fd400 00000000 00000000
> Jun  2 17:47:14 cs02 kernel: Call Trace:
> Jun  2 17:47:14 cs02 kernel: [<c0137923>] run_workqueue+0x73/0x120
> Jun  2 17:47:14 cs02 kernel: [<c03422c0>] process_queued_ios+0x0/0x160
> Jun  2 17:47:14 cs02 kernel: [<c0137cc7>] worker_thread+0x47/0x90
> Jun  2 17:47:14 cs02 kernel: [<c013b3a0>] autoremove_wake_function+0x0/0x40
> Jun  2 17:47:14 cs02 kernel: [<c0137c80>] worker_thread+0x0/0x90
> Jun  2 17:47:14 cs02 kernel: [<c013b079>] kthread+0x39/0x70
> Jun  2 17:47:14 cs02 kernel: [<c013b040>] kthread+0x0/0x70
> Jun  2 17:47:14 cs02 kernel: [<c0103f0b>] kernel_thread_helper+0x7/0x1c
> Jun  2 17:47:14 cs02 kernel: Code: 00 00 00 80 df 62 f6 82 02 00 00 f0
> e4 a7 f5 80 eb 05 f7 7b 00 62 f6 7b 00 62 f6 d8 00 a7 f5 ff ff ff ff
> 74 5f 34 f7 60 00 00 00 <82> 02 01 00 00 d4 9f f6 00 d4 9f f6 f4 e4 a7
> f5 23 79 13 c0 46
> Jun  2 17:47:14 cs02 kernel: EIP: [<f7345f74>] 0xf7345f74 SS:ESP 0068:f7345f78
> Jun  2 17:47:14 cs02 kernel: ---[ end trace 256818778cd84edd ]---

This patch might be related:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=17d5c8ca7572124c9623045f24b0c21d4aa2b47f

It is not in 2.6.29, only in 2.6.30. Could you apply this patch and
see if you still hit the same problem?

--
Christof Schmitt
