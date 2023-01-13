Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122F8C54EBE
	for <dm-devel@archiver.kernel.org>; Fri, 13 Jan 2023 08:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673596844;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2AXqiLksyWoMsxdbtiYFxKQdrCgCsImO2mS2qYvmAk8=;
	b=ZDenQQYkpvyne9Nl0plkryjAJ6K3DQKg15zJdq8K+tjzSFNa2w9svMLnEHzotiXNoRKCWe
	vxzOQ5ZQlV5hbYyw60fe0aFQTXj0xiXNBhgAIhHiZSN6PYO6J+prnkUKBFuv0secoyyFzC
	T0pzGFIz2J3uDmuraeVYD1JRF5PoJvQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-_W1CfFLYNXibECITRm39hA-1; Fri, 13 Jan 2023 03:00:43 -0500
X-MC-Unique: _W1CfFLYNXibECITRm39hA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1199485C6E1;
	Fri, 13 Jan 2023 08:00:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B61C92166B26;
	Fri, 13 Jan 2023 08:00:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9FB91947050;
	Fri, 13 Jan 2023 08:00:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C5C81946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 Jan 2023 00:18:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E8902026D76; Fri, 13 Jan 2023 00:18:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56DFA2026D68
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 00:18:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 370252807D67
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 00:18:13 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-zDh77-XlOba0wko1n4rAOQ-1; Thu, 12 Jan 2023 19:18:11 -0500
X-MC-Unique: zDh77-XlOba0wko1n4rAOQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 50102B8203B;
 Fri, 13 Jan 2023 00:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4808FC43446;
 Fri, 13 Jan 2023 00:11:35 +0000 (UTC)
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
 id A0E425C118F; Thu, 12 Jan 2023 16:11:34 -0800 (PST)
From: "Paul E. McKenney" <paulmck@kernel.org>
To: rcu@vger.kernel.org
Date: Thu, 12 Jan 2023 16:11:18 -0800
Message-Id: <20230113001132.3375334-6-paulmck@kernel.org>
In-Reply-To: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
References: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Fri, 13 Jan 2023 08:00:38 +0000
Subject: [dm-devel] [PATCH rcu v2 06/20] drivers/md: Remove "select SRCU"
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
Cc: John Ogness <john.ogness@linutronix.de>,
 "Paul E. McKenney" <paulmck@kernel.org>, kernel-team@meta.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that the SRCU Kconfig option is unconditionally selected, there is
no longer any point in selecting it.  Therefore, remove the "select SRCU"
Kconfig statements.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: <dm-devel@redhat.com>
Cc: <linux-raid@vger.kernel.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/md/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 998a5cfdbc4e9..5f1e2593fad7e 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -6,7 +6,6 @@
 menuconfig MD
 	bool "Multiple devices driver support (RAID and LVM)"
 	depends on BLOCK
-	select SRCU
 	help
 	  Support multiple physical spindles through a single logical device.
 	  Required for RAID and logical volume management.
-- 
2.31.1.189.g2e36527f23

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

