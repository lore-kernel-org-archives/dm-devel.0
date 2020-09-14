From: Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] dm integrity: convert to use le64_add_cpu()
Date: Mon, 14 Sep 2020 12:17:49 +0800
Message-ID: <20200914041749.3702000-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>
List-Id: dm-devel.ids

Convert cpu_to_le64(le64_to_cpu(E1) + E2) to use le64_add_cpu().

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 3fc3757def55..cf9dadd55625 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3696,7 +3696,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 retest_commit_id:
 		for (j = 0; j < i; j++) {
 			if (ic->commit_ids[j] == ic->commit_ids[i]) {
-				ic->commit_ids[i] = cpu_to_le64(le64_to_cpu(ic->commit_ids[i]) + 1);
+				le64_add_cpu(&ic->commit_ids[i], 1);
 				goto retest_commit_id;
 			}
 		}
-- 
2.25.1
