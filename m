From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Fri, 19 Jun 2009 11:43:47 +1000
Message-ID: <19002.60755.876186.489524@notabene.brown>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org>
	<1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o>
	<19000.8388.899607.749942@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Neil Brown on Wednesday June 17
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Wednesday June 17, neilb@suse.de wrote:
> 
> I will try to find time to review your dm-raid5 code with a view to
> understanding how it plugs in to dm, and then how the md/raid5 engine
> can be used by dm-raid5.

I've had a bit of a look through the dm-raid5 patches.

Some observations:

- You have your own 'xor' code against which you do a run-time test of
  the 'xor_block' code which md/raid5 uses - then choose the fasted.
  This really should not be necessary.  If you have xor code that runs
  faster than anything in xor_block, it really would be best to submit
  it for inclusion in the common xor code base.

- You have introduced "dm-message" which is a frame work for sending
  messages to dm targets.  It is used for adjusting the cache size,
  changing the bandwidth used by resync, and doing things with
  statistics.  Linux already has a framework for sending messages to
  kernel objects.  It is called "sysfs".  It would be much nicer if
  you could use that.

- I don't know what Christoph Hellwig was referring to when he
  suggested that dm-raid1 was broken, but there is one issue with it
  that concerns me and which is (as far as I can tell) broken in
  dm-raid45 as well.
  That issue is summarised in the thread
   http://www.linux-archive.org/device-mapper-development/282987-dm-raid1-data-corruption.html

  The problem is that when a drive fails you allow writes to continue
  without waiting for the metadata to be updated.  I.e. metadata
  updates are asynchronous. 
  The problem scenario for raid5 is:
    - a drive fails while a write is in process
    - the drive is marked as faulty and user space is notified
    - that write, and possibly several others, complete and that 
      status is potentially returned to user-space (e.g. for an fsync)
    - user space acts on that status (e.g. sends an acknowledgement over
      the network)
    - the host crashes before the metadata update completes

    - on reboot, the drive, which just had a transient failure, works
      fine, and the metadata reports that all the drives are good, but
      that the array was active so a parity-resync is needed.
    - All parity blocks are recalculated.  However that write we
      mentioned above is only recorded in the parity block.  So that
      data is lost.

   Now if you get a crash while the array is degraded data loss is a
   real possibility.  However silent data loss should not be tolerated.

   For this reason, metadata updates reporting failed devices really
   need to by synchronous with respect to writes.
   
- Your algorithm for limiting bandwidth used by resync seems to be
  based on a % concept (which is rounded to the nearest reciprocal,
  so 100%, 50%, 33%, 25%, 20%, 16% etc).  If there is outstanding
  IO, the amount of outstanding resync IO must not exceed the given
  percentage of regular IO.   While it is hard to get resync "just
  right", I think this will have some particularly poor
  characteristics.
  Heavy regular IO load, or a non-existent regular load should be
  handled OK, but I suspect that a light IO load (e.g. one or two
  threads of synchronous requests) would cause the resync to go much
  slower than you would want.

  Also it does not take account of IO to other partitions on a device.
  It is common to have a number of different arrays on the same device
  set.  You really want to resync to back off based on IO to all of
  the device, not just to the array.


All of these are issues that are already addressed in md/raid5.
About the only thing that I saw which does not have a working analogue
in md/raid5 is cluster locking.  However that is "not yet implemented"
in dm-raid5 so that isn't a real difference.

Everything else could be made available by md to dm with only a
moderate amount of effort.
Of the different interface routines you require:
+	.ctr = raid_ctr,

  This would be quite straight forward, though it might be worth
  discussing the details of the args passed in.
  "recovery_bandwidth" (as I say above) I don't think is well chosen,
  and I don't quite see the point of io_size (maybe I'm missing
  something obvious)

+	.dtr = raid_dtr,

  This is trivial. raid5.stop

+	.map = raid_map,

  This is very much like the md/raid5 make_request.

+	.presuspend = raid_presuspend,

  I call this 'quiesce'

+	.postsuspend = raid_postsuspend,

  I'm not sure exactly how this fits in.  Something related to the 
  log...

+	.resume = raid_resume,

  ->quiesce requesting 'resume' rather than 'suspend'

+	.status = raid_status,

  very straight forward

+	.message = raid_message,

  As I said, I would rather this didn't exist.  But it could be
  emulated (except for the statistics) if needed - md can already
  adjust resync speed and cache size.


 What is missing is agreement on how to handle synchronous metadata
 updates.  md waits for the drive failure to be acknowledged.  It is
 automatically marked as 'Blocked' on an error, and user-space must
 clear that flag.

 I suspect, using your model, the approach would be a 'dm-message'
 acknowledging that a given device is faulty.  I would, of course,
 rather this be done via sysfs.

 I will try to look at factoring out the md specific part of md/raid5
 over the next few days (maybe next week) and see how that looks.

NeilBrown
