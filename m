Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB60CC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:47:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6988E61131
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:47:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6988E61131
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633553221;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V4GiYm9lxUAJ1O4jPOupxzoc1oh79+FPQ2PS66yzTik=;
	b=RomjFORVtvWqztVhnRZ0ROlep17N6f9bFgLTatpq3O8kxu9fWlOC0639cm5sLxZfrNO03H
	8275LjKdGxk2ogQYKi4XeKfab6a+WvIMDSCIONpzoQpsQuEjA78JO/dFfxRavdTmYZHc/7
	/OgRXIPtbBkwD96KLTubf+j3b7UzqkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-4ZeLq2K4NgeJfIXY0c5fxQ-1; Wed, 06 Oct 2021 16:46:58 -0400
X-MC-Unique: 4ZeLq2K4NgeJfIXY0c5fxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4E4D8015C7;
	Wed,  6 Oct 2021 20:46:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 845735D6D5;
	Wed,  6 Oct 2021 20:46:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D43F84EA29;
	Wed,  6 Oct 2021 20:46:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196KZ8Mc021828 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 16:35:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8C6132026D48; Wed,  6 Oct 2021 20:35:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88B892026D46
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 20:35:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F4AF899ECF
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 20:35:08 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
	[209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-68-IvANykwLNtWBnWqI5X8rLg-1; Wed, 06 Oct 2021 16:35:07 -0400
X-MC-Unique: IvANykwLNtWBnWqI5X8rLg-1
Received: by mail-qk1-f198.google.com with SMTP id
	x25-20020a05620a01f900b0045e1c4567ddso3117579qkn.15
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 13:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=ChmUn1Ubxqhc19tcaK+EQSGprE5oT31gGpUJl6/LOWo=;
	b=GX5lFZHDDEqflx1xb78wz9jWezeo+R/QpDy2Xx+CsI+HGIkcsq7HBIudfRhjt3Wlf/
	uCcxl/3LV//vuDNn9N8MH/x9+Jd+gjnOZPJcJGm1OmgqjM9Hp4vBudTA5i5nhcPS6fBn
	1TyWO+N2zIb9bkSP49Id3QPaTWMIRd113yPjB/pShzI8jwdC/KTrMZbRBlkHtzLPlImc
	uEcEHR7IMytOsqZRDvYJsztMlRV49mUM3ySmx9fMHvKnFSdc8I40qA0f7kxw2rdbpI2J
	xYiFrmU3c8oOS9JjfpegpxtUg4EIKv+SPx/jVaCJ0WnkokFvRaNPcZywoCr0GrPnAtXK
	kHHA==
X-Gm-Message-State: AOAM532OdQ2sKMgWaxAImands7erxtzMYiaJeGBzj+Y9MrXB7atpWa3t
	YvV7sWo1nycKW0Fr+QImLR4BXIo88mUIRuawwDyaD8xBDwucj86zn91FJe1UkIIVgHS4WEylGVI
	IZCtR7vXAqKzEWA==
X-Received: by 2002:a37:951:: with SMTP id 78mr219164qkj.244.1633552506776;
	Wed, 06 Oct 2021 13:35:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhq2Shewpm6bK8Iy643sz+CFeNwn4Rclq799e/uBsRVu4SBMSxg4/7i9slmoEHPf3/TnVfAg==
X-Received: by 2002:a37:951:: with SMTP id 78mr219150qkj.244.1633552506586;
	Wed, 06 Oct 2021 13:35:06 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	s185sm12175662qke.93.2021.10.06.13.35.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 13:35:06 -0700 (PDT)
Date: Wed, 6 Oct 2021 16:35:05 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <YV4IecLg56NpzkYx@redhat.com>
References: <20211004200641.378496-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <20211004200641.378496-1-skhan@linuxfoundation.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] dm: change dm_get_target_type() to check for module
	load error
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 04 2021 at  4:06P -0400,
Shuah Khan <skhan@linuxfoundation.org> wrote:

> dm_get_target_type() doesn't check error return from request_module().
> Change to check for error and return NULL instead of trying to get
> target type again which would fail.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  drivers/md/dm-target.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> index 64dd0b34fcf4..0789e9f91d3a 100644
> --- a/drivers/md/dm-target.c
> +++ b/drivers/md/dm-target.c
> @@ -41,17 +41,22 @@ static struct target_type *get_target_type(const char *name)
>  	return tt;
>  }
>  
> -static void load_module(const char *name)
> +static int load_module(const char *name)
>  {
> -	request_module("dm-%s", name);
> +	return request_module("dm-%s", name);
>  }
>  
>  struct target_type *dm_get_target_type(const char *name)
>  {
>  	struct target_type *tt = get_target_type(name);
> +	int ret;
>  
>  	if (!tt) {
> -		load_module(name);
> +		ret = load_module(name);
> +		if (ret < 0) {
> +			pr_err("Module %s load failed %d\n", name, ret);
> +			return NULL;
> +		}
>  		tt = get_target_type(name);
>  	}
>  
> -- 
> 2.30.2
> 

While I appreciate your intent, the reality is that multiple targets
may be made available in a given module.  And so loading one dm module
may bring in access to N targets.  There isn't a rigid 1:1 mapping of
target modules to names.  And there may not even be a loadable module
that has the name dm-${name} -- but that doesn't mean the target_type
won;t have been loaded into DM for it to access.

So all said, your patch is bogus and would break DM and user
experience:

Nacked-by: Mike Snitzer <snitzer@redhat.com>

But thanks for raising your concern.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

