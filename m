From: Mikulas Patocka <mpatocka@redhat.com>
Subject: removing "active" variable in snapshots
Date: Thu, 1 May 2008 19:52:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0805011943530.20655@engineering.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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
To: Alasdair Graeme Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

While working on snapshot merging, I found that there is "active" entry in 
struct dm_snapshot and it looks that it has no meaning:

This variable is set to 0 on snapshot creation in snapshot_ctr
It is set to 1 on snapshot resume (call is made after every creation)
This variable is never set to 0 again.

This variable is read only in __origin_write and snapshots with active == 
0 are skipped.

It looks to me, like it could be removed, the origin is resumed after all 
snapshots, so there is no window where active could be "0" in 
__origin_write. Furthermore, if such condition existed, writing to origin 
without writing to snapshot would damage the snapshot --- so even if 
"active" ever has some effect, it would only result in data corruption.

I need it to be removed for merging, I start merging when snapshot is 
resumed and at this point all other snapshots must be able to accept new 
exceptions, if I excluded a snapshot, it would be corrupted.

Would you agree with this patch to remove the "active" field, or do you 
see some reason for it?

Mikulas

---
  drivers/md/dm-snap.c |   17 ++---------------
  drivers/md/dm-snap.h |    3 ---
  2 files changed, 2 insertions(+), 18 deletions(-)

Index: linux-2.6.25/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-snap.c	2008-05-01 17:16:02.000000000 +0200
+++ linux-2.6.25/drivers/md/dm-snap.c	2008-05-01 17:17:41.000000000 +0200
@@ -557,7 +557,6 @@ static int snapshot_ctr(struct dm_target
  	s->type = persistent;

  	s->valid = 1;
-	s->active = 0;
  	s->last_percent = 0;
  	init_rwsem(&s->lock);
  	s->ti = ti;
@@ -616,7 +615,6 @@ static int snapshot_ctr(struct dm_target
  	}

  	/* Add snapshot to the list of snapshots for this origin */
-	/* Exceptions aren't triggered till snapshot_resume() is called */
  	if (register_snapshot(s)) {
  		r = -EINVAL;
  		ti->error = "Cannot register snapshot origin";
@@ -954,7 +952,6 @@ static int snapshot_map(struct dm_target
  	chunk = sector_to_chunk(s, bio->bi_sector);

  	/* Full snapshots are not usable */
-	/* To get here the table must be live so s->active is always set. */
  	if (!s->valid)
  		return -EIO;

@@ -1027,15 +1024,6 @@ static int snapshot_end_io(struct dm_tar
  	return 0;
  }

-static void snapshot_resume(struct dm_target *ti)
-{
-	struct dm_snapshot *s = ti->private;
-
-	down_write(&s->lock);
-	s->active = 1;
-	up_write(&s->lock);
-}
-
  static int snapshot_status(struct dm_target *ti, status_type_t type,
  			   char *result, unsigned int maxlen)
  {
@@ -1099,8 +1087,8 @@ static int __origin_write(struct list_he

  		down_write(&snap->lock);

-		/* Only deal with valid and active snapshots */
-		if (!snap->valid || !snap->active)
+		/* Only deal with valid snapshots */
+		if (!snap->valid)
  			goto next_snapshot;

  		/* Nothing to do if writing beyond end of snapshot */
@@ -1288,7 +1276,6 @@ static struct target_type snapshot_targe
  	.dtr     = snapshot_dtr,
  	.map     = snapshot_map,
  	.end_io  = snapshot_end_io,
-	.resume  = snapshot_resume,
  	.status  = snapshot_status,
  };

Index: linux-2.6.25/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-snap.h	2008-05-01 17:15:37.000000000 +0200
+++ linux-2.6.25/drivers/md/dm-snap.h	2008-05-01 17:16:30.000000000 +0200
@@ -151,9 +151,6 @@ struct dm_snapshot {
  	/* You can't use a snapshot if this is 0 (e.g. if full) */
  	int valid;

-	/* Origin writes don't trigger exceptions until this is set */
-	int active;
-
  	/* Used for display of table */
  	char type;
