Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC6EC28D13
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200919;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QLf1N7CwahTQo9tLv4fyp/HgRfnb2xymWuklGQV+uaU=;
	b=LAtGSWUgYe/Gmxt6toj9gBTt6zg0Ut+oCZdfHwVtq8tgvfGelg+Rm5YN5vx4Q0k1p5D5+A
	Zhoje6cHlMYniPgtN0UyxUYvsp7fZeTT/B69PI0ADSXzhDeqBYTBkJsdjoCU5Hcxo/vVX8
	Blfq8howrL4xvHy3VpN/vDMSRRRD1qA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-QQaOawYBP6KtEbC_naW82A-1; Mon, 22 Aug 2022 16:41:57 -0400
X-MC-Unique: QQaOawYBP6KtEbC_naW82A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC24F2999B23;
	Mon, 22 Aug 2022 20:41:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D7481C15BB3;
	Mon, 22 Aug 2022 20:41:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF4CD1946A52;
	Mon, 22 Aug 2022 20:41:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BDB831946A67
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93427492CA5; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F81E492CA4
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77049803301
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-3-jRqlSxKJPESDT4FvoCTp3Q-1; Mon,
 22 Aug 2022 16:41:51 -0400
X-MC-Unique: jRqlSxKJPESDT4FvoCTp3Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 857D35CAF5;
 Mon, 22 Aug 2022 20:41:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 48EC913523;
 Mon, 22 Aug 2022 20:41:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KFc+EA7qA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:50 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:15 +0200
Message-Id: <20220822204119.20719-8-mwilck@suse.com>
In-Reply-To: <20220822204119.20719-1-mwilck@suse.com>
References: <20220822204119.20719-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 07/11] libmultipath: remove weak attribute for
 {get, put}_multipath_config
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The "weak" attribute was set to make sure that these symbols are overridden by
symbols of the same name in the main executable. This is unnecessary, as the
standard ELF symbol resolution algorithm ensures this even without the "weak"
attribute.

See ELF Specification, III.2 Dynamic Linking / Shared Object Dependencies:
"The dynamic linker examines the symbol tables with a breadth-first
search. That is, it first looks at the symbol table of the executable program
itself, then at the symbol tables of the DT_NEEDED entries (in order), then at
the second level DT_NEEDED entries, and so on".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c |  4 ++--
 libmultipath/config.h | 11 -----------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a2c79a4..5c5c072 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -82,7 +82,7 @@ struct config *libmp_get_multipath_config(void)
 }
 
 struct config *get_multipath_config(void)
-	__attribute__((weak, alias("libmp_get_multipath_config")));
+	__attribute__((alias("libmp_get_multipath_config")));
 
 void libmp_put_multipath_config(void *conf __attribute__((unused)))
 {
@@ -90,7 +90,7 @@ void libmp_put_multipath_config(void *conf __attribute__((unused)))
 }
 
 void put_multipath_config(void *conf)
-	__attribute__((weak, alias("libmp_put_multipath_config")));
+	__attribute__((alias("libmp_put_multipath_config")));
 
 static int
 hwe_strmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
diff --git a/libmultipath/config.h b/libmultipath/config.h
index fdcdff0..2d00ad2 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -303,17 +303,6 @@ void free_config (struct config * conf);
 int init_config(const char *file);
 void uninit_config(void);
 
-/*
- * libmultipath provides default implementations of
- * get_multipath_config() and put_multipath_config().
- * Applications using these should use init_config(file, NULL)
- * to load the configuration, rather than load_config(file).
- * Likewise, uninit_config() should be used for teardown, but
- * using free_config() for that is supported, too.
- * Applications can define their own {get,put}_multipath_config()
- * functions, which override the library-internal ones, but
- * could still call libmp_{get,put}_multipath_config().
- */
 struct config *libmp_get_multipath_config(void);
 struct config *get_multipath_config(void);
 void libmp_put_multipath_config(void *);
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

