Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858A9C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 13:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679317603;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gE/8D4G+DRmHMQPrYMEIh6nbqOp0t3gwTJyVIhZgxcM=;
	b=FPzoBWKMvquHY8RJTBSI5Vr1p/GRe5XXHjFmT4Y27IA6yOwxx/J64YY3iTrJgXMcEL4Pnl
	Zpni7mJgLntgiaPUxyAgrmQs0tiu2IlQZz72TaOEs6VFdQ4d3MkpQFPdep+MPsbzNPDctN
	h9o+uZeJUGBIsbFgDTl7BvZlNSM75lM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-GOCY5umzP0a5rWjetXq17w-1; Mon, 20 Mar 2023 09:06:39 -0400
X-MC-Unique: GOCY5umzP0a5rWjetXq17w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F9C8101A531;
	Mon, 20 Mar 2023 13:06:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 23FCA492C14;
	Mon, 20 Mar 2023 13:06:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E71C019465A2;
	Mon, 20 Mar 2023 13:06:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BE2C1946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 13:06:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BAF5A483EC4; Mon, 20 Mar 2023 13:06:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B337B40F158
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 13:06:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CC338828C1
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 13:06:32 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-pk6IXF_QPxCRfCE3hje6Eg-1; Mon, 20 Mar 2023 09:06:30 -0400
X-MC-Unique: pk6IXF_QPxCRfCE3hje6Eg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id BA35E68AFE; Mon, 20 Mar 2023 14:06:25 +0100 (CET)
Date: Mon, 20 Mar 2023 14:06:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20230320130625.GA11908@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
 <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
 <20230315133039.GA24533@lst.de>
 <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
 <6da0ec0a-d465-fec4-0ca5-96b2ffb7be7a@oracle.com>
MIME-Version: 1.0
In-Reply-To: <6da0ec0a-d465-fec4-0ca5-96b2ffb7be7a@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 Jan Hoeppner <hoeppner@linux.ibm.com>, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
 kbusch@kernel.org, Christoph Hellwig <hch@lst.de>, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 16, 2023 at 11:36:12AM -0500, Mike Christie wrote:
> I think we are ok for dasd using BLK_STS_RESV_CONFLICT.
> 
> It thought it sounded similar to SCSI/NVMe and userspace will still
> see -EBADE because the blk_status_to_errno/errno_to_blk_status will
> handle this.
> 
> There was no internal dasd code checking for BLK_STS_NEXUS.
> 
> There is a pr_ops API, but dasd is not hooked into it so we don't
> have to worry about behavior changes.

Yes, we don't have to worry about it.  I just find a bit confusing
to have a PR-related error in a driver that doesn't use PRs.

Maybe add a little comment that it is used for some s390 or DASD
specific locking instead.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

