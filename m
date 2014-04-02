From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH 8/9] dm crypt: offload writes to thread
Date: Wed, 02 Apr 2014 08:55:30 +0200
Message-ID: <533BB462.2020501@redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>	<1396037476-26595-9-git-send-email-snitzer@redhat.com>	<533AE8DC.5080004@redhat.com>
	<20140401163247.GF13050@redhat.com>
	<alpine.LRH.2.02.1404011411100.12362@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1404011411100.12362@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 04/01/2014 08:15 PM, Mikulas Patocka wrote:
>
> ... or try it without XFS. XFS corrupts memory on I/O error
> (https://bugzilla.redhat.com/show_bug.cgi?id=924301), so it may be that.
>
> Can the bug be reproduced if you modify the test to use ext2, ext3 or ext4
> instead of xfs?

It can, I crashed the machine also with ext4, testing the <sort> 
dm-crypt module:

[51218.996332] EXT4-fs (dm-3): mounted filesystem with ordered data 
mode. Opts: barrier=1
[51256.820147] device-mapper: crypt: bio_add_page failed for page 14: 
the underlying device has stricter limits than dm-crypt target
[51256.831928] EXT4-fs warning (device dm-3): ext4_end_bio:317: I/O 
error writing to inode 1443581 (offset 8388608 size 1380352 starting 
block 112320)
[51256.845215] Buffer I/O error on device dm-3, logical block 112320
[51256.851450] Buffer I/O error on device dm-3, logical block 112321
[51256.857640] Buffer I/O error on device dm-3, logical block 112322
[51256.863845] Buffer I/O error on device dm-3, logical block 112323
[51256.870039] Buffer I/O error on device dm-3, logical block 112324
[51256.876197] Buffer I/O error on device dm-3, logical block 112325
[51256.882382] Buffer I/O error on device dm-3, logical block 112326
[51256.888528] Buffer I/O error on device dm-3, logical block 112327
[51256.894732] Buffer I/O error on device dm-3, logical block 112328
[51256.900909] Buffer I/O error on device dm-3, logical block 112329
[51307.584415] device-mapper: crypt: bio_add_page failed for page 8: the 
underlying device has stricter limits than dm-crypt target
[51307.596042] EXT4-fs warning (device dm-3): ext4_end_bio:317: I/O 
error writing to inode 1839894 (offset 0 size 8388608 starting block 194304)
[51307.599959] device-mapper: crypt: bio_add_page failed for page 3: the 
underlying device has stricter limits than dm-crypt target
[51307.599985] EXT4-fs warning (device dm-3): ext4_end_bio:317: I/O 
error writing to inode 1839894 (offset 8388608 size 6574080 starting 
block 196832)
[51307.599988] buffer_io_error: 6 callbacks suppressed
[51307.599991] Buffer I/O error on device dm-3, logical block 196832
[51307.600023] Buffer I/O error on device dm-3, logical block 196833
[51307.600026] Buffer I/O error on device dm-3, logical block 196834
[51307.600028] Buffer I/O error on device dm-3, logical block 196835
[51307.600031] Buffer I/O error on device dm-3, logical block 196836
[51307.600034] Buffer I/O error on device dm-3, logical block 196837
[51307.600036] Buffer I/O error on device dm-3, logical block 196838
[51307.600039] Buffer I/O error on device dm-3, logical block 196839
[51307.600041] Buffer I/O error on device dm-3, logical block 196840
[51307.600044] Buffer I/O error on device dm-3, logical block 196841
[51307.600088] device-mapper: crypt: bio_add_page failed for page 2: the 
underlying device has stricter limits than dm-crypt target
[51307.600096] EXT4-fs warning (device dm-3): ext4_end_bio:317: I/O 
error writing to inode 1839894 (offset 8388608 size 6574080 starting 
block 196848)
[51307.600144] device-mapper: crypt: bio_add_page failed for page 1: the 
underlying device has stricter limits than dm-crypt target
[51307.600149] EXT4-fs warning (device dm-3): ext4_end_bio:317: I/O 
error writing to inode 1839894 (offset 8388608 size 6574080 starting 
block 196864)
[51307.748969] device-mapper: crypt: bio_add_page failed for page 1: the 
underlying device has stricter limits than dm-crypt target
[51307.760717] page:ffffea000447a040 count:0 mapcount:0 mapping: 
   (null) index:0x2
[51307.768791] page flags: 0x2fffff80000000()
[51307.773039] ------------[ cut here ]------------
[51307.774020] kernel BUG at include/linux/mm.h:307!
[51307.774020] invalid opcode: 0000 [#1] SMP
[51307.774020] Modules linked in: dm_crypt(F) ext4 mbcache jbd2 
crypto_null cfg80211 sg rfkill iTCO_wdt iTCO_vendor_support ppdev 
raid456 async_raid6_recov async_memcpy async_pq dcdbas raid6_pq 
async_xor xor async_tx pcspkr lpc_ich serio_raw mfd_core nfsd e1000 
e752x_edac edac_core ipmi_si ipmi_msghandler shpchp parport_pc video 
parport auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod crc_t10dif 
crct10dif_common radeon sr_mod cdrom ata_generic pata_acpi i2c_algo_bit 
drm_kms_helper ttm drm ata_piix libata mptspi scsi_transport_spi 
mptscsih mptbase i2c_core floppy dm_mirror dm_region_hash dm_log dm_mod 
[last unloaded: dm_crypt]
[51307.812279] CPU: 1 PID: 296 Comm: kworker/u16:2 Tainted: GF 
   3.14.0-rc8 #3
[51307.812279] Hardware name: Dell Computer Corporation PowerEdge 
2800/0C8306, BIOS A07 04/25/2008
[51307.812279] Workqueue: kcryptd kcryptd_crypt [dm_crypt]
[51307.812279] task: ffff880034e76a80 ti: ffff880035058000 task.ti: 
ffff880035058000
[51307.812279] RIP: 0010:[<ffffffff81167748>]  [<ffffffff81167748>] 
__free_pages+0x68/0x70
[51307.812279] RSP: 0018:ffff880035059d08  EFLAGS: 00010246
[51307.812279] RAX: 0000000000000000 RBX: ffffea000447a040 RCX: 
0000000000000000
[51307.812279] RDX: 0000000000000000 RSI: ffff88011fc4e6c8 RDI: 
000000000111e810
[51307.812279] RBP: ffff880035059d18 R08: 0000000000000086 R09: 
0000000000000415
[51307.812279] R10: 0000000000000414 R11: 0000000000000003 R12: 
ffffea000447a040
[51307.812279] R13: ffff880090911870 R14: ffff8800c2dfdb18 R15: 
0000000000000000
[51307.812279] FS:  0000000000000000(0000) GS:ffff88011fc40000(0000) 
knlGS:0000000000000000
[51307.812279] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[51307.812279] CR2: 00007fed2e62e000 CR3: 000000000b472000 CR4: 
00000000000007e0
[51307.812279] Stack:
[51307.812279]  ffff8800da671720 ffffea000447a040 ffff880035059d28 
ffffffff811617ae
[51307.812279]  ffff880035059d50 ffffffff81161a29 ffff880090911920 
0000000000000002
[51307.812279]  ffff880090911870 ffff880035059d80 ffffffffa04dec48 
ffff880090911800
[51307.812279] Call Trace:
[51307.812279]  [<ffffffff811617ae>] mempool_free_pages+0xe/0x10
[51307.812279]  [<ffffffff81161a29>] mempool_free+0x49/0x90
[51307.812279]  [<ffffffffa04dec48>] 
crypt_free_buffer_pages.isra.12+0x48/0x70 [dm_crypt]
[51307.812279]  [<ffffffffa04e0874>] kcryptd_crypt+0x224/0x3d0 [dm_crypt]
[51307.812279]  [<ffffffff8108d1eb>] process_one_work+0x17b/0x460
[51307.812279]  [<ffffffff8108dfbb>] worker_thread+0x11b/0x400
[51307.812279]  [<ffffffff8108dea0>] ? rescuer_thread+0x400/0x400
[51307.812279]  [<ffffffff81095001>] kthread+0xe1/0x100
[51307.812279]  [<ffffffff81094f20>] ? kthread_create_on_node+0x1a0/0x1a0
[51307.812279]  [<ffffffff816392bc>] ret_from_fork+0x7c/0xb0
[51307.812279]  [<ffffffff81094f20>] ? kthread_create_on_node+0x1a0/0x1a0
[51307.812279] Code: de 44 89 e6 48 89 df e8 f7 f2 ff ff 5b 41 5c 5d c3 
66 90 48 89 df 31 f6 e8 c6 fd ff ff 5b 41 5c 5d c3 31 d2 31 f6 e8 48 e5 
ff ff <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb
[51307.812279] RIP  [<ffffffff81167748>] __free_pages+0x68/0x70
[51307.812279]  RSP <ffff880035059d08>
[51308.080891] ---[ end trace 12e540e796d165e2 ]---
