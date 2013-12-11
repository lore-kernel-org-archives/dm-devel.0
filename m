From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 16/16] kpartx: autoload loop module on loop
	partition creation
Date: Wed, 11 Dec 2013 00:43:10 -0600
Message-ID: <1386744190-1295-17-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Currently kpartx doesn't do anything to force the loop module to
autoload, so creating partitions over files fails if the loop module
isn't already loaded.  This patch makes kpartx try to find the next
available loop device by ioctling /dev/loop-control, which will
autoload kpartx.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/lopart.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 9082ca8..6f83048 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -32,6 +32,10 @@
 #include "lopart.h"
 #include "xstrncpy.h"
 
+#ifndef LOOP_CTL_GET_FREE
+#define LOOP_CTL_GET_FREE       0x4C82
+#endif
+
 #if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
         && !defined (__s390x__)
 #define int2ptr(x)	((void *) ((int) x))
@@ -140,14 +144,23 @@ find_unused_loop_device (void)
 
 	char dev[20];
 	char *loop_formats[] = { "/dev/loop%d", "/dev/loop/%d" };
-	int i, j, fd, somedev = 0, someloop = 0, loop_known = 0;
+	int i, j, fd, first = 0, somedev = 0, someloop = 0, loop_known = 0;
 	struct stat statbuf;
 	struct loop_info loopinfo;
 	FILE *procdev;
 
+	if (stat("/dev/loop-control", &statbuf) == 0 &&
+	    S_ISCHR(statbuf.st_mode)) {
+		fd = open("/dev/loop-control", O_RDWR);
+		if (fd >= 0)
+			first = ioctl(fd, LOOP_CTL_GET_FREE);
+		close(fd);
+		if (first < 0)
+			first = 0;
+	}
 	for (j = 0; j < SIZE(loop_formats); j++) {
 
-	    for(i = 0; i < 256; i++) {
+	    for(i = first; i < 256; i++) {
 		sprintf(dev, loop_formats[j], i);
 
 		if (stat (dev, &statbuf) == 0 && S_ISBLK(statbuf.st_mode)) {
-- 
1.8.4.2
