Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15529C7EE24
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480080;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wp589mau1NZN8aA9MNGtD0REbJcZayyqVTgGP3Sdz5Y=;
	b=b4sR8aGwisfJTJryIJMXjoyQIofpydMbiOoQJ65/uts5cYOl6Z4sIvF/msv3JzqgUOG1Gt
	TzMF8z3NuTsGOdShcF6A7cVejYWaKn3Lf/guPdXdF9jlRN4/CqWwGxHB5r4O9IWXBr2QI3
	fdAd0GfRZC2OJeECNYnSSOmj3xTHNB0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-ElS6omWbN4W-HCLmCQGpRw-1; Tue, 30 May 2023 16:54:36 -0400
X-MC-Unique: ElS6omWbN4W-HCLmCQGpRw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0222F101A59B;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4CD240C6EC4;
	Tue, 30 May 2023 20:54:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9BBB419465BA;
	Tue, 30 May 2023 20:54:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADA951946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:41:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A00F72166B26; Tue, 30 May 2023 20:41:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 967D72166B28
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:41:14 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C572E3C13500
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:41:11 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-HUcQe95uNJCidSjay2RruQ-1; Tue, 30 May 2023 16:40:58 -0400
X-MC-Unique: HUcQe95uNJCidSjay2RruQ-1
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
 by mailout.west.internal (Postfix) with ESMTP id C38563200948;
 Tue, 30 May 2023 16:32:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute6.internal (MEProxy); Tue, 30 May 2023 16:32:07 -0400
X-ME-Sender: <xms:Rl12ZAr9aQWa_Qa0egkowH06KsJYmTHtkA-E1EAvwWLgM4WfnS7R1g>
 <xme:Rl12ZGrVpcCLx1UYJ8LeUhOzmhkSxM377BSRfIN9X1kgXYCC6gHdAwLxOekWNQZTl
 c4d2H3hYG3E9y8>
X-ME-Received: <xmr:Rl12ZFNycaVfEeQsS-3kpUA_-kT_bOrYQs8Q2OKWHBCjqSMutY820oVAFcuLdy_7KWZED9wrev0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedune
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:Rl12ZH6rawH_UPbQ1nJIN6Dg0_P60CEXYxgPhsCW7h8JmvVTYQOPbQ>
 <xmx:Rl12ZP78Vu93ETjN9w0f_BXL5M3BXAMEytqXeh_gjRJWPTkdz6CIeA>
 <xmx:Rl12ZHiIZA4a_gkn5vv5uueUjEU59j_7sw1bIyolyLBtoEN5Hzqz5Q>
 <xmx:Rl12ZCaON5yso2NsQujWogpPIv60NqpRS9-gP5P329739DVJCRA63A>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:32:05 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:11 -0400
Message-Id: <20230530203116.2008-12-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-1-demi@invisiblethingslab.com>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 11/16] device-mapper: "." and ".." are not
 valid symlink names
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Using either of these is going to greatly confuse userspace, as they are
not valid symlink names and so creating the usual /dev/mapper/NAME
symlink will not be possible.  As creating a device with either of these
names is almost certainly a userspace bug, just error out.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 9ae00e3c1a72c19575814cf473774835b364320b..17ece816d490b6c40d019da131ade44c9a201dab 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -775,8 +775,10 @@ static int check_name(const char *name)
 		return -EINVAL;
 	}
 
-	if (strcmp(name, DM_CONTROL_NODE) == 0) {
-		DMERR("device name cannot be \"%s\"", DM_CONTROL_NODE);
+	if (strcmp(name, DM_CONTROL_NODE) == 0 ||
+	    strcmp(name, ".") == 0 ||
+	    strcmp(name, "..") == 0) {
+		DMERR("device name cannot be \"%s\", \".\", or \"..\"", DM_CONTROL_NODE);
 		return -EINVAL;
 	}
 
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

