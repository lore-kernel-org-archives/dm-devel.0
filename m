Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B26C433E9
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:40:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6CCB164DE5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CCB164DE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-0Ob9o60hOaWtRaDC9OD-Vg-1; Thu, 28 Jan 2021 03:39:32 -0500
X-MC-Unique: 0Ob9o60hOaWtRaDC9OD-Vg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E26858145FB;
	Thu, 28 Jan 2021 08:39:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C58EF60C6D;
	Thu, 28 Jan 2021 08:39:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 99D4C1809CB2;
	Thu, 28 Jan 2021 08:39:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7FU9w007696 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:15:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 13C2A2026D76; Thu, 28 Jan 2021 07:15:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EE9A2026D48
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF30D187504F
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:29 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-573-Euhj9LeZPmq0H6v2-BYVtQ-1; Thu, 28 Jan 2021 02:15:25 -0500
X-MC-Unique: Euhj9LeZPmq0H6v2-BYVtQ-1
IronPort-SDR: ePAnOFJ8nBCW/5weBcO1e/IhxrdRX+tPyzn6V9ujMg9RFO5I0qO8r3lVmoMUYmOzZOMOYp5i8+
	9wurbL0Q1ivcv0hEhkHe4RINXdARrrvnncWDLYLubzfgSDM6M8pAJFIxvu0qyTj+gFZUmWicU9
	Sjkh2mz0aol1bRmO16612EBLhYZz+Xidmy3xihH6h0geFO85rkhWzhkbQ/6ROWQlqekvXC2iRW
	6NXbj4enSFuk19frkPTtpnSrGArRHpzkn+7bpXZrnxOx7REs/VBKLQdaeAtYLZm/P4AhEKKpSh
	g/8=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="262549176"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:18:21 +0800
IronPort-SDR: 3iuuGdjGs6ZaULW5DOpy6/TujJnx882W+kznjkQht/vS1lQWTVpyLRZsuUBnT4ANgb3hksfw43
	BflYI7Kv1tbvyFjJrrAEBk9m9COuyFD5JES3W01y61Afi/bCUuJ1qI3X9PqXVQ8sehbiCpjtEO
	gPLk+TfgCP0mGxcZZvRn41veFjo0r9faTNI5NaTwON3o6MVtiWANv5G79uitJMQcpc8MzLvSWi
	c6CNwu263wMpk135LpxwALFLTdonsyKmTJw3e98QEnBNhsgw8t+Chdsy5nh16JeFQluywB+x39
	pVly14iKJjsTaoR6PuBCJU/l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:57:42 -0800
IronPort-SDR: AdKYJH34AY4CiVzOXrR15FurWGZi/qDC6z/alYko7jfVcX/SfFhaxUFqHY45DLkP4HiXq60mY4
	qy4n2aJHjpVtmV4fSh3ShuNif1qvectRI2b9x90Cd2PVCzWhg42ZluTJX4mv+bwQtY61xYcAp/
	v9bG8JoB/eY2HEcD52Jlws++S0SYBgnZiIiDuQlpbjK+vhOG1JlBdY+QSI5Hl4fkjAcjiES8aY
	m35tunBPrJVbQ/UTOrTX0lDDjwM/GyWBlapp84/HLby91yE2yFuR9fqy9YimXKC2AojA6XdL7Z
	KBU=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:15:24 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:26 -0800
Message-Id: <20210128071133.60335-28-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: [dm-devel] [RFC PATCH 27/34] xfs: use bio_new in xfs_buf_ioapply_map
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index f8400bbd6473..3ff6235e4f94 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1507,12 +1507,10 @@ xfs_buf_ioapply_map(
 	atomic_inc(&bp->b_io_remaining);
 	nr_pages = min(total_nr_pages, BIO_MAX_PAGES);
 
-	bio = bio_alloc(GFP_NOIO, nr_pages);
-	bio_set_dev(bio, bp->b_target->bt_bdev);
-	bio->bi_iter.bi_sector = sector;
+	bio = bio_new(bp->b_target->bt_bdev, sector, op, 0, nr_pages,
+		      GFP_NOIO);
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
-	bio->bi_opf = op;
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

