Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C60FFC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 01:29:46 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-t1BsGAmaP1iHfp9HWEdkjQ-1; Tue, 22 Feb 2022 20:29:40 -0500
X-MC-Unique: t1BsGAmaP1iHfp9HWEdkjQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D7BE51AE;
	Wed, 23 Feb 2022 01:29:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBE9C60FFD;
	Wed, 23 Feb 2022 01:29:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B76164A701;
	Wed, 23 Feb 2022 01:29:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21N1TUek000438 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 20:29:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 492EC140240B; Wed, 23 Feb 2022 01:29:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A831402407
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 01:29:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B56185A5A8
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 01:29:30 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-42-eheAvoGpO4auoeucUlqU8g-1; Tue, 22 Feb 2022 20:29:28 -0500
X-MC-Unique: eheAvoGpO4auoeucUlqU8g-1
X-IronPort-AV: E=Sophos;i="5.88,389,1635177600"; d="scan'208";a="194690624"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2022 09:29:28 +0800
IronPort-SDR: 1xOElyHlrTiZBLYNd4YQ9cnPmAyQPvtWwlIjRsc5/MjyffDcz1yoa9aZVtVghLF+FYfhTvXCoE
	tyjFwF+Mv7mSohxf5ytsG+xMQxXcqvZVOhGzGZr0XCNGJfHU7sI43LEs/pCLeQk9scm5J8v+67
	F/YsA/yI0WhlOQ9tnkueN/hSxHG9U4tbmsIWYoJK7Ea802/njvqceQvmOQvcTxLgoKllDLSVSb
	EtmPqQvRoR8C5zNW5N1Gvsg7zHXvI2Eksasngg5uyI9FU3ckcSNd7Ng1pEXdOlzm+riL5aqnXD
	SVTpZYYeS0v6zDZ7pEkHnwsr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	22 Feb 2022 17:02:05 -0800
IronPort-SDR: eWekStu1Hlhb/zY2VMhpn2wm/p3piSzZxJE93uzwx9CG4jAPxs0QFFfzSruMrEKU1wdRRd4+Kt
	CORZf1sSwT1PwlnmyRGnngm5oE+WuHj4RpotyRCIQ7ceyuGYkj/Hhoo1HZQ7ZxZfEYhK5RQjnS
	hZGOhLgeqq+/HgUDTgVF+0MHVnxrbkur9999TXkLlBqefzuYEQNQLuLcv7NOLZH+A4aZ0bSw7N
	dc/3MowJSZ+FaKZPDMvSyxdiYEpOtFekZfBQLNm14WIXaDFbfTTcKcNJBjEVQouXvzT1zKzCZF
	UVY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	22 Feb 2022 17:29:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K3JNk5l9qz1SVp4
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 17:29:26 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id 6ogbgXyR-jOy for <dm-devel@redhat.com>;
	Tue, 22 Feb 2022 17:29:24 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K3JNb3h1Dz1Rvlx;
	Tue, 22 Feb 2022 17:29:19 -0800 (PST)
Message-ID: <98ddab1b-6702-f121-9fef-0ce185888a1a@opensource.wdc.com>
Date: Wed, 23 Feb 2022 10:29:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Luis Chamberlain <mcgrof@kernel.org>, Nitesh Shetty <nj.shetty@samsung.com>
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080605epcas5p16868dae515a6355cf9fecf22df4f3c3d@epcas5p1.samsung.com>
	<20220214080002.18381-3-nj.shetty@samsung.com>
	<20220217090700.b7n33vbkx5s4qbfq@garbanzo>
	<20220217125901.GA3781@test-zns>
	<YhWGDUyQkUcE6itt@bombadil.infradead.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YhWGDUyQkUcE6itt@bombadil.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
	hch@lst.de, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 02/10] block: Introduce queue limits for
 copy-offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/23/22 09:55, Luis Chamberlain wrote:
> On Thu, Feb 17, 2022 at 06:29:01PM +0530, Nitesh Shetty wrote:
>>  Thu, Feb 17, 2022 at 01:07:00AM -0800, Luis Chamberlain wrote:
>>> The subject says limits for copy-offload...
>>>
>>> On Mon, Feb 14, 2022 at 01:29:52PM +0530, Nitesh Shetty wrote:
>>>> Add device limits as sysfs entries,
>>>>         - copy_offload (RW)
>>>>         - copy_max_bytes (RW)
>>>>         - copy_max_hw_bytes (RO)
>>>>         - copy_max_range_bytes (RW)
>>>>         - copy_max_range_hw_bytes (RO)
>>>>         - copy_max_nr_ranges (RW)
>>>>         - copy_max_nr_ranges_hw (RO)
>>>
>>> Some of these seem like generic... and also I see a few more max_hw ones
>>> not listed above...
>>>
>> queue_limits and sysfs entries are differently named.
>> All sysfs entries start with copy_* prefix. Also it makes easy to lookup
>> all copy sysfs.
>> For queue limits naming, I tried to following existing queue limit
>> convention (like discard).
> 
> My point was that your subject seems to indicate the changes are just
> for copy-offload, but you seem to be adding generic queue limits as
> well. Is that correct? If so then perhaps the subject should be changed
> or the patch split up.
> 
>>>> +static ssize_t queue_copy_offload_store(struct request_queue *q,
>>>> +				       const char *page, size_t count)
>>>> +{
>>>> +	unsigned long copy_offload;
>>>> +	ssize_t ret = queue_var_store(&copy_offload, page, count);
>>>> +
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (copy_offload && !q->limits.max_hw_copy_sectors)
>>>> +		return -EINVAL;
>>>
>>>
>>> If the kernel schedules, copy_offload may still be true and
>>> max_hw_copy_sectors may be set to 0. Is that an issue?
>>>
>>
>> This check ensures that, we dont enable offload if device doesnt support
>> offload. I feel it shouldn't be an issue.
> 
> My point was this:
> 
> CPU1                                       CPU2
> Time
> 1) if (copy_offload 
> 2)    ---> preemption so it schedules      
> 3)    ---> some other high priority task  Sets q->limits.max_hw_copy_sectors to 0
> 4) && !q->limits.max_hw_copy_sectors)
> 
> Can something bad happen if we allow for this?

max_hw_copy_sectors describes the device capability to offload copy. So
this is read-only and "max_hw_copy_sectors != 0" means that the device
supports copy offload (this attribute should really be named
max_hw_copy_offload_sectors).

The actual loop to issue copy offload BIOs, however, must use the soft
version of the attribute: max_copy_sectors, which defaults to
max_hw_copy_sectors if copy offload is truned on and I guess to
max_sectors for the emulation case.

Now, with this in mind, I do not see how allowing max_copy_sectors to be
0 makes sense. I fail to see why that should be allowed since:
1) If copy_offload is true, we will rely on the device and chunk copy
offload BIOs up to max_copy_sectors
2) If copy_offload is false (or device does not support it), emulation
will be used by issuing read/write BIOs of up to max_copy_sectors.

Thus max_copy_sectors must always be at least equal to the device
minimum IO size, that is, the logical block size.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

