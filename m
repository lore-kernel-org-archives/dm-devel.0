Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02DDBC433EF
	for <dm-devel@archiver.kernel.org>; Sat, 30 Apr 2022 02:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651285879;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p1DQJ184EinYjcuPMuVRkoRFuQWo1K/ZArd21Fp8Zb8=;
	b=GaVi5JDKJeMA0Qm7YVb2ewSKIoKpdZXmpO0DH9o3ytow1v5A8GXQBYYfcJQ1MdE3BGLI+A
	3lrhE6ti7Sfu/s0Wvq3g5jxXjFnzVUwZuHP1QG3JoH5kl2A8F0DCLii6R222Fqoq3aC5i7
	dnkAuAkt1xoxL+3p/5/+1tqBfXAIryE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-FJHRE6c0NIW2Oeit3lGkDA-1; Fri, 29 Apr 2022 22:31:16 -0400
X-MC-Unique: FJHRE6c0NIW2Oeit3lGkDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9E7C185A7A4;
	Sat, 30 Apr 2022 02:31:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE38F40CF8F4;
	Sat, 30 Apr 2022 02:31:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7173F1947057;
	Sat, 30 Apr 2022 02:31:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADD851947050
 for <dm-devel@listman.corp.redhat.com>; Sat, 30 Apr 2022 02:31:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A0897C44AE9; Sat, 30 Apr 2022 02:31:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 081CAC44AE1;
 Sat, 30 Apr 2022 02:31:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23U2V8kK030784;
 Fri, 29 Apr 2022 21:31:09 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23U2V8VQ030783;
 Fri, 29 Apr 2022 21:31:08 -0500
Date: Fri, 29 Apr 2022 21:31:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Message-ID: <20220430023108.GQ24684@octiron.msp.redhat.com>
References: <CAHZQxyLeK6L_wtGr=YN6AYPq1CucozjpTPHf194jxUiH=RyzOg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHZQxyLeK6L_wtGr=YN6AYPq1CucozjpTPHf194jxUiH=RyzOg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] multipath-tools: prevent a kernel upgrade
 leading to all paths lost
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
Cc: device-mapper development <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 18, 2022 at 02:54:15PM -0700, Brian Bunker wrote:
> With the kernel commit 268940b80fa4096397fd0a28e6ad807e64120215, the
> handling of ALUA state transitioning state changed. It used to be that
> paths which returned with ALUA transitioning state would not result in
> those paths being failed. With this patch, that state returned will
> result in the path being failed. The result of this will result in all
> paths down events when a configuration has the no_path_retry set to 0.
> Before this kernel change that same configuration would not reach all
> paths down.
> 
> If the kernel is not changed back to the previous behavior, the
> multipath-tools have to protect against this condition or
> configurations which were working correctly prior to the kernel change
> will lead to an unexpected failure.

Unless I'm missing something, this patch isn't going to be helpful. It
doesn't configure the multipath device to queue IOs before the failure.
When the kernel runs out of paths, it will see that the mutltipath
device has no paths and isn't set to queue, and it will fail the IOs.
After the paths come back up again, multipath will enable queueing in
update_queue_mode_add_path().  But it's too late by then. The IOs will
have already been failed.

Another issue is that the patch is doing scsi specific work in code
meant for general block devices. Finally, It's seems pointless to set
the device to queue when all the paths go away and the turn off queueing
when the paths come back. no_path_retry doesn't do anything when there
are paths, so if it's necessary to set when the paths are gone, it won't
hurt anything to be set when the paths are present. I understand that
you only want to do this for devices in the ALUA transtitioning state,
but the only why to make this actually help is if multipathd enables
queueing before the device ever gets into that state. 

The only really safe thing to do would be to set no_path_retry to
something other than 0 or NO_PATH_RETRY_QUEUE. This can already be done
in the configuration files. But I agree that failing in IOs because the
device is transitioning seems wrong in the first place, and fixing this
in the kernel makes sense.
 
> See the kernel discussions here:
> https://marc.info/?l=linux-scsi&m=162636826305740&w=2
> https://marc.info/?l=linux-scsi&m=164987222322261&w=2
> 
> Signed-off-by: brian@purestorage.com
> Reviewed-by: sconnor@purestorage.com
> ___
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index d94f93a0..0af7e598 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -370,6 +370,7 @@ struct multipath {
>         int failback_tick;
> 
>         int no_path_retry; /* number of retries after all paths are down */
> +       int no_path_retry_configured; /* value in config */
>         int retry_tick;    /* remaining times for retries */
>         int disable_queueing;
>         int minio;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 6c23df86..3db4e6f7 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -780,8 +780,15 @@ void update_queue_mode_add_path(struct multipath *mpp)
>  {
>         int active = count_active_paths(mpp);
> 
> -       if (active > 0)
> +       if (active > 0) {
>                 leave_recovery_mode(mpp);
> +               if (mpp->no_path_retry != mpp->no_path_retry_configured) {
> +                       condlog(2, "%s: return no path retry to %d
> from %d", mpp->alias,
> +                       mpp->no_path_retry_configured, mpp->no_path_retry);
> +                       mpp->no_path_retry = mpp->no_path_retry_configured;
> +               }
> +       }
> +
>         condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
>  }
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f2c0b280..92841d13 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -524,7 +524,7 @@ int update_multipath (struct vectors *vecs, char
> *mapname, int reset)
>         struct multipath *mpp;
>         struct pathgroup  *pgp;
>         struct path *pp;
> -       int i, j;
> +       int i, j, tpg;
> 
>         mpp = find_mp_by_alias(vecs->mpvec, mapname);
> 
> @@ -553,6 +553,15 @@ int update_multipath (struct vectors *vecs, char
> *mapname, int reset)
>                                 checkint = conf->checkint;
>                                 put_multipath_config(conf);
>                                 condlog(2, "%s: mark as failed", pp->dev);
> +                               tpg = get_target_port_group(pp, DEF_TIMEOUT);
> +                               if ((tpg >= 0) &&
> +                                   (mpp->no_path_retry == 0) &&
> +                                   (get_asymmetric_access_state(pp,
> tpg, DEF_TIMEOUT) == AAS_TRANSITIONING)) {
> +                                       mpp->no_path_retry_configured
> = mpp->no_path_retry;
> +                                       mpp->no_path_retry = (60 / checkint);
> +                                       condlog(2, "%s: changed %s no
> path retry to %d", pp->dev, mpp->alias,
> +                                               (60 / checkint));
> +                               }
>                                 mpp->stat_path_failures++;
>                                 pp->state = PATH_DOWN;
>                                 if (oldstate == PATH_UP ||
> ___
> 
> -- 
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

