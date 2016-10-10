From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid1: "mirror" target doesn't use all
	available legs on multiple failures
Date: Mon, 10 Oct 2016 18:48:06 +0200
Message-ID: <1476118086-2975-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

In case legs of a "mirror" target fail, any read will cause a new,
operational default leg to be selected and the read be resubmitted
to it. If that new default leg fails the read too, no other still
accessible legs are used to resubmit the read again thus failing
the io.

Fix by allowing the read to get resubmitted until there's no
operational legs any more.

Resolves: rhbz1383444

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid1.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 7a6254d..dd31019 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1266,16 +1266,6 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 		goto out;
 
 	if (unlikely(error)) {
-		if (!bio_record->details.bi_bdev) {
-			/*
-			 * There wasn't enough memory to record necessary
-			 * information for a retry or there was no other
-			 * mirror in-sync.
-			 */
-			DMERR_LIMIT("Mirror read failed.");
-			return -EIO;
-		}
-
 		m = bio_record->m;
 
 		DMERR("Mirror read failed from %s. Trying alternative device.",
@@ -1291,7 +1281,6 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 			bd = &bio_record->details;
 
 			dm_bio_restore(bd, bio);
-			bio_record->details.bi_bdev = NULL;
 			bio->bi_error = 0;
 
 			queue_bio(ms, bio, rw);
-- 
2.7.4
