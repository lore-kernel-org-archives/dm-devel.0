From: Qu Wenruo <wqu@suse.com>
Subject: [PATCH 2/2] fstests: log-writes: Add support for
	METADATA flag
Date: Thu,  1 Mar 2018 13:38:21 +0800
Message-ID: <20180301053821.18718-3-wqu@suse.com>
References: <20180301053821.18718-1-wqu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301053821.18718-1-wqu@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: fstests@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 src/log-writes/log-writes.c | 3 ++-
 src/log-writes/log-writes.h | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
index 181dabf442de..168fea905ef3 100644
--- a/src/log-writes/log-writes.c
+++ b/src/log-writes/log-writes.c
@@ -130,7 +130,8 @@ struct flags_to_str_entry {
 	DEFINE_LOG_FLAGS_STR_ENTRY(FLUSH),
 	DEFINE_LOG_FLAGS_STR_ENTRY(FUA),
 	DEFINE_LOG_FLAGS_STR_ENTRY(DISCARD),
-	DEFINE_LOG_FLAGS_STR_ENTRY(MARK)
+	DEFINE_LOG_FLAGS_STR_ENTRY(MARK),
+	DEFINE_LOG_FLAGS_STR_ENTRY(METADATA)
 };
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/src/log-writes/log-writes.h b/src/log-writes/log-writes.h
index 35ca35838aac..75fb8ac0bf79 100644
--- a/src/log-writes/log-writes.h
+++ b/src/log-writes/log-writes.h
@@ -20,10 +20,11 @@ typedef __u32 u32;
 /*
  * Constants copied from kernel file drivers/md/dm-log-writes.c
  */
-#define LOG_FLUSH_FLAG (1 << 0)
-#define LOG_FUA_FLAG (1 << 1)
-#define LOG_DISCARD_FLAG (1 << 2)
-#define LOG_MARK_FLAG (1 << 3)
+#define LOG_FLUSH_FLAG		(1 << 0)
+#define LOG_FUA_FLAG		(1 << 1)
+#define LOG_DISCARD_FLAG	(1 << 2)
+#define LOG_MARK_FLAG		(1 << 3)
+#define LOG_METADATA_FLAG	(1 << 4)
 
 #define WRITE_LOG_VERSION 1
 #define WRITE_LOG_MAGIC 0x6a736677736872
-- 
2.16.2
