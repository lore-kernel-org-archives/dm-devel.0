Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5E9C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-h-Ql_BgYPpSRcO9qmVnKcg-1; Mon, 16 May 2022 12:54:42 -0400
X-MC-Unique: h-Ql_BgYPpSRcO9qmVnKcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3F1986B8A2;
	Mon, 16 May 2022 16:54:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6568740CF8EA;
	Mon, 16 May 2022 16:54:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 045021947054;
	Mon, 16 May 2022 16:54:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3442194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D826D40CF8EF; Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D144540CF8EA
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D26E185A7A4
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-GtCqlcp0MF-czvM3S7AAyQ-1; Mon, 16 May 2022 12:54:35 -0400
X-MC-Unique: GtCqlcp0MF-czvM3S7AAyQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165434euoutp01606dd393054e6698eb4a652905cf7d1c~vpCazi-a32836328363euoutp01S
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516165434euoutp01606dd393054e6698eb4a652905cf7d1c~vpCazi-a32836328363euoutp01S
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220516165432eucas1p28fa728357342aadebf5be26269ea5b40~vpCZc4W501887918879eucas1p2n;
 Mon, 16 May 2022 16:54:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id A2.4A.09887.8C182826; Mon, 16
 May 2022 17:54:32 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220516165432eucas1p2e1ea74d44738e44745f49e37b6b9e503~vpCYwJZGZ0200602006eucas1p2R;
 Mon, 16 May 2022 16:54:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220516165432eusmtrp1057bb593a1a030e8e478dd59b33a54e3~vpCYvYe2E2961829618eusmtrp1Q;
 Mon, 16 May 2022 16:54:32 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-43-628281c8fad5
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 02.99.09522.8C182826; Mon, 16
 May 2022 17:54:32 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165431eusmtip2bac363d67d5edcb5d23957c2ace71c86~vpCYcv3fi0272502725eusmtip2v;
 Mon, 16 May 2022 16:54:31 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:13 +0200
Message-Id: <20220516165416.171196-11-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7djP87onGpuSDNY+MbZYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjuKySUnNySxLLdK3S+DKOPvgCFPBdoGK6ZtOMDcwnuXtYuTk
 kBAwkbg2/QhbFyMXh5DACkaJNVP72SGcL4wSHR9nQTmfGSV+TtzMDtPS/fcgE0RiOaPE5m3L
 mEESQgLPGSV+vZToYuTgYBPQkmjsBKsXEciSmHbiISNIPbPAYiaJlXsms4AkhAVcJF5sPcsG
 YrMIqEoc+riICaSXV8Ba4tl0O4hd8hIzL31nBwlzAoVXd3GDhHkFBCVOznwCNoUZqKR562xm
 kPESAvM5Jeb8aWKG6HWR2HFvPyOELSzx6vgWqPtlJE5P7mGBsKslnt74DdXcwijRv3M9G8gy
 CaBlfWdyQExmAU2J9bv0IcodJb6fvsUEUcEnceOtIMQJfBKTtk1nhgjzSnS0CUFUK0ns/PkE
 aqmExOWmOSwQJR4SE78oTmBUnIXkl1lIfpmFsHYBI/MqRvHU0uLc9NRio7zUcr3ixNzi0rx0
 veT83E2MwER3+t/xLzsYl7/6qHeIkYmD8RCjBAezkgivQUVDkhBvSmJlVWpRfnxRaU5q8SFG
 aQ4WJXHe5MwNiUIC6YklqdmpqQWpRTBZJg5OqQYm78zlAn+e6wUbhnYXpJxsbGOen3uwIXjh
 3NkHRRQnR3FW1S3YZ7VO4fIBsScOL6a/ahCcveJVp0HF9Efn/q2d5XL8P4t20ZtdWVfYTa9W
 +on897i48uHuZU8v/Pgv6p6b1xcoqvOo+FeIa5vftN/q32UYZrPrmR4umrgwMoVL8ZOqwood
 NRsChP/2dSoJOoWWnf3dlRb74rlp+OXmZ7vOqNftmHNoVw/zBafdSqvtP5z9nNg927CsgdUg
 ZYuXNMeE6Px77zbonupobDP8N7H036c1b1b4Vzt3POP+ldk7haNI6spKn+v16358n6p2/OtV
 xrSsPT5bfu5q2f/kQZKxvtVUo7ria5X6AatYz6ybocRSnJFoqMVcVJwIAGjJCBjjAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t/xe7onGpuSDM4dZrdYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjtKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV
 0rezSUnNySxLLdK3S9DLOPvgCFPBdoGK6ZtOMDcwnuXtYuTkkBAwkej+e5Cpi5GLQ0hgKaNE
 46XfrBAJCYnbC5sYIWxhiT/Xutggip4ySjz++Ji5i5GDg01AS6Kxkx2kRkSgQGJO/xYWkBpm
 gbVMEq9/vAdrFhZwkXix9SwbiM0ioCpx6OMiJpBeXgFriWfT7SDmy0vMvPSdHSTMCRRe3cUN
 EhYSsJL4+uQW2HheAUGJkzOfsIDYzEDlzVtnM09gFJiFJDULSWoBI9MqRpHU0uLc9NxiQ73i
 xNzi0rx0veT83E2MwLjcduzn5h2M81591DvEyMTBeIhRgoNZSYTXoKIhSYg3JbGyKrUoP76o
 NCe1+BCjKdDVE5mlRJPzgYkhryTe0MzA1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQim
 j4mDU6qBSWyaspCrxJeaZzVzlFm6Fh7e6Puu9qWQTs+Hg/OqjH46mCpnut9I+HXC5H/apc//
 t+9RvtR6Iadwe/DxZl32YDmZm49OTBHayb52r+ihZTdu2e1KPqCtzmuo8v5CaOBehYTomA0P
 T3Qezz/lN/fi7dLVmysCUrL/GlYUTpc9saBwx4cD2xrq0ws+R3XNCPSqi/Mp0PY6G8Z3J6BU
 euoR51se3Wzxe9JE6qYVl+s0vbNrZBD0sjDRXfaPYZp6pnpYRdfD2gV15/8cVTbQ93p31mmr
 /umFHLNd/st+eXChVsnI/R9X762/h9sWH3X0VDvzOP+s+iHOmbckJJ6rmGqmZmf4uu9e5hO5
 UO1dkESNEktxRqKhFnNRcSIAA7FWCVQDAAA=
X-CMS-MailID: 20220516165432eucas1p2e1ea74d44738e44745f49e37b6b9e503
X-Msg-Generator: CA
X-RootMTR: 20220516165432eucas1p2e1ea74d44738e44745f49e37b6b9e503
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165432eucas1p2e1ea74d44738e44745f49e37b6b9e503
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165432eucas1p2e1ea74d44738e44745f49e37b6b9e503@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v4 10/13] zonefs: allow non power of 2 zoned
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
Cc: p.raghav@samsung.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The zone size shift variable is useful only if the zone sizes are known
to be power of 2. Remove that variable and use generic helpers from
block layer to calculate zone index in zonefs.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/zonefs/super.c  | 6 ++----
 fs/zonefs/zonefs.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 57ca775f5..e302c889a 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -451,10 +451,9 @@ static void __zonefs_io_error(struct inode *inode, bool write)
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
@@ -1375,7 +1374,7 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	int ret;
 
-	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
+	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
 	inode->i_mode = S_IFREG | sbi->s_perm;
 
 	zi->i_ztype = type;
@@ -1752,7 +1751,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	 * interface constraints.
 	 */
 	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
-	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
 	sbi->s_uid = GLOBAL_ROOT_UID;
 	sbi->s_gid = GLOBAL_ROOT_GID;
 	sbi->s_perm = 0640;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 4b3de66c3..39895195c 100644
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

