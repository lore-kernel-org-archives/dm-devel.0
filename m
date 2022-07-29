Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4915C00144
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 07:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659081129;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VYD+LHjz9FbALX/khOVbWZ4/AluhcbAOOsGeTkcf8Vw=;
	b=VPaIcdlTi9L85xkak8nep2lrRoutoZlnyzJPnWOgrqbY3I09px0dH3XBGltDvJaAJLYzbU
	bVfVXtLRGbezXHeqsTalyEscKjEaAz9MqmzfSt3rlpL0cj+2EoZdcyNoZN4VCu/N46AD+6
	nL/9ca5GM4gz7VPzX43xAM3IuRS+NjA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-tYLVKHDsOJKxnjPGYD5VvA-1; Fri, 29 Jul 2022 03:52:06 -0400
X-MC-Unique: tYLVKHDsOJKxnjPGYD5VvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C54141019DE1;
	Fri, 29 Jul 2022 07:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F2A02026D07;
	Fri, 29 Jul 2022 07:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 370D2193211F;
	Fri, 29 Jul 2022 07:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C81A4193211B
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 07:52:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AEE701415122; Fri, 29 Jul 2022 07:52:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AADD3141511F
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 07:52:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 602E429AB408
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 07:52:03 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-EdD5kVm5MkyLFs9Lm1rS_w-1; Fri, 29 Jul 2022 03:52:00 -0400
X-MC-Unique: EdD5kVm5MkyLFs9Lm1rS_w-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220729075158euoutp017bbee26c437021ae19de144c82a50d66~GPXzND-y02491724917euoutp01O
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 07:51:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220729075158euoutp017bbee26c437021ae19de144c82a50d66~GPXzND-y02491724917euoutp01O
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220729075158eucas1p2e4e5b78421be68c72746bebc8992e543~GPXyvt5sx0916509165eucas1p2w;
 Fri, 29 Jul 2022 07:51:58 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 7B.D1.09580.E9193E26; Fri, 29
 Jul 2022 08:51:58 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220729075158eucas1p29f800c791e3504b687064ad650d20055~GPXyWDazN0066900669eucas1p2I;
 Fri, 29 Jul 2022 07:51:58 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220729075158eusmtrp206b4834711a30972e7eadfa2036c7815~GPXyU9g9j0852508525eusmtrp2Z;
 Fri, 29 Jul 2022 07:51:58 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-39-62e3919e652f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id CE.22.09095.D9193E26; Fri, 29
 Jul 2022 08:51:57 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220729075157eusmtip1cbac1cd4c0f0b835564fcd7eae868363~GPXyLHmvy1491314913eusmtip1L;
 Fri, 29 Jul 2022 07:51:57 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.8) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 29 Jul 2022 08:51:55 +0100
Message-ID: <a2b40d05-5f1d-0e56-b530-ce6d61be7b8a@samsung.com>
Date: Fri, 29 Jul 2022 09:51:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <bbcfe218-5bae-266c-5712-3489b2eeaaba@nvidia.com>
X-Originating-IP: [106.210.248.8]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7djPc7rzJj5OMvhxTsxi9d1+NotpH34y
 W7w/+JjV4vfZ88wWe9/NZrXYs2gSk8XK1UeZLJ6sn8Vs8bfrHpPF3lvaFpd3zWGzmL/sKbvF
 hLavzBY3JjxltFhz8ymLxYlb0g4CHpeveHvsnHWX3ePy2VKPTas62Tw2L6n32H2zgc2jt/kd
 m8fO1vusHu/3XQWKn672+LxJzqP9QDdTAE8Ul01Kak5mWWqRvl0CV8aJY9PZC1okKt4sW8Xa
 wPhcsIuRk0NCwERi5bkW1i5GLg4hgRWMEkuOfWcCSQgJfGGU2LozASLxmVGiYV0jM0zHj94t
 jBCJ5YwS69dOYYPoAKpa3aACkdjJKLHn4AewBK+AncTf6yAdHBwsAqoSU15qQYQFJU7OfMIC
 YosKREqs2X2WHcQWFvCSWHzoHVgrs4C4xK0n88EuEhHQk7h66wY7yHxmgflsEqeeP2cDmckm
 oCXR2AnWywm06u2cKawQvZoSrdt/s0PY8hLb386BekBRov/7BjYIu1Zi7bEzYDMlBF5xSmzb
 +ogRIuEisfPkEXYIW1ji1fEtULaMxP+dEAdJCFRLPL3xmxmiuYVRon/nerCDJASsJfrO5EDU
 OEpceXWcCSLMJ3HjrSDEPXwSk7ZNZ57AqDoLKShmIXl5FpIXZiF5YQEjyypG8dTS4tz01GLj
 vNRyveLE3OLSvHS95PzcTYzAxHj63/GvOxhXvPqod4iRiYPxEKMEB7OSCK9AwOMkId6UxMqq
 1KL8+KLSnNTiQ4zSHCxK4rzJmRsShQTSE0tSs1NTC1KLYLJMHJxSDUzlZr2FsxNetHDHns//
 WN4xJcZsor9PQoSa67pZqh0djwX9v22q+WnO9O3zyd/dmjck0n8tsubJsD5i9nLOVT6TXT8s
 l2T/XKaqv2tj/l57Dt1qzTWuW8xiKi4mRNYxcFu93vNz6vya3rdnF5h8XV08eY2FrumueZ1x
 VjE1mVPfHa3a0zx/ZmNmy9rW0/XHfT482q5YcVph7gkpvwmXzjtffhok8Wy29m4VvnOyh8R+
 niuXapn881S71lr5KXKdV4VfcjvM9Pp9xuHJ+8cFiy1tJJacd5x+5p/zlii5Mv0N4TpsLYUc
 79Tc0rQCnKc7SlzcnmRm9yU0UEnz6/r/1T3MWhKrj61VTI9aXh6jI6vEUpyRaKjFXFScCABZ
 KwqV+wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t/xu7pzJz5OMjjYb2Wx+m4/m8W0Dz+Z
 Ld4ffMxq8fvseWaLve9ms1rsWTSJyWLl6qNMFk/Wz2K2+Nt1j8li7y1ti8u75rBZzF/2lN1i
 QttXZosbE54yWqy5+ZTF4sQtaQcBj8tXvD12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObR2/yO
 zWNn631Wj/f7rgLFT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP
 0Ng81srIVEnfziYlNSezLLVI3y5BL+PEsensBS0SFW+WrWJtYHwu2MXIySEhYCLxo3cLYxcj
 F4eQwFJGieUTVjJDJGQkPl35yA5hC0v8udbFBlH0kVGiY/p3JghnJ6PEszNrwap4Bewk/l4H
 GcXBwSKgKjHlpRZEWFDi5MwnLCC2qECkxMNlTUwgtrCAl8TiQ+/YQGxmAXGJW0/mg8VFBPQk
 rt66wQ4yn1lgPpvE7InfmCGWfWaUeHx2EwvIAjYBLYnGTrC9nEB7386ZwgoxSFOidftvdghb
 XmL72zlQ3yhK9H/fwAZh10q8ur+bcQKj6Cwk981CcscsJKNmIRm1gJFlFaNIamlxbnpusaFe
 cWJucWleul5yfu4mRmBK2Xbs5+YdjPNefdQ7xMjEwXiIUYKDWUmEVyDgcZIQb0piZVVqUX58
 UWlOavEhRlNgGE1klhJNzgcmtbySeEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0xJLU7NTUgtQi
 mD4mDk6pBial9F+LOvjePbdsmdf+187ohMjHrVMFpyhPz1kkYzzlzppJ3ln7uHW7C1n2HUu3
 n/jnR3WH7WqXPec9etLPq0ff92f6e/hk3Yfnahp32jXm7Ppy5qVlebTeo2mTuQRrxPL7L/Eb
 b7LLc2RUOhSy9t45oUUsGTIXRJ0yjyctKOFXmZ849e+B6EixA4p+PdtCQmcoKxQoaEydu9pw
 +ndWO/3y1QK7Yp49uZtX+tRNMKbLZb5w3y3hJVappn3Shjq6VXmrMx6rdDu+fKHwtEilyD8u
 dtly0Q1nTafFh+e2F9aVpAQZ7W/68UrrSrfL88ULfZ5s7l/97dTSoOrkDfUucVumr1J7FD7v
 2S/ZEL4iKyWW4oxEQy3mouJEAMBw9K2yAwAA
X-CMS-MailID: 20220729075158eucas1p29f800c791e3504b687064ad650d20055
X-Msg-Generator: CA
X-RootMTR: 20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f@eucas1p1.samsung.com>
 <20220727162245.209794-6-p.raghav@samsung.com>
 <bbcfe218-5bae-266c-5712-3489b2eeaaba@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 05/11] null_blk: allow non power of 2
 zoned devices
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "Johannes.Thumshirn@wdc.com" <Johannes.Thumshirn@wdc.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>, Luis
 Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-07-27 23:59, Chaitanya Kulkarni wrote:
>> Sequential Write:
>>
>> x-----------------x---------------------------------x---------------------------------x
>> |     IOdepth     |            8                    |            16                   |
>> x-----------------x---------------------------------x---------------------------------x
>> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
>> x-----------------x---------------------------------x---------------------------------x
>> | Without patch   |  578     |  2257    |   12.80   |  576     |  2248    |   25.78   |
>> x-----------------x---------------------------------x---------------------------------x
>> |  With patch     |  581     |  2268    |   12.74   |  576     |  2248    |   25.85   |
>> x-----------------x---------------------------------x---------------------------------x
>>
>> Sequential read:
>>
>> x-----------------x---------------------------------x---------------------------------x
>> | IOdepth         |            8                    |            16                   |
>> x-----------------x---------------------------------x---------------------------------x
>> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
>> x-----------------x---------------------------------x---------------------------------x
>> | Without patch   |  667     |  2605    |   11.79   |  675     |  2637    |   23.49   |
>> x-----------------x---------------------------------x---------------------------------x
>> |  With patch     |  667     |  2605    |   11.79   |  675     |  2638    |   23.48   |
>> x-----------------x---------------------------------x---------------------------------x
>>
>> Random read:
>>
>> x-----------------x---------------------------------x---------------------------------x
>> | IOdepth         |            8                    |            16                   |
>> x-----------------x---------------------------------x---------------------------------x
>> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
>> x-----------------x---------------------------------x---------------------------------x
>> | Without patch   |  522     |  2038    |   15.05   |  514     |  2006    |   30.87   |
>> x-----------------x---------------------------------x---------------------------------x
>> |  With patch     |  522     |  2039    |   15.04   |  523     |  2042    |   30.33   |
>> x-----------------x---------------------------------x---------------------------------x
>>
>> Minor variations are noticed in Sequential write with io depth 8 and
>> in random read with io depth 16. But overall no noticeable differences
>> were noticed
> 
> minor variations in with aspect of the performance ?
> are these documented somewhere ?
> 
The table above documents those minor variations in performance.
> move the large table of performance numbers to the cover letter it looks 
> ugly in the git log...
> 
I could do that.
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

