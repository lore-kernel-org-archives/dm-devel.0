From: heinzm@redhat.com
Subject: [PATCH] dm raid1: the device-mapper 'mirror' target
	errors written bios erroneously
Date: Wed, 23 Mar 2016 21:06:27 +0100
Message-ID: <1458763587-9307-1-git-send-email-heinzm@redhat.com>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

	The device-mapper 'mirror' target errors correctly written
	bios erroneously in hold_bio() in case the mapped device is
	suspended and flushs are allowed.

	Because the caller already copes with erroring such bios in
	case all mirror legs got failed, any getting to hold_bio()
	are good, thus the patch sets bio->bi_error to 0.

	Resolves: rhbz1307111
---
 drivers/md/dm-raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index b3ccf1e..2285ab2 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -492,7 +492,7 @@ static void hold_bio(struct mirror_set *ms, struct bio *bio)
 		if (dm_noflush_suspending(ms->ti))
 			bio->bi_error = DM_ENDIO_REQUEUE;
 		else
-			bio->bi_error = -EIO;
+			bio->bi_error = 0;
 
 		bio_endio(bio);
 		return;
-- 
2.5.0
