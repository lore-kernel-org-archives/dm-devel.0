From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] dm bio prison: use rb_entry()
Date: Fri, 20 Jan 2017 22:36:54 +0800
Message-ID: <edf46b9e198bf2b0c0a31a9b99da6e59e880cdb9.1484816756.git.geliangtang@gmail.com>
References: <c6a809ea5820242a4ae126b03cdcd910a36e5cae.1484817152.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c6a809ea5820242a4ae126b03cdcd910a36e5cae.1484817152.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/md/dm-bio-prison.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
index 03af174..a2c8a9e 100644
--- a/drivers/md/dm-bio-prison.c
+++ b/drivers/md/dm-bio-prison.c
@@ -115,7 +115,7 @@ static int __bio_detain(struct dm_bio_prison *prison,
 
 	while (*new) {
 		struct dm_bio_prison_cell *cell =
-			container_of(*new, struct dm_bio_prison_cell, node);
+			rb_entry(*new, struct dm_bio_prison_cell, node);
 
 		r = cmp_keys(key, &cell->key);
 
-- 
2.9.3
