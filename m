From: Ahmed Samy <f.fallen45@gmail.com>
Subject: [PATCH] dm cache metadata: fix cmd_read_lock acquiring write lock
Date: Sun, 17 Apr 2016 05:37:09 +0000
Message-ID: <1460871429-22523-1-git-send-email-f.fallen45@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Ahmed Samy <f.fallen45@gmail.com>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

commit 9567366fefdd ("dm cache metadata: fix READ_LOCK macros and cleanup WRITE_LOCK macros")
seemed to use down_write instead of down_read in cmd_read_lock(), yet
releasing it with up_read() in READ_UNLOCK.  Fix it.

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ahmed Samy <f.fallen45@gmail.com>
---
 drivers/md/dm-cache-metadata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 65ce698..3970cda 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -894,9 +894,9 @@ static bool cmd_write_lock(struct dm_cache_metadata *cmd)
 
 static bool cmd_read_lock(struct dm_cache_metadata *cmd)
 {
-	down_write(&cmd->root_lock);
+	down_read(&cmd->root_lock);
 	if (cmd->fail_io) {
-		up_write(&cmd->root_lock);
+		up_read(&cmd->root_lock);
 		return false;
 	}
 	return true;
-- 
2.8.1.210.gb8b4d93
