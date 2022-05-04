Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3752CC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 21:23:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-uBaIgLdWPqquEbeSDc3E9w-1; Wed, 04 May 2022 17:23:29 -0400
X-MC-Unique: uBaIgLdWPqquEbeSDc3E9w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4051B833959;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E258415F4E;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C059B1947078;
	Wed,  4 May 2022 21:23:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 58F7B19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 08:38:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47D151558995; Wed,  4 May 2022 08:38:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43A161558982
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:38:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C3C2965D28
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:38:58 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-JDoP3qwBMkm0gCY9hvW3dw-1; Wed, 04 May 2022 04:38:56 -0400
X-MC-Unique: JDoP3qwBMkm0gCY9hvW3dw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220504083855euoutp0230960aeabafeedb9a88e5fbf220360f4~r2iO4GaAg0549005490euoutp02K
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:38:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220504083855euoutp0230960aeabafeedb9a88e5fbf220360f4~r2iO4GaAg0549005490euoutp02K
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220504083854eucas1p10fc4f0885aa39652e7f66eedb7c8b3b7~r2iOaQegh0678506785eucas1p1F;
 Wed,  4 May 2022 08:38:54 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 66.C2.10260.E9B32726; Wed,  4
 May 2022 09:38:54 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220504083854eucas1p27a878ea3b3c156361b1985e011e789d7~r2iOAxaSx2524025240eucas1p2_;
 Wed,  4 May 2022 08:38:54 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220504083854eusmtrp24bc4a1c830349bf68a4ceea515e48c11~r2iN-TlXb3001530015eusmtrp2j;
 Wed,  4 May 2022 08:38:54 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-d4-62723b9e95b5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 62.3E.09522.E9B32726; Wed,  4
 May 2022 09:38:54 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220504083854eusmtip13d9e6e9508fba46e708446cb1e14ed62~r2iN0ADCm1508715087eusmtip1I;
 Wed,  4 May 2022 08:38:54 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.170) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 4 May 2022 09:38:51 +0100
Message-ID: <622d87eb-f189-a2f0-281e-a0d4c1a04293@samsung.com>
Date: Wed, 4 May 2022 10:38:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Bart Van Assche <bvanassche@acm.org>, <jaegeuk@kernel.org>,
 <axboe@kernel.dk>, <snitzer@kernel.org>, <hch@lst.de>, <mcgrof@kernel.org>,
 <naohiro.aota@wdc.com>, <sagi@grimberg.me>,
 <damien.lemoal@opensource.wdc.com>, <dsterba@suse.com>,
 <johannes.thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <1e3afa38-0652-0a6a-045c-79a0b9c19f30@acm.org>
X-Originating-IP: [106.210.248.170]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf1CTZRzved937152zXtBkuekK26VpxIUYvZcphHQ+Z5xUZwJmUVD3kOU
 jbUx0lADAe9cCAOZxCiHScoAmTIEhqC2jiG/mjCgtUJDoHTChANOfpjGftjx3+f7/Xw/3+/n
 89xD4T715GoqWZzGSsXCFAHJIxpM8+ag05ulCa/bjwYhXacJR9VDBSQ6NTmPoy5VD4aKCr7j
 osUeM45aHWUcdHMuC0Pa6jYMjerUOMq7PkmgfxW3lno5wzh6NByCioyDAI0NqDHUagtEfSOV
 XNT34zbU0tpBIEvz9yTSnBvjIuWxWRxZlWMAFbbrOaj2/gMC3bD5h/kzlv73mcc3akimMNvB
 Zcy3LhGMpUfO1FUdJ5kzmSqc0Vd8w1wpn8aYK79nksyJbAfJGHJvc5gHVwdIRlc/QDBK/SUO
 M133wofeu3hvJ7Ipyems9LWtX/D2lo5PAYmWOGDNrsUyQQOuAF4UpDdCRYWBUAAe5UNXAni5
 fIHrLmYAPKb/08NMA1jTksV5Kvnb0YW7ifMANud8i/0/lVvi8BTNAJ4vriMVgKL49FZoOhfg
 VBP0y7DAft+1iU97w47SUcKJn6Pj4Cl1N+nEK+lPYbOtw9XHaT9oG9W4dvrSxRhsVY64TuP0
 TRw+mbFynQdIej3MOs51CrzozVCjmiXd4nUwt3GR68YvwuzLZZ7UL8GT1n7MjQ/DC6ZurhuP
 8uCAJsONI2FJVaEn8kpob6/3zDwPnxg0Hm0GHLMuuvxAOgfAAoPOFRgumcjvTnHPvAvbfpgg
 3O0V0Drh7bazAhY1lOBK8Ip62VOol0VWL0ugXpagHBBVwI+Vy0RJrCxUzH4VLBOKZHJxUvCe
 VFEdWPrYXY/bZ5tApX0q2AgwChgBpHCBLz/iJ0mCDz9RePBrVpoaL5WnsDIj8KcIgR9/T/JF
 oQ+dJExj97OshJU+ZTHKa3UmturNwDv3tsxz+hQWfpjGL38h12oeDe8VzeVcN8g+2VB8cEd1
 VPpwqONq3OB8d/oI7VvGjz8UvGbur5jmkAMhPdHypi/PGvXjv9EbIy1hn0cm3k3cHl70rIUq
 vbOlzVK1wX7C1PhWzcevXlM1jU3GTkb1SzqJqLWH/ni4I+ZhzMSvvdr8k0PP5Grv5e3cF3i0
 9vSsNTYnL+5aAl5/VyuwdcZ/FNQXe2Rn+KYP3kgfXDBHrNtvmBFJPzu7NuTnLvk2r4Vib+Oq
 XnXG7sWKR8ObJsY5ksNlv6h0LalaxTD9nnKoxhJwJO1ix75+Xdg/obejixpLpiOmxLpdGWfK
 L0S/4797TYBtu4CQ7RWGrMelMuF/CvwJpUcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/xu7rzrIuSDA7fE7BYf+oYs8Xqu/1s
 FtM+/GS2OD31LJPFpP4Z7Ba/z55nttj7bjarxYUfjUwWK1cfZbJ4sn4Ws0XPgQ8sFn+77gHF
 Wh4yW/x5aGgx6dA1RounV2cxWey9pW1x6fEKdotLi9wt9uw9yWJxedccNov5y56yW0xo+8ps
 cWPCU0aLicc3s1qse/2exeLELWkHaY/LV7w9/p1Yw+Yxsfkdu8f5extZPC6fLfXYtKqTzWNh
 w1Rmj81L6j12L/jM5LH7ZgObR2/zOzaPna33WT3e77vK5rF+y1UWjwmbN7J6fN4kFyAYpWdT
 lF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqkb2eTkpqTWZZapG+XoJcx881HxoKV
 LBU3mtcxNTBuY+5i5OSQEDCRePbuNJDNxSEksJRRYv3Kw6wQCRmJT1c+skPYwhJ/rnWxQRR9
 ZJRYd/cyI4Szi1HiyeXjTF2MHBy8AnYSx5YpgDSwCKhI9L96DTaIV0BQ4uTMJywgtqhAhMSD
 3WfB4sIC0RK7bp0EizMLiEvcejKfCWSmiMAUJom9Ex6DncQscIFZ4v+XG+wQ2z4wSqw53MoM
 so1NQEuisRPsPE4Ba4n5U7+yQUzSlGjd/psdwpaXaN46G+pPZYnJN64wQdi1Eq/u72acwCg6
 C8mBs5AcMgvJqFlIRi1gZFnFKJJaWpybnltsqFecmFtcmpeul5yfu4kRmOi2Hfu5eQfjvFcf
 9Q4xMnEwHmKU4GBWEuF1XlqQJMSbklhZlVqUH19UmpNafIjRFBhKE5mlRJPzgak2ryTe0MzA
 1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQimj4mDU6qBSVAilemPr2j52pmLFi7XsNpy
 iHn21/UKftuWXVmtLcfCwGrxp4Dv6mIHxoWLInzFlTbsE3xftUV1+92AHcsd2p7cX3s8TWqq
 8sXPMtJXG5TshUyv739kY6q7+pi80sVX91mb/qotVQ/Tv6Js+fborV/5DWl7T07QTG/7l/Po
 nPfb+C93lprc9+N6v6xrrd3BXcs8ty/YmxkbcC79qUeSJaO56HJBlUOHwqTjJxicffp50YSX
 B9imvfR80ResNlv37kx3lgP+xZt/saxaOa163itL+7sa4tsqzXrM+xlCS1U3Vjz3ffNEu+7O
 ucWNR9j6Y8vc/m794Srtt/WBisvqvb+ZVERmGLV6/FR60zLXarYSS3FGoqEWc1FxIgBxSFeX
 /QMAAA==
X-CMS-MailID: 20220504083854eucas1p27a878ea3b3c156361b1985e011e789d7
X-Msg-Generator: CA
X-RootMTR: 20220427160301eucas1p147d0dced70946e20dd2dd046b94b8224
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160301eucas1p147d0dced70946e20dd2dd046b94b8224
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160301eucas1p147d0dced70946e20dd2dd046b94b8224@eucas1p1.samsung.com>
 <20220427160255.300418-6-p.raghav@samsung.com>
 <1e3afa38-0652-0a6a-045c-79a0b9c19f30@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 04 May 2022 21:23:25 +0000
Subject: Re: [dm-devel] [PATCH 05/16] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Ck9uIDIwMjItMDUtMDMgMTg6NTAsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPiBPbiA0LzI3LzIy
IDA5OjAyLCBQYW5rYWogUmFnaGF2IHdyb3RlOgo+PiAtwqDCoMKgIHNlY3RvciAmPSB+KG5zLT56
c3plIC0gMSk7Cj4+ICvCoMKgwqAgc2VjdG9yID0gcm91bmRkb3duKHNlY3RvciwgbnMtPnpzemUp
Owo+IAo+IFRoZSBhYm92ZSBjaGFuZ2UgYnJlYWtzIDMyLWJpdCBidWlsZHMgc2luY2UgbnMtPnpz
emUgaXMgNjQgYml0cyB3aWRlIGFuZAo+IHNpbmNlIHJvdW5kZG93bigpIHVzZXMgdGhlIEMgZGl2
aXNpb24gb3BlcmF0b3IgaW5zdGVhZCBvZiBkaXY2NF91NjQoKS4KPiAKR29vZCBjYXRjaC4gSSBk
b24ndCBzZWUgYW55IGdlbmVyaWMgaGVscGVyIGZvciByb3VuZGRvd24gdGhhdCB3aWxsIHdvcmsK
Zm9yIGJvdGggMzIgYml0cyBhbmQgNjQgYml0cy4gTWF5YmUgSSB3aWxsIG9wZW4gY29kZSB0aGUg
cm91bmRkb3duIGxvZ2ljCmhlcmUgc28gdGhhdCBpdCB3b3JrcyBmb3IgYm90aCAzMiBhbmQgNjQg
Yml0cy4KPiBUaGFua3MsCj4gCj4gQmFydC4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

