Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880C5C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E40DF64DDB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E40DF64DDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-dJsohWo7O3yZwkMCB0P0mA-1; Thu, 28 Jan 2021 03:39:21 -0500
X-MC-Unique: dJsohWo7O3yZwkMCB0P0mA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 155FC80A5EE;
	Thu, 28 Jan 2021 08:39:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E961A60C5F;
	Thu, 28 Jan 2021 08:39:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BBDE61809CA6;
	Thu, 28 Jan 2021 08:39:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7FDZB007664 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:15:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8ABAC2166B2E; Thu, 28 Jan 2021 07:15:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83AD02166B2B
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA458101A560
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:08 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-426-2iNNbL6JMqOlZ7d_tnelPw-1; Thu, 28 Jan 2021 02:15:04 -0500
X-MC-Unique: 2iNNbL6JMqOlZ7d_tnelPw-1
IronPort-SDR: Ig3M1JxRa8gf4MUenTw1YssI0nd+DXtYAsc7M3iGzJ8ZvxsK1xzhkojhlCb3ex6rOKhDDtNNNd
	f55m1W7xK2ClGKsExy1BouGzjmz9y9tM2BW7hF/etXOu0arktkhXJ2nRt86KYTaJxMPCwD9xBC
	/sWJLW0QxNFgrtHnTu/0hvyxKtHdgEPpoQ+y4efqOYpjaSiYiHDqywPrxf81/cRKbxqo1lihOe
	wkzjqSEuW9jABtDTsWknqM+lJ/LpVYX4c0k544ihTF+0FE3Mb3ywhHQ/lUU5xMtS83lvlWRZx5
	Kik=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="268892611"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:15:02 +0800
IronPort-SDR: 2uJdW7IYev372MVN5EDKrFbXI8UmLyPHg164vWAkBxj6HgGdJdLKr9xnwcSJmP4Xrjjql0a+yC
	5WVITh89pcDYTSzMLJOK0jV4Z7gmzKgttq+dAcpl2ITAC09WKS5MsXomSfk3eh9lWaoNfkT0qW
	ele+Nz5ZYyHxcVHGxGw2z03jZsE0h2VhEVj9kVTjs3ksEIJf+T/tPVXB+gLJE0gRjuoin2CrAj
	A1yKXz3AMznJyzR6DqNkme/ZIztvNi6JiZTBzzHr2GDkINaeNkECVG0ZbXLu/22KxsvupjCs85
	awol+zanKdp9vmwcdR2SNdTQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:59:22 -0800
IronPort-SDR: RvbuIrKpOmmqZ+oQPbnvg4P9b6yDctCj11PDSHseFUe3NzGe7aNswGzNT7aYrNNymGc7RRLBwA
	EyS5TC5ya2f1DBzchV289rrRJN4G30R6UcKQHWHLCT1EqyVYm8BdK2p8B74xj927ubYpSXJJYX
	yqNCzY6cgWt8a45E/OUvNDiMBg+lmhS8FA2ZqgTfl/62S3ZiS0x0JS7q7oikS9hfGQV2kW1Mb+
	vR4fnDhlmPbHKapqq2eTmDAeG1Ipck513pFwPBeDtMk5IkG3qgl83KvWp5povuzxSWxrnJjDon
	5kw=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:15:02 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:23 -0800
Message-Id: <20210128071133.60335-25-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Subject: [dm-devel] [RFC PATCH 24/34] fs/nilfs: use bio_new
	nilfs_alloc_seg_bio
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
 fs/nilfs2/segbuf.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 1e75417bfe6e..df352cab7a93 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -383,15 +383,9 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 static struct bio *nilfs_alloc_seg_bio(struct the_nilfs *nilfs, sector_t start,
 				       int nr_vecs)
 {
-	struct bio *bio;
+	sector_t sect = start << (nilfs->ns_blocksize_bits - 9);
 
-	bio = bio_alloc(GFP_NOIO, nr_vecs);
-	if (likely(bio)) {
-		bio_set_dev(bio, nilfs->ns_bdev);
-		bio->bi_iter.bi_sector =
-			start << (nilfs->ns_blocksize_bits - 9);
-	}
-	return bio;
+	return bio_new(nilfs->ns_bdev, sect, 0, 0, nr_vecs, GFP_NOIO);
 }
 
 static void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *segbuf,
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

