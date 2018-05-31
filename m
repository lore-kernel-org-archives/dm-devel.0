From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] dm writecache: fix return value check in writecache_ctr()
Date: Thu, 31 May 2018 11:53:15 +0000
Message-ID: <1527767595-76082-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

Function dm_io_client_create() and dm_kcopyd_client_create() return
ERR_PTR() not NULL in case of error. The NULL test in the return value
check should be replaced with IS_ERR()

Fixes: 2105231db61b ("dm: add writecache target")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/dm-writecache.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 844c4fb..0b2b436 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1872,9 +1872,10 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	wc->dm_io = dm_io_client_create();
-	if (!wc->dm_io) {
-		r = -ENOMEM;
+	if (IS_ERR(wc->dm_io)) {
+		r = PTR_ERR(wc->dm_io);
 		ti->error = "Unable to allocate dm-io client";
+		wc->dm_io = NULL;
 		goto bad;
 	}
 
@@ -2096,9 +2097,10 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		}
 
 		wc->dm_kcopyd = dm_kcopyd_client_create(&dm_kcopyd_throttle);
-		if (!wc->dm_kcopyd) {
-			r = -ENOMEM;
+		if (IS_ERR(wc->dm_kcopyd)) {
+			r = PTR_ERR(wc->dm_kcopyd);
 			ti->error = "Unable to allocate dm-kcopyd client";
+			wc->dm_kcopyd = NULL;
 			goto bad;
 		}
