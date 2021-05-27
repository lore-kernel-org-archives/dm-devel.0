Return-Path: <SRS0=F9kp=KW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74389C4707F
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 18:52:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F18F0613D4
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 18:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F18F0613D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622141568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HHVmJIUjOjQqn3Hp2Dx7PyeqGevuRhVbM4MBtvcs6Gs=;
	b=RP2ZdXIJRZ2l8gRyVzBrm3BDyWKJllF3/092wphxq1s+G1q32YZakG9raDK+Ho/dS3c4bU
	VaP7HSPZnDnrT/ZqDQKneuOpf2NXU3npmj0u6f11Ge1HrWjCov/rmarZZCe6ptfxDe+RRU
	ttZ39jpgKL8bMF999ria/DHSzPMGQdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-PC_Oodx8PVCQ4OlX7EqOLA-1; Thu, 27 May 2021 14:52:46 -0400
X-MC-Unique: PC_Oodx8PVCQ4OlX7EqOLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48229802938;
	Thu, 27 May 2021 18:52:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9C762C161;
	Thu, 27 May 2021 18:52:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7ADA555348;
	Thu, 27 May 2021 18:52:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14RIqWHh017766 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 May 2021 14:52:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CC34E107CD16; Thu, 27 May 2021 18:52:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8121107CCFA
	for <dm-devel@redhat.com>; Thu, 27 May 2021 18:52:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F2218339A3
	for <dm-devel@redhat.com>; Thu, 27 May 2021 18:52:29 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
	[209.85.219.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-323-VKwZCaKKOYmsNEA90a5MjQ-1; Thu, 27 May 2021 14:52:27 -0400
X-MC-Unique: VKwZCaKKOYmsNEA90a5MjQ-1
Received: by mail-qv1-f48.google.com with SMTP id h7so632007qvs.12;
	Thu, 27 May 2021 11:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:mime-version:content-disposition;
	bh=irFDTmhfj5+mUVkDlWzm45eHLPkDZVXsNY0Yh4yvFJw=;
	b=UT22eWO9Ujugjuo6k8t8Zchb6SjUzs/8dFwEBdoMYBLv5CFep9MadF9r6CuaDu9kg5
	P1z2roCADi2dAvo9RwTq92dumHVY0T9cZbc9A92lQ00Xj5GgQHRQHNyQ1ekvzlnyWpFN
	c+WFWRRBNzvGuQ7Eb9vVvfhJvJ86Nd61zjx/8ajTKOYxRRkVj4qIc/hxvIA+IF77cHOn
	L+6E2dw/d/IqGjIw90t1YW9uOmGpSDLZdiLV7fe6hks+IO9TY03c8kqkl6Kxukg/TAbx
	xizJbDYo2Ti8C6Tw9T7bzgJ6onnKblo/8hIzzgd/QGZIxjNTMuIKhrbgtQDELXQdGVF1
	6SKg==
X-Gm-Message-State: AOAM533FvvhgssnPwJr4PE1twNXrTZzlsTwIGgZ6TDRiMTG+9XzjjvTm
	yAK8TVki9aa4JYMX++EKRMFw3X4ZWvSYJzpw
X-Google-Smtp-Source: ABdhPJwInFMBWXlkNnFR9FRuaRgbtnyYV/fylItuyWAkS+lZHcG75OJCcPhS64Js4i72av7+Sa+RXA==
X-Received: by 2002:a0c:fa4e:: with SMTP id k14mr5243918qvo.51.1622141546756; 
	Thu, 27 May 2021 11:52:26 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	d200sm1934340qkc.44.2021.05.27.11.52.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 May 2021 11:52:26 -0700 (PDT)
Date: Thu, 27 May 2021 14:52:25 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YK/qaSCdhqDlKh1l@redhat.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@redhat.com, John Keeping <john@metanate.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper fixes for 5.13-rc4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit c4681547bcce777daf576925a966ffa824edd09d:

  Linux 5.13-rc3 (2021-05-23 11:42:48 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.13/dm-fixes-2

for you to fetch changes up to 7e768532b2396bcb7fbf6f82384b85c0f1d2f197:

  dm snapshot: properly fix a crash when an origin has no snapshots (2021-05-25 16:19:58 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM verity target's 'require_signatures' module_param permissions.

- Revert DM snapshot fix from v5.13-rc3 and then properly fix crash
  when an origin has no snapshots. This allows only the proper fix to
  go to stable@ (since the original fix was successfully dropped).

----------------------------------------------------------------
John Keeping (1):
      dm verity: fix require_signatures module_param permissions

Mikulas Patocka (2):
      dm snapshot: revert "fix a crash when an origin has no snapshots"
      dm snapshot: properly fix a crash when an origin has no snapshots

 drivers/md/dm-snap.c              | 3 ++-
 drivers/md/dm-verity-verify-sig.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

