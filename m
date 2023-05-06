Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4409CC7EE2F
	for <dm-devel@archiver.kernel.org>; Sat,  6 May 2023 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683354569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Mbh0rqkuFNvAhUekWE7NRj+amolD1hhxii3J46NYlEQ=;
	b=KYdRX24XlO6qkF/EuIwTKw+8VV694S1Ol0P3LKJt93IDSoaLuWQJs+xaUEKvXV4OxlGVpQ
	yZokqQbSNW30iiE6GRDUYYq/d3zUxwaFLoGaD5HhG35n2VFFBLKILjpR6Ny56BxW358skm
	9buzM/yA9AFekFZqc0UwqU+8Sj3rVe4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-ZZvn44S5Npu0_yUT19pn-Q-1; Sat, 06 May 2023 02:29:28 -0400
X-MC-Unique: ZZvn44S5Npu0_yUT19pn-Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A36885A5B1;
	Sat,  6 May 2023 06:29:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D4FF492B01;
	Sat,  6 May 2023 06:29:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BF261946588;
	Sat,  6 May 2023 06:29:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD1291946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 May 2023 06:29:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9247135443; Sat,  6 May 2023 06:29:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89F0F63F5C
 for <dm-devel@redhat.com>; Sat,  6 May 2023 06:29:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69D3985A5A3
 for <dm-devel@redhat.com>; Sat,  6 May 2023 06:29:23 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-l2zBNIhZMqyqO_096bYNvw-1; Sat, 06 May 2023 02:29:22 -0400
X-MC-Unique: l2zBNIhZMqyqO_096bYNvw-1
Received: by mail-pg1-f173.google.com with SMTP id
 41be03b00d2f7-51b603bb360so2299032a12.2
 for <dm-devel@redhat.com>; Fri, 05 May 2023 23:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683354560; x=1685946560;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=QzUNeo8AaNnB2TIGkih7468jv3ib2GmUiAAiulb8HSg=;
 b=kU4Qa59iNStNYoVyDHsCZ6uqB6SzCJXBT5DV3ACCVA/RX1iuJ8DE1ATshwJyHpwuKy
 fA5SqG0O+nxyd+rguUwNp+/AJmBJucLep1MUZ2yFfTC0cI377EvG6lnZIQc+lf2ltlYt
 KPufO1iE6ndfr528cu6ZfcNzL7RHHdBxaUXuef1Am+B8vqK8eBxCy4kC4HqiIbEKofYd
 GeoIEPJ7IQNglHOKn+I/jXb6fAEmCBbAnQ4peegzNBy9abHjeSSUyhk9ta3mi9OLHqcE
 dIcigxkIzoK1/7rb7efjU5tNLGLNlZUQOZ2NeH5th0Bq47L26h7sfkSKn80vpbeExb0w
 fhtQ==
X-Gm-Message-State: AC+VfDynQG80anztRyVH14EE6Lxq1/xQ0wxjH84UsrFknMvr5Vu4Fp5m
 3GnA94SbBA6k6oaXjbRbzUzSvFndyB76KqCfVmo=
X-Google-Smtp-Source: ACHHUZ6jokL+0JA0+CBbmC7mx4pCawIF14Bio4r2MNA9EuX2SoeIteB8Nzv9VY3ha0KGEbV0N1b/Qg==
X-Received: by 2002:a17:902:ea0f:b0:1ab:13bd:5f96 with SMTP id
 s15-20020a170902ea0f00b001ab13bd5f96mr4894008plg.4.1683354560544; 
 Fri, 05 May 2023 23:29:20 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:f19c:a713:5517:ed4])
 by smtp.gmail.com with ESMTPSA id
 q16-20020a170902dad000b001ac381f1ce9sm2793598plx.185.2023.05.05.23.29.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 May 2023 23:29:20 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Fri,  5 May 2023 23:29:04 -0700
Message-ID: <20230506062909.74601-1-sarthakkukreti@chromium.org>
In-Reply-To: <20230420004850.297045-1-sarthakkukreti@chromium.org>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v6 0/5] Introduce block provisioning primitives
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patch series covers iteration 6 of adding support for block
provisioning requests.

Changes from v5:
- Remove explicit supports_provision from dm devices.
- Move provision sectors io hint to pool_io_hint. Other devices
  will derive the provisioning limits from the stack.
- Remove artifact from v4 to omit cell_defer_no_holder for
  REQ_OP_PROVISION.
- Fix blkdev_fallocate() called with invalid fallocate
  modes to propagate errors correctly.

Sarthak Kukreti (5):
  block: Don't invalidate pagecache for invalid falloc modes
  block: Introduce provisioning primitives
  dm: Add block provisioning support
  dm-thin: Add REQ_OP_PROVISION support
  loop: Add support for provision requests

 block/blk-core.c              |  5 +++
 block/blk-lib.c               | 53 ++++++++++++++++++++++++++
 block/blk-merge.c             | 18 +++++++++
 block/blk-settings.c          | 19 ++++++++++
 block/blk-sysfs.c             |  9 +++++
 block/bounce.c                |  1 +
 block/fops.c                  | 31 +++++++++++++---
 drivers/block/loop.c          | 42 +++++++++++++++++++++
 drivers/md/dm-crypt.c         |  4 +-
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-snap.c          |  7 ++++
 drivers/md/dm-table.c         | 23 ++++++++++++
 drivers/md/dm-thin.c          | 70 +++++++++++++++++++++++++++++++++--
 drivers/md/dm.c               |  6 +++
 include/linux/bio.h           |  6 ++-
 include/linux/blk_types.h     |  5 ++-
 include/linux/blkdev.h        | 16 ++++++++
 include/linux/device-mapper.h | 17 +++++++++
 18 files changed, 319 insertions(+), 14 deletions(-)

-- 
2.40.1.521.gf1e218fcd8-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

