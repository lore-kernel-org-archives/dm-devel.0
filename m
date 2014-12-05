From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv2 0/4] blk-mq support for dm multipath
Date: Fri, 5 Dec 2014 18:25:42 -0500
Message-ID: <20141205232542.GA1274@redhat.com>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
	<alpine.LNX.2.00.1410281808390.4225@localhost.lm.intel.com>
	<20141028182627.GA28537@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141028182627.GA28537@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 28 2014 at  2:26pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Oct 28 2014 at  2:13pm -0400,
> Keith Busch <keith.busch@intel.com> wrote:
> 
> > No comments this time. Did I totally botch this in the wrong direction,
> > or was the timing bad with the linux con/plumbers that week?
> 
> I've just been busy with other things.  Reviewing this is on my
> near-term TODO (for 3.19 merge consideration).

Hi Keith,

I've found a few issues with your v2.  I've been working through the
code and fixing things as I see them.  Please see this branch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19-blk-mq

My changes build on your v2 baseline.

How much testing have you done?  It could be that my changes screwed
something up but... I just tried simply creating a normal request-based
DM multipath device (using non blk-mq devices) and hit this crash:

[ 1179.088841] BUG: unable to handle kernel NULL pointer dereference at 0000000000000378
[ 1179.097587] IP: [<ffffffff8142091a>] scsi_setup_cmnd+0xea/0x170
[ 1179.104202] PGD 0
[ 1179.106450] Oops: 0000 [#1] SMP
[ 1179.110062] Modules linked in: dm_service_time(O) scsi_debug dm_multipath(O) sg iTCO_wdt ixgbe dm_thin_pool igb dm_persistent_data mdio coretemp kvm_intel i7core_ed
ac dm_bio_prison kvm ptp crct10dif_pclmul pps_core edac_core dm_bufio crc32_pclmul dca crc32c_intel ipmi_si iTCO_vendor_support ses ghash_clmulni_intel ipmi_msghandler
 aesni_intel enclosure glue_helper lrw shpchp gf128mul ablk_helper lpc_ich mfd_core cryptd i2c_i801 pcspkr acpi_power_meter acpi_cpufreq xfs libcrc32c sr_mod sd_mod cd
rom mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ata_generic pata_acpi ttm ata_piix drm libata iomemory_vsl(POE) megaraid_sas i2ccore dm_mirro
r dm_region_hash dm_log dm_mod
[ 1179.178539] CPU: 5 PID: 4395 Comm: kdmwork-253:13 Tainted: P        W IOE  3.17.0-rc5.snitm+ #21
[ 1179.188338] Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
[ 1179.202983] task: ffff8800b9bfa8b0 ti: ffff8802c7578000 task.ti: ffff8802c7578000
[ 1179.211329] RIP: 0010:[<ffffffff8142091a>]  [<ffffffff8142091a>] scsi_setup_cmnd+0xea/0x170
[ 1179.220653] RSP: 0018:ffff8802c757bcb0  EFLAGS: 00010046
[ 1179.226574] RAX: 0000000000000000 RBX: ffff88032b193140 RCX: 0000000000001000
[ 1179.234532] RDX: ffff8800afc23200 RSI: ffff88032b193140 RDI: ffff8800afc23200
[ 1179.242488] RBP: ffff8802c757bcc0 R08: ffff880329b3f840 R09: ffffffff81416a9b
[ 1179.250444] R10: ffffffff812cc9c3 R11: 0000000000000000 R12: ffff8800afc23200
[ 1179.258401] R13: ffff880329b3f800 R14: ffff880329b3f968 R15: ffff880328390000
[ 1179.266359] FS:  0000000000000000(0000) GS:ffff88033fca0000(0000) knlGS:0000000000000000
[ 1179.275381] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1179.281787] CR2: 0000000000000378 CR3: 00000000b0d90000 CR4: 00000000000007e0
[ 1179.289746] Stack:
[ 1179.291984]  ffff88032b193140 ffff880328390000 ffff8802c757bcf8 ffffffff81420a7b
[ 1179.300266]  ffff8800b9bfa8b0 ffff880328390000 ffff880329addc00 0000000100000000
[ 1179.308546]  ffff88032b193140 ffff8802c757bd28 ffffffff812c8fa6 ffff880329b3f800
[ 1179.316827] Call Trace:
[ 1179.319553]  [<ffffffff81420a7b>] scsi_prep_fn+0xdb/0x180
[ 1179.325573]  [<ffffffff812c8fa6>] blk_peek_request+0x166/0x290
[ 1179.332077]  [<ffffffff81422540>] scsi_request_fn+0x50/0x7b0
[ 1179.338388]  [<ffffffff812c4863>] __blk_run_queue+0x33/0x40
[ 1179.344602]  [<ffffffff812c22fb>] __elv_add_request+0xdb/0x2e0
[ 1179.351105]  [<ffffffff812c8bd1>] blk_insert_cloned_request+0xa1/0x120
[ 1179.358390]  [<ffffffffa00007ab>] dm_dispatch_request+0x3b/0x60 [dm_mod]
[ 1179.365865]  [<ffffffffa0001154>] map_tio_request+0x174/0x250 [dm_mod]
[ 1179.373146]  [<ffffffff81091023>] kthread_worker_fn+0x83/0x1d0
[ 1179.379650]  [<ffffffff81090fa0>] ? kthread_stop+0xe0/0xe0
[ 1179.385767]  [<ffffffff81090c58>] kthread+0xd8/0xf0
[ 1179.391204]  [<ffffffff81090b80>] ? kthread_create_on_node+0x1a0/0x1a0
[ 1179.398486]  [<ffffffff8163abfc>] ret_from_fork+0x7c/0xb0
[ 1179.404505]  [<ffffffff81090b80>] ? kthread_create_on_node+0x1a0/0x1a0
[ 1179.411783] Code: 00 00 49 8b 84 24 d8 00 00 00 4c 89 e7 48 c7 00 00 00 00 00 48 c7 40 08 00 00 00 00 49 8b 84 24 08 01 00 00 48 8b 80 c0 00 00 00 <48> 8b 80 78 03
00 00 48 8b 00 ff 90 88 00 00 00 5b 41 5c 5d c3
[ 1179.433377] RIP  [<ffffffff8142091a>] scsi_setup_cmnd+0xea/0x170
[ 1179.440086]  RSP <ffff8802c757bcb0>
[ 1179.443974] CR2: 0000000000000378
[ 1199.444124] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 10
[ 1200.503096] Shutting down cpus with NMI
[ 1200.507978] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[ 1200.519326] drm_kms_helper: panic occurred, switching back to text console
[ 1208.015881] ---[ end Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 10
