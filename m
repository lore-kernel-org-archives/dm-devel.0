Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1374AC10F1B
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 23:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670974587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aSI5Tr+NF23dhfwl8kfx2XQAWQwQPDRMwto6QgMMR4I=;
	b=Fa2vYdovzIV1SiYfCDeOJBt9mIAsCS0BdmKyWzYaAVwuO2Po6nb6cvcUI1lnZotLoN6lQp
	cdoM/lx1rmDBx8G9qb/zyi3mz/f9yiVzVU24oh/WpZYMDnex/EiNdwFtIScUrutneHlso2
	/sOlQw0ik2vPutFsFxfaDygLFdhTsXQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-9HrBU5eqO46318K6osBSGg-1; Tue, 13 Dec 2022 18:36:23 -0500
X-MC-Unique: 9HrBU5eqO46318K6osBSGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22D43877CA9;
	Tue, 13 Dec 2022 23:36:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B8B3F2026D68;
	Tue, 13 Dec 2022 23:36:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8839219465B3;
	Tue, 13 Dec 2022 23:36:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D47B1946A43
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 23:36:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CCEBE14171B7; Tue, 13 Dec 2022 23:36:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B559314171B6;
 Tue, 13 Dec 2022 23:36:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BDNaAir008048;
 Tue, 13 Dec 2022 17:36:10 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BDNa9f4008046;
 Tue, 13 Dec 2022 17:36:09 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 13 Dec 2022 17:36:05 -0600
Message-Id: <1670974567-8005-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
References: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 1/3] libmpathutil: simplify set_value
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

alloc_strvec() will never create a strvec with multiple tokens between
the quote tokens.  Verify this in validate_config_strvec(), and simplify
set_value() by only reading one value after a quote token.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/parser.c | 64 ++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 43 deletions(-)

diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index 8d3ac53a..ac4eb1fd 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -333,59 +333,33 @@ void *
 set_value(vector strvec)
 {
 	char *str = VECTOR_SLOT(strvec, 1);
-	size_t size;
-	int i = 0;
-	int len = 0;
 	char *alloc = NULL;
-	char *tmp;
 
 	if (!str) {
 		condlog(0, "option '%s' missing value",
 			(char *)VECTOR_SLOT(strvec, 0));
 		return NULL;
 	}
-	if (!is_quote(str)) {
-		size = strlen(str);
-		if (size == 0) {
-			condlog(0, "option '%s' has empty value",
-				(char *)VECTOR_SLOT(strvec, 0));
-			return NULL;
-		}
-		alloc = calloc(1, sizeof (char) * (size + 1));
-		if (alloc)
-			memcpy(alloc, str, size);
-		else
-			goto oom;
-		return alloc;
-	}
-	/* Even empty quotes counts as a value (An empty string) */
-	alloc = (char *)calloc(1, sizeof (char));
-	if (!alloc)
-		goto oom;
-	for (i = 2; i < VECTOR_SIZE(strvec); i++) {
-		str = VECTOR_SLOT(strvec, i);
-		if (!str) {
-			free(alloc);
-			condlog(0, "parse error for option '%s'",
-				(char *)VECTOR_SLOT(strvec, 0));
-			return NULL;
+	if (is_quote(str)) {
+		if (VECTOR_SIZE(strvec) > 2) {
+			str = VECTOR_SLOT(strvec, 2);
+			if (!str) {
+				condlog(0, "parse error for option '%s'",
+					(char *)VECTOR_SLOT(strvec, 0));
+				return NULL;
+			}
 		}
-		if (is_quote(str))
-			break;
-		tmp = alloc;
-		/* The first +1 is for the NULL byte. The rest are for the
-		 * spaces between words */
-		len += strlen(str) + 1;
-		alloc = realloc(alloc, sizeof (char) * len);
-		if (!alloc) {
-			free(tmp);
-			goto oom;
+		/* Even empty quotes counts as a value (An empty string) */
+		if (is_quote(str)) {
+			alloc = (char *)calloc(1, sizeof (char));
+			if (!alloc)
+				goto oom;
+			return alloc;
 		}
-		if (*alloc != '\0')
-			strncat(alloc, " ", len - strlen(alloc));
-		strncat(alloc, str, len - strlen(alloc) - 1);
 	}
-	return alloc;
+	alloc = strdup(str);
+	if (alloc)
+		return alloc;
 oom:
 	condlog(0, "can't allocate memory for option '%s'",
 		(char *)VECTOR_SLOT(strvec, 0));
@@ -496,6 +470,10 @@ validate_config_strvec(vector strvec, const char *file)
 			if (VECTOR_SIZE(strvec) > i + 1)
 				condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, (i + 1)), line_nr, file);
 			return 0;
+		} else if (i > 3) {
+			/* There should only ever be one token between quotes */
+			condlog(0, "parsing error starting with '%s' on line %d of %s", str, line_nr, file);
+			return -1;
 		}
 	}
 	condlog(0, "missing closing quotes on line %d of %s",
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

