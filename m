Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936A1C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 19:46:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 29CCB6135A
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 19:46:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29CCB6135A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621539971;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2DQE1R1lIVggFnm1hCMHLlI0Sh4sfR34Nk88lmpH9eQ=;
	b=QrTBSpwG5E5/jn2fPYAkyIGgSvzffl31Wi902ecy4HGmrZHLyP5Zvecsbn/Ie4Fjmo4hy7
	YPPycKba4l+t2bEdy2jLxuk9149V9knRzklbBoroAvpdKaymnS4GdPLdSwh0xJuBSnExeJ
	37+T2p9MixYRT41jGYU06tJmfbPBK18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-IbjxL2dnO5uqxAiPPbFZyA-1; Thu, 20 May 2021 15:46:07 -0400
X-MC-Unique: IbjxL2dnO5uqxAiPPbFZyA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA0A2107ACCA;
	Thu, 20 May 2021 19:46:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAAB05D761;
	Thu, 20 May 2021 19:45:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4744655353;
	Thu, 20 May 2021 19:45:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14KJjtqI013471 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 15:45:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 429BB20BDB3B; Thu, 20 May 2021 19:45:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E3D820BDB37
	for <dm-devel@redhat.com>; Thu, 20 May 2021 19:45:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92C0180014A
	for <dm-devel@redhat.com>; Thu, 20 May 2021 19:45:52 +0000 (UTC)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com
	[209.85.222.176]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-40-knJAuIhRPhSNdPT2MWXyug-1; Thu, 20 May 2021 15:45:48 -0400
X-MC-Unique: knJAuIhRPhSNdPT2MWXyug-1
Received: by mail-qk1-f176.google.com with SMTP id x8so17480333qkl.2;
	Thu, 20 May 2021 12:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:mime-version:content-disposition;
	bh=HHJU3Q306ITmLSio1GcF/N7+OjoVriUxfio1f6Xoj4s=;
	b=h2Dn3rZBYLvYzxBxmqOAO5nGbzdoZbwnYbjAcs7SHtvqJPqWNFV55QvjGEknqQpDG4
	GFCqzR21G/20c9bDUt7Atbo2Vvu4ahavWebz2NHpBm1aiMwuEmKF/G41WrcOIgAKul/i
	WA35za+f7j52RZlMsB8N4vOUVYOYlo1doZWTtw981d9ba/XgGtHO4u4ujuneqdTpUz3r
	0+03Yf0yJ7vkTt/b+CiKB7A/XJ2752L96CtwSSdO4s0j8gKtqtUvfqrWhyLbg4ZPDtIA
	pTNDEMzDTq2JY+OIHONJqrD9Goy7qOjdIXGFgt2Hlu9N95Ry65+G4jtoTIexAcYEFteq
	3EpQ==
X-Gm-Message-State: AOAM530bGKc5Wf1bXd0SOHrFsXXMVxkVB4aG814N/pqIiJX0c4xxO725
	lIYpphDFZdt0sAoErvGDA54=
X-Google-Smtp-Source: ABdhPJzmUfqcOPKc6TrGlLiQX15KKLZNOun7zl5sdHXRTtunYckGLbsgOQEV8MJehPCse+DHFLyRIg==
X-Received: by 2002:ae9:c016:: with SMTP id u22mr7105608qkk.114.1621539947905; 
	Thu, 20 May 2021 12:45:47 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	g64sm2809749qkf.41.2021.05.20.12.45.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 20 May 2021 12:45:47 -0700 (PDT)
Date: Thu, 20 May 2021 15:45:46 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YKa8aq2SgXzX7sva@redhat.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.13-rc3
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.13/dm-fixes

for you to fetch changes up to bc8f3d4647a99468d7733039b6bc9234b6e91df4:

  dm integrity: fix sparse warnings (2021-05-13 14:53:49 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix a couple DM snapshot target crashes exposed by user-error.

- Fix DM integrity target to not use discard optimization, introduced
  during 5.13 merge, when recalulating.

- Fix some sparse warnings in DM integrity target.

----------------------------------------------------------------
Mikulas Patocka (4):
      dm snapshot: fix a crash when an origin has no snapshots
      dm snapshot: fix crash with transient storage and zero chunk size
      dm integrity: revert to not using discard filler when recalulating
      dm integrity: fix sparse warnings

 drivers/md/dm-integrity.c | 81 +++++++++++++++++++++--------------------------
 drivers/md/dm-snap.c      |  6 ++--
 2 files changed, 39 insertions(+), 48 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

