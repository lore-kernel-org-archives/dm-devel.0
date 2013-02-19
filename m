From: Bart Van Assche <bvanassche@acm.org>
Subject: v3.8-rc7: Kernel oops in end_clone_bio()
Date: Tue, 19 Feb 2013 14:10:16 +0100
Message-ID: <512379B8.2040204@acm.org>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I can trigger the kernel oops mentioned below about once every two times 
I block communication between SRP initiator and SRP target via 
ibportstate disable. Reverting the source code in the drivers/md 
directory to v3.7 and updating include/linux/device-mapper.h accordingly 
makes this crash disappear. Does that mean that I hit a regression in 
the device mapper code ?

Kernel log messages obtained via netconsole:

scsi host12: ib_srp: SRP reset_host called
scsi host8: ib_srp: DREQ received - connection closed
scsi host12: ib_srp: reconnect succeeded
scsi host8: ib_srp: connection closed
general protection fault: 0000 [#1] SMP
Modules linked in: ext4 jbd2 crc16 dm_round_robin dm_multipath dm_mod 
ib_srp scsi_transport_srp netconsole configfs af_packet rdma_ucm rdma_cm 
iw_cm ib_addr scsi_tgt ib_ipoib ib_cm ib_uverbs ib_umad mlx4_ib ib_sa 
ib_mad ib_core cpufreq_conservative cpufreq_userspace cpufreq_powersave 
snd_hda_codec_hdmi snd_hda_codec_analog acpi_cpufreq mperf snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq sg sr_mod cdrom snd_timer 
snd_seq_device snd skge pcspkr i2c_i801 i2c_core ehci_pci soundcore 
snd_page_alloc scsi_transport_fc mlx4_core intel_agp intel_gtt agpgart 
button microcode autofs4 ext3 jbd mbcache sd_mod crc_t10dif uhci_hcd 
processor ehci_hcd usbcore usb_common thermal_sys hwmon scsi_dh_alua 
scsi_dh ata_generic ata_piix ahci libahci pata_marvell libata scsi_mod 
[last unloaded: scsi_transport_srp]
CPU 1
Pid: 198, comm: kworker/1:1H Not tainted 3.8.0-rc7-debug+ #2 System 
manufacturer P5Q DELUXE/P5Q DELUXE
RIP: 0010:[<ffffffff810fe754>]  [<ffffffff810fe754>] mempool_free+0x24/0xb0
RSP: 0018:ffff8801b9003c00  EFLAGS: 00010282
RAX: 00000000a53d0790 RBX: dead000000100100 RCX: 0000000000000008
RDX: 0000000000001000 RSI: dead000000100100 RDI: ffff88010d4e9480
RBP: ffff8801b9003c20 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000003 R12: ffff88010d4e9480
R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000001000
FS:  0000000000000000(0000) GS:ffff8801b9000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f0b84ada000 CR3: 000000019cd9d000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/1:1H (pid: 198, threadinfo ffff8801b3276000, task 
ffff8801b3ae2500)
Stack:
  ffff8801b9003c30 ffff8801b28b9c10 ffff8801b6771600 0000000000000000
  ffff8801b9003c40 ffffffff81187417 ffff8801b33a16c0 ffff8801b3159900
  ffff8801b9003c70 ffffffffa02247a5 ffff8801b28b9c10 0000000000000000
Call Trace:
  <IRQ>
  [<ffffffff81187417>] bio_put+0x97/0xc0
  [<ffffffffa02247a5>] end_clone_bio+0x35/0x90 [dm_mod]
  [<ffffffff81185efd>] bio_endio+0x1d/0x30
  [<ffffffff811f03a3>] req_bio_endio.isra.51+0xa3/0xe0
  [<ffffffff811f2f68>] blk_update_request+0x118/0x520
  [<ffffffff811f3397>] blk_update_bidi_request+0x27/0xa0
  [<ffffffff811f343c>] blk_end_bidi_request+0x2c/0x80
  [<ffffffff811f34d0>] blk_end_request+0x10/0x20
  [<ffffffffa000b32b>] scsi_io_completion+0xfb/0x6c0 [scsi_mod]
  [<ffffffffa000107d>] scsi_finish_command+0xbd/0x120 [scsi_mod]
  [<ffffffffa000b12f>] scsi_softirq_done+0x13f/0x160 [scsi_mod]
  [<ffffffff811f9fd0>] blk_done_softirq+0x80/0xa0
  [<ffffffff81044551>] __do_softirq+0xf1/0x250
  [<ffffffff8142ee8c>] call_softirq+0x1c/0x30
  [<ffffffff8100420d>] do_softirq+0x8d/0xc0
  [<ffffffff81044885>] irq_exit+0xd5/0xe0
  [<ffffffff8142f3e3>] do_IRQ+0x63/0xe0
  [<ffffffff814257af>] common_interrupt+0x6f/0x6f
  <EOI>
  [<ffffffffa021737c>] srp_queuecommand+0x8c/0xcb0 [ib_srp]
  [<ffffffffa0002f18>] scsi_dispatch_cmd+0x148/0x310 [scsi_mod]
  [<ffffffffa000a38e>] scsi_request_fn+0x31e/0x520 [scsi_mod]
  [<ffffffff811f1e57>] __blk_run_queue+0x37/0x50
  [<ffffffff811f1f69>] blk_delay_work+0x29/0x40
  [<ffffffff81059003>] process_one_work+0x1c3/0x5c0
  [<ffffffff8105b22e>] worker_thread+0x15e/0x440
  [<ffffffff8106164b>] kthread+0xdb/0xe0
  [<ffffffff8142db9c>] ret_from_fork+0x7c/0xb0
Code: ff 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 48 83 ec 20 48 85 
ff 4c 89 65 f0 49 89 fc 48 89 5d e8 4c 89 6d f8 74 33 48 89 f3 <8b> 46 
48 39 46 4c 7d 1e 48 89 f7 e8 3c 62 32 00 49 89 c5 8b 43
RIP  [<ffffffff810fe754>] mempool_free+0x24/0xb0
  RSP <ffff8801b9003c00>
---[ end trace 02286fe9057d9fc9 ]---
Kernel panic - not syncing: Fatal exception in interrupt

Bart.
