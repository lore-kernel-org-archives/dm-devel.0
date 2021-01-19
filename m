Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1798FC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7CE3422BE9
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CE3422BE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-A5acfTlVNISfzuCBQsH3UQ-1; Tue, 19 Jan 2021 00:08:59 -0500
X-MC-Unique: A5acfTlVNISfzuCBQsH3UQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D223806668;
	Tue, 19 Jan 2021 05:08:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 009A9669EC;
	Tue, 19 Jan 2021 05:08:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CC55C50033;
	Tue, 19 Jan 2021 05:08:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58rA8020765 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7E8322026D49; Tue, 19 Jan 2021 05:08:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A0C12026D11
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00B68811E76
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:51 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-71-UJCkOxr5PqC4vCDAJVtwKw-1; Tue, 19 Jan 2021 00:08:46 -0500
X-MC-Unique: UJCkOxr5PqC4vCDAJVtwKw-1
IronPort-SDR: ar/D+jtoTuNhPD/p3FEDu0je4YbcAR/A88exSVFZtJFfcm7ILadJtPQl+UT15jz/L7sGnu4ycc
	c8+gW83hpKqr7YL3xog3CI7PVs2otkRz1TaSyW0UYNlMdWXhwJUY1dnIvyFitJwsdPF7P8YiNs
	ZBhhNAMMojJS/k9au8z1vAV4djJQ4DiP8p/ZeY7nZQgYsIgxHuHL06wOApaGcUqJ/M63CQVHKV
	GdnGVjNPfxVvGnbESXxG17Vc3fKK8E6BR4vFBiiHSblbmjtT9UT58nT1CGWbZwjx5IC3xFj/6R
	p5Y=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157763933"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:08:44 +0800
IronPort-SDR: Z2YvtiVg4/r/bdVSE1FEoeXb9tJgQNZxJxqa9yNKqYxAVaZbQz13BHXQ579LmLfiq+htnTxAWT
	M827uuYUTMrOq49PlxBGS2TAZAdP3cWPodfyvRyvGZ03AeEm6F45frwOZlbaGyUFun5R7W2Jtf
	+QNDjCEfhxLmro0GmGr61w2O0QBX+fcXh2PF5ycyFVl5FboW2CI+bRoIsyo8jhM+bUAOmmvgSn
	tov5patqqlyHjkBm/IzUJM/9wV9JEoY5KCZZvQq9duen99iQ55lsDMuMHmGinBJk/b2gtt6F7+
	a3NF5/HmlyqQJlwY3NaspWxX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:53:22 -0800
IronPort-SDR: xHO7HSedCSnJKcraGlp7cKbNn6U0vc/h0J7EqOAnrofU3EEgY4EwjLXGgaVPQ5fUfdFd219vRC
	LbXct13YZVVN6KiDu7+byPcBbjh+W64o6mdrAGqpUIdo+laa5H7zxxeLGqJmYjiZ2ypNwYS6EG
	9RidoyBhQkvm19kb9tceoxELnw81qM1BKYuv80rD63H6aZrLZIzawrq4dPgHk7mfEo+EtG3r5z
	NCmJQgYY2IUYeXtIflYFA9t16yIX5Qq8Uqp9iDzkQXKkZabUiMynH1bRZzCY09gOJtgWn+rlXY
	Wrs=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:08:44 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:12 -0800
Message-Id: <20210119050631.57073-19-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: [dm-devel] [RFC PATCH 18/37] bcache: use bio_init_fields in journal
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
 drivers/md/bcache/journal.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index aefbdb7e003b..0aabcb5cf2ad 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -54,12 +54,10 @@ reread:		left = ca->sb.bucket_size - offset;
 		len = min_t(unsigned int, left, PAGE_SECTORS << JSET_BITS);
 
 		bio_reset(bio);
-		bio->bi_iter.bi_sector	= bucket + offset;
-		bio_set_dev(bio, ca->bdev);
+		bio_init_fields(bio, ca->bdev, bucket + offset,
+				&cl, journal_read_endio, 0, 0);
 		bio->bi_iter.bi_size	= len << 9;
 
-		bio->bi_end_io	= journal_read_endio;
-		bio->bi_private = &cl;
 		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		bch_bio_map(bio, data);
 
@@ -588,6 +586,7 @@ static void do_journal_discard(struct cache *ca)
 {
 	struct journal_device *ja = &ca->journal;
 	struct bio *bio = &ja->discard_bio;
+	sector_t sect;
 
 	if (!ca->discard) {
 		ja->discard_idx = ja->last_idx;
@@ -613,12 +612,10 @@ static void do_journal_discard(struct cache *ca)
 
 		bio_init(bio, bio->bi_inline_vecs, 1);
 		bio_set_op_attrs(bio, REQ_OP_DISCARD, 0);
-		bio->bi_iter.bi_sector	= bucket_to_sector(ca->set,
-						ca->sb.d[ja->discard_idx]);
-		bio_set_dev(bio, ca->bdev);
 		bio->bi_iter.bi_size	= bucket_bytes(ca);
-		bio->bi_end_io		= journal_discard_endio;
-
+		sect = bucket_to_sector(ca->set, ca->sb.d[ja->discard_idx]);
+		bio_init_fields(bio, ca->bdev, sect, NULL,
+				journal_discard_endio, 0, 0);
 		closure_get(&ca->set->cl);
 		INIT_WORK(&ja->discard_work, journal_discard_work);
 		queue_work(bch_journal_wq, &ja->discard_work);
@@ -774,12 +771,10 @@ static void journal_write_unlocked(struct closure *cl)
 		atomic_long_add(sectors, &ca->meta_sectors_written);
 
 		bio_reset(bio);
-		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
-		bio_set_dev(bio, ca->bdev);
 		bio->bi_iter.bi_size = sectors << 9;
 
-		bio->bi_end_io	= journal_write_endio;
-		bio->bi_private = w;
+		bio_init_fields(bio, ca->bdev, PTR_OFFSET(k, i), w,
+				journal_write_endio, 0, 0);
 		bio_set_op_attrs(bio, REQ_OP_WRITE,
 				 REQ_SYNC|REQ_META|REQ_PREFLUSH|REQ_FUA);
 		bch_bio_map(bio, w->data);
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

