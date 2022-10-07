Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2575CC4332F
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164155;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BIgMnY49y+TR0PRm+E9Qfr9Tryex06phIzK7ud5E85k=;
	b=CmG62iAUFNnMsHHiGmTifUnk59Lq7jlk4RQfQAzDgH60x44n3YfkwkD1NBax/EcK+KS+Cv
	4Na8ISouL7npUXA86dT2zFaXEeQWoNSbt7ZtS9r9YLZ87KUuO8yGIBLrn4/EOkN/sxvVYE
	4El/R+PM05edcarcjBEyxMgTf35TwWQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-YV2EWiZSONmxt0ya7SrLvw-1; Fri, 07 Oct 2022 13:35:52 -0400
X-MC-Unique: YV2EWiZSONmxt0ya7SrLvw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6322855309;
	Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C879A535D20;
	Fri,  7 Oct 2022 17:35:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 809B51946A51;
	Fri,  7 Oct 2022 17:35:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 185421946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D85220290AE; Fri,  7 Oct 2022 17:35:48 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0CFE20290A2;
 Fri,  7 Oct 2022 17:35:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZkk2006758;
 Fri, 7 Oct 2022 12:35:46 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZkTK006757;
 Fri, 7 Oct 2022 12:35:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:37 -0500
Message-Id: <1665164144-6716-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 1/8] libmultipath: cleanup remove_feature
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

remove_feature() didn't correctly handle feature strings that used
whitespace other than spaces, which the kernel allows. It also didn't
check if the feature string to be removed was part of a larger feature
token. Finally, it did a lot of unnecessary work. By failing if the
feature string to be removed contains leading or trailing whitespace,
the function can be significanly simplified.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 82 +++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 53 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 49621cb3..1f9945e0 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -6,6 +6,7 @@
 #include <unistd.h>
 #include <libdevmapper.h>
 #include <libudev.h>
+#include <ctype.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -663,7 +664,7 @@ int add_feature(char **f, const char *n)
 
 int remove_feature(char **f, const char *o)
 {
-	int c = 0, d, l;
+	int c = 0, d;
 	char *e, *p, *n;
 	const char *q;
 
@@ -674,33 +675,35 @@ int remove_feature(char **f, const char *o)
 	if (!o || *o == '\0')
 		return 0;
 
-	/* Check if not present */
-	if (!strstr(*f, o))
+	d = strlen(o);
+	if (isspace(*o) || isspace(*(o + d - 1))) {
+		condlog(0, "internal error: feature \"%s\" has leading or trailing spaces", o);
+		return 1;
+	}
+
+	/* Check if present and not part of a larger feature token*/
+	p = *f + 1; /* the size must be at the start of the features string */
+	while ((p = strstr(p, o)) != NULL) {
+		if (isspace(*(p - 1)) &&
+		    (isspace(*(p + d)) || *(p + d) == '\0'))
+			break;
+		p += d;
+	}
+	if (!p)
 		return 0;
 
 	/* Get feature count */
 	c = strtoul(*f, &e, 10);
-	if (*f == e)
-		/* parse error */
+	if (*f == e || !isspace(*e)) {
+		condlog(0, "parse error in feature string \"%s\"", *f);
 		return 1;
-
-	/* Normalize features */
-	while (*o == ' ') {
-		o++;
 	}
-	/* Just spaces, return */
-	if (*o == '\0')
-		return 0;
-	q = o + strlen(o);
-	while (*q == ' ')
-		q--;
-	d = (int)(q - o);
 
 	/* Update feature count */
 	c--;
 	q = o;
-	while (q[0] != '\0') {
-		if (q[0] == ' ' && q[1] != ' ' && q[1] != '\0')
+	while (*q != '\0') {
+		if (isspace(*q) && !isspace(*(q + 1)) && *(q + 1) != '\0')
 			c--;
 		q++;
 	}
@@ -714,15 +717,8 @@ int remove_feature(char **f, const char *o)
 		goto out;
 	}
 
-	/* Search feature to be removed */
-	e = strstr(*f, o);
-	if (!e)
-		/* Not found, return */
-		return 0;
-
 	/* Update feature count space */
-	l = strlen(*f) - d;
-	n =  malloc(l + 1);
+	n =  malloc(strlen(*f) - d + 1);
 	if (!n)
 		return 1;
 
@@ -732,36 +728,16 @@ int remove_feature(char **f, const char *o)
 	 * Copy existing features up to the feature
 	 * about to be removed
 	 */
-	p = strchr(*f, ' ');
-	if (!p) {
-		/* Internal error, feature string inconsistent */
-		free(n);
-		return 1;
-	}
-	while (*p == ' ')
-		p++;
-	p--;
-	if (e != p) {
-		do {
-			e--;
-			d++;
-		} while (*e == ' ');
-		e++; d--;
-		strncat(n, p, (size_t)(e - p));
-		p += (size_t)(e - p);
-	}
+	strncat(n, e, (size_t)(p - e));
 	/* Skip feature to be removed */
 	p += d;
-
 	/* Copy remaining features */
-	if (strlen(p)) {
-		while (*p == ' ')
-			p++;
-		if (strlen(p)) {
-			p--;
-			strcat(n, p);
-		}
-	}
+	while (isspace(*p))
+		p++;
+	if (*p != '\0')
+		strcat(n, p);
+	else
+		strchop(n);
 
 out:
 	free(*f);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

