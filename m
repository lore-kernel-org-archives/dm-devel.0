Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86545C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647908336;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JXNLU2jRxqcZLz0sLK9Ln3KTeaptFqoAUxjO8A9QYl0=;
	b=NniW5FhTE2x5DoNOMtb3/qPUl+U7RSiSMcCWpBLT4QLijhOqJdnTT1u9h8P9H5cWEVRHUr
	vLqlw/Nq7dGcOPSxaTrhR6Ad+WZnXCjD6bx04HEeZZYWazpqaN4q9YI5fRknkYecWUqvfq
	I1LUWL1dOAwhZEqPmJQ1jpP+xz6PW9o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-nJQre56_P8CQevbSPBAQvw-1; Mon, 21 Mar 2022 20:18:54 -0400
X-MC-Unique: nJQre56_P8CQevbSPBAQvw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59AA43C11A00;
	Tue, 22 Mar 2022 00:18:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 317F4469A59;
	Tue, 22 Mar 2022 00:18:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EAE601947BBE;
	Tue, 22 Mar 2022 00:18:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5CF971947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:18:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 223914B8D64; Tue, 22 Mar 2022 00:18:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E9E84B8D4D
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:18:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02251802803
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:18:49 +0000 (UTC)
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-dyD6JlHfMyuWDSX1xiiOGQ-1; Mon, 21 Mar 2022 20:18:47 -0400
X-MC-Unique: dyD6JlHfMyuWDSX1xiiOGQ-1
Received: by mail-lj1-f199.google.com with SMTP id
 b2-20020a2e8942000000b002497c9833c2so2690307ljk.8
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3zuuyKcMBd/pU5d+ifA7/1xZmlY+Kpqr7p7HSLKPCvQ=;
 b=0s8BFFny3yZKFoCRS0hs0uTELQBASccm+cAvsrdLvctjt0rboJUB8NV8ifIybck1mz
 kF2tJYbm672NMH0n1GwDeRg/H5U6IYZwKgfesos5t8EmMqxAdR4eF0kjhQUFX7987xi+
 P/R8AIw0BcWQe1hYoSfPX72hxLpXlsnLcFerTQx3eXuXrNcYdeL99sn/94HaROdgePNT
 cii/MunjHHW004yCP/FwRL0dRjq4XVLdnjepwUKtx9VhaWwZAY5nNTMLBeLY0cZsLOS1
 TAnO1BQMGm7aREqNshHgZiA5Wx73IThgFzvl2hSUUlOi2vr4Ucfzgjz84zfAY2CmsZzB
 6CNQ==
X-Gm-Message-State: AOAM533TGaWIUma8ZW0CbC+hwfv+QtXcrUY47gySjm+uUl/zZF3JBWLj
 AtvYbWruQnm2rbHWxogOqEH0tl4VOonT6T99msq2E1Lzhaxg7eeBSBQIOFozgYtjGq0A3ZGCowF
 3SVSg0HLN8+Cl17Uqgs4DDuO13XcCsEM=
X-Received: by 2002:a2e:9b03:0:b0:249:7ded:f634 with SMTP id
 u3-20020a2e9b03000000b002497dedf634mr8169922lji.98.1647908326039; 
 Mon, 21 Mar 2022 17:18:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIIpluk0D+9MDy6/YIv+YuC8LlY6kdisoSM/BmgNHpip1w5WLwB57qrdoNzyt5TYDSVBfzwzuo1sTfLN7ypDE=
X-Received: by 2002:a2e:9b03:0:b0:249:7ded:f634 with SMTP id
 u3-20020a2e9b03000000b002497dedf634mr8169911lji.98.1647908325800; Mon, 21 Mar
 2022 17:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-2-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-2-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:18:34 -0500
Message-ID: <CAPt1nt4ekLUJ029i0XHcjNzDUYYTVJJNvLSqXuUyqPcZaYtxng@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 01/11] multipathd: child(): remove
 superfluous if condition
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
>
> From: Martin Wilck <mwilck@suse.com>
>
> No need to test for state == DAEMON_CONFIGURE at this point, we
> know that this is the case.
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f2c0b28..1c8839d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3395,6 +3395,8 @@ child (__attribute__((unused)) void *param)
>         pthread_attr_destroy(&misc_attr);
>
>         while (1) {
> +               int rc = 0;
> +
>                 pthread_cleanup_push(config_cleanup, NULL);
>                 pthread_mutex_lock(&config_lock);
>                 while (running_state != DAEMON_CONFIGURE &&
> @@ -3404,23 +3406,21 @@ child (__attribute__((unused)) void *param)
>                 pthread_cleanup_pop(1);
>                 if (state == DAEMON_SHUTDOWN)
>                         break;
> -               if (state == DAEMON_CONFIGURE) {
> -                       int rc = 0;
>
> -                       pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -                       lock(&vecs->lock);
> -                       pthread_testcancel();
> -                       if (!need_to_delay_reconfig(vecs))
> -                               rc = reconfigure(vecs);
> -                       else
> -                               enable_delayed_reconfig();
> -                       lock_cleanup_pop(vecs->lock);
> -                       if (!rc)
> -                               post_config_state(DAEMON_IDLE);
> -                       else {
> -                               condlog(0, "fatal error applying configuration - aborting");
> -                               exit_daemon();
> -                       }
> +               /* handle DAEMON_CONFIGURE */
> +               pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +               lock(&vecs->lock);
> +               pthread_testcancel();
> +               if (!need_to_delay_reconfig(vecs))
> +                       rc = reconfigure(vecs);
> +               else
> +                       enable_delayed_reconfig();
> +               lock_cleanup_pop(vecs->lock);
> +               if (!rc)
> +                       post_config_state(DAEMON_IDLE);
> +               else {
> +                       condlog(0, "fatal error applying configuration - aborting");
> +                       exit_daemon();
>                 }
>         }
>
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

