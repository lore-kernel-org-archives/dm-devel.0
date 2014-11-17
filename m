From: Leonardo Santos <heiligerstein@gmail.com>
Subject: dmcache RAID1 bug?
Date: Mon, 17 Nov 2014 12:24:23 -0200
Message-ID: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5507507147964933178=="
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

--===============5507507147964933178==
Content-Type: multipart/alternative; boundary=001a11c35626396b9105080ebc08

--001a11c35626396b9105080ebc08
Content-Type: text/plain; charset=UTF-8

I'm working in tests for my msc thesis envolving dm_cache module. I'm
having problems with the following scenario:

Slowstorage: RAID1 (mdadm) with 4 HDDs;
- /dev/md/raid1_4ssds
-- /dev/sda
-- /dev/sdb
-- /dev/sdc
-- /dev/sdd

Faststorage: RAID1 (mdadm) with 4 SSDs
- /dev/md/raid1_4hdds
-- /dev/sde
-- /dev/sdf
-- /dev/sdg
-- /dev/sdh

Cachestorage: dm_cache envolving both devices
- /dev/mapper/dmcache
-- /dev/md/raid1_4ssds
-- /dev/md/raid1_4hdds

Other informations (strange facts):
In RAID0 it's working very well.
In a virtual machine (vbox) it's working as well (in this case disks have
2GB only for big tests automatization, in production are 160GB SSDs and 2TB
HDDs);

Have you seen about this error? Syslog is bellow.

Thanks!
Leonardo Santos


Nov 14 17:05:36 steinhager mdadm[2412]: NewArray event detected on md
device /dev/md/raid1_4ssds
Nov 14 17:05:36 steinhager kernel: [22995.480318] md/raid1:md126: active
with 4 out of 4 mirrors
Nov 14 17:05:36 steinhager kernel: [22995.480367] md126: detected capacity
change from 0 to 2197865431040
Nov 14 17:05:36 steinhager kernel: [22995.491499]  md126: unknown partition
table
Nov 14 17:05:39 steinhager kernel: [22999.008757] device-mapper:
cache-policy-mq: version 1.2.0 loaded
Nov 14 17:05:40 steinhager kernel: [22999.086449] BUG: unable to handle
kernel paging request at 0000000ffcc35800
Nov 14 17:05:40 steinhager kernel: [22999.086486] IP: [<ffffffffa03c102e>]
bio_list_pop+0x8/0x23 [dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.086518] PGD 0
Nov 14 17:05:40 steinhager kernel: [22999.086531] Oops: 0000 [#1] SMP
Nov 14 17:05:40 steinhager kernel: [22999.086553] Modules linked in:
dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_bufio libcrc32c
raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx
raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd_pcm iTCO_wdt
snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vendor_support
ipmi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_raw
microcode ipmi_msghandler ehci_pci button acpi_cpufreq processor
thermal_sys ext4 crc16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod
crc_t10dif crct10dif_common crc32c_intel uhci_hcd firewire_ohci ehci_hcd
ata_generic ahci firewire_core libahci pata_jmicron crc_itu_t usbcore
libata usb_common megaraid_sas igb i2c_algo_bit i2c_core dca ptp pps_core
scsi_mod [last unloaded: dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.086972] CPU: 4 PID: 6 Comm:
kworker/u48:0 Not tainted 3.17.2 #2
Nov 14 17:05:40 steinhager kernel: [22999.086996] Hardware name: SGI.COM
C3108-TY11/X8DAH, BIOS 1.1     03/16/2011
Nov 14 17:05:40 steinhager kernel: [22999.087024] Workqueue: dm-cache
do_worker [dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.087045] task: ffff8801b90ec050
ti: ffff8801b90fc000 task.ti: ffff8801b90fc000
Nov 14 17:05:40 steinhager kernel: [22999.087072] RIP:
0010:[<ffffffffa03c102e>]  [<ffffffffa03c102e>] bio_list_pop+0x8/0x23
[dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.087132] RSP:
0018:ffff8801b90ffdb0  EFLAGS: 00010206
Nov 14 17:05:40 steinhager kernel: [22999.087176] RAX: 0000000ffcc35800
RBX: ffff880338e5bd48 RCX: 0000000000000008
Nov 14 17:05:40 steinhager kernel: [22999.087226] RDX: 0000000000000000
RSI: ffff88032c1b3400 RDI: ffff8801b90ffde8
Nov 14 17:05:40 steinhager kernel: [22999.087276] RBP: ffff880338e5bc00
R08: ffff8801b90fc000 R09: 0000000000000000
Nov 14 17:05:40 steinhager kernel: [22999.087325] R10: 000000000000b951
R11: 0000000000000005 R12: ffff8801b90ffe00
Nov 14 17:05:40 steinhager kernel: [22999.087375] R13: ffff8801b90ffde8
R14: ffff880338e5bc5c R15: 0000000000000246
Nov 14 17:05:40 steinhager kernel: [22999.087425] FS:
 0000000000000000(0000) GS:ffff88033fc00000(0000) knlGS:0000000000000000
Nov 14 17:05:40 steinhager kernel: [22999.087502] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Nov 14 17:05:40 steinhager kernel: [22999.087547] CR2: 0000000ffcc35800
CR3: 0000000001611000 CR4: 00000000000007e0
Nov 14 17:05:40 steinhager kernel: [22999.087597] Stack:
Nov 14 17:05:40 steinhager kernel: [22999.087630]  ffffffffa03c4095
ffff880338e5bc60 ffff8801b90ec050 0000000000000000
Nov 14 17:05:40 steinhager kernel: [22999.087713]  ffff88033fc131f0
ffffffff810016b0 ffff8801b90ec568 0000000ffcc35800
Nov 14 17:05:40 steinhager kernel: [22999.087796]  0000000ee6ea5800
ffff880331a323c0 ffff880331a31470 ffff880331a32400
Nov 14 17:05:40 steinhager kernel: [22999.087879] Call Trace:
Nov 14 17:05:40 steinhager kernel: [22999.087917]  [<ffffffffa03c4095>] ?
do_worker+0x29f/0x649 [dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.087968]  [<ffffffff810016b0>] ?
__switch_to+0x22d/0x45a
Nov 14 17:05:40 steinhager kernel: [22999.088016]  [<ffffffff8104dfb5>] ?
process_one_work+0x158/0x27b
Nov 14 17:05:40 steinhager kernel: [22999.088063]  [<ffffffff8104e765>] ?
worker_thread+0x1ea/0x294
Nov 14 17:05:40 steinhager kernel: [22999.088109]  [<ffffffff8104e57b>] ?
rescuer_thread+0x217/0x217
Nov 14 17:05:40 steinhager kernel: [22999.088157]  [<ffffffff81051db6>] ?
kthread+0xa7/0xaf
Nov 14 17:05:40 steinhager kernel: [22999.088201]  [<ffffffff81051d0f>] ?
__kthread_parkme+0x5b/0x5b
Nov 14 17:05:40 steinhager kernel: [22999.088251]  [<ffffffff81397d2c>] ?
ret_from_fork+0x7c/0xb0
Nov 14 17:05:40 steinhager kernel: [22999.088296]  [<ffffffff81051d0f>] ?
__kthread_parkme+0x5b/0x5b
Nov 14 17:05:40 steinhager kernel: [22999.088342] Code: c3 48 8b 06 48 85
c0 74 19 48 8b 57 08 48 85 d2 74 05 48 89 02 eb 03 48 89 07 48 8b 46 08 48
89 47 08 c3 48 8b 07 48 85 c0 74 1a <48> 8b 10 48 85 d2 48 89 17 75 08 48
c7 47 08 00 00 00 00 48 c7
Nov 14 17:05:40 steinhager kernel: [22999.088625] RIP  [<ffffffffa03c102e>]
bio_list_pop+0x8/0x23 [dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.088677]  RSP <ffff8801b90ffdb0>
Nov 14 17:05:40 steinhager kernel: [22999.088714] CR2: 0000000ffcc35800
Nov 14 17:05:40 steinhager kernel: [22999.089108] ---[ end trace
91dc97f60fa89842 ]---
Nov 14 17:05:40 steinhager kernel: [22999.089114] general protection fault:
0000 [#2] SMP
Nov 14 17:05:40 steinhager kernel: [22999.089151] Modules linked in:
dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_bufio libcrc32c
raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx
raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd_pcm iTCO_wdt
snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vendor_support
ipmi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_raw
microcode ipmi_msghandler ehci_pci button acpi_cpufreq processor
thermal_sys ext4 crc16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod
crc_t10dif crct10dif_common crc32c_intel uhci_hcd firewire_ohci ehci_hcd
ata_generic ahci firewire_core libahci pata_jmicron crc_itu_t usbcore
libata usb_common megaraid_sas igb i2c_algo_bit i2c_core dca ptp pps_core
scsi_mod [last unloaded: dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.089154] CPU: 9 PID: 10045 Comm:
blkid Tainted: G      D        3.17.2 #2
Nov 14 17:05:40 steinhager kernel: [22999.089155] Hardware name: SGI.COM
C3108-TY11/X8DAH, BIOS 1.1     03/16/2011
Nov 14 17:05:40 steinhager kernel: [22999.089157] task: ffff8801b8e4ce60
ti: ffff8801b44b4000 task.ti: ffff8801b44b4000
Nov 14 17:05:40 steinhager kernel: [22999.089163] RIP:
0010:[<ffffffffa0370417>]  [<ffffffffa0370417>]
dm_cell_release_no_holder+0x2c/0x85 [dm_bio_prison]
Nov 14 17:05:40 steinhager kernel: [22999.089164] RSP:
0018:ffff8801b44b7a00  EFLAGS: 00010086
Nov 14 17:05:40 steinhager kernel: [22999.089165] RAX: 0000000000000086
RBX: ffff8801b7818018 RCX: dead000000200200
Nov 14 17:05:40 steinhager kernel: [22999.089166] RDX: dead000000100100
RSI: 0000000000000001 RDI: ffff8801b7818018
Nov 14 17:05:40 steinhager kernel: [22999.089168] RBP: ffff8801b5a38870
R08: 0000000000000010 R09: 0000000000000001
Nov 14 17:05:40 steinhager kernel: [22999.089169] R10: 0000000000000001
R11: ffff8801b93e2810 R12: ffff880338e5bc60
Nov 14 17:05:40 steinhager kernel: [22999.089170] R13: 0000000000000246
R14: 0000000000000000 R15: ffff8801b213fd80
Nov 14 17:05:40 steinhager kernel: [22999.089172] FS:
 00007ffff7fea780(0000) GS:ffff8801bfca0000(0000) knlGS:0000000000000000
Nov 14 17:05:40 steinhager kernel: [22999.089173] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Nov 14 17:05:40 steinhager kernel: [22999.089174] CR2: 00007ffff79586a7
CR3: 00000001b0dba000 CR4: 00000000000007e0
Nov 14 17:05:40 steinhager kernel: [22999.089175] Stack:
Nov 14 17:05:40 steinhager kernel: [22999.089178]  ffff880338e5bc00
ffff880338e5bc5c ffff8801b5a38870 ffffffffa03c1b3f
Nov 14 17:05:40 steinhager kernel: [22999.089179]  ffff880338e5bc00
ffff8801b213fd80 0000000000000001 00000000007feebf
Nov 14 17:05:40 steinhager kernel: [22999.089181]  ffff8801b213fd40
ffffffffa03c3d98 ffff8801b0e01900 ffff8801b5a38870
Nov 14 17:05:40 steinhager kernel: [22999.089182] Call Trace:
Nov 14 17:05:40 steinhager kernel: [22999.089187]  [<ffffffffa03c1b3f>] ?
cell_defer+0x45/0x6f [dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.089191]  [<ffffffffa03c3d98>] ?
cache_map+0x319/0x32b [dm_cache]
Nov 14 17:05:40 steinhager kernel: [22999.089198]  [<ffffffffa00ab0e6>] ?
__map_bio+0x39/0xe3 [dm_mod]
Nov 14 17:05:40 steinhager kernel: [22999.089205]  [<ffffffffa00ab5f8>] ?
__split_and_process_bio+0x306/0x33c [dm_mod]
Nov 14 17:05:40 steinhager kernel: [22999.089211]  [<ffffffffa00aba47>] ?
dm_request+0x15e/0x16f [dm_mod]
Nov 14 17:05:40 steinhager kernel: [22999.089216]  [<ffffffff811b686a>] ?
generic_make_request+0xaa/0xf0
Nov 14 17:05:40 steinhager kernel: [22999.089218]  [<ffffffff811b69a7>] ?
submit_bio+0xf7/0x100
Nov 14 17:05:40 steinhager kernel: [22999.089223]  [<ffffffff8113a911>] ?
_submit_bh+0x1b0/0x1d5
Nov 14 17:05:40 steinhager kernel: [22999.089225]  [<ffffffff8113afb5>] ?
block_read_full_page+0x1b8/0x1d1
Nov 14 17:05:40 steinhager kernel: [22999.089228]  [<ffffffff8113c2a3>] ?
I_BDEV+0x8/0x8
Nov 14 17:05:40 steinhager kernel: [22999.089233]  [<ffffffff810cec69>] ?
__add_to_page_cache_locked+0xf2/0x14d
Nov 14 17:05:40 steinhager kernel: [22999.089236]  [<ffffffff810d909c>] ?
get_page+0x9/0x25
Nov 14 17:05:40 steinhager kernel: [22999.089239]  [<ffffffff810d918d>] ?
__lru_cache_add+0x1a/0x39
Nov 14 17:05:40 steinhager kernel: [22999.089242]  [<ffffffff810d7d74>] ?
__do_page_cache_readahead+0x1a8/0x1e1
Nov 14 17:05:40 steinhager kernel: [22999.089245]  [<ffffffff810d8090>] ?
force_page_cache_readahead+0x67/0x80
Nov 14 17:05:40 steinhager kernel: [22999.089247]  [<ffffffff810ced4a>] ?
pagecache_get_page+0x25/0x13c
Nov 14 17:05:40 steinhager kernel: [22999.089249]  [<ffffffff810d8090>] ?
force_page_cache_readahead+0x67/0x80
Nov 14 17:05:40 steinhager kernel: [22999.089252]  [<ffffffff810cf517>] ?
generic_file_read_iter+0x170/0x4ca
Nov 14 17:05:40 steinhager kernel: [22999.089256]  [<ffffffff811153c7>] ?
new_sync_read+0x62/0x86
Nov 14 17:05:40 steinhager kernel: [22999.089259]  [<ffffffff81115963>] ?
vfs_read+0x93/0xe3
Nov 14 17:05:40 steinhager kernel: [22999.089261]  [<ffffffff8111612d>] ?
SyS_read+0x48/0x73
Nov 14 17:05:40 steinhager kernel: [22999.089266]  [<ffffffff81397dd2>] ?
system_call_fastpath+0x16/0x1b
Nov 14 17:05:40 steinhager kernel: [22999.089284] Code: 54 55 48 89 f5 53
49 89 d4 6b 5e 20 fb 23 5f 0c 48 c1 e3 04 48 03 5f 10 48 89 df e8 72 75 02
e1 48 8b 55 00 48 8b 4d 08 48 85 d2 <48> 89 11 74 04 48 89 4a 08 48 8b 55
30 48 be 00 01 10 00 00 00
Nov 14 17:05:40 steinhager kernel: [22999.089287] RIP  [<ffffffffa0370417>]
dm_cell_release_no_holder+0x2c/0x85 [dm_bio_prison]
Nov 14 17:05:40 steinhager kernel: [22999.089291]  RSP <ffff8801b44b7a00>
Nov 14 17:05:40 steinhager kernel: [22999.089293] ---[ end trace
91dc97f60fa89843 ]---
Nov 14 17:06:40 steinhager kernel: [22999.094103] BUG: unable to handle
kernel paging request at ffffffffffffffd8
Nov 14 17:06:40 steinhager kernel: [22999.094291] IP: [<ffffffff81052083>]
kthread_data+0x7/0xc
Nov 14 17:06:40 steinhager kernel: [22999.094428] PGD 1612067 PUD 1614067
PMD 0
Nov 14 17:06:40 steinhager kernel: [22999.094653] Oops: 0000 [#3] SMP
Nov 14 17:06:40 steinhager kernel: [22999.094828] Modules linked in:
dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_bufio libcrc32c
raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx
raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd_pcm iTCO_wdt
snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vendor_support
ipmi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_raw
microcode ipmi_msghandler ehci_pci button acpi_cpufreq processor
thermal_sys ext4 crc16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod
crc_t10dif crct10dif_common crc32c_intel uhci_hcd firewire_ohci ehci_hcd
ata_generic ahci firewire_core libahci pata_jmicron crc_itu_t usbcore
libata usb_common megaraid_sas igb i2c_algo_bit i2c_core dca ptp pps_core
scsi_mod [last unloaded: dm_cache]
Nov 14 17:06:40 steinhager kernel: [22999.099000] CPU: 4 PID: 6 Comm:
kworker/u48:0 Tainted: G      D        3.17.2 #2
Nov 14 17:06:40 steinhager kernel: [22999.099119] Hardware name: SGI.COM
C3108-TY11/X8DAH, BIOS 1.1     03/16/2011
Nov 14 17:06:40 steinhager kernel: [22999.099220] task: ffff8801b90ec050
ti: ffff8801b90fc000 task.ti: ffff8801b90fc000
Nov 14 17:06:40 steinhager kernel: [22999.099339] RIP:
0010:[<ffffffff81052083>]  [<ffffffff81052083>] kthread_data+0x7/0xc
Nov 14 17:06:40 steinhager kernel: [22999.099508] RSP:
0018:ffff8801b90ffaa0  EFLAGS: 00010002
Nov 14 17:06:40 steinhager kernel: [22999.099596] RAX: 0000000000000000
RBX: ffff88033fc13180 RCX: 0000000000000004
Nov 14 17:06:40 steinhager kernel: [22999.099690] RDX: 0000000000000000
RSI: 0000000000000004 RDI: ffff8801b90ec050
Nov 14 17:06:40 steinhager kernel: [22999.099785] RBP: 0000000000000004
R08: ffff88033fc131f0 R09: ffffffff817ceac0
Nov 14 17:06:40 steinhager kernel: [22999.099879] R10: 000000000000b9cd
R11: ffff8801b90f002f R12: 0000000000000004
Nov 14 17:06:40 steinhager kernel: [22999.099973] R13: ffff8801b90ec4b0
R14: ffff8801b90ffb58 R15: ffff8801b90ec3a8
Nov 14 17:06:40 steinhager kernel: [22999.100068] FS:
 0000000000000000(0000) GS:ffff88033fc00000(0000) knlGS:0000000000000000
Nov 14 17:06:40 steinhager kernel: [22999.100189] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Nov 14 17:06:40 steinhager kernel: [22999.100279] CR2: 0000000000000028
CR3: 0000000001611000 CR4: 00000000000007e0
Nov 14 17:06:40 steinhager kernel: [22999.100373] Stack:
Nov 14 17:06:40 steinhager kernel: [22999.100451]  ffffffff8104e86c
ffff88033fc13180 ffff8801b90ec050 ffffffff81394f3f
Nov 14 17:06:40 steinhager kernel: [22999.100757]  0000000000013180
ffff8801b90ec050 ffff8801b90fffd8 0000000000000000
Nov 14 17:06:40 steinhager kernel: [22999.101064]  ffff8801b90ec050
ffff8801b90ec6d0 0000000000000001 ffff8801b90ec040
Nov 14 17:06:40 steinhager kernel: [22999.101370] Call Trace:
Nov 14 17:06:40 steinhager kernel: [22999.101451]  [<ffffffff8104e86c>] ?
wq_worker_sleeping+0x9/0x7f
Nov 14 17:06:40 steinhager kernel: [22999.101543]  [<ffffffff81394f3f>] ?
__schedule+0x137/0x4d9
Nov 14 17:06:40 steinhager kernel: [22999.101636]  [<ffffffff8103e220>] ?
do_exit+0x929/0x966
Nov 14 17:06:40 steinhager kernel: [22999.101728]  [<ffffffff8139360e>] ?
printk+0x4a/0x52
Nov 14 17:06:40 steinhager kernel: [22999.101817]  [<ffffffff810050bd>] ?
oops_end+0x9c/0xa1
Nov 14 17:06:40 steinhager kernel: [22999.101908]  [<ffffffff810314c5>] ?
no_context+0x2c8/0x325
Nov 14 17:06:40 steinhager kernel: [22999.101998]  [<ffffffff81031ab2>] ?
__do_page_fault+0x1d7/0x397
Nov 14 17:06:40 steinhager kernel: [22999.102093]  [<ffffffff810582b1>] ?
set_task_cpu+0x92/0xeb
Nov 14 17:06:40 steinhager kernel: [22999.102185]  [<ffffffff810d556d>] ?
__alloc_pages_nodemask+0x16c/0x7c5
Nov 14 17:06:40 steinhager kernel: [22999.102280]  [<ffffffff8110960a>] ?
kmem_getpages+0xbc/0xd0
Nov 14 17:06:40 steinhager kernel: [22999.102370]  [<ffffffff8110a81a>] ?
cache_grow+0x163/0x1b5
Nov 14 17:06:40 steinhager kernel: [22999.102460]  [<ffffffff8110a48a>] ?
____cache_alloc+0x127/0x253
Nov 14 17:06:40 steinhager kernel: [22999.102554]  [<ffffffff813997e2>] ?
page_fault+0x22/0x30
Nov 14 17:06:40 steinhager kernel: [22999.102644]  [<ffffffffa03c102e>] ?
bio_list_pop+0x8/0x23 [dm_cache]
Nov 14 17:06:40 steinhager kernel: [22999.102738]  [<ffffffffa03c4095>] ?
do_worker+0x29f/0x649 [dm_cache]
Nov 14 17:06:40 steinhager kernel: [22999.102830]  [<ffffffff810016b0>] ?
__switch_to+0x22d/0x45a
Nov 14 17:06:40 steinhager kernel: [22999.102921]  [<ffffffff8104dfb5>] ?
process_one_work+0x158/0x27b
Nov 14 17:06:40 steinhager kernel: [22999.103012]  [<ffffffff8104e765>] ?
worker_thread+0x1ea/0x294
Nov 14 17:06:40 steinhager kernel: [22999.103103]  [<ffffffff8104e57b>] ?
rescuer_thread+0x217/0x217
Nov 14 17:06:40 steinhager kernel: [22999.103194]  [<ffffffff81051db6>] ?
kthread+0xa7/0xaf
Nov 14 17:06:40 steinhager kernel: [22999.103282]  [<ffffffff81051d0f>] ?
__kthread_parkme+0x5b/0x5b
Nov 14 17:06:40 steinhager kernel: [22999.103373]  [<ffffffff81397d2c>] ?
ret_from_fork+0x7c/0xb0
Nov 14 17:06:40 steinhager kernel: [22999.103464]  [<ffffffff81051d0f>] ?
__kthread_parkme+0x5b/0x5b
Nov 14 17:06:40 steinhager kernel: [22999.103553] Code: 5d 41 5c 41 5d 41
5e c3 65 48 8b 04 25 c0 b9 00 00 48 8b 80 08 04 00 00 48 8b 40 c8 48 c1 e8
02 83 e0 01 c3 48 8b 87 08 04 00 00 <48> 8b 40 d8 c3 50 48 8b b7 08 04 00
00 ba 08 00 00 00 48 89 e7
Nov 14 17:06:40 steinhager kernel: [22999.112758] RIP  [<ffffffff81052083>]
kthread_data+0x7/0xc
Nov 14 17:06:40 steinhager kernel: [22999.112896]  RSP <ffff8801b90ffaa0>
Nov 14 17:06:40 steinhager kernel: [22999.112978] CR2: ffffffffffffffd8
Nov 14 17:06:40 steinhager kernel: [22999.113060] ---[ end trace
91dc97f60fa89844 ]---
Nov 14 17:06:40 steinhager kernel: [22999.113146] Fixing recursive fault
but reboot is needed!
Nov 14 17:06:40 steinhager kernel: [23029.548874] ------------[ cut here
]------------
Nov 14 17:06:40 steinhager kernel: [23029.548951] WARNING: CPU: 0 PID: 0 at
kernel/watchdog.c:267 watchdog_overflow_callback+0x92/0x9d()
Nov 14 17:06:40 steinhager kernel: [23029.549041] Watchdog detected hard
LOCKUP on cpu 0
Nov 14 17:06:40 steinhager kernel: [23029.549094] Modules linked in:
dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_bufio libcrc32c
raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx
raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd_pcm iTCO_wdt
snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vendor_support
ipmi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_raw
microcode ipmi_msghandler ehci_pci button acpi_cpufreq processor
thermal_sys ext4 crc16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod
crc_t10dif crct10dif_common crc32c_intel uhci_hcd firewire_ohci ehci_hcd
ata_generic ahci firewire_core libahci pata_jmicron crc_itu_t usbcore
libata usb_common megaraid_sas igb i2c_algo_bit i2c_core dca ptp pps_core
scsi_mod [last unloaded: dm_cache]
Nov 14 17:06:40 steinhager kernel: [23029.552866] CPU: 0 PID: 0 Comm:
swapper/0 Tainted: G      D        3.17.2 #2
Nov 14 17:06:40 steinhager kernel: [23029.552938] Hardware name: SGI.COM
C3108-TY11/X8DAH, BIOS 1.1     03/16/2011
Nov 14 17:06:40 steinhager kernel: [23029.553010]  0000000000000006
ffffffff813940f8 ffff8801bfc06ca0 ffffffff8103cb84
Nov 14 17:06:40 steinhager kernel: [23029.553270]  ffffffff810aa484
ffff8801b911e400 ffff8801bfc06cf8 ffff8801bfc06d90
Nov 14 17:06:40 steinhager kernel: [23029.553530]  ffff8801bfc06ef8
ffffffff8103cbdc ffffffff8150ddf9 0000000000000020
Nov 14 17:06:40 steinhager kernel: [23029.553790] Call Trace:
Nov 14 17:06:40 steinhager kernel: [23029.553853]  <NMI>
 [<ffffffff813940f8>] ? dump_stack+0x41/0x51
Nov 14 17:06:40 steinhager kernel: [23029.554016]  [<ffffffff8103cb84>] ?
warn_slowpath_common+0x74/0x89
Nov 14 17:06:40Write failed: Connection reset by peer

--001a11c35626396b9105080ebc08
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote"><div dir=3D"ltr"><div>I&#39;m w=
orking in tests for my msc thesis envolving dm_cache module. I&#39;m having=
 problems with the following scenario:<br></div><div><br></div><div>Slowsto=
rage: RAID1 (mdadm) with 4 HDDs;</div><div>- /dev/md/raid1_4ssds</div><div>=
-- /dev/sda</div><div>-- /dev/sdb</div><div>-- /dev/sdc</div><div>-- /dev/s=
dd</div><div><br></div><div>Faststorage: RAID1 (mdadm) with 4 SSDs</div><di=
v>- /dev/md/raid1_4hdds</div><div>-- /dev/sde</div><div>-- /dev/sdf</div><d=
iv>-- /dev/sdg</div><div>-- /dev/sdh</div><div><br></div><div>Cachestorage:=
 dm_cache envolving both devices</div><div>- /dev/mapper/dmcache</div><div>=
-- /dev/md/raid1_4ssds</div><div>-- /dev/md/raid1_4hdds</div><div><br></div=
><div>Other informations (strange facts):</div><div>In RAID0 it&#39;s worki=
ng very well.</div><div>In a virtual machine (vbox) it&#39;s working as wel=
l (in this case disks have 2GB only for big tests automatization, in produc=
tion are 160GB SSDs and 2TB HDDs);</div><div><br></div><div>Have you seen a=
bout this error? Syslog is bellow.</div><div><br></div><div>Thanks!</div><d=
iv>Leonardo Santos</div><div><br></div><div><br></div><div><div>Nov 14 17:0=
5:36 steinhager mdadm[2412]: NewArray event detected on md device /dev/md/r=
aid1_4ssds</div><div>Nov 14 17:05:36 steinhager kernel: [22995.480318] md/r=
aid1:md126: active with 4 out of 4 mirrors</div><div>Nov 14 17:05:36 steinh=
ager kernel: [22995.480367] md126: detected capacity change from 0 to 21978=
65431040</div><div>Nov 14 17:05:36 steinhager kernel: [22995.491499] =C2=A0=
md126: unknown partition table</div><div>Nov 14 17:05:39 steinhager kernel:=
 [22999.008757] device-mapper: cache-policy-mq: version 1.2.0 loaded</div><=
div>Nov 14 17:05:40 steinhager kernel: [22999.086449] BUG: unable to handle=
 kernel paging request at 0000000ffcc35800</div><div>Nov 14 17:05:40 steinh=
ager kernel: [22999.086486] IP: [&lt;ffffffffa03c102e&gt;] bio_list_pop+0x8=
/0x23 [dm_cache]</div><div>Nov 14 17:05:40 steinhager kernel: [22999.086518=
] PGD 0</div><div>Nov 14 17:05:40 steinhager kernel: [22999.086531] Oops: 0=
000 [#1] SMP</div><div>Nov 14 17:05:40 steinhager kernel: [22999.086553] Mo=
dules linked in: dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_b=
ufio libcrc32c raid456 async_raid6_recov async_memcpy async_pq async_xor xo=
r async_tx raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd_pcm iTCO_=
wdt snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vendor_support=
 ipmi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_raw microco=
de ipmi_msghandler ehci_pci button acpi_cpufreq processor thermal_sys ext4 =
crc16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod crc_t10dif crct10dif_commo=
n crc32c_intel uhci_hcd firewire_ohci ehci_hcd ata_generic ahci firewire_co=
re libahci pata_jmicron crc_itu_t usbcore libata usb_common megaraid_sas ig=
b i2c_algo_bit i2c_core dca ptp pps_core scsi_mod [last unloaded: dm_cache]=
</div><div>Nov 14 17:05:40 steinhager kernel: [22999.086972] CPU: 4 PID: 6 =
Comm: kworker/u48:0 Not tainted 3.17.2 #2</div><div>Nov 14 17:05:40 steinha=
ger kernel: [22999.086996] Hardware name: <a href=3D"http://SGI.COM" target=
=3D"_blank">SGI.COM</a> C3108-TY11/X8DAH, BIOS 1.1 =C2=A0 =C2=A0 03/16/2011=
</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087024] Workqueue: dm-=
cache do_worker [dm_cache]</div><div>Nov 14 17:05:40 steinhager kernel: [22=
999.087045] task: ffff8801b90ec050 ti: ffff8801b90fc000 task.ti: ffff8801b9=
0fc000</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087072] RIP: 001=
0:[&lt;ffffffffa03c102e&gt;] =C2=A0[&lt;ffffffffa03c102e&gt;] bio_list_pop+=
0x8/0x23 [dm_cache]</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087=
132] RSP: 0018:ffff8801b90ffdb0 =C2=A0EFLAGS: 00010206</div><div>Nov 14 17:=
05:40 steinhager kernel: [22999.087176] RAX: 0000000ffcc35800 RBX: ffff8803=
38e5bd48 RCX: 0000000000000008</div><div>Nov 14 17:05:40 steinhager kernel:=
 [22999.087226] RDX: 0000000000000000 RSI: ffff88032c1b3400 RDI: ffff8801b9=
0ffde8</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087276] RBP: fff=
f880338e5bc00 R08: ffff8801b90fc000 R09: 0000000000000000</div><div>Nov 14 =
17:05:40 steinhager kernel: [22999.087325] R10: 000000000000b951 R11: 00000=
00000000005 R12: ffff8801b90ffe00</div><div>Nov 14 17:05:40 steinhager kern=
el: [22999.087375] R13: ffff8801b90ffde8 R14: ffff880338e5bc5c R15: 0000000=
000000246</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087425] FS: =
=C2=A00000000000000000(0000) GS:ffff88033fc00000(0000) knlGS:00000000000000=
00</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087502] CS: =C2=A000=
10 DS: 0000 ES: 0000 CR0: 000000008005003b</div><div>Nov 14 17:05:40 steinh=
ager kernel: [22999.087547] CR2: 0000000ffcc35800 CR3: 0000000001611000 CR4=
: 00000000000007e0</div><div>Nov 14 17:05:40 steinhager kernel: [22999.0875=
97] Stack:</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087630] =C2=
=A0ffffffffa03c4095 ffff880338e5bc60 ffff8801b90ec050 0000000000000000</div=
><div>Nov 14 17:05:40 steinhager kernel: [22999.087713] =C2=A0ffff88033fc13=
1f0 ffffffff810016b0 ffff8801b90ec568 0000000ffcc35800</div><div>Nov 14 17:=
05:40 steinhager kernel: [22999.087796] =C2=A00000000ee6ea5800 ffff880331a3=
23c0 ffff880331a31470 ffff880331a32400</div><div>Nov 14 17:05:40 steinhager=
 kernel: [22999.087879] Call Trace:</div><div>Nov 14 17:05:40 steinhager ke=
rnel: [22999.087917] =C2=A0[&lt;ffffffffa03c4095&gt;] ? do_worker+0x29f/0x6=
49 [dm_cache]</div><div>Nov 14 17:05:40 steinhager kernel: [22999.087968] =
=C2=A0[&lt;ffffffff810016b0&gt;] ? __switch_to+0x22d/0x45a</div><div>Nov 14=
 17:05:40 steinhager kernel: [22999.088016] =C2=A0[&lt;ffffffff8104dfb5&gt;=
] ? process_one_work+0x158/0x27b</div><div>Nov 14 17:05:40 steinhager kerne=
l: [22999.088063] =C2=A0[&lt;ffffffff8104e765&gt;] ? worker_thread+0x1ea/0x=
294</div><div>Nov 14 17:05:40 steinhager kernel: [22999.088109] =C2=A0[&lt;=
ffffffff8104e57b&gt;] ? rescuer_thread+0x217/0x217</div><div>Nov 14 17:05:4=
0 steinhager kernel: [22999.088157] =C2=A0[&lt;ffffffff81051db6&gt;] ? kthr=
ead+0xa7/0xaf</div><div>Nov 14 17:05:40 steinhager kernel: [22999.088201] =
=C2=A0[&lt;ffffffff81051d0f&gt;] ? __kthread_parkme+0x5b/0x5b</div><div>Nov=
 14 17:05:40 steinhager kernel: [22999.088251] =C2=A0[&lt;ffffffff81397d2c&=
gt;] ? ret_from_fork+0x7c/0xb0</div><div>Nov 14 17:05:40 steinhager kernel:=
 [22999.088296] =C2=A0[&lt;ffffffff81051d0f&gt;] ? __kthread_parkme+0x5b/0x=
5b</div><div>Nov 14 17:05:40 steinhager kernel: [22999.088342] Code: c3 48 =
8b 06 48 85 c0 74 19 48 8b 57 08 48 85 d2 74 05 48 89 02 eb 03 48 89 07 48 =
8b 46 08 48 89 47 08 c3 48 8b 07 48 85 c0 74 1a &lt;48&gt; 8b 10 48 85 d2 4=
8 89 17 75 08 48 c7 47 08 00 00 00 00 48 c7</div><div>Nov 14 17:05:40 stein=
hager kernel: [22999.088625] RIP =C2=A0[&lt;ffffffffa03c102e&gt;] bio_list_=
pop+0x8/0x23 [dm_cache]</div><div>Nov 14 17:05:40 steinhager kernel: [22999=
.088677] =C2=A0RSP &lt;ffff8801b90ffdb0&gt;</div><div>Nov 14 17:05:40 stein=
hager kernel: [22999.088714] CR2: 0000000ffcc35800</div><div>Nov 14 17:05:4=
0 steinhager kernel: [22999.089108] ---[ end trace 91dc97f60fa89842 ]---</d=
iv><div>Nov 14 17:05:40 steinhager kernel: [22999.089114] general protectio=
n fault: 0000 [#2] SMP</div><div>Nov 14 17:05:40 steinhager kernel: [22999.=
089151] Modules linked in: dm_cache_mq dm_cache dm_persistent_data dm_bio_p=
rison dm_bufio libcrc32c raid456 async_raid6_recov async_memcpy async_pq as=
ync_xor xor async_tx raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd=
_pcm iTCO_wdt snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vend=
or_support ipmi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_r=
aw microcode ipmi_msghandler ehci_pci button acpi_cpufreq processor thermal=
_sys ext4 crc16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod crc_t10dif crct1=
0dif_common crc32c_intel uhci_hcd firewire_ohci ehci_hcd ata_generic ahci f=
irewire_core libahci pata_jmicron crc_itu_t usbcore libata usb_common megar=
aid_sas igb i2c_algo_bit i2c_core dca ptp pps_core scsi_mod [last unloaded:=
 dm_cache]</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089154] CPU:=
 9 PID: 10045 Comm: blkid Tainted: G =C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0 =
=C2=A0 =C2=A03.17.2 #2</div><div>Nov 14 17:05:40 steinhager kernel: [22999.=
089155] Hardware name: <a href=3D"http://SGI.COM" target=3D"_blank">SGI.COM=
</a> C3108-TY11/X8DAH, BIOS 1.1 =C2=A0 =C2=A0 03/16/2011</div><div>Nov 14 1=
7:05:40 steinhager kernel: [22999.089157] task: ffff8801b8e4ce60 ti: ffff88=
01b44b4000 task.ti: ffff8801b44b4000</div><div>Nov 14 17:05:40 steinhager k=
ernel: [22999.089163] RIP: 0010:[&lt;ffffffffa0370417&gt;] =C2=A0[&lt;fffff=
fffa0370417&gt;] dm_cell_release_no_holder+0x2c/0x85 [dm_bio_prison]</div><=
div>Nov 14 17:05:40 steinhager kernel: [22999.089164] RSP: 0018:ffff8801b44=
b7a00 =C2=A0EFLAGS: 00010086</div><div>Nov 14 17:05:40 steinhager kernel: [=
22999.089165] RAX: 0000000000000086 RBX: ffff8801b7818018 RCX: dead00000020=
0200</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089166] RDX: dead0=
00000100100 RSI: 0000000000000001 RDI: ffff8801b7818018</div><div>Nov 14 17=
:05:40 steinhager kernel: [22999.089168] RBP: ffff8801b5a38870 R08: 0000000=
000000010 R09: 0000000000000001</div><div>Nov 14 17:05:40 steinhager kernel=
: [22999.089169] R10: 0000000000000001 R11: ffff8801b93e2810 R12: ffff88033=
8e5bc60</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089170] R13: 00=
00000000000246 R14: 0000000000000000 R15: ffff8801b213fd80</div><div>Nov 14=
 17:05:40 steinhager kernel: [22999.089172] FS: =C2=A000007ffff7fea780(0000=
) GS:ffff8801bfca0000(0000) knlGS:0000000000000000</div><div>Nov 14 17:05:4=
0 steinhager kernel: [22999.089173] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 0=
000000080050033</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089174]=
 CR2: 00007ffff79586a7 CR3: 00000001b0dba000 CR4: 00000000000007e0</div><di=
v>Nov 14 17:05:40 steinhager kernel: [22999.089175] Stack:</div><div>Nov 14=
 17:05:40 steinhager kernel: [22999.089178] =C2=A0ffff880338e5bc00 ffff8803=
38e5bc5c ffff8801b5a38870 ffffffffa03c1b3f</div><div>Nov 14 17:05:40 steinh=
ager kernel: [22999.089179] =C2=A0ffff880338e5bc00 ffff8801b213fd80 0000000=
000000001 00000000007feebf</div><div>Nov 14 17:05:40 steinhager kernel: [22=
999.089181] =C2=A0ffff8801b213fd40 ffffffffa03c3d98 ffff8801b0e01900 ffff88=
01b5a38870</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089182] Call=
 Trace:</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089187] =C2=A0[=
&lt;ffffffffa03c1b3f&gt;] ? cell_defer+0x45/0x6f [dm_cache]</div><div>Nov 1=
4 17:05:40 steinhager kernel: [22999.089191] =C2=A0[&lt;ffffffffa03c3d98&gt=
;] ? cache_map+0x319/0x32b [dm_cache]</div><div>Nov 14 17:05:40 steinhager =
kernel: [22999.089198] =C2=A0[&lt;ffffffffa00ab0e6&gt;] ? __map_bio+0x39/0x=
e3 [dm_mod]</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089205] =C2=
=A0[&lt;ffffffffa00ab5f8&gt;] ? __split_and_process_bio+0x306/0x33c [dm_mod=
]</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089211] =C2=A0[&lt;ff=
ffffffa00aba47&gt;] ? dm_request+0x15e/0x16f [dm_mod]</div><div>Nov 14 17:0=
5:40 steinhager kernel: [22999.089216] =C2=A0[&lt;ffffffff811b686a&gt;] ? g=
eneric_make_request+0xaa/0xf0</div><div>Nov 14 17:05:40 steinhager kernel: =
[22999.089218] =C2=A0[&lt;ffffffff811b69a7&gt;] ? submit_bio+0xf7/0x100</di=
v><div>Nov 14 17:05:40 steinhager kernel: [22999.089223] =C2=A0[&lt;fffffff=
f8113a911&gt;] ? _submit_bh+0x1b0/0x1d5</div><div>Nov 14 17:05:40 steinhage=
r kernel: [22999.089225] =C2=A0[&lt;ffffffff8113afb5&gt;] ? block_read_full=
_page+0x1b8/0x1d1</div><div>Nov 14 17:05:40 steinhager kernel: [22999.08922=
8] =C2=A0[&lt;ffffffff8113c2a3&gt;] ? I_BDEV+0x8/0x8</div><div>Nov 14 17:05=
:40 steinhager kernel: [22999.089233] =C2=A0[&lt;ffffffff810cec69&gt;] ? __=
add_to_page_cache_locked+0xf2/0x14d</div><div>Nov 14 17:05:40 steinhager ke=
rnel: [22999.089236] =C2=A0[&lt;ffffffff810d909c&gt;] ? get_page+0x9/0x25</=
div><div>Nov 14 17:05:40 steinhager kernel: [22999.089239] =C2=A0[&lt;fffff=
fff810d918d&gt;] ? __lru_cache_add+0x1a/0x39</div><div>Nov 14 17:05:40 stei=
nhager kernel: [22999.089242] =C2=A0[&lt;ffffffff810d7d74&gt;] ? __do_page_=
cache_readahead+0x1a8/0x1e1</div><div>Nov 14 17:05:40 steinhager kernel: [2=
2999.089245] =C2=A0[&lt;ffffffff810d8090&gt;] ? force_page_cache_readahead+=
0x67/0x80</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089247] =C2=
=A0[&lt;ffffffff810ced4a&gt;] ? pagecache_get_page+0x25/0x13c</div><div>Nov=
 14 17:05:40 steinhager kernel: [22999.089249] =C2=A0[&lt;ffffffff810d8090&=
gt;] ? force_page_cache_readahead+0x67/0x80</div><div>Nov 14 17:05:40 stein=
hager kernel: [22999.089252] =C2=A0[&lt;ffffffff810cf517&gt;] ? generic_fil=
e_read_iter+0x170/0x4ca</div><div>Nov 14 17:05:40 steinhager kernel: [22999=
.089256] =C2=A0[&lt;ffffffff811153c7&gt;] ? new_sync_read+0x62/0x86</div><d=
iv>Nov 14 17:05:40 steinhager kernel: [22999.089259] =C2=A0[&lt;ffffffff811=
15963&gt;] ? vfs_read+0x93/0xe3</div><div>Nov 14 17:05:40 steinhager kernel=
: [22999.089261] =C2=A0[&lt;ffffffff8111612d&gt;] ? SyS_read+0x48/0x73</div=
><div>Nov 14 17:05:40 steinhager kernel: [22999.089266] =C2=A0[&lt;ffffffff=
81397dd2&gt;] ? system_call_fastpath+0x16/0x1b</div><div>Nov 14 17:05:40 st=
einhager kernel: [22999.089284] Code: 54 55 48 89 f5 53 49 89 d4 6b 5e 20 f=
b 23 5f 0c 48 c1 e3 04 48 03 5f 10 48 89 df e8 72 75 02 e1 48 8b 55 00 48 8=
b 4d 08 48 85 d2 &lt;48&gt; 89 11 74 04 48 89 4a 08 48 8b 55 30 48 be 00 01=
 10 00 00 00</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089287] RI=
P =C2=A0[&lt;ffffffffa0370417&gt;] dm_cell_release_no_holder+0x2c/0x85 [dm_=
bio_prison]</div><div>Nov 14 17:05:40 steinhager kernel: [22999.089291] =C2=
=A0RSP &lt;ffff8801b44b7a00&gt;</div><div>Nov 14 17:05:40 steinhager kernel=
: [22999.089293] ---[ end trace 91dc97f60fa89843 ]---</div><div>Nov 14 17:0=
6:40 steinhager kernel: [22999.094103] BUG: unable to handle kernel paging =
request at ffffffffffffffd8</div><div>Nov 14 17:06:40 steinhager kernel: [2=
2999.094291] IP: [&lt;ffffffff81052083&gt;] kthread_data+0x7/0xc</div><div>=
Nov 14 17:06:40 steinhager kernel: [22999.094428] PGD 1612067 PUD 1614067 P=
MD 0</div><div>Nov 14 17:06:40 steinhager kernel: [22999.094653] Oops: 0000=
 [#3] SMP</div><div>Nov 14 17:06:40 steinhager kernel: [22999.094828] Modul=
es linked in: dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_bufi=
o libcrc32c raid456 async_raid6_recov async_memcpy async_pq async_xor xor a=
sync_tx raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd_pcm iTCO_wdt=
 snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vendor_support ip=
mi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_raw microcode =
ipmi_msghandler ehci_pci button acpi_cpufreq processor thermal_sys ext4 crc=
16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common c=
rc32c_intel uhci_hcd firewire_ohci ehci_hcd ata_generic ahci firewire_core =
libahci pata_jmicron crc_itu_t usbcore libata usb_common megaraid_sas igb i=
2c_algo_bit i2c_core dca ptp pps_core scsi_mod [last unloaded: dm_cache]</d=
iv><div>Nov 14 17:06:40 steinhager kernel: [22999.099000] CPU: 4 PID: 6 Com=
m: kworker/u48:0 Tainted: G =C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0 =C2=A0 =C2=
=A03.17.2 #2</div><div>Nov 14 17:06:40 steinhager kernel: [22999.099119] Ha=
rdware name: <a href=3D"http://SGI.COM" target=3D"_blank">SGI.COM</a> C3108=
-TY11/X8DAH, BIOS 1.1 =C2=A0 =C2=A0 03/16/2011</div><div>Nov 14 17:06:40 st=
einhager kernel: [22999.099220] task: ffff8801b90ec050 ti: ffff8801b90fc000=
 task.ti: ffff8801b90fc000</div><div>Nov 14 17:06:40 steinhager kernel: [22=
999.099339] RIP: 0010:[&lt;ffffffff81052083&gt;] =C2=A0[&lt;ffffffff8105208=
3&gt;] kthread_data+0x7/0xc</div><div>Nov 14 17:06:40 steinhager kernel: [2=
2999.099508] RSP: 0018:ffff8801b90ffaa0 =C2=A0EFLAGS: 00010002</div><div>No=
v 14 17:06:40 steinhager kernel: [22999.099596] RAX: 0000000000000000 RBX: =
ffff88033fc13180 RCX: 0000000000000004</div><div>Nov 14 17:06:40 steinhager=
 kernel: [22999.099690] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ff=
ff8801b90ec050</div><div>Nov 14 17:06:40 steinhager kernel: [22999.099785] =
RBP: 0000000000000004 R08: ffff88033fc131f0 R09: ffffffff817ceac0</div><div=
>Nov 14 17:06:40 steinhager kernel: [22999.099879] R10: 000000000000b9cd R1=
1: ffff8801b90f002f R12: 0000000000000004</div><div>Nov 14 17:06:40 steinha=
ger kernel: [22999.099973] R13: ffff8801b90ec4b0 R14: ffff8801b90ffb58 R15:=
 ffff8801b90ec3a8</div><div>Nov 14 17:06:40 steinhager kernel: [22999.10006=
8] FS: =C2=A00000000000000000(0000) GS:ffff88033fc00000(0000) knlGS:0000000=
000000000</div><div>Nov 14 17:06:40 steinhager kernel: [22999.100189] CS: =
=C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003b</div><div>Nov 14 17:06:4=
0 steinhager kernel: [22999.100279] CR2: 0000000000000028 CR3: 000000000161=
1000 CR4: 00000000000007e0</div><div>Nov 14 17:06:40 steinhager kernel: [22=
999.100373] Stack:</div><div>Nov 14 17:06:40 steinhager kernel: [22999.1004=
51] =C2=A0ffffffff8104e86c ffff88033fc13180 ffff8801b90ec050 ffffffff81394f=
3f</div><div>Nov 14 17:06:40 steinhager kernel: [22999.100757] =C2=A0000000=
0000013180 ffff8801b90ec050 ffff8801b90fffd8 0000000000000000</div><div>Nov=
 14 17:06:40 steinhager kernel: [22999.101064] =C2=A0ffff8801b90ec050 ffff8=
801b90ec6d0 0000000000000001 ffff8801b90ec040</div><div>Nov 14 17:06:40 ste=
inhager kernel: [22999.101370] Call Trace:</div><div>Nov 14 17:06:40 steinh=
ager kernel: [22999.101451] =C2=A0[&lt;ffffffff8104e86c&gt;] ? wq_worker_sl=
eeping+0x9/0x7f</div><div>Nov 14 17:06:40 steinhager kernel: [22999.101543]=
 =C2=A0[&lt;ffffffff81394f3f&gt;] ? __schedule+0x137/0x4d9</div><div>Nov 14=
 17:06:40 steinhager kernel: [22999.101636] =C2=A0[&lt;ffffffff8103e220&gt;=
] ? do_exit+0x929/0x966</div><div>Nov 14 17:06:40 steinhager kernel: [22999=
.101728] =C2=A0[&lt;ffffffff8139360e&gt;] ? printk+0x4a/0x52</div><div>Nov =
14 17:06:40 steinhager kernel: [22999.101817] =C2=A0[&lt;ffffffff810050bd&g=
t;] ? oops_end+0x9c/0xa1</div><div>Nov 14 17:06:40 steinhager kernel: [2299=
9.101908] =C2=A0[&lt;ffffffff810314c5&gt;] ? no_context+0x2c8/0x325</div><d=
iv>Nov 14 17:06:40 steinhager kernel: [22999.101998] =C2=A0[&lt;ffffffff810=
31ab2&gt;] ? __do_page_fault+0x1d7/0x397</div><div>Nov 14 17:06:40 steinhag=
er kernel: [22999.102093] =C2=A0[&lt;ffffffff810582b1&gt;] ? set_task_cpu+0=
x92/0xeb</div><div>Nov 14 17:06:40 steinhager kernel: [22999.102185] =C2=A0=
[&lt;ffffffff810d556d&gt;] ? __alloc_pages_nodemask+0x16c/0x7c5</div><div>N=
ov 14 17:06:40 steinhager kernel: [22999.102280] =C2=A0[&lt;ffffffff8110960=
a&gt;] ? kmem_getpages+0xbc/0xd0</div><div>Nov 14 17:06:40 steinhager kerne=
l: [22999.102370] =C2=A0[&lt;ffffffff8110a81a&gt;] ? cache_grow+0x163/0x1b5=
</div><div>Nov 14 17:06:40 steinhager kernel: [22999.102460] =C2=A0[&lt;fff=
fffff8110a48a&gt;] ? ____cache_alloc+0x127/0x253</div><div>Nov 14 17:06:40 =
steinhager kernel: [22999.102554] =C2=A0[&lt;ffffffff813997e2&gt;] ? page_f=
ault+0x22/0x30</div><div>Nov 14 17:06:40 steinhager kernel: [22999.102644] =
=C2=A0[&lt;ffffffffa03c102e&gt;] ? bio_list_pop+0x8/0x23 [dm_cache]</div><d=
iv>Nov 14 17:06:40 steinhager kernel: [22999.102738] =C2=A0[&lt;ffffffffa03=
c4095&gt;] ? do_worker+0x29f/0x649 [dm_cache]</div><div>Nov 14 17:06:40 ste=
inhager kernel: [22999.102830] =C2=A0[&lt;ffffffff810016b0&gt;] ? __switch_=
to+0x22d/0x45a</div><div>Nov 14 17:06:40 steinhager kernel: [22999.102921] =
=C2=A0[&lt;ffffffff8104dfb5&gt;] ? process_one_work+0x158/0x27b</div><div>N=
ov 14 17:06:40 steinhager kernel: [22999.103012] =C2=A0[&lt;ffffffff8104e76=
5&gt;] ? worker_thread+0x1ea/0x294</div><div>Nov 14 17:06:40 steinhager ker=
nel: [22999.103103] =C2=A0[&lt;ffffffff8104e57b&gt;] ? rescuer_thread+0x217=
/0x217</div><div>Nov 14 17:06:40 steinhager kernel: [22999.103194] =C2=A0[&=
lt;ffffffff81051db6&gt;] ? kthread+0xa7/0xaf</div><div>Nov 14 17:06:40 stei=
nhager kernel: [22999.103282] =C2=A0[&lt;ffffffff81051d0f&gt;] ? __kthread_=
parkme+0x5b/0x5b</div><div>Nov 14 17:06:40 steinhager kernel: [22999.103373=
] =C2=A0[&lt;ffffffff81397d2c&gt;] ? ret_from_fork+0x7c/0xb0</div><div>Nov =
14 17:06:40 steinhager kernel: [22999.103464] =C2=A0[&lt;ffffffff81051d0f&g=
t;] ? __kthread_parkme+0x5b/0x5b</div><div>Nov 14 17:06:40 steinhager kerne=
l: [22999.103553] Code: 5d 41 5c 41 5d 41 5e c3 65 48 8b 04 25 c0 b9 00 00 =
48 8b 80 08 04 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 48 8b 87 08 04 00 =
00 &lt;48&gt; 8b 40 d8 c3 50 48 8b b7 08 04 00 00 ba 08 00 00 00 48 89 e7</=
div><div>Nov 14 17:06:40 steinhager kernel: [22999.112758] RIP =C2=A0[&lt;f=
fffffff81052083&gt;] kthread_data+0x7/0xc</div><div>Nov 14 17:06:40 steinha=
ger kernel: [22999.112896] =C2=A0RSP &lt;ffff8801b90ffaa0&gt;</div><div>Nov=
 14 17:06:40 steinhager kernel: [22999.112978] CR2: ffffffffffffffd8</div><=
div>Nov 14 17:06:40 steinhager kernel: [22999.113060] ---[ end trace 91dc97=
f60fa89844 ]---</div><div>Nov 14 17:06:40 steinhager kernel: [22999.113146]=
 Fixing recursive fault but reboot is needed!</div><div>Nov 14 17:06:40 ste=
inhager kernel: [23029.548874] ------------[ cut here ]------------</div><d=
iv>Nov 14 17:06:40 steinhager kernel: [23029.548951] WARNING: CPU: 0 PID: 0=
 at kernel/watchdog.c:267 watchdog_overflow_callback+0x92/0x9d()</div><div>=
Nov 14 17:06:40 steinhager kernel: [23029.549041] Watchdog detected hard LO=
CKUP on cpu 0</div><div>Nov 14 17:06:40 steinhager kernel: [23029.549094] M=
odules linked in: dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_=
bufio libcrc32c raid456 async_raid6_recov async_memcpy async_pq async_xor x=
or async_tx raid6_pq raid0 raid1 md_mod coretemp kvm_intel kvm snd_pcm iTCO=
_wdt snd_timer snd i7core_edac ioatdma psmouse edac_core iTCO_vendor_suppor=
t ipmi_si soundcore lpc_ich mfd_core i2c_i801 evdev pcspkr serio_raw microc=
ode ipmi_msghandler ehci_pci button acpi_cpufreq processor thermal_sys ext4=
 crc16 jbd2 mbcache dm_mod sr_mod cdrom sg sd_mod crc_t10dif crct10dif_comm=
on crc32c_intel uhci_hcd firewire_ohci ehci_hcd ata_generic ahci firewire_c=
ore libahci pata_jmicron crc_itu_t usbcore libata usb_common megaraid_sas i=
gb i2c_algo_bit i2c_core dca ptp pps_core scsi_mod [last unloaded: dm_cache=
]</div><div>Nov 14 17:06:40 steinhager kernel: [23029.552866] CPU: 0 PID: 0=
 Comm: swapper/0 Tainted: G =C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0 =C2=A0 =C2=
=A03.17.2 #2</div><div>Nov 14 17:06:40 steinhager kernel: [23029.552938] Ha=
rdware name: <a href=3D"http://SGI.COM" target=3D"_blank">SGI.COM</a> C3108=
-TY11/X8DAH, BIOS 1.1 =C2=A0 =C2=A0 03/16/2011</div><div>Nov 14 17:06:40 st=
einhager kernel: [23029.553010] =C2=A00000000000000006 ffffffff813940f8 fff=
f8801bfc06ca0 ffffffff8103cb84</div><div>Nov 14 17:06:40 steinhager kernel:=
 [23029.553270] =C2=A0ffffffff810aa484 ffff8801b911e400 ffff8801bfc06cf8 ff=
ff8801bfc06d90</div><div>Nov 14 17:06:40 steinhager kernel: [23029.553530] =
=C2=A0ffff8801bfc06ef8 ffffffff8103cbdc ffffffff8150ddf9 0000000000000020</=
div><div>Nov 14 17:06:40 steinhager kernel: [23029.553790] Call Trace:</div=
><div>Nov 14 17:06:40 steinhager kernel: [23029.553853] =C2=A0&lt;NMI&gt; =
=C2=A0[&lt;ffffffff813940f8&gt;] ? dump_stack+0x41/0x51</div><div>Nov 14 17=
:06:40 steinhager kernel: [23029.554016] =C2=A0[&lt;ffffffff8103cb84&gt;] ?=
 warn_slowpath_common+0x74/0x89</div><div>Nov 14 17:06:40Write failed: Conn=
ection reset by peer</div></div></div>
</div><br></div>

--001a11c35626396b9105080ebc08--


--===============5507507147964933178==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5507507147964933178==--
