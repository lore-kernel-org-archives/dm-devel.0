From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/4] kpartx: handle alternate bsd disklabel
	location
Date: Wed,  1 Jul 2020 17:39:35 -0500
Message-ID: <1593643176-6206-4-git-send-email-bmarzins@redhat.com>
References: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

bsd disk labels can either be at the start of the second sector, or 64
bytes into the first sector, but kpartx only handled the first case.
However the second case is what parted creates, and what the linux
kernel partition code expects.  kpartx should handle both cases.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/bsd.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kpartx/bsd.c b/kpartx/bsd.c
index 0e661fbc..950b0f92 100644
--- a/kpartx/bsd.c
+++ b/kpartx/bsd.c
@@ -1,6 +1,7 @@
 #include "kpartx.h"
 #include <stdio.h>
 
+#define BSD_LABEL_OFFSET	64
 #define BSD_DISKMAGIC	(0x82564557UL)	/* The disk magic number */
 #define XBSD_MAXPARTITIONS	16
 #define BSD_FS_UNUSED		0
@@ -60,8 +61,19 @@ read_bsd_pt(int fd, struct slice all, struct slice *sp, unsigned int ns) {
 		return -1;
 
 	l = (struct bsd_disklabel *) bp;
-	if (l->d_magic != BSD_DISKMAGIC)
-		return -1;
+	if (l->d_magic != BSD_DISKMAGIC) {
+		/*
+		 * BSD disklabels can also start 64 bytes offset from the
+		 * start of the first sector
+		 */
+		bp = getblock(fd, offset);
+		if (bp == NULL)
+			return -1;
+
+		l = (struct bsd_disklabel *)(bp + 64);
+		if (l->d_magic != BSD_DISKMAGIC)
+			return -1;
+	}
 
 	max_partitions = 16;
 	if (l->d_npartitions < max_partitions)
-- 
2.17.2
