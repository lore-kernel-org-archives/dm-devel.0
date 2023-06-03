Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AC3C77B73
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685804010;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MGFgT7ETbeookTfv40m2dpSdYQZXjeVih5ajdD6hf+g=;
	b=NyN64ktPpsx/G/nw8CLjogjGdG4hNCHmGuKpHEWYDIgRdi+3KhFGszw4f7Wrth/NmuBxPY
	r/6GCN87Hdi48zNyaNVa1jJ45I+hVKALBGppoWUDYwqPkwJEx4yUhd6oM2g2vXiTqpFVal
	1cQqsWuXKcTC+ntWx3VJ27D5h+e/IeE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-ZiLD7hvLNXaCKl6rR4PsWg-1; Sat, 03 Jun 2023 10:53:26 -0400
X-MC-Unique: ZiLD7hvLNXaCKl6rR4PsWg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 354173801ECD;
	Sat,  3 Jun 2023 14:53:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 227BF403174;
	Sat,  3 Jun 2023 14:53:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA25819465A0;
	Sat,  3 Jun 2023 14:53:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 415A719465A0
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 14:53:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24A554097562; Sat,  3 Jun 2023 14:53:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CB2B4097561
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:23 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 028BB2A59549
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:23 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-E6ah9-DuNbG8ABxEAIAJAA-1; Sat, 03 Jun 2023 10:53:20 -0400
X-MC-Unique: E6ah9-DuNbG8ABxEAIAJAA-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.nyi.internal (Postfix) with ESMTP id 441865C018B;
 Sat,  3 Jun 2023 10:53:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute4.internal (MEProxy); Sat, 03 Jun 2023 10:53:20 -0400
X-ME-Sender: <xms:4FN7ZLebUufMRlHdmQH-4Xja5B9zOnfbmNv1b5o3buYKs3ywv90X8Q>
 <xme:4FN7ZBPTvDwBIKoCJ1jvK0v6lNxtMqK5DsRE5zsCWfXX1PBU-itza3LSus6OzniRk
 um2aI35OoS7GXQ>
X-ME-Received: <xmr:4FN7ZEhJ7YhboYEMcSRCWhqWfF9Hytw2MtibaXQM33bXWY5PG42Pbg7C0EMQwprElCxVGwo0_3k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelhedgkedvucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgepfeenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:4FN7ZM9PIsDUYxbvWf3AAYDZpgoz2-l9AuC4c0yaWnoFqL5ADRbUbg>
 <xmx:4FN7ZHu5Z_OZcaMfaR2iln71X6eEHkc97BlD6QGrIHDUGqQd6sLkXA>
 <xmx:4FN7ZLEXGfxYQ2sSCXTgTDTrt2YAFKSK3sry-18XBsWM07Lfah7pGw>
 <xmx:4FN7ZA5bJL37uMKTkZBOTVKC211Onl6n47AnWxjGkgb8YS0uE3IN0Q>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 3 Jun 2023 10:53:19 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 10:52:43 -0400
Message-Id: <20230603145244.1538-6-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 5/6] device-mapper: Refuse to create device
 named "control"
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
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Typical userspace setups create a symlink under /dev/mapper with the
name of the device, but /dev/mapper/control is reserved for the control
device.  Therefore, trying to create such a device is almost certain to
be a userspace bug.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 7510afe237d979a5ee71afe87a20d49f631de1aa..5b647ab044e44b0c9d0961b5a336b41f50408f88 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -767,7 +767,12 @@ static int get_target_version(struct file *filp, struct dm_ioctl *param, size_t
 static int check_name(const char *name)
 {
 	if (strchr(name, '/')) {
-		DMERR("invalid device name");
+		DMERR("device name cannot contain '/'");
+		return -EINVAL;
+	}
+
+	if (strcmp(name, DM_CONTROL_NODE) == 0) {
+		DMERR("device name cannot be \"%s\"", DM_CONTROL_NODE);
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

