From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH v2] dm bio prison: use rb_entry()
Date: Sat,  6 May 2017 23:39:10 +0800
Message-ID: <ddb7846622c75a58f7cd872f36c4c22d4b4ce7d4.1493722271.git.geliangtang@gmail.com>
References: <478774bc-7af1-58a6-7c3e-36745249d61b@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <478774bc-7af1-58a6-7c3e-36745249d61b@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Acked-by: Coly Li <colyli@suse.de>
---
Changes in v2:
 - Apply to dm-bio-prison-v1.c and dm-bio-prison-v2.c
---
 drivers/md/dm-bio-prison-v1.c | 2 +-
 drivers/md/dm-bio-prison-v2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index ae7da2c..f8d221b 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -116,7 +116,7 @@ static int __bio_detain(struct dm_bio_prison *prison,
 
 	while (*new) {
 		struct dm_bio_prison_cell *cell =
-			container_of(*new, struct dm_bio_prison_cell, node);
+			rb_entry(*new, struct dm_bio_prison_cell, node);
 
 		r = cmp_keys(key, &cell->key);
 
diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index c9b11f7..8ce3a1a 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -120,7 +120,7 @@ static bool __find_or_insert(struct dm_bio_prison_v2 *prison,
 
 	while (*new) {
 		struct dm_bio_prison_cell_v2 *cell =
-			container_of(*new, struct dm_bio_prison_cell_v2, node);
+			rb_entry(*new, struct dm_bio_prison_cell_v2, node);
 
 		r = cmp_keys(key, &cell->key);
 
-- 
2.9.3
