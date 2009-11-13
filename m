From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 02/17] dm snapshot: add suspended flag to
	dm_snapshot
Date: Fri, 13 Nov 2009 09:48:12 -0500
Message-ID: <20091113144812.GB18455@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
	<1256078825-11331-3-git-send-email-snitzer@redhat.com>
	<20091105005635.GN13375@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091105005635.GN13375@agk-dp.fab.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 04 2009 at  7:56pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Tue, Oct 20, 2009 at 06:46:50PM -0400, Mike Snitzer wrote:
> > Allow the snapshot target to be able to verify its state relative to a
> > requested operation.  Allows for invalid operations to be prevented,
> > e.g. an attempt handover an "old" snapshot's exceptions without it
> > having been suspended first.
>  
> OK - same as we do in dm-raid1.
> 
> But just be aware that:
>         /* This does not get reverted if there's an error later. */
>         dm_table_presuspend_targets(map);
> 
> and so it's not identical to querying the dm_suspended() property directly.

Alasdair,

I think it would be best to drop this patch.  We can accomplish the same
using Mike Anderson's new dm_table_md_suspended:
http://patchwork.kernel.org/patch/59743/

Dropping dm-snapshot-track-suspended-state-in-target.patch requires a
small tweak to
dm-snapshot-allow-live-exception-store-handover-between-tables.patch

The following just illustrates how minimal this change is.  For your
convenience I'll just send v8 of the handover patch that includes this
change (and it will also bump the snapshot target's version now that
dm-snapshot-track-suspended-state-in-target.patch is out of the
picture).
---

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index fce0c39..1543932 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1325,6 +1325,7 @@ static int snapshot_preresume(struct dm_target *ti)
 			up_write(&snap_src->lock);
 			goto normal_snapshot;
 		}
+		up_write(&snap_src->lock);
 		if (s == snap_src) {
 			/* handover source must not resume before destination */
 			DMERR("Unable to handover exceptions on "
@@ -1334,13 +1335,12 @@ static int snapshot_preresume(struct dm_target *ti)
 			r = -EINVAL;
 		} else {
 			/* if handover-destination, source must be suspended */
-			if (!snap_src->suspended) {
+			if (!dm_table_md_suspended(snap_src->ti->table)) {
 				DMERR("Unable to accept exceptions from a "
 				      "snapshot that is not suspended.");
 				r = -EINVAL;
 			}
 		}
-		up_write(&snap_src->lock);
 	}
 
 normal_snapshot:
