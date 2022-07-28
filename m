Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D69EC19F29
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659010324;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fAtMoHlOOBGHlYJ4iAfFpG9wjPFPKRSgMLg9HaVmK8Y=;
	b=WBLv6EX0UME4DVsbM8Bq7cpTEYBgWKHEFY2Zx9rO83rcX8Mx1G0Fui4Xsrl66H8sE4Vbtf
	zfYAswWrr7Yho6f293igYjgBDEwHwVlBWSGq10ZFLRzAfcRelXd9sS8abzOwirCPPj7bTo
	eUuRS7lTWiiv9hiHgsbkZn2787vIQ9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-3aaIjUYDO6OuR6rJHaQatQ-1; Thu, 28 Jul 2022 08:12:01 -0400
X-MC-Unique: 3aaIjUYDO6OuR6rJHaQatQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AF3685A587;
	Thu, 28 Jul 2022 12:12:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC5CA2166B26;
	Thu, 28 Jul 2022 12:11:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C9061945DAB;
	Thu, 28 Jul 2022 12:11:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA81B1945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 12:11:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF1322026D2D; Thu, 28 Jul 2022 12:11:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA9A52026D64
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 12:11:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BF203C11727
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 12:11:57 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-gOgiXxwLPcKSrWV2oN5E-Q-1; Thu, 28 Jul 2022 08:11:55 -0400
X-MC-Unique: gOgiXxwLPcKSrWV2oN5E-Q-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220728121154euoutp02ad346654915e3ab727115bb4cf5c1c0a~F-Rdlcu-L2148921489euoutp02a
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 12:11:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220728121154euoutp02ad346654915e3ab727115bb4cf5c1c0a~F-Rdlcu-L2148921489euoutp02a
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220728121154eucas1p2a483eaeef676eb995683b016b0c0a0c2~F-RdCaIaK2051520515eucas1p2s;
 Thu, 28 Jul 2022 12:11:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id EE.96.10067.90D72E26; Thu, 28
 Jul 2022 13:11:54 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220728121153eucas1p2608d9935422fdb31c3a99a4ea2e765ff~F-RcirRNq2057020570eucas1p2D;
 Thu, 28 Jul 2022 12:11:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220728121153eusmtrp2f526d169df0fc66fd0d18be8b5c1a050~F-RcgtnQX2735727357eusmtrp2u;
 Thu, 28 Jul 2022 12:11:53 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-ce-62e27d09b17a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 11.F4.09095.90D72E26; Thu, 28
 Jul 2022 13:11:53 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220728121153eusmtip125d7a9b3b36b4c1ae55cbba9c4f02230~F-RcWQT1O3030030300eusmtip1X;
 Thu, 28 Jul 2022 12:11:53 +0000 (GMT)
Received: from [106.110.32.100] (106.110.32.100) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 28 Jul 2022 13:11:52 +0100
Message-ID: <eed7d9ee-fd7f-e57c-598e-909dbb0d2380@samsung.com>
Date: Thu, 28 Jul 2022 14:11:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Bart Van Assche <bvanassche@acm.org>,
 <damien.lemoal@opensource.wdc.com>, <hch@lst.de>, <axboe@kernel.dk>,
 <snitzer@kernel.org>, <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <7984b969-9025-6b31-2645-da08daeefafb@acm.org>
X-Originating-IP: [106.110.32.100]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djPc7pctY+SDBZOY7RYfbefzWLah5/M
 Fr/Pnme22PtuNqvFnkWTmCxWrj7KZPFk/Sxmi79d95gs9t7Stri8aw6bxfxlT9ktJrR9Zba4
 MeEpo8Wam09ZLE7cknbg97h8xdtj56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweO1vvs3q833cV
 KHS62uPzJjmP9gPdTAHcUVw2Kak5mWWpRfp2CVwZe9/fYS2YL14x+e1klgbGycJdjJwcEgIm
 EhcnvGPpYuTiEBJYwSjx+EULE4TzhVGi6+cPqMxnRonN+xexwLS86/rNCJFYzijx7/cuNriq
 3a1roPp3M0r8vzGPvYuRg4NXwE7iU5MmiMkioCpxqSEQZBCvgKDEyZlPwIaKCkRKrNl9lh3E
 FhaIl/hxfBEbiM0sIC5x68l8sJEiAkuBlt2+CLaMWWAGk8Txy6vYQIayCWhJNHaCreIUsJa4
 fL0coldTonX7b3YIW16ieetsZogHlCQmzLvPBmHXSqw9doYdZKSEwDNOibWPdkAVuUg82f6V
 EcIWlnh1fAs7hC0j8X8nyEEgdrXE0xu/mSGaWxgl+neuB7tHAuiIvjM5EDWOEgteP2eECPNJ
 3HgrCHEPn8SkbdOZJzCqzkIKillIXp6F5IVZSF5YwMiyilE8tbQ4Nz212CgvtVyvODG3uDQv
 XS85P3cTIzANnv53/MsOxuWvPuodYmTiYDzEKMHBrCTCmxB9P0mINyWxsiq1KD++qDQntfgQ
 ozQHi5I4b3LmhkQhgfTEktTs1NSC1CKYLBMHp1QD0+pz82Ku6OckvN0X+9r+5zFldneDnKPe
 20oOXHz/M+ei3jp55W3q0ZkJV1/YttQqv3fTd3KdmMKp/oLpYYN7NMf2J79288/MYLDs55tR
 FWQdGx1m19uiat3xZee+vZp5fy5xnFfYZdt9LalR27Ow8tEr6xdW/Ln+giJ6glnR7Ffb1t6c
 siW260jGnXAZniLJm8pGwtxRlybmJD6se3z24cNTu7Xmz+h4+P+NzvTH+rOcFm1c4JJ1I/va
 16CnDKfPnrGf6vRh97986Uuv/Ztm7ua6xvHWbf5Uh0mWqru2bnx+mW9/SdLRm3+lZ3bmtS8W
 2n5NnyNpZ/LXW299bd63mMdP2/RlTouvyZzpDD9vTFBiKc5INNRiLipOBABWBeAm8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t/xu7qctY+SDDZclbZYfbefzWLah5/M
 Fr/Pnme22PtuNqvFnkWTmCxWrj7KZPFk/Sxmi79d95gs9t7Stri8aw6bxfxlT9ktJrR9Zba4
 MeEpo8Wam09ZLE7cknbg97h8xdtj56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweO1vvs3q833cV
 KHS62uPzJjmP9gPdTAHcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2
 Kak5mWWpRfp2CXoZe9/fYS2YL14x+e1klgbGycJdjJwcEgImEu+6fjN2MXJxCAksZZT40vqa
 DSIhI/Hpykd2CFtY4s+1LjaIoo+MEhse3WKFcHYzSqx6u4y5i5GDg1fATuJTkyaIySKgKnGp
 IRCkl1dAUOLkzCcsILaoQKTEw2VNTCC2sEC8xI/ji8B2MQuIS9x6Mp8JZKQIyBFzZj4Bu4hZ
 YAaTxPHLq8CqhAQ+MEp0HpUFWcAmoCXR2MkOYnIKWEtcvl4OMUdTonX7b3YIW16ieetsZoj7
 lSQmzLsP9VetxKv7uxknMIrOQnLeLCRnzEIyahaSUQsYWVYxiqSWFuem5xYb6hUn5haX5qXr
 JefnbmIEpo5tx35u3sE479VHvUOMTByMhxglOJiVRHgTou8nCfGmJFZWpRblxxeV5qQWH2I0
 BQbRRGYp0eR8YPLKK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1ILYLpY+LglGpg
 Wmh+55llhdbKTSUXPX8utvzYvmL17VfTDW6fccu5vf25Y5yq22TlN3+fOa9JmL04vtR58dek
 yZO8Z7+7fN6Webfix+XHF0UtL/r1QaVqZbL7PpVXC074qKUdXPJO+9r7K/cbUzKm65+Veljk
 1MusF5iXcShm8rJrSz2X9b9fGzpjPuf5xPZJj5qNbx8rter9VCagxpT962BpE7Pm20Pz7v6Z
 fGARA5fB9ctbt59fcj5O7ISy64a9D6csv72p9avntaf7dDaxHEpRszPebuwxf+O+KtvIiXdP
 yO3WT5p4btb9rm/1Os3///maxZ7Z+eT66kQn9r3N5akdcwrX+jb9eHNnhTl3yblg3rRFUuqh
 pWo8SizFGYmGWsxFxYkAoli54aYDAAA=
X-CMS-MailID: 20220728121153eucas1p2608d9935422fdb31c3a99a4ea2e765ff
X-Msg-Generator: CA
X-RootMTR: 20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9@eucas1p2.samsung.com>
 <20220727162245.209794-3-p.raghav@samsung.com>
 <7984b969-9025-6b31-2645-da08daeefafb@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v8 02/11] block: allow blk-zoned devices to
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMi0wNy0yOCAwMToxNiwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+IE9uIDcvMjcvMjIg
MDk6MjIsIFBhbmthaiBSYWdoYXYgd3JvdGU6Cj4+IENoZWNraW5nIGlmIGEgZ2l2ZW4gc2VjdG9y
IGlzIGFsaWduZWQgdG8gYSB6b25lIGlzIGEgY29tbW9uCj4+IG9wZXJhdGlvbiB0aGF0IGlzIHBl
cmZvcm1lZCBmb3Igem9uZWQgZGV2aWNlcy4gQWRkCj4+IGJkZXZfaXNfem9uZV9zdGFydCBoZWxw
ZXIgdG8gY2hlY2sgZm9yIHRoaXMgaW5zdGVhZCBvZiBvcGVuY29kaW5nIGl0Cj4+IGV2ZXJ5d2hl
cmUuCj4gCj4gSSBjYW4ndCBmaW5kIHRoZSBiZGV2X2lzX3pvbmVfc3RhcnQoKSBmdW5jdGlvbiBp
biB0aGlzIHBhdGNoPwo+IApJIG1hZGUgdGhlIG5hbWUgY2hhbmdlIGZyb20gYmRldl9pc196b25l
X3N0YXJ0IHRvIGJkZXZfaXNfem9uZV9hbGlnbmVkCmxhc3QgbW9tZW50IGFuZCBtaXNzZWQgY2hh
bmdpbmcgaXQgaW4gdGhlIGNvbW1pdCBsb2cuCgo+PiBUbyBtYWtlIHRoaXMgd29yayBiZGV2X2dl
dF9xdWV1ZSgpLCBiZGV2X3pvbmVfc2VjdG9ycygpIGFuZAo+PiBiZGV2X2lzX3pvbmVkKCkgYXJl
IG1vdmVkIGVhcmxpZXIgd2l0aG91dCBtb2RpZmljYXRpb25zLgo+IAo+IENhbiB0aGF0IGNoYW5n
ZSBwZXJoYXBzIGJlIGlzb2xhdGVkIGludG8gYSBzZXBhcmF0ZSBwYXRjaD8KPiAKPj4gZGlmZiAt
LWdpdCBhL2Jsb2NrL2Jsay1jb3JlLmMgYi9ibG9jay9ibGstY29yZS5jCj4+IGluZGV4IDNkMjg2
YTI1NmQzZC4uMWY3ZTlhOTBlMTk4IDEwMDY0NAo+PiAtLS0gYS9ibG9jay9ibGstY29yZS5jCj4+
ICsrKyBiL2Jsb2NrL2Jsay1jb3JlLmMKPj4gQEAgLTU3MCw3ICs1NzAsNyBAQCBzdGF0aWMgaW5s
aW5lIGJsa19zdGF0dXNfdAo+PiBibGtfY2hlY2tfem9uZV9hcHBlbmQoc3RydWN0IHJlcXVlc3Rf
cXVldWUgKnEsCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gQkxLX1NUU19OT1RTVVBQOwo+
PiDCoCDCoMKgwqDCoMKgIC8qIFRoZSBiaW8gc2VjdG9yIG11c3QgcG9pbnQgdG8gdGhlIHN0YXJ0
IG9mIGEgc2VxdWVudGlhbCB6b25lICovCj4+IC3CoMKgwqAgaWYgKGJpby0+YmlfaXRlci5iaV9z
ZWN0b3IgJiAoYmRldl96b25lX3NlY3RvcnMoYmlvLT5iaV9iZGV2KSAtCj4+IDEpIHx8Cj4+ICvC
oMKgwqAgaWYgKCFiZGV2X2lzX3pvbmVfYWxpZ25lZChiaW8tPmJpX2JkZXYsIGJpby0+YmlfaXRl
ci5iaV9zZWN0b3IpIHx8Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCAhYmlvX3pvbmVfaXNfc2VxKGJp
bykpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gQkxLX1NUU19JT0VSUjsKPiAKPiBUaGUg
YmRldl9pc196b25lX3N0YXJ0KCkgbmFtZSBzZWVtcyBtb3JlIGNsZWFyIHRvIG1lIHRoYW4KPiBi
ZGV2X2lzX3pvbmVfYWxpZ25lZCgpLiBIYXMgdGhlcmUgYWxyZWFkeSBiZWVuIGEgZGlzY3Vzc2lv
biBhYm91dCB3aGljaAo+IG5hbWUgdG8gdXNlIGZvciB0aGlzIGZ1bmN0aW9uPwo+IApUaGUgcmVh
c29uIEkgZGlkIHMvYmRldl9pc196b25lX3N0YXJ0L2JkZXZfaXNfem9uZV9hbGlnbmVkIGlzIHRo
YXQgdGhpcwpuYW1lIG1ha2VzIG1vcmUgc2Vuc2UgZm9yIGFsc28gY2hlY2tpbmcgaWYgYSBnaXZl
biBzaXplIGlzIGEgbXVsdGlwbGUgb2YKem9uZSBzZWN0b3JzIGZvciBlLmcuLCB1c2VkIGluIFBB
VENIIDk6CgotCQlpZiAobGVuICYgKHpvbmVfc2VjdG9ycyAtIDEpKSB7CisJCWlmICghYmRldl9p
c196b25lX2FsaWduZWQoYmRldiwgbGVuKSkgewoKSSBmZWx0IGBiZGV2X2lzX3pvbmVfYWxpZ25l
ZGAgZml0cyB0aGUgdXNlIGNhc2Ugb2YgY2hlY2tpbmcgaWYgdGhlCnNlY3RvciBzdGFydHMgYXQg
dGhlIHN0YXJ0IG9mIGEgem9uZSBhbmQgYWxzbyBjaGVjayBpZiBhIGdpdmVuIGxlbmd0aCBvZgpz
ZWN0b3JzIGFsc28gYWxpZ24gd2l0aCB0aGUgem9uZSBzZWN0b3JzLiBiZGV2X2lzX3pvbmVfc3Rh
cnQgZG9lcyBub3QKbWFrZSB0aGUgaW50ZW50aW9uIGNsZWFyIGZvciB0aGUgbGF0dGVyIHVzZSBj
YXNlIElNTy4KCkJ1dCBJIGFtIGZpbmUgd2l0aCBnb2luZyBiYWNrIHRvIGJkZXZfaXNfem9uZV9z
dGFydCBpZiB5b3UgYW5kIERhbWllbgpmZWVsIHN0cm9uZ2x5IG90aGVyd2lzZS4KPj4gK8KgwqDC
oMKgwqDCoMKgIC8qCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogTm9uIHBvd2VyLW9mLTIgem9uZSBz
aXplIHN1cHBvcnQgd2FzIGFkZGVkIHRvIHJlbW92ZSB0aGUKPj4gK8KgwqDCoMKgwqDCoMKgwqAg
KiBnYXAgYmV0d2VlbiB6b25lIGNhcGFjaXR5IGFuZCB6b25lIHNpemUuIFRob3VnaCBpdCBpcwo+
PiB0ZWNobmljYWxseQo+PiArwqDCoMKgwqDCoMKgwqDCoCAqIHBvc3NpYmxlIHRvIGhhdmUgZ2Fw
cyBpbiBhIG5vbiBwb3dlci1vZi0yIGRldmljZSwgTGludXgKPj4gcmVxdWlyZXMKPj4gK8KgwqDC
oMKgwqDCoMKgwqAgKiB0aGUgem9uZSBzaXplIHRvIGJlIGVxdWFsIHRvIHpvbmUgY2FwYWNpdHkg
Zm9yIG5vbiBwb3dlci1vZi0yCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogem9uZWQgZGV2aWNlcy4K
Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKi8KPj4gK8KgwqDCoMKgwqDCoMKgIGlmICghaXNfcG93ZXJf
b2ZfMih6b25lLT5sZW4pICYmIHpvbmUtPmNhcGFjaXR5IDwgem9uZS0+bGVuKSB7Cj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHByX3dhcm4oIiVzOiBJbnZhbGlkIHpvbmUgY2FwYWNpdHkgZm9y
IG5vbiBwb3dlciBvZiAyCj4+IHpvbmUgc2l6ZSIsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZGlzay0+ZGlza19uYW1lKTsKPiAKPiBHaXZlbiB0aGUgc2V2ZXJpdHkgb2YgdGhp
cyBlcnJvciwgc2hvdWxkbid0IHRoZSB6b25lIGNhcGFjaXR5IGFuZCBsZW5ndGgKPiBiZSByZXBv
cnRlZCBpbiB0aGUgZXJyb3IgbWVzc2FnZT8KPiAKT2suCj4gVGhhbmtzLAo+IAo+IEJhcnQuCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

