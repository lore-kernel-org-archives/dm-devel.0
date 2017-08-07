From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 00/20] blk-mq-sched: improve SCSI-MQ performance
Date: Tue, 8 Aug 2017 07:04:25 +0800
Message-ID: <20170807230419.GA30140@ming.t460p>
References: <20170805065705.12989-1-ming.lei@redhat.com>
 <df64b15d-a443-553c-a3c6-d834320648fd@redhat.com>
 <1502119672.6219.1.camel@wdc.com>
 <839ff581-6e8b-6d9c-6f85-28770fb96107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <839ff581-6e8b-6d9c-6f85-28770fb96107@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Aug 07, 2017 at 01:29:41PM -0400, Laurence Oberman wrote:
> 
> 
> On 08/07/2017 11:27 AM, Bart Van Assche wrote:
> > On Mon, 2017-08-07 at 08:48 -0400, Laurence Oberman wrote:
> > > I tested this series using Ming's tests as well as my own set of tests
> > > typically run against changes to upstream code in my SRP test-bed.
> > > My tests also include very large sequential buffered and un-buffered I/O.
> > > 
> > > This series seems to be fine for me. I did uncover another issue that is
> > > unrelated to these patches and also exists in 4.13-RC3 generic that I am
> > > still debugging.
> > 
> > Hello Laurence,
> > 
> > What kind of tests did you run? Only functional tests or also performance
> > tests?
> > 
> > Has the issue you encountered with kernel 4.13-rc3 already been reported on
> > the linux-rdma mailing list?
> > 
> > Thanks,
> > 
> > Bart.
> > 
> 
> Hi Bart
> 
> Actually I was focusing on just performance to see if we had any regressions
> with Mings new patches for the large sequential I/O cases.
> 
> Ming had already tested the small I/O performance cases so I was making sure
> the large I/O sequential tests did not suffer.
> 
> The 4MB un-buffered direct read tests to DM devices seems to perform much
> the same in my test bed.
> The 4MB buffered and un-buffered 4MB writes also seem to be well behaved
> with not much improvement.

As I described, this patch improves I/O scheduling, especially it
improves I/O merge in sequential I/O. BLK_DEF_MAX_SECTORS is defined
as 2560(1280K), it is expected that this patch can't help the 4M I/O
because there isn't no merge for 4MB I/O.

But the result is still positive, since there isn't regression with
patchset.

> 
> These were not exhaustive tests and did not include my usual port disconnect
> and recovery tests either.
> I was just making sure we did not regress with Ming's changes.
> 
> I was only just starting to baseline test the mq-deadline scheduler as prior
> to 4.13-RC3 I had not been testing any of the new MQ schedulers.
> I had always only tested with [none]
> 
> The tests were with [none] and [mq-deadline]
> 
> The new issue I started seeing was not yet reported yet as I was still
> investigating it.
> 
> In summary:
> With buffered writes we see the clone fail in blk_get_request in both Mings
> kernel and in the upstream 4.13-RC3 stock kernel
> 
> [  885.271451] io scheduler mq-deadline registered
> [  898.455442] device-mapper: multipath: blk_get_request() returned -11 -
> requeuing

-11 is -EAGAIN, and it isn't a error.

GFP_ATOMIC is passed to blk_get_request() in multipath_clone_and_map(),
it isn't strange to see this failure especially when there are too
many concurrent I/O. So 

> 
> This is due to
> 
> multipath_clone_and_map()
> 
> /*
>  * Map cloned requests (request-based multipath)
>  */
> static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
>                                    union map_info *map_context,
>                                    struct request **__clone)
> {
> ..
> ..
> ..
>         clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
>         if (IS_ERR(clone)) {
>                 /* EBUSY, ENODEV or EWOULDBLOCK: requeue */
>                 bool queue_dying = blk_queue_dying(q);
>                 DMERR_LIMIT("blk_get_request() returned %ld%s - requeuing",
>                             PTR_ERR(clone), queue_dying ? " (path offline)"
> : "");
>                 if (queue_dying) {
>                         atomic_inc(&m->pg_init_in_progress);
>                         activate_or_offline_path(pgpath);
>                         return DM_MAPIO_REQUEUE;
>                 }
>                 return DM_MAPIO_DELAY_REQUEUE;
>         }
> 
> Still investigating but it leads to a hard lockup
> 
> 
> So I still need to see if the hard-lockup happens in the stock kernel with
> mq-deadline and some other work before coming up with a full summary of the
> issue.
> 
> I also intend to re-run all tests including disconnect and reconnect tests
> on both mq-deadline and none.
> 
> Trace below
> 
> 
> [ 1553.167357] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
> [ 1553.167359] Modules linked in: mq_deadline binfmt_misc dm_round_robin
> xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter
> ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
> nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat
> nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 rpcrdma ip6table_mangle
> ip6table_security ip6table_raw iptable_nat ib_isert nf_conntrack_ipv4
> iscsi_target_mod nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_iser
> libiscsi scsi_transport_iscsi iptable_mangle iptable_security iptable_raw
> ebtable_filter ebtables target_core_mod ip6table_filter ip6_tables
> iptable_filter ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs
> ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp
> kvm_intel kvm irqbypass crct10dif_pclmul
> [ 1553.167385]  crc32_pclmul ghash_clmulni_intel pcbc aesni_intel sg joydev
> ipmi_si hpilo crypto_simd hpwdt iTCO_wdt cryptd ipmi_devintf glue_helper
> gpio_ich iTCO_vendor_support shpchp ipmi_msghandler pcspkr acpi_power_meter
> i7core_edac lpc_ich pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc
> dm_multipath ip_tables xfs libcrc32c sd_mod amdkfd amd_iommu_v2 radeon
> i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
> ttm mlx5_core drm mlxfw i2c_core ptp serio_raw hpsa crc32c_intel bnx2
> pps_core devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
> [last unloaded: ib_srpt]
> [ 1553.167410] CPU: 4 PID: 11532 Comm: dd Tainted: G          I
> 4.13.0-rc3lobeming.ming_V4+ #20
> [ 1553.167411] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
> [ 1553.167412] task: ffff9d9344b0d800 task.stack: ffffb5cb913b0000
> [ 1553.167421] RIP: 0010:__blk_recalc_rq_segments+0xec/0x3d0
> [ 1553.167421] RSP: 0018:ffff9d9377a83d08 EFLAGS: 00000046
> [ 1553.167422] RAX: 0000000000001000 RBX: 0000000000001000 RCX:
> ffff9d91b8e9f500
> [ 1553.167423] RDX: fffffcd56af20f00 RSI: ffff9d91b8e9f588 RDI:
> ffff9d91b8e9f488
> [ 1553.167424] RBP: ffff9d9377a83d88 R08: 000000000003c000 R09:
> 0000000000000001
> [ 1553.167424] R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000000
> [ 1553.167425] R13: 0000000000000000 R14: 0000000000000000 R15:
> 0000000000000003
> [ 1553.167426] FS:  00007f3061002740(0000) GS:ffff9d9377a80000(0000)
> knlGS:0000000000000000
> [ 1553.167427] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1553.167428] CR2: 00007f305a511000 CR3: 0000000b1bfb2000 CR4:
> 00000000000006e0
> [ 1553.167429] Call Trace:
> [ 1553.167432]  <IRQ>
> [ 1553.167437]  ? mempool_free+0x2b/0x80
> [ 1553.167440]  blk_recalc_rq_segments+0x28/0x40
> [ 1553.167442]  blk_update_request+0x249/0x310
> [ 1553.167450]  end_clone_bio+0x46/0x70 [dm_mod]
> [ 1553.167453]  bio_endio+0xa1/0x120
> [ 1553.167454]  blk_update_request+0xb7/0x310
> [ 1553.167457]  scsi_end_request+0x38/0x1d0
> [ 1553.167458]  scsi_io_completion+0x13c/0x630
> [ 1553.167460]  scsi_finish_command+0xd9/0x120
> [ 1553.167462]  scsi_softirq_done+0x12a/0x150
> [ 1553.167463]  __blk_mq_complete_request_remote+0x13/0x20
> [ 1553.167466]  flush_smp_call_function_queue+0x52/0x110
> [ 1553.167468]  generic_smp_call_function_single_interrupt+0x13/0x30
> [ 1553.167470]  smp_call_function_single_interrupt+0x27/0x40
> [ 1553.167471]  call_function_single_interrupt+0x93/0xa0
> [ 1553.167473] RIP: 0010:radix_tree_next_chunk+0xcb/0x2e0
> [ 1553.167474] RSP: 0018:ffffb5cb913b3a68 EFLAGS: 00000203 ORIG_RAX:
> ffffffffffffff04
> [ 1553.167475] RAX: 0000000000000001 RBX: 0000000000000010 RCX:
> ffff9d9e2c556938
> [ 1553.167476] RDX: ffff9d93053c5919 RSI: 0000000000000001 RDI:
> ffff9d9e2c556910
> [ 1553.167476] RBP: ffffb5cb913b3ab8 R08: ffffb5cb913b3bc0 R09:
> 0000000ab7d52000
> [ 1553.167477] R10: fffffcd56adf5440 R11: 0000000000000000 R12:
> 0000000000000230
> [ 1553.167477] R13: 0000000000000000 R14: 000000000006e0fe R15:
> ffff9d9e2c556910

This one looks a real issue, and not sure this one is related
with request allocation failure. Looks there is a deadloop
in blk_recalc_rq_segments()?



-- 
Ming
