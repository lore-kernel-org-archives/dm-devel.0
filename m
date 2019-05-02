From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document missing mpathpersist
	flags in help output
Date: Thu,  2 May 2019 23:49:01 +0200
Message-ID: <20190502214901.3170-1-xose.vazquez@gmail.com>
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
 mpathpersist/main.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 10cba45..5a2cf9a 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -15,6 +15,7 @@
 #include <pthread.h>
 #include <ctype.h>
 #include <string.h>
+#include "version.h"
 
 static const char * pr_type_strs[] = {
 	"obsolete [0]",
@@ -687,6 +688,7 @@ void mpath_print_buf_readfullstat( struct prin_resp *pr_buff)
 
 static void usage(void)
 {
+	fprintf(stderr, VERSION_STRING);
 	fprintf(stderr,
 			"Usage: mpathpersist [OPTIONS] [DEVICE]\n"
 			" Options:\n"
@@ -706,10 +708,8 @@ static void usage(void)
 			"    --param-aptpl|-Z           PR Out parameter 'APTPL'\n"
 			"    --read-keys|-k             PR In: Read Keys\n"
 			"    --param-rk=RK|-K RK        PR Out parameter reservation key\n"
-			"    --param-sark=SARK|-S SARK  PR Out parameter service "
-			"action\n"
-			"                               reservation key (SARK is in "
-			"hex)\n"
+			"    --param-sark=SARK|-S SARK  PR Out parameter service action\n"
+			"                               reservation key (SARK is in hex)\n"
 			"    --preempt|-P               PR Out: Preempt\n"
 			"    --preempt-abort|-A         PR Out: Preempt and Abort\n"
 			"    --prout-type=TYPE|-T TYPE  PR Out command type\n"
@@ -721,11 +721,14 @@ static void usage(void)
 			"    --release|-L               PR Out: Release\n"
 			"    --report-capabilities|-c   PR In: Report Capabilities\n"
 			"    --reserve|-R               PR Out: Reserve\n"
-			"    --transport-id=TIDS|-X TIDS  TransportIDs can be mentioned \n"
-			"                               in several forms\n"
+			"    --transport-id=TIDS|-X TIDS  TransportIDs can be mentioned\n"
+			"                                 in several forms\n"
+			"    --alloc-length=LEN|-l LEN  PR In: maximum allocation length\n"
 			" Examples:\n"
 			"     mpathpersist --out --register --param-sark=123abc --prout-type=5 /dev/mapper/mpath9\n"
-			"     mpathpersist -i -k /dev/mapper/mpath9\n"	);
+			"     mpathpersist -i -k /dev/mapper/mpath9\n"
+			"     mpathpersist --out --reserve --param-sark=123abc --prout-type=8 -d /dev/mapper/mpath9\n"
+			"     mpathpersist -i -s -d /dev/mapper/mpath9\n");
 }
 
 void
-- 
2.21.0
