From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Fri, 6 Nov 2009 14:26:21 -0500
Message-ID: <20091106192620.GD13427@redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<20091106184642.GC13427@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091106184642.GC13427@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 06 2009 at  1:46pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Alasdair,
> 
> Here is the incremental patch that illustrates the relevant changes that
> I layered ontop of the current patch you have in your tree.
> 
> . changed snapshot_ctr() to avoid read_metadata entirely for
>   snapshot-merge (unnecessary if handover will occur)
>   - adjusted a few other things in snapshot_ctr to accomodate early
>     return in the case of handover
> 
> . new snapshot's ti->split_io is now reset in handover_exceptions() to
>   match the chunk_size of the store that was just handed over
> 
> . register_snapshot() for snapshot-merge snapshot is now done after
>   handover_exceptions rather than in snapshot_ctr()
>   - not done in handover_exceptions() to avoid lock order issues between
>     s->lock and _origins_lock
> 
> . remove support for old->resume handover
>   - now that snapshot_ctr no longer does read_metadata() this is no
>     longer needed to support 'lvchange --refresh'

OK, actually in practice 'lvchange --refresh' is:

old->suspend
new->ctr
old->resume
 - device-mapper: snapshots: Unable to handover exceptions to another snapshot on resume.
new->resume
 - snapshot_resume: handing over exceptions

So it looks like we really do need to allow snapshot_resume to trigger
handover if the old is resumed before the new. (snapshot-merge is always
activated last by lvm because it acts as the origin).

I added this before, and  mistakenly thought it wasn't now:
http://patchwork.kernel.org/patch/57787/

Without it the old snapshot would be active with the exceptions that get
handed over to the snapshot-merge.  Quite bad.

Here is the incremental patch to add it back:

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e5acff4..1ba1861 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -82,9 +82,10 @@ struct dm_snapshot {
 	 *
 	 * 'is_handover_destination' is set in snapshot_ctr if an existing
 	 * snapshot has the same cow device. The handover is performed,
-	 * and 'is_handover_destination' is cleared, when either of the
+	 * and 'is_handover_destination' is cleared, when one of the
 	 * following occurs:
 	 * - src (old) snapshot, that is handing over, is destructed
+	 * - src (old) snapshot, that is handing over, is resumed
 	 * - dest (new) snapshot, that is accepting the handover, is resumed
 	 */
 	int is_handover_destination;
@@ -1379,23 +1380,28 @@ static void snapshot_presuspend(struct dm_target *ti)
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
-	struct dm_snapshot *old_snap, *new_snap = NULL;
+	struct dm_snapshot *lock_snap, *old_snap, *new_snap = NULL;
 
 	down_write(&s->lock);
 	if (s->handover_snap) {
-		if (!s->is_handover_destination) {
-			DMERR("Unable to handover exceptions to "
-			      "another snapshot on resume.");
-			goto out;
-		}
-		/* Get exception store from another snapshot */
+		/*
+		 * Initially assumes this snapshot will get
+		 * exception store from another snapshot
+		 */
 		old_snap = s->handover_snap;
 		new_snap = s;
+		lock_snap = old_snap;
 
-		down_write_nested(&old_snap->lock,
+		if (!s->is_handover_destination) {
+			/* Handover exceptions to another snapshot */
+			old_snap = s;
+			new_snap = s->handover_snap;
+			lock_snap = new_snap;
+		}
+		down_write_nested(&lock_snap->lock,
 				  SINGLE_DEPTH_NESTING);
 		handover_exceptions(old_snap, new_snap);
-		up_write(&old_snap->lock);
+		up_write(&lock_snap->lock);
 	}
 	/* An incomplete exception handover is not allowed */
 	BUG_ON(s->handover_snap);


I'll post v2 of the overall handover patch; it will include this patch.

Mike
