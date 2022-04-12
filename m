Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65405C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 02:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649728811;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YYWR1hqMmF4oY+UrBJgTXYwWJ3+OQn4Yd1MolGHXGwE=;
	b=QTQA7dUS8VaiT6JZr9+zgsB1w44AiVO/N8qFfisnfNp9rmvJ2znMlb5xubpL30Ils33nv8
	hdhZVAV+vvePsRtvUEpFPelcxKQ9sSO3Q8P0pTJnXFCXt3vhhwyRX12U06/HUvZVN4P5wE
	L2C8UVfQSBFkFTi+6Zs1SbN86as2lJE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-oi_3XfxyN4GS2UBIVG5U-A-1; Mon, 11 Apr 2022 22:00:08 -0400
X-MC-Unique: oi_3XfxyN4GS2UBIVG5U-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54B9A805F0A;
	Tue, 12 Apr 2022 02:00:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4E2E407F78B;
	Tue, 12 Apr 2022 02:00:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E4F5194037A;
	Tue, 12 Apr 2022 02:00:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E351E1947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 02:00:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D624540E80E0; Tue, 12 Apr 2022 02:00:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C600C40E80F3;
 Tue, 12 Apr 2022 02:00:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23C201lq011832;
 Mon, 11 Apr 2022 21:00:01 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23C201IZ011831;
 Mon, 11 Apr 2022 21:00:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 11 Apr 2022 20:59:51 -0500
Message-Id: <1649728799-11790-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 1/9] libmultipath: steal the src string pointer
 in merge_str()
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of allocating a copy when the original string is going to be
freed right after the merge, just steal the pointer. Also, merge_mpe()
can't get called with NULL arguments.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index c595e768..612941b8 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -387,9 +387,9 @@ set_param_str(const char * str)
 }
 
 #define merge_str(s) \
-	if (!dst->s && src->s) { \
-		if (!(dst->s = set_param_str(src->s))) \
-			return 1; \
+	if (!dst->s && src->s && strlen(src->s)) { \
+		dst->s = src->s; \
+		src->s = NULL; \
 	}
 
 #define merge_num(s) \
@@ -397,7 +397,7 @@ set_param_str(const char * str)
 		dst->s = src->s
 
 
-static int
+static void
 merge_hwe (struct hwentry * dst, struct hwentry * src)
 {
 	char id[SCSI_VENDOR_SIZE+PATH_PRODUCT_SIZE];
@@ -449,15 +449,11 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	reconcile_features_with_options(id, &dst->features,
 					&dst->no_path_retry,
 					&dst->retain_hwhandler);
-	return 0;
 }
 
-static int
+static void
 merge_mpe(struct mpentry *dst, struct mpentry *src)
 {
-	if (!dst || !src)
-		return 1;
-
 	merge_str(alias);
 	merge_str(uid_attribute);
 	merge_str(getuid);
@@ -499,8 +495,6 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	merge_num(uid);
 	merge_num(gid);
 	merge_num(mode);
-
-	return 0;
 }
 
 void merge_mptable(vector mptable)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

