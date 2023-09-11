Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F46EE7FF4
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450371;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=djza1+gJz4wYPDgVrue4NRbtBO2X/AzdE6pKe4YxVyQ=;
	b=VRgND5MaqNqq6xQM/DcARVLHhLgRJ/lBzmqxhq938eyfW8VT1QzrwRA7pZOmtPW5jTa4ds
	dlVOwZGOTBgzgf8Y6XAgkk9R5Uw6tDqlgM9Ak1OwRBS1JZy/3sO6Om9BQqdSv68Z0aHhWr
	MZrm3Ga0KAdhVSu59Aw8Y3Ueaxsl7Y8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-Gbkd6VEiONyiok5pUZN0xg-1; Mon, 11 Sep 2023 12:39:26 -0400
X-MC-Unique: Gbkd6VEiONyiok5pUZN0xg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25C1E3C01C27;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1296E21CAC7A;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E7F4E19465A2;
	Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1C1C1946A4D
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D723C2027047; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CDC612027019
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFC7A928B8B
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-xmzJAbd0Ni2f9k8SJs237Q-1; Mon,
 11 Sep 2023 12:39:18 -0400
X-MC-Unique: xmzJAbd0Ni2f9k8SJs237Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 682F621847;
 Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39BDC139CC;
 Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KGJpDLVC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:20 +0200
Message-ID: <20230911163846.27197-12-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 11/37] libmultipath: add global variable for
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Add a variable global_bindings that holds the currently active vector of
bindings. This variable is freed at program exit.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c              | 11 +++++++++--
 libmultipath/alias.h              |  1 +
 libmultipath/libmultipath.version |  1 +
 multipath/main.c                  |  2 ++
 multipathd/main.c                 |  1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index b95cbbe..701e7a2 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -511,6 +511,7 @@ static void _free_binding(struct binding *bdg)
  * an abstract type.
  */
 typedef struct _vector Bindings;
+static Bindings global_bindings = { .allocated = 0 };
 
 static void free_bindings(Bindings *bindings)
 {
@@ -522,6 +523,11 @@ static void free_bindings(Bindings *bindings)
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
@@ -751,7 +757,6 @@ int check_alias_settings(const struct config *conf)
 	pthread_cleanup_pop(1);
 	pthread_cleanup_pop(1);
 
-	pthread_cleanup_push_cast(free_bindings, &bindings);
 	fd = open_file(conf->bindings_file, &can_write, BINDINGS_FILE_HEADER);
 	if (fd != -1) {
 		FILE *file = fdopen(fd, "r");
@@ -771,6 +776,8 @@ int check_alias_settings(const struct config *conf)
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
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

