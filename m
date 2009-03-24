From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Update the documentation for path checkers and
	use MALLOC instead of malloc in one path checker.
Date: Tue, 24 Mar 2009 11:25:00 -0400
Message-ID: <1237908301-2339-3-git-send-email-konrad@virtualiron.com>
References: <1237908301-2339-1-git-send-email-konrad@virtualiron.com>
	<1237908301-2339-2-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237908301-2339-2-git-send-email-konrad@virtualiron.com>
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

The internal memory debugger throws a fit if the path checkers are
using the malloc instead of the 'MALLOC' macro.
---
 libmultipath/checkers.h              |    4 ++--
 libmultipath/checkers/emc_clariion.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index b610e6b..23b1c46 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -36,7 +36,7 @@
  * - Description: Indicates path not available for "normal" operations
  *
  * PATH_GHOST:
- * - Use: Only hp_sw
+ * - Use: Only hp_sw and rdac
  * - Description: Indicates a "passive/standby" path on active/passive HP
  *   arrays.  These paths will return valid answers to certain SCSI commands
  *   (tur, read_capacity, inquiry, start_stop), but will fail I/O commands.
@@ -101,7 +101,7 @@ struct checker {
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
 	void * context;                      /* store for persistent data */
 	void ** mpcontext;                   /* store for persistent data
-						shared multipath-wide */
+						shared multipath-wide. Use MALLOC if you want to stuff data in.  */
 	int (*check)(struct checker *);
 	int (*init)(struct checker *);       /* to allocate the context */
 	void (*free)(struct checker *);      /* to free the context */
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 9eac31d..200daee 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -10,6 +10,7 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <errno.h>
+#include <memory.h>
 
 #include "../libmultipath/sg_include.h"
 #include "libsg.h"
@@ -76,7 +77,7 @@ int libcheck_init (struct checker * c)
 	 * Allocate and initialize the multi-path global context.
 	 */
 	if (c->mpcontext) {
-		void * mpctxt = malloc(sizeof(int));
+		void * mpctxt = MALLOC(sizeof(int));
 		*c->mpcontext = mpctxt;
 		CLR_INACTIVE_SNAP(c);
 	}
-- 
1.5.4.1
