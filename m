Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C30C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647908528;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F1ktYCojOpoxwBhvIqNm6Hf73jjL6vIBlHxOKvVz8bE=;
	b=CT/L0se/X5iDWc2ZKfPiOgg3VELcoQ24vlsZ2oZzb7+RiyUKOoclWB9jTdidWYYl95OIU8
	kJCLJDWoxeLW0dRb/BVtEyslZRY2g+vkSjXSb8qCIi8FsXjL7yNzpVaGCKGYVyNxPGY9Qu
	qkGHTCmKxUiviRslC2CgIJmnzldKPkA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-pXJNwc56N_-WdN6HQLxFcQ-1; Mon, 21 Mar 2022 20:22:05 -0400
X-MC-Unique: pXJNwc56N_-WdN6HQLxFcQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAF01811E76;
	Tue, 22 Mar 2022 00:22:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9866C400E42D;
	Tue, 22 Mar 2022 00:22:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C51E1947BBE;
	Tue, 22 Mar 2022 00:22:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DEF011947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:22:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CB75A2026D13; Tue, 22 Mar 2022 00:22:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6BF72026D07
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:21:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB8683C11A09
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:21:54 +0000 (UTC)
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-lojK7sZ-OoG1DsamPXZ3qQ-1; Mon, 21 Mar 2022 20:21:53 -0400
X-MC-Unique: lojK7sZ-OoG1DsamPXZ3qQ-1
Received: by mail-lf1-f72.google.com with SMTP id
 z24-20020a056512371800b0043ea4caa07cso4126739lfr.17
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3EqWClVlyX9FGEFNj2apRR+crtidhbUE/SeGkYq8Ogc=;
 b=dMcelYUqYFLsmF/iXuudSUXLH3a52futPV1u99kgvvY5Fe9AW4wd+n+LuFKfaw+SSv
 U31Hq7HrwMJXDoX/BAK3e63JzP9vFoWWNb9kG2EL3KD4nmOooQ4jhNoUY2f8aExa4S+9
 tw0tiW/84tyQfpaqnz8UxBLhVKYeNutMG19RxZ6LgrmIIozrMI81Uww178ASwTXH4k8+
 erHFDqHLafJUirNi1qJrdJKx1o9eVWnzMK2ImzQtYfrl+dRszLVCIZ+1rll/6hGivkfx
 /UL85aSccw9pvQKh2Y0dAMrwN87yDv4fSpX3lRezq0VajnbmotDUUCPn8tzLJK8UI40Y
 k51g==
X-Gm-Message-State: AOAM532iJCUi+J+Ntn+9u0yk5EJJGVCJCLrYT/WgfF5O4DaT7J+QjNqy
 NDQDzwzOd3B0ricWZSBTD1vv1Z67K0iXBWrf9KKf4PcaYTvYOF8piVj96EFvRu567ckqy13nwJ3
 wXvqDhlBMG8/uxeZIfuFBcL5UQ/ylqPk=
X-Received: by 2002:a05:6512:318f:b0:448:6eab:df4c with SMTP id
 i15-20020a056512318f00b004486eabdf4cmr16257191lfe.493.1647908511886; 
 Mon, 21 Mar 2022 17:21:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8fWlMlOrISKz5e6AHxIlJyqFUNk2WeAtStxLOxXUVASr9IclvyIDcHK+DtLf+ZuMWztqMKbMYl302bapW0zA=
X-Received: by 2002:a05:6512:318f:b0:448:6eab:df4c with SMTP id
 i15-20020a056512318f00b004486eabdf4cmr16257182lfe.493.1647908511679; Mon, 21
 Mar 2022 17:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-5-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-5-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:21:40 -0500
Message-ID: <CAPt1nt6CoCRGYRtqzaF63HFGQBihGem3uzm3ExCKKm4PXBOw9g@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2 04/11] multipathd: reset
 __delayed_reconfig from ev_add_map()
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
> With the previous patch, one race condition between child() and
> the uevent handler (ev_add_map()) remains: 1. child() sets
> __delayed_reconfig, 2. ev_add_map() calls schedule_reconfigure() and
> thus DAEMON_CONFIGURE, 3. child() sets DAEMON_IDLE. This would cause
> the pending reconfigure request to be missed.
>
> To fix this, reset __delayed_reconfig immediately from ev_add_map()
> (and likewise, missing_uev_wait_tick()). This way the wait loop in
> child() terminates on the reconfigure_pending condition.
>
> Also, these schedule_reconfigure() callers don't really request a
> reconfigure() call; they just unblock processing previously requested
> reconfigure() calls. Add a new helper, unblock_reconfigure(), that
> does just that.
>
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 45 +++++++++++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 20 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d033a9a..1454a18 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -155,16 +155,6 @@ int should_exit(void)
>         return get_running_state() == DAEMON_SHUTDOWN;
>  }
>
> -static bool get_delayed_reconfig(void)
> -{
> -       bool val;
> -
> -       pthread_mutex_lock(&config_lock);
> -       val = __delayed_reconfig;
> -       pthread_mutex_unlock(&config_lock);
> -       return val;
> -}
> -
>  /*
>   * global copy of vecs for use in sig handlers
>   */
> @@ -308,6 +298,27 @@ void post_config_state(enum daemon_status state)
>         pthread_cleanup_pop(1);
>  }
>
> +static bool unblock_reconfigure(void)
> +{
> +       bool was_delayed;
> +
> +       pthread_mutex_lock(&config_lock);
> +       was_delayed = __delayed_reconfig;
> +       if (was_delayed) {
> +               __delayed_reconfig = false;
> +               /*
> +                * In IDLE state, make sure child() is woken up
> +                * Otherwise it will wake up when state switches to IDLE
> +                */
> +               if (running_state == DAEMON_IDLE)
> +                       __post_config_state(DAEMON_CONFIGURE);
> +       }
> +       pthread_mutex_unlock(&config_lock);
> +       if (was_delayed)
> +               condlog(3, "unblocked delayed reconfigure");
> +       return was_delayed;
> +}
> +
>  void schedule_reconfigure(enum force_reload_types requested_type)
>  {
>         pthread_mutex_lock(&config_lock);
> @@ -790,12 +801,9 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
>                 dm_get_info(mpp->alias, &mpp->dmi);
>                 if (mpp->wait_for_udev) {
>                         mpp->wait_for_udev = 0;
> -                       if (get_delayed_reconfig() &&
> -                           !need_to_delay_reconfig(vecs)) {
> -                               condlog(2, "reconfigure (delayed)");
> -                               schedule_reconfigure(FORCE_RELOAD_WEAK);
> +                       if (!need_to_delay_reconfig(vecs) &&
> +                           unblock_reconfigure())
>                                 return 0;
> -                       }
>                 }
>                 /*
>                  * Not really an error -- we generate our own uevent
> @@ -1899,11 +1907,8 @@ missing_uev_wait_tick(struct vectors *vecs)
>                 }
>         }
>
> -       if (timed_out && get_delayed_reconfig() &&
> -           !need_to_delay_reconfig(vecs)) {
> -               condlog(2, "reconfigure (delayed)");
> -               schedule_reconfigure(FORCE_RELOAD_WEAK);
> -       }
> +       if (timed_out && !need_to_delay_reconfig(vecs))
> +               unblock_reconfigure();
>  }
>
>  static void
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

