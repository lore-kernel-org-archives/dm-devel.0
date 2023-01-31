Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD63DC636CC
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 19:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675193675;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XA/bxO64xsNJNyze8P4/6DgrYCQ79AlwMlwpw3YA0aQ=;
	b=QlsNsy6Z/kLBztvELeoBgvEtbfOCsA+9RXVxphbkJXtIQKnig6pP0vI2pkEainbMJxYbKE
	i/ZJe7SFp6EU3UlWCQUVQLMQRDcx14F/tWjCz0k2b9NJ9CYuVaAMRO5tpqpnA05VMC8FEe
	Bwm5VEzx3KeEEW4/jkHatNV7xC0+KSY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-x5FG7lalMpiPeQsjCO-HtA-1; Tue, 31 Jan 2023 14:34:34 -0500
X-MC-Unique: x5FG7lalMpiPeQsjCO-HtA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71D201C05AC0;
	Tue, 31 Jan 2023 19:34:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFC9F492B00;
	Tue, 31 Jan 2023 19:34:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF1011946589;
	Tue, 31 Jan 2023 19:34:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83BD51946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 19:34:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7698A2166B34; Tue, 31 Jan 2023 19:34:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6217F2166B33;
 Tue, 31 Jan 2023 19:34:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 30VJYO5t001189;
 Tue, 31 Jan 2023 13:34:24 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 30VJYNuM001188;
 Tue, 31 Jan 2023 13:34:23 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 31 Jan 2023 13:34:18 -0600
Message-Id: <1675193661-1147-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 1/4] libmultipath: use select_reload_action in
 select_action
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

Since we have a function to set the action to reload, use it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e689f8a7..050b984a 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -729,9 +729,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 
 	if (force_reload) {
 		mpp->force_udev_reload = 1;
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (forced by user)",
-			mpp->alias);
+		select_reload_action(mpp, "forced by user");
 		return;
 	}
 	if (cmpp->size != mpp->size) {
@@ -744,9 +742,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 
 	if (!is_udev_ready(cmpp) && count_active_paths(mpp) > 0) {
 		mpp->force_udev_reload = 1;
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (udev incomplete)",
-			mpp->alias);
+		select_reload_action(mpp, "udev incomplete");
 		return;
 	}
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

