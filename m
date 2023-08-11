Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C0CC04A94
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691752835;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oMcvcAd+o99NPpEuypxjUqLJiKpB6DMbG8zI8qfP4ng=;
	b=aNc5BLJYPsn3c/qd7riBRb9oNkkJZ4AtgZCwjMVAYdvtBVQmfQ31uG+e0v2EKTbQgaf2xI
	7IP0OjP148HCmQsVTxufq/UUSW8Gb+x07XHxa2s+21yb9FDtlqQFsm9egDwZ/x3u7OwIM4
	i70ddAint8UemWObUb+KGtP4JheDuUQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-Aoth_ZvDPau-7_hkesa9UA-1; Fri, 11 Aug 2023 07:20:29 -0400
X-MC-Unique: Aoth_ZvDPau-7_hkesa9UA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B8B2805951;
	Fri, 11 Aug 2023 11:20:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45FBAC15BB8;
	Fri, 11 Aug 2023 11:20:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14D4F1946594;
	Fri, 11 Aug 2023 11:20:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7825A1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 11:20:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6A46240C2063; Fri, 11 Aug 2023 11:20:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6236640C2071
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4341D28EC119
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:25 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-vjnOyw23PKip4rfjilxZZg-1; Fri, 11 Aug 2023 07:20:23 -0400
X-MC-Unique: vjnOyw23PKip4rfjilxZZg-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230811112020epoutp0244cb6edc2c42f22cd143d0b02f4c5fc2~6UDoRrkas0105201052epoutp02B
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230811112020epoutp0244cb6edc2c42f22cd143d0b02f4c5fc2~6UDoRrkas0105201052epoutp02B
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230811112019epcas5p2a57cf2476884422a636a175833c1f083~6UDnpMjsk0511305113epcas5p2o;
 Fri, 11 Aug 2023 11:20:19 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4RMhD140ltz4x9Py; Fri, 11 Aug
 2023 11:20:17 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 B0.7D.55522.17916D46; Fri, 11 Aug 2023 20:20:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230811105734epcas5p1b465394a301ba85f2c52ed7fde334f52~6TvwrRB2X2729727297epcas5p1n;
 Fri, 11 Aug 2023 10:57:34 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230811105734epsmtrp1ed176f2233ebaa42c1ef6e00e48f21d4~6TvwqSCzB0371503715epsmtrp1Q;
 Fri, 11 Aug 2023 10:57:34 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-eb-64d6197199e1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 0D.01.30535.E1416D46; Fri, 11 Aug 2023 19:57:34 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230811105729epsmtip2ef78d0d5cd04032b7b1ba24b0efdf868~6Tvr-w28T1482714827epsmtip2I;
 Fri, 11 Aug 2023 10:57:29 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Fri, 11 Aug 2023 16:22:49 +0530
Message-Id: <20230811105300.15889-7-nj.shetty@samsung.com>
In-Reply-To: <20230811105300.15889-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1CTdRzH+z7PeBji8nFofIF0c2YJBmw41heDzODyKb2OO7S77Lg12RMg
 Yxv7IUlyDRxQeGwo5uUWv46ZCQI2lF9rhuOUH+lBcIIgmNk4Q34ZFVYgxTYo/3t93vd5fz8/
 vvdh4uy/iUBmqlxDq+QSGY9YxWhsD94amhEwIOVP2QJRffd1HOUWP8FRzaiRQBPtswA52woA
 uvfdTmSfNnuhobYWDJ2vuYahk44BgMZumTBkH96GKvMtDPStvYuB+lu/JFD5V2Pe6FzHIoZu
 F48B1DhfjqO6iRkG6hwOQj1POrxef47qufsNg+q/qaWs1Z8RVIPlE8o2pCOoKkOJF1V0bJqg
 fh0bZlAzV24RlOFSNaB+s26krM4pLH71gbToFFoipVVcWp6kkKbKk2N4exLEseJIEV8QKohC
 r/C4ckk6HcOL2xsf+maqbGleHvewRKZdkuIlajUv/LVolUKrobkpCrUmhkcrpTKlUBmmlqSr
 tfLkMDmt2SHg8yMilxI/SEsZ7C0llBVrPnrYrPfWgYurC4EPE5JCONk+CgrBKiabtAFYYrXg
 nmAWwJacT708wRyA7WWTjBWL8bTFzWzSDuBfp2M9SXkYzKvTexcCJpMgt8Hv/2G69HWkDocX
 bVXuGjjpwKCpcgpzuf1IMXSeKXe/xCC3wJnedtzFLHIHXOh87OV6CJLh0PjjWpfsQ74KZ6x9
 hCdlLew643RbcZIDj102u9uG5HEfqOsvwTydxkGD4Q7wsB982HHJ28OBcNyYv8yZ8PyprwmP
 WQ+gadC0bNgJ87qNuKsJnAyG9a3hHnkD/Ly7DvMUfhYWzTuXa7Fgc9kKb4YX6isIDwfAgcc5
 y0zBgtxHy8s2AKgfn8OLAdf01ECmpwYy/V+6AuDVIIBWqtOTaXWkUiCnM//75iRFuhW4jyDk
 rWYweu9RmANgTOAAkInz1rFiEvqkbJZUciSLVinEKq2MVjtA5NLCT+CB65MUS1ck14gFwii+
 UCQSCaO2iwQ8f9ZEXqmUTSZLNHQaTStp1YoPY/oE6jCOKqflbuntxAXT/RJzMxiOaMG7398l
 KmUfWZwzlh+/qj3XhPe8lK+fDK7RLTaGj/P/MGc3DjU0+LNUjkTf3de0C1mbXyQD/A5dSaoO
 ey/rJyGDyyGzN2QoZv2LZCP7nx/h3OmC9piRN04s5nahPQ3zZRcsfZdt7z6o1x82//Dxbpbe
 W/tMf8PBP+1BEfs3vj1wNv2drbUVvjc5uu1rpCFlN07uyjpYa/Kt73w5aq7v0Ka8tOnr0Xaf
 hLj+2qirlYnBpzgjN/bu0/RkN2358JcmmWz9geDyQefP5k3302K+ONpmcFqcGUZbY4E2s3ef
 scr+e+xAyNmK1qOjQSUvmNm9VQ/EPIY6RSIIwVVqyb+Ahb/zjQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWy7bCSvK6cyLUUgy2bzSzWnzrGbNE04S+z
 xeq7/WwWrw9/YrR4cqCd0eLBfnuLve9ms1rcPLCTyWLl6qNMFpMOXWO0eHp1FpPF3lvaFgvb
 lrBY7Nl7ksXi8q45bBbzlz1lt1h+/B+TxY0JTxkttv2ez2yx7vV7FosTt6Qtzv89zuog5nH+
 3kYWj8tnSz02repk89i8pN5j980GNo/FfZNZPXqb37F5fHx6i8Xj/b6rbB59W1YxenzeJOex
 6clbpgCeKC6blNSczLLUIn27BK6M6xfmshUs4K94taOFvYFxA08XIyeHhICJRP+0JSxdjFwc
 QgK7GSWO77vEBJGQlFj29wgzhC0ssfLfc3aIomYmiRcn/rJ1MXJwsAloS5z+zwESFxHoYpbo
 3PmOBaSBWeAck8TJ2/wgtrBArMTLK1sYQWwWAVWJ9xcOgw3lFbCS+HPiOyvIHAkBfYn++4Ig
 YU4Ba4n3my6xgdhCQCUflh1khCgXlDg58wnUeHmJ5q2zmScwCsxCkpqFJLWAkWkVo2RqQXFu
 em6xYYFRXmq5XnFibnFpXrpecn7uJkZwnGpp7WDcs+qD3iFGJg7GQ4wSHMxKIry2wZdShHhT
 EiurUovy44tKc1KLDzFKc7AoifN+e92bIiSQnliSmp2aWpBaBJNl4uCUamBarm9pmbptUv63
 RzuP+zaej/Jaq8F5fe+vz5utDd7rnY1klI15GnV8wlXbaXmdT9e/1kkNmi0tmC1u6ejVptYf
 rtkW+GZmTf3UvYsEdn3NiXOsmJt0SMioiKMlaOcn0a3+/kynqlfPb9vqZjc7i/fzn39O68/O
 rd29m2mn0QX2XSefpYaVNiX6iKTsD6m123VtvafcJ60OV6nsg/vOf3gfvilg16LZqzbEN2rc
 v/6++cccJ4uTd3cp+Ds3yDOmqfM7XJCt/lT26Si/xb4U32zTNl6V29qvrmpkXz0TXKIzWfzM
 wglhXgwRifd5J9zLfrkuevqcjPv5ixao3jh6pC8o9JvovL/nVv2+6lok/FZWiaU4I9FQi7mo
 OBEAh25GcEIDAAA=
X-CMS-MailID: 20230811105734epcas5p1b465394a301ba85f2c52ed7fde334f52
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105734epcas5p1b465394a301ba85f2c52ed7fde334f52
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105734epcas5p1b465394a301ba85f2c52ed7fde334f52@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v14 06/11] fs,
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
 dlemoal@kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
index eaa98a987213..f5cf061ea91b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -738,6 +738,30 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -831,6 +855,7 @@ const struct file_operations def_blk_fops = {
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

