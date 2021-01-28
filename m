Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C096FC433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FD8E60235
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FD8E60235
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-65TIgw8RP_Sww4IOwqcoPw-1; Thu, 28 Jan 2021 03:39:18 -0500
X-MC-Unique: 65TIgw8RP_Sww4IOwqcoPw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE9291081B29;
	Thu, 28 Jan 2021 08:39:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A423722E8;
	Thu, 28 Jan 2021 08:39:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6C8031809CA6;
	Thu, 28 Jan 2021 08:39:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7D0hR007426 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:13:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2D2A9ED145; Thu, 28 Jan 2021 07:13:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28192ED154
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:12:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A61241875040
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:12:57 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-419-c1TyedEpPei-lxMIZjZhJQ-1; Thu, 28 Jan 2021 02:12:55 -0500
X-MC-Unique: c1TyedEpPei-lxMIZjZhJQ-1
IronPort-SDR: SHx/hydKHBQPzvcsYqnOOppRD8vpowMDkLRjnn0ndoLQfa9nWzvTGCf87u3FFAoJJEmdBCcZef
	FHmK9Yd0MMhA7pr7rlZpAv8C9pHpTDEds/khCpaLHEiIGaGEU4TuZR2LKqr+9X5X1OPugLbWhf
	jZAC/EZBddL1R5m7+9mzETtlfHzRiqjmEKwKXDvk/bIbmotq/8QrZSJfmgNat7MkEBoMKCmFod
	1rPniUSXEttU8O+4EoMup3qVefBIS/lzPZ2VhrRrRE/z8UxijyfG2WMqf2LMEeubPdza0s1TD1
	yRY=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="162963187"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:12:53 +0800
IronPort-SDR: /2Br/toO5EAx2nDlHbr0+EOi+HFRG4Dtx5KMsgqRE2+Idev98JiBz1On+4G5DxbW4dLNHnARrA
	MlXO5LlCob/XKC5b7a+vEesRB7tql7s5rTqsdavkw22plaLGyT5mGR7vLE95V+/716ubGXixKE
	Jk9j8JB4SQa5/1Epy5Syz+5kpYbXWCO5BPPxT3VLZNV66RrMkWoLX4l9kFCLb8zXOtgymHNNue
	pcnPF96bFk+zl1hONCojM6c7z26e1i9xBy7APOsqCiK/dOEHE+vRxoeB+yWYQZDPofYjM1g6qB
	0DtaZ6IfrD0Reuzn+XLoaF2P
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:57:13 -0800
IronPort-SDR: PY5y9iQTPaVno0Uv+vDzXalBIBo52CYeNhdpn1c7TxoOle28qWYUG06GBXepBaS7SSBSs9yjco
	7juMCiLNAFC5Fl7+86T3v8dT5wViZ/r3nWsFgtnjfanPUZXEs47a6Ez/SVmFCas+uBcEU4K0rz
	829GMnmof7Vria8o+CPxuoND3CfaQPgb+QYuf0lvO7BAPoDvQAY10VoO7lep1Qta/l6nA5+vbg
	ht+uppfjRckOmE5ekZUsc4vMGzhgqqwVxG/dC7eG99G+et4hw+q4h30FxFyz73HjopgItSw/2N
	PHA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:12:53 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:07 -0800
Message-Id: <20210128071133.60335-9-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
Subject: [dm-devel] [RFC PATCH 08/34] dm-zoned: use bio_new in
	get_mblock_slow
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
 drivers/md/dm-zoned-metadata.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 039d17b28938..e6252f48a49c 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -550,7 +550,8 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct dmz_metadata *zmd,
 	if (!mblk)
 		return ERR_PTR(-ENOMEM);
 
-	bio = bio_alloc(GFP_NOIO, 1);
+	bio = bio_new(dev->bdev, dmz_blk2sect(block), REQ_OP_READ,
+		      REQ_META | REQ_PRIO, 1, GFP_NOIO);
 	if (!bio) {
 		dmz_free_mblock(zmd, mblk);
 		return ERR_PTR(-ENOMEM);
@@ -577,11 +578,8 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct dmz_metadata *zmd,
 	spin_unlock(&zmd->mblk_lock);
 
 	/* Submit read BIO */
-	bio->bi_iter.bi_sector = dmz_blk2sect(block);
-	bio_set_dev(bio, dev->bdev);
 	bio->bi_private = mblk;
 	bio->bi_end_io = dmz_mblock_bio_end_io;
-	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META | REQ_PRIO);
 	bio_add_page(bio, mblk->page, DMZ_BLOCK_SIZE, 0);
 	submit_bio(bio);
 
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

