From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 09/10] dm snapshot: Combine substrings for seven error
 messages
Date: Thu, 29 Sep 2016 11:17:16 +0200
Message-ID: <e8510754-7d0c-0081-e682-94cba351a3b4@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 29 Sep 2016 09:46:32 +0200

The script "checkpatch.pl" can point information out like the following.

WARNING: quoted string split across lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-snap.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 4966584..7593986 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -468,8 +468,7 @@ static int __validate_exception_handover(struct dm_snapshot *snap)
 	if ((__find_snapshots_sharing_cow(snap, &snap_src, &snap_dest,
 					  &snap_merge) == 2) ||
 	    snap_dest) {
-		snap->ti->error = "Snapshot cow pairing for exception "
-				  "table handover failed";
+		snap->ti->error = "Snapshot cow pairing for exception table handover failed";
 		return -EINVAL;
 	}
 
@@ -496,8 +495,7 @@ static int __validate_exception_handover(struct dm_snapshot *snap)
 
 	if (!snap_src->store->type->prepare_merge ||
 	    !snap_src->store->type->commit_merge) {
-		snap->ti->error = "Snapshot exception store does not "
-				  "support snapshot-merge.";
+		snap->ti->error = "Snapshot exception store does not support snapshot-merge.";
 		return -EINVAL;
 	}
 
@@ -858,8 +856,7 @@ static int __remove_single_exception_chunk(struct dm_snapshot *s,
 
 	e = dm_lookup_exception(&s->complete, old_chunk);
 	if (!e) {
-		DMERR("Corruption detected: exception for block %llu is "
-		      "on disk but not in memory",
+		DMERR("Corruption detected: exception for block %llu is on disk but not in memory",
 		      (unsigned long long)old_chunk);
 		return -EINVAL;
 	}
@@ -886,8 +883,7 @@ static int __remove_single_exception_chunk(struct dm_snapshot *s,
 		e->new_chunk++;
 	} else if (old_chunk != e->old_chunk +
 		   dm_consecutive_chunk_count(e)) {
-		DMERR("Attempt to merge block %llu from the "
-		      "middle of a chunk range [%llu - %llu]",
+		DMERR("Attempt to merge block %llu from the middle of a chunk range [%llu - %llu]",
 		      (unsigned long long)old_chunk,
 		      (unsigned long long)e->old_chunk,
 		      (unsigned long long)
@@ -980,8 +976,7 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 						      &new_chunk);
 	if (linear_chunks <= 0) {
 		if (linear_chunks < 0) {
-			DMERR("Read error in exception store: "
-			      "shutting down merge");
+			DMERR("Read error in exception store: shutting down merge");
 			down_write(&s->lock);
 			s->merge_failed = 1;
 			up_write(&s->lock);
@@ -1877,12 +1872,10 @@ static int snapshot_preresume(struct dm_target *ti)
 	if (snap_src && snap_dest) {
 		down_read(&snap_src->lock);
 		if (s == snap_src) {
-			DMERR("Unable to resume snapshot source until "
-			      "handover completes.");
+			DMERR("Unable to resume snapshot source until handover completes.");
 			r = -EINVAL;
 		} else if (!dm_suspended(snap_src->ti)) {
-			DMERR("Unable to perform snapshot handover until "
-			      "source is suspended.");
+			DMERR("Unable to perform snapshot handover until source is suspended.");
 			r = -EINVAL;
 		}
 		up_read(&snap_src->lock);
-- 
2.10.0
