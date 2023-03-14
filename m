Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA199C6FD1F
	for <dm-devel@archiver.kernel.org>; Tue, 14 Mar 2023 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678814273;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jIqA09h8BsBaYbahGn8Z09WdHVVSR7rd77YKGluf38g=;
	b=fq0L/opUo89pXGgMbujttc6pi70x3kloitR86CvTeKZFM50ZbQ3Em8SXM8aV0LjpQBdyXU
	rX3r747bNy1yih4BEH593vk2eOYodUZyyfqSSJQtmIgB7NRD/PsXGNyP8hmyE0IBDCS1k5
	g2TsCRp0em07rHpUuOgcHgOB6I4neUI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-d3K5tYe0MYSOO1LVHMyLdA-1; Tue, 14 Mar 2023 13:17:50 -0400
X-MC-Unique: d3K5tYe0MYSOO1LVHMyLdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F13FE3815F62;
	Tue, 14 Mar 2023 17:17:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E04D12027040;
	Tue, 14 Mar 2023 17:17:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F87419465A2;
	Tue, 14 Mar 2023 17:17:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E27C319465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Mar 2023 17:17:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0C34202701F; Tue, 14 Mar 2023 17:17:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B90D7202701E
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 17:17:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D7ED181E3F2
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 17:17:41 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-Flr4wterM-6mMKxibErNjQ-1; Tue, 14 Mar 2023 13:17:40 -0400
X-MC-Unique: Flr4wterM-6mMKxibErNjQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 30BD268AA6; Tue, 14 Mar 2023 18:11:20 +0100 (CET)
Date: Tue, 14 Mar 2023 18:11:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20230314171119.GB6780@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20230224174502.321490-3-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 bvanassche@acm.org, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 Jan Hoeppner <hoeppner@linux.ibm.com>, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
 martin.petersen@oracle.com, kbusch@kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 24, 2023 at 11:44:46AM -0600, Mike Christie wrote:
> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts or in dasd's
> case something similar. This renames BLK_STS_NEXUS so it better reflects
> this.

I like this rename a lot.

> diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
> index a9c2a8d76c45..a2899d9690d4 100644
> --- a/drivers/s390/block/dasd.c
> +++ b/drivers/s390/block/dasd.c
> @@ -2723,7 +2723,7 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
>  	else if (status == 0) {
>  		switch (cqr->intrc) {
>  		case -EPERM:
> -			error = BLK_STS_NEXUS;
> +			error = BLK_STS_RESV_CONFLICT;
>  			break;

But is this really a reservation conflict?  Or should the DASD code
maybe use a different error code here?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

