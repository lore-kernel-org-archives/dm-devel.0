From: Steve Lord <stephen.lord@adic.com>
Subject: recursive stack overflow running multipath command
Date: Thu, 07 Jul 2005 17:01:52 -0500
Message-ID: <42CDA650.7090907@adic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,


I have been fighting getting multipath up and running for a few days now,
it seems to invariably end in one form of stack overflow or another.

Running on a fresh git tree just pulled from Linus's tree today then
patched with kdb, I loaded the dm-multipath module and just ran the
multipath command (from multipath-tools-0.4.4). The machine is running
Fedora Core 4.0

It came out with this output, then crashed very shortly afterwards:

create: 3600a0b800013cc690000002500000000
[size=20 MB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:13:7 sdaa 65:160  [ready ]
   \_ 4:0:12:7 sddd 70:176  [ready ]
   \_ 4:0:13:7 sddk 71:32   [ready ]
   \_ 3:0:12:7 sdt  65:48   [ready ]

create: 3600a0b800013cc690000001f42528e30
[size=271 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:14:0 sdab 65:176  [ready ]
   \_ 3:0:15:0 sdai 66:32   [ready ]
   \_ 4:0:14:0 sddl 71:48   [ready ]
   \_ 4:0:15:0 sdds 71:160  [ready ]
\_ round-robin 0
   \_ 4:0:12:0 sdcx 70:80   [ready ]
   \_ 4:0:13:0 sdde 70:192  [ready ]
   \_ 3:0:12:0 sdn  8:208   [ready ]
   \_ 3:0:13:0 sdu  65:64   [ready ]

create: 3600a0b800013cc6900000023425297f4
[size=271 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:14:1 sdac 65:192  [ready ]
   \_ 3:0:15:1 sdaj 66:48   [ready ]
   \_ 4:0:14:1 sddm 71:64   [ready ]
   \_ 4:0:15:1 sddt 71:176  [ready ]
\_ round-robin 0
   \_ 4:0:12:1 sdcy 70:96   [ready ]
   \_ 4:0:13:1 sddf 70:208  [ready ]
   \_ 3:0:12:1 sdo  8:224   [ready ]
   \_ 3:0:13:1 sdv  65:80   [ready ]

create: 3600a0b800013cc69000000244252980e
[size=271 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:14:2 sdad 65:208  [ready ]
   \_ 3:0:15:2 sdak 66:64   [ready ]
   \_ 4:0:14:2 sddn 71:80   [ready ]
   \_ 4:0:15:2 sddu 71:192  [ready ]
\_ round-robin 0
   \_ 4:0:12:2 sdcz 70:112  [ready ]
   \_ 4:0:13:2 sddg 70:224  [ready ]
   \_ 3:0:12:2 sdp  8:240   [ready ]
   \_ 3:0:13:2 sdw  65:96   [ready ]

create: 3600a0b800013c40b0000002342529b61
[size=271 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:14:3 sdae 65:224  [ready ]
   \_ 3:0:15:3 sdal 66:80   [ready ]
   \_ 4:0:14:3 sddo 71:96   [ready ]
   \_ 4:0:15:3 sddv 71:208  [ready ]
\_ round-robin 0
   \_ 4:0:12:3 sdda 70:128  [ready ]
   \_ 4:0:13:3 sddh 70:240  [ready ]
   \_ 3:0:12:3 sdq  65:0    [ready ]
   \_ 3:0:13:3 sdx  65:112  [ready ]

create: 3600a0b800013c40b0000001f42528f03
[size=271 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:14:4 sdaf 65:240  [ready ]
   \_ 3:0:15:4 sdam 66:96   [ready ]
   \_ 4:0:14:4 sddp 71:112  [ready ]
   \_ 4:0:15:4 sddw 71:224  [ready ]
\_ round-robin 0
   \_ 4:0:12:4 sddb 70:144  [ready ]
   \_ 4:0:13:4 sddi 71:0    [ready ]
   \_ 3:0:12:4 sdr  65:16   [ready ]
   \_ 3:0:13:4 sdy  65:128  [ready ]

create: 3600a0b800013c40b0000002442529b73
[size=271 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:14:5 sdag 66:0    [ready ]
   \_ 3:0:15:5 sdan 66:112  [ready ]
   \_ 4:0:14:5 sddq 71:128  [ready ]
   \_ 4:0:15:5 sddx 71:240  [ready ]
\_ round-robin 0
   \_ 4:0:12:5 sddc 70:160  [ready ]
   \_ 4:0:13:5 sddj 71:16   [ready ]
   \_ 3:0:12:5 sds  65:32   [ready ]
   \_ 3:0:13:5 sdz  65:144  [ready ]

create: 3600a0b800013c40b0000002500000000
[size=20 MB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:14:7 sdah 66:16   [ready ]
   \_ 3:0:15:7 sdao 66:128  [ready ]
   \_ 4:0:14:7 sddr 71:144  [ready ]
   \_ 4:0:15:7 sddy 128:0   [ready ]

create: 32000002037153c20
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:16:0 sdap 66:144  [ready ]
   \_ 4:0:16:0 sddz 128:16  [ready ]

create: 320000004cf733125
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:17:0 sdaq 66:160  [ready ]
   \_ 4:0:17:0 sdea 128:32  [ready ]

create: 320000004cf733094
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:18:0 sdar 66:176  [ready ]
   \_ 4:0:18:0 sdeb 128:48  [ready ]

create: 320000004cf73304a
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:19:0 sdas 66:192  [ready ]
   \_ 4:0:19:0 sdec 128:64  [ready ]

create: 320000004cf733041
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:20:0 sdat 66:208  [ready ]
   \_ 4:0:20:0 sded 128:80  [ready ]

create: 320000004cf732fe2
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:21:0 sdau 66:224  [ready ]
   \_ 4:0:21:0 sdee 128:96  [ready ]

create: 320000004cf733084
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:22:0 sdav 66:240  [ready ]
   \_ 4:0:22:0 sdef 128:112 [ready ]

create: 320000004cf732ff0
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:23:0 sdaw 67:0    [ready ]
   \_ 4:0:23:0 sdeg 128:128 [ready ]

create: 320000004cf7331ae
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:24:0 sdax 67:16   [ready ]
   \_ 4:0:24:0 sdeh 128:144 [ready ]

create: 320000004cf733115
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:25:0 sday 67:32   [ready ]
   \_ 4:0:25:0 sdei 128:160 [ready ]

create: 320000004cf733066
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:26:0 sdaz 67:48   [ready ]
   \_ 4:0:26:0 sdej 128:176 [ready ]

create: SFUJITSU_MAM3184MC______UKL3P2704365
[size=16 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 1:0:0:0 sda  8:0     [ready ]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
create: 320000004cf7331e6
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:27:0 sdba 67:64   [ready ]
   \_ 4:0:27:0 sdek 128:192 [ready ]

create: 320000004cf73317d
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:28:0 sdbb 67:80   [ready ]
   \_ 4:0:28:0 sdel 128:208 [ready ]

create: 320000004cf733139
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:29:0 sdbc 67:96   [ready ]
   \_ 4:0:29:0 sdem 128:224 [ready ]

create: 320000004cf7330f2
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:30:0 sdbd 67:112  [ready ]
   \_ 4:0:30:0 sden 128:240 [ready ]

create: 320000004cf7331aa
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:31:0 sdbe 67:128  [ready ]
   \_ 4:0:31:0 sdeo 129:0   [ready ]

create: 320000004cf7331ce
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:32:0 sdbf 67:144  [ready ]
   \_ 4:0:32:0 sdep 129:16  [ready ]

create: 320000004cf73303f
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:33:0 sdbg 67:160  [ready ]
   \_ 4:0:33:0 sdeq 129:32  [ready ]

create: 320000004cf7330f0
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:34:0 sdbh 67:176  [ready ]
   \_ 4:0:34:0 sder 129:48  [ready ]

create: 320000004cf7330c1
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:35:0 sdbi 67:192  [ready ]
   \_ 4:0:35:0 sdes 129:64  [ready ]

create: 320000004cf733071
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:36:0 sdbj 67:208  [ready ]
   \_ 4:0:36:0 sdet 129:80  [ready ]

create: 320000004cf73312b
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:37:0 sdbk 67:224  [ready ]
   \_ 4:0:37:0 sdeu 129:96  [ready ]

create: 320000004cf733083
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:38:0 sdbl 67:240  [ready ]
   \_ 4:0:38:0 sdev 129:112 [ready ]

create: 320000004cf733171
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:39:0 sdbm 68:0    [ready ]
   \_ 4:0:39:0 sdew 129:128 [ready ]

create: 320000004cf73301c
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:40:0 sdbn 68:16   [ready ]
   \_ 4:0:40:0 sdex 129:144 [ready ]

create: 320000004cf00f3b2
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:41:0 sdbo 68:32   [ready ]
   \_ 4:0:41:0 sdey 129:160 [ready ]

create: 320000004cf73307b
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:42:0 sdbp 68:48   [ready ]
   \_ 4:0:42:0 sdez 129:176 [ready ]

create: 320000004cf00f444
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:43:0 sdbq 68:64   [ready ]
   \_ 4:0:43:0 sdfa 129:192 [ready ]

create: 320000004cf733037
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:44:0 sdbr 68:80   [ready ]
   \_ 4:0:44:0 sdfb 129:208 [ready ]

create: 320000004cf733053
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:45:0 sdbs 68:96   [ready ]
   \_ 4:0:45:0 sdfc 129:224 [ready ]

create: 320000004cf73312a
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:46:0 sdbt 68:112  [ready ]

create: 320000004cf73304f
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:47:0 sdbu 68:128  [ready ]
   \_ 4:0:47:0 sdfe 130:0   [ready ]

create: 320000004cf733121
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:48:0 sdbv 68:144  [ready ]
   \_ 4:0:48:0 sdff 130:16  [ready ]

create: 320000004cf732dd2
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:49:0 sdbw 68:160  [ready ]
   \_ 4:0:49:0 sdfg 130:32  [ready ]

create: 32000002037153d46
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:50:0 sdbx 68:176  [ready ]
   \_ 4:0:50:0 sdfh 130:48  [ready ]

create: 320000004cf733033
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:51:0 sdby 68:192  [ready ]
   \_ 4:0:51:0 sdfi 130:64  [ready ]

create: 320000004cf732f2f
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:52:0 sdbz 68:208  [ready ]
   \_ 4:0:52:0 sdfj 130:80  [ready ]

create: 320000004cf87d4c0
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:0:0 sdb  8:16    [ready ]
   \_ 4:0:0:0 sdcl 69:144  [ready ]
   \_ 4:0:6:0 sdcr 69:240  [ready ]
   \_ 3:0:6:0 sdh  8:112   [ready ]

create: 320000004cf73307e
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:53:0 sdca 68:224  [ready ]
   \_ 4:0:53:0 sdfk 130:96  [ready ]

create: 32000002037153d60
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:54:0 sdcb 68:240  [ready ]
   \_ 4:0:54:0 sdfl 130:112 [ready ]

create: 320000004cf733161
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:55:0 sdcc 69:0    [ready ]
   \_ 4:0:55:0 sdfm 130:128 [ready ]

create: 32000000c500a715a
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:56:0 sdcd 69:16   [ready ]
   \_ 3:0:60:0 sdch 69:80   [ready ]
   \_ 4:0:56:0 sdfn 130:144 [ready ]
   \_ 4:0:60:0 sdfr 130:208 [ready ]

create: 32000000c500a71ca
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:57:0 sdce 69:32   [ready ]
   \_ 3:0:61:0 sdci 69:96   [ready ]
   \_ 4:0:57:0 sdfo 130:160 [ready ]
   \_ 4:0:61:0 sdfs 130:224 [ready ]

create: 32000000c5056bc99
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 3:0:58:0 sdcf 69:48   [ready ]
   \_ 3:0:62:0 sdcj 69:112  [ready ]
   \_ 4:0:58:0 sdfp 130:176 [ready ]
   \_ 4:0:62:0 sdft 130:240 [ready ]

create: 320000004cf87d4c5
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 4:0:1:0 sdcm 69:160  [ready ]
   \_ 4:0:7:0 sdcs 70:0    [ready ]
   \_ 3:0:1:0 sdc  8:32    [ready ]
   \_ 3:0:7:0 sdi  8:128   [ready ]

create: 320000004cf87d49e
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 4:0:2:0 sdcn 69:176  [ready ]
   \_ 4:0:9:0 sdcu 70:32   [ready ]
   \_ 3:0:2:0 sdd  8:48    [ready ]
   \_ 3:0:9:0 sdk  8:160   [ready ]

create: 320000004cf87d93b
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 4:0:3:0 sdco 69:192  [ready ]
   \_ 4:0:10:0 sdcv 70:48   [ready ]
   \_ 3:0:3:0 sde  8:64    [ready ]
   \_ 3:0:10:0 sdl  8:176   [ready ]

create: 320000004cf87d4bd
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 4:0:4:0 sdcp 69:208  [ready ]
   \_ 4:0:8:0 sdct 70:16   [ready ]
   \_ 3:0:4:0 sdf  8:80    [ready ]
   \_ 3:0:8:0 sdj  8:144   [ready ]

create: 320000004cf87d8ef
[size=34 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 4:0:5:0 sdcq 69:224  [ready ]
   \_ 4:0:11:0 sdcw 70:64   [ready ]
   \_ 3:0:5:0 sdg  8:96    [ready ]
   \_ 3:0:11:0 sdm  8:192   [ready ]

cannot signal daemon, pidfile not found

The oops output:
<6>device-mapper: dm-multipath version 1.0.4 loaded
[1]more>
<6>device-mapper: dm-round-robin version 1.0.0 loaded
<3>device-mapper: dm-multipath: error getting device
<4>device-mapper: error adding target to table
<1>Unable to handle kernel NULL pointer dereference at virtual address 00000000
<1> printing eip:
<4>c0147fd7
<1>*pde = 00000000
<1>Oops: 0000 [#1]
<4>SMP
<4>Modules linked in: dm_round_robin dm_multipath autofs4 nfs lockd sunrpc 
dm_mod video button battery ac sworks_agp agpgart e100 mii tg3 e1000 floppy sg 
qla2300 qla2xxx scsi_transport_fc aic7xxx scsi_transport_spi sd_mod scsi_mod
<4>CPU:    1
<4>EIP:    0060:[<c0147fd7>]    Not tainted VLI
<4>EFLAGS: 00010086   (2.6.13-rc2-kdb)
<4>EIP is at kmem_cache_alloc+0x1a/0x49
<4>eax: f7ea7a80   ebx: 00000292   ecx: f6c35980   edx: 00000000
<4>esi: f68ab440   edi: 00011210   ebp: f4424028   esp: f442401c
<4>ds: 007b   es: 007b   ss: 0068
<4>Process udev (pid: 19283, threadinfo=f4422000 task=f6be2a40)
<4>Stack: c014283d 00011200 f48a4700 f4424038 c014297c f6c35980 00011200 f4424070
<4>       c014283d 00011200 f6c35980 f68ab45c 00000000 00000000 00000000 f7e8d280
<4>       00000010 00000000 f48a4700 f48a4700 f7800180 f4424094 f8add590 f68ab440
<4>Call Trace:
<4> =======================
[1]more>
<4> =======================
<1>Unable to handle kernel paging request at virtual address 010c0030
<1> printing eip:
<4>c0103b57
<1>*pde = 00000000
<1>Oops: 0000 [#2]
<4>SMP
<4>Modules linked in: dm_round_robin dm_multipath autofs4 nfs lockd sunrpc 
dm_mod video button battery ac sworks_agp agpgart e100 mii tg3 e1000 floppy sg 
qla2300 qla2xxx scsi_transport_fc aic7xxx scsi_transport_spi sd_mod scsi_mod
<4>CPU:    1
<4>EIP:    0060:[<c0103b57>]    Not tainted VLI
<4>EFLAGS: 00010096   (2.6.13-rc2-kdb)
<4>EIP is at show_trace+0x79/0xaa
<4>eax: 010c1ffd   ebx: 010c0014   ecx: ffffffff   edx: 00000092
<4>esi: 010c0000   edi: f4423e84   ebp: f4423e84   esp: f4423e70
<4>ds: 007b   es: 007b   ss: 0068
<4>Process udev (pid: 19283, threadinfo=f4422000 task=f6be2a40)
<4>Stack: c02e6147 c011d3b2 00000018 f442407f 00000000 f4423ea0 c0103c22 00000000
<4>       f442401c f4422000 00010086 f4423fe8 f4423edc c0103ded 00000000 f442401c
<4>       00004b53 f4422000 f6be2a40 00010086 c031c2c2 00000001 f442401c 00000068
<4>Call Trace:
<4> [<c0103c22>] show_stack+0x9a/0xd0
<4> [<c0103ded>] show_registers+0x175/0x209
<4> [<c010400c>] die+0xfa/0x19c
[1]more> i
Only 'q' or 'Q' are processed at more prompt, input ignored
<4> [<c0115092>] do_page_fault+0x25b/0x717
<4> [<c0103843>] error_code+0x4f/0x54
<4> [<c0103c22>] show_stack+0x9a/0xd0
<4> [<c0103ded>] show_registers+0x175/0x209
<4> [<c010400c>] die+0xfa/0x19c
<4> [<c0115092>] do_page_fault+0x25b/0x717
<4> [<c0103843>] error_code+0x4f/0x54
<4>Code: 3b 61 2e c0 e8 62 98 01 00 89 5c 24 04 c7 04 24 02 db 2f c0 e8 b2 55 03 
00 c7 04 24 23 c2 2e c0 e8 46 98 01 00 8b 3f 39 fe 72 c1 <8b> 46 30 89 c3 85 c0 
74 0e c7 04 24 47 61 2e c0 e8 2b 98 01 00

And a kdb backtrace, which repeats ad infinitum until it crashes:


0xf4425714 0xc022fd89 generic_make_request+0x9b (0xf48a4680, 0xf48a4680, 
0xf40522d4, 0xf44257b0, 0xf40522cc)
0xf4425734 0xf8991371 [dm_mod]__map_bio+0x4e (0xf91ca080, 0xf48a4680, 
0xf40522cc, 0x0, 0x1)
0xf442579c 0xf89915d4 [dm_mod]__clone_and_map+0xe9 (0xf44257b0, 0x10, 0x0, 
0xf4cdf880, 0xf4c04280)
0xf44257dc 0xf8991968 [dm_mod]__split_bio+0xe6 (0xf4cdf880, 0xf48a4600, 0x0, 
0xf5f2602c, 0xf48a4600)
0xf44257f8 0xf8991a3d [dm_mod]dm_request+0x8c (0xf5f2602c, 0xf48a4600, 0x1000, 
0x0, 0xf454c080)
0xf4425854 0xc022fd89 generic_make_request+0x9b (0xf48a4600, 0xf48a4600, 
0xf40522e4, 0xf44258f0, 0xf40522dc)
0xf4425874 0xf8991371 [dm_mod]__map_bio+0x4e (0xf923e080, 0xf48a4600, 
0xf40522dc, 0x0, 0x1)
0xf44258dc 0xf89915d4 [dm_mod]__clone_and_map+0xe9 (0xf44258f0, 0x10, 0x0, 
0xf4be3e00, 0xf48e0880)
0xf442591c 0xf8991968 [dm_mod]__split_bio+0xe6 (0xf4be3e00, 0xf4e31980, 0x0, 
0xf44fcb00, 0xf4e31980)
0xf4425938 0xf8991a3d [dm_mod]dm_request+0x8c (0xf44fcb00, 0xf4e31980, 0x1000, 
0x0, 0xf5b12b80)
0xf4425994 0xc022fd89 generic_make_request+0x9b (0xf4e31980, 0xf4e31980, 
0xf40522f4, 0xf4425a30, 0xf40522ec)
0xf44259b4 0xf8991371 [dm_mod]__map_bio+0x4e (0xf92aa080, 0xf4e31980, 
0xf40522ec, 0x0, 0x1)
0xf4425a1c 0xf89915d4 [dm_mod]__clone_and_map+0xe9 (0xf4425a30, 0x10, 0x0, 
0xf465dd80, 0xf4618e80)
0xf4425a5c 0xf8991968 [dm_mod]__split_bio+0xe6 (0xf465dd80, 0xf4aa5c80, 0x0, 
0xf44cf1b8, 0xf4aa5c80)
0xf4425a78 0xf8991a3d [dm_mod]dm_request+0x8c (0xf44cf1b8, 0xf4aa5c80, 0x1000, 
0x0, 0xf4f28b00)
0xf4425ad4 0xc022fd89 generic_make_request+0x9b (0xf4aa5c80, 0xf4aa5c80, 
0xf4052ea4, 0xf4425b70, 0xf4052e9c)
0xf4425af4 0xf8991371 [dm_mod]__map_bio+0x4e (0xf9317080, 0xf4aa5c80, 
0xf4052e9c, 0x0, 0x1)
0xf4425b5c 0xf89915d4 [dm_mod]__clone_and_map+0xe9 (0xf4425b70, 0x10, 0x0, 
0xf465df00, 0xf4492b80)
0xf4425b9c 0xf8991968 [dm_mod]__split_bio+0xe6 (0xf465df00, 0xf4aa5d00, 0x0, 
0xf4d554d0, 0xf4aa5d00)
0xf4425bb8 0xf8991a3d [dm_mod]dm_request+0x8c (0xf4d554d0, 0xf4aa5d00, 0x0, 0x0, 
0xf478a700)
[1]more>
0xf4425c14 0xc022fd89 generic_make_request+0x9b (0xf4aa5d00, 0x8, 0xf4aa5d00, 
0x0, 0x0)
0xf4425c64 0xc022ffa3 submit_bio+0x51 (0x0, 0xf4aa5d00, 0x8, 0x0, 0xf4425cd0)
0xf4425c88 0xc016227b submit_bh+0xf4 (0x0, 0xf54d46fc, 0x0, 0xf54d46fc, 0x0)
0xf4425cfc 0xc01611d5 block_read_full_page+0x2cf (0xc168bb00, 0xc0165151)
0xf4425d0c 0xc01652d6 blkdev_readpage+0x19 (0xf5652280, 0xc168bb00, 0x0, 0xd0, 0x0)
0xf4425d70 0xc0146516 read_pages+0x7f (0xf478a818, 0xf5652280, 0xf4425d98, 0x8, 
0xf478a81c)
0xf4425dac 0xc01466e5 __do_page_cache_readahead+0x15f (0xf478a818, 0xf5652280, 
0x0, 0x8, 0x0)
0xf4425dd0 0xc014682c blockable_page_cache_readahead+0x61 (0xf478a818, 
0xf5652280, 0x0, 0x8, 0xf4425e44)
0xf4425dfc 0xc0146a6e page_cache_readahead+0x137 (0xf478a818, 0xf4425e44, 
0xf5652280, 0x0, 0x1)
0xf4425e78 0xc013fe8f do_generic_mapping_read+0x3e7 (0xf478a818, 0xf56522c8, 
0xf5652280, 0xf4425fa0, 0xf4425eac)
0xf4425ec8 0xc0140176 __generic_file_aio_read+0x172 (0xf4425ee0, 0xf4425f58, 
0x1, 0xf4425fa0, 0xbfb6c170)
0xf4425f64 0xc0140320 generic_file_read+0x9d (0xf5652280, 0x804e828, 0x200, 
0xf4425fa0, 0xf5652280)
0xf4425f88 0xc015db8d vfs_read+0x99 (0xf5652280, 0x804e828, 0x200, 0xf4425fa0, 
0x200)
0xf4425fb4 0xc015de6e sys_read+0x47
            0xc0102d51 syscall_call+0x7


I have done very little configuration on the machine, none of these disks have
a standard partition table on them. There are a fair number of dual port jbod
fiber channel disks on the san, and a 4 port LSI raid with 6 luns on it. The
machine has two HBA ports attached to the San.

Any suggestions? I presume udev is attempting to read from a device, but
device mapper is recursing back on itself rather than find one of the
base LUNs to talk to.

Thanks

    Steve
