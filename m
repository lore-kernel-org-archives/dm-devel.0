Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B7BC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 15:32:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-nyfNvhgFOq2SsMYGL9QRfQ-1; Tue, 24 May 2022 11:32:47 -0400
X-MC-Unique: nyfNvhgFOq2SsMYGL9QRfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E207101A54E;
	Tue, 24 May 2022 15:32:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC4601410F36;
	Tue, 24 May 2022 15:32:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F1B8194EBB6;
	Tue, 24 May 2022 15:32:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FE76194EBB5
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 15:32:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CF724401E74; Tue, 24 May 2022 15:32:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA8A4401E3B
 for <dm-devel@redhat.com>; Tue, 24 May 2022 15:32:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3179811E84
 for <dm-devel@redhat.com>; Tue, 24 May 2022 15:32:41 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-EcP4MxlPPa6V8DYr55kzOA-1; Tue, 24 May 2022 11:32:39 -0400
X-MC-Unique: EcP4MxlPPa6V8DYr55kzOA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220524153238euoutp0262ddb18c78e338eab6388e6b49201c64~yFFK9oSPI2915429154euoutp02N
 for <dm-devel@redhat.com>; Tue, 24 May 2022 15:32:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220524153238euoutp0262ddb18c78e338eab6388e6b49201c64~yFFK9oSPI2915429154euoutp02N
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220524153237eucas1p21713359205fa91bff66c156a8006e9f3~yFFKHPzAz1196811968eucas1p2X;
 Tue, 24 May 2022 15:32:37 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 5E.51.10260.59AFC826; Tue, 24
 May 2022 16:32:37 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220524153237eucas1p112db24d3a714f392b11ca536f8ad02fc~yFFJt-Xdb1038610386eucas1p13;
 Tue, 24 May 2022 15:32:37 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220524153237eusmtrp1cdbe1017ebc6f3ec63d9d497e5476fed~yFFJpeED73015730157eusmtrp1C;
 Tue, 24 May 2022 15:32:37 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-03-628cfa95c0ee
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 12.89.09404.59AFC826; Tue, 24
 May 2022 16:32:37 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220524153237eusmtip2b3fb7136966530549b550fb45623a334~yFFJeMCmc3163231632eusmtip2F;
 Tue, 24 May 2022 15:32:37 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.20) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 24 May 2022 16:32:34 +0100
Message-ID: <6e409447-be78-f189-231f-f39b1e50b91e@samsung.com>
Date: Tue, 24 May 2022 17:32:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Nathan Chancellor <nathan@kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <Yoz4PsQjWzVxz+YO@dev-arch.thelio-3990X>
X-Originating-IP: [106.210.248.20]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7djPc7pTf/UkGbw8amCx+m4/m8Xvs+eZ
 Lfa+m81qceFHI5PFnkWTmCxWrj7KZPFk/Sxmi54DH1gs/nbdY7I4232N0WLvLW2Ly7vmsFnM
 X/aU3eJV8yM2iydT9rNZ3JjwlNGifeVTNou2jV8ZHYQ8/p1Yw+axeM9LJo/LZ0s9Nq3qZPPo
 nv2PxWPzknqPF5tnMnrsvtnA5rGz9T6rx/t9V9k81m+5CpQ8Xe3xeZOcR/uBbqYAvigum5TU
 nMyy1CJ9uwSujN9zPzAVnBSoeLopoYHxIW8XIyeHhICJxJPJH5m6GLk4hARWMEq0P/zPAuF8
 YZSY//YqVOYzo8TEI5/ZYVp+73rFDpFYDpT4f5EZrury6p2sEM4uRomHa14xgrTwCthJXJyy
 B8xmEVCV6LvznQkiLihxcuYTFhBbVCBCYmXrGzBbWMBDovXUHbB1zALiEreezAerFxHQlNh4
 cDXYNmaBN8wSGw6uBGrg4GAT0JJo7ASr5xQwlTg4dzEjRK+mROv231Bz5CW2v53DDFIuIaAk
 se2XCcQ3tRJrj50B+0ZCoI9L4veLY0wQCReJmVNmQ9nCEq+Ob4F6X0bi9OQeFgi7WuLpjd/M
 EM0tjBL9O9ezQSywlug7kwNR4yjx/eVdqDCfxI23ghDn8ElM2jadeQKj6iykkJiF5ONZSD6Y
 heSDBYwsqxjFU0uLc9NTi43zUsv1ihNzi0vz0vWS83M3MQLT6Ol/x7/uYFzx6qPeIUYmDsZD
 jBIczEoivClhPUlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZMzNyQKCaQnlqRmp6YWpBbBZJk4
 OKUamJQ9j3U5K5/hK34lqH1q5Y5S2zUpjEW/Vjp48m+9f5z//6/Vr+5q8uracR/RdzLsCNh7
 KDptWvWh3hbGjE8Sd48brd5yNLXKQ/122o25SbOfH4kKWRig3WGZ8N7qQ3Xu76PTggWtzq1v
 L8t9kRbnYekh+c6MrdT/7xSRCwtuOmTY7Erv2/jg64RJO61k9zornWlSLrdPvqUg8/zipMRJ
 qlZ/2pL+1SXo705/5CJ4TTBoVVfGzfjNRdz30nfVqv+8/fvK24Qrv9osFy+bIfppVu6XJBN7
 6ebrgS72fS/qL86c/2pH+jVroVMZ7/SvG8uIrLisrRuwY6/G9sycto+pASydUnL7U8/GXP0Z
 xLnRTomlOCPRUIu5qDgRAJlvqloSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t/xe7pTf/UkGbQ2ClmsvtvPZvH77Hlm
 i73vZrNaXPjRyGSxZ9EkJouVq48yWTxZP4vZoufABxaLv133mCzOdl9jtNh7S9vi8q45bBbz
 lz1lt3jV/IjN4smU/WwWNyY8ZbRoX/mUzaJt41dGByGPfyfWsHks3vOSyePy2VKPTas62Ty6
 Z/9j8di8pN7jxeaZjB67bzaweexsvc/q8X7fVTaP9VuuAiVPV3t83iTn0X6gmymAL0rPpii/
 tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEv4/fcD0wFJwUq
 nm5KaGB8yNvFyMkhIWAi8XvXK3YQW0hgKaPEzDVaEHEZiU9XPrJD2MISf651sXUxcgHVfGSU
 2DFhIjOEs4tRYsb5eWBVvAJ2Ehen7GEEsVkEVCX67nxngogLSpyc+YQFxBYViJD4tGwCK4gt
 LOAh0XrqDlgvs4C4xK0n88HqRQQ0JTYeXA22gFngDbPEhoMrWSC2TWWS6Dl9AugODg42AS2J
 xk6wZk4BU4mDcxczQgzSlGjd/htqqLzE9rdzmEHKJQSUJLb9MoH4plbi1f3djBMYRWchOW8W
 kjNmIZk0C8mkBYwsqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQJTz7ZjP7fsYFz56qPeIUYm
 DsZDjBIczEoivClhPUlCvCmJlVWpRfnxRaU5qcWHGE2BYTSRWUo0OR+Y/PJK4g3NDEwNTcws
 DUwtzYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpg2h4TKFpwxLb/654zLw43v9e+LOSRK
 iy9Yf8HWI++QdipvTtCrwhU2/z/xntjZV6rJVvZQUyosUvXD4Sr33y8b43yE/k8zM+1ddubD
 Ec5wu5DH7xeZWshEzlO4Jnv81rqIZXl/T7rX8Pxqyno3aV3jwb5/xp90VX54nVhbOpXRwYzZ
 5d6WosNvZwbbbn/VtaOS65rTY8eyD69TOfdy9a8R3yC/d8Jyjft9eQJvWo2iko7w3nLv5Vh8
 dNpNtnUSUyrEzs3JuvagS2mte/1HNReVxk+XdSxWhkv5XakV0v0nkX9g07XynYfnxPQ+mCCa
 tO9Fc6bsjqkdMelLK08ELlY3+exy6n6gyb/l7Odvq81XYinOSDTUYi4qTgQA4f3IIsYDAAA=
X-CMS-MailID: 20220524153237eucas1p112db24d3a714f392b11ca536f8ad02fc
X-Msg-Generator: CA
X-RootMTR: 20220524024108eucas1p26a6384cd77f143bb0fa628f01866e0a0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220524024108eucas1p26a6384cd77f143bb0fa628f01866e0a0
References: <20220523161601.58078-6-p.raghav@samsung.com>
 <CGME20220524024108eucas1p26a6384cd77f143bb0fa628f01866e0a0@eucas1p2.samsung.com>
 <202205241034.izkLMTcH-lkp@intel.com>
 <7656fdc2-0511-722e-de6a-c2a2460cb048@samsung.com>
 <Yoz4PsQjWzVxz+YO@dev-arch.thelio-3990X>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v5 5/7] null_blk: allow non power of 2 zoned
 devices
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
Cc: axboe@kernel.dk, kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 snitzer@redhat.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, llvm@lists.linux.dev,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 gost.dev@samsung.com, dsterba@suse.com, jaegeuk@kernel.org, hch@lst.de,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/24/22 17:22, Nathan Chancellor wrote:
>>>         git remote add linux-review https://protect2.fireeye.com/v1/url?k=081be8db-5780d026-081a6394-000babff317b-d12fdca0fccd0493&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fintel-lab-lkp%2Flinux
>>>         git fetch --no-tags linux-review Pankaj-Raghav/block-make-blkdev_nr_zones-and-blk_queue_zone_no-generic-for-npo2-zsze/20220524-011616
>>>         git checkout 3d3c81da0adbd40eb0d2125327b7e227582b2a37
>>>         # save the config file
>>>         mkdir build_dir && cp config build_dir/.config
>>>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash
>>>
>>> If you fix the issue, kindly add following tag where applicable
>>> Reported-by: kernel test robot <lkp@intel.com>
>>>
>>> All errors (new ones prefixed by >>, old ones prefixed by <<):
>>>
>>>>> ERROR: modpost: "__hexagon_umoddi3" [drivers/block/null_blk/null_blk.ko] undefined!
>>
>> I am able to apply my patches cleanly against next-20220523, build it
>> without any errors with GCC and boot into it in my x86_64 machine. Not
>> sure why this error is popping up.
> 
> Do a 32-bit build and you'll see it. With GCC 12.1.0, ARCH=i386
> defconfig + CONFIG_BLK_DEV_NULL_BLK=y + CONFIG_BLK_DEV_ZONED=y
> reproduces it for me:
> 
> $ make -skj"$(nproc)" ARCH=i386 defconfig menuconfig all
> ld: drivers/block/null_blk/zoned.o: in function `null_init_zoned_dev':
> zoned.c:(.text+0x112e): undefined reference to `__umoddi3'
> ...
> 
Ah.. I didn't see anything about 32 bit ARCH in the email so it didn't
strike to me that was the problem. It said ARCH=hexagon and I had no
idea what it was. Thanks for reproducing it.
> roundup() does a plain division with a 64-bit dividend, which will cause
> issues with 32-bit architectures. I suspect that you should really be
> using DIV_ROUND_UP_SECTOR_T() for the nr_zones calculation or maybe one
> of the other rounding macros in include/linux/math.h but I am not sure.
> 
That must be it. I will fix it. Thanks Nathan.
> Cheers,
> Nathan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

