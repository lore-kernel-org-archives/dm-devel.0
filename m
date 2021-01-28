Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CECC433E6
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E14FF64DD9
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E14FF64DD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-QwkVopVWMi-vJi0UWLp5jg-1; Thu, 28 Jan 2021 03:39:38 -0500
X-MC-Unique: QwkVopVWMi-vJi0UWLp5jg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0CC085C736;
	Thu, 28 Jan 2021 08:39:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2953722C1;
	Thu, 28 Jan 2021 08:39:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84A9C1809CAF;
	Thu, 28 Jan 2021 08:39:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7G2DW007735 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:16:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CE4C115D347; Thu, 28 Jan 2021 07:16:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18111115D344
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:16:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05B57101A564
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:16:02 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-555-0YcuFxhHMwC3CDqg22K4aA-1; Thu, 28 Jan 2021 02:15:57 -0500
X-MC-Unique: 0YcuFxhHMwC3CDqg22K4aA-1
IronPort-SDR: 9ZO0v54oPZ+VBrkpqQ5wG6sXUB4PpZL5wUrJupPbmWT+/GTxd3YGpaykIfS+XmssYFx+IXKmK9
	d6iKC4T5y16otjnh7+1MDQX1zwBXmzuUgfzJSR8AsNra9UKCB/RrWg5lnvupGV3YDWiImSThZA
	oVn99eWu282vkq6rnYKpvBErHEI9gYT+9yKHSpK8U4XnCIS8KHhX6kk1/Xp1loyCo9gVvlC3ET
	c/WfdjhazhoIIHzKPy4x1Z7c61/sGJ7oDQEO6+6kDDgcj0b6PfDVFHMPD7tKXOwf/2QGbQyWq/
	X6Q=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="262549243"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:19:09 +0800
IronPort-SDR: AyPubC/58opQOxW69XFsj5o1leeeorezyNXzEXI6WyktNagHp8eEoBRXTxZDrPS2HtL1iY9SpX
	BiwLrWoB5gdVwtluYnOJiwFqWEY0/fMB/iXVyOsEQAPemRQmwm3xJkQ6Zsfmie0p3ZerHV709b
	pFEaecgB/3WFjbqD6MHqE+cllOwL3rcPd6zp9rvblXvUvEbyIYHtmKT8zflMX3fZF/vix/lLif
	/Q/4zySl7nQ10H523pg5BAUjIEmsb/9MoTMKlpzZaooG6lGI8OS37jEODOaEX04MGUDPKuBscn
	yuEgskjNUY2TVzpr2DQW6Xgz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:58:14 -0800
IronPort-SDR: MJghY7CI3VIGR5/IaW1FKfL3TP8YTcGZMlKgwb78Me3B/B/3apRuuzh9zoIBvsafPZo8P1zI7O
	tvlMLEPWxNEsao+d+OWmeAfzkHQtyrR4CezWVDYJlrvLmf+2864qvNG9WiZqHSu38lUOwqOgWr
	BwUEJ5wQyzZ3OCyeIORv7uUc6VzLa9ZZ6RiC/IlKAQuXNbiGRl7btRhvnWciISjEw6c6WHvSr7
	U7MWRK7LEz7DNkLYA3LIdhi5N4PJW+ftjhgTNZ5eyVeVGIhgT6If8NwOmXnpUTI7IymY6dp08v
	5GE=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:15:56 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:30 -0800
Message-Id: <20210128071133.60335-32-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:55 -0500
Cc: shaggy@kernel.org, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com,
	tiwai@suse.de, djwong@kernel.org, gustavoars@kernel.org,
	joseph.qi@linux.alibaba.com, pavel@ucw.cz,
	alex.shi@linux.alibaba.com, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, mark@fasheh.com,
	osandov@fb.com, ebiggers@kernel.org, ngupta@vflare.org,
	len.brown@intel.com, chaitanya.kulkarni@wdc.com,
	konrad.wilk@oracle.com, ming.lei@redhat.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	jaegeuk@kernel.org, konishi.ryusuke@gmail.com,
	bvanassche@acm.org, axboe@kernel.dk, damien.lemoal@wdc.com,
	tytso@mit.edu, akpm@linux-foundation.org,
	martin.petersen@oracle.com, rjw@rjwysocki.net,
	philipp.reisner@linbit.com, minchan@kernel.org, tj@kernel.org,
	lars.ellenberg@linbit.com, jth@kernel.org,
	asml.silence@gmail.com, jlbec@evilplan.org, roger.pau@citrix.com
Subject: [dm-devel] [RFC PATCH 31/34] iomap: use bio_new in
	iomap_readpage_actor
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/iomap/buffered-io.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 16a1e82e3aeb..08d119b62cf5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -241,6 +241,9 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	struct page *page = ctx->cur_page;
 	struct iomap_page *iop = iomap_page_create(inode, page);
 	bool same_page = false, is_contig = false;
+	struct block_device *bdev = iomap->bdev;
+	unsigned opf = ctx->rac ? REQ_RAHEAD : 0;
+	unsigned op = REQ_OP_READ;
 	loff_t orig_pos = pos;
 	unsigned poff, plen;
 	sector_t sector;
@@ -285,19 +288,14 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
-		ctx->bio = bio_alloc(gfp, min(BIO_MAX_PAGES, nr_vecs));
+		ctx->bio = bio_new(bdev, sector, op, opf, gfp, nr_vecs);
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
 		 * what do_mpage_readpage does.
 		 */
 		if (!ctx->bio)
-			ctx->bio = bio_alloc(orig_gfp, 1);
-		ctx->bio->bi_opf = REQ_OP_READ;
-		if (ctx->rac)
-			ctx->bio->bi_opf |= REQ_RAHEAD;
-		ctx->bio->bi_iter.bi_sector = sector;
-		bio_set_dev(ctx->bio, iomap->bdev);
+			ctx->bio = bio_new(bdev, sector, op, opf, orig_gfp, 1);
 		ctx->bio->bi_end_io = iomap_read_end_io;
 	}
 
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

