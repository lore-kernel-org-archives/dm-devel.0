Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8491ACD37AE
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 22:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694817845;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NOT+WM+9qBdm0H59RiMOyHXlGZPrTg2NxDvDKHRnw1o=;
	b=Q6CW/SSwnKQISwV3qM5/P3jwnHgZTMuKdoWZS+Rz0W75cQUpFhlOwnUbROE+QuwqhEd24N
	ErHzofD0ztNfEaQ/5r2lxd1s9y5mIqyEdsBQ99cWryD7DmG9S+OjqGUicT/vG2ibUtJgtQ
	bOKA/R27YzReW+mwd0Q4kMBabkF0GNY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-Lm4e1tgPNzuU8ryfzW9xmA-1; Fri, 15 Sep 2023 18:44:04 -0400
X-MC-Unique: Lm4e1tgPNzuU8ryfzW9xmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EEF482A698;
	Fri, 15 Sep 2023 22:44:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE3B62156A27;
	Fri, 15 Sep 2023 22:44:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7B93194658C;
	Fri, 15 Sep 2023 22:43:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9277C194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 22:43:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82D7F1D0AF; Fri, 15 Sep 2023 22:43:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7ABFC176C3
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 22:43:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CE1382A68B
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 22:43:55 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-nUmSHJEgOgGNnFexKH6COg-1; Fri, 15 Sep 2023 18:43:53 -0400
X-MC-Unique: nUmSHJEgOgGNnFexKH6COg-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1qhHXM-00BUtK-2O; Fri, 15 Sep 2023 22:43:44 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, djwong@kernel.org,
 minchan@kernel.org, senozhatsky@chromium.org
Date: Fri, 15 Sep 2023 15:43:39 -0700
Message-Id: <20230915224343.2740317-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v3 0/4] block: simplify with PAGE_SECTORS_SHIFT
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
Cc: p.raghav@samsung.com, linux-xfs@vger.kernel.org, rohan.puri@samsung.com,
 da.gomez@samsung.com, mcgrof@kernel.org, patches@lists.linux.dev,
 willy@infradead.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 rpuri.linux@gmail.com, kbusch@kernel.org, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Just spinning these low hanging fruit patches I forgot about.

Changes on v3:

 o Add tags for Reviews/acks
 o rebase onto next-20230914
 o Fixes as suggested by Johannes Thumshirn:
   - drop not-needed parens on dm bufio
   - use SECTOR_MASK instead of PAGE_SECTORS - 1 for the zram driver
 o Drop shmem patches as they are already merged / modified

Changes on v2:
                                                                                                                                                                                              
 o keep iomap math visibly simple                                                                                                                                                             
 o Add tags for Reviews/acks                                                                                                                                                                  
 o rebase onto next-20230525 

Luis Chamberlain (4):
  drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
  iomap: simplify iomap_init() with PAGE_SECTORS
  dm bufio: simplify by using PAGE_SECTORS_SHIFT
  zram: use generic PAGE_SECTORS and PAGE_SECTORS_SHIFT

 drivers/block/drbd/drbd_bitmap.c |  4 ++--
 drivers/block/zram/zram_drv.c    | 15 ++++++---------
 drivers/block/zram/zram_drv.h    |  2 --
 drivers/md/dm-bufio.c            |  4 ++--
 fs/iomap/buffered-io.c           |  2 +-
 5 files changed, 11 insertions(+), 16 deletions(-)

-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

