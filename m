Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32369CA0FEF
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591407;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EZgwwZqbMcd4xe45dp4JTdgrR9S4/644wrd+/iX9QRA=;
	b=B9BbSN4Jrav0jSsOwWjnuiLT4OTxsuzHqqnqQCMWqtl+N7dEPyJzlcujpHffau7fG6ye/9
	CaaP4IIoQBybxhYqiE6Hv2TJhckpzq7OFJTFqtAi7v9Jf7de+tLbnHs3DuygpR6/mBA5lt
	/beqRpeklI4PcKFPRSm7Op+w93ow+uM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-IKRgEI-KNnmoD2UkOYGmTw-1; Fri, 01 Sep 2023 14:03:25 -0400
X-MC-Unique: IKRgEI-KNnmoD2UkOYGmTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19187381CC15;
	Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3B6E1055466;
	Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D88919472AF;
	Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 15A8D19465B7
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA53140C84A6; Fri,  1 Sep 2023 18:03:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E337840C84A5
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C549492ACE3
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:19 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-GlwMz_AUOCOWgsqMLqEjKw-1; Fri,
 01 Sep 2023 14:03:18 -0400
X-MC-Unique: GlwMz_AUOCOWgsqMLqEjKw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 069F02186C;
 Fri,  1 Sep 2023 18:03:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD60013582;
 Fri,  1 Sep 2023 18:03:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id +EeXKGQn8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:16 +0200
Message-ID: <20230901180235.23980-4-mwilck@suse.com>
In-Reply-To: <20230901180235.23980-1-mwilck@suse.com>
References: <20230901180235.23980-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 03/21] libmultipath: unify use_existing_alias()
 and get_user_friendly_alias()
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>,
 David Bond <dbond@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

These functions are only called from select_alias(). The logic
is more obvious when unified in a single function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: David Bond <dbond@suse.com>
---
 libmultipath/alias.c   | 82 ++++++++++++------------------------------
 libmultipath/alias.h   |  9 ++---
 libmultipath/propsel.c | 19 +++++-----
 3 files changed, 34 insertions(+), 76 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index abde08c..9b9b789 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -329,13 +329,13 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 	return alias;
 }
 
-char *
-use_existing_alias (const char *wwid, const char *file, const char *alias_old,
-		    const char *prefix, int bindings_read_only)
+char *get_user_friendly_alias(const char *wwid, const char *file, const char *alias_old,
+			      const char *prefix, bool bindings_read_only)
 {
 	char *alias = NULL;
 	int id = 0;
 	int fd, can_write;
+	bool new_binding = false;
 	char buff[WWID_SIZE];
 	FILE *f;
 
@@ -349,6 +349,10 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 		close(fd);
 		return NULL;
 	}
+
+	if (!strlen(alias_old))
+		goto new_alias;
+
 	/* lookup the binding. if it exists, the wwid will be in buff
 	 * either way, id contains the id for the alias
 	 */
@@ -358,14 +362,14 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 		/* if buff is our wwid, it's already
 		 * allocated correctly
 		 */
-		if (strcmp(buff, wwid) == 0)
+		if (strcmp(buff, wwid) == 0) {
 			alias = strdup(alias_old);
-		else {
-			alias = NULL;
+			goto out;
+		} else {
 			condlog(0, "alias %s already bound to wwid %s, cannot reuse",
 				alias_old, buff);
+			goto new_alias;
 		}
-		goto out;
 	}
 
 	id = lookup_binding(f, wwid, &alias, NULL, 0);
@@ -377,8 +381,15 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 
 	/* allocate the existing alias in the bindings file */
 	id = scan_devname(alias_old, prefix);
-	if (id <= 0)
-		goto out;
+
+new_alias:
+	if (id <= 0) {
+		id = lookup_binding(f, wwid, &alias, prefix, 1);
+		if (id <= 0)
+			goto out;
+		else
+			new_binding = true;
+	}
 
 	if (fflush(f) != 0) {
 		condlog(0, "cannot fflush bindings file stream : %s",
@@ -388,8 +399,9 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 
 	if (can_write && !bindings_read_only) {
 		alias = allocate_binding(fd, wwid, id, prefix);
-		condlog(0, "Allocated existing binding [%s] for WWID [%s]",
-			alias, wwid);
+		if (alias && !new_binding)
+			condlog(2, "Allocated existing binding [%s] for WWID [%s]",
+				alias, wwid);
 	}
 
 out:
@@ -399,54 +411,6 @@ out:
 	return alias;
 }
 
-char *
-get_user_friendly_alias(const char *wwid, const char *file, const char *prefix,
-			int bindings_read_only)
-{
-	char *alias;
-	int fd, id;
-	FILE *f;
-	int can_write;
-
-	if (!wwid || *wwid == '\0') {
-		condlog(3, "Cannot find binding for empty WWID");
-		return NULL;
-	}
-
-	fd = open_file(file, &can_write, bindings_file_header);
-	if (fd < 0)
-		return NULL;
-
-	f = fdopen(fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor : %s",
-			strerror(errno));
-		close(fd);
-		return NULL;
-	}
-
-	id = lookup_binding(f, wwid, &alias, prefix, 1);
-	if (id < 0) {
-		fclose(f);
-		return NULL;
-	}
-
-	pthread_cleanup_push(free, alias);
-
-	if (fflush(f) != 0) {
-		condlog(0, "cannot fflush bindings file stream : %s",
-			strerror(errno));
-		free(alias);
-		alias = NULL;
-	} else if (can_write && !bindings_read_only && !alias)
-		alias = allocate_binding(fd, wwid, id, prefix);
-
-	fclose(f);
-
-	pthread_cleanup_pop(0);
-	return alias;
-}
-
 int
 get_user_friendly_wwid(const char *alias, char *buff, const char *file)
 {
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index dbc950c..fa33223 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -2,13 +2,10 @@
 #define _ALIAS_H
 
 int valid_alias(const char *alias);
-char *get_user_friendly_alias(const char *wwid, const char *file,
-			      const char *prefix,
-			      int bindings_readonly);
 int get_user_friendly_wwid(const char *alias, char *buff, const char *file);
-char *use_existing_alias (const char *wwid, const char *file,
-			  const char *alias_old,
-			  const char *prefix, int bindings_read_only);
+char *get_user_friendly_alias(const char *wwid, const char *file,
+			      const char *alias_old,
+			      const char *prefix, bool bindings_read_only);
 
 struct config;
 int check_alias_settings(const struct config *);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d6bce12..354e883 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -401,19 +401,16 @@ int select_alias(struct config *conf, struct multipath * mp)
 
 	select_alias_prefix(conf, mp);
 
-	if (strlen(mp->alias_old) > 0) {
-		mp->alias = use_existing_alias(mp->wwid, conf->bindings_file,
-				mp->alias_old, mp->alias_prefix,
-				conf->bindings_read_only);
-		memset (mp->alias_old, 0, WWID_SIZE);
-		origin = "(setting: using existing alias)";
-	}
+	mp->alias = get_user_friendly_alias(mp->wwid, conf->bindings_file,
+					    mp->alias_old, mp->alias_prefix,
+					    conf->bindings_read_only);
 
-	if (mp->alias == NULL) {
-		mp->alias = get_user_friendly_alias(mp->wwid,
-				conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
+	if (mp->alias && !strncmp(mp->alias, mp->alias_old, WWID_SIZE))
+		origin = "(setting: using existing alias)";
+	else if (mp->alias)
 		origin = "(setting: user_friendly_name)";
-	}
+	memset (mp->alias_old, 0, WWID_SIZE);
+
 out:
 	if (mp->alias == NULL) {
 		mp->alias = strdup(mp->wwid);
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

