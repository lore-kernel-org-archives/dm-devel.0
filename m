From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/6] dm-delay: Use DM_MAPIO_XXX macros instead of
	0/1 (resend)
Date: Wed, 28 Oct 2015 04:38:55 +0900
Message-ID: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

.map function of dm-delay returns return value of delay_bio(),
hence it's supposed to return either of DM_MAPIO_XXX macros.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 drivers/md/dm-delay.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index b34f6e2..e10f69a 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -237,7 +237,7 @@ static int delay_bio(struct delay_c *dc, int delay, struct bio *bio)
 	unsigned long expires = 0;
 
 	if (!delay || !atomic_read(&dc->may_delay))
-		return 1;
+		return DM_MAPIO_REMAPPED;
 
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
@@ -257,7 +257,7 @@ static int delay_bio(struct delay_c *dc, int delay, struct bio *bio)
 
 	queue_timeout(dc, expires);
 
-	return 0;
+	return DM_MAPIO_SUBMITTED;
 }
 
 static void delay_presuspend(struct dm_target *ti)
-- 
1.7.1
