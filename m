From: mwilck@suse.com
Subject: [PATCH] fix boolean value with json-c 0.14
Date: Wed, 20 May 2020 22:43:13 +0200
Message-ID: <20200520204313.29708-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Gris Ge <fge@redhat.com>, dm-devel@redhat.com, "mail@eworm.de" <mail@eworm.de>
List-Id: dm-devel.ids

From: "mail@eworm.de" <mail@eworm.de>

Upstream json-c removed the TRUE and FALSE defines in commit
0992aac61f8b087efd7094e9ac2b84fa9c040fcd.


Signed-off-by: Christian Hesse <mail@eworm.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/libdmmp_private.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---
mwilck: Resent from Christian's patch from 2020-04-25.
Changes wrt original patch:
 - Use stdbool.h, and keep the error message unchanged.

(Resent, as I forgot to cc dm-devel. Sorry!)

diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index ac85b63f..b1a6ddea 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -30,6 +30,7 @@
 #include <stdint.h>
 #include <string.h>
 #include <assert.h>
+#include <stdbool.h>
 #include <json.h>
 
 #include "libdmmp/libdmmp.h"
@@ -82,7 +83,7 @@ static out_type func_name(struct dmmp_context *ctx, const char *var_name) { \
 do { \
 	json_type j_type = json_type_null; \
 	json_object *j_obj_tmp = NULL; \
-	if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) != TRUE) { \
+	if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) != true) { \
 		_error(ctx, "Invalid JSON output from multipathd IPC: " \
 		       "key '%s' not found", key); \
 		rc = DMMP_ERR_IPC_ERROR; \
-- 
2.26.2
