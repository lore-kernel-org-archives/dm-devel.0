From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/9] dm flakey: use dm_target_offset() and
	support discards
Date: Mon, 27 Jun 2011 15:53:36 -0400
Message-ID: <1309204423-8599-3-git-send-email-snitzer@redhat.com>
References: <1309204423-8599-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1309204423-8599-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index ea79062..70a69b2 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -79,6 +79,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
 	ti->private = fc;
 	return 0;
 
@@ -99,7 +100,7 @@ static sector_t flakey_map_sector(struct dm_target *ti, sector_t bi_sector)
 {
 	struct flakey_c *fc = ti->private;
 
-	return fc->start + (bi_sector - ti->begin);
+	return fc->start + dm_target_offset(ti, bi_sector);
 }
 
 static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
-- 
1.7.1
