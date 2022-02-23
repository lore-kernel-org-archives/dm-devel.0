Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEA0C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 03:20:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-3ldbEWQAPR2HkTl9s3C4mg-1; Tue, 22 Feb 2022 22:20:09 -0500
X-MC-Unique: 3ldbEWQAPR2HkTl9s3C4mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 002FB1006AA8;
	Wed, 23 Feb 2022 03:20:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 950EA45CB8;
	Wed, 23 Feb 2022 03:20:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C8AEB4EE76;
	Wed, 23 Feb 2022 03:20:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21N3K0SG008264 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 22:20:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 17B2C112132C; Wed, 23 Feb 2022 03:20:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 133FF112131E
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 03:19:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 110F485A5BC
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 03:19:57 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-75-Girjh88cOzGGERI7FWuT1A-1; Tue, 22 Feb 2022 22:19:54 -0500
X-MC-Unique: Girjh88cOzGGERI7FWuT1A-1
X-IronPort-AV: E=Sophos;i="5.88,390,1635177600"; d="scan'208";a="305627943"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2022 11:19:53 +0800
IronPort-SDR: 0VKV30WhTV4Hue7zZAI8YzFisctb6Cium8ebpO2vE983KMXBZhvnUWMW//bdJB9RmxOJ/Pqbc8
	rp6x11tJHcWsxxfoX1Jo313Uhnw68GgHwjQ+hfzAm4ixqJZxXIpC7oPIZoCcAX6lWQYv/qc1Qm
	I9/GF+r2Hcudi2xpHsL2+l+Gco1R3Bg15jjihzsSb/5P8sPgDFcTfqXUCp+RRC6JhJYgGvbCxe
	zo6CyLR7nw+X+JCMABGSFiPYwwh0W0NxXdQbZMgFXF4SgzPr/hf2ZIAm39JtMDdk4zZ1SyiDZV
	4yGLpttjn0JhmO/ApoFCxWL9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	22 Feb 2022 18:52:30 -0800
IronPort-SDR: 1VLLiaI1ZXpyX4XSKkuhocTZwuVQI8f9LjJTmURqu5AWQXqjTkhijUPqOz8HV2EheuTT4Ps5Mh
	PP1LSE6wdFiOdqDI7f6fN2c7YMLhZQPEIID5TdnkfWbeMnNGEVn0JFuJ/9Q65hN385T+XZrONl
	zBE3jGEKdRQ2W/+zg6flQpBhLrov4VoLN4t2chnjSODXHz6pXI6Yz69p871LIrGAVlneUQ0onV
	xjNk1uRVPe6Dp6DBSN3Dq+K67wxG6fCO2ST5jpzwhMOGQjX3cxZxYj8xbR+b8d60SkMPgckhDm
	Vf8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	22 Feb 2022 19:19:53 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K3Lr862CWz1SHwl
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 19:19:52 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id hiqRkVSxZIZw for <dm-devel@redhat.com>;
	Tue, 22 Feb 2022 19:19:52 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K3Lr73CX1z1Rvlx;
	Tue, 22 Feb 2022 19:19:51 -0800 (PST)
Message-ID: <cf99d18e-d8e5-cd41-5541-9d1e1d81adc8@opensource.wdc.com>
Date: Wed, 23 Feb 2022 12:19:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Mike Snitzer <snitzer@redhat.com>
References: <c64d2143-284e-7621-440c-971e3405b4d8@virtuozzo.com>
	<d209a0b1-2514-79a0-257a-22bcb372785a@virtuozzo.com>
	<1d287c7e-8aff-beea-1bd6-4b2226f9f3db@opensource.wdc.com>
	<CAH6w=ayrR0yRCumgjtyB+mt_+33S6PHxBQDcwYVcuQ79ECYd7A@mail.gmail.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAH6w=ayrR0yRCumgjtyB+mt_+33S6PHxBQDcwYVcuQ79ECYd7A@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Kirill Tkhai <ktkhai@virtuozzo.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v2] dm: Fix use-after-free in
 dm_cleanup_zoned_dev()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/23/22 12:02, Mike Snitzer wrote:
> On Thu, Feb 17, 2022 at 5:49 AM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
>>
>> On 2/17/22 19:13, Kirill Tkhai wrote:
>>>
>>> dm_cleanup_zoned_dev() uses queue, so it must be called
>>> before blk_cleanup_disk() starts its killing:
>>>
>>> blk_cleanup_disk->blk_cleanup_queue()->kobject_put()->blk_release_queue()->
>>> ->...RCU...->blk_free_queue_rcu()->kmem_cache_free()
>>>
>>> Otherwise, RCU callback may be executed first,
>>> and dm_cleanup_zoned_dev() touches freed memory:
>>
>> Mike,
>>
>> Can you queue this please ?
> 
> I queued it earlier today, please see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=588b7f5df0cb64f281290c7672470c006abe7160
> 
> Thanks,
> Mike

Thanks !


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

