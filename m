Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB14C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 11:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659009496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n+y9qm7AnnTDfgps9bV0vAy4fp2RMvFygvBpE0fVsZY=;
	b=EqlAgc/rOlLIR4iOjmM+BtUUUt5Jo4phOS9x5sZp7YfKYJM2AgQiA6EyrnzZ6bzU6vSVbo
	p7BCk9CGH5hOZh6V00X2yAZdcq0qX0pSZEmxPXM67z8of/dRHUn3uldgps9m8F2bOflJQg
	/6qV1/FROat/TjiIz77bW2Pe6c1gNO8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-8vYcuwrOMeKdpZ8Q_0vggg-1; Thu, 28 Jul 2022 07:58:09 -0400
X-MC-Unique: 8vYcuwrOMeKdpZ8Q_0vggg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 645D91C0336D;
	Thu, 28 Jul 2022 11:58:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7BE7400DFD7;
	Thu, 28 Jul 2022 11:58:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76DA81945DAC;
	Thu, 28 Jul 2022 11:58:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DFC51945DAB
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 11:58:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B6EB2166B26; Thu, 28 Jul 2022 11:58:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16C702166B2B
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 11:58:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBCB92811372
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 11:58:03 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-T5oOHSsDMU6B2jnBFzNVqQ-1; Thu, 28 Jul 2022 07:58:02 -0400
X-MC-Unique: T5oOHSsDMU6B2jnBFzNVqQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220728115801euoutp02d98e2a7cac54b4cb55b2900e83c53bbc~F-FVTeKrL0288902889euoutp02f
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 11:58:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220728115801euoutp02d98e2a7cac54b4cb55b2900e83c53bbc~F-FVTeKrL0288902889euoutp02f
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220728115800eucas1p1cfc0536b8810df81ea18e3f25a846771~F-FU-7W-02681226812eucas1p1O;
 Thu, 28 Jul 2022 11:58:00 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 28.E3.10067.8C972E26; Thu, 28
 Jul 2022 12:58:00 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220728115800eucas1p1ef291627fc0b897e1a8b9eec57c6f561~F-FUlA6Ay1218012180eucas1p15;
 Thu, 28 Jul 2022 11:58:00 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220728115800eusmtrp2a03c0e871dd6ae6be0ac755217f4daa5~F-FUkG1QQ1863418634eusmtrp2T;
 Thu, 28 Jul 2022 11:58:00 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-b5-62e279c8453c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 4A.82.09038.8C972E26; Thu, 28
 Jul 2022 12:58:00 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220728115800eusmtip2a18e1ce7d66d68ae6bb638c7ef0e7597~F-FUVbZpZ1315713157eusmtip2a;
 Thu, 28 Jul 2022 11:58:00 +0000 (GMT)
Received: from [106.110.32.100] (106.110.32.100) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 28 Jul 2022 12:57:58 +0100
Message-ID: <e0606903-c007-43f1-538f-b70ee607be0a@samsung.com>
Date: Thu, 28 Jul 2022 13:57:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Bart Van Assche <bvanassche@acm.org>,
 <damien.lemoal@opensource.wdc.com>, <hch@lst.de>, <axboe@kernel.dk>,
 <snitzer@kernel.org>, <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
X-Originating-IP: [106.110.32.100]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7djPc7onKh8lGfQf17ZYfbefzWLah5/M
 Fr/Pnme22PtuNqvFnkWTmCxWrj7KZPFk/Sxmi79d95gs9t7Stri8aw6bxfxlT9ktJrR9ZbZY
 c/Mpi8WJW9IOfB6Xr3h77Jx1l93j8tlSj02rOtk8Ni+p99h9s4HNY2frfVaP9/uuAoVOV3t8
 3iTn0X6gmymAO4rLJiU1J7MstUjfLoEr4/m8FtaCY+wVk/fdYmtg7GLrYuTkkBAwkZi1exU7
 iC0ksIJRYs21+C5GLiD7C6PE7WkfmCCcz4wS+2+cBergAOuYd6kMomE5o8SXD8FwNQtP3oFq
 2M0osfvTElaQKl4BO4kFO+cwgtgsAqoS07+sYoKIC0qcnPmEBcQWFYiUWLP7LNgZwgKOEh+f
 fQOrZxYQl7j1ZD7YUBGBpYwS/25fZANxmAU+MEpcau9gBTmJTUBLorETrJlTwFpi+owtzBDN
 mhKt23+zQ9jyEs1bZzND/KwkMWHefaj/ayXWHjvDDjJTQuAWp0TPtmNQRS4ST/+/hCoSlnh1
 fAs7hC0j8X/nfCYIu1ri6Y3fzBDNLYwS/TvXQ8PIWqLvTA5EjaPE9i3nWCDCfBI33gpC3MMn
 MWnbdOYJjKqzkMJiFpKfZyF5YRaSFxYwsqxiFE8tLc5NTy02ykst1ytOzC0uzUvXS87P3cQI
 TH6n/x3/soNx+auPeocYmTgYDzFKcDArifAmRN9PEuJNSaysSi3Kjy8qzUktPsQozcGiJM6b
 nLkhUUggPbEkNTs1tSC1CCbLxMEp1cDEJlu6N3etXV2+6POepSv6GMxr1cS9tUymybrrzu3X
 XJDRbHHIRuzVY8MLF1wbdH8Y1EdwnxIUexp0gK/yJ8fBRdt+tp7kmlNcFHSskzljrUbDuZwp
 6wVn7swNOdGUsU2ymYPrmLyroGXFzv5yrZ82NV1TFPZ/rH7G/3PGse9l+nl7rk9YH2UYuvDf
 uwxWJh27eXar1uzO47uiOuHv71uzDjirqbqFrn1msGseg3DgdbeexV2vPtcIa58uDVcwvF7y
 QmorBx/7p5vf9yzlXW44/06ak7z7TB2tr9cWb8lff05+haGi6JFlywRXzGO6PlPWOOuzcfPl
 b9UfLfdqld/0reM0PZO1flEsV63i+rVKLMUZiYZazEXFiQD0Zw0g7QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t/xe7onKh8lGczcxGux+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZ7L2lbXF51xw2i/nLnrJbTGj7ymyx
 5uZTFosTt6Qd+DwuX/H22DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx87W+6we7/ddBQqdrvb4
 vEnOo/1AN1MAd5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZ
 apG+XYJexvN5LawFx9grJu+7xdbA2MXWxcjBISFgIjHvUlkXIxeHkMBSRonem0tYuhg5geIy
 Ep+ufGSHsIUl/lwDqecEKvrIKHFwvz1Ew25GieUX3jKCJHgF7CQW7JwDZrMIqEpM/7KKCSIu
 KHFy5hOwoaICkRIPlzWBxYUFHCU+PvsGVs8sIC5x68l8JpChIiBXzJn5hBHEYRb4wChxqb2D
 FWLdfkaJM+u3M4PczSagJdHYCXYep4C1xPQZW5ghJmlKtG7/zQ5hy0s0b53NDPGCksSEeffZ
 IOxaiVf3dzNOYBSdheTAWUgOmYVk1CwkoxYwsqxiFEktLc5Nzy020itOzC0uzUvXS87P3cQI
 TBrbjv3csoNx5auPeocYmTgYDzFKcDArifAmRN9PEuJNSaysSi3Kjy8qzUktPsRoCgylicxS
 osn5wLSVVxJvaGZgamhiZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXApPM/xdil
 7GibE+++LP7Aw10fZ2QyLpj1sCf51faKgz+VE8omPNXQqZnLdZdtkqiAQUPa4uocgfdWG81z
 f3F6fnWNnCj+UnPlxkX99ZdOxCRzHnp6OHbJ7y7+9LaFlVfNJsm3np7M9/LfkdVZdvxFitov
 F4a7TFmsNXP5xi2zX6nGM/jyv0p+tFN5mX/AQ9+t3yrF5kftau/SZ/2got5VPb91q3fTgjc7
 X0yIu6Txxoar7uYh8eXfS3peVVQulBA18vbn7pH7djTj9eOELd3HN1fu2e/Xdba6lk8v7V2k
 YepnqcS8s6ev/Jna4MGs3Bxj9TTZ7aFwyrXfSguV2D/cmfglWzzzkvPqk70bAlmuKLEUZyQa
 ajEXFScCAFkXhv6jAwAA
X-CMS-MailID: 20220728115800eucas1p1ef291627fc0b897e1a8b9eec57c6f561
X-Msg-Generator: CA
X-RootMTR: 20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754
References: <CGME20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754@eucas1p1.samsung.com>
 <20220727162245.209794-1-p.raghav@samsung.com>
 <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v8 00/11] support non power of 2 zoned device
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQmFydCwKCk9uIDIwMjItMDctMjggMDE6MTksIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPiBP
biA3LzI3LzIyIDA5OjIyLCBQYW5rYWogUmFnaGF2IHdyb3RlOgo+PiBUaGlzIHNlcmllcyBhZGRz
IHN1cHBvcnQgdG8gbnBvMiB6b25lZCBkZXZpY2VzIGluIHRoZSBibG9jayBhbmQgbnZtZQo+PiBs
YXllciBhbmQgYSBuZXcgKipkbSB0YXJnZXQqKiBpcyBhZGRlZDogZG0tcG8yei10YXJnZXQuIFRo
aXMgbmV3Cj4+IHRhcmdldCB3aWxsIGJlIGluaXRpYWxseSB1c2VkIGZvciBmaWxlc3lzdGVtcyBz
dWNoIGFzIGJ0cmZzIGFuZAo+PiBmMmZzIHRoYXQgZG9lcyBub3QgaGF2ZSBuYXRpdmUgbnBvMiB6
b25lIHN1cHBvcnQuCj4gCj4gU2hvdWxkIGFueSBTQ1NJIGNoYW5nZXMgYmUgaW5jbHVkZWQgaW4g
dGhpcyBwYXRjaCBzZXJpZXM/IEZyb20gc2RfemJjLmM6Cj4gCj4gwqDCoMKgwqBpZiAoIWlzX3Bv
d2VyX29mXzIoem9uZV9ibG9ja3MpKSB7Cj4gwqDCoMKgwqDCoMKgwqAgc2RfcHJpbnRrKEtFUk5f
RVJSLCBzZGtwLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJab25lIHNpemUgJWxsdSBp
cyBub3QgYSBwb3dlciBvZiB0d28uXG4iLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHpv
bmVfYmxvY2tzKTsKPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiDCoMKgwqDCoH0K
PiAKSSB3b3VsZCBrZWVwIHRoZXNlIGNoYW5nZXMgb3V0IG9mIHRoZSBjdXJyZW50IHBhdGNoIHNl
cmllcyBiZWNhdXNlIGl0CndpbGwgYWxzbyBpbmNyZWFzZSB0aGUgdGVzdCBzY29wZS4gSSB0aGlu
ayBvbmNlIHRoZSBibG9jayBsYXllcgpjb25zdHJhaW50IGlzIHJlbW92ZWQgYXMgYSBwYXJ0IG9m
IHRoaXMgc2VyaWVzLCB3ZSBjYW4gd29yayBvbiB0aGUgU0NTSQpjaGFuZ2VzIGluIHRoZSBuZXh0
IGN5Y2xlLgo+IFRoYW5rcywKPiAKPiBCYXJ0LgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

