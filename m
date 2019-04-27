From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document missing kpartx options
	in man and output
Date: Sat, 27 Apr 2019 03:30:45 +0200
Message-ID: <20190427013045.14487-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/Makefile | 2 +-
 kpartx/kpartx.8 | 8 ++++++--
 kpartx/kpartx.c | 7 +++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 7eb467e..2906a98 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -3,7 +3,7 @@
 #
 include ../Makefile.inc
 
-CFLAGS += $(BIN_CFLAGS) -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+CFLAGS += $(BIN_CFLAGS) -I. -I$(multipathdir) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 LDFLAGS += $(BIN_LDFLAGS)
 
 LIBDEPS += -ldevmapper
diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index ba58acb..08bb349 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -25,7 +25,7 @@ kpartx \- Create device maps from partition tables.
 .RB [\| \-p \|]
 .RB [\| \-f \|]
 .RB [\| \-g \|]
-.RB [\| \-s \|]
+.RB [\| \-s | \-n \|]
 .RB [\| \-v \|]
 .B wholedisk
 .
@@ -77,7 +77,11 @@ Force GUID partition table (GPT).
 .
 .TP
 .B \-s
-Sync mode. Don't return until the partitions are created.
+Sync mode (Default). Don't return until the partitions are created.
+.
+.TP
+.B \-n
+Nosync mode. Return before the partitions are created.
 .
 .TP
 .B \-v
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index d4fb53b..d3620c5 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -37,6 +37,7 @@
 #include "crc32.h"
 #include "lopart.h"
 #include "kpartx.h"
+#include "version.h"
 
 #define SIZE(a) (sizeof(a)/sizeof((a)[0]))
 
@@ -95,7 +96,9 @@ int force_devmap=0;
 
 static int
 usage(void) {
-	printf("usage : kpartx [-a|-d|-l] [-f] [-v] wholedisk\n");
+	printf(VERSION_STRING);
+	printf("Usage:\n");
+	printf("  kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n] [-v] wholedisk\n");
 	printf("\t-a add partition devmappings\n");
 	printf("\t-r devmappings will be readonly\n");
 	printf("\t-d del partition devmappings\n");
@@ -106,7 +109,7 @@ usage(void) {
 	printf("\t-f force devmap create\n");
 	printf("\t-v verbose\n");
 	printf("\t-n nosync mode. Return before the partitions are created\n");
-	printf("\t-s sync mode. Don't return until the partitions are created. Default.\n");
+	printf("\t-s sync mode (Default). Don't return until the partitions are created\n");
 	return 1;
 }
 
-- 
2.21.0-Tranquilo majete
