From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 4.5-rc1 multipath regression
Date: Tue, 9 Feb 2016 11:40:14 -0500
Message-ID: <20160209164013.GA22101@redhat.com>
References: <56AAA6AE.1060802@sandisk.com> <56ABB279.5020609@sandisk.com>
	<20160130000657.GA14034@redhat.com> <56B8DB94.10404@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B8DB94.10404@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 08 2016 at  1:16pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 01/29/2016 04:07 PM, Mike Snitzer wrote:
> > On Fri, Jan 29 2016 at  1:42pm -0500,
> > Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> >> On 01/28/2016 03:39 PM, Bart Van Assche wrote:
> >>> There is a regression in the 4.5-rc1 kernel with regard to multipath
> >>> setup. On my SRP I usually use for these tests after a few minutes a
> >>> kernel crash occurs and the console freezes. A screenshot has been attached.
> >>
> >> (replying to my own e-mail)
> > 
> > Not sure where you sent your first email.. not seeing it on dm-devel
> > archives.
> > 
> > So I don't have the original screenshot you attached.
> > 
> > The 4.5 merge window didn't see any changes to DM mpath or DM core.  So
> > any regression is very likely outside DM and rooted in SRP or whatever
> > other dependencies your setup relies on.
> 
> Hello Mike,
> 
> The behavior I see with kernel v4.5-rc3 is different of what I saw with
> v4.5-rc1 but it still is not the behavior I expect. The call trace that
> was triggered this morning on my test setup can be found below. I assume
> the information below means that the tio->ti->type is NULL in dm_done() ?

Yes, looks like it:

crash> struct -o target_type
struct target_type {
   [0x0] uint64_t features;
   [0x8] const char *name;
  [0x10] struct module *module;
  [0x18] unsigned int version[3];
  [0x28] dm_ctr_fn ctr;
  [0x30] dm_dtr_fn dtr;
  [0x38] dm_map_fn map;
  [0x40] dm_map_request_fn map_rq;
  [0x48] dm_clone_and_map_request_fn clone_and_map_rq;
  [0x50] dm_release_clone_request_fn release_clone_rq;
  [0x58] dm_endio_fn end_io;
  [0x60] dm_request_endio_fn rq_end_io;
  ...

Not aware of any use-after-free issues in request-based DM.  But this
report clearly speaks to one.  If you're using blk-mq then the tio is
part of the pdu (so that explains why dereferencing tio isn't a
problem).  But somehow tio->ti is being reset to NULL early (init_tio
does reset it, but not until a new request comes in via dm_mq_queue_rq).

Anyway, certainly strange.

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> IP: [<ffffffffa00020e5>] dm_done+0x35/0x1b0 [dm_mod]
> PGD 456993067 PUD 40c76a067 PMD 0 
> Oops: 0000 [#1] SMP 
> Modules linked in: scsi_dh_alua dm_queue_length netconsole autofs4 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm configfs ib_cm iw_cm dm_round_robin dm_multipath iTCO_wdt iTCO_vendor_support ipmi_devintf dcdbas ipmi_si ipmi_msghandler sb_edac edac_core lpc_ich mfd_core tg3 libphy ptp pps_core sg wmi ext4(E) jbd2(E) mbcache(E) sr_mod(E) cdrom(E) sd_mod(E) ahci(E) libahci(E) mlx4_ib(E) ib_sa(E) ib_mad(E) ib_core(E) ib_addr(E) ipv6(E) mlx4_core(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
> CPU: 0 PID: 618 Comm: kworker/0:1H Tainted: G            E   4.5.0-rc3+ #3
> Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
> Workqueue: kblockd blk_mq_run_work_fn
> task: ffff880437fa5e80 ti: ffff880437a6c000 task.ti: ffff880437a6c000
> RIP: 0010:[<ffffffffa00020e5>]  [<ffffffffa00020e5>] dm_done+0x35/0x1b0 [dm_mod]
> RSP: 0018:ffff88046e403e38  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff8803f6a98d70 RCX: dead000000000200
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffc9000933c040
> sd 23:0:0:1: Asymmetric access state changed
> device-mapper: multipath: Failing path 67:176.
> device-mapper: multipath: Failing path 68:16.
> sd 24:0:0:1: Asymmetric access state changed
> RBP: ffff88046e403e78 R08: ffff8803f6a98c78 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88006c0f2680
> R13: ffff8803f6a98c00 R14: ffff88046e403ec8 R15: 0000000000000005
> FS:  0000000000000000(0000) GS:ffff88046e400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000060 CR3: 000000041defd000 CR4: 00000000001406f0
> Stack:
>  0000000000000003 0000000000000002 ffff88046e403e78 ffff8803f6a98d70
>  ffff8803f6a98c00 ffff8803f6a98c00 ffff88046e403ec8 0000000000000005
>  ffff88046e403ea8 ffffffffa00022ac ffffffff81a090e0 ffff8803f6a98c78
> Call Trace:
>  <IRQ> 
>  [<ffffffffa00022ac>] dm_softirq_done+0x4c/0xd0 [dm_mod]
>  [<ffffffff812476ac>] blk_done_softirq+0x8c/0xb0
>  [<ffffffff8105be66>] __do_softirq+0xf6/0x240
>  [<ffffffff8105c0bc>] irq_exit+0xac/0xc0
>  [<ffffffff8103afde>] smp_call_function_single_interrupt+0x2e/0x40
>  [<ffffffff81535779>] call_function_single_interrupt+0x89/0x90
>  <EOI> 
>  [<ffffffff8153422d>] ? _raw_spin_unlock_irqrestore+0x3d/0x60
>  [<ffffffffa03515bc>] multipath_busy+0xcc/0xf0 [dm_multipath]
>  [<ffffffffa00045bd>] dm_mq_queue_rq+0x7d/0x180 [dm_mod]
>  [<ffffffff81249cdb>] __blk_mq_run_hw_queue+0x29b/0x490
>  [<ffffffff810a5fd3>] ? __lock_acquire+0x3b3/0x560
>  [<ffffffff81249f10>] blk_mq_run_work_fn+0x10/0x20
>  [<ffffffff810723ea>] process_one_work+0x1da/0x480
>  [<ffffffff8107237a>] ? process_one_work+0x16a/0x480
>  [<ffffffff810a62c4>] ? __lock_release+0xc4/0x3a0
>  [<ffffffff81072f39>] worker_thread+0x169/0x520
>  [<ffffffff81099d58>] ? complete+0x48/0x60
>  [<ffffffff8153422b>] ? _raw_spin_unlock_irqrestore+0x3b/0x60
>  [<ffffffff81072dd0>] ? maybe_create_worker+0x110/0x110
>  [<ffffffff81072dd0>] ? maybe_create_worker+0x110/0x110
>  [<ffffffff8152ee92>] ? schedule+0x42/0xb0
>  [<ffffffff81072dd0>] ? maybe_create_worker+0x110/0x110
>  [<ffffffff81078f94>] kthread+0xe4/0x100
>  [<ffffffff810a4dcd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81081c99>] ? schedule_tail+0x19/0xd0
>  [<ffffffff81078eb0>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff8153497f>] ret_from_fork+0x3f/0x70
>  [<ffffffff81078eb0>] ? __init_kthread_worker+0x70/0x70
> Code: 65 e0 48 89 5d d8 49 89 fc 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 48 8b 9f 60 01 00 00 48 8b 7b 08 48 85 ff 74 0c 48 8b 47 08 84 d2 <4c> 8b 40 60 75 44 41 89 f5 41 83 fd 87 0f 84 f2 00 00 00 45 85 
> RIP  [<ffffffffa00020e5>] dm_done+0x35/0x1b0 [dm_mod]
>  RSP <ffff88046e403e38>
> CR2: 0000000000000060
> ---[ end trace f47c39416952f73a ]---
> sd 31:0:0:1: Asymmetric access state changed
> Kernel panic - not syncing: Fatal exception in interrupt
> Kernel Offset: disabled
> ---[ end Kernel panic - not syncing: Fatal exception in interrupt
> 
> 
> $ gdb drivers/md/dm-mod.o
> (gdb) list *(dm_done+0x35)
> 0x20e5 is in dm_done (drivers/md/dm.c:1273).
> 1268            int r = error;
> 1269            struct dm_rq_target_io *tio = clone->end_io_data;
> 1270            dm_request_endio_fn rq_end_io = NULL;
> 1271
> 1272            if (tio->ti) {
> 1273                    rq_end_io = tio->ti->type->rq_end_io;
> 1274
> 1275                    if (mapped && rq_end_io)
> 1276                            r = rq_end_io(tio->ti, clone, error, &tio->info);
> 1277            }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
