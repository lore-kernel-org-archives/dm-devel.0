Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C43C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 19:14:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-CzCjhhwtPK-ixAlnUYS0Fw-1; Mon, 09 May 2022 15:14:43 -0400
X-MC-Unique: CzCjhhwtPK-ixAlnUYS0Fw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6804E101B44C;
	Mon,  9 May 2022 19:14:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D4D6415F56;
	Mon,  9 May 2022 19:14:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA65F1947052;
	Mon,  9 May 2022 19:14:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3723C1947051
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 19:14:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24AE77B64; Mon,  9 May 2022 19:14:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 207337AF2
 for <dm-devel@redhat.com>; Mon,  9 May 2022 19:14:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09B3180B719
 for <dm-devel@redhat.com>; Mon,  9 May 2022 19:14:39 +0000 (UTC)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
 [209.85.167.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-3AdHJcTrPk27Fqa3lxKwuQ-1; Mon, 09 May 2022 15:14:37 -0400
X-MC-Unique: 3AdHJcTrPk27Fqa3lxKwuQ-1
Received: by mail-lf1-f47.google.com with SMTP id h29so25531726lfj.2
 for <dm-devel@redhat.com>; Mon, 09 May 2022 12:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to;
 bh=ZP+FMR0U/uuu+vArCOTUPD2wz/xOel1tL0yRlZpwU3s=;
 b=YNDc/qJABDOBCPj3bb4SzPrBF5V61iOpGD5pF71RPVWFu4LP1hWCWWQXhUt2916FG/
 9uJOVP+/7eZQbKebhTaJ+GDwVjdXkd5HfsW0VeTTJwQR9mO8ctz7tko91VD1LXtW3c1S
 sT7ygUZa2yeAs99cqyu369JIALLNrlxRyvom5f/7cl6/4LvyrMxGcQH7t404lTu1pLNL
 ZRHyaryj8YKZOth6y4LnO23yaByZCJToK3JwEkMY+rwMSsyEoDXR8MvxoLWxPGS8Aal4
 Nuki+LRdcpLhitsIKDkNyVDHBtIgP5MfMpYM3Y+edW6BcmVfa4S6LqhRUnHmvCsjk18Z
 Mo6w==
X-Gm-Message-State: AOAM530kOvhuB2pVjSPVhXde+oAA4WT3XtlK/N12vSpg6XPdGISV6N86
 r9A6C7pIn+eZbKGkTJYJcQbDbilzaPfHAos7WdH/oo9Ccj9VFw==
X-Google-Smtp-Source: ABdhPJzi8jBUzaMUdA79DNs4VCcPZw9tar+WH34pRsTs4MWlEZKFA/Q563J/IM9ASNT9xi8AqRZoYBi74DvEhGmpw5A=
X-Received: by 2002:a05:6512:13a9:b0:448:9dd3:b84 with SMTP id
 p41-20020a05651213a900b004489dd30b84mr13634348lfa.556.1652123675670; Mon, 09
 May 2022 12:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxyLeK6L_wtGr=YN6AYPq1CucozjpTPHf194jxUiH=RyzOg@mail.gmail.com>
 <20220430023108.GQ24684@octiron.msp.redhat.com>
In-Reply-To: <20220430023108.GQ24684@octiron.msp.redhat.com>
From: Brian Bunker <brian@purestorage.com>
Date: Mon, 9 May 2022 12:14:24 -0700
Message-ID: <CAHZQxy+SkZVL3xiQg0D1RxoViv3g+dpis65Df1Q_r+fwtiVnvw@mail.gmail.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
 device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This did work, but I agree, it is not the best approach. I was looking
for a backstop in case I could not get the kernel change that was the
real fix to the issue. I wanted to give a solution to our customers
who would upgrade into the problem. Having multitpath-tools dealing
with a fail path that isn't really a fail path is clumsy at best. The
kernel fix got in here:

https://git.kernel.org/mkp/scsi/c/6056a92ceb2a

So this patch is no longer needed.

Thanks,
Brian

On Fri, Apr 29, 2022 at 7:31 PM Benjamin Marzinski <bmarzins@redhat.com> wrote:
>
> On Mon, Apr 18, 2022 at 02:54:15PM -0700, Brian Bunker wrote:
> > With the kernel commit 268940b80fa4096397fd0a28e6ad807e64120215, the
> > handling of ALUA state transitioning state changed. It used to be that
> > paths which returned with ALUA transitioning state would not result in
> > those paths being failed. With this patch, that state returned will
> > result in the path being failed. The result of this will result in all
> > paths down events when a configuration has the no_path_retry set to 0.
> > Before this kernel change that same configuration would not reach all
> > paths down.
> >
> > If the kernel is not changed back to the previous behavior, the
> > multipath-tools have to protect against this condition or
> > configurations which were working correctly prior to the kernel change
> > will lead to an unexpected failure.
>
> Unless I'm missing something, this patch isn't going to be helpful. It
> doesn't configure the multipath device to queue IOs before the failure.
> When the kernel runs out of paths, it will see that the mutltipath
> device has no paths and isn't set to queue, and it will fail the IOs.
> After the paths come back up again, multipath will enable queueing in
> update_queue_mode_add_path().  But it's too late by then. The IOs will
> have already been failed.
>
> Another issue is that the patch is doing scsi specific work in code
> meant for general block devices. Finally, It's seems pointless to set
> the device to queue when all the paths go away and the turn off queueing
> when the paths come back. no_path_retry doesn't do anything when there
> are paths, so if it's necessary to set when the paths are gone, it won't
> hurt anything to be set when the paths are present. I understand that
> you only want to do this for devices in the ALUA transtitioning state,
> but the only why to make this actually help is if multipathd enables
> queueing before the device ever gets into that state.
>
> The only really safe thing to do would be to set no_path_retry to
> something other than 0 or NO_PATH_RETRY_QUEUE. This can already be done
> in the configuration files. But I agree that failing in IOs because the
> device is transitioning seems wrong in the first place, and fixing this
> in the kernel makes sense.
>
> > See the kernel discussions here:
> > https://marc.info/?l=linux-scsi&m=162636826305740&w=2
> > https://marc.info/?l=linux-scsi&m=164987222322261&w=2
> >
> > Signed-off-by: brian@purestorage.com
> > Reviewed-by: sconnor@purestorage.com
> > ___
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index d94f93a0..0af7e598 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -370,6 +370,7 @@ struct multipath {
> >         int failback_tick;
> >
> >         int no_path_retry; /* number of retries after all paths are down */
> > +       int no_path_retry_configured; /* value in config */
> >         int retry_tick;    /* remaining times for retries */
> >         int disable_queueing;
> >         int minio;
> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index 6c23df86..3db4e6f7 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -780,8 +780,15 @@ void update_queue_mode_add_path(struct multipath *mpp)
> >  {
> >         int active = count_active_paths(mpp);
> >
> > -       if (active > 0)
> > +       if (active > 0) {
> >                 leave_recovery_mode(mpp);
> > +               if (mpp->no_path_retry != mpp->no_path_retry_configured) {
> > +                       condlog(2, "%s: return no path retry to %d
> > from %d", mpp->alias,
> > +                       mpp->no_path_retry_configured, mpp->no_path_retry);
> > +                       mpp->no_path_retry = mpp->no_path_retry_configured;
> > +               }
> > +       }
> > +
> >         condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
> >  }
> >
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index f2c0b280..92841d13 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -524,7 +524,7 @@ int update_multipath (struct vectors *vecs, char
> > *mapname, int reset)
> >         struct multipath *mpp;
> >         struct pathgroup  *pgp;
> >         struct path *pp;
> > -       int i, j;
> > +       int i, j, tpg;
> >
> >         mpp = find_mp_by_alias(vecs->mpvec, mapname);
> >
> > @@ -553,6 +553,15 @@ int update_multipath (struct vectors *vecs, char
> > *mapname, int reset)
> >                                 checkint = conf->checkint;
> >                                 put_multipath_config(conf);
> >                                 condlog(2, "%s: mark as failed", pp->dev);
> > +                               tpg = get_target_port_group(pp, DEF_TIMEOUT);
> > +                               if ((tpg >= 0) &&
> > +                                   (mpp->no_path_retry == 0) &&
> > +                                   (get_asymmetric_access_state(pp,
> > tpg, DEF_TIMEOUT) == AAS_TRANSITIONING)) {
> > +                                       mpp->no_path_retry_configured
> > = mpp->no_path_retry;
> > +                                       mpp->no_path_retry = (60 / checkint);
> > +                                       condlog(2, "%s: changed %s no
> > path retry to %d", pp->dev, mpp->alias,
> > +                                               (60 / checkint));
> > +                               }
> >                                 mpp->stat_path_failures++;
> >                                 pp->state = PATH_DOWN;
> >                                 if (oldstate == PATH_UP ||
> > ___
> >
> > --
> > Brian Bunker
> > PURE Storage, Inc.
> > brian@purestorage.com
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://listman.redhat.com/mailman/listinfo/dm-devel
>


-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

