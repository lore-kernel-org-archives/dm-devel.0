Return-Path: <SRS0=bIvj=O3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7F5C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Oct 2021 07:58:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BAB4661029
	for <dm-devel@archiver.kernel.org>; Thu,  7 Oct 2021 07:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BAB4661029
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-4vnJhUTNOq6ugMvvMq46rg-1; Thu, 07 Oct 2021 03:58:45 -0400
X-MC-Unique: 4vnJhUTNOq6ugMvvMq46rg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03B1C802C8A;
	Thu,  7 Oct 2021 07:58:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7E685C1A3;
	Thu,  7 Oct 2021 07:58:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86E2F4EA2A;
	Thu,  7 Oct 2021 07:58:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196A5Tdj023926 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 06:05:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 09B9E111287E; Wed,  6 Oct 2021 10:05:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 044AE1112872
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 10:05:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDC1A811E7F
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 10:05:28 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
	[210.118.77.12]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-31-cmL540WvPg-tABobXDGk6A-1; Wed, 06 Oct 2021 06:05:27 -0400
X-MC-Unique: cmL540WvPg-tABobXDGk6A-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
	20211006100526euoutp02a1614d5365f38bfa90ec80691fa65111~raP0Xqw2j2261022610euoutp02h
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 10:05:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
	20211006100526euoutp02a1614d5365f38bfa90ec80691fa65111~raP0Xqw2j2261022610euoutp02h
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20211006100525eucas1p11a0dd5d9be9e7517aa477f007d64a89f~raPzzOT322660526605eucas1p1p;
	Wed,  6 Oct 2021 10:05:25 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 05.36.45756.5E47D516;
	Wed,  6 Oct 2021 11:05:25 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20211006100524eucas1p2a1686056cf4a213dc42af4da610ddb67~raPzQbfZM3035530355eucas1p2m;
	Wed,  6 Oct 2021 10:05:24 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20211006100524eusmtrp1f259da37f2d056536891022ee35c0c12~raPzPegq41327913279eusmtrp1w;
	Wed,  6 Oct 2021 10:05:24 +0000 (GMT)
X-AuditID: cbfec7f2-7d5ff7000002b2bc-04-615d74e51519
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 84.78.31287.4E47D516;
	Wed,  6 Oct 2021 11:05:24 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20211006100524eusmtip128bb89f78867a5936408df4c49982d42~raPzBqDMU0572405724eusmtip1Y;
	Wed,  6 Oct 2021 10:05:24 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC01.scsc.local
	(2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id
	15.0.1497.2; Wed, 6 Oct 2021 11:05:23 +0100
Date: Wed, 6 Oct 2021 12:05:23 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
MIME-Version: 1.0
In-Reply-To: <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG9957e3tbBlwLC29Et6zTberE4czyRo3iZPE2pmTTDfeF0Iy7
	SiyttrC5D7Wjxq3VCVYjWAIaolQoX2sVGaModYMh1Q0tExCrrmVT5ENK2cpG2dpezfjvd855
	nvecJ3kpXGQg51I5yjxWrZQpxKSQaGyfurp0MC9D9nLQAJHlViGJjj2cwpHp5gMC2UdLechj
	/RdDLRVGDFVZfsRQ0ODGkNHxK0D2/iXoROUgHx240USi1gd2HJk7ZjB0+OseDF01TZPokruH
	QJZphKp+x9DQha0p8cx110bmsG6Uz1y/ks9Yq/UkYzu1lznSawbM931akinx+UnmhvM8xowP
	9hNM491v+MxYa09I1vU5M2F9mvnq4gHsjdj3hKuzWUXOx6x62Zos4bbTjm58hzNqV6DgGE8L
	fhAYgICC9ArYfr8NGICQEtFnACz3XOZxhR/AuvGjWFgloicA9HnQY8dA8CafE5kBdBuGHxUh
	kct/+dFbZwFscBWBsIWgF8CGAS0ZZpJeC69V9uNhjqdfhH/eMRNhA06XU9B/u5kID56gWbhv
	uI0f5jhaApsaCiN3RNNSWFbcx+N4Duw87o3ocXol1D8sCPWpECdC8wzFtZ+BunOlkV0CehW8
	dbs5IoH0c9BcLOXS7Ia17c5IAEifFsLAtW9JbpAKp+z1PI7j4FDHWT7H82DXkYMEZ9AB6Kxx
	4VxxEMBp4xnAbVgFDzkVnGEdPH/0Ls61Y2DvyBzuthhobCzGi8BC06w0pllpTP+nMc1KcxIQ
	1SCBzdfkyllNspL9JEkjy9XkK+VJH6pyrSD0XbtmOnxNoGxoPMkBMAo4AKRwcXy0am2GTBSd
	Lfv0M1atylTnK1iNAyRShDghurq0JlNEy2V57HaW3cGqH08xSjBXiwnu6ep/Nr2Z3brko2df
	aIhJ6NP/tIDZuCxjzDdi01eumZ+ir0u7uG61KqH8XpZIYtzQY07xSSzpu6L+kVQd9yXu6bRM
	irG0J7+Yx3re1wmlbYujbG63duFwb1vhhKven5pb9Jp8/6X+lj9obwny7V2OKl7a8pv93Pqc
	+96ynI6CpzqzuucvktYsSn69aES927b8+fVRryytNX2QuYk3Sqh2BrauRCXvDOj2TwalgjjF
	CVB75VBfZbPty/Sh7yRBZWxs4OSr+3QoNX3nW5Nl0pZ3S8ZNlurUC95AfK2uNVn899unNkxa
	PXV/VXiFUmJsRfedqrRfprzbmzWb5W56i2UPISY022TJi3G1RvYfXce2Jx0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t/xu7pPSmITDc5u07dYfbefzWLah5/M
	FrNuv2ax2PtuNqvF403/mSz2LJrEZLFy9VEmi79d95gsJh26xmix95a2xfxlT9ktuq/vYLPY
	93ovs8Xy4/+YLCZ2XGWyODfrD5vF4XtXWSxW/7GwWPmMyeLV/jgHEY/LV7w9Jja/Y/e4fLbU
	Y9OqTjaPzUvqPSbfWM7osftmA5vHjE9f2Dyun9nO5PHx6S0Wj20Pe9k93u+7ClR2utrj8yY5
	j/YD3UwB/FF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkamSvp2NimpOZllqUX6
	dgl6GUsPXWQuOMNd8aNpGmsD4xHOLkZODgkBE4k7f2+zdzFycQgJLGWUmPDkDRtEQkbi05WP
	7BC2sMSfa11sEEUfGSW+dGxhhXC2MEo8v90JVsUioCKx4U4DWDebgL3EpWW3mEFsEQENiW8P
	lrOANDALzOOQ+HJ/FwtIgkEgVaLlzUGwZmEBT4kdG/qZQGxeAV+JudNvQm34wSRx4GYvG0RC
	UOLkzCdgzcwCFhIz559n7GLkALKlJZb/44AIy0s0b50NtphTwFri7v1drCAlEgLKEsun+0J8
	Uyvx6v5uxgmMorOQDJ2FZOgshKGzkAxdwMiyilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzAl
	bTv2c/MOxnmvPuodYmTiYDzEKMHBrCTCm28fmyjEm5JYWZValB9fVJqTWnyI0RQYXBOZpUST
	84FJMa8k3tDMwNTQxMzSwNTSzFhJnHfr3DXxQgLpiSWp2ampBalFMH1MHJxSDUz5D4/J/m5b
	rutbZPpGbkurskns0fMnbDqaGqpe+l3fO19aV6GAJXCdy1RvDe5+yUhHvUL25sWKPhMsypmb
	mR+veLpuxbNXC9/b6slzXJYrn7OSu2vfmt0BHLcuvnVjeNVadFVCX7JDKqrP5tzfP9ujm5fE
	Fzb/bit4POdcAcM6+8baM+GH/8aJvZ88jW/qWsvqffMj06uUbwoJlX1b+yq859L1tslumz7f
	OuK0yjjqQk31kvvcMRuX/iyTW23O+T7WaNP7tyzfJnvd2rVDT8ZfWJ55WbTRG6bpuqw79lUy
	uCxmXRCwpWvl3L9K06JEpjCwnF3tzrsruPEQg3bMWcH3LDP1VDcHB3lMr1iVtk+JpTgj0VCL
	uag4EQABnR0A0gMAAA==
X-CMS-MailID: 20211006100524eucas1p2a1686056cf4a213dc42af4da610ddb67
X-Msg-Generator: CA
X-RootMTR: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 196A5Tdj023926
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 07 Oct 2021 03:43:07 -0400
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMzAuMDkuMjAyMSAwOToyMCwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+T24gOS8yOC8yMSAx
MjoxMyBQTSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj5TaW5jZSB3ZSBhcmUgbm90IGdvaW5n
IHRvIGJlIGFibGUgdG8gdGFsayBhYm91dCB0aGlzIGF0IExTRi9NTSwgYSBmZXcgb2YKPj51cyB0
aG91Z2h0IGFib3V0IGhvbGRpbmcgYSBkZWRpY2F0ZWQgdmlydHVhbCBkaXNjdXNzaW9uIGFib3V0
IENvcHkKPj5PZmZsb2FkLiBJIGJlbGlldmUgd2UgY2FuIHVzZSBDaGFpdGFueWEncyB0aHJlYWQg
YXMgYSBzdGFydC4gR2l2ZW4gdGhlCj4+Y3VycmVudCBzdGF0ZSBvZiB0aGUgY3VycmVudCBwYXRj
aGVzLCBJIHdvdWxkIHByb3Bvc2UgdGhhdCB3ZSBmb2N1cyBvbgo+PnRoZSBuZXh0IHN0ZXAgdG8g
Z2V0IHRoZSBtaW5pbWFsIHBhdGNoc2V0IHRoYXQgY2FuIGdvIHVwc3RyZWFtIHNvIHRoYXQKPj53
ZSBjYW4gYnVpbGQgZnJvbSB0aGVyZS4KPj4KPj5CZWZvcmUgd2UgdHJ5IHRvIGZpbmQgYSBkYXRl
IGFuZCBhIHRpbWUgdGhhdCBmaXRzIG1vc3Qgb2YgdXMsIHdobyB3b3VsZAo+PmJlIGludGVyZXN0
ZWQgaW4gcGFydGljaXBhdGluZz8KPgo+R2l2ZW4gdGhlIHRlY2huaWNhbCBjb21wbGV4aXR5IG9m
IHRoaXMgdG9waWMgYW5kIGFsc28gdGhhdCB0aGUgcGVvcGxlIHdobyBhcmUKPmludGVyZXN0ZWQg
bGl2ZSBpbiBtdWx0aXBsZSB0aW1lIHpvbmVzLCBJIHByZWZlciBlbWFpbCB0byBkaXNjdXNzIHRo
ZSB0ZWNobmljYWwKPmFzcGVjdHMgb2YgdGhpcyB3b3JrLiBNeSBhdHRlbXB0IHRvIHN1bW1hcml6
ZSBob3cgdG8gaW1wbGVtZW50IGNvcHkgb2ZmbG9hZGluZwo+aXMgYXZhaWxhYmxlIGhlcmU6IGh0
dHBzOi8vcHJvdGVjdDIuZmlyZWV5ZS5jb20vdjEvdXJsP2s9YmE3ZTVkOWEtZTVlNTY0ZDUtYmE3
ZmQ2ZDUtMGNjNDdhMzBkNDQ2LTA3YTQ3ZjNmNTNjYmZlNTMmcT0xJmU9YzM5NzNiZGMtYjZmZC00
M2ZiLTgwZTYtMGM4NmNiNmI0ZDVmJnU9aHR0cHMlM0ElMkYlMkZnaXRodWIuY29tJTJGYnZhbmFz
c2NoZSUyRmxpbnV4LWtlcm5lbC1jb3B5LW9mZmxvYWQuCj5GZWVkYmFjayBvbiB0aGlzIHRleHQg
aXMgd2VsY29tZS4KClRoYW5rcyBmb3Igc2hhcmluZyB0aGlzIEJhcnQuCgpJIGFncmVlIHRoYXQg
dGhlIHRvcGljIGlzIGNvbXBsZXguIEhvd2V2ZXIsIHdlIGhhdmUgbm90IGJlZW4gYWJsZSB0bwpm
aW5kIGEgY2xlYXIgcGF0aCBmb3J3YXJkIGluIHRoZSBtYWlsaW5nIGxpc3QuCgpXaGF0IGRvIHlv
dSB0aGluayBhYm91dCBqb2luaW5nIHRoZSBjYWxsIHRvIHRhbGsgdmVyeSBzcGVjaWZpYyBuZXh0
CnN0ZXBzIHRvIGdldCBhIHBhdGNoc2V0IHRoYXQgd2UgY2FuIHN0YXJ0IHJldmlld2luZyBpbiBk
ZXRhaWwuCgpJIHRoaW5rIHRoYXQgeW91ciBwcmVzZW5jZSBpbiB0aGUgY2FsbCB3aWxsIGhlbHAg
dXMgYWxsLgoKV2hhdCBkbyB5b3UgdGhpbms/CgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbA==

