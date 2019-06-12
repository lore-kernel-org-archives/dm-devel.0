From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH] dm-log: use struct_size() to calculate the size
	of struct
Date: Wed, 12 Jun 2019 14:14:46 +0800
Message-ID: <1560320086-14243-2-git-send-email-liuzhengyuan@kylinos.cn>
References: <1560320086-14243-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1560320086-14243-1-git-send-email-liuzhengyuan@kylinos.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: dm-devel.ids

As Gustavo said in other patches doing the same replace, we can now
use the new struct_size() helper to avoid leaving these open-coded and
prone to type mistake.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/dm-log-writes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 9ea2b02..cda6363 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -680,7 +680,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	if (discard_bio)
 		alloc_size = sizeof(struct pending_block);
 	else
-		alloc_size = sizeof(struct pending_block) + sizeof(struct bio_vec) * bio_segments(bio);
+		alloc_size = struct_size(block, vecs, bio_segments(bio));
 
 	block = kzalloc(alloc_size, GFP_NOIO);
 	if (!block) {
-- 
2.7.4


.
