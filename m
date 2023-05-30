Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB866C7EE2F
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480092;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KI3CEgfRFH6yoO/+/WXpbPzpwAT6EB6TjhxxDw99epM=;
	b=EmK3M2raKACyFArNbG4UJgbh3CHo8DGZSLqKr1tVb9wPfpC8L3+hQlKmKr8s4ynOF6qud3
	08ihp4LXKU3YJAPReKp5iKth7Q3mWUUnnvxjdbaQnzcLSXECsUwo6ZuOyIeV/AQaNwEdbz
	gk8xpgpqNAEL6e9zFt7cjrs6aUAs99U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-afFAyTI6MuORu0Qz1nj97g-1; Tue, 30 May 2023 16:54:51 -0400
X-MC-Unique: afFAyTI6MuORu0Qz1nj97g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2513280BCA7;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D8612023273;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D74C119451E2;
	Tue, 30 May 2023 20:54:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFF3419465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C4394400DFF; Tue, 30 May 2023 20:40:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB8B2492B00
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B5821C0150D
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:54 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-nFevvtGoM4WIzgRzcDcf7w-1; Tue, 30 May 2023 16:40:52 -0400
X-MC-Unique: nFevvtGoM4WIzgRzcDcf7w-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.west.internal (Postfix) with ESMTP id F2B183200930;
 Tue, 30 May 2023 16:32:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute2.internal (MEProxy); Tue, 30 May 2023 16:32:04 -0400
X-ME-Sender: <xms:Q112ZMJhVikC1UrX3Mb_HLcgL_u4cRjw7_2N3_37WA8f1GdiBc0pnw>
 <xme:Q112ZMIHatiw5Vza07l_H3J8Q5Jo6SiJ0JklzDq2oVq19WcxL7-SLcq2Z6xIGOn9e
 WudhjdY1xw9uGw>
X-ME-Received: <xmr:Q112ZMvxVcJBiasn5UFXjTImzNzJJWI7pNevtYfQQmMTBB-b8IybX_PYolTn_jMKlOzP0fkNc-E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:Q112ZJbB2ysOiize_ujypULuG_R3Cn4Yq-9hscSDMSK5ll_YW10Haw>
 <xmx:Q112ZDb1CeOkQsN1ioyuZQeKryd91axJ67ADAgGmg8uxAd6cVc2vzw>
 <xmx:Q112ZFCIOgBVdd0gvdQPehRl4EuciVdHt2_LQ9qvpSUR9DQCv8tXpQ>
 <xmx:Q112ZH4GTf0whc09NpBt8a1c0iKBwD4CvlewH7ytbqUM7jnZPa7ciw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:32:02 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:10 -0400
Message-Id: <20230530203116.2008-11-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 10/16] device-mapper: Refuse to create device
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
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
index 52aa5505d23b2f3d9c0faf6e8a91b74cd7845581..9ae00e3c1a72c19575814cf473774835b364320b 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -771,7 +771,12 @@ static int get_target_version(struct file *filp, struct dm_ioctl *param, size_t
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

