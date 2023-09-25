Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88BDCD3431
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695666028;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CbRM+fGyWtYW2fh/ZFsEzJBi47UjvftRvAxkzpct4a4=;
	b=abzZ9lo8nV9Xzm4Hit7CjibEsjuzQeolfssxyte0PCZ/fv8xo9xlYpWRsyaI/57xurH8fn
	gmeTB0dMoHC9++4gwwpW16AsXYAVOSakwyybCAqCKKdqNeSc+BJXfHG73rxvhv5Yd31IRt
	fA5xf/oPlZvjXW97UpWcBbeV8spVNGI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-qMO3mL0sNs620XIFnFb8lw-1; Mon, 25 Sep 2023 14:20:25 -0400
X-MC-Unique: qMO3mL0sNs620XIFnFb8lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EC77185A79B;
	Mon, 25 Sep 2023 18:20:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B5D62156701;
	Mon, 25 Sep 2023 18:20:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3AB35194658F;
	Mon, 25 Sep 2023 18:20:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B64D194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 18:20:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 133D3400F36; Mon, 25 Sep 2023 18:20:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B5EF492C37
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:20:22 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD1FA3C176F9
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:20:21 +0000 (UTC)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-NozyrI9eM1-U9HJiTvE-rw-1; Mon, 25 Sep 2023 14:20:20 -0400
X-MC-Unique: NozyrI9eM1-U9HJiTvE-rw-1
Received: by mail-ot1-f47.google.com with SMTP id
 46e09a7af769-6c4e30a3604so1894900a34.2
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 11:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695666019; x=1696270819;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=NO8m8eKRK6gw6Fe8TwUzngktRHamqnnDsDwwzDNH28M=;
 b=mS44pjKwqRPdAO8ZUOgAz6yXuktdfuVwBDeudOWujcPDgGt3onw/egu9W4x6uU4WsN
 MQO+Wj4DX4QpCdGX+Qm0K3Pr5+XxqIxKuhSicE+l+HrTz5DYr4aCaS/M/IvGEGLS5Tbd
 snlodP7uxbkPuIca6AmzZcyPwfmrE2JpQ1Vfgb+NNDxFvy5i3G5eIDUhAdxH29OpxgFy
 2vC16gZ76iE9WNyKhSenVVnvYR+EcYSDlB4pbXo2AFSjS66HmbO5Ao8fW/p+MsM7xTfn
 tyxMAKjsYeeoUlC3bg2v/OXEwg6b9t814tbQSBAHTqo7TAcNTl1kqTQCZjOEB715cTlT
 L0yQ==
X-Gm-Message-State: AOJu0YxrPnZlusLG3pK39G6kO3HXTmWLkhofaYKevpw46UIwxop0MbQK
 okgal5Iva8FvBaUH06YApETzKg==
X-Google-Smtp-Source: AGHT+IHKSOY+zwApZkbmmnPtFl0loyWLQ/uN8QUCjcTuZ0xU2ovE+l4Elr00aAvn1WMqw7C2F4wggA==
X-Received: by 2002:a05:6830:115a:b0:6bc:b8d9:476e with SMTP id
 x26-20020a056830115a00b006bcb8d9476emr9039803otq.16.1695666019073; 
 Mon, 25 Sep 2023 11:20:19 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 k7-20020aa790c7000000b006875df4773fsm8310724pfk.163.2023.09.25.11.20.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Sep 2023 11:20:18 -0700 (PDT)
Date: Mon, 25 Sep 2023 11:20:18 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Message-ID: <202309251119.69C15DC@keescook>
References: <20230925-strncpy-drivers-md-dm-log-userspace-base-c-v1-1-030d7bcf1004@google.com>
MIME-Version: 1.0
In-Reply-To: <20230925-strncpy-drivers-md-dm-log-userspace-base-c-v1-1-030d7bcf1004@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] dm log userspace: replace deprecated strncpy
 with strscpy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 25, 2023 at 07:06:03AM +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> `lc` is already zero-allocated:
> |       lc = kzalloc(sizeof(*lc), GFP_KERNEL);
> ... as such, any future NUL-padding is superfluous.
> 
> A suitable replacement is `strscpy` [2] due to the fact that it
> guarantees NUL-termination on the destination buffer without
> unnecessarily NUL-padding.
> 
> Let's also go with the more idiomatic `dest, src, sizeof(dest)` pattern
> for destination buffers that the compiler can calculate the size for.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Looks good to me. Thanks for the sizeof() replacement. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> Note: build-tested only.
> ---
>  drivers/md/dm-log-userspace-base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
> index 5aace6ee6d47..7e4f27e86150 100644
> --- a/drivers/md/dm-log-userspace-base.c
> +++ b/drivers/md/dm-log-userspace-base.c
> @@ -224,7 +224,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
>  
>  	lc->usr_argc = argc;
>  
> -	strncpy(lc->uuid, argv[0], DM_UUID_LEN);
> +	strscpy(lc->uuid, argv[0], sizeof(lc->uuid));
>  	argc--;
>  	argv++;
>  	spin_lock_init(&lc->flush_lock);
> 
> ---
> base-commit: 6465e260f48790807eef06b583b38ca9789b6072
> change-id: 20230925-strncpy-drivers-md-dm-log-userspace-base-c-857579d9834f
> 
> Best regards,
> --
> Justin Stitt <justinstitt@google.com>
> 

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

