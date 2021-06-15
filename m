Return-Path: <SRS0=rgwX=LJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B263C48BDF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 15:58:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2602160FE9
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 15:58:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2602160FE9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-XIdMP2zIOqecj9E1r935Kg-1; Tue, 15 Jun 2021 11:58:41 -0400
X-MC-Unique: XIdMP2zIOqecj9E1r935Kg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3260800D55;
	Tue, 15 Jun 2021 15:58:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF14E6060F;
	Tue, 15 Jun 2021 15:58:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8EB3C4A717;
	Tue, 15 Jun 2021 15:58:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15FFwSXt019518 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 11:58:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7B0CE11558AA; Tue, 15 Jun 2021 15:58:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73E2E1040859
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 15:58:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D8721825064
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 15:58:25 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-581-OE1p9FgwMQm7A3bwsMZQeQ-1;
	Tue, 15 Jun 2021 11:58:22 -0400
X-MC-Unique: OE1p9FgwMQm7A3bwsMZQeQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 757AD67373; Tue, 15 Jun 2021 17:58:17 +0200 (CEST)
Date: Tue, 15 Jun 2021 17:58:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20210615155817.GA31047@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
	<20210602065345.355274-10-hch@lst.de>
	<CGME20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61@eucas1p1.samsung.com>
	<13b21a07-b7c7-37db-fdc9-77bf174b6f8f@samsung.com>
MIME-Version: 1.0
In-Reply-To: <13b21a07-b7c7-37db-fdc9-77bf174b6f8f@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Christoph Hellwig <hch@lst.de>,
	Tim Waugh <tim@cyberelk.net>, linux-s390@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Alex Dubov <oakad@yahoo.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Geoff Levand <geoff@infradead.org>,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 09/30] mtd_blkdevs: use blk_mq_alloc_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 15, 2021 at 05:47:44PM +0200, Marek Szyprowski wrote:
> Hi,
> 
> On 02.06.2021 08:53, Christoph Hellwig wrote:
> > Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
> > allocation.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch landed in linux-next as commit 6966bb921def ("mtd_blkdevs: 
> use blk_mq_alloc_disk"). It causes the following regression on my QEMU 
> arm64 setup:

Please try the patch below:

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 5dc4c966ea73..6ce4bc57f919 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -382,6 +382,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	}
 
 	new->disk = gd;
+	new->rq = new->disk->queue;
 	gd->private_data = new;
 	gd->major = tr->major;
 	gd->first_minor = (new->devnum) << tr->part_bits;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

