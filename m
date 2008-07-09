From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH -next 04/11] remove CONFIG_KMOD from drivers
Date: Wed, 09 Jul 2008 10:28:38 +0200
Message-ID: <20080709082903.277499000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-ppp-owner@vger.kernel.org>
Content-Disposition: inline; filename=006-config-kmod-remove-drivers.patch
Sender: linux-ppp-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, video4linux-list@redhat.com, David Woodhouse <dwmw2@infradead.org>, linux-ppp@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Straight forward conversions to CONFIG_MODULE; many drivers
include <linux/kmod.h> conditionally and then don't have any
other conditional code so remove it from those.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: video4linux-list@redhat.com
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-ppp@vger.kernel.org
Cc: dm-devel@redhat.com
---
v2: remove #ifdef in md.c

 drivers/md/md.c                                 |    7 -------
 drivers/media/video/cpia.c                      |    4 ----
 drivers/media/video/usbvision/usbvision-core.c  |    4 ----
 drivers/media/video/usbvision/usbvision-video.c |    4 ----
 drivers/media/video/v4l1-compat.c               |    4 ----
 drivers/media/video/v4l2-common.c               |    4 ----
 drivers/media/video/vino.c                      |    5 +----
 drivers/media/video/w9968cf.c                   |    4 ++--
 drivers/mtd/mtdpart.c                           |    2 --
 drivers/net/irda/sir_dongle.c                   |    2 --
 drivers/net/ppp_generic.c                       |   10 +++-------
 drivers/net/pppox.c                             |    9 ++-------
 drivers/video/fbmem.c                           |   17 ++---------------
 13 files changed, 10 insertions(+), 66 deletions(-)

--- linux-next.orig/drivers/md/md.c	2008-07-08 23:47:19.000000000 +0200
+++ linux-next/drivers/md/md.c	2008-07-08 23:55:21.000000000 +0200
@@ -44,14 +44,9 @@
 #include <linux/mutex.h>
 #include <linux/ctype.h>
 #include <linux/freezer.h>
-
 #include <linux/init.h>
-
 #include <linux/file.h>
-
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 
 #include <asm/unaligned.h>
 
@@ -3565,12 +3560,10 @@ static int do_md_run(mddev_t * mddev)
 		}
 	}
 
-#ifdef CONFIG_KMOD
 	if (mddev->level != LEVEL_NONE)
 		request_module("md-level-%d", mddev->level);
 	else if (mddev->clevel[0])
 		request_module("md-%s", mddev->clevel);
-#endif
 
 	/*
 	 * Drop all container device buffers, from now on
--- linux-next.orig/drivers/media/video/cpia.c	2008-07-08 23:47:19.000000000 +0200
+++ linux-next/drivers/media/video/cpia.c	2008-07-08 23:55:21.000000000 +0200
@@ -39,10 +39,6 @@
 #include <asm/io.h>
 #include <linux/mutex.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include "cpia.h"
 
 static int video_nr = -1;
--- linux-next.orig/drivers/media/video/usbvision/usbvision-core.c	2008-07-08 23:47:19.000000000 +0200
+++ linux-next/drivers/media/video/usbvision/usbvision-core.c	2008-07-08 23:55:21.000000000 +0200
@@ -47,10 +47,6 @@
 
 #include <linux/workqueue.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include "usbvision.h"
 
 static unsigned int core_debug;
--- linux-next.orig/drivers/media/video/usbvision/usbvision-video.c	2008-07-08 23:47:19.000000000 +0200
+++ linux-next/drivers/media/video/usbvision/usbvision-video.c	2008-07-08 23:55:21.000000000 +0200
@@ -70,10 +70,6 @@
 
 #include <linux/workqueue.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include "usbvision.h"
 #include "usbvision-cards.h"
 
--- linux-next.orig/drivers/media/video/v4l1-compat.c	2008-07-08 23:47:19.000000000 +0200
+++ linux-next/drivers/media/video/v4l1-compat.c	2008-07-08 23:55:21.000000000 +0200
@@ -35,10 +35,6 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
--- linux-next.orig/drivers/media/video/v4l2-common.c	2008-07-08 23:47:19.000000000 +0200
+++ linux-next/drivers/media/video/v4l2-common.c	2008-07-08 23:55:21.000000000 +0200
@@ -60,10 +60,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #include <linux/videodev.h>
 
 MODULE_AUTHOR("Bill Dirks, Justin Schoeman, Gerd Knorr");
--- linux-next.orig/drivers/media/video/vino.c	2008-07-08 23:47:20.000000000 +0200
+++ linux-next/drivers/media/video/vino.c	2008-07-08 23:55:21.000000000 +0200
@@ -30,10 +30,7 @@
 #include <linux/mm.h>
 #include <linux/time.h>
 #include <linux/version.h>
-
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 
 #include <linux/i2c.h>
 #include <linux/i2c-algo-sgi.h>
@@ -4641,7 +4638,7 @@ static int __init vino_module_init(void)
 	}
 	vino_init_stage++;
 
-#if defined(CONFIG_KMOD) && defined(MODULE)
+#ifdef MODULE
 	request_module("saa7191");
 	request_module("indycam");
 #endif
--- linux-next.orig/drivers/media/video/w9968cf.c	2008-07-08 23:47:20.000000000 +0200
+++ linux-next/drivers/media/video/w9968cf.c	2008-07-08 23:55:21.000000000 +0200
@@ -110,7 +110,7 @@ static int specific_debug = W9968CF_SPEC
 
 static unsigned int param_nv[24]; /* number of values per parameter */
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 module_param(ovmod_load, bool, 0644);
 #endif
 module_param(simcams, ushort, 0644);
@@ -143,7 +143,7 @@ module_param(debug, ushort, 0644);
 module_param(specific_debug, bool, 0644);
 #endif
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 MODULE_PARM_DESC(ovmod_load,
 		 "\n<0|1> Automatic 'ovcamchip' module loading."
 		 "\n0 disabled, 1 enabled."
--- linux-next.orig/drivers/mtd/mtdpart.c	2008-07-08 23:47:22.000000000 +0200
+++ linux-next/drivers/mtd/mtdpart.c	2008-07-08 23:55:21.000000000 +0200
@@ -544,10 +544,8 @@ int parse_mtd_partitions(struct mtd_info
 
 	for ( ; ret <= 0 && *types; types++) {
 		parser = get_partition_parser(*types);
-#ifdef CONFIG_KMOD
 		if (!parser && !request_module("%s", *types))
 				parser = get_partition_parser(*types);
-#endif
 		if (!parser) {
 			printk(KERN_NOTICE "%s partition parsing not available\n",
 			       *types);
--- linux-next.orig/drivers/net/irda/sir_dongle.c	2008-07-08 23:47:22.000000000 +0200
+++ linux-next/drivers/net/irda/sir_dongle.c	2008-07-08 23:55:21.000000000 +0200
@@ -67,9 +67,7 @@ int sirdev_get_dongle(struct sir_dev *de
 	const struct dongle_driver *drv = NULL;
 	int err = -EINVAL;
 
-#ifdef CONFIG_KMOD
 	request_module("irda-dongle-%d", type);
-#endif
 
 	if (dev->dongle_drv != NULL)
 		return -EBUSY;
--- linux-next.orig/drivers/net/ppp_generic.c	2008-07-08 23:47:23.000000000 +0200
+++ linux-next/drivers/net/ppp_generic.c	2008-07-08 23:55:21.000000000 +0200
@@ -2124,13 +2124,9 @@ ppp_set_compress(struct ppp *ppp, unsign
 	    || ccp_option[1] < 2 || ccp_option[1] > data.length)
 		goto out;
 
-	cp = find_compressor(ccp_option[0]);
-#ifdef CONFIG_KMOD
-	if (!cp) {
-		request_module("ppp-compress-%d", ccp_option[0]);
-		cp = find_compressor(ccp_option[0]);
-	}
-#endif /* CONFIG_KMOD */
+	cp = try_then_request_module(
+		find_compressor(ccp_option[0]),
+		"ppp-compress-%d", ccp_option[0]);
 	if (!cp)
 		goto out;
 
--- linux-next.orig/drivers/net/pppox.c	2008-07-08 23:47:23.000000000 +0200
+++ linux-next/drivers/net/pppox.c	2008-07-08 23:55:21.000000000 +0200
@@ -115,13 +115,8 @@ static int pppox_create(struct net *net,
 		goto out;
 
 	rc = -EPROTONOSUPPORT;
-#ifdef CONFIG_KMOD
-	if (!pppox_protos[protocol]) {
-		char buffer[32];
-		sprintf(buffer, "pppox-proto-%d", protocol);
-		request_module(buffer);
-	}
-#endif
+	if (!pppox_protos[protocol])
+		request_module("pppox-proto-%d", protocol);
 	if (!pppox_protos[protocol] ||
 	    !try_module_get(pppox_protos[protocol]->owner))
 		goto out;
--- linux-next.orig/drivers/video/fbmem.c	2008-07-08 23:47:28.000000000 +0200
+++ linux-next/drivers/video/fbmem.c	2008-07-08 23:55:21.000000000 +0200
@@ -28,9 +28,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/console.h>
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/efi.h>
@@ -837,13 +835,6 @@ fb_write(struct file *file, const char _
 	return (cnt) ? cnt : err;
 }
 
-#ifdef CONFIG_KMOD
-static void try_to_load(int fb)
-{
-	request_module("fb%d", fb);
-}
-#endif /* CONFIG_KMOD */
-
 int
 fb_pan_display(struct fb_info *info, struct fb_var_screeninfo *var)
 {
@@ -1086,10 +1077,8 @@ fb_ioctl(struct inode *inode, struct fil
 		    return -EINVAL;
 		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
 		    return -EINVAL;
-#ifdef CONFIG_KMOD
 		if (!registered_fb[con2fb.framebuffer])
-		    try_to_load(con2fb.framebuffer);
-#endif /* CONFIG_KMOD */
+		    request_module("fb%d", con2fb.framebuffer);
 		if (!registered_fb[con2fb.framebuffer])
 		    return -EINVAL;
 		event.info = info;
@@ -1327,10 +1316,8 @@ fb_open(struct inode *inode, struct file
 	if (fbidx >= FB_MAX)
 		return -ENODEV;
 	lock_kernel();
-#ifdef CONFIG_KMOD
 	if (!(info = registered_fb[fbidx]))
-		try_to_load(fbidx);
-#endif /* CONFIG_KMOD */
+		request_module("fb%d", fbidx);
 	if (!(info = registered_fb[fbidx])) {
 		res = -ENODEV;
 		goto out;

-- 
