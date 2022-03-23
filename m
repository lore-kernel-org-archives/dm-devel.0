Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDD3C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:35:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-FPINO7yZOhCj-Amu4gb5fw-1; Thu, 24 Mar 2022 11:35:06 -0400
X-MC-Unique: FPINO7yZOhCj-Amu4gb5fw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57A9B10665A3;
	Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4436740F692;
	Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 611431940376;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F5E51940347
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 09:01:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D64A2024CB7; Wed, 23 Mar 2022 09:01:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 492A52024CB6
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 09:01:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E4CB29DD99F
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 09:01:44 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-PhMCWMAkPY-av4YHgL1gow-1; Wed, 23 Mar 2022 05:01:40 -0400
X-MC-Unique: PhMCWMAkPY-av4YHgL1gow-1
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.226])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KNj3b1ngBz67PtB;
 Wed, 23 Mar 2022 16:59:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 23 Mar 2022 10:01:37 +0100
Received: from [10.47.85.68] (10.47.85.68) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 23 Mar
 2022 09:01:36 +0000
Message-ID: <378065de-3cb8-b44f-66e9-747960bcd990@huawei.com>
Date: Wed, 23 Mar 2022 09:01:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Bart Van Assche <bvanassche@acm.org>, <axboe@kernel.dk>,
 <damien.lemoal@opensource.wdc.com>, <jejb@linux.ibm.com>,
 <martin.petersen@oracle.com>, <hch@lst.de>, <ming.lei@redhat.com>,
 <hare@suse.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
 <e74776f0-505b-8b4f-effd-519bce9bdc79@acm.org>
From: John Garry <john.garry@huawei.com>
In-Reply-To: <e74776f0-505b-8b4f-effd-519bce9bdc79@acm.org>
X-Originating-IP: [10.47.85.68]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:43 +0000
Subject: Re: [dm-devel] [PATCH 01/11] blk-mq: Add blk_mq_init_queue_ops()
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
Cc: linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 23/03/2022 02:57, Bart Van Assche wrote:
> On 3/22/22 03:39, John Garry wrote:
>> Add an API to allocate a request queue which accepts a custom set of
>> blk_mq_ops for that request queue.
>>
>> The reason which we may want custom ops is for queuing requests which we
>> don't want to go through the normal queuing path.
> 

Hi Bart,

 > Custom ops shouldn't be required for this. See e.g. how tmf_queue
 > is used in the UFS driver for an example of a queue implementation
 > with custom operations and that does not require changes of the block
 > layer core.

The UFS code uses a private tagset (in ufs_hba.tmf_tag_set) for only 
management of TMF tags/memories. This tagset does not really have any 
custom operations. All it has is a stub of .queue_rq CB in 
ufshcd_queue_tmf() and that is because this CB is compulsory.

As for the idea of having multiple tagsets per shost with real custom 
operations, this idea was mentioned before, but I think managing 
multiple tagsets could be trouble. For a start, it would mean that we 
need a distinct allocation of reserved and regular tags, and sometimes 
we don't want this - as Hannes mentioned earlier, many HBAs have low 
queue depth and cannot afford to permanently carve out a bunch of 
reserved tags.

Thanks,
John

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

