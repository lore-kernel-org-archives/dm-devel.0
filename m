Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5ADDCA0FF0
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591417;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YFKpZsaMrrry+dB/4K+Ejef/djd+IojWD5GsG/xqZHA=;
	b=F+cuI5OKGTYpCBqpX9UIO7Ft8u8bePoK7dx5Yr5hcCYhTEmvID6zoMwywnCsEG7qNcfJ6N
	ktG1uNaZ6qBuz+QqndWzgl2GTBE02DEaIgA7hM4dluDIYtM1g2g9I8YPMZtom86dLFTSPg
	an2NJB2hChUiFrJlA/siA2B+si96wFY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-jmQWk_ELOBOiJIG8jcegWw-1; Fri, 01 Sep 2023 14:03:32 -0400
X-MC-Unique: jmQWk_ELOBOiJIG8jcegWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E849F92AD02;
	Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D690E200BA73;
	Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82D4F19472A0;
	Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9303919465B7
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 845A31208F6E; Fri,  1 Sep 2023 18:03:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D0111055466
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6176A8030A9
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-6hkNg2r2N-uDJZNNnjxmXw-1; Fri,
 01 Sep 2023 14:03:21 -0400
X-MC-Unique: 6hkNg2r2N-uDJZNNnjxmXw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 2B22D1F88D;
 Fri,  1 Sep 2023 18:03:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EFF7313582;
 Fri,  1 Sep 2023 18:03:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id sEr0OGcn8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:19 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:24 +0200
Message-ID: <20230901180235.23980-12-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 11/21] libmultipath: add global variable for
 current bindings
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Add a variable global_bindings that holds the currently active vector of
bindings. This variable is freed at program exit.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c              | 11 +++++++++--
 libmultipath/alias.h              |  1 +
 libmultipath/libmultipath.version |  1 +
 multipath/main.c                  |  2 ++
 multipathd/main.c                 |  1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index e61eb91..0759643 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -522,6 +522,7 @@ static void _free_binding(struct binding *bdg)
  * an abstract type.
  */
 typedef struct _vector Bindings;
+static Bindings global_bindings = { .allocated = 0 };
 
 static void free_bindings(Bindings *bindings)
 {
@@ -533,6 +534,11 @@ static void free_bindings(Bindings *bindings)
 	vector_reset(bindings);
 }
 
+void cleanup_bindings(void)
+{
+	free_bindings(&global_bindings);
+}
+
 enum {
 	BINDING_EXISTS,
 	BINDING_CONFLICT,
@@ -762,7 +768,6 @@ int check_alias_settings(const struct config *conf)
 	pthread_cleanup_pop(1);
 	pthread_cleanup_pop(1);
 
-	pthread_cleanup_push_cast(free_bindings, &bindings);
 	fd = open_file(conf->bindings_file, &can_write, BINDINGS_FILE_HEADER);
 	if (fd != -1) {
 		FILE *file = fdopen(fd, "r");
@@ -782,6 +787,8 @@ int check_alias_settings(const struct config *conf)
 			close(fd);
 		}
 	}
-	pthread_cleanup_pop(1);
+
+	cleanup_bindings();
+	global_bindings = bindings;
 	return rc;
 }
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index fa33223..37b49d9 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -9,5 +9,6 @@ char *get_user_friendly_alias(const char *wwid, const char *file,
 
 struct config;
 int check_alias_settings(const struct config *);
+void cleanup_bindings(void);
 
 #endif /* _ALIAS_H */
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index a7b8c33..ddd302f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -64,6 +64,7 @@ global:
 	checker_name;
 	checker_state_name;
 	check_foreign;
+	cleanup_bindings;
 	cleanup_lock;
 	coalesce_paths;
 	count_active_paths;
diff --git a/multipath/main.c b/multipath/main.c
index b78f316..45e9745 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -843,6 +843,8 @@ main (int argc, char *argv[])
 	conf->force_sync = 1;
 	if (atexit(cleanup_vecs))
 		condlog(1, "failed to register cleanup handler for vecs: %m");
+	if (atexit(cleanup_bindings))
+		condlog(1, "failed to register cleanup handler for bindings: %m");
 	while ((arg = getopt(argc, argv, ":adDcChl::eFfM:v:p:b:BrR:itTquUwW")) != EOF ) {
 		switch(arg) {
 		case 'v':
diff --git a/multipathd/main.c b/multipathd/main.c
index 2e02a54..214ed4a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3325,6 +3325,7 @@ static void cleanup_child(void)
 {
 	cleanup_threads();
 	cleanup_vecs();
+	cleanup_bindings();
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

