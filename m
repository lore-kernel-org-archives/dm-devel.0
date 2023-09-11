Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10832EEB57E
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450380;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Vxd96bS1QmQgYqzBeRXHj46GhQIeJjYG7dytok9mcmo=;
	b=Rpe85if8JYPy/5iovg7mADuOxDl+hbaHPWNg/5gQc4eTpwyb9axtThQUEvZlC0TbIaIUIR
	oOqg/qrU4exBZVFToiJ7ViZSW8UiL+cu5VzrUf1yQ9rSxN/0yrKSdkKsUzrlAOZQLFtPNQ
	OHJF9ZPuOEN/3qvd/A2QuJAXVl9NYYo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-F5aRCnbXPwWwjhLPh_dUeA-1; Mon, 11 Sep 2023 12:39:36 -0400
X-MC-Unique: F5aRCnbXPwWwjhLPh_dUeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FDF5945E76;
	Mon, 11 Sep 2023 16:39:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6C2E540C6EC1;
	Mon, 11 Sep 2023 16:39:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE44219465A3;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2067619465B8
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 02A2640C200B; Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF2C340C200A
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFA4F101FAAB
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-mCrr0ixROl2sorVc1W9Ufw-1; Mon,
 11 Sep 2023 12:39:19 -0400
X-MC-Unique: mCrr0ixROl2sorVc1W9Ufw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id E299C1F8A6;
 Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD296139CC;
 Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id uM26KLVC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:22 +0200
Message-ID: <20230911163846.27197-14-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 13/37] libmultipath: alias.c: move bindings
 related code up
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

No code changes, just moving code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 239 ++++++++++++++++++++++---------------------
 1 file changed, 120 insertions(+), 119 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 06e6f7c..7e6b0d2 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -9,6 +9,7 @@
 #include <limits.h>
 #include <stdio.h>
 #include <stdbool.h>
+#include <assert.h>
 
 #include "debug.h"
 #include "util.h"
@@ -51,6 +52,125 @@
 
 static const char bindings_file_header[] = BINDINGS_FILE_HEADER;
 
+struct binding {
+	char *alias;
+	char *wwid;
+};
+
+/*
+ * Perhaps one day we'll implement this more efficiently, thus use
+ * an abstract type.
+ */
+typedef struct _vector Bindings;
+static Bindings global_bindings = { .allocated = 0 };
+
+enum {
+	BINDING_EXISTS,
+	BINDING_CONFLICT,
+	BINDING_ADDED,
+	BINDING_DELETED,
+	BINDING_NOTFOUND,
+	BINDING_ERROR,
+};
+
+static void _free_binding(struct binding *bdg)
+{
+	free(bdg->wwid);
+	free(bdg->alias);
+	free(bdg);
+}
+
+static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
+{
+	struct binding *bdg;
+	int i, cmp = 0;
+
+	/*
+	 * Keep the bindings array sorted by alias.
+	 * Optimization: Search backwards, assuming that the bindings file is
+	 * sorted already.
+	 */
+	vector_foreach_slot_backwards(bindings, bdg, i) {
+		if ((cmp = strcmp(bdg->alias, alias)) <= 0)
+			break;
+	}
+
+	/* Check for exact match */
+	if (i >= 0 && cmp == 0)
+		return strcmp(bdg->wwid, wwid) ?
+			BINDING_CONFLICT : BINDING_EXISTS;
+
+	i++;
+	bdg = calloc(1, sizeof(*bdg));
+	if (bdg) {
+		bdg->wwid = strdup(wwid);
+		bdg->alias = strdup(alias);
+		if (bdg->wwid && bdg->alias &&
+		    vector_insert_slot(bindings, i, bdg))
+			return BINDING_ADDED;
+		else
+			_free_binding(bdg);
+	}
+
+	return BINDING_ERROR;
+}
+
+static int write_bindings_file(const Bindings *bindings, int fd)
+{
+	struct binding *bnd;
+	STRBUF_ON_STACK(line);
+	int i;
+
+	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
+	    != sizeof(BINDINGS_FILE_HEADER) - 1)
+		return -1;
+
+	vector_foreach_slot(bindings, bnd, i) {
+		int len;
+
+		if ((len = print_strbuf(&line, "%s %s\n",
+					bnd->alias, bnd->wwid)) < 0)
+			return -1;
+		if (write(fd, get_strbuf_str(&line), len) != len)
+			return -1;
+		truncate_strbuf(&line, 0);
+	}
+	return 0;
+}
+
+static int update_bindings_file(const struct config *conf,
+				const Bindings *bindings)
+{
+	int rc;
+	int fd = -1;
+	char tempname[PATH_MAX];
+	mode_t old_umask;
+
+	if (safe_sprintf(tempname, "%s.XXXXXX", conf->bindings_file))
+		return -1;
+	/* coverity: SECURE_TEMP */
+	old_umask = umask(0077);
+	if ((fd = mkstemp(tempname)) == -1) {
+		condlog(1, "%s: mkstemp: %m", __func__);
+		return -1;
+	}
+	umask(old_umask);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
+	rc = write_bindings_file(bindings, fd);
+	pthread_cleanup_pop(1);
+	if (rc == -1) {
+		condlog(1, "failed to write new bindings file %s",
+			tempname);
+		unlink(tempname);
+		return rc;
+	}
+	if ((rc = rename(tempname, conf->bindings_file)) == -1)
+		condlog(0, "%s: rename: %m", __func__);
+	else
+		condlog(1, "updated bindings file %s", conf->bindings_file);
+	return rc;
+}
+
 int
 valid_alias(const char *alias)
 {
@@ -494,25 +614,6 @@ get_user_friendly_wwid(const char *alias, char *buff, const char *file)
 	return 0;
 }
 
-struct binding {
-	char *alias;
-	char *wwid;
-};
-
-static void _free_binding(struct binding *bdg)
-{
-	free(bdg->wwid);
-	free(bdg->alias);
-	free(bdg);
-}
-
-/*
- * Perhaps one day we'll implement this more efficiently, thus use
- * an abstract type.
- */
-typedef struct _vector Bindings;
-static Bindings global_bindings = { .allocated = 0 };
-
 static void free_bindings(Bindings *bindings)
 {
 	struct binding *bdg;
@@ -528,106 +629,6 @@ void cleanup_bindings(void)
 	free_bindings(&global_bindings);
 }
 
-enum {
-	BINDING_EXISTS,
-	BINDING_CONFLICT,
-	BINDING_ADDED,
-	BINDING_DELETED,
-	BINDING_NOTFOUND,
-	BINDING_ERROR,
-};
-
-static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
-{
-	struct binding *bdg;
-	int i, cmp = 0;
-
-	/*
-	 * Keep the bindings array sorted by alias.
-	 * Optimization: Search backwards, assuming that the bindings file is
-	 * sorted already.
-	 */
-	vector_foreach_slot_backwards(bindings, bdg, i) {
-		if ((cmp = strcmp(bdg->alias, alias)) <= 0)
-			break;
-	}
-
-	/* Check for exact match */
-	if (i >= 0 && cmp == 0)
-		return strcmp(bdg->wwid, wwid) ?
-			BINDING_CONFLICT : BINDING_EXISTS;
-
-	i++;
-	bdg = calloc(1, sizeof(*bdg));
-	if (bdg) {
-		bdg->wwid = strdup(wwid);
-		bdg->alias = strdup(alias);
-		if (bdg->wwid && bdg->alias &&
-		    vector_insert_slot(bindings, i, bdg))
-			return BINDING_ADDED;
-		else
-			_free_binding(bdg);
-	}
-
-	return BINDING_ERROR;
-}
-
-static int write_bindings_file(const Bindings *bindings, int fd)
-{
-	struct binding *bnd;
-	STRBUF_ON_STACK(line);
-	int i;
-
-	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
-	    != sizeof(BINDINGS_FILE_HEADER) - 1)
-		return -1;
-
-	vector_foreach_slot(bindings, bnd, i) {
-		int len;
-
-		if ((len = print_strbuf(&line, "%s %s\n",
-					bnd->alias, bnd->wwid)) < 0)
-			return -1;
-		if (write(fd, get_strbuf_str(&line), len) != len)
-			return -1;
-		truncate_strbuf(&line, 0);
-	}
-	return 0;
-}
-
-static int update_bindings_file(const struct config *conf,
-				const Bindings *bindings)
-{
-	int rc;
-	int fd = -1;
-	char tempname[PATH_MAX];
-	mode_t old_umask;
-
-	if (safe_sprintf(tempname, "%s.XXXXXX", conf->bindings_file))
-		return -1;
-	/* coverity: SECURE_TEMP */
-	old_umask = umask(0077);
-	if ((fd = mkstemp(tempname)) == -1) {
-		condlog(1, "%s: mkstemp: %m", __func__);
-		return -1;
-	}
-	umask(old_umask);
-	pthread_cleanup_push(cleanup_fd_ptr, &fd);
-	rc = write_bindings_file(bindings, fd);
-	pthread_cleanup_pop(1);
-	if (rc == -1) {
-		condlog(1, "failed to write new bindings file %s",
-			tempname);
-		unlink(tempname);
-		return rc;
-	}
-	if ((rc = rename(tempname, conf->bindings_file)) == -1)
-		condlog(0, "%s: rename: %m", __func__);
-	else
-		condlog(1, "updated bindings file %s", conf->bindings_file);
-	return rc;
-}
-
 static int _check_bindings_file(const struct config *conf, FILE *file,
 				 Bindings *bindings)
 {
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

