Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D55C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:25:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FB5860233
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FB5860233
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-FODbPNLAN42tojlOocyyhQ-1; Wed, 10 Feb 2021 15:25:15 -0500
X-MC-Unique: FODbPNLAN42tojlOocyyhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA04419357B3;
	Wed, 10 Feb 2021 20:25:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03B6860657;
	Wed, 10 Feb 2021 20:25:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F95F4EEF6;
	Wed, 10 Feb 2021 20:25:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AKP6OF011776 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 15:25:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B53572026D11; Wed, 10 Feb 2021 20:25:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B04102026D46
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 20:25:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 779F780088E
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 20:25:04 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-554-a0tZKg4gODunavCN6Omi5w-1;
	Wed, 10 Feb 2021 15:25:02 -0500
X-MC-Unique: a0tZKg4gODunavCN6Omi5w-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC5364EDC;
	Wed, 10 Feb 2021 20:25:00 +0000 (UTC)
Date: Wed, 10 Feb 2021 12:24:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Satya Tangirala <satyat@google.com>
Message-ID: <YCRBGnGq/LY0uNxM@gmail.com>
References: <20210201051019.1174983-1-satyat@google.com>
	<20210201051019.1174983-6-satyat@google.com>
MIME-Version: 1.0
In-Reply-To: <20210201051019.1174983-6-satyat@google.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 5/5] dm: set DM_TARGET_PASSES_CRYPTO
 feature for some targets
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 01, 2021 at 05:10:19AM +0000, Satya Tangirala wrote:
> dm-linear and dm-flakey obviously can pass through inline crypto support.
> 
> Co-developed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>
> ---
>  drivers/md/dm-flakey.c | 4 +++-
>  drivers/md/dm-linear.c | 5 +++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index a2cc9e45cbba..30c6bc151213 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -482,8 +482,10 @@ static struct target_type flakey_target = {
>  	.name   = "flakey",
>  	.version = {1, 5, 0},
>  #ifdef CONFIG_BLK_DEV_ZONED
> -	.features = DM_TARGET_ZONED_HM,
> +	.features = DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO,
>  	.report_zones = flakey_report_zones,
> +#else
> +	.features = DM_TARGET_PASSES_CRYPTO,
>  #endif
>  	.module = THIS_MODULE,
>  	.ctr    = flakey_ctr,
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 00774b5d7668..fc9c4272c10d 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -229,10 +229,11 @@ static struct target_type linear_target = {
>  	.version = {1, 4, 0},
>  #ifdef CONFIG_BLK_DEV_ZONED
>  	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
> -		    DM_TARGET_ZONED_HM,
> +		    DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO,
>  	.report_zones = linear_report_zones,
>  #else
> -	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT,
> +	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
> +		    DM_TARGET_PASSES_CRYPTO,
>  #endif
>  	.module = THIS_MODULE,
>  	.ctr    = linear_ctr,
> -- 

This latest version looks good to me.  If it's needed despite my
Co-developed-by, feel free to add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

BTW, the #ifdef for CONFIG_BLK_DEV_ZONED is error-prone (though it's a
pre-existing issue).  I wonder if DM_TARGET_ZONED_HM should be defined to 0 when
!CONFIG_BLK_DEV_ZONED, which would avoid the need for the #ifdef on .features.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

