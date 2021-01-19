Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1B4C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0860B23119
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0860B23119
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-LnTNkvQNNZyqoHo78nVu1A-1; Tue, 19 Jan 2021 00:10:23 -0500
X-MC-Unique: LnTNkvQNNZyqoHo78nVu1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C01E107ACF6;
	Tue, 19 Jan 2021 05:10:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B3B4669EC;
	Tue, 19 Jan 2021 05:10:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 103FC1809CA3;
	Tue, 19 Jan 2021 05:10:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5AGl3021383 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:10:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2E7702166B2B; Tue, 19 Jan 2021 05:10:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29AE52166B29
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1615D800969
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:16 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-450-DXEzmAhQOmKdUQL3y6p_KQ-1; Tue, 19 Jan 2021 00:10:13 -0500
X-MC-Unique: DXEzmAhQOmKdUQL3y6p_KQ-1
IronPort-SDR: 21Lu/W0P1w6m25tQI9PQQVj26BDBuWCjrqIufaPSPX+zk4EDdMVpeEo6rge/R4u9WHUfTQzDq9
	DIH1iqVp7aTomi3PuxbwEN6kKMG6GCYU1sInB0BDCwUbSvOKq2/hRlzzPDw1Bzr112GxUFQ5gj
	kPOjOtCXcIKvPbfpQBxywJ6t7fxEjDJI/2OcOl7Ee3DdG6jB7eBFUz2FbROfiAzF2DOEBswn5/
	R2TYX4+gtH/sK5U47fhvzDqBzrHphm0wzPBGyB/ij6jzCCYPTRv6o49KXAJNAwr1oXVDmczwcZ
	3tU=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="162201265"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:10:11 +0800
IronPort-SDR: QqdJK0UE6x1UviHjVxnWc05AjuHxGzsQrh6FJGead4FxFaJEJhOg2sApLBvacR4OiCHnoWxEjg
	ewzyZ4l5A4+Zpq63C/2FWdT+jWZdagRnfzm4Mzfw87q5+SKVnc6xN8bz2HMEeP5a06rMd2Mprl
	J7l1PLvhaQhmv9653rZbP/7/bKC2MiD30FZ24QPVFnPRQIlF8S/xqQb7M59ihFWlhIWarnys8U
	vZxgelxEgADbJJMggAYZy40+K7UzuMPUzlJ76XD9ymmPN0k/sAGggOBWB5IxPqu4rYr4+dIJXS
	cpqnZCXBQn2WsGY8OtgEvYhM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:54:48 -0800
IronPort-SDR: sUJEXVVGtr6hdXWriU6va4OHVDFOeCqexBkNQgHd29bupqR1FAk1FagKslaqLW3ZUUxGQzR8Ug
	NtO68JgANUVdRxpoSQWII/hxMhExDp+a994ofqnoDT8BbVyZ1XbW5GYb7r0UZsyIyvfIjO50yw
	MZh/UChC09g0/v2Fmm2Ka8Iym4W7jfv3l61pY/GYFfEKqEthOGPxecFMe1viLbkfMh+TmPOZOJ
	niLv3X9jvTg8OiAwbkqtrE2GRDLktY9HmYFpEeDkaOstLITBHpJmhuyQTx4ICZPfsDRpeUTWvU
	THQ=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:10:11 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:24 -0800
Message-Id: <20210119050631.57073-31-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 30/37] fs: use bio_init_fields in buffer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/buffer.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 32647d2011df..32e9f780e134 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3027,16 +3027,13 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 
 	fscrypt_set_bio_crypt_ctx_bh(bio, bh, GFP_NOIO);
 
-	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
-	bio_set_dev(bio, bh->b_bdev);
+	bio_init_fields(bio, bh->b_bdev, bh->b_blocknr * (bh->b_size >> 9),
+			bh, end_bio_bh_io_sync, 0, 0);
 	bio->bi_write_hint = write_hint;
 
 	bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
 	BUG_ON(bio->bi_iter.bi_size != bh->b_size);
 
-	bio->bi_end_io = end_bio_bh_io_sync;
-	bio->bi_private = bh;
-
 	if (buffer_meta(bh))
 		op_flags |= REQ_META;
 	if (buffer_prio(bh))
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

