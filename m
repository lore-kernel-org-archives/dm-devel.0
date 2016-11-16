From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] dm-mpath: Fix a race condition in the
	blk-mq path
Date: Wed, 16 Nov 2016 14:32:10 -0500
Message-ID: <20161116193209.GA24333@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<05d83937-9fcc-7bee-8507-fd59ec25ec7f@suse.de>
	<20161116145630.GB23071@redhat.com>
	<96c1db57-deee-491c-94b1-39eb9e35f9b2@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <96c1db57-deee-491c-94b1-39eb9e35f9b2@sandisk.com>
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

On Wed, Nov 16 2016 at  1:22pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 11/16/2016 06:56 AM, Mike Snitzer wrote:
> >7 is not acceptable.  It complicates the code for no reason (the
> >scenario that it is meant to address isn't possible).
> 
> Hello Mike,
> 
> With patch (a) applied I see warning (b) appear a few seconds after
> I start test 02-sq from the srp-test suite. I think that shows that
> something like patch (7) is really needed. Please let me know if you
> need more information about my test setup.
> 
> Bart.
> 
> 
> (a)
> 
> @@ -568,8 +568,10 @@ static int __multipath_map(struct dm_target
> *ti, struct requ
> est *clone,
>          * multiqueue path is added before __multipath_map() is called. If
>          * that happens requeue to trigger unprepare and reprepare.
>          */
> -       if ((clone && q->mq_ops) || (!clone && !q->mq_ops))
> +       if ((clone && q->mq_ops) || (!clone && !q->mq_ops)) {
> +               WARN_ON_ONCE(true);
>                 return r;
> +       }
> 
>         mpio = set_mpio(m, map_context);
>         if (!mpio)
> 
> (b)
> 
> ------------[ cut here ]------------
> WARNING: CPU: 9 PID: 542 at drivers/md/dm-mpath.c:584
> __multipath_map.isra.15+0x1e2/0x390 [dm_multipath]
> Modules linked in: ib_srp scsi_transport_srp ib_srpt(O)
> scst_vdisk(O) scst(O) dlm libcrc32c brd dm_service_time netconsole
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_conn track nf_conntrack ipt_REJECT xt_tcpudp tun bridge stp llc
> ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
> ip_tables x_tables af_packet ib_ipoib rdma_ucm ib_ucm ib_uverbs msr
> ib_umad rdma_cm configfs ib_cm iw_cm mlx4_ib ib_core sb_edac
> edac_core x86_pkg_temp_thermal coretemp kvm_intel kvm ipmi_ssif
> ipmi_devintf mlx4_core irqbypass hid_generic crct10dif_pclmul
> crc32_pclmul usbhid ghash_clmulni_intel aesni_intel aes_x86_64 lrw
> tg3 gf128mul glue_helper iTCO_wdt ptp iTCO_vendor_support pps_core
> dcdbas ablk_helper pcspkr ipmi_si libphy cryptd mei_me
> ipmi_msghandler fjes tpm_tis mei tpm_tis_core tpm lpc_ich shpchp
> mfd_core wmi button mgag200 i2c_algo_bit drm_kms_helper syscopyarea
> sysfillrect sysimgblt fb_sys_fops ttm drm sr_mod cdrom crc32c_intel
> ehci_pci ehci_hcd usbcore usb_common sg dm_multipath dm_mod
> scsi_dh_rdac scsi_dh_emc scsi_dh_alua [last unloaded: brd]
> CPU: 9 PID: 542 Comm: kworker/9:1H Tainted: G           O
> 4.9.0-rc5-dbg+ #1
> Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
> Workqueue: kblockd blk_mq_requeue_work
>  ffffc9000251fb08 ffffffff81329555 0000000000000000 0000000000000000
>  ffffc9000251fb48 ffffffff81064a56 0000024800000000 ffff8803f2a3ba78
>  ffff8803f2a32758 0000000000000000 ffff8804519de528 0000000000000000
> Call Trace:
>  [<ffffffff81329555>] dump_stack+0x68/0x93
>  [<ffffffff81064a56>] __warn+0xc6/0xe0
>  [<ffffffff81064b28>] warn_slowpath_null+0x18/0x20
>  [<ffffffffa0046372>] __multipath_map.isra.15+0x1e2/0x390 [dm_multipath]
>  [<ffffffffa0046535>] multipath_clone_and_map+0x15/0x20 [dm_multipath]
>  [<ffffffffa002a3ed>] map_request+0x14d/0x3a0 [dm_mod]
>  [<ffffffffa002a6e7>] dm_mq_queue_rq+0x77/0x110 [dm_mod]
>  [<ffffffff8131083f>] blk_mq_process_rq_list+0x23f/0x340
>  [<ffffffff81310a62>] __blk_mq_run_hw_queue+0x122/0x1c0
>  [<ffffffff81310a1e>] ? __blk_mq_run_hw_queue+0xde/0x1c0
>  [<ffffffff813105df>] blk_mq_run_hw_queue+0x9f/0xc0
>  [<ffffffff81310bae>] blk_mq_run_hw_queues+0x6e/0x90
>  [<ffffffff81312b37>] blk_mq_requeue_work+0xf7/0x110
>  [<ffffffff81082ab5>] process_one_work+0x1f5/0x690
>  [<ffffffff81082a3a>] ? process_one_work+0x17a/0x690
>  [<ffffffff81082f99>] worker_thread+0x49/0x490
>  [<ffffffff81082f50>] ? process_one_work+0x690/0x690
>  [<ffffffff81082f50>] ? process_one_work+0x690/0x690
>  [<ffffffff8108983b>] kthread+0xeb/0x110
>  [<ffffffff81089750>] ? kthread_park+0x60/0x60
>  [<ffffffff8163ef87>] ret_from_fork+0x27/0x40
> ---[ end trace 81cfd74742407be1 ]---

Glad you tried this, I was going to ask you to.

It'd be nice to verify, but I assume it is this half of the conditional
that is triggering: (!clone && !q->mq_ops)

This speaks to a race with cleanup of the underlying path while the
top-level blk-mq request_queue is in ->queue_rq

If that is in fact the case then I'd imagine that the underlying path's
request_queue should be marked as dying?  Wouldn't it be better to check
for that, rather than looking for a side-effect of a request_queue being
torn down (rather that ->mq_ops being NULL, though it isn't clear to me
what would be causing ->mq_ops to be NULL either)?  Anyway, my point is
we need to _know_ what is causing this to trigger.  What part of the
life-cycle is the underlying path's request_queue in?

BTW< Laurence is the one who has a testbed that can run your testsuite.
I can coordinate with him if need be but I'd prefer it if you could dig
into this the last 5%.  Apologies for being prickly yesterday, I held
certain aspects of the IO stack to be infallible.  Reality is code
evolves and bugs/regressions happen.  We just need to pin it down.

Thanks,
Mike
