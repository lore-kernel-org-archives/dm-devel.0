From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Kernel v4.1-rc1 + MQ dm-multipath + MQ SRP oops
Date: Tue, 28 Apr 2015 13:52:20 +0200
Message-ID: <553F7474.70905@sandisk.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

Earlier today I started testing an SRP initiator patch series on top of 
Linux kernel v4.1-rc1. Although that patch series works reliably on top 
of kernel v4.0, a test during which I triggered scsi_remove_host() + 
relogin (for p in /sys/class/srp_remote_ports/*; do echo 1 >$p/delete & 
done; wait; srp_daemon -oaec) triggered the following kernel oops:

device-mapper: multipath: Failing path 8:0.
BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
IP: [<ffffffffa045f8e9>] free_rq_clone+0x29/0xb0 [dm_mod]
PGD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: dm_queue_length scsi_dh_alua dm_round_robin 
dm_multipath scsi_dh dm_mod sd_mod ib_uverbs mlx4_ib ib_umad netconsole 
ib_srp scsi_transport_srp configfs ib_iser rdma_cm iw_cm ib_cm ib_sa 
ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi hid_generic af_packet sg microcode sr_mod i2c_piix4 
usbhid hid intel_agp intel_gtt i2c_core cdrom virtio_balloon agpgart 
acpi_cpufreq processor thermal_sys fuse hwmon button ata_generic 
pata_acpi mlx4_en ptp pps_core ext4 crc16 jbd2 mbcache virtio_blk 
virtio_net ata_piix libata uhci_hcd virtio_pci virtio_ring mlx4_core 
usbcore virtio scsi_mod usb_common
CPU: 1 PID: 5423 Comm: kdmwork-252:0 Not tainted 4.1.0-rc1-debug+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff880056568000 ti: ffff8800516c0000 task.ti: ffff8800516c0000
RIP: 0010:[<ffffffffa045f8e9>]  [<ffffffffa045f8e9>] 
free_rq_clone+0x29/0xb0 [dm_mod]
RSP: 0018:ffff8800516c3d18  EFLAGS: 00010296
RAX: 0000000000000000 RBX: ffff880058bb7040 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8179d723 RDI: 0000000000000000
RBP: ffff8800516c3d38 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880058bb6ff0
R13: ffff880051570948 R14: 0000000000000000 R15: ffffc900000b7040
FS:  0000000000000000(0000) GS:ffff88005fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000138 CR3: 000000005dab8000 CR4: 00000000000007e0
Stack:
  0000000000000001 ffff880058bb6e80 ffff8800342ab0a0 ffff880051570948
  ffff8800516c3d78 ffffffffa045fa67 ffff880058bb6e80 ffff880058bb6ff0
  0000000000000002 ffff880058bb6e80 ffff880051570c60 ffffc900000b7040
Call Trace:
  [<ffffffffa045fa67>] dm_requeue_unmapped_original_request+0x47/0xe0 
[dm_mod]
  [<ffffffffa0461daf>] map_request.isra.35+0x9f/0x430 [dm_mod]
  [<ffffffff814ff2d0>] ? _raw_spin_unlock_irq+0x30/0x70
  [<ffffffffa0462166>] map_tio_request+0x26/0x40 [dm_mod]
  [<ffffffff8108382f>] kthread_worker_fn+0xaf/0x200
  [<ffffffff81083780>] ? __init_kthread_worker+0x60/0x60
  [<ffffffff8108370a>] kthread+0x10a/0x120
  [<ffffffff814ff2d0>] ? _raw_spin_unlock_irq+0x30/0x70
  [<ffffffff81083600>] ? kthread_create_on_node+0x220/0x220
  [<ffffffff815001a2>] ret_from_fork+0x42/0x70
  [<ffffffff81083600>] ? kthread_create_on_node+0x220/0x220
Code: 00 00 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 53 48 89 fb 48 83 ec 
08 4c 8b a7 60 01 00 00 4d 8b 2c 24 e8 bb 6e e0 e0 48 8b 43 30 <48> 83 
b8 38 01 00 00 00 74 2d 49 8b 44 24 08 48 89 df 48 8b 40
RIP  [<ffffffffa045f8e9>] free_rq_clone+0x29/0xb0 [dm_mod]
  RSP <ffff8800516c3d18>
CR2: 0000000000000138
---[ end trace ba598d96706a7353 ]---

In case anyone wants to see the translation of the crash address:

(gdb) list *(free_rq_clone+0x29)
0x919 is in free_rq_clone (drivers/md/dm.c:1092).
1087            struct dm_rq_target_io *tio = clone->end_io_data;
1088            struct mapped_device *md = tio->md;
1089
1090            blk_rq_unprep_clone(clone);
1091
1092            if (clone->q->mq_ops)
1093                    tio->ti->type->release_clone_rq(clone);
1094            else if (!md->queue->mq_ops)
1095                    /* request_fn queue stacked on request_fn 
queue(s) */
1096                    free_clone_request(md, clone);
(gdb) list *(dm_requeue_unmapped_original_request+0x47)
0xa97 is in dm_requeue_unmapped_original_request (drivers/md/dm.c:1146).
1141                    rq->special = NULL;
1142                    rq->cmd_flags &= ~REQ_DONTPREP;
1143            }
1144
1145            if (clone)
1146                    free_rq_clone(clone);
1147    }
1148
1149    /*
1150     * Requeue the original request of a clone.

Bart.
