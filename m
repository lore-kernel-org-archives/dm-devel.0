From: Gris Ge <fge@redhat.com>
Subject: [PATCH 3/4] multipath-tools: libdmmp: Add new function
	dmmp_last_error_msg()
Date: Tue, 21 Nov 2017 22:09:16 +0800
Message-ID: <20171121140917.18298-4-fge@redhat.com>
References: <20171121140917.18298-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171121140917.18298-1-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

 * New function dmmp_last_error_msg() to retrieve the last error
   message.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libdmmp/libdmmp.c           |  9 +++++++++
 libdmmp/libdmmp/libdmmp.h   | 15 +++++++++++++++
 libdmmp/test/libdmmp_test.c | 12 ++++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 74cdb0a6..95f65b88 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -48,6 +48,7 @@
 #define _ERRNO_STR_BUFF_SIZE			256
 #define _IPC_MAX_CMD_LEN			512
 /* ^ Was _MAX_CMD_LEN in ./libmultipath/uxsock.h */
+#define _LAST_ERR_MSG_BUFF_SIZE			1024
 
 struct dmmp_context {
 	void (*log_func)(struct dmmp_context *ctx, int priority,
@@ -56,6 +57,7 @@ struct dmmp_context {
 	int log_priority;
 	void *userdata;
 	unsigned int tmo;
+	char last_err_msg[_LAST_ERR_MSG_BUFF_SIZE];
 };
 
 /*
@@ -81,6 +83,9 @@ _dmmp_getter_func_gen(dmmp_context_userdata_get, struct dmmp_context, ctx,
 _dmmp_getter_func_gen(dmmp_context_timeout_get, struct dmmp_context, ctx, tmo,
 		      unsigned int);
 
+_dmmp_getter_func_gen(dmmp_last_error_msg, struct dmmp_context, ctx,
+		      last_err_msg, const char *);
+
 _dmmp_array_free_func_gen(dmmp_mpath_array_free, struct dmmp_mpath,
 			  _dmmp_mpath_free);
 
@@ -94,6 +99,9 @@ void _dmmp_log(struct dmmp_context *ctx, int priority, const char *file,
 
 	va_start(args, format);
 	ctx->log_func(ctx, priority, file, line, func_name, format, args);
+	if (priority == DMMP_LOG_PRIORITY_ERROR)
+		vsnprintf(ctx->last_err_msg, _LAST_ERR_MSG_BUFF_SIZE,
+			  format, args);
 	va_end(args);
 }
 
@@ -110,6 +118,7 @@ struct dmmp_context *dmmp_context_new(void)
 	ctx->log_priority = DMMP_LOG_PRIORITY_DEFAULT;
 	ctx->userdata = NULL;
 	ctx->tmo = _DEFAULT_UXSOCK_TIMEOUT;
+	memset(ctx->last_err_msg, 0, _LAST_ERR_MSG_BUFF_SIZE);
 
 	return ctx;
 }
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 6e233e4f..33b5d743 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -708,6 +708,21 @@ DMMP_DLL_EXPORT int dmmp_flush_mpath(struct dmmp_context *ctx,
  */
 DMMP_DLL_EXPORT int dmmp_reconfig(struct dmmp_context *ctx);
 
+/**
+ * dmmp_last_error_msg() - Retrieves the last error message.
+ *
+ * Retrieves the last error message.
+ *
+ * @ctx:
+ *	Pointer of 'struct dmmp_context'.
+ *	If this pointer is NULL, your program will be terminated by assert.
+ *
+ * Return:
+ *	const char *. No need to free this memory, the resources will get
+ *	freed when dmmp_context_free().
+ */
+DMMP_DLL_EXPORT const char *dmmp_last_error_msg(struct dmmp_context *ctx);
+
 #ifdef __cplusplus
 } /* End of extern "C" */
 #endif
diff --git a/libdmmp/test/libdmmp_test.c b/libdmmp/test/libdmmp_test.c
index 56bd03e7..d944e1e3 100644
--- a/libdmmp/test/libdmmp_test.c
+++ b/libdmmp/test/libdmmp_test.c
@@ -126,7 +126,8 @@ int main(int argc, char *argv[])
 		     "timeout to %u\n", TMO);
 
 	if (dmmp_mpath_array_get(ctx, &dmmp_mps, &dmmp_mp_count) != 0)
-		FAIL(rc, out, "dmmp_mpath_array_get(): rc != 0\n");
+		FAIL(rc, out, "dmmp_mpath_array_get() failed: %s\n",
+		     dmmp_last_error_msg(ctx));
 	if (dmmp_mp_count == 0)
 		FAIL(rc, out, "dmmp_mpath_array_get(): "
 		     "Got no multipath devices\n");
@@ -154,17 +155,20 @@ int main(int argc, char *argv[])
 	dmmp_mpath_array_free(dmmp_mps, dmmp_mp_count);
 
 	if (dmmp_flush_mpath(ctx, old_name) != DMMP_OK)
-		FAIL(rc, out, "dmmp_flush_mpath(): Failed\n");
+		FAIL(rc, out, "dmmp_flush_mpath(): failed %s\n",
+		     dmmp_last_error_msg(ctx));
 
 	PASS("dmmp_flush_mpath(): OK\n");
 
 	if (dmmp_reconfig(ctx) != DMMP_OK)
-		FAIL(rc, out, "dmmp_reconfig(): Failed\n");
+		FAIL(rc, out, "dmmp_reconfig() failed: %s\n",
+		     dmmp_last_error_msg(ctx));
 
 	PASS("dmmp_reconfig(): OK\n");
 
 	if (dmmp_mpath_array_get(ctx, &dmmp_mps, &dmmp_mp_count) != 0)
-		FAIL(rc, out, "dmmp_mpath_array_get(): rc != 0\n");
+		FAIL(rc, out, "dmmp_mpath_array_get() failed: %s\n",
+		     dmmp_last_error_msg(ctx));
 	if (dmmp_mp_count == 0)
 		FAIL(rc, out, "dmmp_mpath_array_get(): "
 		     "Got no multipath devices\n");
-- 
2.15.0
