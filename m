From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 20/17] dm thin: optimize
	retry_bios_on_resume
Date: Sun, 19 Oct 2014 19:02:36 -0400
Message-ID: <1413759757-7935-3-git-send-email-snitzer@redhat.com>
References: <1413759757-7935-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413759757-7935-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Eliminate redundant should_error_unserviceable_bio check and error
loop.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1351df0..917ade5 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1263,13 +1263,8 @@ static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *c
 	bio_list_init(&bios);
 	cell_release(pool, cell, &bios);
 
-	error = should_error_unserviceable_bio(pool);
-	if (error)
-		while ((bio = bio_list_pop(&bios)))
-			bio_endio(bio, error);
-	else
-		while ((bio = bio_list_pop(&bios)))
-			retry_on_resume(bio);
+	while ((bio = bio_list_pop(&bios)))
+		retry_on_resume(bio);
 }
 
 static void process_discard_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
-- 
1.8.3.1
