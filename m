Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F51AC7EE2F
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 21:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685655072;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Rr0W1fHK0CnB10hUtCnWCHLewf/NRbXEn30QguClzI0=;
	b=WXpM3CaEIAaMgJPCzZs4co0v3/ehH8cYtMsAI5lX7pAMiaafqbCTi6CCa5a+nqvyKcZoHn
	3nghLn2yHw8R87DohBtKv/qOVpZP2pt1WmtS7c102j4vifA3/CJsnjRZHMRSjIdZI51vch
	gHVT2XiZDtH6ETPobykPRtJ8WpiMsbs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-HCIb36YPMeSR776j3kAdRg-1; Thu, 01 Jun 2023 17:31:09 -0400
X-MC-Unique: HCIb36YPMeSR776j3kAdRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4B4438149AE;
	Thu,  1 Jun 2023 21:31:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE1D140CFD08;
	Thu,  1 Jun 2023 21:31:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC42919465A2;
	Thu,  1 Jun 2023 21:31:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D9A1B194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC55B492B0B; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4C69492B0A
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 966DD293249E
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
 [66.111.4.29]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-1XiUdibGNCmzCErsuIJb0Q-1; Thu, 01 Jun 2023 17:31:02 -0400
X-MC-Unique: 1XiUdibGNCmzCErsuIJb0Q-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailout.nyi.internal (Postfix) with ESMTP id 1A4215C01BD;
 Thu,  1 Jun 2023 17:25:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute5.internal (MEProxy); Thu, 01 Jun 2023 17:25:13 -0400
X-ME-Sender: <xms:uAx5ZEorR5uh5S82mapCbkteVGxsfNfzQgPbmETHb8AQHwWR74nQFg>
 <xme:uAx5ZKoGYGpndiV7OJsVE0Z_rM5Eb_KTHVAsDXjtbRNFEd8ji0Za9Q7C3T4D6aOds
 av8EBOZ-PhKzvk>
X-ME-Received: <xmr:uAx5ZJPq9xiWmPAr5GldAXllT0ERcWFLPD1CPRs2ZWe0QR_5aTe93kCBRfK9wMZ11C13faYi7gI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeluddgudeiudcutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffvghmihcu
 ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
 hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvfeegkedvkefgffegkefhieejtdff
 keehhfelheefjeeutefgleeggfdtveeileenucevlhhushhtvghrufhiiigvpedtnecurf
 grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
 rggsrdgtohhm
X-ME-Proxy: <xmx:uAx5ZL5etlybPL6lKFpSm62GS08sCaBLNDvPNcFIsMimYQH-yWQvHQ>
 <xmx:uAx5ZD7PMKrmXTwrViJnaCY22nz3SQ_y_by29spSWbJt1Ws2Mi305A>
 <xmx:uAx5ZLiNCKOi3EbAzysfbnXdCGVOUWBYmHPTXRlvMkqceMZtcGR0eA>
 <xmx:uQx5ZDFGw3Nx3Zhgv2A7uRMy77Fynnu1decOGHWcKPeIxLOsGDzTgg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Jun 2023 17:25:12 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Thu,  1 Jun 2023 17:24:49 -0400
Message-Id: <20230601212456.1533-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 0/6] Several device-mapper fixes
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This series contains several miscellaneous fixes to input validation in
device-mapper.  The only potentially controversial commits should be the
last two, which prevent creating devices named ".", "..", or "control".
The other patches fix input validation problems that have existed since
at least the beginning of git history.

Demi Marie Obenour (6):
  device-mapper: Check that target specs are sufficiently aligned
  device-mapper: Avoid pointer arithmetic overflow
  device-mapper: structs and parameter strings must not overlap
  device-mapper: Avoid double-fetch of version
  device-mapper: Refuse to create device named "control"
  device-mapper: "." and ".." are not valid symlink names

 drivers/md/dm-ioctl.c | 75 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 12 deletions(-)

-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

