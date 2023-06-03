Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B26C7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685804003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0GydxEyIfj5trnMKR5cZKwokhDGM+brf6myNhah6VQs=;
	b=J0r0UDAEufSSjwdWPULRl+iXxTLLz3yGn76sAGzE/SFbPA2kkMasKWa/noHqqWWS2MnCOD
	MS4BD8MmKv7EaCVeY2eQr1t+/K16iyIx9j0sLg7+mSP0y98Bd51UvlVKlcfYgm3g4ZkYXG
	ktt2VINNrKHVP0+Izo2rc+1WLMPEcw0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-Wb3EH3SSPhu4o4pO_R2Fug-1; Sat, 03 Jun 2023 10:53:20 -0400
X-MC-Unique: Wb3EH3SSPhu4o4pO_R2Fug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3739685A5B5;
	Sat,  3 Jun 2023 14:53:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D81BC492B00;
	Sat,  3 Jun 2023 14:53:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8848219465A3;
	Sat,  3 Jun 2023 14:53:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 24AB61946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 14:53:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 00A27C154DA; Sat,  3 Jun 2023 14:53:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC9F0C154D7
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2FE529AA3B9
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:15 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-7xDQEJaTMtiLxlNrpGnMzA-1; Sat, 03 Jun 2023 10:53:14 -0400
X-MC-Unique: 7xDQEJaTMtiLxlNrpGnMzA-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.nyi.internal (Postfix) with ESMTP id 05CCE5C00D5;
 Sat,  3 Jun 2023 10:53:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute4.internal (MEProxy); Sat, 03 Jun 2023 10:53:14 -0400
X-ME-Sender: <xms:2VN7ZFOOnLLSMNyLKsjRpe64xNv4C7ld1fAh9C3BV--P5_bBM4otUQ>
 <xme:2VN7ZH9HASt9Rc9hMEGzW_kzKXepnp30YWZf1kO9WtKvPTqTjXv5NhSJkYGSRD7hg
 a0Yqm-hc5X4AVY>
X-ME-Received: <xmr:2VN7ZETjO3jSzOnsD7iG4cQuZP7Ywu6sDDveNM4Ikww850NU-fG25jr5MXeFW3KVywvz5u9EY7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelhedgkedvucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgepudenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:2VN7ZBtIQr8ab_QY7pzn9qmzRils_8B8d0AnTu7S1xcwjAVBYDLCBw>
 <xmx:2VN7ZNe5KBuMTfqM1xxpC7q-CKAEFwowwLos69plGuNf7DHCuY6Pqw>
 <xmx:2VN7ZN3maGw4XPSuYZKLMM_p98HZ5GDfJT9zMTF86Sj8fRdDy5ZF7A>
 <xmx:2lN7ZB5rgqfmsT9A-XpPh30iiaFF6T0YJSxpGK4rjSbnKd6OvQVOsw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 3 Jun 2023 10:53:13 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 10:52:40 -0400
Message-Id: <20230603145244.1538-3-demi@invisiblethingslab.com>
In-Reply-To: <20230603145244.1538-1-demi@invisiblethingslab.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 2/6] device-mapper: Avoid pointer arithmetic
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

