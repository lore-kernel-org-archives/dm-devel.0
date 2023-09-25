Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB142CD3431
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695665970;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OLvwkZpz3/ggpuJizglz1UdDIAT3iiSX9ZMaoF9sWvQ=;
	b=Pg0gXK10tbuR6IIt7a7eKFj3atKBrCSjW5ofYXX4YZSPdSHWn2seITEcZSFomDJEkr2Pxu
	/csFx17pmIbKhxHLeq/uwrNxWy2OBWBzyvUy7jlhfIhZxIuZh7hVQrDBlitXguv3C+vYdZ
	/mtXlFOBFmzE6EIoRfcrhixQrOsYQX8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-sUytqiiENgqJ-Sy77j65AQ-1; Mon, 25 Sep 2023 14:19:27 -0400
X-MC-Unique: sUytqiiENgqJ-Sy77j65AQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9D33811E7D;
	Mon, 25 Sep 2023 18:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2041BC15BB8;
	Mon, 25 Sep 2023 18:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CBB10194658F;
	Mon, 25 Sep 2023 18:19:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 43C93194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 18:19:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2EE2540C6E76; Mon, 25 Sep 2023 18:19:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 279C140C6EA8
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:19:24 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 057E58030A9
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:19:24 +0000 (UTC)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com
 [209.85.167.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-O-N5bHDhOGyJi0MbCZSRIg-1; Mon, 25 Sep 2023 14:19:22 -0400
X-MC-Unique: O-N5bHDhOGyJi0MbCZSRIg-1
Received: by mail-oi1-f179.google.com with SMTP id
 5614622812f47-3ae0135c4deso4290137b6e.3
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 11:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695665961; x=1696270761;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=iTuU49n18VYSBeYT+lBU1flo4trajW5dqzu15DzOflI=;
 b=SFodMRhb+YDtk7H8M3qkfxXHKagvfbYQpqTMSc506zPujosyjzQRmBdnMz7dvNUrTI
 TB4sr25N5a4eDxjiLMDEvYU9XF+YKmdqpJJJCsLoOysdb89P/K3tKq541zhgLNhOFF4u
 C0YlNmOwICtNN2uvx2DT6LNPXrh4IufLJkWdr650wsN1km+QtlpstIucpGfjWwV3wdXb
 PlAl04goOh+frE5hQzjUdMquFqduNg8AuJ0FSiZQ/f+pCfp6ZCr3sBILrZRa+OAV0bMu
 xR3rYIp/WMHDYE/210VcRQ1w3hAJJ/Li+qpl2/p6kneolceHNvuiazm3yGTG8eH4Pov9
 7TMQ==
X-Gm-Message-State: AOJu0YyzvAS2E4EvwiSCiMBE4j7SIZcVvo9on4pZ0z4FIRnTisiyUI73
 Q1RYrXA+uTB7xkNA2+ql69cEkA==
X-Google-Smtp-Source: AGHT+IHx6BfOfHDMJM4u4SbWnBpvZYEK3N4VRzJDRxi/bvyhpBGykczqAdZZ1m/m8+89wVmMWrEqKg==
X-Received: by 2002:a05:6808:2094:b0:3ad:f536:2f26 with SMTP id
 s20-20020a056808209400b003adf5362f26mr11219365oiw.18.1695665961389; 
 Mon, 25 Sep 2023 11:19:21 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 j26-20020aa7801a000000b0068be3489b0dsm8616363pfi.172.2023.09.25.11.19.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Sep 2023 11:19:20 -0700 (PDT)
Date: Mon, 25 Sep 2023 11:19:20 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Message-ID: <202309251109.5AEBF4369@keescook>
References: <20230925-strncpy-drivers-md-dm-ioctl-c-v1-1-f0bfa093ef14@google.com>
MIME-Version: 1.0
In-Reply-To: <20230925-strncpy-drivers-md-dm-ioctl-c-v1-1-f0bfa093ef14@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] dm ioctl: replace deprecated strncpy with
 strscpy_pad
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 linux-hardening@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 25, 2023 at 06:54:51AM +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> We expect `spec->target_type` to be NUL-terminated based on its use with
> a format string after `dm_table_add_target()` is called
> | 	r = dm_table_add_target(table, spec->target_type,
> | 				(sector_t) spec->sector_start,
> | 				(sector_t) spec->length,
> | 				target_params);
> ... wherein `spec->target_type` is passed as parameter `type` and later
> printed with DMERR:
> |       DMERR("%s: %s: unknown target type", dm_device_name(t->md), type);
> 
> It appears that `spec` is not zero-allocated and thus NUL-padding may be
> required in this ioctl context.

Yeah... this one was a bit odd. I see the memory being filled from
userspace in copy_params(), so it's unlikely there was any kernel memory
content leaking, but I think the old code may have been buggy:

		strncpy(spec->target_type, ti->type->name,
			sizeof(spec->target_type) - 1);

I can't find any reason to think that
spec->target_type[sizeof(spec->target_type) - 1] would be %NUL after
this code runs.

get_result_buffer() is basically:
        return ((void *) param) + param->data_start;

then:

        outptr = outbuf = get_result_buffer(param, param_size, &len);
	...
                spec = (struct dm_target_spec *) outptr;

and before that:

        r = copy_params(user, &param_kernel, ioctl_flags, &param, &param_flags);

        if (r)
                return r;

        input_param_size = param->data_size;
        r = validate_params(cmd, param);
        if (r)
                goto out;

        param->data_size = offsetof(struct dm_ioctl, data);
        r = fn(file, param, input_param_size);

Notably validate_params() %NUL-terminates some _other_ strings, but
doesn't clear the param->data area.

So I think this is actually fixing a bug too, but I can't quite tell.

Regardless, the change looks correct:

Reviewed-by: Kees Cook <keescook@chromium.org>

> 
> Considering the above, a suitable replacement is `strscpy_pad` due to
> the fact that it guarantees NUL-termination whilst maintaining the
> NUL-padding behavior that strncpy provides.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
> Note: build-tested only.
> ---
>  drivers/md/dm-ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 21ebb6c39394..e65058e0ed06 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1295,8 +1295,8 @@ static void retrieve_status(struct dm_table *table,
>  		spec->status = 0;
>  		spec->sector_start = ti->begin;
>  		spec->length = ti->len;
> -		strncpy(spec->target_type, ti->type->name,
> -			sizeof(spec->target_type) - 1);
> +		strscpy_pad(spec->target_type, ti->type->name,
> +			sizeof(spec->target_type));
>  
>  		outptr += sizeof(struct dm_target_spec);
>  		remaining = len - (outptr - outbuf);
> 
> ---
> base-commit: 6465e260f48790807eef06b583b38ca9789b6072
> change-id: 20230925-strncpy-drivers-md-dm-ioctl-c-ea5c10e77981
> 
> Best regards,
> --
> Justin Stitt <justinstitt@google.com>
> 
> 

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

