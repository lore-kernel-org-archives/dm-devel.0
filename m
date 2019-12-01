From: Jieun Kim <jieun.kim4758@gmail.com>
Subject: [PATCH 2/2] drivers: md: dm-log.c: Remove unused
	variable 'sz'
Date: Sun,  1 Dec 2019 14:42:57 +0900
Message-ID: <20191201054257.13199-1-Jieun.Kim4758@gmail.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jieun Kim <Jieun.Kim4758@gmail.com>, dm-devel@redhat.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Remove unused variable 'sz' in disk_status function
detected by coccinelle scripts(returnvar.cocci)

Signed-off-by: Jieun Kim <Jieun.Kim4758@gmail.com>
---
 drivers/md/dm-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 8800ec1847b5..67e74362c6ac 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -800,7 +800,6 @@ static int core_status(struct dm_dirty_log *log, status_type_t status,
 static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
-	int sz = 0;
 	struct log_c *lc = log->context;
 
 	switch(status) {
@@ -818,7 +817,7 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		DMEMIT_SYNC;
 	}
 
-	return sz;
+	return 0;
 }
 
 static struct dm_dirty_log_type _core_type = {
-- 
2.17.1
