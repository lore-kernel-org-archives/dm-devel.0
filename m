From: Christian Hesse <mail@eworm.de> (by way of Christian Hesse
	<mail@eworm.de>)
Subject: [PATCH 1/1] fix boolean value with json-c 0.14
Date: Sat, 25 Apr 2020 21:11:13 +0200
Message-ID: <20200425191113.33868-1-mail@eworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20200426205416.168f275d@leda>
Resent-To: dm-devel@redhat.com
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
Cc: Christian Hesse <mail@eworm.de>
List-Id: dm-devel.ids

Upstream removed the TRUE and FALSE defines in commit
0992aac61f8b087efd7094e9ac2b84fa9c040fcd.

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 libdmmp/libdmmp_private.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index ac85b63f..29400826 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -82,7 +82,7 @@ static out_type func_name(struct dmmp_context *ctx, const char *var_name) { \
 do { \
 	json_type j_type = json_type_null; \
 	json_object *j_obj_tmp = NULL; \
-	if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) != TRUE) { \
+	if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) != 1) { \
 		_error(ctx, "Invalid JSON output from multipathd IPC: " \
 		       "key '%s' not found", key); \
 		rc = DMMP_ERR_IPC_ERROR; \
@@ -90,7 +90,7 @@ do { \
 	} \
 	if (j_obj_tmp == NULL) { \
 		_error(ctx, "BUG: Got NULL j_obj_tmp from " \
-		       "json_object_object_get_ex() while it return TRUE"); \
+		       "json_object_object_get_ex() while it return 1"); \
 		rc = DMMP_ERR_BUG; \
 		goto out; \
 	} \
