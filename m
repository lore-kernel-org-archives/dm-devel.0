Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73706CE79AC
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695201265;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Uy/jBiCPcWV3AMFtDztLuKGmJMeWvSNnAHR5EOjIhB8=;
	b=LFLYjIWStRlrh1gvEP0LBDK9d/Uvt1xxC4qmUfXZ7CpJWRO8yhBrIY1nUdvqVgosNoWsrj
	TkzLLMMRAGaKOx+UyEB2bP8RoiPTEn7EgAbCo69piTiZWFhNiHZ3HXSYoh4sPlMHrGYO0B
	jC/UgnUkQ0fLDO5bCWvyDGKM7rnWBsg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-z3q6zSUMP4aknmb_6fsemQ-1; Wed, 20 Sep 2023 05:14:23 -0400
X-MC-Unique: z3q6zSUMP4aknmb_6fsemQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4E2C805BAC;
	Wed, 20 Sep 2023 09:14:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7ED0720268E6;
	Wed, 20 Sep 2023 09:14:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C669D1946594;
	Wed, 20 Sep 2023 09:14:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E87B194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 08:58:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7090E140E953; Wed, 20 Sep 2023 08:58:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68C53140E950
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:36 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 498353C147E0
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:36 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-pReP5pgWNaO3IGbFE4Vmxw-1; Wed, 20 Sep 2023 04:58:33 -0400
X-MC-Unique: pReP5pgWNaO3IGbFE4Vmxw-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230920085830epoutp019c7d9d412fb49a476f48540eb14053f9~Gj7Nzbh6M2974629746epoutp01S
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230920085830epoutp019c7d9d412fb49a476f48540eb14053f9~Gj7Nzbh6M2974629746epoutp01S
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230920085830epcas5p39ebd476d89a1e542215c8f140a2b0c3d~Gj7NSewOC0420204202epcas5p3J;
 Wed, 20 Sep 2023 08:58:30 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4RrC9w2LQZz4x9Ps; Wed, 20 Sep
 2023 08:58:28 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 11.25.09635.434BA056; Wed, 20 Sep 2023 17:58:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230920081519epcas5p24e047589278635b45aab3b260cb447f0~GjVgWL6Y43141931419epcas5p2E;
 Wed, 20 Sep 2023 08:15:19 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230920081519epsmtrp1157ed79642ad55184f926482f8ada941~GjVgVHWKB2250122501epsmtrp1S;
 Wed, 20 Sep 2023 08:15:19 +0000 (GMT)
X-AuditID: b6c32a4b-2f5ff700000025a3-96-650ab4348e01
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 B9.6C.08649.61AAA056; Wed, 20 Sep 2023 17:15:19 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230920081515epsmtip15e8c3592b5843f13f663f32c55b96f38~GjVcov2vD0185801858epsmtip1K;
 Wed, 20 Sep 2023 08:15:15 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 20 Sep 2023 13:37:43 +0530
Message-Id: <20230920080756.11919-7-nj.shetty@samsung.com>
In-Reply-To: <20230920080756.11919-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzH59y73N1lAi6vOqDCzjJaQLC7uGyHl9pAcJNqaJpKS4IV7rAE
 +2B3YUtmEuRRorJAgrAoIg9FFJHnACspoOJCBROjPJJHstQkAyokikjFslj+9/l9z+87v8eZ
 Hwu3K2A6s+JlalopEydyCUtGa4+7u5ew2ZLmT4yxUX3fTRw9erzCQIfyVnF0YVxLoNmeBYCM
 174FqHO+1AKNXmvH0JWKAgydv3ADQwXddwCaua3DUOeYJzqTXcVAVzoNDDTUcZJAp8/OMNGR
 4TYCnev9G0MjeTMAtRnTAWpdOY2jS7MPGOjW2CY0sNprscuJateNM6mBiQYGNfRTMtVYe5ig
 mqoOUvrRNIKqzP3egjqWMU9Qj2bGGNSDH24TVG5zLaCa+lOpxUYXqtE4h0VYf5YQKKHFsbSS
 Q8ti5LHxsrggbvhHUcFRviK+wEvgh97icmRiKR3EDXkvwis0PnFtEVxOijgxeU2KEKtUXN6O
 QKU8WU1zJHKVOohLK2ITFUKFt0osVSXL4rxltNpfwOf7+K4lRidIau/+aqHQ23x1arWckQZ6
 X8kBbBYkhVCftoLnAEuWHakHcOz5pIU5WABweb56I1gCsDU/H+QA1rpluijErHcCWKNd2LBn
 YfD63F9MUxJBesL+f1gm3YFMw+FlfSUwBThZhsOme72YKcmejIKFv+8x9cEgt0LDH+m4ia1I
 fzjd0b9RjAe1k7YmmU0GwMWqYaY5xRYaSowME+OkK8xoKV3vAZKVbLhwdYlhni0EfldSjJvZ
 Ht7vbWaa2Rn+qc3eYA08f7yGMJszAdQN64D5YSfM6tPipiZw0h3Wd/DM8hZY2HcJMxe2hsdW
 jJhZt4JtZS/YDV6sLyfM7ATvPEnfYAoa67I2NpoL4EjOFJEHOLqXBtK9NJDu/9LlAK8FTrRC
 JY2jVb6K7TJa898vx8iljWD9ODzC28C9qYfe3QBjgW4AWTjXwUq6zZK2s4oVf32AVsqjlMmJ
 tKob+K4tPB93doyRr12XTB0lEPrxhSKRSOi3XSTgvmY1m3Uq1o6ME6vpBJpW0MoXPozFdk7D
 Bve1H6oL19m+utvFkBrqb2jvyq7Wf/nBb0/984wHGmpSDjacYL9rM/8hMf72681yx4mdDzWN
 VqvB45MD6qYT07zcMnveYc+znptDihNW1T0B0Z8Epnc0JIqfdZXcP7Jv9Nk3PtscBzkdT6jI
 7oqwG9G4nWSP2k+w43nSls9LU3dFLneBUr0mu9A9VGPj63LUKeOmz2ap9V6Qkbl3aqY0k/ej
 y1aNdDDS/839TfuLDbL8jxerKwN+GdW6LU1vkrf8fLemqE7iajgXuDzhluT6+GLCyPG5osPX
 K0S3tENi+6VaXpjjmcufBnuMp/ScfOr0ha7qalhYUgO/731r6p0Wd47DG7uXuQyVRCzwwJUq
 8b+AeRKepQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02ReUiTYRzHe9733bt3q+nrsnxmUDBoiab2UsjTbWD1/hESERXmNdqbmm6N
 vVpWUtqoaFauE/Oammk70JxmHhmi6TLtwDJ1pQZql2SH3UurZUH/ffhe/OBH4VIH4UslaJI5
 nUaZJCfFRE2LfG6gj0XMLWpoxVHFnTYcvf/kItBh4wSOrP1ZJBpt+QDQcNMxgBrHcgWor6kO
 QzeKz2DIbG3F0JnmxwCNdOdgqNEZgIqOlhDoRmM7gR7W55HIVDoiRJk9tSQqc0xiqNc4AlDt
 cAZANS4TjspH3xLotnMOuj/hEITK2LqcfiF7f6CSYB/eTWHtluMkW1VyiG3oSyfZS6fOCtiT
 +jGSfT/iJNi3N7tJ9lS1BbBVHQfYcftc1j78BtvoESFeoeKSEvZwuuBVseJ4y9MnAm2DZ2r+
 RCGRDhwzDICiIL0EDl0IMwAxJaUbAGw6UkQagOi3LoOlE7fwKZ4JzZMvhFMhPQadg3qBu0zS
 AbDjJ+XWvWkDDo/XjRHuAk7bcFidL3HzTDoKDunzMDcT9HzY/iLjz6iEXgaH6jvA1BHBMGvQ
 yy2L6OVwvKRH6Gbp70jHA5NwKu4F2y8O/52fB/XXcnEjoHP+s3L+swoBZgEyTsur49Q7GC2j
 4fYG8Uo1n6KJC9qxW20Hf37t71cLBkyTQc0Ao0AzgBQu95aoFWJOKlEp9+3ndLtjdClJHN8M
 5lCE3EfCZOeqpHScMplL5Dgtp/vnYpTINx2rD+njuxyLC6aPmzqfZtoW+0e2Zn63WTwXhBNY
 ZclBgXRFhk+sH+Md/GmQPMfXdO8UGz02L7PR2ert52tgttnOtDguZY0yvmXrtJ6JO/c5DV2l
 ZQVcNG/eNC1VFVn1aFcifP1MeC9tVlHymihwOXroa4HCY715g+vbwt7C2SEuhfm08bMt+0rX
 wKOLk37XvtxiUleBaDzDKzym+MlaRcR25aGr02NCr4dubTtKJq8u3Lb6hLVpLPFV2NewWCsT
 /pzq7+sJCLTUdWoDVRELY1Y6QqSilKVF+eUnCs6Naq6f1KW1pXW2WjfI7OZ3r2QvL1srMPVH
 kaGqWPRjyyZpr5zg45WMP67jlb8AEnlxkFoDAAA=
X-CMS-MailID: 20230920081519epcas5p24e047589278635b45aab3b260cb447f0
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081519epcas5p24e047589278635b45aab3b260cb447f0
References: <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081519epcas5p24e047589278635b45aab3b260cb447f0@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v16 06/12] fs,
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
Cc: Anuj Gupta <anuj20.g@samsung.com>, anuj1072538@gmail.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-doc@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For direct block device opened with O_DIRECT, use copy_file_range to
issue device copy offload, or use generic_copy_file_range in case
device copy offload capability is absent or the device files are not open
with O_DIRECT.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/fops.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index acff3d5d22d4..6aa537c0e24f 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -735,6 +735,30 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
+	} else {
+		copied = generic_copy_file_range(file_in, pos_in + copied,
+						 file_out, pos_out + copied,
+						 len - copied, flags);
+	}
+
+	return copied;
+}
+
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
@@ -828,6 +852,7 @@ const struct file_operations def_blk_fops = {
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

