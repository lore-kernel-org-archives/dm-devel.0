Return-Path: <SRS0=WBCP=JG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370B8C433B4
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 11:48:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB30E610CC
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 11:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB30E610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-44IF6TsZNhGLzJ9h86ssZw-1; Fri, 09 Apr 2021 07:48:49 -0400
X-MC-Unique: 44IF6TsZNhGLzJ9h86ssZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB7D287A82A;
	Fri,  9 Apr 2021 11:48:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B590F100164A;
	Fri,  9 Apr 2021 11:48:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8258F5533E;
	Fri,  9 Apr 2021 11:48:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 139BmXac000972 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 07:48:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BD310210FE21; Fri,  9 Apr 2021 11:48:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0D9821493DF
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 11:48:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6987385A5BD
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 11:48:33 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-89-Q3ccpOqyMf-tj_GDlbANVA-1;
	Fri, 09 Apr 2021 07:48:31 -0400
X-MC-Unique: Q3ccpOqyMf-tj_GDlbANVA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 461554146C;
	Fri,  9 Apr 2021 07:48:28 -0400 (EDT)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Fri, 9 Apr 2021 13:48:21 +0200
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
	<dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 9 Apr 2021 14:48:04 +0300
Message-ID: <1617968884-15149-5-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
References: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B59657262
X-Veeam-MMEX: True
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
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v8 4/4] fix origin_map - don't split a bio for
	the origin device if it does not have registered snapshots.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/dm-snap.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 11890db71f3f..81e8e3bb6d25 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2685,11 +2685,18 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(bio) != WRITE)
 		return DM_MAPIO_REMAPPED;
 
-	available_sectors = o->split_boundary -
-		((unsigned)bio->bi_iter.bi_sector & (o->split_boundary - 1));
+	/*
+	 * If no snapshot is connected to origin, then split_boundary
+	 * will be set to zero. In this case, we don't need to split a bio.
+	 */
+	if (o->split_boundary) {
+		available_sectors = o->split_boundary -
+			((unsigned int)bio->bi_iter.bi_sector &
+				(o->split_boundary - 1));
 
-	if (bio_sectors(bio) > available_sectors)
-		dm_accept_partial_bio(bio, available_sectors);
+		if (bio_sectors(bio) > available_sectors)
+			dm_accept_partial_bio(bio, available_sectors);
+	}
 
 	/* Only tell snapshots if this is a write */
 	return do_origin(o->dev, bio, true);
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

