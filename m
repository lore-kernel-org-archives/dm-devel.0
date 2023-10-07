Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F28E94139
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 01:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696642115;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f4Na23RSFh5LdjabTh5b4JuFdj4jndKZ9mBqNqGnsb8=;
	b=N/V4cE/RuV0BKScZq2WlONEBoIyTvsyGLRR7hPGEi9Muhz/LjgNrRjBJRzm3eMF20sSgIm
	Ucns5KDR62R6erSysF6oE57y8oWiCztBuw2fXXamXu2ZqfivQ9dbMeKxaEZSnT1HAvBMsf
	c1yXMAgQvOtc+HV72LUs5xIiZyaluFk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-spWbYRsvNFuo_OxWDLxGNg-1; Fri, 06 Oct 2023 21:28:32 -0400
X-MC-Unique: spWbYRsvNFuo_OxWDLxGNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AF12811E7B;
	Sat,  7 Oct 2023 01:28:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 878A610F1BEA;
	Sat,  7 Oct 2023 01:28:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53CD41946589;
	Sat,  7 Oct 2023 01:28:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A73881946588
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 01:28:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 857DF2027046; Sat,  7 Oct 2023 01:28:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E0B82027045
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:27 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F9CF3C0E678
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:27 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-e3ntOigrO3GJkvZnbKdtVQ-1; Fri, 06 Oct 2023 21:28:25 -0400
X-MC-Unique: e3ntOigrO3GJkvZnbKdtVQ-1
Received: by mail-pl1-f169.google.com with SMTP id
 d9443c01a7336-1c874b43123so23046975ad.2
 for <dm-devel@redhat.com>; Fri, 06 Oct 2023 18:28:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696642104; x=1697246904;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=sPAOchZ3lviZQWz7F/yVzJ/5u6K9fS7pELXL8VtCc9c=;
 b=mgsQQMIN5XL9gprQ7/ki91HM85+OqE0QiUXfpB0xQ4royKkXqvTk3DDsbfeMidJ4xr
 ybpomM9x/zBhPKE07GpkEv7yJxfCsn5sqcsakQmxWB1KhjTWlc1Ixvy+VrvLO6pCZctS
 fOLki55QG5s42ZuGrk/dK6+uPNsMy9rmHzblE0BBapNKi2U05z2FfSLc0S7fQwPxxJbP
 WQ4j8JiSITJRMt1Twcici1qli0Q0AN4R2Xij+VyBhhDZqszsEaYXpN36SoZ7X5/zb19f
 v061tjSO+bsH0WeiTs8qtkCPIQPu20FYj8npWxWY3TFHA9C8sZewifdeCbg5rVFXmckZ
 JPww==
X-Gm-Message-State: AOJu0YzRxixLngD2UjS8qQYTf/dtd7M5ofmBLlXMwaidTtxQEePS/7IY
 9mszWjYvZDm52irr2COClbDi5iwum3y2GIQ9uWE=
X-Google-Smtp-Source: AGHT+IF35TNd+fTvsxdLu9WMjvVSs/iB8sRAO30572Xwc92tYnfHc95l4aq5f8nH5De0gpWJSaCjww==
X-Received: by 2002:a17:903:228f:b0:1c7:66a4:27ba with SMTP id
 b15-20020a170903228f00b001c766a427bamr11470478plh.48.1696642104031; 
 Fri, 06 Oct 2023 18:28:24 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:138c:8976:eb4a:a91c])
 by smtp.gmail.com with UTF8SMTPSA id
 q13-20020a170902dacd00b001b8b2a6c4a4sm4575373plx.172.2023.10.06.18.28.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Oct 2023 18:28:23 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Fri,  6 Oct 2023 18:28:12 -0700
Message-ID: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v8 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patch series is version 8 of the patch series to introduce
block-level provisioning mechanism (original [1]), which is useful for provisioning
space across thinly provisioned storage architectures (loop devices
backed by sparse files, dm-thin devices, virtio-blk). This series has
minimal changes over v7[2].

This patch series is rebased from the linux-dm/dm-6.5-provision-support [1] on to
(cac405a3bfa2 Merge tag 'for-6.6-rc3-tag'). In addition, there's an
additional patch to allow passing through an unshare intent via REQ_OP_PROVISION
(suggested by Darrick in [4]).

[1] Original: https://lore.kernel.org/lkml/20220915164826.1396245-1-sarthakkukreti@google.com/
[2] v7 (last series): https://lore.kernel.org/linux-fsdevel/20230518223326.18744-1-sarthakkukreti@chromium.org/
[3] linux-dm/dm-6.5-provision-suppport tree:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.5-provision-support
(with the last two WIP patches for dm-thinpool dropped as per discussion with
maintainers).
[4] https://lore.kernel.org/linux-fsdevel/20230522163710.GA11607@frogsfrogsfrogs/

Changes from v7:
- Drop dm-thinpool (will be independently developed with snapshot
  support) and dm-snapshot (will not be supported) from the series.
- (By snitzer@kernel.org) Fixes for block device provision limits.
- (Suggested by djwong@kernel.org) Add mechanism to pass unshare intent
  via REQ_OP_PROVISION

Sarthak Kukreti (5):
  block: Don't invalidate pagecache for invalid falloc modes
  block: Introduce provisioning primitives
  loop: Add support for provision requests
  dm: Add block provisioning support
  block: Pass unshare intent via REQ_OP_PROVISION

 block/blk-core.c              |  5 +++
 block/blk-lib.c               | 55 ++++++++++++++++++++++++++++++++
 block/blk-merge.c             | 18 +++++++++++
 block/blk-settings.c          | 19 +++++++++++
 block/blk-sysfs.c             |  9 ++++++
 block/bounce.c                |  1 +
 block/fops.c                  | 33 ++++++++++++++++----
 drivers/block/loop.c          | 59 ++++++++++++++++++++++++++++++++---
 drivers/md/dm-crypt.c         |  4 ++-
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-table.c         | 23 ++++++++++++++
 drivers/md/dm.c               |  7 +++++
 include/linux/bio.h           |  6 ++--
 include/linux/blk_types.h     |  8 ++++-
 include/linux/blkdev.h        | 17 ++++++++++
 include/linux/device-mapper.h | 17 ++++++++++
 16 files changed, 268 insertions(+), 14 deletions(-)

-- 
2.42.0.609.gbb76f46606-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

