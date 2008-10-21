From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Calltrace in dm-snapshot in 2.6.27 kernel
Date: Tue, 21 Oct 2008 09:55:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0810210953560.12983@hs20-bc2-1.build.redhat.com>
References: <48FC23DE.5040000@poczta.onet.pl> <48FC4498.5070706@redhat.com>
	<48FD7911.1000705@poczta.onet.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48FD7911.1000705@poczta.onet.pl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi

Please send me files mm/mempool.o and driver/md/*.o from these two 
kernels, that crashed with these oopses. So that I can see more precisely, 
where it happened.

Mikulas

On Tue, 21 Oct 2008, aluno3@poczta.onet.pl wrote:

> Hi Milan,
> 
> Thanks for the patch. I've applied it on 2.6.27 but it looks like we're
> still having the same problem. We've tested it on both 32 and 64 bit
> kernels - and on both of them the problem occurs, but in different way.
> 
> Here there are calltraces from both kernels (32 and 64 bit):
> 
> 
> 32 bit one:
> 
> BUG: unable to handle kernel paging request at 08048000
> IP: [<c05263f9>] _spin_lock_irqsave+0x9/0x20
> *pdpt = 000000000c438001 *pde = 000000007f997067
> Oops: 0003 [#1] SMP
> Modules linked in: sg st iscsi_trgt drbd bonding iscsi_tcp libiscsi
> scsi_transport_iscsi 3w_9xxx sata_nv forcedeth button ftdi_sio usbserial
> 
> Pid: 30618, comm: kcopyd Not tainted (2.6.27-32#1)
> EIP: 0060:[<c05263f9>] EFLAGS: 00010097 CPU: 0
> EIP is at _spin_lock_irqsave+0x9/0x20
> EAX: 08048000 EBX: 08048000 ECX: 00000297 EDX: 00000100
> ESI: eb602148 EDI: eb53cb40 EBP: 00000000 ESP: f11f7ea0
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kcopyd (pid: 30618, ti=f11f6000 task=f5065580 task.ti=f11f6000)
> Stack: c015a57f eb602148 eb641d08 eb53cb40 c044ca4a eb641d08 00000000
> f29a5080
>        c044cb07 00000002 00000000 eb8dd540 00000000 c044ddb3 00057803
> 00000000
>        000001f5 00000000 f2728108 f29a5080 00000000 c044cba0 f2728108
> ed016370
> Call Trace:
>  [<c015a57f>] mempool_free+0x1f/0x70
>  [<c044ca4a>] put_pending_exception+0x5a/0x60
>  [<c044cb07>] pending_complete+0xb7/0x110
>  [<c044ddb3>] persistent_commit+0xe3/0x110
>  [<c044cba0>] copy_callback+0x30/0x40
>  [<c0447d04>] segment_complete+0x154/0x1d0
>  [<c0447935>] run_complete_job+0x45/0x80
>  [<c0447bb0>] segment_complete+0x0/0x1d0
>  [<c04478f0>] run_complete_job+0x0/0x80
>  [<c0447af4>] process_jobs+0x14/0x70
>  [<c0447b50>] do_work+0x0/0x40
>  [<c0447b66>] do_work+0x16/0x40
>  [<c013509d>] run_workqueue+0x4d/0xf0
>  [<c01351bd>] worker_thread+0x7d/0xc0
>  [<c0138350>] autoremove_wake_function+0x0/0x30
>  [<c0524efc>] __sched_text_start+0x1ec/0x4b0
>  [<c0138350>] autoremove_wake_function+0x0/0x30
>  [<c0121a9b>] complete+0x2b/0x40
>  [<c0135140>] worker_thread+0x0/0xc0
>  [<c0137e24>] kthread+0x44/0x70
>  [<c0137de0>] kthread+0x0/0x70
>  [<c0104c57>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: 89 c8 c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 90 83 28 01
> 79 05 e8 25 ff ff ff c3 8d 74 26 00 9c 59 fa ba 00 01 00 00 90 <66> 0f
> c1 10 38 f2 74 06 f3 90 8a 10 eb f6 89 c8 c3 8d b6 00 00
> EIP: [<c05263f9>] _spin_lock_irqsave+0x9/0x20 SS:ESP 0068:f11f7ea0
> ---[ end trace b3493777a8378781 ]---
> 
> 
> 
> 64 bit one:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<0000000000000000>] 0x0
> PGD 6e88e067 PUD 53f6f067 PMD 0
> Oops: 0000 [1] SMP
> CPU 1
> Modules linked in: iscsi_trgt drbd bonding iscsi_tcp libiscsi
> scsi_transport_iscsi megaraid_mbox megaraid_mm sky2 skge button ftdi_sio
> usbserial
> Pid: 13724, comm: kcopyd Not tainted 2.6.27-64#3
> RIP: 0010:[<0000000000000000>]  [<0000000000000000>] 0x0
> RSP: 0000:ffff880000b83d18  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff88002626fba8 RCX: 0000000000000001
> RDX: ffff8800761d4208 RSI: 8000000000000000 RDI: ffff88002626fba8
> RBP: ffff8800399e4000 R08: ffffc20005e1e130 R09: 00ffffffffffffff
> R10: 0100000000000000 R11: 0000000000000000 R12: ffff880030087c88
> R13: 0000000000000000 R14: ffff88002c14f440 R15: ffff8800399e4118
> FS:  0000000000000000(0000) GS:ffff88007f473dc0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000002a7d9000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kcopyd (pid: 13724, threadinfo ffff880000b82000, task
> ffff88007f58cf30)
> Stack:  ffffffff805c2eae 0000000000000400 0000000000000001 ffff8800561a55c0
>  0000000000000000 ffff880038c1f978 0000000000000400 0000000000000000
>  ffffffff805c4130 0000000000001425 000000000000062a 0000000000000082
> Call Trace:
>  [<ffffffff805c2eae>] ? pending_complete+0x1ee/0x230
>  [<ffffffff805c4130>] ? persistent_commit+0xe0/0x130
>  [<ffffffff805bd8a3>] ? segment_complete+0x183/0x1c0
>  [<ffffffff805bd720>] ? segment_complete+0x0/0x1c0
>  [<ffffffff805bd385>] ? run_complete_job+0x65/0xb0
>  [<ffffffff805bd320>] ? run_complete_job+0x0/0xb0
>  [<ffffffff805bd5d6>] ? process_jobs+0x26/0xe0
>  [<ffffffff805bd690>] ? do_work+0x0/0x60
>  [<ffffffff805bd6b8>] ? do_work+0x28/0x60
>  [<ffffffff8024686a>] ? run_workqueue+0x5a/0x110
>  [<ffffffff802469bc>] ? worker_thread+0x9c/0xf0
>  [<ffffffff8024a620>] ? autoremove_wake_function+0x0/0x30
>  [<ffffffff8024a620>] ? autoremove_wake_function+0x0/0x30
>  [<ffffffff80246920>] ? worker_thread+0x0/0xf0
>  [<ffffffff80249f0c>] ? kthread+0x6c/0xa0
>  [<ffffffff8020d1c9>] ? child_rip+0xa/0x11
>  [<ffffffff8021b5f0>] ? lapic_next_event+0x0/0x10
>  [<ffffffff80249ea0>] ? kthread+0x0/0xa0
>  [<ffffffff8020d1bf>] ? child_rip+0x0/0x11
> 
> 
> Code:  Bad RIP value.
> RIP  [<0000000000000000>] 0x0
>  RSP <ffff880000b83d18>
> CR2: 0000000000000000
> ---[ end trace 03b26540ec781e73 ]---
> 
> 
> 
> Any other suggestions?
> 
> Best
> 
> Milan Broz wrote:
> > aluno3@poczta.onet.pl wrote:
> >   
> >> I've got this calltrace from our QA team. They say that they mad few
> >> snapshots, run several programs like bacula or rsync and that calltrace
> >> is appearing about 1 hour after starting those programs.
> >>     
> >
> > Hi,
> > if it is reproducible, please can you try if this patch helps?
> > http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-snapshot-fix-primary_pe-race.patch
> >
> > Probably the same problem reported here
> > http://bugzilla.kernel.org/show_bug.cgi?id=11636
> >
> > (Added Mikulas to CC)
> >
> > Milan
> > --
> > mbroz@redhat.com
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
> >   
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
