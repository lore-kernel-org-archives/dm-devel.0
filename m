Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F64C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 21:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649970686;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sc44p9alkiIgV7gqjkNc5fO6Ge+aBqUE93Wz45etIVU=;
	b=M8UkI2KR8eJhUW1CUoVeFigOsgb627N4VmklDFt4EuMUGoCkCHowQgChWsU1NHm+6kSvpj
	J7nnjwNi1SfuerGEQ4jXwm1XzPellpmhNWKJgjEugCLHu497zfg917FIxiQXQaZ3JKYY8z
	7ce9YD3w8acJ3WNTjJwVV3M7uChaQCE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-pZ7YSoeFN9agVr8OtzEOFA-1; Thu, 14 Apr 2022 17:11:22 -0400
X-MC-Unique: pZ7YSoeFN9agVr8OtzEOFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5FCD833960;
	Thu, 14 Apr 2022 21:11:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30EACC15D5C;
	Thu, 14 Apr 2022 21:11:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 970CC194034A;
	Thu, 14 Apr 2022 21:11:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A14319452D2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 21:11:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7B25C44AFE; Thu, 14 Apr 2022 21:11:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C47A4C15D5C;
 Thu, 14 Apr 2022 21:11:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23ELBBsp030173;
 Thu, 14 Apr 2022 16:11:11 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23ELBAgB030172;
 Thu, 14 Apr 2022 16:11:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 14 Apr 2022 16:11:10 -0500
Message-Id: <1649970670-30135-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH] libmultipath: use symbolic value for invalid
 pcentry
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Suggested-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 4 ++--
 libmultipath/config.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index c3cfa119..54c28d24 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -383,7 +383,7 @@ alloc_pce (void)
 {
 	struct pcentry *pce = (struct pcentry *)
 				calloc(1, sizeof(struct pcentry));
-	pce->type = -1;
+	pce->type = PCE_INVALID;
 	return pce;
 }
 
@@ -642,7 +642,7 @@ validate_pctable(struct hwentry *ovr, int idx, const char *table_desc)
 		return;
 
 	vector_foreach_slot_after(ovr->pctable, pce, idx) {
-		if (pce->type < 0) {
+		if (pce->type == PCE_INVALID) {
 			condlog(0, "protocol section in %s missing type",
 				table_desc);
 			vector_del_slot(ovr->pctable, idx--);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 4f1a18a1..45cf9b35 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -40,6 +40,7 @@ enum force_reload_types {
 	FORCE_RELOAD_WEAK,
 };
 
+#define PCE_INVALID -1
 struct pcentry {
 	int type;
 	int fast_io_fail;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

