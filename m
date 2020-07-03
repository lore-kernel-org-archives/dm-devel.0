From: Mikulas Patocka <mpatocka@redhat.com>
Subject: a crash in md-raid
Date: Fri, 3 Jul 2020 08:18:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007030812320.13686@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi

I report a crash in md-raid. I have 5.8-rc3 kernel with debugging enabled. 
The crash happened when running the "shell/integrity-blocksize.sh" lvm 
test.

The crash is not reproducible.

Mikulas


[ 1188.640677] device-mapper: raid: Superblocks created for new raid set
[ 1188.679378] md/raid1:mdX: not clean -- starting background reconstruction
[ 1188.681072] md/raid1:mdX: active with 2 out of 2 mirrors
[ 1189.093707] mdX: bitmap file is out of date, doing full recovery
[ 1189.108688] md: resync of RAID array mdX
[ 1189.341925] Unable to handle kernel paging request at virtual address 006b6b6b6b6b6b73
[ 1189.343183] Mem abort info:
[ 1189.343632]   ESR = 0x96000004
[ 1189.344219]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1189.345012]   SET = 0, FnV = 0
[ 1189.345483]   EA = 0, S1PTW = 0
[ 1189.345998] Data abort info:
[ 1189.346483]   ISV = 0, ISS = 0x00000004
[ 1189.347109]   CM = 0, WnR = 0
[ 1189.347589] [006b6b6b6b6b6b73] address between user and kernel address ranges
[ 1189.348761] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[ 1189.349802] Modules linked in: brd reiserfs hmac crc32_generic dm_zero dm_integrity dm_crypt dm_writecache dm_raid xfs dm_thin_pool dm_cache_smq dm_cache dm_persistent_data dm_bio_prison dm_mirror dm_region_hash dm_log dm_snapshot dm_bufio loop ipv6 autofs4 binfmt_misc nls_utf8 nls_cp852 vfat fat dm_mod af_packet aes_ce_blk crypto_simd cryptd aes_ce_cipher crct10dif_ce ghash_ce gf128mul sha2_ce sha256_arm64 sha1_ce sha1_generic efivars sg virtio_rng virtio_net rng_core net_failover failover virtio_console ext4 crc16 mbcache jbd2 raid10 raid456 libcrc32c crc32c_generic async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor xor_neon async_tx raid1 raid0 linear md_mod sd_mod t10_pi virtio_scsi scsi_mod virtio_blk virtio_mmio virtio_pci virtio_ring virtio [last unloaded: scsi_debug]
 
[ 1189.370709] CPU: 2 PID: 20 Comm: ksoftirqd/2 Not tainted 5.8.0-rc3-debug #1
[ 1189.372088] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 1189.373400] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[ 1189.374492] pc : end_sync_write+0x38/0xf8 [raid1]
[ 1189.375408] lr : bio_endio+0x234/0x238
[ 1189.376134] sp : ffffff80fee87af0
[ 1189.376788] x29: ffffff80fee87af0 x28: 0000000000000004
[ 1189.377817] x27: 0000000000000100 x26: ffffffc010532916
[ 1189.378832] x25: 0000000100015b61 x24: 0000000100015b61
[ 1189.379860] x23: 0000000000000001 x22: ffffffc01062f8e8
[ 1189.380921] x21: 6b6b6b6b6b6b6b6b x20: ffffff80eaaa2058
[ 1189.381967] x19: ffffff80d2e01c00 x18: 0000000000000000
[ 1189.382970] x17: 0000000000000000 x16: 0000000000000000
[ 1189.383994] x15: 0000000000000000 x14: 0000000000000000
[ 1189.385003] x13: 0000000000000000 x12: 0000000000000001
[ 1189.386010] x11: 0000000000000000 x10: 00000000000010f0
[ 1189.387032] x9 : ffffff80f932cf98 x8 : 0000000000000000
[ 1189.388044] x7 : 0000000000000000 x6 : 0000000000000000
[ 1189.389050] x5 : 0000000000000001 x4 : ffffff80fee87aa0
[ 1189.390062] x3 : ffffff8000000000 x2 : 0000000000000001
[ 1189.391088] x1 : ffffff80fa22ca00 x0 : ffffff80d2e01c00
[ 1189.392230] Call trace:
[ 1189.392719]  end_sync_write+0x38/0xf8 [raid1]
[ 1189.393553]  bio_endio+0x234/0x238
[ 1189.394440]  dec_pending+0x1b8/0x1bc [dm_mod]
[ 1189.395307]  clone_endio+0x14c/0x160 [dm_mod]
[ 1189.396155]  bio_endio+0x234/0x238
[ 1189.397602]  blk_update_request+0x2f8/0x418
[ 1189.398473]  blk_mq_end_request+0x20/0x44
[ 1189.400709]  lo_complete_rq+0x5c/0xbc [loop]
[ 1189.401771]  blk_done_softirq+0xbc/0xc0
[ 1189.402564]  efi_header_end+0x368/0x4b8
[ 1189.403559]  run_ksoftirqd+0x34/0x64
[ 1189.404303]  smpboot_thread_fn+0x228/0x22c
[ 1189.405132]  kthread+0x114/0x124
[ 1189.405807]  ret_from_fork+0x10/0x18
[ 1189.406537] Code: f9400013 aa1303e0 f9401274 f9400295 (f94006a8)
[ 1189.414734] ---[ end trace 4538a7676b244523 ]---
[ 1189.415635] Kernel panic - not syncing: Fatal exception in interrupt
[ 1189.416874] SMP: stopping secondary CPUs
[ 1189.417691] Kernel Offset: disabled
[ 1189.418380] CPU features: 0x000022,00002000
[ 1189.419185] Memory Limit: none
[ 1189.419743] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
