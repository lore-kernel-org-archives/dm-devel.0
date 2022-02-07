Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D80BC4332F
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:34:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-Tz0z2fu3MiK5o93NQdnrAA-1; Tue, 08 Feb 2022 17:34:24 -0500
X-MC-Unique: Tz0z2fu3MiK5o93NQdnrAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D185B1091DB6;
	Tue,  8 Feb 2022 22:34:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B6E0879FE;
	Tue,  8 Feb 2022 22:34:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45A1B18523D2;
	Tue,  8 Feb 2022 22:34:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217EUV6d012639 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 09:30:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7B6EEC0809B; Mon,  7 Feb 2022 14:30:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76348C08098
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CB66811E7A
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:31 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-532-QMgwZrNMMOWPfF3LDtSrKg-1; Mon, 07 Feb 2022 09:30:29 -0500
X-MC-Unique: QMgwZrNMMOWPfF3LDtSrKg-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20220207142247epoutp02fb33f95e03c3f526d635ddce9d922931~Rhv6zMUjs0538505385epoutp02W
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:22:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20220207142247epoutp02fb33f95e03c3f526d635ddce9d922931~Rhv6zMUjs0538505385epoutp02W
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20220207142246epcas5p3d1e902b8f18dde09cfab0780f0a9a413~Rhv6J9Buf1616716167epcas5p3k;
	Mon,  7 Feb 2022 14:22:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4JspJL2Cvhz4x9Pw;
	Mon,  7 Feb 2022 14:22:42 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	24.5F.06423.23B21026; Mon,  7 Feb 2022 23:22:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20220207141908epcas5p4f270c89fc32434ea8b525fa973098231~Rhsuv2ZRv3069230692epcas5p4c;
	Mon,  7 Feb 2022 14:19:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220207141908epsmtrp1bc38ae71f57bbe6e5ae06984b9b559c1~RhsuuVp2C0764707647epsmtrp1u;
	Mon,  7 Feb 2022 14:19:08 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-2c-62012b3288e7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	DF.33.08738.C5A21026; Mon,  7 Feb 2022 23:19:08 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20220207141904epsmtip18597f2262c82f183ea500a689687c70d~Rhsq5dSBw0282502825epsmtip1l;
	Mon,  7 Feb 2022 14:19:04 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: mpatocka@redhat.com
Date: Mon,  7 Feb 2022 19:43:39 +0530
Message-Id: <20220207141348.4235-2-nj.shetty@samsung.com>
In-Reply-To: <20220207141348.4235-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te1BUVRzu3Lt7dxcDr4DDESFxLQyJxyqsB5UUtbypDBSjmc1IV7jCBuwu
	u4umTgnsgAISj+IpK1giystEoBUXTIiYDXB4iIiDDwJzgAEBkQCRjeVC+d/3fef7Pc/8+Lh5
	Gc+aL5GqGIWUDhUSJpzKOgcHp/WO4LDr+I8CpOt6wUVFD5MIlD4yhaPnt3u5KDUpk4fa+8xQ
	9fA5LmqZjMJQb5kBQ7qfUjF0pageQ88KfgYorrEFQzM9IlRvGCJQau09gKofOCJdtZ6Dci89
	5aGETi2BagarcVTQMIuhlDMdGLqTPUOgyle5OKp71MFBRTMIDU7qCRRzdoqHBm4d2vYO1X53
	D5WiHuZR6rxuDtXeHEGVFcYR1PWLp6gf7hcA6mZXJEFFN9XjVObYOEF1Nv2KUYnqYYIaffqA
	Q1X2JPKo5zUdBPV9eSHwtTwYsiWYoQMZhR0jDZAFSqRBnsI9fv47/N3FriInkQfaKLST0mGM
	p3DnXl+njyWhc5sS2h2lQyPmJF9aqRS6fLhFIYtQMXbBMqXKU8jIA0PlbnJnJR2mjJAGOUsZ
	1SaRq+t69znjVyHBQ12ZXHny299k1iRgkeCsSTzg8yHpBtPyl8QDE745eRPAjM5WjCVjALaU
	X+Ow5AWAaaOjnMWIulac1asA1GUZeCyJwWB+dRNuNBGkI2w08OOBgG9JWsGZlkpg9OBkDhdG
	TfVzjA8W5FZYdKOEa8Qc8j04lRGPG7Ep6QGvxRQBI4bkGnih5/a8R0BughMz6RzWswzqs/rm
	MU6uguqKczjrfySAWaWQbXQnLOngsrIFHGgo57HYGvYnxc73DMkEACebHmMsyQRQnawmWNdW
	2Kp7jRkT4aQDvFrlwsq2MO3PUoytawYTX/VhrG4KtecX8RpYfDVvIc0KeO+fqAVMwfjKvxc2
	dxfAjit/8JKBXfYb82S/MU/2/6XzAF4IVjByZVgQo3SXi6TMsf8+OUAWVgbmj2fdJ1rw8MmI
	cy3A+KAWQD4utDS1STDQ5qaB9PETjELmr4gIZZS1wH1u4Sm49fIA2dz1SVX+IjcPVzexWOzm
	sUEsElqZNgb9QpuTQbSKCWEYOaNYjMP4AutIzFsc7od/eXyz34BLxsW9Mh+JInD3xom1tnUT
	RwSaz8IrmNdmKVaH35cs1dZrT+jS/hp8EiSY1ibEmNe1eRlo4MP5rVCwLM5iYOQo83m6TRbW
	/S13dFozK3qrO/b8KY0mOrZdkqCNOl07prPZnzXdsbpx6fCuffKwnE7HofpDfZutxZeSnfrt
	1Sn633u91bsazvS91H/h1TYekFt1h7tqJjdyeb2utcKl5Lsc/Q6c+/Vs8actBw5c3l5tf1Lj
	z4uOdyihtq0suqCyPNlM7vbx1qwMd342e7rdol2wunfDB4ZCrxvR+/Y7F/s03z9y8OWxx++2
	6dZe/2jJZaXtbGmn7Ja9KF8u5CiDadE6XKGk/wUZlf3sxQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWy7bCSnG6MFmOSwZ1//BZ7bn5mtVh9t5/N
	YtqHn8wW7w8+ZrWY1D+D3eLyEz6Lve9ms1pc+NHIZPF4038miz2LJjFZrFx9lMni+fLFjBad
	py8wWfx5aGhx9P9bNotJh64xWuy9pW2xZ+9JFov5y56yW3Rf38Fmse/1XmaL5cf/MVlM7LjK
	ZHFu1h82i22/5zNbHL53lcVi9R8Li9c/TrJZtPb8ZLd4tT/OQc7j8hVvj4nN79g9mhfcYfG4
	fLbUY9OqTjaPzUvqPSbfWM7osftmA5tH05mjzB4zPn1h87h+ZjuTR2/zOzaPj09vsXhse9jL
	7vF+31U2j74tqxgDRKK4bFJSczLLUov07RK4Mt7enMFaMIGnYsa+bqYGxh6uLkYODgkBE4nD
	F5m7GLk4hAR2MEos3LeZrYuREyguKbHs7xFmCFtYYuW/5+wQRc1MEidabzOBNLMJaEuc/s8B
	UiMiIC7x58I2RpAaZoFDrBL/zr0BaxYWsJdYvXMtK4jNIqAq8XN6F1icV8BSYmPrakaIBcoS
	Cx8eBKvhFLCS+PZnGgvEsgZGiYZzK1ghGgQlTs58wgJiMwvISzRvnc08gVFgFpLULCSpBYxM
	qxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgpODltYOxj2rPugdYmTiYDzEKMHBrCTC
	K9P9P1GINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpg1z
	jCynvph8R/OR3GK+F9Gn/VRS/IMks1btO786TtuHrTb4x+eH/nNnn1pqFV0nKpt8z7k49IQv
	h8cheRG3SPn1DW7NJ+ZzKXYmrjv9/eWb2/6512/HHjmlrqyyVfpN+reD1dbRU7SctleGW4cf
	yQ6+unXn7XM9zzxai47bO8UtT2/iCKm/myj4L8P0aUbQKd+n86qOPXq269vsqQaB7xy3N+6+
	d0DheoXq3SsCS9t41KftzuO+ultB7c/SGXN+iU55sDf2tZzy/wu/+hV3t/F2BcRfnjPvyPcg
	Bc9Qdb9+hmW7p6oGddU15/2M1Dn549EJiRSjN00/1QpPsahcC9h7XmUtk4GDn+h8w9Ctckos
	xRmJhlrMRcWJADEwHpZ9AwAA
X-CMS-MailID: 20220207141908epcas5p4f270c89fc32434ea8b525fa973098231
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220207141908epcas5p4f270c89fc32434ea8b525fa973098231
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141908epcas5p4f270c89fc32434ea8b525fa973098231@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 217EUV6d012639
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 08 Feb 2022 02:51:51 -0500
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, SelvaKumar S <selvakuma.s1@samsung.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: [dm-devel] [PATCH v2 01/10] block: make bio_map_kern() non static
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: SelvaKumar S <selvakuma.s1@samsung.com>

Make bio_map_kern() non static

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/blk-map.c        | 2 +-
 include/linux/blkdev.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde0156..c110205df0d5 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -336,7 +336,7 @@ static void bio_map_kern_endio(struct bio *bio)
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_map_kern(struct request_queue *q, void *data,
+struct bio *bio_map_kern(struct request_queue *q, void *data,
 		unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3bfc75a2a450..efed3820cbf7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1106,6 +1106,8 @@ extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, int flags,
 		struct bio **biop);
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+		gfp_t gfp_mask);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

