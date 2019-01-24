From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH] block: Fix a WRITE SAME BUG_ON
Date: Thu, 24 Jan 2019 13:23:51 +0100
Message-ID: <CAMeeMh_qaLMzLUEPWFvycUqcdtRxsgKnr98Y7C6gsnVt2QWP-Q@mail.gmail.com>
References: <20190124121315.6737-1-zhangxiaoxu5@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1537610022804977430=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190124121315.6737-1-zhangxiaoxu5@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org
List-Id: dm-devel.ids

--===============1537610022804977430==
Content-Type: multipart/alternative; boundary="00000000000039fcd405803349ac"

--00000000000039fcd405803349ac
Content-Type: text/plain; charset="UTF-8"

Adding dm-devel since it involves LVM.

On Thu, Jan 24, 2019 at 1:14 PM Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
wrote:

> If the lvm is stacked by different logical_block_size disks,
> when WRITE SAME on it, will bug_on:
>
> kernel BUG at drivers/scsi/sd.c:968!
> invalid opcode: 0000 [#1] SMP PTI
> CPU: 11 PID: 525 Comm: kworker/11:1H Tainted: G           O
> 5.0.0-rc3+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27
> 04/01/2014
> Workqueue: kblockd blk_mq_run_work_fn
> RIP: 0010:sd_init_command+0x7aa/0xdb0
> Code: 30 75 00 00 c7 85 44 01 00 00 18 00 00 00 0f 85 fa 04 00 00 48 83 c4
> 40 48
>       89 df 5b 5d 41 5c 41 5d 41 5e 41 5f e9 b6 ca fe ff <0f> 0b 41 bc 09
> RSP: 0018:ffffb55f80ddbca0 EFLAGS: 00010206
> RAX: 0000000000001000 RBX: ffff9ed23fb927a0 RCX: 000000000000f000
> RDX: ffff9ed23f0a8400 RSI: ffff9ed27bc79800 RDI: 0000000000000000
> RBP: ffff9ed23fb92680 R08: ffff9ed27c8c0000 R09: ffff9ed23fb927d8
> R10: 0000000000000000 R11: fefefefefefefeff R12: ffff9ed27bc79800
> R13: ffff9ed2787a0000 R14: ffff9ed27bdf3400 R15: ffff9ed23fb927a0
> FS:  0000000000000000(0000) GS:ffff9ed27c8c0000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f6b14cf9341 CR3: 0000000069058000 CR4: 00000000000006e0
> Call Trace:
>  ? vp_notify+0x12/0x20
>  scsi_queue_rq+0x525/0xa30
>  blk_mq_dispatch_rq_list+0x8d/0x580
>  ? syscall_return_via_sysret+0x10/0x7f
>  ? elv_rb_del+0x1f/0x30
>  ? deadline_remove_request+0x55/0xc0
>  blk_mq_do_dispatch_sched+0x76/0x110
>  blk_mq_sched_dispatch_requests+0xf9/0x170
>  __blk_mq_run_hw_queue+0x51/0xd0
>  process_one_work+0x195/0x380
>  worker_thread+0x30/0x390
>  ? process_one_work+0x380/0x380
>  kthread+0x113/0x130
>  ? kthread_park+0x90/0x90
>  ret_from_fork+0x35/0x40
> Modules linked in: alloc(O+)
> ---[ end trace dc92ddeb2e6d1fe5 ]---
>
> The logical_block_size of the LVM is the max value of the sub disks,
> it maybe different with one of the sub disk. when WRITE SAME on the
> disk, it will BUG_ON when setup WRITE SAME cmd.
>
> Close WRITE_SAME feature on the LVM if it was stacked by different
> logical_block_size disk.
>
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  block/blk-settings.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 3e7038e475ee..e1695155ad61 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -537,6 +537,10 @@ int blk_stack_limits(struct queue_limits *t, struct
> queue_limits *b,
>                 }
>         }
>
> +       /* If the logical block size is different, forbid write same */
> +       if (t->logical_block_size != b->logical_block_size)
> +               t->max_write_same_sectors = 0;
> +
>         t->logical_block_size = max(t->logical_block_size,
>                                     b->logical_block_size);
>
> --
> 2.14.4
>
>

--00000000000039fcd405803349ac
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Adding dm-devel since it involves LVM.<br></div></div=
><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail-m_657265225=
312649470gmail_attr">On Thu, Jan 24, 2019 at 1:14 PM Zhang Xiaoxu &lt;<a hr=
ef=3D"mailto:zhangxiaoxu5@huawei.com" target=3D"_blank">zhangxiaoxu5@huawei=
.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">If the lvm is stacked by different logical_block_size disks,<br>
when WRITE SAME on it, will bug_on:<br>
<br>
kernel BUG at drivers/scsi/sd.c:968!<br>
invalid opcode: 0000 [#1] SMP PTI<br>
CPU: 11 PID: 525 Comm: kworker/11:1H Tainted: G=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0O=C2=A0 =C2=A0 =C2=A0 5.0.0-rc3+ #2<br>
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 0=
4/01/2014<br>
Workqueue: kblockd blk_mq_run_work_fn<br>
RIP: 0010:sd_init_command+0x7aa/0xdb0<br>
Code: 30 75 00 00 c7 85 44 01 00 00 18 00 00 00 0f 85 fa 04 00 00 48 83 c4 =
40 48<br>
=C2=A0 =C2=A0 =C2=A0 89 df 5b 5d 41 5c 41 5d 41 5e 41 5f e9 b6 ca fe ff &lt=
;0f&gt; 0b 41 bc 09<br>
RSP: 0018:ffffb55f80ddbca0 EFLAGS: 00010206<br>
RAX: 0000000000001000 RBX: ffff9ed23fb927a0 RCX: 000000000000f000<br>
RDX: ffff9ed23f0a8400 RSI: ffff9ed27bc79800 RDI: 0000000000000000<br>
RBP: ffff9ed23fb92680 R08: ffff9ed27c8c0000 R09: ffff9ed23fb927d8<br>
R10: 0000000000000000 R11: fefefefefefefeff R12: ffff9ed27bc79800<br>
R13: ffff9ed2787a0000 R14: ffff9ed27bdf3400 R15: ffff9ed23fb927a0<br>
FS:=C2=A0 0000000000000000(0000) GS:ffff9ed27c8c0000(0000) knlGS:0000000000=
000000<br>
CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033<br>
CR2: 00007f6b14cf9341 CR3: 0000000069058000 CR4: 00000000000006e0<br>
Call Trace:<br>
=C2=A0? vp_notify+0x12/0x20<br>
=C2=A0scsi_queue_rq+0x525/0xa30<br>
=C2=A0blk_mq_dispatch_rq_list+0x8d/0x580<br>
=C2=A0? syscall_return_via_sysret+0x10/0x7f<br>
=C2=A0? elv_rb_del+0x1f/0x30<br>
=C2=A0? deadline_remove_request+0x55/0xc0<br>
=C2=A0blk_mq_do_dispatch_sched+0x76/0x110<br>
=C2=A0blk_mq_sched_dispatch_requests+0xf9/0x170<br>
=C2=A0__blk_mq_run_hw_queue+0x51/0xd0<br>
=C2=A0process_one_work+0x195/0x380<br>
=C2=A0worker_thread+0x30/0x390<br>
=C2=A0? process_one_work+0x380/0x380<br>
=C2=A0kthread+0x113/0x130<br>
=C2=A0? kthread_park+0x90/0x90<br>
=C2=A0ret_from_fork+0x35/0x40<br>
Modules linked in: alloc(O+)<br>
---[ end trace dc92ddeb2e6d1fe5 ]---<br>
<br>
The logical_block_size of the LVM is the max value of the sub disks,<br>
it maybe different with one of the sub disk. when WRITE SAME on the<br>
disk, it will BUG_ON when setup WRITE SAME cmd.<br>
<br>
Close WRITE_SAME feature on the LVM if it was stacked by different<br>
logical_block_size disk.<br>
<br>
Signed-off-by: Zhang Xiaoxu &lt;<a href=3D"mailto:zhangxiaoxu5@huawei.com" =
target=3D"_blank">zhangxiaoxu5@huawei.com</a>&gt;<br>
---<br>
=C2=A0block/blk-settings.c | 4 ++++<br>
=C2=A01 file changed, 4 insertions(+)<br>
<br>
diff --git a/block/blk-settings.c b/block/blk-settings.c<br>
index 3e7038e475ee..e1695155ad61 100644<br>
--- a/block/blk-settings.c<br>
+++ b/block/blk-settings.c<br>
@@ -537,6 +537,10 @@ int blk_stack_limits(struct queue_limits *t, struct qu=
eue_limits *b,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* If the logical block size is different, forb=
id write same */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (t-&gt;logical_block_size !=3D b-&gt;logical=
_block_size)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0t-&gt;max_write_sam=
e_sectors =3D 0;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 t-&gt;logical_block_size =3D max(t-&gt;logical_=
block_size,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b-&gt;logical_block_si=
ze);<br>
<br>
-- <br>
2.14.4<br>
<br>
</blockquote></div>

--00000000000039fcd405803349ac--


--===============1537610022804977430==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1537610022804977430==--
