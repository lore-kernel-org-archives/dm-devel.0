From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 15/17] dm snapshot: make exceptions if merge
	is dispatching to origin
Date: Tue, 20 Oct 2009 18:47:03 -0400
Message-ID: <1256078825-11331-16-git-send-email-snitzer@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
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

If write request to merging snapshot device is to be dispatched
directly to the origin (because the chunk is not remapped or was
already merged), we must make exceptions in other snapshots.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7f0d261..f67bfff 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1529,6 +1529,11 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 
 	bio->bi_bdev = s->origin->bdev;
 
+	if (bio_rw(bio) == WRITE) {
+		up_write(&s->lock);
+		return do_origin(s->origin, bio);
+	}
+
  out_unlock:
 	up_write(&s->lock);
 
-- 
1.6.5.rc2
