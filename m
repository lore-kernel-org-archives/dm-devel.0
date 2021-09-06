Return-Path: <SRS0=HcGL=N5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E10C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 06:19:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07128610FE
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 06:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07128610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-pbSPNys4PnOgIRojSYRS1w-1; Tue, 07 Sep 2021 02:19:32 -0400
X-MC-Unique: pbSPNys4PnOgIRojSYRS1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A243B5200;
	Tue,  7 Sep 2021 06:19:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DD5460C9F;
	Tue,  7 Sep 2021 06:19:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BEE9A1806D0F;
	Tue,  7 Sep 2021 06:19:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 186HArg3015702 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Sep 2021 13:10:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8B18620316D8; Mon,  6 Sep 2021 17:10:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8668B20316C2
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 17:10:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47EEE89B846
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 17:10:50 +0000 (UTC)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
	[209.85.208.178]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-64-dz-bdEFSNQOcQyY6c4dCfg-1; Mon, 06 Sep 2021 13:10:48 -0400
X-MC-Unique: dz-bdEFSNQOcQyY6c4dCfg-1
Received: by mail-lj1-f178.google.com with SMTP id m4so12307278ljq.8
	for <dm-devel@redhat.com>; Mon, 06 Sep 2021 10:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=eBV6xJO0OJaH8jzRZsLqKsR9gePhFCKXaYbJlTL1SK0=;
	b=gtlhvq2gyLTZHEMpK+iJ8UQ7No7Ta/gko/iTlC2fsGPs4zhuYbEMGF4t7Fz+PY5JTX
	N16h8XqScf+L/81AJ9tfer1IBVvbsWTKhmwWlDuqWWBrGPXdrJb7kOYNS4ZLTSCd3Xnx
	eAuVucYZTApN2eZDg62DD3QPESzFTJJ2z8OrfXSIH73zCupfi/T55H1YV7GcaGqgH1Ma
	iPB+t8Hfh8finphE6SEWsJD7YYn80ecS+GRca1SK6C07h0tHvhRS+JGDZ4qbRUgjZvff
	Ytt+ebOxDg6mfi2vrEMwrbbN74PbaA7qC+HemWmGno7z3zXEOcfKRjMIPgDDsfYvL2oy
	m1oA==
X-Gm-Message-State: AOAM531C0V32W/sicVQd8RYjo0HbIr8iXYiuNpDmRnBMFut+tyJMYd5P
	UFzv7ec9NFFdOPqTNsnk5i/1+R4lUtHy0Fk0mCFHUg==
X-Google-Smtp-Source: ABdhPJxhSEFI8wMN4u5XHazx2hzbbCQEPxdsCfALNn+wlwsdQueMDsoHtriqduJghpS67u2M98pG6gst9sXWJqwHE5o=
X-Received: by 2002:a05:651c:1b3:: with SMTP id
	c19mr11757010ljn.16.1630948247165; 
	Mon, 06 Sep 2021 10:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210830212538.148729-1-mcgrof@kernel.org>
	<20210830212538.148729-5-mcgrof@kernel.org>
In-Reply-To: <20210830212538.148729-5-mcgrof@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Mon, 6 Sep 2021 19:10:10 +0200
Message-ID: <CAPDyKFp9HTjQ_6c2tHuPhhixfcnFa8XQBrPO2PqoB113BszLJw@mail.gmail.com>
To: Luis Chamberlain <mcgrof@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 07 Sep 2021 02:19:00 -0400
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dm-devel@redhat.com, agk@redhat.com,
	"Bean Huo \(beanhuo\)" <beanhuo@micron.com>,
	Ming Lei <ming.lei@redhat.com>, sagi@grimberg.me,
	linux-scsi <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-block <linux-block@vger.kernel.org>,
	Avri Altman <avri.altman@wdc.com>, kbusch@kernel.org,
	Stephen Boyd <swboyd@chromium.org>, Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [dm-devel] [PATCH v3 4/8] mmc/core/block: add error handling
	support for add_disk()
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 30 Aug 2021 at 23:26, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
>
> The caller only cleanups the disk if we pass on an allocated md
> but on error we return return ERR_PTR(ret), and so we must do all
> the unwinding ourselves.
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Queued for v5.16 on the temporary devel branch, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/core/block.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index 6a15fdf6e5f2..9b2856aa6231 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -2453,9 +2453,14 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
>         /* used in ->open, must be set before add_disk: */
>         if (area_type == MMC_BLK_DATA_AREA_MAIN)
>                 dev_set_drvdata(&card->dev, md);
> -       device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> +       ret = device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> +       if (ret)
> +               goto err_cleanup_queue;
>         return md;
>
> + err_cleanup_queue:
> +       blk_cleanup_queue(md->disk->queue);
> +       blk_mq_free_tag_set(&md->queue.tag_set);
>   err_kfree:
>         kfree(md);
>   out:
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

