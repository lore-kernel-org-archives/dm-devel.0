Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D620FC19F2C
	for <dm-devel@archiver.kernel.org>; Thu,  4 Aug 2022 07:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659598201;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FRt+z+A2W9Lpch0iORyRN+lg2K4aBOFOcNsOvHUf6FM=;
	b=Xnc5Y2tzRXoP2afV1D5kShuDTKJbaufiDBAJtPcHSn5/+iqtSZJzw5KowEghlQj8tH1I4m
	Gp7wGGEZ3mDROfTVoLTyVujal8AibPaJajQuSBMMUg7aar+Gs5DfJTlTH5caRAKq6x7Pj+
	pTQIYbHAVO2TFoiIzJxXzUYwxTuGJwo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-Wp2hEXz9NWWezznmRCEsrg-1; Thu, 04 Aug 2022 03:30:00 -0400
X-MC-Unique: Wp2hEXz9NWWezznmRCEsrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7B6A3C11044;
	Thu,  4 Aug 2022 07:29:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F06840CF8EA;
	Thu,  4 Aug 2022 07:29:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F9221946A53;
	Thu,  4 Aug 2022 07:29:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EAF211946A52
 for <dm-devel@listman.corp.redhat.com>; Thu,  4 Aug 2022 07:29:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D94D7403D0D0; Thu,  4 Aug 2022 07:29:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D49AF40C1288
 for <dm-devel@redhat.com>; Thu,  4 Aug 2022 07:29:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B75741C01B2F
 for <dm-devel@redhat.com>; Thu,  4 Aug 2022 07:29:54 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-e2eUghbvO2OfZVpJhG7JjA-1; Thu, 04 Aug 2022 03:29:50 -0400
X-MC-Unique: e2eUghbvO2OfZVpJhG7JjA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220804072948euoutp0252408d7edb52db75b4c6c6a36b7a243b~IE8J5Zcf51946819468euoutp02h
 for <dm-devel@redhat.com>; Thu,  4 Aug 2022 07:29:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220804072948euoutp0252408d7edb52db75b4c6c6a36b7a243b~IE8J5Zcf51946819468euoutp02h
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220804072948eucas1p121431348dc2c1518f5e4162314d7e198~IE8JgzTTM2410624106eucas1p1N;
 Thu,  4 Aug 2022 07:29:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 90.6F.10067.C657BE26; Thu,  4
 Aug 2022 08:29:48 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220804072947eucas1p13d72273f427549e045227443a1b5986e~IE8JH1r-i3015830158eucas1p1-;
 Thu,  4 Aug 2022 07:29:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220804072947eusmtrp2d9ed2aef8f7f26f182d2f638ed0d03fa~IE8JG9fZC2908429084eusmtrp2a;
 Thu,  4 Aug 2022 07:29:47 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-7a-62eb756c783f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 5E.9C.09038.B657BE26; Thu,  4
 Aug 2022 08:29:47 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220804072947eusmtip10cdd8d8afa4cf74d25a908afe0f498aa~IE8I7rQ8t1783017830eusmtip1S;
 Thu,  4 Aug 2022 07:29:47 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.112) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 4 Aug 2022 08:29:45 +0100
Message-ID: <73f35f39-9637-056e-91b9-ee6b2c104977@samsung.com>
Date: Thu, 4 Aug 2022 09:29:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Bart Van Assche <bvanassche@acm.org>, <Johannes.Thumshirn@wdc.com>,
 <snitzer@kernel.org>, <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <agk@redhat.com>, <hch@lst.de>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <2616b59b-8c6b-a482-a396-d9408fa461a3@acm.org>
X-Originating-IP: [106.210.248.112]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djPc7o5pa+TDM4/4bRYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1Wrj7KZPFk/Sxmi79d95gs9t7Stri8aw6bxfxlT9ktJrR9Zba4
 MeEpo8Wam09ZLE7cknbg97h8xdtj56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweO1vvs3q833eV
 zePzJjmP9gPdTAFcUVw2Kak5mWWpRfp2CVwZl54dYyk4x1Kx8OVx5gbGJ8xdjBwcEgImEvv/
 mnUxcnEICaxglJjztoUZwvnCKNE3/T4ThPOZUWLXm8OsXYycYB1vrh1ihUgsZ5TYefoxWAKs
 asXdaIjELkaJhVsfMIMkeAXsJHZN+cgGYrMIqEj0Xd3BChEXlDg58wkLiC0qECmxZvdZdhBb
 WCBTYunaxUwgNrOAuMStJ/PBzhAR2M4o8f7XHTCHWaCNSWLuni3sIF+wCWhJNHaCNXMKWEu8
 XPIHqllTonX7b3YIW16ieetsZogXlCWObJ/LDmHXSqw9doYdZKaEwC1Oib+nV7FAJFwkNpzu
 ZYOwhSVeHd8C1SAj8X/nfCYIu1ri6Y3fzBDNLYwS/TvXs0GC1Vqi70wORI2jxOKZM1ghwnwS
 N94KQtzDJzFp23TmCYyqs5DCYhaSn2cheWEWkhcWMLKsYhRPLS3OTU8tNspLLdcrTswtLs1L
 10vOz93ECEyAp/8d/7KDcfmrj3qHGJk4GA8xSnAwK4nwrrB8nSTEm5JYWZValB9fVJqTWnyI
 UZqDRUmcNzlzQ6KQQHpiSWp2ampBahFMlomDU6qByflaG++t/LYdK458+38yfr4i1zlpQU8T
 0d07b3w5IW3I5/3QoXe9W5Vx4svEaGvGhv6qbwFMcWoTJ0v9i/eaUnUq993xJtN8vsO/WhOC
 WjTzVbbsWpHZ4pTcNS9a97/ttSsLPdw+tfF1bxOcGTFX98aEGBf9I5nCLHsnV06u2Ppv3s7t
 J2a4TdSUX9Gw5fZ07oULpGfcW3BnynrZxE0Fy40Xcdq5pcbpaFlvvff3n5I4/+9jK/4qfL/R
 O5Pb2+mwWhRL+5mHy2c7bVPiu8m/zjyabcmXQ9sc53HJPQivZG6Vy7zY8ixv+gbZeqfIbJkC
 l7rI5TU7BTi+m74wMUtTfnpK9e7T/q8/0mtun5P1VmIpzkg01GIuKk4EABJBtL3vAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t/xu7rZpa+TDBYt1rFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1Wrj7KZPFk/Sxmi79d95gs9t7Stri8aw6bxfxlT9ktJrR9Zba4
 MeEpo8Wam09ZLE7cknbg97h8xdtj56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweO1vvs3q833eV
 zePzJjmP9gPdTAFcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5
 mWWpRfp2CXoZl54dYyk4x1Kx8OVx5gbGJ8xdjJwcEgImEm+uHWLtYuTiEBJYyihxaecKqISM
 xKcrH9khbGGJP9e62CCKPjJKNJ74AuXsYpQ4s3I7C0gVr4CdxK4pH9lAbBYBFYm+qztYIeKC
 EidnPgGrERWIlHi4rIkJxBYWyJTYtecmI4jNLCAucevJfCaQoSIC2xkl3v+6A+YwC7QxSczd
 s4UdYt0HRomjfSuAHA4ONgEticZOsPs4BawlXi75wwQxSVOidftvdghbXqJ562yof5Qljmyf
 C/VPrcSr+7sZJzCKzkJy4Cwkh8xCMmoWklELGFlWMYqklhbnpucWG+kVJ+YWl+al6yXn525i
 BKaObcd+btnBuPLVR71DjEwcjIcYJTiYlUR4V1i+ThLiTUmsrEotyo8vKs1JLT7EaAoMpYnM
 UqLJ+cDklVcSb2hmYGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fEwSnVwJR18u2q
 GvbkpZx9JWxh2csEjyXldhTsZMiK/aOrma9bVyd8yaK6nC/hY32lu7TcY7usyMmKz+1sRSSn
 84S/uvLNnSOgaKWNxt6Fuc0r74Znbfj2/fqVqd7WTFqBK3jvv+F67/6050bqSqWiXRFz37ge
 1LkgWBI3v8td8kSg6ZftC/wXllqdbPX7+GRZi8ve2fJnf89mqokMFKyWmNreJSTpae4cde3r
 Pl0PEcN4hw07VqUzLGq6xvhci/MO9/QM5oX5vd2TXs1/tFDp270raxQjbBsvd/jeqihqkpBe
 q+syp1nukaP/WslbRfnOwfsyyzwE7Z/s2+Ycu19Wr33Rh7r/tsGeTbVvrtaHKQYqsRRnJBpq
 MRcVJwIA5SgUHaYDAAA=
X-CMS-MailID: 20220804072947eucas1p13d72273f427549e045227443a1b5986e
X-Msg-Generator: CA
X-RootMTR: 20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527@eucas1p1.samsung.com>
 <20220803094801.177490-6-p.raghav@samsung.com>
 <2616b59b-8c6b-a482-a396-d9408fa461a3@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v9 05/13] nvme: zns: Allow ZNS drives that
 have non-power_of_2 zone size
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
 dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQmFydCwKCk9uIDIwMjItMDgtMDMgMTk6MjIsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPiBP
biA4LzMvMjIgMDI6NDcsIFBhbmthaiBSYWdoYXYgd3JvdGU6Cj4+IC3CoMKgwqAgc2VjdG9yICY9
IH4obnMtPnpzemUgLSAxKTsKPj4gK8KgwqDCoCAvKgo+PiArwqDCoMKgwqAgKiBSb3VuZCBkb3du
IHRoZSBzZWN0b3IgdmFsdWUgdG8gdGhlIG5lYXJlc3Qgem9uZSBzdGFydAo+PiArwqDCoMKgwqAg
Ki8KPj4gK8KgwqDCoCBkaXY2NF91NjRfcmVtKHNlY3RvciwgbnMtPnpzemUsICZyZW1haW5kZXIp
Owo+PiArwqDCoMKgIHNlY3RvciAtPSByZW1haW5kZXI7Cj4gCj4gQ291bGQgYmRldl9vZmZzZXRf
ZnJvbV96b25lX3N0YXJ0KCkgYmUgdXNlZCBoZXJlPwo+IApXZSBjYWxsIHRoaXMgZnVuY3Rpb24g
ZHVyaW5nIGJsa19yZXZhbGlkYXRlX2Rpc2tfem9uZXMoKSB0byBldmFsdWF0ZSB0aGUKY2h1bmsg
c2VjdG9ycy4gU28gd2UgY2FuJ3QgY2FsbCBiZGV2X29mZnNldF9mcm9tX3pvbmVfc3RhcnQoKSBm
cm9tIGhlcmUKYXMgdGhlIGNodW5rX3NlY3RvcnMgd2lsbCBub3QgYmUgaW5pdGlhbGl6ZWQgeWV0
IDopCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

