From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Patch to lsi rda  device handler
Date: Thu, 17 Jul 2008 15:30:26 -0700
Message-ID: <1216333826.27507.272.camel@chandra-ubuntu>
References: <00FE57DD11E3A94893D5BD54C3358BE884BE1F@AUSX3MPC128.aus.amer.dell.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <00FE57DD11E3A94893D5BD54C3358BE884BE1F@AUSX3MPC128.aus.amer.dell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yanqing_Liu@Dell.com
Cc: Ahmad_Ali@Dell.com, Shyam_Iyer@Dell.com, Jacob_Cherian@Dell.com, Charles_Rose@Dell.com, dm-devel@redhat.com, mchristi@redhat.com
List-Id: dm-devel.ids

Yanqing,

Thanks. Thee fix is in the set of patches that Hannes has sent (latest
one sent yesterday). It will make into 2.6.27.

Thanks,

chandra
On Thu, 2008-07-17 at 11:56 -0500, Yanqing_Liu@Dell.com wrote:
> Hello,
> 
> Here is the lsi rdac device handler code that was posted:
> 
> https://www.redhat.com/archives/dm-devel/2008-May/msg00003.html
> 
> The following patch is to address a NULL pointer problem in lsi rdac
> device handler.
> 
> In function get_rdac_req, after a request is successfully allocated,
> the area that the cmd pointer points to should be zeroed out. However,
> the function zeros out the command pointer itself, along with some
> other adjacent area. This results in NULL pointer dereference when
> submitting inquiry commands when checking virtual disk ownership
> during device discovery time. The kernel trace is attached at the end
> of the message.
> 
> The change is to zero out the area that the cmd pointer points to,
> instead of the pointer itself in the allocated request structure.
> 
> --- scsi_dh_rdac.c.orig 2008-07-17 01:53:10.000000000 -0400 
> +++ scsi_dh_rdac.c      2008-07-17 01:45:28.000000000 -0400 
> @@ -214,7 +214,7 @@ 
>                 return NULL; 
>         } 
>   
> -       memset(&rq->cmd, 0, BLK_MAX_CDB); 
> +       memset(rq->cmd, 0, BLK_MAX_CDB); 
>         rq->sense = h->sense; 
>         memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE); 
>         rq->sense_len = 0;
> 
> 
> Below is the kernel trace when problem happens, just for reference:
> 
> Jul 10 01:05:52 localhost kernel: In fn rdac_activate 
> Jul 10 01:05:52 localhost kernel: BUG: unable to handle kernel NULL
> pointer dereference at 0000000000000000 
> Jul 10 01:05:52 localhost kernel: IP:
> [<ffffffffa051e1d4>] :scsi_dh_rdac:submit_inquiry+0x42/0x8d 
> Jul 10 01:05:52 localhost kernel: PGD 0 
> Jul 10 01:05:52 localhost kernel: Oops: 0002 [1] SMP 
> Jul 10 01:05:52 localhost kernel: CPU 2 
> Jul 10 01:05:52 localhost kernel: Modules linked in: scsi_dh_rdac vfat
> fat autofs4 hidp rfcomm l2cap bluetooth sunrpc iptable_filter
> ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables
> ipv6 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
> iscsi_tcp libiscsi scsi_transport_iscsi dm_round_robin dm_multipath
> scsi_dh sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg
> usb_storage dcdbas ide_cd_mod cdrom bnx2 serio_raw button rtc_cmos
> rtc_core rtc_lib i5000_edac shpchp edac_core pcspkr dm_snapshot
> dm_zero dm_mirror dm_log dm_mod ata_piix libata megaraid_sas mptsas
> mptscsih scsi_transport_sas mptbase sd_mod scsi_mod ext3 jbd uhci_hcd
> ohci_hcd ehci_hcd [last unloaded: microcode]
> 
> Jul 10 01:05:52 localhost kernel: Pid: 5741, comm: kmpath_handlerd Not
> tainted 2.6.26-rc5 #1 
> Jul 10 01:05:52 localhost kernel: RIP: 0010:[<ffffffffa051e1d4>]
> [<ffffffffa051e1d4>] :scsi_dh_rdac:submit_inquiry+0x42/0x8d
> 
> Jul 10 01:05:52 localhost kernel: RSP: 0018:ffff81003c511dd0  EFLAGS:
> 00010246 
> Jul 10 01:05:52 localhost kernel: RAX: 0000000000000000 RBX:
> 00000000000000af RCX: 0000000000000001 
> Jul 10 01:05:52 localhost kernel: RDX: ffff81003c4818b8 RSI:
> 0000000000000000 RDI: ffff81003e82eb10 
> Jul 10 01:05:52 localhost kernel: RBP: 00000000000000c8 R08:
> 0000000000000003 R09: 0000000000000005 
> Jul 10 01:05:52 localhost kernel: R10: ffff81003a472c15 R11:
> 000000000000005d R12: ffff81003e82eb10 
> Jul 10 01:05:52 localhost multipathd: mpath2: event checker started 
> Jul 10 01:05:52 localhost kernel: R13: ffffffffa051f640 R14:
> ffff81003956d920 R15: 0000000000000000 
> Jul 10 01:05:52 localhost kernel: FS:  0000000000000000(0000)
> GS:ffff81003fa5be40(0000) knlGS:0000000000000000 
> Jul 10 01:05:52 localhost kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
> 000000008005003b 
> Jul 10 01:05:52 localhost kernel: CR2: 0000000000000000 CR3:
> 0000000000201000 CR4: 00000000000006e0 
> Jul 10 01:05:52 localhost kernel: DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000 
> Jul 10 01:05:52 localhost kernel: DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400 
> Jul 10 01:05:52 localhost kernel: Process kmpath_handlerd (pid: 5741,
> threadinfo ffff81003c510000, task ffff81003e9329a0)
> 
> Jul 10 01:05:52 localhost kernel: Stack:  ffff81003a472c00
> ffff81003956d800 ffff81003956d800 ffffffffa051e4db 
> Jul 10 01:05:52 localhost kernel:  ffff81003e9329a0 ffff81003a472c08
> ffff81003d5e67c0 ffffffff808d0700 
> Jul 10 01:05:52 localhost kernel:  0000000000000000 ffff81003d5e67c0
> ffff81003c511ed0 0000000000000000 
> Jul 10 01:05:52 localhost kernel: Call Trace: 
> Jul 10 01:05:52 localhost kernel:
> [<ffffffffa051e4db>] ? :scsi_dh_rdac:rdac_activate+0x70/0x461 
> Jul 10 01:05:52 localhost kernel:
> [<ffffffffa03050f4>] ? :scsi_dh:scsi_dh_activate+0x55/0x9c 
> Jul 10 01:05:52 localhost kernel:
> [<ffffffffa0310327>] ? :dm_multipath:activate_path+0x0/0x16d 
> Jul 10 01:05:52 localhost kernel:
> [<ffffffffa0310352>] ? :dm_multipath:activate_path+0x2b/0x16d 
> Jul 10 01:05:52 localhost kernel:
> [<ffffffffa0310327>] ? :dm_multipath:activate_path+0x0/0x16d 
> Jul 10 01:05:52 localhost kernel:  [<ffffffff8023fed9>] ?
> run_workqueue+0x7b/0x103 
> Jul 10 01:05:52 localhost kernel:  [<ffffffff80240754>] ?
> worker_thread+0xd5/0xe0 
> Jul 10 01:05:52 localhost kernel:  [<ffffffff80242f26>] ?
> autoremove_wake_function+0x0/0x2e 
> Jul 10 01:05:52 localhost kernel:  [<ffffffff8024067f>] ?
> worker_thread+0x0/0xe0 
> Jul 10 01:05:52 localhost kernel:  [<ffffffff80242df7>] ? kthread
> +0x47/0x74 
> Jul 10 01:05:53 localhost kernel:  [<ffffffff8022d674>] ?
> schedule_tail+0x28/0x5d 
> Jul 10 01:05:53 localhost kernel:  [<ffffffff8020cb98>] ? child_rip
> +0xa/0x12 
> Jul 10 01:05:53 localhost kernel:  [<ffffffff80242db0>] ? kthread
> +0x0/0x74 
> Jul 10 01:05:53 localhost kernel:  [<ffffffff8020cb8e>] ? child_rip
> +0x0/0x12 
> Jul 10 01:05:53 localhost kernel: 
> Jul 10 01:05:53 localhost multipathd: mpath0: event checker started 
> Jul 10 01:05:53 localhost kernel: 
> Jul 10 01:05:53 localhost multipathd: mpath13: event checker started 
> Jul 10 01:05:53 localhost kernel: Code: 04 0f 0b eb fe 48 8d 70 75 31
> c9 e8 c1 fe ff ff 48 85 c0 48 89 c2 b9 0c 00 00 00 74 52 48 8b 80 e8
> 00 00 00 b1 01 31 f6 4c 89 e7 <c6> 00 12 48 8b 82 e8 00 00 00 c6 40 01
> 01 48 8b 82 e8 00 00 00 
> 
> Jul 10 01:05:53 localhost multipathd: path checkers start up 
> Jul 10 01:05:53 localhost kernel: RIP
> [<ffffffffa051e1d4>] :scsi_dh_rdac:submit_inquiry+0x42/0x8d 
> Jul 10 01:05:53 localhost multipathd: dm-4: add map (uevent) 
> Jul 10 01:05:53 localhost kernel:  RSP <ffff81003c511dd0> 
> Jul 10 01:05:53 localhost multipathd: dm-4: devmap already registered 
> Jul 10 01:05:53 localhost kernel: CR2: 0000000000000000 
> Jul 10 01:05:53 localhost kernel: ---[ end trace
> f05af9e56671650e ]--- 
> Jul 10 01:08:52 localhost multipathd: dm-3: add map (uevent) 
> Jul 10 01:08:52 localhost multipathd: dm-3: devmap already registered 
> Jul 10 01:08:52 localhost multipathd: dm-2: remove map (uevent) 
> Jul 10 01:08:52 localhost multipathd: mpath2: map in use 
> Jul 10 01:08:52 localhost multipathd: mpath2: can't flush 
> Jul 10 01:11:52 localhost multipathd: dm-2: add map (uevent) 
> Jul 10 01:11:52 localhost multipathd: dm-2: devmap already registered 
> 
> Please provide any feedback that you may have.
> 
> Thanks, 
> Yanqing
> 
