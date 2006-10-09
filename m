From: "Vijai Babu Madhavan" <MVijai@novell.com>
Subject: [RFC] DM Snapshot scalability - Common snap store
	approach
Date: Mon, 09 Oct 2006 02:31:09 -0600
Message-ID: <452A5625.E9E2.000B.0@novell.com>
References: <452A3B1A0200000B0001CA9C@lucius.provo.novell.com>
	<452A3B4C0200000B0001CA9E@lucius.provo.novell.com>
	<452A3B520200000B0001CAA0@lucius.provo.novell.com>
	<452A3D570200000B0001CAA7@lucius.provo.novell.com>
	<452A3D680200000B0001CAA9@lucius.provo.novell.com>
	<452A3DCD0200000B0001CAAB@lucius.provo.novell.com>
	<452A3E150200000B0001CAAD@lucius.provo.novell.com>
	<452A3E3A0200000B0001CAAF@lucius.provo.novell.com>
	<452A3E540200000B0001CAB1@lucius.provo.novell.com>
	<452A3E970200000B0001CAB3@lucius.provo.novell.com>
	<452A3EDC0200000B0001CAB9@lucius.provo.novell.com>
	<452A3EE80200000B0001CABB@lucius.provo.novell.com>
	<452A3EF70200000B0001CABD@lucius.provo.novell.com>
	<452A3F210200000B0001CABF@lucius.provo.novell.com>
	<452A3F260200000B0001CAC1@lucius.provo.novell.com>
	<452A3F2A0200000B0001CAC3@lucius.provo.novell.com>
	<452A3F2D0200000B0001CAC5@lucius.provo.novell.com>
	<452A3F310200000B0001CAC7@lucius.provo.novell.com>
	<452A3F370200000B0001CAC9@lucius.provo.novell.com>
	<452A3F440200000B0001CACB@lucius.provo.novell.com>
	<452A3F4B0200000B0001CACD@lucius.provo.novell.com>
	<452A3F520200000B0001CACF@lucius.provo.novell.com>
	<452A3F5D0200000B0001CAD1@lucius.provo.novell.com>
	<452A3F600200000B0001CAD3@lucius.provo.novell.com>
	<452A3F690200000B0001CAD5@lucius.provo.novell.com>
	<452A3F6E0200000B0001CAD7@lucius.provo.novell.com>
	<452A3F980200000B0001CAD9@lucius.provo.novell.com>
	<452A3FA00200000B0001CADB@lucius.provo.novell.com>
	<452A3FA50200000B0001CADD@lucius.provo.novell.com>
	<452A3FE20200000B0001CADF@lucius.provo.novell.com>
	<452A3FF20200000B0001CAE1@lucius.provo.novell.com>
	<452A40750200000B0001CAE3@lucius.provo.novell.com>
	<452A40790200000B0001CAE5@lucius.provo.novell.com>
	<452A40850200000B0001CAE7@lucius.provo.novell.com>
	<452A409C0200000B0001CAE9@lucius.provo.novell.com>
	<452A40AC0200000B0001CAEB@lucius.provo.novell.com>
	<452A41140200000B0001CAED@lucius.provo.novell.com>
	<452A413B0200000B0001CAF6@lucius.provo.novell.com>
	<452A414F0200000B0001CAF8@lucius.provo.novell.com>
	<452A41610200000B0001CAFA@lucius.provo.novell.com>
	<452A417D0200000B0001CAFC@lucius.provo.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Scalability - Problem definition
==================

The current code creates an exclusive copy of the chunks to every
snapshot's cow device (Each 
snapshot is associated with an exclusive cow device). The COW
operations are repeated for 
every single snapshot. This results in linear degrade of origin write
throughput for every additional 
snapshot. Here are the steps:

For Every snapshot,
{
Step 1 - Read chunkSize sectors from the origin device
Step 2 - Write chunkSize sectors to the cow device
Step 3 - Update meta-data (chunkSize sectors) when (a) there are no
other pending IOs to the 
same origin device, (b) the meta-data chunk is full.
}
Step 4 - Allow the origin device write

Hence, the server (processing, memory)/storage overhead increases as
number of snapshots 
increase. Here are some throughput numbers,

Origin Writes                                 Restores                
Bonnie 	    dd

One snapshot		886 MB/min	55 MB/sec	950KB/s
Four snapshot		581 MB/min	16 MB/sec	630 KB/s
Eight snapshot		410 MB/min	14 MB/sec	471 KB/s
Sixteen snapshot	                245 MB/min               6.5
MB/sec               257 KB/s

Quick summary
=========

Various approaches that are being considered/prototyped to solve the
scalability problem with 
DM snapshots are described here. Currently, I like the 2.d approach
(using a single cow device
for all snapshots of an origin, with a combination of exception
stores). If you don't want to 
read about other approaches, jump there directly. I would like to know
about other ways 
to solve this problem, and comments about these approaches.

Technical Goals
=========

- Should solve the problem ;-)
- Creation friendly.
- Minimal memory usage,
- Single snapshot case should not get degraded further in the attempt
to optimize multiple snapshots 
   case.
- Deletes should be faster (Current one simply zeros out the header
area of the disk). Deletes could 
happen on some snapshots, while a whole lot of other snapshots are
around.
- Origin reads should NOT be affected.
- Snap reads should not end up with more overhead.
- Snap loading time should be faster.
- Reliability should not be affected.
- Lookup friendly.
- The necessary operations should be independent of the size of the
volume.

Approach 1 - COW device chaining
=====================

Here are my views about the chaining approach. More info on this by
Haripriya @
https://www.redhat.com/archives/dm-devel/2006-September/msg00098.html

This solution intends to continue with the current architecture of
having one cow device per snapshot. 
When origin gets modified, instead of copying the chunk to all
snapshots, it gets copied to the most recent 
snapshot's cow device only. And, all other snapshots share this chunk.
When origin changes, data is copied
only once, and the meta-data entry is shared among snapshots.

Origin writes - If the chunk is not found in the most recent snapshot,
make a copy in the recent snapshot's
cow device only.

Snap reads - If the chunk is not found in the current exception store,
follow the read chain to see if the next 
snapshot has it, until origin is found (which is at the end of the
chain).

Snap writes - if the chunk is found in the current exception store and
if it was created due to a copy-on-write, 
then it is moved to the previous snapshot in the write chain.

Snap deletes - All the shared chunks need to be moved to the previous
snapshot in the write chain.

Pros:
- Minimal changes to DM architecture and code
- Meta-data entries are shared, hence reducing the memory usage.

Cons:
- Makes the snapshots dependent on each other. If snapshots get loaded
out of order by the volume 
managers (This can be controlled though), it would result in incorrect
version being sent out.
- Since all snapshots need to be up, it increases the memory usage.
- Snap reads need to follow the chain, affecting the read throughput to
some extent.


Approach 2 - Single snap store
===================

This solution intends to use only one cow device for an origin
irrespective of the number of snapshots. When 
the origin write happens, only one copy of the origin chunk will be
made in the cow device and all snapshots 
would share the chunk. There are some variants of this solution that
primarily vary in the way the meta-data 
is handled.

At the time of loading/creating the snapshot, this method requires an
identifier to be passed to the snapshot 
target's constructor (by the volume managers - LVM, EVMS) to uniquely
identify the logical exception store for 
the associated snapshot. And, this unique identifier needs to be stored
on disk as well.

Also, a cow device wide chunk manager is necessary to manage the
allocation/deallocation of the chunks (The 
current one cow disk for every snapshot approach does not need this as
the entire logical disk gets deleted on 
snap deletes and the individual chunks are never deallocated during the
lifetime of the snapshot).

Some obvious advantages of this approach (all variants) include, 

(i) Manageability of the snapshots - Administrators/Users no longer
need to predict the size required for 
the cow device every time they create a snapshot. They need to
provision the storage just once.
(ii) Ability to share the data blocks among snapshots effectively
(writes/deletes also do not necessitate 
movement of data).

Some disadvantages of this approach include,

(i) LVM, EVMS needs to change.
(ii) Some identity information (snapshot's unique identifier) gets
stored on disk by DM.
(iii) All snapshots of the given origin need to have a single, common
chunk size.

2.a Chaining
-----------------

This approach is very similar to solution (1). Every time a new
snapshot is created, an exclusive exception 
store is created inside the cow device, in addition to the header.
Meta-data entries are shared among 
snapshots.

Snap manager - Needs to maintain a bit map for the entire cow disk's
address space (In memory and on disk 
as well). For 1 TB sized cow device and 64K chunks, it would require ~2
MB of space and memory.

Origin writes - If not found in the most recent snapshot's table, a
single chunk is allocated for data and the 
meta-data entry is made to ONLY one snapshot (the most recent one).
Allocators require an additional update 
on disk.

Snap reads - need to follow the chain and look for the mapping entry,
until the origin is found (which is the 
end of the chain)

Snap writes -  the meta-data entry needs to be pushed to the previous
exception store in the chain. If the 
previous exception store already has an entry, then overwrite it.

Snap deletes - push all the relevant (only those that are still shared)
meta-data entries to the previous 
exception store.

Pros:
- Meta-data entries are shared, hence reducing the memory usage.

Cons:
- Creates inter-dependency among snapshots. If the snapshots were
loaded out of order by the volume 
managers, this would result in incorrect version of the data be given
out.
- Since all snapshots need to be up, it also increases the memory
usage.
- Snap reads need to follow the chain, affecting the read throughput to
some extent.

2.b Exclusive Exception stores
---------------------------------------

This is similar to 2.a and varies only by the fact that when the origin
writes happen, the meta-data entry is 
made to each of the exclusive exception stores. While the data chunks
are shared, the meta-data entries are 
not. This also requires that the chunk manager maintains an useCount
for each chunk (in memory and on 
disk), as that is necessary to determine whether to delete the chunks
or not, on snapshot deletions. 1TB cow 
disk with 64K chunks, and an 8bit useCount (with 255 snapshots support)
would require 16MB.

Snap manager - Needs to maintain an useCount for each chunk (in memory
and on disk), as that is necessary 
to determine whether to delete the chunks or not, on snapshot
deletions. 1TB cow disk with 64K chunks, and 
an 8bit useCount (with 255 snapshots support) would require 16MB.

Origin writes - a single chunk is allocated for data and the meta-data
entry is made to ALL snapshots that 
don't already have one.

Snap reads - look up the associated exception store only. If not found,
go directly to origin. No chaining.

Snap writes - if found in the associated snapshot, check useCount. If
it is just 1 simply re-use. Else, allocate a 
new one, write the data and overwrite the meta-data

Snap deletes - Deallocates all the chunks, which would in turn reduce
the useCount. This needs to be written 
to the disk.

Chunk allocations requires disk updates.

Pros:
- Avoids the inter-dependence among snapshots.
- Not all snapshots need to be up.
- Snap reads need not follow the chain

Cons:
- Meta-data updates scale up as the number of snapshots grow.
- Origin write look up might be similar to the current dm-snapshot
case.

2.c One global exception store
------------------------------------

This approach uses a single exception store that contains an ordered
list of meta-data entries (mappings). 
They are ordered by time (either the snap creation time or some other
snap identifier). Meta-data entries 
would look like this, logically.

time t0
old chunk - new chunk
old chunk - new chunk
old chunk - new chunk
.......
.......
time t1
old chunk - new chunk - snapshot id (indicates this is a write and the
snapshot that the write is associated 
with)
.......
.......

These times correspond to the snapshot creation time. The headers for
each snapshot should also include the 
time stamps.

Origin writes - start the look up in the table from the time when the
most recent snapshot was created, if 
chunk not found, a single chunk is allocated for data and the meta-data
entry is made to the exception store.

Snap reads - start the look up in the table from the time when the
associated snapshot was created. Use the 
first non-exclusive entry that matches. If none found, go to origin.

Snap writes - start the look up in the table from the time when the
associated snapshot was created till the 
end of the table for a write that matches with the chunk and snap id.
if not found, allocate a new one, write 
data and update the meta-data.

Snap deletes - should invalidate the exclusive entries and free up
those data chunks. look ups for these 
entries will start from the snapshot being deleted till the end of the
table.

Chunk Manager - Needs to maintain a bitmap.

Pros:

Cons:
- the entire mappings (exclusive + non-exclusive) need to be up.
- snap read, snap write look ups would be slower.
- deletes are a bit messy


2.d One global cow store (shared by all snapshots) + One exclusive
store for each snapshot
------------------------------------------------------------------------------------------------------------------

This is similar to 2.c. The difference is that this approach uses one
exception store (per origin) that contains 
an ordered (either by time or snap identifier) list of shared entries
and one exclusive exception store for each 
snapshot. All the entries due to the origin writes mostly go to the
global exception store. And, the snapshot's 
own exception store would receive entries from the snap writes. 

When the first snapshot for an origin is loaded, the global cow store
entries will be brought into memory (only 
the relevant entries - those entries that were created after this
snapshot), in addition to the exclusive 
exception store that corresponds with this snapshot. The exclusive
table is brought to memory only when the 
associated snapshot is loaded. The exception stores would like this,

Global exception store (for shared entries)

time t0
old chunk - new chunk
.......
.......
time t1
old chunk - new chunk
.......

Snapshot specific exclusive exception store 1

old chunk - new chunk
........

Snapshot specific exclusive exception store 2

old chunk - new chunk
........

These times correspond to the snapshot creation time. The headers for
each snapshot should also include 
the time stamps.

Origin writes - look up (from the time the most recent snap was
created) for a matching entry in the global 
cow table. If none found, allocate a chunk for data, write to it,
update meta-data. either this is the first 
table or if the previous table already has an entry, add this entry in
the exclusive table.

Chunk allocations requires disk updates.

Snap reads - first look up the exclusive table for the associated
snapshot, if none found, look up the 
shared store (from the snap creation time), if none found, go to
origin.

Snap writes - look up the exclusive table only, if none found, add an
entry.

snap deletes - cleanup the entire exclusive table for the associated
snapshot. And if this does not 
have predecessors in the shared table, remove all the entries and free
up the chunks.

chunk manager - Needs to maintain a bit map (or some other data
structure) for the entire cow disk's 
address space (In memory and on disk as well). For 1 TB sized cow
device and 64K chunks, it would 
require ~2 MB of space and memory.

Pros:
- No movement of meta-data during deletes
- deletes are much faster
- snap reads, writes look ups are faster
- memory usage is minimal, as exclusive entries associated with a
snapshot are brought to memory only 
when that snapshot is activated.
- snapshot loading is faster

Cons:
- In some cases, chunk usage might be more. After a shared entry is
created, if ALL the predecessors 
obtain an exclusive entry then the shared entry would remain allocated
but won't get used.

Also, look at the pros/cons mentioned for all variants of the common
store 
approach, under approach 2.

Prototype Results
===========

I have built a prototype using a variant of 2.a and here are the
results.

Tests -On Origin(dd)	Single cow device	DM	
One snapshot		942 KB/s		950KB/s	
Four snapshot		930 KB/s		720 KB/s
Eight snapshot		927 KB/s		470 KB/s
Sixteen snapshot	                920 KB/s		257
KB/s


Some more things under consideration
=======================

- Currently, when snapshots get deleted, the volume managers simply
zero out the header area of the 
cow device. But, with any of these approaches, we need some other
mechanism by which the 
volume managers notify DM.

- With the common store, individual snaps will not be associated with a
specific quota. Is that fine? 
OR Should the quota be associated with the exclusive entries?

- How to get these approaches to work with one cow device per snapshot
type of volume managers. 
Is it necessary at all?

- Ways to minimize changes to EVMS, LVM while still retaining the
benefits of these approaches.

Vijai
