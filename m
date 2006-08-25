From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: Re: dm-userspace memory consumption in remap cache
Date: Fri, 25 Aug 2006 15:32:45 -0400
Message-ID: <44EF505D.8040806@cs.cmu.edu>
References: <44EF3DC5.2040403@cs.cmu.edu>
	<m3zmdsbqrs.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3zmdsbqrs.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Smith <danms@us.ibm.com>
Cc: Niraj Tolia <ntolia@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dan Smith wrote:
> BG> I noticed that after I wrote 1 GB of data to a dmu device with a 4
> BG> KB blocksize, the dm-userspace-remaps slab cache consumed about 39
> BG> MB of memory.  
> Ah, right.

In fact, when the dmu device is unmapped, destroy_dmu_device() moves all 
of the dmu_maps to the end of the MRU list but does not free them, so 
that memory stays around.  If a new device is created, its dmu_maps will 
still be obtained from kmem_cache_alloc even though there are unused 
dmu_maps.

> We could push statistic information back to cowd when there
> was nothing else to do.  That might be interesting, but probably not
> the best way to solve this particular issue.

Come to think of it, that would be very interesting data in its own 
right.  Hmm... you could push statistics on a block whenever its mapping 
expires, but that doesn't help the MFU blocks.  You could provide a 
query-and-reset-counters request for individual blocks still in the 
cache, and since userspace could watch the statistics pushes to see what 
blocks had been removed, it would know which blocks to query on.  That 
would allow userspace to maintain statistics on whatever level of 
time-granularity it wanted, without requiring the kernel to do periodic 
sweeps or to do large dumps to userspace.

...I'm probably missing an obvious reason that that won't work.

> BG> (As an aside, I haven't been able to figure out the semantics of
> BG> the completion notification mechanism.  Could you provide an
> BG> example of how you expect it to be used from the userspace side?)
> Recent versions of cowd use this to prevent the completion (endio)
> From firing until it has flushed its internal metadata mapping to
> disk, to prevent the data from being written and the completion event
> sent, when the data isn't really on the disk (well, it's on the disk,
> but if we crash before we write our metadata, we can't tell that it's
> really there during recovery).

Okay, I see.

> BG> 3. Map in dm-linear when there are large consecutive ranges, to
> BG> try to keep the table size down.
> I don't think this is the best approach, because if you want to
> invalidate a mapping, you'd have to split the dm-linear back up,
> suspend/resume the device, etc.

Oh, good point.

> Now that I know at least someone is paying attention, I'll try to get
> my latest dm-userspace and cowd versions out on this list.  A small
> fix has been made to dm-userspace, and several improvements and fixes
> have been made to cowd.  After I post my current code, I'll implement
> the memory limit/aggressive reuse functionality and post that as well.

Great.  Thanks!

Thanks
--Benjamin Gilbert
