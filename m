From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] dm: use local ratelimit state for *_LIMIT()
Date: Wed,  3 Aug 2011 23:23:46 +0900
Message-ID: <1312381426-24386-1-git-send-email-namhyung@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

printk_ratelimit() shares global ratelimiting state with all
other subsystems, so its usage is discouraged. Instead,
define and use dm's local state.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/dm.c               |   10 ++++++++++
 include/linux/device-mapper.h |   17 +++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0cf68b478878..29ba355ea91d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -25,6 +25,16 @@
 
 #define DM_MSG_PREFIX "core"
 
+#ifdef CONFIG_PRINTK
+/*
+ * ratelimit state to be used in DMXXX_LIMIT().
+ */
+DEFINE_RATELIMIT_STATE(dm_ratelimit_state,
+		       DEFAULT_RATELIMIT_INTERVAL,
+		       DEFAULT_RATELIMIT_BURST);
+EXPORT_SYMBOL(dm_ratelimit_state);
+#endif
+
 /*
  * Cookies are numeric values sent with CHANGE and REMOVE
  * uevents while resuming, removing or renaming the device.
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 4427e0454051..7dcab5d29223 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -10,6 +10,7 @@
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/ratelimit.h>
 
 struct dm_dev;
 struct dm_target;
@@ -327,6 +328,14 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
  *---------------------------------------------------------------*/
 #define DM_NAME "device-mapper"
 
+#ifdef CONFIG_PRINTK
+extern struct ratelimit_state dm_ratelimit_state;
+
+#define dm_ratelimit()	__ratelimit(&dm_ratelimit_state)
+#else
+#define dm_ratelimit()	0
+#endif
+
 #define DMCRIT(f, arg...) \
 	printk(KERN_CRIT DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 
@@ -334,7 +343,7 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 	printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 #define DMERR_LIMIT(f, arg...) \
 	do { \
-		if (printk_ratelimit())	\
+		if (dm_ratelimit())	\
 			printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " \
 			       f "\n", ## arg); \
 	} while (0)
@@ -343,7 +352,7 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 	printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 #define DMWARN_LIMIT(f, arg...) \
 	do { \
-		if (printk_ratelimit())	\
+		if (dm_ratelimit())	\
 			printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " \
 			       f "\n", ## arg); \
 	} while (0)
@@ -352,7 +361,7 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 	printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 #define DMINFO_LIMIT(f, arg...) \
 	do { \
-		if (printk_ratelimit())	\
+		if (dm_ratelimit())	\
 			printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f \
 			       "\n", ## arg); \
 	} while (0)
@@ -362,7 +371,7 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 	printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
 #  define DMDEBUG_LIMIT(f, arg...) \
 	do { \
-		if (printk_ratelimit())	\
+		if (dm_ratelimit())	\
 			printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
 			       "\n", ## arg); \
 	} while (0)
-- 
1.7.6
