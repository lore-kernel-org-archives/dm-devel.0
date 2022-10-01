Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B292C433F5
	for <dm-devel@archiver.kernel.org>; Sat,  1 Oct 2022 00:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664585192;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+V8gWNfryyLP/pxC0KOXvwrfNNzKv7jMMuR2qmMazbQ=;
	b=H1wy0w/jkJPDAeRv+vOOzH24knzbnHdIJB3wQDs2MrYQe+Uc1tkHwurv59adw07i5NnT/g
	7OPUcA04I3N9riQxjwOSXvwDSIskvBkI5M30N5DExq4E2QOoANupRpV9zonwh8o0YcN35o
	hm8exkMEVLvFhMgmN7mjlPIl48/IZ6w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-4qWKrTLAPQC0wRHbF8Qmrw-1; Fri, 30 Sep 2022 20:46:29 -0400
X-MC-Unique: 4qWKrTLAPQC0wRHbF8Qmrw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 812901019C8A;
	Sat,  1 Oct 2022 00:46:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CB6E492B04;
	Sat,  1 Oct 2022 00:46:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 24BFB1946A67;
	Sat,  1 Oct 2022 00:46:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55FF51946A52
 for <dm-devel@listman.corp.redhat.com>; Sat,  1 Oct 2022 00:46:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF4CE1121315; Sat,  1 Oct 2022 00:46:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D72171121314
 for <dm-devel@redhat.com>; Sat,  1 Oct 2022 00:46:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A75D63C0E218
 for <dm-devel@redhat.com>; Sat,  1 Oct 2022 00:46:21 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-RvGcG9R-MwKnW0LKyCZjpw-1; Fri, 30 Sep 2022 20:46:20 -0400
X-MC-Unique: RvGcG9R-MwKnW0LKyCZjpw-1
X-IronPort-AV: E=Sophos;i="5.93,359,1654531200"; d="scan'208";a="213116203"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 01 Oct 2022 08:45:16 +0800
IronPort-SDR: +53yIs23oPrmGa8d1SkjyyngPVUAzEz9f+EAXLAJaH0Muk8y+iaadjhveclRFGUfqGGyMWbUfX
 IVug9i85BkBsv+4WRGmOTrzgeD+gU4iEQ3MLbfjwLc6N+k1ohlABQO6sS4qoQPdCTO5KG7HIjy
 81zSAQZzS3ieu9IfmhOsItGLXKyl+imsujwEWjS17IqGJjGiEO87m1a6we2OAAXA1+SzPhc2C8
 xegk0tCn7Ykm4YqKPqbP3k/IH8p6gCm6bafcp7AnqMmX2DcBi/hvT/QuVgrgOFdoauHM+ZmFD1
 4yxKgj1rgswzMeCDuy9D0aUi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 30 Sep 2022 17:05:09 -0700
IronPort-SDR: 6i1hcMaq7+vVhlArj9WQANisuNBgUbK8PBorwSTUvt3uU0zluXRnuCJ/H2Yp+rrGHNBUJ6UMLM
 bpLs099jYCnagfA0Om8JPnNTt3aHMk3wO49mfzV7Y4qgcEN2zmg39+4U0racxLTDYbAWusut9M
 nkVkLkyE6zaSUCTrgTlFXh8+z9IXtNCHBfiNlnJqrU5C4pD1Qqzqi1IansH6MLpVELI0LdfFB8
 9kjDCsWxlldYM9syzzrxa8lIZIxDdtC0jJ8OL6NqZsgLIzxwM9JWb20xRuOdSyYMI9WcDm2Lgh
 wMI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 30 Sep 2022 17:45:17 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MfT0D1TJdz1Rwtm
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 17:45:16 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 6cGRyApR30J2 for <dm-devel@redhat.com>;
 Fri, 30 Sep 2022 17:45:14 -0700 (PDT)
Received: from [10.225.163.96] (unknown [10.225.163.96])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MfT076V2Xz1RvLy;
 Fri, 30 Sep 2022 17:45:11 -0700 (PDT)
Message-ID: <bb2b3784-422f-fc82-e5be-e4d24412e21f@opensource.wdc.com>
Date: Sat, 1 Oct 2022 09:45:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
 Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de,
 Keith Busch <kbusch@kernel.org>
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
 <20220923173618.6899-1-p.raghav@samsung.com>
 <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
 <bd9479f4-ff87-6e5d-296e-e31e669fb148@kernel.dk>
 <0e5088a5-5408-c5bd-bf97-00803cb5faed@acm.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <0e5088a5-5408-c5bd-bf97-00803cb5faed@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v15 00/13] support zoned block devices with
 non-power-of-2 zone sizes
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, pankydev8@gmail.com,
 matias.bjorling@wdc.com, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/1/22 04:38, Bart Van Assche wrote:
> On 9/30/22 08:13, Jens Axboe wrote:
>> On 9/29/22 12:31 AM, Pankaj Raghav wrote:
>>>> Hi Jens,
>>>>    Please consider this patch series for the 6.1 release.
>>>>
>>>
>>> Hi Jens, Christoph, and Keith,
>>>   All the patches have a Reviewed-by tag at this point. Can we queue this up
>>> for 6.1?
>>
>> It's getting pretty late for 6.1 and I'd really like to have both Christoph
>> and Martin sign off on these changes.
> 
> Hi Jens,
> 
> Agreed that it's getting late for 6.1.
> 
> Since this has not been mentioned in the cover letter, I want to add 
> that in the near future we will need these patches for Android devices. 
> JEDEC is working on supporting zoned storage for UFS devices, the 
> storage devices used in all modern Android phones. Although it would be 
> possible to make the offset between zone starts a power of two by 
> inserting gap zones between data zones, UFS vendors asked not to do this 
> and hence need support for zone sizes that are not a power of two. An 
> advantage of not having to deal with gap zones is better filesystem 
> performance since filesystem extents cannot span gap zones. Having to 
> split filesystem extents because of gap zones reduces filesystem 
> performance.

As mentioned many times, my opinion is that a good implementation should
*not* have any extent span zone boundaries. So personally, I do not
consider such argument as a valid justification for the non-power-of-2
zone size support.

> 
> Thanks,
> 
> Bart.
> 
> 

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

