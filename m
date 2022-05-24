Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2429BC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 07:11:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-RHaLFLDTPMiQCCpY9fuSBg-1; Tue, 24 May 2022 03:11:05 -0400
X-MC-Unique: RHaLFLDTPMiQCCpY9fuSBg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02CB2380673E;
	Tue, 24 May 2022 07:11:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B383492CA2;
	Tue, 24 May 2022 07:11:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4876F1947065;
	Tue, 24 May 2022 07:11:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4550B194704A
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 07:11:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E630492CA2; Tue, 24 May 2022 07:11:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09D86492C3B
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:11:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5F47185A79C
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:11:00 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-4AmdA6DCPim1cHeXG3ctBg-1; Tue, 24 May 2022 03:10:58 -0400
X-MC-Unique: 4AmdA6DCPim1cHeXG3ctBg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220524071057euoutp011b97b2e8767aa4b1995f3e38ebc29053~x_PI2QM0c2608026080euoutp01N
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:10:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220524071057euoutp011b97b2e8767aa4b1995f3e38ebc29053~x_PI2QM0c2608026080euoutp01N
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220524071057eucas1p1855d95118ad4a2d9cc6b3eb43d9db154~x_PIlUqWT0268302683eucas1p1u;
 Tue, 24 May 2022 07:10:57 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 45.5C.09887.0058C826; Tue, 24
 May 2022 08:10:57 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220524071056eucas1p1fe9ca64e7d7910c9cf81eb952420a35a~x_PH8Sjm30651106511eucas1p1w;
 Tue, 24 May 2022 07:10:56 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220524071056eusmtrp19475774e768b4fc9b274dcfc332f4ab0~x_PH58txD0167801678eusmtrp1K;
 Tue, 24 May 2022 07:10:56 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-c2-628c8500b490
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id FD.22.09404.0058C826; Tue, 24
 May 2022 08:10:56 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220524071056eusmtip202bd84c83b9ad12b546a1192a494994e~x_PHu3Og71582015820eusmtip2C;
 Tue, 24 May 2022 07:10:56 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.20) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 24 May 2022 08:10:54 +0100
Message-ID: <214e0c82-ce20-ba0f-77bd-21f3b83fd1f1@samsung.com>
Date: Tue, 24 May 2022 09:10:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>, <hch@lst.de>,
 <snitzer@redhat.com>, <damien.lemoal@opensource.wdc.com>,
 <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <a7a409dc-4cf3-7096-50f6-7f794d4a0b9b@suse.de>
X-Originating-IP: [106.210.248.20]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djPc7qMrT1JBic+MFqsvtvPZvH77Hlm
 i73vZrNaXPjRyGSxZ9EkJouVq48yWTxZP4vZoufABxaLv133mCz23tK2uLxrDpvF/GVP2S1u
 THjKaNG28SujA5/HvxNr2Dwuny312LSqk81j85J6j903G9g8drbeZ/V4v+8qm8f6LVdZPDaf
 rvb4vEnOo/1AN1MAdxSXTUpqTmZZapG+XQJXxs+px9gKjgtUND7bwNjAuI+3i5GTQ0LARKJn
 0xzGLkYuDiGBFYwSE28fZ4FwvjBKLNz3kR3C+cwoMeFmKwtMy6onC5lBbCGB5YwSZy7xwRXd
 mDAJqmMXo8T8eUvAOngF7CRWnO8Bs1kEVCXa/uxih4gLSpyc+QQsLioQIbGy9Q2YLSwQK/Fq
 wgowm1lAXOLWk/lMIENFBOYzSsw4sRJsA7NAO5NE6+KfQHdwcLAJaEk0drKDmJwC1hJnHsRD
 9GpKtG7/zQ5hy0s0b50NVi0hoCSx7ZcJxDO1EmuPnQGbKCFwj1Pi4cyXbBAJF4mGaWsYIWxh
 iVfHt7BD2DISpyf3QEOiWuLpjd/MEM0tjBL9O9ezQSywlug7kwNR4yjxc+M7qDCfxI23ghDn
 8ElM2jadeQKj6iykkJiF5ONZSD6YheSDBYwsqxjFU0uLc9NTi43yUsv1ihNzi0vz0vWS83M3
 MQIT4Ol/x7/sYFz+6qPeIUYmDsZDjBIczEoivClhPUlCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
 eZMzNyQKCaQnlqRmp6YWpBbBZJk4OKUamCTOF3x4wfz728Sa2p1uDyfd+NAQ8XM+q6x0eEzw
 6jI1ZtdE9Vax2Ac9ZVaXhU+oRl/eGDnjdO6X9q/Jkz+K1/vMO2394f9nvqy29Bl9KnOtX00X
 j7EwNLsUl+/9ffLFnAn5s8+xTkrYoaEt+G2K56XlAu4ORReTPGXPGGyuyFqm+NUj3Nz597MT
 Wp/e5p3i6Swq3qC8OGh96E+ttl5LZ/X/H7+73rxwfovnl38zC5d8t8t7u+Xl1NLwYtPEWTwF
 Hi9SJl509Il0UggPENv38u3X7eddozaK7AzbqiaSqfwsc1JY7uX1xp++VyxL2819U841Iq9v
 78uvduuvJN4QFfyxMPLy3mmlbHZbtq7Pc1NiKc5INNRiLipOBADcL3RV7wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t/xe7oMrT1JBjs6hCxW3+1ns/h99jyz
 xd53s1ktLvxoZLLYs2gSk8XK1UeZLJ6sn8Vs0XPgA4vF3657TBZ7b2lbXN41h81i/rKn7BY3
 JjxltGjb+JXRgc/j34k1bB6Xz5Z6bFrVyeaxeUm9x+6bDWweO1vvs3q833eVzWP9lqssHptP
 V3t83iTn0X6gmymAO0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1
 J7MstUjfLkEv4+fUY2wFxwUqGp9tYGxg3MfbxcjJISFgIrHqyULmLkYuDiGBpYwS15o/MEMk
 ZCQ+XfnIDmELS/y51sUGUfSRUWLn+T1MEM4uRolfBw4wglTxCthJrDjfwwJiswioSrT92cUO
 EReUODnzCVhcVCBC4tOyCawgtrBArMSrCSvA4swC4hK3nswHGyoiMJ9RYsaJlewgDrNAO5NE
 6+KfUAe+Y5ToWrEVKMPBwSagJdHYCWZyClhLnHkQDzFIU6J1+292CFteonnrbGaQEgkBJYlt
 v0wgvqmVeHV/N+MERtFZSM6bheSMWUgmzUIyaQEjyypGkdTS4tz03GIjveLE3OLSvHS95Pzc
 TYzAxLHt2M8tOxhXvvqod4iRiYPxEKMEB7OSCG9KWE+SEG9KYmVValF+fFFpTmrxIUZTYBhN
 ZJYSTc4Hpq68knhDMwNTQxMzSwNTSzNjJXFez4KORCGB9MSS1OzU1ILUIpg+Jg5OqQYmBZHY
 wxmCfN4tV4oyqn5+Zu7O+mEZ/vLH/UKL1B8nThS7topVfZ5t/OXIujMMpX2fLRNeHCsyPbpA
 kMctnvHHe+34g+s2JPW2Wwebx37ufNXqYMP50c/D/3/dXP3e4l2TTvMtj3LdcuLX9kdr779d
 dzPZPH2iQG1QrF9+ft/WZ9WCPuH1BxquTjNfXhrBJ9Fx6/uvurkKE/zD8nNTFuYlrRblVefh
 XMMtMcmQdb3826tXb2+Sfd/CZr4p8+Q6uYsJS10nGL+W//VzUnSZ5Kn/d/YJTPvkF3H+yPUM
 uzWqO3RDMqQXfc74zNXGMPXSue8HZ003mu59/PWU/6KsJ5dJs8/1f3XKd17a2qnnbN+/VWIp
 zkg01GIuKk4EAPABXj+lAwAA
X-CMS-MailID: 20220524071056eucas1p1fe9ca64e7d7910c9cf81eb952420a35a
X-Msg-Generator: CA
X-RootMTR: 20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e@eucas1p2.samsung.com>
 <20220523161601.58078-3-p.raghav@samsung.com>
 <a7a409dc-4cf3-7096-50f6-7f794d4a0b9b@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v5 2/7] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNS8yNC8yMiAwNzoxOSwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgoKPj4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvYmxrZGV2LmggYi9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oCj4+IGluZGV4
IGM0ZTRjNzA3MWI3Yi4uZjVjN2E0MTAzMmJhIDEwMDY0NAo+PiAtLS0gYS9pbmNsdWRlL2xpbnV4
L2Jsa2Rldi5oCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4gQEAgLTY3Niw2ICs2
NzYsMjEgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQKPj4gYmxrX3F1ZXVlX3pvbmVfbm8o
c3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4+IMKgwqDCoMKgwqAgcmV0dXJuIGRpdjY0X3U2NChz
ZWN0b3IsIHpvbmVfc2VjdG9ycyk7Cj4+IMKgIH0KPj4gwqAgK3N0YXRpYyBpbmxpbmUgYm9vbCBi
bGtfcXVldWVfaXNfem9uZV9zdGFydChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwKPj4gc2VjdG9y
X3Qgc2VjKQo+PiArewo+PiArwqDCoMKgIHNlY3Rvcl90IHpvbmVfc2VjdG9ycyA9IGJsa19xdWV1
ZV96b25lX3NlY3RvcnMocSk7Cj4+ICvCoMKgwqAgdTY0IHJlbWFpbmRlciA9IDA7Cj4+ICsKPj4g
K8KgwqDCoCBpZiAoIWJsa19xdWV1ZV9pc196b25lZChxKSkKPj4gK8KgwqDCoMKgwqDCoMKgIHJl
dHVybiBmYWxzZTsKPj4gKwo+IAo+IE5vdCBzdXJlIGlmIHdlIG5lZWQgdGhpcyBoZXJlOyBzdXJl
bHkgYmxrX3F1ZXVlX3pvbmVfc2VjdG9ycygpIHdpbGwKPiBhbHJlYWR5IGJhcmYsIGFuZCBub25l
IG9mIHRoZSBjYWxsZXJzIGRpZCB0aGlzIGNoZWNrLgo+IApJIHRvdGFsbHkgYWdyZWUgd2l0aCB5
b3UgYnV0IGFsbCB0aGUgb3RoZXIgYmxrX3F1ZXVlXyogZnVuY3Rpb25zIGhhZAp0aGlzIGRlZmVu
c2l2ZSBjaGVjayBhbmQgSSBkaWRuJ3Qgd2FudCB0byBicmVhayB0aGF0IHBhdHRlcm46CgpzdGF0
aWMgaW5saW5lIHVuc2lnbmVkIGludCBibGtfcXVldWVfem9uZV9ubyhzdHJ1Y3QgcmVxdWVzdF9x
dWV1ZSAqcSwKCQkJCQkgICAgIHNlY3Rvcl90IHNlY3RvcikKewoJLi4uLgoJaWYgKCFibGtfcXVl
dWVfaXNfem9uZWQocSkpCgkJcmV0dXJuIDA7CiAgICAgICAgLi4uLgp9CgoKPj4gK8KgwqDCoCBp
ZiAoaXNfcG93ZXJfb2ZfMih6b25lX3NlY3RvcnMpKQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJu
IElTX0FMSUdORUQoc2VjLCB6b25lX3NlY3RvcnMpOwo+PiArCkFuZCwgaWYgdGhlIGNodW5rIHNl
Y3RvcnMgaXMgMCwgdGhlbiB3ZSB3aWxsIGRvIHRoZSBucG8yIGNhbGN1bGF0aW9uCnJlc3VsdGlu
ZyBpbiBhIGRpdmlkZSBieSB6ZXJvIGV2ZW4gdGhvdWdoIGNoYW5jZXMgb2YgdGhhdCBoYXBwZW5p
bmcgaXMKdmVyeSB2ZXJ5IGxvdyBhcyB5b3UgcG9pbnRlZCBvdXQuCj4+ICvCoMKgwqAgZGl2NjRf
dTY0X3JlbShzZWMsIHpvbmVfc2VjdG9ycywgJnJlbWFpbmRlcik7Cj4+ICvCoMKgwqAgcmV0dXJu
IHJlbWFpbmRlciA9PSAwOwo+PiArfQo+PiArCj4+IMKgIHN0YXRpYyBpbmxpbmUgYm9vbCBibGtf
cXVldWVfem9uZV9pc19zZXEoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlY3Rvcl90IHNlY3RvcikKPj4gwqAg
ewo+PiBAQCAtNzIyLDYgKzczNywxMiBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludAo+PiBi
bGtfcXVldWVfem9uZV9ubyhzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwKPj4gwqAgewo+PiDCoMKg
wqDCoMKgIHJldHVybiAwOwo+PiDCoCB9Cj4+ICsKPj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBibGtf
cXVldWVfaXNfem9uZV9zdGFydChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwKPj4gc2VjdG9yX3Qg
c2VjKQo+PiArewo+PiArwqDCoMKgIHJldHVybiBmYWxzZTsKPj4gK30KPj4gKwo+PiDCoCBzdGF0
aWMgaW5saW5lIHVuc2lnbmVkIGludCBxdWV1ZV9tYXhfb3Blbl96b25lcyhjb25zdCBzdHJ1Y3QK
Pj4gcmVxdWVzdF9xdWV1ZSAqcSkKPj4gwqAgewo+PiDCoMKgwqDCoMKgIHJldHVybiAwOwo+IE90
aGVyd2lzZSBsb29rcyBnb29kLgo+IApUaGFua3MhCj4gQ2hlZXJzLAo+IAo+IEhhbm5lcwoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

