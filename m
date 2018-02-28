From: Qu Wenruo <wqu@suse.com>
Subject: [PATCH 2/2] log-writes: Add support for METADATA flag
Date: Wed, 28 Feb 2018 15:33:26 +0800
Message-ID: <20180228073326.30106-2-wqu@suse.com>
References: <20180228073326.30106-1-wqu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180228073326.30106-1-wqu@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, jbacik@fb.com
List-Id: dm-devel.ids

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 log-writes.c | 3 ++-
 log-writes.h | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/log-writes.c b/log-writes.c
index 5ef328656c89..651db43383ba 100644
--- a/log-writes.c
+++ b/log-writes.c
@@ -127,7 +127,8 @@ struct flags_to_str_entry {
 	DEFINE_LOG_FLAGS_STR_ENTRY(FLUSH),
 	DEFINE_LOG_FLAGS_STR_ENTRY(FUA),
 	DEFINE_LOG_FLAGS_STR_ENTRY(DISCARD),
-	DEFINE_LOG_FLAGS_STR_ENTRY(MARK)
+	DEFINE_LOG_FLAGS_STR_ENTRY(MARK),
+	DEFINE_LOG_FLAGS_STR_ENTRY(METADATA)
 };
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/log-writes.h b/log-writes.h
index 13f98ffe1730..ce41262f6aaa 100644
--- a/log-writes.h
+++ b/log-writes.h
@@ -12,10 +12,11 @@ extern int log_writes_verbose;
 typedef __u64 u64;
 typedef __u32 u32;
 
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
