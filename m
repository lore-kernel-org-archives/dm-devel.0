Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF793CA0EC3
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 06:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694501223;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=meGRM5SPB8ekmoVoOo0ZUYXZ4JiIyoS5iZIVCmyEal8=;
	b=Kp9PnnzH/kbTeaxG02lmmJ/9yxHbAWPg0u8AIohC5yFU6AqPTR8Jy+s7r4Ar4j1Egw9Egj
	3pnyVtXmlOmq6jUyY8BGyhEIGGQHU09O3qEWki2Fe6l1XWCVqCkj78Kt0NmiTmmLw0rGdM
	8Ttwyen94bEGu0eTQsJov/sQGcjfsJc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-b1VQTvLHMwOTVln-mxTocA-1; Tue, 12 Sep 2023 02:47:01 -0400
X-MC-Unique: b1VQTvLHMwOTVln-mxTocA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AB46801FA9;
	Tue, 12 Sep 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4614E40C6EA8;
	Tue, 12 Sep 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F211D1946597;
	Tue, 12 Sep 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E86819465BA
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 709094405A; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69B2044029
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4880B816526
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-LtoF0y5iMjCDmUdi6JfTug-1; Mon,
 11 Sep 2023 12:39:23 -0400
X-MC-Unique: LtoF0y5iMjCDmUdi6JfTug-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A6DE521863;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6B44C139CC;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id aDBtGLlC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:21 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:36 +0200
Message-ID: <20230911163846.27197-28-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 12 Sep 2023 06:46:55 +0000
Subject: [dm-devel] [PATCH v2 27/37] multipathd: watch bindings file with
 inotify + timestamp
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Since "libmultipath: keep bindings in memory", we don't re-read the
bindings file after every modification. Add a notification mechanism
that makes multipathd aware of changes to the bindings file. Because
multipathd itself will change the bindings file, it must compare
timestamps in order to avoid reading the file repeatedly.

Because select_alias() can be called from multiple thread contexts (uxlsnr,
uevent handler), we need to add locking for the bindings file. The
timestamp must also be protected by a lock, because it can't be read
or written atomically.

Note: The notification mechanism expects the bindings file to be
atomically replaced by rename(2). Changes must be made in a temporary file and
applied using rename(2), as in update_bindings_file(). The inotify
mechanism deliberately does not listen to close-after-write events
that would be generated by editing the bindings file directly. This

Note also: new bindings will only be read from add_map_with_path(),
i.e. either during reconfigure(), or when a new map is created during
runtime. Existing maps will not be renamed if the binding file changes,
unless the user runs "multipathd reconfigure". This is not a change
wrt the previous code, but it should be mentioned anyway.

Signed-off-by: Martin Wilck <mwilck@suse.com>

libmultipath: protect global_bindings with a mutex

Signed-off-by: Martin Wilck <mwilck@suse.com>

libmultipath: check timestamp of bindings file before reading it

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c              | 250 +++++++++++++++++++++++++-----
 libmultipath/alias.h              |   3 +-
 libmultipath/libmultipath.version |   5 +
 multipathd/uxlsnr.c               |  36 ++++-
 tests/alias.c                     |   3 +
 5 files changed, 252 insertions(+), 45 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 66e34e3..76ed62d 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -10,6 +10,7 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include <assert.h>
+#include <sys/inotify.h>
 
 #include "debug.h"
 #include "util.h"
@@ -22,6 +23,7 @@
 #include "config.h"
 #include "devmapper.h"
 #include "strbuf.h"
+#include "time-util.h"
 
 /*
  * significant parts of this file were taken from iscsi-bindings.c of the
@@ -50,6 +52,12 @@
 "# alias wwid\n" \
 "#\n"
 
+/* uatomic access only */
+static int bindings_file_changed = 1;
+
+static pthread_mutex_t timestamp_mutex = PTHREAD_MUTEX_INITIALIZER;
+static struct timespec bindings_last_updated;
+
 struct binding {
 	char *alias;
 	char *wwid;
@@ -60,6 +68,9 @@ struct binding {
  * an abstract type.
  */
 typedef struct _vector Bindings;
+
+/* Protect global_bindings */
+static pthread_mutex_t bindings_mutex = PTHREAD_MUTEX_INITIALIZER;
 static Bindings global_bindings = { .allocated = 0 };
 
 enum {
@@ -78,6 +89,26 @@ static void _free_binding(struct binding *bdg)
 	free(bdg);
 }
 
+static void free_bindings(Bindings *bindings)
+{
+	struct binding *bdg;
+	int i;
+
+	vector_foreach_slot(bindings, bdg, i)
+		_free_binding(bdg);
+	vector_reset(bindings);
+}
+
+static void set_global_bindings(Bindings *bindings)
+{
+	Bindings old_bindings = global_bindings;
+
+	pthread_mutex_lock(&bindings_mutex);
+	global_bindings = *bindings;
+	pthread_mutex_unlock(&bindings_mutex);
+	free_bindings(&old_bindings);
+}
+
 static const struct binding *get_binding_for_alias(const Bindings *bindings,
 						   const char *alias)
 {
@@ -199,7 +230,8 @@ static int delete_binding(Bindings *bindings, const char *wwid)
 	return BINDING_DELETED;
 }
 
-static int write_bindings_file(const Bindings *bindings, int fd)
+static int write_bindings_file(const Bindings *bindings, int fd,
+			       struct timespec *ts)
 {
 	struct binding *bnd;
 	STRBUF_ON_STACK(content);
@@ -227,9 +259,56 @@ static int write_bindings_file(const Bindings *bindings, int fd)
 		}
 		len -= n;
 	}
+	fsync(fd);
+	if (ts) {
+		struct stat st;
+
+		if (fstat(fd, &st) == 0)
+			*ts = st.st_mtim;
+		else
+			clock_gettime(CLOCK_REALTIME_COARSE, ts);
+	}
 	return 0;
 }
 
+void handle_bindings_file_inotify(const struct inotify_event *event)
+{
+	struct config *conf;
+	const char *base;
+	bool changed = false;
+	struct stat st;
+	struct timespec ts = { 0 };
+	int ret;
+
+	if (!(event->mask & IN_MOVED_TO))
+		return;
+
+	conf = get_multipath_config();
+	base = strrchr(conf->bindings_file, '/');
+	changed = base && base > conf->bindings_file &&
+		!strcmp(base + 1, event->name);
+	ret = stat(conf->bindings_file, &st);
+	put_multipath_config(conf);
+
+	if (!changed)
+		return;
+
+	pthread_mutex_lock(&timestamp_mutex);
+	if (ret == 0) {
+		ts = st.st_mtim;
+		changed = timespeccmp(&ts, &bindings_last_updated) > 0;
+	}
+	pthread_mutex_unlock(&timestamp_mutex);
+
+	if (changed) {
+		uatomic_xchg(&bindings_file_changed, 1);
+		condlog(3, "%s: bindings file must be re-read, new timestamp: %ld.%06ld",
+			__func__, (long)ts.tv_sec, (long)ts.tv_nsec / 1000);
+	} else
+		condlog(3, "%s: bindings file is up-to-date, timestamp: %ld.%06ld",
+			__func__, (long)ts.tv_sec, (long)ts.tv_nsec / 1000);
+}
+
 static int update_bindings_file(const Bindings *bindings,
 				const char *bindings_file)
 {
@@ -237,6 +316,7 @@ static int update_bindings_file(const Bindings *bindings,
 	int fd = -1;
 	char tempname[PATH_MAX];
 	mode_t old_umask;
+	struct timespec ts;
 
 	if (safe_sprintf(tempname, "%s.XXXXXX", bindings_file))
 		return -1;
@@ -248,7 +328,7 @@ static int update_bindings_file(const Bindings *bindings,
 	}
 	umask(old_umask);
 	pthread_cleanup_push(cleanup_fd_ptr, &fd);
-	rc = write_bindings_file(bindings, fd);
+	rc = write_bindings_file(bindings, fd, &ts);
 	pthread_cleanup_pop(1);
 	if (rc == -1) {
 		condlog(1, "failed to write new bindings file");
@@ -257,8 +337,12 @@ static int update_bindings_file(const Bindings *bindings,
 	}
 	if ((rc = rename(tempname, bindings_file)) == -1)
 		condlog(0, "%s: rename: %m", __func__);
-	else
+	else {
 		condlog(1, "updated bindings file %s", bindings_file);
+		pthread_mutex_lock(&timestamp_mutex);
+		bindings_last_updated = ts;
+		pthread_mutex_unlock(&timestamp_mutex);
+	}
 	return rc;
 }
 
@@ -387,6 +471,7 @@ int get_free_id(const Bindings *bindings, const char *prefix, const char *map_ww
 	return id;
 }
 
+/* Called with binding_mutex held */
 static char *
 allocate_binding(const char *filename, const char *wwid, int id, const char *prefix)
 {
@@ -423,6 +508,30 @@ allocate_binding(const char *filename, const char *wwid, int id, const char *pre
 	return alias;
 }
 
+enum {
+	BINDINGS_FILE_UP2DATE,
+	BINDINGS_FILE_READ,
+	BINDINGS_FILE_ERROR,
+	BINDINGS_FILE_BAD,
+};
+
+static int _read_bindings_file(const struct config *conf, Bindings *bindings,
+			       bool force);
+
+static void read_bindings_file(void)
+{
+	struct config *conf;
+	Bindings bindings = {.allocated = 0, };
+	int rc;
+
+	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
+	rc = _read_bindings_file(conf, &bindings, false);
+	pthread_cleanup_pop(1);
+	if (rc == BINDINGS_FILE_READ)
+		set_global_bindings(&bindings);
+}
+
 /*
  * get_user_friendly_alias() action table
  *
@@ -463,6 +572,11 @@ char *get_user_friendly_alias(const char *wwid, const char *file, const char *al
 	bool new_binding = false;
 	const struct binding *bdg;
 
+	read_bindings_file();
+
+	pthread_mutex_lock(&bindings_mutex);
+	pthread_cleanup_push(cleanup_mutex, &bindings_mutex);
+
 	if (!*alias_old)
 		goto new_alias;
 
@@ -514,40 +628,38 @@ new_alias:
 			alias, wwid);
 
 out:
+	/* unlock bindings_mutex */
+	pthread_cleanup_pop(1);
 	return alias;
 }
 
 int get_user_friendly_wwid(const char *alias, char *buff)
 {
 	const struct binding *bdg;
+	int rc = -1;
 
 	if (!alias || *alias == '\0') {
 		condlog(3, "Cannot find binding for empty alias");
 		return -1;
 	}
 
+	pthread_mutex_lock(&bindings_mutex);
+	pthread_cleanup_push(cleanup_mutex, &bindings_mutex);
 	bdg = get_binding_for_alias(&global_bindings, alias);
-	if (!bdg) {
+	if (bdg) {
+		strlcpy(buff, bdg->wwid, WWID_SIZE);
+		rc = 0;
+	} else
 		*buff = '\0';
-		return -1;
-	}
-	strlcpy(buff, bdg->wwid, WWID_SIZE);
-	return 0;
-}
-
-static void free_bindings(Bindings *bindings)
-{
-	struct binding *bdg;
-	int i;
-
-	vector_foreach_slot(bindings, bdg, i)
-		_free_binding(bdg);
-	vector_reset(bindings);
+	pthread_cleanup_pop(1);
+	return rc;
 }
 
 void cleanup_bindings(void)
 {
+	pthread_mutex_lock(&bindings_mutex);
 	free_bindings(&global_bindings);
+	pthread_mutex_unlock(&bindings_mutex);
 }
 
 enum {
@@ -595,7 +707,21 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
 	char *line = NULL;
 	size_t line_len = 0;
 	ssize_t n;
+	char header[sizeof(BINDINGS_FILE_HEADER)];
 
+	header[sizeof(BINDINGS_FILE_HEADER) - 1] = '\0';
+	if (fread(header, sizeof(BINDINGS_FILE_HEADER) - 1, 1, file)
+	    < sizeof(BINDINGS_FILE_HEADER)  - 1) {
+		condlog(2, "%s: failed to read header from %s", __func__,
+			conf->bindings_file);
+		fseek(file, 0, SEEK_SET);
+		rc = -1;
+	} else if (strcmp(header, BINDINGS_FILE_HEADER)) {
+		condlog(2, "%s: invalid header in %s", __func__,
+			conf->bindings_file);
+		fseek(file, 0, SEEK_SET);
+		rc = -1;
+	}
 	pthread_cleanup_push(cleanup_free_ptr, &line);
 	while ((n = getline(&line, &line_len, file)) >= 0) {
 		char *alias, *wwid;
@@ -643,6 +769,68 @@ static int mp_alias_compar(const void *p1, const void *p2)
 			    &((*(struct mpentry * const *)p2)->alias));
 }
 
+static int _read_bindings_file(const struct config *conf, Bindings *bindings,
+			       bool force)
+{
+	int can_write;
+	int rc = 0, ret, fd;
+	FILE *file;
+	struct stat st;
+	int has_changed = uatomic_xchg(&bindings_file_changed, 0);
+
+	if (!force) {
+		if (!has_changed) {
+			condlog(4, "%s: bindings are unchanged", __func__);
+			return BINDINGS_FILE_UP2DATE;
+		}
+	}
+
+	fd = open_file(conf->bindings_file, &can_write, BINDINGS_FILE_HEADER);
+	if (fd == -1)
+		return BINDINGS_FILE_ERROR;
+
+	file = fdopen(fd, "r");
+	if (file != NULL) {
+		condlog(3, "%s: reading %s", __func__, conf->bindings_file);
+
+		pthread_cleanup_push(cleanup_fclose, file);
+		ret = _check_bindings_file(conf, file, bindings);
+		if (ret == 0) {
+			struct timespec ts;
+
+			rc = BINDINGS_FILE_READ;
+			ret = fstat(fd, &st);
+			if (ret == 0)
+				ts = st.st_mtim;
+			else {
+				condlog(1, "%s: fstat failed (%m), using current time", __func__);
+				clock_gettime(CLOCK_REALTIME_COARSE, &ts);
+			}
+			pthread_mutex_lock(&timestamp_mutex);
+			bindings_last_updated = ts;
+			pthread_mutex_unlock(&timestamp_mutex);
+		} else if (ret == -1 && can_write && !conf->bindings_read_only) {
+			ret = update_bindings_file(bindings, conf->bindings_file);
+			if (ret == 0)
+				rc = BINDINGS_FILE_READ;
+			else
+				rc = BINDINGS_FILE_BAD;
+		} else if (ret == -1) {
+			condlog(0, "ERROR: bad settings in read-only bindings file %s",
+				conf->bindings_file);
+			rc = BINDINGS_FILE_BAD;
+		}
+		pthread_cleanup_pop(1);
+	} else {
+		condlog(1, "failed to fdopen %s: %m",
+			conf->bindings_file);
+		close(fd);
+		rc = BINDINGS_FILE_ERROR;
+	}
+
+	return rc;
+}
+
 /*
  * check_alias_settings(): test for inconsistent alias configuration
  *
@@ -661,8 +849,7 @@ static int mp_alias_compar(const void *p1, const void *p2)
  */
 int check_alias_settings(const struct config *conf)
 {
-	int can_write;
-	int rc = 0, i, fd;
+	int i, rc;
 	Bindings bindings = {.allocated = 0, };
 	vector mptable = NULL;
 	struct mpentry *mpe;
@@ -695,27 +882,12 @@ int check_alias_settings(const struct config *conf)
 	pthread_cleanup_pop(1);
 	pthread_cleanup_pop(1);
 
-	fd = open_file(conf->bindings_file, &can_write, BINDINGS_FILE_HEADER);
-	if (fd != -1) {
-		FILE *file = fdopen(fd, "r");
+	rc = _read_bindings_file(conf, &bindings, true);
 
-		if (file != NULL) {
-			pthread_cleanup_push(cleanup_fclose, file);
-			rc = _check_bindings_file(conf, file, &bindings);
-			pthread_cleanup_pop(1);
-			if (rc == -1 && can_write && !conf->bindings_read_only)
-				rc = update_bindings_file(&bindings, conf->bindings_file);
-			else if (rc == -1)
-				condlog(0, "ERROR: bad settings in read-only bindings file %s",
-					conf->bindings_file);
-		} else {
-			condlog(1, "failed to fdopen %s: %m",
-				conf->bindings_file);
-			close(fd);
-		}
+	if (rc == BINDINGS_FILE_READ) {
+		set_global_bindings(&bindings);
+		rc = 0;
 	}
 
-	cleanup_bindings();
-	global_bindings = bindings;
 	return rc;
 }
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index 5ef6720..ca8911f 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -10,5 +10,6 @@ char *get_user_friendly_alias(const char *wwid, const char *file,
 struct config;
 int check_alias_settings(const struct config *);
 void cleanup_bindings(void);
-
+struct inotify_event;
+void handle_bindings_file_inotify(const struct inotify_event *event);
 #endif /* _ALIAS_H */
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index ddd302f..57e50c1 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -238,3 +238,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_20.1.0 {
+global:
+	handle_bindings_file_inotify;
+};
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 02e89fb..d1f8f23 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -41,6 +41,7 @@
 #include "cli.h"
 #include "uxlsnr.h"
 #include "strbuf.h"
+#include "alias.h"
 
 /* state of client connection */
 enum {
@@ -190,6 +191,7 @@ void wakeup_cleanup(void *arg)
 struct watch_descriptors {
 	int conf_wd;
 	int dir_wd;
+	int mp_wd; /* /etc/multipath; for bindings file */
 };
 
 /* failing to set the watch descriptor is o.k. we just miss a warning
@@ -200,6 +202,8 @@ static void reset_watch(int notify_fd, struct watch_descriptors *wds,
 	struct config *conf;
 	int dir_reset = 0;
 	int conf_reset = 0;
+	int mp_reset = 0;
+	char *bindings_file __attribute__((cleanup(cleanup_charp))) = NULL;
 
 	if (notify_fd == -1)
 		return;
@@ -214,7 +218,10 @@ static void reset_watch(int notify_fd, struct watch_descriptors *wds,
 			conf_reset = 1;
 		if (wds->dir_wd == -1)
 			dir_reset = 1;
+		if (wds->mp_wd == -1)
+			mp_reset = 1;
 	}
+	bindings_file = strdup(conf->bindings_file);
 	put_multipath_config(conf);
 
 	if (dir_reset) {
@@ -235,7 +242,18 @@ static void reset_watch(int notify_fd, struct watch_descriptors *wds,
 		if (wds->conf_wd == -1)
 			condlog(3, "didn't set up notifications on /etc/multipath.conf: %m");
 	}
-	return;
+	if (mp_reset && bindings_file) {
+		char *slash = strrchr(bindings_file, '/');
+
+		if (slash && slash > bindings_file) {
+			*slash = '\0';
+			wds->mp_wd = inotify_add_watch(notify_fd, bindings_file,
+						       IN_MOVED_TO|IN_ONLYDIR);
+			if (wds->mp_wd == -1)
+				condlog(3, "didn't set up notifications on %s: %m",
+					bindings_file);
+		}
+	}
 }
 
 static void handle_inotify(int fd, struct watch_descriptors *wds)
@@ -256,12 +274,13 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 					inotify_rm_watch(fd, wds->conf_wd);
 				if (wds->dir_wd != -1)
 					inotify_rm_watch(fd, wds->dir_wd);
-				wds->conf_wd = wds->dir_wd = -1;
+				if (wds->mp_wd != -1)
+					inotify_rm_watch(fd, wds->mp_wd);
+				wds->conf_wd = wds->dir_wd = wds->mp_wd = -1;
 			}
 			break;
 		}
 
-		got_notify = 1;
 		for (ptr = buff; ptr < buff + len;
 		     ptr += sizeof(struct inotify_event) + event->len) {
 			event = (const struct inotify_event *) ptr;
@@ -273,7 +292,13 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 					wds->conf_wd = inotify_add_watch(notify_fd, DEFAULT_CONFIGFILE, IN_CLOSE_WRITE);
 				else if (wds->dir_wd == event->wd)
 					wds->dir_wd = -1;
+				else if (wds->mp_wd == event->wd)
+					wds->mp_wd = -1;
 			}
+			if (wds->mp_wd != -1 && wds->mp_wd == event->wd)
+				handle_bindings_file_inotify(event);
+			else
+				got_notify = 1;
 		}
 	}
 	if (got_notify)
@@ -599,7 +624,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	int max_pfds = MIN_POLLS + POLLFDS_BASE;
 	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
 	unsigned int sequence_nr = 0;
-	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
+	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1, .mp_wd = -1, };
 	struct vectors *vecs = trigger_data;
 
 	condlog(3, "uxsock: startup listener");
@@ -666,7 +691,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 
 		reset_watch(notify_fd, &wds, &sequence_nr);
 		polls[POLLFD_NOTIFY].fd = notify_fd;
-		if (notify_fd == -1 || (wds.conf_wd == -1 && wds.dir_wd == -1))
+		if (notify_fd == -1 || (wds.conf_wd == -1 && wds.dir_wd == -1
+					&& wds.mp_wd == -1))
 			polls[POLLFD_NOTIFY].events = 0;
 		else
 			polls[POLLFD_NOTIFY].events = POLLIN;
diff --git a/tests/alias.c b/tests/alias.c
index 2e765fb..872b1fc 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -1954,6 +1954,9 @@ int main(void)
 	int ret = 0;
 	init_test_verbosity(3);
 
+	/* avoid open_file() call in _read_bindings_file */
+	bindings_file_changed = 0;
+
 	ret += test_format_devname();
 	ret += test_scan_devname();
 	ret += test_lookup_binding();
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

