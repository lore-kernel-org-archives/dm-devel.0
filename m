From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] sort snapshots according to a chunk size
Date: Fri, 9 Oct 2009 19:28:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0910091926590.334@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Sort the snapshot list.

Snapshot with the largest chunk size goes first, smallest last.

This fixes corruption with multiple snapshots with different chunksizes
(https://bugzilla.redhat.com/show_bug.cgi?id=182659)

For example, let's have two snapshots with different chunksizes, the first
snapshot has small chunksize and the second snapshot has large chunksize.
Let's have chunks A, B, C in these snapshots:
snapshot1: ====A====   ====B====
snapshot2: ==========C==========

Now, write to the origin at the position "A/C" comes. It triggers reallocation
of A, then reallocation of C and links C's primary_pe to A.

Then, another write to the origin comes at the position "B/C". It creates
pending exception for "B", then it finds "C", it has already pending
exceptions and it is already linked to "A", so nothing is done with it.

If the reallocation of "B" finishes before reallocation of "C", the second
write is dispatched to the origin and causes data corruption in the chunk "C"
in snapshot2.

To avoid this situation, we maintain snapshots sorted, in a descending order
according to a chunk size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.31-fast-new/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.31-fast-new.orig/drivers/md/dm-snap.c	2009-10-09 23:37:10.000000000 +0200
+++ linux-2.6.31-fast-new/drivers/md/dm-snap.c	2009-10-10 01:15:29.000000000 +0200
@@ -297,6 +297,7 @@ static void __insert_origin(struct origi
  */
 static int register_snapshot(struct dm_snapshot *snap)
 {
+	struct dm_snapshot *l;
 	struct origin *o, *new_o;
 	struct block_device *bdev = snap->origin->bdev;
 
@@ -320,7 +321,11 @@ static int register_snapshot(struct dm_s
 		__insert_origin(o);
 	}
 
-	list_add_tail(&snap->list, &o->snapshots);
+	/* Sort the list according to chunk size, largest-first smallest-last */
+	list_for_each_entry(l, &o->snapshots, list)
+		if (l->store->chunk_size < snap->store->chunk_size)
+			break;
+	list_add_tail(&snap->list, &l->list);
 
 	up_write(&_origins_lock);
 	return 0;
