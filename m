Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34550191474
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130833; cv=none; b=Guu62noBfPjwXrf5/lvUxTA25fVhZ4xPnvRvz0biMnvG4ef6MA62g8R0+OFWe/sLujIlQkgpp+URC9Lc1a+nOZUkMGXMq2UkssIrtf5fe2n7nLdR51AECwhyJ5YNpoUizppNO5sb200p0+BTNi0y7EkcdaFlYMRiwQaDKlFh1W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130833; c=relaxed/simple;
	bh=BZ2ufZzymcE5S1nEBqkYIC1a73EBbWDydKorytx14+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbtwNMOctibfOJHrAAaxyyTWPGJa9NqQ8UW8Z48wZMlsqNhpMvzYKlHD3Rn/32C+bNC7i6MgwjHVRQrMuPo0il4vUZzp8M4ZUeZs7sFg15Wm980nZpohzaAb2OQYeY2umxBNPGEUG3FHeT6mCki84C3wD6jgaYv0wsANMpaM+00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B1LncQJ3; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B1LncQJ3"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a7a9e25008aso135585866b.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130829; x=1723735629; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGAcoYP+NRdSl9G7OoWn3dvxLqe4ZyEafx75lvH92t0=;
        b=B1LncQJ3nf8E2/CGrB0E+bcLunbya8h2KUxJ4yShfrhcVzaiffdCz2N+M21EL1SJNH
         7yC18EdEVwpvvovNACPdImeq/l2I5v/xyIpcm6Q8Ej0BLb0Bs8lCzPeg3KFSp3pddlB3
         ipfqeq6K2QpSrRYlZ88+fVaVAXFykJhIBz5l9rxwvxfoA5HIPwR9Nk8yTGdEOOdHej/W
         YPiGbLHM8EOIxeDd1fX+orrMM+ziM44B8ZU+s+d563Zhm9j7k2XtfPSRnEBoy6OX6Nq6
         wob2gLxxbfWzBTEwtCB56jHbhZLT1FLWdchtFOzjP5a+idEnTxTwWbSTv4rC5g+BZ3Cj
         5jAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130829; x=1723735629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGAcoYP+NRdSl9G7OoWn3dvxLqe4ZyEafx75lvH92t0=;
        b=qDoUspx5yiyAX386+ycyQ5YKMIs5Ou4WsYCA+mS9mxvUHiE0dPA/kD6gZWpZVRxV9D
         N38Sad52ClR0J2HZnrPnow4CzUxjA7MW5S+eqMtYx00Nf/xz8g0WdhhI5KoCdM3g8z5u
         Z8Od+Jno+o2xkuQVuiOZLEzG2q8ArleN5hha8c9ge5KuYWq5ZEMAUV+oihBcIYCu34Vl
         DTmx7VtCYhXoxgoOO6lXoAamNQR6J6igZ2EHc+i7M38yq1IhFXyAkHoijpYlMhElpxEZ
         pLZ+hxNU8mWYHkIozms0qvcWt80fNLdEy7YDYgNYD7Z8L/C4dD3IEWHPGFBpihPz/qeQ
         1lgQ==
X-Gm-Message-State: AOJu0YwkFyowGLR/tboj+yLAFZr9m8ys10JPEviO50f0dNkLR2a/1Imr
	4P+xORU+f+gWvm5eBIz0+jPgEYQ19eN1o5r/19cCbg+odVe7ASdG8QcGZYOHnd8=
X-Google-Smtp-Source: AGHT+IEbEv4XkbNrk+8jvSV64cTzRLp16w7+wNW4/WtBOww9kSQO4HBbe4Ko1pVVxEVdeJ5IqwB1yQ==
X-Received: by 2002:a17:907:1c18:b0:a72:8296:ca1f with SMTP id a640c23a62f3a-a8090e3d103mr172661066b.50.1723130829160;
        Thu, 08 Aug 2024 08:27:09 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9c0b8dasm748739566b.83.2024.08.08.08.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:08 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 34/41] libdmmp: rename macros starting with _DMMP
Date: Thu,  8 Aug 2024 17:26:13 +0200
Message-ID: <20240808152620.93965-35-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/libdmmp.c         | 60 +++++++++++++++++++--------------------
 libdmmp/libdmmp_misc.c    |  6 ++--
 libdmmp/libdmmp_pg.c      |  6 ++--
 libdmmp/libdmmp_private.h |  2 +-
 4 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 1bfdbed..47f5b53 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -35,19 +35,19 @@
 #include "libdmmp/libdmmp.h"
 #include "libdmmp_private.h"
 
-#define _DEFAULT_UXSOCK_TIMEOUT		60000
+#define DEFAULT_UXSOCK_TIMEOUT		60000
 /* ^ 60 seconds. On system with 10k sdX, dmmp_mpath_array_get()
  *   only take 3.5 seconds, so this default value should be OK for most users.
  */
 
-#define _DMMP_IPC_SHOW_JSON_CMD			"show maps json"
-#define _DMMP_JSON_MAJOR_KEY			"major_version"
-#define _DMMP_JSON_MAJOR_VERSION		0
-#define _DMMP_JSON_MAPS_KEY			"maps"
-#define _ERRNO_STR_BUFF_SIZE			256
-#define _IPC_MAX_CMD_LEN			512
+#define DMMP_IPC_SHOW_JSON_CMD			"show maps json"
+#define DMMP_JSON_MAJOR_KEY			"major_version"
+#define DMMP_JSON_MAJOR_VERSION		0
+#define DMMP_JSON_MAPS_KEY			"maps"
+#define ERRNO_STR_BUFF_SIZE			256
+#define IPC_MAX_CMD_LEN			512
 /* ^ Was MAX_CMD_LEN in ./libmultipath/uxsock.h */
-#define _LAST_ERR_MSG_BUFF_SIZE			1024
+#define LAST_ERR_MSG_BUFF_SIZE			1024
 
 struct dmmp_context {
 	void (*log_func)(struct dmmp_context *ctx, int priority,
@@ -56,7 +56,7 @@ struct dmmp_context {
 	int log_priority;
 	void *userdata;
 	unsigned int tmo;
-	char last_err_msg[_LAST_ERR_MSG_BUFF_SIZE];
+	char last_err_msg[LAST_ERR_MSG_BUFF_SIZE];
 };
 
 /*
@@ -99,7 +99,7 @@ void _dmmp_log(struct dmmp_context *ctx, int priority, const char *file,
 	va_start(args, format);
 	ctx->log_func(ctx, priority, file, line, func_name, format, args);
 	if (priority == DMMP_LOG_PRIORITY_ERROR)
-		vsnprintf(ctx->last_err_msg, _LAST_ERR_MSG_BUFF_SIZE,
+		vsnprintf(ctx->last_err_msg, LAST_ERR_MSG_BUFF_SIZE,
 			  format, args);
 	va_end(args);
 }
@@ -116,8 +116,8 @@ struct dmmp_context *dmmp_context_new(void)
 	ctx->log_func = _dmmp_log_stderr;
 	ctx->log_priority = DMMP_LOG_PRIORITY_DEFAULT;
 	ctx->userdata = NULL;
-	ctx->tmo = _DEFAULT_UXSOCK_TIMEOUT;
-	memset(ctx->last_err_msg, 0, _LAST_ERR_MSG_BUFF_SIZE);
+	ctx->tmo = DEFAULT_UXSOCK_TIMEOUT;
+	memset(ctx->last_err_msg, 0, LAST_ERR_MSG_BUFF_SIZE);
 
 	return ctx;
 }
@@ -180,7 +180,7 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 
 	_good(_ipc_connect(ctx, &ipc_fd), rc, out);
 
-	_good(_process_cmd(ctx, ipc_fd, _DMMP_IPC_SHOW_JSON_CMD, &j_str),
+	_good(_process_cmd(ctx, ipc_fd, DMMP_IPC_SHOW_JSON_CMD, &j_str),
 	      rc, out);
 
 	_debug(ctx, "Got json output from multipathd: '%s'", j_str);
@@ -202,20 +202,20 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 	}
 
 	_json_obj_get_value(ctx, j_obj, cur_json_major_version,
-			    _DMMP_JSON_MAJOR_KEY, json_type_int,
+			    DMMP_JSON_MAJOR_KEY, json_type_int,
 			    json_object_get_int, rc, out);
 
-	if (cur_json_major_version != _DMMP_JSON_MAJOR_VERSION) {
+	if (cur_json_major_version != DMMP_JSON_MAJOR_VERSION) {
 		rc = DMMP_ERR_INCOMPATIBLE;
 		_error(ctx, "Incompatible multipathd JSON major version %d, "
 		       "should be %d", cur_json_major_version,
-		       _DMMP_JSON_MAJOR_VERSION);
+		       DMMP_JSON_MAJOR_VERSION);
 		goto out;
 	}
 	_debug(ctx, "multipathd JSON major version(%d) check pass",
-	       _DMMP_JSON_MAJOR_VERSION);
+	       DMMP_JSON_MAJOR_VERSION);
 
-	_json_obj_get_value(ctx, j_obj, ar_maps, _DMMP_JSON_MAPS_KEY,
+	_json_obj_get_value(ctx, j_obj, ar_maps, DMMP_JSON_MAPS_KEY,
 			    json_type_array, json_object_get_array, rc, out);
 
 	if (ar_maps == NULL) {
@@ -279,7 +279,7 @@ static int _process_cmd(struct dmmp_context *ctx, int fd, const char *cmd,
 {
 	int errno_save = 0;
 	int rc = DMMP_OK;
-	char errno_str_buff[_ERRNO_STR_BUFF_SIZE];
+	char errno_str_buff[ERRNO_STR_BUFF_SIZE];
 	struct timespec start_ts;
 	struct timespec cur_ts;
 	unsigned int ipc_tmo = 0;
@@ -300,7 +300,7 @@ static int _process_cmd(struct dmmp_context *ctx, int fd, const char *cmd,
 
 	ipc_tmo = ctx->tmo;
 	if (ctx->tmo == 0)
-		ipc_tmo = _DEFAULT_UXSOCK_TIMEOUT;
+		ipc_tmo = DEFAULT_UXSOCK_TIMEOUT;
 
 invoke:
 	_debug(ctx, "Invoking IPC command '%s' with IPC tmo %u milliseconds",
@@ -308,8 +308,8 @@ invoke:
 	flag_check_tmo = false;
 	if (mpath_process_cmd(fd, cmd, output, ipc_tmo) != 0) {
 		errno_save = errno;
-		memset(errno_str_buff, 0, _ERRNO_STR_BUFF_SIZE);
-		strerror_r(errno_save, errno_str_buff, _ERRNO_STR_BUFF_SIZE);
+		memset(errno_str_buff, 0, ERRNO_STR_BUFF_SIZE);
+		strerror_r(errno_save, errno_str_buff, ERRNO_STR_BUFF_SIZE);
 		if (errno_save == ETIMEDOUT) {
 			flag_check_tmo = true;
 		} else {
@@ -397,7 +397,7 @@ static int _ipc_connect(struct dmmp_context *ctx, int *fd)
 {
 	int rc = DMMP_OK;
 	int errno_save = 0;
-	char errno_str_buff[_ERRNO_STR_BUFF_SIZE];
+	char errno_str_buff[ERRNO_STR_BUFF_SIZE];
 
 	assert(ctx != NULL);
 	assert(fd != NULL);
@@ -407,8 +407,8 @@ static int _ipc_connect(struct dmmp_context *ctx, int *fd)
 	*fd = mpath_connect();
 	if (*fd == -1) {
 		errno_save = errno;
-		memset(errno_str_buff, 0, _ERRNO_STR_BUFF_SIZE);
-		strerror_r(errno_save, errno_str_buff, _ERRNO_STR_BUFF_SIZE);
+		memset(errno_str_buff, 0, ERRNO_STR_BUFF_SIZE);
+		strerror_r(errno_save, errno_str_buff, ERRNO_STR_BUFF_SIZE);
 		if (errno_save == ECONNREFUSED) {
 			rc = DMMP_ERR_NO_DAEMON;
 			_error(ctx, "Socket connection refuse. "
@@ -426,14 +426,14 @@ int dmmp_flush_mpath(struct dmmp_context *ctx, const char *mpath_name)
 {
 	int rc = DMMP_OK;
 	int ipc_fd = -1;
-	char cmd[_IPC_MAX_CMD_LEN];
+	char cmd[IPC_MAX_CMD_LEN];
 	char *output = NULL;
 
 	assert(ctx != NULL);
 	assert(mpath_name != NULL);
 
-	snprintf(cmd, _IPC_MAX_CMD_LEN, "del map %s", mpath_name);
-	if (strlen(cmd) == _IPC_MAX_CMD_LEN - 1) {
+	snprintf(cmd, IPC_MAX_CMD_LEN, "del map %s", mpath_name);
+	if (strlen(cmd) == IPC_MAX_CMD_LEN - 1) {
 		rc = DMMP_ERR_INVALID_ARGUMENT;
 		_error(ctx, "Invalid mpath name %s", mpath_name);
 		goto out;
@@ -461,9 +461,9 @@ int dmmp_reconfig(struct dmmp_context *ctx)
 	int rc = DMMP_OK;
 	int ipc_fd = -1;
 	char *output = NULL;
-	char cmd[_IPC_MAX_CMD_LEN];
+	char cmd[IPC_MAX_CMD_LEN];
 
-	snprintf(cmd, _IPC_MAX_CMD_LEN, "%s", "reconfigure");
+	snprintf(cmd, IPC_MAX_CMD_LEN, "%s", "reconfigure");
 
 	_good(_ipc_connect(ctx, &ipc_fd), rc, out);
 	_good(_process_cmd(ctx, ipc_fd, cmd, &output), rc, out);
diff --git a/libdmmp/libdmmp_misc.c b/libdmmp/libdmmp_misc.c
index 69b5a20..51c71cd 100644
--- a/libdmmp/libdmmp_misc.c
+++ b/libdmmp/libdmmp_misc.c
@@ -30,7 +30,7 @@
 #include "libdmmp/libdmmp.h"
 #include "libdmmp_private.h"
 
-#define _DMMP_LOG_STRERR_ALIGN_WIDTH	80
+#define DMMP_LOG_STRERR_ALIGN_WIDTH	80
 /* ^ Only used in _dmmp_log_stderr() for pretty log output.
  *   When provided log message is less than 80 bytes, fill it with space, then
  *   print code file name, function name, line after the 80th bytes.
@@ -81,9 +81,9 @@ void _dmmp_log_stderr(struct dmmp_context *ctx, int priority,
 	 *   bypass clang static analyzer about unused ctx argument warning
 	 */
 
-	if (printed_bytes < _DMMP_LOG_STRERR_ALIGN_WIDTH) {
+	if (printed_bytes < DMMP_LOG_STRERR_ALIGN_WIDTH) {
 		fprintf(stderr, "%*s # %s:%s():%d\n",
-			_DMMP_LOG_STRERR_ALIGN_WIDTH - printed_bytes, "", file,
+			DMMP_LOG_STRERR_ALIGN_WIDTH - printed_bytes, "", file,
 			func_name, line);
 	} else {
 		fprintf(stderr, " # %s:%s():%d\n", file, func_name, line);
diff --git a/libdmmp/libdmmp_pg.c b/libdmmp/libdmmp_pg.c
index 5149161..6be2316 100644
--- a/libdmmp/libdmmp_pg.c
+++ b/libdmmp/libdmmp_pg.c
@@ -78,7 +78,7 @@ struct dmmp_path_group *_dmmp_path_group_new(void)
 		malloc(sizeof(struct dmmp_path_group));
 
 	if (dmmp_pg != NULL) {
-		dmmp_pg->id = _DMMP_PATH_GROUP_ID_UNKNOWN;
+		dmmp_pg->id = DMMP_PATH_GROUP_ID_UNKNOWN;
 		dmmp_pg->status = DMMP_PATH_GROUP_STATUS_UNKNOWN;
 		dmmp_pg->priority = 0;
 		dmmp_pg->selector = NULL;
@@ -127,10 +127,10 @@ int _dmmp_path_group_update(struct dmmp_context *ctx,
 
 	dmmp_pg->id = id;
 
-	if (dmmp_pg->id == _DMMP_PATH_GROUP_ID_UNKNOWN) {
+	if (dmmp_pg->id == DMMP_PATH_GROUP_ID_UNKNOWN) {
 		rc = DMMP_ERR_BUG;
 		_error(ctx, "BUG: Got unknown(%d) path group ID",
-		       _DMMP_PATH_GROUP_ID_UNKNOWN);
+		       DMMP_PATH_GROUP_ID_UNKNOWN);
 		goto out;
 	}
 
diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index 9606fb3..0c497b3 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -46,7 +46,7 @@ extern "C" {
 			goto out; \
 	} while(0)
 
-#define _DMMP_PATH_GROUP_ID_UNKNOWN	0
+#define DMMP_PATH_GROUP_ID_UNKNOWN	0
 
 struct DMMP_DLL_LOCAL _num_str_conv;
 struct _num_str_conv {
-- 
2.46.0

