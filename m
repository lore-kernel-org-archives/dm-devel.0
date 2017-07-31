From: Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] dm-integrity: Do not check integrity for failed
	read operations
Date: Mon, 31 Jul 2017 16:22:20 +0900
Message-ID: <1501485740-27519-1-git-send-email-hyc.lee@gmail.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: kernel-team@lge.com, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hyunchul Lee <cheol.lee@lge.com>

Even though read operations fail, dm_integrity_map_continue()
calls integrity_metadata() to check integrity. In this case,
just complete these.

Signed-off-by: Hyunchul Lee <cheol.lee@lge.com>
---
 drivers/md/dm-integrity.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 10f123e..f99eee9 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1697,7 +1697,11 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 
 	if (need_sync_io) {
 		wait_for_completion_io(&read_comp);
-		integrity_metadata(&dio->work);
+		if (likely(!bio->bi_status))
+			integrity_metadata(&dio->work);
+		else
+			dec_in_flight(dio);
+
 	} else {
 		INIT_WORK(&dio->work, integrity_metadata);
 		queue_work(ic->metadata_wq, &dio->work);
-- 
1.9.1
