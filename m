From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: dm-userspace memory consumption in remap cache
Date: Fri, 25 Aug 2006 14:13:25 -0400
Message-ID: <44EF3DC5.2040403@cs.cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: danms@us.ibm.com
Cc: dm-devel@redhat.com, Niraj Tolia <ntolia@cmu.edu>
List-Id: dm-devel.ids

Hi Dan,

I've been playing with a program which uses the libdmu/libdevmapper 
interface to map a block device through dm-userspace.  (I haven't been 
using cowd; I'm looking to integrate dmu support into an existing program.)

I noticed that after I wrote 1 GB of data to a dmu device with a 4 KB 
blocksize, the dm-userspace-remaps slab cache consumed about 39 MB of 
memory.  Looking at alloc_remap_atomic(), dmu makes no attempt to reuse 
dmu_maps until a memory allocation fails, so that potentially dmu could 
force a large amount of data out of the page cache to make room for its map.


I've considered some workarounds from the userspace side, but they all 
seem fairly suboptimal:

1. Periodically invalidate the entire table.  When cowd does this right 
now (on SIGHUP), it invalidates each page individually, which is not 
very pleasant.  I suppose this could be done by loading a new dm table.

2. Periodically trigger block invalidations from userspace, fired by 
either the completion notification mechanism or a periodic timer. 
Userspace couldn't do this in an LRU fashion, since it doesn't see remap 
cache hits.

(As an aside, I haven't been able to figure out the semantics of the 
completion notification mechanism.  Could you provide an example of how 
you expect it to be used from the userspace side?)

3. Map in dm-linear when there are large consecutive ranges, to try to 
keep the table size down.  Some of the early dm-cow design notes 
mentioned this approach*, but I notice that the current cowd doesn't use 
it.  Is this still a recommended procedure?


 From the kernel side -- if the remap cache in the kernel is expected to 
be a subset of the mapping information maintained by userspace, it seems 
as though it should be possible to more aggressively reuse the LRU 
dmu_maps.  That would impose a performance penalty for the extra map 
requests to userspace, but I wonder how that balances against having a 
larger page cache.


Thoughts?

Thanks
--Benjamin Gilbert

* http://www.redhat.com/archives/dm-devel/2006-March/msg00013.html
