Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAB7C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:07:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5532822BE9
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5532822BE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-mdpOgJ-XNQ-uNYpBYJ3ZMg-1; Tue, 19 Jan 2021 00:07:49 -0500
X-MC-Unique: mdpOgJ-XNQ-uNYpBYJ3ZMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E1F5802B48;
	Tue, 19 Jan 2021 05:07:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46CA057;
	Tue, 19 Jan 2021 05:07:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D7DF74A7C7;
	Tue, 19 Jan 2021 05:07:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J57f7c020319 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:07:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0112A2026D11; Tue, 19 Jan 2021 05:07:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F006B2026D49
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:07:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8069F800889
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:07:38 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-383-I7YN_O__OLmHLHD3cSCWcA-1; Tue, 19 Jan 2021 00:07:35 -0500
X-MC-Unique: I7YN_O__OLmHLHD3cSCWcA-1
IronPort-SDR: 7XHnwcM03toui5TkKqv1THQUPEgzeTkj2nWLDro+OHp2Q7lITM+uAKsKJPFjbfU8ng8U2Voj97
	xWT8krTpfpRd3WIvYEWa0hwP3mGR0DgBo6P/3Il7rJRyiQ/j6zW1lDDawoqjDZRQR8w5i4weSZ
	Xo8UEvbtXurC6km0L3JG5L645Ewa07cRjyJ8U/5Ju0nYM1uy5XUcKreDFOO/kPmGJN+GDtdh8A
	fUPUxSFxpWfGAvGCu5SNGnjsI53yXpPmGpVFahmKj5LwNkEXDXt85tQDm+v07T7ibfS4LM+bUR
	9CA=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="162200971"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:07:33 +0800
IronPort-SDR: SfMt0MgzTcNBRybN4UsnfEz9YVdIbPId7iEs1Zuw8hoXkIK8Re9dhNarVzAX3M2tQQj2F2OhR/
	jqtOSUtwMd1BLJ0gQuY5c2Q+N0KzUDVv9xor7soa+XSwbeHJCmQdXsoNnqUlmtsFXhfzxm5+P8
	Pl7JVqkKrNrn2hjAWVo9zUJpxhU833MAB8juNxBXIR02wK/iRZ6ILsh0Ak3jTReR9DQzuKxkGF
	p+2vtewmPFKRLrTH5OPFRi5CbALvANAkikoclkgczljOxePnSPTKKLGhxMyVTJc/PlvCJKjI5t
	9ei10fjiQAUZ/fMA6S/2FLy3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:52:10 -0800
IronPort-SDR: XuHiYNQi6H/F+p2JRpeqvKepY/gWFggYc3PK+RX4NWnH2J++ktvqaZn+XFm15C5dMKrEJfHz0B
	tcx/8H8EcZQjAkvVLLfd960MjBgFb7S9i+JAaGulJ1Ed6y5pQvCWzQsDBAb4mxWFQRcOQm2sQh
	InLeUCQ8BhpQ0hg7T5JV8TxNze71LOROzEztByIwFHi0muZ5jMuDAa0BYs0z85+J0ujkGowHhy
	B7cEPZDWrY2+Vnoe2urCnxNw5+yxuKbmlE5yr1VYKmzFzJMkDPxkr8LEyEvcKah9eb96VGIlX+
	j4Y=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:07:33 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:02 -0800
Message-Id: <20210119050631.57073-9-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 08/37] gfs2: use bio_init_fields in ops_fstype
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/gfs2/ops_fstype.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 61fce59cb4d3..32506d5615f4 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -255,12 +255,9 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 	lock_page(page);
 
 	bio = bio_alloc(GFP_NOFS, 1);
-	bio->bi_iter.bi_sector = sector * (sb->s_blocksize >> 9);
-	bio_set_dev(bio, sb->s_bdev);
+	bio_init_fields(bio, sb->s_bdev, sector * (sb->s_blocksize >> 9), page,
+			end_bio_io_page, 0, 0);
 	bio_add_page(bio, page, PAGE_SIZE, 0);
-
-	bio->bi_end_io = end_bio_io_page;
-	bio->bi_private = page;
 	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META);
 	submit_bio(bio);
 	wait_on_page_locked(page);
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

