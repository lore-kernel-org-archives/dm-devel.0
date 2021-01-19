Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A310C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07798206F8
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07798206F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-zoqUgd3qNH622F7n4upy3g-1; Tue, 19 Jan 2021 00:11:11 -0500
X-MC-Unique: zoqUgd3qNH622F7n4upy3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10965107ACF5;
	Tue, 19 Jan 2021 05:11:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB36A70471;
	Tue, 19 Jan 2021 05:11:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C0EC11809CA2;
	Tue, 19 Jan 2021 05:11:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5B5tP021628 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:11:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C8F74411D; Tue, 19 Jan 2021 05:11:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73E4C63AFA
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:11:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61C4B811E78
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:11:05 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-537-ezeYQEsrP5OPPzr02iPf8w-1; Tue, 19 Jan 2021 00:11:00 -0500
X-MC-Unique: ezeYQEsrP5OPPzr02iPf8w-1
IronPort-SDR: a9+VdqEfug6gNMKkL+v3njjJvX9UO6uIJPQnyZ7dxR4bdAjuRw61eIrjDETNb5lE/lF4HjEkMZ
	AnNOgl7PSZfv8QsZVa/8fdhxhGra+9ScjJxMuPoldVUzJ7hKUS4Yo7tPUgN9UPBnfjj77nBcHn
	50J7XS6+ySIKjYqM4uWg5Hl1TuLzUrC3rEA76xQtShGmRHvTXxSVHKJhCZWR/dSC2zzrXwGtax
	rlJ5/ZISDdBsoe4nX9NQ9v7qwdzhED02isjrUpXdHDcnuoyDFZl13OX8cPy/ehwGaw610LHTwW
	uVA=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157764105"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:10:58 +0800
IronPort-SDR: HVxCXMrxoHh+mjvfj++XHYI9YgUq4/d0dS2nIpkzIVYIYCMH3P7l6fdjezzGjx2JOm8C5mDtSS
	mKwX15T2TjDB3/xzS0pFM1rwI44OgHZiKTtCtU7wMIblEb/MGGTY42Ev+F9lkmvpeeOfNkSIL8
	UNr7USio7vxDasSfxr42pxC7YC2xdwj6Fqu0qGOo0TO4mlLnGYV4rvDIImdrpvMn5eJWSgQvtO
	UATfqEDraEC2IEQW/3d2/ojOgnT4uG1IvwsLnBF2lXTKsvL/79tcHLPieA6GG4AbOvGZ7bon9C
	qyJBhEDHGX8xJjoIwp2JwnJX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:53:34 -0800
IronPort-SDR: YVg4oetj669oXGPyen5Yz7/4lwwknpBuwOHqtYisxWomXA6swBTRl0Q6a9GaHjktx9T2m6JStb
	CDvwa7TZCZ4M9GVWSo4RbtmgfurnOujjvD4svcphbEiZT+7y+gglJ9ZlIF/tnwxqJkfJFxncIx
	g5wm4nu8oJyzJ24M9klTWymj61zMdpHfpxs6XcMjZOa3vIqm+lJQ5C0tB3xkI9dYlB+E3Ul943
	D49b5EPSkdl17MTuiUi4ULzuOqSv9X94gCd9MvAo2Xb2yDb8OLgPVo7IBgCR+uA44u4+72LP4B
	OSs=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:10:58 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:30 -0800
Message-Id: <20210119050631.57073-37-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
References: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, snitzer@redhat.com,
	gustavo@embeddedor.com, clm@fb.com, dm-devel@redhat.com,
	adilger.kernel@dilger.ca, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, darrick.wong@oracle.com,
	osandov@fb.com, kent.overstreet@gmail.com,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	josef@toxicpanda.com, efremov@linux.com, colyli@suse.de,
	tj@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
	bvanassche@acm.org, agruenba@redhat.com, axboe@kernel.dk,
	damien.lemoal@wdc.com, tytso@mit.edu, martin.petersen@oracle.com,
	song@kernel.org, philipp.reisner@linbit.com,
	jefflexu@linux.alibaba.com, rpeterso@redhat.com,
	lars.ellenberg@linbit.com, jth@kernel.org, asml.silence@gmail.com
Subject: [dm-devel] [RFC PATCH 36/37] xfs: use bio_init_fields in xfs_buf
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
 fs/xfs/xfs_buf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f8400bbd6473..1c157cfc5f8f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1508,10 +1508,8 @@ xfs_buf_ioapply_map(
 	nr_pages = min(total_nr_pages, BIO_MAX_PAGES);
 
 	bio = bio_alloc(GFP_NOIO, nr_pages);
-	bio_set_dev(bio, bp->b_target->bt_bdev);
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_end_io = xfs_buf_bio_end_io;
-	bio->bi_private = bp;
+	bio_init_fields(bio, bp->b_target->bt_bdev, sector, bp,
+			xfs_buf_bio_end_io, 0, 0);
 	bio->bi_opf = op;
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

