Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B82ECAAA1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Aug 2022 10:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661853851;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QAj9ITD4lrhyCoq6Ltw7SWmyTjcXxpxCfMuzrW0/DQ8=;
	b=b0BUNeFgO8j8OU+G9Xdo2mn2hgtsLrVRc0W4y6pd9Cci6l7qtF+4FoaGIiEd5pfzYZ6K2f
	NhNgHiuLvEjIa22TPQz1XRKuLabK34NYMhSwWnxTW+/i2PYITpr6Klt5b9RAQR9/ujzSYD
	izUn9K9iC1lalEJuzamyaPrstPIa+AE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-qsCvw1kHO5CnxdqIrCZ1zQ-1; Tue, 30 Aug 2022 06:04:08 -0400
X-MC-Unique: qsCvw1kHO5CnxdqIrCZ1zQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8634E803301;
	Tue, 30 Aug 2022 10:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 718D82026D4C;
	Tue, 30 Aug 2022 10:04:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4FF781946A42;
	Tue, 30 Aug 2022 10:04:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D7FA61946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 10:04:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 874B2C15BBD; Tue, 30 Aug 2022 10:04:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82A63C15BB3
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 10:04:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C05E85A585
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 10:04:02 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-1r7UirQyOp-oXDCZYkPjNw-1; Tue, 30 Aug 2022 06:04:00 -0400
X-MC-Unique: 1r7UirQyOp-oXDCZYkPjNw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220830100359euoutp01225379891a16ef45c8c1b9b497e5f460~QF0MM2CuP1457514575euoutp01A
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 10:03:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220830100359euoutp01225379891a16ef45c8c1b9b497e5f460~QF0MM2CuP1457514575euoutp01A
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220830100358eucas1p2af1fbb0a82c2821242d06ca0e134bd5a~QF0L4lhMD2247422474eucas1p2x;
 Tue, 30 Aug 2022 10:03:58 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 3E.A0.19378.E80ED036; Tue, 30
 Aug 2022 11:03:58 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220830100358eucas1p2f02eaa55af0113c1aee6ea579f549c33~QF0LXQAhH2046320463eucas1p2I;
 Tue, 30 Aug 2022 10:03:58 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220830100358eusmtrp12349e828db7354d492bbd6755edd86a9~QF0LWbizQ1029210292eusmtrp1X;
 Tue, 30 Aug 2022 10:03:58 +0000 (GMT)
X-AuditID: cbfec7f5-fc0a2a8000014bb2-28-630de08e0b56
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 46.34.07473.E80ED036; Tue, 30
 Aug 2022 11:03:58 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220830100358eusmtip1348cb269f1db821d6093c62dedd1c9ac~QF0LLi4Be0117901179eusmtip1C;
 Tue, 30 Aug 2022 10:03:58 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.27) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 30 Aug 2022 11:03:56 +0100
Message-ID: <ea7e7c1c-b47a-6c3a-edce-502b58cc440e@samsung.com>
Date: Tue, 30 Aug 2022 12:03:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220830025235.vesnxh6xw6j2vvsu@shindev>
X-Originating-IP: [106.210.248.27]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsWy7djPc7p9D3iTDT42GlmsP3WM2WL13X42
 i2kffjJb/D57ntmitf0bk8Xed7NZLfYsmsRksXL1USaLJ+tnMVv87boHlLilbXF51xw2i/nL
 nrJbTGj7ymyx5uZTFot9szwtTtySdhD0uHzF22PnrLvsHpfPlnpsWtXJ5rF5Sb3H7psNbB47
 W++zerzfdxUodLra4/MmOY/2A91MAdxRXDYpqTmZZalF+nYJXBnvOrczFezkrWhZu5+1gfEJ
 VxcjJ4eEgIlE29qXzF2MXBxCAisYJa4tnMkG4XxhlHi/+CCU85lR4ujSVkaYlsZnx6FaljNK
 LFy3mwWu6vLGm0wQzi5GiZ8fX4O18ArYSRxceZ4FxGYRUJU4N/8LC0RcUOLkzCdgtqhApMSa
 3WfZQWxhgWyJpX3HwWxmAXGJW0/mM4HYIgKmEk+2bGGCiO9nk/i327OLkYODTUBLorETrJxT
 wEzi5sN2qFZNidbtv6FseYntb+cwQ3ygJHFy2UomCLtWYu2xM+wgN0sIPOOU6Dp/nQUi4SIx
 p+E5VJGwxKvjW9ghbBmJ05N7oGqqJZ7e+M0M0dzCKNG/cz0byEESAtYSfWdyIGocJfYvOM8M
 EeaTuPFWEOIePolJ26YzT2BUnYUUErOQfDwLyQuzkLywgJFlFaN4amlxbnpqsXFearlecWJu
 cWleul5yfu4mRmBqPP3v+NcdjCtefdQ7xMjEwXiIUYKDWUmE9/s5nmQh3pTEyqrUovz4otKc
 1OJDjNIcLErivMmZGxKFBNITS1KzU1MLUotgskwcnFINTKKmzKk+hXePWs+zerf+sYsZp2lY
 wvWArn/Kh7d8nd9oJJFeclHwe/TZ6N1aUysEbl9befHW/h1LZ6Vt4nhtyaW8kcdqw0v2ntlG
 T29sPHZs/5yMT8mcvdKPBOc/iPZzk65hmyz11VH74N4zFya9WDBP54Hc0+t2E57ZV8oor84P
 vHW4XuZp1+bLR/vdNQO6s1pPGd7q81uR9tD4yd/8ubfn7fpwbdGeGwkP1K3TZA7wpbxzDBYQ
 Fji+86BFSSbDZW/x9Usa5204rC4kYu3C4D1D/vmZlxovJwrMuaCked/5YITYpl7eXSpFlwIC
 T9VHNLOGZaisjxUuuG4eZzB56rpn9w7cYFzBaNK1TyjR56YSS3FGoqEWc1FxIgDPdhDe/AMA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xu7p9D3iTDXo2ClisP3WM2WL13X42
 i2kffjJb/D57ntmitf0bk8Xed7NZLfYsmsRksXL1USaLJ+tnMVv87boHlLilbXF51xw2i/nL
 nrJbTGj7ymyx5uZTFot9szwtTtySdhD0uHzF22PnrLvsHpfPlnpsWtXJ5rF5Sb3H7psNbB47
 W++zerzfdxUodLra4/MmOY/2A91MAdxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbm
 sVZGpkr6djYpqTmZZalF+nYJehnvOrczFezkrWhZu5+1gfEJVxcjJ4eEgIlE47PjzF2MXBxC
 AksZJVZ2/GODSMhIfLrykR3CFpb4c62LDaLoI6NEw68dUM4uRolLT/aCdfAK2EkcXHmeBcRm
 EVCVODf/CwtEXFDi5MwnYLaoQKTEw2VNTCC2sEC2xNK+42AbmAXEJW49mQ8WFxEwlXiyZQsT
 RHw/m8S/3Z4Qy94wSkxYvghoEAcHm4CWRGMnWC+ngJnEzYftUHM0JVq3/4ay5SW2v53DDPGB
 ksTJZSuZIOxaiVf3dzNOYBSdheS8WUjOmIVk1CwkoxYwsqxiFEktLc5Nzy021CtOzC0uzUvX
 S87P3cQITCjbjv3cvINx3quPeocYmTgYDzFKcDArifB+P8eTLMSbklhZlVqUH19UmpNafIjR
 FBhGE5mlRJPzgSktryTe0MzA1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQimj4mDU6qB
 ycnpYjXXwqPTnwjvWO+3z3XTQ9stV6ZXR54Jf/70Eutf/bju1bHWx1VTLjaJxS5Zo2Q5v3DN
 +7mRwR4zlT5GtE8/0c4WP9/GdWZT1K7X/Xv2vJM5G/3o/9nY78s89YVS94hu8FF/7jb/yamt
 V2akqbyYXSaWzfdBaoeU8/yHhmnvLKatZ7k299zieIvHinv5e7ewLFTd4h7H29qWUbBHeSrL
 4V91j7J9j9b/DjrgNc25fseefyJa6QvitJQ4t+ad89pXeehsKUegiEvz1avlDledfp2VuvB7
 2dKiPan/lN77W+7QrmyeszE8KY0x4venFpvIiww2Dtnmk6y/qU53npGlce50xr6iWdtb783X
 CVBiKc5INNRiLipOBAA2RNjKsQMAAA==
X-CMS-MailID: 20220830100358eucas1p2f02eaa55af0113c1aee6ea579f549c33
X-Msg-Generator: CA
X-RootMTR: 20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de@eucas1p1.samsung.com>
 <20220823121859.163903-14-p.raghav@samsung.com>
 <20220830025235.vesnxh6xw6j2vvsu@shindev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v12 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 =?UTF-8?Q?Matias_Bj=c3=b8rling?= <Matias.Bjorling@wdc.com>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-08-30 04:52, Shinichiro Kawasaki wrote:
> On Aug 23, 2022 / 14:18, Pankaj Raghav wrote:
>> Only zoned devices with power-of-2(po2) number of sectors per zone(zone
>> size) were supported in linux but now non power-of-2(npo2) zone sizes
>> support has been added to the block layer.
>>
>> Filesystems such as F2FS and btrfs have support for zoned devices with
>> po2 zone size assumption. Before adding native support for npo2 zone
>> sizes, it was suggested to create a dm target for npo2 zone size device to
>> appear as a po2 zone size target so that file systems can initially
>> work without any explicit changes by using this target.
> 
> FYI, with this patch series, I created the new dm target and ran blktests zbd
> group for it. And I observed zbd/007 test case failure (other test cases
> passed). The test checks sector mapping of zoned dm-linear, dm-flakey and dm-
> crypt. Some changes in the test case look required to handle the new target.
> 
Thanks for testing it. I am aware of this test case, and I skipped it while
I was testing my target.

The test needs to be adapted as the container's start, and the logical
device's start will be different for this target.

I initially thought this test case might not apply to the dm-po2zone
target, but at a closer look, it is helpful once the zone offset is adapted
while doing a reset and writing data as the test only verifies the relative
WP position.

I also noticed that this test relies on getting the underlying device id
using `dmsetup table` command. The target currently lacks the `.status`
callback which appends the device id details. I will add them as a part of
the next revision for this target. Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

