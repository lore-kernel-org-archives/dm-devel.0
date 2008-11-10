From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Mon, 10 Nov 2008 08:11:51 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1225944008.14830.1101.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: axboe@kernel.dk, dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

The bug is correctly analyzed.

Regarding the patch --- you need to wake up md->wait if dec_pending drops 
to zero, so that dm_suspend is not waiting forever.

Otherwise the patch is correct, but contains some unneeded parts: if 
md->pending is used to block removal, we no longer need to hold the 
reference on the table at all. If the code is already called under a 
spinlock (from upstream kernel), we could execute everything under 
md->map_lock spinlock and drop this reference counting at all. But the 
code can take indefinite amount of time, so it would be best to not call 
it under a spinlock in the first place.

For upstream Linux developers: you are holding a spinlock and calling 
bdi*_congested functions that can take indefinite amount of time (there 
are even users reporting having 50 disks in one logical volume or so). I 
think it would be good to move these calls out of spinlocks.

What are the general locking rules for these block queue upcalls 
(congested_fn, unplug_fn, merge_bvec_fn & others)? It looks like there may 
be more bugs like this in another upcalls. Can you please somehow specify 
what can the upcall do and what can't?

Mikulas

On Wed, 5 Nov 2008, Chandra Seetharaman wrote:

> dm_any_congested() just checks for the DMF_BLOCK_IO and has no
> code to make sure that suspend waits for dm_any_congested() to
> complete.
> 
> This leads to a case where the table_destroy() and free_multipath()
> and some other sleeping functions are called (thru dm_table_put())
> from dm_any_congested.
> 
> This leads to 2 problems:
> 1. Sleeping functions called from congested code, whose caller
>    holds a spin lock.
> 2. An ABBA deadlock between pdflush and multipathd. The two locks
>    in contention are inode lock and kernel lock.
>    Here is the crash analysis:
> PID: 16879  TASK: ffff81013a06a140  CPU: 3   COMMAND: "pdflush"
> Owns inode_lock and waiting for kernel_sem
> 
> PID: 8299   TASK: ffff81024f03e100  CPU: 2   COMMAND: "multipathd"
> Owns kernel_sem and waiting for inode_lock.
> 
> 
> PID: 8299   TASK: ffff81024f03e100  CPU: 2   COMMAND: "multipathd"^M
>  #0 [ffff81024ad338c8] schedule at ffffffff8128534c^M
>  #1 [ffff81024ad33980] rt_spin_lock_slowlock at ffffffff81286d15^M << Waiting
> for inode_lock
>  #2 [ffff81024ad33a40] __rt_spin_lock at ffffffff812873b0^M
>  #3 [ffff81024ad33a50] rt_spin_lock at ffffffff812873bb^M
>  #4 [ffff81024ad33a60] ifind_fast at ffffffff810c32a1^M
>  #5 [ffff81024ad33a90] iget_locked at ffffffff810c3be8^M
>  #6 [ffff81024ad33ad0] proc_get_inode at ffffffff810ebaff^M
>  #7 [ffff81024ad33b10] proc_lookup at ffffffff810f082a^M
>  #8 [ffff81024ad33b40] proc_root_lookup at ffffffff810ec312^M
>  #9 [ffff81024ad33b70] do_lookup at ffffffff810b78f7^M
> #10 [ffff81024ad33bc0] __link_path_walk at ffffffff810b9a93^M
> #11 [ffff81024ad33c60] link_path_walk at ffffffff810b9fc1^M
> #12 [ffff81024ad33d30] path_walk at ffffffff810ba073^M
> #13 [ffff81024ad33d40] do_path_lookup at ffffffff810ba37a^M
> #14 [ffff81024ad33d90] __path_lookup_intent_open at ffffffff810baeb0^M
> #15 [ffff81024ad33de0] path_lookup_open at ffffffff810baf60^M
> #16 [ffff81024ad33df0] open_namei at ffffffff810bb071^M
> #17 [ffff81024ad33e80] do_filp_open at ffffffff810ae610^M
> #18 [ffff81024ad33f30] do_sys_open at ffffffff810ae67f^M
> #19 [ffff81024ad33f70] sys_open at ffffffff810ae729^M
> 
> 
> PID: 16879  TASK: ffff81013a06a140  CPU: 3   COMMAND: "pdflush"^M
>  #0 [ffff810023063aa0] schedule at ffffffff8128534c^M
>  #1 [ffff810023063b58] rt_mutex_slowlock at ffffffff81286ac5^M  << Waiting for
> Kernel Lock
>  #2 [ffff810023063c28] rt_mutex_lock at ffffffff81285fb4^M
>  #3 [ffff810023063c38] rt_down at ffffffff8105fec7^M
>  #4 [ffff810023063c58] lock_kernel at ffffffff81287b8c^M
>  #5 [ffff810023063c78] __blkdev_put at ffffffff810d5d31^M
>  #6 [ffff810023063cb8] blkdev_put at ffffffff810d5e68^M
>  #7 [ffff810023063cc8] close_dev at ffffffff8819e547^M
>  #8 [ffff810023063ce8] dm_put_device at ffffffff8819e579^M
>  #9 [ffff810023063d08] free_priority_group at ffffffff881c0e86^M
> #10 [ffff810023063d58] free_multipath at ffffffff881c0f11^M
> #11 [ffff810023063d78] multipath_dtr at ffffffff881c0f73^M
> #12 [ffff810023063d98] dm_table_put at ffffffff8819e347^M
> #13 [ffff810023063dc8] dm_any_congested at ffffffff8819d074^M
> #14 [ffff810023063df8] sync_sb_inodes at ffffffff810cd451^M
> #15 [ffff810023063e38] writeback_inodes at ffffffff810cd7b5^M
> #16 [ffff810023063e68] background_writeout at ffffffff8108be38^M
> #17 [ffff810023063ed8] pdflush at ffffffff8108c79a^M
> #18 [ffff810023063f28] kthread at ffffffff81051477^M
> #19 [ffff810023063f48] kernel_thread at ffffffff8100d048^M
> 
> crash> kernel_sem
> kernel_sem = $5 = {
>   count = {
>     counter = 0
>   }, 
>   lock = {
>     wait_lock = {
>       raw_lock = {
>         slock = 34952
>       }, 
>       break_lock = 0
>     }, 
>     wait_list = {
>       prio_list = {
>         next = 0xffff810023063b88, 
>         prev = 0xffff81014941fdc0
>       }, 
>       node_list = {
>         next = 0xffff810023063b98, 
>         prev = 0xffff81014d04ddd0
>       }
>     }, 
>     owner = 0xffff81024f03e102 << multipathd owns it. (task 0xffff81024f03e100) 
>                                                    << last two bits are flags..
> so replace it with 0.
>   }
> }
> crash> inode_lock
> inode_lock = $6 = {
>   lock = {
>     wait_lock = {
>       raw_lock = {
>         slock = 3341
>       }, 
>       break_lock = 0
>     }, 
>     wait_list = {
>       prio_list = {
>         next = 0xffff81024ad339a0, 
>         prev = 0xffff8100784fdd78
>       }, 
>       node_list = {
>         next = 0xffff81024ad339b0, 
>         prev = 0xffff81024afb3a70
>       }
>     }, 
>     owner = 0xffff81013a06a142 << pdflush owns it. (task 0xffff81013a06a140)
>   }, 
>   break_lock = 0
> }
> crash> 
> ----------------
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ----
> 
> Index: linux-2.6.28-rc3/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.28-rc3.orig/drivers/md/dm.c
> +++ linux-2.6.28-rc3/drivers/md/dm.c
> @@ -937,16 +937,21 @@ static void dm_unplug_all(struct request
>  
>  static int dm_any_congested(void *congested_data, int bdi_bits)
>  {
> -	int r;
> +	int r = bdi_bits;
>  	struct mapped_device *md = (struct mapped_device *) congested_data;
> -	struct dm_table *map = dm_get_table(md);
> +	struct dm_table *map;
>  
> -	if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
> -		r = bdi_bits;
> -	else
> -		r = dm_table_any_congested(map, bdi_bits);
> +	atomic_inc(&md->pending);
> +	if (test_bit(DMF_BLOCK_IO, &md->flags))
> +		goto done;
>  
> -	dm_table_put(map);
> +	map = dm_get_table(md);
> +	if (map) {
> +		r = dm_table_any_congested(map, bdi_bits);
> +		dm_table_put(map);
> +	}
> +done:
> +	atomic_dec(&md->pending);
>  	return r;
>  }
>  
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
