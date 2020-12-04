Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321F7C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 369102310B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 09:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 369102310B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-gLnd9CL1MN2ouISaVtO6PA-1; Mon, 07 Dec 2020 04:59:56 -0500
X-MC-Unique: gLnd9CL1MN2ouISaVtO6PA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63E28803F69;
	Mon,  7 Dec 2020 09:59:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C2AA1A7C1;
	Mon,  7 Dec 2020 09:59:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 90D56180954D;
	Mon,  7 Dec 2020 09:59:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4B9sIV003370 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 06:09:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4EE3810D16D8; Fri,  4 Dec 2020 11:09:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AF1B10D16DA
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 11:09:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C578103B800
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 11:09:52 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-526-8b_e1ZImOCC2xNek-zZuPQ-1; Fri, 04 Dec 2020 06:09:49 -0500
X-MC-Unique: 8b_e1ZImOCC2xNek-zZuPQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20201204110208epoutp02caa2776c59d2968d4721c9896c00de05~Nfn_ElIBJ3253132531epoutp02u
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 11:02:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20201204110208epoutp02caa2776c59d2968d4721c9896c00de05~Nfn_ElIBJ3253132531epoutp02u
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20201204110207epcas5p208934b5f67b6f15fe11761b1292f0dc5~Nfn9MckUd2339123391epcas5p2S;
	Fri,  4 Dec 2020 11:02:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	39.9C.50652.F271ACF5; Fri,  4 Dec 2020 20:02:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5~NempRmT2H2182421824epcas5p2V;
	Fri,  4 Dec 2020 09:47:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20201204094719epsmtrp122b4869dd4861c71d0efc9ac0aa99115~NempQw_vK2092920929epsmtrp1x;
	Fri,  4 Dec 2020 09:47:19 +0000 (GMT)
X-AuditID: b6c32a4a-6b3ff7000000c5dc-a8-5fca172f1ed9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C9.28.13470.6A50ACF5; Fri,  4 Dec 2020 18:47:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20201204094716epsmtip2329cbe727fd325e53ac93dbc006cd44d~Nemmxh8jE0388403884epsmtip2M;
	Fri,  4 Dec 2020 09:47:16 +0000 (GMT)
From: SelvaKumar S <selvakuma.s1@samsung.com>
To: linux-nvme@lists.infradead.org
Date: Fri,  4 Dec 2020 15:16:57 +0530
Message-Id: <20201204094659.12732-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmlq6++Kl4g8tP2SxW3+1ns2ht/8Zk
	sffdbFaLlauPMlk8vvOZ3eLo/7dsFpMOXWO02HtL2+LyrjlsFvOXPWW32PZ7PrPFlSmLmC3W
	vX7PYvHg/XV2i9c/TrJZtG38yugg4LFz1l12j/P3NrJ4XD5b6rFpVSebx+Yl9R67bzawebzf
	d5XNo2/LKkaPz5vkPNoPdDMFcEVx2aSk5mSWpRbp2yVwZbx8Ppm14KBQxdlzDUwNjEf4uhg5
	OSQETCRu3Wlg62Lk4hAS2M0ocXD6ESjnE6PE/SNfmECqhAS+MUq8WskE07Gk5xkjRNFeRolz
	j25BOZ8ZJT41PwOrYhPQlbi2ZBMLiC0ioCTxd30TC0gRs8ApJommf7vYQRLCAsYS8/ffZQSx
	WQRUJV7P2Q3WzCtgK7Fx1xU2iHXyEjMvfWeHiAtKnJz5BGwoM1C8eetsZpChEgJ7OCRenF8I
	lOAAclwk2l67Q/QKS7w6voUdwpaSeNnfBmWXSzzrnAb1TgOjRN/7cgjbXuLinr9MIGOYBTQl
	1u/ShwjLSkw9tY4JYi2fRO/vJ1CtvBI75j1hgtiqJnFquxlEWEbiw+FdUNd7SLTsXs0OCcRY
	ia3PtzNOYJSfheSZWUiemYWweAEj8ypGydSC4tz01GLTAqO81HK94sTc4tK8dL3k/NxNjODk
	puW1g/Hhgw96hxiZOBgPMUpwMCuJ8MaqnowX4k1JrKxKLcqPLyrNSS0+xCjNwaIkzqv040yc
	kEB6YklqdmpqQWoRTJaJg1OqgWm6wa3GB7U5GQb7FO0nt69fPyfEVk96zreyaXsefdDxrVzd
	P/tJ3wQm8dl/9l5t7JzzVnBtxJ3tKgeZHflFJ6sKlU7ReCZ5pjp59tng0nCOpSrxiQfuWa+9
	vsS25QDTa+bUYK8Zqq4rdk+ZqtG0/PmMhjyXMMbYjauDDI34nk9SsJFoYr6sY9HJuGjOBuVH
	M74dXnt469dN5h9MJi5j0zunufLB22sGx/g9vp4OLTFIXJpusvqOUsSFvUsONQee7uJdu/e6
	BOspS+sHK9fecvik7Svo8rZuCZ8k84/SmgmLp7AEvXzT4TW3QO/Le83lBz4GJ3Y6tk1c6/5S
	5227+Ie9OrzLJRh3nHzoenPutl5jJZbijERDLeai4kQA23lOOt0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJXnc566l4g2dSFqvv9rNZtLZ/Y7LY
	+242q8XK1UeZLB7f+cxucfT/WzaLSYeuMVrsvaVtcXnXHDaL+cueslts+z2f2eLKlEXMFute
	v2exePD+OrvF6x8n2SzaNn5ldBDw2DnrLrvH+XsbWTwuny312LSqk81j85J6j903G9g83u+7
	yubRt2UVo8fnTXIe7Qe6mQK4orhsUlJzMstSi/TtErgyXj6fzFpwUKji7LkGpgbGI3xdjJwc
	EgImEkt6njGC2EICuxkl1m+2g4jLSKy928kGYQtLrPz3nL2LkQuo5iOjxJLLE8Aa2AR0Ja4t
	2cQCYosIKEn8Xd8EZjML3GGS2PbDFcQWFjCWmL//Llg9i4CqxOs5u5lAbF4BW4mNu65ALZCX
	mHnpOztEXFDi5MwnQHM4gOaoS6yfJwQxUl6ieets5gmM/LOQVM1CqJqFpGoBI/MqRsnUguLc
	9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgqNLS3MG4fdUHvUOMTByMhxglOJiVRHhjVU/GC/Gm
	JFZWpRblxxeV5qQWH2KU5mBREue90AWUEkhPLEnNTk0tSC2CyTJxcEo1MFm+eODexX/fNo+H
	NcFKWW3Cac7PbRNtrWuDIr2nd82MuRrNuKjhziIRtrCOdZsSpx+b66ny/F2+eeFr/b3KVr2X
	3J9ldaVw5LLEpZ7TyNX7u8jyD6/yocJFocdfnSjZv+Tk75+Fs5SFrx330FPf9v7Y5isn1fj1
	rqXoyc2IWcv07f/fmIPGLGnz6+pMHpybZhTbv/Po+lsKOybV/azn5QwJVX4e6CkdPZHZWsJu
	l9GDbZp66q9dXx72lchcFJ979qH+kn/zTb+macfIWHv8qSjQ++euNoF5wabHM5fzrpf4Z3qQ
	qffZ11X9ngXpf+6HmPE6T+j9cFzZdd5Btdrl2vNdE3O5Nyf7vlQ511QiocRSnJFoqMVcVJwI
	AOAWwJIZAwAA
X-CMS-MailID: 20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B4B9sIV003370
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Dec 2020 04:59:37 -0500
Cc: axboe@kernel.dk, damien.lemoal@wdc.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, nj.shetty@samsung.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	joshi.k@samsung.com, kbusch@kernel.org, javier.gonz@samsung.com, hch@lst.de
Subject: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
source ranges from application and attach it as payload to the bio and
submits to the device.

Following limits are added to queue limits and are exposed in sysfs
to userspace
	- *max_copy_sectors* limits the sum of all source_range length
	- *max_copy_nr_ranges* limits the number of source ranges
	- *max_copy_range_sectors* limit the maximum number of sectors
		that can constitute a single source range.

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

 block/blk-core.c          |  94 ++++++++++++++++++++++++++---
 block/blk-lib.c           | 123 ++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         |   2 +
 block/blk-settings.c      |  11 ++++
 block/blk-sysfs.c         |  23 +++++++
 block/blk-zoned.c         |   1 +
 block/bounce.c            |   1 +
 block/ioctl.c             |  43 +++++++++++++
 drivers/nvme/host/core.c  |  87 +++++++++++++++++++++++++++
 include/linux/bio.h       |   1 +
 include/linux/blk_types.h |  15 +++++
 include/linux/blkdev.h    |  15 +++++
 include/linux/nvme.h      |  43 ++++++++++++-
 include/uapi/linux/fs.h   |  13 ++++
 14 files changed, 461 insertions(+), 11 deletions(-)

-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

