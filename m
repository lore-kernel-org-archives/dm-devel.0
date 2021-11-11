Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C604C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB222610F8
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB222610F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636656857;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ix60BVVOFmm1mE4367DDlz9kaSOG4URjHyJZMTvssew=;
	b=ZZIiN0Umnc1OH+wKyQkKPKkCVPqCOg7MGiYTOZl+TeDQXioxaN//YZQD6PQpdGTFHjE3Cc
	RYe4QLtptfjgd0dFAN5u1M3JKEycv3RF+fx811H9hWammxkvCsWIhCydRDR2Y83jMqjWls
	qqYxrw/VRCF+I42jyHfYX2E3Aq+do8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-w_cEOdfiO0K9vyPrU5_I1A-1; Thu, 11 Nov 2021 13:54:14 -0500
X-MC-Unique: w_cEOdfiO0K9vyPrU5_I1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 793EA102CC54;
	Thu, 11 Nov 2021 18:54:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED0CE10016F4;
	Thu, 11 Nov 2021 18:54:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A07014E58F;
	Thu, 11 Nov 2021 18:54:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABIs3FY027744 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 13:54:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8C96929403; Thu, 11 Nov 2021 18:54:03 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20BA55DEFB;
	Thu, 11 Nov 2021 18:53:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ABIrt9H026105; 
	Thu, 11 Nov 2021 12:53:56 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ABIrtmk026103;
	Thu, 11 Nov 2021 12:53:55 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 11 Nov 2021 12:53:44 -0600
Message-Id: <1636656832-26062-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
References: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 1/9] libmultipath: add section name to invalid
	keyword output
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If users forget the closing brace for a section in multipath.conf,
multipath has no way to detect that. When it sees the keyword at the
start of the next section, it will complain that there is an invalid
keyword, because that keyword doesn't belong in previous section (which
was never ended with a closing brace). This can confuse users. To make
this easier to understand, when multipath prints an invalid keyword
message, it now also prints the current section name, which can give
users a hint that they didn't end the previous section.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/parser.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 8ca91bf2..611054f7 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -504,7 +504,7 @@ validate_config_strvec(vector strvec, const char *file)
 
 static int
 process_stream(struct config *conf, FILE *stream, vector keywords,
-	       const char *file)
+	       const char *section, const char *file)
 {
 	int i;
 	int r = 0, t;
@@ -568,16 +568,22 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 				if (keyword->sub) {
 					kw_level++;
 					r += process_stream(conf, stream,
-							    keyword->sub, file);
+							    keyword->sub,
+							    keyword->string,
+							    file);
 					kw_level--;
 				}
 				break;
 			}
 		}
-		if (i >= VECTOR_SIZE(keywords))
-			condlog(1, "%s line %d, invalid keyword: %s",
-				file, line_nr, str);
-
+		if (i >= VECTOR_SIZE(keywords)) {
+			if (section)
+				condlog(1, "%s line %d, invalid keyword in the %s section: %s",
+					file, line_nr, section, str);
+			else
+				condlog(1, "%s line %d, invalid keyword: %s",
+					file, line_nr, str);
+		}
 		free_strvec(strvec);
 	}
 	if (kw_level == 1)
@@ -608,7 +614,7 @@ process_file(struct config *conf, const char *file)
 
 	/* Stream handling */
 	line_nr = 0;
-	r = process_stream(conf, stream, conf->keywords, file);
+	r = process_stream(conf, stream, conf->keywords, NULL, file);
 	fclose(stream);
 	//free_keywords(keywords);
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

