From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: 4.1-rc2 dm-multipath-mq kernel warning
Date: Tue, 5 May 2015 16:04:21 +0200
Message-ID: <5548CDE5.9@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Mike,

While retesting my SRP initiator patches on top of kernel v4.1-rc2 with 
DM_MQ_DEFAULT=y I ran into the kernel warning below. Does this mean that 
I'm missing any device mapper related patches ? This warning was 
reported shortly after scsi_remove_host() had been invoked.

Thanks,

Bart.

[  636.982089] device-mapper: multipath: Failing path 8:16.
[  636.982395] blk_update_request: I/O error, dev dm-1, sector 42378
[  636.987025] ------------[ cut here ]------------
[  636.987053] WARNING: CPU: 0 PID: 3 at drivers/md/dm.c:1090 
free_rq_clone+0x7a/0xf0 [dm_mod]()
[  636.987070] Modules linked in: dm_service_time dm_multipath scsi_dh 
ib_srp scsi_transport_srp netconsole configfs fuse dm_crypt xts gf128mul 
algif_skcipher af_alg loop rdma_ucm rdma_cm iw_cm ib_ipoib ib_cm 
ib_uverbs ib_umad mlx4_en ptp pps_core iscsi_ibft iscsi_boot_sysfs 
af_packet mlx4_ib ib_sa ib_mad ib_core ib_addr mlx4_core iTCO_wdt sky2 
iTCO_vendor_support coretemp lpc_ich shpchp mfd_core pcspkr serio_raw 
i2c_i801 acpi_cpufreq tpm_infineon tpm_tis tpm asus_atk0110 button 
processor dm_mod sr_mod cdrom ata_generic radeon ata_piix firewire_ohci 
i2c_algo_bit firewire_core crc_itu_t drm_kms_helper ttm pata_marvell drm 
floppy sg [last unloaded: scsi_transport_srp]
[  636.998755] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 
4.1.0-rc2-debug+ #1
[  636.998771] Hardware name: System manufacturer P5Q DELUXE/P5Q DELUXE, 
BIOS 2301    07/10/2009
[  636.998786]  ffffffffa02ce8ad ffff8801b81efca8 ffffffff81606de3 
ffff8801bfc0fff8
[  636.998862]  0000000000000000 ffff8801b81efce8 ffffffff81052940 
ffffffff81e3d288
[  636.998953]  ffff8800a1f82580 ffff8800a1e40000 ffff8800a1f82530 
ffff8800a1e40000
[  636.999032] Call Trace:
[  636.999054]  [<ffffffff81606de3>] dump_stack+0x4c/0x6e
[  636.999074]  [<ffffffff81052940>] warn_slowpath_common+0x80/0xc0
[  636.999092]  [<ffffffff81052a25>] warn_slowpath_null+0x15/0x20
[  636.999115]  [<ffffffffa02bdc2a>] free_rq_clone+0x7a/0xf0 [dm_mod]
[  636.999139]  [<ffffffffa02be45c>] dm_softirq_done+0x13c/0x250 [dm_mod]
[  636.999162]  [<ffffffff812c6ec8>] blk_done_softirq+0x78/0x90
[  636.999181]  [<ffffffff81056a2a>] __do_softirq+0x10a/0x240
[  636.999200]  [<ffffffff81056b7a>] run_ksoftirqd+0x1a/0x70
[  636.999218]  [<ffffffff81076adf>] smpboot_thread_fn+0x16f/0x260
[  636.999256]  [<ffffffff81073099>] kthread+0xf9/0x110
[  636.999294]  [<ffffffff8160fce2>] ret_from_fork+0x42/0x70
[  636.999338] ---[ end trace ba34bc950a902b8f ]---
