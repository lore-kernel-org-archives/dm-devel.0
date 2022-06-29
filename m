Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430FBCCA482
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 22:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656543259;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KbaCzPhany6FQ2j0AbjnWGvAkETPuB3DOkN5Mi09ZEk=;
	b=NCNKUx2kv+guvBmXDtWM6103tzIW3pnPc0OiB/swBBFsb+uYjF5kyHTZKD7j1Lga8R/p2X
	phbN76TgpmfRNFvqu3rfudwZ7GfBRo0fY7fypeWWl5JHBwk4Lcb7wGaTj9OlE2enl6Mso5
	CHSE3aQ94oeBulOdqjHvaWBhOiEkfi4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-zF0_niazN3-IqADdStvNyg-1; Wed, 29 Jun 2022 18:54:16 -0400
X-MC-Unique: zF0_niazN3-IqADdStvNyg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA7BC1C01B53;
	Wed, 29 Jun 2022 22:54:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 950CC40334D;
	Wed, 29 Jun 2022 22:54:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4058F194705D;
	Wed, 29 Jun 2022 22:54:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 104BF1947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 21:55:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE67F112131B; Wed, 29 Jun 2022 21:55:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA2661121314
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF0113C025CE
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:16 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-t7JicFM9PHGuiYO9AsaJCA-1; Wed, 29 Jun 2022 17:55:15 -0400
X-MC-Unique: t7JicFM9PHGuiYO9AsaJCA-1
Received: by mail-qk1-f179.google.com with SMTP id g1so236296qkl.9
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 14:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=mgLvicxygsgFWfkkr4Nfr2kLCpJ+k85KjEN3Gw0z4Zk=;
 b=J0hJGuTPy8My3YEWHVO1StR8ZSslbvm4SHhP03BZcAtfCubIWfHdANm8C5WdRhP0np
 +9CyEqe4U979u2Cmf0Is8UOVyCxePMFPyHX1EqxJy01sVwRLk+C+4/sVKsl1CDM2LCfw
 Ys/xrO5Ip4oKbcN7d/F6UqAHhvxveEOIsphANbpi7XXKg7cd1TivIU/zoL7Q97IHYCCg
 E4v//QKjW+bgRwSHAGLw6s8YDs5Zn/3L3s44QuKTp3jYrOK4d5DvIHCBf/E69T06qtv6
 EGDb4ApSNs31DOlAo+3gvrRocWnfdm5adLNJSmwrMzx34IadHeIBk9fe/8002WOFfCgg
 AH8w==
X-Gm-Message-State: AJIora8ClZO2N6tny3Lsn87r88R/jkqT2gbYCjK+NePNSg7K9ytfzqfd
 PZouxNP1gf5N71qKp4WelRNO1Uw=
X-Google-Smtp-Source: AGRyM1uXQvQsptKSLy23DUES/xRH4SfsIle9GVnQzewwll2BBUehX9+zCu4ZlGzioPk5MgGrHAZPcQ==
X-Received: by 2002:a37:a589:0:b0:6b1:ba97:5dbf with SMTP id
 o131-20020a37a589000000b006b1ba975dbfmr1611512qke.772.1656539714605; 
 Wed, 29 Jun 2022 14:55:14 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 d8-20020ac85ac8000000b00304e70585f9sm12400080qtd.72.2022.06.29.14.55.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 14:55:14 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Date: Wed, 29 Jun 2022 17:55:10 -0400
Message-Id: <20220629215513.37860-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 5.20 v2 0/3] block/dm: add bio_rewind to improve
 DM requeue
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Kent Overstreet <kent.overstreet@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Eric Biggers <ebiggers@google.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This v2 is the by-product of my having picked up v1's patch 2+3 and
folding them (into patch 1 of this v2 series). So patch 1 of this v2
is settled and will be merged into 5.20.

Patches 2 and 3 are the result of me having gone over the v1 code. I
folded in the copy-n-paste bugfix that Eric Biggers kindly pointed out
in v1. I also updated patch headers and code comments for clarity. And
I also renamed some variables, tweaked some style knits (subjective
but whatever).

This code is available in linux-dm.git's 'dm-5.20' branch:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20
Which is based on Jens's for-5.20/block

I'll obviously rebase 'dm-5.20' ontop of Jens's branch if/when he
picks up patch 2 in this series.

This code is passing all my tests so far but testing is ongoing.

All comments welcome.

ps. I was told Kent had replied to the v1 thread while I was working
on this v2, I kept focus on finishing this v2. I'll check my email in
a bit.

Ming Lei (3):
  dm: improve BLK_STS_DM_REQUEUE and BLK_STS_AGAIN handling
  block: add bio_rewind() API
  dm: add two stage requeue mechanism

 block/bio-integrity.c       |  19 +++++
 block/bio.c                 |  20 +++++
 block/blk-crypto-internal.h |   7 ++
 block/blk-crypto.c          |  25 ++++++
 drivers/md/dm-core.h        |  11 ++-
 drivers/md/dm.c             | 189 ++++++++++++++++++++++++++++++++++----------
 include/linux/bio.h         |  21 +++++
 include/linux/bvec.h        |  33 ++++++++
 8 files changed, 281 insertions(+), 44 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

