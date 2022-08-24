Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEF7C00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 08:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661328783;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=laV7MnrRrvp6BKiwNf6/q5ekpWJb5uUVoHlrNnxQv0Q=;
	b=bNUbYSmwfHBggRhNILqxYe8oDZfjJJ6X5wSS4ZHJhX4VY/i6mRfYbLZNfOe2EFbwPZ+ZyE
	XjYfbjaQSelNkMiau+WdVWXpSx5yEh6Gp7mihbrLN+Y4AStV+F2VNvD/+mf83ELz9jQ2aA
	V7hRGsMUEo/fha9GdB0Qs0s1AKwqanI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-iWjzyKiiO7ylMHLHzmv1rQ-1; Wed, 24 Aug 2022 04:12:18 -0400
X-MC-Unique: iWjzyKiiO7ylMHLHzmv1rQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E76828039B7;
	Wed, 24 Aug 2022 08:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D72BA492C3B;
	Wed, 24 Aug 2022 08:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 990851946A42;
	Wed, 24 Aug 2022 08:12:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2FC1E1946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 08:12:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 203181415137; Wed, 24 Aug 2022 08:12:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C3C01415133
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:12:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 046BB185A7B2
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:12:15 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-453-2l2uFIglMhmGu2q8L1uJBA-1; Wed,
 24 Aug 2022 04:12:11 -0400
X-MC-Unique: 2l2uFIglMhmGu2q8L1uJBA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 79C2B33D38;
 Wed, 24 Aug 2022 08:12:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 46E8513AE9;
 Wed, 24 Aug 2022 08:12:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id aEp1D1rdBWNqXwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 24 Aug 2022 08:12:10 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 24 Aug 2022 10:11:47 +0200
Message-Id: <20220824081147.29270-4-mwilck@suse.com>
In-Reply-To: <20220824081147.29270-1-mwilck@suse.com>
References: <20220824081147.29270-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 3/3] multipath: optimize program startup for
 frequent invocations
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Neither "multipath -u" nor "multipath -U" need initialization of the
prioritizers, checkers, and foreign libraries. Also, these commands
need not fail if the bindings file is inconsistent. Move these
possibly slow initialization steps after these special command
invocations.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 034dd2f..8e5154a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -957,11 +957,6 @@ main (int argc, char *argv[])
 		exit(RTVL_FAIL);
 	}
 
-	if (check_alias_settings(conf)) {
-		fprintf(stderr, "fatal configuration error, aborting");
-		exit(RTVL_FAIL);
-	}
-
 	if (optind < argc) {
 		dev = calloc(1, FILE_NAME_SIZE);
 
@@ -988,20 +983,9 @@ main (int argc, char *argv[])
 
 	libmp_udev_set_sync_support(1);
 
-	if (init_checkers()) {
-		condlog(0, "failed to initialize checkers");
-		goto out;
-	}
-	if (init_prio()) {
-		condlog(0, "failed to initialize prioritizers");
-		goto out;
-	}
-
 	if ((cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) && enable_foreign)
 		conf->enable_foreign = strdup("");
 
-	/* Failing here is non-fatal */
-	init_foreign(conf->enable_foreign);
 	if (cmd == CMD_USABLE_PATHS) {
 		r = check_usable_paths(conf, dev, dev_type) ?
 			RTVL_FAIL : RTVL_OK;
@@ -1036,6 +1020,23 @@ main (int argc, char *argv[])
 		break;
 	}
 
+	if (check_alias_settings(conf)) {
+		fprintf(stderr, "fatal configuration error, aborting");
+		exit(RTVL_FAIL);
+	}
+
+	if (init_checkers()) {
+		condlog(0, "failed to initialize checkers");
+		goto out;
+	}
+	if (init_prio()) {
+		condlog(0, "failed to initialize prioritizers");
+		goto out;
+	}
+
+	/* Failing here is non-fatal */
+	init_foreign(conf->enable_foreign);
+
 	if (cmd == CMD_RESET_WWIDS) {
 		struct multipath * mpp;
 		int i;
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

