Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3766C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F365C64DE1
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F365C64DE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175--FayBtLJOK2RB-v9lFJhZA-1; Thu, 28 Jan 2021 03:39:26 -0500
X-MC-Unique: -FayBtLJOK2RB-v9lFJhZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29E1280DDE9;
	Thu, 28 Jan 2021 08:39:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ACD360C6D;
	Thu, 28 Jan 2021 08:39:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C6EC41809CA9;
	Thu, 28 Jan 2021 08:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7EYJv007594 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:14:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 46A802166B2B; Thu, 28 Jan 2021 07:14:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40F3F2166B2A
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:14:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAB06858EEC
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:14:31 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-550-GiXn-RmxPY6ANrQkaVZ_oQ-2; Thu, 28 Jan 2021 02:14:27 -0500
X-MC-Unique: GiXn-RmxPY6ANrQkaVZ_oQ-2
IronPort-SDR: X2M/HGxvi7YqtDqTNxgG59KyTVVAKa6bEmXtzL2DnZ4irRoij8EdZ3hmjZ2iY7MGwRmg6OE487
	BSILSh+wa3GcJXvF1j/QR2K9B+mqmqTbmLGq590RK4zVY4MzoZ/t/qolzSamAd7j5tMNKPejDC
	xjF6hvCFYrBkbA81ffwLzGmOZ3nAjA2UCUfxcnwB7SWAytvyitJ7zzwsJQakP+eajJ4Hbgeqmh
	0i+TRewJ8agf/sRSmYvdc9cxpSC1wevF4+y2k7h4zTuHKkAZ6DTvkbGz77wcvDdhoClTn+Vc+4
	hEo=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="159693925"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:14:26 +0800
IronPort-SDR: e3FXjfI+VbJPdrgEWS15vVANxC0DBXggwo3c8c9vkNatBhXdNkJdmS7/WcTcYbh8RbwNIcs7PZ
	/7kmLIMJEPnmMpHBHYPd7gJ2UAUgjwYtf6HmYeYZWfbhB8n8lrdzLJe/PB4pVzhH1Ykui/uDfM
	vHKYuSkFe27RHcu8Suo8wY3jRXRgB0QZ4yzDOJKEBJC/ooQoc6olxHqL1kdijWRFozPTDnlj6l
	Ng6BZLeJnJBoHBfzP5jh4jslFyHc2UPZCbwTyzVucin6yXGPtARbXfTFo8vqxdvYVGxLdKktiG
	OrODM+N3Xig80uX+kqC7+mco
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:58:46 -0800
IronPort-SDR: 8zWpKV1GG73An1zpnhB0A6RHwKcvj53Vuxf9sCqOuA5ZBa5rmYze0QOVvU8HXRv/G7xpZnMIM1
	owK+1cH03BzVuf34Vf4nPTxb3MJRxKHU7MPVsfYKBvoE5U6OUm3WvlKRFiuZT6me2l9YBpl9Dw
	srBAVfHgvdy6RitQaBWTWMkJB+swHKrWKKu/bnpunnMHs5/vTt80z06ovpDFKB7vDmFytTZ38T
	a/jEmxYBTtNgI1MsJxovm0Lez6j5sfQFarO3Hedm9NgwCWDpXDWzTcx88c/FgbEiOtdVVLfaVV
	avQ=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:14:26 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:18 -0800
Message-Id: <20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 19/34] fs/jfs/jfs_logmgr.c: use bio_new in
	lbmRead
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
 fs/jfs/jfs_logmgr.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 9330eff210e0..4481f3e33a3f 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1979,17 +1979,14 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bp->l_flag |= lbmREAD;
 
-	bio = bio_alloc(GFP_NOFS, 1);
-
-	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
-	bio_set_dev(bio, log->bdev);
+	bio = bio_new(log->bdev, bp->l_blkno << (log->l2bsize - 9),
+			REQ_OP_READ, 0, 1, GFP_NOFS);
 
 	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
-	bio->bi_opf = REQ_OP_READ;
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
 		bio->bi_iter.bi_size = 0;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

