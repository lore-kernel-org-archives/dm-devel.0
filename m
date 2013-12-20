From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 06/20] dm persistent data: cleanup
	dm-thin specific references in text
Date: Fri, 20 Dec 2013 18:37:19 -0500
Message-ID: <1387582653-13647-7-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

DM's persistent-data library is now used my multiple targets so
exclusive references to "pool" or "thin provisioning" need to be
cleaned up.  Adjust Kconfig's DM_DEBUG_BLOCK_STACK_TRACING text
and remove "pool" from a block manager error message.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Kconfig                            | 6 +++---
 drivers/md/persistent-data/dm-block-manager.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f2ccbc3..7441344 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -250,12 +250,12 @@ config DM_THIN_PROVISIONING
          Provides thin provisioning and snapshots that share a data store.
 
 config DM_DEBUG_BLOCK_STACK_TRACING
-	boolean "Keep stack trace of thin provisioning block lock holders"
-	depends on STACKTRACE_SUPPORT && DM_THIN_PROVISIONING
+	boolean "Keep stack trace of persistent data block lock holders"
+	depends on STACKTRACE_SUPPORT && DM_PERSISTENT_DATA
 	select STACKTRACE
 	---help---
 	  Enable this for messages that may help debug problems with the
-	  block manager locking used by thin provisioning.
+	  block manager locking used by thin provisioning and caching.
 
 	  If unsure, say N.
 
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 064a3c2..455f792 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -104,7 +104,7 @@ static int __check_holder(struct block_lock *lock)
 
 	for (i = 0; i < MAX_HOLDERS; i++) {
 		if (lock->holders[i] == current) {
-			DMERR("recursive lock detected in pool metadata");
+			DMERR("recursive lock detected in metadata");
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 			DMERR("previously held here:");
 			print_stack_trace(lock->traces + i, 4);
-- 
1.8.1.4
