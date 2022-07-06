Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E76CCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 07:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657092726;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ye3UuNWwWnTwz8ViK8KmtH+VbviP2L/ub7LdOCXcuaY=;
	b=BdOXG2N5C4yYJiSbW3iyHk3WI3n1a1WAqYnGJRv95X/RQpWDqj4RX7jZMfN3b81j/wUlDI
	bg/hEYzNzLMrweOoE7LIGbMIG7lBuFnCaPzpfwVKiOLHn4eEh/tzuamMbycFf6BngC1FkM
	MFs9O9qyAw9wZtM5mlY+74wPCDd02wE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-6fgrrOraOymd7dJVv-ZpOw-1; Wed, 06 Jul 2022 03:32:03 -0400
X-MC-Unique: 6fgrrOraOymd7dJVv-ZpOw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42C9C802D1C;
	Wed,  6 Jul 2022 07:32:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4E4940315A;
	Wed,  6 Jul 2022 07:32:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9CB4D1947060;
	Wed,  6 Jul 2022 07:32:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A04A61947060
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 07:31:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 65D0540315A; Wed,  6 Jul 2022 07:31:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 61C55492C3B
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 07:31:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A859811E83
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 07:31:59 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-wRcPLtrqNHGLc0_zfkNSZg-1; Wed, 06 Jul 2022 03:31:57 -0400
X-MC-Unique: wRcPLtrqNHGLc0_zfkNSZg-1
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8z4i-006uoJ-K5; Wed, 06 Jul 2022 07:03:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Wed,  6 Jul 2022 09:03:34 +0200
Message-Id: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] clean up zoned device information v2
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
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

this cleans up the block layer zoned device information APIs and
moves all fields currently in the request_queue to the gendisk as
they aren't relevant for passthrough I/O.

Changes since v1:
 - drop the blk-zoned/nvmet code sharing for now
 - use a helper a little earlier
 - various spelling fixes

Diffstat:
 block/bio.c                    |    2 
 block/blk-core.c               |   13 +--
 block/blk-merge.c              |    2 
 block/blk-mq-debugfs-zoned.c   |    6 -
 block/blk-mq.c                 |    2 
 block/blk-mq.h                 |   18 ++---
 block/blk-settings.c           |   11 +--
 block/blk-sysfs.c              |    8 --
 block/blk-zoned.c              |   85 ++++++++++++------------
 block/blk.h                    |    8 +-
 block/genhd.c                  |    1 
 block/ioctl.c                  |    2 
 block/partitions/core.c        |    2 
 drivers/block/null_blk/zoned.c |    8 +-
 drivers/md/dm-table.c          |    6 -
 drivers/md/dm-zone.c           |   86 +++++++++++-------------
 drivers/md/dm-zoned-target.c   |   25 +++----
 drivers/md/dm.c                |    2 
 drivers/nvme/host/multipath.c  |    2 
 drivers/nvme/host/zns.c        |    6 -
 drivers/nvme/target/zns.c      |   14 +--
 drivers/scsi/sd.c              |    6 -
 drivers/scsi/sd_zbc.c          |   10 +-
 fs/zonefs/super.c              |   17 ++--
 include/linux/blk-mq.h         |    8 +-
 include/linux/blkdev.h         |  144 +++++++++++++++--------------------------
 26 files changed, 227 insertions(+), 267 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

