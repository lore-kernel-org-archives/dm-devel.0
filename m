From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [for-4.16 PATCH v6 0/3] blk-mq: improve DM's blk-mq
 IO merging via blk_insert_cloned_request feedback
Date: Wed, 17 Jan 2018 20:17:22 -0500
Message-ID: <CAFfF4qtE5iCanO=LYy_7rQ+NuJLPMdRO4VUQihLJ1WwT1ypQig@mail.gmail.com>
References: <20180117162558.28553-1-snitzer@redhat.com>
	<45f70a28-aeea-8278-0b8e-9601ea043595@kernel.dk>
	<20180117165832.GA5573@redhat.com> <1516231868.2820.84.camel@wdc.com>
	<1516232589.3805.2.camel@redhat.com>
	<1516233206.2820.103.camel@wdc.com>
	<20180118005452.GB7649@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0184276390856737217=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180118005452.GB7649@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>
List-Id: dm-devel.ids

--===============0184276390856737217==
Content-Type: multipart/alternative; boundary="94eb2c058080d79aed056302b92d"

--94eb2c058080d79aed056302b92d
Content-Type: text/plain; charset="UTF-8"

MIke and Bart

Replying via Browser because Evolution is having issues so cannot copy the
block list.
The gmail browser wont do clean text, only evolution for me.

Server is running 4.13-rc1 for the RPT so stayed up, Client see sthe list
corruption like I saw on Barts tree.
Someone will have to copy the block list if needed until I get evolution
back

[  370.765953] list_add corruption. prev->next should be next
(0000000062acf0b0), but was 000000007a44ce4f. (prev=000000007a44ce4f).
[  370.831948] WARNING: CPU: 15 PID: 13175 at lib/list_debug.c:28
__list_add_valid+0x6a/0x70
[  370.877893] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun
bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter rpcrdma ib_isert iscsi_target_mod target_core_mod ib_iser
libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc aesni_intel crypto_simd
ipmi_si glue_helper cryptd joydev ipmi_devintf ipmi_msghandler iTCO_wdt
iTCO_vendor_support dm_service_time pcspkr acpi_power_meter gpio_ich hpilo
hpwdt sg pcc_cpufreq i7core_edac
[  371.273754]  shpchp lpc_ich nfsd auth_rpcgss nfs_acl lockd grace
dm_multipath sunrpc ip_tables xfs libcrc32c sd_mod radeon mlx5_core
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
ttm mlxfw drm ptp i2c_core crc32c_intel hpsa pps_core serio_raw bnx2
devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  371.444895] CPU: 15 PID: 13175 Comm: kworker/u66:14 Tainted: G
I      4.15.0-rc4.dm_and_block+ #1
[  371.499292] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  371.535070] Workqueue: writeback wb_workfn (flush-253:13)
[  371.565729] RIP: 0010:__list_add_valid+0x6a/0x70
[  371.592197] RSP: 0018:ffffae5b8c293690 EFLAGS: 00010286
[  371.621114] RAX: 0000000000000000 RBX: ffff929ba920b800 RCX:
0000000000000000
[  371.661131] RDX: 0000000000000001 RSI: ffff929c333cdf78 RDI:
ffff929c333cdf78
[  371.702111] RBP: ffff929ba8b34c00 R08: 0000000000000000 R09:
00000000000006d7
[  371.743248] R10: 0000000000000000 R11: ffffae5b8c2933f8 R12:
ffff929ba8b34c40
[  371.783772] R13: ffff929ba8b34c40 R14: ffff929ba920b808 R15:
0000000000000001
[  371.824291] FS:  0000000000000000(0000) GS:ffff929c333c0000(0000)
knlGS:0000000000000000
[  371.870706] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  371.903803] CR2: 00007fb07e09b000 CR3: 0000000f56609006 CR4:
00000000000206e0
[  371.943875] Call Trace:
[  371.957310]  blk_mq_request_bypass_insert+0x57/0xa0
[  371.984333]  __blk_mq_try_issue_directly+0x56/0x1e0
[  372.011390]  blk_mq_request_direct_issue+0x5d/0xc0
[  372.038404]  ? blk_insert_cloned_request+0x96/0x1c0
[  372.065923]  map_request+0x142/0x260 [dm_mod]
[  372.090043]  dm_mq_queue_rq+0xa4/0x120 [dm_mod]
[  372.115507]  blk_mq_dispatch_rq_list+0x8e/0x530
[  372.141076]  ? deadline_remove_request+0x79/0xc0
[  372.167035]  blk_mq_do_dispatch_sched+0x8b/0x110
[  372.192938]  blk_mq_sched_dispatch_requests+0x118/0x1a0
[  372.222326]  __blk_mq_run_hw_queue+0x5f/0xf0
[  372.246083]  __blk_mq_delay_run_hw_queue+0x9c/0xa0
[  372.272943]  blk_mq_run_hw_queue+0x54/0xf0
[  372.296181]  blk_mq_flush_plug_list+0x17f/0x260
[  372.322152]  blk_flush_plug_list+0xe4/0x260
[  372.345712]  blk_mq_make_request+0x483/0x560
[  372.370156]  generic_make_request+0x110/0x2e0
[  372.394759]  submit_bio+0x6e/0x140
[  372.414258]  xfs_submit_ioend+0x9c/0x110 [xfs]
[  372.439759]  xfs_vm_writepages+0xc6/0xd0 [xfs]
[  372.464677]  do_writepages+0x17/0x70
[  372.484686]  __writeback_single_inode+0x3d/0x330
[  372.510219]  writeback_sb_inodes+0x24f/0x4b0
[  372.534789]  __writeback_inodes_wb+0x87/0xb0
[  372.558826]  wb_writeback+0x276/0x310
[  372.579434]  wb_workfn+0x1b0/0x460
[  372.598886]  process_one_work+0x141/0x340
[  372.621522]  worker_thread+0x47/0x3e0
[  372.641939]  kthread+0xf5/0x130
[  372.659890]  ? rescuer_thread+0x380/0x380
[  372.682932]  ? kthread_associate_blkcg+0x90/0x90
[  372.708925]  ret_from_fork+0x1f/0x30
[  372.729339] Code: fe 31 c0 48 c7 c7 58 a8 c9 ba e8 02 4c cf ff 0f ff 31
c0 c3 48 89 d1 48 c7 c7 08 a8 c9 ba 48 89 f2 48 89 c6 31 c0 e8 e6 4b cf ff
<0f> ff 31 c0 c3 90 48 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b
[  372.835562] ---[ end trace d6ddd485d92c6ddd ]---

[  372.861081] scsi host1: ib_srp: Failed to map data (-5)    Note

[  372.863116] WARNING: CPU: 15 PID: 13175 at block/blk-mq.c:667
blk_mq_start_request+0x161/0x170
[  372.863117] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun
bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter rpcrdma ib_isert iscsi_target_mod target_core_mod ib_iser
libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc aesni_intel crypto_simd
ipmi_si glue_helper cryptd joydev ipmi_devintf ipmi_msghandler iTCO_wdt
iTCO_vendor_support dm_service_time pcspkr acpi_power_meter gpio_ich hpilo
hpwdt sg pcc_cpufreq i7core_edac
[  372.863147]  shpchp lpc_ich nfsd auth_rpcgss nfs_acl lockd grace
dm_multipath sunrpc ip_tables xfs libcrc32c sd_mod radeon mlx5_core
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
ttm mlxfw drm ptp i2c_core crc32c_intel hpsa pps_core serio_raw bnx2
devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  372.863165] CPU: 15 PID: 13175 Comm: kworker/u66:14 Tainted: G        W
I      4.15.0-rc4.dm_and_block+ #1
[  372.863166] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  372.863170] Workqueue: writeback wb_workfn (flush-253:13)
[  372.863173] RIP: 0010:blk_mq_start_request+0x161/0x170
[  372.863174] RSP: 0018:ffffae5b8c293480 EFLAGS: 00010202
[  372.863177] RAX: 0000000000000009 RBX: ffff929ba8b34c00 RCX:
0001ffffffffffff
[  372.863179] RDX: 00000056af18c440 RSI: 00310d51549749a3 RDI:
ffffffffbae29760
[  372.863180] RBP: 0000000000000000 R08: 0000000000000000 R09:
ffff929ba8b34d98
[  372.863182] R10: 0000000000001000 R11: 0000000000000000 R12:
ffff929ba8cdcba8
[  372.863183] R13: 0000000000004000 R14: ffff929ba920b800 R15:
ffff929ba8b34d60
[  372.863185] FS:  0000000000000000(0000) GS:ffff929c333c0000(0000)
knlGS:0000000000000000
[  372.863187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  372.863188] CR2: 00007fb07e09b000 CR3: 0000000f56609006 CR4:
00000000000206e0
[  372.863189] Call Trace:
[  372.863200]  scsi_queue_rq+0x2f4/0x560
[  372.863202]  ? scsi_mq_get_budget+0x31/0x110
[  372.863205]  __blk_mq_try_issue_directly+0x195/0x1e0
[  372.863206]  blk_mq_request_direct_issue+0x5d/0xc0
[  372.863209]  ? blk_insert_cloned_request+0x96/0x1c0
[  372.863221]  map_request+0x142/0x260 [dm_mod]
[  372.863226]  dm_mq_queue_rq+0xa4/0x120 [dm_mod]
[  372.863229]  blk_mq_dispatch_rq_list+0x8e/0x530
[  372.863233]  ? deadline_remove_request+0x79/0xc0
[  372.863236]  blk_mq_do_dispatch_sched+0x8b/0x110
[  372.863239]  blk_mq_sched_dispatch_requests+0x118/0x1a0
[  372.863241]  __blk_mq_run_hw_queue+0x5f/0xf0
[  372.863243]  __blk_mq_delay_run_hw_queue+0x9c/0xa0
[  372.863245]  blk_mq_run_hw_queue+0x54/0xf0
[  372.863248]  blk_mq_flush_plug_list+0x17f/0x260
[  372.863250]  blk_flush_plug_list+0xe4/0x260
[  372.863252]  blk_mq_make_request+0x483/0x560
[  372.863254]  generic_make_request+0x110/0x2e0
[  372.863257]  submit_bio+0x6e/0x140
[  372.863333]  xfs_add_to_ioend+0x13f/0x240 [xfs]
[  372.863364]  ? xfs_map_buffer.isra.14+0x33/0x60 [xfs]
[  372.863397]  xfs_do_writepage+0x214/0x600 [xfs]
[  372.863403]  ? find_get_pages_range_tag+0x15f/0x290
[  372.863407]  ? invalid_page_referenced_vma+0x90/0x90
[  372.863410]  write_cache_pages+0x222/0x470
[  372.863439]  ? xfs_aops_discard_page+0x130/0x130 [xfs]
[  372.863469]  xfs_vm_writepages+0xb2/0xd0 [xfs]
[  372.863473]  do_writepages+0x17/0x70
[  372.863475]  __writeback_single_inode+0x3d/0x330
[  372.863477]  writeback_sb_inodes+0x24f/0x4b0
[  372.863479]  __writeback_inodes_wb+0x87/0xb0
[  372.863481]  wb_writeback+0x276/0x310
[  372.863483]  wb_workfn+0x1b0/0x460
[  372.863489]  process_one_work+0x141/0x340
[  372.863491]  worker_thread+0x47/0x3e0
[  372.863494]  kthread+0xf5/0x130
[  372.863497]  ? rescuer_thread+0x380/0x380
[  372.863499]  ? kthread_associate_blkcg+0x90/0x90
[  372.863504]  ret_from_fork+0x1f/0x30
[  372.863506] Code: ed 09 48 21 c8 44 89 ea 81 e2 ff 0f 00 00 48 c1 e2 31
48 09 ea 48 09 c2 48 89 93 b0 00 00 00 e9 ea fe ff ff 0f ff e9 14 ff ff ff
<0f> ff e9 eb fe ff ff 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48
[  372.863523] ---[ end trace d6ddd485d92c6dde ]---
[  372.863536] WARNING: CPU: 15 PID: 13175 at block/blk-mq.h:128
blk_mq_start_request+0x15a/0x170
[  372.863537] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun
bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter rpcrdma ib_isert iscsi_target_mod target_core_mod ib_iser
libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc aesni_intel crypto_simd
ipmi_si glue_helper cryptd joydev ipmi_devintf ipmi_msghandler iTCO_wdt
iTCO_vendor_support dm_service_time pcspkr acpi_power_meter gpio_ich hpilo
hpwdt sg pcc_cpufreq i7core_edac
[  372.863557]  shpchp lpc_ich nfsd auth_rpcgss nfs_acl lockd grace
dm_multipath sunrpc ip_tables xfs libcrc32c sd_mod radeon mlx5_core
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
ttm mlxfw drm ptp i2c_core crc32c_intel hpsa pps_core serio_raw bnx2
devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  372.863568] CPU: 15 PID: 13175 Comm: kworker/u66:14 Tainted: G        W
I      4.15.0-rc4.dm_and_block+ #1
[  372.863569] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  372.863571] Workqueue: writeback wb_workfn (flush-253:13)
[  372.863573] RIP: 0010:blk_mq_start_request+0x15a/0x170
[  372.863574] RSP: 0018:ffffae5b8c293480 EFLAGS: 00010202
[  372.863576] RAX: 0000000000000009 RBX: ffff929ba8b34c00 RCX:
0001ffffffffffff
[  372.863577] RDX: 0000000000000001 RSI: 00310d51549749a3 RDI:
ffffffffbae29760
[  372.863578] RBP: 0000000000000000 R08: 0000000000000000 R09:
ffff929ba8b34d98
[  372.863579] R10: 0000000000001000 R11: 0000000000000000 R12:
ffff929ba8cdcba8
[  372.863580] R13: 0000000000004000 R14: ffff929ba920b800 R15:
ffff929ba8b34d60
[  372.863582] FS:  0000000000000000(0000) GS:ffff929c333c0000(0000)
knlGS:0000000000000000
[  372.863584] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  372.863585] CR2: 00007fb07e09b000 CR3: 0000000f56609006 CR4:
00000000000206e0
[  372.863587] Call Trace:
[  372.863589]  scsi_queue_rq+0x2f4/0x560
[  372.863591]  ? scsi_mq_get_budget+0x31/0x110
[  372.863593]  __blk_mq_try_issue_directly+0x195/0x1e0
[  372.863595]  blk_mq_request_direct_issue+0x5d/0xc0
[  372.863598]  ? blk_insert_cloned_request+0x96/0x1c0
[  372.863604]  map_request+0x142/0x260 [dm_mod]
[  372.863609]  dm_mq_queue_rq+0xa4/0x120 [dm_mod]
[  372.863611]  blk_mq_dispatch_rq_list+0x8e/0x530
[  372.863614]  ? deadline_remove_request+0x79/0xc0
[  372.863617]  blk_mq_do_dispatch_sched+0x8b/0x110
[  372.863619]  blk_mq_sched_dispatch_requests+0x118/0x1a0
[  372.863622]  __blk_mq_run_hw_queue+0x5f/0xf0
[  372.863625]  __blk_mq_delay_run_hw_queue+0x9c/0xa0
[  372.863627]  blk_mq_run_hw_queue+0x54/0xf0
[  372.863628]  blk_mq_flush_plug_list+0x17f/0x260
[  372.863630]  blk_flush_plug_list+0xe4/0x260
[  372.863632]  blk_mq_make_request+0x483/0x560
[  372.863634]  generic_make_request+0x110/0x2e0
[  372.863635]  submit_bio+0x6e/0x140
[  372.863664]  xfs_add_to_ioend+0x13f/0x240 [xfs]
[  372.863694]  ? xfs_map_buffer.isra.14+0x33/0x60 [xfs]
[  372.863724]  xfs_do_writepage+0x214/0x600 [xfs]
[  372.863727]  ? find_get_pages_range_tag+0x15f/0x290
[  372.863730]  ? invalid_page_referenced_vma+0x90/0x90
[  372.863732]  write_cache_pages+0x222/0x470
[  372.863762]  ? xfs_aops_discard_page+0x130/0x130 [xfs]
[  372.863791]  xfs_vm_writepages+0xb2/0xd0 [xfs]
[  372.863794]  do_writepages+0x17/0x70
[  372.863796]  __writeback_single_inode+0x3d/0x330
[  372.863799]  writeback_sb_inodes+0x24f/0x4b0
[  372.863801]  __writeback_inodes_wb+0x87/0xb0
[  372.863804]  wb_writeback+0x276/0x310
[  372.863806]  wb_workfn+0x1b0/0x460
[  372.863809]  process_one_work+0x141/0x340
[  372.863812]  worker_thread+0x47/0x3e0
[  372.863814]  kthread+0xf5/0x130
[  372.863817]  ? rescuer_thread+0x380/0x380
[  372.863820]  ? kthread_associate_blkcg+0x90/0x90
[  372.863822]  ret_from_fork+0x1f/0x30
[  372.863823] Code: 18 00 00 02 00 41 c1 ed 09 48 21 c8 44 89 ea 81 e2 ff
0f 00 00 48 c1 e2 31 48 09 ea 48 09 c2 48 89 93 b0 00 00 00 e9 ea fe ff ff
<0f> ff e9 14 ff ff ff 0f ff e9 eb fe ff ff 0f 1f 84 00 00 00 00
[  372.863841] ---[ end trace d6ddd485d92c6ddf ]---
[  372.915387] ------------[ cut here ]------------
[  372.915391] list_add corruption. prev->next should be next
(00000000bebab7ca), but was 00000000b1199db9. (prev=00000000b1199db9).
[  372.915416] WARNING: CPU: 15 PID: 13175 at lib/list_debug.c:28
__list_add_valid+0x6a/0x70
[  372.915417] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun
bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter rpcrdma ib_isert iscsi_target_mod target_core_mod ib_iser
libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc aesni_intel crypto_simd
ipmi_si glue_helper cryptd joydev ipmi_devintf ipmi_msghandler iTCO_wdt
iTCO_vendor_support dm_service_time pcspkr acpi_power_meter gpio_ich hpilo
hpwdt sg pcc_cpufreq i7core_edac
[  372.915454]  shpchp lpc_ich nfsd auth_rpcgss nfs_acl lockd grace
dm_multipath sunrpc ip_tables xfs libcrc32c sd_mod radeon mlx5_core
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
ttm mlxfw drm ptp i2c_core crc32c_intel hpsa pps_core serio_raw bnx2
devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  372.915473] CPU: 15 PID: 13175 Comm: kworker/u66:14 Tainted: G        W
I      4.15.0-rc4.dm_and_block+ #1
[  372.915473] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  372.915478] Workqueue: writeback wb_workfn (flush-253:13)
[  372.915481] RIP: 0010:__list_add_valid+0x6a/0x70
[  372.915482] RSP: 0018:ffffae5b8c2934b0 EFLAGS: 00010282
[  372.915484] RAX: 0000000000000000 RBX: ffff929c2bb83000 RCX:
0000000000000000
[  372.915485] RDX: 0000000000000001 RSI: 0000000000000002 RDI:
0000000000000282
[  372.915487] RBP: ffff929ba87ed100 R08: 0000000000000075 R09:
ffff929c6402cfdd
[  372.915487] R10: 0000000000000780 R11: 0000000000000000 R12:
ffff929ba87ed140
[  372.915489] R13: ffff929ba87ed140 R14: ffff929c2bb83008 R15:
0000000000000001
[  372.915491] FS:  0000000000000000(0000) GS:ffff929c333c0000(0000)
knlGS:0000000000000000
[  372.915492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  372.915493] CR2: 00007fb07e09b000 CR3: 0000000f56609006 CR4:
00000000000206e0
[  372.915494] Call Trace:
[  372.915500]  blk_mq_request_bypass_insert+0x57/0xa0
[  372.915503]  __blk_mq_try_issue_directly+0x56/0x1e0
[  372.915504]  blk_mq_request_direct_issue+0x5d/0xc0
[  372.915507]  ? blk_insert_cloned_request+0x96/0x1c0
[  372.915517]  map_request+0x142/0x260 [dm_mod]
[  372.915522]  dm_mq_queue_rq+0xa4/0x120 [dm_mod]
[  372.915525]  blk_mq_dispatch_rq_list+0x8e/0x530
[  372.915528]  ? deadline_remove_request+0x79/0xc0
[  372.915531]  blk_mq_do_dispatch_sched+0x8b/0x110
[  372.915534]  blk_mq_sched_dispatch_requests+0x118/0x1a0
[  372.915538]  __blk_mq_run_hw_queue+0x5f/0xf0
[  372.915540]  __blk_mq_delay_run_hw_queue+0x9c/0xa0
[  372.915542]  blk_mq_run_hw_queue+0x54/0xf0
[  372.915544]  blk_mq_flush_plug_list+0x17f/0x260
[  372.915547]  blk_flush_plug_list+0xe4/0x260
[  372.915550]  blk_mq_make_request+0x483/0x560
[  372.915553]  generic_make_request+0x110/0x2e0
[  372.915555]  submit_bio+0x6e/0x140
[  372.915608]  xfs_add_to_ioend+0x13f/0x240 [xfs]
[  372.915639]  ? xfs_map_buffer.isra.14+0x33/0x60 [xfs]
[  372.915667]  xfs_do_writepage+0x214/0x600 [xfs]
[  372.915673]  ? find_get_pages_range_tag+0x15f/0x290
[  372.915677]  ? invalid_page_referenced_vma+0x90/0x90
[  372.915680]  write_cache_pages+0x222/0x470
[  372.915709]  ? xfs_aops_discard_page+0x130/0x130 [xfs]
[  372.915739]  xfs_vm_writepages+0xb2/0xd0 [xfs]
[  372.915743]  do_writepages+0x17/0x70
[  372.915745]  __writeback_single_inode+0x3d/0x330
[  372.915746]  writeback_sb_inodes+0x24f/0x4b0
[  372.915749]  __writeback_inodes_wb+0x87/0xb0
[  372.915751]  wb_writeback+0x276/0x310
[  372.915753]  wb_workfn+0x1b0/0x460
[  372.915758]  process_one_work+0x141/0x340
[  372.915761]  worker_thread+0x47/0x3e0
[  372.915764]  kthread+0xf5/0x130
[  372.915766]  ? rescuer_thread+0x380/0x380
[  372.915769]  ? kthread_associate_blkcg+0x90/0x90
[  372.915774]  ret_from_fork+0x1f/0x30
[  372.915775] Code: fe 31 c0 48 c7 c7 58 a8 c9 ba e8 02 4c cf ff 0f ff 31
c0 c3 48 89 d1 48 c7 c7 08 a8 c9 ba 48 89 f2 48 89 c6 31 c0 e8 e6 4b cf ff
<0f> ff 31 c0 c3 90 48 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b
[  372.915792] ---[ end trace d6ddd485d92c6de0 ]---
[  372.916492] ------------[ cut here ]------------
[  372.916493] list_add corruption. prev->next should be next
(00000000bebab7ca), but was 00000000b1199db9. (prev=00000000b1199db9).
[  372.916501] WARNING: CPU: 15 PID: 13175 at lib/list_debug.c:28
__list_add_valid+0x6a/0x70






On Wed, Jan 17, 2018 at 7:54 PM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Jan 17 2018 at  6:53pm -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
> > On Wed, 2018-01-17 at 18:43 -0500, Laurence Oberman wrote:
> > > On Wed, 2018-01-17 at 23:31 +0000, Bart Van Assche wrote:
> > > > On Wed, 2018-01-17 at 11:58 -0500, Mike Snitzer wrote:
> > > > > On Wed, Jan 17 2018 at 11:50am -0500,
> > > > > Jens Axboe <axboe@kernel.dk> wrote:
> > > > >
> > > > > > On 1/17/18 9:25 AM, Mike Snitzer wrote:
> > > > > > > Hi Jens,
> > > > > > >
> > > > > > > Think this finally takes care of it! ;)
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Mike
> > > > > > >
> > > > > > > Mike Snitzer (2):
> > > > > > >   blk-mq: factor out a few helpers from
> > > > > > > __blk_mq_try_issue_directly
> > > > > > >   blk-mq-sched: remove unused 'can_block' arg from
> > > > > > > blk_mq_sched_insert_request
> > > > > > >
> > > > > > > Ming Lei (1):
> > > > > > >   blk-mq: improve DM's blk-mq IO merging via
> > > > > > > blk_insert_cloned_request feedback
> > > > > >
> > > > > > Applied - added actual commit message to patch 3.
> > > > >
> > > > > Great, thanks.
> > > >
> > > > Hello Mike,
> > > >
> > > > Laurence hit the following while retesting the SRP initiator code:
> > > >
> > > > [ 2223.797129] list_add corruption. prev->next should be next
> > > > (00000000e0ddd5dd), but was 000000003defe5cd.
> > > > (prev=000000003defe5cd).
> > > > [ 2223.862168] WARNING: CPU: 14 PID: 577 at lib/list_debug.c:28
> > > > __list_add_valid+0x6a/0x70
> > > > [ 2224.481151] CPU: 14 PID: 577 Comm: kworker/14:1H Tainted:
> > > > G          I      4.15.0-rc8.bart3+ #1
> > > > [ 2224.531193] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > > 08/16/2015
> > > > [ 2224.567150] Workqueue: kblockd blk_mq_run_work_fn
> > > > [ 2224.593182] RIP: 0010:__list_add_valid+0x6a/0x70
> > > > [ 2224.967002] Call Trace:
> > > > [ 2224.980941]  blk_mq_request_bypass_insert+0x57/0xa0
> > > > [ 2225.009044]  __blk_mq_try_issue_directly+0x56/0x1e0
> > > > [ 2225.037007]  blk_mq_request_direct_issue+0x5d/0xc0
> > > > [ 2225.090608]  map_request+0x142/0x260 [dm_mod]
> > > > [ 2225.114756]  dm_mq_queue_rq+0xa4/0x120 [dm_mod]
> > > > [ 2225.140812]  blk_mq_dispatch_rq_list+0x90/0x5b0
> > > > [ 2225.211769]  blk_mq_sched_dispatch_requests+0x107/0x1a0
> > > > [ 2225.240825]  __blk_mq_run_hw_queue+0x5f/0xf0
> > > > [ 2225.264852]  process_one_work+0x141/0x340
> > > > [ 2225.287872]  worker_thread+0x47/0x3e0
> > > > [ 2225.308354]  kthread+0xf5/0x130
> > > > [ 2225.396405]  ret_from_fork+0x32/0x40
> > > >
> > > > That call trace did not show up before this patch series was added to
> > > > Jens'
> > > > tree. This is a regression. Could this have been introduced by this
> > > > patch
> > > > series?
> > > >
> > > > Thanks,
> > > >
> > > > Bart.
> > >
> > > Hi Bart
> > > One thing to note.
> > >
> > > I tested Mike's combined tree on the weekend fully dm4.16-block4.16 and
> > > did not see this.
> > > This was with Mike combined tree and SRPT running 4.13-rc2.
> > >
> > > I also tested your tree Monday with the revert of the scatter/gather
> > > patches with both SRP and SRPT running your tree and it was fine.
> > >
> > > So its a combination of what you provided me before and that has been
> > > added to your tree.
> > >
> > > Mike combined tree seemed to be fine, I can revisit that if needed. I
> > > still have that kernel in place.
> > >
> > > I was not running latest SRPT when I tested Mike's tree
> >
> > Hello Laurence,
> >
> > The tree I sent you this morning did not only include Mike's latest dm
> code
> > but also Jens' latest for-next branch. So what you wrote above does not
> > contradict what I wrote in my e-mail, namely that I suspect that a
> regression
> > was introduced by the patches in the series "blk-mq: improve DM's blk-mq
> IO
> > merging via blk_insert_cloned_request feedback". These changes namely
> went in
> > through the block tree and not through the dm tree. Additionally, these
> > changes were not present in the block-scsi-for-next branch I sent you on
> > Monday.
>
> Functionality shouldn't be any different than the variant (Ming's v4)
> that Laurence tested on Sunday/Monday (once we got past the genirq issue
> on HPSA).
>
> But sure, I suppose there is something I missed when refactoring Ming's
> change to get it acceptable for upstream.  I went over the mechanical
> nature of what I did many times (comaping Ming's v4 to my v5).
>
> Anyway, we'll see how Laurence fairs with this tree (but with the revert
> of 84676c1 added, so his HPSA server will boot):
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/
> linux.git/log/?h=block-4.16_dm-4.16
> (which is the same as linux-dm.git's 'for-next' at the moment)
>
> The call to blk_mq_request_bypass_insert will only occur via
> __blk_mq_fallback_to_insert.  Which as the name implies this is not the
> fast path.  This will occur if the underlying blk-mq device cannot get
> resources it needs in order to issue the request.  Specifically: if/when
> in __blk_mq_try_issue_directly() the hctx is stopped, or queue is
> quiesced, or it cannot get the driver tag or dispatch_budget (in the
> case of scsi-mq).
>
> The same fallback, via call to blk_mq_request_bypass_insert, occured
> with Ming's v4 though.
>
> Anyway, we'll see what Laurence finds when testing my above kernel.
>
> Mike
>

--94eb2c058080d79aed056302b92d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">MIke and Bart<div><br><div>Replying via Browser because Ev=
olution is having issues so cannot copy the block list.</div><div>The gmail=
 browser wont do clean text, only evolution for me.</div><div><br></div><di=
v>Server is running 4.13-rc1 for the RPT so stayed up, Client see sthe list=
 corruption like I saw on Barts tree.</div><div>Someone will have to copy t=
he block list if needed until I get evolution back<br></div><div><br></div>=
<div><div>[=C2=A0 370.765953] list_add corruption. prev-&gt;next should be =
next (0000000062acf0b0), but was 000000007a44ce4f. (prev=3D000000007a44ce4f=
).</div><div>[=C2=A0 370.831948] WARNING: CPU: 15 PID: 13175 at lib/list_de=
bug.c:28 __list_add_valid+0x6a/0x70</div><div>[=C2=A0 370.877893] Modules l=
inked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 =
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrac=
k nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter =
ebtables ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert iscsi_t=
arget_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_srp scsi=
_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_=
cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel kvm irqbypass crct10=
dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc aesni_intel cryp=
to_simd ipmi_si glue_helper cryptd joydev ipmi_devintf ipmi_msghandler iTCO=
_wdt iTCO_vendor_support dm_service_time pcspkr acpi_power_meter gpio_ich h=
pilo hpwdt sg pcc_cpufreq i7core_edac</div><div>[=C2=A0 371.273754]=C2=A0 s=
hpchp lpc_ich nfsd auth_rpcgss nfs_acl lockd grace dm_multipath sunrpc ip_t=
ables xfs libcrc32c sd_mod radeon mlx5_core i2c_algo_bit drm_kms_helper sys=
copyarea sysfillrect sysimgblt fb_sys_fops ttm mlxfw drm ptp i2c_core crc32=
c_intel hpsa pps_core serio_raw bnx2 devlink scsi_transport_sas dm_mirror d=
m_region_hash dm_log dm_mod</div><div>[=C2=A0 371.444895] CPU: 15 PID: 1317=
5 Comm: kworker/u66:14 Tainted: G=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 I=C2=A0=
 =C2=A0 =C2=A0 4.15.0-rc4.dm_and_block+ #1</div><div>[=C2=A0 371.499292] Ha=
rdware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015</div><div>[=C2=A0 37=
1.535070] Workqueue: writeback wb_workfn (flush-253:13)</div><div>[=C2=A0 3=
71.565729] RIP: 0010:__list_add_valid+0x6a/0x70</div><div>[=C2=A0 371.59219=
7] RSP: 0018:ffffae5b8c293690 EFLAGS: 00010286</div><div>[=C2=A0 371.621114=
] RAX: 0000000000000000 RBX: ffff929ba920b800 RCX: 0000000000000000</div><d=
iv>[=C2=A0 371.661131] RDX: 0000000000000001 RSI: ffff929c333cdf78 RDI: fff=
f929c333cdf78</div><div>[=C2=A0 371.702111] RBP: ffff929ba8b34c00 R08: 0000=
000000000000 R09: 00000000000006d7</div><div>[=C2=A0 371.743248] R10: 00000=
00000000000 R11: ffffae5b8c2933f8 R12: ffff929ba8b34c40</div><div>[=C2=A0 3=
71.783772] R13: ffff929ba8b34c40 R14: ffff929ba920b808 R15: 000000000000000=
1</div><div>[=C2=A0 371.824291] FS:=C2=A0 0000000000000000(0000) GS:ffff929=
c333c0000(0000) knlGS:0000000000000000</div><div>[=C2=A0 371.870706] CS:=C2=
=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033</div><div>[=C2=A0 371.9038=
03] CR2: 00007fb07e09b000 CR3: 0000000f56609006 CR4: 00000000000206e0</div>=
<div>[=C2=A0 371.943875] Call Trace:</div><div>[=C2=A0 371.957310]=C2=A0 bl=
k_mq_request_bypass_insert+0x57/0xa0</div><div>[=C2=A0 371.984333]=C2=A0 __=
blk_mq_try_issue_directly+0x56/0x1e0</div><div>[=C2=A0 372.011390]=C2=A0 bl=
k_mq_request_direct_issue+0x5d/0xc0</div><div>[=C2=A0 372.038404]=C2=A0 ? b=
lk_insert_cloned_request+0x96/0x1c0</div><div>[=C2=A0 372.065923]=C2=A0 map=
_request+0x142/0x260 [dm_mod]</div><div>[=C2=A0 372.090043]=C2=A0 dm_mq_que=
ue_rq+0xa4/0x120 [dm_mod]</div><div>[=C2=A0 372.115507]=C2=A0 blk_mq_dispat=
ch_rq_list+0x8e/0x530</div><div>[=C2=A0 372.141076]=C2=A0 ? deadline_remove=
_request+0x79/0xc0</div><div>[=C2=A0 372.167035]=C2=A0 blk_mq_do_dispatch_s=
ched+0x8b/0x110</div><div>[=C2=A0 372.192938]=C2=A0 blk_mq_sched_dispatch_r=
equests+0x118/0x1a0</div><div>[=C2=A0 372.222326]=C2=A0 __blk_mq_run_hw_que=
ue+0x5f/0xf0</div><div>[=C2=A0 372.246083]=C2=A0 __blk_mq_delay_run_hw_queu=
e+0x9c/0xa0</div><div>[=C2=A0 372.272943]=C2=A0 blk_mq_run_hw_queue+0x54/0x=
f0</div><div>[=C2=A0 372.296181]=C2=A0 blk_mq_flush_plug_list+0x17f/0x260</=
div><div>[=C2=A0 372.322152]=C2=A0 blk_flush_plug_list+0xe4/0x260</div><div=
>[=C2=A0 372.345712]=C2=A0 blk_mq_make_request+0x483/0x560</div><div>[=C2=
=A0 372.370156]=C2=A0 generic_make_request+0x110/0x2e0</div><div>[=C2=A0 37=
2.394759]=C2=A0 submit_bio+0x6e/0x140</div><div>[=C2=A0 372.414258]=C2=A0 x=
fs_submit_ioend+0x9c/0x110 [xfs]</div><div>[=C2=A0 372.439759]=C2=A0 xfs_vm=
_writepages+0xc6/0xd0 [xfs]</div><div>[=C2=A0 372.464677]=C2=A0 do_writepag=
es+0x17/0x70</div><div>[=C2=A0 372.484686]=C2=A0 __writeback_single_inode+0=
x3d/0x330</div><div>[=C2=A0 372.510219]=C2=A0 writeback_sb_inodes+0x24f/0x4=
b0</div><div>[=C2=A0 372.534789]=C2=A0 __writeback_inodes_wb+0x87/0xb0</div=
><div>[=C2=A0 372.558826]=C2=A0 wb_writeback+0x276/0x310</div><div>[=C2=A0 =
372.579434]=C2=A0 wb_workfn+0x1b0/0x460</div><div>[=C2=A0 372.598886]=C2=A0=
 process_one_work+0x141/0x340</div><div>[=C2=A0 372.621522]=C2=A0 worker_th=
read+0x47/0x3e0</div><div>[=C2=A0 372.641939]=C2=A0 kthread+0xf5/0x130</div=
><div>[=C2=A0 372.659890]=C2=A0 ? rescuer_thread+0x380/0x380</div><div>[=C2=
=A0 372.682932]=C2=A0 ? kthread_associate_blkcg+0x90/0x90</div><div>[=C2=A0=
 372.708925]=C2=A0 ret_from_fork+0x1f/0x30</div><div>[=C2=A0 372.729339] Co=
de: fe 31 c0 48 c7 c7 58 a8 c9 ba e8 02 4c cf ff 0f ff 31 c0 c3 48 89 d1 48=
 c7 c7 08 a8 c9 ba 48 89 f2 48 89 c6 31 c0 e8 e6 4b cf ff &lt;0f&gt; ff 31 =
c0 c3 90 48 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b=C2=A0</div><div>[=C2=
=A0 372.835562] ---[ end trace d6ddd485d92c6ddd ]---</div><div><br></div><d=
iv>[=C2=A0 372.861081] scsi host1: ib_srp: Failed to map data (-5)=C2=A0 =
=C2=A0 Note</div><div><br></div><div>[=C2=A0 372.863116] WARNING: CPU: 15 P=
ID: 13175 at block/blk-mq.c:667 blk_mq_start_request+0x161/0x170</div><div>=
[=C2=A0 372.863117] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQU=
ERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ip=
v4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun b=
ridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_fi=
lter rpcrdma ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scs=
i_transport_iscsi ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uve=
rbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp k=
vm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmuln=
i_intel pcbc aesni_intel crypto_simd ipmi_si glue_helper cryptd joydev ipmi=
_devintf ipmi_msghandler iTCO_wdt iTCO_vendor_support dm_service_time pcspk=
r acpi_power_meter gpio_ich hpilo hpwdt sg pcc_cpufreq i7core_edac</div><di=
v>[=C2=A0 372.863147]=C2=A0 shpchp lpc_ich nfsd auth_rpcgss nfs_acl lockd g=
race dm_multipath sunrpc ip_tables xfs libcrc32c sd_mod radeon mlx5_core i2=
c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm=
 mlxfw drm ptp i2c_core crc32c_intel hpsa pps_core serio_raw bnx2 devlink s=
csi_transport_sas dm_mirror dm_region_hash dm_log dm_mod</div><div>[=C2=A0 =
372.863165] CPU: 15 PID: 13175 Comm: kworker/u66:14 Tainted: G=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 W I=C2=A0 =C2=A0 =C2=A0 4.15.0-rc4.dm_and_block+ #1</div><di=
v>[=C2=A0 372.863166] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2=
015</div><div>[=C2=A0 372.863170] Workqueue: writeback wb_workfn (flush-253=
:13)</div><div>[=C2=A0 372.863173] RIP: 0010:blk_mq_start_request+0x161/0x1=
70</div><div>[=C2=A0 372.863174] RSP: 0018:ffffae5b8c293480 EFLAGS: 0001020=
2</div><div>[=C2=A0 372.863177] RAX: 0000000000000009 RBX: ffff929ba8b34c00=
 RCX: 0001ffffffffffff</div><div>[=C2=A0 372.863179] RDX: 00000056af18c440 =
RSI: 00310d51549749a3 RDI: ffffffffbae29760</div><div>[=C2=A0 372.863180] R=
BP: 0000000000000000 R08: 0000000000000000 R09: ffff929ba8b34d98</div><div>=
[=C2=A0 372.863182] R10: 0000000000001000 R11: 0000000000000000 R12: ffff92=
9ba8cdcba8</div><div>[=C2=A0 372.863183] R13: 0000000000004000 R14: ffff929=
ba920b800 R15: ffff929ba8b34d60</div><div>[=C2=A0 372.863185] FS:=C2=A0 000=
0000000000000(0000) GS:ffff929c333c0000(0000) knlGS:0000000000000000</div><=
div>[=C2=A0 372.863187] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033</div><div>[=C2=A0 372.863188] CR2: 00007fb07e09b000 CR3: 0000000f566090=
06 CR4: 00000000000206e0</div><div>[=C2=A0 372.863189] Call Trace:</div><di=
v>[=C2=A0 372.863200]=C2=A0 scsi_queue_rq+0x2f4/0x560</div><div>[=C2=A0 372=
.863202]=C2=A0 ? scsi_mq_get_budget+0x31/0x110</div><div>[=C2=A0 372.863205=
]=C2=A0 __blk_mq_try_issue_directly+0x195/0x1e0</div><div>[=C2=A0 372.86320=
6]=C2=A0 blk_mq_request_direct_issue+0x5d/0xc0</div><div>[=C2=A0 372.863209=
]=C2=A0 ? blk_insert_cloned_request+0x96/0x1c0</div><div>[=C2=A0 372.863221=
]=C2=A0 map_request+0x142/0x260 [dm_mod]</div><div>[=C2=A0 372.863226]=C2=
=A0 dm_mq_queue_rq+0xa4/0x120 [dm_mod]</div><div>[=C2=A0 372.863229]=C2=A0 =
blk_mq_dispatch_rq_list+0x8e/0x530</div><div>[=C2=A0 372.863233]=C2=A0 ? de=
adline_remove_request+0x79/0xc0</div><div>[=C2=A0 372.863236]=C2=A0 blk_mq_=
do_dispatch_sched+0x8b/0x110</div><div>[=C2=A0 372.863239]=C2=A0 blk_mq_sch=
ed_dispatch_requests+0x118/0x1a0</div><div>[=C2=A0 372.863241]=C2=A0 __blk_=
mq_run_hw_queue+0x5f/0xf0</div><div>[=C2=A0 372.863243]=C2=A0 __blk_mq_dela=
y_run_hw_queue+0x9c/0xa0</div><div>[=C2=A0 372.863245]=C2=A0 blk_mq_run_hw_=
queue+0x54/0xf0</div><div>[=C2=A0 372.863248]=C2=A0 blk_mq_flush_plug_list+=
0x17f/0x260</div><div>[=C2=A0 372.863250]=C2=A0 blk_flush_plug_list+0xe4/0x=
260</div><div>[=C2=A0 372.863252]=C2=A0 blk_mq_make_request+0x483/0x560</di=
v><div>[=C2=A0 372.863254]=C2=A0 generic_make_request+0x110/0x2e0</div><div=
>[=C2=A0 372.863257]=C2=A0 submit_bio+0x6e/0x140</div><div>[=C2=A0 372.8633=
33]=C2=A0 xfs_add_to_ioend+0x13f/0x240 [xfs]</div><div>[=C2=A0 372.863364]=
=C2=A0 ? xfs_map_buffer.isra.14+0x33/0x60 [xfs]</div><div>[=C2=A0 372.86339=
7]=C2=A0 xfs_do_writepage+0x214/0x600 [xfs]</div><div>[=C2=A0 372.863403]=
=C2=A0 ? find_get_pages_range_tag+0x15f/0x290</div><div>[=C2=A0 372.863407]=
=C2=A0 ? invalid_page_referenced_vma+0x90/0x90</div><div>[=C2=A0 372.863410=
]=C2=A0 write_cache_pages+0x222/0x470</div><div>[=C2=A0 372.863439]=C2=A0 ?=
 xfs_aops_discard_page+0x130/0x130 [xfs]</div><div>[=C2=A0 372.863469]=C2=
=A0 xfs_vm_writepages+0xb2/0xd0 [xfs]</div><div>[=C2=A0 372.863473]=C2=A0 d=
o_writepages+0x17/0x70</div><div>[=C2=A0 372.863475]=C2=A0 __writeback_sing=
le_inode+0x3d/0x330</div><div>[=C2=A0 372.863477]=C2=A0 writeback_sb_inodes=
+0x24f/0x4b0</div><div>[=C2=A0 372.863479]=C2=A0 __writeback_inodes_wb+0x87=
/0xb0</div><div>[=C2=A0 372.863481]=C2=A0 wb_writeback+0x276/0x310</div><di=
v>[=C2=A0 372.863483]=C2=A0 wb_workfn+0x1b0/0x460</div><div>[=C2=A0 372.863=
489]=C2=A0 process_one_work+0x141/0x340</div><div>[=C2=A0 372.863491]=C2=A0=
 worker_thread+0x47/0x3e0</div><div>[=C2=A0 372.863494]=C2=A0 kthread+0xf5/=
0x130</div><div>[=C2=A0 372.863497]=C2=A0 ? rescuer_thread+0x380/0x380</div=
><div>[=C2=A0 372.863499]=C2=A0 ? kthread_associate_blkcg+0x90/0x90</div><d=
iv>[=C2=A0 372.863504]=C2=A0 ret_from_fork+0x1f/0x30</div><div>[=C2=A0 372.=
863506] Code: ed 09 48 21 c8 44 89 ea 81 e2 ff 0f 00 00 48 c1 e2 31 48 09 e=
a 48 09 c2 48 89 93 b0 00 00 00 e9 ea fe ff ff 0f ff e9 14 ff ff ff &lt;0f&=
gt; ff e9 eb fe ff ff 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48=C2=A0</div>=
<div>[=C2=A0 372.863523] ---[ end trace d6ddd485d92c6dde ]---</div><div>[=
=C2=A0 372.863536] WARNING: CPU: 15 PID: 13175 at block/blk-mq.h:128 blk_mq=
_start_request+0x15a/0x170</div><div>[=C2=A0 372.863537] Modules linked in:=
 xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_n=
at nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conn=
track ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables =
ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert iscsi_target_mod=
 target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_srp scsi_transpor=
t_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_i=
b ib_core intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmu=
l crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc aesni_intel crypto_simd i=
pmi_si glue_helper cryptd joydev ipmi_devintf ipmi_msghandler iTCO_wdt iTCO=
_vendor_support dm_service_time pcspkr acpi_power_meter gpio_ich hpilo hpwd=
t sg pcc_cpufreq i7core_edac</div><div>[=C2=A0 372.863557]=C2=A0 shpchp lpc=
_ich nfsd auth_rpcgss nfs_acl lockd grace dm_multipath sunrpc ip_tables xfs=
 libcrc32c sd_mod radeon mlx5_core i2c_algo_bit drm_kms_helper syscopyarea =
sysfillrect sysimgblt fb_sys_fops ttm mlxfw drm ptp i2c_core crc32c_intel h=
psa pps_core serio_raw bnx2 devlink scsi_transport_sas dm_mirror dm_region_=
hash dm_log dm_mod</div><div>[=C2=A0 372.863568] CPU: 15 PID: 13175 Comm: k=
worker/u66:14 Tainted: G=C2=A0 =C2=A0 =C2=A0 =C2=A0 W I=C2=A0 =C2=A0 =C2=A0=
 4.15.0-rc4.dm_and_block+ #1</div><div>[=C2=A0 372.863569] Hardware name: H=
P ProLiant DL380 G7, BIOS P67 08/16/2015</div><div>[=C2=A0 372.863571] Work=
queue: writeback wb_workfn (flush-253:13)</div><div>[=C2=A0 372.863573] RIP=
: 0010:blk_mq_start_request+0x15a/0x170</div><div>[=C2=A0 372.863574] RSP: =
0018:ffffae5b8c293480 EFLAGS: 00010202</div><div>[=C2=A0 372.863576] RAX: 0=
000000000000009 RBX: ffff929ba8b34c00 RCX: 0001ffffffffffff</div><div>[=C2=
=A0 372.863577] RDX: 0000000000000001 RSI: 00310d51549749a3 RDI: ffffffffba=
e29760</div><div>[=C2=A0 372.863578] RBP: 0000000000000000 R08: 00000000000=
00000 R09: ffff929ba8b34d98</div><div>[=C2=A0 372.863579] R10: 000000000000=
1000 R11: 0000000000000000 R12: ffff929ba8cdcba8</div><div>[=C2=A0 372.8635=
80] R13: 0000000000004000 R14: ffff929ba920b800 R15: ffff929ba8b34d60</div>=
<div>[=C2=A0 372.863582] FS:=C2=A0 0000000000000000(0000) GS:ffff929c333c00=
00(0000) knlGS:0000000000000000</div><div>[=C2=A0 372.863584] CS:=C2=A0 001=
0 DS: 0000 ES: 0000 CR0: 0000000080050033</div><div>[=C2=A0 372.863585] CR2=
: 00007fb07e09b000 CR3: 0000000f56609006 CR4: 00000000000206e0</div><div>[=
=C2=A0 372.863587] Call Trace:</div><div>[=C2=A0 372.863589]=C2=A0 scsi_que=
ue_rq+0x2f4/0x560</div><div>[=C2=A0 372.863591]=C2=A0 ? scsi_mq_get_budget+=
0x31/0x110</div><div>[=C2=A0 372.863593]=C2=A0 __blk_mq_try_issue_directly+=
0x195/0x1e0</div><div>[=C2=A0 372.863595]=C2=A0 blk_mq_request_direct_issue=
+0x5d/0xc0</div><div>[=C2=A0 372.863598]=C2=A0 ? blk_insert_cloned_request+=
0x96/0x1c0</div><div>[=C2=A0 372.863604]=C2=A0 map_request+0x142/0x260 [dm_=
mod]</div><div>[=C2=A0 372.863609]=C2=A0 dm_mq_queue_rq+0xa4/0x120 [dm_mod]=
</div><div>[=C2=A0 372.863611]=C2=A0 blk_mq_dispatch_rq_list+0x8e/0x530</di=
v><div>[=C2=A0 372.863614]=C2=A0 ? deadline_remove_request+0x79/0xc0</div><=
div>[=C2=A0 372.863617]=C2=A0 blk_mq_do_dispatch_sched+0x8b/0x110</div><div=
>[=C2=A0 372.863619]=C2=A0 blk_mq_sched_dispatch_requests+0x118/0x1a0</div>=
<div>[=C2=A0 372.863622]=C2=A0 __blk_mq_run_hw_queue+0x5f/0xf0</div><div>[=
=C2=A0 372.863625]=C2=A0 __blk_mq_delay_run_hw_queue+0x9c/0xa0</div><div>[=
=C2=A0 372.863627]=C2=A0 blk_mq_run_hw_queue+0x54/0xf0</div><div>[=C2=A0 37=
2.863628]=C2=A0 blk_mq_flush_plug_list+0x17f/0x260</div><div>[=C2=A0 372.86=
3630]=C2=A0 blk_flush_plug_list+0xe4/0x260</div><div>[=C2=A0 372.863632]=C2=
=A0 blk_mq_make_request+0x483/0x560</div><div>[=C2=A0 372.863634]=C2=A0 gen=
eric_make_request+0x110/0x2e0</div><div>[=C2=A0 372.863635]=C2=A0 submit_bi=
o+0x6e/0x140</div><div>[=C2=A0 372.863664]=C2=A0 xfs_add_to_ioend+0x13f/0x2=
40 [xfs]</div><div>[=C2=A0 372.863694]=C2=A0 ? xfs_map_buffer.isra.14+0x33/=
0x60 [xfs]</div><div>[=C2=A0 372.863724]=C2=A0 xfs_do_writepage+0x214/0x600=
 [xfs]</div><div>[=C2=A0 372.863727]=C2=A0 ? find_get_pages_range_tag+0x15f=
/0x290</div><div>[=C2=A0 372.863730]=C2=A0 ? invalid_page_referenced_vma+0x=
90/0x90</div><div>[=C2=A0 372.863732]=C2=A0 write_cache_pages+0x222/0x470</=
div><div>[=C2=A0 372.863762]=C2=A0 ? xfs_aops_discard_page+0x130/0x130 [xfs=
]</div><div>[=C2=A0 372.863791]=C2=A0 xfs_vm_writepages+0xb2/0xd0 [xfs]</di=
v><div>[=C2=A0 372.863794]=C2=A0 do_writepages+0x17/0x70</div><div>[=C2=A0 =
372.863796]=C2=A0 __writeback_single_inode+0x3d/0x330</div><div>[=C2=A0 372=
.863799]=C2=A0 writeback_sb_inodes+0x24f/0x4b0</div><div>[=C2=A0 372.863801=
]=C2=A0 __writeback_inodes_wb+0x87/0xb0</div><div>[=C2=A0 372.863804]=C2=A0=
 wb_writeback+0x276/0x310</div><div>[=C2=A0 372.863806]=C2=A0 wb_workfn+0x1=
b0/0x460</div><div>[=C2=A0 372.863809]=C2=A0 process_one_work+0x141/0x340</=
div><div>[=C2=A0 372.863812]=C2=A0 worker_thread+0x47/0x3e0</div><div>[=C2=
=A0 372.863814]=C2=A0 kthread+0xf5/0x130</div><div>[=C2=A0 372.863817]=C2=
=A0 ? rescuer_thread+0x380/0x380</div><div>[=C2=A0 372.863820]=C2=A0 ? kthr=
ead_associate_blkcg+0x90/0x90</div><div>[=C2=A0 372.863822]=C2=A0 ret_from_=
fork+0x1f/0x30</div><div>[=C2=A0 372.863823] Code: 18 00 00 02 00 41 c1 ed =
09 48 21 c8 44 89 ea 81 e2 ff 0f 00 00 48 c1 e2 31 48 09 ea 48 09 c2 48 89 =
93 b0 00 00 00 e9 ea fe ff ff &lt;0f&gt; ff e9 14 ff ff ff 0f ff e9 eb fe f=
f ff 0f 1f 84 00 00 00 00=C2=A0</div><div>[=C2=A0 372.863841] ---[ end trac=
e d6ddd485d92c6ddf ]---</div><div>[=C2=A0 372.915387] ------------[ cut her=
e ]------------</div><div>[=C2=A0 372.915391] list_add corruption. prev-&gt=
;next should be next (00000000bebab7ca), but was 00000000b1199db9. (prev=3D=
00000000b1199db9).</div><div>[=C2=A0 372.915416] WARNING: CPU: 15 PID: 1317=
5 at lib/list_debug.c:28 __list_add_valid+0x6a/0x70</div><div>[=C2=A0 372.9=
15417] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_=
masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_=
ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc=
 ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter rpcrdma =
ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_i=
scsi ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad r=
dma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel kvm =
irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc =
aesni_intel crypto_simd ipmi_si glue_helper cryptd joydev ipmi_devintf ipmi=
_msghandler iTCO_wdt iTCO_vendor_support dm_service_time pcspkr acpi_power_=
meter gpio_ich hpilo hpwdt sg pcc_cpufreq i7core_edac</div><div>[=C2=A0 372=
.915454]=C2=A0 shpchp lpc_ich nfsd auth_rpcgss nfs_acl lockd grace dm_multi=
path sunrpc ip_tables xfs libcrc32c sd_mod radeon mlx5_core i2c_algo_bit dr=
m_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlxfw drm pt=
p i2c_core crc32c_intel hpsa pps_core serio_raw bnx2 devlink scsi_transport=
_sas dm_mirror dm_region_hash dm_log dm_mod</div><div>[=C2=A0 372.915473] C=
PU: 15 PID: 13175 Comm: kworker/u66:14 Tainted: G=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 W I=C2=A0 =C2=A0 =C2=A0 4.15.0-rc4.dm_and_block+ #1</div><div>[=C2=A0 3=
72.915473] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015</div><d=
iv>[=C2=A0 372.915478] Workqueue: writeback wb_workfn (flush-253:13)</div><=
div>[=C2=A0 372.915481] RIP: 0010:__list_add_valid+0x6a/0x70</div><div>[=C2=
=A0 372.915482] RSP: 0018:ffffae5b8c2934b0 EFLAGS: 00010282</div><div>[=C2=
=A0 372.915484] RAX: 0000000000000000 RBX: ffff929c2bb83000 RCX: 0000000000=
000000</div><div>[=C2=A0 372.915485] RDX: 0000000000000001 RSI: 00000000000=
00002 RDI: 0000000000000282</div><div>[=C2=A0 372.915487] RBP: ffff929ba87e=
d100 R08: 0000000000000075 R09: ffff929c6402cfdd</div><div>[=C2=A0 372.9154=
87] R10: 0000000000000780 R11: 0000000000000000 R12: ffff929ba87ed140</div>=
<div>[=C2=A0 372.915489] R13: ffff929ba87ed140 R14: ffff929c2bb83008 R15: 0=
000000000000001</div><div>[=C2=A0 372.915491] FS:=C2=A0 0000000000000000(00=
00) GS:ffff929c333c0000(0000) knlGS:0000000000000000</div><div>[=C2=A0 372.=
915492] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033</div><div>[=
=C2=A0 372.915493] CR2: 00007fb07e09b000 CR3: 0000000f56609006 CR4: 0000000=
0000206e0</div><div>[=C2=A0 372.915494] Call Trace:</div><div>[=C2=A0 372.9=
15500]=C2=A0 blk_mq_request_bypass_insert+0x57/0xa0</div><div>[=C2=A0 372.9=
15503]=C2=A0 __blk_mq_try_issue_directly+0x56/0x1e0</div><div>[=C2=A0 372.9=
15504]=C2=A0 blk_mq_request_direct_issue+0x5d/0xc0</div><div>[=C2=A0 372.91=
5507]=C2=A0 ? blk_insert_cloned_request+0x96/0x1c0</div><div>[=C2=A0 372.91=
5517]=C2=A0 map_request+0x142/0x260 [dm_mod]</div><div>[=C2=A0 372.915522]=
=C2=A0 dm_mq_queue_rq+0xa4/0x120 [dm_mod]</div><div>[=C2=A0 372.915525]=C2=
=A0 blk_mq_dispatch_rq_list+0x8e/0x530</div><div>[=C2=A0 372.915528]=C2=A0 =
? deadline_remove_request+0x79/0xc0</div><div>[=C2=A0 372.915531]=C2=A0 blk=
_mq_do_dispatch_sched+0x8b/0x110</div><div>[=C2=A0 372.915534]=C2=A0 blk_mq=
_sched_dispatch_requests+0x118/0x1a0</div><div>[=C2=A0 372.915538]=C2=A0 __=
blk_mq_run_hw_queue+0x5f/0xf0</div><div>[=C2=A0 372.915540]=C2=A0 __blk_mq_=
delay_run_hw_queue+0x9c/0xa0</div><div>[=C2=A0 372.915542]=C2=A0 blk_mq_run=
_hw_queue+0x54/0xf0</div><div>[=C2=A0 372.915544]=C2=A0 blk_mq_flush_plug_l=
ist+0x17f/0x260</div><div>[=C2=A0 372.915547]=C2=A0 blk_flush_plug_list+0xe=
4/0x260</div><div>[=C2=A0 372.915550]=C2=A0 blk_mq_make_request+0x483/0x560=
</div><div>[=C2=A0 372.915553]=C2=A0 generic_make_request+0x110/0x2e0</div>=
<div>[=C2=A0 372.915555]=C2=A0 submit_bio+0x6e/0x140</div><div>[=C2=A0 372.=
915608]=C2=A0 xfs_add_to_ioend+0x13f/0x240 [xfs]</div><div>[=C2=A0 372.9156=
39]=C2=A0 ? xfs_map_buffer.isra.14+0x33/0x60 [xfs]</div><div>[=C2=A0 372.91=
5667]=C2=A0 xfs_do_writepage+0x214/0x600 [xfs]</div><div>[=C2=A0 372.915673=
]=C2=A0 ? find_get_pages_range_tag+0x15f/0x290</div><div>[=C2=A0 372.915677=
]=C2=A0 ? invalid_page_referenced_vma+0x90/0x90</div><div>[=C2=A0 372.91568=
0]=C2=A0 write_cache_pages+0x222/0x470</div><div>[=C2=A0 372.915709]=C2=A0 =
? xfs_aops_discard_page+0x130/0x130 [xfs]</div><div>[=C2=A0 372.915739]=C2=
=A0 xfs_vm_writepages+0xb2/0xd0 [xfs]</div><div>[=C2=A0 372.915743]=C2=A0 d=
o_writepages+0x17/0x70</div><div>[=C2=A0 372.915745]=C2=A0 __writeback_sing=
le_inode+0x3d/0x330</div><div>[=C2=A0 372.915746]=C2=A0 writeback_sb_inodes=
+0x24f/0x4b0</div><div>[=C2=A0 372.915749]=C2=A0 __writeback_inodes_wb+0x87=
/0xb0</div><div>[=C2=A0 372.915751]=C2=A0 wb_writeback+0x276/0x310</div><di=
v>[=C2=A0 372.915753]=C2=A0 wb_workfn+0x1b0/0x460</div><div>[=C2=A0 372.915=
758]=C2=A0 process_one_work+0x141/0x340</div><div>[=C2=A0 372.915761]=C2=A0=
 worker_thread+0x47/0x3e0</div><div>[=C2=A0 372.915764]=C2=A0 kthread+0xf5/=
0x130</div><div>[=C2=A0 372.915766]=C2=A0 ? rescuer_thread+0x380/0x380</div=
><div>[=C2=A0 372.915769]=C2=A0 ? kthread_associate_blkcg+0x90/0x90</div><d=
iv>[=C2=A0 372.915774]=C2=A0 ret_from_fork+0x1f/0x30</div><div>[=C2=A0 372.=
915775] Code: fe 31 c0 48 c7 c7 58 a8 c9 ba e8 02 4c cf ff 0f ff 31 c0 c3 4=
8 89 d1 48 c7 c7 08 a8 c9 ba 48 89 f2 48 89 c6 31 c0 e8 e6 4b cf ff &lt;0f&=
gt; ff 31 c0 c3 90 48 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b=C2=A0</div>=
<div>[=C2=A0 372.915792] ---[ end trace d6ddd485d92c6de0 ]---</div><div>[=
=C2=A0 372.916492] ------------[ cut here ]------------</div><div>[=C2=A0 3=
72.916493] list_add corruption. prev-&gt;next should be next (00000000bebab=
7ca), but was 00000000b1199db9. (prev=3D00000000b1199db9).</div><div>[=C2=
=A0 372.916501] WARNING: CPU: 15 PID: 13175 at lib/list_debug.c:28 __list_a=
dd_valid+0x6a/0x70</div></div><div><br></div><div><br></div><div><br></div>=
<div><br></div><div><br></div></div></div><div class=3D"gmail_extra"><br><d=
iv class=3D"gmail_quote">On Wed, Jan 17, 2018 at 7:54 PM, Mike Snitzer <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:snitzer@redhat.com" target=3D"_blank">s=
nitzer@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><=
div class=3D"HOEnZb"><div class=3D"h5">On Wed, Jan 17 2018 at=C2=A0 6:53pm =
-0500,<br>
Bart Van Assche &lt;<a href=3D"mailto:Bart.VanAssche@wdc.com">Bart.VanAssch=
e@wdc.com</a>&gt; wrote:<br>
<br>
&gt; On Wed, 2018-01-17 at 18:43 -0500, Laurence Oberman wrote:<br>
&gt; &gt; On Wed, 2018-01-17 at 23:31 +0000, Bart Van Assche wrote:<br>
&gt; &gt; &gt; On Wed, 2018-01-17 at 11:58 -0500, Mike Snitzer wrote:<br>
&gt; &gt; &gt; &gt; On Wed, Jan 17 2018 at 11:50am -0500,<br>
&gt; &gt; &gt; &gt; Jens Axboe &lt;<a href=3D"mailto:axboe@kernel.dk">axboe=
@kernel.dk</a>&gt; wrote:<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; On 1/17/18 9:25 AM, Mike Snitzer wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; Hi Jens,<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Think this finally takes care of it! ;)<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; &gt; &gt; &gt; Mike<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Mike Snitzer (2):<br>
&gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0blk-mq: factor out a few helpers =
from<br>
&gt; &gt; &gt; &gt; &gt; &gt; __blk_mq_try_issue_directly<br>
&gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0blk-mq-sched: remove unused &#39;=
can_block&#39; arg from<br>
&gt; &gt; &gt; &gt; &gt; &gt; blk_mq_sched_insert_request<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Ming Lei (1):<br>
&gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0blk-mq: improve DM&#39;s blk-mq I=
O merging via<br>
&gt; &gt; &gt; &gt; &gt; &gt; blk_insert_cloned_request feedback<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Applied - added actual commit message to patch 3.<=
br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Great, thanks.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Hello Mike,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Laurence hit the following while retesting the SRP initiator=
 code:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; [ 2223.797129] list_add corruption. prev-&gt;next should be =
next<br>
&gt; &gt; &gt; (00000000e0ddd5dd), but was 000000003defe5cd.<br>
&gt; &gt; &gt; (prev=3D000000003defe5cd).<br>
&gt; &gt; &gt; [ 2223.862168] WARNING: CPU: 14 PID: 577 at lib/list_debug.c=
:28<br>
&gt; &gt; &gt; __list_add_valid+0x6a/0x70<br>
&gt; &gt; &gt; [ 2224.481151] CPU: 14 PID: 577 Comm: kworker/14:1H Tainted:=
<br>
&gt; &gt; &gt; G=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 I=C2=A0 =C2=A0 =C2=A0 4.=
15.0-rc8.bart3+ #1<br>
&gt; &gt; &gt; [ 2224.531193] Hardware name: HP ProLiant DL380 G7, BIOS P67=
<br>
&gt; &gt; &gt; 08/16/2015<br>
&gt; &gt; &gt; [ 2224.567150] Workqueue: kblockd blk_mq_run_work_fn<br>
&gt; &gt; &gt; [ 2224.593182] RIP: 0010:__list_add_valid+0x6a/<wbr>0x70<br>
&gt; &gt; &gt; [ 2224.967002] Call Trace:<br>
&gt; &gt; &gt; [ 2224.980941]=C2=A0 blk_mq_request_bypass_insert+<wbr>0x57/=
0xa0<br>
&gt; &gt; &gt; [ 2225.009044]=C2=A0 __blk_mq_try_issue_directly+<wbr>0x56/0=
x1e0<br>
&gt; &gt; &gt; [ 2225.037007]=C2=A0 blk_mq_request_direct_issue+<wbr>0x5d/0=
xc0<br>
&gt; &gt; &gt; [ 2225.090608]=C2=A0 map_request+0x142/0x260 [dm_mod]<br>
&gt; &gt; &gt; [ 2225.114756]=C2=A0 dm_mq_queue_rq+0xa4/0x120 [dm_mod]<br>
&gt; &gt; &gt; [ 2225.140812]=C2=A0 blk_mq_dispatch_rq_list+0x90/<wbr>0x5b0=
<br>
&gt; &gt; &gt; [ 2225.211769]=C2=A0 blk_mq_sched_dispatch_<wbr>requests+0x1=
07/0x1a0<br>
&gt; &gt; &gt; [ 2225.240825]=C2=A0 __blk_mq_run_hw_queue+0x5f/<wbr>0xf0<br=
>
&gt; &gt; &gt; [ 2225.264852]=C2=A0 process_one_work+0x141/0x340<br>
&gt; &gt; &gt; [ 2225.287872]=C2=A0 worker_thread+0x47/0x3e0<br>
&gt; &gt; &gt; [ 2225.308354]=C2=A0 kthread+0xf5/0x130<br>
&gt; &gt; &gt; [ 2225.396405]=C2=A0 ret_from_fork+0x32/0x40<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; That call trace did not show up before this patch series was=
 added to<br>
&gt; &gt; &gt; Jens&#39;<br>
&gt; &gt; &gt; tree. This is a regression. Could this have been introduced =
by this<br>
&gt; &gt; &gt; patch<br>
&gt; &gt; &gt; series?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Bart.<br>
&gt; &gt;<br>
&gt; &gt; Hi Bart<br>
&gt; &gt; One thing to note.<br>
&gt; &gt;<br>
&gt; &gt; I tested Mike&#39;s combined tree on the weekend fully dm4.16-blo=
ck4.16 and<br>
&gt; &gt; did not see this.<br>
&gt; &gt; This was with Mike combined tree and SRPT running 4.13-rc2.<br>
&gt; &gt;<br>
&gt; &gt; I also tested your tree Monday with the revert of the scatter/gat=
her<br>
&gt; &gt; patches with both SRP and SRPT running your tree and it was fine.=
<br>
&gt; &gt;<br>
&gt; &gt; So its a combination of what you provided me before and that has =
been<br>
&gt; &gt; added to your tree.<br>
&gt; &gt;<br>
&gt; &gt; Mike combined tree seemed to be fine, I can revisit that if neede=
d. I<br>
&gt; &gt; still have that kernel in place.<br>
&gt; &gt;<br>
&gt; &gt; I was not running latest SRPT when I tested Mike&#39;s tree<br>
&gt;<br>
&gt; Hello Laurence,<br>
&gt;<br>
&gt; The tree I sent you this morning did not only include Mike&#39;s lates=
t dm code<br>
&gt; but also Jens&#39; latest for-next branch. So what you wrote above doe=
s not<br>
&gt; contradict what I wrote in my e-mail, namely that I suspect that a reg=
ression<br>
&gt; was introduced by the patches in the series &quot;blk-mq: improve DM&#=
39;s blk-mq IO<br>
&gt; merging via blk_insert_cloned_request feedback&quot;. These changes na=
mely went in<br>
&gt; through the block tree and not through the dm tree. Additionally, thes=
e<br>
&gt; changes were not present in the block-scsi-for-next branch I sent you =
on<br>
&gt; Monday.<br>
<br>
</div></div>Functionality shouldn&#39;t be any different than the variant (=
Ming&#39;s v4)<br>
that Laurence tested on Sunday/Monday (once we got past the genirq issue<br=
>
on HPSA).<br>
<br>
But sure, I suppose there is something I missed when refactoring Ming&#39;s=
<br>
change to get it acceptable for upstream.=C2=A0 I went over the mechanical<=
br>
nature of what I did many times (comaping Ming&#39;s v4 to my v5).<br>
<br>
Anyway, we&#39;ll see how Laurence fairs with this tree (but with the rever=
t<br>
of 84676c1 added, so his HPSA server will boot):<br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.gi=
t/log/?h=3Dblock-4.16_dm-4.16" rel=3D"noreferrer" target=3D"_blank">https:/=
/git.kernel.org/pub/<wbr>scm/linux/kernel/git/snitzer/<wbr>linux.git/log/?h=
=3Dblock-4.16_<wbr>dm-4.16</a><br>
(which is the same as linux-dm.git&#39;s &#39;for-next&#39; at the moment)<=
br>
<br>
The call to blk_mq_request_bypass_insert will only occur via<br>
__blk_mq_fallback_to_insert.=C2=A0 Which as the name implies this is not th=
e<br>
fast path.=C2=A0 This will occur if the underlying blk-mq device cannot get=
<br>
resources it needs in order to issue the request.=C2=A0 Specifically: if/wh=
en<br>
in __blk_mq_try_issue_directly() the hctx is stopped, or queue is<br>
quiesced, or it cannot get the driver tag or dispatch_budget (in the<br>
case of scsi-mq).<br>
<br>
The same fallback, via call to blk_mq_request_bypass_insert, occured<br>
with Ming&#39;s v4 though.<br>
<br>
Anyway, we&#39;ll see what Laurence finds when testing my above kernel.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Mike<br>
</font></span></blockquote></div><br></div>

--94eb2c058080d79aed056302b92d--


--===============0184276390856737217==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0184276390856737217==--
