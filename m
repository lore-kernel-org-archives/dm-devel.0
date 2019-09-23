From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] dm clone: Make __hash_find static
Date: Mon, 23 Sep 2019 14:11:11 +0800
Message-ID: <20190923061111.39956-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, ntsironis@arrikto.com, iliastsi@arrikto.com
Cc: linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: dm-devel.ids

drivers/md/dm-clone-target.c:594:34: warning:
 symbol '__hash_find' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/md/dm-clone-target.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index cd6f9e9..0f99b68 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -591,8 +591,9 @@ static struct hash_table_bucket *get_hash_table_bucket(struct clone *clone,
  *
  * NOTE: Must be called with the bucket lock held
  */
-struct dm_clone_region_hydration *__hash_find(struct hash_table_bucket *bucket,
-					      unsigned long region_nr)
+static struct
+dm_clone_region_hydration *__hash_find(struct hash_table_bucket *bucket,
+				       unsigned long region_nr)
 {
 	struct dm_clone_region_hydration *hd;
 
-- 
2.7.4
