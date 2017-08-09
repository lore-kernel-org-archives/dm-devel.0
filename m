From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/7] dm: Fix the second dec_pending() argument in
	__split_and_process_bio()
Date: Wed, 9 Aug 2017 11:32:10 -0700
Message-ID: <20170809183216.526-2-bart.vanassche@wdc.com>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170809183216.526-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Detected by sparse.

Fixes: commit 4e4cbee93d56 ("block: switch bios to blk_status_t")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Laurence Oberman <loberman@redhat.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2edbcc2d7d3f..8298670757e9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1523,7 +1523,7 @@ static void __split_and_process_bio(struct mapped_device *md,
 	}
 
 	/* drop the extra reference count */
-	dec_pending(ci.io, error);
+	dec_pending(ci.io, errno_to_blk_status(error));
 }
 /*-----------------------------------------------------------------
  * CRUD END
-- 
2.13.3
