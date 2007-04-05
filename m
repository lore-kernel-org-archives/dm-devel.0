From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH take 2] dm-core-add-ratelimit-printing.patch
Date: Thu, 05 Apr 2007 15:28:36 -0500
Message-ID: <1175804916.29924.2.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

adds the DMDEBUG_LIMIT

 brassow

Index: linux-2.6.21-rc5-mm4/drivers/md/dm.h
===================================================================
--- linux-2.6.21-rc5-mm4.orig/drivers/md/dm.h
+++ linux-2.6.21-rc5-mm4/drivers/md/dm.h
@@ -19,12 +19,25 @@
 #define DM_NAME "device-mapper"
 
 #define DMERR(f, arg...) printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMERR_LIMIT(f, arg...) \
+	if (printk_ratelimit())	\
+		printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 #define DMWARN(f, arg...) printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMWARN_LIMIT(f, arg...) \
+	if (printk_ratelimit())	\
+		printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 #define DMINFO(f, arg...) printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMINFO_LIMIT(f, arg...) \
+	if (printk_ratelimit())	\
+		printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 #ifdef CONFIG_DM_DEBUG
 #  define DMDEBUG(f, arg...) printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
+#  define DMDEBUG_LIMIT(f, arg...) \
+	if (printk_ratelimit())	\
+		printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
 #else
 #  define DMDEBUG(f, arg...) do {} while (0)
+#  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
 #endif
 
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
