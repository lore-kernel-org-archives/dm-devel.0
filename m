Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD1EC19F2B
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658978909;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pgv8D6Y57+v0wyUNrF95d9Qtbd9Hb9ZD7LJ166B/vYk=;
	b=a+/ziwLGnwnUNDWUrl1cC16GnSQBCV2E6ylmSQuWDhxq5mbvNimNFTAeVFPUCB0g19q5TH
	lelF5Tp9R7JypnrJ0ervqA5hS494d6jpPONyjAeXOSuaqhYgCPLlKsyDBcGAdLZFJeHxGw
	vPuIhseTQOUTOGBSlnw6awrNQaocDqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-NBTYDw1XP4CVqlX0yPtTwA-1; Wed, 27 Jul 2022 23:28:26 -0400
X-MC-Unique: NBTYDw1XP4CVqlX0yPtTwA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A54E48032F0;
	Thu, 28 Jul 2022 03:28:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 942CD403D0E0;
	Thu, 28 Jul 2022 03:28:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3732D1945DAF;
	Thu, 28 Jul 2022 03:28:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E2AE1945DAB
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:28:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F37F22026D07; Thu, 28 Jul 2022 03:28:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF3572026D64
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:28:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D44413801F5C
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:28:22 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-0Brb2iTDPMeefjT7ryhofQ-1; Wed, 27 Jul 2022 23:28:18 -0400
X-MC-Unique: 0Brb2iTDPMeefjT7ryhofQ-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="212068004"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:28:16 +0800
IronPort-SDR: bIPyJ8TEm6GYYOdHO5ZUwX8yLqd3JTmvM4KRaHf6BXbFAl1p3QxeUsYD+ouxnjVmR8n63oTOaF
 MWRCsqH45JMHKZbQpZ+71CKSTB8PgX1U4KTDpM919OWU8HEIbVkABEK4nsvcBGfXLqY+bEt+H9
 c4KLC5FQxRQGNnbSWwlc8CHvbSl9enMMOZH9At0I0f3UL3mzIij2AkM4YOQi3PQkOROYJJIwFE
 hFqvth/ziJrQaN932X4jvO7+xtwF5iziz4DjGLibHJ9X+MkD54sn2XUkry6bRayaf0IjzC4isa
 N5KHph257RCJ2QVQRrxsj7k9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:49:28 -0700
IronPort-SDR: 9ai9jQhWV5KVKTNwPuRvpOTZrCnJeHNq56v32+D4yu7l7yhA9rMmV+x4e3AWWHQFBpwUFk8QkV
 ngJTqoiXSRLitgP+DM13UpV3jOBoFBPR0bS6jHL05S5nJelQoTzXI0Oaq1a28vJT2EBoIX4k0N
 857opr89M/FSGLVMLJP4oPnG6uXgYlY8Xl0Dnjs7huIMJaemUy5Gbw/QsBqWYK8SUKLhGUmT2v
 u4UGFENQkDzFrIdAIHAKCNud7RZr/8zZ9ajX7cxHYFmavUPqG8ZoBKdsGhIq5TMmXmNMMuvXqj
 Fhw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:28:17 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtbhJ5Fjyz1Rwnx
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:28:16 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Q6iUC4zVJ1LB for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:28:15 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtbhF2DLPz1RtVk;
 Wed, 27 Jul 2022 20:28:13 -0700 (PDT)
Message-ID: <14108b56-10c9-8760-39b1-ffa56220e5a3@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:28:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Bart Van Assche <bvanassche@acm.org>, Pankaj Raghav
 <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk, snitzer@kernel.org,
 Johannes.Thumshirn@wdc.com
References: <CGME20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754@eucas1p1.samsung.com>
 <20220727162245.209794-1-p.raghav@samsung.com>
 <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
 <f2f29f97-5994-37f9-c922-31158c1c1b9a@opensource.wdc.com>
 <024d16ac-d685-0fcf-1ad3-e99946852b03@acm.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <024d16ac-d685-0fcf-1ad3-e99946852b03@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 11:58, Bart Van Assche wrote:
> On 7/27/22 18:52, Damien Le Moal wrote:
>> On 7/28/22 08:19, Bart Van Assche wrote:
>>> On 7/27/22 09:22, Pankaj Raghav wrote:
>>>> This series adds support to npo2 zoned devices in the block and nvme
>>>> layer and a new **dm target** is added: dm-po2z-target. This new
>>>> target will be initially used for filesystems such as btrfs and
>>>> f2fs that does not have native npo2 zone support.
>>>
>>> Should any SCSI changes be included in this patch series? From sd_zbc.c:
>>>
>>> 	if (!is_power_of_2(zone_blocks)) {
>>> 		sd_printk(KERN_ERR, sdkp,
>>> 			  "Zone size %llu is not a power of two.\n",
>>> 			  zone_blocks);
>>> 		return -EINVAL;
>>> 	}
>>
>> There are no non-power of 2 SMR drives on the market and no plans to have
>> any as far as I know. Users want power of 2 zone size. So I think it is
>> better to leave sd_zbc & scsi_debug as is for now.
> 
> Zoned UFS devices will support ZBC and may have a zone size that is not 
> a power of two.

OK. So the check needs to be removed then and the entire zone append
emulation checked carefully. The divisions for zone no etc on non power of
2 zone size devices in zone append emulation hot path are really not
welcome though.


> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

