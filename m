Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17246CA0FF4
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591416;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tt5z/D697IfPXT/pZGGVYSA0oh7reM8CMYI5wNBtI9c=;
	b=fPOk90M1JM9AlCAlTn+S0t2zRaJATjAalInd0qlNKnRoJIYtI8+4I2+hDSHbTEFOIhvZdg
	ZrJWACxzD7KSEuhBxhZuP7ZzgpFP1EkBkDy5R5CZ16udWtq3vu1ek0bI9edj6cEIaoWnIy
	9SS0CAOwsjjvH4dOBsIk7Mbm8LCO50M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-RDSBEvJfPryt-t7QlVFrHA-1; Fri, 01 Sep 2023 14:03:32 -0400
X-MC-Unique: RDSBEvJfPryt-t7QlVFrHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9947C3C0EAB7;
	Fri,  1 Sep 2023 18:03:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87A1963F7A;
	Fri,  1 Sep 2023 18:03:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 75DD51946A46;
	Fri,  1 Sep 2023 18:03:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7610F194729A
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64156D4781B; Fri,  1 Sep 2023 18:03:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C774D4781A
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E903A89F4FD
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:24 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-RSj63q7LM5yIni8C9u1apw-1; Fri,
 01 Sep 2023 14:03:22 -0400
X-MC-Unique: RSj63q7LM5yIni8C9u1apw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id E9D651F74D;
 Fri,  1 Sep 2023 18:03:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B6DC713582;
 Fri,  1 Sep 2023 18:03:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id GNj9Kmgn8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:20 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:27 +0200
Message-ID: <20230901180235.23980-15-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 14/21] libmultipath: update_bindings_file: take
 filename argument
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This function just uses the file name, no other configuration
parameters. Also, pass the Bindings argument first to use the
same convention as the other functions in this file.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 5a6cdee..76d852f 100644
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
 
@@ -778,7 +778,7 @@ int check_alias_settings(const struct config *conf)
 			rc = _check_bindings_file(conf, file, &bindings);
 			pthread_cleanup_pop(1);
 			if (rc == -1 && can_write && !conf->bindings_read_only)
-				rc = update_bindings_file(conf, &bindings);
+				rc = update_bindings_file(&bindings, conf->bindings_file);
 			else if (rc == -1)
 				condlog(0, "ERROR: bad settings in read-only bindings file %s",
 					conf->bindings_file);
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

