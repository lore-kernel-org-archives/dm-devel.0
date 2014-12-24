From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Wed, 24 Dec 2014 14:02:49 +0100
Message-ID: <549AB979.4050302@acm.org>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>	<20141217230622.GC15390@redhat.com>
	<54943714.2040704@acm.org>	<20141219153801.GA8697@redhat.com>
	<20141219171438.GA6347@redhat.com>	<5498389D.6070909@acm.org>
	<20141222184910.GB8054@redhat.com>	<54999756.70303@acm.org>	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, device-mapper@redhat.com, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 12/23/14 22:42, Mike Snitzer wrote:
> I've rebased with this fix folded into both the 'for-next' and
> 'dm-for-3.20-blk-mq' branches of linux-dm.git

Thanks, that's appreciated. However, with this tree I ran into a
different issue:

BUG: unable to handle kernel NULL pointer dereference at 00000000000002a0
IP: [<ffffffff811b2d18>] blk_account_io_completion+0x48/0x90
PGD 8150b6067 PUD 8150b4067 PMD 0 
Oops: 0000 [#1] SMP 
Modules linked in: dm_queue_length dm_multipath ib_srp scsi_transport_srp netconsole configfs fuse ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables 8021q garp bridge stp llc rdma_ucm rdma_cm iw_cm af_packet ib_ipoib ib_cm ib_uverbs ib_umad mlx4_en mlx4_ib ib_sa ib_mad ib_core ib_addr snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec x86_pkg_temp_thermal coretemp snd_hwdep kvm_intel snd_pcm kvm snd_seq snd_seq_device crct10dif_pclmul snd_timer crc32c_intel e1000e mlx4_core sr_mod snd sb_edac xhci_pci edac_core cdrom microcode xhci_hcd pcspkr ptp lpc_ich mfd_core soundcore i2c_i801 pps_core wmi button sg dm_mod autofs4 ext4 crc16 mbcache jbd2 sd_mod hid_generic usbhid hid radeon i2c_algo_bit drm_kms_
 helper ttm ahci libahci libata drm ehci_pci ehci_hcd usbcore agpgart usb_common processor thermal_sys hwmon scsi_dh_alua scsi_dh scsi_mod
CPU: 10 PID: 0 Comm: swapper/10 Not tainted 3.19.0-rc1+ #1
Hardware name: MSI MS-7737/Big Bang-XPower II (MS-7737), BIOS V1.5 10/16/2012
task: ffff88085c145010 ti: ffff88085c2c4000 task.ti: ffff88085c2c4000
RIP: 0010:[<ffffffff811b2d18>]  [<ffffffff811b2d18>] blk_account_io_completion+0x48/0x90
RSP: 0018:ffff88085fd43df8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880806c60000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88085fd43df8 R08: 000000000000000a R09: 0000000000000002
R10: 000000000000004e R11: 0000000000000000 R12: ffff88080844c800
R13: ffff880806c60170 R14: 0000000000000000 R15: ffff880806c60000
FS:  0000000000000000(0000) GS:ffff88085fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000002a0 CR3: 00000008150b9000 CR4: 00000000000407e0
Stack:
 ffff88085fd43e48 ffffffff811b2d9a ffff88085fd43e08 000000005fd43e08
 ffff88085fd43e48 ffff880806c60000 ffff88080844c800 ffff880806c60170
 0000000000000000 ffff880834fe8008 ffff88085fd43e98 ffffffffa000902f
Call Trace:
 <IRQ> 
 [<ffffffff811b2d9a>] blk_update_request+0x3a/0x300
 [<ffffffffa000902f>] scsi_end_request+0x2f/0x1e0 [scsi_mod]
 [<ffffffffa000b451>] scsi_io_completion+0x101/0x690 [scsi_mod]
 [<ffffffffa000124a>] scsi_finish_command+0xca/0x130 [scsi_mod]
 [<ffffffffa000abff>] scsi_softirq_done+0x12f/0x160 [scsi_mod]
 [<ffffffff811ba1de>] __blk_mq_complete_request_remote+0xe/0x10
 [<ffffffff8109ea6d>] generic_smp_call_function_single_interrupt+0x5d/0x150
 [<ffffffff8102c382>] smp_call_function_single_interrupt+0x22/0x40
 [<ffffffff813e925a>] call_function_single_interrupt+0x6a/0x70
 <EOI> 
 [<ffffffff812f0b15>] ? cpuidle_enter_state+0x55/0xc0
 [<ffffffff812f0b07>] ? cpuidle_enter_state+0x47/0xc0
 [<ffffffff812f0c32>] cpuidle_enter+0x12/0x20
 [<ffffffff81078bcc>] cpu_startup_entry+0x22c/0x2c0
 [<ffffffff8102ca1d>] start_secondary+0x14d/0x170

(gdb) list *(blk_account_io_completion+0x48)
0xffffffff811b2d18 is in blk_account_io_completion (block/blk-core.c:2114).
2109                    struct hd_struct *part;
2110                    int cpu;
2111
2112                    cpu = part_stat_lock();
2113                    part = req->part;
2114                    part_stat_add(cpu, part, sectors[rw], bytes >> 9);
2115                    part_stat_unlock();
2116            }
2117    }
2118

Bart.
