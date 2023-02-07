Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761C7C636CC
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 07:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675756571;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/6RY6zsPVPPaIVAM2TG0K/4tljA2C5bNDOv87RzS6jg=;
	b=ckxPSWB2oWqL5PLl3aljpdg4WOSm9ur+/PEc0l9Ms5ytDr5FyHICg9zwaFJ8GPzB+dih7Z
	EEBUAr5+VJPwvDBJHQm1tGGNiYNE5l37RQQCwn1L6BlQZd2AqUQ9x/LfIRhNQ0kUI9NSPc
	iu61u07wz4QDHjr9d/XY9/du5FWTCEk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-H_Y22riBN0GRuSyL8WpqmQ-1; Tue, 07 Feb 2023 02:56:10 -0500
X-MC-Unique: H_Y22riBN0GRuSyL8WpqmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F048838123B4;
	Tue,  7 Feb 2023 07:56:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D3C1F2166B29;
	Tue,  7 Feb 2023 07:56:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF694194658C;
	Tue,  7 Feb 2023 07:56:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2169B194658C
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 01:19:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 158991410F36; Tue,  7 Feb 2023 01:19:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D186140EBF6
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 01:19:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E31A329AB3EA
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 01:19:11 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-175-GjMz28WjNG608OtH8xnGuQ-1; Mon, 06 Feb 2023 20:19:10 -0500
X-MC-Unique: GjMz28WjNG608OtH8xnGuQ-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id 8687F320090A;
 Mon,  6 Feb 2023 20:19:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
 by compute1.internal (MEProxy); Mon, 06 Feb 2023 20:19:09 -0500
X-ME-Sender: <xms:C6fhYyKANZxcwdzMoquLvp5HuQoTcGeVwKUaqM8E5AEZPSw8jKQ6xg>
 <xme:C6fhY6I2NHfR4ckPtnsr-CL3GXI6sOnhr-cGuTXJfNZaR7vLsKMKHdUawE8D3fWD3
 HX8ZT2B14m03zM>
X-ME-Received: <xmr:C6fhYysnCXuO5JruzFetT53xXoHLBa6l7hUCIT4BDNGrTaFKFtQiX4kIwl9rqAgpQC8MJQ8GXqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegjedgfedvucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:DKfhY3a7nUY7Nz07xI6dzwJM4K10twQlOZEjzxiZJ1Luq21GSj5PsA>
 <xmx:DKfhY5aZoCh8vec3etP3cW2vUJcKNbaT9Qnb0Ad01VlbFoKM4uLlYg>
 <xmx:DKfhYzDFjMFiUYy0emaKEjItM8FbrenWPGDu1_dfnqpHcLikIPROcQ>
 <xmx:DKfhY9GgNpe75Gt8IAssC4jBlJSINL72LCITTJPLqsfV1WYh2saNzw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Feb 2023 20:19:07 -0500 (EST)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Mon,  6 Feb 2023 20:18:49 -0500
Message-Id: <20230207011849.1343-2-demi@invisiblethingslab.com>
In-Reply-To: <20230207011849.1343-1-demi@invisiblethingslab.com>
References: <20230207011849.1343-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 07 Feb 2023 07:56:04 +0000
Subject: [dm-devel] [PATCH 2/2] dm-thin: Allow specifying an offset
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
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This allows exposing only part of a thin volume without having to layer
dm-linear.  One use-case is a hypervisor replacing a partition table.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-thin.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d85fdbd782ae5426003c99a4b4bf53818cc85efa..87f14933375b050a950a5f58e98c13b4d28f6af0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -357,6 +357,7 @@ struct thin_c {
 	 */
 	refcount_t refcount;
 	struct completion can_destroy;
+	u64 offset;
 };
 
 /*----------------------------------------------------------------*/
@@ -1180,9 +1181,9 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 	discard_parent = bio_alloc(NULL, 1, 0, GFP_NOIO);
 	discard_parent->bi_end_io = passdown_endio;
 	discard_parent->bi_private = m;
- 	if (m->maybe_shared)
- 		passdown_double_checking_shared_status(m, discard_parent);
- 	else {
+	if (m->maybe_shared)
+		passdown_double_checking_shared_status(m, discard_parent);
+	else {
 		struct discard_op op;
 
 		begin_discard(&op, tc, discard_parent);
@@ -4149,7 +4150,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	mutex_lock(&dm_thin_pool_table.mutex);
 
-	if (argc != 2 && argc != 3) {
+	if (argc < 2 || argc > 4) {
 		ti->error = "Invalid argument count";
 		r = -EINVAL;
 		goto out_unlock;
@@ -4168,7 +4169,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	bio_list_init(&tc->retry_on_resume_list);
 	tc->sort_bio_list = RB_ROOT;
 
-	if (argc == 3) {
+	/* Use "/" to indicate "no origin device" while providing an offset */
+	if (argc >= 3 && strcmp(argv[2], "/")) {
 		if (!strcmp(argv[0], argv[2])) {
 			ti->error = "Error setting origin device";
 			r = -EINVAL;
@@ -4196,6 +4198,23 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad_common;
 	}
 
+	tc->offset = 0;
+	if (argc > 3) {
+		sector_t sector_offset;
+
+		if (kstrtoull(argv[3], 10, &tc->offset)) {
+			ti->error = "Invalid offset";
+			r = -EINVAL;
+			goto bad_common;
+		}
+
+		if (check_add_overflow(tc->offset, ti->len, &sector_offset)) {
+			ti->error = "Offset + len overflows sector_t";
+			r = -EINVAL;
+			goto bad_common;
+		}
+	}
+
 	pool_md = dm_get_md(tc->pool_dev->bdev->bd_dev);
 	if (!pool_md) {
 		ti->error = "Couldn't get pool mapped device";
@@ -4285,8 +4304,9 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 static int thin_map(struct dm_target *ti, struct bio *bio)
 {
-	bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
+	struct thin_c *tc = ti->private;
 
+	bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector) + tc->offset;
 	return thin_bio_map(ti, bio);
 }
 
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

