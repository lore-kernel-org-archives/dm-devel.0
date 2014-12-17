From: alex chen <alex.chen@huawei.com>
Subject: [PATCH] dm: check error instead of r in clone_endio
Date: Wed, 17 Dec 2014 14:37:04 +0800
Message-ID: <54912490.8030808@huawei.com>
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
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
List-Id: dm-devel.ids

In the clone_endio, when target_type is linear and WRITE SAME bio
fails, r will be always be initialized 0 because of null end_io, and
in this case WRITE SAME will not be disabled.
So we should check error instead of r.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6aa2592..3642d10 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -791,7 +791,7 @@ static void clone_endio(struct bio *bio, int error)
 		}
 	}

-	if (unlikely(r == -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
+	if (unlikely(error == -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
 		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors))
 		disable_write_same(md);

-- 
1.8.4.3
