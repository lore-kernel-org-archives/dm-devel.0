Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116A0C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 05:55:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8FF37610A3
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 05:55:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8FF37610A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-aE_5SOmXPHuFoey2mKDAKA-1; Mon, 18 Oct 2021 01:54:21 -0400
X-MC-Unique: aE_5SOmXPHuFoey2mKDAKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C0E71842154;
	Mon, 18 Oct 2021 05:54:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39E7910016F4;
	Mon, 18 Oct 2021 05:54:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E7111806D04;
	Mon, 18 Oct 2021 05:54:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19I5s8Sj007313 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 01:54:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A7CA640C1257; Mon, 18 Oct 2021 05:54:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A42F7400F3E3
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:54:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CEC6899EC1
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:54:08 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-270-rKtxURE3PYyY_TMU6OC3Gg-1; Mon, 18 Oct 2021 01:54:06 -0400
X-MC-Unique: rKtxURE3PYyY_TMU6OC3Gg-1
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcKSH-00E3Et-TF; Mon, 18 Oct 2021 04:40:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Date: Mon, 18 Oct 2021 06:40:43 +0200
Message-Id: <20211018044054.1779424-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] futher decouple DAX from block devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Dan,

this series cleans up and simplifies the association between DAX and block
devices in preparation of allowing to mount file systems directly on DAX
devices without a detour through block devices.

Diffstat:
 drivers/dax/Kconfig          |    4 
 drivers/dax/bus.c            |    2 
 drivers/dax/super.c          |  220 +++++--------------------------------------
 drivers/md/dm-linear.c       |   51 +++------
 drivers/md/dm-log-writes.c   |   44 +++-----
 drivers/md/dm-stripe.c       |   65 +++---------
 drivers/md/dm-table.c        |   22 ++--
 drivers/md/dm-writecache.c   |    2 
 drivers/md/dm.c              |   29 -----
 drivers/md/dm.h              |    4 
 drivers/nvdimm/Kconfig       |    2 
 drivers/nvdimm/pmem.c        |    9 -
 drivers/s390/block/Kconfig   |    2 
 drivers/s390/block/dcssblk.c |   12 +-
 fs/dax.c                     |   13 ++
 fs/erofs/super.c             |   11 +-
 fs/ext2/super.c              |    6 -
 fs/ext4/super.c              |    9 +
 fs/fuse/Kconfig              |    2 
 fs/fuse/virtio_fs.c          |    2 
 fs/xfs/xfs_super.c           |   54 +++++-----
 include/linux/dax.h          |   30 ++---
 22 files changed, 185 insertions(+), 410 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

