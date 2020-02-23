From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] dm thin metadata: fix lockdep complaint
Date: Sun, 23 Feb 2020 14:54:58 -0500
Message-ID: <20200223195458.1196339-1-tytso@mit.edu>
References: <20200220234519.GA620489@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200220234519.GA620489@mit.edu>
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
Cc: Theodore Ts'o <tytso@mit.edu>, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

[ 3934.173244] ======================================================
[ 3934.179572] WARNING: possible circular locking dependency detected
[ 3934.185884] 5.4.21-xfstests #1 Not tainted
[ 3934.190151] ------------------------------------------------------
[ 3934.196673] dmsetup/8897 is trying to acquire lock:
[ 3934.201688] ffffffffbce82b18 (shrinker_rwsem){++++}, at: unregister_shrinker+0x22/0x80
[ 3934.210268]
               but task is already holding lock:
[ 3934.216489] ffff92a10cc5e1d0 (&pmd->root_lock){++++}, at: dm_pool_metadata_close+0xba/0x120
[ 3934.225083]
               which lock already depends on the new lock.

[ 3934.564165] Chain exists of:
                 shrinker_rwsem --> &journal->j_checkpoint_mutex --> &pmd->root_lock

For a more detailed lockdep report, please see:

	https://lore.kernel.org/r/20200220234519.GA620489@mit.edu

We shouldn't need to hold the lock while are just tearing down and
freeing the whole metadata pool structure.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/md/dm-thin-metadata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index fc9947d6210c..76b6b323bf4b 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -960,9 +960,9 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
 			DMWARN("%s: __commit_transaction() failed, error = %d",
 			       __func__, r);
 	}
+	pmd_write_unlock(pmd);
 	if (!pmd->fail_io)
 		__destroy_persistent_data_objects(pmd);
-	pmd_write_unlock(pmd);
 
 	kfree(pmd);
 	return 0;
-- 
2.24.1
