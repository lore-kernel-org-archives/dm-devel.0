From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v6] dm snapshot: allow live exception store
 handover between tables
Date: Wed, 11 Nov 2009 14:37:57 -0500
Message-ID: <20091111193757.GA30110@redhat.com>
References: <1257958132-19737-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1257958132-19737-1-git-send-email-snitzer@redhat.com>
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

On Wed, Nov 11 2009 at 11:48am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> +static struct dm_snapshot *find_snapshot_using_cow(struct dm_snapshot *snap)
> +{
> +	struct dm_snapshot *s, *handover_snap = NULL;
> +	struct origin *o;
> +
> +	down_read(&_origins_lock);
> +
> +	o = __lookup_origin(snap->origin->bdev);
> +	if (!o)
> +		goto out;
> +
> +	list_for_each_entry(s, &o->snapshots, list) {
> +		if (s == snap || !bdev_equal(s->cow->bdev, snap->cow->bdev))
> +			continue;
> +
> +		handover_snap = s;
> +		break;
> +	}
> +
> +out:
> +	up_read(&_origins_lock);
> +
> +	return handover_snap;
> +}

find_snapshot_using_cow() incorrectly assumed that the new snapshot
(handover-destination) was already put on the origin's 'snapshots'
list.  So it looked to make sure it didn't return the new snapshot
(handover-destination) that was being constructed via snapshot_ctr().
Originally find_snapshot_using_cow() was only ever called from
snapshot_ctr().

The new snapshot (handover-destination) doesn't get added to the
origin's snapshot list until after handover_exceptions() -- via
snapshot_resume()'s register_snapshot().

My v6 patch leverages the fact that only one snapshot with a given cow
device is on the origin's snapshots list.  So in snapshot_preresume(),
and else where, I use find_snapshot_using_cow() to determine if the
current snapshot is the handover-source (s == snap_src) or not.

Look story short, I need to change find_snapshot_using_cow() with the
following incremental patch.  I also make sure that both the
snapshot-source and snapshot-destination are not on the origin's
snapshots list at the same time by unregistering the handover-source.

I'll post v7 to include these changes (this is getting tiresome
now.. hopefully v7 will be the last rev that'll get in agk's editing
tree!?):

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1d17c4f..db21c0a 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -558,11 +558,10 @@ static struct dm_snapshot *find_snapshot_using_cow(struct dm_snapshot *snap)
 		goto out;
 
 	list_for_each_entry(s, &o->snapshots, list) {
-		if (s == snap || !bdev_equal(s->cow->bdev, snap->cow->bdev))
-			continue;
-
-		handover_snap = s;
-		break;
+		if (bdev_equal(s->cow->bdev, snap->cow->bdev)) {
+			handover_snap = s;
+			break;
+		}
 	}
 
 out:
@@ -1636,12 +1635,17 @@ static void snapshot_resume(struct dm_target *ti)
 		}
 		up_write(&snap_src->lock);
 
-		if (snap_dest && register_snapshot(snap_dest)) {
-			DMERR("Unable to register snapshot "
-			      "after exception handover.");
-			down_write(&snap_dest->lock);
-			snap_dest->valid = 0;
-			up_write(&snap_dest->lock);
+		if (snap_dest) {
+			if (register_snapshot(snap_dest)) {
+				DMERR("Unable to register snapshot "
+				      "after exception handover.");
+				down_write(&snap_dest->lock);
+				snap_dest->valid = 0;
+				up_write(&snap_dest->lock);
+				return;
+			}
+			/* unregister handover-source */
+			unregister_snapshot(snap_src);
 		}
 	}
 
