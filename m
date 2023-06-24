Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE939EB64DA
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jun 2023 23:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687648213;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TYASGDB3IvB5f8HY3oQ0gpq06IbKEGJDgTjz0XQpAjc=;
	b=KzWmzVww59Ifq/eu2ShJQXVreUwIIoGFbDPh1F+8wgwEPDF1W5B8hKXZ4KcZmksqd3Q4er
	99ZUQylOnaX1zlBpLNpHF5C/qHutrz90RRkzkvPbcHUcXB7ThmchOThTTCnLwdWmb/Xyjo
	NLVbGutL2lwKChTlPV48b73C8E+QE+k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-1ZxigBpQMYKyVRXGsxLr_Q-1; Sat, 24 Jun 2023 19:10:10 -0400
X-MC-Unique: 1ZxigBpQMYKyVRXGsxLr_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 824752A59579;
	Sat, 24 Jun 2023 23:10:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC080F5AC5;
	Sat, 24 Jun 2023 23:10:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52D341946588;
	Sat, 24 Jun 2023 23:10:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 060881946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 24 Jun 2023 23:09:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BFC66492B03; Sat, 24 Jun 2023 23:09:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7E47492B01
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:09:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99A3438035A6
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:09:58 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-Ko7UHizAMFyIwP7SbiVBlw-1; Sat, 24 Jun 2023 19:09:56 -0400
X-MC-Unique: Ko7UHizAMFyIwP7SbiVBlw-1
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
 by mailout.west.internal (Postfix) with ESMTP id BCE7C3200065;
 Sat, 24 Jun 2023 19:09:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute6.internal (MEProxy); Sat, 24 Jun 2023 19:09:55 -0400
X-ME-Sender: <xms:wneXZOzpDMXyHB5nNGihQDlwEvm80EBrOvlC7u8oELUKq-ClfMJzsw>
 <xme:wneXZKS9LxYIa9-xfvtRxMt6OM-kuGBdL8LsQFY_EmJqoyji-fY9IxSbm0TiZhfHL
 Tv0d-eq0TN7a14>
X-ME-Received: <xmr:wneXZAVvRVlejMu023IVEBvLIgwq7HKeE6-hP_ws8zk4QswXOjZP5OiFHLzRNOeZg191CheYFpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeegkedgudekucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgvmhhiucfo
 rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
 grsgdrtghomheqnecuggftrfgrthhtvghrnhepvdefgeekvdekgfffgeekhfeijedtffek
 hefhleehfeejueetgfelgefgtdevieelnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
 hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
 sgdrtghomh
X-ME-Proxy: <xmx:wneXZEgvzlc8nVYPOhk5f79G5koevQvdF9XTFkPt7YtRffBoAVRdaQ>
 <xmx:wneXZACW6ONEW_NBXszyPtQivp26sWwGhzAyC2mvLaeoRmEytclsTA>
 <xmx:wneXZFJ6sskoNJVl1UxJa9EJPJGHvT0uE5dBj_PfNP1HaAx1Z0v7qQ>
 <xmx:wneXZDNj8EA4ceoM3u9pdPZMiVmQ9XlubqorahAvGwxnbj62_01Utw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 24 Jun 2023 19:09:53 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat, 24 Jun 2023 19:09:43 -0400
Message-ID: <20230624230950.2272-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 0/4] Diskseq support in device-mapper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This work aims to allow userspace to create and destroy device-mapper
devices in a race-free way.

Changes since v1:

- Potentially backwards-incompatible changes to device-mapper now
  require userspace opt-in.
- The code has been tested: I have a block script written in C that uses
  these changes to successfully boot a Xen VM.
- The core block layer is completely untouched.  Instead of exposing a
  block device inode directly to userspace, device-mapper ioctls that
  create a block device now return that device's diskseq.  Userspace can
  then use that diskseq to safely open the device.  Furthermore, ioctls
  that operate on an existing device-mapper device now accept a diskseq
  parameter, which can be used to prevent races.

Demi Marie Obenour (4):
  dm ioctl: Allow userspace to opt-in to strict parameter checks
  dm ioctl: Allow userspace to provide expected diskseq
  dm ioctl: Allow userspace to suppress uevent generation
  dm ioctl: inform caller about already-existing device

 drivers/md/dm-core.h          |   2 +
 drivers/md/dm-ioctl.c         | 351 ++++++++++++++++++++++++++++------
 drivers/md/dm.c               |   5 +-
 include/linux/device-mapper.h |   2 +-
 include/uapi/linux/dm-ioctl.h |  90 ++++++++-
 5 files changed, 382 insertions(+), 68 deletions(-)

-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

