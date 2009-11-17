From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 13/12] dm snapshot: avoid
 __minimum_chunk_size() during merge
Date: Tue, 17 Nov 2009 15:35:37 -0500
Message-ID: <20091117203537.GA18929@redhat.com>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
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

The merging snapshot already has the origin's __minimum_chunk_size()
stored in the target's 'split_io'.  Avoid rediscovering it every call to
snapshot_merge_process().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 34d8c3f..f91ee08 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -730,20 +730,25 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 
 test_again:
 	/* Reallocate other snapshots; must account for all 'linear_chunks' */
-	down_read(&_origins_lock);
-	o = __lookup_origin(s->origin->bdev);
 	must_wait = 0;
-	min_chunksize = __minimum_chunk_size(o);
+	/*
+	 * Merging snapshot already has the origin's __minimum_chunk_size()
+	 * stored in split_io (see: snapshot_merge_resume); avoid rediscovery
+	 */
+	min_chunksize = s->ti->split_io;
 	if (min_chunksize) {
 		chunk_t n;
+
+		down_read(&_origins_lock);
+		o = __lookup_origin(s->origin->bdev);
 		for (n = 0; n < io_size; n += min_chunksize) {
 			r = __origin_write(&o->snapshots, dest.sector + n,
 					   NULL);
 			if (r == DM_MAPIO_SUBMITTED)
 				must_wait = 1;
 		}
+		up_read(&_origins_lock);
 	}
-	up_read(&_origins_lock);
 	if (must_wait) {
 		sleep_on_timeout(&_pending_exception_done, HZ / 100 + 1);
 		goto test_again;
