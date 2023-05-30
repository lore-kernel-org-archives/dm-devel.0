Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7383C77B73
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480087;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0GydxEyIfj5trnMKR5cZKwokhDGM+brf6myNhah6VQs=;
	b=d4Wk9dnRT6MUj/MHrg3LaNrvaEV/sBXO49zr1s6z98GMmmZj7BROmxk3aUqdqWtxveYc0e
	CLC3QYknSNzDkXsIEnlMtw+T6foAxhlxSHOfaXb0GTffmhRq1o9vmwUFpq+O6LXhLqen8g
	NK/8+R3+fXm/nidRzpxjSPDQ6R1tNU8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-1dCD8ISsMQqVjAmAPqxbrg-1; Tue, 30 May 2023 16:54:46 -0400
X-MC-Unique: 1dCD8ISsMQqVjAmAPqxbrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B29F71022F0A;
	Tue, 30 May 2023 20:54:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98D96112132E;
	Tue, 30 May 2023 20:54:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 45B96194E01A;
	Tue, 30 May 2023 20:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 822251946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:41:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 722E720296C6; Tue, 30 May 2023 20:41:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ABE8200AE6F
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:41:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F59D800B35
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:41:04 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-z07MPZY_PA-hrDf0P6Xm1A-1; Tue, 30 May 2023 16:40:55 -0400
X-MC-Unique: z07MPZY_PA-hrDf0P6Xm1A-1
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
 by mailout.west.internal (Postfix) with ESMTP id 26C5032005C1;
 Tue, 30 May 2023 16:31:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute6.internal (MEProxy); Tue, 30 May 2023 16:31:40 -0400
X-ME-Sender: <xms:K112ZNLdk7wSJASVb91a04jG4oflO_XcOFaiSvkBTykdbHCVNggo6w>
 <xme:K112ZJI6zgUEzXAHeDV5KaRENmzmZJKK0SSdpBSaQmgoSdJ5yLXrxeq7Hsavz2EHD
 3MPAtXfus4r32E>
X-ME-Received: <xmr:K112ZFt0ZlOK8gkZQh9dbasyotJ1vU7m9y9SUbnCFXx7UUbjsnujiJQOQn0pH30DleIzc3IrecY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:K112ZOa48AE4ZVOlNQI--xrDOF3nPXzQfahOf1ELK_GIz23fXPAnHA>
 <xmx:K112ZEYi6T0TChdOca6-6colnmqEJiG9Bi3CTwZBPyClLrhgw-QmZw>
 <xmx:K112ZCAYfZ5lmE6T25N3tVSR69c_BbGJ6sC2B9IpBSRuupCOGSXAdQ>
 <xmx:K112ZKMp1wowIzo5DcMQ7w40nQAFGFn6_yoXvmSQVFYk44IdGB8nAA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:31:38 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:02 -0400
Message-Id: <20230530203116.2008-3-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 02/16] device-mapper: Avoid pointer arithmetic
 overflow
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Especially on 32-bit systems, it is possible for the pointer arithmetic
to overflow and cause a userspace pointer to be dereferenced in the
kernel.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
---
 drivers/md/dm-ioctl.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 34fa74c6a70db8aa67aaba3f6a2fc4f38ef736bc..64e8f16d344c47057de5e2d29e3d63202197dca0 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1396,6 +1396,25 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
 {
 	static_assert(_Alignof(struct dm_target_spec) <= 8,
 		      "struct dm_target_spec has excessive alignment requirements");
+	static_assert(offsetof(struct dm_ioctl, data) >= sizeof(struct dm_target_spec),
+		      "struct dm_target_spec too big");
+
+	/*
+	 * Number of bytes remaining, starting with last. This is always
+	 * sizeof(struct dm_target_spec) or more, as otherwise *last was
+	 * out of bounds already.
+	 */
+	size_t remaining = (char *)end - (char *)last;
+
+	/*
+	 * There must be room for both the next target spec and the
+	 * NUL-terminator of the target itself.
+	 */
+	if (remaining - sizeof(struct dm_target_spec) <= next) {
+		DMERR("Target spec extends beyond end of parameters");
+		return -EINVAL;
+	}
+
 	if (next % 8) {
 		DMERR("Next target spec (offset %u) is not 8-byte aligned", next);
 		return -EINVAL;
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

