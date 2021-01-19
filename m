Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01D3C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 20B6E22241
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20B6E22241
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-UZxW6SL1Oaa7ccSc8_R6qg-1; Tue, 19 Jan 2021 00:09:27 -0500
X-MC-Unique: UZxW6SL1Oaa7ccSc8_R6qg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E171801F9A;
	Tue, 19 Jan 2021 05:09:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0FF81F078;
	Tue, 19 Jan 2021 05:09:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B382D50032;
	Tue, 19 Jan 2021 05:09:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J59KC4021048 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:09:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A1B236D9EA; Tue, 19 Jan 2021 05:09:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C8B24411D
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:09:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89C74858280
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:09:20 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-197-9-JP6NY1Mzqsag7Uf3JWVw-1; Tue, 19 Jan 2021 00:09:17 -0500
X-MC-Unique: 9-JP6NY1Mzqsag7Uf3JWVw-1
IronPort-SDR: 1VlEdt/14CxzlCwHZO/Ty5AFKjk2XjKM6wvfpmeywVZKPWxaOcdX2QixcNoYEEyXneksE4SvQy
	pQVmgA+yIN81phSr686GYYOgxpL/Y/tr3dgtsziHZ0F2e2uuOGaH2xZlotCLgk/xKHZkIptYSm
	pa0asLz9zhKcoh8lkar6TXGsZGo+Nt0j+giaCsoBOTMtn0pfMwMEv+lLCkI3szX3bOlDh+oQ8K
	hQ0a7AZuk/80X5DXm900/vbHovi3+03242pZMVuFi3X6XFXHRlIz5fLQDiLANatwd4hzzzHWh9
	piU=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="268081125"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:09:15 +0800
IronPort-SDR: hn9KK+UtI72rDA1ld3DA/iqS4Nk88vXJBbQafLkAqlAXpiXGUj6zAEGT/g+2+HuU4p9GEGG9JN
	Ahq8ePmU5ONJN2nzUvic2sVtrlBZuEdqEBs9kJkT2R0kXdURJe3zRv5vd+8yxOTl9YK2VFxANi
	h4mWs++TDzx5uWjjCg1IGhxqPV+zNg9IspcPXGcEenDY/vDCQw6WLnMaw6A5vXRhHJLFaHQ23A
	+smSrmLsrigLxDjCXRY0j6HNV3szHLsRZezUEAnWQQL/FoLQHRq37Gf5G7d3nXPZGVH7KDOlqf
	b2SSKFRoagBBWhJP04TRlTeh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:53:52 -0800
IronPort-SDR: TUB4fUCiZmYYR74Zcq3vSkW9sI4g+StmmNi9bjrhbbXw9jVqPyfJUUEFsMQdyN9Xq4K6n7Gn8a
	Xr6vVD5OtZEwhLTDm6sJ+DJHPnZcY1k4fpGLKffcDnsEbkcmhWxrNLKyN/hbblQkxxwTcZE2KU
	qYtpp06Bbo/MdAwTBedKhVuo+MaJ3eMXDG6FXDQH5gjW129P5pemibZ8rtfa1SbEY1fp51cPiu
	ZnsBDBB15dkF/zopQoBN7n0qT3SGiHxK3hsHzU8k+P+0nyNJdJcQLu/AX3kBJLLH5SuOOpZND1
	ur4=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:09:14 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:16 -0800
Message-Id: <20210119050631.57073-23-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 22/37] dm-crypt: use bio_init_fields
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
 drivers/md/dm-crypt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 53791138d78b..b03dbcbff491 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1764,9 +1764,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 {
 	struct crypt_config *cc = io->cc;
 
-	clone->bi_private = io;
-	clone->bi_end_io  = crypt_endio;
-	bio_set_dev(clone, cc->dev->bdev);
+	bio_init_fields(clone, cc->dev->bdev, 0, io, crypt_endio, 0, 0);
 	clone->bi_opf	  = io->base_bio->bi_opf;
 }
 
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

