From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 10/12]
	dm-snapshot-merge-make-exceptions-in-other-snapshots-if-remapped-to-origin
Date: Mon,  5 Oct 2009 15:02:45 -0400
Message-ID: <1254769367-12111-11-git-send-email-snitzer@redhat.com>
References: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
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

If dispatching write request to merging snapshot device directly to the origin
(because the chunk is not remapped or was already merged), we must make
exceptions in other snapshots.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3be57ba..8060fe3 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1488,6 +1488,11 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 
 	bio->bi_bdev = s->origin->bdev;
 
+	if (bio_rw(bio) == WRITE) {
+		up_write(&s->lock);
+		return do_origin(s->origin, bio);
+	}
+
  out_unlock:
 	up_write(&s->lock);
 
-- 
1.6.2.5
