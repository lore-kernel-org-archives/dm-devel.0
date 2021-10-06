Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2790C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:05:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 469496113A
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:05:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 469496113A
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633550703;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V2sAmincTnCJ/CF8EVhULUJI5N9Jtcgz6/9kzqrZpDM=;
	b=PAb1FUHyIDxaNxrLmJx86aWQRiXcDQnnFDrwhNIlJpaa9LZ5pReJJ4Z2P5VyVlRfRCiLhF
	8OhqP1SPOn4QjF49qV32hUpNqaeQSDwNjhqtNdefXqgnA5s6vrdVRAGwgfl9Ckq2tiUkqE
	Lr8S9NQ39PBsHxvpCm5AqP8osH5YpPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-UH_qf40oNcqo-gqMOK0mpg-1; Wed, 06 Oct 2021 16:05:01 -0400
X-MC-Unique: UH_qf40oNcqo-gqMOK0mpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C46D650752;
	Wed,  6 Oct 2021 20:04:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB71A5F4FA;
	Wed,  6 Oct 2021 20:04:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D6E91806D01;
	Wed,  6 Oct 2021 20:04:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196K4VDh020067 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 16:04:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B69CE5F4EE; Wed,  6 Oct 2021 20:04:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 351CD5F4E7;
	Wed,  6 Oct 2021 20:04:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 196K4Rlw025617; 
	Wed, 6 Oct 2021 15:04:27 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 196K4RYS025616;
	Wed, 6 Oct 2021 15:04:27 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  6 Oct 2021 15:04:17 -0500
Message-Id: <1633550663-25571-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 2/8] libmultipath: use typedef for keyword
	handler function
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Don't keep writing out the function type.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c |  6 +++---
 libmultipath/parser.h | 15 ++++++---------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 611054f7..ebe1cbd9 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -33,7 +33,7 @@ static int line_nr;
 
 int
 keyword_alloc(vector keywords, char *string,
-	      int (*handler) (struct config *, vector),
+	      handler_fn *handler,
 	      print_fn *print,
 	      int unique)
 {
@@ -72,7 +72,7 @@ install_sublevel_end(void)
 
 int
 _install_keyword(vector keywords, char *string,
-		 int (*handler) (struct config *, vector),
+		 handler_fn *handler,
 		 print_fn *print,
 		 int unique)
 {
@@ -558,7 +558,7 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 						goto out;
 				}
 				if (keyword->handler) {
-				    t = (*keyword->handler) (conf, strvec);
+				    t = keyword->handler(conf, strvec);
 					r += t;
 					if (t)
 						condlog(1, "multipath.conf +%d, parsing failed: %s",
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index b43d46f8..3452bde1 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -43,10 +43,11 @@ struct strbuf;
 
 /* keyword definition */
 typedef int print_fn(struct config *, struct strbuf *, const void *);
+typedef int handler_fn(struct config *, vector);
 
 struct keyword {
 	char *string;
-	int (*handler) (struct config *, vector);
+	handler_fn *handler;
 	print_fn *print;
 	vector sub;
 	int unique;
@@ -62,18 +63,14 @@ struct keyword {
 	for (i = 0; i < (k)->sub->allocated && ((p) = (k)->sub->slot[i]); i++)
 
 /* Prototypes */
-extern int keyword_alloc(vector keywords, char *string,
-			 int (*handler) (struct config *, vector),
-			 print_fn *print,
-			 int unique);
+extern int keyword_alloc(vector keywords, char *string, handler_fn *handler,
+			 print_fn *print, int unique);
 #define install_keyword_root(str, h) keyword_alloc(keywords, str, h, NULL, 1)
 extern void install_sublevel(void);
 extern void install_sublevel_end(void);
 
-extern int _install_keyword(vector keywords, char *string,
-			    int (*handler) (struct config *, vector),
-			    print_fn *print,
-			    int unique);
+extern int _install_keyword(vector keywords, char *string, handler_fn *handler,
+			    print_fn *print, int unique);
 #define install_keyword(str, vec, pri) _install_keyword(keywords, str, vec, pri, 1)
 #define install_keyword_multi(str, vec, pri) _install_keyword(keywords, str, vec, pri, 0)
 extern void dump_keywords(vector keydump, int level);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

