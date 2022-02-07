Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73B4C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:33:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-kv3S2resMBKF4W_HheWSpw-1; Tue, 08 Feb 2022 17:33:44 -0500
X-MC-Unique: kv3S2resMBKF4W_HheWSpw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA7EC84B9A8;
	Tue,  8 Feb 2022 22:33:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9B421037F51;
	Tue,  8 Feb 2022 22:33:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4AF4B473CF;
	Tue,  8 Feb 2022 22:33:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217EUYtG012650 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 09:30:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8CFC540FF696; Mon,  7 Feb 2022 14:30:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8854040FF690
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EE14803DDA
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:34 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-215-OFAX2Cf7NDeL7GMw4HgOdQ-1; Mon, 07 Feb 2022 09:30:31 -0500
X-MC-Unique: OFAX2Cf7NDeL7GMw4HgOdQ-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20220207142300epoutp0245fbfbae2170d7be70daeb5f0cdea9ff~RhwHHzJdN0687906879epoutp02E
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:23:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20220207142300epoutp0245fbfbae2170d7be70daeb5f0cdea9ff~RhwHHzJdN0687906879epoutp02E
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20220207142259epcas5p4a54c85eb6a5b263a7605f6232654a6db~RhwFw67Mf1944419444epcas5p4S;
	Mon,  7 Feb 2022 14:22:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4JspJX4Mknz4x9Pr;
	Mon,  7 Feb 2022 14:22:52 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F0.2E.46822.F8A21026; Mon,  7 Feb 2022 23:20:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20220207141924epcas5p26ad9cf5de732224f408aded12ed0a577~Rhs_OEOEH3248332483epcas5p2V;
	Mon,  7 Feb 2022 14:19:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220207141924epsmtrp2a557190332f6fece38e0a61005523cd6~Rhs_M6Kdm0696106961epsmtrp2T;
	Mon,  7 Feb 2022 14:19:24 +0000 (GMT)
X-AuditID: b6c32a4a-dfbff7000000b6e6-49-62012a8fdc8f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	B6.43.08738.C6A21026; Mon,  7 Feb 2022 23:19:24 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20220207141920epsmtip1a7ccbdb905ddb0402a8d97a28a9ac832~Rhs6Z13Yd0564005640epsmtip1J;
	Mon,  7 Feb 2022 14:19:20 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: mpatocka@redhat.com
Date: Mon,  7 Feb 2022 19:43:42 +0530
Message-Id: <20220207141348.4235-5-nj.shetty@samsung.com>
In-Reply-To: <20220207141348.4235-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfyycdxzH832eu+ceVvLs6HzJbLdTW1Dctce+p1Ua0jypbZFuaZZmYQ/3
	DOHO5Y61XcToaVe/lbTT6+Jom8mYVv04WkeLoYrN5rfVVBAJSnGM0dpxZ+t/r8+P9/f9/Xy+
	+ZI4v5LnRMYoEliVgokTEtYcfaubm2eeO4gQ/VaMI8PICheVj+US6NqLDRwtNk9yUX5uIQ/1
	TdmixoUbXNS7noqhyaptDBlu5mPop/I2DM2U3gIovasXQ1sTYtS2/ZxA+S2DADWOeiBDYycH
	6X6c5qHMoXoCNc014qi04xWGrlwewNCv2i0C6Td1OGr9a4CDyrcQupi1wUOzD8MCnem+/hD6
	imaBR2uKn3Lovp5EuqosnaCrb39LFwyXArphJIWgL3S34XThspGgh7rrMDpbs0DQS9OjHFo/
	kc2jF5sGCDqnpgyE2p+JPRrNMjJWJWAVkfGyGEWUvzDk0/CgcB9fkdhTLEUfCgUKRs76C4M/
	CvU8ERNnWpJQ8DUTl2hKhTJqtdD72FFVfGICK4iOVyf4C1mlLE4pUXqpGbk6URHlpWAT/MQi
	0SEfU+OXsdELFQZM2Q3P9egy8RSgs88AViSkJLAqPQdkAGuSTzUAOLs+ipuDZQD1m608c7AC
	4PpENb4nqU0b55oLDwC8M5qxW+BTFzGoeR6UAUiSoDxg1za5k7anHOBWr37XAqdWOHBwSMvb
	KdhRAbD9XhmxwxzKFWYtp3F22IaSQuMjo8XMBZZMNHN32Iryg2tb1yw9b8LO61O7jFPvQk3t
	jd1rQ2rUCv653Y2ZxcGw8N4zwsx2cLajhmdmJ7iy0EiYBZmm0brHMXNQCKAmT2NRBMDfDS+x
	nXFwyg3efeBtTjvDq0/uYGZnW5i9OWUxs4H1RXvsAn++W2w5xhEO/p1qYRo2ZbVaFtwP4NPF
	TiIPCLSvTaR9bSLt/9bFAC8DjqxSLY9i1T7KQwr27H/vHBkvrwK7X8f9ZD2YePbCqwVgJGgB
	kMSF9jZvZ24zfBsZc/4bVhUfrkqMY9UtwMe08iu40/7IeNPfUySEiyVSkcTX11ciPewrFjrY
	dEVVMnwqiklgY1lWyar2dBhp5ZSCBa0GLBtfiub/qKi/XXJcah/UEnSgn7t0wufx6bB9/5Ah
	q5cuf1ISNt+cROjOiAUbh5tfXU8SlK2G5Z41pEkXI3oeOVp3HRn0Sr7k8dbBC4HvyDqvSj1n
	aG5DlleMMWmQM+j91VpiRpsNeswtIEvr/KqHC0Sz7Xz52sf3i6zn3tinDXxSwJ39bv6HBavA
	+/JfrPRDQ8UPI0bGIiNcbWOcrU9NcmrOL7rzXdMi3hsZrw8/UtkxbLeUsTpTkup1cnmuYppP
	1gVLKr84/f7wQT+P/TJjrZ3LpO25me9DtBu1x52Sw491kDm6z4qMdiF0bnKoR9rNsZQPPl+/
	5eAzckrWjjMzB4QcdTQjdsdVauZfcJk/YcMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsWy7bCSnG6OFmOSwZo1BhZ7bn5mtVh9t5/N
	YtqHn8wW7w8+ZrWY1D+D3eLyEz6Lve9ms1pc+NHIZPF4038miz2LJjFZrFx9lMni+fLFjBad
	py8wWfx5aGhx9P9bNotJh64xWuy9pW2xZ+9JFov5y56yW3Rf38Fmse/1XmaL5cf/MVlM7LjK
	ZHFu1h82i22/5zNbHL53lcVi9R8Li9aen+wWr/bHOch6XL7i7TGx+R27R/OCOywel8+Wemxa
	1cnmsXlJvcfkG8sZPXbfbGDzaDpzlNljxqcvbB7Xz2xn8uhtfsfm8fHpLRaPbQ972T3e77vK
	5tG3ZRVjgEgUl01Kak5mWWqRvl0CV8a7tXuYCs5IVJyd383cwDhfpIuRk0NCwERia8t91i5G
	Lg4hgR2MEs/bu9khEpISy/4eYYawhSVW/nsOFhcSaGaSOHVSp4uRg4NNQFvi9H8OkLCIgLjE
	nwvbGEHmMAtMZ5VoOHWZCSQhLGAvcWzjKjYQm0VAVaLnUwsLiM0rYCnx5cAXqPnKEgsfHmQF
	sTkFrCS+/ZnGAnFQA6NEw7kVrBANghInZz4Ba2YWkJdo3jqbeQKjwCwkqVlIUgsYmVYxSqYW
	FOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgSnBC2tHYx7Vn3QO8TIxMF4iFGCg1lJhFem+3+i
	EG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUxCO59dctb8
	f/N7q7Bdk+m3NVvTdu+o93Sa8e3ceYUu/6znW9K2MTenP7EVEPBfbzH7gPvNL3vLpPQ+aTCb
	PHE5F6kVLix98I3T2YpdZ2ovyDw+GVRXN8VfyrMiZP/sLuvS7OLEAwuTDF90rfczNlv+S2XZ
	jSvms3NcTNg8xQU0TjCvXn/b8Whs19P5q1/k8Dpt+K+0ufhPp3+/Z82j5iLZHQ9/GhyuPmK9
	MN7VMdWk4mNPZNTpYIe+U5kuggc+WiQ0P/xRLWdy+eyJSAenM067SnmjNTf5hT1lEtpTOPnq
	JHfRWu/rApdVrjrx9Ew66+W8+sT6tWfvFr0v/z65YE1K2empryuvBlUYK1nanFJiKc5INNRi
	LipOBABRSx0eeAMAAA==
X-CMS-MailID: 20220207141924epcas5p26ad9cf5de732224f408aded12ed0a577
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220207141924epcas5p26ad9cf5de732224f408aded12ed0a577
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141924epcas5p26ad9cf5de732224f408aded12ed0a577@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 217EUYtG012650
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 08 Feb 2022 02:51:51 -0500
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: [dm-devel] [PATCH v2 04/10] block: Introduce a new ioctl for copy
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

Add new BLKCOPY ioctl that offloads copying of one or more sources ranges
to one or more destination in a device. COPY ioctl accepts a 'copy_range'
structure that contains no of range, a reserved field , followed by an
array of ranges. Each source range is represented by 'range_entry' that
contains source start offset, destination start offset and length of
source ranges (in bytes)

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
---
 block/ioctl.c           | 37 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |  9 +++++++++
 2 files changed, 46 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index 4a86340133e4..d77f6143287e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -124,6 +124,41 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 	return err;
 }
 
+static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
+		unsigned long arg)
+{
+	struct copy_range crange, *ranges;
+	size_t payload_size = 0;
+	int ret;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
+		return -EFAULT;
+
+	if (unlikely(!crange.nr_range || crange.reserved || crange.nr_range >= MAX_COPY_NR_RANGE))
+		return -EINVAL;
+
+	payload_size = (crange.nr_range * sizeof(struct range_entry)) + sizeof(crange);
+
+	ranges = kmalloc(payload_size, GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
+
+	if (copy_from_user(ranges, (void __user *)arg, payload_size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = blkdev_issue_copy(bdev, ranges->nr_range, ranges->range_list, bdev, GFP_KERNEL, 0);
+	if (copy_to_user((void __user *)arg, ranges, payload_size))
+		ret = -EFAULT;
+out:
+	kfree(ranges);
+	return ret;
+}
+
 static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 		unsigned long arg)
 {
@@ -455,6 +490,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 	case BLKSECDISCARD:
 		return blk_ioctl_discard(bdev, mode, arg,
 				BLKDEV_DISCARD_SECURE);
+	case BLKCOPY:
+		return blk_ioctl_copy(bdev, mode, arg);
 	case BLKZEROOUT:
 		return blk_ioctl_zeroout(bdev, mode, arg);
 	case BLKGETDISKSEQ:
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 55bca8f6e8ed..190911ea4311 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -78,6 +78,14 @@ struct range_entry {
 	__u64 comp_len;
 };
 
+struct copy_range {
+	__u64 nr_range;
+	__u64 reserved;
+
+	/* Range_list always must be at the end */
+	struct range_entry range_list[];
+};
+
 /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
 #define FILE_DEDUPE_RANGE_SAME		0
 #define FILE_DEDUPE_RANGE_DIFFERS	1
@@ -199,6 +207,7 @@ struct fsxattr {
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
 #define BLKGETDISKSEQ _IOR(0x12,128,__u64)
+#define BLKCOPY _IOWR(0x12, 129, struct copy_range)
 /*
  * A jump here: 130-136 are reserved for zoned block devices
  * (see uapi/linux/blkzoned.h)
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

