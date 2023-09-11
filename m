Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD12FEE57DF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iFCWpjLvnCVZNd76en2Eb4KlohxV3GDdgTBAtuGVUT4=;
	b=Aoy6aNv0EG/HEHRSEZc8oaukNQtPpBoWIrosUHiXo+5bw4WWF1m++zVd/YjHT4vmLHA2kz
	hP+BmusIbDOrLE0oov8UvwkbBZS2+jRU5aprVnvooRCeRyrFulR/PsupC+nSvBgCjFPFL0
	iv9zMFk8m72s7sw7Uq3HUNsemqo3ZTg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-I2fj7Z81MhqhUaqmkUTaZw-1; Mon, 11 Sep 2023 12:39:49 -0400
X-MC-Unique: I2fj7Z81MhqhUaqmkUTaZw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6200481652E;
	Mon, 11 Sep 2023 16:39:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EAB440C6EBF;
	Mon, 11 Sep 2023 16:39:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE8D019465B8;
	Mon, 11 Sep 2023 16:39:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C7AF1946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5DC232027047; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5619E2027045
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38BCC945E90
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-7HTqDs7JOEOEbvXzVhHqJg-1; Mon,
 11 Sep 2023 12:39:24 -0400
X-MC-Unique: 7HTqDs7JOEOEbvXzVhHqJg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 5C05E1F8CD;
 Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2CD9A139CC;
 Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id WJ8xCbtC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:23 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:43 +0200
Message-ID: <20230911163846.27197-35-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 34/37] libmultipath: print built-in values for
 deprecated options
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

In the error messages we print when a deprecated option is encountered,
print the compile-time value of the option.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index f81c84a..dace343 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -314,14 +314,16 @@ def_ ## option ## _handler (struct config *conf, vector strvec,		\
 static int deprecated_handler(struct config *conf, vector strvec, const char *file,
 			      int line_nr);
 
-#define declare_deprecated_handler(option)				\
+#define declare_deprecated_handler(option, default)				\
 static int								\
 deprecated_ ## option ## _handler (struct config *conf, vector strvec,	\
 				   const char *file, int line_nr)	\
 {									\
 	static bool warned;						\
 	if (!warned) {							\
-		condlog(1, "%s line %d: ignoring deprecated option \"" #option "\"", file, line_nr); \
+		condlog(1, "%s line %d: ignoring deprecated option \""	\
+			#option "\", using built-in value: \"%s\"",	\
+			file, line_nr, default);			\
 		warned = true;						\
 	}								\
 	return deprecated_handler(conf, strvec, file, line_nr);		\
@@ -2057,11 +2059,11 @@ snprint_deprecated (struct config *conf, struct strbuf *buff, const void * data)
 }
 
 // Deprecated keywords
-declare_deprecated_handler(config_dir)
-declare_deprecated_handler(disable_changed_wwids)
-declare_deprecated_handler(getuid_callout)
-declare_deprecated_handler(multipath_dir)
-declare_deprecated_handler(pg_timeout)
+declare_deprecated_handler(config_dir, CONFIG_DIR)
+declare_deprecated_handler(disable_changed_wwids, "yes")
+declare_deprecated_handler(getuid_callout, "(not set)")
+declare_deprecated_handler(multipath_dir, MULTIPATH_DIR)
+declare_deprecated_handler(pg_timeout, "(not set)")
 
 /*
  * If you add or remove a keyword also update multipath/multipath.conf.5
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

