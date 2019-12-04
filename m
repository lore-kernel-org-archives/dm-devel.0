From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH] dm thin: Avoid flushing the data device twice
Date: Wed,  4 Dec 2019 19:06:38 +0200
Message-ID: <20191204170638.28163-1-ntsironis@arrikto.com>
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
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: thornber@redhat.com, ntsironis@arrikto.com
List-Id: dm-devel.ids

Since we flush the data device as part of a metadata commit, it's
redundant to then submit any deferred REQ_PREFLUSH bios.

Add a check in process_deferred_bios() for deferred REQ_PREFLUSH bios
and complete them immediately.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-thin.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e0be545080d0..40d8a255dbc3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2383,8 +2383,18 @@ static void process_deferred_bios(struct pool *pool)
 	while ((bio = bio_list_pop(&bio_completions)))
 		bio_endio(bio);
 
-	while ((bio = bio_list_pop(&bios)))
-		generic_make_request(bio);
+	while ((bio = bio_list_pop(&bios))) {
+		if (bio->bi_opf & REQ_PREFLUSH) {
+			/*
+			 * We just flushed the data device as part of the
+			 * metadata commit, so there is no reason to send
+			 * another flush.
+			 */
+			bio_endio(bio);
+		} else {
+			generic_make_request(bio);
+		}
+	}
 }
 
 static void do_worker(struct work_struct *ws)
-- 
2.11.0
