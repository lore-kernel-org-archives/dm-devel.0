Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3043C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-vD-q5QOGPaeib4gPKrkQ8Q-1; Tue, 19 Apr 2022 02:10:32 -0400
X-MC-Unique: vD-q5QOGPaeib4gPKrkQ8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6E95803D7C;
	Tue, 19 Apr 2022 06:10:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A48E5C5097E;
	Tue, 19 Apr 2022 06:10:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7FCE7194035A;
	Tue, 19 Apr 2022 06:10:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 16667194034A
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 08:45:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C5293453854; Fri, 15 Apr 2022 08:45:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1635416165
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 08:45:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A79D33C32B82
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 08:45:17 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-C8FJKXpNMaC8snSHDr3E-A-1; Fri, 15 Apr 2022 04:45:15 -0400
X-MC-Unique: C8FJKXpNMaC8snSHDr3E-A-1
X-IronPort-AV: E=Sophos;i="5.90,262,1643644800"; d="scan'208";a="198878322"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 16:45:15 +0800
IronPort-SDR: k+XtxwXs+HyKucQYwvUsPdXETxPjUusk518Blwf4NDkKnP9O3ROfJtfby39I5R/MlmmHMZsvLy
 DCoqUNcTpN3KuPB0NZ0FJXJF1ZpNOFedWlAtMAlvAckJeySnicZm3ebIfSGetTemLIJjRpnzda
 msfsgpqkP6C7GfAvBeS7mGrzaC0XqvQB7HYMjtHTe4fLI8yDrY4iWmSZ0prUNxcaWLqvHnvdqp
 qja8N07KyDMgsDvIo5VVPs400COpFo9kUZPjleuGHk8FhqQSK773Shp1rw9DRai6xzWCLHKOAZ
 I/wVjYGo+J4yLOmwLot5zLqW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Apr 2022 01:16:26 -0700
IronPort-SDR: Y0ZiPxHabn85gfo/aeiShpy3r/UcGQIscqpa2oX4+PVFekI7204Ci07clWaOktW8nsPsfNlVJp
 /E1MCLltHfQATPpF1Mv5YT1xWvphHN+JTnkKWvg/HXLTnjYh9DUFsfzosR96/nAnOxENaFF19r
 /W5qpMwhf19OiWDIP0YQVPUB7PaSk1Qq8sDrA5o/Oas2Q51SrMiaZpdULQ1urgfgQ/YL0xlh2s
 mFXlvLU3m7K5Nsp3DDWBjjhHFV7ElXhkniRecE/ai/ehGc9Q8HU3mdZLoKuXQ7ymX2y9IwNpQF
 kI0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com)
 ([10.149.52.173])
 by uls-op-cesaip02.wdc.com with ESMTP; 15 Apr 2022 01:45:14 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Date: Fri, 15 Apr 2022 17:45:13 +0900
Message-Id: <20220415084513.790722-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: [dm-devel] [PATCH] dm: fix bio length of empty flush
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Damien Le Moal <Damien.LeMoal@wdc.com>, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The commit 92986f6b4c8a ("dm: use bio_clone_fast in alloc_io/alloc_tio")
removed bio_clone_fast() call from alloc_tio() when ci->io->tio is
available. In this case, ci->bio is not copied to ci->io->tio.clone.
This is fine since init_clone_info() sets same values to ci->bio and
ci->io->tio.clone.

However, when incoming bios have REQ_PREFLUSH flag, __send_empty_flush()
prepares a zero length bio on stack and set it to ci->bio. At this time,
ci->io->tio.clone still keeps non-zero length. When alloc_tio() chooses
this ci->io->tio.clone as the bio to map, it is passed to targets as
non-empty flush bio. It causes bio length check failure in dm-zoned and
unexpected operation such as dm_accept_partial_bio() call.

To avoid the non-empty flush bio, set zero length to ci->io->tio.clone
in __send_empty_flush().

Fixes: 92986f6b4c8a ("dm: use bio_clone_fast in alloc_io/alloc_tio")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/md/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3c5fad7c4ee6..f2397546b93f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1392,6 +1392,7 @@ static void __send_empty_flush(struct clone_info *ci)
 
 	ci->bio = &flush_bio;
 	ci->sector_count = 0;
+	ci->io->tio.clone.bi_iter.bi_size = 0;
 
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

