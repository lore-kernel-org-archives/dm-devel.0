Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4982C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 21:23:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-_2jlSrwbOH2IcDfmwCuxkQ-1; Wed, 04 May 2022 17:23:32 -0400
X-MC-Unique: _2jlSrwbOH2IcDfmwCuxkQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE9CD833942;
	Wed,  4 May 2022 21:23:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 78949550A50;
	Wed,  4 May 2022 21:23:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C07D194704F;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5A0B19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 08:35:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6E130463E12; Wed,  4 May 2022 08:35:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6994E41373D
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:35:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B70C3C92FC1
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:35:12 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-XKSHZuuXNVa6BAsWwpUz2g-1; Wed, 04 May 2022 04:35:10 -0400
X-MC-Unique: XKSHZuuXNVa6BAsWwpUz2g-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220504083509euoutp023c2715c3e82f82bb6fa52a2e05ab3eb6~r2e8uTffn3252032520euoutp02o
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:35:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220504083509euoutp023c2715c3e82f82bb6fa52a2e05ab3eb6~r2e8uTffn3252032520euoutp02o
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220504083509eucas1p1bf302755e2c37837eba93e0b599d169b~r2e8Q2IW10045900459eucas1p1g;
 Wed,  4 May 2022 08:35:09 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id A3.F1.10260.DBA32726; Wed,  4
 May 2022 09:35:09 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220504083508eucas1p2b13cd91f8b71fcf1a929d098c710ed9e~r2e7a28PG0925109251eucas1p2Z;
 Wed,  4 May 2022 08:35:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220504083508eusmtrp1cf71a20db9e2f38cdbb8f13ea104ef26~r2e7ZXh5Y3254032540eusmtrp1W;
 Wed,  4 May 2022 08:35:08 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-a9-62723abdce8d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id B3.74.09404.CBA32726; Wed,  4
 May 2022 09:35:08 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220504083508eusmtip2e7e8bbafdd96bdd30b9c5ab3df5cab58~r2e7M-lMY2662026620eusmtip2R;
 Wed,  4 May 2022 08:35:08 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.170) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 4 May 2022 09:35:05 +0100
Message-ID: <a55665f1-26ae-c19f-5e2e-cf733e8f7fef@samsung.com>
Date: Wed, 4 May 2022 10:35:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Bart Van Assche <bvanassche@acm.org>, <jaegeuk@kernel.org>,
 <axboe@kernel.dk>, <snitzer@kernel.org>, <hch@lst.de>, <mcgrof@kernel.org>,
 <naohiro.aota@wdc.com>, <sagi@grimberg.me>,
 <damien.lemoal@opensource.wdc.com>, <dsterba@suse.com>,
 <johannes.thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <3a178153-62c0-e298-ccb0-0edfd41b7ee2@acm.org>
X-Originating-IP: [106.210.248.170]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf1CTdRzm+77v3r0swZch8Y15dAf5RxoYRd330kxOjff6ddbxR5d3wYA3
 4IBJGwuVQ0b80CHKZE5lWDOxRKyWwLYAh7ZwDDYcASOaSnGCFsmAQwgaSIwXO/57Ps/nee77
 PJ/7UrjQQIZRGZJcVioRZ0WQAsJonXdGmV+TJr/4s5pA+i4rjq7crSTR6cl5HNk13RiqqjzL
 R95uJ47Mnhoe6pkrwtDlKzcxNKLX4qjixiSBFsuHlrmSYRwtDMegKssAQKMuLYbM7i2o914d
 H/VeiEfXzJ0E6ms5RyLdN6N8pCqbwdGgahSgkx2NPPT93xMEsrlFO0VMX//bzGPbtyRzstjD
 Z5xDVwmmr1vONNQrSeYrhQZnGi8WMq3npzGm9TcFyRwv9pBMc+nvPGaizUUy+iYXwagar/KY
 6YbwvUEfCbanslkZn7HSrTuSBOl3R+7gOT3rD7g09XwF+CKgHPhTkI6F+ul2ohwIKCFdB+B4
 9zWSGx4BOHuujc8N0wBe/vIh/4nFNKDGuMUlAO3tJt7/qt4/P1+1tAA4o3GQPksAvQM6um6v
 YIJ+DnYcO4NzfBDsrB4hfDiE/hCe1vr0FBVMp0K3Lc5H43QodI/oVl7bQJ/CoFl1D/cNON2D
 w6VHg3yfgaQ3wyLlSjx/ehusnKgmOfPzsNTk5XP4WVhsqMG5CpFQPdiPcbgAfmd1rISG9B8C
 qFjUrop2Q/vxrlUcDMc6mlb7b4R2dQXB4Xw4OujFOXMJgJXN+pUGcDnFCUcWp4mDinbDKh0I
 B8eDuDyBsMp4BleBTdo1p9Cu6axdU0G7psJ5QNSDUFYuy05jZS9L2LxomThbJpekRafsz24A
 yz/b/rhj5kdQNzYVbQEYBSwAUnjEhoBdX+ckCwNSxQcPsdL9iVJ5FiuzABFFRIQGpGT8IBbS
 aeJcNpNlc1jpky1G+YcpMNOlj9vuJ8SJVZnbk4zrw73ZT3tefzA5kBCWsNXxQUNiW6A73bvH
 XDZnPYblOF9lbJ1+zW+oKgxHdLPzpve3bUoEvyZlW235Uy9Z5LE1JZ+EHdbYDoQcuX5zLEaX
 utAUWTurGj+MTb638SedekskdTQzN6U646kTJQ9KQ3bXA9ettxDvlbJ/34zfM2aIdCtB88Ls
 cGCNsr/6AjqUH9IerN0VPhFb/I/4zjOVt/Naat21n1pu+YfPLb4z9K6zNccjKTQaXb/U7VsX
 VWS5rjT4iYb3FoRenMqMWso1EWcfLimXzImiG4XxXv+8gt51B4/et+sEQstA8guu/L8cLpff
 zox9EYQsXRyzGZfKxP8BTb8GHEgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/xe7p7rIqSDO58YrdYf+oYs8Xqu/1s
 FtM+/GS2OD31LJPFpP4Z7Ba/z55nttj7bjarxYUfjUwWK1cfZbJ4sn4Ws0XPgQ8sFn+77gHF
 Wh4yW/x5aGgx6dA1RounV2cxWey9pW1x6fEKdotLi9wt9uw9yWJxedccNov5y56yW0xo+8ps
 cWPCU0aLicc3s1qse/2exeLELWkHaY/LV7w9/p1Yw+Yxsfkdu8f5extZPC6fLfXYtKqTzWNh
 w1Rmj81L6j12L/jM5LH7ZgObR2/zOzaPna33WT3e77vK5rF+y1UWjwmbN7J6fN4kFyAYpWdT
 lF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqkb2eTkpqTWZZapG+XoJdx98kd5oIL
 /BVXp65ib2Ccy9vFyMkhIWAisf3aZKYuRi4OIYGljBK3Js1lhUjISHy68pEdwhaW+HOtiw2i
 6COjxMze+cwQzi5GicPfbjOCVPEK2EmcOXWbDcRmEVCRON49nRkiLihxcuYTFhBbVCBC4sHu
 s0AbODiEBVIkbp1wBAkzC4hL3HoyH+wKEYEpTBJ7JzwGW8AscIFZ4v+XG+wQ2z4wSvxbdpsF
 pJtNQEuisRPsPE4Ba4n+9zPZICZpSrRu/80OYctLNG+dzQzxgrLE5BtXmCDsWolX93czTmAU
 nYXkvllIDpmFZNQsJKMWMLKsYhRJLS3OTc8tNtIrTswtLs1L10vOz93ECEx024793LKDceWr
 j3qHGJk4GA8xSnAwK4nwOi8tSBLiTUmsrEotyo8vKs1JLT7EaAoMpInMUqLJ+cBUm1cSb2hm
 YGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fEwSnVwLRa1t7kd9eegNsCFdISYmUm
 9WmGrxVPBwjoNdfaR/Oe4550+JKWszP/ru4PizX6LY/8UbnpnnzgrP9sjSiOYLP/J3a2Nqdv
 27jBPlnJ/nRqtf+elTwv9JZoHVt5nz32dOahKfMe9504dW3738Kn9epn7+dbz05zuceWLLL5
 /2oplX9/3eM2Xd+QXdq3PZFf2ej6/aqfVTHX7tnzVJbsXa62TeWVZWu/+XuxArPfu5xefC2V
 9bs/fY1R45vwVVHmJ5yvNLNOdQzvF3ETuqL26+XLit+sNxRiN/slCvx7WiMXmKBl/eLIq8Si
 KoGJ+rPn+5WveXx+Z5RxfphXsCDvB46aTMH+afozv4luUmJeq8RSnJFoqMVcVJwIAKUYqwP9
 AwAA
X-CMS-MailID: 20220504083508eucas1p2b13cd91f8b71fcf1a929d098c710ed9e
X-Msg-Generator: CA
X-RootMTR: 20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895@eucas1p2.samsung.com>
 <20220427160255.300418-2-p.raghav@samsung.com>
 <3a178153-62c0-e298-ccb0-0edfd41b7ee2@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 04 May 2022 21:23:25 +0000
Subject: Re: [dm-devel] [PATCH 01/16] block: make blkdev_nr_zones and
 blk_queue_zone_no generic for npo2 zsze
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
Cc: jiangbo.365@bytedance.com, kch@nvidia.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
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

T24gMjAyMi0wNS0wMyAxODozNywgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+PiDCoMKgwqDCoMKg
IHNlY3Rvcl90IHpvbmVfc2VjdG9ycyA9IGJsa19xdWV1ZV96b25lX3NlY3RvcnMoZGlzay0+cXVl
dWUpOwo+PiArwqDCoMKgIHNlY3Rvcl90IGNhcGFjaXR5ID0gZ2V0X2NhcGFjaXR5KGRpc2spOwo+
PiDCoCDCoMKgwqDCoMKgIGlmICghYmxrX3F1ZXVlX2lzX3pvbmVkKGRpc2stPnF1ZXVlKSkKPj4g
wqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAwOwo+PiAtwqDCoMKgIHJldHVybiAoZ2V0X2NhcGFj
aXR5KGRpc2spICsgem9uZV9zZWN0b3JzIC0gMSkgPj4KPj4gaWxvZzIoem9uZV9zZWN0b3JzKTsK
Pj4gKwo+PiArwqDCoMKgIGlmIChpc19wb3dlcl9vZl8yKHpvbmVfc2VjdG9ycykpCj4+ICvCoMKg
wqDCoMKgwqDCoCByZXR1cm4gKGNhcGFjaXR5ICsgem9uZV9zZWN0b3JzIC0gMSkgPj4KPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWxvZzIoem9uZV9zZWN0b3JzKTsKPj4gKwo+PiAr
wqDCoMKgIHJldHVybiBkaXY2NF91NjQoY2FwYWNpdHkgKyB6b25lX3NlY3RvcnMgLSAxLCB6b25l
X3NlY3RvcnMpOwo+PiDCoCB9Cj4+IMKgIEVYUE9SVF9TWU1CT0xfR1BMKGJsa2Rldl9ucl96b25l
cyk7Cj4gCj4gRG9lcyBhbnlvbmUgbmVlZCBzdXBwb3J0IGZvciBtb3JlIHRoYW4gNCBiaWxsaW9u
IHNlY3RvcnMgcGVyIHpvbmU/IElmCj4gbm90LCBkb19kaXYoKSBzaG91bGQgYmUgc3VmZmljaWVu
dC4KPiAKWW91IGFyZSBhYnNvbHV0ZWx5IHJpZ2h0IGJ1dCBibGtfcXVldWVfem9uZV9zZWN0b3Jz
IGV4cGxpY2l0bHkgY2hhbmdlZAp0aGUgcmV0dXJuIHR5cGUgdG8gdWludDMyX3QgdG8gc2VjdG9y
X3QgaW4gdGhpcyBjb21taXQ6CicxMTNhYjcyICBibG9jazogRml4IHBvdGVudGlhbCBvdmVyZmxv
dyBpbiBibGtfcmVwb3J0X3pvbmVzKCknLgoKSSBpbml0aWFsbHkgZGlkIGhhdmUgYSBkb19kaXYg
YnV0IGxhdGVyIGNoYW5nZWQgdG8gZGl2NjRfdTY0IHRvIGF2b2lkCmFueSBpbXBsaWNpdCBkb3du
IGNhc3RpbmcgZXZlbiB0aG91Z2ggem9uZV9zZWN0b3JzIHdpbGwgYmUgYWx3YXlzCmxpbWl0ZWQg
dG8gYW4gdW5zaWduZWQgaW50Lgo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9ibGtkZXYu
aCBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4gaW5kZXggNjBkMDE2MTM4OTk3Li5jNGU0Yzcw
NzFiN2IgMTAwNjQ0Cj4+IC0tLSBhL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4gKysrIGIvaW5j
bHVkZS9saW51eC9ibGtkZXYuaAo+PiBAQCAtNjY1LDkgKzY2NSwxNSBAQCBzdGF0aWMgaW5saW5l
IHVuc2lnbmVkIGludAo+PiBibGtfcXVldWVfbnJfem9uZXMoc3RydWN0IHJlcXVlc3RfcXVldWUg
KnEpCj4+IMKgIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGJsa19xdWV1ZV96b25lX25vKHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxLAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlY3Rvcl90IHNlY3RvcikKPj4gwqAgewo+PiArwqDCoMKg
IHNlY3Rvcl90IHpvbmVfc2VjdG9ycyA9IGJsa19xdWV1ZV96b25lX3NlY3RvcnMocSk7Cj4+ICsK
Pj4gwqDCoMKgwqDCoCBpZiAoIWJsa19xdWV1ZV9pc196b25lZChxKSkKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiAwOwo+PiAtwqDCoMKgIHJldHVybiBzZWN0b3IgPj4gaWxvZzIocS0+bGlt
aXRzLmNodW5rX3NlY3RvcnMpOwo+PiArCj4+ICvCoMKgwqAgaWYgKGlzX3Bvd2VyX29mXzIoem9u
ZV9zZWN0b3JzKSkKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBzZWN0b3IgPj4gaWxvZzIoem9u
ZV9zZWN0b3JzKTsKPj4gKwo+PiArwqDCoMKgIHJldHVybiBkaXY2NF91NjQoc2VjdG9yLCB6b25l
X3NlY3RvcnMpOwo+PiDCoCB9Cj4gCj4gU2FtZSBjb21tZW50IGhlcmUuCj4gCj4gVGhhbmtzLAo+
IAo+IEJhcnQuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

