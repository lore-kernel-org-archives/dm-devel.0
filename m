Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5ECC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62B2D64DE0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62B2D64DE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-_Ox-6JwiMWuIijhotUAuOA-1; Thu, 28 Jan 2021 03:39:36 -0500
X-MC-Unique: _Ox-6JwiMWuIijhotUAuOA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE3E1100F357;
	Thu, 28 Jan 2021 08:39:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1D125D9F8;
	Thu, 28 Jan 2021 08:39:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A792D1809CAE;
	Thu, 28 Jan 2021 08:39:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7FuCt007725 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:15:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E0BA7115D342; Thu, 28 Jan 2021 07:15:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAC6C115D345
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1D18805BC3
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:51 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-284-pAN1e1iDOnOhEwekGFnNVA-1; Thu, 28 Jan 2021 02:15:49 -0500
X-MC-Unique: pAN1e1iDOnOhEwekGFnNVA-1
IronPort-SDR: WvQ4CEZw8aG84hvXj/8nnvIbUgQf1gaHStncPvk0m+/huC85IdaMbV/D+kAtqevo/UE2AeaMfS
	pXEXGf/7ZZjmzTsW64YwRjrcU8K7z7M6OXsp1gVzUSWqQ/kW9/ICpIttcDENkDqVCMv8hf/UM/
	rSFOX+VqLv73Pz8hD99X4M0ba0LbhDVR8cvZdOeucAYqeUhbrwtes77tPbIwj2xoxukGQoyC89
	XOkx8QLpmiZSa/TjvPkSsN1njxJIDhBjPZtb+aQDXIT2rN/teOwrX37osLOzXhUNhuS2DdWdak
	Q5M=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="262549237"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:18:57 +0800
IronPort-SDR: gqALGOY24x3vG9rExZQd/Dcr7pSHRgrmepBRmp1tnuTrvLs3stLy10TEAhB1WcEbuqV5qTLuNl
	ClrhOc+FlPVZdFBBDPU+IkXHR4tJWL8GeV3yFDDYorazJunjXRXbnJt1bq+aCG/TpFFYWiqI/r
	ujR8rZET6xCW64pOYlNVd6TFMbCRUSjtka2KVl+U4qL0dIjhtht+BnVUhHZNfemlt6p/YWyTZF
	9toaGpmXcFr3hvUPKQq/jeFlVoisdktY6HdUrFdMWpfW7pOnE1zf4ll9ydvDltU2kWKvGsXgoC
	WQKE/P9uU4c1I62oLLPHQa8m
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 23:00:08 -0800
IronPort-SDR: QLHAdyBGhpMGQ+9sBMvXF0omk88B/E7BRqUoQLtstkadK8XTqcLBOvZ/pjpZSQe5Fab6+IJLIs
	ck58Xl2YqFxcQH934VbGmHAxVZYNpxUZEqIAo35K+cwpiHURts0rCHDJ2TNufJwwd/0szVEfZu
	V2kbFpOqLyVucrhtvqpRhrkBznCSCkx3a3rZqsYu2xJ2ZrJKihugfXyvxYjD/F6eNL2QYyPhq5
	GySOsYgZ6Jfrk4o/qsLABBe1b7+pVB/jDQ0aaMBZEhc+3I3KzSll4D3O/V1q5DDbYD+ht9Zxf5
	kSQ=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:15:48 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:29 -0800
Message-Id: <20210128071133.60335-31-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 30/34] hfsplus: use bio_new in
	hfsplus_submit_bio()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/hfsplus/wrapper.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 0350dc7821bf..8341ee6c9b31 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -64,10 +64,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	offset = start & (io_size - 1);
 	sector &= ~((io_size >> HFSPLUS_SECTOR_SHIFT) - 1);
 
-	bio = bio_alloc(GFP_NOIO, 1);
-	bio->bi_iter.bi_sector = sector;
-	bio_set_dev(bio, sb->s_bdev);
-	bio_set_op_attrs(bio, op, op_flags);
+	bio = bio_new(sb->s_bdev, sector, op, op_flags, 1, GFP_NOIO);
 
 	if (op != WRITE && data)
 		*data = (u8 *)buf + offset;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

