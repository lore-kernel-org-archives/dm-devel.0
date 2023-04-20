Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F1EC77B7F
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 00:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681951745;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cvIhMJQL1zocEToFH7vIp45OwihaX84KwhsH+Zq1d+E=;
	b=SUH9P2Rc4dNZXXrkjvfUxDbLyLagiuXd0Z8vzjb8zgt+3yueFWRrw8qnttSMjOl2C2bVm9
	qGua9c6PVPpSlkPBP0/SihFzaks2MsG/WZwguf76mPglAnnE8myhBJv/D9hAoM9FjyiGPG
	SWnfiwXoKY9uAOhzpfWa2uJYaDuZYVo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-PJFUxTJWOnSLljgepaTeDA-1; Wed, 19 Apr 2023 20:49:02 -0400
X-MC-Unique: PJFUxTJWOnSLljgepaTeDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A345101A531;
	Thu, 20 Apr 2023 00:49:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40AC32026E1C;
	Thu, 20 Apr 2023 00:48:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 024CD19465B9;
	Thu, 20 Apr 2023 00:48:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC3D919465B5
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 00:48:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 99B122166B34; Thu, 20 Apr 2023 00:48:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91D3D2166B33
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 00:48:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75EBF811E7C
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 00:48:57 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-i7UX843dPoOnH10iRa6Jdg-1; Wed, 19 Apr 2023 20:48:56 -0400
X-MC-Unique: i7UX843dPoOnH10iRa6Jdg-1
Received: by mail-pl1-f180.google.com with SMTP id
 d9443c01a7336-1a80d827179so5289085ad.3
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 17:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681951734; x=1684543734;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=rF9Var5VZaH4S5EIpXHW6R6bAqiZWgFJai0UoeyTkwE=;
 b=Vd7/S2+AW84bYzLf9ML15LYqKRzIe6ZUqP+7TCBn/eglXphIVGvYF/h81e76BUX+TG
 ZyN8MBNiD79L2QtYv1To7YLGCiZ6Z5L4u8E8hgJGUaaBJgd53tx9lffeySsQgxmvElgP
 MO6j1oh1AGj2Re6juIqMtMLQNkdupv/zQPFpyC21RORo/Mj3dmIc3jVBFY7hFT5tP+7i
 JsOc8EfNMwZqF0vLY80DwHdhQOdAwN3kjLBwJ/dSXMp2D3oIo/wbZaNZ9MkYsTdeomJG
 +EVgXoaKAZnp4mlZB2VFUREZAdSydtcDKWLJpPmc+30xJJRTqgzLFjW3FQ2HW/phylvT
 43mw==
X-Gm-Message-State: AAQBX9cnzu+qOT4AkvuUsQsjxEIGMUJuSlO2Pb0KRgjXFO+9XJ6ixXaM
 efJ4oGFlpJE2Vl/06XwqrJ1IruZ0RgLahufIDtQ=
X-Google-Smtp-Source: AKy350bnjW+rV3sEg0tC2tTj1Uiqplfmhzcjp9WRxYk7355tnhy27//NgU2Ws9tKNLyyUuU4hwqcAA==
X-Received: by 2002:a17:902:b18b:b0:1a6:a327:67e1 with SMTP id
 s11-20020a170902b18b00b001a6a32767e1mr6367289plr.57.1681951734635; 
 Wed, 19 Apr 2023 17:48:54 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:5113:a333:10ce:e2d])
 by smtp.gmail.com with ESMTPSA id
 io18-20020a17090312d200b001a65575c13asm74323plb.48.2023.04.19.17.48.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Apr 2023 17:48:54 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Wed, 19 Apr 2023 17:48:45 -0700
Message-ID: <20230420004850.297045-1-sarthakkukreti@chromium.org>
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
Subject: [dm-devel] [PATCH v5 0/5] Introduce block provisioning primitives
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Next revision of adding support for block provisioning requests.

Changes from v4:
- Add fix for block devices invalidating pagecache if blkdev_fallocate()
  is called with an invalid mode.
- s/max_provision_sectors/provision_max_bytes in sysfs.

Sarthak Kukreti (5):
  block: Don't invalidate pagecache for invalid falloc modes
  block: Introduce provisioning primitives
  dm: Add block provisioning support
  dm-thin: Add REQ_OP_PROVISION support
  loop: Add support for provision requests

 block/blk-core.c              |  5 +++
 block/blk-lib.c               | 53 +++++++++++++++++++++++++
 block/blk-merge.c             | 18 +++++++++
 block/blk-settings.c          | 19 +++++++++
 block/blk-sysfs.c             |  9 +++++
 block/bounce.c                |  1 +
 block/fops.c                  | 28 +++++++++-----
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
 18 files changed, 318 insertions(+), 18 deletions(-)

-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

