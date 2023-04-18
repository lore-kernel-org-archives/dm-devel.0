Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B9BCC77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 03:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681876550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YjnjJgM+IfelYdpFVKRLPA1JChunuLo0WaNtyivxBuM=;
	b=ARKWvzEsnaGXXQEZ4rlcb6CCxn2tK6+LD0aJvgD2V53CQm73ro3Ih7kvLFfV8viDRvk0ic
	Z2vxNMzVE1DgV8UdJbFF44qisT0ohRMJxYKub6DSsI2Ut9go5JRWM0SJD2Oc9wYT507u/8
	hiWz9ztnPq6TO5/dPuWmGNdfB/GrsLw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-QKMvYKQMOp-0B3m834-fwQ-1; Tue, 18 Apr 2023 23:55:47 -0400
X-MC-Unique: QKMvYKQMOp-0B3m834-fwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 785888996F3;
	Wed, 19 Apr 2023 03:55:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5426B1410F1F;
	Wed, 19 Apr 2023 03:55:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39EE51946597;
	Wed, 19 Apr 2023 03:55:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7CC9194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 22:12:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 906042166B29; Tue, 18 Apr 2023 22:12:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 88F412166B26
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B502101A553
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:28 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-vZ9ekbTDPJqzm3vGeBGbJg-1; Tue, 18 Apr 2023 18:12:26 -0400
X-MC-Unique: vZ9ekbTDPJqzm3vGeBGbJg-1
Received: by mail-pf1-f170.google.com with SMTP id
 d2e1a72fcca58-63d4595d60fso2906129b3a.0
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 15:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681855945; x=1684447945;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=M9E1BqVFDy2BflXM1cADV/r0z5lqbfjda2/59Vcchgo=;
 b=e+SPJEdziEFOxeeJAbc8c2I4p2hfRkLFKwN7TN8TxTPEDwhpV7A4ofXikKUv+B2ZVA
 39b0dgRKQJizk9wqvI5yR/AYteXT6qXj8yviwo3S6tQakNXbtCZf2MrlT8d5eYkjw6p9
 +vDzFKnfq+gL0HZDbnrFVn6tszcMvr1gqBiL+G0vYr3oD41YsQsDQ+9a9jRrDLbKXaZR
 zLyuGKVWE6+pVkm3hazhFavOob/RVy7MeHjbgNRP1rIT5SIMNLxUNZz1vRZPbFOG6ZYg
 3AT5Z0cSpIom1CIkK96JtK+/FuC8W0oGV6jxtLr0ObL4a0zT/2HYDo5gvS8M6kFddbcB
 WWVw==
X-Gm-Message-State: AAQBX9c90MLa6Rxv5kmO1Lu5xJyzLn6mYU5pZpnpQu3mSljjuf/eyiQs
 5HsSm1NNlb+Z0A7YTyGceHnR2gbtGOD5J0NTdEU=
X-Google-Smtp-Source: AKy350br4lmpBQ9IqBERy8QWvPvh8nF+TV+5IMWinZQGy/0x1eapXdYeTnP5vhm7GN1Hj1rvRlU8RQ==
X-Received: by 2002:a17:902:d2cb:b0:1a6:3def:5ff6 with SMTP id
 n11-20020a170902d2cb00b001a63def5ff6mr314888plc.4.1681855944989; 
 Tue, 18 Apr 2023 15:12:24 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:e38b:ca5e:3203:48d3])
 by smtp.gmail.com with ESMTPSA id
 x1-20020a1709029a4100b001a687c505e9sm9911892plv.237.2023.04.18.15.12.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Apr 2023 15:12:24 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Tue, 18 Apr 2023 15:12:03 -0700
Message-ID: <20230418221207.244685-1-sarthakkukreti@chromium.org>
In-Reply-To: <20230414000219.92640-1-sarthakkukreti@chromium.org>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 19 Apr 2023 03:55:32 +0000
Subject: [dm-devel] [PATCH v4 0/4] Introduce provisioning primitives for
 thinly provisioned storage
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
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patch series is revision 4 of introducing a new mechanism to pass through provision requests on stacked thinly provisioned storage devices. See [1] for original cover letter.

[1] https://lore.kernel.org/lkml/ZDnMl8A1B1+Tfn5S@redhat.com/T/#md4f20113c2242755747ae069f84be720a6751012

Changelog:

V4:
- Fix UNSHARE and KEEP_SIZE handling in blkdev_fallocate.
- Split dm-thin support into a separate patch.
- Remove ranged provision request handling and adjust io hints to handle provisioning one block at a time.
- Add missing provision_supported for dm targets.

V3:
- Drop FALLOC_FL_PROVISION and use mode == 0 for provision requests.
- Drop fs-specific patches; will be sent out in a follow up series.
- Fix missing shared block handling for thin snapshots.

V2:
- Fix stacked limit handling.
- Enable provision request handling in dm-snapshot
- Don't call truncate_bdev_range if blkdev_fallocate() is called with
  FALLOC_FL_PROVISION.
- Clarify semantics of FALLOC_FL_PROVISION and why it needs to be a separate flag
  (as opposed to overloading mode == 0).


Sarthak Kukreti (4):
  block: Introduce provisioning primitives
  dm: Add block provisioning support
  dm-thin: Add REQ_OP_PROVISION support
  loop: Add support for provision requests

 block/blk-core.c              |  5 +++
 block/blk-lib.c               | 53 +++++++++++++++++++++++++
 block/blk-merge.c             | 18 +++++++++
 block/blk-settings.c          | 19 +++++++++
 block/blk-sysfs.c             |  8 ++++
 block/bounce.c                |  1 +
 block/fops.c                  | 25 +++++++++---
 drivers/block/loop.c          | 42 ++++++++++++++++++++
 drivers/md/dm-crypt.c         |  5 ++-
 drivers/md/dm-linear.c        |  2 +
 drivers/md/dm-snap.c          |  8 ++++
 drivers/md/dm-table.c         | 23 +++++++++++
 drivers/md/dm-thin.c          | 73 ++++++++++++++++++++++++++++++++---
 drivers/md/dm.c               |  6 +++
 include/linux/bio.h           |  6 ++-
 include/linux/blk_types.h     |  5 ++-
 include/linux/blkdev.h        | 16 ++++++++
 include/linux/device-mapper.h | 17 ++++++++
 18 files changed, 317 insertions(+), 15 deletions(-)

-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

