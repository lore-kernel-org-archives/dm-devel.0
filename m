From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/3] dm thin metadata: check
	__commit_transaction()'s return
Date: Mon, 15 Apr 2019 17:17:17 -0400
Message-ID: <20190415211717.18737-4-snitzer@redhat.com>
References: <20190415211717.18737-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190415211717.18737-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Fix __reserve_metadata_snap() to return early if __commit_transaction()
fails.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index f4e8327abc75..3ba27f5f7da9 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1248,7 +1248,12 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 	 * We commit to ensure the btree roots which we increment in a
 	 * moment are up to date.
 	 */
-	__commit_transaction(pmd);
+	r = __commit_transaction(pmd);
+	if (r < 0) {
+		DMWARN("%s: __commit_transaction() failed, error = %d",
+		       __func__, r);
+		return r;
+	}
 
 	/*
 	 * Copy the superblock.
-- 
2.18.0
