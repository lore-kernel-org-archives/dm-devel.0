From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Fri, 19 Jun 2009 12:33:50 +0200
Message-ID: <1245407630.12264.66.camel@o>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o> <19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19002.60755.876186.489524@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Fri, 2009-06-19 at 11:43 +1000, Neil Brown wrote:
> On Wednesday June 17, neilb@suse.de wrote:
> > 
> > I will try to find time to review your dm-raid5 code with a view to
> > understanding how it plugs in to dm, and then how the md/raid5 engine
> > can be used by dm-raid5.

Hi Neil.

> 
> I've had a bit of a look through the dm-raid5 patches.

Thanks.

> 
> Some observations:
> 
> - You have your own 'xor' code against which you do a run-time test of
>   the 'xor_block' code which md/raid5 uses - then choose the fasted.
>   This really should not be necessary.  If you have xor code that runs
>   faster than anything in xor_block, it really would be best to submit
>   it for inclusion in the common xor code base.

This is in because it actually shows better performance regularly by
utilizing cache lines etc. more efficiently (tested on Intel, AMD and
Sparc).

If xor_block would always have been performed best, I'd dropped that
optimization already.

> 
> - You have introduced "dm-message" which is a frame work for sending
>   messages to dm targets.

dm-message is a parser for messages sent to a device-mapper targets
message interface. It aims at allowing common message parsing functions
to be shared between targets.

The message interface in general allows for runtime state changes of
targets like those you found below.

See "dmsetup message ..."

> It is used for adjusting the cache size,
>   changing the bandwidth used by resync, and doing things with
>   statistics.  Linux already has a framework for sending messages to
>   kernel objects.  It is called "sysfs".  It would be much nicer if
>   you could use that.

Looks to me like heavier to program (I counted ~100 LOC of sysfs defines
and calls in md.c) for 3 files used in md.

That needs some more discussion.

> 
> - I don't know what Christoph Hellwig was referring to when he
>   suggested that dm-raid1 was broken, but there is one issue with it
>   that concerns me and which is (as far as I can tell) broken in
>   dm-raid45 as well.
>   That issue is summarised in the thread
>    http://www.linux-archive.org/device-mapper-development/282987-dm-raid1-data-corruption.html

Yes, major point being that dm aims to mostly do uspace metadata updates
and as little kspace metadata access as possible.

> 
>   The problem is that when a drive fails you allow writes to continue
>   without waiting for the metadata to be updated.  I.e. metadata
>   updates are asynchronous. 
>   The problem scenario for raid5 is:
>     - a drive fails while a write is in process
>     - the drive is marked as faulty and user space is notified
>     - that write, and possibly several others, complete and that 
>       status is potentially returned to user-space (e.g. for an fsync)
>     - user space acts on that status (e.g. sends an acknowledgement over
>       the network)
>     - the host crashes before the metadata update completes
>     - on reboot, the drive, which just had a transient failure, works
>       fine, and the metadata reports that all the drives are good, but
>       that the array was active so a parity-resync is needed.
>     - All parity blocks are recalculated.  However that write we
>       mentioned above is only recorded in the parity block.  So that
>       data is lost.
> 

Yes, like in the dm raid1 scenario, blocking of writes would have to
occur until metadata has been updated in order to detect the failing
drive persistently, hence not updating parity (which contains data
mandatory to preserve) but recalculating chunks on the transiently
failing drive utilizing intact parity.

> 
>    Now if you get a crash while the array is degraded data loss is a
>    real possibility.  However silent data loss should not be tolerated.
> 
>    For this reason, metadata updates reporting failed devices really
>    need to by synchronous with respect to writes.
> 

Agreed.
   
> - Your algorithm for limiting bandwidth used by resync seems to be
>   based on a % concept (which is rounded to the nearest reciprocal,
>   so 100%, 50%, 33%, 25%, 20%, 16% etc).  If there is outstanding
>   IO, the amount of outstanding resync IO must not exceed the given
>   percentage of regular IO.   While it is hard to get resync "just
>   right", I think this will have some particularly poor
>   characteristics.

My ANALYZEME pointed you there ? ;-)
That's why it's in. I admitted with that that I'm not satisfied with the
characteristics yet.

>   Heavy regular IO load, or a non-existent regular load should be
>   handled OK, but I suspect that a light IO load (e.g. one or two
>   threads of synchronous requests) would cause the resync to go much
>   slower than you would want.

I'll look into it further taking your thoughts into account.
.
> 
>   Also it does not take account of IO to other partitions on a device.
>   It is common to have a number of different arrays on the same device
>   set.  You really want to resync to back off based on IO to all of
>   the device, not just to the array.

Does MD RAID > 0 cope with that in multi-partition RAID configs ?
E.g.:
disk1:part1+disk2:part1 -> md0 and disk1:part2+disk2:part2 -> md1 with
global iostats for disk[12] ?

> 
> 
> All of these are issues that are already addressed in md/raid5.
> About the only thing that I saw which does not have a working analogue
> in md/raid5 is cluster locking.  However that is "not yet implemented"
> in dm-raid5 so that isn't a real difference.

Yes, it's a start for future cluster RAID5 usage.

> 
> Everything else could be made available by md to dm with only a
> moderate amount of effort.
> Of the different interface routines you require:
> +	.ctr = raid_ctr,
> 
>   This would be quite straight forward, though it might be worth
>   discussing the details of the args passed in.
>   "recovery_bandwidth" (as I say above) I don't think is well chosen,

I was aware it needs further tweaking (your points above taken).

You mean the wording here ?

>   and I don't quite see the point of io_size (maybe I'm missing
>   something obvious)

Performance related. I studied read ahead/chunk size/io size pairs and
found examples of better performance with io_size > PAGE_SIZE <=
chunk_size. io_size being 2^N.

Do you have similar experiences to share with MD RAID ?

> 
> +	.dtr = raid_dtr,
> 
>   This is trivial. raid5.stop
> 
> +	.map = raid_map,
> 
>   This is very much like the md/raid5 make_request.
> 
> +	.presuspend = raid_presuspend,
> 
>   I call this 'quiesce'
> 
> +	.postsuspend = raid_postsuspend,
> 
>   I'm not sure exactly how this fits in.  Something related to the 
>   log...

We use these distinct presuspend/postsuspend methods in order to allow
for targets to distinguish flushing any io in flight in presuspend and
release/quiesce/... any resource (e.g. quiesce the dirty log) utilized
in the first step in postsuspend.

If MD RAID doesn't need that, stick with presuspend.

> 
> +	.resume = raid_resume,
> 
>   ->quiesce requesting 'resume' rather than 'suspend'
> 
> +	.status = raid_status,
> 
>   very straight forward
> 
> +	.message = raid_message,
> 
>   As I said, I would rather this didn't exist.

I think its better to offer options to be utilized for different
purposes. Tradeoff is always (some) overlap.

We don't have one filesystem for all use cases ;-)

> But it could be
>   emulated (except for the statistics) if needed - md can already
>   adjust resync speed and cache size.
> 
> 
>  What is missing is agreement on how to handle synchronous metadata
>  updates.  md waits for the drive failure to be acknowledged.  It is
>  automatically marked as 'Blocked' on an error, and user-space must
>  clear that flag.

Yes, Mikulas already put thought into that.
Let's allow him /and others) to join in.


> 
>  I suspect, using your model, the approach would be a 'dm-message'
>  acknowledging that a given device is faulty.  I would, of course,
>  rather this be done via sysfs.
> 
>  I will try to look at factoring out the md specific part of md/raid5
>  over the next few days (maybe next week) and see how that looks.

That'll be interesting to see how it fits into the device-mapper
framework

I take it You'll port code to create an "md-raid456" target ?

Thanks a lot,
Heinz

> 
> NeilBrown
