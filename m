Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B875C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA8CA22D71
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA8CA22D71
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-XVo4ce1NM3SHNk55nImNWw-1; Tue, 19 Jan 2021 00:08:20 -0500
X-MC-Unique: XVo4ce1NM3SHNk55nImNWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AC4BAFA81;
	Tue, 19 Jan 2021 05:08:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CD6E7048B;
	Tue, 19 Jan 2021 05:08:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2F4BD5002E;
	Tue, 19 Jan 2021 05:08:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58Dpv020485 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8BD0F2166B2B; Tue, 19 Jan 2021 05:08:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8555D2166B2D
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 713CB800969
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:13 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-464-c1PBr3DgPK-4UjKPU-1sJQ-1; Tue, 19 Jan 2021 00:08:09 -0500
X-MC-Unique: c1PBr3DgPK-4UjKPU-1sJQ-1
IronPort-SDR: xf1+e2zuaYnD00G1wZiM21zMfji9aC91/kq4AC6Jt+4HCFD8ZqNO0OzSDcEUDUChULvugTwQip
	rify+kawWLFAT/pnQZ6wCnM3dWdIr5qXzC8tcgcTtg0yeHfUcWgulxRnz5oGTl+4iHQ89deQas
	tvxXnAzBk/Kv+VJtUiYqyY5dX9SXpt6VCLCIDeXuSM22J58wh7vdzmlN1sREmJS4Tm84XtnXNs
	f07iDAEhC/GdigTTHuSbpdhItq4Fb/cQSHGJxRJqIeFvMPfag+qtDhpwHfFYjMeAnMmBlbyoHh
	EfU=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157763877"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:08:07 +0800
IronPort-SDR: yIYtqCr0qDp0MVmufrLFdVUK6E0UiGrG01LXZ7HHDjt5Guwpcpq0XZkz9D/Kz7IouBB5OwOvX1
	jRVnUQdc59/RxqDDJ/lefJd0osTRIX9/Z5yTNPgADuG9Gvi8+4PLFO9OQFGaynXU3aOxY90nsx
	XmdTc8P9dyTBfNaKhrTaQMMRwv/2/fTIJ5BYXN33phsLIWmGd1G6A0vBp/CZPMSUvNAn1t5Q9w
	1Q7mC0cJHutoDZpZql4PHU0vjJv8mzXxUjaaZoBupFvi4C5m7WqnXdk5PXpT4jVrERE+dN12sL
	LNWO+pHqrDBirdEAeHLWjK3a
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:50:42 -0800
IronPort-SDR: BI4IRRImuMT37W/0fgUHv+jo9/cFXOLHBSkHLB71uXGRhjXdqsMAnoeLSicBDzNjCtXE6Dh3IX
	0CYkAjVxbNezhsYqTHeC7O5MKiUI+nte0sRu7g2EHJnUc9MH1BYN8otchvz0lbdHnJk4iU7F4c
	WmfRkOrAtQMZI0QoGyPGUddwOVe1ADf9CPub9wyiRWCIGto1nEeON+Wfy1+NBrAsdMrCFgxnqp
	vom68oJ4IlK86VNF+Hzp5EiJIZpEBG12SHeKkbAPc06Spul2+gAW8LkpVcP5k8qn/tXfmApHrz
	H7o=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:08:07 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:07 -0800
Message-Id: <20210119050631.57073-14-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Subject: [dm-devel] [RFC PATCH 13/37] drdb: use bio_init_fields in actlog
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
 drivers/block/drbd/drbd_actlog.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 7227fc7ab8ed..733679cf456b 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -139,13 +139,10 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	op_flags |= REQ_SYNC;
 
 	bio = bio_alloc_drbd(GFP_NOIO);
-	bio_set_dev(bio, bdev->md_bdev);
-	bio->bi_iter.bi_sector = sector;
+	bio_init_fields(bio, bdev->md_bdev, sector, device, drbd_md_endio, 0, 0);
 	err = -EIO;
 	if (bio_add_page(bio, device->md_io.page, size, 0) != size)
 		goto out;
-	bio->bi_private = device;
-	bio->bi_end_io = drbd_md_endio;
 	bio_set_op_attrs(bio, op, op_flags);
 
 	if (op != REQ_OP_WRITE && device->state.disk == D_DISKLESS && device->ldev == NULL)
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

