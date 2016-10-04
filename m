From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/15] libmultipath/checkers/tur: Introduce
	strlcpy()
Date: Tue, 4 Oct 2016 10:39:53 -0700
Message-ID: <048db159-d8dc-62fc-f823-c0dfa88bcee5@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Change the strncpy() calls into strlcpy() calls instead of open-coding
strlcpy().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index ac272d4..67933cb 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -21,6 +21,7 @@
 #include "../libmultipath/sg_include.h"
 #include "../libmultipath/uevent.h"
 #include "../libmultipath/time-util.h"
+#include "../libmultipath/util.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
@@ -311,8 +312,7 @@ libcheck_check (struct checker * c)
 			/* TUR checker done */
 			ct->running = 0;
 			tur_status = ct->state;
-			strncpy(c->message, ct->message, CHECKER_MSG_LEN);
-			c->message[CHECKER_MSG_LEN - 1] = '\0';
+			strlcpy(c->message, ct->message, sizeof(c->message));
 		}
 		pthread_mutex_unlock(&ct->lock);
 	} else {
@@ -347,8 +347,7 @@ libcheck_check (struct checker * c)
 		tur_timeout(&tsp);
 		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
 		tur_status = ct->state;
-		strncpy(c->message, ct->message,CHECKER_MSG_LEN);
-		c->message[CHECKER_MSG_LEN - 1] = '\0';
+		strlcpy(c->message, ct->message, sizeof(c->message));
 		pthread_mutex_unlock(&ct->lock);
 		if (ct->thread &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
-- 
2.10.0
