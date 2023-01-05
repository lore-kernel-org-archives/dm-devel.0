Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B921C54EBC
	for <dm-devel@archiver.kernel.org>; Thu,  5 Jan 2023 07:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672904796;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JUUYcu+NSdawMBrA1039Zo1slVWYJXG6yq0Xs2eJYDM=;
	b=JfebHLVs7x6L4HV3D0JKZjXMbKPVEHibJWWdHzYSrxQ4E5U8hGFmoqzcTPlwgbE6scY2Pw
	0aPpV4sk7r3tlyosKXjebhJld11JiD+dgfLgPdeYoOnlU7x1VNar8n/6dyF/OrDKYKYSda
	18AUbqNwq6PM0zOzCwXnFs9ow65jlV0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-Ep1AZGJZNLGc5BisGhfKEw-1; Thu, 05 Jan 2023 02:46:33 -0500
X-MC-Unique: Ep1AZGJZNLGc5BisGhfKEw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3985299E756;
	Thu,  5 Jan 2023 07:46:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9515240C2004;
	Thu,  5 Jan 2023 07:46:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6A4919465A8;
	Thu,  5 Jan 2023 07:46:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22BE91946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Jan 2023 00:45:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1130114152F6; Thu,  5 Jan 2023 00:45:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 093B8140EBF5
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 00:45:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E19213C0252F
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 00:45:04 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-HM9Z2SF_MsSEszNHoBcILw-1; Wed, 04 Jan 2023 19:45:03 -0500
X-MC-Unique: HM9Z2SF_MsSEszNHoBcILw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 405086189A;
 Thu,  5 Jan 2023 00:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8816FC43444;
 Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
 id CF0515C1C98; Wed,  4 Jan 2023 16:38:14 -0800 (PST)
From: "Paul E. McKenney" <paulmck@kernel.org>
To: rcu@vger.kernel.org
Date: Wed,  4 Jan 2023 16:38:00 -0800
Message-Id: <20230105003813.1770367-14-paulmck@kernel.org>
In-Reply-To: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 05 Jan 2023 07:46:22 +0000
Subject: [dm-devel] [PATCH rcu 14/27] drivers/md: Remove "select SRCU"
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
Cc: "Paul E. McKenney" <paulmck@kernel.org>, kernel-team@meta.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

