Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2536BC38145
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 12:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662120157;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VfwiQb7du7TZNQumaCe5k9A7NTGUnQmrIi8/Z+O6QC4=;
	b=Tc0lYjUL8l+M9DL6s1Od2MzLupp00VYHOfDQCqmEfTmnK4kH27P02LwM7RO/7pns4SG8r5
	NftP3uimXDRlQado7Sm4L7uLPD4oI26PYBjFsMmpH9vnH9x2jNSkin4glt2ZvBXLmlXXoe
	uCqIH2fmrMULKuwUAg56dVFf80OO5do=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-yHyXlgopM42xTOlklgZLeg-1; Fri, 02 Sep 2022 08:02:33 -0400
X-MC-Unique: yHyXlgopM42xTOlklgZLeg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36F5E3C1198F;
	Fri,  2 Sep 2022 12:02:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81839C15BB3;
	Fri,  2 Sep 2022 12:02:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F03B3194B941;
	Fri,  2 Sep 2022 12:02:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D0764194E013
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 12:02:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 43CC7403163; Fri,  2 Sep 2022 12:02:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 401A2492C3B
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 12:02:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26928380406E
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 12:02:13 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-I6cCuGFyOzCu5ztmpQuX6g-1; Fri, 02 Sep 2022 08:02:08 -0400
X-MC-Unique: I6cCuGFyOzCu5ztmpQuX6g-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220902120207euoutp0221220e5730d2fb7e7c0d5ee831954925~RCXMGcdpK3254632546euoutp02u
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 12:02:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220902120207euoutp0221220e5730d2fb7e7c0d5ee831954925~RCXMGcdpK3254632546euoutp02u
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220902120206eucas1p2718c2f0ddf87452f3dd1bf6349e92563~RCXLpFLBu3079630796eucas1p2Y;
 Fri,  2 Sep 2022 12:02:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 0A.52.07817.EB0F1136; Fri,  2
 Sep 2022 13:02:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220902120206eucas1p1bff06c1bc60d068c2807bad75ce342f2~RCXLHFq-_3031230312eucas1p1R;
 Fri,  2 Sep 2022 12:02:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220902120206eusmtrp2bce39382a0e300c0c835ba79a2b355f1~RCXLGKl2C0333103331eusmtrp2D;
 Fri,  2 Sep 2022 12:02:06 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-78-6311f0bee919
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id D5.24.07473.DB0F1136; Fri,  2
 Sep 2022 13:02:05 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220902120205eusmtip11c33df1e1d97a92b6e98a09492ea4d42~RCXK7TqlI3188931889eusmtip1z;
 Fri,  2 Sep 2022 12:02:05 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.27) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 2 Sep 2022 13:02:04 +0100
Message-ID: <96f90e1d-aa0f-1c76-bfc9-a87e978ad655@samsung.com>
Date: Fri, 2 Sep 2022 14:02:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Snitzer <snitzer@redhat.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <YxFOS8fq8AeE5mkf@redhat.com>
X-Originating-IP: [106.210.248.27]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7djP87r7PggmG5zfIWux/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rsWTSJyWLl6qNMFk/Wz2K2+Nt1j8li7y1ti8u75rBZzF/2lN1i
 QttXZos1N5+yWJy4JW3RtvEro4OAx+Ur3h47Z91l97h8ttRj06pONo/NS+o9dt9sYPPY2Xqf
 1eP9vqtAodPVHp83yXm0H+hmCuCO4rJJSc3JLEst0rdL4Mr4saeNraCHs2JaS2ED4zr2LkZO
 DgkBE4klK2ezdDFycQgJrGCUmHhnCVhCSOALo8STAzIQ9mdGid6t/DANm/69ZYVoWM4oMfXM
 PEYIB6io8fpydghnJ6PEwcctrCAtvAJ2Ert3dLGA2CwCKhJrL79ngYgLSpyc+QTMFhWIlFiz
 +yzYamEBL4m5H/4ygdjMAuISt57MB7I5OEQEVCVuTXMBmc8sMJ1Z4tWMRewgcTYBLYnGTrBW
 TiDz+54dLBCtmhKt23+zQ9jyEtvfzmGG+EBJ4uSylUwQdq3E2mNnoEHxiFPiwr4yCNtFYtOD
 ZkYIW1ji1fEtUDUyEv93zofqrZZ4euM3M8g9EgItjBL9O9ezgdwjIWAt0XcmB6LGUeLm2+3s
 EGE+iRtvBSHO4ZOYtG068wRG1VlIATELycOzkHwwC8kHCxhZVjGKp5YW56anFhvlpZbrFSfm
 Fpfmpesl5+duYgSmwtP/jn/Zwbj81Ue9Q4xMHIyHGCU4mJVEeKceFkgW4k1JrKxKLcqPLyrN
 SS0+xCjNwaIkzpucuSFRSCA9sSQ1OzW1ILUIJsvEwSnVwOQScp/VeVXdxNqYvoCJjb51KnO8
 dndrTl2j9+xA2FbXhedvNGst3yDjvNFX4RdjzgOd3k6dI9zc8zwSszKVVzallzxv4jpmKf1X
 2eTZ7lShDbODAm6fzKnhOTsl6fj7CLZb6YLKvPcWt6dE38/aaapx8PGnG/4zC7/0pEjbvdpY
 uEhPd5/9hitMrC5KP7NW9vwP/Sdq+y5oruvh0EdyWtuCJ+pxlluEq55zWxJy4+2DSPW5wUyd
 BmXm5/hF7+x7dde9k63a8deEy/m95jpXiv8UHzu2wbMlQu9h14fLRctO+Oc/KjvX873hSmKP
 9LkVWzhYjvWVfShsLdwe+Zj17/3FXQEXPt89tu3Tq9VytkosxRmJhlrMRcWJACswvdv0AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t/xu7p7PwgmGyxqsrZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS32LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8Wam09ZLE7ckrZo2/iV0UHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31Wg0Olqj8+b5DzaD3QzBXBH6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZ
 mSrp29mkpOZklqUW6dsl6GX82NPGVtDDWTGtpbCBcR17FyMnh4SAicSmf29ZQWwhgaWMEgff
 6UHEZSQ+XfkIVSMs8edaF1sXIxdQzUdGiY9tZ1khnJ2MEoumb2QCqeIVsJPYvaOLBcRmEVCR
 WHv5PQtEXFDi5MwnYLaoQKTEw2VNYPXCAl4Scz/8BbOZBcQlbj2ZD2RzcIgIqErcmuYCMp9Z
 YDqzxKsZi9ghrrvHKLH3RxFIDZuAlkRjJ1iYE8j8vmcHC8QYTYnW7b/ZIWx5ie1v5zBDPKAk
 cXLZSiYIu1bi1f3djBMYRWchuW4WkitmIRk1C8moBYwsqxhFUkuLc9Nziw31ihNzi0vz0vWS
 83M3MQJTyLZjPzfvYJz36qPeIUYmDsZDjBIczEoivFMPCyQL8aYkVlalFuXHF5XmpBYfYjQF
 BtFEZinR5HxgEssriTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJzU5NLUgtgulj4uCUamCy
 aLXrmNTIfD896G5c0iXX/0Y24n48L2QOm1wMfGCiZBu26uhTBtvQE18/TpcXtC9wFHj7W/2F
 aUsX69tVTfOlNEPkKnvcu3b+TnaIef06bPoO6bP/rjnLfJ1wnO3+wu9zZr0yUUnl0l5b3RLx
 513cjllVh8PZFk3I2DhnyaLutveXK61Pv0yPW3L98JGKvLP22fOtS/P91vbH5Lbejgg/n/6W
 i0VW/Yy8u5ZLo+nM02GKhvs13bZ7lVWVHT2W6LXyY/tcbh+DY7vOGMy8+CJwy/SoN2FNM0ND
 K/5EPXCv/ZRx8+Lj56sfSF+rV7jO/XbGcusUJtOvBzimqXRvs/18r/K+ou1fhlsv3kXb93Yr
 sRRnJBpqMRcVJwIAHouRhqoDAAA=
X-CMS-MailID: 20220902120206eucas1p1bff06c1bc60d068c2807bad75ce342f2
X-Msg-Generator: CA
X-RootMTR: 20220823121914eucas1p2f4445066c23cdae4fca80f7b0268815b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121914eucas1p2f4445066c23cdae4fca80f7b0268815b
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121914eucas1p2f4445066c23cdae4fca80f7b0268815b@eucas1p2.samsung.com>
 <20220823121859.163903-13-p.raghav@samsung.com>
 <YxFOS8fq8AeE5mkf@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v12 12/13] dm: introduce DM_EMULATED_ZONES
 target type
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
Cc: axboe@kernel.dk, bvanassche@acm.org, pankydev8@gmail.com,
 matias.bjorling@wdc.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-09-02 02:28, Mike Snitzer wrote:
> On Tue, Aug 23 2022 at  8:18P -0400,
> Pankaj Raghav <p.raghav@samsung.com> wrote:
> 
>> Introduce a new target type DM_EMULATED_ZONES for targets with
>> a different number of sectors per zone (aka zone size) than the underlying
>> device zone size.
>>
>> This target type is introduced as the existing zoned targets assume
>> that the target and the underlying device have the same zone size.
>> The new target: dm-po2zone will use this new target
>> type as it emulates the zone boundary that is different from the
>> underlying zoned device.
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> This patch's use of "target type" jargon isn't valid. 
> 
> Please say "target feature flag" and rename DM_EMULATED_ZONES to
> DM_TARGET_EMULATED_ZONES in the subject and header.
> Good catch. I will fix it up for the next version.
> But, with those fixed:
> 
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> 
You mean <Reviewed-By> ? :)
> (fyi, I'll review patch 13, the dm-po2zone target, tomorrow)
> 
Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

