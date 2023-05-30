Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2914FC7EE39
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ghhkiJzSzjCP1N0T1Q/FQ80KLvUxlw1aIDaKLCJGC7w=;
	b=SJXaj5Ueodx/KST3ug9n2TsFAnidAfYxu6/kaGkFf0LxxCUgGCB+8qe7F0hoeYlCvSB71A
	F27lx5ln0/r58BrJtKO7s4d2huOJU6IfcIWpzm1vAC5G/7FgsSpH73UVSHr6AvNzHT8EvO
	hYYGdPF05ZS8tMGt5F9hpCoWoQVJ8w0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-eHhJN0ezO2OhVjLHBErSmg-1; Tue, 30 May 2023 16:54:48 -0400
X-MC-Unique: eHhJN0ezO2OhVjLHBErSmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29AF7100F66D;
	Tue, 30 May 2023 20:54:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 150CC112132D;
	Tue, 30 May 2023 20:54:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A8A65194F4B4;
	Tue, 30 May 2023 20:54:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8071E19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63A69492B0C; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C2AF492B0B
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3786329324BD
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-qCZ_Yv64N-CwFBltE0TIDg-1; Tue, 30 May 2023 16:40:53 -0400
X-MC-Unique: qCZ_Yv64N-CwFBltE0TIDg-1
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
 by mailout.west.internal (Postfix) with ESMTP id E7B28320091C;
 Tue, 30 May 2023 16:31:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute3.internal (MEProxy); Tue, 30 May 2023 16:31:49 -0400
X-ME-Sender: <xms:NF12ZPsxzLb6qiNMX1P2rmKAhz4tbssdhxqb5b2W4EpVXzuVeLIYuA>
 <xme:NF12ZAfmMk9oJ8u-mhK6Ui9Ulx5bvQ75B1qWdW7mwmhy1E8VWdhGqMqT5i45iBhrL
 5_Kp9tH1jr-geA>
X-ME-Received: <xmr:NF12ZCyTKoszpzg74E1caX7SPMUAsM7ZbJgaQdN_fT3vsPw-0CdsBuS4E3sGSm5CMXcpcrCEQj8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudegkecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedune
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:NF12ZOOdzZrmzTTxQPerP2vAcrpzO6xwvMZsOM5HHfWIHjdkHwKsOw>
 <xmx:NF12ZP_v7UgW9QNz5GrWbg7QsOI10Y-VgTtA-VukT93FIMsnJVueuQ>
 <xmx:NF12ZOXl6LQXxBP_VPj-MHje4cHa370IULNKDufIrLuGd68vCXJiiw>
 <xmx:NF12ZLSelBIStPRHT1mOrFfztO0x3Inl8EpbIXnSumWL1iS8_dkzOg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:31:47 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:05 -0400
Message-Id: <20230530203116.2008-6-demi@invisiblethingslab.com>
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
Subject: [dm-devel] [PATCH v2 05/16] device-mapper: Target parameters must
 not overlap next target spec
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

The NUL terminator for each target parameter string must preceed the
following 'struct dm_target_spec'.  Otherwise, dm_split_args() might
corrupt this struct.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
---
 drivers/md/dm-ioctl.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 9f505abba3dc22bffc6acb335c0bf29fec288fd5..491ef55b9e8662c3b02a2162b8c93ee086c078a1 100644
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
@@ -1423,7 +1423,7 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
 	*spec = (struct dm_target_spec *) ((unsigned char *) last + next);
 	*target_params = (char *) (*spec + 1);
 
-	return invalid_str(*target_params, end);
+	return 0;
 }
 
 static int populate_table(struct dm_table *table,
@@ -1433,24 +1433,21 @@ static int populate_table(struct dm_table *table,
 	unsigned int i = 0;
 	struct dm_target_spec *spec = (struct dm_target_spec *) param;
 	uint32_t next = param->data_start;
-	void *end = (void *) param + param_size;
+	const char *const end = (const char *) param + param_size;
 	char *target_params;
+	size_t min_size = sizeof(struct dm_ioctl);
 
 	if (!param->target_count) {
 		DMERR("%s: no targets specified", __func__);
 		return -EINVAL;
 	}
 
-	if (next < sizeof(struct dm_ioctl)) {
-		DMERR("%s: first target spec (offset %u) overlaps 'struct dm_ioctl'",
-		      __func__, next);
-		return -EINVAL;
-	}
-
 	for (i = 0; i < param->target_count; i++) {
-		if (next < sizeof(*spec)) {
-			DMERR("%s: next target spec (offset %u) overlaps 'struct dm_target_spec'",
-			      __func__, next);
+		const char *nul_terminator;
+
+		if (next < min_size) {
+			DMERR("%s: next target spec (offset %u) overlaps %s",
+			      __func__, next, i ? "previous target" : "'struct dm_ioctl'");
 			return -EINVAL;
 		}
 
@@ -1460,6 +1457,15 @@ static int populate_table(struct dm_table *table,
 			return r;
 		}
 
+		nul_terminator = memchr(target_params, 0, (size_t)(end - target_params));
+		if (nul_terminator == NULL) {
+			DMERR("%s: target parameters not NUL-terminated", __func__);
+			return -EINVAL;
+		}
+
+		/* Add 1 for NUL terminator */
+		min_size = (nul_terminator - (const char *)spec) + 1;
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

