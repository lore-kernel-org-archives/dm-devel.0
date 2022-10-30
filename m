Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF54C38A02
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 08:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667117844;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YC/WLj4rIMKM1QzUabdqH3hesFLJw8X+3Be2d7uobfU=;
	b=A73xxx3S2X9pTF0dbUbvghxfAqNPrJdwiBLP51+pLYOAVzpwHUBcshDKPj5YRdayNyJ5sr
	KXzGW+Y0FPSgkXXIHI7ysGPkFx0/z5wQAh2IQrtLPfMERneFt3dMjEGzFmfKz8UFLCyHmK
	yMOijqM6PqRJe3hmWclGEoULwUpksP0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-JJwXsbeeNsa-QYQFE4zZuw-1; Sun, 30 Oct 2022 04:17:21 -0400
X-MC-Unique: JJwXsbeeNsa-QYQFE4zZuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47CBF3C025A0;
	Sun, 30 Oct 2022 08:17:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E9067111DCE1;
	Sun, 30 Oct 2022 08:17:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A24091946587;
	Sun, 30 Oct 2022 08:17:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6845F1946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 08:17:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 09B882027063; Sun, 30 Oct 2022 08:17:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01D712027062
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 08:17:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7815811E67
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 08:17:16 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-dciDle3ZO8-q7aquhWRVMQ-1; Sun, 30 Oct 2022 04:17:13 -0400
X-MC-Unique: dciDle3ZO8-q7aquhWRVMQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 91DFB68BEB; Sun, 30 Oct 2022 09:17:08 +0100 (CET)
Date: Sun, 30 Oct 2022 09:17:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20221030081708.GA4774@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-10-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20221026231945.6609-10-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v3 09/19] nvme: Add pr_ops read_keys support
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
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, martin.petersen@oracle.com,
 kbusch@kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 26, 2022 at 06:19:35PM -0500, Mike Christie wrote:
> This patch adds support for the pr_ops read_keys callout by calling the
> NVMe Reservation Report helper, then parsing that info to get the
> controller's registered keys. Because the callout is only used in the
> kernel where the callers do not know about controller/host IDs, the
> callout just returns the registered keys which is required by the SCSI PR
> in READ KEYS command.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/nvme/host/pr.c | 73 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/nvme.h   |  4 +++
>  2 files changed, 77 insertions(+)
> 
> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
> index aa88c55879b2..df7eb2440c67 100644
> --- a/drivers/nvme/host/pr.c
> +++ b/drivers/nvme/host/pr.c
> @@ -118,10 +118,83 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
>  	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
>  }
>  
> +static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
> +		u32 data_len, bool *eds)

Is there any good reason this method seems to take a u8 instead of a void
pointer?  As that seems to make a few things a bit messy.

> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
> +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
> +	else
> +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
> +					      data, data_len);

Can you please add a hlper for this logic?

> +	for (i = 0; i < num_ret_keys; i++) {
> +		if (eds) {
> +			keys_info->keys[i] =
> +					le64_to_cpu(status->regctl_eds[i].rkey);
> +		} else {
> +			keys_info->keys[i] =
> +					le64_to_cpu(status->regctl_ds[i].rkey);
> +		}

If you shorten the status variable name to something like rs this becomes
much easier to follow :)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

