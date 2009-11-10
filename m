From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4] dm snapshot: allow live exception store
 handover between tables
Date: Tue, 10 Nov 2009 12:47:27 -0500
Message-ID: <20091110174726.GA22788@redhat.com>
References: <1257825316-23227-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1257825316-23227-1-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 09 2009 at 10:55pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Permit in-use snapshot exception data to be 'handed over' from one
> snapshot instance to another.  This is a pre-requisite for patches
> that allow the changes made in a snapshot device to be merged back into
> its origin device and also allows device resizing.
> 
> The basic call sequence is:
> 
>   dmsetup load new_snapshot (referencing the existing in-use cow device)
>      - the ctr code detects that the cow is already in use and links the
>        two snapshot target instances together
>   dmsetup suspend original_snapshot
>   dmsetup resume new_snapshot
>      - the new_snapshot becomes live, and if anything now tries to access
>        the original one it will receive EIO
>   dmsetup remove original_snapshot
> 
> (There can only be two snapshot targets referencing the same cow device
> simultaneously.)
...

As part of this v4 patch I introduced snapshot_preresume and added
handover validation checks:

> +static int snapshot_preresume(struct dm_target *ti)
> +{
> +	struct dm_snapshot *s = ti->private;
> +	struct dm_snapshot *snap_src, *snap_dest;
> +
> +	if (lock_snapshots_for_handover(s, &snap_src, &snap_dest)) {
> +		if (s == snap_dest && !snap_src->suspended) {
> +			/* make sure snap_src is suspended */
> +			DMERR("Unable to accept exceptions from a "
> +			      "snapshot that is not suspended, "
> +			      "cancelling handover.");
> +			__unlink_snapshots_for_handover(snap_src, snap_dest);
> +			snap_dest->valid = 0;
> +		} else if (s == snap_src) {
> +			/*
> +			 * snap_dest is invalid if snap_src is
> +			 * resumed before it
> +			 */
> +			DMERR("Unable to handover exceptions to another "
> +			      "snapshot on resume, cancelling handover.");
> +			__unlink_snapshots_for_handover(snap_src, snap_dest);
> +			snap_dest->valid = 0;
> +		}
> +		unlock_snapshots_for_handover(snap_src, snap_dest);
> +	}
> +
> +	/* returning failure leaves target suspended, best to avoid hung IO */
> +	return 0;
> +}

I used snapshot_preresume because it can return errors to userspace, but
I stopped short of actually returning errors because it left the merging
snapshot suspended (which causes various IO hangs when running lvm2
commands after the failed resume).

I shouldn't have done that.  We're already beyond the commit point
(both in terms of lvm2's VG metadata, and DM's swap_table) so it doesn't
make sense to allow the snapshot that is to be merged to become active
again in the same transaction.

But we can make DM more tolerant of out of order resumes by keeping the
snapshot suspended (returning failure from snapshot_preresume) and _not_
cancelling the handover.  This way if/when the snapshot-merge is resumed
it'll complete handover as expected.  The following incremental patch
has been tested to work well:

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5e53ee2..153ba37 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1665,6 +1666,7 @@ static void snapshot_presuspend(struct dm_target *ti)
 
 static int snapshot_preresume(struct dm_target *ti)
 {
+	int r = 0;
 	struct dm_snapshot *s = ti->private;
 	struct dm_snapshot *snap_src, *snap_dest;
 
@@ -1676,21 +1678,23 @@ static int snapshot_preresume(struct dm_target *ti)
 			      "cancelling handover.");
 			__unlink_snapshots_for_handover(snap_src, snap_dest);
 			snap_dest->valid = 0;
+			r = -EINVAL;
 		} else if (s == snap_src) {
 			/*
-			 * snap_dest is invalid if snap_src is
-			 * resumed before it
+			 * do not allow merging snapshot to resume before
+			 * the snapshot-merge target
 			 */
 			DMERR("Unable to handover exceptions to another "
-			      "snapshot on resume, cancelling handover.");
-			__unlink_snapshots_for_handover(snap_src, snap_dest);
-			snap_dest->valid = 0;
+			      "snapshot on resume.\n"
+			      "Deferring handover until snapshot-merge "
+			      "is resumed.");
+			r = -EINVAL;
 		}
 		unlock_snapshots_for_handover(snap_src, snap_dest);
 	}
 
 	/* returning failure leaves target suspended, best to avoid hung IO */
-	return 0;
+	return r;
 }
 
 static void snapshot_resume(struct dm_target *ti)
