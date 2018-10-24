From: Shenghui Wang <shhuiw@foxmail.com>
Subject: [PATCH] dm writecache: fix typo in error msg for
	creating writecache_flush_thread
Date: Wed, 24 Oct 2018 16:04:36 +0800
Message-ID: <20181024080436.2230-1-shhuiw@foxmail.com>
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

The error msg should be "flush thread" instead of "endio thread"
for writecache_flush_thread.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/dm-writecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5f1f80d424dd..d656bd1799ae 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2064,7 +2064,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		if (IS_ERR(wc->flush_thread)) {
 			r = PTR_ERR(wc->flush_thread);
 			wc->flush_thread = NULL;
-			ti->error = "Couldn't spawn endio thread";
+			ti->error = "Couldn't spawn flush thread";
 			goto bad;
 		}
 		wake_up_process(wc->flush_thread);
-- 
2.18.0
