From: Mikulas Patocka <mpatocka@redhat.com>
Subject: crash in dm-raid
Date: Wed, 25 Jul 2018 12:20:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1807251213190.9722@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I've got this crash in dm-raid when running the lvm testsuide (the failed 
test was shell/lvconvert-raid.sh ), but it is not reproducible, it doesn't 
crash when I re-run the test.

The crash happens when reading "conf->max_nr_stripes" because the pointer 
"conf" is invalid.

Mikulas


[ 1604.156977] Unable to handle kernel paging request at virtual address ffffffc09ad4b0e8
[ 1604.158301] Mem abort info:
[ 1604.158800]   ESR = 0x96000007
[ 1604.159338]   Exception class = DABT (current EL), IL = 32 bits
[ 1604.160351]   SET = 0, FnV = 0
[ 1604.160902]   EA = 0, S1PTW = 0
[ 1604.161456] Data abort info:
[ 1604.161968]   ISV = 0, ISS = 0x00000007
[ 1604.162643]   CM = 0, WnR = 0
[ 1604.163171] swapper pgtable: 4k pages, 39-bit VAs, pgdp = 000000002d13e6e0
[ 1604.164368] [ffffffc09ad4b0e8] pgd=00000000ffbf7803, pud=00000000ffbf7803, pmd=00000000ffb20803, pte=00e80000dad4b712
[ 1604.166310] Internal error: Oops: 96000007 [#1] PREEMPT SMP
[ 1604.167737] Modules linked in: brd raid0 raid10 dm_delay xfs algif_skcipher af_alg reiserfs loop dm_crypt hmac dm_zero dm_integrity raid1 dm_raid raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx md_mod dm_thin_pool dm_cache_smq dm_cache dm_persistent_data dm_bio_prison libcrc32c dm_mirror dm_region_hash dm_log dm_snapshot dm_bufio dm_mod ipv6 autofs4 binfmt_misc nls_utf8 nls_cp852 vfat fat af_packet aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce crct10dif_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 virtio_rng rng_core virtio_net sha1_ce net_failover failover sha1_generic virtio_console efivars ext4 crc32c_generic crc16 mbcache jbd2 virtio_scsi sd_mod scsi_mod virtio_blk virtio_mmio virtio_pci virtio_ring virtio [last unloaded: brd]
[ 1604.182770] CPU: 1 PID: 13967 Comm: lvm Not tainted 4.18.0-rc6 #9
[ 1604.184276] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 1604.185936] pstate: 40000005 (nZcv daif -PAN -UAO)
[ 1604.186974] pc : raid_status+0x30/0xb48 [dm_raid]
[ 1604.188011] lr : retrieve_status+0x134/0x17c [dm_mod]
[ 1604.189093] sp : ffffffc099b13ae0
[ 1604.189814] x29: ffffffc099b13ae0 x28: ffffffc09a8cc138
[ 1604.190963] x27: ffffffc09b31cc00 x26: 0000000000000001
[ 1604.192105] x25: 0000000000000000 x24: ffffffc09a8cc160
[ 1604.193246] x23: 0000000000000000 x22: ffffffc09a8cc160
[ 1604.194393] x21: 0000000000003ea0 x20: ffffffc0ba8ae000
[ 1604.195532] x19: ffffffc09a8cc000 x18: 0000007fd496d547
[ 1604.196673] x17: 0000007f9a001c90 x16: ffffff800819f62c
[ 1604.197816] x15: 000000000000000a x14: 66424c4d6f6e4339
[ 1604.198955] x13: 4f61653149485946 x12: 5946427864495448
[ 1604.200093] x11: 516b676a4c314f58 x10: 4c4b4c4e7374564b
[ 1604.201237] x9 : 0000000000000001 x8 : ffffff80008c53c0
[ 1604.202376] x7 : ffffff800e94c040 x6 : ffffff80006e9fec
[ 1604.203515] x5 : 0000000000000000 x4 : 0000000000003ea0
[ 1604.204658] x3 : ffffffc09a8cc160 x2 : 0000000000000000
[ 1604.205797] x1 : 0000000000000001 x0 : ffffffc09ad4af00
[ 1604.206937] Process lvm (pid: 13967, stack limit = 0x00000000744ba109)
[ 1604.208331] Call trace:
[ 1604.208877]  raid_status+0x30/0xb48 [dm_raid]
[ 1604.209824]  retrieve_status+0x134/0x17c [dm_mod]
[ 1604.210852]  table_status+0x50/0x80 [dm_mod]
[ 1604.211779]  ctl_ioctl+0x368/0x4e4 [dm_mod]
[ 1604.212691]  dm_ctl_ioctl+0xc/0x18 [dm_mod]
[ 1604.213597]  vfs_ioctl+0x24/0x40
[ 1604.214307]  do_vfs_ioctl+0x90/0x840
[ 1604.215082]  ksys_ioctl+0x44/0x74
[ 1604.215804]  sys_ioctl+0xc/0x18
[ 1604.216487]  el0_svc_naked+0x30/0x34
[ 1604.217273] Code: a90573fb f9402014 f9403680 b4002900 (b941e818)
[ 1604.218572] ---[ end trace 87e40c60d8cf964d ]---
[ 1604.354618] Unable to handle kernel paging request at virtual address ffffffc09ad4b0e8
[ 1604.355772] Mem abort info:
[ 1604.356177]   ESR = 0x96000007
[ 1604.356808]   Exception class = DABT (current EL), IL = 32 bits
[ 1604.357676]   SET = 0, FnV = 0
[ 1604.358110]   EA = 0, S1PTW = 0
[ 1604.358555] Data abort info:
[ 1604.358965]   ISV = 0, ISS = 0x00000007
[ 1604.359574]   CM = 0, WnR = 0
[ 1604.359998] swapper pgtable: 4k pages, 39-bit VAs, pgdp = 000000002d13e6e0
[ 1604.360954] [ffffffc09ad4b0e8] pgd=00000000ffbf7803, pud=00000000ffbf7803, pmd=00000000ffb20803, pte=00e80000dad4b712
[ 1604.362409] Internal error: Oops: 96000007 [#2] PREEMPT SMP
[ 1604.363176] Modules linked in: brd raid0 raid10 dm_delay xfs algif_skcipher af_alg reiserfs loop dm_crypt hmac dm_zero dm_integrity raid1 dm_raid raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx md_mod dm_thin_pool dm_cache_smq dm_cache dm_persistent_data dm_bio_prison libcrc32c dm_mirror dm_region_hash dm_log dm_snapshot dm_bufio dm_mod ipv6 autofs4 binfmt_misc nls_utf8 nls_cp852 vfat fat af_packet aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce crct10dif_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 virtio_rng rng_core virtio_net sha1_ce net_failover failover sha1_generic virtio_console efivars ext4 crc32c_generic crc16 mbcache jbd2 virtio_scsi sd_mod scsi_mod virtio_blk virtio_mmio virtio_pci virtio_ring virtio [last unloaded: brd]
[ 1604.375131] CPU: 3 PID: 13977 Comm: dmsetup Tainted: G      D           4.18.0-rc6 #9
[ 1604.376636] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 1604.377968] pstate: 40000005 (nZcv daif -PAN -UAO)
[ 1604.378904] pc : raid_status+0x30/0xb48 [dm_raid]
[ 1604.379861] lr : retrieve_status+0x134/0x17c [dm_mod]
[ 1604.380848] sp : ffffffc09c8e3ae0
[ 1604.381500] x29: ffffffc09c8e3ae0 x28: ffffffc09c888138
[ 1604.382531] x27: ffffffc09b31cc00 x26: 0000000000000001
[ 1604.383563] x25: 0000000000000000 x24: ffffffc09c888160
[ 1604.384605] x23: 0000000000000000 x22: ffffffc09c888160
[ 1604.385634] x21: 0000000000003ea0 x20: ffffffc0ba8ae000
[ 1604.386664] x19: ffffffc09c888000 x18: 0000007f935e2a70
[ 1604.387706] x17: 0000007f93555c90 x16: ffffff800819f62c
[ 1604.388735] x15: 1f444e014054032d x14: 66424c4d6f6e4339
[ 1604.389763] x13: 4f61653149485946 x12: 5946427864495448
[ 1604.390800] x11: 516b676a4c314f58 x10: 4c4b4c4e7374564b
[ 1604.391828] x9 : 0000000000000000 x8 : ffffff80008c53c0
[ 1604.392861] x7 : ffffff800e94c040 x6 : ffffff80006e9fec
[ 1604.393904] x5 : 0000000000000000 x4 : 0000000000003ea0
[ 1604.394933] x3 : ffffffc09c888160 x2 : 0000000000000000
[ 1604.395958] x1 : 0000000000000001 x0 : ffffffc09ad4af00
[ 1604.396989] Process dmsetup (pid: 13977, stack limit = 0x00000000502f5fe3)
[ 1604.398311] Call trace:
[ 1604.398811]  raid_status+0x30/0xb48 [dm_raid]
[ 1604.399698]  retrieve_status+0x134/0x17c [dm_mod]
[ 1604.400677]  table_status+0x50/0x80 [dm_mod]
[ 1604.401518]  ctl_ioctl+0x368/0x4e4 [dm_mod]
[ 1604.402338]  dm_ctl_ioctl+0xc/0x18 [dm_mod]
[ 1604.403153]  vfs_ioctl+0x24/0x40
[ 1604.403795]  do_vfs_ioctl+0x90/0x840
[ 1604.404498]  ksys_ioctl+0x44/0x74
[ 1604.405149]  sys_ioctl+0xc/0x18
[ 1604.405769]  el0_svc_naked+0x30/0x34
[ 1604.406469] Code: a90573fb f9402014 f9403680 b4002900 (b941e818)
[ 1604.407643] ---[ end trace 87e40c60d8cf964e ]---
[ 1604.437377] Unable to handle kernel paging request at virtual address ffffffc09ad4b0e8
[ 1604.438520] Mem abort info:
[ 1604.438924]   ESR = 0x96000007
[ 1604.439361]   Exception class = DABT (current EL), IL = 32 bits
[ 1604.440184]   SET = 0, FnV = 0
[ 1604.440634]   EA = 0, S1PTW = 0
[ 1604.441083] Data abort info:
[ 1604.441496]   ISV = 0, ISS = 0x00000007
[ 1604.442038]   CM = 0, WnR = 0
[ 1604.442463] swapper pgtable: 4k pages, 39-bit VAs, pgdp = 000000002d13e6e0
[ 1604.443513] [ffffffc09ad4b0e8] pgd=00000000ffbf7803, pud=00000000ffbf7803, pmd=00000000ffb20803, pte=00e80000dad4b712
[ 1604.444990] Internal error: Oops: 96000007 [#3] PREEMPT SMP
[ 1604.445764] Modules linked in: brd raid0 raid10 dm_delay xfs algif_skcipher af_alg reiserfs loop dm_crypt hmac dm_zero dm_integrity raid1 dm_raid raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx md_mod dm_thin_pool dm_cache_smq dm_cache dm_persistent_data dm_bio_prison libcrc32c dm_mirror dm_region_hash dm_log dm_snapshot dm_bufio dm_mod ipv6 autofs4 binfmt_misc nls_utf8 nls_cp852 vfat fat af_packet aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce crct10dif_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 virtio_rng rng_core virtio_net sha1_ce net_failover failover sha1_generic virtio_console efivars ext4 crc32c_generic crc16 mbcache jbd2 virtio_scsi sd_mod scsi_mod virtio_blk virtio_mmio virtio_pci virtio_ring virtio [last unloaded: brd]
[ 1604.458985] CPU: 2 PID: 13983 Comm: dmsetup Tainted: G      D           4.18.0-rc6 #9
[ 1604.460646] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 1604.462084] pstate: 40000005 (nZcv daif -PAN -UAO)
[ 1604.463108] pc : raid_status+0x30/0xb48 [dm_raid]
[ 1604.464130] lr : retrieve_status+0x134/0x17c [dm_mod]
[ 1604.465197] sp : ffffffc09c8e3ae0
[ 1604.465907] x29: ffffffc09c8e3ae0 x28: ffffffc0b36e8138
[ 1604.467029] x27: ffffffc09b31cc00 x26: 0000000000000001
[ 1604.468166] x25: 0000000000000000 x24: ffffffc0b36e8160
[ 1604.469292] x23: 0000000000000000 x22: ffffffc0b36e8160
[ 1604.470417] x21: 0000000000003ea0 x20: ffffffc0ba8ae000
[ 1604.471553] x19: ffffffc0b36e8000 x18: 0000007f8c039a70
[ 1604.472678] x17: 0000007f8bfacc90 x16: ffffff800819f62c
[ 1604.473812] x15: 1f444e014054032d x14: 66424c4d6f6e4339
[ 1604.474939] x13: 4f61653149485946 x12: 5946427864495448
[ 1604.476138] x11: 516b676a4c314f58 x10: 4c4b4c4e7374564b
[ 1604.477284] x9 : 0000000000000000 x8 : ffffff80008c53c0
[ 1604.478416] x7 : ffffff800e94c040 x6 : ffffff80006e9fec
[ 1604.479546] x5 : 0000000000000000 x4 : 0000000000003ea0
[ 1604.480687] x3 : ffffffc0b36e8160 x2 : 0000000000000000
[ 1604.481817] x1 : 0000000000000001 x0 : ffffffc09ad4af00
[ 1604.482949] Process dmsetup (pid: 13983, stack limit = 0x00000000502f5fe3)
[ 1604.484401] Call trace:
[ 1604.484944]  raid_status+0x30/0xb48 [dm_raid]
[ 1604.485885]  retrieve_status+0x134/0x17c [dm_mod]
[ 1604.486899]  table_status+0x50/0x80 [dm_mod]
[ 1604.487832]  ctl_ioctl+0x368/0x4e4 [dm_mod]
[ 1604.488738]  dm_ctl_ioctl+0xc/0x18 [dm_mod]
[ 1604.489637]  vfs_ioctl+0x24/0x40
[ 1604.490338]  do_vfs_ioctl+0x90/0x840
[ 1604.491122]  ksys_ioctl+0x44/0x74
[ 1604.491848]  sys_ioctl+0xc/0x18
[ 1604.492532]  el0_svc_naked+0x30/0x34
[ 1604.493370] Code: a90573fb f9402014 f9403680 b4002900 (b941e818)
[ 1604.494668] ---[ end trace 87e40c60d8cf964f ]---
[ 1604.523171] Unable to handle kernel paging request at virtual address ffffffc09ad4b0e8
[ 1604.524346] Mem abort info:
[ 1604.524750]   ESR = 0x96000007
[ 1604.525189]   Exception class = DABT (current EL), IL = 32 bits
[ 1604.526016]   SET = 0, FnV = 0
[ 1604.526556]   EA = 0, S1PTW = 0
[ 1604.527023] Data abort info:
[ 1604.527444]   ISV = 0, ISS = 0x00000007
[ 1604.527982]   CM = 0, WnR = 0
[ 1604.528408] swapper pgtable: 4k pages, 39-bit VAs, pgdp = 000000002d13e6e0
[ 1604.529345] [ffffffc09ad4b0e8] pgd=00000000ffbf7803, pud=00000000ffbf7803, pmd=00000000ffb20803, pte=00e80000dad4b712
[ 1604.530818] Internal error: Oops: 96000007 [#4] PREEMPT SMP
[ 1604.531578] Modules linked in: brd raid0 raid10 dm_delay xfs algif_skcipher af_alg reiserfs loop dm_crypt hmac dm_zero dm_integrity raid1 dm_raid raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx md_mod dm_thin_pool dm_cache_smq dm_cache dm_persistent_data dm_bio_prison libcrc32c dm_mirror dm_region_hash dm_log dm_snapshot dm_bufio dm_mod ipv6 autofs4 binfmt_misc nls_utf8 nls_cp852 vfat fat af_packet aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce crct10dif_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 virtio_rng rng_core virtio_net sha1_ce net_failover failover sha1_generic virtio_console efivars ext4 crc32c_generic crc16 mbcache jbd2 virtio_scsi sd_mod scsi_mod virtio_blk virtio_mmio virtio_pci virtio_ring virtio [last unloaded: brd]
[ 1604.542988] CPU: 2 PID: 13993 Comm: dmsetup Tainted: G      D           4.18.0-rc6 #9
[ 1604.544495] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 1604.545812] pstate: 40000005 (nZcv daif -PAN -UAO)
[ 1604.546746] pc : raid_status+0x30/0xb48 [dm_raid]
[ 1604.547678] lr : retrieve_status+0x134/0x17c [dm_mod]
[ 1604.548652] sp : ffffffc09c8e3ae0
[ 1604.549307] x29: ffffffc09c8e3ae0 x28: ffffffc098174138
[ 1604.550345] x27: ffffffc09b31cc00 x26: 0000000000000001
[ 1604.551387] x25: 0000000000000000 x24: ffffffc098174160
[ 1604.552420] x23: 0000000000000000 x22: ffffffc098174160
[ 1604.553463] x21: 0000000000003ea0 x20: ffffffc0ba8ae000
[ 1604.554513] x19: ffffffc098174000 x18: 0000007f99cd8a70
[ 1604.555541] x17: 0000007f99c4bc90 x16: ffffff800819f62c
[ 1604.556563] x15: 1f444e014054032d x14: 66424c4d6f6e4339
[ 1604.557598] x13: 4f61653149485946 x12: 5946427864495448
[ 1604.558622] x11: 516b676a4c314f58 x10: 4c4b4c4e7374564b
[ 1604.559653] x9 : 0000000000000000 x8 : ffffff80008c53c0
[ 1604.560693] x7 : ffffff800e94c040 x6 : ffffff80006e9fec
[ 1604.561720] x5 : 0000000000000000 x4 : 0000000000003ea0
[ 1604.562745] x3 : ffffffc098174160 x2 : 0000000000000000
[ 1604.563778] x1 : 0000000000000001 x0 : ffffffc09ad4af00
[ 1604.564808] Process dmsetup (pid: 13993, stack limit = 0x00000000502f5fe3)
[ 1604.566121] Call trace:
[ 1604.566616]  raid_status+0x30/0xb48 [dm_raid]
[ 1604.567486]  retrieve_status+0x134/0x17c [dm_mod]
[ 1604.568408]  table_status+0x50/0x80 [dm_mod]
[ 1604.569245]  ctl_ioctl+0x368/0x4e4 [dm_mod]
[ 1604.570067]  dm_ctl_ioctl+0xc/0x18 [dm_mod]
[ 1604.570890]  vfs_ioctl+0x24/0x40
[ 1604.571526]  do_vfs_ioctl+0x90/0x840
[ 1604.572226]  ksys_ioctl+0x44/0x74
[ 1604.572878]  sys_ioctl+0xc/0x18
[ 1604.573497]  el0_svc_naked+0x30/0x34
[ 1604.574202] Code: a90573fb f9402014 f9403680 b4002900 (b941e818)
[ 1604.575387] ---[ end trace 87e40c60d8cf9650 ]---
[ 1604.613071] Unable to handle kernel paging request at virtual address ffffffc09ad4b0e8
[ 1604.621438] Mem abort info:
[ 1604.623952]   ESR = 0x96000007
[ 1604.626479]   Exception class = DABT (current EL), IL = 32 bits
[ 1604.627332]   SET = 0, FnV = 0
[ 1604.627782]   EA = 0, S1PTW = 0
[ 1604.628238] Data abort info:
[ 1604.628662]   ISV = 0, ISS = 0x00000007
[ 1604.629215]   CM = 0, WnR = 0
[ 1604.629653] swapper pgtable: 4k pages, 39-bit VAs, pgdp = 000000002d13e6e0
[ 1604.630643] [ffffffc09ad4b0e8] pgd=00000000ffbf7803, pud=00000000ffbf7803, pmd=00000000ffb20803, pte=00e80000dad4b712
[ 1604.632148] Internal error: Oops: 96000007 [#5] PREEMPT SMP
[ 1604.632942] Modules linked in: brd raid0 raid10 dm_delay xfs algif_skcipher af_alg reiserfs loop dm_crypt hmac dm_zero dm_integrity raid1 dm_raid raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx md_mod dm_thin_pool dm_cache_smq dm_cache dm_persistent_data dm_bio_prison libcrc32c dm_mirror dm_region_hash dm_log dm_snapshot dm_bufio dm_mod ipv6 autofs4 binfmt_misc nls_utf8 nls_cp852 vfat fat af_packet aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce crct10dif_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 virtio_rng rng_core virtio_net sha1_ce net_failover failover sha1_generic virtio_console efivars ext4 crc32c_generic crc16 mbcache jbd2 virtio_scsi sd_mod scsi_mod virtio_blk virtio_mmio virtio_pci virtio_ring virtio [last unloaded: brd]
[ 1604.645991] CPU: 1 PID: 14007 Comm: dmsetup Tainted: G      D           4.18.0-rc6 #9
[ 1604.647681] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 1604.649162] pstate: 40000005 (nZcv daif -PAN -UAO)
[ 1604.650215] pc : raid_status+0x30/0xb48 [dm_raid]
[ 1604.651271] lr : retrieve_status+0x134/0x17c [dm_mod]
[ 1604.652372] sp : ffffffc09c8e3ae0
[ 1604.653104] x29: ffffffc09c8e3ae0 x28: ffffffc098184138
[ 1604.654274] x27: ffffffc09b31cc00 x26: 0000000000000001
[ 1604.655432] x25: 0000000000000000 x24: ffffffc098184160
[ 1604.656583] x23: 0000000000000000 x22: ffffffc098184160
[ 1604.657750] x21: 0000000000003ea0 x20: ffffffc0ba8ae000
[ 1604.658902] x19: ffffffc098184000 x18: 0000007fadd4ea70
[ 1604.660055] x17: 0000007fadcc1c90 x16: ffffff800819f62c
[ 1604.661217] x15: 1f444e014054032d x14: 66424c4d6f6e4339
[ 1604.662370] x13: 4f61653149485946 x12: 5946427864495448
[ 1604.663517] x11: 516b676a4c314f58 x10: 4c4b4c4e7374564b
[ 1604.664674] x9 : 0000000000000000 x8 : ffffff80008c53c0
[ 1604.665824] x7 : ffffff800e94c040 x6 : ffffff80006e9fec
[ 1604.666973] x5 : 0000000000000000 x4 : 0000000000003ea0
[ 1604.668136] x3 : ffffffc098184160 x2 : 0000000000000000
[ 1604.669286] x1 : 0000000000000000 x0 : ffffffc09ad4af00
[ 1604.670455] Process dmsetup (pid: 14007, stack limit = 0x00000000502f5fe3)
[ 1604.671933] Call trace:
[ 1604.672489]  raid_status+0x30/0xb48 [dm_raid]
[ 1604.673454]  retrieve_status+0x134/0x17c [dm_mod]
[ 1604.674555]  table_status+0x50/0x80 [dm_mod]
[ 1604.675552]  ctl_ioctl+0x368/0x4e4 [dm_mod]
[ 1604.676477]  dm_ctl_ioctl+0xc/0x18 [dm_mod]
[ 1604.677406]  vfs_ioctl+0x24/0x40
[ 1604.678120]  do_vfs_ioctl+0x90/0x840
[ 1604.678905]  ksys_ioctl+0x44/0x74
[ 1604.679634]  sys_ioctl+0xc/0x18
[ 1604.680330]  el0_svc_naked+0x30/0x34
[ 1604.681130] Code: a90573fb f9402014 f9403680 b4002900 (b941e818)
[ 1604.682446] ---[ end trace 87e40c60d8cf9651 ]---
