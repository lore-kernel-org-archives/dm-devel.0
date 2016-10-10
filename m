From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid1: "mirror" target read error on default
	leg failure
Date: Mon, 10 Oct 2016 17:58:23 +0200
Message-ID: <1476115103-23203-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

In case the default leg of a "mirror" target fails, any read will
cause a new, operational default leg to be selected and the read be
resubmitted to it. Nonetheless that io succeeds, an error will be
reported back because bio->bi_error was not cleared properly.

Fix by clearing bio->bi_error before resubmission.

Resolves: rhbz1382516

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index bdf1606..7a6254d 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1292,6 +1292,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 
 			dm_bio_restore(bd, bio);
 			bio_record->details.bi_bdev = NULL;
+			bio->bi_error = 0;
 
 			queue_bio(ms, bio, rw);
 			return DM_ENDIO_INCOMPLETE;
-- 
2.7.4
