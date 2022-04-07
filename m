Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54912C4167D
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-gFO5o88sN5aAnEjGW-_hWg-1; Mon, 11 Apr 2022 02:19:28 -0400
X-MC-Unique: gFO5o88sN5aAnEjGW-_hWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B274D2A59543;
	Mon, 11 Apr 2022 06:19:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A055CC33B13;
	Mon, 11 Apr 2022 06:19:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9D0A1194037C;
	Mon, 11 Apr 2022 06:19:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63FE51947BBE
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 14:32:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 33297C2812B; Thu,  7 Apr 2022 14:32:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E714C27E86
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 14:32:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5597F80B710
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 14:32:16 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-lP9csl-DMRazj7rcaa6-Nw-1; Thu, 07 Apr 2022 10:32:12 -0400
X-MC-Unique: lP9csl-DMRazj7rcaa6-Nw-1
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KZ3gw30svz681Z4;
 Thu,  7 Apr 2022 22:30:20 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Apr 2022 16:32:10 +0200
Received: from [10.47.80.129] (10.47.80.129) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 7 Apr
 2022 15:32:09 +0100
Message-ID: <3e1914a8-5f6b-8fcf-7fb3-2d1edb9766e1@huawei.com>
Date: Thu, 7 Apr 2022 15:32:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From: John Garry <john.garry@huawei.com>
To: Christoph Hellwig <hch@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-4-git-send-email-john.garry@huawei.com>
 <20220322112057.GC29270@lst.de>
In-Reply-To: <20220322112057.GC29270@lst.de>
X-Originating-IP: [10.47.80.129]
X-ClientProxiedBy: lhreml728-chm.china.huawei.com (10.201.108.79) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:20 +0000
Subject: Re: [dm-devel] [PATCH 03/11] libata: Send internal commands through
 the block layer
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
Cc: axboe@kernel.dk, bvanassche@acm.org, martin.petersen@oracle.com,
 chenxiang66@hisilicon.com, damien.lemoal@opensource.wdc.com,
 linux-kernel@vger.kernel.org, ming.lei@redhat.com, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org,
 jejb@linux.ibm.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 22/03/2022 11:20, Christoph Hellwig wrote:
> On Tue, Mar 22, 2022 at 06:39:37PM +0800, John Garry wrote:
>> When SCSI HBA device drivers are required to process an ATA internal
>> command they still need a tag for the IO. This often requires the driver
>> to set aside a set of tags for these sorts of IOs and manage the tags
>> themselves.
>>
>> If we associate a SCSI command (and request) with an ATA internal command
>> then the tag is already provided, so introduce the change to send ATA
>> internal commands through the block layer with a set of custom blk-mq ops.
>>
>> note: I think that the timeout handling needs to be fixed up.

Hi Christoph,

> Any reason to not just send them through an ATA_16 passthrough CDB and
> just use all the normal SCSI command handling?

I had a go at implementing this but I have come up against a few issues:

- ATA_16 handling translates the passthrough CDB to a ATA TF. However 
ata_exec_internal_sg() is passed a TF already. So what to do? Change the 
callers to generate a ATA_16 CDB? I guess not. Otherwise we could put 
the already-generated TF in the SCSI cmd CDB somehow and use directly.

- We may have no SCSI device (yet) for the target when issuing an 
internal command, but only the ATA port+dev. So need a method to pass 
these pointers to ATA_16 handling

- we would need to change ata_scsi_translate(), ata_scsi_pass_thru() and 
other friends to deal with ATA_TAG_INTERNAL and its peculiarities - 
today it just deals with regular qc's.

It still does seem a reasonable idea to use ATA_16, but it looks like 
significant modifications would be required....

Thanks,
John

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

