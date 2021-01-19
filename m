Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7DBC433E6
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C0F5522241
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0F5522241
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-XFfGUUlLOju-qhcWfI4grQ-1; Tue, 19 Jan 2021 00:09:21 -0500
X-MC-Unique: XFfGUUlLOju-qhcWfI4grQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C428018A9;
	Tue, 19 Jan 2021 05:09:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7345E1F078;
	Tue, 19 Jan 2021 05:09:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 43A5F5002E;
	Tue, 19 Jan 2021 05:09:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J59EIb020987 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:09:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 968332166B2C; Tue, 19 Jan 2021 05:09:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91A532166B29
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:09:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEC461875040
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:09:11 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-514-t55ng4HKMcGQO-HMrCICBQ-1; Tue, 19 Jan 2021 00:09:08 -0500
X-MC-Unique: t55ng4HKMcGQO-HMrCICBQ-1
IronPort-SDR: 79w8o/Ns+LI5rA6FAdvRV/i2Io9rwaJUPDUeBLRmdO4yhBKapTa2I8RbSy2i43f2fElNS8vYZa
	/jDTqMlXKgtgFGLTRVffbgWCNKWkqG1r4K6FO0vKk1w26BkwHPdpEhHC0e0GTaXizWONUGByPx
	nO06oZpkXUzRFP9z+iuljCrerOQ9QQrzCt1YttZADkFBirUoyD+3yLXODwaonlU6kTu5nvoBhK
	pHlggw+S3qSCq0NzzFeKwKGkeUQ+Wi9onMmMs1gw5CUTpCMY5l9ikRzo8JLLGo3ZdupUuoo7FL
	zY8=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="268081105"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:09:07 +0800
IronPort-SDR: T4YCjsI+d+5kBzZsi0a4HBt7cFrztBSpbUAIaYs1bdbici5jPCVGmkDUXV8KrA5ueQzH6qmlpa
	79oUhWR/b3BWufEWkYtf0I1wOTdmY07EOp7yOgfaytlM2B6uF8K05EvK681wWGFfBsAwl8CspV
	XM5jpGAahr9TKn1kHNfdrAAMn4b9EjdFgm0bggJRhYTu/yona0VqJQy1rIxmAMtWGiRwd+WX6O
	CVUMIh7viJcgZbRagND9G958h+xeQJZVCI2esjWusmRJX62g8Le4NK7gP914rs2bERigXz/0fH
	121kcBWIrzVXValpax+DPm8z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:53:44 -0800
IronPort-SDR: YTx2sPI+S6B3s0zwLxmE9JLYYaAYYdsBlTi/QBtBxd/WH8egWo/s2t318EELWraWDHn4aYbSz+
	GTI/c0RV1f+ot/Yyog9omiJsfpSR5vK5KT4IJoKlPtJElbAfKckX/OVaF06ki+8DfWwezcFUha
	cQceDg9EfnRtvtgEBcHMkJqbMz+Hf9lDezVT3gRBkt4FXtAK8F0+3Jw8Dlu3r3MJXdxsm4oEy7
	lej+XAjPd2ZdZGUr333NTWzmm/vXM3I7gj6chGIMLH1v36uCSVr35WYHxwt+NXTGuosML8y4Lr
	Cxg=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:09:06 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:15 -0800
Message-Id: <20210119050631.57073-22-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 21/37] dm-bufio: use bio_init_fields
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/md/dm-bufio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c1a86bde658..1295e7e33e06 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -633,11 +633,8 @@ static void use_bio(struct dm_buffer *b, int rw, sector_t sector,
 		return;
 	}
 
-	bio->bi_iter.bi_sector = sector;
-	bio_set_dev(bio, b->c->bdev);
 	bio_set_op_attrs(bio, rw, 0);
-	bio->bi_end_io = bio_complete;
-	bio->bi_private = b;
+	bio_init_fields(bio, b->c->bdev, sector, b, bio_complete, 0, 0);
 
 	ptr = (char *)b->data + offset;
 	len = n_sectors << SECTOR_SHIFT;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

