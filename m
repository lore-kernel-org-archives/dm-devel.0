From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 09/13] dm snapshot: do not merge a chunk until
	active writes to it finish
Date: Thu,  3 Dec 2009 21:23:50 -0500
Message-ID: <1259893434-10792-10-git-send-email-snitzer@redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Track merging snapshot device's in-progress writes, to chunks that
were already remapped, and delay merging a chunk until all writes to
that chunk finish.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3504672..45c47b0 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -788,7 +788,8 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 	s->merge_write_interlock_n = 1;
 	up_write(&s->lock);
 
-	/* !!! FIXME: wait until writes to this chunk drain */
+	while (__chunk_is_tracked(s, old_chunk))
+		msleep(1);
 
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, merge_callback, s);
 	return;
@@ -1561,7 +1562,11 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 			r = DM_MAPIO_SUBMITTED;
 			goto out_unlock;
 		}
+
 		remap_exception(s, e, bio, chunk);
+
+		if (bio_rw(bio) == WRITE)
+			map_context->ptr = track_chunk(s, chunk);
 		goto out_unlock;
 	}
 
-- 
1.6.5.2
