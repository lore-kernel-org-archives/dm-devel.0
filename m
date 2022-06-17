Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A1C3C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 16:23:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-5kanO4GaNjiA8ET-mC6D_g-1; Fri, 17 Jun 2022 12:23:03 -0400
X-MC-Unique: 5kanO4GaNjiA8ET-mC6D_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F36D811E76;
	Fri, 17 Jun 2022 16:23:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA0CE40CFD0A;
	Fri, 17 Jun 2022 16:22:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82E421947063;
	Fri, 17 Jun 2022 16:22:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39951194705F
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 16:22:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 176BB2166B29; Fri, 17 Jun 2022 16:22:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1355C2166B26
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 16:22:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDB8C85A581
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 16:22:57 +0000 (UTC)
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com
 [209.85.222.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-k7fdkfTgOBOhHlDLzVcr_w-1; Fri, 17 Jun 2022 12:22:56 -0400
X-MC-Unique: k7fdkfTgOBOhHlDLzVcr_w-1
Received: by mail-qk1-f174.google.com with SMTP id c144so3479695qkg.11
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 09:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=4bObu6p1k2g+8vMXl1zhLx65wzpCkPXQManHSgZa+PI=;
 b=St2mu7NQ9Xy/Px6D0o0fXI00ZP8EZTzB7TmKtmqKDEIa0VtrTrRMWJJDSiWHrjzQVw
 9PXf+vtNrBbT4oYUvmUvvpbzXJZiWHVqDbrtoYMymX8tj2J/Q7RDJLph8Otcso5iqwHf
 5xz6VTwn2Qz13u24FZ8Z6nAtXJbdMsV2cqcD9Ox1k7hJCjSbBC1HV93pmb7uLMzNHUZ0
 PMsKfYbhG8uRIEGs+Yh8nO0hKhdlrNr9K6HZ/EyIZkrhmabvGL2t/1UcUTrFXWMG0E5p
 amqw5fhjzIzbcJUFzubCoYhAQIgwu/OZDS73LPeO+lS3JAnOTl/5X0kqSFssZq61PKog
 1e5Q==
X-Gm-Message-State: AJIora/azgvd7tARH77Govw3RuPDXU3nrmN/nel95FcBvU2/8TSZInjP
 a55o/TqMpoVJs5YM6D/ebp0Q9+29XvWYtcc=
X-Google-Smtp-Source: AGRyM1uGUmSAXAbQUvVC96ACQl9YgJNglOsmd/xGTZ+qYJ2/oB9NBV6L2yUsEa7BF4pdlgE+0ywSTw==
X-Received: by 2002:a05:620a:120d:b0:6a6:a5a8:3ced with SMTP id
 u13-20020a05620a120d00b006a6a5a83cedmr7459056qkj.755.1655482975944; 
 Fri, 17 Jun 2022 09:22:55 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 l16-20020a05620a28d000b006a6cadd89efsm5157201qkp.82.2022.06.17.09.22.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 09:22:55 -0700 (PDT)
Date: Fri, 17 Jun 2022 12:22:54 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YqyqXocn0lrLVJ1R@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [git pull] device mapper fixes for 5.19-rc3
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
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3:

  Linux 5.19-rc2 (2022-06-12 16:11:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.19/dm-fixes-3

for you to fetch changes up to 85e123c27d5cbc22cfdc01de1e2ca1d9003a02d0:

  dm mirror log: round up region bitmap size to BITS_PER_LONG (2022-06-16 19:39:29 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix a race in DM core's dm_start_io_acct that could result in double
  accounting for abnormal IO (e.g. discards, write zeroes, etc).

- Fix a use-after-free in DM core's dm_put_live_table_bio.

- Fix a race for REQ_NOWAIT bios being issued despite no support from
  underlying DM targets (due to DM table reload at an "unlucky" time)

- Fix access beyond allocated bitmap in DM mirror's log.

----------------------------------------------------------------
Benjamin Marzinski (1):
      dm: fix race in dm_start_io_acct

Mikulas Patocka (3):
      dm: fix use-after-free in dm_put_live_table_bio
      dm: fix narrow race for REQ_NOWAIT bios being issued despite no support
      dm mirror log: round up region bitmap size to BITS_PER_LONG

 drivers/md/dm-log.c |  3 +--
 drivers/md/dm.c     | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

