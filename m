Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E01BC4321E
	for <dm-devel@archiver.kernel.org>; Wed,  9 Nov 2022 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668030596;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dz5RNnQ/vdXyEtedkEjd6tk27gxBbgtDG0U4CKNbJKo=;
	b=G3T1SScFFx2pQJBDunQ7sMXCEYZ+/PFDDA/IT06ABB1mnmWSLxEDykg7N6/e2KbZMBEml6
	HgVEz0DDJ6xPlTl3Y6mO9gxH+PG/f9CqEBoSkSp/m1OFkf8O3xDu5DtGprNRO8GHQg7U+k
	FQCJmfRa1T3ZRYft0bGqWcIsVUmEfM8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-HN7ac5n-MV63O-96pSttNQ-1; Wed, 09 Nov 2022 16:49:53 -0500
X-MC-Unique: HN7ac5n-MV63O-96pSttNQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 720F83C0DDDF;
	Wed,  9 Nov 2022 21:49:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5EF2A477F66;
	Wed,  9 Nov 2022 21:49:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BC471946597;
	Wed,  9 Nov 2022 21:49:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EEA11946A4B
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Nov 2022 21:49:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 450BF111DCE0; Wed,  9 Nov 2022 21:49:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BB291121320;
 Wed,  9 Nov 2022 21:49:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2A9LnmjA009480;
 Wed, 9 Nov 2022 15:49:49 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2A9LnmfE009479;
 Wed, 9 Nov 2022 15:49:48 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  9 Nov 2022 15:49:43 -0600
Message-Id: <1668030583-9428-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1668030583-9428-1-git-send-email-bmarzins@redhat.com>
References: <1668030583-9428-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 3/3] libmultipath: improve remove_feature()
 variable names
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use descriptive names, instead of single letters. No functional changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 80 +++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index f90bd0b6..87e84d5d 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -668,86 +668,86 @@ int add_feature(char **features_p, const char *new_feat)
 	return 0;
 }
 
-int remove_feature(char **f, const char *o)
+int remove_feature(char **features_p, const char *old_feat)
 {
-	int c = 0, d;
-	char *e, *p, *n;
-	const char *q;
+	int count = 0, len;
+	char *feats_start, *ptr, *new;
 
-	if (!f || !*f)
+	if (!features_p || !*features_p)
 		return 1;
 
 	/* Nothing to do */
-	if (!o || *o == '\0')
+	if (!old_feat || *old_feat == '\0')
 		return 0;
 
-	d = strlen(o);
-	if (isspace(*o) || isspace(*(o + d - 1))) {
-		condlog(0, "internal error: feature \"%s\" has leading or trailing spaces", o);
+	len = strlen(old_feat);
+	if (isspace(*old_feat) || isspace(*(old_feat + len - 1))) {
+		condlog(0, "internal error: feature \"%s\" has leading or trailing spaces",
+			old_feat);
 		return 1;
 	}
 
 	/* Check if present and not part of a larger feature token*/
-	p = *f + 1; /* the size must be at the start of the features string */
-	while ((p = strstr(p, o)) != NULL) {
-		if (isspace(*(p - 1)) &&
-		    (isspace(*(p + d)) || *(p + d) == '\0'))
+	ptr = *features_p + 1;
+	while ((ptr = strstr(ptr, old_feat)) != NULL) {
+		if (isspace(*(ptr - 1)) &&
+		    (isspace(*(ptr + len)) || *(ptr + len) == '\0'))
 			break;
-		p += d;
+		ptr += len;
 	}
-	if (!p)
+	if (!ptr)
 		return 0;
 
 	/* Get feature count */
-	c = strtoul(*f, &e, 10);
-	if (*f == e || !isspace(*e)) {
-		condlog(0, "parse error in feature string \"%s\"", *f);
+	count = strtoul(*features_p, &feats_start, 10);
+	if (*features_p == feats_start || !isspace(*feats_start)) {
+		condlog(0, "parse error in feature string \"%s\"", *features_p);
 		return 1;
 	}
 
 	/* Update feature count */
-	c--;
-	q = o;
-	while (*q != '\0') {
-		if (isspace(*q) && !isspace(*(q + 1)) && *(q + 1) != '\0')
-			c--;
-		q++;
+	count--;
+	while (*old_feat != '\0') {
+		if (isspace(*old_feat) && !isspace(*(old_feat + 1)) &&
+		    *(old_feat + 1) != '\0')
+			count--;
+		old_feat++;
 	}
 
 	/* Quick exit if all features have been removed */
-	if (c == 0) {
-		n = malloc(2);
-		if (!n)
+	if (count == 0) {
+		new = malloc(2);
+		if (!new)
 			return 1;
-		strcpy(n, "0");
+		strcpy(new, "0");
 		goto out;
 	}
 
 	/* Update feature count space */
-	n =  malloc(strlen(*f) - d + 1);
-	if (!n)
+	new = malloc(strlen(*features_p) - len + 1);
+	if (!new)
 		return 1;
 
 	/* Copy the feature count */
-	sprintf(n, "%0d", c);
+	sprintf(new, "%0d", count);
 	/*
 	 * Copy existing features up to the feature
 	 * about to be removed
 	 */
-	strncat(n, e, (size_t)(p - e));
+	strncat(new, feats_start, (size_t)(ptr - feats_start));
 	/* Skip feature to be removed */
-	p += d;
+	ptr += len;
 	/* Copy remaining features */
-	while (isspace(*p))
-		p++;
-	if (*p != '\0')
-		strcat(n, p);
+	while (isspace(*ptr))
+		ptr++;
+	if (*ptr != '\0')
+		strcat(new, ptr);
 	else
-		strchop(n);
+		strchop(new);
 
 out:
-	free(*f);
-	*f = n;
+	free(*features_p);
+	*features_p = new;
 
 	return 0;
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

