Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA72C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  1 Apr 2022 19:28:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-UlmFUCSGO7ayv7Uf7lL3Vw-1; Fri, 01 Apr 2022 15:27:29 -0400
X-MC-Unique: UlmFUCSGO7ayv7Uf7lL3Vw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79CC218812C9;
	Fri,  1 Apr 2022 19:27:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DC215E53FA;
	Fri,  1 Apr 2022 19:27:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D01B81949761;
	Fri,  1 Apr 2022 19:27:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C069A1947BBE
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Apr 2022 19:27:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C11240E58B4; Fri,  1 Apr 2022 19:27:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 97FC440E58A4
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 19:27:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 961B929AB3E5
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 19:27:04 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-vSPj3W5uP6W7E0GQOg_12w-1; Fri, 01 Apr 2022 15:27:02 -0400
X-MC-Unique: vSPj3W5uP6W7E0GQOg_12w-1
Received: by mail-qv1-f47.google.com with SMTP id a5so2798469qvx.1
 for <dm-devel@redhat.com>; Fri, 01 Apr 2022 12:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=nvFo57OWxTfF6xwdTmogwqLgyZ3UA+Mu9A7SNgh8l+A=;
 b=Z1Xp26powTdCCQ+iHhwVg6aBGhHicRq48eGmqSk2I6RSkZajSHlCB7fnu3nINXmyeD
 xKcZh3NCtEtc2+IJqZDj1Jp1/I+uwfQqPzKZyn1J/vtMQpEt+58DewZWdua1o8DIqaSA
 ZfNna9QRSZXcsPcSnpW7xKWLE6yVEXX62UqVeNW6ZZUMttHlh83HxxfG3HkXjKdhkWN2
 N46+QRaaXwnqfpw/KncHFAy1a9JDTrnKPH5Q0HlPXt06E1Ate8vPepZaAZDSkhzhRY5Y
 VD/05pPLz5ZT4Z7PVMyPialGW48ge/UZ9MmlTThQyjYuSpBwpE0DhVsk867woKOD0ffa
 kEew==
X-Gm-Message-State: AOAM532ytEljLeu29pYeuYdKegfQ/rVvcBEM4ipEO7Bb8Qw9flDqycib
 B3KDDKWQCNU5xIlITpirVA87Xms7dJWCWS4=
X-Google-Smtp-Source: ABdhPJz7IojtZWqKLAmzeellR8Hr0SP+8z17HN70PVGT0MGDxgLjPsXgmnzE3U9TIQxU971k8XygPA==
X-Received: by 2002:ad4:5ba7:0:b0:441:75bc:d7a6 with SMTP id
 7-20020ad45ba7000000b0044175bcd7a6mr37912669qvq.123.1648841221729; 
 Fri, 01 Apr 2022 12:27:01 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 s31-20020a05622a1a9f00b002e1df010316sm2387410qtc.80.2022.04.01.12.27.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Apr 2022 12:27:01 -0700 (PDT)
Date: Fri, 1 Apr 2022 15:27:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YkdSBEf1PpU9w2qs@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [git pull] device mapper fixes for 5.18-rc1
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
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 3f7282139fe1594be464b90141d56738e7a0ea8a:

  Merge tag 'for-5.18/64bit-pi-2022-03-25' of git://git.kernel.dk/linux-block (2022-03-26 12:01:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.18/dm-fixes

for you to fetch changes up to 5291984004edfcc7510024e52eaed044573b79c7:

  dm: fix bio polling to handle possibile BLK_STS_AGAIN (2022-04-01 13:23:12 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM integrity shrink crash due to journal entry not being marked
  unused.

- Fix DM bio polling to handle possibility that underlying device(s)
  return BLK_STS_AGAIN during submission.

- Fix dm_io and dm_target_io flags race condition on Alpha.

- Add some pr_err debugging to help debug cases when DM ioctl
  structure is corrupted.

----------------------------------------------------------------
Mikulas Patocka (3):
      dm ioctl: log an error if the ioctl structure is corrupted
      dm integrity: set journal entry unused when shrinking device
      dm: fix dm_io and dm_target_io flags race condition on Alpha

Ming Lei (1):
      dm: fix bio polling to handle possibile BLK_STS_AGAIN

 drivers/md/dm-core.h      |  4 ++--
 drivers/md/dm-integrity.c |  6 ++++--
 drivers/md/dm-ioctl.c     | 15 ++++++++++++---
 drivers/md/dm.c           | 20 +++++++++++++-------
 include/linux/blk_types.h |  2 ++
 5 files changed, 33 insertions(+), 14 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

