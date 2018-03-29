From: E V <eliventer@gmail.com>
Subject: Soft lockups using dm_snapshot
Date: Thu, 29 Mar 2018 10:45:32 -0400
Message-ID: <CAJtFHUSmYAVoadFVeXYXV9LiK629nfeMLyU2WmT+LCwdHA7u_A@mail.gmail.com>
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

Just testing out using dm_snapshot for postgresql backups and am
seeing softlockups causing the system to go haywire i.e. network
interfaces dropping, disks getting kicked out of arrays etc. I assume
this is expected to work, so let me know if that option is incorrect.
Happy to test out any suggestions

System is a Dell R630 with a pair of E5-2643 cpu's and 512GB of RAM
and a couple of disk arrays hooked up to an LSI 3008 based HBA:
mpt3sas_cm0: LSISAS3008: FWVersion(13.00.00.00), ChipRevision(0x02),
BiosVersion(15.00.02.00)

Postgresql 9.6 database running on the system is a streaming replica
of our primary db, about 3TB in size on an 10TB ext4 lv. Lightly
loaded, other then keeping up with the primary.

Problem first observed with a 4.9 kernel, so I upgraded to 4.14.31 and
still get the soft lockups.

Process to create soft lockups is lvcreate -l1186994 -s -n pg_snap
dbv/db, mount /dev/dbv/pg_snap /mnt/tmp, remove postgresql
recovery.conf and postmaster.* files then start up a postgresql 9.6
instance on it, then run pg_dump. Should take about 1 hour for the
pg_dump. Runs ok, for a while then soft lockups start and things start
getting bad i.e nic timeout, multipath fails disks, all IO to the md
devices freezes. Most recent attempt after upgarding to linux 4.14.31
started with the nic freezing:

[ 3289.790185] NETDEV WATCHDOG: eno1 (i40e): transmit queue 2 timed out
[ 3289.790255] ------------[ cut here ]------------
[ 3289.790294] WARNING: CPU: 10 PID: 0 at net/sched/sch_generic.c:320
dev_watchdog+0x1ef/0x200
[ 3289.790347] Modules linked in: dm_snapshot dm_bufio nfsv3 nfs_acl
nfs lockd grace fscache bonding ext2 mgag200 drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm iTCO_wdt sb_edac
iTCO_vendor_support drm x86_pkg_temp_thermal intel_powerclamp coretemp
crct10dif_pclmul crc32_pclmul ghash_clmulni_inte
l aesni_intel aes_x86_64 dcdbas crypto_simd cryptd glue_helper pcspkr
evdev mei_me mei lpc_ich mfd_core ipmi_si acpi_power_meter
ipmi_devintf ipmi_msghandler button dm_service_time ses enclosure sg
dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc autofs4 ext4
crc16 mbcache jbd2 hid_generic usbhid hid raid
10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx
xor raid6_pq libcrc32c crc32c_generic raid1 raid0 linear md_mod sd_mod
crc32c_intel mpt3sas raid_class scsi_transport_sas
[ 3289.790832]  igb ehci_pci megaraid_sas i2c_algo_bit ehci_hcd i40e
i2c_core ptp usbcore scsi_mod pps_core usb_common
[ 3289.790912] CPU: 10 PID: 0 Comm: swapper/10 Not tainted 4.14.31 #2
[ 3289.790953] Hardware name: Dell Inc. PowerEdge R630, BIOS 2.4.3 01/17/2017
[ 3289.791001] task: ffff88407932f040 task.stack: ffffc90000154000
[ 3289.791043] RIP: 0010:dev_watchdog+0x1ef/0x200
[ 3289.791073] RSP: 0000:ffff88407fd43e98 EFLAGS: 00010292
[ 3289.791109] RAX: 0000000000000038 RBX: 0000000000000002 RCX: 0000000000000000
[ 3289.791155] RDX: 0000000000040400 RSI: 00000000000000f6 RDI: 0000000000000300
[ 3289.791200] RBP: ffff884078c80000 R08: 0000000000000000 R09: 0000000000000943
[ 3289.791246] R10: ffff88407fd597f0 R11: ffff882f2532f1d0 R12: 0000000000000040
[ 3289.791292] R13: 000000000000000a R14: ffff884078c80000 R15: 0000000000000001
[ 3289.791338] FS:  0000000000000000(0000) GS:ffff88407fd40000(0000)
knlGS:0000000000000000
[ 3289.791389] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3289.791427] CR2: 0000564bc58a31f0 CR3: 0000000001c09004 CR4: 00000000001606e0
[ 3289.791472] Call Trace:
[ 3289.791493]  <IRQ>
[ 3289.791513]  ? qdisc_rcu_free+0x40/0x40
[ 3289.791542]  call_timer_fn+0x29/0x120
[ 3289.791569]  run_timer_softirq+0x1b2/0x3c0
[ 3289.791600]  ? tick_sched_handle+0x1e/0x50
[ 3289.791630]  ? tick_sched_timer+0x2f/0x70
[ 3289.791660]  __do_softirq+0xfa/0x282
[ 3289.791689]  irq_exit+0xa3/0xb0
[ 3289.791713]  smp_apic_timer_interrupt+0x5f/0x110
[ 3289.791746]  apic_timer_interrupt+0x7a/0x80
[ 3289.791775]  </IRQ>
[ 3289.791795] RIP: 0010:cpuidle_enter_state+0x9a/0x2b0
[ 3289.791829] RSP: 0000:ffffc90000157ed0 EFLAGS: 00000206 ORIG_RAX:
ffffffffffffff10
[ 3289.791878] RAX: ffff88407fd5fec0 RBX: 0000000000799e42 RCX: 000000000000001f
[ 3289.791924] RDX: 000002fdf6c5f836 RSI: ffc39f3e14da3709 RDI: 0000000000000000
[ 3289.791970] RBP: ffffe8bfffd48250 R08: 0000000000001ea4 R09: 0000000000000018
[ 3289.792015] R10: 0000000000001915 R11: 0000000000001ea4 R12: 0000000000000004
[ 3289.792061] R13: 0000000000000004 R14: 0000000000000004 R15: 000002fdf64c59f4
[ 3289.792110]  do_idle+0x170/0x1b0
[ 3289.792136]  cpu_startup_entry+0x14/0x20
[ 3289.792164]  secondary_startup_64+0xa5/0xb0
[ 3289.792194] Code: 63 8d 20 04 00 00 eb 96 48 89 ef c6 05 2a 5e 83
00 01 e8 55 cb fd ff 89 d9 48 89 c2 48 89 ee 48 c7 c7 30 b0 b8 81 e8
37 94 c2 ff <0f> 0b eb c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 48 c7
47 08
[ 3289.792348] ---[ end trace d5425cc794e169eb ]---
[ 3289.792389] i40e 0000:01:00.0 eno1: tx_timeout: VSI_seid: 391, Q 2,
NTC: 0x198, HWB: 0x1f8, NTU: 0x1f8, TAIL: 0x1f8, INT: 0x0
[ 3289.792468] i40e 0000:01:00.0 eno1: tx_timeout recovery level 1, hung_queue 2
[ 3289.794177] bond0: link status down for interface eno1, disabling
it in 200 ms
...

then a few minutes later:

[ 4476.191684] watchdog: BUG: soft lockup - CPU#10 stuck for 22s!
[kworker/10:21:6604]
[ 4476.191907] Modules linked in: dm_snapshot dm_bufio nfsv3 nfs_acl
nfs lockd grace fscache bonding ext2 mgag200 drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm iTCO_wdt sb_edac
iTCO_vendor_support drm x86_pkg_temp_thermal intel_powerclamp coretemp
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 dcdbas crypto_simd cryptd glue_helper pcspkr evdev mei_me
mei lpc_ich mfd_core ipmi_si acpi_power_meter ipmi_devintf
ipmi_msghandler button dm_service_time ses enclosure sg dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc autofs4 ext4 crc16
mbcache jbd2 hid_generic usbhid hid raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c
crc32c_generic raid1 raid0 linear md_mod sd_mod crc32c_intel mpt3sas
raid_class scsi_transport_sas
[ 4476.193213]  igb ehci_pci megaraid_sas i2c_algo_bit ehci_hcd i40e
i2c_core ptp usbcore scsi_mod pps_core usb_common
[ 4476.193503] CPU: 10 PID: 6604 Comm: kworker/10:21 Tainted: G
W       4.14.31 #2
[ 4476.193798] Hardware name: Dell Inc. PowerEdge R630, BIOS 2.4.3 01/17/2017
[ 4476.194105] Workqueue: kcopyd do_work
[ 4476.194414] task: ffff882f247c2100 task.stack: ffffc9000d700000
[ 4476.194737] RIP: 0010:copy_callback+0x36/0x130 [dm_snapshot]
[ 4476.195064] RSP: 0018:ffffc9000d703d68 EFLAGS: 00000283 ORIG_RAX:
ffffffffffffff10
[ 4476.195403] RAX: ffff882dd1b406e8 RBX: ffff882f2871b000 RCX: ffff882f2871b070
[ 4476.195766] RDX: ffff882e51353c30 RSI: 0000000000000000 RDI: 0000000000a96f39
[ 4476.196139] RBP: ffff88407381c840 R08: ffff882e3ed530b8 R09: 00000000ffffffd6
[ 4476.196503] R10: 0000000000000000 R11: ffffffffffffffd8 R12: ffffffffa059e020
[ 4476.196875] R13: 0000000000000000 R14: 0000000000000000 R15: ffff882e51353c30
[ 4476.197253] FS:  0000000000000000(0000) GS:ffff88407fd40000(0000)
knlGS:0000000000000000
[ 4476.197641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4476.198035] CR2: 00000000020c7f08 CR3: 0000000001c09002 CR4: 00000000001606e0
[ 4476.198441] Call Trace:
[ 4476.198851]  ? dm_snap_cow+0x10/0x10 [dm_snapshot]
[ 4476.199270]  run_complete_job+0x58/0x90
[ 4476.199704]  ? drop_pages+0x30/0x30
[ 4476.200146]  process_jobs+0x79/0x1c0
[ 4476.200573]  do_work+0x3d/0x80
[ 4476.201005]  ? process_one_work+0x1c0/0x3a0
[ 4476.201442]  process_one_work+0x1c0/0x3a0
[ 4476.201884]  worker_thread+0x23c/0x3e0
[ 4476.202330]  kthread+0xf7/0x130
[ 4476.202778]  ? create_worker+0x170/0x170
[ 4476.203233]  ? kthread_create_on_node+0x40/0x40
[ 4476.203704]  ret_from_fork+0x1f/0x30
[ 4476.204185] Code: f6 55 0f 95 c1 53 48 8b 5a 40 09 c8 48 8b 7a 50
0f b6 c0 89 42 4c 48 3b 7b 68 74 3e 48 8b 43 78 48 8d 4b 70 48 39 c8
75 0b eb 12 <48> 8b 40 08 48 39 c8 74 09 48 3b 78 f8 76 f1 48 89 c1 48
8b 31
[ 4504.190854] watchdog: BUG: soft lockup - CPU#10 stuck for 22s!
[kworker/10:21:6604]
[ 4504.191496] Modules linked in: dm_snapshot dm_bufio nfsv3 nfs_acl
nfs lockd grace fscache bonding ext2 mgag200 drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm iTCO_wdt sb_edac
iTCO_vendor_support drm x86_pkg_temp_thermal intel_powerclamp coretemp
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 dcdbas crypto_simd cryptd glue_helper pcspkr evdev mei_me
mei lpc_ich mfd_core ipmi_si acpi_power_meter ipmi_devintf
ipmi_msghandler button dm_service_time ses enclosure sg dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc autofs4 ext4 crc16
mbcache jbd2 hid_generic usbhid hid raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c
crc32c_generic raid1 raid0 linear md_mod sd_mod crc32c_intel mpt3sas
raid_class scsi_transport_sas
[ 4504.195263]  igb ehci_pci megaraid_sas i2c_algo_bit ehci_hcd i40e
i2c_core ptp usbcore scsi_mod pps_core usb_common
[ 4504.195961] CPU: 10 PID: 6604 Comm: kworker/10:21 Tainted: G
W    L  4.14.31 #2
[ 4504.196664] Hardware name: Dell Inc. PowerEdge R630, BIOS 2.4.3 01/17/2017
[ 4504.197380] Workqueue: kcopyd do_work
[ 4504.198097] task: ffff882f247c2100 task.stack: ffffc9000d700000
[ 4504.198828] RIP: 0010:copy_callback+0x36/0x130 [dm_snapshot]
[ 4504.199593] RSP: 0018:ffffc9000d703d68 EFLAGS: 00000287 ORIG_RAX:
ffffffffffffff10
[ 4504.200343] RAX: ffff886e8ffdf940 RBX: ffff882f2871b000 RCX: ffff882f2871b070
[ 4504.201103] RDX: ffff886e9bbc7e88 RSI: 0000000000000000 RDI: 0000000000b0ae8c
[ 4504.201869] RBP: ffff88407381c840 R08: ffff886ec60aef38 R09: 00000000ffffffaa
[ 4504.202643] R10: 0000000000000000 R11: ffffffffffffffac R12: ffffffffa059e020
[ 4504.203451] R13: 0000000000000000 R14: 0000000000000000 R15: ffff886e9bbc7e88
[ 4504.204240] FS:  0000000000000000(0000) GS:ffff88407fd40000(0000)
knlGS:0000000000000000
[ 4504.205037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4504.205840] CR2: 00000000020c7f08 CR3: 0000000001c09002 CR4: 00000000001606e0
[ 4504.206655] Call Trace:
[ 4504.207501]  ? dm_snap_cow+0x10/0x10 [dm_snapshot]
[ 4504.208326]  run_complete_job+0x58/0x90
[ 4504.209157]  ? drop_pages+0x30/0x30
[ 4504.209979]  process_jobs+0x79/0x1c0
[ 4504.210791]  do_work+0x3d/0x80
[ 4504.211611]  ? process_one_work+0x1c0/0x3a0
[ 4504.212385]  process_one_work+0x1c0/0x3a0
[ 4504.213140]  worker_thread+0x23c/0x3e0
[ 4504.213875]  kthread+0xf7/0x130
[ 4504.214588]  ? create_worker+0x170/0x170
[ 4504.215311]  ? kthread_create_on_node+0x40/0x40
[ 4504.215995]  ret_from_fork+0x1f/0x30
[ 4504.216667] Code: f6 55 0f 95 c1 53 48 8b 5a 40 09 c8 48 8b 7a 50
0f b6 c0 89 42 4c 48 3b 7b 68 74 3e 48 8b 43 78 48 8d 4b 70 48 39 c8
75 0b eb 12 <48> 8b 40 08 48 39 c8 74 09 48 3b 78 f8 76 f1 48 89 c1 48
8b 31
[ 4514.766557] INFO: rcu_sched self-detected stall on CPU
[ 4514.767380]  10-...: (1 GPs behind) idle=232/140000000000001/0
softirq=107692/107693 fqs=7493
[ 4514.768092]   (t=15000 jiffies g=158702 c=158701 q=4674)
[ 4514.768798] NMI backtrace for cpu 10
[ 4514.769496] CPU: 10 PID: 6604 Comm: kworker/10:21 Tainted: G
W    L  4.14.31 #2
[ 4514.770203] Hardware name: Dell Inc. PowerEdge R630, BIOS 2.4.3 01/17/2017
[ 4514.770945] Workqueue: kcopyd do_work
[ 4514.771652] Call Trace:
[ 4514.772355]  <IRQ>
[ 4514.773050]  dump_stack+0x46/0x5a
[ 4514.773740]  nmi_cpu_backtrace+0xb3/0xc0
[ 4514.774428]  ? irq_force_complete_move+0x130/0x130
[ 4514.775138]  nmi_trigger_cpumask_backtrace+0xf4/0x120
[ 4514.775823]  rcu_dump_cpu_stacks+0x99/0xd5
[ 4514.776506]  rcu_check_callbacks+0x7ad/0x900
[ 4514.777189]  ? update_wall_time+0x436/0x6f0
[ 4514.777873]  ? tick_sched_do_timer+0x40/0x40
[ 4514.778558]  update_process_times+0x23/0x50
[ 4514.779270]  tick_sched_handle+0x1e/0x50
[ 4514.779954]  tick_sched_timer+0x2f/0x70
[ 4514.780636]  __hrtimer_run_queues+0xc1/0x1f0
[ 4514.781322]  hrtimer_interrupt+0xa1/0x1e0
[ 4514.782007]  smp_apic_timer_interrupt+0x55/0x110
[ 4514.782709]  apic_timer_interrupt+0x7a/0x80
[ 4514.783406]  </IRQ>
[ 4514.784074] RIP: 0010:copy_callback+0x36/0x130 [dm_snapshot]
[ 4514.784732] RSP: 0018:ffffc9000d703d68 EFLAGS: 00000287 ORIG_RAX:
ffffffffffffff10
[ 4514.785392] RAX: ffff8856109f2ee0 RBX: ffff882f2871b000 RCX: ffff882f2871b070
[ 4514.786039] RDX: ffff8862df4e2ac8 RSI: 0000000000000000 RDI: 0000000000b2936c
[ 4514.786681] RBP: ffff88407381c840 R08: ffff8862df53e3c8 R09: 00000000ffffffd8
[ 4514.787307] R10: 0000000000000000 R11: ffffffffffffffda R12: ffffffffa059e020
[ 4514.787902] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8862df4e2ac8
[ 4514.788481]  ? dm_snap_cow+0x10/0x10 [dm_snapshot]
[ 4514.789042]  ? dm_snap_cow+0x10/0x10 [dm_snapshot]
[ 4514.789584]  run_complete_job+0x58/0x90
[ 4514.790115]  ? drop_pages+0x30/0x30
[ 4514.790650]  process_jobs+0x79/0x1c0
[ 4514.791180]  do_work+0x3d/0x80
[ 4514.791690]  ? process_one_work+0x1c0/0x3a0
[ 4514.792197]  process_one_work+0x1c0/0x3a0
[ 4514.792697]  worker_thread+0x23c/0x3e0
[ 4514.793193]  kthread+0xf7/0x130
[ 4514.793683]  ? create_worker+0x170/0x170
[ 4514.794172]  ? kthread_create_on_node+0x40/0x40
[ 4514.794671]  ret_from_fork+0x1f/0x30
[ 4564.189280] watchdog: BUG: soft lockup - CPU#10 stuck for 22s!
[kworker/10:21:6604]
[ 4564.189910] Modules linked in: dm_snapshot dm_bufio nfsv3 nfs_acl
nfs lockd grace fscache bonding ext2 mgag200 drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm iTCO_wdt sb_edac
iTCO_vendor_support drm x86_pkg_temp_thermal intel_powerclamp coretemp
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 dcdbas crypto_simd cryptd glue_helper pcspkr evdev mei_me
mei lpc_ich mfd_core ipmi_si acpi_power_meter ipmi_devintf
ipmi_msghandler button dm_service_time ses enclosure sg dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc autofs4 ext4 crc16
mbcache jbd2 hid_generic usbhid hid raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c
crc32c_generic raid1 raid0 linear md_mod sd_mod crc32c_intel mpt3sas
raid_class scsi_transport_sas
[ 4564.193285]  igb ehci_pci megaraid_sas i2c_algo_bit ehci_hcd i40e
i2c_core ptp usbcore scsi_mod pps_core usb_common
[ 4564.193932] CPU: 10 PID: 6604 Comm: kworker/10:21 Tainted: G
W    L  4.14.31 #2
[ 4564.194554] Hardware name: Dell Inc. PowerEdge R630, BIOS 2.4.3 01/17/2017
[ 4564.195183] Workqueue: kcopyd do_work
[ 4564.195809] task: ffff882f247c2100 task.stack: ffffc9000d700000
[ 4564.196446] RIP: 0010:copy_callback+0x36/0x130 [dm_snapshot]
[ 4564.197083] RSP: 0000:ffffc9000d703d68 EFLAGS: 00000283 ORIG_RAX:
ffffffffffffff10
[ 4564.197758] RAX: ffff8862c7013f58 RBX: ffff882f2871b000 RCX: ffff882f2871b070
[ 4564.198410] RDX: ffff8862d3d851e0 RSI: 0000000000000000 RDI: 0000000000b7ea1b
[ 4564.199062] RBP: ffff88407381c840 R08: 00000000062c2ca8 R09: 00000000ffffffb2
[ 4564.199700] R10: 0000000000000000 R11: ffffffffffffffb4 R12: ffffffffa059e020
[ 4564.200326] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8862d3d851e0
[ 4564.200949] FS:  0000000000000000(0000) GS:ffff88407fd40000(0000)
knlGS:0000000000000000
[ 4564.201598] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4564.202212] CR2: 00000000020c7f08 CR3: 0000000001c09002 CR4: 00000000001606e0
[ 4564.202830] Call Trace:
[ 4564.203444]  ? dm_snap_cow+0x10/0x10 [dm_snapshot]
[ 4564.204056]  run_complete_job+0x58/0x90
[ 4564.204662]  ? drop_pages+0x30/0x30
[ 4564.205265]  process_jobs+0x79/0x1c0
[ 4564.205898]  do_work+0x3d/0x80
[ 4564.206502]  ? process_one_work+0x1c0/0x3a0
[ 4564.207108]  process_one_work+0x1c0/0x3a0
[ 4564.207714]  worker_thread+0x23c/0x3e0
[ 4564.208318]  kthread+0xf7/0x130
[ 4564.208917]  ? create_worker+0x170/0x170
[ 4564.209536]  ? kthread_create_on_node+0x40/0x40
[ 4564.210150]  ret_from_fork+0x1f/0x30
[ 4564.210752] Code: f6 55 0f 95 c1 53 48 8b 5a 40 09 c8 48 8b 7a 50
0f b6 c0 89 42 4c 48 3b 7b 68 74 3e 48 8b 43 78 48 8d 4b 70 48 39 c8
75 0b eb 12 <48> 8b 40 08 48 39 c8 74 09 48 3b 78 f8 76 f1 48 89 c1 48
8b 31

at which point I killed the pg_dump as the system was becoming
increasingly unresponsive. Previous runs using 4.9 kernel ended up
with multipath freezing and kicking out half of the disks from the
arrays, so didn't wait to see how bad it would get. Main data for
postgresql in on md0, with the snapshot created on md1. sar during
this timeframe and some sysinfo below:

$ sar -s 09:15:00 -e 09:45:00
Linux 4.9.0-6-amd64 (gdx-pg2)   03/29/2018      _x86_64_        (12 CPU)

09:15:01 AM     CPU     %user     %nice   %system   %iowait    %steal     %idle
09:20:01 AM     all     11.74      0.00      3.28      5.06      0.00     79.92
09:25:01 AM     all     13.39      0.00      3.18      4.06      0.00     79.37
09:30:01 AM     all     14.09      0.00      1.61      0.25      0.00     84.06
09:35:01 AM     all     11.41      0.00      5.50      5.74      0.00     77.35
09:40:01 AM     all     12.22      0.01      2.48      1.43      0.00     83.87
Average:        all     12.57      0.00      3.21      3.31      0.00     80.91

$ sar -s 09:15:00 -e 09:45:00 -n DEV | egrep 'bond|eno1|eno2'
09:20:01 AM      eno1   8003.92  14693.49    759.35  21476.04
0.00      0.00      0.01      1.76
09:20:01 AM      eno2      7.39      1.94      3.58      0.74
0.00      0.00      0.01      0.00
09:20:01 AM     bond0   8011.31  14695.42    762.92  21476.78
0.00      0.00      0.02      0.88
09:25:01 AM      eno1   3782.42      0.00    321.34      0.00
0.00      0.00      0.00      0.03
09:25:01 AM      eno2      7.71   7353.11      3.61  10825.06
0.00      0.00      0.00      0.89
09:25:01 AM     bond0   7420.76  14437.33    585.07  21221.48
0.00      0.00      0.01      0.87
09:30:01 AM      eno1   6047.23      0.00    568.65      0.00
0.00      0.00      0.01      0.05
09:30:01 AM      eno2      7.36  11660.18      3.58  17160.95
0.00      0.00      0.00      1.41
09:30:01 AM     bond0   6054.58  11660.18    572.23  17160.95
0.00      0.00      0.01      0.70
09:35:01 AM      eno1   5759.93      0.00    540.85      0.00
0.00      0.00      0.01      0.04
09:35:01 AM      eno2      7.24  11091.32      3.55  16327.91
0.00      0.00      0.00      1.34
09:35:01 AM     bond0   5767.17  11091.32    544.40  16327.91
0.00      0.00      0.01      0.67
09:40:01 AM      eno1   5994.88      0.00    578.59      0.00
0.00      0.00      0.01      0.05
09:40:01 AM      eno2      7.64  11521.07      3.61  16954.99
0.00      0.00      0.00      1.39
09:40:01 AM     bond0   6002.52  11521.07    582.20  16954.99
0.00      0.00      0.01      0.69
Average:         eno1   4316.77      0.00    401.87      0.00
0.00      0.00      0.01      0.03
Average:         eno2      7.47   8325.28      3.59  12253.57
0.00      0.00      0.00      1.00
Average:        bond0   6651.31  12681.13    609.37  18628.51
0.00      0.00      0.01      0.76

$ sar -s 09:15:00 -e 09:45:00 -dp | grep md
Linux 4.9.0-6-amd64 (gdx-pg2)   03/29/2018      _x86_64_        (12 CPU)
09:20:01 AM       md0  26937.95 212532.64   2946.80      8.00
0.00      0.00      0.00      0.00
09:20:01 AM       md1   3436.95      0.05  27321.44      7.95
0.00      0.00      0.00      0.00
09:25:01 AM       md0  31396.17 250629.37    523.86      8.00
0.00      0.00      0.00      0.00
09:25:01 AM       md1   3843.03      1.12  30592.47      7.96
0.00      0.00      0.00      0.00
09:30:01 AM       md0  30887.87 246694.62    401.68      8.00
0.00      0.00      0.00      0.00
09:30:01 AM       md1     52.86      0.00    404.69      7.66
0.00      0.00      0.00      0.00
09:35:01 AM       md0  24449.67 194993.71    595.69      8.00
0.00      0.00      0.00      0.00
09:35:01 AM       md1   8361.06      2.03  66610.42      7.97
0.00      0.00      0.00      0.00
09:40:01 AM       md0  21642.72 172515.67    615.77      8.00
0.00      0.00      0.00      0.00
09:40:01 AM       md1   2737.49      0.00  21793.19      7.96
0.00      0.00      0.00      0.00
Average:          md0  27062.89 215473.26   1016.81      8.00
0.00      0.00      0.00      0.00
Average:          md1   3686.24      0.64  29344.14      7.96
0.00      0.00      0.00      0.00


$ vgs dbv
  VG  #PV #LV #SN Attr   VSize  VFree
  dbv   2   1   0 wz--n- 15.01t 4.53t

$ lvs dbv/db
  LV   VG  Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  db   dbv -wi-ao---- 10.48t

$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid10 dm-52[23](S) dm-51[10] dm-50[22](S) dm-48[4]
dm-49[7] dm-47[17] dm-46[12] dm-45[9] dm-43[14] dm-44[2] dm-40[1]
dm-41[11] dm-42[5] dm-31[13] dm-29[16] dm-36[6] dm-28[21] dm-32[20]
dm-38[0] dm-39[8] dm-33[19] dm-34[18] dm-35[3] dm-30[15]
      9668519168 blocks super 1.2 256K chunks 2 near-copies [22/22]
[UUUUUUUUUUUUUUUUUUUUUU]
      bitmap: 0/73 pages [0KB], 65536KB chunk

md0 : active raid10 dm-37[8] dm-27[2](S) dm-25[15] dm-26[16] dm-23[11]
dm-24[13] dm-21[7] dm-19[14] dm-22[0](S) dm-18[19] dm-20[5] dm-15[3]
dm-17[1] dm-16[22] dm-14[10] dm-7[9] dm-10[23] dm-11[4] dm-13[17]
dm-12[6] dm-8[20] dm-5[24] dm-9[21] dm-6[18]
      6445235456 blocks super 1.2 256K chunks 2 near-copies [22/22]
[UUUUUUUUUUUUUUUUUUUUUU]
      bitmap: 14/49 pages [56KB], 65536KB chunk
