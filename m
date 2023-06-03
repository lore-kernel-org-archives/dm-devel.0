Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074E5C7EE32
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685804003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fK981mmeTGCBsB5zZdKGnkAn4+eR2YDc9F7jTTUiGqU=;
	b=elhcVoqH1ZrGUXrjXeZZXHn1rhhVWgbfrfulwlVqXzPoM15IIPprD3SztipO52h59pbVnW
	zXuMSX4ij8+jW9i6yhESTeHO7hJg4jjvrTOf/9t2WLkNfLO0VXg50Iq0Xwn02akCfPwh51
	x6GQLMpL88YyEOw/i+kUy7p1IYpJv6I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-5CSbxv6lNa2eScLoHIoIQg-1; Sat, 03 Jun 2023 10:53:22 -0400
X-MC-Unique: 5CSbxv6lNa2eScLoHIoIQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F05DA85A5A8;
	Sat,  3 Jun 2023 14:53:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF33240C6EC4;
	Sat,  3 Jun 2023 14:53:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDB1419465A0;
	Sat,  3 Jun 2023 14:53:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EEBE41946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 14:53:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE9112026D6A; Sat,  3 Jun 2023 14:53:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C721A2026D49
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:19 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAADB1C05AF1
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:19 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-EzM8yoqGPJGRjzoLAIfKjg-1; Sat, 03 Jun 2023 10:53:17 -0400
X-MC-Unique: EzM8yoqGPJGRjzoLAIfKjg-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.nyi.internal (Postfix) with ESMTP id 503095C00C8;
 Sat,  3 Jun 2023 10:53:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute1.internal (MEProxy); Sat, 03 Jun 2023 10:53:17 -0400
X-ME-Sender: <xms:3VN7ZIjtvr-hGPa2eAqMGPPBk3kg81-uNdIgPs7fp1jqnHyTjgj4Hg>
 <xme:3VN7ZBBvCV_lM-ebsJpvXTDXbKa3LYrMufYXqA_Qq5FioHXC6N1TG0qwg0IwPkDwN
 QN-AF1eNhKWPdU>
X-ME-Received: <xmr:3VN7ZAEC7SpFyijRN8PCmYeHNBTy04K3zEJDn0XHNJ3ic_SG0N35QtYbbGuNgTElKjkTX16rGlM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelhedgkedvucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:3VN7ZJQshjK0OPVZRyMOvUkjEAlvzktF87-H0QbB09KdHmXGg6sWtw>
 <xmx:3VN7ZFy34bsTIjkJyP1YL7_JyTO9CUp-wBx04YlnaD85tT2hAKbiKg>
 <xmx:3VN7ZH5WjhtCzpfyFr5-AGu7p4R-itSBC6XJQDOH4CO-SmF-BWypGA>
 <xmx:3VN7ZN_N75wSI2u1kCUoeJH0pfb-_0GlDNZhJ9UYKwPA8R1ujP-npA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 3 Jun 2023 10:53:16 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 10:52:41 -0400
Message-Id: <20230603145244.1538-4-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 3/6] device-mapper: structs and parameter
 strings must not overlap
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The NUL terminator for each target parameter string must precede the
following 'struct dm_target_spec'.  Otherwise, dm_split_args() might
corrupt this struct.  Furthermore, the first 'struct dm_target_spec'
must come after the 'struct dm_ioctl', as if it overlaps too much
dm_split_args() could corrupt the 'struct dm_ioctl'.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
---
 drivers/md/dm-ioctl.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 64e8f16d344c47057de5e2d29e3d63202197dca0..da6ca26b51d0953df380582bb3a51c2ec22c27cb 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1391,7 +1391,7 @@ static inline fmode_t get_mode(struct dm_ioctl *param)
 	return mode;
 }
 
-static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
+static int next_target(struct dm_target_spec *last, uint32_t next, const char *end,
 		       struct dm_target_spec **spec, char **target_params)
 {
 	static_assert(_Alignof(struct dm_target_spec) <= 8,
@@ -1404,7 +1404,7 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
 	 * sizeof(struct dm_target_spec) or more, as otherwise *last was
 	 * out of bounds already.
 	 */
-	size_t remaining = (char *)end - (char *)last;
+	size_t remaining = end - (char *)last;
 
 	/*
 	 * There must be room for both the next target spec and the
@@ -1423,10 +1423,7 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
 	*spec = (struct dm_target_spec *) ((unsigned char *) last + next);
 	*target_params = (char *) (*spec + 1);
 
-	if (*spec < (last + 1))
-		return -EINVAL;
-
-	return invalid_str(*target_params, end);
+	return 0;
 }
 
 static int populate_table(struct dm_table *table,
@@ -1436,8 +1433,9 @@ static int populate_table(struct dm_table *table,
 	unsigned int i = 0;
 	struct dm_target_spec *spec = (struct dm_target_spec *) param;
 	uint32_t next = param->data_start;
-	void *end = (void *) param + param_size;
+	const char *const end = (const char *) param + param_size;
 	char *target_params;
+	size_t min_size = sizeof(struct dm_ioctl);
 
 	if (!param->target_count) {
 		DMERR("%s: no targets specified", __func__);
@@ -1445,6 +1443,13 @@ static int populate_table(struct dm_table *table,
 	}
 
 	for (i = 0; i < param->target_count; i++) {
+		const char *nul_terminator;
+
+		if (next < min_size) {
+			DMERR("%s: next target spec (offset %u) overlaps %s",
+			      __func__, next, i ? "previous target" : "'struct dm_ioctl'");
+			return -EINVAL;
+		}
 
 		r = next_target(spec, next, end, &spec, &target_params);
 		if (r) {
@@ -1452,6 +1457,15 @@ static int populate_table(struct dm_table *table,
 			return r;
 		}
 
+		nul_terminator = memchr(target_params, 0, (size_t)(end - target_params));
+		if (nul_terminator == NULL) {
+			DMERR("%s: target parameters not NUL-terminated", __func__);
+			return -EINVAL;
+		}
+
+		/* Add 1 for NUL terminator */
+		min_size = (size_t)(nul_terminator - (const char *)spec) + 1;
+
 		r = dm_table_add_target(table, spec->target_type,
 					(sector_t) spec->sector_start,
 					(sector_t) spec->length,
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

