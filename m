From: Jieun Kim <jieun.kim4758@gmail.com>
Subject: [PATCH 1/2] drivers: md: dm-log.c: Remove unused variable 'sz'
Date: Sun,  1 Dec 2019 14:42:19 +0900
Message-ID: <20191201054219.13146-1-Jieun.Kim4758@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Jieun Kim <Jieun.Kim4758@gmail.com>
List-Id: dm-devel.ids

Remove unused variable 'sz' in core_status function
detected by coccinelle scripts(returnvar.cocci)

Signed-off-by: Jieun Kim <Jieun.Kim4758@gmail.com>
---
 drivers/md/dm-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 33e71ea6cc14..8800ec1847b5 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -781,7 +781,6 @@ static region_t core_get_sync_count(struct dm_dirty_log *log)
 static int core_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
-	int sz = 0;
 	struct log_c *lc = log->context;
 
 	switch(status) {
@@ -795,7 +794,7 @@ static int core_status(struct dm_dirty_log *log, status_type_t status,
 		DMEMIT_SYNC;
 	}
 
-	return sz;
+	return 0;
 }
 
 static int disk_status(struct dm_dirty_log *log, status_type_t status,
-- 
2.17.1
