Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80710C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E840622BE9
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E840622BE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-geEpa7EVM5a4hQu5KVRQSw-1; Tue, 19 Jan 2021 00:09:16 -0500
X-MC-Unique: geEpa7EVM5a4hQu5KVRQSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8805107ACF6;
	Tue, 19 Jan 2021 05:09:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBF78709AB;
	Tue, 19 Jan 2021 05:09:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 913021809CA2;
	Tue, 19 Jan 2021 05:09:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J599sT020924 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:09:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C973D6D9D9; Tue, 19 Jan 2021 05:09:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3F8A63AFA
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:09:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3123B101A53F
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:09:07 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-521--iS_nJC5OYe6tPMN7ga96w-1; Tue, 19 Jan 2021 00:09:01 -0500
X-MC-Unique: -iS_nJC5OYe6tPMN7ga96w-1
IronPort-SDR: LTHcBerioiOywzW0h8dZoWP0sU0sg0JoAKJw2AylDoCLVwZYk30mkkan56j6A7MrFaZvckVisF
	bAU+Cqw/k29yGwpWbvH5jdyyl/rOKxeaP2eE7MoJOl8SlvaYs+hFWMY46TyKAMolpo+FQ/Luee
	+pb5EbQz5AxLVrxgijaKeF1I5qkNzPIqJOzIHM27JAGEfbcYAZ59r7Ra6o2n9Sn445PZJymXNz
	t03yWCtLWA3dOU8wksqY2EZcKd32OhPBv+YjUoU0QlPS5efg5QHoJD1wIqzNwKnMmX6hg3iCda
	ikg=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="162201137"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:08:58 +0800
IronPort-SDR: E80q2F6MNksuklPW0UN4u9Xvn8JT3vevYyaDqQfIylTl/46PaXgtYCoZggwjt5O7z9sZ+Q6bmY
	smKRNCEv5jCWjnSh0aWm0GEZWOn64XeTUa5atUUqmHozLY4L+XpgJnKlaWgmwKlwBTi2Uy+MPM
	7LjnM8CqSTxi9kev0YIQfQbHDzadzVF+vks7suD/nK3LVca+7fsLkFjRtpEont2EgYL/S2ewfs
	cdy9EJtBdMhuAJzeXHsevZdPPqyKshSfzKNdBF+LZPkSzp/EDOQbSfK5cB1yA23F+MN9SzRvme
	Xba0CG/z6XcCZQSdt2MihaTW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:53:36 -0800
IronPort-SDR: jlVjSrblz306Hto1pLF+Ht0EEquCddwQbUHFuCddrqoN07zLTxnOBCPrasx6QzbFI3wH8LUOM6
	f1riISJo1ZfVD8XFhKudLwqjNPGTk45UkBknW/fvY8/YSLAFyl7p/oEVvVwMk/Qs1/83QCrF4q
	ATtQzOiVpqAKtEILRicfThLBsahVfoN7j2kdMa4Kjuo9XbLFp402k/0XWqZ4GyoE/rJecEZ36T
	8WqaSeI83mvc1WGr9SQTI7cT3Gl1099yvZzXS5oMJnA3jan5x1SLdjiEGtr/xqjinEgosWxBG6
	/Qk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:08:58 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:14 -0800
Message-Id: <20210119050631.57073-21-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 20/37] bcache: use bio_init_fields in
	writeback
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/md/bcache/writeback.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index a129e4d2707c..e2b769bbdb14 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -358,10 +358,8 @@ static void write_dirty(struct closure *cl)
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
 		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
-		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
-		bio_set_dev(&io->bio, io->dc->bdev);
-		io->bio.bi_end_io	= dirty_endio;
-
+		bio_init_fields(&io->bio, io->dc->bdev, KEY_START(&w->key), NULL,
+				dirty_endio, 0, 0);
 		/* I/O request sent to backing device */
 		closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 	}
@@ -471,10 +469,10 @@ static void read_dirty(struct cached_dev *dc)
 
 			dirty_init(w);
 			bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
-			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
-			bio_set_dev(&io->bio,
-				    PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
-			io->bio.bi_end_io	= read_dirty_endio;
+			bio_init_fields(&io->bio,
+				PTR_CACHE(dc->disk.c, &w->key, 0)->bdev,
+				PTR_OFFSET(&w->key, 0), NULL,
+				read_dirty_endio, 0, 0);
 
 			if (bch_bio_alloc_pages(&io->bio, GFP_KERNEL))
 				goto err_free;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

