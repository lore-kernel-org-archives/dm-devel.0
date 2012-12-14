From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Another cache target
Date: Thu, 13 Dec 2012 17:16:43 -0800
Message-ID: <20121214011643.GB9845@blackbox.djwong.org>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121213215715.GA19419@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Darrick Wong <darrick.wong@oracle.com>
List-Id: dm-devel.ids

On Thu, Dec 13, 2012 at 04:57:15PM -0500, Mike Snitzer wrote:
> On Thu, Dec 13 2012 at  3:19pm -0500,
> Joe Thornber <ejt@redhat.com> wrote:
> 
> > Here's a cache target that Heinz Mauelshagen, Mike Snitzer and I
> > have been working on.
> > 
> > It's also available in the thin-dev branch of my git tree:
> > 
> > git@github.com:jthornber/linux-2.6.git
> 
> This url is best for others to clone from:
> git://github.com/jthornber/linux-2.6.git
> 
> > The main features are a plug-in architecture for policies which decide
> > what data gets cached, and reuse of the metadata library from the thin
> > provisioning target.
> 
> It should be noted that there are more cache replacement policies
> available in Joe's thin-dev branch via the "basic" policy, see:
> drivers/md/dm-cache-policy-basic.c
> 
> (these basic policies include fifo, lru, lfu, and many more)
>  
> > These patches apply on top of the dm patches that agk has got queued
> > for 3.8.
> 
> agk's patches are here:
> http://people.redhat.com/agk/patches/linux/editing/series.html
> 
> But agk hasn't staged all the required patches yet.  I've imported agk's
> editing tree (and a couple other required patches that I previously
> posted to dm-devel, which aren't yet in agk's tree) into the
> 'dm-for-3.8' branch on my github tree here:
> git://github.com/snitm/linux.git
> 
> This 8 patch patchset from Joe should apply cleanly ontop of my
> 'dm-for-3.8' branch.
> 
> But if all you care about is a tree with all the changes then please
> just use Joe's github 'thin-dev' branch.

A full list of broken-out patches would've been nice, but oh well, I ate this
git tree. :)

Curiously, the Documentation/device-mapper/dm-cache.txt says to specify devices
in the order: metadata, origin, and cache, but the code (and Joe's mail) seeem
to want metadata, cache, origin.  This sort of makes me wonder what's going on?

Also, I found a bug when using the mru policy.  If I do this:

<set up a scsi_debug "ssd" with a 448M /dev/sda1 for cache and the rest for
 metadata on /dev/sda2>
# echo 0 67108864 cache /dev/sda2 /dev/sda1 /dev/vda 512 0 mru 0 | dmsetup create fubar
...<use fubar, fill up the cache>...
# dmsetup remove fubar
# echo 0 67108864 cache /dev/sda2 /dev/sda1 /dev/vda 512 0 mru 0 | dmsetup create fubar

I see the following crash in dmesg:

[  426.661458] scsi1 : scsi_debug, version 1.82 [20100324], dev_size_mb=512, opts=0x0
[  426.663955] scsi 1:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[  426.667005] sd 1:0:0:0: Attached scsi generic sg0 type 0
[  426.667020] sd 1:0:0:0: [sda] 1048576 512-byte logical blocks: (536 MB/512 MiB)
[  426.667046] sd 1:0:0:0: [sda] Write Protect is off
[  426.667057] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[  426.667203]  sda: unknown partition table
[  426.667311] sd 1:0:0:0: [sda] Attached SCSI disk
[  426.694055]  sda: sda1 sda2
[  448.155368] bio: create slab <bio-1> at 1
[  460.762930] promote thresholds = 65/4 queue stats = 1/0
[  468.121084] promote thresholds = 65/4 queue stats = 1/1
[  471.970865] dm-cache statistics:
[  471.974809] read hits:	887895
[  471.976948] read misses:	499
[  471.978195] write hits:	0
[  471.979380] write misses:	0
[  471.980716] demotions:	7
[  471.982391] promotions:	1799
[  471.983798] copies avoided:	7
[  471.985137] cache cell clashs:	0
[  471.986886] commits:		1653
[  471.988410] discards:		0
[  474.177476] bio: create slab <bio-1> at 1
[  474.206000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  474.209037] IP: [<ffffffffa01b1aad>] queue_evict_default+0x1d/0x50 [dm_cache_basic]
[  474.209969] PGD 0 
[  474.209969] Oops: 0002 [#1] PREEMPT SMP 
[  474.209969] Modules linked in: scsi_debug dm_cache_basic dm_cache_mq dm_cache dm_bio_prison dm_persistent_data dm_bufio crc_t10dif nfsv4 sch_fq_codel eeprom nfsd auth_rpcgss exportfs af_packet btrfs zlib_deflate libcrc32c [last unloaded: scsi_debug]
[  474.209969] CPU 0 
[  474.209969] Pid: 1285, comm: kworker/u:2 Not tainted 3.7.0-dmcache #1 Bochs Bochs
[  474.209969] RIP: 0010:[<ffffffffa01b1aad>]  [<ffffffffa01b1aad>] queue_evict_default+0x1d/0x50 [dm_cache_basic]
[  474.209969] RSP: 0018:ffff880055641be8  EFLAGS: 00010282
[  474.209969] RAX: ffff880073a85eb0 RBX: ffff880037ca5c00 RCX: 0000000000000000
[  474.209969] RDX: 0000000000000000 RSI: 0007fff80005ffff RDI: ffff880073a85eb0
[  474.209969] RBP: ffff880055641be8 R08: e000000000000000 R09: ffff880072d619a0
[  474.209969] R10: 0000000000000034 R11: fffffff80005ffff R12: ffff880037f33d30
[  474.209969] R13: ffff880037ca5c78 R14: ffff880055641c98 R15: 000000000001ffff
[  474.209969] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[  474.209969] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  474.209969] CR2: 0000000000000008 CR3: 0000000001a0c000 CR4: 00000000000407f0
[  474.209969] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  474.209969] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  474.209969] Process kworker/u:2 (pid: 1285, threadinfo ffff880055640000, task ffff88007cb62de0)
[  474.209969] Stack:
[  474.209969]  ffff880055641c58 ffffffffa01b28a4 0000000000000040 0000000000000286
[  474.209969]  ffff880000000000 ffffffffa017658c 0000000000000000 ffff880155641cd0
[  474.209969]  ffff880055641c58 ffff88007cac7400 ffff880055641d50 ffff880037f33d30
[  474.209969] Call Trace:
[  474.209969]  [<ffffffffa01b28a4>] basic_map+0x484/0x708 [dm_cache_basic]
[  474.209969]  [<ffffffffa017658c>] ? dm_bio_detain+0x5c/0x80 [dm_bio_prison]
[  474.209969]  [<ffffffffa019c221>] process_bio+0x101/0x4c0 [dm_cache]
[  474.209969]  [<ffffffffa019cb4f>] do_worker+0x56f/0x630 [dm_cache]
[  474.209969]  [<ffffffff81081ab6>] ? finish_task_switch+0x56/0xb0
[  474.209969]  [<ffffffff8106fa31>] process_one_work+0x121/0x490
[  474.209969]  [<ffffffffa019c5e0>] ? process_bio+0x4c0/0x4c0 [dm_cache]
[  474.209969]  [<ffffffff81070be5>] worker_thread+0x165/0x3f0
[  474.209969]  [<ffffffff81070a80>] ? manage_workers+0x2a0/0x2a0
[  474.209969]  [<ffffffff81076010>] kthread+0xc0/0xd0
[  474.209969]  [<ffffffff81075f50>] ? flush_kthread_worker+0xb0/0xb0
[  474.209969]  [<ffffffff815680ac>] ret_from_fork+0x7c/0xb0
[  474.209969]  [<ffffffff81075f50>] ? flush_kthread_worker+0xb0/0xb0
[  474.209969] Code: de 48 89 47 08 48 89 f8 5d c3 0f 0b 66 90 66 66 66 66 90 55 48 8b bf f8 01 00 00 48 89 e5 e8 ab ff ff ff 48 8b 48 28 48 8b 50 30 <48> 89 51 08 48 89 0a 48 ba 00 01 10 00 00 00 ad de 48 b9 00 02 
[  474.209969] RIP  [<ffffffffa01b1aad>] queue_evict_default+0x1d/0x50 [dm_cache_basic]
[  474.209969]  RSP <ffff880055641be8>
[  474.209969] CR2: 0000000000000008
[  474.333040] ---[ end trace 20dda5f362594054 ]---
[  474.336010] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  474.336680] IP: [<ffffffff810761f0>] kthread_data+0x10/0x20
[  474.336680] PGD 1a0e067 PUD 1a0f067 PMD 0 
[  474.336680] Oops: 0000 [#2] PREEMPT SMP 
[  474.336680] Modules linked in: scsi_debug dm_cache_basic dm_cache_mq dm_cache dm_bio_prison dm_persistent_data dm_bufio crc_t10dif nfsv4 sch_fq_codel eeprom nfsd auth_rpcgss exportfs af_packet btrfs zlib_deflate libcrc32c [last unloaded: scsi_debug]
[  474.336680] CPU 0 
[  474.336680] Pid: 1285, comm: kworker/u:2 Tainted: G      D      3.7.0-dmcache #1 Bochs Bochs
[  474.336680] RIP: 0010:[<ffffffff810761f0>]  [<ffffffff810761f0>] kthread_data+0x10/0x20
[  474.336680] RSP: 0018:ffff8800556417a8  EFLAGS: 00010096
[  474.336680] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81bb2f80
[  474.336680] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007cb62de0
[  474.336680] RBP: ffff8800556417a8 R08: 0000000000000001 R09: 0000000000000083
[  474.336680] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[  474.336680] R13: ffff88007cb631d0 R14: 0000000000000000 R15: 0000000000000001
[  474.336680] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[  474.336680] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  474.336680] CR2: ffffffffffffffd8 CR3: 0000000001a0c000 CR4: 00000000000407f0
[  474.336680] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  474.336680] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  474.336680] Process kworker/u:2 (pid: 1285, threadinfo ffff880055640000, task ffff88007cb62de0)
[  474.336680] Stack:
[  474.336680]  ffff8800556417c8 ffffffff81071445 ffff8800556417c8 ffff88007fc12880
[  474.336680]  ffff880055641848 ffffffff81565a58 ffff8800556417f8 ffff880037daeba0
[  474.336680]  ffff88007cb62de0 ffff880055641fd8 ffff880055641fd8 ffff880055641fd8
[  474.336680] Call Trace:
[  474.336680]  [<ffffffff81071445>] wq_worker_sleeping+0x15/0xc0
[  474.336680]  [<ffffffff81565a58>] __schedule+0x5f8/0x7c0
[  474.336680]  [<ffffffff81565d39>] schedule+0x29/0x70
[  474.336680]  [<ffffffff81057748>] do_exit+0x678/0x9e0
[  474.336680]  [<ffffffff8155fe50>] ? printk+0x4d/0x4f
[  474.336680]  [<ffffffff8100662b>] oops_end+0xab/0xf0
[  474.336680]  [<ffffffff8155f7a6>] no_context+0x201/0x210
[  474.336680]  [<ffffffff8155f986>] __bad_area_nosemaphore+0x1d1/0x1f0
[  474.336680]  [<ffffffff8110ba75>] ? mempool_kmalloc+0x15/0x20
[  474.336680]  [<ffffffff8155f9b8>] bad_area_nosemaphore+0x13/0x15
[  474.336680]  [<ffffffff810311a2>] __do_page_fault+0x322/0x4d0
[  474.336680]  [<ffffffff8111109f>] ? get_page_from_freelist+0x1bf/0x460
[  474.336680]  [<ffffffff81335eca>] ? virtblk_request+0x44a/0x460
[  474.336680]  [<ffffffff81232d56>] ? cpumask_next_and+0x36/0x50
[  474.336680]  [<ffffffff81232d56>] ? cpumask_next_and+0x36/0x50
[  474.336680]  [<ffffffff8108fa53>] ? update_sd_lb_stats+0x123/0x610
[  474.336680]  [<ffffffff8103138e>] do_page_fault+0xe/0x10
[  474.336680]  [<ffffffff8102e425>] do_async_page_fault+0x35/0xa0
[  474.336680]  [<ffffffff81567925>] async_page_fault+0x25/0x30
[  474.336680]  [<ffffffffa01b1aad>] ? queue_evict_default+0x1d/0x50 [dm_cache_basic]
[  474.336680]  [<ffffffffa01b1aa5>] ? queue_evict_default+0x15/0x50 [dm_cache_basic]
[  474.336680]  [<ffffffffa01b28a4>] basic_map+0x484/0x708 [dm_cache_basic]
[  474.336680]  [<ffffffffa017658c>] ? dm_bio_detain+0x5c/0x80 [dm_bio_prison]
[  474.336680]  [<ffffffffa019c221>] process_bio+0x101/0x4c0 [dm_cache]
[  474.336680]  [<ffffffffa019cb4f>] do_worker+0x56f/0x630 [dm_cache]
[  474.336680]  [<ffffffff81081ab6>] ? finish_task_switch+0x56/0xb0
[  474.336680]  [<ffffffff8106fa31>] process_one_work+0x121/0x490
[  474.336680]  [<ffffffffa019c5e0>] ? process_bio+0x4c0/0x4c0 [dm_cache]
[  474.336680]  [<ffffffff81070be5>] worker_thread+0x165/0x3f0
[  474.336680]  [<ffffffff81070a80>] ? manage_workers+0x2a0/0x2a0
[  474.336680]  [<ffffffff81076010>] kthread+0xc0/0xd0
[  474.336680]  [<ffffffff81075f50>] ? flush_kthread_worker+0xb0/0xb0
[  474.336680]  [<ffffffff815680ac>] ret_from_fork+0x7c/0xb0
[  474.336680]  [<ffffffff81075f50>] ? flush_kthread_worker+0xb0/0xb0
[  474.336680] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 98 03 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[  474.336680] RIP  [<ffffffff810761f0>] kthread_data+0x10/0x20
[  474.336680]  RSP <ffff8800556417a8>
[  474.336680] CR2: ffffffffffffffd8
[  474.336680] ---[ end trace 20dda5f362594055 ]---
[  474.336680] Fixing recursive fault but reboot is needed!
[  477.004016] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 1
[  477.004016] Shutting down cpus with NMI
[  477.004016] panic occurred, switching back to text console

*Before* it crashes, though, I can run my iops exerciser and watch the numbers
climb from ~300 to ~100000.  Nice work! :)

(The default policy engine doesn't seem to have this problem, but I haven't
figured out how to make it cache blocks yet...)

--D
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
