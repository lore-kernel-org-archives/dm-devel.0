From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: Kernel oops with dm-cache
Date: Sun, 8 Dec 2013 13:01:52 +0100
Message-ID: <20131208120152.GA4096@samfundet.no>
References: <20131208105930.GA3763@sesse.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131208105930.GA3763@sesse.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Dec 08, 2013 at 11:59:30AM +0100, Steinar H. Gunderson wrote:
> I woke up to my machine being crashed during the night; it complained about
> the CPU being hung, but looking a bit closer in the CPU backtraces, it seems
> that one of them had oopsed. I only have parts of this (it's salvaged from
> the serial console), but hopefully it will help someone track it down:

I booted, and within the hour it crashed again. This time I got the full
oops:

[ 4089.472457] Hardware name: Supermicro X8DTL/X8DTL, BIOS 2.1a       12/30/2011
[ 4089.479816] Workqueue: dm-cache do_worker [dm_cache]
[ 4089.485025] task: ffff88061fcc8000 ti: ffff88062099a000 task.ti: ffff88062099a000
[ 4089.492934] RIP: 0010:[<ffffffffa02bb7d4>]  [<ffffffffa02bb7d4>] metadata_ll_load_ie+0x10/0x21 [dm_persistent_data]
[ 4089.503814] RSP: 0018:ffff88062099bb20  EFLAGS: 00010207
[ 4089.509340] RAX: 000404022224d79a RBX: ffff8806168b8070 RCX: 0000000000003fc0
[ 4089.516707] RDX: ffff88062099bb38 RSI: 003fc82838d8fac0 RDI: ffff8806168b8070
[ 4089.524060] RBP: ffff88062099bb68 R08: ffff88062099bc0c R09: ffff88061dc17ab8
[ 4089.531407] R10: 0000000100000000 R11: 0000000000000004 R12: ffff88062099bb84
[ 4089.538754] R13: 0000000000002e80 R14: ffff88062099bc10 R15: ffffffffa02c0c00
[ 4089.546139] FS:  0000000000000000(0000) GS:ffff8806272a0000(0000) knlGS:0000000000000000
[ 4089.554668] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4089.560626] CR2: ffffffffff600400 CR3: 00000000015d3000 CR4: 00000000000007e0
[ 4089.567976] Stack:
[ 4089.570194]  ffffffffa02bbed4 ffff88062099bb38 ffffffff813a859b ffff88062099bb48
[ 4089.578106]  ffffffffa02b00f7 ffff88062099bb68 0000000000000000 ffff88062099bc0c
[ 4089.586006]  ffff8800acb0c800 ffff88062099bb98 ffffffffa02bcc18 ffff88061dc15820
[ 4089.593917] Call Trace:
[ 4089.596583]  [<ffffffffa02bbed4>] ? sm_ll_lookup_bitmap+0x2e/0x7d [dm_persistent_data]
[ 4089.604938]  [<ffffffff813a859b>] ? mutex_unlock+0x9/0xb
[ 4089.610467]  [<ffffffffa02b00f7>] ? dm_bufio_unlock+0x9/0xb [dm_bufio]
[ 4089.617216]  [<ffffffffa02bcc18>] sm_metadata_count_is_more_than_one+0x6a/0x97 [dm_persistent_data]
[ 4089.626684]  [<ffffffffa02bd316>] dm_tm_shadow_block+0x37/0x179 [dm_persistent_data]
[ 4089.634852]  [<ffffffffa02d06b4>] ? set_clean_shutdown+0x14/0x14 [dm_cache]
[ 4089.642060]  [<ffffffffa02bb80f>] metadata_ll_commit+0x2a/0x6b [dm_persistent_data]
[ 4089.650140]  [<ffffffffa02bc158>] sm_ll_commit+0x1a/0x29 [dm_persistent_data]
[ 4089.657502]  [<ffffffffa02bccc7>] sm_metadata_commit+0x16/0x48 [dm_persistent_data]
[ 4089.665584]  [<ffffffffa02bcf9f>] dm_tm_pre_commit+0x13/0x28 [dm_persistent_data]
[ 4089.673502]  [<ffffffffa02d168c>] dm_cache_commit+0x66/0x317 [dm_cache]
[ 4089.680377]  [<ffffffffa02cd7e6>] ? process_migrations+0x6e/0x85 [dm_cache]
[ 4089.687564]  [<ffffffffa02cf637>] do_worker+0x9a9/0xb21 [dm_cache]
[ 4089.693962]  [<ffffffff81054aa2>] process_one_work+0x1e3/0x368
[ 4089.700011]  [<ffffffff8105506b>] worker_thread+0x1cd/0x2c4
[ 4089.705800]  [<ffffffff81054e9e>] ? rescuer_thread+0x24d/0x24d
[ 4089.711852]  [<ffffffff81059aca>] kthread+0xcd/0xd5
[ 4089.716948]  [<ffffffff810599fd>] ? kthread_freezable_should_stop+0x43/0x43
[ 4089.724126]  [<ffffffff813afefc>] ret_from_fork+0x7c/0xb0
[ 4089.729751]  [<ffffffff810599fd>] ? kthread_freezable_should_stop+0x43/0x43
[ 4089.736925] Code: c1 e6 04 48 89 e5 48 01 f7 48 8b 02 48 89 07 48 8b 42 08 48 89 47 08 31 c0 5d c3 48 83 c6 0b 55 48 c1 e6 04 48 89 e5 5d 48 01 fe <48> 8b 06 48 89 02 48 8b 46 08 48 89 42 08 31 c0 c3 55 48 c7 c2
[ 4089.757706] RIP  [<ffffffffa02bb7d4>] metadata_ll_load_ie+0x10/0x21 [dm_persistent_data]
[ 4089.766264]  RSP <ffff88062099bb20>
[ 4089.770361] ---[ end trace 5d8e28243e549ab6 ]---
[ 4089.775333] BUG: unable to handle kernel paging request at ffffffffffffffd8
[ 4089.782683] IP: [<ffffffff81059eb8>] kthread_data+0xc/0x11
[ 4089.788483] PGD 15d4067 PUD 15d6067 PMD 0
[ 4089.793024] Oops: 0000 [#2] SMP
[ 4089.796630] Modules linked in: sha256_generic btrfs lzo_compress ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs ext2 cpuid af_packet 8021q mrp bridge stp llc binfmt_misc fuse ext3 jbd dm_crypt coretemp w83627ehf hwmon_vid cfq_iosched ip_gre gre ip_tunnel ide_generic ide_gd_mod ide_cd_mod cdrom kvm_intel kvm iTCO_wdt iTCO_vendor_support psmouse serio_raw i2c_i801 pcspkr lpc_ich i2c_core mfd_core ehci_pci acpi_cpufreq evbug evdev ext4 crc16 jbd2 mbcache dm_cache_mq dm_cache dm_persistent_data dm_bufio dm_bio_prison crc32c libcrc32c raid0 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 md_mod microcode sg sd_mod usbhid ide_pci_generic ide_core dm_mod e1000e ata_piix ptp pps_core uhci_hcd ehci_hcd mpt2sas raid_class unix
[ 4089.872746] CPU: 13 PID: 1468 Comm: kworker/u48:4 Tainted: G      D      3.13.0-rc3 #1
[ 4089.881127] Hardware name: Supermicro X8DTL/X8DTL, BIOS 2.1a       12/30/2011
[ 4089.888587] task: ffff88061fcc8000 ti: ffff88062099a000 task.ti: ffff88062099a000
[ 4089.896538] RIP: 0010:[<ffffffff81059eb8>]  [<ffffffff81059eb8>] kthread_data+0xc/0x11
[ 4089.904985] RSP: 0018:ffff88062099b820  EFLAGS: 00010002
[ 4089.910555] RAX: 0000000000000000 RBX: 000000000000000d RCX: ffffffff81751080
[ 4089.917945] RDX: 0000000000000001 RSI: 000000000000000d RDI: ffff88061fcc8000
[ 4089.925350] RBP: ffff88062099b838 R08: 000000000000007f R09: 000000000000b5e7
[ 4089.932745] R10: ffffea00188fe780 R11: 000000000000beff R12: 0000000000000001
[ 4089.940132] R13: ffff88061fcc83f8 R14: 000000000000000d R15: ffff88061fcc8300
[ 4089.947521] FS:  0000000000000000(0000) GS:ffff8806273a0000(0000) knlGS:0000000000000000
[ 4089.956067] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4089.962073] CR2: 0000000000000028 CR3: 00000000015d3000 CR4: 00000000000007e0
[ 4089.969467] Stack:
[ 4089.971737]  ffffffff810554bd 000000000000007f ffff8806273b27c0 ffff88062099b958
[ 4089.979926]  ffffffff813a61bd ffff88062099b878 ffff88061fcc8000 00000000000127c0
[ 4089.988036]  0000000000004000 ffff880623808240 ffff88061fcc8000 ffff88062099b8b8
[ 4089.996153] Call Trace:
[ 4089.998858]  [<ffffffff810554bd>] ? wq_worker_sleeping+0xe/0x85
[ 4090.005041]  [<ffffffff813a61bd>] __schedule+0x154/0x8eb
[ 4090.010615]  [<ffffffff811a505b>] ? put_io_context+0x5c/0x82
[ 4090.016529]  [<ffffffff810fc245>] ? kmem_cache_free+0xe9/0x127
[ 4090.022618]  [<ffffffff811a505b>] ? put_io_context+0x5c/0x82
[ 4090.028538]  [<ffffffff811a512e>] ? put_io_context_active+0x99/0xa2
[ 4090.035060]  [<ffffffff813a69f4>] schedule+0x6a/0x6c
[ 4090.040277]  [<ffffffff81041fcb>] do_exit+0x869/0x8c5
[ 4090.045586]  [<ffffffff813aa859>] oops_end+0x7c/0x81
[ 4090.050805]  [<ffffffff81004a32>] die+0x55/0x5f
[ 4090.055593]  [<ffffffff813aa42d>] do_general_protection+0x91/0x139
[ 4090.062027]  [<ffffffff813a9e82>] general_protection+0x22/0x30
[ 4090.068120]  [<ffffffffa02bb7d4>] ? metadata_ll_load_ie+0x10/0x21 [dm_persistent_data]
[ 4090.076562]  [<ffffffffa02bbed4>] ? sm_ll_lookup_bitmap+0x2e/0x7d [dm_persistent_data]
[ 4090.084937]  [<ffffffff813a859b>] ? mutex_unlock+0x9/0xb
[ 4090.090504]  [<ffffffffa02b00f7>] ? dm_bufio_unlock+0x9/0xb [dm_bufio]
[ 4090.097291]  [<ffffffffa02bcc18>] sm_metadata_count_is_more_than_one+0x6a/0x97 [dm_persistent_data]
[ 4090.106802]  [<ffffffffa02bd316>] dm_tm_shadow_block+0x37/0x179 [dm_persistent_data]
[ 4090.115013]  [<ffffffffa02d06b4>] ? set_clean_shutdown+0x14/0x14 [dm_cache]
[ 4090.122244]  [<ffffffffa02bb80f>] metadata_ll_commit+0x2a/0x6b [dm_persistent_data]
[ 4090.130360]  [<ffffffffa02bc158>] sm_ll_commit+0x1a/0x29 [dm_persistent_data]
[ 4090.137760]  [<ffffffffa02bccc7>] sm_metadata_commit+0x16/0x48 [dm_persistent_data]
[ 4090.145879]  [<ffffffffa02bcf9f>] dm_tm_pre_commit+0x13/0x28 [dm_persistent_data]
[ 4090.153831]  [<ffffffffa02d168c>] dm_cache_commit+0x66/0x317 [dm_cache]
[ 4090.160703]  [<ffffffffa02cd7e6>] ? process_migrations+0x6e/0x85 [dm_cache]
[ 4090.167929]  [<ffffffffa02cf637>] do_worker+0x9a9/0xb21 [dm_cache]
[ 4090.174367]  [<ffffffff81054aa2>] process_one_work+0x1e3/0x368
[ 4090.180458]  [<ffffffff8105506b>] worker_thread+0x1cd/0x2c4
[ 4090.186294]  [<ffffffff81054e9e>] ? rescuer_thread+0x24d/0x24d
[ 4090.192387]  [<ffffffff81059aca>] kthread+0xcd/0xd5
[ 4090.197519]  [<ffffffff810599fd>] ? kthread_freezable_should_stop+0x43/0x43
[ 4090.204742]  [<ffffffff813afefc>] ret_from_fork+0x7c/0xb0
[ 4090.210398]  [<ffffffff810599fd>] ? kthread_freezable_should_stop+0x43/0x43
[ 4090.217671] Code: 48 8b 04 25 c0 b7 00 00 48 8b 80 a0 03 00 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 48 8b 87 a0 03 00 00 55 48 89 e5 5d <48> 8b 40 d8 c3 55 ba 08 00 00 00 48 89 e5 48 83 ec 10 48 8b b7
[ 4090.241143] RIP  [<ffffffff81059eb8>] kthread_data+0xc/0x11
[ 4090.247036]  RSP <ffff88062099b820>
[ 4090.250785] CR2: ffffffffffffffd8
[ 4090.254358] ---[ end trace 5d8e28243e549ab7 ]---
[ 4090.259235] Fixing recursive fault but reboot is needed!

When I booted it, it was dead:

[   13.762082] device-mapper: cache-policy-mq: version 1.0.0 loaded
[   13.954485] attempt to access beyond end of device
[   13.959574] dm-0: rw=0, want=18445688565725020168, limit=1048576
[   13.965906] device-mapper: transaction manager: couldn't open metadata space map
[   13.973798] device-mapper: cache metadata: tm_open_with_sm failed
[   14.044225] device-mapper: table: 254:3: cache: Error creating metadata object
[   14.051986] device-mapper: ioctl: error adding target to table

I'll try the tools I was pointed to last time again, but I'm not trusting
cache_dump this time...

/* Steinar */
-- 
Homepage: http://www.sesse.net/
