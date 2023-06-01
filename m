Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FD3C7EE32
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 21:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685655072;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qGDMANYIKAZ2Z4btJ+KgLdlKdGRh+GJG8AOyi37zRGM=;
	b=er6BIQ/+f9YZ5wgaC4NIyyBVHe273qKTIC+/xvVNnZK4H4Gub1bSNtrftySza3qq3IvVss
	0h689LBK/ShNxoFZhzHCv5cnbg7cJ/w9yqZhvqfRqr0mqjK5Dqyyy4umg6/kdguFHGxEAE
	sTo7EPAgg9qFOSOd5KmjfePh/A/Rh/A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-Twr043UwOQ2nSWWHa1KITQ-1; Thu, 01 Jun 2023 17:31:08 -0400
X-MC-Unique: Twr043UwOQ2nSWWHa1KITQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5F488030D0;
	Thu,  1 Jun 2023 21:31:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E65CE492B0C;
	Thu,  1 Jun 2023 21:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C7D019465B6;
	Thu,  1 Jun 2023 21:31:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7447194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93F5E202696C; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C8F22029F6D
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7245838149A2
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
 [66.111.4.29]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-6VtjFLt3MaGW-LqA-7V1tA-1; Thu, 01 Jun 2023 17:31:02 -0400
X-MC-Unique: 6VtjFLt3MaGW-LqA-7V1tA-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailout.nyi.internal (Postfix) with ESMTP id 1827B5C01D9;
 Thu,  1 Jun 2023 17:25:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute5.internal (MEProxy); Thu, 01 Jun 2023 17:25:24 -0400
X-ME-Sender: <xms:wwx5ZN-1nVIOm-poAfwY9drGrP90YJr5LpDKtQC7y0V1wVqOEYF2nA>
 <xme:wwx5ZBvmFjIoi_nEYkSHx4SoUgCEPCj5JjzzcatwrTOK9fa3MSU7SUicVzOfNeewF
 waFfYuhoSjT7ZE>
X-ME-Received: <xmr:wwx5ZLCTwGhQvoIACKWGpOIxAADgTa98P88Cz2-F86hbwBliEpBaJSG_lXwozkbcuhGdXiGEa_I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeluddgudeiudcutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedune
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:wwx5ZBdu0qnky4yPi8iZRFNjfK0r4M2LhhyDSGerNQOK36XFPeGGJA>
 <xmx:wwx5ZCNO-Qh9kG24AtB4r0wKEVfpVCo8avynWEOLTvq3v27efeUSKA>
 <xmx:wwx5ZDlThLHPAN4DdI1yz7fhhxtS3qwq8COBRROqtcR1yY02SWmdhw>
 <xmx:xAx5ZLbchMSSD7_LbgR_uT6c8M0LsdGIxZ-a370F4lDPGenGDUjQEA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Jun 2023 17:25:23 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Thu,  1 Jun 2023 17:24:55 -0400
Message-Id: <20230601212456.1533-7-demi@invisiblethingslab.com>
In-Reply-To: <20230601212456.1533-1-demi@invisiblethingslab.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 6/6] device-mapper: "." and ".." are not valid
 symlink names
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

Using either of these is going to greatly confuse userspace, as they are
not valid symlink names and so creating the usual /dev/mapper/NAME
symlink will not be possible.  As creating a device with either of these
names is almost certainly a userspace bug, just error out.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b12592bcb4b2b8513f5da6208fb545203534d7ff..adf0c4becc743e4ad59e1d6b0ef108ddd56f207d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -771,8 +771,10 @@ static int check_name(const char *name)
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

