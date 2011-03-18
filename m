From: "Janec, Jozef" <jozef.janec@hp.com>
Subject: orphan status and mixed pvs
Date: Fri, 18 Mar 2011 11:34:00 +0000
Message-ID: <A510D7CF8900D246979209B696F496F67EBC04F71F@GVW1088EXB.americas.hpqcorp.net>
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

Hello All,

I would like to ask what exactly means status : orphan.

We had one interesting issue on one server. We added next 8 disks to the server from eva, multipath detected new disks and created mpath targets. But the multipathd crashed, and swapped 2 devices:

LUNA (3600508b4001082ff0000900000ad0000) dm-62 HP,HSV210
[size=281G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=200][active]
 \_ 1:0:4:6   sdlj 68:272  [active][ready]
 \_ 0:0:4:6   sdbv 68:144  [active][ready]
 \_ 1:0:0:6   sdar 66:176  [active][ready]
 \_ 0:0:1:6   sdn  8:208   [active][ready]
\_ round-robin 0 [prio=40][enabled]
 \_ 1:0:5:6   sdmr 70:304  [active][ready]
 \_ 1:0:1:6   sdjl 8:496   [active][ready]
 \_ 0:0:7:6   sdet 129:80  [active][ready]
 \_ 0:0:6:6   sddl 71:48   [active][ready]

Which is used in fs

mpathbp (3600508b40007021c0000e00008990000) dm-77 HP,HSV210
[size=65G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=200][active]
 \_ 0:0:14:6  sdqx 133:272 [active][ready]
 \_ 0:0:15:6  sdrf 133:400 [active][ready]
 \_ 1:0:13:6  sdsd 135:272 [active][ready]
 \_ 1:0:15:6  sdst 8:528   [active][ready]
\_ round-robin 0 [prio=40][enabled]
 \_ 0:0:16:6  sdrn 134:272 [active][ready]
 \_ 0:0:17:6  sdrv 134:400 [active][ready]
 \_ 1:0:14:6  sdsl 135:400 [active][ready]
 \_ 1:0:16:6  sdtb 8:656   [active][ready]
New lun.

In multipathd -k we found:

From show paths:

0:0:14:6  sdqx 133:272 50  [active][ready] [orphan]        
0:0:15:6  sdrf 133:400 50  [active][ready] [orphan]
0:0:16:6  sdrn 134:272 10  [active][ready] [orphan]
0:0:17:6  sdrv 134:400 10  [active][ready] [orphan]
1:0:13:6  sdsd 135:272 50  [active][ready] [orphan]  
1:0:14:6  sdsl 135:400 10  [active][ready] [orphan]
1:0:15:6  sdst 8:528   50  [active][ready] [orphan]    
1:0:16:6  sdtb 8:656   10  [active][ready] [orphan]  

1:0:5:6   sdmr 70:304  10  [active][ready] XX........ 10/40
1:0:4:6   sdlj 68:272  50  [active][ready] XX........ 10/40
1:0:1:6   sdjl 8:496   10  [active][ready] XX........ 10/40
1:0:0:6   sdar 66:176  50  [active][ready] XX........ 10/40
0:0:7:6   sdet 129:80  10  [active][ready] XX........ 10/40
0:0:6:6   sddl 71:48   10  [active][ready] XX........ 10/40
0:0:4:6   sdbv 68:144  50  [active][ready] XX........ 10/40
0:0:1:6   sdn  8:208   50  [active][ready] XX........ 10/40

And after few sec the status was:

0:0:14:6  sdqx 133:272 50  [undef] [ready] [orphan] 
0:0:15:6  sdrf 133:400 50  [undef] [ready] [orphan]    
0:0:16:6  sdrn 134:272 10  [undef] [ready] [orphan] 
0:0:17:6  sdrv 134:400 10  [undef] [ready] [orphan]
1:0:13:6  sdsd 135:272 50  [undef] [ready] [orphan]
1:0:14:6  sdsl 135:400 10  [undef] [ready] [orphan]  
1:0:15:6  sdst 8:528   50  [undef] [ready] [orphan] 
1:0:16:6  sdtb 8:656   10  [undef] [ready] [orphan]   

  
1:0:5:6   sdmr 70:304  10  [undef] [ready] [orphan] 
1:0:4:6   sdlj 68:272  50  [undef] [ready] [orphan] 
1:0:1:6   sdjl 8:496   10  [undef] [ready] [orphan]  
1:0:0:6   sdar 66:176  50  [undef] [ready] [orphan]  
0:0:7:6   sdet 129:80  10  [undef] [ready] [orphan] 
0:0:6:6   sddl 71:48   10  [undef] [ready] [orphan] 
0:0:4:6   sdbv 68:144  50  [undef] [ready] [orphan]    
0:0:1:6   sdn  8:208   50  [undef] [ready] [orphan]  

All other luns were ok and in /var/log/messages:

Feb 10 04:33:26 server kernel: attempt to access beyond end of device
Feb 10 04:33:26 server kernel: dm-62: rw=0, want=409437569, limit=136314880
Feb 10 04:33:26 server kernel: attempt to access beyond end of device
Feb 10 04:33:26 server kernel: dm-62: rw=0, want=409438113, limit=136314880

Where we can see that dm-62 was directed to device with size 65G

And lvol located on this pv

Feb 10 04:42:55 server kernel: attempt to access beyond end of device
Feb 10 04:42:55 server kernel: dm-62: rw=1, want=350787672, limit=136314880
Feb 10 04:42:55 server kernel: Buffer I/O error on device dm-75, logical block 348689754
Feb 10 04:42:55 server kernel: lost page write due to I/O error on dm-75
Feb 10 04:43:17 server kernel: attempt to access beyond end of device
Feb 10 04:43:17 server kernel: dm-62: rw=1, want=455805408, limit=136314880
Feb 10 04:43:17 server kernel: Buffer I/O error on device dm-75, logical block 453708043
Feb 10 04:43:17 server kernel: lost page write due to I/O error on dm-75

And status of the  old lun was:

LUNA (3600508b4001082ff0000900000ad0000) dm-62 HP,HSV210
[size=65G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=200][enabled]
 \_ 1:0:15:6  sdst 8:528   [active][ready]
 \_ 1:0:13:6  sdsd 135:272 [active][ready]
 \_ 0:0:15:6  sdrf 133:400 [active][ready]
 \_ 0:0:14:6  sdqx 133:272 [active][ready]
\_ round-robin 0 [prio=40][enabled]
 \_ 1:0:16:6  sdtb 8:656   [active][ready]
 \_ 1:0:14:6  sdsl 135:400 [active][ready]
 \_ 0:0:17:6  sdrv 134:400 [active][ready]
 \_ 0:0:16:6  sdrn 134:272 [active][ready]

The LUNA has configured alias through multipath.conf

And this is responsible for this issue:

eb 10 04:33:26 server kernel: Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP:
Feb 10 04:33:26 server kernel: <ffffffff8810d34d>{:dm_mod:__map_bio+69}
Feb 10 04:33:26 server kernel: PGD 3798e1067 PUD 350556067 PMD 0
Feb 10 04:33:26 server kernel: Oops: 0000 [1] SMP
Feb 10 04:33:26 server kernel: last sysfs file: /block/dm-0/uevent
Feb 10 04:33:26 server kernel: CPU 6
Feb 10 04:33:26 server kernel: Modules linked in: nfs mptctl mptbase softdog ipmi_si ipmi_devintf ipmi_msghandler nfsd exportfs lockd nfs_acl hpilo sunrpc bonding i
pv6 dock button battery ac apparmor ext3 jbd loop dm_round_robin dm_multipath scsi_dh usbhid reiserfs dm_snapshot usb_storage sata_nv libata generic ide_cd cdrom e100
0 st bnx2 shpchp pci_hotplug ohci_hcd uhci_hcd ehci_hcd usbcore serio_raw pcmcia pcmcia_core edd dm_mod fan thermal processor sg qla2xxx firmware_class scsi_transport
_fc cciss amd74xx sd_mod scsi_mod ide_disk ide_core
Feb 10 04:33:26 server kernel: Pid: 24485, comm: multipathd Tainted: G     U 2.6.16.60-0.66.1-smp #1
Feb 10 04:33:26 server kernel: RIP: 0010:[<ffffffff8810d34d>] <ffffffff8810d34d>{:dm_mod:__map_bio+69}
Feb 10 04:33:26 server kernel: RSP: 0000:ffff8101167a1c18  EFLAGS: 00010202
Feb 10 04:33:26 server kernel: RAX: 0000000000000000 RBX: 0000000021b61740 RCX: 0000000000000000
Feb 10 04:33:26 server kernel: RDX: ffff8108ca288400 RSI: ffff810340e2a640 RDI: ffffc2000391f0e0
Feb 10 04:33:26 server kernel: RBP: ffff810340e2a640 R08: ffff810774568b40 R09: ffff81046d4fe600
Feb 10 04:33:26 server kernel: R10: 0000000000000002 R11: 0000000000000001 R12: ffff8108ca2883f0
Feb 10 04:33:26 server kernel: R13: ffff8107e7568c00 R14: 0000000000000000 R15: ffffffff88110e9d
Feb 10 04:33:26 server kernel: FS:  00002b755522d1c0(0000) GS:ffff810b71c2dec0(0000) knlGS:00000000df53dba0
Feb 10 04:33:26 server kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 10 04:33:26 server kernel: CR2: 0000000000000030 CR3: 0000000190c26000 CR4: 00000000000006e0
Feb 10 04:33:26 server kernel: Process multipathd (pid: 24485, threadinfo ffff8101167a0000, task ffff81069384e040)
Feb 10 04:33:26 server kernel: Stack: ffffffffde49e8c0 ffff810774568b40 ffff81046ffa2200 ffffffffde49e8c0
Feb 10 04:33:26 server kernel:        ffff810774568b40 ffffffff8810ddfe 0000000000000000 ffffffff80118335
Feb 10 04:33:26 server kernel:        ffff8108ca2883f0 ffffc2000391f0e0
Feb 10 04:33:26 server kernel: Call Trace: <ffffffff8810ddfe>{:dm_mod:__split_bio+408}
Feb 10 04:33:26 server kernel:        <ffffffff80118335>{smp_call_function+50} <ffffffff88110e9d>{:dm_mod:dev_suspend+0}
Feb 10 04:33:26 server kernel:        <ffffffff8810e067>{:dm_mod:__flush_deferred_io+31} <ffffffff8810e664>{:dm_mod:dm_resume+160}
Feb 10 04:33:26 server kernel:        <ffffffff88110feb>{:dm_mod:dev_suspend+334} <ffffffff88111801>{:dm_mod:ctl_ioctl+567}
Feb 10 04:33:26 server kernel:        <ffffffff80199105>{do_ioctl+85} <ffffffff80199363>{vfs_ioctl+584}
Feb 10 04:33:26 server kernel:        <ffffffff801993dd>{sys_ioctl+100} <ffffffff8010ae36>{system_call+126}
Feb 10 04:33:26 server kernel:
Feb 10 04:33:26 server kernel: Code: ff 50 30 83 f8 00 89 c6 7e 73 48 8b 45 10 48 8b 80 98 00 00
Feb 10 04:33:26 server kernel: RIP <ffffffff8810d34d>{:dm_mod:__map_bio+69} RSP <ffff8101167a1c18>
Feb 10 04:33:26 server kernel: CR2: 0000000000000030

So for the end I want to just say. We have already detected bug in multipathd daemon which when is mpath target busy only replace the devices behind the mpath target.
And the "solution was use aliases, or disable friendly names", but still nobody check how to avoid that multipathd daemon can remove devices which were used and replace them with other devices

Best regards

Jozef
