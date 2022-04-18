Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADBBC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170--cv23aZgNFGJtddR-b2ejg-1; Sun, 17 Apr 2022 22:27:40 -0400
X-MC-Unique: -cv23aZgNFGJtddR-b2ejg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA3C180B71C;
	Mon, 18 Apr 2022 02:27:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5148A40F4941;
	Mon, 18 Apr 2022 02:27:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1527C19451F1;
	Mon, 18 Apr 2022 02:27:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F52C19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A7AF409B410; Mon, 18 Apr 2022 02:27:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26956409B409
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EB15811E78
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:37 +0000 (UTC)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com
 [209.85.160.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-yBnaS168NLyF6OlQkmC2mw-1; Sun, 17 Apr 2022 22:27:35 -0400
X-MC-Unique: yBnaS168NLyF6OlQkmC2mw-1
Received: by mail-qt1-f176.google.com with SMTP id o18so9295379qtk.7
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=cL6LjqFAEAfiZyXAATZ+FZCFsdDlPWYrSf1d+drmfhg=;
 b=2EEV3GGVEKjYwod0S9CXevUPkGGp8KFq2khJCeevquyy+7PeNWi4LfBi09LadjJbcA
 Z0B/ZcsQLml/qmq5RpZMo5YzZ8AAJECUC+w+oj5LN2iIppmlK8UaYOOqJ78xGqY1LVQR
 GSYrfZYqej3IYmB/CiwcxaB+U74Hyx+0379D62R15LNOwF5pKonSaGrVQ7HKJFYm5/oY
 3idpBEspJgAH7LIsazgCHWDsISVpGP0sXJ0OS4jNZQPc4xoAdGE854olS/zpnltWZuKq
 CS2B8jDaMQrZgiyC8ATJo5lm3WXplz43BjtEUstql1h6lef5e9sin0keCLVq4Slb7/ME
 LSXg==
X-Gm-Message-State: AOAM531KYAgVAax7YGG6bsgl2geTy+QL0Eum4wt6FqR5Q+Ef/kPlCzt9
 RpmhJaqQFPPLntWbI8vYIKcHuu7ZOHrxwmn1YtdXjjEgSuukES8/ESaZjj1OW3JKJzfEqBdQCRz
 XdU7t+T1cnkPSmtfRIN2IP3QajjLiO+VJ4vUEbbmtYXwX1BPgmEUlTckJqr8KWZthUhc=
X-Google-Smtp-Source: ABdhPJw6/Evf53gGmr7V6GmE2a2BP75ZOHx15G7dK4OMRUFpGecAcaALykhIRaUUq3ZW/mxdcO74dg==
X-Received: by 2002:ac8:5855:0:b0:2eb:87af:ab50 with SMTP id
 h21-20020ac85855000000b002eb87afab50mr5840120qth.406.1650248854856; 
 Sun, 17 Apr 2022 19:27:34 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 p5-20020ae9f305000000b0069e6dcc4188sm3126425qkg.57.2022.04.17.19.27.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:34 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:12 -0400
Message-Id: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [dm-5.19 PATCH 00/21] dm: changes staged for 5.19
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patchset reflects what I've staged in linux-dm.git's "dm-5.19"
branch (also staged in "for-next" for linux-next):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19

It build's on jens/for-5.19/block branch (which is based on v5.18-rc3)

I can still make changes or add Reviewed-by:s, etc. So please feel
free to review.

Jens, I'd appreciate it if you could pickup the first patch:
"block: change exported IO accounting interface from gendisk to bdev"
(still not in love with that subject but...)

Thanks,
Mike

Mike Snitzer (13):
  dm: conditionally enable BIOSET_PERCPU_CACHE for dm_io bioset
  dm: factor out dm_io_set_error and __dm_io_dec_pending
  dm: simplify dm_io access in dm_split_and_process_bio
  dm: simplify dm_start_io_acct
  dm: mark various branches unlikely
  dm: add local variables to clone_endio and __map_bio
  dm: move hot dm_io members to same cacheline as dm_target_io
  dm: introduce dm_{get,put}_live_table_bio called from dm_submit_bio
  dm: conditionally enable branching for less used features
  dm: simplify basic targets
  dm: use bio_sectors in dm_aceept_partial_bio
  dm: simplify bio-based IO accounting further
  dm: improve abnormal bio processing

Ming Lei (8):
  block: change exported IO accounting interface from gendisk to bdev
  dm: don't pass bio to __dm_start_io_acct and dm_end_io_acct
  dm: pass dm_io instance to dm_io_acct directly
  dm: switch to bdev based IO accounting interfaces
  dm: improve bio splitting and associated IO accounting
  dm: don't grab target io reference in dm_zone_map_bio
  dm: improve dm_io reference counting
  dm: put all polled dm_io instances into a single list

 block/blk-core.c              |  52 ++---
 drivers/block/zram/zram_drv.c |   5 +-
 drivers/md/dm-core.h          |  38 ++--
 drivers/md/dm-delay.c         |   3 +-
 drivers/md/dm-flakey.c        |   4 +-
 drivers/md/dm-linear.c        |  11 +-
 drivers/md/dm-stats.c         |   3 +
 drivers/md/dm-table.c         |  16 +-
 drivers/md/dm-zone.c          |  10 -
 drivers/md/dm.c               | 515 ++++++++++++++++++++++++------------------
 drivers/md/dm.h               |   4 +-
 include/linux/blkdev.h        |   7 +-
 12 files changed, 367 insertions(+), 301 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

