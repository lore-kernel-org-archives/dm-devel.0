From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 12/18] dm: add ratelimit logging macros
Date: Wed, 11 Jul 2007 22:01:20 +0100
Message-ID: <20070711210120.GD24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

Add ratelimit extension to dm logging macros.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm.h |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

Index: linux/drivers/md/dm.h
===================================================================
--- linux.orig/drivers/md/dm.h	2007-07-11 21:37:31.000000000 +0100
+++ linux/drivers/md/dm.h	2007-07-11 21:37:49.000000000 +0100
@@ -18,13 +18,45 @@
 
 #define DM_NAME "device-mapper"
 
-#define DMERR(f, arg...) printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-#define DMWARN(f, arg...) printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-#define DMINFO(f, arg...) printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMERR(f, arg...) \
+	printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMERR_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " \
+			       f "\n", ## arg); \
+	} while (0)
+
+#define DMWARN(f, arg...) \
+	printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMWARN_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " \
+			       f "\n", ## arg); \
+	} while (0)
+
+#define DMINFO(f, arg...) \
+	printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMINFO_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f \
+			       "\n", ## arg); \
+	} while (0)
+
 #ifdef CONFIG_DM_DEBUG
-#  define DMDEBUG(f, arg...) printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
+#  define DMDEBUG(f, arg...) \
+	printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
+#  define DMDEBUG_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
+			       "\n", ## arg); \
+	} while (0)
 #else
 #  define DMDEBUG(f, arg...) do {} while (0)
+#  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
 #endif
 
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
