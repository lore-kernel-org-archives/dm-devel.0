From: Igor Druzhinin <igor.druzhinin@citrix.com>
Subject: BUG: unable to handle kernel paging request
Date: Tue, 10 Jan 2017 19:54:37 +0000
Message-ID: <1527924d-fa13-bb09-961e-e6ce68a122bc@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hi,

During a multipath failover we are getting a crash like this below. The
host is booting from an FCoE device so as the root disk is a remote LUN
somewhere in the network. The failing over is intended behavior - we
disconnect all the network links for a short period of time while still
queuing all the outstanding requests during the outage. In most cases,
we only receive one or two messages like this one:

[  100.888455] blk_update_request: I/O error, dev dm-0, sector 55432

which is normal. But sometimes (which is quite rare) we may also get the
following output:

[  100.888479] Buffer I/O error on device dm-4, logical block 6673

that usually precedes the crash. (dm-0 is the root multipath device,
while dm-4 is an LVM device on top of that). We use 4.4 kernel now.

I'm looking for some clues to understand what is actually happening
there and would appreciate any advice. I can also provide any additional
information if it helps.

Apologies, if it has been fixed before but I couldn't find any related
issue.

Thanks,
Igor

[  100.888401] Buffer I/O error on device dm-4, logical block 26030
[  100.888429] Buffer I/O error on device dm-4, logical block 26031
[  100.888455] blk_update_request: I/O error, dev dm-0, sector 55432
[  100.888479] Buffer I/O error on device dm-4, logical block 6673
[  100.888535] blk_update_request: I/O error, dev dm-0, sector 32648
[  100.888556] Buffer I/O error on device dm-4, logical block 3825
[  100.888583] Buffer I/O error on device dm-4, logical block 3826
[  100.888712] BUG: unable to handle kernel paging request at
ffffc900400b3048
[  100.888737] IP: [<ffffffffa00680e4>] map_request+0x34/0x230 [dm_mod]
[  100.888815] PGD 788c0067
[  100.888815] device-mapper: multipath: Failing path 8:192.
[  100.888861] PUD 18f09b067 PMD 18f09c067 PTE 0
[  100.888875] Oops: 0000 [#1] [  100.888914] device-mapper: multipath:
Failing path 8:16.

[  100.888938] SMP
[  100.888955] Modules linked in: openvswitch nf_defrag_ipv6 ipt_REJECT
nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_tcpudp xt_multiport
xt_conntrack nf_conntrack iptable_filter ipmi_devintf
x86_pkg_temp_thermal coretemp crc32_pclmul aesni_intel aes_x86_64
ablk_helper cryptd ipmi_si sg psmouse lrw hpilo ipmi_msghandler gf128mul
tpm_tis glue_helper sb_edac edac_core tpm wmi hed lpc_ich shpchp
i2c_i801 mfd_core nls_utf8 isofs nfsd auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc ip_tables x_tables dm_service_time 8021q garp stp llc
mrp sd_mod uhci_hcd serio_raw bnx2x(O) xhci_pci ehci_pci mdio xhci_hcd
ehci_hcd vxlan ip6_udp_tunnel udp_tunnel hpsa(O) ptp scsi_transport_sas
pps_core libcrc32c dm_mirror dm_region_hash dm_log bnx2fc(O) cnic(O) uio
fcoe libfcoe libfc scsi_transport_fc scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua dm_multipath scsi_mod dm_mod ipv6 autofs4
[  100.889542] CPU: 2 PID: 701 Comm: kdmwork-253:0 Tainted: G
O    4.4.0+2 #1
[  100.889556] Hardware name: HP ProLiant BL460c Gen9, BIOS I36 09/12/2016
[  100.889573] task: ffff88018b009c00 ti: ffff880183080000 task.ti:
ffff880183080000
[  100.889622] RIP: e030:[<ffffffffa00680e4>]  [<ffffffffa00680e4>]
map_request+0x34/0x230 [dm_mod]
[  100.889645] RSP: e02b:ffff880183083e30  EFLAGS: 00010286
[  100.889691] RAX: 0000000000000001 RBX: ffff880183136df0 RCX:
ffff880183137190
[  100.889702] RDX: ffff88018baa8000 RSI: ffff880183136e60 RDI:
ffff880183136df0
[  100.889713] RBP: ffff880183083e68 R08: ffff88018acf7800 R09:
000000018020000e
[  100.889764] R10: 000000008b914201 R11: ffffea00062e4500 R12:
ffff880183136c80
[  100.889774] R13: ffff88018baa8000 R14: ffffc900400b3040 R15:
ffff88018b009c00
[  100.889798] FS:  0000000000000000(0000) GS:ffff88018f840000(0000)
knlGS:ffff88018f840000
[  100.889842] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.889851] CR2: ffffc900400b3048 CR3: 0000000181d2b000 CR4:
0000000000042660
[  100.889867] Stack:
[  100.889904]  ffff8801fffffffb 0000000000000000 ffff88018baa8000
ffff880183136c80
[  100.889921]  ffff88018b009c00 ffff88018b009c00 ffff88018b009c00
ffff880183083e88
[  100.889937]  ffffffffa0068302 ffff88018baa83c8 ffff88018b009c00
ffff880183083ec8
[  100.889989] Call Trace:
[  100.890014]  [<ffffffffa0068302>] map_tio_request+0x22/0x40 [dm_mod]
[  100.890065]  [<ffffffff8108e0ef>] kthread_worker_fn+0xcf/0x160
[  100.890076]  [<ffffffff8108e020>] ? kthread_create_on_node+0x180/0x180
[  100.890089]  [<ffffffff8108ddf5>] kthread+0xd5/0xe0
[  100.890132]  [<ffffffff8108dd20>] ? kthread_stop+0x110/0x110
[  100.890152]  [<ffffffff815a0a4f>] ret_from_fork+0x3f/0x70
[  100.890167]  [<ffffffff8108dd20>] ? kthread_stop+0x110/0x110
[  100.890207] Code: 41 57 41 56 41 55 49 89 d5 41 54 49 89 f4 53 48 89
fb 48 83 ec 10 48 8b 77 18 4c 8b 77 08 48 c7 45 d0 00 00 00 00 48 85 f6
74 32 <49> 8b 4e 08 48 8d 57 48 48 89 75 d0 4c 89 f7 ff 51 40 83 f8 01
[  100.890436] RIP  [<ffffffffa00680e4>] map_request+0x34/0x230 [dm_mod]
[  100.890492]  RSP <ffff880183083e30>
[  100.890500] CR2: ffffc900400b3048
[  100.890519] ---[ end trace 92251d486ed850c9 ]---
[  100.898324] ERST: [Firmware Warn]: Firmware does not respond in time.
[  100.898614] sd 2:0:0:0: alua: port group 3e8 state A non-preferred
supports TolUsNA
[  102.281054] libfcoe: host1: FIP Fibre-Channel Forwarder MAC
0e:fc:00:00:00:00 deselected
[  102.281090] libfcoe: host1: FIP selected Fibre-Channel Forwarder MAC
00:2a:6a:46:69:aa
[  102.281112] host1: Assigned Port ID d10204
[  104.587926] sd 1:0:1:0: alua: port group 3e8 state A non-preferred
supports TolUsNA
[  104.589831] sd 1:0:0:0: alua: port group 3e8 state A non-preferred
supports TolUsNA
