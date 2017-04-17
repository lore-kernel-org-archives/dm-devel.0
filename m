From: Joe Perches <joe@perches.com>
Subject: [PATCH] device-mapper: Convert printks to pr_<level> macros
Date: Mon, 17 Apr 2017 12:00:14 -0700
Message-ID: <265c09d8869388ced29b91fcae8d6f936ed2ad13.1492455602.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Using pr_<level> is the more common logging style.

In addition, using the pr_<level> macros could shrink the kernel image
if/when the macros are converted to functions.

Miscellanea:

o Standardize style and use pr_fmt to prefix the output
o Standardize the DMDEBUG and DMDEBUG_LIMIT output prefix

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/device-mapper.h | 81 ++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b7ab76ed8e11..759a1a0c72dc 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -533,48 +533,51 @@ extern struct ratelimit_state dm_ratelimit_state;
 #define dm_ratelimit()	0
 #endif
 
-#define DMCRIT(f, arg...) \
-	printk(KERN_CRIT DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-
-#define DMERR(f, arg...) \
-	printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-#define DMERR_LIMIT(f, arg...) \
-	do { \
-		if (dm_ratelimit())	\
-			printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " \
-			       f "\n", ## arg); \
-	} while (0)
-
-#define DMWARN(f, arg...) \
-	printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-#define DMWARN_LIMIT(f, arg...) \
-	do { \
-		if (dm_ratelimit())	\
-			printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " \
-			       f "\n", ## arg); \
-	} while (0)
-
-#define DMINFO(f, arg...) \
-	printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-#define DMINFO_LIMIT(f, arg...) \
-	do { \
-		if (dm_ratelimit())	\
-			printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f \
-			       "\n", ## arg); \
-	} while (0)
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
+
+#define DMCRIT(fmt, ...)						\
+	pr_crit(fmt "\n", ##__VA_ARGS__)
+
+#define DMERR(fmt, ...)							\
+	pr_err(fmt "\n", ##__VA_ARGS__)
+#define DMERR_LIMIT(fmt, ...)						\
+do {									\
+	if (dm_ratelimit())						\
+		DMERR(fmt, ##__VA_ARGS__);				\
+} while (0)
+
+#define DMWARN(fmt, ...)						\
+	pr_warn(fmt "\n", ##__VA_ARGS__)
+#define DMWARN_LIMIT(fmt, ...)						\
+do {									\
+	if (dm_ratelimit())						\
+		DMWARN(fmt, ##__VA_ARGS__);				\
+} while (0)
+
+#define DMINFO(fmt, ...)						\
+	pr_info(fmt "\n", ##__VA_ARGS__)
+#define DMINFO_LIMIT(fmt, ...)						\
+do {									\
+	if (dm_ratelimit())						\
+		DMINFO(fmt, ##__VA_ARGS__);				\
+} while (0)
 
 #ifdef CONFIG_DM_DEBUG
-#  define DMDEBUG(f, arg...) \
-	printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
-#  define DMDEBUG_LIMIT(f, arg...) \
-	do { \
-		if (dm_ratelimit())	\
-			printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
-			       "\n", ## arg); \
-	} while (0)
+#  define DMDEBUG(fmt, ...)						\
+	printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " fmt "\n", \
+	       ##__VA_ARGS__)
+#  define DMDEBUG_LIMIT(fmt, ...)					\
+do {									\
+	if (dm_ratelimit())						\
+		DMDEBUG(fmt, ##__VA_ARGS__);				\
+} while (0)
 #else
-#  define DMDEBUG(f, arg...) do {} while (0)
-#  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
+#  define DMDEBUG(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
+#  define DMDEBUG_LIMIT(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
-- 
2.10.0.rc2.1.g053435c
