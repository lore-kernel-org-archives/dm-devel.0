Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C23C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:35:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-bKbABggkNrG7tE-JJTqvww-1; Thu, 24 Mar 2022 11:34:57 -0400
X-MC-Unique: bKbABggkNrG7tE-JJTqvww-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB9B299E763;
	Thu, 24 Mar 2022 15:34:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2B8427855;
	Thu, 24 Mar 2022 15:34:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6EDB6193F50F;
	Thu, 24 Mar 2022 15:34:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7F7CB1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 15:17:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 36436C26EA9; Tue, 22 Mar 2022 15:17:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 319CCC27E80
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:17:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF0F928035E0
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:17:30 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-krKOQid2OGGocwpyJUVb4A-1; Tue, 22 Mar 2022 11:17:29 -0400
X-MC-Unique: krKOQid2OGGocwpyJUVb4A-1
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.200])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KNFRj3Vrfz67Ncp;
 Tue, 22 Mar 2022 23:15:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 22 Mar 2022 16:17:26 +0100
Received: from [10.47.85.68] (10.47.85.68) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 22 Mar
 2022 15:17:25 +0000
Message-ID: <0f7b9765-8835-25b5-4cdb-bc78edddad37@huawei.com>
Date: Tue, 22 Mar 2022 15:17:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
 <20220322111848.GA29270@lst.de>
 <cacc3f7b-c8be-0f72-1c52-562c15b468a4@huawei.com>
 <b5df2ef1-2d6d-340e-e4b4-09132dc0516b@suse.de>
 <a5e42012-c1fc-082e-e636-594abc07dd70@huawei.com>
 <306df4cf-0ee0-2b1e-044c-aed6c70122f9@suse.de>
From: John Garry <john.garry@huawei.com>
In-Reply-To: <306df4cf-0ee0-2b1e-044c-aed6c70122f9@suse.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Cc: axboe@kernel.dk, bvanassche@acm.org, martin.petersen@oracle.com,
 chenxiang66@hisilicon.com, damien.lemoal@opensource.wdc.com,
 linux-kernel@vger.kernel.org, ming.lei@redhat.com, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org,
 jejb@linux.ibm.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 22/03/2022 14:03, Hannes Reinecke wrote:
>>
>> As mentioned in the cover letter response, it just seems best to keep 
>> the normal scsi_cmnd payload but have other means to add on the 
>> internal command data, like using host_scribble or scsi_cmnd priv data.
>>
> Well; I found that most drivers I had been looking at the scsi command 
> payload isn't used at all; the drivers primarily cared about the 
> (driver-provided) payload, and were completely ignoring the scsi command 
> payload.
> 
> Similar for ATA/libsas: you basically never issue real scsi commands, 
> but either 'raw' ATA requests or SCSI TMFs. None of which are scsi 
> commands, so providing them is a bit of a waste.
> 
> (And causes irritations, too, as a scsi command requires associated 
> pointers like ->device etc to be set up. Which makes it tricky to use 
> for the initial device setup.)

A problem I see is that in scsi_mq_init_request() we allocate memories 
like sense_buffer and prot_sdb and store the pointers in the scsi_cmnd 
payload. If we then reuse a scsi_cmnd payload as an "internal" command 
payload then this data may be lost.

It might be possible to reuse the scsi cmnd payload for the "internal", 
but I would rather not get hung up on it now if possible.

Thanks,
John

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

