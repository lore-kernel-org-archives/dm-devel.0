From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 07/11] multipath-tools: move DEFAULT_PRIO
	DEFAULT_PRIO_ARGS and DEFAULT_CHECKER to libmultipath/defaults.h
Date: Thu, 11 Aug 2016 20:32:23 +0200
Message-ID: <1470940345-4441-7-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/checkers.h | 3 +--
 libmultipath/defaults.h | 3 +++
 libmultipath/prio.h     | 4 +---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 502d2d9..4fb97c9 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -3,6 +3,7 @@
 
 #include "list.h"
 #include "memory.h"
+#include "defaults.h"
 
 /*
  *
@@ -86,8 +87,6 @@ enum path_check_state {
 #define CCISS_TUR    "cciss_tur"
 #define RBD          "rbd"
 
-#define DEFAULT_CHECKER TUR
-
 #define ASYNC_TIMEOUT_SEC	30
 
 /*
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 3af85eb..9bf27d6 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -28,6 +28,9 @@
 #define DEFAULT_RETRIGGER_DELAY	10
 #define DEFAULT_RETRIGGER_TRIES	3
 #define DEFAULT_UEV_WAIT_TIMEOUT 30
+#define DEFAULT_PRIO		"const"
+#define DEFAULT_PRIO_ARGS	""
+#define DEFAULT_CHECKER		TUR
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 032028e..261105b 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -12,9 +12,7 @@ struct path;
 
 #include "list.h"
 #include "memory.h"
-
-#define DEFAULT_PRIO "const"
-#define DEFAULT_PRIO_ARGS ""
+#include "defaults.h"
 
 /*
  * Known prioritizers for use in hwtable.c
-- 
2.7.4
