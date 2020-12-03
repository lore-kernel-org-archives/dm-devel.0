Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DECC4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 22:13:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F1802220F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 22:13:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F1802220F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-7ML3-r7DNb2Prr-41DeYGQ-1; Thu, 03 Dec 2020 17:13:53 -0500
X-MC-Unique: 7ML3-r7DNb2Prr-41DeYGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9ABE0180A094;
	Thu,  3 Dec 2020 22:13:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EED960854;
	Thu,  3 Dec 2020 22:13:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DA094BB7B;
	Thu,  3 Dec 2020 22:13:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3MDhwe009088 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 17:13:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C0AEB2166B2C; Thu,  3 Dec 2020 22:13:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA8562166B2B
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:13:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B1548007D9
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:13:40 +0000 (UTC)
Received: from mail-ua1-f68.google.com (mail-ua1-f68.google.com
	[209.85.222.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-290-mfl7SQ5PMiqCmFdbKu2e_g-1; Thu, 03 Dec 2020 17:13:35 -0500
X-MC-Unique: mfl7SQ5PMiqCmFdbKu2e_g-1
Received: by mail-ua1-f68.google.com with SMTP id q68so1216123uaq.3
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 14:13:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=KPxLDK2m3t3rbdEsv04AbgR9S3xVqD3vwyaV/8maCC4=;
	b=eu8q94VfE07SyKDfy4jJK/E39ssY3ZUhw5DXxzq5/gsTbe6OaNcVfz8PzxqwWrc/7Z
	1T3EQ8RU2D7BFh7LHscBYElaZeueh0pHO1TdBRTmCv++/uYyV/LvH/AprePXEXRaucT0
	RB7d8MjzR8in718mIegV9EHOAnpcoCFoqVEAm17t6LD2bydZQTHhJBXwg/DQUZMhAryS
	c0qOsNBMMD3lopM4/yBSLCiO8h3wv8+NRLpr5dVVTMLJ/gLzBvRN1GB1hMbXsw7KDF1x
	dCFV5cSGvq6+EvosNG1s3CuXrQt4Hu+OQ9wY8Ug+28gygCKxeEirTLSXedNBbKZY0pLK
	s5Jg==
X-Gm-Message-State: AOAM532EShKwljw5CYiDTnLNf/cOD6s1O1kI795BIhLmK8YWjk91PLye
	RxGKcm5H8dY5raUIiazBCLY0eYVxPKYavPauyCtEcT6Vpg4Z6Q==
X-Google-Smtp-Source: ABdhPJyzSP1fKwgvfT8Xm6ntUvZx+Fw3PJ26xCx+ecjHbcR9thZbQiP7LX27J+zTqg20SfVqUdUJxAo0/qJts8Fm1uk=
X-Received: by 2002:ab0:310:: with SMTP id 16mr1106249uat.33.1607033614516;
	Thu, 03 Dec 2020 14:13:34 -0800 (PST)
MIME-Version: 1.0
References: <000001d6c8d5$b03e7200$10bb5600$@codeaurora.org>
In-Reply-To: <000001d6c8d5$b03e7200$10bb5600$@codeaurora.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 3 Dec 2020 14:13:23 -0800
Message-ID: <CABCJKueYF95fvdJHCuK2JwY1jpTuM4T2ynMvqa8iUp-rvqYhZA@mail.gmail.com>
To: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm verity: correcting logic used with
 corrupted_errs counter
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 3, 2020 at 8:18 AM Ravi Kumar Siddojigari
<rsiddoji@codeaurora.org> wrote:
>
> Sorry,  Resending the patch for comments with  dm-devel added .
>
> -----Original Message-----
> From: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org>
> Sent: Friday, November 20, 2020 6:37 PM
> To: 'linux-block@vger.kernel.org' <linux-block@vger.kernel.org>
> Cc: 'dm-devel@redhat.com' <dm-devel@redhat.com>
> Subject: RE: [PATCH] dm verity: correcting logic used with corrupted_errs
> counter
>
> One more question  :
>         Current code has DM_VERITY_MAX_CORRUPTED_ERRS  set to 100  can we
> reduce this ? or is there any  data that made us to keep this 100 ?
> Regards,
> Ravi
>
> -----Original Message-----
> From: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org>
> Sent: Wednesday, November 18, 2020 6:17 PM
> To: 'linux-block@vger.kernel.org' <linux-block@vger.kernel.org>
> Subject: [PATCH] dm verity: correcting logic used with corrupted_errs
> counter
>
> In verity_handle_err we see that the "corrupted_errs"  is never going to be
> more than one as the code will fall through "out" label and hit
> panic/kernel_restart on the first error  which is not as expected..
> Following patch will make sure that corrupted_errs are incremented and only
> panic/kernel_restart once it reached DM_VERITY_MAX_CORRUPTED_ERRS.
>
> Signed-off-by: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org>
> ---
>  drivers/md/dm-verity-target.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index f74982dcbea0..d86900a2a8d7 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -221,8 +221,10 @@ static int verity_handle_err(struct dm_verity *v, enum
> verity_block_type type,
>         /* Corruption should be visible in device status in all modes */
>         v->hash_failed = 1;
>
> -       if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
> +       if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS) {
> +               DMERR("%s: reached maximum errors", v->data_dev->name);
>                 goto out;
> +       }
>
>         v->corrupted_errs++;
>
> @@ -240,13 +242,13 @@ static int verity_handle_err(struct dm_verity *v, enum
> verity_block_type type,
>         DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
>                     type_str, block);
>
> -       if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS)
> -               DMERR("%s: reached maximum errors", v->data_dev->name);
>
>         snprintf(verity_env, DM_VERITY_ENV_LENGTH, "%s=%d,%llu",
>                 DM_VERITY_ENV_VAR_NAME, type, block);
>
>         kobject_uevent_env(&disk_to_dev(dm_disk(md))->kobj, KOBJ_CHANGE,
> envp);
> +       /* DM_VERITY_MAX_CORRUPTED_ERRS limit not reached yet */
> +               return 0;

No. This would allow invalid blocks to be returned to userspace when
dm-verity is NOT in logging mode, which is unacceptable.
DM_VERITY_MAX_CORRUPTED_ERRS is only used to limit the number of error
messages printed out, we cannot let the first N corrupt blocks to just
slip through.

Sami

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

