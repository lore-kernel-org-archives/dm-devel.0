Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018B1C32793
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257163;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jamXr8quZrda2gm/OeXqwXaoHJv1i7HvaixEeOY243M=;
	b=D5UmRjunxwoth5Rp6GcXbSkku8uR9r8OuhUMl8RwT8mddpeMJz+IsJHV4STE3ED8XfJWbP
	BXkijRY8YNqPdFP8qTJyioTKOvh7JYOpNRZCZ95epcyKI9fCj1AXpVSfWZSUA4Ok6iWUG5
	gQqOsJiP9NlTDlwHVx6u/WtJkjnuJ1c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-QzTF_iUYPOOoaxmicRBm7w-1; Tue, 23 Aug 2022 08:19:19 -0400
X-MC-Unique: QzTF_iUYPOOoaxmicRBm7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 721801C004EB;
	Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D693112131E;
	Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F51F1946A47;
	Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BCE351946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B0D372026D64; Tue, 23 Aug 2022 12:19:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACF1C2026D4C
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EBF2823F0E
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:14 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-OEo4CbH1PEGxjyBEfPWKvA-1; Tue, 23 Aug 2022 08:19:12 -0400
X-MC-Unique: OEo4CbH1PEGxjyBEfPWKvA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121911euoutp01a8a02aca793a5f5e164f58ca2691e312~N_JPnzmO21946919469euoutp01Z
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220823121911euoutp01a8a02aca793a5f5e164f58ca2691e312~N_JPnzmO21946919469euoutp01Z
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121909eucas1p2890b8b0b0d55aa9afc392a2cffc55cfa~N_JNsywfQ2415624156eucas1p2K;
 Tue, 23 Aug 2022 12:19:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 5E.71.07817.DB5C4036; Tue, 23
 Aug 2022 13:19:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220823121909eucas1p16b613217afcb29c29d6149c2620c93b4~N_JNIXK_f1881118811eucas1p1L;
 Tue, 23 Aug 2022 12:19:09 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220823121909eusmtrp22f6243acddad4b04f9f38496fedca76e~N_JNHjxvZ2697126971eusmtrp2j;
 Tue, 23 Aug 2022 12:19:09 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-66-6304c5bd4d76
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 07.12.07473.CB5C4036; Tue, 23
 Aug 2022 13:19:08 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121908eusmtip1e4f8549b7b6a639b4f98f48c588602e6~N_JMvqvoU0460904609eusmtip1T;
 Tue, 23 Aug 2022 12:19:08 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:53 +0200
Message-Id: <20220823121859.163903-8-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7djPc7p7j7IkG6z7pGSx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK+PB
 hMSCFsGKFX+qGxgn8XUxcnJICJhIvH3/h7mLkYtDSGAFo8TDQ5/ZQBJCAl8YJV4vzYNIfGaU
 2Dp5NhNMx7lTSxghEssZJc4t2M0C4bxglPi3sw+oioODTUBLorGTHaRBRCBd4uvXDYwgNrPA
 HSaJb9dzQWxhAVeJL48ngtWwCKhKrGu7xwxi8wpYSbw9/ZINYpm8xMxL38FqOAWsJeYtPcUI
 USMocXLmExaImfISzVtng70gIbCdU+L6iY1Ql7pIbFv+hRHCFpZ4dXwLO4QtI/F/53yommqJ
 pzd+QzW3MEr071zPBvKABNC2vjM5ICazgKbE+l36EOWOEkcb/jNBVPBJ3HgrCHECn8SkbdOZ
 IcK8Eh1tQhDVShI7fz6BWiohcblpDguE7SFxdNsmlgmMirOQPDMLyTOzEPYuYGRexSieWlqc
 m55abJSXWq5XnJhbXJqXrpecn7uJEZgKT/87/mUH4/JXH/UOMTJxMB5ilOBgVhLhrb7IkCzE
 m5JYWZValB9fVJqTWnyIUZqDRUmcNzlzQ6KQQHpiSWp2ampBahFMlomDU6qBSVAkz6Al7uyK
 k7u2ZjFFTM1T83nGoxb//d9nBwvdevnZ+ywjt+680Dox9M9r2ZWb+f73GMw9tS7Y9Wcu2wXT
 0+1nGNMT5jdFqXHmvc94Ivrq/RbOp98m9LblXH5ktdc6d0bh9i2Zy00Pstx+fbqt58SWziOV
 zydNivWe3fnEteBfRfbRpj3OZa4xH82PJc+QDd54wfjk3o/bPavKGKLC7ixhD91h2/u2symu
 efK1zTP7lx1VXcs0u+syc6XTkhALbrcdVU787jcbNVeXi4qttb6vrNXwsuzz6viobbvZZubP
 X7QvkPPZxCJJ/dXperbuSbLBt83mBiV181RwaU+e+K8kZP9hi6kSNgm9t3xvKrEUZyQaajEX
 FScCALSosC/0AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xu7p7jrIkG7w7Y2qx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina
 0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+PBhMSCFsGKFX+qGxgn8XUxcnJI
 CJhInDu1hLGLkYtDSGApo0TXk+OsEAkJidsLmxghbGGJP9e62CCKnjFKvOuYxN7FyMHBJqAl
 0djJDlIjIpArcXjzBCaQGmaBN0wSR/+1gA0SFnCV+PJ4IlgRi4CqxLq2e8wgNq+AlcTb0y/Z
 IBbIS8y89B2shlPAWmLe0lNgi4WAaubf+sQGUS8ocXLmExYQmxmovnnrbOYJjAKzkKRmIUkt
 YGRaxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERi524793LyDcd6rj3qHGJk4GA8xSnAwK4nw
 Vl9kSBbiTUmsrEotyo8vKs1JLT7EaAp090RmKdHkfGDqyCuJNzQzMDU0MbM0MLU0M1YS5/Us
 6EgUEkhPLEnNTk0tSC2C6WPi4JRqYJJQl2Dvjrb027OuV9P0Do/t5/9nr+sut+EuubAqSm2r
 OG/g50nGnwNWhjKyeZ3ScFU2ublRkau0bNLHzNCjoi86qrttXUtW/X4tcnW35ovdBzZ9c/i8
 h91T86n+wzNlN28/nPmaV6PmpqYoz2emsm673zdCGc+a/Xz2Luht3azWPTPNli6+EeMd/POj
 lLSLyVb59vjvrrOemS3nf//f6fKc53z7A1dwT2Vq23Qy2/dV51LtaT31OxSkuZzTt24/Eq/8
 wXLjQd1PkjwGDFNOvtq74l5R1f1JxhpfssX3s2+0qHg+r4VHQ+xH97OjPCfSdneHfNwrl926
 41TuZY/vVhKLP7zwZOK4xCsxycBTXEeJpTgj0VCLuag4EQANjWn+ZQMAAA==
X-CMS-MailID: 20220823121909eucas1p16b613217afcb29c29d6149c2620c93b4
X-Msg-Generator: CA
X-RootMTR: 20220823121909eucas1p16b613217afcb29c29d6149c2620c93b4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121909eucas1p16b613217afcb29c29d6149c2620c93b4
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121909eucas1p16b613217afcb29c29d6149c2620c93b4@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v12 07/13] zonefs: allow non power of 2 zoned
 devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The zone size shift variable is useful only if the zone sizes are known
to be power of 2. Remove that variable and use generic helpers from
block layer to calculate zone index in zonefs.

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/zonefs/super.c  | 6 ++----
 fs/zonefs/zonefs.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 860f0b1032c6..e549ef16738c 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -476,10 +476,9 @@ static void __zonefs_io_error(struct inode *inode, bool write)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct super_block *sb = inode->i_sb;
-	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	unsigned int noio_flag;
 	unsigned int nr_zones =
-		zi->i_zone_size >> (sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+		bdev_zone_no(sb->s_bdev, zi->i_zone_size >> SECTOR_SHIFT);
 	struct zonefs_ioerr_data err = {
 		.inode = inode,
 		.write = write,
@@ -1401,7 +1400,7 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	int ret = 0;
 
-	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
+	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
 	inode->i_mode = S_IFREG | sbi->s_perm;
 
 	zi->i_ztype = type;
@@ -1776,7 +1775,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	 * interface constraints.
 	 */
 	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
-	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
 	sbi->s_uid = GLOBAL_ROOT_UID;
 	sbi->s_gid = GLOBAL_ROOT_GID;
 	sbi->s_perm = 0640;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 4b3de66c3233..39895195cda6 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -177,7 +177,6 @@ struct zonefs_sb_info {
 	kgid_t			s_gid;
 	umode_t			s_perm;
 	uuid_t			s_uuid;
-	unsigned int		s_zone_sectors_shift;
 
 	unsigned int		s_nr_files[ZONEFS_ZTYPE_MAX];
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

