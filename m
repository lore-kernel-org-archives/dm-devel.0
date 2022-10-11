Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C46BC43217
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 21:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665525194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4yFhr+YY8RSq2SNIb33z87A4pasXjUhGZglLorjNxOI=;
	b=NgSUkAQqoB7ORqdE+veMUL+Ell9Ki6zTdS59p2YBm1Ou3fTojf7R+Wn8MQUpF15nwNk6bi
	p3eNsYI8ko4hIT7cclw6hfEQ6u/3F5dcENOl6cj6Dm6L6jLvJ5VcgvWAHvZTY+rcDji2Si
	2VJHBVPfW8IQ+oBamGC+vItacgBFJt8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-qPvmguYwOe2qsMssaq9xLg-1; Tue, 11 Oct 2022 17:53:11 -0400
X-MC-Unique: qPvmguYwOe2qsMssaq9xLg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30712101A52A;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29E5A40C6F75;
	Tue, 11 Oct 2022 21:53:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7705419465B2;
	Tue, 11 Oct 2022 21:53:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A33131946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Oct 2022 21:53:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7FA264C816; Tue, 11 Oct 2022 21:53:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6505E39DB3;
 Tue, 11 Oct 2022 21:53:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29BLr5rG027419;
 Tue, 11 Oct 2022 16:53:05 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29BLr4Zw027418;
 Tue, 11 Oct 2022 16:53:04 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 11 Oct 2022 16:53:00 -0500
Message-Id: <1665525183-27377-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 1/4] libmultipath: don't print garbage keywords
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If snprint_keyword() failed to correctly set up sbuf, don't print it.
Instead, return an error.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/parser.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index 014d9b83..8d3ac53a 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -152,7 +152,7 @@ int
 snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 		const void *data)
 {
-	int r;
+	int r = 0;
 	char *f;
 	struct config *conf;
 	STRBUF_ON_STACK(sbuf);
@@ -190,8 +190,10 @@ snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 		}
 	} while (*fmt++);
 out:
-	return __append_strbuf_str(buff, get_strbuf_str(&sbuf),
-				   get_strbuf_len(&sbuf));
+	if (r >= 0)
+		r = __append_strbuf_str(buff, get_strbuf_str(&sbuf),
+					get_strbuf_len(&sbuf));
+	return r;
 }
 
 static const char quote_marker[] = { '\0', '"', '\0' };
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

