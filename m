Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A09C00144
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658851812;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mywIrQSG7yK0uKqlcLqGvLinE9yKo+Mp82bSOVQgOSc=;
	b=D6rnCwxU8ESvgl/SnSMpk6IhK+539bUGHq0lnmOaGs7ROXV3IIAXcIje8c0JmwNQ62sBqL
	g6r4quUgrZQNoeIDSAncJEOtxDHYHTBMCcdvv/ZY+A15E3tYLEGyTbAC6xC066BIk9qE2n
	ec578kJpNBO694XPxqBCGV+1Kvzr1Lg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484--oBjOpd5OLa5tSkpEAghQg-1; Tue, 26 Jul 2022 12:10:09 -0400
X-MC-Unique: -oBjOpd5OLa5tSkpEAghQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9060680418F;
	Tue, 26 Jul 2022 16:10:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 429AF1121314;
	Tue, 26 Jul 2022 16:10:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 203DD1945DA5;
	Tue, 26 Jul 2022 16:10:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3507B1945DA5
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 16:10:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1479818EA8; Tue, 26 Jul 2022 16:10:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F86690A11
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E856A1C13946
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:02 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-iLSKevWnPAWMdUw-DDiR7w-1; Tue, 26 Jul 2022 12:10:01 -0400
X-MC-Unique: iLSKevWnPAWMdUw-DDiR7w-1
Received: by mail-qt1-f173.google.com with SMTP id a9so10755436qtw.10
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 09:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=nWpYyFT1bHRlgyxepyMu7fOIqIgMNNMeyT+P2b7OILo=;
 b=c0KBwdJcz210TrFv8W5Zs0fU+DQr2wVaVXzQ44G2CEvFA2XL9vV2h4AbGDkJhNS65V
 uu7n5dINuayoSGDp4Nu3ftIKYoezPtB2UnaCclPH7XwRmQ39TqpbeG7CeWw1j9Jlg7x9
 /kbQWkBFOGQlqf0kpjfdFUvydEtYYRAq2OnBqWjIW6xTCskEpClaqSvjUvFuMY8A0hkS
 kC9zRtKJWRxM1+AUv2kHo+DV032Wg47qMVwQMQpYLsF1NX+NWRGMud6XAg8Tw2/4lbza
 QTVJ/RLEcxsmKo9t0sHG8jBa5Sqp7evR3Zdj5LZophfk1tjUYoDZuA/Cis5j+Wu2qACp
 um4Q==
X-Gm-Message-State: AJIora98nW7gE6mhvkn4Cst+UU7X5/h7Ni2KyEVv2CmjkCxebQxcWK1L
 eMWNYItPSKMSI3XnztuW61ojx9E=
X-Google-Smtp-Source: AGRyM1t/IbdLPSURXT0S11DdZEimIxpQJyhIazDAV3JkZ/F4I47D8BXOguMIxi+XtKNiKoKDM5JeTw==
X-Received: by 2002:a05:622a:1488:b0:31f:295d:c74b with SMTP id
 t8-20020a05622a148800b0031f295dc74bmr13331149qtx.547.1658851800730; 
 Tue, 26 Jul 2022 09:10:00 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bq11-20020a05620a468b00b006b578ff5dfasm11790470qkb.41.2022.07.26.09.09.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 09:10:00 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, Eric Biggers <ebiggers@kernel.org>
Date: Tue, 26 Jul 2022 12:09:53 -0400
Message-Id: <20220726160959.89247-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 0/6] dm verity: optionally use tasklets
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
Cc: dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Please see this updated patchset that reflects what I've staged for
the 5.20 merge window, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20

My only outstanding question, from previous v1 patchset, is: should
the verify_wq be created using WQ_HIGHPRI instead of WQ_CPU_INTENSIVE?
(I doubt it has a significant impact on performance but if you have
insight on why you made that change, and if it meaningful, I'd happily
apply the change).

I've tested using cryptsetup's testsuite (which has dm-verity tests)
but I haven't tested the "try_verify_in_tasklet" feature.

I'd welcome review and focused "try_verify_in_tasklet" testing.

Thanks,
Mike

Mike Snitzer (3):
  dm verity: allow optional args to alter primary args handling
  dm bufio: conditionally enable branching for DM_BUFIO_CLIENT_NO_SLEEP
  dm verity: conditionally enable branching for "try_verify_in_tasklet"

Nathan Huckleberry (3):
  dm bufio: Add flags argument to dm_bufio_client_create
  dm bufio: Add DM_BUFIO_CLIENT_NO_SLEEP flag
  dm verity: Add optional "try_verify_in_tasklet" feature

 drivers/md/dm-bufio.c                         |  32 ++++-
 drivers/md/dm-ebs-target.c                    |   3 +-
 drivers/md/dm-integrity.c                     |   2 +-
 drivers/md/dm-snap-persistent.c               |   2 +-
 drivers/md/dm-verity-fec.c                    |   4 +-
 drivers/md/dm-verity-target.c                 | 121 +++++++++++++++---
 drivers/md/dm-verity.h                        |   7 +-
 drivers/md/persistent-data/dm-block-manager.c |   3 +-
 include/linux/dm-bufio.h                      |   8 +-
 9 files changed, 154 insertions(+), 28 deletions(-)

-- 
2.32.1 (Apple Git-133)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

