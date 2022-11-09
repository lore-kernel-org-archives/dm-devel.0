Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36173C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Nov 2022 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668030596;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XiRAZEx0qcSWHKbXynkAJiT6G6slm8hrmjzpMuvc/LA=;
	b=SK/A14gS7ZzyoGN2MAwCreWo0jud7PUieAXVVRgalKoHI0bjFp6E4SnisGLA7Wm/JD4dnN
	zHeDJ9Nw2zdn44iBywL4lccQsjpes/7M8HqdTTGlKjav/spzOFGBKhGgI19oHkzyQPYUA4
	bVk1AM9a9c7V4gBC36Dsw4UXuVnc3q4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-y6Nt0AT9OuSSKfTJpeaKbQ-1; Wed, 09 Nov 2022 16:49:52 -0500
X-MC-Unique: y6Nt0AT9OuSSKfTJpeaKbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A363803D48;
	Wed,  9 Nov 2022 21:49:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEBA1200B408;
	Wed,  9 Nov 2022 21:49:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3EF6019466DF;
	Wed,  9 Nov 2022 21:49:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B782A1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Nov 2022 21:49:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ABFCF1415119; Wed,  9 Nov 2022 21:49:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 941C4140EBF5;
 Wed,  9 Nov 2022 21:49:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2A9LnkAl009472;
 Wed, 9 Nov 2022 15:49:46 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2A9Lnj4i009471;
 Wed, 9 Nov 2022 15:49:45 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  9 Nov 2022 15:49:41 -0600
Message-Id: <1668030583-9428-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1668030583-9428-1-git-send-email-bmarzins@redhat.com>
References: <1668030583-9428-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 1/3] libmultipath: impove add_feature() variable
 names
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

Use descriptive names, instead of single letters. No functional changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 63 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 7a2ff589..f90bd0b6 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -604,65 +604,66 @@ first_path (const struct multipath * mpp)
 	return pgp?VECTOR_SLOT(pgp->paths, 0):NULL;
 }
 
-int add_feature(char **f, const char *n)
+int add_feature(char **features_p, const char *new_feat)
 {
-	int c = 0, d, l;
-	char *e, *t;
-	const char *p;
+	int count = 0, new_count, len;
+	char *tmp, *feats;
+	const char *ptr;
 
-	if (!f)
+	if (!features_p)
 		return 1;
 
 	/* Nothing to do */
-	if (!n || *n == '\0')
+	if (!new_feat || *new_feat == '\0')
 		return 0;
 
-	l = strlen(n);
-	if (isspace(*n) || isspace(*(n + l - 1))) {
-		condlog(0, "internal error: feature \"%s\" has leading or trailing spaces", n);
+	len = strlen(new_feat);
+	if (isspace(*new_feat) || isspace(*(new_feat + len - 1))) {
+		condlog(0, "internal error: feature \"%s\" has leading or trailing spaces",
+			new_feat);
 		return 1;
 	}
 
-	p = n;
-	d = 1;
-	while (*p != '\0') {
-		if (isspace(*p) && !isspace(*(p + 1)) && *(p + 1) != '\0')
-			d++;
-		p++;
+	ptr = new_feat;
+	new_count = 1;
+	while (*ptr != '\0') {
+		if (isspace(*ptr) && !isspace(*(ptr + 1)) && *(ptr + 1) != '\0')
+			new_count++;
+		ptr++;
 	}
 
 	/* default feature is null */
-	if(!*f)
+	if(!*features_p)
 	{
-		l = asprintf(&t, "%0d %s", d, n);
-		if(l == -1)
+		len = asprintf(&feats, "%0d %s", new_count, new_feat);
+		if(len == -1)
 			return 1;
 
-		*f = t;
+		*features_p = feats;
 		return 0;
 	}
 
 	/* Check if feature is already present */
-	e = *f;
-	while ((e = strstr(e, n)) != NULL) {
-		if (isspace(*(e - 1)) &&
-		    (isspace(*(e + l)) || *(e + l) == '\0'))
+	tmp = *features_p;
+	while ((tmp = strstr(tmp, new_feat)) != NULL) {
+		if (isspace(*(tmp - 1)) &&
+		    (isspace(*(tmp + len)) || *(tmp + len) == '\0'))
 			return 0;
-		e += l;
+		tmp += len;
 	}
 
 	/* Get feature count */
-	c = strtoul(*f, &e, 10);
-	if (*f == e || (!isspace(*e) && *e != '\0')) {
-		condlog(0, "parse error in feature string \"%s\"", *f);
+	count = strtoul(*features_p, &tmp, 10);
+	if (*features_p == tmp || (!isspace(*tmp) && *tmp != '\0')) {
+		condlog(0, "parse error in feature string \"%s\"", *features_p);
 		return 1;
 	}
-	c += d;
-	if (asprintf(&t, "%0d%s %s", c, e, n) < 0)
+	count += new_count;
+	if (asprintf(&feats, "%0d%s %s", count, tmp, new_feat) < 0)
 		return 1;
 
-	free(*f);
-	*f = t;
+	free(*features_p);
+	*features_p = feats;
 
 	return 0;
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

