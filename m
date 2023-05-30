Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C211C77B73
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hkjGCwCoK0EpEkbOn9zh08gw8pl0swYRCrfKgUJREhc=;
	b=W2EaipEja1rAq1JMuV8pn7gH2WJ8qu7DWyyNVxiOGEEmPNKwKa08XBFIHan3xZdAAydL/t
	tf0O0nGOyDPeHo+hs4XRfOs1uCksO+Q3yHin6iJrKOETjtunQaE06RqGzJXCwxsPA7wP4I
	pRmYe2I9XtwaQajnVomwjUvnL9Cts9I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-42IASqqhPlqwCXgN1CM6Gw-1; Tue, 30 May 2023 16:54:47 -0400
X-MC-Unique: 42IASqqhPlqwCXgN1CM6Gw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77C9B382C982;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65C5BC154D3;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E61DC194F257;
	Tue, 30 May 2023 20:54:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0538219465A2
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E94AE40CFD46; Tue, 30 May 2023 20:40:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1E8440CFD45
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C19048030D2
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:57 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-5eYMH6mfNiqvnb_WcCACcg-1; Tue, 30 May 2023 16:40:56 -0400
X-MC-Unique: 5eYMH6mfNiqvnb_WcCACcg-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id 210F1320093A;
 Tue, 30 May 2023 16:31:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute1.internal (MEProxy); Tue, 30 May 2023 16:31:46 -0400
X-ME-Sender: <xms:MV12ZNrs4Z9KmViO-dI3XIzBAS1TrFl0swpM5VQmw0lxIXMYMcYH8g>
 <xme:MV12ZPrQ67qj8n8Ym7JcnhoeIbBOcqe5AUzEdZaRULY3Y2ljd_av-OWHIU7FzbFEt
 QjUStib5j_KJew>
X-ME-Received: <xmr:MV12ZKPuAN6Wkyrp02gS2tS2qthWhdXqYyKQGY2nnqs8ppDaU7tay_iYZjR-1GawLtG2ma21xI8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:MV12ZI558_m5ZAeIugOGhFh509dG0GfvI0meCVPsv0GzuuTVlEP55Q>
 <xmx:MV12ZM4ZDJsH_r6GgjxCGg9stcnTa1DX0UyGw4N5CSip8_xY_eOlIw>
 <xmx:MV12ZAitJNIqv97FdHQsw70B7O5NYVmGarm35_SET05V6VqDlcbwrg>
 <xmx:MV12ZLaNM7ETgMhYzUUA-gFXBJlTSFaEx8TwyLr2GLFSH0w_bxJTiw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:31:44 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:04 -0400
Message-Id: <20230530203116.2008-5-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 04/16] device-mapper: Better error message for
 too-short target spec
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Previously the error was "unable to find target", which is not helpful.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a1d5fe64e1d0d9d3dcb06924249b89fe661944ab..9f505abba3dc22bffc6acb335c0bf29fec288fd5 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1423,9 +1423,6 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
 	*spec = (struct dm_target_spec *) ((unsigned char *) last + next);
 	*target_params = (char *) (*spec + 1);
 
-	if (*spec < (last + 1))
-		return -EINVAL;
-
 	return invalid_str(*target_params, end);
 }
 
@@ -1451,6 +1448,11 @@ static int populate_table(struct dm_table *table,
 	}
 
 	for (i = 0; i < param->target_count; i++) {
+		if (next < sizeof(*spec)) {
+			DMERR("%s: next target spec (offset %u) overlaps 'struct dm_target_spec'",
+			      __func__, next);
+			return -EINVAL;
+		}
 
 		r = next_target(spec, next, end, &spec, &target_params);
 		if (r) {
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

