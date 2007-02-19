From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG?] register_blkdev: failed to get major for
	device mapper
Date: Mon, 19 Feb 2007 11:59:52 -0800
Message-ID: <20070219115952.a06be52c.akpm@linux-foundation.org>
References: <200702161437.34063.eike-kernel@sf-tec.de>
	<20070219022955.f734006a.akpm@linux-foundation.org>
	<200702191340.56855.eike-kernel@sf-tec.de>
	<200702191539.38902.eike-kernel@sf-tec.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200702191539.38902.eike-kernel@sf-tec.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 19 Feb 2007 15:39:38 +0100 Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> > It's totally weird. It prints the "skipped" message for every (!) number,
> > not just for the blacklisted ones. And I've triple checked that I don't
> > have missed the '{'.
> >
> > Compiler is SuSEs 4.1.0 from their 10.1. I remember some rumors that this
> > thing is just broken?
> 
> Ok, I'm using the compiler from SuSE 10.2 now and it works. Time that we 
> refuse to build if it's a 4.1.0.

argh, I was down to suspecting gcc.

I suppose we can just stir the code around to make it go away.  Like this?


 block/genhd.c          |    9 ++-------
 drivers/base/core.c    |   14 ++++++++++++++
 fs/char_dev.c          |    8 ++------
 include/linux/kdev_t.h |    1 +
 4 files changed, 19 insertions(+), 13 deletions(-)

diff -puN block/genhd.c~rework-reserved-major-handling block/genhd.c
--- a/block/genhd.c~rework-reserved-major-handling
+++ a/block/genhd.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
+#include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
@@ -61,13 +62,7 @@ int register_blkdev(unsigned int major, 
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= index && index <= 63) ||
-					(120 <= index && index <= 127) ||
-					(240 <= index && index <= 254))
+			if (is_lanana_major(index))
 				continue;
 			if (major_names[index] == NULL)
 				break;
diff -puN fs/char_dev.c~rework-reserved-major-handling fs/char_dev.c
--- a/fs/char_dev.c~rework-reserved-major-handling
+++ a/fs/char_dev.c
@@ -6,6 +6,7 @@
 
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/kdev_t.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -108,12 +109,7 @@ __register_chrdev_region(unsigned int ma
 	/* temporary */
 	if (major == 0) {
 		for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= i && i <= 63) || (120 <= i && i <= 127) ||
-					(240 <= i && i <= 254))
+			if (is_lanana_major(i))
 				continue;
 			if (chrdevs[i] == NULL)
 				break;
diff -puN drivers/base/core.c~rework-reserved-major-handling drivers/base/core.c
--- a/drivers/base/core.c~rework-reserved-major-handling
+++ a/drivers/base/core.c
@@ -28,6 +28,20 @@ int (*platform_notify)(struct device * d
 int (*platform_notify_remove)(struct device * dev) = NULL;
 
 /*
+ * Detect the LANANA-assigned LOCAL/EXPERIMENTAL majors
+ */
+bool is_lanana_major(unsigned int major)
+{
+	if (major >= 60 && major <= 63)
+		return 1;
+	if (major >= 120 && major <= 127)
+		return 1;
+	if (major >= 240 && major <= 254)
+		return 1;
+	return 0;
+}
+
+/*
  * sysfs bindings for devices.
  */
 
diff -puN include/linux/kdev_t.h~rework-reserved-major-handling include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~rework-reserved-major-handling
+++ a/include/linux/kdev_t.h
@@ -87,6 +87,7 @@ static inline unsigned sysv_minor(u32 de
 	return dev & 0x3ffff;
 }
 
+bool is_lanana_major(unsigned int major);
 
 #else /* __KERNEL__ */
 
_
