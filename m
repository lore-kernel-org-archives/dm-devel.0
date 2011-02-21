From: "Janec, Jozef" <jozef.janec@hp.com>
Subject: dm_mod crashed while adding new luns into multipath
Date: Mon, 21 Feb 2011 10:24:08 +0000
Message-ID: <A510D7CF8900D246979209B696F496F67EBA06544D@GVW1088EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

 Hello,

I just want to check if somebody saw this message:

We did: hp_rescan, and this initialized multipath to create new mpath devices for new luns and we got:


Feb 10 04:33:26 b021ple0 kernel: Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP: 
Feb 10 04:33:26 b021ple0 kernel: <ffffffff8810d34d>{:dm_mod:__map_bio+69}
Feb 10 04:33:26 b021ple0 kernel: PGD 3798e1067 PUD 350556067 PMD 0 
Feb 10 04:33:26 b021ple0 kernel: Oops: 0000 [1] SMP 
Feb 10 04:33:26 b021ple0 kernel: last sysfs file: /block/dm-0/uevent
Feb 10 04:33:26 b021ple0 kernel: CPU 6 
Feb 10 04:33:26 b021ple0 kernel: Modules linked in: nfs mptctl mptbase softdog ipmi_si ipmi_devintf ipmi_msghandler nfsd exportfs lockd nfs_acl hpilo sunrpc 

bonding ipv6 dock button battery ac apparmor ext3 jbd loop dm_round_robin dm_multipath scsi_dh usbhid reiserfs dm_snapshot usb_storage sata_nv libata generic 

ide_cd cdrom e1000 st bnx2 shpchp pci_hotplug ohci_hcd uhci_hcd ehci_hcd usbcore serio_raw pcmcia pcmcia_core edd dm_mod fan thermal processor sg qla2xxx 

firmware_class scsi_transport_fc cciss amd74xx sd_mod scsi_mod ide_disk ide_core
Feb 10 04:33:26 b021ple0 kernel: Pid: 24485, comm: multipathd Tainted: G     U 2.6.16.60-0.66.1-smp #1
Feb 10 04:33:26 b021ple0 kernel: RIP: 0010:[<ffffffff8810d34d>] <ffffffff8810d34d>{:dm_mod:__map_bio+69}
Feb 10 04:33:26 b021ple0 kernel: RSP: 0000:ffff8101167a1c18  EFLAGS: 00010202
Feb 10 04:33:26 b021ple0 kernel: RAX: 0000000000000000 RBX: 0000000021b61740 RCX: 0000000000000000
Feb 10 04:33:26 b021ple0 kernel: RDX: ffff8108ca288400 RSI: ffff810340e2a640 RDI: ffffc2000391f0e0
Feb 10 04:33:26 b021ple0 kernel: RBP: ffff810340e2a640 R08: ffff810774568b40 R09: ffff81046d4fe600
Feb 10 04:33:26 b021ple0 kernel: R10: 0000000000000002 R11: 0000000000000001 R12: ffff8108ca2883f0
Feb 10 04:33:26 b021ple0 kernel: R13: ffff8107e7568c00 R14: 0000000000000000 R15: ffffffff88110e9d
Feb 10 04:33:26 b021ple0 kernel: FS:  00002b755522d1c0(0000) GS:ffff810b71c2dec0(0000) knlGS:00000000df53dba0
Feb 10 04:33:26 b021ple0 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 10 04:33:26 b021ple0 kernel: CR2: 0000000000000030 CR3: 0000000190c26000 CR4: 00000000000006e0
Feb 10 04:33:26 b021ple0 kernel: Process multipathd (pid: 24485, threadinfo ffff8101167a0000, task ffff81069384e040)
Feb 10 04:33:26 b021ple0 kernel: Stack: ffffffffde49e8c0 ffff810774568b40 ffff81046ffa2200 ffffffffde49e8c0 
Feb 10 04:33:26 b021ple0 kernel:        ffff810774568b40 ffffffff8810ddfe 0000000000000000 ffffffff80118335 
Feb 10 04:33:26 b021ple0 kernel:        ffff8108ca2883f0 ffffc2000391f0e0 
Feb 10 04:33:26 b021ple0 kernel: Call Trace: <ffffffff8810ddfe>{:dm_mod:__split_bio+408}
Feb 10 04:33:26 b021ple0 kernel:        <ffffffff80118335>{smp_call_function+50} <ffffffff88110e9d>{:dm_mod:dev_suspend+0}
Feb 10 04:33:26 b021ple0 kernel:        <ffffffff8810e067>{:dm_mod:__flush_deferred_io+31} <ffffffff8810e664>{:dm_mod:dm_resume+160}
Feb 10 04:33:26 b021ple0 kernel:        <ffffffff88110feb>{:dm_mod:dev_suspend+334} <ffffffff88111801>{:dm_mod:ctl_ioctl+567}
Feb 10 04:33:26 b021ple0 kernel:        <ffffffff80199105>{do_ioctl+85} <ffffffff80199363>{vfs_ioctl+584}
Feb 10 04:33:26 b021ple0 kernel:        <ffffffff801993dd>{sys_ioctl+100} <ffffffff8010ae36>{system_call+126}
Feb 10 04:33:26 b021ple0 kernel: 
Feb 10 04:33:26 b021ple0 kernel: Code: ff 50 30 83 f8 00 89 c6 7e 73 48 8b 45 10 48 8b 80 98 00 00 
Feb 10 04:33:26 b021ple0 kernel: RIP <ffffffff8810d34d>{:dm_mod:__map_bio+69} RSP <ffff8101167a1c18>
Feb 10 04:33:26 b021ple0 kernel: CR2: 0000000000000030

I found that the error is in dm_mod 

Code starting with the faulting instruction
===========================================
   0:   ff 50 30                callq  *0x30(%rax)   <= in this function
   3:   83 f8 00                cmp    $0x0,%eax
   6:   89 c6                   mov    %eax,%esi
   8:   7e 73                   jle    0x7d
   a:   48 8b 45 10             mov    0x10(%rbp),%rax
   e:   48                      rex.W
   f:   8b                      .byte 0x8b
  10:   80                      .byte 0x80
  11:   98                      cwtl

And it directs me to 

0x34d is in __map_bio (drivers/md/dm.c:559).
554              * anything, the target has assumed ownership of
555              * this io.
556              */
557             atomic_inc(&tio->io->io_count);
558             sector = clone->bi_sector;
559             r = ti->type->map(ti, clone, &tio->info);   <==== to this line
560             if (r > 0) {
561                     /* the bio has been remapped so dispatch it */
562                     blk_add_trace_remap(bdev_get_queue(clone->bi_bdev), clone,
563                                         tio->io->bio->bi_bdev->bd_dev, sector,

After this the multipathd was in state <defunc>

Best regards

Jozef
