Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0602C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 197EF206F8
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 197EF206F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-YW5Faw4lMgivT504viMwWw-1; Tue, 19 Jan 2021 00:11:02 -0500
X-MC-Unique: YW5Faw4lMgivT504viMwWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38D26190A7A1;
	Tue, 19 Jan 2021 05:10:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BDD070474;
	Tue, 19 Jan 2021 05:10:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E697A1809CA0;
	Tue, 19 Jan 2021 05:10:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5Au39021563 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:10:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 627FA4411D; Tue, 19 Jan 2021 05:10:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D3BE63AFA
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D60B1101A560
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:53 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-304-FKXE1hOMNz2MSpWDU0rHGg-1; Tue, 19 Jan 2021 00:10:51 -0500
X-MC-Unique: FKXE1hOMNz2MSpWDU0rHGg-1
IronPort-SDR: 7V0fjYvqk6U5mp0BB+6JwDWbIj6wsD/8w1mHUzszG85rl8Cimw4NzTmm/O+RQc3/TtZcYrIkfm
	qseoZ6Ex+dnRw/WX9cuq4HMZXNaM4xauMlBkEDWYHErEfXU/fwpZpQFEB73Zd63IcNOhC0HnFA
	MzfoUlqFo4tLOBsmoTk0da9u/1P4HBJInvKTP3/NxV3JMfXnHk4j0TatwlYT1rBrBd/2m57E27
	Gs/IXxGFDZ7Y3harZo2mhi1KWtAGlihw0S3ARQtVqWNjofu4InFNUSClRucc/kdd+7psuR0Ken
	ubA=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157764099"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:10:49 +0800
IronPort-SDR: iLYpy22HCoDaOhypfqWm+n1NUXh3TRpC/mwgN5JhUP8me+C9gDJRxNX0xnjxSAV+9i+pbiCc+0
	XrP2Eyb/mDmgdpMDHfCGTH/GJ+gk8GmopqTXfqKVLUhq60d2PSrBagHCGvRHzS/unwFEC0domE
	P3DylCzhMORMgz6uFBdehzYUV4VjsWZaRI9AV1BnwJVsL1xVhbWCxxDjlrNT9BflQpvbhhhCfL
	3t5f8bjDLE44EFVX8DiwJW0WrpAO/deF6mKC2jqjPOA8Ls0HEqFlMrrUwNUEmVqAkoAN+FU90K
	eONrt4J3TTFLOv42HK0vMLHT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:55:26 -0800
IronPort-SDR: l/PshN71cWYbTK1WTMMOJErnyUYZ9w/R4z1nl3IAFxlbXv4liArup+WsFD5ickHhD3utQPm1yk
	sDJR5xYPW7Rk4AOBaj9ddtkrfHNoDjxcLvYwqKoJ+zSMrb2LgwmOyjvRLWCwQh66m+L31DF3GG
	cbQQZKVcF02VZtZcPCLoG656Pl8BFav/PRzS4RekqjE2nR1vtzK5A4F7XeBguGBUnZrVICH30u
	hENXcQH2DncOb3p9BCQrIXCeB58uVf13+u9S+duV8v8olXF+1fRyqTUCKPFMBWOtqHC+TvB1s2
	T2w=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:10:49 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:29 -0800
Message-Id: <20210119050631.57073-36-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 35/37] ocfs: use bio_init_fields in heartbeat
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/ocfs2/cluster/heartbeat.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 0179a73a3fa2..dd37aaac4f32 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -528,10 +528,8 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	}
 
 	/* Must put everything in 512 byte sectors for the bio... */
+	bio_init_fields(bio, reg->hr_bdev, 0, wc, o2hb_bio_end_io, 0, 0);
 	bio->bi_iter.bi_sector = (reg->hr_start_block + cs) << (bits - 9);
-	bio_set_dev(bio, reg->hr_bdev);
-	bio->bi_private = wc;
-	bio->bi_end_io = o2hb_bio_end_io;
 	bio_set_op_attrs(bio, op, op_flags);
 
 	vec_start = (cs << bits) % PAGE_SIZE;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

