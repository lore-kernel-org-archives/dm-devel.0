From: Ming Lei <ming.lei@redhat.com>
Subject: [Bug] kernel oops when running xfstests(ext4) generic/081
Date: Tue, 5 Jun 2018 16:08:37 +0800
Message-ID: <20180605080835.GH28826@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

Hi,

The following failure is triggered when running xfstests(ext4)
generic/081 with the linus tree(4.17.0_716a685fdb89).

It might be related with recent mempool change.

[  206.450481] run fstests generic/081 at 2018-06-05 05:48:26
[  207.017192] device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
[  207.018870] EXT4-fs warning (device dm-3): ext4_end_bio:323: I/O error 10 writing to inode 12 (offset 2097152 size 2097152 starting block 14336)
[  207.020480] Buffer I/O error on device dm-3, logical block 12289
[  207.021179] Buffer I/O error on device dm-3, logical block 12290
[  207.021866] Buffer I/O error on device dm-3, logical block 12291
[  207.022547] Buffer I/O error on device dm-3, logical block 12292
[  207.023813] Buffer I/O error on device dm-3, logical block 12293
[  207.024514] Buffer I/O error on device dm-3, logical block 12294
[  207.025198] Buffer I/O error on device dm-3, logical block 12295
[  207.025882] Buffer I/O error on device dm-3, logical block 12296
[  207.026577] Buffer I/O error on device dm-3, logical block 12297
[  207.027264] Buffer I/O error on device dm-3, logical block 12298
[  207.028944] EXT4-fs warning (device dm-3): ext4_end_bio:323: I/O error 10 writing to inode 12 (offset 4194304 size 1048576 starting block 15360)
[  207.032064] Buffer I/O error on dev dm-3, logical block 114689, lost sync page write
[  207.032989] JBD2: Error -5 detected when updating journal superblock for dm-3-8.
[  207.033831] Aborting journal on device dm-3-8.
[  207.034345] Buffer I/O error on dev dm-3, logical block 114689, lost sync page write
[  207.035234] JBD2: Error -5 detected when updating journal superblock for dm-3-8.
[  207.037705] Buffer I/O error on dev dm-3, logical block 1, lost sync page write
[  209.059165] BUG: unable to handle kernel paging request at ffff8805ab10ccf8
[  209.060034] PGD 2981067 P4D 2981067 PUD 0
[  209.060506] Oops: 0000 [#1] PREEMPT SMP PTI
[  209.060994] CPU: 0 PID: 16548 Comm: lvm Not tainted 4.17.0_716a685fdb89_master+ #1
[  209.061848] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-2.fc27 04/01/2014
[  209.062780] RIP: 0010:remove_element.isra.1+0x17/0x20
[  209.063359] Code: 1f 44 00 00 e9 8b 59 05 00 0f 1f 44 00 00 e9 57 52 00 00 0f 1f 44 00 00 8b 77 08 48 8b 47 10 8d 56 ff 48 63 ca 85 d2 89 57 08 <48> 8b 04 c8 79 02 0f 0b c3 0f 1f 44 00 00 53 48 89 fb 83 7b 08 00
[  209.065511] RSP: 0018:ffffc90001313ba0 EFLAGS: 00010206
[  209.066101] RAX: ffff880269330d00 RBX: ffff8802683bb800 RCX: 00000000683bb7ff
[  209.066856] RDX: 00000000683bb7ff RSI: 00000000683bb800 RDI: ffff8802683bb800
[  209.067608] RBP: ffffc90001065040 R08: 0000000000000000 R09: ffff88026b683d00
[  209.068365] R10: ffffc90001313aa0 R11: 0000000000000000 R12: 0000000000000000
[  209.069125] R13: 0000000000000001 R14: 0000000000000000 R15: ffffffffa0008a01
[  209.069882] FS:  00007fec993b6900(0000) GS:ffff88027fc00000(0000) knlGS:0000000000000000
[  209.070735] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  209.071349] CR2: ffff8805ab10ccf8 CR3: 0000000269bc0004 CR4: 0000000000760ef0
[  209.072110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  209.072865] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  209.073617] PKRU: 55555554
[  209.073916] Call Trace:
[  209.074187]  mempool_exit+0x17/0x3c
[  209.074570]  dm_io_client_destroy+0xe/0x20 [dm_mod]
[  209.075098]  dm_kcopyd_client_destroy+0xb0/0x101 [dm_mod]
[  209.075675]  ? remove_all+0x29/0x29 [dm_mod]
[  209.076141]  ? unregister_snapshot+0x7d/0x8a [dm_snapshot]
[  209.076725]  snapshot_dtr+0xfb/0x17d [dm_snapshot]
[  209.077246]  dm_table_destroy+0x60/0xfb [dm_mod]
[  209.077754]  ? remove_all+0x29/0x29 [dm_mod]
[  209.078217]  __dm_destroy+0x13b/0x14b [dm_mod]
[  209.078696]  dev_remove+0x160/0x16a [dm_mod]
[  209.079161]  ctl_ioctl+0x295/0x374 [dm_mod]
[  209.079614]  dm_ctl_ioctl+0xa/0xd [dm_mod]
[  209.080061]  vfs_ioctl+0x1e/0x2b
[  209.080411]  do_vfs_ioctl+0x523/0x54b
[  209.080812]  ? ksys_semctl+0xb9/0x126
[  209.081210]  ? ipcget+0x1f0/0x217
[  209.081568]  ksys_ioctl+0x3e/0x5d
[  209.081934]  __x64_sys_ioctl+0x16/0x19
[  209.082340]  do_syscall_64+0x84/0x13f
[  209.082737]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  209.083279] RIP: 0033:0x7fec97f3a0f7
[  209.083664] Code: b3 66 90 48 8b 05 a9 3d 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 79 3d 2c 00 f7 d8 64 89 01 48
[  209.085660] RSP: 002b:00007ffc6d9c2a48 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  209.086464] RAX: ffffffffffffffda RBX: 0000559dee712350 RCX: 00007fec97f3a0f7
[  209.087222] RDX: 0000559defcb8c30 RSI: 00000000c138fd04 RDI: 0000000000000006
[  209.087978] RBP: 00000000000000fc R08: 0000000000000000 R09: 00007ffc6d9c28b0
[  209.088732] R10: 00007fec98498683 R11: 0000000000000246 R12: 0000000000000001
[  209.089490] R13: 0000559defcb8c60 R14: 0000559defcb8c30 R15: 0000559defc99ec0
[  209.090249] Modules linked in: dm_snapshot dm_bufio xfs libcrc32c dm_flakey isofs iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core lpc_ich mfd_core ip_tables sr_mod cdrom sd_mod usb_storage ahci libahci nvme libata crc32c_intel nvme_core virtio_scsi qemu_fw_cfg dm_mirror dm_region_hash dm_log dm_mod
[  209.093036] Dumping ftrace buffer:
[  209.093404]    (ftrace buffer empty)
[  209.093792] CR2: ffff8805ab10ccf8
[  209.094154] ---[ end trace 49333fa80a7daaa2 ]---

Thanks,
Ming
