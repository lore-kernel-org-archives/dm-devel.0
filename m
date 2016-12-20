From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] dm bufio: use rb_entry()
Date: Tue, 20 Dec 2016 22:02:10 +0800
Message-ID: <ddabc96c798df194791134d8e070d728e2a7b59f.1482203698.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/md/dm-bufio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 84d2f0e..ae3c396 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -266,7 +266,7 @@ static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)
 	struct dm_buffer *b;
 
 	while (n) {
-		b = container_of(n, struct dm_buffer, node);
+		b = rb_entry(n, struct dm_buffer, node);
 
 		if (b->block == block)
 			return b;
@@ -283,7 +283,7 @@ static void __insert(struct dm_bufio_client *c, struct dm_buffer *b)
 	struct dm_buffer *found;
 
 	while (*new) {
-		found = container_of(*new, struct dm_buffer, node);
+		found = rb_entry(*new, struct dm_buffer, node);
 
 		if (found->block == b->block) {
 			BUG_ON(found != b);
-- 
2.9.3
