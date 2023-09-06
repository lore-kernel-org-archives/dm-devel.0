Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A87EE14C3
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694022884;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qHboLAVko22TV8GkzjDM3RtMvTSSStVMW4x0nUEg7X4=;
	b=CNWI8S57Myd7zcSBotI1+mAliZT5qTJbkRJVaqbMog0oh+ySF1IXXGXXW68USLuSpbeUvn
	254FtdTvT9/OkrF6WwgDHAROnX4HeXvN51fW0nxUo6ASl9Bky42mNIQwf6drdTtAqcw/SO
	c7N62COyxArX8OchWjo1bZ5RgvBXbJ8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-mB43pBnAM6m-1jj056Nngw-1; Wed, 06 Sep 2023 13:54:41 -0400
X-MC-Unique: mB43pBnAM6m-1jj056Nngw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0621F8A6829;
	Wed,  6 Sep 2023 17:54:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E9F891121314;
	Wed,  6 Sep 2023 17:54:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE3F419465B3;
	Wed,  6 Sep 2023 17:54:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27EA219465B2
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 17:54:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1877D400F26A; Wed,  6 Sep 2023 17:54:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10DCA40C105A
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8BC33C0E469
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:37 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-av2hnbdXOYCCvkn38EfX7A-1; Wed, 06 Sep 2023 13:54:35 -0400
X-MC-Unique: av2hnbdXOYCCvkn38EfX7A-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230906175432epoutp048fe251680a2ecc0fcbb1aecc400578e2~CYNPTBpDv3253832538epoutp04k
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230906175432epoutp048fe251680a2ecc0fcbb1aecc400578e2~CYNPTBpDv3253832538epoutp04k
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230906175431epcas5p4caef517db715554fb2030354050b0b27~CYNOd4nfJ1892318923epcas5p4O;
 Wed,  6 Sep 2023 17:54:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4Rgqkt10Lyz4x9Pt; Wed,  6 Sep
 2023 17:54:30 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 AD.E9.09638.5DCB8F46; Thu,  7 Sep 2023 02:54:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230906164340epcas5p11ebd2dd93bd1c8bdb0c4452bfe059dd3~CXPW-OFCf0674706747epcas5p1L;
 Wed,  6 Sep 2023 16:43:40 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230906164340epsmtrp15603d6d755b27809f79e6df03f2a9d47~CXPW_WxJb0347103471epsmtrp18;
 Wed,  6 Sep 2023 16:43:40 +0000 (GMT)
X-AuditID: b6c32a4a-92df9700000025a6-69-64f8bcd5368f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 96.D9.18916.C3CA8F46; Thu,  7 Sep 2023 01:43:40 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230906164337epsmtip2793af6b075dc36212bac0a20406c77d8~CXPUJ56dx1829618296epsmtip2c;
 Wed,  6 Sep 2023 16:43:37 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed,  6 Sep 2023 22:08:31 +0530
Message-Id: <20230906163844.18754-7-nj.shetty@samsung.com>
In-Reply-To: <20230906163844.18754-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta1BTRxTHZ++9uQQ0egnQrrTWGHXqo4EEAixofOG0t9oPtM6odSbElNwJ
 CCQxCQWctgYloaK8BKQERUTGGsiAUqXKqwxMeU5LCxhLpiBtYeRRIqVjYcaiJVy0fvud/56z
 /z1nd7k4/wnpz43TGBm9RpkgJL2IurYtm0WOxnmV2OyNarrbcXQ6dwFHVUM5JJpqmwVotCUD
 oCZXCQcNttzDkK3qewxdaHUANHbfiqEm5zZ01VJBoMamLgL1118i0ZXrYx7o645nGPoldwyg
 uqdXcFQ99ZhAnc43UO9CB2e3H907fIug+39Iomsrz5L0NxWn6IZBE0lfy87n0FlnXCT915iT
 oB833yfp7NuVgP679i26dnQai1p5NH5HLKNUMXoBo4nRquI0apnwwEFFpCIkVCwRScJRmFCg
 USYyMuG+D6JE78YlLLYqFHyqTEhalKKUBoMwcOcOvTbJyAhitQajTMjoVAk6qS7AoEw0JGnU
 ARrGGCERi4NCFhOPxcfOudowXdnqFIfFhZnAzZWZwJMLKSm02Uc8MoEXl081AFgyM0yywSyA
 D2bsHi+DyrxJLBNwl0rqRw+w+j0AL43nLleYMWiqblxKIqltsOc51637UiYc3my4BtwBTlVj
 sLiiD3eb+1AKaMoa4LiZoDbBiQvVpJt5VAQ863xGsG6BMOeht1v2pLbD02k/AzbFG3YVjxJu
 xql18MydEty9P6Sec2G3awBjm9sH+6qGPVj2gZMdt5fZH07kWJY5GdoKbpBscTqA1gdWwC7s
 gubuHNx9CJzaAmvqA1l5LSzsrsZY41Uw6+noshcP3i19wRugvaaMZHkNdMylLTMN7T2lGDut
 bADNhUNELhBYX2nI+kpD1v+tywBeCdYwOkOimjGE6II0TPLLa47RJtaCpfe/df9d8NvITEAr
 wLigFUAuLvTludb9o+LzVMrUk4xeq9AnJTCGVhCyOPA83N8vRrv4gTRGhUQaLpaGhoZKw4ND
 JcLXeVPmyyo+pVYamXiG0TH6F3UY19PfhMWkTMpkYOf5i0dSDubttV3dKCt89KG88uHCVzVZ
 n7yX3x6m/em4XdQmt/B6HSumbw21cxRT7wi+zUwvnjzcefzGr56lOJ6hffPRR5HJk+VrZ+OK
 xpMDd3022/g59SSPc6Jvo/TiVNiet0PeT11xLqM53bQQ+VqVDtUOb+r9wnJiM3dAfkfauaEl
 umL/4X5+ubPJXpQsUUR4aQv6ROYGedDJ4LlYv6Onflyduz0tbP3lc+3tf/4b5lwv+vLYiKGw
 /A+fPbvbehLHpXvnS/jBvrrm77pmP55w9cujrwtaRorqIvPEdPQqBerOVx8anLZ1FfCHUw+p
 f/fxtc3EW4845gMa/FMtQsIQq5RsxfUG5X/BryaXiAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHfc85Ho/m6rhlvik5nGWhNBsVvaSUFsiBpMLCD2WXQzvNaOo6
 c1EhNLWUWV5QxDtbZYoaWrPMS5bNbhpmZk5dFz+0oWXNzEtROHNK0Lff87/AHx4KF1YTvtSp
 xGSOT2SVEtKDaOqUiDeG3/ol36TvFaCG7mc4Ssubw1Hdh1wSjXf+AMjakQlQu73MFQ13tGCo
 pu4phvJNZoBsA6UYareEoGsZlQR60N5FoP7WchLpq2xuqPq5A0NDeTaAmv7ocVQ/PkGgFxY/
 1Dv33DXCm+n9eIdg+ns0jLFWRzKNlReZtmEtydzIKXBlstPtJDNpsxDMxMMBksm5WwuYKaM/
 Y7R+w/Z7HvIIl3PKU2c5PnTHcY/4n/ZOTGVYcc6cYce04LZnFqAoSG+BrdY9WcCDEtL3Afxk
 +g2ygPuCvhpWzT3Bl1gEaxyjbkuhdAyOTD1zdZZJOgS+nKec+ko6C4e6FjvhPHC6GYOj8xlu
 zraIPgINr3sWmaDXwc/59aSTBfR2qLM4iKUVoTB3xMspu9NhMC21b3GEcCHyvnYcLMW9YFeJ
 lXAyToth+r0yPA/Qpf9Zpf9ZBoDVAm9OpU5QJJxQyaRqNkGtSVRITyQlGMHiL4NjmkFVw5zU
 BDAKmACkcMlKgV08KxcK5Oz5CxyfdIzXKDm1CfhRhMRHEKjUyYW0gk3mTnOciuP/uRjl7qvF
 Dm7oblN8731VdazC21vDvzk51WCInhZ/MJ8Z2R36rg8lNTq+FDzFWX562Kj6Gkc/ku0cKdln
 1wfxfgH7vSziFFlcYKxpYCrK8/Jo3tGwwgAfa//Y7Qz1INVXva8E77puXquUpNoycc3VnEOX
 ZLv8ReKiWIOjI/g9qxIdrfCJeFygH4/aODOwZszcZnjc3IG9jazZGwwKUzYXi2J7SjYFLg/S
 DgrZxLj+liHtyYiA6MyIKx/DXdZnbyucVG292diqOZAaU2SemAlhJPbicumdsfxoaZFLikK3
 anAZtbnrlckwtmo+VV6+9Qqddng2bjCwTRiZfLx0Bhev89QNSQh1PCsLxnk1+xeh4Ot/OgMA
 AA==
X-CMS-MailID: 20230906164340epcas5p11ebd2dd93bd1c8bdb0c4452bfe059dd3
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164340epcas5p11ebd2dd93bd1c8bdb0c4452bfe059dd3
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164340epcas5p11ebd2dd93bd1c8bdb0c4452bfe059dd3@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v15 06/12] fs,
 block: copy_file_range for def_blk_ops for direct block device
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For direct block device opened with O_DIRECT, use copy_file_range to
issue device copy offload, and fallback to generic_copy_file_range incase
device copy offload capability is absent or the device files are not open
with O_DIRECT.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/fops.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index a24a624d3bf7..2d96459f3277 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -739,6 +739,30 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+static ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
+				      struct file *file_out, loff_t pos_out,
+				      size_t len, unsigned int flags)
+{
+	struct block_device *in_bdev = I_BDEV(bdev_file_inode(file_in));
+	struct block_device *out_bdev = I_BDEV(bdev_file_inode(file_out));
+	ssize_t copied = 0;
+
+	if ((in_bdev == out_bdev) && bdev_max_copy_sectors(in_bdev) &&
+	    (file_in->f_iocb_flags & IOCB_DIRECT) &&
+	    (file_out->f_iocb_flags & IOCB_DIRECT)) {
+		copied = blkdev_copy_offload(in_bdev, pos_in, pos_out, len,
+					     NULL, NULL, GFP_KERNEL);
+		if (copied < 0)
+			copied = 0;
+	}
+	if (copied != len)
+		copied = generic_copy_file_range(file_in, pos_in + copied,
+						 file_out, pos_out + copied,
+						 len - copied, flags);
+
+	return copied;
+}
+
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
@@ -832,6 +856,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.copy_file_range = blkdev_copy_file_range,
 };
 
 static __init int blkdev_init(void)
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

