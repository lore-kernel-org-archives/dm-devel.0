From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm-mpath: Fix a race condition in
	__multipath_map()
Date: Mon, 21 Nov 2016 18:43:17 -0500
Message-ID: <20161121234316.GA25362@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
	<20161116003720.GA19059@redhat.com>
	<be828cfa-1121-8d99-0cd1-9021fab3adc8@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <be828cfa-1121-8d99-0cd1-9021fab3adc8@sandisk.com>
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

On Mon, Nov 21 2016 at  4:44pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 11/15/2016 04:37 PM, Mike Snitzer wrote:
> > On Tue, Nov 15 2016 at  6:35pm -0500,
> > Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> > 
> >> If a single-queue dm device is stacked on top of multi-queue block
> >> devices and map_tio_request() is called while there are no paths then
> >> the request will be prepared for a single-queue path. If a path is
> >> added after a request was prepared and before __multipath_map() is
> >> called return DM_MAPIO_REQUEUE such that it gets unprepared and
> >> reprepared as a blk-mq request.
> > 
> > This patch makes little sense to me.  There isn't a scenario that I'm
> > aware of that would allow the request_queue to transition between old
> > .request_fn and new blk-mq.
> > 
> > The dm-table code should prevent this.
> 
> Hello Mike,
> 
> After having added the following code in __multipath_map() just before
> the set_mpio() call:
> 
> 	bdev = pgpath->path.dev->bdev;
> 	q = bdev_get_queue(bdev);
> 
> 	if (WARN_ON_ONCE(clone && q->mq_ops) ||
> 	    WARN_ON_ONCE(!clone && !q->mq_ops)) {
> 		pr_debug("q->queue_flags = %#lx\n", q->queue_flags);
> 		return r;
> 	}
> 
> I see the following warning appear (line 544 contains
> WARN_ON_ONCE(clone && q->mq_ops)):
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 25384 at drivers/md/dm-mpath.c:544 __multipath_map.isra.17+0x325/0x360 [dm_multipath]
> Modules linked in: ib_srp scsi_transport_srp ib_srpt(O) scst_vdisk(O) scst(O) dlm libcrc32c brd dm_service_time netconsole xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables af_packet ib_ipoib rdma_ucm ib_ucm msr ib_uverbs ib_umad rdma_cm configfs ib_cm iw_cm mlx4_ib ib_core sb_edac edac_core x86_pkg_temp_thermal coretemp kvm_intel hid_generic ipmi_ssif usbhid ipmi_devintf kvm irqbypass mlx4_core crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel tg3 aes_x86_64 iTCO_wdt lrw gf128mul ptp dcdbas iTCO_vendor_support glue_helper pps_core ablk_helper libphy
  cryptd ipmi_si pcspkr mei_me fjes ipmi_msghandler mei shpchp tpm_tis tpm_tis_core lpc_ich tpm mfd_core wmi button mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_s!
 ys_fops ttm drm sr_mod cdrom crc32c_intel ehci_pci ehci_hcd usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua [last unloaded: brd]
> CPU: 2 PID: 25384 Comm: kdmwork-254:0 Tainted: G           O    4.9.0-rc6-dbg+ #1
> Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
>  ffffc90002cd7d00 ffffffff81329bb5 0000000000000000 0000000000000000
>  ffffc90002cd7d40 ffffffff810650e6 0000022000001000 ffff8804433a0008
>  ffff88039134fc28 ffff88037e804008 ffff88039bacce98 0000000000001000
> Call Trace:
>  [<ffffffff81329bb5>] dump_stack+0x68/0x93
>  [<ffffffff810650e6>] __warn+0xc6/0xe0
>  [<ffffffff810651b8>] warn_slowpath_null+0x18/0x20
>  [<ffffffffa0046125>] __multipath_map.isra.17+0x325/0x360 [dm_multipath]
>  [<ffffffffa0046192>] multipath_map+0x12/0x20 [dm_multipath]
>  [<ffffffffa002a356>] map_request+0x46/0x300 [dm_mod]
>  [<ffffffffa002a621>] map_tio_request+0x11/0x30 [dm_mod]
>  [<ffffffff8108a065>] kthread_worker_fn+0x105/0x1e0
>  [<ffffffff81089f60>] ? __kthread_init_worker+0x70/0x70
>  [<ffffffff81089ecb>] kthread+0xeb/0x110
>  [<ffffffff81089de0>] ? kthread_park+0x60/0x60
>  [<ffffffff8163fcc7>] ret_from_fork+0x27/0x40
> ---[ end trace b181de88e3eff2a0 ]---
> dm_multipath:__multipath_map: q->queue_flags = 0x1d06a00
> 
> As one can see neither QUEUE_FLAG_DYING nor QUEUE_FLAG_DEAD was set:
> 
> $ grep -E 'define QUEUE_FLAG[^[:blank:]]*[[:blank:]](9|11|13|14|20|22|23|24)[[:blank:]]' include/linux/blkdev.h 
> #define QUEUE_FLAG_SAME_COMP    9       /* complete on same CPU-group */
> #define QUEUE_FLAG_STACKABLE   11       /* supports request stacking */
> #define QUEUE_FLAG_IO_STAT     13       /* do IO stats */
> #define QUEUE_FLAG_DISCARD     14       /* supports DISCARD */
> #define QUEUE_FLAG_INIT_DONE   20       /* queue is initialized */
> #define QUEUE_FLAG_POLL        22       /* IO polling enabled if set */
> #define QUEUE_FLAG_WC          23       /* Write back caching */
> #define QUEUE_FLAG_FUA         24       /* device supports FUA writes */
> 
> Do you want to comment on this?

Shouldn't be possible.  The previous stacktrace you shared clearly
showed that the DM mpath request_queue was using blk-mq (dm_mq_queue_rq
was in the stack).

Whereas the stacktrace above is clearly the old request_fn interface.

I'm unaware of how the existing code can allow this.  As I said in my
earlier mails on this: the request-queue shouldn't be able to change
from blk-mq back to .request_fn or vice-versa.

So if you think you're only testing blk-mq DM mpath on blk-mq paths,
then you need to determine how dm_old_init_request_queue() is getting
called to even setup .request_fn (dm_old_request_fn) to be used.

If the opposite is true (old request_fn DM mpath stack on blk-mq paths)
then determine how dm_mq_init_request_queue is getting called.

Basically dm_setup_md_queue() should only ever be called the first time
the "multipath" target is loaded.  If that isn't the case, then you've
exposed some seriously weird bug/regression.

Mike
