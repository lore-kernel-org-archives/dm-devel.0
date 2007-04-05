From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] dm-core-add-ratelimit-printing.patch
Date: Thu, 05 Apr 2007 11:36:52 -0500
Message-ID: <1175791012.24640.6.camel@hydrogen.msp.redhat.com>
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

This patch adds macros for ratelimiting messages.

 brassow

Index: linux-2.6.19-rc4-mm2/drivers/md/dm.h
===================================================================
--- linux-2.6.19-rc4-mm2.orig/drivers/md/dm.h	2006-11-07 09:22:45.000000000 -0600
+++ linux-2.6.19-rc4-mm2/drivers/md/dm.h	2006-11-27 15:08:38.000000000 -0600
@@ -19,8 +19,17 @@
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
 #else
