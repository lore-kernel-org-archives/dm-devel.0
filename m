From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: 5.6-rc1 lockdep warning during dm-thin shutdown
Date: Thu, 20 Feb 2020 18:45:19 -0500
Message-ID: <20200220234519.GA620489@mit.edu>
References: <20200213205014.GA349527@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200213205014.GA349527@mit.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Ping?  It looks like I'm still seeing across the board failures for
generic/347 in 5.6-rc2 and it looks like it's pretty clearly a dm-thin
issue.

If this isn't going to be fixed soon, that's fine.  I'm just going to
blacklist generic/347 in kvm-xfstests and gce-xfstests.

Thanks,

						- Ted


On Thu, Feb 13, 2020 at 03:50:14PM -0500, Theodore Y. Ts'o wrote:
> I noticed this while running xfstests generic/347.  The lockdep report is below:
> 
> [ 3742.062744] run fstests generic/347 at 2020-02-13 13:18:03
> [ 3742.431761] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
> [ 3743.696630] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
> [ 3749.384483] device-mapper: thin: 253:4: reached low water mark for data device: sending event.
> [ 3750.853156] device-mapper: thin: 253:4: switching pool to out-of-data-space (queue IO) mode
> [ 3812.123242] device-mapper: thin: 253:4: switching pool to out-of-data-space (error IO) mode
> [ 3812.138217] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 378 starting block 128192)
> [ 3812.150804] buffer_io_error: 708 callbacks suppressed
> [ 3812.150809] Buffer I/O error on device dm-5, logical block 128000
> [ 3812.162553] Buffer I/O error on device dm-5, logical block 128001
> [ 3812.169205] Buffer I/O error on device dm-5, logical block 128002
> [ 3812.175793] Buffer I/O error on device dm-5, logical block 128003
> [ 3812.183686] Buffer I/O error on device dm-5, logical block 128004
> [ 3812.191467] Buffer I/O error on device dm-5, logical block 128005
> [ 3812.199311] Buffer I/O error on device dm-5, logical block 128006
> [ 3812.207204] Buffer I/O error on device dm-5, logical block 128007
> [ 3812.214915] Buffer I/O error on device dm-5, logical block 128008
> [ 3812.222699] Buffer I/O error on device dm-5, logical block 128009
> [ 3812.240796] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 379 starting block 128448)
> [ 3812.264563] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 380 starting block 128704)
> [ 3812.287052] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 381 starting block 128960)
> [ 3812.308866] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 382 starting block 129216)
> [ 3812.330810] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 383 starting block 129472)
> [ 3812.352898] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 384 starting block 129728)
> [ 3812.373989] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 385 starting block 129984)
> [ 3812.395096] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 386 starting block 130240)
> [ 3812.416946] EXT4-fs warning (device dm-5): ext4_end_bio:347: I/O error 3 writing to inode 387 starting block 130496)
> [ 3813.736289] device-mapper: thin: 253:4: switching pool to write mode
> [ 3813.736304] device-mapper: thin: 253:4: growing the data device from 1000 to 1200 blocks
> [ 3813.848386] device-mapper: thin: 253:4: reached low water mark for data device: sending event.
> 
> [ 3814.349795] ======================================================
> [ 3814.356234] WARNING: possible circular locking dependency detected
> [ 3814.362533] 5.5.0-xfstests-07635-gc96dceeabf76 #1477 Not tainted
> [ 3814.368654] ------------------------------------------------------
> [ 3814.374947] dmsetup/10207 is trying to acquire lock:
> [ 3814.380079] ffffffff85489a78 (shrinker_rwsem){++++}, at: unregister_shrinker+0x22/0x80
> [ 3814.388115] 
>                but task is already holding lock:
> [ 3814.394061] ffff9c184c8c95d0 (&pmd->root_lock){++++}, at: dm_pool_metadata_close+0xba/0x120
> [ 3814.402530] 
>                which lock already depends on the new lock.
> 
> [ 3814.411867] 
>                the existing dependency chain (in reverse order) is:
> [ 3814.419464] 
>                -> #3 (&pmd->root_lock){++++}:
> [ 3814.425321]        lock_acquire+0x9a/0x160
> [ 3814.429545]        down_read+0x41/0x200
> [ 3814.433542]        dm_thin_find_block+0x2e/0x80
> [ 3814.438590]        thin_map+0x172/0x270
> [ 3814.442548]        __map_bio+0x42/0x210
> [ 3814.446501]        __split_and_process_non_flush+0xd6/0x150
> [ 3814.452292]        __split_and_process_bio+0xe0/0x380
> [ 3814.457588]        dm_process_bio+0x90/0x2b0
> [ 3814.462838]        dm_make_request+0x54/0x120
> [ 3814.467596]        generic_make_request+0xd8/0x400
> [ 3814.472508]        submit_bio+0x3c/0x140
> [ 3814.476587]        submit_bh_wbc+0x16d/0x190
> [ 3814.480975]        ext4_read_block_bitmap_nowait+0x41d/0x670
> [ 3814.486896]        ext4_mb_init_cache+0x163/0x760
> [ 3814.491799]        ext4_mb_init_group+0x19a/0x260
> [ 3814.496759]        ext4_mb_good_group+0x16a/0x180
> [ 3814.501587]        ext4_mb_regular_allocator+0x28f/0x400
> [ 3814.507036]        ext4_mb_new_blocks+0x57e/0xbe0
> [ 3814.512016]        ext4_ext_map_blocks+0xb32/0xf30
> [ 3814.516992]        ext4_map_blocks+0xef/0x580
> [ 3814.521743]        mpage_map_and_submit_extent+0xe7/0x510
> [ 3814.527259]        ext4_writepages+0x895/0xb10
> [ 3814.531971]        do_writepages+0x41/0xe0
> [ 3814.536199]        __filemap_fdatawrite_range+0xd2/0x120
> [ 3814.541752]        file_write_and_wait_range+0x71/0xc0
> [ 3814.547100]        ext4_sync_file+0x130/0x4b0
> [ 3814.551580]        do_fsync+0x38/0x70
> [ 3814.555367]        __x64_sys_fsync+0x10/0x20
> [ 3814.559760]        do_syscall_64+0x50/0x1f0
> [ 3814.564195]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 3814.569882] 
>                -> #2 (&ei->i_data_sem){++++}:
> [ 3814.575580]        lock_acquire+0x9a/0x160
> [ 3814.580109]        down_write+0x40/0x110
> [ 3814.584145]        ext4_truncate+0x3ce/0x510
> [ 3814.588529]        ext4_evict_inode+0x29a/0x5c0
> [ 3814.593184]        evict+0xd0/0x1a0
> [ 3814.596952]        vfs_rmdir+0x167/0x190
> [ 3814.600990]        do_rmdir+0x145/0x1b0
> [ 3814.605303]        do_syscall_64+0x50/0x1f0
> [ 3814.609613]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 3814.615301] 
>                -> #1 (jbd2_handle){++++}:
> [ 3814.620744]        lock_acquire+0x9a/0x160
> [ 3814.625088]        start_this_handle+0x226/0x680
> [ 3814.629824]        jbd2__journal_start+0xf7/0x270
> [ 3814.634856]        __ext4_journal_start_sb+0x85/0x1b0
> [ 3814.640051]        ext4_release_dquot+0x68/0xc0
> [ 3814.644716]        dqput.part.0+0x7f/0x210
> [ 3814.648931]        __dquot_drop+0x69/0x90
> [ 3814.653495]        ext4_clear_inode+0x35/0x90
> [ 3814.658107]        ext4_evict_inode+0x6f/0x5c0
> [ 3814.662767]        evict+0xd0/0x1a0
> [ 3814.666365]        dispose_list+0x48/0x70
> [ 3814.673422]        prune_icache_sb+0x54/0x80
> [ 3814.677808]        super_cache_scan+0x124/0x1a0
> [ 3814.682454]        do_shrink_slab+0x171/0x3a0
> [ 3814.687036]        shrink_slab+0x22c/0x2b0
> [ 3814.691322]        drop_slab_node+0x2e/0x50
> [ 3814.695628]        drop_slab+0x34/0x60
> [ 3814.699511]        drop_caches_sysctl_handler+0x70/0x80
> [ 3814.704859]        proc_sys_call_handler+0x19d/0x1c0
> [ 3814.709944]        vfs_write+0xde/0x1b0
> [ 3814.713911]        ksys_write+0x68/0xe0
> [ 3814.718207]        do_syscall_64+0x50/0x1f0
> [ 3814.722512]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 3814.728895] 
>                -> #0 (shrinker_rwsem){++++}:
> [ 3814.734504]        check_prev_add+0x8e/0x9f0
> [ 3814.738897]        __lock_acquire+0xcdf/0xf80
> [ 3814.743431]        lock_acquire+0x9a/0x160
> [ 3814.747651]        down_write+0x40/0x110
> [ 3814.751806]        unregister_shrinker+0x22/0x80
> [ 3814.756646]        dm_bufio_client_destroy+0xbf/0x220
> [ 3814.761922]        dm_block_manager_destroy+0x11/0x20
> [ 3814.767098]        dm_pool_metadata_close+0x113/0x120
> [ 3814.772503]        __pool_dec+0x96/0x120
> [ 3814.776547]        pool_dtr+0x2d/0x70
> [ 3814.780574]        dm_table_destroy+0x58/0x110
> [ 3814.785137]        __dm_destroy+0x159/0x1b0
> [ 3814.789444]        dev_remove+0xd3/0x110
> [ 3814.793482]        ctl_ioctl+0x1ab/0x3b0
> [ 3814.797543]        dm_ctl_ioctl+0xa/0x10
> [ 3814.801608]        ksys_ioctl+0x82/0xc0
> [ 3814.805593]        __x64_sys_ioctl+0x16/0x20
> [ 3814.809991]        do_syscall_64+0x50/0x1f0
> [ 3814.814401]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 3814.820226] 
>                other info that might help us debug this:
> 
> [ 3814.828343] Chain exists of:
>                  shrinker_rwsem --> &ei->i_data_sem --> &pmd->root_lock
> 
> [ 3814.839823]  Possible unsafe locking scenario:
> 
> [ 3814.845864]        CPU0                    CPU1
> [ 3814.850625]        ----                    ----
> [ 3814.855274]   lock(&pmd->root_lock);
> [ 3814.858962]                                lock(&ei->i_data_sem);
> [ 3814.865215]                                lock(&pmd->root_lock);
> [ 3814.871686]   lock(shrinker_rwsem);
> [ 3814.875377] 
>                 *** DEADLOCK ***
> 
> [ 3814.881412] 2 locks held by dmsetup/10207:
> [ 3814.885637]  #0: ffffffff86fc05f0 (&dm_thin_pool_table.mutex){+.+.}, at: pool_dtr+0x1d/0x70
> [ 3814.894114]  #1: ffff9c184c8c95d0 (&pmd->root_lock){++++}, at: dm_pool_metadata_close+0xba/0x120
> [ 3814.903068] 
>                stack backtrace:
> [ 3814.907544] CPU: 1 PID: 10207 Comm: dmsetup Not tainted 5.5.0-xfstests-07635-gc96dceeabf76 #1477
> [ 3814.916451] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> [ 3814.925915] Call Trace:
> [ 3814.928485]  dump_stack+0x71/0xa0
> [ 3814.931929]  check_noncircular+0x162/0x180
> [ 3814.936144]  check_prev_add+0x8e/0x9f0
> [ 3814.940010]  __lock_acquire+0xcdf/0xf80
> [ 3814.943964]  lock_acquire+0x9a/0x160
> [ 3814.947733]  ? unregister_shrinker+0x22/0x80
> [ 3814.952123]  down_write+0x40/0x110
> [ 3814.955650]  ? unregister_shrinker+0x22/0x80
> [ 3814.960035]  unregister_shrinker+0x22/0x80
> [ 3814.964248]  dm_bufio_client_destroy+0xbf/0x220
> [ 3814.968898]  dm_block_manager_destroy+0x11/0x20
> [ 3814.973551]  dm_pool_metadata_close+0x113/0x120
> [ 3814.978307]  __pool_dec+0x96/0x120
> [ 3814.981829]  pool_dtr+0x2d/0x70
> [ 3814.985086]  dm_table_destroy+0x58/0x110
> [ 3814.989156]  __dm_destroy+0x159/0x1b0
> [ 3814.992939]  dev_remove+0xd3/0x110
> [ 3814.996494]  ? remove_all+0x30/0x30
> [ 3815.000136]  ctl_ioctl+0x1ab/0x3b0
> [ 3815.003672]  dm_ctl_ioctl+0xa/0x10
> [ 3815.007187]  ksys_ioctl+0x82/0xc0
> [ 3815.010614]  __x64_sys_ioctl+0x16/0x20
> [ 3815.014474]  do_syscall_64+0x50/0x1f0
> [ 3815.018257]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 3815.023440] RIP: 0033:0x7f2c9d82e427
> [ 3815.027131] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 f7 d8 64 89 01 48
> [ 3815.046014] RSP: 002b:00007ffee7570578 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
> [ 3815.053715] RAX: ffffffffffffffda RBX: 00007f2c9d90ca7f RCX: 00007f2c9d82e427
> [ 3815.061052] RDX: 00005625880b2b40 RSI: 00000000c138fd04 RDI: 0000000000000003
> [ 3815.068302] RBP: 00007ffee7570630 R08: 00007f2c9d95b310 R09: 00007ffee75703e0
> [ 3815.076018] R10: 00007f2c9d95a65a R11: 0000000000000202 R12: 00007f2c9d95a65a
> [ 3815.083398] R13: 00007f2c9d95a65a R14: 00007f2c9d95a65a R15: 00007f2c9d95a65a
