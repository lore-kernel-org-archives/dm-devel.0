From: Gris Ge <fge@redhat.com>
Subject: [PATCH 2/3] multipath-tools: libdmmp: Improve timeout
	mechanism
Date: Wed, 16 Aug 2017 20:34:08 +0800
Message-ID: <20170816123409.16535-2-fge@redhat.com>
References: <20170816123409.16535-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170816123409.16535-1-fge@redhat.com>
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

Issue:
    libdmmp return error of timeout before user requested timeout was
    met.
    This happens when multipathd daemon is starting with a lot(1k+) mpaths.

Root cause:
    The multipath has two timeout settings:
        1. 'uxsock_timeout' in multipath.conf
        2. libmpathcmd timeout argument.
    And the first is not controllable in current libdmmp code.

Fix:
    * Only keep 1 timeout setting in libdmmp:
        dmmp_context_timeout_set()/dmmp_context_timeout_get().
    * libdmmp will keep reply until meet user requested timeout.
    * Allow user to set timeout as 0 which mean infinite, only return
      when error or pass.
    * Updated libdmmp.h document to to indicate timeout 0 as infinite.
    * Increase timeout setting in libdmmp test case to test this
      mechanism.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libdmmp/libdmmp.c           | 136 ++++++++++++++++++++++++++++++++++++--------
 libdmmp/libdmmp/libdmmp.h   |   1 +
 libdmmp/test/libdmmp_test.c |   2 +-
 3 files changed, 114 insertions(+), 25 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 3906335a..6db348b4 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -29,6 +29,7 @@
 #include <unistd.h>
 #include <assert.h>
 #include <json.h>
+#include <time.h>
 #include <mpath_cmd.h>
 
 #include "libdmmp/libdmmp.h"
@@ -54,6 +55,17 @@ struct dmmp_context {
 	unsigned int tmo;
 };
 
+/*
+ * The multipathd daemon are using "uxsock_timeout" to define timeout value,
+ * if timeout at daemon side, we will get message "timeout\n".
+ * To unify this timeout with `dmmp_context_timeout_set()`, this function
+ * will keep retry mpath_process_cmd() tile meet the time of
+ * dmmp_context_timeout_get().
+ * Need to free `*output` string manually.
+ */
+static int _process_cmd(struct dmmp_context *ctx, int fd, const char *cmd,
+			char **output);
+
 _dmmp_getter_func_gen(dmmp_context_log_priority_get,
 		      struct dmmp_context, ctx, log_priority,
 		      int);
@@ -169,32 +181,11 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 		goto out;
 	}
 
-	if (mpath_process_cmd(socket_fd, _DMMP_IPC_SHOW_JSON_CMD,
-			      &j_str, ctx->tmo) != 0) {
-		errno_save = errno;
-		memset(errno_str_buff, 0, _ERRNO_STR_BUFF_SIZE);
-		strerror_r(errno_save, errno_str_buff, _ERRNO_STR_BUFF_SIZE);
-		if (errno_save == ETIMEDOUT) {
-			rc = DMMP_ERR_IPC_TIMEOUT;
-			_error(ctx, "IPC communication timeout, try to "
-			       "increase it via dmmp_context_timeout_set()");
-			goto out;
-		}
-		_error(ctx, "IPC failed when process command '%s' with "
-		       "error %d(%s)", _DMMP_IPC_SHOW_JSON_CMD, errno_save,
-		       errno_str_buff);
-		rc = DMMP_ERR_IPC_ERROR;
-		goto out;
-	}
-
-	if ((j_str == NULL) || (strlen(j_str) == 0)) {
-		_error(ctx, "IPC return empty reply for command %s",
-		       _DMMP_IPC_SHOW_JSON_CMD);
-		rc = DMMP_ERR_IPC_ERROR;
-		goto out;
-	}
+	_good(_process_cmd(ctx, socket_fd, _DMMP_IPC_SHOW_JSON_CMD, &j_str),
+	      rc, out);
 
 	_debug(ctx, "Got json output from multipathd: '%s'", j_str);
+
 	j_token = json_tokener_new();
 	if (j_token == NULL) {
 		rc = DMMP_ERR_BUG;
@@ -283,3 +274,100 @@ out:
 
 	return rc;
 }
+
+static int _process_cmd(struct dmmp_context *ctx, int fd, const char *cmd,
+			char **output)
+{
+	int errno_save = 0;
+	int rc = DMMP_OK;
+	char errno_str_buff[_ERRNO_STR_BUFF_SIZE];
+	struct timespec start_ts;
+	struct timespec cur_ts;
+	unsigned int ipc_tmo = 0;
+	bool flag_check_tmo = false;
+	unsigned int elapsed = 0;
+
+	assert(output != NULL);
+	assert(ctx != NULL);
+	assert(cmd != NULL);
+
+	*output = NULL;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &start_ts) != 0) {
+		_error(ctx, "BUG: Failed to get CLOCK_MONOTONIC time "
+		       "via clock_gettime(), error %d", errno);
+		return DMMP_ERR_BUG;
+	}
+
+	ipc_tmo = ctx->tmo;
+	if (ctx->tmo == 0)
+		ipc_tmo = _DEFAULT_UXSOCK_TIMEOUT;
+
+invoke:
+	_debug(ctx, "Invoking IPC command '%s' with IPC tmo %u miliseconds",
+	       cmd, ipc_tmo);
+	flag_check_tmo = false;
+	if (mpath_process_cmd(fd, cmd, output, ipc_tmo) != 0) {
+		errno_save = errno;
+		memset(errno_str_buff, 0, _ERRNO_STR_BUFF_SIZE);
+		strerror_r(errno_save, errno_str_buff, _ERRNO_STR_BUFF_SIZE);
+		if (errno_save == ETIMEDOUT) {
+			flag_check_tmo = true;
+		} else {
+			_error(ctx, "IPC failed when process command '%s' with "
+			       "error %d(%s)", cmd, errno_save, errno_str_buff);
+			_debug(ctx, "%s", *output);
+			rc = DMMP_ERR_IPC_ERROR;
+			goto out;
+		}
+	}
+	if ((*output != NULL) &&
+	    (strncmp(*output, "timeout", strlen("timeout")) == 0))
+		flag_check_tmo = true;
+
+	if (flag_check_tmo == true) {
+		free(*output);
+		*output = NULL;
+		if (ctx->tmo == 0) {
+			_debug(ctx, "IPC timeout, but user requested infinite "
+			       "timeout");
+			goto invoke;
+		}
+
+		if (clock_gettime(CLOCK_MONOTONIC, &cur_ts) != 0) {
+			_error(ctx, "BUG: Failed to get CLOCK_MONOTONIC time "
+			       "via clock_gettime(), error %d", errno);
+			rc = DMMP_ERR_BUG;
+			goto out;
+		}
+		elapsed = (cur_ts.tv_sec - start_ts.tv_sec) * 1000 +
+			(cur_ts.tv_nsec - start_ts.tv_nsec) / 1000000;
+
+		if (elapsed >= ctx->tmo) {
+			rc = DMMP_ERR_IPC_TIMEOUT;
+			_error(ctx, "Timeout, try to increase it via "
+			       "dmmp_context_timeout_set()");
+			goto out;
+		}
+		if (ctx->tmo != 0)
+			ipc_tmo = ctx->tmo - elapsed;
+
+		_debug(ctx, "IPC timeout, but user requested timeout has not "
+		       "reached yet, still have %u milliseconds", ipc_tmo);
+		goto invoke;
+	} else {
+		if ((*output == NULL) || (strlen(*output) == 0)) {
+			_error(ctx, "IPC return empty reply for command %s",
+			       cmd);
+			rc = DMMP_ERR_IPC_ERROR;
+			goto out;
+		}
+	}
+
+out:
+	if (rc != DMMP_OK) {
+		free(*output);
+		*output = NULL;
+	}
+	return rc;
+}
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 06791586..3f3fd017 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -171,6 +171,7 @@ DMMP_DLL_EXPORT void dmmp_context_free(struct dmmp_context *ctx);
  *
  * @tmo:
  *	Timeout in milliseconds(1 seconds equal 1000 milliseconds).
+ *	0 means infinite, function only return when error or pass.
  *
  * Return:
  *	void
diff --git a/libdmmp/test/libdmmp_test.c b/libdmmp/test/libdmmp_test.c
index 00b40e90..dad0e280 100644
--- a/libdmmp/test/libdmmp_test.c
+++ b/libdmmp/test/libdmmp_test.c
@@ -35,7 +35,7 @@
 	} while(0)
 #define PASS(...) fprintf(stdout, "PASS: "__VA_ARGS__ );
 #define FILE_NAME_SIZE 256
-#define TMO 10000	/* Forcing timeout to 10 seconds */
+#define TMO 60000		/* Forcing timeout to 60 seconds */
 
 int test_paths(struct dmmp_path_group *mp_pg)
 {
-- 
2.14.1
