Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB938C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 01:07:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8CE646135E
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 01:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8CE646135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636592826;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sT+Nj9qvyCy6uilhWBM1o2aCJvMAZeb3ptbi6CmFY9Q=;
	b=CV2mroT7RRAiGBgHVHLSleTu5Fm31HIYswBZmicCaAfbEXUt4EMS2SP98qbD1mP0IW0ycc
	zbUqHUIUUpx8WGeEirhbAbaxzbet1l7h8uFss4s2tMeZq1t1DVy8xiJ5UBBMGxJj+qGHfx
	qCaVeAPlR+dXVlUOBpPV2wSFpkOCnls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-6-9vm5_7Nz6Pg4DIquEsKA-1; Wed, 10 Nov 2021 20:07:03 -0500
X-MC-Unique: 6-9vm5_7Nz6Pg4DIquEsKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B130587180C;
	Thu, 11 Nov 2021 01:06:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 930375E26F;
	Thu, 11 Nov 2021 01:06:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6EF2418199EE;
	Thu, 11 Nov 2021 01:06:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB16VYb013108 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Nov 2021 20:06:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5AB0B9324; Thu, 11 Nov 2021 01:06:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEB2090BA;
	Thu, 11 Nov 2021 01:06:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AB16QhL020437; 
	Wed, 10 Nov 2021 19:06:26 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AB16PfW020436;
	Wed, 10 Nov 2021 19:06:25 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 10 Nov 2021 19:06:13 -0600
Message-Id: <1636592780-20391-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 2/9] libmultipath: use typedef for keyword
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Don't keep writing out the function type.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

