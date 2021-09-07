Return-Path: <SRS0=HcGL=N5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7610C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 01:37:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08C026109D
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 01:37:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 08C026109D
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630978657;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DpYre6ow6DpXVFIak+ThGF86dzvyNckqJeWjz9Ez7wA=;
	b=F7CsuHi0y1Q6cQi7SFLdgBCXeCJgCKbIXDFb9TZT35/aXVdL/MxVhS8YGBbtUGe/KnDX4b
	d7fxU21AK39Q+dByivhOsChbRT4rSqNv5c7mVNJrDZzCOv0TGjIJd8SJ97+q4oVWPouqzC
	wAFIQMAQzWSzzK+PHOlYTCShqFGE6rs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-w2elVKQ1Owqxextw9T_TKQ-1; Mon, 06 Sep 2021 21:37:35 -0400
X-MC-Unique: w2elVKQ1Owqxextw9T_TKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C86E84A5E0;
	Tue,  7 Sep 2021 01:37:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10332272A8;
	Tue,  7 Sep 2021 01:37:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D24344A59;
	Tue,  7 Sep 2021 01:37:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1871bRvk020505 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Sep 2021 21:37:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CDEB3272A5; Tue,  7 Sep 2021 01:37:27 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8619927097;
	Tue,  7 Sep 2021 01:37:04 +0000 (UTC)
Date: Tue, 7 Sep 2021 09:37:05 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Message-ID: <YTbCQdieHG07Bz8W@T590>
References: <20210830212538.148729-1-mcgrof@kernel.org>
	<20210830212538.148729-3-mcgrof@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210830212538.148729-3-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: ulf.hansson@linaro.org, snitzer@redhat.com, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, agk@redhat.com,
	beanhuo@micron.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
	hch@infradead.org, jejb@linux.ibm.com, josef@toxicpanda.com,
	swboyd@chromium.org, linux-block@vger.kernel.org,
	avri.altman@wdc.com, kbusch@kernel.org, nbd@other.debian.org,
	bvanassche@acm.org, axboe@kernel.dk, martin.petersen@oracle.com,
	linux-mmc@vger.kernel.org, adrian.hunter@intel.com
Subject: Re: [dm-devel] [PATCH v3 2/8] scsi/sr: add error handling support
	for add_disk()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 30, 2021 at 02:25:32PM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/scsi/sr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 2942a4ec9bdd..72fd21844367 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -779,7 +779,10 @@ static int sr_probe(struct device *dev)
>  	dev_set_drvdata(dev, cd);
>  	disk->flags |= GENHD_FL_REMOVABLE;
>  	sr_revalidate_disk(cd);
> -	device_add_disk(&sdev->sdev_gendev, disk, NULL);
> +
> +	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
> +	if (error)
> +		goto fail_minor;

You don't undo register_cdrom(), maybe you can use kref_put(&cd->kref, sr_kref_release);
to simplify the error handling.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

