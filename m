Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E55EECAAD2
	for <dm-devel@archiver.kernel.org>; Fri, 26 Aug 2022 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661531106;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=laV7MnrRrvp6BKiwNf6/q5ekpWJb5uUVoHlrNnxQv0Q=;
	b=OI4+dB5K/6+6dInenQEb8lZ476iABzfw+5Zu8I8AF3hzL3u7NxUz8aoONBU8mopdxeEzNp
	GE/q3XRRvSq+vU19bOtpf74TKJADgxJR0bFXN3/u5hC+4vF88ti14bva9aGNNdGiAFzqKZ
	oGamjNkZENQBoL0HKJABO+HvVqUXWl8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-6zUtt8jYMlSXN_KjWuBb2g-1; Fri, 26 Aug 2022 12:22:35 -0400
X-MC-Unique: 6zUtt8jYMlSXN_KjWuBb2g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EF901857F1A;
	Fri, 26 Aug 2022 16:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96C07492C3B;
	Fri, 26 Aug 2022 16:22:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03C281946A4E;
	Fri, 26 Aug 2022 16:22:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADDB51946A6C
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92102492CA2; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DBEE492CA5
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 766331857F06
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-387-Bvf_TAHbMaOpEurz_R4ptg-1; Fri,
 26 Aug 2022 12:22:27 -0400
X-MC-Unique: Bvf_TAHbMaOpEurz_R4ptg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A320E1F940;
 Fri, 26 Aug 2022 16:22:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 764AD13421;
 Fri, 26 Aug 2022 16:22:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id CAN6G0HzCGPocAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 26 Aug 2022 16:22:25 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Aug 2022 18:22:03 +0200
Message-Id: <20220826162203.20317-6-mwilck@suse.com>
In-Reply-To: <20220826162203.20317-1-mwilck@suse.com>
References: <20220826162203.20317-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v3 5/5] multipath: optimize program startup for
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

