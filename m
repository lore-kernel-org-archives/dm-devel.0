From: David Shaw <dshaw@jabberwocky.com>
Subject: Writing to a DM snapshot blocks for a long time
Date: Thu, 16 Aug 2012 13:55:46 -0400
Message-ID: <C1F66088-A72F-40DF-B68D-2858007BD189@jabberwocky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
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

Hello,

I'm seeing some odd behavior using DM snapshots, and I was hoping someone here could help shed some light on it.  What I'm doing is creating a snapshot using DM directly (not through LVM), mounting the snapshot, and then writing to both sides (the mounted snapshot as well as the original filesystem).  The data written to the snapshot goes away after I tear it down, of course.

I managed to get this down to a simple reproduction case.  All this is starting with a LVM VG named "tests", which contains two LVs named "original" and "cow".  The "original" LV is formatted ext4 and mounted on /original.

1) time dd if=/dev/zero bs=16384 count=1 of=/original/zeroes
2) dmsetup suspend tests-original
3) dmsetup table tests-original | dmsetup create tests-original-backup
4) echo 0 `blockdev --getsz /dev/mapper/tests-original` snapshot-origin /dev/mapper/tests-original-backup  | dmsetup reload tests-original
5) echo 0 `blockdev --getsz /dev/mapper/tests-original-backup` snapshot /dev/mapper/tests-original-backup /dev/mapper/tests-cow N 1024 | dmsetup create tests-snap
6) dmsetup resume tests-original
7) mount /dev/mapper/tests-snap /snap

So far so good - original is mounted on /original, the snapshot is mounted on /snap.  Now here comes the problem:

8) time dd if=/dev/zero bs=16384 count=1 of=/snap/zeroes

Writing to the snapshot blocks for a long time (60-180 seconds).  Doing a strace of the dd shows it blocking in write().  Note that /snap/zeroes is overwriting (the snapshot version of) the /original/zeroes file written in step 1.  If this isn't an overwrite (if, for example, the dd wrote to "/snap/a-different-filename"), there is no blocking.  Similarly, there is no problem writing to anything under "/original".

Test cleanup steps that work without any problem:

9) umount /snap
10) dmsetup suspend tests-original
11) dmsetup table tests-original-backup | dmsetup reload tests-original
12) dmsetup remove tests-snap
13) dmsetup resume tests-original
14) dmsetup remove tests-original-backup 

The kernel in question is kernel-PAE-2.6.35.14-97.fc14.i686 (i.e. Fedora 14).  It's running on a Dell R410 with 16 gigs of RAM.  The PV the VG resides on is a 4-disk RAID5 using the Dell PERC 6 RAID card (from the LVM perspective, it just sees a single block device from the card here).

I captured this trace (via 'echo t > /proc/sysrq-trigger') of a cp stuck in write() while writing to the snapshot:

2012-08-14 13:15:39 foobar kernel: [ 6707.239661] cp            D e2059970     0 15809  15803 0x00000000
2012-08-14 13:15:39 foobar kernel: [ 6707.239664]  e20599a0 00000086 afd59283 e2059970 c0ac4f00 c0ac4f00 c0ac4f00 c0ac4f00
2012-08-14 13:15:39 foobar kernel: [ 6707.239668]  c0ac4f00 f210ce4c a6974267 00000619 c0ac4f00 00000000 00000619 f210cbc0
2012-08-14 13:15:39 foobar kernel: [ 6707.239671]  00000001 ce84935c f210cbc0 e20599f0 e20599b0 c07b8ddd e20599e8 00000000
2012-08-14 13:15:39 foobar kernel: [ 6707.239675] Call Trace:
2012-08-14 13:15:39 foobar kernel: [ 6707.239678]  [<c07b8ddd>] io_schedule+0x3c/0x53
2012-08-14 13:15:39 foobar kernel: [ 6707.239680]  [<c04ff5b3>] sync_buffer+0x27/0x2b
2012-08-14 13:15:39 foobar kernel: [ 6707.239682]  [<c07b929c>] __wait_on_bit+0x39/0x60
2012-08-14 13:15:39 foobar kernel: [ 6707.239684]  [<c04ff58c>] ? sync_buffer+0x0/0x2b
2012-08-14 13:15:39 foobar kernel: [ 6707.239687]  [<c07b931f>] out_of_line_wait_on_bit+0x5c/0x64
2012-08-14 13:15:39 foobar kernel: [ 6707.239689]  [<c04ff58c>] ? sync_buffer+0x0/0x2b
2012-08-14 13:15:39 foobar kernel: [ 6707.239692]  [<c045523a>] ? wake_bit_function+0x0/0x52
2012-08-14 13:15:39 foobar kernel: [ 6707.239694]  [<c04ff552>] __wait_on_buffer+0x1e/0x21
2012-08-14 13:15:39 foobar kernel: [ 6707.239698]  [<c055c4b0>] ext4_mb_init_cache+0x20b/0x452
2012-08-14 13:15:39 foobar kernel: [ 6707.239702]  [<c055d0f9>] ext4_mb_init_group+0x9f/0x1a4
2012-08-14 13:15:39 foobar kernel: [ 6707.239705]  [<c055e14d>] ext4_mb_good_group+0x4e/0xc6
2012-08-14 13:15:39 foobar kernel: [ 6707.239708]  [<c055e2db>] ext4_mb_regular_allocator+0x116/0x240
2012-08-14 13:15:39 foobar kernel: [ 6707.239711]  [<c055b5fc>] ? ext4_mb_initialize_context+0x1d4/0x1de
2012-08-14 13:15:39 foobar kernel: [ 6707.239714]  [<c055ee60>] ext4_mb_new_blocks+0x18b/0x390
2012-08-14 13:15:39 foobar kernel: [ 6707.239717]  [<c04d6a89>] ? __raw_local_irq_save+0x19/0x1e
2012-08-14 13:15:39 foobar kernel: [ 6707.239720]  [<c0558724>] ext4_ext_map_blocks+0x12df/0x1547
2012-08-14 13:15:39 foobar kernel: [ 6707.239723]  [<c04b15b5>] ? mempool_alloc_slab+0x13/0x15
2012-08-14 13:15:39 foobar kernel: [ 6707.239725]  [<c04d6a89>] ? __raw_local_irq_save+0x19/0x1e
2012-08-14 13:15:39 foobar kernel: [ 6707.239728]  [<c04d9595>] ? kmem_cache_alloc+0x7c/0xda
2012-08-14 13:15:39 foobar kernel: [ 6707.239730]  [<c0502b01>] ? bio_free+0x4f/0x52
2012-08-14 13:15:39 foobar kernel: [ 6707.239733]  [<c04d6a89>] ? __raw_local_irq_save+0x19/0x1e
2012-08-14 13:15:39 foobar kernel: [ 6707.239735]  [<c04d9595>] ? kmem_cache_alloc+0x7c/0xda
2012-08-14 13:15:39 foobar kernel: [ 6707.239738]  [<c04b15b5>] ? mempool_alloc_slab+0x13/0x15
2012-08-14 13:15:39 foobar kernel: [ 6707.239740]  [<c04b15b5>] ? mempool_alloc_slab+0x13/0x15
2012-08-14 13:15:39 foobar kernel: [ 6707.239742]  [<c04b170e>] ? mempool_alloc+0x5c/0xeb
2012-08-14 13:15:39 foobar kernel: [ 6707.239745]  [<c0542592>] ext4_map_blocks+0x109/0x1c6
2012-08-14 13:15:39 foobar kernel: [ 6707.239747]  [<c05426de>] _ext4_get_block+0x8f/0x105
2012-08-14 13:15:39 foobar kernel: [ 6707.239750]  [<c05427b9>] ext4_get_block+0x1b/0x20
2012-08-14 13:15:39 foobar kernel: [ 6707.239752]  [<c05008e0>] __block_prepare_write+0x11b/0x268
2012-08-14 13:15:39 foobar kernel: [ 6707.239755]  [<c0500ad0>] block_write_begin_newtrunc+0x6d/0xa0
2012-08-14 13:15:39 foobar kernel: [ 6707.239757]  [<c054279e>] ? ext4_get_block+0x0/0x20
2012-08-14 13:15:39 foobar kernel: [ 6707.239761]  [<c04bf1bc>] ? __inc_zone_page_state+0x1d/0x1f
2012-08-14 13:15:39 foobar kernel: [ 6707.239763]  [<c0500d8d>] block_write_begin+0x28/0x62
2012-08-14 13:15:39 foobar kernel: [ 6707.239765]  [<c054279e>] ? ext4_get_block+0x0/0x20
2012-08-14 13:15:39 foobar kernel: [ 6707.239768]  [<c0543631>] ext4_write_begin+0x117/0x1ec
2012-08-14 13:15:39 foobar kernel: [ 6707.239770]  [<c054279e>] ? ext4_get_block+0x0/0x20
2012-08-14 13:15:39 foobar kernel: [ 6707.239774]  [<c04af7ad>] generic_file_buffered_write+0xb6/0x1a3
2012-08-14 13:15:39 foobar kernel: [ 6707.239777]  [<c04b0ce1>] __generic_file_aio_write+0x25b/0x283
2012-08-14 13:15:39 foobar kernel: [ 6707.239780]  [<c042e0bd>] ? kunmap_atomic+0x50/0x76
2012-08-14 13:15:39 foobar kernel: [ 6707.239783]  [<c0430b5a>] ? need_resched+0x19/0x23
2012-08-14 13:15:39 foobar kernel: [ 6707.239786]  [<c04b0d63>] generic_file_aio_write+0x5a/0xa4
2012-08-14 13:15:39 foobar kernel: [ 6707.239789]  [<c053cd23>] ext4_file_write+0x91/0xa2
2012-08-14 13:15:39 foobar kernel: [ 6707.239792]  [<c04e320c>] do_sync_write+0x8f/0xca
2012-08-14 13:15:39 foobar kernel: [ 6707.239796]  [<c0585a89>] ? security_file_permission+0x14/0x16
2012-08-14 13:15:39 foobar kernel: [ 6707.239798]  [<c04e3610>] ? rw_verify_area+0x95/0xb1
2012-08-14 13:15:39 foobar kernel: [ 6707.239800]  [<c04e317d>] ? do_sync_write+0x0/0xca
2012-08-14 13:15:39 foobar kernel: [ 6707.239803]  [<c04e38ab>] vfs_write+0x87/0xdf
2012-08-14 13:15:39 foobar kernel: [ 6707.239806]  [<c07bcece>] ? do_page_fault+0x219/0x275
2012-08-14 13:15:39 foobar kernel: [ 6707.239808]  [<c04e3a81>] sys_write+0x40/0x62
2012-08-14 13:15:39 foobar kernel: [ 6707.239811]  [<c040895f>] sysenter_do_call+0x12/0x28

Any advice would be very much appreciated.

David
