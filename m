From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] device-mapper snaphot: fix origin_write
	pending_exception submission
Date: Wed, 11 Jan 2006 21:17:28 +0000
Message-ID: <20060111211728.GH4474@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Say you have several snapshots of the same origin and then you issue
a write to some place in the origin for the first time.

Before the device-mapper snapshot target lets the write go through to 
the underlying device, it needs to make a copy of the data that 
is about to be overwritten.  Each snapshot is independent, so it makes 
one copy for each snapshot.

__origin_write() loops through each snapshot and checks to see
whether a copy is needed for that snapshot.  (A copy is only needed
the first time that data changes.)  

If a copy is needed, the code allocates a 'pending_exception' structure 
holding the details.  It links these together for all the snapshots, then 
works its way through this list and submits the copying requests to
the kcopyd thread by calling start_copy().  When each request is
completed, the original pending_exception structure gets freed in
pending_complete().

If you're very unlucky, this structure can get freed *before* the 
submission process has finished walking the list.


This patch:
  1) Creates a new temporary list pe_queue to hold the pending exception 
structures;
  2) Does all the bookkeeping up-front, then walks through the new list
safely and calls start_copy() for each pending_exception that needed it;
  3) Avoids attempting to add pe->siblings to the list if it's already
connected.


[NB This does not fix all the races in this code.  More patches to follow.]

Signed-Off-By: Alasdair G Kergon <agk@redhat.com>

Index: current-quilt-publish/drivers/md/dm-snap.c
===================================================================
--- current-quilt-publish.orig/drivers/md/dm-snap.c	2006-01-06 15:02:51.000000000 +0000
+++ current-quilt-publish/drivers/md/dm-snap.c	2006-01-11 21:13:20.000000000 +0000
@@ -49,6 +49,11 @@ struct pending_exception {
 	struct bio_list snapshot_bios;
 
 	/*
+	 * Short-term queue of pending exceptions prior to submission.
+	 */
+	struct list_head list;
+
+	/*
 	 * Other pending_exceptions that are processing this
 	 * chunk.  When this list is empty, we know we can
 	 * complete the origins.
@@ -930,8 +935,9 @@ static int __origin_write(struct list_he
 	int r = 1, first = 1;
 	struct dm_snapshot *snap;
 	struct exception *e;
-	struct pending_exception *pe, *last = NULL;
+	struct pending_exception *pe, *next_pe, *last = NULL;
 	chunk_t chunk;
+	LIST_HEAD(pe_queue);
 
 	/* Do all the snapshots on this origin */
 	list_for_each_entry (snap, snapshots, list) {
@@ -965,12 +971,19 @@ static int __origin_write(struct list_he
 				snap->valid = 0;
 
 			} else {
-				if (last)
+				if (first) {
+					bio_list_add(&pe->origin_bios, bio);
+					r = 0;
+					first = 0;
+				}
+				if (last && list_empty(&pe->siblings))
 					list_merge(&pe->siblings,
 						   &last->siblings);
-
+				if (!pe->started) {
+					pe->started = 1;
+					list_add_tail(&pe->list, &pe_queue);
+				}
 				last = pe;
-				r = 0;
 			}
 		}
 
@@ -980,24 +993,8 @@ static int __origin_write(struct list_he
 	/*
 	 * Now that we have a complete pe list we can start the copying.
 	 */
-	if (last) {
-		pe = last;
-		do {
-			down_write(&pe->snap->lock);
-			if (first)
-				bio_list_add(&pe->origin_bios, bio);
-			if (!pe->started) {
-				pe->started = 1;
-				up_write(&pe->snap->lock);
-				start_copy(pe);
-			} else
-				up_write(&pe->snap->lock);
-			first = 0;
-			pe = list_entry(pe->siblings.next,
-					struct pending_exception, siblings);
-
-		} while (pe != last);
-	}
+	list_for_each_entry_safe(pe, next_pe, &pe_queue, list)
+		start_copy(pe);
 
 	return r;
 }
