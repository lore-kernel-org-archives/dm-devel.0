Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD62C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9741D61019
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9741D61019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-w4_qVDF2Miu_L9dHsJ87Mg-1; Thu, 14 Oct 2021 03:53:13 -0400
X-MC-Unique: w4_qVDF2Miu_L9dHsJ87Mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3260C10A8E0D;
	Thu, 14 Oct 2021 07:53:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F53694B4;
	Thu, 14 Oct 2021 07:53:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E88551806D00;
	Thu, 14 Oct 2021 07:53:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D8Zdnt008529 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 04:35:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C0DC140CFD11; Wed, 13 Oct 2021 08:35:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB70440CFD10
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 08:35:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DBEC8001EA
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 08:35:39 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
	[210.118.77.11]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-354-QHbyY511O6G1KueCK2k2XA-1; Wed, 13 Oct 2021 04:35:37 -0400
X-MC-Unique: QHbyY511O6G1KueCK2k2XA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
	20211013083536euoutp011c25b142fe047d975340b0ba6f18965a~tiiZFAkfq2584325843euoutp01s
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 08:35:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
	20211013083536euoutp011c25b142fe047d975340b0ba6f18965a~tiiZFAkfq2584325843euoutp01s
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20211013083536eucas1p1a795c57a764df3335f868000c9bd6669~tiiYmAiHG0164501645eucas1p1B;
	Wed, 13 Oct 2021 08:35:36 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id E7.15.45756.85A96616;
	Wed, 13 Oct 2021 09:35:36 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20211013083535eucas1p13f4ddfc4b6ee1a62c824d48b0cc0e105~tiiYLEzD81511715117eucas1p1f;
	Wed, 13 Oct 2021 08:35:35 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20211013083535eusmtrp1e3e4270a1575147c3e0ee833770dc49b~tiiYKE2KJ2173921739eusmtrp1c;
	Wed, 13 Oct 2021 08:35:35 +0000 (GMT)
X-AuditID: cbfec7f2-7bdff7000002b2bc-16-61669a58817f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 2F.C0.20981.75A96616;
	Wed, 13 Oct 2021 09:35:35 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20211013083535eusmtip2ecd856f2ed1ab8f61ba652b25279da00~tiiX7G0Tr2272522725eusmtip2s;
	Wed, 13 Oct 2021 08:35:35 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC01.scsc.local
	(2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id
	15.0.1497.2; Wed, 13 Oct 2021 09:35:34 +0100
Date: Wed, 13 Oct 2021 10:35:33 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20211013083533.hhgrkm3lhoytfp3a@mpHalley-2.domain_not_set.invalid>
MIME-Version: 1.0
In-Reply-To: <20211006100121.2hqfdkyuivzvzd33@mpHalley.domain_not_set.invalid>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7djPc7oRs9ISDc53c1qsvtvPZjHtw09m
	i1m3X7NYvD/4mNVi77vZrBaPN/1nstizaBKTxcrVR5ks/nbdY7KYdOgao8XeW9oW85c9Zbfo
	vr6DzWLf673MFsuP/2OymNhxlcni3Kw/bBaH711lsVj9x8Ji5TMmi1f74xxEPS5f8faY2PyO
	3ePy2VKPTas62Tw2L6n3mHxjOaPH7psNbB4zPn1h87h+ZjuTR2/zOzaPj09vsXhse9jL7vF+
	31Wg2tPVHp83yXm0H+hmChCI4rJJSc3JLEst0rdL4MroPu9ecE+y4t9/1wbGVyJdjJwcEgIm
	Ehe/LmLrYuTiEBJYwSjxafZfRpCEkMAXRonmLZkQic+MEh2vn7HAdJx8+pIZIrGcUeJa6zVW
	uKqGUwegMlsZJZadvssG0sIioCrx4OUvVhCbTcBe4tKyW8wgtoiAnsTVWzfYQRqYBTZwSmxa
	tAGsQVjAU2LHhn4mEJtXwF/i6eJZbBC2oMTJmU/A7mAWsJLo/NAENJQDyJaWWP6PAyIsL9G8
	dTbYfE4BP4nm67vZQUokBJQllk/3hfigVmLtsTNgayUElnJJzJ/wkhUi4SJx/eIiZghbWOLV
	8S3sELaMxOnJPSwQDc2MEmfWXGGGcHoYJf5MWsEIscFaou9MDkSDo8T2KQ+ZIcJ8EjfeCkLc
	xicxadt0qDCvREeb0ARGlVlIHpuF5LFZCI/NQvLYAkaWVYziqaXFuempxYZ5qeV6xYm5xaV5
	6XrJ+bmbGIGp9vS/4592MM599VHvECMTB+MhRgkOZiURXsOM1EQh3pTEyqrUovz4otKc1OJD
	jNIcLErivKtmr4kXEkhPLEnNTk0tSC2CyTJxcEo1MCXLzpqz3Cqm+6/Xr8t3/TvrmYvbXdOf
	a0483P2k7Fjwf4NXutccvutv7U4SDJLMmSP0Ji+g2nDlbdbV87JezJlorBf15HMj3+Ku1Qn/
	HgX+OqbA2/PMbUvT169MZx3uNEQ9vPpkQ/aSrfozPf1C+7oKYp5q6+THK/c7z3W9ZXTCWjve
	cfbn+rlMl45zrT0cwFW2MGLuqYLtNzOb71nIxzu3Xlpzr77uZsfOey+5kp4JPbpcmsO1v/Xp
	/whxwzme7Noni2uOLO82OHlI2n+7ke+9MvZ8hnTOj9fefvxnPO3b5D2BXXL8RRkGWd7a2mFp
	FyNbD87J3ap6tvG71TOPrxNehs09pCeSFVtio155SImlOCPRUIu5qDgRAIXemJckBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t/xe7rhs9ISDQ7vU7dYfbefzWLah5/M
	FrNuv2axeH/wMavF3nezWS0eb/rPZLFn0SQmi5WrjzJZ/O26x2Qx6dA1Rou9t7Qt5i97ym7R
	fX0Hm8W+13uZLZYf/8dkMbHjKpPFuVl/2CwO37vKYrH6j4XFymdMFq/2xzmIely+4u0xsfkd
	u8fls6Uem1Z1snlsXlLvMfnGckaP3Tcb2DxmfPrC5nH9zHYmj97md2weH5/eYvHY9rCX3eP9
	vqtAtaerPT5vkvNoP9DNFCAQpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqk
	b2eTkpqTWZZapG+XoJfRfd694J5kxb//rg2Mr0S6GDk5JARMJE4+fcncxcjFISSwlFFi18Ev
	jBAJGYlPVz6yQ9jCEn+udbFBFH1klFj8vIkJwtkK5OyaAtbBIqAq8eDlL1YQm03AXuLSslvM
	ILaIgJ7E1Vs32EEamAU2cEpsWrSBDSQhLOApsWNDPxOIzSvgL/F08SyoFfuZJTo2/WCFSAhK
	nJz5hAXEZhawkJg5/zzQNg4gW1pi+T8OiLC8RPPW2WDLOAX8JJqv72YHKZEQUJZYPt0X4oNa
	iVf3dzNOYBSZhWToLCRDZyEMnYVk6AJGllWMIqmlxbnpucVGesWJucWleel6yfm5mxiBqWjb
	sZ9bdjCufPVR7xAjEwfjIUYJDmYlEV7DjNREId6UxMqq1KL8+KLSnNTiQ4ymwCCayCwlmpwP
	TIZ5JfGGZgamhiZmlgamlmbGSuK8JkfWxAsJpCeWpGanphakFsH0MXFwSjUwzXKcnt9/9urp
	FfIp8xYvYWI9ovucP8NhyrR7kjIx9cLX7HbOfjStX/VJkFbXjXVbO97Lny6YNq9BjTGSf2lV
	39pvqgufWZy8bGO5KqjUv1Fkxbki/XC/bXmnGNYoruLmCnvZox0574F4y4evJ3an1Z9LDxPe
	3nbu1rIt3D2yc42eXmn4sExZVePLFX2lx1N+adWlZCfUv4ueuVff+Crnr5aDr2bpRGzdY/Wu
	ecHd0sh/F8U/Wm+bpTtli5HjQi07908/V9b2zBNM5QkxKtr99HeueqJjzY6MjbWRqevEP0cs
	Mdx+4pqcS+mWl3efr94+76DhlzjfNcZOc2bIeG7ijDvAtkfQadnTSz7rrGaaP1diKc5INNRi
	LipOBAAGHKBGzgMAAA==
X-CMS-MailID: 20211013083535eucas1p13f4ddfc4b6ee1a62c824d48b0cc0e105
X-Msg-Generator: CA
X-RootMTR: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
	<20211006100121.2hqfdkyuivzvzd33@mpHalley.domain_not_set.invalid>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19D8Zdnt008529
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 14 Oct 2021 03:53:04 -0400
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Q2hhaXRhbnlhLAoKRGlkIHlvdSBoYXZlIGEgY2hhbmNlIHRvIGxvb2sgYXQgdGhlIGFuc3dlcnMg
YmVsb3c/CgpJIHdvdWxkIGxpa2UgdG8gc3RhcnQgZmluZGluZyBjYW5kaWRhdGUgZGF0ZXMgdGhy
b3VnaG91dCB0aGUgbmV4dCBjb3VwbGUKb2Ygd2Vla3MuCgpUaGFua3MsCkphdmllcgoKT24gMDYu
MTAuMjAyMSAxMjowMSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPk9uIDMwLjA5LjIwMjEgMDk6
NDMsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPj5KYXZpZXIsCj4+Cj4+Pgo+Pj5IaSBhbGws
Cj4+Pgo+Pj5TaW5jZSB3ZSBhcmUgbm90IGdvaW5nIHRvIGJlIGFibGUgdG8gdGFsayBhYm91dCB0
aGlzIGF0IExTRi9NTSwgYSBmZXcgb2YKPj4+dXMgdGhvdWdodCBhYm91dCBob2xkaW5nIGEgZGVk
aWNhdGVkIHZpcnR1YWwgZGlzY3Vzc2lvbiBhYm91dCBDb3B5Cj4+Pk9mZmxvYWQuIEkgYmVsaWV2
ZSB3ZSBjYW4gdXNlIENoYWl0YW55YSdzIHRocmVhZCBhcyBhIHN0YXJ0LiBHaXZlbiB0aGUKPj4+
Y3VycmVudCBzdGF0ZSBvZiB0aGUgY3VycmVudCBwYXRjaGVzLCBJIHdvdWxkIHByb3Bvc2UgdGhh
dCB3ZSBmb2N1cyBvbgo+Pj50aGUgbmV4dCBzdGVwIHRvIGdldCB0aGUgbWluaW1hbCBwYXRjaHNl
dCB0aGF0IGNhbiBnbyB1cHN0cmVhbSBzbyB0aGF0Cj4+PndlIGNhbiBidWlsZCBmcm9tIHRoZXJl
Lgo+Pj4KPj4KPj5JIGFncmVlIHdpdGggaGF2aW5nIGEgY2FsbCBhcyBpdCBoYXMgYmVlbiB0d28g
eWVhcnMgSSdtIHRyeWluZyB0byBoYXZlCj4+dGhpcyBkaXNjdXNzaW9uLgo+Pgo+PkJlZm9yZSB3
ZSBzZXR1cCBhIGNhbGwsIHBsZWFzZSBzdW1tYXJpemUgZm9sbG93aW5nIGhlcmUgOi0KPj4KPj4x
LiBFeGFjdGx5IHdoYXQgd29yayBoYXMgYmVlbiBkb25lIHNvIGZhci4KPgo+Cj5XZSBjYW4gY2F0
ZWdvcml6ZSB0aGF0IGludG8gdHdvIHNldHMuIEZpcnN0IG9uZSBmb3IgWENvcHkgKDIwMTQpLCBh
bmQKPnNlY29uZCBvbmUgZm9yIE5WTWUgQ29weSAoMjAyMSkuCj4KPlhDT1BZIHNldCAqKioqKioq
KioKPi0gYmxvY2stZ2VuZXJpYyBjb3B5IGNvbW1hbmQgKHNpbmdsZSByYW5nZSwgYmV0d2VlbiBv
bmUKPiAgc291cmNlL2Rlc3RpbmF0aW9uIGRldmljZSkKPi0gaW9jdGwgaW50ZXJmYWNlIGZvciB0
aGUgYWJvdmUKPi0gU0NTSSBwbHVtYmluZyAoYmxvY2stZ2VuZXJpYyB0byBYQ09QWSBjb252ZXJz
aW9uKQo+LSBkZXZpY2UtbWFwcGVyIHN1cHBvcnQ6IG9mZmxvYWQgY29weSB3aGVuZXZlciBwb3Nz
aWJsZSAoaWYgSU8gaXMgbm90Cj4gIHNwbGl0IHdoaWxlIHRyYXZlbGluZyBsYXllcnMgb2Ygdmly
dHVhbCBkZXZpY2VzKQo+Cj5OVk1lLUNvcHkgc2V0ICoqKioqKioqKioqKioKPi0gYmxvY2stZ2Vu
ZXJpYyBjb3B5IGNvbW1hbmQgKG11bHRpcGxlIHJhbmdlcywgYmV0d2VlbiBvbmUKPiAgc291cmNl
L2Rlc3RpbmF0aW9uIGRldmljZSkKPi0gaW9jdGwgaW50ZXJmYWNlIGZvciB0aGUgYWJvdmUKPi0g
TlZNZSBwbHVtYmluZyAoYmxvY2stZ2VuZXJpYyB0byBOVk1lIENvcHkgY29udmVyc2lvbikKPi0g
Y29weS1lbXVsYXRpb24gKHJlYWQgKyB3cml0ZSkgaW4gYmxvY2stbGF5ZXIKPi0gZGV2aWNlLW1h
cHBlciBzdXBwb3J0OiBubyBvZmZsb2FkLCByYXRoZXIgZmFsbCBiYWNrIHRvIGNvcHktZW11bGF0
aW9uCj4KPgo+PjIuIFdoYXQga2luZCBvZiBmZWVkYmFjayB5b3UgZ290Lgo+Cj5Gb3IgTlZNZSBD
b3B5LCB0aGUgbWFqb3IgcG9pbnRzIGFyZSAtIGEpIGFkZCBjb3B5LWVtdWxhdGlvbiBpbgo+Ymxv
Y2stbGF5ZXIgYW5kIHVzZSB0aGF0IGlmIGNvcHktb2ZmbG9hZCBpcyBub3QgbmF0aXZlbHkgc3Vw
cG9ydGVkIGJ5Cj5kZXZpY2UgYikgdXNlci1pbnRlcmZhY2UgKGlvY3RsKSBzaG91bGQgYmUgZXh0
ZW5kYWJsZSBmb3IgY29weSBhY3Jvc3MKPnR3byBkZXZpY2VzIChvbmUgc291cmNlLCBvbmUgZGVz
dGluYXRpb24pIGMpIGRldmljZS1tYXBwZXIgdGFyZ2V0cwo+c2hvdWxkIHN1cHBvcnQgY29weS1v
ZmZsb2FkLCB3aGVuZXZlciBwb3NzaWJsZQo+Cj4id2hlbmV2ZXIgcG9zc2libGUiIGNhc2VzIGdl
dCByZWR1Y2VkIGNvbXBhcmVkIHRvIFhDT1BZIGJlY2F1c2UgTlZNZQo+Q29weSBpcyB3aXQKPgo+
PjMuIFdoYXQgYXJlIHRoZSBleGFjdCBibG9ja2Vycy9vYmplY3Rpb25zLgo+Cj5JIHRoaW5rIGl0
IHdhcyBkZXZpY2UtbWFwcGVyIGZvciBYQ09QWSBhbmQgcmVtYWlucyB0aGUgc2FtZSBmb3IgTlZN
ZQo+Q29weSBhcyB3ZWxsLiAgRGV2aWNlLW1hcHBlciBzdXBwb3J0IHJlcXVpcmVzIGRlY29tcG9z
aW5nIGNvcHkgb3BlcmF0aW9uCj50byByZWFkIGFuZCB3cml0ZS4gIFdoaWxlIHRoYXQgaXMgbm90
IGdyZWF0IGZvciBlZmZpY2llbmN5IFBvViwgYmlnZ2VyCj5jb25jZXJuIGlzIHRvIGNoZWNrIGlm
IHdlIGFyZSB0YWtpbmcgdGhlIHNhbWUgcm91dGUgYXMgWENPUFkuCj4KPkZyb20gTWFydGluJ3Mg
ZG9jdW1lbnQgKGh0dHA6Ly9ta3AubmV0L3B1YnMveGNvcHkucGRmKSwgaWYgSSBnb3QgaXQKPnJp
Z2h0LCBvbmUgdGhlIG1ham9yIGJsb2NrZXIgaXMgaGF2aW5nIG1vcmUgZmFpbHVyZSBjYXNlcyB0
aGFuCj5zdWNjZXNzZnVsIG9uZXMuIEFuZCB0aGF0IGRpZCBub3QganVzdGlmeSB0aGUgZWZmb3J0
L2NvZGUgdG8gd2lyZSB1cAo+ZGV2aWNlIG1hcHBlci4gIElzIHRoYXQgYSBmYWN0b3IgdG8gY29u
c2lkZXIgZm9yIE5WTWUgQ29weSAod2hpY2ggaXMKPm5hcnJvd2VyIGluIHNjb3BlIHRoYW4gWENP
UFkpLgo+Cj4+NC4gUG90ZW50aWFsIHdheXMgb2YgbW92aW5nIGZvcndhcmQuCj4KPmEpIHdlIGRl
ZmVyIGF0dGVtcHQgZGV2aWNlLW1hcHBlciBzdXBwb3J0ICh1bnRpbCBOVk1lIGhhcwo+c3VwcG9y
dC91c2VjYXNlKSwgYW5kIGFkZHJlc3MgZXZlcnl0aGluZyBlbHNlIChyZXVzYWJsZSB1c2VyLWlu
dGVyZmFjZQo+ZXRjLikKPgo+Yikgd2UgYXR0ZW1wdCBkZXZpY2UtbWFwcGVyIHN1cHBvcnQgKGJ5
IG1vdmluZyB0byBjb21wb3NpdGUgcmVhZCt3cml0ZQo+Y29tbXVuaWNhdGlvbiBiZXR3ZWVuIGJs
b2NrLWxheWVyIGFuZCBudm1lKQo+Cj4KPklzIHRoaXMgZW5vdWdoIGluIHlvdXIgbWluZCB0byBt
b3ZlIGZvcndhcmQgd2l0aCBhIHNwZWNpZmljIGFnZW5kYT8gSWYKPndlIGNhbiwgSSB3b3VsZCBs
aWtlIHRvIHRhcmdldCB0aGUgbWVldHVwIGluIHRoZSBuZXh0IDIgd2Vla3MuCj4KPlRoYW5rcywK
PkphdmllcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

