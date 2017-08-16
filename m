From: Gris Ge <fge@redhat.com>
Subject: [PATCH 3/3] multipath-tools: libdmmp: New function to
	flush and reconfig
Date: Wed, 16 Aug 2017 20:34:09 +0800
Message-ID: <20170816123409.16535-3-fge@redhat.com>
References: <20170816123409.16535-1-fge@redhat.com>
	<20170816123409.16535-2-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170816123409.16535-2-fge@redhat.com>
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

New functions:
    * dmmp_reconfig() to invoke reconfiguration of multipathd daemon.
    * dmmp_flush_mpath() to flush/del unused mpath.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libdmmp/libdmmp.c           | 143 +++++++++++++++++++++++++++++++++++++-------
 libdmmp/libdmmp/libdmmp.h   |  60 +++++++++++++++++++
 libdmmp/libdmmp_misc.c      |   5 +-
 libdmmp/test/libdmmp_test.c |  47 ++++++++++++++-
 4 files changed, 229 insertions(+), 26 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 6db348b4..b4e7f08f 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2015 - 2016 Red Hat, Inc.
+ * Copyright (C) 2015 - 2017 Red Hat, Inc.
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -19,6 +19,7 @@
  */
 
 #include <stdint.h>
+#include <stdbool.h>
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
@@ -45,6 +46,8 @@
 #define _DMMP_JSON_MAJOR_VERSION		0
 #define _DMMP_JSON_MAPS_KEY			"maps"
 #define _ERRNO_STR_BUFF_SIZE			256
+#define _IPC_MAX_CMD_LEN			512
+/* ^ Was _MAX_CMD_LEN in ./libmultipath/uxsock.h */
 
 struct dmmp_context {
 	void (*log_func)(struct dmmp_context *ctx, int priority,
@@ -66,6 +69,8 @@ struct dmmp_context {
 static int _process_cmd(struct dmmp_context *ctx, int fd, const char *cmd,
 			char **output);
 
+static int _ipc_connect(struct dmmp_context *ctx, int *fd);
+
 _dmmp_getter_func_gen(dmmp_context_log_priority_get,
 		      struct dmmp_context, ctx, log_priority,
 		      int);
@@ -153,9 +158,7 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 	uint32_t i = 0;
 	int cur_json_major_version = -1;
 	int ar_maps_len = -1;
-	int socket_fd = -1;
-	int errno_save = 0;
-	char errno_str_buff[_ERRNO_STR_BUFF_SIZE];
+	int ipc_fd = -1;
 
 	assert(ctx != NULL);
 	assert(dmmp_mps != NULL);
@@ -164,24 +167,9 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 	*dmmp_mps = NULL;
 	*dmmp_mp_count = 0;
 
-	socket_fd = mpath_connect();
-	if (socket_fd == -1) {
-		errno_save = errno;
-		memset(errno_str_buff, 0, _ERRNO_STR_BUFF_SIZE);
-		strerror_r(errno_save, errno_str_buff, _ERRNO_STR_BUFF_SIZE);
-		if (errno_save == ECONNREFUSED) {
-			rc = DMMP_ERR_NO_DAEMON;
-			_error(ctx, "Socket connection refuse. "
-			       "Maybe multipathd daemon is not running");
-		} else {
-			_error(ctx, "IPC failed with error %d(%s)", errno_save,
-			       errno_str_buff);
-			rc = DMMP_ERR_IPC_ERROR;
-		}
-		goto out;
-	}
+	_good(_ipc_connect(ctx, &ipc_fd), rc, out);
 
-	_good(_process_cmd(ctx, socket_fd, _DMMP_IPC_SHOW_JSON_CMD, &j_str),
+	_good(_process_cmd(ctx, ipc_fd, _DMMP_IPC_SHOW_JSON_CMD, &j_str),
 	      rc, out);
 
 	_debug(ctx, "Got json output from multipathd: '%s'", j_str);
@@ -258,8 +246,8 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 	}
 
 out:
-	if (socket_fd >= 0)
-		mpath_disconnect(socket_fd);
+	if (ipc_fd >= 0)
+		mpath_disconnect(ipc_fd);
 	free(j_str);
 	if (j_token != NULL)
 		json_tokener_free(j_token);
@@ -371,3 +359,112 @@ out:
 	}
 	return rc;
 }
+
+static int _ipc_connect(struct dmmp_context *ctx, int *fd)
+{
+	int rc = DMMP_OK;
+	int errno_save = 0;
+	char errno_str_buff[_ERRNO_STR_BUFF_SIZE];
+
+	assert(ctx != NULL);
+	assert(fd != NULL);
+
+	*fd = -1;
+
+	*fd = mpath_connect();
+	if (*fd == -1) {
+		errno_save = errno;
+		memset(errno_str_buff, 0, _ERRNO_STR_BUFF_SIZE);
+		strerror_r(errno_save, errno_str_buff, _ERRNO_STR_BUFF_SIZE);
+		if (errno_save == ECONNREFUSED) {
+			rc = DMMP_ERR_NO_DAEMON;
+			_error(ctx, "Socket connection refuse. "
+			       "Maybe multipathd daemon is not running");
+		} else {
+			_error(ctx, "IPC failed with error %d(%s)", errno_save,
+			       errno_str_buff);
+			rc = DMMP_ERR_IPC_ERROR;
+		}
+	}
+	return rc;
+}
+
+int dmmp_flush_mpath(struct dmmp_context *ctx, const char *mpath_name)
+{
+	int rc = DMMP_OK;
+	struct dmmp_mpath **dmmp_mps = NULL;
+	uint32_t dmmp_mp_count = 0;
+	uint32_t i = 0;
+	bool found = false;
+	int ipc_fd = -1;
+	char cmd[_IPC_MAX_CMD_LEN];
+	char *output = NULL;
+
+	assert(ctx != NULL);
+	assert(mpath_name != NULL);
+
+	snprintf(cmd, _IPC_MAX_CMD_LEN, "del map %s", mpath_name);
+	if (strlen(cmd) == _IPC_MAX_CMD_LEN - 1) {
+		rc = DMMP_ERR_INVALID_ARGUMENT;
+		_error(ctx, "Invalid mpath name %s", mpath_name);
+		goto out;
+	}
+
+	_good(_ipc_connect(ctx, &ipc_fd), rc, out);
+	_good(_process_cmd(ctx, ipc_fd, cmd, &output), rc, out);
+
+	/* _process_cmd() already make sure output is not NULL */
+
+	if (strncmp(output, "fail", strlen("fail")) == 0) {
+		/* Check whether specified mpath exits */
+		_good(dmmp_mpath_array_get(ctx, &dmmp_mps, &dmmp_mp_count),
+		      rc, out);
+
+		for (i = 0; i < dmmp_mp_count; ++i) {
+			if (strcmp(dmmp_mpath_name_get(dmmp_mps[i]),
+				   mpath_name) == 0) {
+				found = true;
+				break;
+			}
+		}
+
+		if (found == false) {
+			rc = DMMP_ERR_MPATH_NOT_FOUND;
+			_error(ctx, "Specified mpath %s not found", mpath_name);
+			goto out;
+		}
+
+		rc = DMMP_ERR_MPATH_BUSY;
+		_error(ctx, "Specified mpath is in use");
+	} else if (strncmp(output, "ok", strlen("ok")) != 0) {
+		rc = DMMP_ERR_BUG;
+		_error(ctx, "Got unexpected output for cmd '%s': '%s'",
+		       cmd, output);
+	}
+
+out:
+	if (ipc_fd >= 0)
+		mpath_disconnect(ipc_fd);
+	dmmp_mpath_array_free(dmmp_mps, dmmp_mp_count);
+	free(output);
+	return rc;
+}
+
+int dmmp_reconfig(struct dmmp_context *ctx)
+{
+	int rc = DMMP_OK;
+	int ipc_fd = -1;
+	char *output = NULL;
+	char cmd[_IPC_MAX_CMD_LEN];
+
+	snprintf(cmd, _IPC_MAX_CMD_LEN, "%s", "reconfigure");
+
+	_good(_ipc_connect(ctx, &ipc_fd), rc, out);
+	_good(_process_cmd(ctx, ipc_fd, cmd, &output), rc, out);
+
+out:
+	if (ipc_fd >= 0)
+		mpath_disconnect(ipc_fd);
+	free(output);
+	return rc;
+}
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 3f3fd017..72b79b97 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -39,6 +39,9 @@ extern "C" {
 #define DMMP_ERR_IPC_ERROR		4
 #define DMMP_ERR_NO_DAEMON		5
 #define DMMP_ERR_INCOMPATIBLE		6
+#define DMMP_ERR_MPATH_BUSY		7
+#define DMMP_ERR_MPATH_NOT_FOUND	8
+#define DMMP_ERR_INVALID_ARGUMENT	9
 
 /*
  * Use the syslog severity level as log priority
@@ -647,6 +650,63 @@ DMMP_DLL_EXPORT uint32_t dmmp_path_status_get(struct dmmp_path *dmmp_p);
  */
 DMMP_DLL_EXPORT const char *dmmp_path_status_str(uint32_t path_status);
 
+/**
+ * dmmp_flush_mpath() - Flush specified multipath device map if unused.
+ *
+ * Flush a multipath device map specified as parameter, if unused.
+ *
+ * @ctx:
+ *	Pointer of 'struct dmmp_context'.
+ *	If this pointer is NULL, your program will be terminated by assert.
+ * @mpath_name:
+ *	const char *. The name of multipath device map.
+ *
+ * Return:
+ *	int. Valid error codes are:
+ *
+ *	* DMMP_OK
+ *
+ *	* DMMP_ERR_BUG
+ *
+ *	* DMMP_ERR_NO_MEMORY
+ *
+ *	* DMMP_ERR_NO_DAEMON
+ *
+ *	* DMMP_ERR_MPATH_BUSY
+ *
+ *	* DMMP_ERR_MPATH_NOT_FOUND
+ *
+ *	* DMMP_ERR_INVALID_ARGUMENT
+ *
+ *	Error number could be converted to string by dmmp_strerror().
+ */
+DMMP_DLL_EXPORT int dmmp_flush_mpath(struct dmmp_context *ctx,
+				     const char *mpath_name);
+
+/**
+ * dmmp_reconfig() - Instruct multipathd daemon to do reconfiguration.
+ *
+ * Instruct multipathd daemon to do reconfiguration.
+ *
+ * @ctx:
+ *	Pointer of 'struct dmmp_context'.
+ *	If this pointer is NULL, your program will be terminated by assert.
+ *
+ * Return:
+ *	int. Valid error codes are:
+ *
+ *	* DMMP_OK
+ *
+ *	* DMMP_ERR_BUG
+ *
+ *	* DMMP_ERR_NO_MEMORY
+ *
+ *	* DMMP_ERR_NO_DAEMON
+ *
+ *	Error number could be converted to string by dmmp_strerror().
+ */
+DMMP_DLL_EXPORT int dmmp_reconfig(struct dmmp_context *ctx);
+
 #ifdef __cplusplus
 } /* End of extern "C" */
 #endif
diff --git a/libdmmp/libdmmp_misc.c b/libdmmp/libdmmp_misc.c
index 27f1161a..435ddfa5 100644
--- a/libdmmp/libdmmp_misc.c
+++ b/libdmmp/libdmmp_misc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2015 - 2016 Red Hat, Inc.
+ * Copyright (C) 2015 - 2017 Red Hat, Inc.
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -46,6 +46,9 @@ static const struct _num_str_conv _DMMP_RC_MSG_CONV[] = {
 	{DMMP_ERR_IPC_ERROR, "Error when communicate with multipathd daemon"},
 	{DMMP_ERR_NO_DAEMON, "The multipathd daemon not started"},
 	{DMMP_ERR_INCOMPATIBLE, "Incompatible multipathd daemon version"},
+	{DMMP_ERR_MPATH_BUSY, "Specified multipath device map is in use"},
+	{DMMP_ERR_MPATH_NOT_FOUND, "Specified multipath not found"},
+	{DMMP_ERR_INVALID_ARGUMENT, "Invalid argument"},
 };
 
 _dmmp_str_func_gen(dmmp_strerror, int, rc, _DMMP_RC_MSG_CONV);
diff --git a/libdmmp/test/libdmmp_test.c b/libdmmp/test/libdmmp_test.c
index dad0e280..56bd03e7 100644
--- a/libdmmp/test/libdmmp_test.c
+++ b/libdmmp/test/libdmmp_test.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2015-2016 Red Hat, Inc.
+ * Copyright (C) 2015-2017 Red Hat, Inc.
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <pthread.h>
 #include <unistd.h>
+#include <stdbool.h>
 
 #include <libdmmp/libdmmp.h>
 
@@ -106,11 +107,14 @@ int main(int argc, char *argv[])
 	struct dmmp_context *ctx = NULL;
 	struct dmmp_mpath **dmmp_mps = NULL;
 	uint32_t dmmp_mp_count = 0;
+	uint32_t old_dmmp_mp_count = 0;
 	const char *name = NULL;
 	const char *wwid = NULL;
 	const char *kdev = NULL;
 	uint32_t i = 0;
 	int rc = EXIT_SUCCESS;
+	const char *old_name = NULL;
+	bool found = false;
 
 	ctx = dmmp_context_new();
 	dmmp_context_log_priority_set(ctx, DMMP_LOG_PRIORITY_DEBUG);
@@ -119,7 +123,7 @@ int main(int argc, char *argv[])
 	dmmp_context_timeout_set(ctx, TMO);
 	if (dmmp_context_timeout_get(ctx) != TMO)
 		FAIL(rc, out, "dmmp_context_timeout_set(): Failed to set "
-		     "timeout to %u", TMO);
+		     "timeout to %u\n", TMO);
 
 	if (dmmp_mpath_array_get(ctx, &dmmp_mps, &dmmp_mp_count) != 0)
 		FAIL(rc, out, "dmmp_mpath_array_get(): rc != 0\n");
@@ -140,7 +144,46 @@ int main(int argc, char *argv[])
 		if (rc != 0)
 			goto out;
 	}
+
+	old_name = strdup(name);
+	if (old_name == NULL)
+		FAIL(rc, out, "strdup(): no memory\n");
+
+	old_dmmp_mp_count = dmmp_mp_count;
+
 	dmmp_mpath_array_free(dmmp_mps, dmmp_mp_count);
+
+	if (dmmp_flush_mpath(ctx, old_name) != DMMP_OK)
+		FAIL(rc, out, "dmmp_flush_mpath(): Failed\n");
+
+	PASS("dmmp_flush_mpath(): OK\n");
+
+	if (dmmp_reconfig(ctx) != DMMP_OK)
+		FAIL(rc, out, "dmmp_reconfig(): Failed\n");
+
+	PASS("dmmp_reconfig(): OK\n");
+
+	if (dmmp_mpath_array_get(ctx, &dmmp_mps, &dmmp_mp_count) != 0)
+		FAIL(rc, out, "dmmp_mpath_array_get(): rc != 0\n");
+	if (dmmp_mp_count == 0)
+		FAIL(rc, out, "dmmp_mpath_array_get(): "
+		     "Got no multipath devices\n");
+
+	if (dmmp_mp_count != old_dmmp_mp_count)
+		FAIL(rc, out, "Got different mpath count after reconfig: "
+		     "old %" PRIu32 ", new %" PRIu32 "\n", old_dmmp_mp_count,
+		     dmmp_mp_count);
+
+	for (i = 0; i < dmmp_mp_count; ++i) {
+		if (strcmp(old_name, dmmp_mpath_name_get(dmmp_mps[i])) == 0) {
+			found = true;
+			break;
+		}
+	}
+	if (found == false)
+		FAIL(rc, out, "dmmp_reconfig() does not recreate deleted "
+		     "mpath %s\n", old_name);
+
 out:
 	dmmp_context_free(ctx);
 	exit(rc);
-- 
2.14.1
