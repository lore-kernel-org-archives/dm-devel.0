Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7400C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647908413;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nJvgfDX0hI4E4Jq8ShF1jFx5Wh/Zt1QbqBVEgi2LOOg=;
	b=BHmmHKa97vRgp7qp65aV0W1bMprUsHJ6bZxp3xrmhVue6743kDwVQ3vz+G/gMxRXQE06fN
	GwJGlFx/HESlO+7ITo46CVe0URUDfs1bta7Zovt3vcE1+Tc+Vmuf7XBb6JQwscdl4vKf5z
	mRulSXa4NfvvEC3h6hZ24rG5NNxfYsI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-aUbt8bblOIeFdZNVxCrOGQ-1; Mon, 21 Mar 2022 20:20:10 -0400
X-MC-Unique: aUbt8bblOIeFdZNVxCrOGQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 248873C11A02;
	Tue, 22 Mar 2022 00:20:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 139FA401E50;
	Tue, 22 Mar 2022 00:20:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E1F001947BBE;
	Tue, 22 Mar 2022 00:20:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 834841947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:20:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D7B940CF8FB; Tue, 22 Mar 2022 00:20:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39883400E550
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:20:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20F492999B2D
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:20:07 +0000 (UTC)
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-m3hoUlnjNYCpeeKJ8e2zlg-1; Mon, 21 Mar 2022 20:20:06 -0400
X-MC-Unique: m3hoUlnjNYCpeeKJ8e2zlg-1
Received: by mail-lf1-f72.google.com with SMTP id
 u29-20020ac251dd000000b0044a245bcc1aso1094591lfm.7
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/k3Sqp8qG/ek+e2Wz5sqt/QAURrH9zjYs+Pq6/R5tGw=;
 b=7LCg97GOJHW3V9WUs1p1yW4D+tWaD0R4lIVNK8ySqXTNE5/3EaQkoDyT0PEAk22C3w
 b7S/M+bVlRfA9LspTaAXz9C8SxQQzAeKIKpzWwsTA1NUu3L5HwyF9UYMUJ1YUJgPyCwD
 SYHNPXrZcFPDWQzYniCTR36NZ6pc4TYL/4VpgeggxiXW4r5x5BLe6+LZnWMzqW6hztnj
 EEaGm0KQWKNLVh7tRSuxrc9axFL7AKERi1wcFafiidMnOLEFYZt/2vBzej0Hx7QvEZkc
 8/ciKIMKfL83eROjXtLuKNl2Rmt9kCu83w4xq4jMZLiFCjAUxQ7TwQ7t9z4t5U0oEt89
 ePTA==
X-Gm-Message-State: AOAM5304fkPjccFFoUAPCLy37TEePEheSklZQBL9pKNn4Nq5yewz1nqv
 m0SSVRM59mka4BGMOl9vt8jQgedf6baw0lFwIHKS/QCme4sX8p6zgD3hqepGdY6U0ITAYJ93FZU
 aLSjWaErff/WLSvbOwzuaPTrXSiTik1Q=
X-Received: by 2002:a05:6512:2292:b0:44a:2a12:e7e8 with SMTP id
 f18-20020a056512229200b0044a2a12e7e8mr5787118lfu.33.1647908404052; 
 Mon, 21 Mar 2022 17:20:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMU7EbD4m8Z8I80Vr+mCzgupLebIa02F/29jPZBd2g80oKm/neFB+vMm2O9F3YgzGTEHyM/hRd6ydqDc5OkUg=
X-Received: by 2002:a05:6512:2292:b0:44a:2a12:e7e8 with SMTP id
 f18-20020a056512229200b0044a2a12e7e8mr5787108lfu.33.1647908403853; Mon, 21
 Mar 2022 17:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-4-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-4-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:19:53 -0500
Message-ID: <CAPt1nt6mMiXs1mr+TR0m9bki7dVN+16KTLG-ZaAJrRC_5VOzWg@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 03/11] multipathd: avoid busy loop in
 child() for delayed reconfigure
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
> If need_to_delay_reconfig() returned true, the logic introduced
> by 250708c ("multipathd: improve delayed reconfigure") and
> 4b104e6 ("multipathd: pass in the type of reconfigure") could cause
> child() to run in a tight loop, switching back and forth between
> DAEMON_CONFIGURE and DAEMON_IDLE states without actually calling
> reconfigure().
>
> Move the logic to postpone reconfigure() calls from __post_config_state()
> into child(), entirely, to avoid this situation. This means that child()
> needs to poll for reconfigure_pending besides running_state changes.
>
> Fixes: 250708c ("multipathd: improve delayed reconfigure")
> Fixes: 4b104e6 ("multipathd: pass in the type of reconfigure")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 48 +++++++++++++++++++----------------------------
>  1 file changed, 19 insertions(+), 29 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7ecf3bd..d033a9a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -288,38 +288,12 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
>  /* Don't access this variable without holding config_lock */
>  static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
>
> -static void enable_delayed_reconfig(void)
> -{
> -       pthread_mutex_lock(&config_lock);
> -       __delayed_reconfig = true;
> -       pthread_mutex_unlock(&config_lock);
> -}
> -
>  /* must be called with config_lock held */
>  static void __post_config_state(enum daemon_status state)
>  {
>         if (state != running_state && running_state != DAEMON_SHUTDOWN) {
>                 enum daemon_status old_state = running_state;
>
> -               /*
> -                * Handle a pending reconfigure request.
> -                * DAEMON_IDLE is set from child() after reconfigure(),
> -                * or from checkerloop() after completing checkers.
> -                * In either case, child() will see DAEMON_CONFIGURE
> -                * again and start another reconfigure cycle.
> -                */
> -               if (reconfigure_pending != FORCE_RELOAD_NONE &&
> -                   state == DAEMON_IDLE &&
> -                   (old_state == DAEMON_CONFIGURE ||
> -                    old_state == DAEMON_RUNNING)) {
> -                       /*
> -                        * notify systemd of transient idle state, lest systemd
> -                        * thinks the reload lasts forever.
> -                        */
> -                       do_sd_notify(old_state, DAEMON_IDLE);
> -                       old_state = DAEMON_IDLE;
> -                       state = DAEMON_CONFIGURE;
> -               }
>                 running_state = state;
>                 pthread_cond_broadcast(&config_cond);
>                 do_sd_notify(old_state, state);
> @@ -3390,8 +3364,21 @@ child (__attribute__((unused)) void *param)
>                 pthread_cleanup_push(config_cleanup, NULL);
>                 pthread_mutex_lock(&config_lock);
>                 while (running_state != DAEMON_CONFIGURE &&
> -                      running_state != DAEMON_SHUTDOWN)
> +                      running_state != DAEMON_SHUTDOWN &&
> +                      /*
> +                       * Check if another reconfigure request was scheduled
> +                       * while we last ran reconfigure().
> +                       * We have to test __delayed_reconfig here
> +                       * to avoid a busy loop
> +                       */
> +                      (reconfigure_pending == FORCE_RELOAD_NONE
> +                        || __delayed_reconfig))
>                         pthread_cond_wait(&config_cond, &config_lock);
> +
> +               if (running_state != DAEMON_CONFIGURE &&
> +                   running_state != DAEMON_SHUTDOWN)
> +                       /* This sets running_state to DAEMON_CONFIGURE */
> +                       __post_config_state(DAEMON_CONFIGURE);
>                 state = running_state;
>                 pthread_cleanup_pop(1);
>                 if (state == DAEMON_SHUTDOWN)
> @@ -3412,8 +3399,11 @@ child (__attribute__((unused)) void *param)
>                         pthread_mutex_unlock(&config_lock);
>
>                         rc = reconfigure(vecs, reload_type);
> -               } else
> -                       enable_delayed_reconfig();
> +               } else {
> +                       pthread_mutex_lock(&config_lock);
> +                       __delayed_reconfig = true;
> +                       pthread_mutex_unlock(&config_lock);
> +               }
>                 lock_cleanup_pop(vecs->lock);
>                 if (!rc)
>                         post_config_state(DAEMON_IDLE);
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

