Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9C9EEB593
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450375;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LI3Acn4bSJ6aOdu14j1adhvasfwhyeDgt+MIl3eKO4o=;
	b=VSuewwG2x49buvQtWnKVn8sPxB+eRJIW2UisusGnpL0YaB2/s3DKkdnSKl8lKKy7M1Vu4m
	wXhiQbviNVghF0G8w2ZgHkBzANRF0NXtkiVAewAV0IsizZFmya9fDkllB8kLbo1UR1qevf
	z0yj2px66zzR/0nXX+OMN5xincsJyr4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-682-5jGTQJFFPDGZ-SBRvTUmlQ-1; Mon, 11 Sep 2023 12:39:30 -0400
X-MC-Unique: 5jGTQJFFPDGZ-SBRvTUmlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A05F9933737;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CDA640C6EA8;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52CBA19465B8;
	Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C231119465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B3A9C4405A; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC1B55CC01
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77C7E181A6F7
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-426-Xre1CYOvPSC6DtKBcZd6Zg-1; Mon,
 11 Sep 2023 12:39:19 -0400
X-MC-Unique: Xre1CYOvPSC6DtKBcZd6Zg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 293F021858;
 Mon, 11 Sep 2023 16:39:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF1FB139CC;
 Mon, 11 Sep 2023 16:39:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id yFaeOLVC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:23 +0200
Message-ID: <20230911163846.27197-15-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 14/37] libmultipath: update_bindings_file:
 take filename argument
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

This function just uses the file name, no other configuration
parameters. Also, pass the Bindings argument first to use the
same convention as the other functions in this file.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 7e6b0d2..ae7bbd2 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -138,15 +138,15 @@ static int write_bindings_file(const Bindings *bindings, int fd)
 	return 0;
 }
 
-static int update_bindings_file(const struct config *conf,
-				const Bindings *bindings)
+static int update_bindings_file(const Bindings *bindings,
+				const char *bindings_file)
 {
 	int rc;
 	int fd = -1;
 	char tempname[PATH_MAX];
 	mode_t old_umask;
 
-	if (safe_sprintf(tempname, "%s.XXXXXX", conf->bindings_file))
+	if (safe_sprintf(tempname, "%s.XXXXXX", bindings_file))
 		return -1;
 	/* coverity: SECURE_TEMP */
 	old_umask = umask(0077);
@@ -164,10 +164,10 @@ static int update_bindings_file(const struct config *conf,
 		unlink(tempname);
 		return rc;
 	}
-	if ((rc = rename(tempname, conf->bindings_file)) == -1)
+	if ((rc = rename(tempname, bindings_file)) == -1)
 		condlog(0, "%s: rename: %m", __func__);
 	else
-		condlog(1, "updated bindings file %s", conf->bindings_file);
+		condlog(1, "updated bindings file %s", bindings_file);
 	return rc;
 }
 
@@ -767,7 +767,7 @@ int check_alias_settings(const struct config *conf)
 			rc = _check_bindings_file(conf, file, &bindings);
 			pthread_cleanup_pop(1);
 			if (rc == -1 && can_write && !conf->bindings_read_only)
-				rc = update_bindings_file(conf, &bindings);
+				rc = update_bindings_file(&bindings, conf->bindings_file);
 			else if (rc == -1)
 				condlog(0, "ERROR: bad settings in read-only bindings file %s",
 					conf->bindings_file);
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

