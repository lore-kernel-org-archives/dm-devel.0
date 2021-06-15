Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6B1C48BE6
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 07:26:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 889C06135C
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 07:26:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 889C06135C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-UaiI5iTrOzaOxc3_k4LjGQ-1; Wed, 16 Jun 2021 03:26:17 -0400
X-MC-Unique: UaiI5iTrOzaOxc3_k4LjGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73703BBEE3;
	Wed, 16 Jun 2021 07:26:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4846060853;
	Wed, 16 Jun 2021 07:26:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6620D46F82;
	Wed, 16 Jun 2021 07:26:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15FFuw3u019411 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 11:56:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3E29921D4F3B; Tue, 15 Jun 2021 15:56:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38D6621D4F38
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 15:56:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91DC280D0E8
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 15:56:55 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
	[210.118.77.12]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-105-iBJYSlQ3MfGy_ujrUIi6GA-1; Tue, 15 Jun 2021 11:56:36 -0400
X-MC-Unique: iBJYSlQ3MfGy_ujrUIi6GA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
	20210615154748euoutp025393b0ef1c05766c8964ff08effcb737~IzBfLeirf0708407084euoutp02U;
	Tue, 15 Jun 2021 15:47:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
	20210615154748euoutp025393b0ef1c05766c8964ff08effcb737~IzBfLeirf0708407084euoutp02U
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20210615154747eucas1p10fc0c489f6b2b99ec3ee3c0d1d182386~IzBerCabW2052020520eucas1p1O;
	Tue, 15 Jun 2021 15:47:47 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 25.05.09439.3ABC8C06;
	Tue, 15 Jun 2021 16:47:47 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61~IzBeAseUp3082930829eucas1p1T;
	Tue, 15 Jun 2021 15:47:46 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210615154746eusmtrp2ae9e870f68d5a24f27850c8ddaf7c3b5~IzBd-erfP0310203102eusmtrp2N;
	Tue, 15 Jun 2021 15:47:46 +0000 (GMT)
X-AuditID: cbfec7f5-c03ff700000024df-5c-60c8cba39819
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 42.91.08705.2ABC8C06;
	Tue, 15 Jun 2021 16:47:46 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20210615154744eusmtip131f3ea0c677d37e629dba0cc864eb86e~IzBb_60KM0958409584eusmtip1b;
	Tue, 15 Jun 2021 15:47:44 +0000 (GMT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <13b21a07-b7c7-37db-fdc9-77bf174b6f8f@samsung.com>
Date: Tue, 15 Jun 2021 17:47:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210602065345.355274-10-hch@lst.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH855zenrapXgoKK/KhqvTZGWCzC2+CQ4vY3DiB0S2+IEt0gZO
	AIVqWphuy5SAE22GVEqkazcucimTi1puAlOkjJtAZVAmVhgpgiLCBnLbEOgohY1vv+f/f573
	ef7JS+FCM7mFipbFsXKZNEZE8onKpn9Mu3LbWiS7Uy57oKL+VBLd1tzkoIzCKgJNPE7D0N0/
	dRxkflALUN4LP9SpneWgyrZbXPQy8wZAPxc1YmggM5lEBV1TGBo3pBNoweqDzAk7UUHuMEB3
	LZ7oV1sqQLWJBVykyknC0eu5JQ4aa73ORQ3J9zjINj/KQa+HSzBkbSrCkbp6DCDNw1wOunh7
	BqDBfD2ObB0TXKTvyCTRXLkaOyBiMou/YV6qVYBpfdFOMI0N9VymftBIMtXafi5TVihm2sb6
	MKa7I54ZMmdgjOr6fcCU5Z1n1L16wDzU5ACmYcJMMLWPE8jgzaH8fRFsTPSXrNzbT8KPSsu6
	T5x+6nlW89vWBGDYrgQ8CtIfQMtIO1ACPiWkCwFsNtlwRzENYNGUcrWYWnbSdWBtpGAxHbez
	kNYD+HuH1NE0CWDxcB9mN1zoj+BgqYljZ1f6ANTdyiftTTidx4OPTImE3SBpH6gcVy4bFCWg
	/WBKjbtdJugdcMx6lbTzRjoc/pWpWXlHQDvD1h+GVkZ59PvwQZ1thXHaAyZV6HAHu0HLUBZm
	3wXpIT68ZOnFHFf7Q7M+lXSwCxxtLuc62B3aqtcGkgC0mkq4juJ7ALsTNauZfWGfaX7lUpx+
	F96s8XbIB+EF5R3cLkPaCfaOOzuOcIJplRmrsgBeuih0dO+E2ubS/9bWd3bhKiDSroumXRdH
	uy6O9v+92YC4AdzYeEVsJKvYI2PPeCmksYp4WaRX+KlYA1j++G1LzTN3QOHopJcRYBQwAkjh
	IlfBLkWLRCiIkH71NSs/FSaPj2EVRrCVIkRugpqK4jAhHSmNY0+y7GlWvuZiFG9LAiZNenOA
	91nluZmjE82fuxiajs+W+Zs/je/6IzrLemK3qTfkO3d5NRUaZ9nb8/yLeZPR3+TtNiIJrko7
	UTHicczvSonhvSD3zopXruqze62zXYq6HZ7RsQPeHPMbf9/ruXDcqWnTj7KynpDAKnVIpa86
	Oyk/efJg8DXLtvyRw6Pftsqm0o4U6558eDJIwVzpf7Kg5UdiAZuf/zQksUU9Dd0n1B9++61p
	7wiLpj3gWGjgonYpfSFAnnL+qFg19/EnYs2zwP3Xlq6eyfY9FFjX8mjD9ukw57xt4tCmd+a4
	3ZJfgjz3h5/jPts4sFjaIDF6ZFQX5ZSVHyIbDSXDG46o6Fd7XC/PbxIRiiipjxiXK6T/AgrX
	tBBnBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTdxjG+Z9bC6Tk0JZ4hpiZLkMDo9AC9c8C1C/bzrIsUaaJUxxt8HAR
	KK6Xpduy2YiKdi5UWgYrrlxbqsBALjpuU6l1AkOGY2YSmFBgC1gUr4xx6WjZEr798r7P70ne
	5GWj3Bk8lJ2tUDNKhTxXQARgA2s/jUdVD9yWxXT/FQvrx4sIeLmsCYel9qsYXLhfjMCeR+U4
	HOnvArB2Nhn+Yn6JwysDzSz40HIJwIv1TgQ+sBQS0Hb3GQLnW0wYXJkUwRFdOLTVzADYMxoJ
	b3qKAOw6YWNBQ1UBCpcX13Do7qtmQUfhjzj0/DOHw+WZRgRO3qpHobHDDWDZUA0OT19+AaDL
	WodCz+ACC9YNWgi42GZEdgtoS8Pn9EOjAdB9sz9jtNNxg0XfcPUSdId5nEW32iPoAfcYQv86
	qKGnR0oR2lB9HdCttcdp4+91gB4qqwK0Y2EEo7vu64g9rxwUJirzNWpme1a+Sp0kOCSCYqEo
	AQrFcQlCUeyuw2+K4wXRyYlHmNzsTxhldLJMmFVccR07NhWpLRveqgMtr+mBP5si4yjbqgn1
	Mpe0Aur5hP/GPIzq+0aHbzCPWrmnJ/QgYD3zGFC/TX1FeBc8MolyfX/HF+KTu6nyZqsvhJI2
	f2p0eJy10XqAWio45WOCFFH6eW8Tm80hk6mvO8O8Y4x8nXJPnvd1hpDp1FJToY85ZDDV9+00
	5mV/Ukz1X/P4GCUllKV1Et3gV6mC9vL/eAs1Ol2BGADXvEk3b1LMmxTzJqUSYJcAn9Go8jLz
	VCKhSp6n0igyhen5eS1g/d+u3Fpq/QFY5p4IewHCBr2AYqMCPidKdVvG5RyRf/oZo8xPU2py
	GVUviF+/5zwaGpKev/6wCnWaSBITL4qTJMTEJ0hiBVs47d81pHHJTLmayWGYY4zyfw9h+4fq
	kNS43HOz8asBOc8aX3QWHdI2B9szLmRI91hXnU/3HnVlVa2IU6TbwAcmtd8ux0SkNkJnr8zo
	3Pruny9Loi0V147ST2oJSebQO4q7N7e5+NgfbfwKrTnxcXRgqeSjKb+9y3/Lz+akLrIP0MPZ
	jtTjYcXZ+/AvwkOGrMbnNU1BTNC8VvrxNO9DnnQqiCdlC9z7A9faL8pOTtRuX+wcHtP3Ne54
	dLjh5E6TM5A01r5ve3vsTkp/lMMkqzI0vReZ4GfYGZKUcoLz5VvwzOmOC0/5SzOERRlc2Xau
	lMc45SV27X7rG0EZptUzJVcPeuDZsHqsslvnyuspnet4EH6K6Q6/J8BUWXJRBKpUyf8FChkx
	W/gDAAA=
X-CMS-MailID: 20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61
X-Msg-Generator: CA
X-RootMTR: 20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61
References: <20210602065345.355274-1-hch@lst.de>
	<20210602065345.355274-10-hch@lst.de>
	<CGME20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15FFuw3u019411
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 16 Jun 2021 03:23:33 -0400
Cc: Justin Sanders <justin@coraid.com>, Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael
	S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, Geoff, Konrad, "Md. Haris
	Iqbal" <haris.iqbal@ionos.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Gorbik <gor@linux.ibm.com>,
	Alex Dubov <oakad@yahoo.com>, Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, Vasily, ceph-devel@vger.kernel.org,
	Levand <geoff@infradead.org>, linux-mmc@vger.kernel.org,
	dm-devel@redhat.com, Vignesh, linux-mtd@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 09/30] mtd_blkdevs: use blk_mq_alloc_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgpPbiAwMi4wNi4yMDIxIDA4OjUzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBVc2Ug
dGhlIGJsa19tcV9hbGxvY19kaXNrIEFQSSB0byBzaW1wbGlmeSB0aGUgZ2VuZGlzayBhbmQgcmVx
dWVzdF9xdWV1ZQo+IGFsbG9jYXRpb24uCj4KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4KClRoaXMgcGF0Y2ggbGFuZGVkIGluIGxpbnV4LW5leHQgYXMgY29t
bWl0IDY5NjZiYjkyMWRlZiAoIm10ZF9ibGtkZXZzOiAKdXNlIGJsa19tcV9hbGxvY19kaXNrIiku
IEl0IGNhdXNlcyB0aGUgZm9sbG93aW5nIHJlZ3Jlc3Npb24gb24gbXkgUUVNVSAKYXJtNjQgc2V0
dXA6CgogwqBVc2luZyBidWZmZXIgd3JpdGUgbWV0aG9kCiDCoENvbmNhdGVuYXRpbmcgTVREIGRl
dmljZXM6CiDCoCgwKTogIjAuZmxhc2giCiDCoCgxKTogIjAuZmxhc2giCiDCoGludG8gZGV2aWNl
ICIwLmZsYXNoIgogwqBVbmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2UgYXQgdmlydHVhbCBhZGRyZXNzIAowMDAwMDAwMDAwMDAwMDY4CiDCoE1lbSBhYm9ydCBp
bmZvOgogwqDCoCBFU1IgPSAweDk2MDAwMDA0CiDCoMKgIEVDID0gMHgyNTogREFCVCAoY3VycmVu
dCBFTCksIElMID0gMzIgYml0cwogwqDCoCBTRVQgPSAwLCBGblYgPSAwCiDCoMKgIEVBID0gMCwg
UzFQVFcgPSAwCiDCoERhdGEgYWJvcnQgaW5mbzoKIMKgwqAgSVNWID0gMCwgSVNTID0gMHgwMDAw
MDAwNAogwqDCoCBDTSA9IDAsIFduUiA9IDAKIMKgWzAwMDAwMDAwMDAwMDAwNjhdIHVzZXIgYWRk
cmVzcyBidXQgYWN0aXZlX21tIGlzIHN3YXBwZXIKIMKgSW50ZXJuYWwgZXJyb3I6IE9vcHM6IDk2
MDAwMDA0IFsjMV0gUFJFRU1QVCBTTVAKIMKgTW9kdWxlcyBsaW5rZWQgaW46CiDCoENQVTogMCBQ
SUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDUuMTMuMC1yYzMrICMxMDQ5MgogwqBI
YXJkd2FyZSBuYW1lOiBsaW51eCxkdW1teS12aXJ0IChEVCkKIMKgcHN0YXRlOiAwMDAwMDAwNSAo
bnpjdiBkYWlmIC1QQU4gLVVBTyAtVENPIEJUWVBFPS0tKQogwqBwYyA6IGJsa19maW5pc2hfcGx1
ZysweDVjLzB4MjY4CiDCoGxyIDogYmxrX3F1ZXVlX3dyaXRlX2NhY2hlKzB4MjgvMHg3MAouLi4K
IMKgQ2FsbCB0cmFjZToKIMKgIGJsa19maW5pc2hfcGx1ZysweDVjLzB4MjY4CiDCoCBhZGRfbXRk
X2Jsa3RyYW5zX2RldisweDI3MC8weDQyMAogwqAgbXRkYmxvY2tfYWRkX210ZCsweDY4LzB4OTgK
IMKgIGJsa3RyYW5zX25vdGlmeV9hZGQrMHg0NC8weDcwCiDCoCBhZGRfbXRkX2RldmljZSsweDQx
Yy8weDQ5MAogwqAgbXRkX2RldmljZV9wYXJzZV9yZWdpc3RlcisweGY0LzB4MWM4CiDCoCBwaHlz
bWFwX2ZsYXNoX3Byb2JlKzB4NDRjLzB4NzgwCiDCoCBwbGF0Zm9ybV9wcm9iZSsweDkwLzB4ZDgK
IMKgIHJlYWxseV9wcm9iZSsweDEwOC8weDNjMAogwqAgZHJpdmVyX3Byb2JlX2RldmljZSsweDYw
LzB4YzAKIMKgIGRldmljZV9kcml2ZXJfYXR0YWNoKzB4NmMvMHg3OAogwqAgX19kcml2ZXJfYXR0
YWNoKzB4YzAvMHgxMDAKIMKgIGJ1c19mb3JfZWFjaF9kZXYrMHg2OC8weGM4CiDCoCBkcml2ZXJf
YXR0YWNoKzB4MjAvMHgyOAogwqAgYnVzX2FkZF9kcml2ZXIrMHgxNjgvMHgxZjgKIMKgIGRyaXZl
cl9yZWdpc3RlcisweDYwLzB4MTEwCiDCoCBfX3BsYXRmb3JtX2RyaXZlcl9yZWdpc3RlcisweDI0
LzB4MzAKIMKgIHBoeXNtYXBfaW5pdCsweDE4LzB4MjAKIMKgIGRvX29uZV9pbml0Y2FsbCsweDg0
LzB4NDUwCiDCoCBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDJkYy8weDMzNAogwqAga2VybmVsX2lu
aXQrMHgxMC8weDExMAogwqAgcmV0X2Zyb21fZm9yaysweDEwLzB4MTgKIMKgQ29kZTogODgwMjdj
MDEgMzVmZmZmYTIgMTdmZmYwNzkgZjk4MDAwMzEgKGM4NWY3YzIyKQogwqAtLS1bIGVuZCB0cmFj
ZSBiNzc0NTE4ZTA3NjZjYzkyIF0tLS0KIMKgS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0
dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRjb2RlPTB4MDAwMDAwMGIKIMKgU01QOiBzdG9wcGlu
ZyBzZWNvbmRhcnkgQ1BVcwogwqBLZXJuZWwgT2Zmc2V0OiAweDU5NGQxZmEwMDAwMCBmcm9tIDB4
ZmZmZjgwMDAxMDAwMDAwMAogwqBQSFlTX09GRlNFVDogMHhmZmZmZWE3MzAwMDAwMDAwCiDCoENQ
VSBmZWF0dXJlczogMHgxMTAwMDY3MSwwMDAwMDg0NgogwqBNZW1vcnkgTGltaXQ6IG5vbmUKIMKg
LS0tWyBlbmQgS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIGlu
aXQhIApleGl0Y29kZT0weDAwMDAwMDBiIF0tLS0KCj4gLS0tCj4gICBkcml2ZXJzL210ZC9tdGRf
YmxrZGV2cy5jIHwgNDggKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4g
ICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pCj4KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQvbXRkX2Jsa2RldnMuYyBiL2RyaXZlcnMvbXRkL210ZF9i
bGtkZXZzLmMKPiBpbmRleCBmYjhlMTJkNTkwYTEuLjVkYzRjOTY2ZWE3MyAxMDA2NDQKPiAtLS0g
YS9kcml2ZXJzL210ZC9tdGRfYmxrZGV2cy5jCj4gKysrIGIvZHJpdmVycy9tdGQvbXRkX2Jsa2Rl
dnMuYwo+IEBAIC0zMCwxMSArMzAsOSBAQCBzdGF0aWMgdm9pZCBibGt0cmFuc19kZXZfcmVsZWFz
ZShzdHJ1Y3Qga3JlZiAqa3JlZikKPiAgIAlzdHJ1Y3QgbXRkX2Jsa3RyYW5zX2RldiAqZGV2ID0K
PiAgIAkJY29udGFpbmVyX29mKGtyZWYsIHN0cnVjdCBtdGRfYmxrdHJhbnNfZGV2LCByZWYpOwo+
ICAgCj4gLQlkZXYtPmRpc2stPnByaXZhdGVfZGF0YSA9IE5VTEw7Cj4gLQlibGtfY2xlYW51cF9x
dWV1ZShkZXYtPnJxKTsKPiArCWJsa19jbGVhbnVwX2Rpc2soZGV2LT5kaXNrKTsKPiAgIAlibGtf
bXFfZnJlZV90YWdfc2V0KGRldi0+dGFnX3NldCk7Cj4gICAJa2ZyZWUoZGV2LT50YWdfc2V0KTsK
PiAtCXB1dF9kaXNrKGRldi0+ZGlzayk7Cj4gICAJbGlzdF9kZWwoJmRldi0+bGlzdCk7Cj4gICAJ
a2ZyZWUoZGV2KTsKPiAgIH0KPiBAQCAtMzU0LDcgKzM1Miw3IEBAIGludCBhZGRfbXRkX2Jsa3Ry
YW5zX2RldihzdHJ1Y3QgbXRkX2Jsa3RyYW5zX2RldiAqbmV3KQo+ICAgCWlmIChuZXctPmRldm51
bSA+IChNSU5PUk1BU0sgPj4gdHItPnBhcnRfYml0cykgfHwKPiAgIAkgICAgKHRyLT5wYXJ0X2Jp
dHMgJiYgbmV3LT5kZXZudW0gPj0gMjcgKiAyNikpIHsKPiAgIAkJbXV0ZXhfdW5sb2NrKCZibGt0
cmFuc19yZWZfbXV0ZXgpOwo+IC0JCWdvdG8gZXJyb3IxOwo+ICsJCXJldHVybiByZXQ7Cj4gICAJ
fQo+ICAgCj4gICAJbGlzdF9hZGRfdGFpbCgmbmV3LT5saXN0LCAmdHItPmRldnMpOwo+IEBAIC0z
NjYsMTcgKzM2NCwyOCBAQCBpbnQgYWRkX210ZF9ibGt0cmFuc19kZXYoc3RydWN0IG10ZF9ibGt0
cmFuc19kZXYgKm5ldykKPiAgIAlpZiAoIXRyLT53cml0ZXNlY3QpCj4gICAJCW5ldy0+cmVhZG9u
bHkgPSAxOwo+ICAgCj4gLQkvKiBDcmVhdGUgZ2VuZGlzayAqLwo+ICAgCXJldCA9IC1FTk9NRU07
Cj4gLQlnZCA9IGFsbG9jX2Rpc2soMSA8PCB0ci0+cGFydF9iaXRzKTsKPiArCW5ldy0+dGFnX3Nl
dCA9IGt6YWxsb2Moc2l6ZW9mKCpuZXctPnRhZ19zZXQpLCBHRlBfS0VSTkVMKTsKPiArCWlmICgh
bmV3LT50YWdfc2V0KQo+ICsJCWdvdG8gb3V0X2xpc3RfZGVsOwo+ICAgCj4gLQlpZiAoIWdkKQo+
IC0JCWdvdG8gZXJyb3IyOwo+ICsJcmV0ID0gYmxrX21xX2FsbG9jX3NxX3RhZ19zZXQobmV3LT50
YWdfc2V0LCAmbXRkX21xX29wcywgMiwKPiArCQkJQkxLX01RX0ZfU0hPVUxEX01FUkdFIHwgQkxL
X01RX0ZfQkxPQ0tJTkcpOwo+ICsJaWYgKHJldCkKPiArCQlnb3RvIG91dF9rZnJlZV90YWdfc2V0
Owo+ICsKPiArCS8qIENyZWF0ZSBnZW5kaXNrICovCj4gKwlnZCA9IGJsa19tcV9hbGxvY19kaXNr
KG5ldy0+dGFnX3NldCwgbmV3KTsKPiArCWlmIChJU19FUlIoZ2QpKSB7Cj4gKwkJcmV0ID0gUFRS
X0VSUihnZCk7Cj4gKwkJZ290byBvdXRfZnJlZV90YWdfc2V0Owo+ICsJfQo+ICAgCj4gICAJbmV3
LT5kaXNrID0gZ2Q7Cj4gICAJZ2QtPnByaXZhdGVfZGF0YSA9IG5ldzsKPiAgIAlnZC0+bWFqb3Ig
PSB0ci0+bWFqb3I7Cj4gICAJZ2QtPmZpcnN0X21pbm9yID0gKG5ldy0+ZGV2bnVtKSA8PCB0ci0+
cGFydF9iaXRzOwo+ICsJZ2QtPm1pbm9ycyA9IDEgPDwgdHItPnBhcnRfYml0czsKPiAgIAlnZC0+
Zm9wcyA9ICZtdGRfYmxvY2tfb3BzOwo+ICAgCj4gICAJaWYgKHRyLT5wYXJ0X2JpdHMpCj4gQEAg
LTM5OCwyMiArNDA3LDkgQEAgaW50IGFkZF9tdGRfYmxrdHJhbnNfZGV2KHN0cnVjdCBtdGRfYmxr
dHJhbnNfZGV2ICpuZXcpCj4gICAJc3Bpbl9sb2NrX2luaXQoJm5ldy0+cXVldWVfbG9jayk7Cj4g
ICAJSU5JVF9MSVNUX0hFQUQoJm5ldy0+cnFfbGlzdCk7Cj4gICAKPiAtCW5ldy0+dGFnX3NldCA9
IGt6YWxsb2Moc2l6ZW9mKCpuZXctPnRhZ19zZXQpLCBHRlBfS0VSTkVMKTsKPiAtCWlmICghbmV3
LT50YWdfc2V0KQo+IC0JCWdvdG8gZXJyb3IzOwo+IC0KPiAtCW5ldy0+cnEgPSBibGtfbXFfaW5p
dF9zcV9xdWV1ZShuZXctPnRhZ19zZXQsICZtdGRfbXFfb3BzLCAyLAo+IC0JCQkJQkxLX01RX0Zf
U0hPVUxEX01FUkdFIHwgQkxLX01RX0ZfQkxPQ0tJTkcpOwo+IC0JaWYgKElTX0VSUihuZXctPnJx
KSkgewo+IC0JCXJldCA9IFBUUl9FUlIobmV3LT5ycSk7Cj4gLQkJbmV3LT5ycSA9IE5VTEw7Cj4g
LQkJZ290byBlcnJvcjQ7Cj4gLQl9Cj4gLQo+ICAgCWlmICh0ci0+Zmx1c2gpCj4gICAJCWJsa19x
dWV1ZV93cml0ZV9jYWNoZShuZXctPnJxLCB0cnVlLCBmYWxzZSk7Cj4gICAKPiAtCW5ldy0+cnEt
PnF1ZXVlZGF0YSA9IG5ldzsKPiAgIAlibGtfcXVldWVfbG9naWNhbF9ibG9ja19zaXplKG5ldy0+
cnEsIHRyLT5ibGtzaXplKTsKPiAgIAo+ICAgCWJsa19xdWV1ZV9mbGFnX3NldChRVUVVRV9GTEFH
X05PTlJPVCwgbmV3LT5ycSk7Cj4gQEAgLTQzNywxMyArNDMzLDEzIEBAIGludCBhZGRfbXRkX2Js
a3RyYW5zX2RldihzdHJ1Y3QgbXRkX2Jsa3RyYW5zX2RldiAqbmV3KQo+ICAgCQlXQVJOX09OKHJl
dCk7Cj4gICAJfQo+ICAgCXJldHVybiAwOwo+IC1lcnJvcjQ6Cj4gKwo+ICtvdXRfZnJlZV90YWdf
c2V0Ogo+ICsJYmxrX21xX2ZyZWVfdGFnX3NldChuZXctPnRhZ19zZXQpOwo+ICtvdXRfa2ZyZWVf
dGFnX3NldDoKPiAgIAlrZnJlZShuZXctPnRhZ19zZXQpOwo+IC1lcnJvcjM6Cj4gLQlwdXRfZGlz
ayhuZXctPmRpc2spOwo+IC1lcnJvcjI6Cj4gK291dF9saXN0X2RlbDoKPiAgIAlsaXN0X2RlbCgm
bmV3LT5saXN0KTsKPiAtZXJyb3IxOgo+ICAgCXJldHVybiByZXQ7Cj4gICB9Cj4gICAKCkJlc3Qg
cmVnYXJkcwotLSAKTWFyZWsgU3p5cHJvd3NraSwgUGhEClNhbXN1bmcgUiZEIEluc3RpdHV0ZSBQ
b2xhbmQKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

