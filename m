Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B27CC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3798206F8
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3798206F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-N2Fe6_wpPkW5eWGCR0UXAg-1; Tue, 19 Jan 2021 00:11:20 -0500
X-MC-Unique: N2Fe6_wpPkW5eWGCR0UXAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6382810054FF;
	Tue, 19 Jan 2021 05:11:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46AE660BF1;
	Tue, 19 Jan 2021 05:11:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E6D7B1809C9F;
	Tue, 19 Jan 2021 05:11:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5BEKY021676 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:11:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BA1DB2166B2E; Tue, 19 Jan 2021 05:11:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2C062166B2C
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:11:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B5CA101A561
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:11:11 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-315-4ypFHnh_PZuqXiJtb9mYYQ-1; Tue, 19 Jan 2021 00:11:07 -0500
X-MC-Unique: 4ypFHnh_PZuqXiJtb9mYYQ-1
IronPort-SDR: hYTYh1vhacz5n4sNHm7nNR302unKm4FfwnZXT3h0WBtfoPTw6zBh7KTY/NQjA2FCtwHZ1+//Y9
	nSyFs7z0Kjp+SpbfUsACVGbjfzQg5Ra0K90b7LC2fUowyMCOQMI5vxiK3mCueCQN61eB9BI9rM
	Nlq2glgKB0Jaa7nJKzKOt9xONwiNM4FT1Ww6Q3cVQQvW2WPfd01M8aEuuwmO7VCPWFebUyirOJ
	KZ/IluARu2VWIMGWa+QMbEaKHUk/bZmsbjWRJXcyTJHaUKbRcAvhfvL1wdurdWAAyb8FxuW0ca
	dWM=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="158940822"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:11:05 +0800
IronPort-SDR: 2wd2T5ep+Fb56QtmID46E12Mo28tR3o762k9G+ZplXKbM+BFi6d2tXU7zdlpw2t7Z3an9fHeKi
	lOhfPWDgWys1hqnimw5xSw1NzaGvEpzGWPZkFf0w9VghjrD0w2zQX9SV1SD+nb6+2JRamrW822
	l6VFbVUrcl9NsqjDPndhr9P3wLeULCO2wY+U0SK9v9wt/i2SyQZ0LURgMc8OlzedOiOYO/0r/M
	3oJ12nzkRmmPm5Gwud8xcPNR2RVoZ5vJEppORLya7r/0Ljt+Fwu0e6XzGKAIoJXnEG2xGCLxb9
	p/XDf2L5hpsEPriJSb2Dk3SI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:55:42 -0800
IronPort-SDR: JhXhgWS0+e3HTDStYfAXJ39RQBEk0euVnqe58ziJOnn1c9Zev+zyQZ1feT8Pf3jy1k/0jfejeB
	9eRQsJQYlpsXL/MQdwG+RKeojvlhwZb7/kK3K8LYVIUeWuWwf4teK/xrJ6FiTzChv1xe4/bY5+
	eWHUFZ+nWTw4YtzlPxnn6S3DZ4LcVreyfhizYCPM9a4WY7tqwq6bMPlFdYm38BooiwkcJvUlM2
	jto6KJJwnZYWpzG78qeBvec0imqsf+1kIqtJBGsfGtjSerNFR4ZUCja3e3hANc2sx71Lno1zNp
	h1M=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:11:05 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:31 -0800
Message-Id: <20210119050631.57073-38-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 37/37] xfs: use bio_init_fields in xfs_log
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
 fs/xfs/xfs_log.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa2d05e65ff1..062ee664a910 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1702,10 +1702,8 @@ xlog_write_iclog(
 	}
 
 	bio_init(&iclog->ic_bio, iclog->ic_bvec, howmany(count, PAGE_SIZE));
-	bio_set_dev(&iclog->ic_bio, log->l_targ->bt_bdev);
-	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
-	iclog->ic_bio.bi_end_io = xlog_bio_end_io;
-	iclog->ic_bio.bi_private = iclog;
+	bio_init_fields(&iclog->ic_bio, log->l_targ->bt_bdev,
+			log->l_logBBstart + bno, iclog, xlog_bio_end_io, 0, 0);
 
 	/*
 	 * We use REQ_SYNC | REQ_IDLE here to tell the block layer the are more
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

