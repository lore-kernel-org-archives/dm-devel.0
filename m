From: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
Subject: [PATCH] dm era: Save spacemap metadata root after the
	pre-commit
Date: Fri,  7 Apr 2017 12:14:55 -0700
Message-ID: <20170407191455.14118-1-somasundaram.krishnasamy@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de
Cc: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
List-Id: dm-devel.ids

When committing era metadata to disk, it doesn't always save the latest
spacemap metadata root in superblock. Due to this, metadata is getting
corrupted sometimes when reopening the device. The correct order of update
should be, pre-commit (shadows spacemap root), save the spacemap root
(newly shadowed block) to in-core superblock and then the final commit.

Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
---
 drivers/md/dm-era-target.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ad913cd4aded..330151d6ee42 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -957,15 +957,15 @@ static int metadata_commit(struct era_metadata *md)
 		}
 	}
 
-	r = save_sm_root(md);
+	r = dm_tm_pre_commit(md->tm);
 	if (r) {
-		DMERR("%s: save_sm_root failed", __func__);
+		DMERR("%s: pre commit failed", __func__);
 		return r;
 	}
 
-	r = dm_tm_pre_commit(md->tm);
+	r = save_sm_root(md);
 	if (r) {
-		DMERR("%s: pre commit failed", __func__);
+		DMERR("%s: save_sm_root failed", __func__);
 		return r;
 	}
 
-- 
2.10.0
