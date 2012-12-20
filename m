From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: basic cache policy module fix [was: Re: Another
 cache target]
Date: Thu, 20 Dec 2012 13:57:59 +0100
Message-ID: <50D30B57.6030403@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<50CF4E61.5030904@redhat.com> <20121218154403.GA1389@redhat.com>
	<20121220011430.GB4878@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010809050608060808020709"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121220011430.GB4878@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, darrick.wong@oracle.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010809050608060808020709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Darrick,

thanks for testing.

Bug's a superfluous increment of the number of allocated cache blocks in 
dm-cache-policy-basic:load_mappings().

Patch is attached and on my git@github.com:lvmguy/linux-2.6, branch 
dm-devel-cache.

Heinz

On 12/20/2012 02:14 AM, Darrick J. Wong wrote:
> On Tue, Dec 18, 2012 at 10:44:04AM -0500, Mike Snitzer wrote:
>> On Mon, Dec 17 2012 at 11:54am -0500,
>> Heinz Mauelshagen <heinzm@redhat.com> wrote:
>>
>>> Darrick,
>>>
>>> please try attached patch, which is on my
>>> git@github.com:lvmguy/linux-2.6, branch thin-dev_Work as well.
>>> Does that fix the issue for you?
>> FYI, I've pushed this fix to the previously mentioned 'dm-devel-cache'
>> branch of my github: git://github.com/snitm/linux.git
> Hmm... now I see this:
>
> [  194.012775] ------------[ cut here ]------------
> [  194.014595] kernel BUG at /storage/home/djwong/cdev/work/linux-dmcache/drivers/md/dm-cache-policy-basic.c:447!
> [  194.016018] invalid opcode: 0000 [#1] PREEMPT SMP
> [  194.016018] Modules linked in: ext4 mbcache jbd2 dm_cache_basic dm_cache dm_bio_prison dm_persistent_data dm_bufio scsi_debug crc_t10dif sch_fq_codel eeprom nfsv4 nfsd auth_rpcgss exportfs af_packet btrfs zlib_deflate libcrc32c [last unloaded: dm_cache]
> [  194.016018] CPU 1
> [  194.016018] Pid: 1572, comm: dmsetup Not tainted 3.7.0-dmcache #7 Bochs Bochs
> [  194.016018] RIP: 0010:[<ffffffffa019a00d>]  [<ffffffffa019a00d>] basic_load_mapping+0x1bd/0x1c0 [dm_cache_basic]
> [  194.016018] RSP: 0018:ffff88007610fb18  EFLAGS: 00010246
> [  194.016018] RAX: 0000000000000700 RBX: ffff88007bedf000 RCX: 0000000000000000
> [  194.016018] RDX: 0000000000000380 RSI: 000000000000c075 RDI: ffff88007bedf000
> [  194.016018] RBP: ffff88007610fb48 R08: 0000000000000001 R09: 0000000000000001
> [  194.016018] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000c075
> [  194.016018] R13: 0000000000000380 R14: 0000000000000000 R15: 0000000000000001
> [  194.016018] FS:  00007f79095bb7c0(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
> [  194.016018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  194.016018] CR2: 00007fff3f33a6dc CR3: 0000000029ac4000 CR4: 00000000000407e0
> [  194.016018] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  194.016018] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  194.016018] Process dmsetup (pid: 1572, threadinfo ffff88007610e000, task ffff880076e3c470)
> [  194.016018] Stack:
> [  194.016018]  ffff88007b715088 ffff880076c9ec00 0000000000000380 000000000000c075
> [  194.016018]  0000000000000001 00000000000001fd ffff88007610fb88 ffffffffa01a47e2
> [  194.016018]  0000000000000000 0000000000000017 ffff88007610fd28 0000000000000380
> [  194.016018] Call Trace:
> [  194.016018]  [<ffffffffa01a47e2>] load_mapping+0x42/0x90 [dm_cache]
> [  194.016018]  [<ffffffffa01a6835>] __load_mapping+0x75/0xd0 [dm_cache]
> [  194.016018]  [<ffffffffa018885e>] walk_ablock+0x8e/0xc0 [dm_persistent_data]
> [  194.016018]  [<ffffffffa01887d0>] ? get_ablock.isra.1+0x60/0x60 [dm_persistent_data]
> [  194.016018]  [<ffffffffa018cd64>] walk_node+0xa4/0xe0 [dm_persistent_data]
> [  194.016018]  [<ffffffffa01887d0>] ? get_ablock.isra.1+0x60/0x60 [dm_persistent_data]
> [  194.016018]  [<ffffffffa018cf16>] dm_btree_walk+0x46/0x70 [dm_persistent_data]
> [  194.016018]  [<ffffffffa018802d>] dm_array_walk+0x2d/0x30 [dm_persistent_data]
> [  194.016018]  [<ffffffffa01a67c0>] ? __dump_mapping+0x40/0x40 [dm_cache]
> [  194.016018]  [<ffffffffa01a7483>] dm_cache_load_mappings+0xa3/0xd0 [dm_cache]
> [  194.016018]  [<ffffffffa01a47a0>] ? complete_migration+0x30/0x30 [dm_cache]
> [  194.016018]  [<ffffffff813d6190>] ? dev_wait+0xc0/0xc0
> [  194.016018]  [<ffffffffa01a3733>] cache_preresume+0xa3/0x130 [dm_cache]
> [  194.016018]  [<ffffffff813d2fa2>] dm_table_resume_targets+0x42/0xa0
> [  194.016018]  [<ffffffff813d0b42>] dm_resume+0x62/0xd0
> [  194.016018]  [<ffffffff813d6339>] dev_suspend+0x1a9/0x240
> [  194.016018]  [<ffffffff813d69fd>] ctl_ioctl+0x12d/0x260
> [  194.016018]  [<ffffffff813d6b43>] dm_ctl_ioctl+0x13/0x20
> [  194.016018]  [<ffffffff8116907f>] do_vfs_ioctl+0x8f/0x4f0
> [  194.016018]  [<ffffffff81081d16>] ? finish_task_switch+0x56/0xb0
> [  194.016018]  [<ffffffff8155ae44>] ? __schedule+0x394/0x7c0
> [  194.016018]  [<ffffffff81169530>] sys_ioctl+0x50/0x90
> [  194.016018]  [<ffffffff8102e425>] ? do_async_page_fault+0x35/0xa0
> [  194.016018]  [<ffffffff8155d79d>] system_call_fastpath+0x1a/0x1f
> [  194.016018] Code: 30 ff ff ff 48 89 df e8 b2 fd ff ff eb a7 48 8b 0a 48 89 41 08 48 89 08 48 89 50 08 48 89 02 e9 65 ff ff ff b8 f4 ff ff ff eb 93 <0f> 0b 90 66 66 66 66 90 55 48 89 e5 48 83 ec 40 85 f6 48 89 5d
> [  194.016018] RIP  [<ffffffffa019a00d>] basic_load_mapping+0x1bd/0x1c0 [dm_cache_basic]
> [  194.016018]  RSP <ffff88007610fb18>
> [  194.154633] ---[ end trace 2fbcf20015b55d9f ]---
>
> --D
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
===============================================================
Heinz Mauelshagen                               +49 2626 141200
Consulting Development Engineer             FAX +49 2626 924446
Red Hat GmbH
Am Sonnenhang 11
56242 Marienrachdorf
Germany                                       heinzm@redhat.com
===============================================================


--------------010809050608060808020709
Content-Type: text/x-patch;
	name="dm-cache-policy-basic_fix_double_blocks_increment.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="dm-cache-policy-basic_fix_double_blocks_increment.patch"

diff --git a/drivers/md/dm-cache-policy-basic.c b/drivers/md/dm-cache-policy-basic.c
index a26a2c0..c1d715e 100644
--- a/drivers/md/dm-cache-policy-basic.c
+++ b/drivers/md/dm-cache-policy-basic.c
@@ -1450,8 +1450,6 @@ static int basic_load_mapping(struct dm_cache_policy *pe,
 		alloc_cblock_insert_cache_and_count_entry(p, e);
 	}
 
-	p->nr_cblocks_allocated = to_cblock(from_cblock(p->nr_cblocks_allocated) + 1);
-
 	return 0;
 }
 

--------------010809050608060808020709
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010809050608060808020709--
