From: Joe Perches <joe@perches.com>
Subject: [PATCH V2] device-mapper: Convert printks to pr_<level> macros
Date: Thu, 20 Apr 2017 10:46:07 -0700
Message-ID: <b7bbe2dda80ec1120149db4c7992a9170a0472ec.1492710052.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Using pr_<level> is the more common logging style.

In addition, using the pr_<level> macros could shrink the kernel image
if/when the macros are converted to functions.

Miscellanea:

o Standardize style and use new macro DM_FMT
o Use no_printk in DMDEBUG macros when CONFIG_DM_DEBUG is not #defined

Signed-off-by: Joe Perches <joe@perches.com>
---

v2: Fix compilation outside of drivers/md/ by adding and using DM_FMT macro

 include/linux/device-mapper.h | 76 +++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b7ab76ed8e11..c93f9ef4a7fc 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -533,48 +533,46 @@ extern struct ratelimit_state dm_ratelimit_state;
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
+#define DM_FMT(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt "\n"
+
+#define DMCRIT(fmt, ...)						\
+	pr_crit(DM_FMT(fmt), ##__VA_ARGS__)
+
+#define DMERR(fmt, ...)							\
+	pr_err(DM_FMT(fmt), ##__VA_ARGS__)
+#define DMERR_LIMIT(fmt, ...)						\
+do {									\
+	if (dm_ratelimit())						\
+		DMERR(fmt, ##__VA_ARGS__);				\
+} while (0)
+
+#define DMWARN(fmt, ...)						\
+	pr_warn(DM_FMT(fmt), ##__VA_ARGS__)
+#define DMWARN_LIMIT(fmt, ...)						\
+do {									\
+	if (dm_ratelimit())						\
+		DMWARN(fmt, ##__VA_ARGS__);				\
+} while (0)
+
+#define DMINFO(fmt, ...)						\
+	pr_info(DM_FMT(fmt), ##__VA_ARGS__)
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
+	printk(KERN_DEBUG DM_FMT(fmt), ##__VA_ARGS__)
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
