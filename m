Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 530E9ECAAA1
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663351061;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0ndeTBiKQzWEhMr4+SIUSbL0SZkFCRYwPwMu70jskws=;
	b=bukZbgZsZ/ussGY7oBePooOvtJXXyGQ6EHK/7aQrX9bEMjc1Bs/QZWS9fiZufV5vMuvsxI
	3maY5Gu5nFJz4jVmM7FlwTY6rbO897twz+qpitlrGL8jeWMXx6MMekLI9ijwKNYdcEgprk
	WdDQt9XDX7bxAlC5sNtxkICclqId5BE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-OzJRMhjYMoO6Q3z5eIxhxA-1; Fri, 16 Sep 2022 13:57:37 -0400
X-MC-Unique: OzJRMhjYMoO6Q3z5eIxhxA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C9C7101A528;
	Fri, 16 Sep 2022 17:57:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EF17492B05;
	Fri, 16 Sep 2022 17:57:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1730C194658F;
	Fri, 16 Sep 2022 17:57:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55EDB1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 17:57:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E92A7C15BA5; Fri, 16 Sep 2022 17:57:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0805C15BA4
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 17:57:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6A83862FDC
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 17:57:30 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-9qZQaQrEPN2oZW3Obp5i7g-1; Fri, 16 Sep 2022 13:57:28 -0400
X-MC-Unique: 9qZQaQrEPN2oZW3Obp5i7g-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220916175727euoutp0208db90c192212f377dc1c4eed75f491f~VaPcOc9eJ2770927709euoutp02N
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 17:57:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220916175727euoutp0208db90c192212f377dc1c4eed75f491f~VaPcOc9eJ2770927709euoutp02N
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220916175727eucas1p29f8779dd295b1870898730a928a1732e~VaPbzdcPJ0630006300eucas1p2i;
 Fri, 16 Sep 2022 17:57:27 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id B3.EC.29727.709B4236; Fri, 16
 Sep 2022 18:57:27 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220916175726eucas1p2b96d3dda893b1e3b47e0ae4f22da13d5~VaPa0z9ck0629506295eucas1p2x;
 Fri, 16 Sep 2022 17:57:26 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220916175726eusmtrp20aec6fd837cb9c97323960623fd98cb1~VaPaz9JkG2811228112eusmtrp2i;
 Fri, 16 Sep 2022 17:57:26 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-45-6324b9075764
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 85.B7.07473.609B4236; Fri, 16
 Sep 2022 18:57:26 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220916175725eusmtip282c3befede6e547a184672cacca605db~VaPanlpJO0439104391eusmtip2m;
 Fri, 16 Sep 2022 17:57:25 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.192) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 16 Sep 2022 18:57:21 +0100
Message-ID: <622ae86d-39ad-c45e-ec48-42abf4b257d2@samsung.com>
Date: Fri, 16 Sep 2022 19:57:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From: Pankaj Raghav <p.raghav@samsung.com>
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <e42a0579-61b2-7b77-08cb-6723278490cc@samsung.com>
X-Originating-IP: [106.210.248.192]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7djPc7rsO1WSDQ6f4rBYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWuxZNInJYuXqo0wWT9bPYrb423UPKHFL2+LyrjlsFvOX
 PWW3mND2ldlizc2nLBYnbklbtG38yugg6HH5irfHzll32T0uny312LSqk81j85J6j903G9g8
 drbeZ/V4v+8qUOh0tcfnTXIe7Qe6mQK4o7hsUlJzMstSi/TtErgyGrfFF2xgqbg+LaGBcTVz
 FyMnh4SAicSF31tZuhi5OIQEVjBKXFnyCcr5wiixu20LG4TzmVGi51ATI0xLz4w5jBCJ5YwS
 +6/8Zoer2tWznBXC2c0o8enwC3aQFl4BO4mbZ98zgdgsAqoSM7/dZoKIC0qcnPmEBcQWFYiU
 WLP7LFi9sEC2xMFrm8AuZBYQl7j1ZD5QPQcHm4CWRGMnO4gpAjTm1jQXiIr9zBL98yxAbE4B
 e4l9Gy4wQcQ1JVq3/2aHsOUltr+dA/WzssTMm1Oh7FqJtcfOsEPYjzglNrVZgIyXEHCR2Nkc
 BxEWlnh1fAtUiYzE/53zmSDsaomnN34zg3wrIdDCKNG/cz0bRK+1RN+ZHIgaR4mGaT+ZIcJ8
 EjfeCkJcwycxadt05gmMqrOQgmEWkndnIXlgFpIHFjCyrGIUTy0tzk1PLTbMSy3XK07MLS7N
 S9dLzs/dxAhMiaf/Hf+0g3Huq496hxiZOBgPMUpwMCuJ8Kp6qiQL8aYkVlalFuXHF5XmpBYf
 YpTmYFES503O3JAoJJCeWJKanZpakFoEk2Xi4JRqYJK1vHtb8uOdE7m/Ledwej2dFbBxUQHT
 nNOB2/9Pz4pSkSitr5vjIfjox66JDtHSp1WKTL5Vxfoz7eeO6fvxaGJabP/7ILc7Ch+S3D8v
 /v2Mw1Iy+qOT4GKGq2snfn958eS6MqHm+XnGFWkhU/yYZkU3zVVwXlQu+JnVs/TG3jW6lq/1
 7TmmOWTbn5h17EtE/uwKxyz5x1rxOpPWH2tViJaovvVD+di6loC4++v+LPl/ZOFJE4uZvtE7
 LgX0GNpvdLG62r/j9fzEq028vas1u1dwRrwKElfx3MBTxJIk3LOQ75I0c27P/M+W/iuao5Oi
 2zTvcTM9PjX7VFjj/rdf77ZYn9r/2j6kPem58rJWUSWW4oxEQy3mouJEAEG+Xgj4AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t/xe7psO1WSDd69ZLVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWuxZNInJYuXqo0wWT9bPYrb423UPKHFL2+LyrjlsFvOX
 PWW3mND2ldlizc2nLBYnbklbtG38yugg6HH5irfHzll32T0uny312LSqk81j85J6j903G9g8
 drbeZ/V4v+8qUOh0tcfnTXIe7Qe6mQK4o/RsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyN
 zWOtjEyV9O1sUlJzMstSi/TtEvQyGrfFF2xgqbg+LaGBcTVzFyMnh4SAiUTPjDmMXYxcHEIC
 Sxkl1i1dywqRkJH4dOUjO4QtLPHnWhcbRNFHRomFuxayQzi7GSVOLL3EBlLFK2AncfPseyYQ
 m0VAVWLmt9tMEHFBiZMzn7CA2KICkRIPlzWBxYUFsiUOXtsEdgazgLjErSfzgeIcHGwCWhKN
 newgpgjQmFvTXCAq9jNL9M+zgFg7kUni34E7YGs5Bewl9m24wARRpCnRuv03O4QtL7H97Ryo
 L5UlZt6cCmXXSry6v5txAqPoLCTXzUJyxSwko2YhGbWAkWUVo0hqaXFuem6xoV5xYm5xaV66
 XnJ+7iZGYDLZduzn5h2M81591DvEyMTBeIhRgoNZSYRX1VMlWYg3JbGyKrUoP76oNCe1+BCj
 KTCIJjJLiSbnA9NZXkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2ampBahFMHxMHp1QD
 0542hevvdr8ydz6+61fYTyfWvYalBXcjfgXLprX/WZmizajYcbPOID2kdeeyp5u9/IJCJZo3
 iWQWPzpvN8vFX+V8VOKqmFPdLDv5DRJ2pi+e/cQh/sDK96r9v8W0FxwwdZ6ffdwsJln056vV
 C8JibDeu5pDamlGTlZImHu0gtr3rh9vjumXrozwqj8vE7/C0aGdvOu9YpdkmuefI/Yynju/m
 mZxI2PVy0d1cnjl1yf3VUv2OK969DokssnuQdizg2N1DE2IPe1meaVR/+DQqfrXz7dPtDkY5
 uab/f35pbftTfEd3ZpHLmVtuQREnn4jf/b1apaZI+aRw8F3FalcjzetPU64ZTEnzPZytWfxU
 iaU4I9FQi7moOBEAgMk2La8DAAA=
X-CMS-MailID: 20220916175726eucas1p2b96d3dda893b1e3b47e0ae4f22da13d5
X-Msg-Generator: CA
X-RootMTR: 20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5@eucas1p2.samsung.com>
 <20220912082204.51189-14-p.raghav@samsung.com> <YyIG3i++QriS9Gyy@redhat.com>
 <e42a0579-61b2-7b77-08cb-6723278490cc@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v13 13/13] dm: add power-of-2 target for
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>
>> Are you certain you shouldn't at least be exposing a different
>> logical_block_size to upper layers?
>>
> To be honest, I tested my patches in QEMU with 4k Logical block size and on
> a device with 4k LBA size.
> 
> I did a quick test with 512B LBA size in QEMU, and I didn't see any
> failures when I ran my normal test suite.
> 
> Do you see any problem with exposing the same LBA as the underlying device?
> 

Do you see any issues here? If not, I can send the next version with the
other two changes you suggested.

Thanks,
Pankaj

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

