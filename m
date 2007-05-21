From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH] fix missing '}' in new ratelimit
	macros
Date: Mon, 21 May 2007 15:02:57 -0500
Message-ID: <1179777777.13913.6.camel@hydrogen.msp.redhat.com>
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

dm-add-ratelimit-logging-macros-fix.patch
 brassow

Index: linux-2.6.22-rc1-mm1/drivers/md/dm.h
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm.h
+++ linux-2.6.22-rc1-mm1/drivers/md/dm.h
@@ -25,7 +25,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " \
 			       f "\n", ## arg); \
-	while (0)
+	} while (0)
 
 #define DMWARN(f, arg...) \
 	printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
@@ -34,7 +34,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " \
 			       f "\n", ## arg); \
-	while (0)
+	} while (0)
 
 #define DMINFO(f, arg...) \
 	printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
@@ -43,7 +43,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f \
 			       "\n", ## arg); \
-	while (0)
+	} while (0)
 
 #ifdef CONFIG_DM_DEBUG
 #  define DMDEBUG(f, arg...) \
@@ -53,7 +53,7 @@
 		if (printk_ratelimit())	\
 			printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
 			       "\n", ## arg); \
-	while (0)
+	} while (0)
 #else
 #  define DMDEBUG(f, arg...) do {} while (0)
 #  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
