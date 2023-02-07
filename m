Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B004C64EC4
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 07:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675756573;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yjb9/d8yan1/pbHSccYWlx9KF+mq+3DKxi5QeQiWTLY=;
	b=G+IOIzXTnqOpVWiaeF0BdbnJe5LEUnRaVuI+Wtm/8pv+sJEJ8tauZnNLnEuBfm3su69yrX
	ALW6ECnvy+pKWyLgn/67+zz8CRpmpc0ZfsFsbUSQaAjeDmInQBixUGoRzQgnsCEUI8kMxc
	wnsXepZlyuoulsS9FfGbbYGUzNUL/TQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-Z8KTG83HPYuz8fqlZuQJ6g-1; Tue, 07 Feb 2023 02:56:11 -0500
X-MC-Unique: Z8KTG83HPYuz8fqlZuQJ6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F16733C0E45A;
	Tue,  7 Feb 2023 07:56:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64B4118EC5;
	Tue,  7 Feb 2023 07:56:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C43219465B8;
	Tue,  7 Feb 2023 07:56:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 588AF1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 01:19:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA648140EBF6; Tue,  7 Feb 2023 01:19:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B22F91400AFC
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 01:19:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95B751869B6C
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 01:19:08 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-322-QlYlNpyIOLeeSfAULJqOEg-1; Mon, 06 Feb 2023 20:19:06 -0500
X-MC-Unique: QlYlNpyIOLeeSfAULJqOEg-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.west.internal (Postfix) with ESMTP id 0D99332008FD;
 Mon,  6 Feb 2023 20:19:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
 by compute2.internal (MEProxy); Mon, 06 Feb 2023 20:19:05 -0500
X-ME-Sender: <xms:CKfhY5ZvTjLwfiybMAqx2xh49i_HCyry6qI8tI0G5F5DMlQw5WMO_w>
 <xme:CKfhYwZj5B1TSoUMUmIQmuevI_xMHZxvjNb4hNgrXIc5OiaaBrxJSZedKPZlKzPqZ
 iIVH1n7JBXQpIA>
X-ME-Received: <xmr:CKfhY7_lHWBNEimbxE6iiCU8KJ3UdvmWKUqAiQ0aMAD6fBI_aiJ528E0Qy07qaEKFudDIQ2Y4FQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegjedgfedvucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgvmhhiucfo
 rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
 grsgdrtghomheqnecuggftrfgrthhtvghrnhepvdefgeekvdekgfffgeekhfeijedtffek
 hefhleehfeejueetgfelgefgtdevieelnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
 hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
 sgdrtghomh
X-ME-Proxy: <xmx:CKfhY3rYG3wiVsBDFyfuiwAWLwuYq7pH0P4KcwmBs6Z-OPFkQ9XJow>
 <xmx:CKfhY0qMFHVn6M_W2vXDDb3zi42VT6PToq0bG5xObwtVNM7n5nw9gw>
 <xmx:CKfhY9TT6FCTfP33sttJChAcWtaceJ2EQgbMVKx-jmqcKkoCkDuErA>
 <xmx:CKfhY_Vf4DiFi7KbOSfNr4J22dR2iDI2aST25ufFzZHDe7F66lDDMg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Feb 2023 20:19:03 -0500 (EST)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Mon,  6 Feb 2023 20:18:48 -0500
Message-Id: <20230207011849.1343-1-demi@invisiblethingslab.com>
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
Subject: [dm-devel] [PATCH 1/2] Fail I/O to thin pool devices
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A thin pool device currently just passes all I/O to its origin device,
but this is a footgun: the user might not realize that tools that
operate on thin pool metadata must operate on the metadata volume.  This
could have security implications.

Fix this by failing all I/O to thin pool devices.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-thin.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 64cfcf46881dc5d87d5dfdb5650ba9babd32cd31..d85fdbd782ae5426003c99a4b4bf53818cc85efa 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3405,19 +3405,14 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 static int pool_map(struct dm_target *ti, struct bio *bio)
 {
-	int r;
-	struct pool_c *pt = ti->private;
-	struct pool *pool = pt->pool;
-
 	/*
-	 * As this is a singleton target, ti->begin is always zero.
+	 * Previously, access to the pool was passed down to the origin device.
+	 * However, this turns out to be error-prone: if the user runs any of
+	 * the thin tools on the pool device, the tools could wind up parsing
+	 * potentially attacker-controlled data.  This mistake has actually
+	 * happened in practice.  Therefore, fail all I/O on the pool device.
 	 */
-	spin_lock_irq(&pool->lock);
-	bio_set_dev(bio, pt->data_dev->bdev);
-	r = DM_MAPIO_REMAPPED;
-	spin_unlock_irq(&pool->lock);
-
-	return r;
+	return -EIO;
 }
 
 static int maybe_resize_data_dev(struct dm_target *ti, bool *need_commit)
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

