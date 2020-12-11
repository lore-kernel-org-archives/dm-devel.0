Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75834C1B0E3
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:00:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 695DF22BEF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 695DF22BEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-U3FF57noMq2HhTN2_F8E0Q-1; Mon, 14 Dec 2020 06:00:36 -0500
X-MC-Unique: U3FF57noMq2HhTN2_F8E0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCBA1107ACE4;
	Mon, 14 Dec 2020 11:00:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E39810016F7;
	Mon, 14 Dec 2020 11:00:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C11FA4E58E;
	Mon, 14 Dec 2020 11:00:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBEvSDG008623 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 09:57:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AF8CBF1014; Fri, 11 Dec 2020 14:57:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7D4AF1033
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 14:57:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D7B858280
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 14:57:24 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-384-4ppGlIG1M--dHwzZmjZ3SQ-1; Fri, 11 Dec 2020 09:57:21 -0500
X-MC-Unique: 4ppGlIG1M--dHwzZmjZ3SQ-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id
	20201211145718epoutp013c1a45e685199efd31113722ed904ca8~PsWTQ0XQD1168111681epoutp01M
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 14:57:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
	20201211145718epoutp013c1a45e685199efd31113722ed904ca8~PsWTQ0XQD1168111681epoutp01M
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20201211145717epcas5p22608a58a5da7ce017b50fa98c9f90ec0~PsWSLZWm80483404834epcas5p2N;
	Fri, 11 Dec 2020 14:57:17 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.00.50652.DC883DF5; Fri, 11 Dec 2020 23:57:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20201211135154epcas5p34cd7f57fb4b13fcd50619efdc0099fa8~PrdM5ATwv0152001520epcas5p3S;
	Fri, 11 Dec 2020 13:51:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20201211135154epsmtrp2af0d193a3214535a0e5e48537c9fabe8~PrdM3-diG0546605466epsmtrp2F;
	Fri, 11 Dec 2020 13:51:54 +0000 (GMT)
X-AuditID: b6c32a4a-6c9ff7000000c5dc-09-5fd388cd9fcb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	21.71.08745.A7973DF5; Fri, 11 Dec 2020 22:51:54 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20201211135151epsmtip26a5ca344d2057143679d0988adfaddc1~PrdJ0roqu2927029270epsmtip2E;
	Fri, 11 Dec 2020 13:51:51 +0000 (GMT)
From: SelvaKumar S <selvakuma.s1@samsung.com>
To: linux-nvme@lists.infradead.org
Date: Fri, 11 Dec 2020 19:21:37 +0530
Message-Id: <20201211135139.49232-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG9957uS3Ezksh7G3dRtJYF1hAV9z2mrnh0CxXjctipn8sc9DM
	KxChYgurzkXLhyIw2WAWR3F8yYaUWUZBRikgtiNEtENatKHDBiJ0OjZbBAt6RUd7Mfrf7zzn
	Oe9zTvLyceF8iJifrshmlAp5hoQMIzqsMTFxtpOO5HWXCinUfOs7ElX4HuLoeKEfQz33qkJQ
	d305hpqa+zF0e2yWhxaL3Rjqf/oficotNwHqcb2JHF1nSVTzyxQPlTg7SdQ48ARDZSdvYKiD
	rcHRyOl6HBmmvQQa9zp5aHrhColOtD4Am6Jox8h22qS7xaOH3K0E7bDl0EZ9EUm3NRyjzaMa
	kp6ZchG0t/cGSZe26wHddvUIPWt8nS7sK8E+EXwWtnEvk5H+FaNc+0FKWJr5McvL+g0eqpr+
	l9AAfUQxCOVDaj20DGvIYhDGF1JmAGt6/8S54j6A3xawGFfMAvhksRV7NtLH1gKu0QVg39zY
	c1eDyckLuEgqDt5sMBIBjqQkcLEljwiYcGoUh/ZH94OmCCoBnvXPgAATlBQO+K6TARZQ78PB
	gjKci4uGlfZ5HqeHwyuVk8FH8SU9/2JVcFlI5YfCOpcHcANbYK3BRnAcAf8ZaOdxLIaz93pI
	jtXQU1SxfI8GwFKvmuNEONy9uKTzlwJiYEvXWk5+DWoHDRiX+zI8xU4ujwpgZ/Vk0A6pNXDw
	93c4+VXos3YtJ9FwwawLspDaA6fy88D3IFr3wjW6F67RPQ+uBbgeiJgsVWYqo3o7S6Zg1PEq
	eaYqR5Ea/+WBTCMI/s3YbZ1gYtwXbwEYH1gA5OOSSAF7zJEsFOyVH/6aUR5IVuZkMCoLWMUn
	JK8IJAvXvhBSqfJsZj/DZDHKZ12MHyrWYNnRCVLr1kMbN+1sDc/z5T8US9cZesM/VZzZ0jYe
	tb90TEubau7S503xKxOGQrZWD6Ts2pHkaNGyucdFJd3VuQ2/yizpxrp6lbfZZe1Jss3vfje7
	6cemOM9Ft/9yy7mipxPnY1QfTlQY1h8UdZTnKtw/2b4RHT66/fG+drv9XGXpmUZ7IjmvXFF7
	esid80PGX7dXuMx3YtlJsX+3GiRFbbgw1Pd5h/XECMv8Xb7yaKXME+G5+tHcS87IPbKfnaAg
	5Q3TKSyVbCsrk/ofXLrwsYfetqNdenfDH9idSEPd6qbEUelmLS9tuL8iUT/TiGuZMfWISL4Z
	HqFk712b27Uq+pGEUKXJ34rFlSr5/84rHiEKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSvG5V5eV4gx3TlC1W3+1ns5j24Sez
	RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
	lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
	uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
	4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBm7//xmL9ggUTH79RuWBsZVwl2MnBwSAiYSB34v
	YOxi5OIQEtjBKPHo1WtmiISMxNq7nWwQtrDEyn/P2SGKPjJKfLx+ggUkwSagK3FtySYwW0RA
	SeLv+iYWkCJmgc/MEvN3tYElhAWMJeZ8+8gIYrMIqEoc/3ABbCqvgK3EqZaJUNvkJWZe+s4O
	EReUODnzCVAvB9AgdYn184RAwsxAJc1bZzNPYOSfhaRqFkLVLCRVCxiZVzFKphYU56bnFhsW
	GOWllusVJ+YWl+al6yXn525iBEesltYOxj2rPugdYmTiYDzEKMHBrCTCK8tyKV6INyWxsiq1
	KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGJscNrl03GG9qVC3fWFCQ
	1LD3fqfb4SPPb5core/W71M21XQTiD991yvU+3D15bhnNdE/Zia7l//KE/Zbqn3Hc/u2ZfIW
	pmyPztwxU5kiuL7kt9kbuRWxa/JKpucqtq2etd/M+e6FWW/YIqZdmznx0+UlXw75yDXbH3vZ
	LLGjYEHPs4YnRlKizXV/T4n4rzXty7lgkC0aqdXs9HhV7ozzJfHMb3YJv55cN6Utxrx0XzWn
	V4+GbjzbcvVZmQI3NrUdmdhZWO/k97L2RXepnsXfR1nB2WHf3aMnXF7H5fjfyLxP9y7b6vMz
	1+6WVC53UVp1I/ZQTfjXpX3Nyr+XN/Bs395zJJ2Bq+ZsYnv/nS5jJZbijERDLeai4kQAHK+k
	gkcDAAA=
X-CMS-MailID: 20201211135154epcas5p34cd7f57fb4b13fcd50619efdc0099fa8
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20201211135154epcas5p34cd7f57fb4b13fcd50619efdc0099fa8
References: <CGME20201211135154epcas5p34cd7f57fb4b13fcd50619efdc0099fa8@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BBEvSDG008623
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: axboe@kernel.dk, damien.lemoal@wdc.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	linux-scsi@vger.kernel.org, selvajove@gmail.com,
	Johannes.Thumshirn@wdc.com, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, nj.shetty@samsung.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	mpatocka@redhat.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, kbusch@kernel.org,
	javier.gonz@samsung.com, hch@lst.de, bvanassche@acm.org
Subject: [dm-devel] [RFC PATCH v3 0/2] add simple copy support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset tries to add support for TP4065a ("Simple Copy Command"),
v2020.05.04 ("Ratified")

The Specification can be found in following link.
https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip

This is an RFC. Looking forward for any feedbacks or other alternate
designs for plumbing simple copy to IO stack.

Simple copy command is a copy offloading operation and is  used to copy
multiple contiguous ranges (source_ranges) of LBA's to a single destination
LBA within the device reducing traffic between host and device.

This implementation accepts destination, no of sources and arrays of
source ranges from application. For devices suporting native copy
offloading, attach the control informantion as payload to the bio and
submits to the device. For devices without native copy support, copy
emulation is done by reading source range into memory and writing it to
the destination.

Following limits are added to queue limits and are exposed in sysfs
to userspace
	- *copy_offload* controls copy_offload. set 0 to disable copy
offload, 1 to enable native copy offloading support.
	- *max_copy_sectors* limits the sum of all source_range length
	- *max_copy_nr_ranges* limits the number of source ranges
	- *max_copy_range_sectors* limit the maximum number of sectors
		that can constitute a single source range.

	max_copy_sectors = 0 indicates the device doesn't support copy
offloading.

	*copy offload* sysfs entry is configurable and can be used toggle
between emulation and native support depending upon the usecase.

Changes from v2

1. Add emulation support for devices not supporting copy.
2. Add *copy_offload* sysfs entry to enable and disable copy_offload
	in devices supporting simple copy.
3. Remove simple copy support for stacked devices.

Changes from v1:

1. Fix memory leak in __blkdev_issue_copy
2. Unmark blk_check_copy inline
3. Fix line break in blk_check_copy_eod
4. Remove p checks and made code more readable
5. Don't use bio_set_op_attrs and remove op and set
   bi_opf directly
6. Use struct_size to calculate total_size
7. Fix partition remap of copy destination
8. Remove mcl,mssrl,msrc from nvme_ns
9. Initialize copy queue limits to 0 in nvme_config_copy
10. Remove return in QUEUE_FLAG_COPY check
11. Remove unused OCFS

SelvaKumar S (2):
  block: add simple copy support
  nvme: add simple copy support

 block/blk-core.c          |  94 ++++++++++++++++++--
 block/blk-lib.c           | 182 ++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         |   2 +
 block/blk-settings.c      |  10 +++
 block/blk-sysfs.c         |  50 +++++++++++
 block/blk-zoned.c         |   1 +
 block/bounce.c            |   1 +
 block/ioctl.c             |  43 +++++++++
 drivers/nvme/host/core.c  |  89 +++++++++++++++++++
 include/linux/bio.h       |   1 +
 include/linux/blk_types.h |  15 ++++
 include/linux/blkdev.h    |  16 ++++
 include/linux/nvme.h      |  43 ++++++++-
 include/uapi/linux/fs.h   |  13 +++
 14 files changed, 549 insertions(+), 11 deletions(-)

-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

