Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1324C7618E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 20:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682108575;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EOpe2fkgWKHWTEsIPw9oie/asgy8WEzrXMGC6Xwbcxw=;
	b=jI+h6M0g6jwwNiRq+ozrgQz68hFQxZM5pgiHs0MIuFgAYsklqLAyoaOXgYe2whUOk1uxXM
	m9HpURT25BGNF/yT7Uq/KHl9F8CWxsPUDllQFuxtTeObgJCuIbmzogjGL1uPbYQUOaSDDM
	jduHDbcTIV3d0an9Ron6eKVqNqYyLGo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-jkMpwvNYP9e6md0XRIqvXQ-1; Fri, 21 Apr 2023 16:22:51 -0400
X-MC-Unique: jkMpwvNYP9e6md0XRIqvXQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86E54101A554;
	Fri, 21 Apr 2023 20:22:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 364591121319;
	Fri, 21 Apr 2023 20:22:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFA2A1946A40;
	Fri, 21 Apr 2023 20:22:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2683119466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 20:22:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C26EDC16026; Fri, 21 Apr 2023 20:22:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAE62C16024
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 20:22:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F1633C025D1
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 20:22:47 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-dDJx8IixOoSsAcCQvHVu1A-1; Fri, 21 Apr 2023 16:22:46 -0400
X-MC-Unique: dDJx8IixOoSsAcCQvHVu1A-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1ppwtU-00BlaV-1S; Fri, 21 Apr 2023 19:58:08 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, djwong@kernel.org,
 minchan@kernel.org, senozhatsky@chromium.org
Date: Fri, 21 Apr 2023 12:58:02 -0700
Message-Id: <20230421195807.2804512-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 0/5] block: simplify with PAGE_SECTORS_SHIFT
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
Cc: p.raghav@samsung.com, linux-xfs@vger.kernel.org, mcgrof@kernel.org,
 da.gomez@samsung.com, patches@lists.linux.dev, willy@infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, kbusch@kernel.org,
 drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A bit of block drivers have their own incantations with
PAGE_SHIFT - SECTOR_SHIFT. Just simplfy and use PAGE_SECTORS_SHIFT
all over.

Based on linux-next next-20230421.

Luis Chamberlain (5):
  dm integrity: simplify by using PAGE_SECTORS_SHIFT
  drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
  iomap: simplify iomap_init() with PAGE_SECTORS
  dm bufio: simplify by using PAGE_SECTORS_SHIFT
  zram: use generic PAGE_SECTORS and PAGE_SECTORS_SHIFT

 drivers/block/drbd/drbd_bitmap.c |  4 ++--
 drivers/block/zram/zram_drv.c    | 12 ++++++------
 drivers/block/zram/zram_drv.h    |  2 --
 drivers/md/dm-bufio.c            |  4 ++--
 drivers/md/dm-integrity.c        | 10 +++++-----
 fs/iomap/buffered-io.c           |  2 +-
 6 files changed, 16 insertions(+), 18 deletions(-)

-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

