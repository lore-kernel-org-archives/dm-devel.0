From: "Pavel Begunkov (Silence)" <asml.silence@gmail.com>
Subject: [PATCH 1/1] dm: Update comment
Date: Thu, 20 Jun 2019 20:50:50 +0300
Message-ID: <08f06799d0336322ae85b3f8ba3acfb68180a96d.1561052999.git.asml.silence@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
List-Id: dm-devel.ids

From: Pavel Begunkov <asml.silence@gmail.com>

Since Commit a1ce35fa49852db60fc6e268 ("block: remove dead elevator
code") blk_end_request() has been replaced with blk_mq_end_request().
Update comment

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/md/dm-rq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 5f7063f05ae0..c9e44ac1f9a6 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -115,7 +115,7 @@ static void end_clone_bio(struct bio *clone)
 
 	/*
 	 * Update the original request.
-	 * Do not use blk_end_request() here, because it may complete
+	 * Do not use blk_mq_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
 	if (is_last)
-- 
2.22.0
