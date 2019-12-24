From: zhengbin <zhengbin13@huawei.com>
Subject: [PATCH 4/4] dm thin metadata: use true,
	false for bool variable
Date: Tue, 24 Dec 2019 14:38:03 +0800
Message-ID: <1577169483-138896-5-git-send-email-zhengbin13@huawei.com>
References: <1577169483-138896-1-git-send-email-zhengbin13@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1577169483-138896-1-git-send-email-zhengbin13@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: zhengbin13@huawei.com
List-Id: dm-devel.ids

Fixes coccicheck warning:

drivers/md/dm-thin-metadata.c:814:3-14: WARNING: Assignment of 0/1 to bool variable
drivers/md/dm-thin-metadata.c:1109:1-12: WARNING: Assignment of 0/1 to bool variable
drivers/md/dm-thin-metadata.c:1621:1-12: WARNING: Assignment of 0/1 to bool variable
drivers/md/dm-thin-metadata.c:1652:1-12: WARNING: Assignment of 0/1 to bool variable
drivers/md/dm-thin-metadata.c:1706:1-12: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/md/dm-thin-metadata.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index b88d6d7..ca03b38 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -811,7 +811,7 @@ static int __write_changed_details(struct dm_pool_metadata *pmd)
 			return r;

 		if (td->open_count)
-			td->changed = 0;
+			td->changed = false;
 		else {
 			list_del(&td->list);
 			kfree(td);
@@ -1106,7 +1106,7 @@ static int __set_snapshot_details(struct dm_pool_metadata *pmd,
 	if (r)
 		return r;

-	td->changed = 1;
+	td->changed = true;
 	td->snapshotted_time = time;

 	snap->mapped_blocks = td->mapped_blocks;
@@ -1618,7 +1618,7 @@ static int __insert(struct dm_thin_device *td, dm_block_t block,
 	if (r)
 		return r;

-	td->changed = 1;
+	td->changed = true;
 	if (inserted)
 		td->mapped_blocks++;

@@ -1649,7 +1649,7 @@ static int __remove(struct dm_thin_device *td, dm_block_t block)
 		return r;

 	td->mapped_blocks--;
-	td->changed = 1;
+	td->changed = true;

 	return 0;
 }
@@ -1703,7 +1703,7 @@ static int __remove_range(struct dm_thin_device *td, dm_block_t begin, dm_block_
 	}

 	td->mapped_blocks -= total_count;
-	td->changed = 1;
+	td->changed = true;

 	/*
 	 * Reinsert the mapping tree.
--
2.7.4
