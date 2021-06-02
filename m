Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37FEC47083
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:06:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88FC5610CB
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88FC5610CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-ghVfh59iMuCn5icvXKDoOA-1; Wed, 02 Jun 2021 03:06:48 -0400
X-MC-Unique: ghVfh59iMuCn5icvXKDoOA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B79C8042B9;
	Wed,  2 Jun 2021 07:06:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B41925D6CF;
	Wed,  2 Jun 2021 07:06:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45B0E44A59;
	Wed,  2 Jun 2021 07:06:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15276bge018448 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 03:06:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F0A37BE5D1; Wed,  2 Jun 2021 07:06:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB5A0B550D
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:06:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33D5590DE38
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:06:34 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-14-VWKr2X3VOxi0X0pRR5Imvw-1; Wed, 02 Jun 2021 03:06:30 -0400
X-MC-Unique: VWKr2X3VOxi0X0pRR5Imvw-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKlB-0025F3-IY; Wed, 02 Jun 2021 06:53:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:15 +0300
Message-Id: <20210602065345.355274-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org, Alex Dubov <oakad@yahoo.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Geoff Levand <geoff@infradead.org>, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] simplify gendisk and request_queue allocation for blk-mq
	based drivers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

this series is the scond part of cleaning up lifetimes and allocation of
the gendisk and request_queue structure.  It adds a new interface to
allocate the disk and queue together for blk based drivers, and uses that
in all drivers that do not have any caveats in their gendisk and
request_queue lifetime rules.

Diffstat:
 block/blk-mq.c                      |   91 +++++++++++++++-------------------
 block/blk.h                         |    1 
 block/elevator.c                    |    2 
 drivers/block/amiflop.c             |   16 +-----
 drivers/block/aoe/aoeblk.c          |   33 ++++--------
 drivers/block/aoe/aoedev.c          |    3 -
 drivers/block/ataflop.c             |   16 +-----
 drivers/block/floppy.c              |   20 +------
 drivers/block/loop.c                |   19 ++-----
 drivers/block/nbd.c                 |   53 +++++++------------
 drivers/block/null_blk/main.c       |   11 +---
 drivers/block/paride/pcd.c          |   19 +++----
 drivers/block/paride/pd.c           |   30 ++++-------
 drivers/block/paride/pf.c           |   18 ++----
 drivers/block/ps3disk.c             |   36 +++++--------
 drivers/block/rbd.c                 |   52 ++++++-------------
 drivers/block/rnbd/rnbd-clt.c       |   35 +++----------
 drivers/block/sunvdc.c              |   47 ++++-------------
 drivers/block/swim.c                |   34 +++++-------
 drivers/block/swim3.c               |   33 +++++-------
 drivers/block/sx8.c                 |   23 ++------
 drivers/block/virtio_blk.c          |   26 ++-------
 drivers/block/xen-blkfront.c        |   96 ++++++++++++++----------------------
 drivers/block/z2ram.c               |   15 +----
 drivers/cdrom/gdrom.c               |   45 +++++++---------
 drivers/md/dm-rq.c                  |    9 +--
 drivers/memstick/core/ms_block.c    |   25 +++------
 drivers/memstick/core/mspro_block.c |   26 ++++-----
 drivers/mtd/mtd_blkdevs.c           |   48 ++++++++----------
 drivers/mtd/ubi/block.c             |   68 ++++++++++---------------
 drivers/s390/block/scm_blk.c        |   21 ++-----
 include/linux/blk-mq.h              |   24 ++++++---
 include/linux/elevator.h            |    1 
 33 files changed, 386 insertions(+), 610 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

