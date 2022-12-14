Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55665C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 14 Dec 2022 21:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671053937;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1pb4XUOvGcJEQZJtD8r27eonamHwE5o5zAVYvs1g0Es=;
	b=ZU7GKIW6UtRUvu9kGCL154o9rB58rCXUa72F5Hjkzsc+tvzLw0SstPASqQnEOEc6i8KVLm
	Z0OXu+tHc2hwfWBmEIwf7KNFEr/5RAdhs01qYOS0Kp28lqK9CR7zi42s9RFkJ1z1yHpUKl
	+mwCG0KZze6R0Q2GD7mBdlrx5k7EAZA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-WTLJW4m6Nfii-fbPAxDaEg-1; Wed, 14 Dec 2022 16:38:56 -0500
X-MC-Unique: WTLJW4m6Nfii-fbPAxDaEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27DEC280BCA4;
	Wed, 14 Dec 2022 21:38:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C208A2026D33;
	Wed, 14 Dec 2022 21:38:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 907F11946A4B;
	Wed, 14 Dec 2022 21:38:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 694BB1946A42
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Dec 2022 21:38:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A32A1400D79C; Wed, 14 Dec 2022 21:38:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E29C40BC781;
 Wed, 14 Dec 2022 21:38:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BELcORk014967;
 Wed, 14 Dec 2022 15:38:24 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BELcNHp014966;
 Wed, 14 Dec 2022 15:38:23 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 14 Dec 2022 15:38:19 -0600
Message-Id: <1671053900-14923-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671053900-14923-1-git-send-email-bmarzins@redhat.com>
References: <1671053900-14923-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH V2 2/3] libmultipath: don't leak memory on
 invalid strings
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

If set_path() or set_str_noslash() are called with a bad value, they
ignore it and continue to use the old value. But they weren't freeing
the bad value, causing a memory leak.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 97f43387..f4233882 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -130,6 +130,7 @@ set_path(vector strvec, void *ptr, const char *file, int line_nr)
 	if ((*str_ptr)[0] != '/'){
 		condlog(1, "%s line %d, %s is not an absolute path. Ignoring",
 			file, line_nr, *str_ptr);
+		free(*str_ptr);
 		*str_ptr = old_str;
 	} else
 		free(old_str);
@@ -150,6 +151,7 @@ set_str_noslash(vector strvec, void *ptr, const char *file, int line_nr)
 	if (strchr(*str_ptr, '/')) {
 		condlog(1, "%s line %d, %s cannot contain a slash. Ignoring",
 			file, line_nr, *str_ptr);
+		free(*str_ptr);
 		*str_ptr = old_str;
 	} else
 		free(old_str);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

