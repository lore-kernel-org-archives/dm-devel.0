Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C44C77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 18 May 2023 22:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684449240;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CNZE+5W8UEjd/LbYrJL+l7FZnOs5uu60w4yWHtbFLBA=;
	b=Kj9Bvc92DrJ1THnBIAQunAddHYHB/LkuE78b+q63BoY677tT1jCH5wMCNqckhnov+gZDVW
	7NO3575baRYK3TWSa8QXbVNO3/iWlhV2ABGlGYaiqRtE7Tf2LvfDoD1/Qp9Hy+JcHcfLmG
	YdeWOTiWpKMix/3NqlqM9xIPV9UYOXs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-BkWKiNY9OhyppkdsAxnRIg-1; Thu, 18 May 2023 18:33:57 -0400
X-MC-Unique: BkWKiNY9OhyppkdsAxnRIg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C00885A5B1;
	Thu, 18 May 2023 22:33:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E4ED492C13;
	Thu, 18 May 2023 22:33:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE9BD19465B2;
	Thu, 18 May 2023 22:33:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8EF0919465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 18 May 2023 22:33:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 70AC1492B03; Thu, 18 May 2023 22:33:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 685AE492B01
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:33:49 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B9F385A5A3
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:33:49 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-UQFjnUreM4mj_jcVwT8CAw-1; Thu, 18 May 2023 18:33:47 -0400
X-MC-Unique: UQFjnUreM4mj_jcVwT8CAw-1
Received: by mail-pg1-f173.google.com with SMTP id
 41be03b00d2f7-52cb78647ecso1779737a12.1
 for <dm-devel@redhat.com>; Thu, 18 May 2023 15:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684449226; x=1687041226;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=WPcvilHxRv5tEGKC3PHnSqwH0oZyyl+v+Zg8TUGpbJw=;
 b=DnGEszKBQhZKxPCo7KFlWfkBx1eNmM2R7y+vaEcyriCHHaLmLPpO+tDULUQWY5iyD6
 vrZjATwZ2Cp80UOxMTSl4py+JYqmQwQcUEVlK1F48vikAgW8MMrH3m9AzLghT0unIAqd
 fLAvVRxSRqDt6DiVgFweQ6r/8CfFo2P+rpwx8t1BtLnoZLHS5pl2NSSucF/E1AC+ET9Y
 PCqERnkhTvty5v29q9CVV3eVwbC7B5DRBBGURAcK2PMPcFUHdkbLjatQ3lghu2SZYp9T
 W17xCdl7wsu0uBUd8WqnrE46kS2MKH9u6G6oHkXE3K0KV5k2/Cr0KhoKPqqvCATtNSrn
 2NUw==
X-Gm-Message-State: AC+VfDzEcdFWEU0yLzpzqTmeOyFbN/UZho4S8AdeQVJuJJjV6vEJcY/q
 CM1iL8+fy9j316VXIQV2FkTQMZDoApIZUoRVZ/Y=
X-Google-Smtp-Source: ACHHUZ7srcWgRWNjK1oBR93TOXpdFS6fhRHeem/s6f029tvJAmcsLM8dRi+XaWwzfkjepb180UvfcA==
X-Received: by 2002:a17:902:9b94:b0:1ae:153f:4cb with SMTP id
 y20-20020a1709029b9400b001ae153f04cbmr560712plp.49.1684449226192; 
 Thu, 18 May 2023 15:33:46 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com ([100.107.238.113])
 by smtp.gmail.com with ESMTPSA id
 q4-20020a170902b10400b001aafb802efbsm1996502plr.12.2023.05.18.15.33.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 May 2023 15:33:45 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Thu, 18 May 2023 15:33:21 -0700
Message-ID: <20230518223326.18744-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This is version 7 of the patch series to introduce block-level provisioning primitives [1]. The current series is rebased on: (2d1bcbc6cd70 Merge tag 'probes-fixes-v6.4-rc1'...).

Changelog:

v7:
- Fold up lo_req_provision() into lo_req_fallocate().
- Propagate error on failure to provision from the blkdev_issue_provision().
- Set 'max_provision_granularity' in thin_ctr.
- Fix positioning of 'max_provision_sectors' in pool_ctr.
- Add provision bios into process_prepared_mapping() to prevent the bio from being reissued to the underlying thinpool.

[1] https://lore.kernel.org/lkml/20220915164826.1396245-1-sarthakkukreti@google.com/

Sarthak Kukreti (5):
  block: Don't invalidate pagecache for invalid falloc modes
  block: Introduce provisioning primitives
  dm: Add block provisioning support
  dm-thin: Add REQ_OP_PROVISION support
  loop: Add support for provision requests

 block/blk-core.c              |  5 +++
 block/blk-lib.c               | 51 ++++++++++++++++++++++++
 block/blk-merge.c             | 18 +++++++++
 block/blk-settings.c          | 19 +++++++++
 block/blk-sysfs.c             |  9 +++++
 block/bounce.c                |  1 +
 block/fops.c                  | 31 ++++++++++++---
 drivers/block/loop.c          | 34 ++++++++++++++--
 drivers/md/dm-crypt.c         |  4 +-
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-snap.c          |  7 ++++
 drivers/md/dm-table.c         | 23 +++++++++++
 drivers/md/dm-thin.c          | 74 +++++++++++++++++++++++++++++++++--
 drivers/md/dm.c               |  6 +++
 include/linux/bio.h           |  6 ++-
 include/linux/blk_types.h     |  5 ++-
 include/linux/blkdev.h        | 16 ++++++++
 include/linux/device-mapper.h | 17 ++++++++
 18 files changed, 310 insertions(+), 17 deletions(-)

-- 
2.40.1.698.g37aff9b760-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

