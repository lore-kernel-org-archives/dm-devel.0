Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C9DC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F295F2063A
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F295F2063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-m5UrCmOEObu92blnYDWSDg-1; Tue, 19 Jan 2021 00:08:05 -0500
X-MC-Unique: m5UrCmOEObu92blnYDWSDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70ECB59;
	Tue, 19 Jan 2021 05:08:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55D7B60BF1;
	Tue, 19 Jan 2021 05:08:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 263521809CA0;
	Tue, 19 Jan 2021 05:08:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J57wbA020384 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:07:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F8662166B2C; Tue, 19 Jan 2021 05:07:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9983A2166B29
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:07:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 859B3800B3B
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:07:58 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-556-P4vxatXTOomxeZ8OxjfKWg-2; Tue, 19 Jan 2021 00:07:55 -0500
X-MC-Unique: P4vxatXTOomxeZ8OxjfKWg-2
IronPort-SDR: Fp9n3QNd07s6KFCb3g9pVMFfXs/dru88ivL7OkG5Tk1pWR5c+IjoHlRX6LseyFbgucUaiWoteB
	O/rB0FNFDJp4ld6RE+FQO7I1FZhsc65is1Rh2yRlkOBmdu4vNbNIuRTUq+S9gShj7QLvFQ6rDA
	zEgsgwaT7Kry/fBS7T8OFXRMUAHKR4bgalK/Z/0ACF7zTpHQiMjWz1W0dEZp1ixv9vg8fc7W6/
	hjPnMZDiUQLdTWhkcpLz1yN/nOazqEIf/nn4DTsdxsWW4gTpq1oheg8uoP6hq11YNHFKV889h4
	V4g=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157763856"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:07:54 +0800
IronPort-SDR: KePAyeuJQ5LWIRBKzokQS26MKxpKhs7juBrlBsfDn4JFzCjuEYc2+tYFVSILASnC/JnWFLiegV
	pF4DcN5WpkJthv2ouGGTYP89aWLBJEtBzmAP+7UzcGxL1dRZ6KPXeICPjYG+KjQGE+S/Zf3rPm
	bMGbCB8olCFBvA3f589+feooL0Gx41n0VuJDqnApvJ05SrKAoX+Eeia/oK2K3eCKzV5pu+Uw4a
	BDXGTqs8y3aGq0+02vHPdZSbAzH3r0/HOhlQsD4WRShyCnghRVD6dm6cPRWseyOIkr38f4bnhG
	wGPQo8tEIC7rHz/HtwZ9SqGH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:50:29 -0800
IronPort-SDR: HfWY3om+yf0xJZDCeO7vzX4qVknDvDGJ6ma4/WV7I62vTgKsXgZzhM0ZULmlPQ+OArppKpZagb
	2D+mRhA2IGb1emIpbOZ6FTF970SZgSIja2ei7WMigALEAQdtMpSzVo//nIAbZ1wNVJo/414BKz
	A1WUO/T5vGii4BJKAkPud7zlDfpbr9iZjAmuNFOXPO1Y6zbT0Inzt3aMei0oz3YT9sfu+Dztk5
	Fg0ppCRIMSkEdmvmSQl8FchZI4H3p6KBElZq4HVESV4gQgEhlwohxssYunDRqcI1BVUhdQDk7h
	o0c=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:07:54 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:05 -0800
Message-Id: <20210119050631.57073-12-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 11/37] jfs: use bio_init_fields in logmgr
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
 fs/jfs/jfs_logmgr.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 9330eff210e0..ee7407ca32c0 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1980,15 +1980,11 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 	bp->l_flag |= lbmREAD;
 
 	bio = bio_alloc(GFP_NOFS, 1);
-
-	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
-	bio_set_dev(bio, log->bdev);
-
+	bio_init_fields(bio, log->bdev, bp->l_blkno << (log->l2bsize - 9),
+			log->bdev, 0, lbmIODone, bp, 0, 0);
 	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
 
-	bio->bi_end_io = lbmIODone;
-	bio->bi_private = bp;
 	bio->bi_opf = REQ_OP_READ;
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
@@ -2125,14 +2121,10 @@ static void lbmStartIO(struct lbuf * bp)
 	jfs_info("lbmStartIO");
 
 	bio = bio_alloc(GFP_NOFS, 1);
-	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
-	bio_set_dev(bio, log->bdev);
-
+	bio_init_fields(bio, log->bdev, bp->l_blkno << (log->l2bsize - 9),
+			log->bdev, 0, lbmIODone, bp, 0, 0);
 	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
-
-	bio->bi_end_io = lbmIODone;
-	bio->bi_private = bp;
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
 
 	/* check if journaling to disk has been disabled */
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

