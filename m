From: Shenghui Wang <shhuiw@foxmail.com>
Subject: [PATCH] dm writecache: remove unused variable sz in
	writecache_status
Date: Thu, 25 Oct 2018 10:38:32 +0800
Message-ID: <20181025023832.9766-1-shhuiw@foxmail.com>
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
To: mpatocka@redhat.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

sz defined but not used in writecache_status. Remove it.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/dm-writecache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5f1f80d424dd..562c32f644b8 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2226,7 +2226,6 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 {
 	struct dm_writecache *wc = ti->private;
 	unsigned extra_args;
-	unsigned sz = 0;
 	uint64_t x;
 
 	switch (type) {
-- 
2.18.0
