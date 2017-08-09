From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/7] dm: Fix printk() rate limiting code
Date: Wed, 9 Aug 2017 11:32:11 -0700
Message-ID: <20170809183216.526-3-bart.vanassche@wdc.com>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170809183216.526-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>, Namhyung Kim <namhyung@gmail.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Using the same rate limiting state for different kinds of messages
is wrong because this can cause a high frequency message to suppress
a report of a low frequency message. Hence use a unique rate limiting
state per message type.

Fixes: commit 71a16736a15e ("dm: use local printk ratelimit")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>
---
 drivers/md/dm.c               | 10 ----------
 include/linux/device-mapper.h | 41 ++++++++++++-----------------------------
 2 files changed, 12 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8298670757e9..d669fddd9290 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -27,16 +27,6 @@
 
 #define DM_MSG_PREFIX "core"
 
-#ifdef CONFIG_PRINTK
-/*
- * ratelimit state to be used in DMXXX_LIMIT().
- */
-DEFINE_RATELIMIT_STATE(dm_ratelimit_state,
-		       DEFAULT_RATELIMIT_INTERVAL,
-		       DEFAULT_RATELIMIT_BURST);
-EXPORT_SYMBOL(dm_ratelimit_state);
-#endif
-
 /*
  * Cookies are numeric values sent with CHANGE and REMOVE
  * uevents while resuming, removing or renaming the device.
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1473455d0341..4f2b3b2076c4 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -549,46 +549,29 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
  *---------------------------------------------------------------*/
 #define DM_NAME "device-mapper"
 
-#ifdef CONFIG_PRINTK
-extern struct ratelimit_state dm_ratelimit_state;
-
-#define dm_ratelimit()	__ratelimit(&dm_ratelimit_state)
-#else
-#define dm_ratelimit()	0
-#endif
+#define DM_RATELIMIT(pr_func, fmt, ...)					\
+do {									\
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+									\
+	if (__ratelimit(&rs))						\
+		pr_func(DM_FMT(fmt), ##__VA_ARGS__);			\
+} while (0)
 
 #define DM_FMT(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt "\n"
 
 #define DMCRIT(fmt, ...) pr_crit(DM_FMT(fmt), ##__VA_ARGS__)
 
 #define DMERR(fmt, ...) pr_err(DM_FMT(fmt), ##__VA_ARGS__)
-#define DMERR_LIMIT(fmt, ...)						\
-do {									\
-	if (dm_ratelimit())						\
-		DMERR(fmt, ##__VA_ARGS__);				\
-} while (0)
-
+#define DMERR_LIMIT(fmt, ...) DM_RATELIMIT(pr_err, fmt, ##__VA_ARGS__)
 #define DMWARN(fmt, ...) pr_warn(DM_FMT(fmt), ##__VA_ARGS__)
-#define DMWARN_LIMIT(fmt, ...)						\
-do {									\
-	if (dm_ratelimit())						\
-		DMWARN(fmt, ##__VA_ARGS__);				\
-} while (0)
-
+#define DMWARN_LIMIT(fmt, ...) DM_RATELIMIT(pr_warn, fmt, ##__VA_ARGS__)
 #define DMINFO(fmt, ...) pr_info(DM_FMT(fmt), ##__VA_ARGS__)
-#define DMINFO_LIMIT(fmt, ...)						\
-do {									\
-	if (dm_ratelimit())						\
-		DMINFO(fmt, ##__VA_ARGS__);				\
-} while (0)
+#define DMINFO_LIMIT(fmt, ...) DM_RATELIMIT(pr_info, fmt, ##__VA_ARGS__)
 
 #ifdef CONFIG_DM_DEBUG
 #define DMDEBUG(fmt, ...) printk(KERN_DEBUG DM_FMT(fmt), ##__VA_ARGS__)
-#define DMDEBUG_LIMIT(fmt, ...)						\
-do {									\
-	if (dm_ratelimit())						\
-		DMDEBUG(fmt, ##__VA_ARGS__);				\
-} while (0)
+#define DMDEBUG_LIMIT(fmt, ...) DM_RATELIMIT(pr_debug, fmt, ##__VA_ARGS__)
 #else
 #define DMDEBUG(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #define DMDEBUG_LIMIT(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
-- 
2.13.3
