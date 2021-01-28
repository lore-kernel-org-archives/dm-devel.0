Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3184C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08A9164DBD
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08A9164DBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-u57ZHoAjNv-FPaFmrGA5cg-1; Thu, 28 Jan 2021 03:39:16 -0500
X-MC-Unique: u57ZHoAjNv-FPaFmrGA5cg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BC6618C89DA;
	Thu, 28 Jan 2021 08:39:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDE5E1992D;
	Thu, 28 Jan 2021 08:39:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD50C1809CA5;
	Thu, 28 Jan 2021 08:39:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7EQJC007581 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:14:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3866D115D345; Thu, 28 Jan 2021 07:14:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 346B4115D344
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:14:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0207D101A562
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:14:24 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-550-IEk-1dsTPqKJjW46Wex29g-1; Thu, 28 Jan 2021 02:14:20 -0500
X-MC-Unique: IEk-1dsTPqKJjW46Wex29g-1
IronPort-SDR: M3n9CxEYVXevf1rnXE1AN0AiiRKYtDEkpcR71OpjqKOHh9H0Vgh5Ar+JzFbeRIJQqzivQ0oNIV
	lW2a2yAAPsSpMQle3lGk1TNbepZadB3dgyxRkF2a1F+rVBxRm8nYeCgG3Q2aZlPmdjLhi5tkcp
	EQtOCZSuov1xGxhr+CucLWyFxo1bS8Zb0TB/NMbWIYVLNIz0HdYXTdFlRORg1bVrxkHN9PQ0Gr
	6EaDnheI31PGq1sXLn1XQ8AdEz2MaKsld9RcV4TQ6NcJ9HedIDIvvPEi01mJxbGsoMS0Jllxkz
	eak=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="159693913"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:14:19 +0800
IronPort-SDR: muLB9qbRIzDo+3bH/hictGHG+9ObzaeOGxBEvWjeCE7B0jwPNl9P53Zj9/LYyyOYhrW6LemJ7b
	P74Oq69yuQaWGnGmYrnvtDwCBmLPL0e2OafM3sR4HMVII9jSgkSiwiSTdwgbEJhH0Xb494rVVX
	iI9GRiqc+pazeJbGuNvXpFVqvt90J+SG5MrpWtrgKaOUU5n9IDBas2YFmCFxWwjqeCayFPt9Qx
	DPqL/gu9PZgB/gnCthwby0hgQgbaHBONJ6IdMro32FhkTB0DNEb34MD2sOGQoWzTh6If/oWOGq
	Hsf/O6wYYwghonmr4E2IO9t3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:58:38 -0800
IronPort-SDR: SE/7jhzj8mUN4IuNpOkC3snrZ8NJ1clnXy6y5ds9FsX94ZBtriQ4uRa7QWKdGcnXbjLMCBoUCV
	muTlW54Qa3qPh6fwMtXMlfwP2+yfKLqOcAu45V7pI+dpenWI0L1OM9udcXtJMTQueAmHig5gDN
	d6OcRwyGrT7GxH48PliS/P58sqmLq3e242QCy6iyXTMgFXRd2EClUAs64FPFphS/GBkZYgQLMx
	xAByTj3G42kPYoeBIsWoRZMAgUwhHcuqehcOxGoJkKVhb66+D9X5hujEyFAgPHDC4Sd1jNsKev
	N7A=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:14:18 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:17 -0800
Message-Id: <20210128071133.60335-19-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 18/34] iomap: use bio_new in
	iomap_dio_bio_actor
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/iomap/direct-io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index f6c557a1bd25..0737192f7e5c 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -267,9 +267,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 			goto out;
 		}
 
-		bio = bio_alloc(GFP_KERNEL, nr_pages);
-		bio_set_dev(bio, iomap->bdev);
-		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
+		bio = bio_new(iomap->bdev, iomap_sector(iomap, pos), 0, 0,
+			      nr_pages, GFP_KERNEL);
 		bio->bi_write_hint = dio->iocb->ki_hint;
 		bio->bi_ioprio = dio->iocb->ki_ioprio;
 		bio->bi_private = dio;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

