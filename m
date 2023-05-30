Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D9BC7EE33
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480085;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5+xQ968vJVLVljDBkUDamOsrI0vZOoDXpt0Ds2iK1nU=;
	b=FTXXA5dWSssp27K5FCZeGJ0kO/U99hUHW4YU7TD/ZShV76W3oEoYzpfNWjTYx+1hlmSx7Q
	Shkz/1SCtDJgCM37dbVfDkKv6kqyIio63+oF3Fwnn02CAz95g6DPdU9RpxabHdaPcECRsx
	/wGMC6ukR3vaUjAkV5MhLi3COzYHPo0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-khp9BxItO5Wdi7JDIMF_mw-1; Tue, 30 May 2023 16:54:43 -0400
X-MC-Unique: khp9BxItO5Wdi7JDIMF_mw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CF74803902;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C9C7492B00;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0803194F24F;
	Tue, 30 May 2023 20:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 859C119465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 593BF492B0B; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5167B492B0A
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 317FF2932498
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-M5yP5hoZO0ychrkyf_mK3g-1; Tue, 30 May 2023 16:40:53 -0400
X-MC-Unique: M5yP5hoZO0ychrkyf_mK3g-1
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
 by mailout.west.internal (Postfix) with ESMTP id 07F803200914;
 Tue, 30 May 2023 16:31:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute3.internal (MEProxy); Tue, 30 May 2023 16:31:43 -0400
X-ME-Sender: <xms:Ll12ZG3ypkz4lUPkIh0DuuQJncBHG735YKqtwU_ktkPdRq3r_9RvgA>
 <xme:Ll12ZJFCVeuAe8Vsr8iAvdOZolH1VlPf7VqJi3_telOOU7kNKuGYsc6DpT14VVJ1H
 FGXcz41JK2iJiQ>
X-ME-Received: <xmr:Ll12ZO71J-CEsAY4_Mr_pTBBQiwUFmjqPIVJ-vTjQf3Y3pRLiM1GadCnVubwZ2flnJFCr-gRBvM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudegkecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:Ll12ZH32Qri6hjgGiJ0FllRPCLo39f-5qy7T3uCDJ8LU5VX4h79TIg>
 <xmx:Ll12ZJEFd3tCtAnkRbIsBqGjfGNkEmSNFU7LjPpUMlqH7CTGrgKV0Q>
 <xmx:Ll12ZA9BQOHMzZIe_5G8lnEVFKz0d1wcyoVCA08ic3b5UkqDI5J22w>
 <xmx:Ll12ZPY1mCG9yLlRFWakggEPeJhZj6eEHLmC5CNrACfoZ9SfSMTPtg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:31:41 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:03 -0400
Message-Id: <20230530203116.2008-4-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 03/16] device-mapper: do not allow targets to
 overlap 'struct dm_ioctl'
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
Cc: =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Demi Marie Obenour <demi@invisiblethingslab.com>,
 xen-devel@lists.xenproject.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This prevents dm_split_args() from corrupting this struct.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
---
 drivers/md/dm-ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 64e8f16d344c47057de5e2d29e3d63202197dca0..a1d5fe64e1d0d9d3dcb06924249b89fe661944ab 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1444,6 +1444,12 @@ static int populate_table(struct dm_table *table,
 		return -EINVAL;
 	}
 
+	if (next < sizeof(struct dm_ioctl)) {
+		DMERR("%s: first target spec (offset %u) overlaps 'struct dm_ioctl'",
+		      __func__, next);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < param->target_count; i++) {
 
 		r = next_target(spec, next, end, &spec, &target_params);
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

