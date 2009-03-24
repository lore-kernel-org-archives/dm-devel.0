From: Mikulas Patocka <mpatocka@redhat.com>
Subject: about the new snapshots
Date: Tue, 24 Mar 2009 04:40:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903240354020.3850@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Jon

The code is here: 
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel

(I'll soon upload a new version that can delete snapshots ... I have 
written it already, I hadn't done much testing yet)


The generic code is in dm-multisnap.c file. The Fujita+Daniel's exception 
store is in dm-multisnap-fujita-daniel.c, my exception store is in the 
rest of the files.

Each origin is represented with structure dm_multisnap, it contains list 
of attached snapshots, structures dm_multisnap_snap. It also contains 
pointer to exception-store-private part, struct exception_store_private 
and a method table (struct dm_multisnap_exception_store).

All I/O except reads from the origin is offloaded to a thread. This can be 
further optimized, that some more cases could be handled directly.


My snapshot store is composed as a B+tree with snapshot ranges, each entry 
contains key (chunk number, start snapshot ID, end snapshot ID) and a 
value of a new chunk where this is remapped. Thus, it has unlimited number 
of snapshots --- really limited to 2^32. It can be used for example for 
rolling snapshots, i.e. take snapshot every 5 minutes to record activity.


Things, you should know if you want to port this implementation into your 
code:

In case someone writes to the snapshots, there may be a need to create 
multiple copies. For example if you have snapshots 1,2,3 and someone 
writes to snapshot 2, it creates key [chunk number,2-2]. If someone writes 
to the origin, it needs to create two more records [chunk number,1-1] and 
[chunk number,3-3] and perform two copies. If there weren't write to the 
snapshot, it would create just one record [chunk number,1-3].

This is done in do_origin_write, the function resets exception store's 
search state machine with s->store->reset_query and then repeatedly asks 
if there is anything more to remap (s->store->query_next_remap) and if 
there is, add an entry to the b+tree (s->store->add_next_remap). When it 
finishes all remaps or when it fills all 8 kcopyd slots, it submits the 
request to kcopyd.

Fujita+Daniel's store uses bitmask, the upside is that it doesn't ever do 
multiple copies, so these methods are implemented in such a way that 
query_next_remap succeeds at most once and add_next_remap processes all 
the snapshots. The downside of the bitmask is that it is limited to max 64 
snapshots.


Another thing (that you'll need to implement in Fujita+Daniel's store too) 
is snapshot-to-snapshot copies. It happens when you write to a shared 
snapshot chunk. The write can't be dispatched directly (because it would 
be reflected to multiple snapshots), so it needs to perform a copy. I do 
it in do_snapshot_io, the method is s->store->make_chunk_writeable, it 
duplicates the record in the b+tree and returns the destination, where the 
data should be copied. After this method is called, kcopyd performs 
snapshot-to-snapshot copy.


Another abstraction that I added is check_conflicts method (called by 
check_pending_io) --- it checks if a given chunk+snapid conflicts with 
kcopyd I/O that is in progress. The exception store fills an union 
chunk_descriptor, that union is opaque to the generic code, and the 
generic code calls check_conflict method to check if there is conflict 
against that I/O. The rationale for this is that in my implementation, 
there may be many snapshots, one kcopyd action could create exceptions 
even for a range of several hundred snapshots, and it would be unsuitable 
to check them one-by-one for conflicts. For Fujita+Daniel's store, the 
union holds a 64-bit bitmap which IDs are copied. For my store, it holds 
the snapid range that is being copied.


When all kcopyd jobs finish, the method commit is called, it updates the 
exception store to reflect changes made so far. My store uses 
log-structure layout, this writes the new commit block that contains 
updated pointers. Fujita+Daniel's code doesn't have data consistency, so 
this only writes all dirty buffers, hoping that the computer won't crash 
between individual writes.


Unlike in the old snapshots, in my implementation the bio is retried after 
a kcopyd job --- when the job finishes, the bio is put back to the queue 
and checked against all the snapshots again. This simplifies design 
because not all snapshots need to be processed when processing the bio. 
For example, kcopyd has 8 slots, when all the slots are filled, there may 
still be unprocessed snapshots. But it doesn't matter, as they'll be 
retried.

In the old snapshots, this no-retry-bio thing is wrong too, it causes bug 
https://bugzilla.redhat.com/show_bug.cgi?id=182659. I already patched it 
(http://people.redhat.com/mpatocka/patches/kernel/merging/2.6.28/dm-snapshot-rework-origin-write.patch) 
but the patch was somehow forgotten by Alasdair, you may think about 
incorporating it into your patchset.


Mikulas
