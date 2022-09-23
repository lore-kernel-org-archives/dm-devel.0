Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D44AC04A95
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kpxQJpQMe3cETRILIpabL+z4fJiDnp9euPjmnoYojlE=;
	b=PrXRvr0BVq65in40czeNo0aLcqY3yiujXUlWKyfDCNth8B1E119Lxj1PtGKJsYwPfnv/M9
	W6tkwVQZ0OeSO/Yn/9rJXH4/D4arM0mwXGCPD9fQUmMLucevuoNEVYIQBXSVUUpEXBxmcZ
	STVYTf9U6e6H6kZHvcH3oUiKTmlpt7g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-3lnMKtc5O46FY6pZNZYZxQ-1; Fri, 23 Sep 2022 13:36:37 -0400
X-MC-Unique: 3lnMKtc5O46FY6pZNZYZxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC36B87A9F2;
	Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 99CBB20290A2;
	Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0669F1946A69;
	Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D578F19465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAFDC40C2066; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C2C3F40C2064
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A78262A5954B
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-dozWv49WPs-Eax0UUdN8-Q-1; Fri, 23 Sep 2022 13:36:30 -0400
X-MC-Unique: dozWv49WPs-Eax0UUdN8-Q-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173629euoutp0137cae6959bf8b178a5a0b21e94390f13~XjeIl_qgp0811408114euoutp01H
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220923173629euoutp0137cae6959bf8b178a5a0b21e94390f13~XjeIl_qgp0811408114euoutp01H
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173628eucas1p18fb85791e90b4d490e510567060c7a77~XjeG_NuqU2512925129eucas1p1n;
 Fri, 23 Sep 2022 17:36:28 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id EB.6E.29727.B9EED236; Fri, 23
 Sep 2022 18:36:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220923173627eucas1p2f134d9cb331e4a8f0fca8431eeb0f0b0~XjeGaf4Wm2090220902eucas1p2i;
 Fri, 23 Sep 2022 17:36:27 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220923173627eusmtrp1aee1e9e64ae111179bc934a5d4095dad~XjeGZuJZk1032310323eusmtrp1b;
 Fri, 23 Sep 2022 17:36:27 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-30-632dee9b3c4d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id CC.78.07473.B9EED236; Fri, 23
 Sep 2022 18:36:27 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173627eusmtip14c74415ab09453de0caf11795fffa12b~XjeGAqtpe2755327553eusmtip14;
 Fri, 23 Sep 2022 17:36:27 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:12 +0200
Message-Id: <20220923173618.6899-8-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7djPc7qz3+kmG5zYZmGx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZPr85isth7S9vi
 8q45bBbzlz1lt5jQ9pXZ4saEp4wWn5e2sFusufmUxeLELWkHYY/LV7w9ds66y+5x+Wypx6ZV
 nWwem5fUe+y+2cDm0dv8js1jZ+t9Vo/3+66yefRtWcXosfl0tcfnTXIe7Qe6mQJ4o7hsUlJz
 MstSi/TtErgyTvz4zFTwRbDi8uc29gbGH3xdjBwcEgImEu3dzF2MXBxCAisYJf7snM7YxcgJ
 5HxhlPj10wsi8ZlRYvfGr+wgCZCG06uOMEEkljNKPDuxFar9JaPEna52NpCxbAJaEo2dYA0i
 AukSx7feZAepYRbYxizR+b+ZGSQhLOAq8fHsP7B1LAKqEtO+HmcC6eUVsJDY9dQRYpm8xMxL
 39lBwpwClhL9jTUgYV4BQYmTM5+wgNjMQCXNW2eDnSAhcJhT4vahVkaIXheJ1vP7WCBsYYlX
 x7dAPSAjcXpyD1S8WuLpjd9QzS2MEv0717NBgsVaou9MDojJLKApsX6XPkS5o8Sqhj5GiAo+
 iRtvBSFO4JOYtG06M0SYV6KjTQiiWkli588nUEslJC43zYFa6iHRf3kh4wRGxVlInpmF5JlZ
 CHsXMDKvYhRPLS3OTU8tNsxLLdcrTswtLs1L10vOz93ECEyPp/8d/7SDce6rj3qHGJk4GA8x
 SnAwK4nwplzUTRbiTUmsrEotyo8vKs1JLT7EKM3BoiTOyzZDK1lIID2xJDU7NbUgtQgmy8TB
 KdXA1Kb4f/++r946myy03spMyFyis048f4+mi8FhH5f6HzvuRE+4WhNloW88waK5KHS9z+lT
 6m80T+2f6Cgd8Nhd9plFnu6/E9NV/lb5PBZ5EqLLOPm4H++3mIeszLv2a8ZYdah/faax7FjE
 3dN13ac2ROhEr934sqDwiKkm36aFbS9XvNlyJHbCc5EN/RPe9ZjUZcgGzDvz40ZQ7mnpxW+C
 Xgaulp2TW7vSQuqw//Ud/xNFV4QoSJzTKl3WyzddQWtdQ2x+rWaFXdnGxw6h349IZc/ds3Hl
 CllWm/8fPqw5wHFo+uqjdoUarmoddg9fHKvykjtmfn57A+++H0oiD/Szi/U9XV9JvU0vZl/o
 wxUdpMRSnJFoqMVcVJwIAFCRYOL+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/xu7qz3+kmG2xtFLJYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UXo2Rfml
 JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZJ358Zir4Ilhx
 +XMbewPjD74uRk4OCQETidOrjjB1MXJxCAksZZT4O3EVE0RCQuL2wiZGCFtY4s+1LjaIoueM
 Eksa9gM5HBxsAloSjZ3sIDUiArkSx9beYwWpYRY4xizx6V0fWLOwgKvEx7P/wGwWAVWJaV+P
 M4H08gpYSOx66ggxX15i5qXv7CBhTgFLif7GGpCwEFDF+cWPwMbzCghKnJz5hAXEZgYqb946
 m3kCo8AsJKlZSFILGJlWMYqklhbnpucWG+oVJ+YWl+al6yXn525iBEbztmM/N+9gnPfqo94h
 RiYOxkOMEhzMSiK8KRd1k4V4UxIrq1KL8uOLSnNSiw8xmgJdPZFZSjQ5H5hO8kriDc0MTA1N
 zCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamKJyS467vDr82euO2Ydt9XNPtKvv
 e9d6bsZD5f13gyeaOV1qE1DvjZz3QEH6tnMyC7eG/B9XgbDo+CPTfywULRTj3Li1SulD21GN
 Qxd83gbUbopIn9TZzaH1TidDTNrQ4Yn4lmcv5V+FVyourubZZBphn83zJaVxmV1PRNCTX467
 /V5eTGSac/2ylNklA58+qaDpRkfK4tasfif0WlWv0nqDrxbfxffRj0ynzU9e9fXJjzqVbR0i
 p15pfIt93cy4t8lpf4n3iQ3qzwxkele9WheTH+ywQ9/2wHF5d2bGgM6PzzgOzFjNHaH36VG4
 sGzer+SsH2fvOxj+vLKs7cbBlU4d/zME/GfIzuN9f/FqgBJLcUaioRZzUXEiAMkXmtVvAwAA
X-CMS-MailID: 20220923173627eucas1p2f134d9cb331e4a8f0fca8431eeb0f0b0
X-Msg-Generator: CA
X-RootMTR: 20220923173627eucas1p2f134d9cb331e4a8f0fca8431eeb0f0b0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173627eucas1p2f134d9cb331e4a8f0fca8431eeb0f0b0
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173627eucas1p2f134d9cb331e4a8f0fca8431eeb0f0b0@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v15 07/13] zonefs: allow non power of 2 zoned
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The zone size shift variable is useful only if the zone sizes are known
to be power of 2. Remove that variable and use generic helpers from
block layer to calculate zone index in zonefs.

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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

