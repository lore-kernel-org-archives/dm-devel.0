From: Roberto Giordani <r.giordani@libero.it>
Subject: Re: multipathd: 8:80 mark as failed - BUG: unable to
 handle kernel NULL pointer dereference at (null)
Date: Wed, 06 Jun 2012 17:05:40 +0200
Message-ID: <4FCF71C4.9030708@libero.it>
References: <4FB4CB5E.9040600@libero.it> <4FBA569C.4080408@libero.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3805478878598775619=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FBA569C.4080408@libero.it>
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

This is a multi-part message in MIME format.
--===============3805478878598775619==
Content-Type: multipart/alternative;
	boundary="------------040102030807040401040406"

This is a multi-part message in MIME format.
--------------040102030807040401040406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx3-phx2.redhat.com id q56F7b1h025423

Hello,
I've got the same error re-building the last version of multipath-tools
from source
Could someone fix the problem?

/[1305052.764077]  rport-4:0-1: blocked FC remote port time out:
removing target and saving binding
[1305052.764136] sd 4:0:1:0: [sdh] Unhandled error code
[1305052.764140] sd 4:0:1:0: [sdh]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.764145] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 0c 2e c1 f0 00
00 08 00
[1305052.764154] end_request: I/O error, dev sdh, sector 204390896
[1305052.764171] sd 4:0:1:0: [sdh] Unhandled error code
[1305052.764173] sd 4:0:1:0: [sdh]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.764176] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 00 03 e1 58 00
00 08 00
[1305052.764184] end_request: I/O error, dev sdh, sector 254296
[1305052.764190] sd 4:0:1:0: [sdh] Unhandled error code
[1305052.764192] sd 4:0:1:0: [sdh]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.764196] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 00 03 e1 68 00
00 08 00
[1305052.764203] end_request: I/O error, dev sdh, sector 254312
[1305052.764209] device-mapper: multipath: Failing path 8:112.
[1305052.764232] sd 4:0:1:0: [sdh] Unhandled error code
[1305052.764235] sd 4:0:1:0: [sdh]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.764240] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 05 09 c3 38 00
00 08 00
[1305052.764249] end_request: I/O error, dev sdh, sector 84525880
[1305052.764260] sd 4:0:1:0: [sdh] Unhandled error code
[1305052.764262] sd 4:0:1:0: [sdh]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.764265] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 06 3d da 38 00
00 08 00
[1305052.764272] end_request: I/O error, dev sdh, sector 104716856
[1305052.764277] sd 4:0:1:0: [sdh] Unhandled error code
[1305052.764279] sd 4:0:1:0: [sdh]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.764282] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 06 3d da 70 00
00 08 00
[1305052.764290] end_request: I/O error, dev sdh, sector 104716912
[1305052.764349]  rport-4:0-0: blocked FC remote port time out: removing
target and saving binding
[1305052.792192] sd 4:0:1:0: [sdh] Synchronizing SCSI cache
[1305052.792269] sd 4:0:1:0: [sdh]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.820160] sd 4:0:1:1: [sdi] Synchronizing SCSI cache
[1305052.820198] sd 4:0:1:1: [sdi]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.852156] sd 4:0:0:0: [sdf] Synchronizing SCSI cache
[1305052.852194] sd 4:0:0:0: [sdf]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.884149] sd 4:0:0:1: [sdg] Synchronizing SCSI cache
[1305052.884185] sd 4:0:0:1: [sdg]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892080]  rport-3:0-0: blocked FC remote port time out: removing
target and saving binding
[1305052.892120] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892129] sd 3:0:0:0: [sdb]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892135] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 07 22 27 70 00
00 20 00
[1305052.892147] end_request: I/O error, dev sdb, sector 119678832
[1305052.892164] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892166] sd 3:0:0:0: [sdb]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892169] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 0c 2f 1b 90 00
00 08 00
[1305052.892177] end_request: I/O error, dev sdb, sector 204413840
[1305052.892186] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892189] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892193] sd 3:0:0:0: [sdb]=20
[1305052.892195] sd 3:0:0:0: [sdb]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892199] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[1305052.892203] sd 3:0:0:0: [sdb] CDB:
[1305052.892205] sd 3:0:0:0: [sdb] CDB: Write(10)Write(10): 2a: 00 00 03
2a e1 60 00 00 00 08 00
[1305052.892226]  05
[1305052.892228] end_request: I/O error, dev sdb, sector 254304
[1305052.892231]  09 c3 40 00 00 28 00
[1305052.892236] end_request: I/O error, dev sdb, sector 84525888
[1305052.892239] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892242] sd 3:0:0:0: [sdb]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892246] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 00 03 e1 68
[1305052.892253] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892255]  00
[1305052.892258] sd 3:0:0:0: [sdb]   00 08 00
[1305052.892262] end_request: I/O error, dev sdb, sector 254312
[1305052.892266] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[1305052.892268] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d
[1305052.892274] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892276]  da
[1305052.892279] sd 3:0:0:0: [sdb]   48 00 00Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[1305052.892286]  08
[1305052.892288] sd 3:0:0:0: [sdb] CDB:  00
[1305052.892293] end_request: I/O error, dev sdb, sector 104716872
[1305052.892295] Write(10): 2a 00 00 03 e1 58 00 00
[1305052.892302] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892304]  08
[1305052.892308] sd 3:0:0:0: [sdb]   00
[1305052.892311] end_request: I/O error, dev sdb, sector 254296
[1305052.892314] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[1305052.892317] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d
[1305052.892322] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892324]  da
[1305052.892326] sd 3:0:0:0: [sdb]   78Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892333]  00
[1305052.892335] sd 3:0:0:0: [sdb] CDB:  00Write(10): 2a 08 00 0c 2e c1
00 f0 00 00
[1305052.892349]  08
[1305052.892353] end_request: I/O error, dev sdb, sector 104716920
[1305052.892354]  00
[1305052.892358] end_request: I/O error, dev sdb, sector 204390896
[1305052.892364] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892366] sd 3:0:0:0: [sdb]=20
[1305052.892367] device-mapper: multipath: Failing path 8:16.
[1305052.892371] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[1305052.892373] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d da 70 00
00 08 00
[1305052.892381] end_request: I/O error, dev sdb, sector 104716912
[1305052.892388] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892390]  rport-3:0-1: blocked FC remote port time out: removing
target and saving binding
[1305052.892394] sd 3:0:0:0: [sdb]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892398] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d da 38 00
00 08 00
[1305052.892405] end_request: I/O error, dev sdb, sector 104716856
[1305052.892415] sd 3:0:0:0: [sdb] Unhandled error code
[1305052.892417] sd 3:0:0:0: [sdb]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.892420] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 05 09 c3 38 00
00 08 00
[1305052.892427] end_request: I/O error, dev sdb, sector 84525880
[1305052.892732] device-mapper: multipath: Failing path 8:16.
[1305052.892796] device-mapper: multipath: Failing path 8:48.
[1305052.892813] scsi 4:0:0:0: rejecting I/O to dead device
[1305052.892818] device-mapper: multipath: Failing path 8:80.
[1305052.894120] device-mapper: multipath: Failing path 8:16.
[1305052.894165] device-mapper: multipath: Failing path 8:48.
[1305052.894178] scsi 4:0:0:0: rejecting I/O to dead device
[1305052.894182] device-mapper: multipath: Failing path 8:80.
[1305052.900596] device-mapper: multipath: adding disabled device 8:96
[1305052.900940] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[1305052.900958] IP: [<ffffffffa08dfa63>]
dm_set_device_limits+0x23/0x140 [dm_mod]
[1305052.900977] PGD 34ff23067 PUD 350859067 PMD 0
[1305052.900984] Oops: 0000 [#1] SMP
[1305052.900989] last sysfs file: /sys/module/scsi_dh_rdac/initstate
[1305052.900994] CPU 3
[1305052.900996] Modules linked in: loop ocfs2 ocfs2_nodemanager
quota_tree ocfs2_stack_user ocfs2_stackglue dlm configfs nbd usbbk netbk
blkbk blkback_pagemap blktap domctl xenbus_be gntdev evtchn bridge stp
llc bonding edd ext4 jbd2 crc16 scsi_dh_rdac dm_round_robin dm_multipath
scsi_dh dm_mod ibmpex ibmaem i5k_amb iTCO_wdt ses iTCO_vendor_support
enclosure e1000e sg ipmi_msghandler bnx2 sr_mod i2c_i801 pcspkr
ics932s401 joydev serio_raw ioatdma i5000_edac 8250_pnp edac_core 8250
serial_core button shpchp pci_hotplug reiserfs usbhid hid uhci_hcd
radeon ttm drm_kms_helper drm i2c_algo_bit ehci_hcd usbcore i2c_core
qla2xxx xenblk cdrom xennet fan processor ata_generic thermal
thermal_sys hwmon aacraid
[1305052.901095]
[1305052.901099] Pid: 2952, comm: multipathd Not tainted
2.6.37.6-0.9-xen #1 IBM IBM System x3650 -[7979AC1]-/System Planar
[1305052.901109] RIP: e030:[<ffffffffa08dfa63>]  [<ffffffffa08dfa63>]
dm_set_device_limits+0x23/0x140 [dm_mod]
[1305052.901119] RSP: e02b:ffff88034b8a1c78  EFLAGS: 00010296
[1305052.901124] RAX: ffff8802dff306f8 RBX: ffff8802a6504940 RCX:
0000000000200000
[1305052.901128] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffffc9000003e040
[1305052.901133] RBP: ffffc9000003e040 R08: ffff88034b8a1d58 R09:
0000000000000200
[1305052.901138] R10: 0000000000000008 R11: 00003ffffffff000 R12:
ffff8802dff306f8
[1305052.901143] R13: 0000000000000000 R14: ffff88034b8a1d58 R15:
ffff8802dff306c0
[1305052.901152] FS:  00007f4856b6b700(0000) GS:ffff8803602f5000(0000)
knlGS:0000000000000000
[1305052.901157] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[1305052.901161] CR2: 0000000000000000 CR3: 000000034da6f000 CR4:
0000000000042660
[1305052.901166] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1305052.901171] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[1305052.901176] Process multipathd (pid: 2952, threadinfo
ffff88034b8a0000, task ffff8803508b84c0)
[1305052.901181] Stack:
[1305052.901183]  00000000000000d2 ffff880351c50b80 ffff88034b8a1cc8
0000000000000003
[1305052.901191]  ffff880351c50bf0 0000000000000001 ffff880351c50ba0
ffffffff8005e61f
[1305052.901199]  ffff88034b8a1ce8 ffffffff8002e082 ffff8802a6504940
ffffc9000003e040
[1305052.901206] Call Trace:
[1305052.901236]  [<ffffffffa0903425>]
multipath_iterate_devices+0x55/0x80 [dm_multipath]
[1305052.901248]  [<ffffffffa08e082c>]
dm_calculate_queue_limits+0x8c/0x130 [dm_mod]
[1305052.901268]  [<ffffffffa08de73b>] dm_swap_table+0x6b/0x90 [dm_mod]
[1305052.901285]  [<ffffffffa08e3048>] do_resume+0x88/0x1b0 [dm_mod]
[1305052.901309]  [<ffffffffa08e3e6c>] ctl_ioctl+0x1ac/0x250 [dm_mod]
[1305052.901335]  [<ffffffffa08e3f1e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
[1305052.901360]  [<ffffffff8012da89>] do_vfs_ioctl+0x89/0x340
[1305052.901369]  [<ffffffff8012ddc0>] sys_ioctl+0x80/0xa0
[1305052.901378]  [<ffffffff80007448>] system_call_fastpath+0x16/0x1b
[1305052.901386]  [<00007f48559d7d87>] 0x7f48559d7d87
[1305052.901390] Code: fd ff ff 0f 1f 44 00 00 48 83 ec 78 48 89 6c 24
58 4c 89 64 24 60 48 89 fd 4c 89 6c 24 68 48 89 5c 24 50 49 89 d5 4c 89
74 24 70 <4c> 8b 36 4d 89 c4 49 8b 86 a0 00 00 00 48 8b 98 10 03 00 00 48
[1305052.901441] RIP  [<ffffffffa08dfa63>]
dm_set_device_limits+0x23/0x140 [dm_mod]
[1305052.901451]  RSP <ffff88034b8a1c78>
[1305052.901453] CR2: 0000000000000000
[1305052.902033] ---[ end trace 876924144444c2e5 ]---
[1305052.912171] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[1305052.912223] sd 3:0:0:0: [sdb]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.940154] sd 3:0:0:1: [sdc] Synchronizing SCSI cache
[1305052.940194] sd 3:0:0:1: [sdc]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305052.972161] sd 3:0:1:0: [sdd] Synchronizing SCSI cache
[1305052.972201] sd 3:0:1:0: [sdd]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305053.000471] sd 3:0:1:1: [sde] Synchronizing SCSI cache
[1305053.000517] sd 3:0:1:1: [sde]  Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
[1305075.677296] scsi 3:0:0:0: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305075.678081] scsi 3:0:0:0: rdac: LUN 0 (owned)
[1305075.678302] sd 3:0:0:0: Attached scsi generic sg8 type 0
[1305075.678307] sd 3:0:0:0: Embedded Enclosure Device
[1305075.678603] sd 3:0:0:0: Failed to get diagnostic page 0x8000002
[1305075.678609] sd 3:0:0:0: Failed to bind enclosure -19
[1305075.682708] scsi 3:0:0:1: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305075.683431] scsi 3:0:0:1: rdac: LUN 1 (owned)
[1305075.683598] sd 3:0:0:1: Attached scsi generic sg9 type 0
[1305075.683603] sd 3:0:0:1: Embedded Enclosure Device
[1305075.683894] sd 3:0:0:1: Failed to get diagnostic page 0x8000002
[1305075.683899] sd 3:0:0:1: Failed to bind enclosure -19
[1305075.684399] scsi 3:0:0:31: Direct-Access     IBM      Universal
Xport  0617 PQ: 0 ANSI: 5
[1305075.684541] scsi 3:0:0:31: Attached scsi generic sg10 type 0
[1305075.684547] scsi 3:0:0:31: Embedded Enclosure Device
[1305075.684947] scsi 3:0:0:31: Failed to get diagnostic page 0x8000002
[1305075.684953] scsi 3:0:0:31: Failed to bind enclosure -19
[1305075.687014] scsi 3:0:1:0: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305075.687783] scsi 3:0:1:0: rdac: LUN 0 (unowned)
[1305075.687943] sd 3:0:1:0: Attached scsi generic sg11 type 0
[1305075.687948] sd 3:0:1:0: Embedded Enclosure Device
[1305075.688238] sd 3:0:1:0: Failed to get diagnostic page 0x8000002
[1305075.688244] sd 3:0:1:0: Failed to bind enclosure -19
[1305075.692346] scsi 3:0:1:1: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305075.693079] scsi 3:0:1:1: rdac: LUN 1 (unowned)
[1305075.693246] sd 3:0:1:1: Attached scsi generic sg12 type 0
[1305075.693252] sd 3:0:1:1: Embedded Enclosure Device
[1305075.693539] sd 3:0:1:1: Failed to get diagnostic page 0x8000002
[1305075.693544] sd 3:0:1:1: Failed to bind enclosure -19
[1305075.694050] scsi 3:0:1:31: Direct-Access     IBM      Universal
Xport  0617 PQ: 0 ANSI: 5
[1305075.694189] scsi 3:0:1:31: Attached scsi generic sg13 type 0
[1305075.694194] scsi 3:0:1:31: Embedded Enclosure Device
[1305075.694435] scsi 3:0:1:31: Failed to get diagnostic page 0x8000002
[1305075.694440] scsi 3:0:1:31: Failed to bind enclosure -19
[1305075.959132] scsi 4:0:0:0: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305075.959882] scsi 4:0:0:0: rdac: LUN 0 (unowned)
[1305075.960040] sd 4:0:0:0: Attached scsi generic sg14 type 0
[1305075.960045] sd 4:0:0:0: Embedded Enclosure Device
[1305101.808015] sd 4:0:0:0: [sdm] 419430400 512-byte logical blocks:
(214 GB/200 GiB)
[1305101.872834] sd 3:0:1:0: [sdk] 419430400 512-byte logical blocks:
(214 GB/200 GiB)
[1305101.872877] sd 3:0:1:1: [sdl] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[1305102.271209] sd 4:0:0:0: FIXME driver has no support for
subenclosures (1)
[1305102.271215] sd 4:0:0:0: Failed to bind enclosure -12
[1305102.611904] sd 4:0:0:0: [sdm] Write Protect is off
[1305102.611911] sd 4:0:0:0: [sdm] Mode Sense: 77 00 10 08
[1305102.612703] sd 3:0:1:0: [sdk] Write Protect is off
[1305102.612709] sd 3:0:1:0: [sdk] Mode Sense: 77 00 10 08
[1305102.613301] sd 3:0:1:1: [sdl] Write Protect is off
[1305102.613306] sd 3:0:1:1: [sdl] Mode Sense: 77 00 10 08
[1305102.619332] scsi 4:0:0:1: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305102.630371] sd 4:0:0:0: [sdm] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305102.631386] sd 3:0:1:0: [sdk] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305102.631913] sd 3:0:1:1: [sdl] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305102.640628] scsi 4:0:0:1: rdac: LUN 1 (unowned)
[1305102.640812] sd 4:0:0:1: Attached scsi generic sg15 type 0
[1305102.640818] sd 4:0:0:1: Embedded Enclosure Device
[1305102.641607] sd 4:0:0:1: Failed to get diagnostic page 0x8000002
[1305102.641613] sd 4:0:0:1: Failed to bind enclosure -19
[1305102.645460] sd 4:0:0:1: [sdn] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[1305102.646522] scsi 4:0:0:31: Direct-Access     IBM      Universal
Xport  0617 PQ: 0 ANSI: 5
[1305102.646667] scsi 4:0:0:31: Attached scsi generic sg16 type 0
[1305102.646672] scsi 4:0:0:31: Embedded Enclosure Device
[1305102.646991] scsi 4:0:0:31: Failed to get diagnostic page 0x8000002
[1305102.646996] scsi 4:0:0:31: Failed to bind enclosure -19
[1305102.649006] scsi 4:0:1:0: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305102.649798] scsi 4:0:1:0: rdac: LUN 0 (owned)
[1305102.649955] sd 4:0:1:0: Attached scsi generic sg17 type 0
[1305102.649960] sd 4:0:1:0: Embedded Enclosure Device
[1305102.650256] sd 4:0:1:0: Failed to get diagnostic page 0x8000002
[1305102.650262] sd 4:0:1:0: Failed to bind enclosure -19
[1305102.650911] ldm_validate_partition_table(): Disk read failed.
[1305102.651058]  sdm: unable to read partition table
[1305102.651271] ldm_validate_partition_table(): Disk read failed.
[1305102.651367]  sdk: unable to read partition table
[1305102.652210] ldm_validate_partition_table(): Disk read failed.
[1305102.652396]  sdl: unable to read partition table
[1305102.654198] sd 4:0:0:1: [sdn] Write Protect is off
[1305102.654204] sd 4:0:0:1: [sdn] Mode Sense: 77 00 10 08
[1305102.655670] scsi 4:0:1:1: Direct-Access     IBM      1726-4xx=20
FAStT  0617 PQ: 0 ANSI: 5
[1305102.656607] scsi 4:0:1:1: rdac: LUN 1 (owned)
[1305102.656788] sd 4:0:1:1: Attached scsi generic sg18 type 0
[1305102.656793] sd 4:0:1:1: Embedded Enclosure Device
[1305102.662167] sd 4:0:0:1: [sdn] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305102.671906] sd 4:0:0:0: [sdm] Attached SCSI disk
[1305102.672552] sd 3:0:1:0: [sdk] Attached SCSI disk
[1305102.673432] sd 3:0:1:1: [sdl] Attached SCSI disk
[1305102.678241] ldm_validate_partition_table(): Disk read failed.
[1305102.678400]  sdn: unable to read partition table
[1305102.689860] sd 4:0:0:1: [sdn] Attached SCSI disk
[1305108.125254] sd 3:0:0:0: [sdh] 419430400 512-byte logical blocks:
(214 GB/200 GiB)
[1305108.125705] sd 3:0:0:1: [sdj] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[1305108.266072] sd 4:0:1:0: [sdo] 419430400 512-byte logical blocks:
(214 GB/200 GiB)
[1305108.266480] sd 4:0:1:1: [sdp] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[1305108.731755] sd 4:0:1:1: FIXME driver has no support for
subenclosures (1)
[1305108.731762] sd 4:0:1:1: Failed to bind enclosure -12
[1305108.764199] sd 3:0:0:0: [sdh] Write Protect is off
[1305108.764205] sd 3:0:0:0: [sdh] Mode Sense: 77 00 10 08
[1305108.769141] sd 3:0:0:1: [sdj] Write Protect is off
[1305108.769147] sd 3:0:0:1: [sdj] Mode Sense: 77 00 10 08
[1305108.851705] scsi 4:0:1:31: Direct-Access     IBM      Universal
Xport  0617 PQ: 0 ANSI: 5
[1305108.851883] scsi 4:0:1:31: Attached scsi generic sg19 type 0
[1305108.851888] scsi 4:0:1:31: Embedded Enclosure Device
[1305108.856095] scsi 4:0:1:31: Failed to get diagnostic page 0x8000002
[1305108.856113] scsi 4:0:1:31: Failed to bind enclosure -19
[1305108.876907] sd 4:0:1:0: [sdo] Write Protect is off
[1305108.876914] sd 4:0:1:0: [sdo] Mode Sense: 77 00 10 08
[1305108.881430] sd 4:0:1:1: [sdp] Write Protect is off
[1305108.881436] sd 4:0:1:1: [sdp] Mode Sense: 77 00 10 08
[1305108.888954] sd 3:0:0:0: [sdh] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305108.893101] sd 3:0:0:1: [sdj] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305108.916079] sd 4:0:1:0: [sdo] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305108.916449] sd 4:0:1:1: [sdp] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[1305109.004797]  sdo: sdo1
[1305109.004972]  sdh: sdh1
[1305109.009478]  sdp: sdp1
[1305109.009634]  sdj: sdj1
[1305109.060643] sd 4:0:1:0: [sdo] Attached SCSI disk
[1305109.060751] sd 3:0:0:0: [sdh] Attached SCSI disk
[1305109.069406] sd 4:0:1:1: [sdp] Attached SCSI disk
[1305109.069544] sd 3:0:0:1: [sdj] Attached SCSI disk
[1751443.072336] sd 3:0:0:0: [sdh] Warning! Received an indication that
the operating parameters on this target have changed. The Linux SCSI
layer does not automatically adjust these parameters.
[1751443.074443] sd 3:0:0:1: [sdj] Warning! Received an indication that
the operating parameters on this target have changed. The Linux SCSI
layer does not automatically adjust these parameters.
[1751443.076799] sd 4:0:1:0: [sdo] Warning! Received an indication that
the operating parameters on this target have changed. The Linux SCSI
layer does not automatically adjust these parameters.
[1751443.078805] sd 4:0:1:1: [sdp] Warning! Received an indication that
the operating parameters on this target have changed. The Linux SCSI
layer does not automatically adjust these parameters./


Regards,
Roberto.

=20
On 05/21/2012 04:52 PM, Roberto Giordani wrote:
> Hello,
> if you can update OpenSUSE 12.1 there default package crash if you try
> to start, I'll be very happy. :-)
>
> Is there a multipath-tools version that I can download it with git?
>
> Regards,
> Roberto.
>
> On 05/17/2012 11:56 AM, Roberto Giordani wrote:
>> Hello,
>> I've compiled and installed on January on Opensuse 11.4 x64 from
>> git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-to=
ols.git
>> the multipath-tools but previous 14 of May the module hang as
>> described below.
>> Now I've got
>> git-clone -b sles11-sp2
>> git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-to=
ols.git
>> .
>> and reinstalled, but I'd like to know if this problem was already
>> resolved.
>>
>> Regards,
>> Roberto.
> >Yeah, sorry, I need to update multipath-tools for OpenSUSE 11.4
> >onwards. Working on it.
>
> >Cheers,
>
> >Hannes
> >--
> >Dr. Hannes Reinecke              zSeries & Storage
> >ha...@suse.de                  +49 911 74053 688
> >SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> >GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)


--------------040102030807040401040406
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    Hello,<br>
    I've got the same error re-building the last version of
    multipath-tools from source<br>
    Could someone fix the problem?<br>
    <br>
    <small><i>[1305052.764077]&nbsp; rport-4:0-1: blocked FC remote port time
        out: removing target and saving binding<br>
        [1305052.764136] sd 4:0:1:0: [sdh] Unhandled error code<br>
        [1305052.764140] sd 4:0:1:0: [sdh]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.764145] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 0c 2e
        c1 f0 00 00 08 00<br>
        [1305052.764154] end_request: I/O error, dev sdh, sector
        204390896<br>
        [1305052.764171] sd 4:0:1:0: [sdh] Unhandled error code<br>
        [1305052.764173] sd 4:0:1:0: [sdh]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.764176] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 00 03
        e1 58 00 00 08 00<br>
        [1305052.764184] end_request: I/O error, dev sdh, sector 254296<br>
        [1305052.764190] sd 4:0:1:0: [sdh] Unhandled error code<br>
        [1305052.764192] sd 4:0:1:0: [sdh]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.764196] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 00 03
        e1 68 00 00 08 00<br>
        [1305052.764203] end_request: I/O error, dev sdh, sector 254312<br>
        [1305052.764209] device-mapper: multipath: Failing path 8:112.<br>
        [1305052.764232] sd 4:0:1:0: [sdh] Unhandled error code<br>
        [1305052.764235] sd 4:0:1:0: [sdh]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.764240] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 05 09
        c3 38 00 00 08 00<br>
        [1305052.764249] end_request: I/O error, dev sdh, sector
        84525880<br>
        [1305052.764260] sd 4:0:1:0: [sdh] Unhandled error code<br>
        [1305052.764262] sd 4:0:1:0: [sdh]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.764265] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 06 3d
        da 38 00 00 08 00<br>
        [1305052.764272] end_request: I/O error, dev sdh, sector
        104716856<br>
        [1305052.764277] sd 4:0:1:0: [sdh] Unhandled error code<br>
        [1305052.764279] sd 4:0:1:0: [sdh]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.764282] sd 4:0:1:0: [sdh] CDB: Write(10): 2a 00 06 3d
        da 70 00 00 08 00<br>
        [1305052.764290] end_request: I/O error, dev sdh, sector
        104716912<br>
        [1305052.764349]&nbsp; rport-4:0-0: blocked FC remote port time out:
        removing target and saving binding<br>
        [1305052.792192] sd 4:0:1:0: [sdh] Synchronizing SCSI cache<br>
        [1305052.792269] sd 4:0:1:0: [sdh]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.820160] sd 4:0:1:1: [sdi] Synchronizing SCSI cache<br>
        [1305052.820198] sd 4:0:1:1: [sdi]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.852156] sd 4:0:0:0: [sdf] Synchronizing SCSI cache<br>
        [1305052.852194] sd 4:0:0:0: [sdf]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.884149] sd 4:0:0:1: [sdg] Synchronizing SCSI cache<br>
        [1305052.884185] sd 4:0:0:1: [sdg]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892080]&nbsp; rport-3:0-0: blocked FC remote port time out:
        removing target and saving binding<br>
        [1305052.892120] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892129] sd 3:0:0:0: [sdb]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892135] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 07 22
        27 70 00 00 20 00<br>
        [1305052.892147] end_request: I/O error, dev sdb, sector
        119678832<br>
        [1305052.892164] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892166] sd 3:0:0:0: [sdb]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892169] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 0c 2f
        1b 90 00 00 08 00<br>
        [1305052.892177] end_request: I/O error, dev sdb, sector
        204413840<br>
        [1305052.892186] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892189] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892193] sd 3:0:0:0: [sdb]&nbsp; <br>
        [1305052.892195] sd 3:0:0:0: [sdb]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892199] Result: hostbyte=DID_NO_CONNECT
        driverbyte=DRIVER_OK<br>
        [1305052.892203] sd 3:0:0:0: [sdb] CDB: <br>
        [1305052.892205] sd 3:0:0:0: [sdb] CDB: Write(10)Write(10): 2a:
        00 00 03 2a e1 60 00 00 00 08 00<br>
        [1305052.892226]&nbsp; 05<br>
        [1305052.892228] end_request: I/O error, dev sdb, sector 254304<br>
        [1305052.892231]&nbsp; 09 c3 40 00 00 28 00<br>
        [1305052.892236] end_request: I/O error, dev sdb, sector
        84525888<br>
        [1305052.892239] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892242] sd 3:0:0:0: [sdb]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892246] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 00 03
        e1 68<br>
        [1305052.892253] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892255]&nbsp; 00<br>
        [1305052.892258] sd 3:0:0:0: [sdb]&nbsp;&nbsp; 00 08 00<br>
        [1305052.892262] end_request: I/O error, dev sdb, sector 254312<br>
        [1305052.892266] Result: hostbyte=DID_NO_CONNECT
        driverbyte=DRIVER_OK<br>
        [1305052.892268] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d<br>
        [1305052.892274] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892276]&nbsp; da<br>
        [1305052.892279] sd 3:0:0:0: [sdb]&nbsp;&nbsp; 48 00 00Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892286]&nbsp; 08<br>
        [1305052.892288] sd 3:0:0:0: [sdb] CDB:&nbsp; 00<br>
        [1305052.892293] end_request: I/O error, dev sdb, sector
        104716872<br>
        [1305052.892295] Write(10): 2a 00 00 03 e1 58 00 00<br>
        [1305052.892302] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892304]&nbsp; 08<br>
        [1305052.892308] sd 3:0:0:0: [sdb]&nbsp;&nbsp; 00<br>
        [1305052.892311] end_request: I/O error, dev sdb, sector 254296<br>
        [1305052.892314] Result: hostbyte=DID_NO_CONNECT
        driverbyte=DRIVER_OK<br>
        [1305052.892317] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d<br>
        [1305052.892322] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892324]&nbsp; da<br>
        [1305052.892326] sd 3:0:0:0: [sdb]&nbsp;&nbsp; 78Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892333]&nbsp; 00<br>
        [1305052.892335] sd 3:0:0:0: [sdb] CDB:&nbsp; 00Write(10): 2a 08 00
        0c 2e c1 00 f0 00 00<br>
        [1305052.892349]&nbsp; 08<br>
        [1305052.892353] end_request: I/O error, dev sdb, sector
        104716920<br>
        [1305052.892354]&nbsp; 00<br>
        [1305052.892358] end_request: I/O error, dev sdb, sector
        204390896<br>
        [1305052.892364] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892366] sd 3:0:0:0: [sdb]&nbsp; <br>
        [1305052.892367] device-mapper: multipath: Failing path 8:16.<br>
        [1305052.892371] Result: hostbyte=DID_NO_CONNECT
        driverbyte=DRIVER_OK<br>
        [1305052.892373] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d
        da 70 00 00 08 00<br>
        [1305052.892381] end_request: I/O error, dev sdb, sector
        104716912<br>
        [1305052.892388] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892390]&nbsp; rport-3:0-1: blocked FC remote port time out:
        removing target and saving binding<br>
        [1305052.892394] sd 3:0:0:0: [sdb]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892398] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 06 3d
        da 38 00 00 08 00<br>
        [1305052.892405] end_request: I/O error, dev sdb, sector
        104716856<br>
        [1305052.892415] sd 3:0:0:0: [sdb] Unhandled error code<br>
        [1305052.892417] sd 3:0:0:0: [sdb]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.892420] sd 3:0:0:0: [sdb] CDB: Write(10): 2a 00 05 09
        c3 38 00 00 08 00<br>
        [1305052.892427] end_request: I/O error, dev sdb, sector
        84525880<br>
        [1305052.892732] device-mapper: multipath: Failing path 8:16.<br>
        [1305052.892796] device-mapper: multipath: Failing path 8:48.<br>
        [1305052.892813] scsi 4:0:0:0: rejecting I/O to dead device<br>
        [1305052.892818] device-mapper: multipath: Failing path 8:80.<br>
        [1305052.894120] device-mapper: multipath: Failing path 8:16.<br>
        [1305052.894165] device-mapper: multipath: Failing path 8:48.<br>
        [1305052.894178] scsi 4:0:0:0: rejecting I/O to dead device<br>
        [1305052.894182] device-mapper: multipath: Failing path 8:80.<br>
        [1305052.900596] device-mapper: multipath: adding disabled
        device 8:96<br>
        [1305052.900940] BUG: unable to handle kernel NULL pointer
        dereference at&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (null)<br>
        [1305052.900958] IP: [&lt;ffffffffa08dfa63&gt;]
        dm_set_device_limits+0x23/0x140 [dm_mod]<br>
        [1305052.900977] PGD 34ff23067 PUD 350859067 PMD 0 <br>
        [1305052.900984] Oops: 0000 [#1] SMP <br>
        [1305052.900989] last sysfs file:
        /sys/module/scsi_dh_rdac/initstate<br>
        [1305052.900994] CPU 3 <br>
        [1305052.900996] Modules linked in: loop ocfs2 ocfs2_nodemanager
        quota_tree ocfs2_stack_user ocfs2_stackglue dlm configfs nbd
        usbbk netbk blkbk blkback_pagemap blktap domctl xenbus_be gntdev
        evtchn bridge stp llc bonding edd ext4 jbd2 crc16 scsi_dh_rdac
        dm_round_robin dm_multipath scsi_dh dm_mod ibmpex ibmaem i5k_amb
        iTCO_wdt ses iTCO_vendor_support enclosure e1000e sg
        ipmi_msghandler bnx2 sr_mod i2c_i801 pcspkr ics932s401 joydev
        serio_raw ioatdma i5000_edac 8250_pnp edac_core 8250 serial_core
        button shpchp pci_hotplug reiserfs usbhid hid uhci_hcd radeon
        ttm drm_kms_helper drm i2c_algo_bit ehci_hcd usbcore i2c_core
        qla2xxx xenblk cdrom xennet fan processor ata_generic thermal
        thermal_sys hwmon aacraid<br>
        [1305052.901095] <br>
        [1305052.901099] Pid: 2952, comm: multipathd Not tainted
        2.6.37.6-0.9-xen #1 IBM IBM System x3650 -[7979AC1]-/System
        Planar<br>
        [1305052.901109] RIP: e030:[&lt;ffffffffa08dfa63&gt;]&nbsp;
        [&lt;ffffffffa08dfa63&gt;] dm_set_device_limits+0x23/0x140
        [dm_mod]<br>
        [1305052.901119] RSP: e02b:ffff88034b8a1c78&nbsp; EFLAGS: 00010296<br>
        [1305052.901124] RAX: ffff8802dff306f8 RBX: ffff8802a6504940
        RCX: 0000000000200000<br>
        [1305052.901128] RDX: 0000000000000000 RSI: 0000000000000000
        RDI: ffffc9000003e040<br>
        [1305052.901133] RBP: ffffc9000003e040 R08: ffff88034b8a1d58
        R09: 0000000000000200<br>
        [1305052.901138] R10: 0000000000000008 R11: 00003ffffffff000
        R12: ffff8802dff306f8<br>
        [1305052.901143] R13: 0000000000000000 R14: ffff88034b8a1d58
        R15: ffff8802dff306c0<br>
        [1305052.901152] FS:&nbsp; 00007f4856b6b700(0000)
        GS:ffff8803602f5000(0000) knlGS:0000000000000000<br>
        [1305052.901157] CS:&nbsp; e033 DS: 0000 ES: 0000 CR0:
        0000000080050033<br>
        [1305052.901161] CR2: 0000000000000000 CR3: 000000034da6f000
        CR4: 0000000000042660<br>
        [1305052.901166] DR0: 0000000000000000 DR1: 0000000000000000
        DR2: 0000000000000000<br>
        [1305052.901171] DR3: 0000000000000000 DR6: 00000000ffff0ff0
        DR7: 0000000000000400<br>
        [1305052.901176] Process multipathd (pid: 2952, threadinfo
        ffff88034b8a0000, task ffff8803508b84c0)<br>
        [1305052.901181] Stack:<br>
        [1305052.901183]&nbsp; 00000000000000d2 ffff880351c50b80
        ffff88034b8a1cc8 0000000000000003<br>
        [1305052.901191]&nbsp; ffff880351c50bf0 0000000000000001
        ffff880351c50ba0 ffffffff8005e61f<br>
        [1305052.901199]&nbsp; ffff88034b8a1ce8 ffffffff8002e082
        ffff8802a6504940 ffffc9000003e040<br>
        [1305052.901206] Call Trace:<br>
        [1305052.901236]&nbsp; [&lt;ffffffffa0903425&gt;]
        multipath_iterate_devices+0x55/0x80 [dm_multipath]<br>
        [1305052.901248]&nbsp; [&lt;ffffffffa08e082c&gt;]
        dm_calculate_queue_limits+0x8c/0x130 [dm_mod]<br>
        [1305052.901268]&nbsp; [&lt;ffffffffa08de73b&gt;]
        dm_swap_table+0x6b/0x90 [dm_mod]<br>
        [1305052.901285]&nbsp; [&lt;ffffffffa08e3048&gt;]
        do_resume+0x88/0x1b0 [dm_mod]<br>
        [1305052.901309]&nbsp; [&lt;ffffffffa08e3e6c&gt;]
        ctl_ioctl+0x1ac/0x250 [dm_mod]<br>
        [1305052.901335]&nbsp; [&lt;ffffffffa08e3f1e&gt;]
        dm_ctl_ioctl+0xe/0x20 [dm_mod]<br>
        [1305052.901360]&nbsp; [&lt;ffffffff8012da89&gt;]
        do_vfs_ioctl+0x89/0x340<br>
        [1305052.901369]&nbsp; [&lt;ffffffff8012ddc0&gt;] sys_ioctl+0x80/0xa0<br>
        [1305052.901378]&nbsp; [&lt;ffffffff80007448&gt;]
        system_call_fastpath+0x16/0x1b<br>
        [1305052.901386]&nbsp; [&lt;00007f48559d7d87&gt;] 0x7f48559d7d87<br>
        [1305052.901390] Code: fd ff ff 0f 1f 44 00 00 48 83 ec 78 48 89
        6c 24 58 4c 89 64 24 60 48 89 fd 4c 89 6c 24 68 48 89 5c 24 50
        49 89 d5 4c 89 74 24 70 &lt;4c&gt; 8b 36 4d 89 c4 49 8b 86 a0 00
        00 00 48 8b 98 10 03 00 00 48 <br>
        [1305052.901441] RIP&nbsp; [&lt;ffffffffa08dfa63&gt;]
        dm_set_device_limits+0x23/0x140 [dm_mod]<br>
        [1305052.901451]&nbsp; RSP &lt;ffff88034b8a1c78&gt;<br>
        [1305052.901453] CR2: 0000000000000000<br>
        [1305052.902033] ---[ end trace 876924144444c2e5 ]---<br>
        [1305052.912171] sd 3:0:0:0: [sdb] Synchronizing SCSI cache<br>
        [1305052.912223] sd 3:0:0:0: [sdb]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.940154] sd 3:0:0:1: [sdc] Synchronizing SCSI cache<br>
        [1305052.940194] sd 3:0:0:1: [sdc]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305052.972161] sd 3:0:1:0: [sdd] Synchronizing SCSI cache<br>
        [1305052.972201] sd 3:0:1:0: [sdd]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305053.000471] sd 3:0:1:1: [sde] Synchronizing SCSI cache<br>
        [1305053.000517] sd 3:0:1:1: [sde]&nbsp; Result:
        hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        [1305075.677296] scsi 3:0:0:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305075.678081] scsi 3:0:0:0: rdac: LUN 0 (owned)<br>
        [1305075.678302] sd 3:0:0:0: Attached scsi generic sg8 type 0<br>
        [1305075.678307] sd 3:0:0:0: Embedded Enclosure Device<br>
        [1305075.678603] sd 3:0:0:0: Failed to get diagnostic page
        0x8000002<br>
        [1305075.678609] sd 3:0:0:0: Failed to bind enclosure -19<br>
        [1305075.682708] scsi 3:0:0:1: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305075.683431] scsi 3:0:0:1: rdac: LUN 1 (owned)<br>
        [1305075.683598] sd 3:0:0:1: Attached scsi generic sg9 type 0<br>
        [1305075.683603] sd 3:0:0:1: Embedded Enclosure Device<br>
        [1305075.683894] sd 3:0:0:1: Failed to get diagnostic page
        0x8000002<br>
        [1305075.683899] sd 3:0:0:1: Failed to bind enclosure -19<br>
        [1305075.684399] scsi 3:0:0:31: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305075.684541] scsi 3:0:0:31: Attached scsi generic sg10 type
        0<br>
        [1305075.684547] scsi 3:0:0:31: Embedded Enclosure Device<br>
        [1305075.684947] scsi 3:0:0:31: Failed to get diagnostic page
        0x8000002<br>
        [1305075.684953] scsi 3:0:0:31: Failed to bind enclosure -19<br>
        [1305075.687014] scsi 3:0:1:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305075.687783] scsi 3:0:1:0: rdac: LUN 0 (unowned)<br>
        [1305075.687943] sd 3:0:1:0: Attached scsi generic sg11 type 0<br>
        [1305075.687948] sd 3:0:1:0: Embedded Enclosure Device<br>
        [1305075.688238] sd 3:0:1:0: Failed to get diagnostic page
        0x8000002<br>
        [1305075.688244] sd 3:0:1:0: Failed to bind enclosure -19<br>
        [1305075.692346] scsi 3:0:1:1: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305075.693079] scsi 3:0:1:1: rdac: LUN 1 (unowned)<br>
        [1305075.693246] sd 3:0:1:1: Attached scsi generic sg12 type 0<br>
        [1305075.693252] sd 3:0:1:1: Embedded Enclosure Device<br>
        [1305075.693539] sd 3:0:1:1: Failed to get diagnostic page
        0x8000002<br>
        [1305075.693544] sd 3:0:1:1: Failed to bind enclosure -19<br>
        [1305075.694050] scsi 3:0:1:31: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305075.694189] scsi 3:0:1:31: Attached scsi generic sg13 type
        0<br>
        [1305075.694194] scsi 3:0:1:31: Embedded Enclosure Device<br>
        [1305075.694435] scsi 3:0:1:31: Failed to get diagnostic page
        0x8000002<br>
        [1305075.694440] scsi 3:0:1:31: Failed to bind enclosure -19<br>
        [1305075.959132] scsi 4:0:0:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305075.959882] scsi 4:0:0:0: rdac: LUN 0 (unowned)<br>
        [1305075.960040] sd 4:0:0:0: Attached scsi generic sg14 type 0<br>
        [1305075.960045] sd 4:0:0:0: Embedded Enclosure Device<br>
        [1305101.808015] sd 4:0:0:0: [sdm] 419430400 512-byte logical
        blocks: (214 GB/200 GiB)<br>
        [1305101.872834] sd 3:0:1:0: [sdk] 419430400 512-byte logical
        blocks: (214 GB/200 GiB)<br>
        [1305101.872877] sd 3:0:1:1: [sdl] 2097152 512-byte logical
        blocks: (1.07 GB/1.00 GiB)<br>
        [1305102.271209] sd 4:0:0:0: FIXME driver has no support for
        subenclosures (1)<br>
        [1305102.271215] sd 4:0:0:0: Failed to bind enclosure -12<br>
        [1305102.611904] sd 4:0:0:0: [sdm] Write Protect is off<br>
        [1305102.611911] sd 4:0:0:0: [sdm] Mode Sense: 77 00 10 08<br>
        [1305102.612703] sd 3:0:1:0: [sdk] Write Protect is off<br>
        [1305102.612709] sd 3:0:1:0: [sdk] Mode Sense: 77 00 10 08<br>
        [1305102.613301] sd 3:0:1:1: [sdl] Write Protect is off<br>
        [1305102.613306] sd 3:0:1:1: [sdl] Mode Sense: 77 00 10 08<br>
        [1305102.619332] scsi 4:0:0:1: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305102.630371] sd 4:0:0:0: [sdm] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305102.631386] sd 3:0:1:0: [sdk] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305102.631913] sd 3:0:1:1: [sdl] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305102.640628] scsi 4:0:0:1: rdac: LUN 1 (unowned)<br>
        [1305102.640812] sd 4:0:0:1: Attached scsi generic sg15 type 0<br>
        [1305102.640818] sd 4:0:0:1: Embedded Enclosure Device<br>
        [1305102.641607] sd 4:0:0:1: Failed to get diagnostic page
        0x8000002<br>
        [1305102.641613] sd 4:0:0:1: Failed to bind enclosure -19<br>
        [1305102.645460] sd 4:0:0:1: [sdn] 2097152 512-byte logical
        blocks: (1.07 GB/1.00 GiB)<br>
        [1305102.646522] scsi 4:0:0:31: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305102.646667] scsi 4:0:0:31: Attached scsi generic sg16 type
        0<br>
        [1305102.646672] scsi 4:0:0:31: Embedded Enclosure Device<br>
        [1305102.646991] scsi 4:0:0:31: Failed to get diagnostic page
        0x8000002<br>
        [1305102.646996] scsi 4:0:0:31: Failed to bind enclosure -19<br>
        [1305102.649006] scsi 4:0:1:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305102.649798] scsi 4:0:1:0: rdac: LUN 0 (owned)<br>
        [1305102.649955] sd 4:0:1:0: Attached scsi generic sg17 type 0<br>
        [1305102.649960] sd 4:0:1:0: Embedded Enclosure Device<br>
        [1305102.650256] sd 4:0:1:0: Failed to get diagnostic page
        0x8000002<br>
        [1305102.650262] sd 4:0:1:0: Failed to bind enclosure -19<br>
        [1305102.650911] ldm_validate_partition_table(): Disk read
        failed.<br>
        [1305102.651058]&nbsp; sdm: unable to read partition table<br>
        [1305102.651271] ldm_validate_partition_table(): Disk read
        failed.<br>
        [1305102.651367]&nbsp; sdk: unable to read partition table<br>
        [1305102.652210] ldm_validate_partition_table(): Disk read
        failed.<br>
        [1305102.652396]&nbsp; sdl: unable to read partition table<br>
        [1305102.654198] sd 4:0:0:1: [sdn] Write Protect is off<br>
        [1305102.654204] sd 4:0:0:1: [sdn] Mode Sense: 77 00 10 08<br>
        [1305102.655670] scsi 4:0:1:1: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305102.656607] scsi 4:0:1:1: rdac: LUN 1 (owned)<br>
        [1305102.656788] sd 4:0:1:1: Attached scsi generic sg18 type 0<br>
        [1305102.656793] sd 4:0:1:1: Embedded Enclosure Device<br>
        [1305102.662167] sd 4:0:0:1: [sdn] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305102.671906] sd 4:0:0:0: [sdm] Attached SCSI disk<br>
        [1305102.672552] sd 3:0:1:0: [sdk] Attached SCSI disk<br>
        [1305102.673432] sd 3:0:1:1: [sdl] Attached SCSI disk<br>
        [1305102.678241] ldm_validate_partition_table(): Disk read
        failed.<br>
        [1305102.678400]&nbsp; sdn: unable to read partition table<br>
        [1305102.689860] sd 4:0:0:1: [sdn] Attached SCSI disk<br>
        [1305108.125254] sd 3:0:0:0: [sdh] 419430400 512-byte logical
        blocks: (214 GB/200 GiB)<br>
        [1305108.125705] sd 3:0:0:1: [sdj] 2097152 512-byte logical
        blocks: (1.07 GB/1.00 GiB)<br>
        [1305108.266072] sd 4:0:1:0: [sdo] 419430400 512-byte logical
        blocks: (214 GB/200 GiB)<br>
        [1305108.266480] sd 4:0:1:1: [sdp] 2097152 512-byte logical
        blocks: (1.07 GB/1.00 GiB)<br>
        [1305108.731755] sd 4:0:1:1: FIXME driver has no support for
        subenclosures (1)<br>
        [1305108.731762] sd 4:0:1:1: Failed to bind enclosure -12<br>
        [1305108.764199] sd 3:0:0:0: [sdh] Write Protect is off<br>
        [1305108.764205] sd 3:0:0:0: [sdh] Mode Sense: 77 00 10 08<br>
        [1305108.769141] sd 3:0:0:1: [sdj] Write Protect is off<br>
        [1305108.769147] sd 3:0:0:1: [sdj] Mode Sense: 77 00 10 08<br>
        [1305108.851705] scsi 4:0:1:31: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        [1305108.851883] scsi 4:0:1:31: Attached scsi generic sg19 type
        0<br>
        [1305108.851888] scsi 4:0:1:31: Embedded Enclosure Device<br>
        [1305108.856095] scsi 4:0:1:31: Failed to get diagnostic page
        0x8000002<br>
        [1305108.856113] scsi 4:0:1:31: Failed to bind enclosure -19<br>
        [1305108.876907] sd 4:0:1:0: [sdo] Write Protect is off<br>
        [1305108.876914] sd 4:0:1:0: [sdo] Mode Sense: 77 00 10 08<br>
        [1305108.881430] sd 4:0:1:1: [sdp] Write Protect is off<br>
        [1305108.881436] sd 4:0:1:1: [sdp] Mode Sense: 77 00 10 08<br>
        [1305108.888954] sd 3:0:0:0: [sdh] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305108.893101] sd 3:0:0:1: [sdj] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305108.916079] sd 4:0:1:0: [sdo] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305108.916449] sd 4:0:1:1: [sdp] Write cache: enabled, read
        cache: enabled, supports DPO and FUA<br>
        [1305109.004797]&nbsp; sdo: sdo1<br>
        [1305109.004972]&nbsp; sdh: sdh1<br>
        [1305109.009478]&nbsp; sdp: sdp1<br>
        [1305109.009634]&nbsp; sdj: sdj1<br>
        [1305109.060643] sd 4:0:1:0: [sdo] Attached SCSI disk<br>
        [1305109.060751] sd 3:0:0:0: [sdh] Attached SCSI disk<br>
        [1305109.069406] sd 4:0:1:1: [sdp] Attached SCSI disk<br>
        [1305109.069544] sd 3:0:0:1: [sdj] Attached SCSI disk<br>
        [1751443.072336] sd 3:0:0:0: [sdh] Warning! Received an
        indication that the operating parameters on this target have
        changed. The Linux SCSI layer does not automatically adjust
        these parameters.<br>
        [1751443.074443] sd 3:0:0:1: [sdj] Warning! Received an
        indication that the operating parameters on this target have
        changed. The Linux SCSI layer does not automatically adjust
        these parameters.<br>
        [1751443.076799] sd 4:0:1:0: [sdo] Warning! Received an
        indication that the operating parameters on this target have
        changed. The Linux SCSI layer does not automatically adjust
        these parameters.<br>
        [1751443.078805] sd 4:0:1:1: [sdp] Warning! Received an
        indication that the operating parameters on this target have
        changed. The Linux SCSI layer does not automatically adjust
        these parameters.</i></small><br>
    <br>
    <br>
    Regards,<br>
    Roberto.<br>
    <br>
    &nbsp;<br>
    On 05/21/2012 04:52 PM, Roberto Giordani wrote:
    <blockquote cite="mid:4FBA569C.4080408@libero.it" type="cite">
      <meta content="text/html; charset=ISO-8859-1"
        http-equiv="Content-Type">
      Hello,<br>
      if you can update OpenSUSE 12.1 there default package crash if you
      try to start, I'll be very happy. :-)<br>
      <br>
      Is there a multipath-tools version that I can download it with
      git?<br>
      <br>
      Regards,<br>
      Roberto.<br>
      <br>
      On 05/17/2012 11:56 AM, Roberto Giordani wrote:
      <blockquote cite="mid:4FB4CB5E.9040600@libero.it" type="cite">
        <meta http-equiv="content-type" content="text/html;
          charset=ISO-8859-1">
        Hello,<br>
        I've compiled and installed on January on Opensuse 11.4 x64 from
        git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git


        the multipath-tools but previous 14 of May the module hang as
        described below.<br>
        Now I've got <br>
        git-clone -b sles11-sp2
        git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git


        .<br>
        and reinstalled, but I'd like to know if this problem was
        already resolved.<br>
        <br>
        Regards,<br>
        Roberto.<br>
      </blockquote>
      &gt;Yeah, sorry, I need to update multipath-tools for OpenSUSE
      11.4<br>
      &gt;onwards. Working on it.<br>
      <br>
      &gt;Cheers,<br>
      <br>
      &gt;Hannes<br>
      &gt;-- <br>
      &gt;Dr. Hannes Reinecke&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; zSeries &amp; Storage<br>
      &gt;<a moz-do-not-send="true" class="moz-txt-link-abbreviated"
        href="mailto:ha...@suse.de">ha...@suse.de</a>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      +49 911 74053 688<br>
      &gt;SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N&uuml;rnberg<br>
      &gt;GF: J. Hawn, J. Guild, F. Imend&ouml;rffer, HRB 16746 (AG N&uuml;rnberg)<br>
    </blockquote>
    <br>
  </body>
</html>

--------------040102030807040401040406--


--===============3805478878598775619==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============3805478878598775619==--
