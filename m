Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5498BC636CD
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675267021;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=R+CEfBxbYV6HtF156pr8TyDuh+fq/Im3Bp86TuOOzac=;
	b=Cl5tVnTDXthVCNFoXDz1n8bpLpQZ/Sa9huZCpGaTllsPYxlen6ru+acsJw7zXcLEuzztwC
	Xc1Dn7PHZpQpE1iQQ3RuHd1E1TnSf2z6UB1TCpfKZto3rcd/plJ/wB2H6nuBJtXTtVs5Rh
	xV2FE0m2EFsOGDGJdo5iuFuF8HpAg9M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-6G1O6LwuNNei8iyNS0UkLA-1; Wed, 01 Feb 2023 10:56:57 -0500
X-MC-Unique: 6G1O6LwuNNei8iyNS0UkLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 516172803623;
	Wed,  1 Feb 2023 15:56:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 775542026D68;
	Wed,  1 Feb 2023 15:56:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4CEA619465B1;
	Wed,  1 Feb 2023 15:56:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 284C4194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 15:56:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90394422AE; Wed,  1 Feb 2023 15:56:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7502453A0;
 Wed,  1 Feb 2023 15:56:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 311FuXq6008327;
 Wed, 1 Feb 2023 09:56:33 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 311FuW9U008326;
 Wed, 1 Feb 2023 09:56:32 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  1 Feb 2023 09:56:27 -0600
Message-Id: <1675266989-8281-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675266989-8281-1-git-send-email-bmarzins@redhat.com>
References: <1675266989-8281-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 2/4] libmultipath: select resize action even
 if reload is forced
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

The ACT_RESIZE action is the same as the ACT_RELOAD action, except that
it flushes outstanding IO because the device size is changing and
the new size might be too small for some of the outstanding IO. If we've
detected a size change, and a forced reload is requested, we still need
to flush the IO because the reload will change the device size.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 050b984a..6811e661 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -727,11 +727,6 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		return;
 	}
 
-	if (force_reload) {
-		mpp->force_udev_reload = 1;
-		select_reload_action(mpp, "forced by user");
-		return;
-	}
 	if (cmpp->size != mpp->size) {
 		mpp->force_udev_reload = 1;
 		mpp->action = ACT_RESIZE;
@@ -740,6 +735,12 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		return;
 	}
 
+	if (force_reload) {
+		mpp->force_udev_reload = 1;
+		select_reload_action(mpp, "forced by user");
+		return;
+	}
+
 	if (!is_udev_ready(cmpp) && count_active_paths(mpp) > 0) {
 		mpp->force_udev_reload = 1;
 		select_reload_action(mpp, "udev incomplete");
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

