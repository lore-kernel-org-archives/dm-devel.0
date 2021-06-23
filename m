Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414CBC2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C46F361C61
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C46F361C61
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cdjrlc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-7lp3pPMfPbGW6E8uW7zSBw-1; Mon, 28 Jun 2021 05:53:00 -0400
X-MC-Unique: 7lp3pPMfPbGW6E8uW7zSBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FBDC100C677;
	Mon, 28 Jun 2021 09:52:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 372BC60939;
	Mon, 28 Jun 2021 09:52:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D4FA24EA3B;
	Mon, 28 Jun 2021 09:52:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15N8SLwE012017 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Jun 2021 04:28:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2473F2068FF2; Wed, 23 Jun 2021 08:28:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FA6C2064010
	for <dm-devel@redhat.com>; Wed, 23 Jun 2021 08:28:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8CFC89B846
	for <dm-devel@redhat.com>; Wed, 23 Jun 2021 08:28:18 +0000 (UTC)
Received: from qq.com (smtpbg466.qq.com [59.36.132.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-26-qeDp6P9RP46VVW9EfpaYJg-1;
	Wed, 23 Jun 2021 04:28:14 -0400
X-MC-Unique: qeDp6P9RP46VVW9EfpaYJg-1
X-QQ-mid: bizesmtp31t1624436797tolcrdaa
Received: from localhost.localdomain (unknown [182.148.13.245])
	by esmtp6.qq.com (ESMTP) with 
	id ; Wed, 23 Jun 2021 16:25:56 +0800 (CST)
X-QQ-SSF: 01000000002000309000000A0000000
X-QQ-FEAT: EE7k6qQxgn5WkcR/sbrXX46dywf/LWEnI8NacT70mktsh5kXbHTXUJYNp+dao
	JYUFgHuS87Fh/nqJuriZGljdDqpAgoYoDY7Mq293GMYMo4tR5eefDAIc8MfY7SGgtyJcpXf
	36T2anvtNy+qOLGTOUDL9rseKFS05u70oOcmb+NLkung7ZftsmnlRfIgKTNbJHijyU6SMMg
	YsASavA08PX5q8vlTaytrdIo4Cos8wSXf5U1QUqGSI9i5qgkDXruRhc4FPMFpfCwTQp86M6
	M8HLfZqRixgZx9sbNuodDx4jejjUIpY+E5I9UOLB+QViSyJ1OKAU7WsNh7Bl3JKY6RgQ==
X-QQ-GoodBg: 0
From: Jinchao Wang <wjc@cdjrlc.com>
To: agk@redhat.com, snitzer@redhat.com
Date: Wed, 23 Jun 2021 16:25:49 +0800
Message-Id: <20210623082549.17187-1-wjc@cdjrlc.com>
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgforeign:qybgforeign6
X-QQ-Bgrelay: 1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: dm-devel@redhat.com, wjc@cdjrlc.com, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm: moved EXPORT_SYMBOL so that it immediately
	followed its function/variable
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

change made to resolve following checkpatch message:
  WARNING: EXPORT_SYMBOL(foo); should immediately follow its
function/variable

Signed-off-by: Jinchao Wang <wjc@cdjrlc.com>
---
 drivers/md/dm-path-selector.c | 3 +--
 drivers/md/dm-target.c        | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-path-selector.c b/drivers/md/dm-path-selector.c
index fa0ccc585cb4..e2d3d6c7dbb3 100644
--- a/drivers/md/dm-path-selector.c
+++ b/drivers/md/dm-path-selector.c
@@ -114,6 +114,7 @@ int dm_register_path_selector(struct path_selector_type *pst)
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(dm_register_path_selector);
 
 int dm_unregister_path_selector(struct path_selector_type *pst)
 {
@@ -135,6 +136,4 @@ int dm_unregister_path_selector(struct path_selector_type *pst)
 
 	return 0;
 }
-
-EXPORT_SYMBOL_GPL(dm_register_path_selector);
 EXPORT_SYMBOL_GPL(dm_unregister_path_selector);
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 64dd0b34fcf4..493a263a8826 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -91,6 +91,7 @@ int dm_register_target(struct target_type *tt)
 	up_write(&_lock);
 	return rv;
 }
+EXPORT_SYMBOL(dm_register_target);
 
 void dm_unregister_target(struct target_type *tt)
 {
@@ -104,6 +105,7 @@ void dm_unregister_target(struct target_type *tt)
 
 	up_write(&_lock);
 }
+EXPORT_SYMBOL(dm_unregister_target);
 
 /*
  * io-err: always fails an io, useful for bringing
@@ -169,5 +171,3 @@ void dm_target_exit(void)
 	dm_unregister_target(&error_target);
 }
 
-EXPORT_SYMBOL(dm_register_target);
-EXPORT_SYMBOL(dm_unregister_target);
-- 
2.31.1



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

