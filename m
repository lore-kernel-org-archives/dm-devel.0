From: Erez Zilber <erezz@voltaire.com>
Subject: multipath modules on RHAS4 up5 cause oops
Date: Thu, 24 Jan 2008 10:45:16 +0200
Message-ID: <4798501C.5000208@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, open-iscsi@googlegroups.com
List-Id: dm-devel.ids

Hi,

We're trying to use the multipath tool on RHAS4 up5 with open-iscsi in
the following way:

Starting open-iscsi:

[root@DBD6 ~]# /etc/init.d/iscsi start
Starting iSCSI initiator service:                          [  OK  ]
Setting up iSCSI targets: Login session [192.168.60.224:3260
iqn.2000-03.com.falconstor-ipstor.sr4g.Everyone-iSCSI-10005]
Login session [192.168.60.223:3260
iqn.2000-03.com.falconstor-ipstor.fiona.D2-3]
Login session [192.168.60.223:3260
iqn.2000-03.com.falconstor-ipstor.fiona.Everyone-iSCSI-4]
                                                           [  OK  ]
Starting multipath:

[root@DBD6 ~]# /etc/init.d/multipathd start
Starting multipathd daemon:                                [  OK  ]

Now, we have some iSCSI sessions:

[root@DBD6 ~]# iscsiadm -m session
iser: [1] 192.168.60.224:3260,0
iqn.2000-03.com.falconstor-ipstor.sr4g.Everyone-iSCSI-10005
iser: [2] 192.168.60.223:3260,0 iqn.2000-03.com.falconstor-ipstor.fiona.D2-3
iser: [3] 192.168.60.223:3260,0
iqn.2000-03.com.falconstor-ipstor.fiona.Everyone-iSCSI-4

Stopping multipath:

[root@DBD6 ~]# /etc/init.d/multipathd stop
Stopping multipathd daemon:                                [  OK  ]

Stopping open-iscsi:

[root@DBD6 ~]# /etc/init.d/iscsi stop
Stopping iSCSI initiator service: Logout session [1][192.168.60.224:3260
iqn.2000-03.com.falconstor-ipstor.sr4g.Everyone-iSCSI-10005]
Logout session [2][192.168.60.223:3260
iqn.2000-03.com.falconstor-ipstor.fiona.D2-3]
Logout session [3][192.168.60.223:3260
iqn.2000-03.com.falconstor-ipstor.fiona.Everyone-iSCSI-4]
                                                           [  OK  ]

Now, the multipath module is still running (I'm not sure if that's a
problem):

[root@DBD6 ~]# lsmod|grep mul
dm_multipath           22865  2 dm_round_robin
dm_mod                 74153  10 dm_mirror,dm_multipath

Looking at the multipath devices returns strange results (since the
iSCSI devices are already gone):

[root@DBD6 ~]# multipath -l
mpath1 (3600d02300063ccc6000000018031a702)
[size=21 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ #:#:#:#  -   8:32 [active]

mpath0 (3600d02300063ccc6000000018031a701)
[size=20 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#  -   8:48 [active]
\_ round-robin 0 [enabled]
 \_ #:#:#:#  -   8:16 [active]

Trying to run INQUIRY fails (of course):

[root@DBD6 ~]# sg_inq /dev/mapper/mpath0
36 byte INQUIRY failed

Now, when I try to start open-iscsi, I get an oops:
[root@DBD6 ~]# /etc/init.d/iscsi start
Starting iSCSI initiator service:                          [  OK  ]
Setting up iSCSI targets: Login session [192.168.60.224:3260
iqn.2000-03.com.falconstor-ipstor.sr4g.Everyone-iSCSI-10005]
Login session [192.168.60.223:3260
iqn.2000-03.com.falconstor-ipstor.fiona.D2-3]
iscsiadm: Could not login session (err 4).

iscsiadm: initiator reported error (4 - encountered connection failure)
Login session [192.168.60.223:3260
iqn.2000-03.com.falconstor-ipstor.fiona.Everyone-iSCSI-4]
iscsiadm: Could not login session (err 4).

iscsiadm: initiator reported error (4 - encountered connection failure)
                                                           [  OK  ]

Here's the oops:

[root@DBD6 ~]# Jan 24 09:41:45 DBD6 kernel: Loading iSCSI transport
class v2.0-iscsi: registered transport (tcp)
724.
iscsi: registered transport (iser)
Jan 24 09:41:45 DBD6 kernel: isciser: iser_connect:connecting to:
192.168.60.224, port 0xbc0c
si: registered tiser: iser_cma_handler:event 0 conn 00000100762751c0 id
0000010001765e00
ransport (tcp)
iser: iser_cma_handler:event 2 conn 00000100762751c0 id 0000010001765e00
iser: iser_create_ib_conn_res:setting conn 00000100762751c0 cma_id
0000010001765e00: fmr_pool 000001007da5f880 qp 0000010079e19a00
Jan 24 09:41:45 DBD6 kernel: iscsi: registered transport (iser)
iser: iser_cma_handler:event 9 conn 00000100762751c0 id 0000010001765e00
iser: iscsi_iser_ep_poll:ib conn 00000100762751c0 rc = 1
Jan 24 09:41:45 DBD6 kernel: iser: iser_connect:connecting to:
192.168.60.224, port 0xbc0c
iser: iscsi_iser_conn_bind:binding iscsi conn 0000010075477d70 to
iser_conn 00000100762751c0
Jan 24 09:41:45 DBD6 kernel: iser: iser_cma_handler:event 0 conn
00000100762751c0 id 0000010001765e00
Jan 24 09:41:45 DBD6 kernel: iser: iser_cma_handler:event 2 conn
00000100762751c0 id 0000010001765e00
Jan 24 09:41:45 DBD6 kernel: iser: iser_create_ib_conn_res:setting conn
00000100762751c0 cma_id 0000010001765e00: fmr_pool 000001007da5f880 qp
0000010079e19a00
Jan 24 09:41:45 DBD6 kernel: iser: iser_cma_handler:event 9 conn
00000100762751c0 id 0000010001765e00
Jan 24 09:41:45 DBD6 kernel: iser: iscsi_iser_ep_poll:ib conn
00000100762751c0 rc = 1
Jan 24 09:41:45 DBD6 kernel: scsi5 : iSCSI Initiator over iSER, v.0.1
Jan 24 09:41:45 DBD6 kernel: iser: iscsi_iser_conn_bind:binding iscsi
conn 0000010075477d70 to iser_conn 00000100762751c0
  Vendor: IFT       Model: ES A16F-G         Rev: 331J
Jan 24 09:41:48   Type:   Direct-Access     DBD6 kernel:  
V                 ANSI SCSI revision: 03endor: IFT
 Model: ES A16F-SCSI device sde: 43008000 512-byte hdwr sectors (22020 MB)
G         Rev: 3SCSI device sde: drive cache: write through
31J
SCSI device sde: 43008000 512-byte hdwr sectors (22020 MB)
SCSI device sde: drive cache: write through
Jan 24 09:41:48 DBD6 kernel:   TAttached scsi disk sde at scsi5, channel
0, id 0, lun 0
ype:   Direct-Access                      ANSI SAttached scsi generic
sg1 at scsi5, channel 0, id 0, lun 0,  type 0
CSI revision: 03
iser: iser_connect:connecting to: 192.168.60.223, port 0xbc0c
iser: iser_cma_handler:event 0 conn 00000100762775c0 id 000001007549dc00
Jan 24 09:41:48 iser: iser_cma_handler:event 2 conn 00000100762775c0 id
000001007549dc00
DBD6 kernel: SCSI device sde: 43008000 512-byte hdwr sectors (22020 MB)
iser: iser_create_ib_conn_res:setting conn 00000100762775c0 cma_id
000001007549dc00: fmr_pool 000001007c5ed700 qp 000001000173bc00
iser: iser_cma_handler:event 8 conn 00000100762775c0 id 000001007549dc00
Jan 24 09:41:48 iser: iser_cma_handler:event: 8, error: 10
DBD6 kernel: SCSI device sde: drive cache: write through
Jan 24 09:41:48 DBD6 kernel: SCSI device sde: 43008000 512-byte hdwr
sectors (22020 MB)
Jan 24 09:41:48 DBD6 kernel: SCSI device sde: drive cache: write through
Jan 24 09:41:48 DBD6 kernel:  sde: sde1
Jan 24 09:41:48 DBD6 kernel: Attached scsi disk sde at scsi5, channel 0,
id 0, lun 0
Jan 24 09:41:48 DBD6 kernel: Attached scsi generic sg1 at scsi5, channel
0, id 0, lun 0,  type 0
iser: iscsi_iser_ep_poll:ib conn 00000100762775c0 rc = -1
Jan 24 09:41:48 iser: iscsi_iser_ep_disconnect:ib conn 00000100762775c0
state 4
DBD6 kernel: iseiser: iser_free_ib_conn_res:freeing conn
00000100762775c0 cma_id 000001007549dc00 fmr pool 000001007c5ed700 qp
000001000173bc00
r: iser_connect:iser: iser_device_try_release:device 000001007da5f780
refcount 1
connecting to: 1iser: iser_connect:connecting to: 192.168.60.223, port
0xbc0c
92.168.60.223, piser: iser_cma_handler:event 0 conn 00000100762775c0 id
000001007587dc00
ort 0xbc0c
Janiser: iser_cma_handler:event 2 conn 00000100762775c0 id 000001007587dc00
 24 09:41:48 DBD6 kernel: iser: iser_cma_handler:event 0 conn
00000100762775c0 id 000001007549dc00
iser: iser_create_ib_conn_res:setting conn 00000100762775c0 cma_id
000001007587dc00: fmr_pool 000001007da69900 qp 000001007587d800
iser: iser_cma_handler:event 8 conn 00000100762775c0 id 000001007587dc00
iser: iser_cma_handler:event: 8, error: 10
Jan 24 09:41:48 DBD6 kernel: iser: iser_cma_handler:event 2 conn
00000100762775c0 id 000001007549dc00
Jan 24 09:41:48 DBD6 kernel: iser: iser_create_ib_conn_res:setting conn
00000100762775c0 cma_id 000001007549dc00: fmr_pool 000001007c5ed700 qp
000001000173bc00
Jan 24 09:41:48 DBD6 kernel: iser: iser_cma_handler:event 8 conn
00000100762775c0 id 000001007549dc00
Jan 24 09:41:48 DBD6 kernel: iser: iser_cma_handler:event: 8, error: 10
Jan 24 09:41:48 DBD6 kernel: iser: iscsi_iser_ep_poll:ib conn
00000100762775c0 rc = -1
Jan 24 09:41:48 DBD6 kernel: iser: iscsi_iser_ep_disconnect:ib conn
00000100762775c0 state 4
Jan 24 09:41:48 iser: iscsi_iser_ep_poll:ib conn 00000100762775c0 rc = -1
DBD6 kernel: iseiser: iscsi_iser_ep_disconnect:ib conn 00000100762775c0
state 4
r: iser_free_ib_iser: iser_free_ib_conn_res:freeing conn
00000100762775c0 cma_id 000001007587dc00 fmr pool 000001007da69900 qp
000001007587d800
conn_res:freeingiser: iser_device_try_release:device 000001007da5f780
refcount 1
 conn 00000100762775c0 cma_id 000001007549dc00 fmr pool 000001007c5ed700
qp 000001000173bc00
Jan 24 09:41:48 DBD6 kernel: iser: iser_device_try_release:device
000001007da5f780 refcount 1
Jan 24 09:41:48 DBD6 kernel: iser: iser_connect:connecting to:
192.168.60.223, port 0xbc0c
Jan 24 09:41:48 DBD6 kernel: iser: iser_cma_handler:event 0 conn
00000100762775c0 id 000001007587dc00
Jan 24 09:41:49 DBD6 kernel: iser: iser_cma_handler:event 2 conn
00000100762775c0 id 000001007587dc00
Jan 24 09:41:49 DBD6 kernel: iser: iser_create_ib_conn_res:setting conn
00000100762775c0 cma_id 000001007587dc00: fmr_pool 000001007da69900 qp
000001007587d800
Jan 24 09:41:49 DBD6 kernel: iser: iser_cma_handler:event 8 conn
00000100762775c0 id 000001007587dc00
Jan 24 09:41:49 DBD6 kernel: iser: iser_cma_handler:event: 8, error: 10
Jan 24 09:41:49 DBD6 kernel: iser: iscsi_iser_ep_poll:ib conn
00000100762775c0 rc = -1
Jan 24 09:41:49 DBD6 kernel: iser: iscsi_iser_ep_disconnect:ib conn
00000100762775c0 state 4
Jan 24 09:41:49 DBD6 kernel: iser: iser_free_ib_conn_res:freeing conn
00000100762775c0 cma_id 000001007587dc00 fmr pool 000001007da69900 qp
000001007587d800
Jan 24 09:41:49 DBD6 kernel: iser: iser_device_try_release:device
000001007da5f780 refcount 1
Unable to handle kernel paging request at ffffffffa0338580 RIP:
<ffffffffa0002f51>{:scsi_mod:scsi_device_put+14}
PML4 103027 PGD 105027 PMD 78cc5067 PTE 0
Oops: 0000 [1] SMP
CPU 2
Modules linked in: ib_iser(U) iscsi_tcp(U) libiscsi(U)
scsi_transport_iscsi(U) sg dm_round_robin parport_pc lp parport autofs4
i2c_dev i2c_core nfs lockd nfs_acl rdma_ucm(U) rds(U) ib_sdp(U)
rdma_cm(U) iw_cm(U) ib_addr(U) mlx4_ib(U) mlx4_core(U) ib_mthca(U)
sunrpc ds yenta_socket pcmcia_core dm_mirror dm_multipath dm_mod button
battery ac joydev uhci_hcd ehci_hcd ib_ipoib(U) ib_umad(U) ib_ucm(U)
ib_uverbs(U) ib_cm(U) ib_sa(U) ib_mad(U) ib_core(U) md5 ipv6 tg3 sd_mod
ext3 jbd ata_piix libata scsi_mod
Pid: 8039, comm: multipath Not tainted 2.6.9-55.ELsmp
RIP: 0010:[<ffffffffa0002f51>]
<ffffffffa0002f51>{:scsi_mod:scsi_device_put+14}
RSP: 0018:000001006f6b3c28  EFLAGS: 00010202
RAX: ffffffffa0338580 RBX: 000001007008d000 RCX: 000001000000d000
RDX: 0000000000000202 RSI: 0000000000000008 RDI: 000001007008d000
RBP: 000001007008d000 R08: 000001007daaa498 R09: 0000000000000000
R10: 0000000000000008 R11: ffffffffa0083cb2 R12: ffffffffa0086500
R13: 000001007008d000 R14: 000001007a769a80 R15: 0000000000000000
FS:  0000002a955898c0(0000) GS:ffffffff804ed800(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffa0338580 CR3: 00000000016de000 CR4: 00000000000006e0
Process multipath (pid: 8039, threadinfo 000001006f6b2000, task
000001007c5627f0)
Stack: 000001007d846950 ffffffffa008207c 000001007d846940 000001007a7699c0
       000001007d889c00 ffffffffa008270d 0000000000000008 0000000000000001
       000001007a7699c0 ffffffff80180ec1
Call Trace:<ffffffffa008207c>{:sd_mod:scsi_disk_put+81}
<ffffffffa008270d>{:sd_mod:sd_release+112}
       <ffffffff80180ec1>{blkdev_put+161}
<ffffffffa01822a0>{:dm_mod:dev_suspend+0}
       <ffffffffa017ffb1>{:dm_mod:close_dev+27}
<ffffffffa017ffd2>{:dm_mod:dm_put_device+23}
       <ffffffffa019263c>{:dm_multipath:free_priority_group+96}
       <ffffffffa019269a>{:dm_multipath:free_multipath+65}
       <ffffffffa017fec4>{:dm_mod:table_destroy+72}
<ffffffffa017f57d>{:dm_mod:dm_swap_table+119}
       <ffffffffa01822a0>{:dm_mod:dev_suspend+0}
<ffffffffa018254a>{:dm_mod:dev_suspend+682}
       <ffffffffa01835e3>{:dm_mod:ctl_ioctl+602}
<ffffffff8018b8d5>{sys_ioctl+853}
       <ffffffff8011026a>{system_call+126}

Code: 48 8b 10 48 85 d2 74 29 65 8b 04 25 34 00 00 00 89 c0 48 c1
RIP <ffffffffa0002f51>{:scsi_mod:scsi_device_put+14} RSP <000001006f6b3c28>
CR2: ffffffffa0338580
 <0>Kernel panic - not syncing: Oops

Now, some questions:

   1. Is it a known bug?
   2. If yes, is there any workaround?
   3. Is there a newer version of dm that works ok on RHAS4 up5? Which
      version?
   4. In RHEL5, this test seems to work ok, but I see that after running
      /etc/init.d/multipath stop, the dm modules are still running. Why?
   5. IN RHEL5, if I do the following:
         1. start open-iscsi
         2. start multipath
         3. stop multipath
         4. stop open-iscsi
         5. start open-iscsi - now running 'multipath -l' shows the
            multipath devices althoguh the multipath service is stopped.
            Why?

Thanks,
Erez
