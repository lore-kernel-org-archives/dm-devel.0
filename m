Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C781BC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164153;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZxjdTvu55i6p/X236qxgMXHAMHrRh/kUpW4BxcVWAo0=;
	b=fKgzsTu6NeYBhtRSP0lLnRvWj+SUHcQQ3FBAzspNZTtwcCmil/ZIEvCLq95lwwQJAGS/p2
	M12F5UGhg0BeuLLha0ThcUsL1eRAj4oi+qm+W3jc0//C1rbEhuz6VDNEs0eGKAnCochnCf
	lr7B63rhTIXFvprgouELYbcPpLJEsno=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-cwFf3BTBN4CsReD6j6VyWw-1; Fri, 07 Oct 2022 13:35:52 -0400
X-MC-Unique: cwFf3BTBN4CsReD6j6VyWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5A9C3C0E219;
	Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DB7020290A2;
	Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CFCD1946A66;
	Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5BEEA1946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4CC572166BDE; Fri,  7 Oct 2022 17:35:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F5062166B4D;
 Fri,  7 Oct 2022 17:35:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZlVV006764;
 Fri, 7 Oct 2022 12:35:47 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZls2006761;
 Fri, 7 Oct 2022 12:35:47 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:38 -0500
Message-Id: <1665164144-6716-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 2/8] libmultipath: cleanup add_feature
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

add_feature() didn't correctly handle feature strings that used
whitespace other than spaces, which the kernel allows. It also didn't
allow adding features with multiple tokens. When it looked to see if the
feature string to be added already existed, it didn't check if the match
was part of a larger token. Finally, it did unnecessary work.  By using
asprintf() to create the string, the function can be signifcantly
simplified.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 49 +++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 1f9945e0..0f16c071 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -602,23 +602,33 @@ int add_feature(char **f, const char *n)
 {
 	int c = 0, d, l;
 	char *e, *t;
+	const char *p;
 
 	if (!f)
 		return 1;
 
 	/* Nothing to do */
-	if (!n || *n == '0')
+	if (!n || *n == '\0')
 		return 0;
 
-	if (strchr(n, ' ') != NULL) {
-		condlog(0, "internal error: feature \"%s\" contains spaces", n);
+	l = strlen(n);
+	if (isspace(*n) || isspace(*(n + l - 1))) {
+		condlog(0, "internal error: feature \"%s\" has leading or trailing spaces", n);
 		return 1;
 	}
 
+	p = n;
+	d = 1;
+	while (*p != '\0') {
+		if (isspace(*p) && !isspace(*(p + 1)) && *(p + 1) != '\0')
+			d++;
+		p++;
+	}
+
 	/* default feature is null */
 	if(!*f)
 	{
-		l = asprintf(&t, "1 %s", n);
+		l = asprintf(&t, "%0d %s", d, n);
 		if(l == -1)
 			return 1;
 
@@ -627,35 +637,24 @@ int add_feature(char **f, const char *n)
 	}
 
 	/* Check if feature is already present */
-	if (strstr(*f, n))
-		return 0;
+	e = *f;
+	while ((e = strstr(e, n)) != NULL) {
+		if (isspace(*(e - 1)) &&
+		    (isspace(*(e + l)) || *(e + l) == '\0'))
+			return 0;
+		e += l;
+	}
 
 	/* Get feature count */
 	c = strtoul(*f, &e, 10);
-	if (*f == e || (*e != ' ' && *e != '\0')) {
+	if (*f == e || (!isspace(*e) && *e != '\0')) {
 		condlog(0, "parse error in feature string \"%s\"", *f);
 		return 1;
 	}
-
-	/* Add 1 digit and 1 space */
-	l = strlen(e) + strlen(n) + 2;
-
-	c++;
-	/* Check if we need more digits for feature count */
-	for (d = c; d >= 10; d /= 10)
-		l++;
-
-	t = calloc(1, l + 1);
-	if (!t)
+	c += d;
+	if (asprintf(&t, "%0d%s %s", c, e, n) < 0)
 		return 1;
 
-	/* e: old feature string with leading space, or "" */
-	if (*e == ' ')
-		while (*(e + 1) == ' ')
-			e++;
-
-	snprintf(t, l + 1, "%0d%s %s", c, e, n);
-
 	free(*f);
 	*f = t;
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

