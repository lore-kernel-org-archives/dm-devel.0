Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D6A7C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685643474;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c5wksYtOe6l2+Ag7MGZ+cPLehmo+vA6kfN6Z8oyTWwo=;
	b=WddI2T2YPZGLaIFP+uN5Jh9au8VG0uGqY9BHFKIDJPKMSsV2betgOqKjjAGxxWQQ5pxO8y
	9lJGmhJ/5YztrAywbtfncjZ3lET+QXLbdKapZkpt5ZpxVCFfd7I+W3nqPSDYIFe1troOqF
	G+qRKqTKAphGfEj4Wh81iGgCWTH7QyA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-rbbznj4DPM6tJiVQwJCvWQ-1; Thu, 01 Jun 2023 14:17:51 -0400
X-MC-Unique: rbbznj4DPM6tJiVQwJCvWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C924B858EEB;
	Thu,  1 Jun 2023 18:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47FCF9E75;
	Thu,  1 Jun 2023 18:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 13C6719465A0;
	Thu,  1 Jun 2023 18:17:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77E0F194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 18:17:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C2BBDC154DA; Thu,  1 Jun 2023 18:17:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B84BC154D7;
 Thu,  1 Jun 2023 18:17:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 351IHJSw023998;
 Thu, 1 Jun 2023 13:17:19 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 351IHIp4023997;
 Thu, 1 Jun 2023 13:17:18 -0500
Date: Thu, 1 Jun 2023 13:17:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230601181718.GO24096@octiron.msp.redhat.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-6-git-send-email-bmarzins@redhat.com>
 <a84a184d9e7624a6377ecfcab4d9f7c01d06d975.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <a84a184d9e7624a6377ecfcab4d9f7c01d06d975.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: add "detect_pgpolicy"
 config option
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 03:44:58PM +0000, Martin Wilck wrote:
> On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> > This allows configuations to use "group_by_tpg" if alua is
> > autodetected
> > and another policy if it isn't, so they can work with detect_prio.
>=20
> This is a bit confusing. We might have introduced this kind of
> autodetection without group_by_tpg; using group_by_prio for arrays with
> ALUA support would have made quite a bit of sense.

I guess that all depends on what the autodetection is for.  If the goal
for ALUA autodetection is to make it possible to write configs that
support arrays which have an optional ALUA mode, then I don't think this
is necessary.  All those arrays should be configured with group_by_prio,
regardless of whether or not they are in ALUA mode.

But we've moved more towards adding autodetection to make multipath work
correctly, even without a config for a specific array. In this case,
yes, if we autodetect ALUA, if would be nice if we could
automatically set group_by_prio.

> What this patch really does is to make multipath-tools prefer
> group_by_tpg over group_by_prio if it finds that ALUA is supported.=A0
> Should this be a separate option, perhaps?
>=20
>  - detect_pgpolicy: use an ALUA-based pgpolicy if available
>  - detect_pgpolicy_prefer_tpg: prefer group_by_tpg over group_by_prio
>    for arrays supporting ALUA.
>=20
> This way users could benefit from ALUA autodetection without switching
> to the TPG algorithm automatically.

Sure. Lets go with that. I'll respin this.

> Or do we have good arguments that group_by_tpg is always "better" than
> group_by_prio if ALUA is supported? I guess it might be, but it still
> needs to prove its usefulness it practice.

I would also rather it proved itself first. That's why I had it disabled
by default. We can always switch the default later.

> Also, if we add the auto-detection feature, I think it should default
> to ON, at least upstream.

I don't know of any case where you would need FAILOVER, when you have an
ALUA device.  I can imagine someone wanting to be able to turn off
load-balancing, but I think it makes sense to enable this by default
upstream.

>=20
> Regards,
> Martin
>=20
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 ++
> > =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 ++
> > =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 11 +=
++++++++++
> > =A0libmultipath/hwtable.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/libmultipath.version | 10 +++-------
> > =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 23 +++++++=
+++++++++++++++-
> > =A0libmultipath/propsel.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 7 +++++=
++
> > =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 | 12 ++++++++++++
> > =A011 files changed, 63 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 5c5c0726..2e742373 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -452,6 +452,7 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> > src)
> > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(retain_hwhandler);
> > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(detect_prio);
> > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(detect_checker);
> > +=A0=A0=A0=A0=A0=A0=A0merge_num(detect_pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(deferred_remove);
> > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(delay_watch_checks);
> > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(delay_wait_checks);
> > @@ -617,6 +618,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
> > =A0=A0=A0=A0=A0=A0=A0=A0hwe->retain_hwhandler =3D dhwe->retain_hwhandle=
r;
> > =A0=A0=A0=A0=A0=A0=A0=A0hwe->detect_prio =3D dhwe->detect_prio;
> > =A0=A0=A0=A0=A0=A0=A0=A0hwe->detect_checker =3D dhwe->detect_checker;
> > +=A0=A0=A0=A0=A0=A0=A0hwe->detect_pgpolicy =3D dhwe->detect_pgpolicy;
> > =A0=A0=A0=A0=A0=A0=A0=A0hwe->ghost_delay =3D dhwe->ghost_delay;
> > =A0=A0=A0=A0=A0=A0=A0=A0hwe->vpd_vendor_id =3D dhwe->vpd_vendor_id;
> > =A0
> > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > index 87947469..014c6849 100644
> > --- a/libmultipath/config.h
> > +++ b/libmultipath/config.h
> > @@ -76,6 +76,7 @@ struct hwentry {
> > =A0=A0=A0=A0=A0=A0=A0=A0int retain_hwhandler;
> > =A0=A0=A0=A0=A0=A0=A0=A0int detect_prio;
> > =A0=A0=A0=A0=A0=A0=A0=A0int detect_checker;
> > +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> > =A0=A0=A0=A0=A0=A0=A0=A0int deferred_remove;
> > =A0=A0=A0=A0=A0=A0=A0=A0int delay_watch_checks;
> > =A0=A0=A0=A0=A0=A0=A0=A0int delay_wait_checks;
> > @@ -171,6 +172,7 @@ struct config {
> > =A0=A0=A0=A0=A0=A0=A0=A0int retain_hwhandler;
> > =A0=A0=A0=A0=A0=A0=A0=A0int detect_prio;
> > =A0=A0=A0=A0=A0=A0=A0=A0int detect_checker;
> > +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> > =A0=A0=A0=A0=A0=A0=A0=A0int force_sync;
> > =A0=A0=A0=A0=A0=A0=A0=A0int deferred_remove;
> > =A0=A0=A0=A0=A0=A0=A0=A0int processed_main_config;
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 4a1c28bb..366b166f 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -304,6 +304,7 @@ int setup_map(struct multipath *mpp, char
> > **params, struct vectors *vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_multipath_config, conf=
);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0select_pgfailback(conf, mpp);
> > +=A0=A0=A0=A0=A0=A0=A0select_detect_pgpolicy(conf, mpp);
> > =A0=A0=A0=A0=A0=A0=A0=A0select_pgpolicy(conf, mpp);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> > index a5e9ea0c..090baa5c 100644
> > --- a/libmultipath/defaults.h
> > +++ b/libmultipath/defaults.h
> > @@ -29,6 +29,7 @@
> > =A0#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
> > =A0#define DEFAULT_DETECT_PRIO=A0=A0=A0=A0DETECT_PRIO_ON
> > =A0#define DEFAULT_DETECT_CHECKER=A0DETECT_CHECKER_ON
> > +#define DEFAULT_DETECT_PGPOLICY=A0=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY=
_OFF
> > =A0#define DEFAULT_DEFERRED_REMOVE=A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMO=
VE_OFF
> > =A0#define DEFAULT_DELAY_CHECKS=A0=A0=A0NU_NO
> > =A0#define DEFAULT_ERR_CHECKS=A0=A0=A0=A0=A0NU_NO
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index dddd3cd6..edd4923d 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -868,6 +868,14 @@ declare_ovr_snprint(detect_checker,
> > print_yes_no_undef)
> > =A0declare_hw_handler(detect_checker, set_yes_no_undef)
> > =A0declare_hw_snprint(detect_checker, print_yes_no_undef)
> > =A0
> > +declare_def_handler(detect_pgpolicy, set_yes_no_undef)
> > +declare_def_snprint_defint(detect_pgpolicy, print_yes_no_undef,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 DEFAULT_DETECT_PGPOLICY)
> > +declare_ovr_handler(detect_pgpolicy, set_yes_no_undef)
> > +declare_ovr_snprint(detect_pgpolicy, print_yes_no_undef)
> > +declare_hw_handler(detect_pgpolicy, set_yes_no_undef)
> > +declare_hw_snprint(detect_pgpolicy, print_yes_no_undef)
> > +
> > =A0declare_def_handler(force_sync, set_yes_no)
> > =A0declare_def_snprint(force_sync, print_yes_no)
> > =A0
> > @@ -2112,6 +2120,7 @@ init_keywords(vector keywords)
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("retain_attached_hw_handler",
> > &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &def_detect_prio=
_handler,
> > &snprint_def_detect_prio);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker",
> > &def_detect_checker_handler, &snprint_def_detect_checker);
> > +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> > &def_detect_pgpolicy_handler, &snprint_def_detect_pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("force_sync", &def_force_sync_h=
andler,
> > &snprint_def_force_sync);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("strict_timing", &def_strict_ti=
ming_handler,
> > &snprint_def_strict_timing);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> > &def_deferred_remove_handler, &snprint_def_deferred_remove);
> > @@ -2202,6 +2211,7 @@ init_keywords(vector keywords)
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("retain_attached_hw_handler",
> > &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &hw_detect_prio_=
handler,
> > &snprint_hw_detect_prio);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker", &hw_detect_ch=
ecker_handler,
> > &snprint_hw_detect_checker);
> > +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> > &hw_detect_pgpolicy_handler, &snprint_hw_detect_pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> > &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_watch_checks",
> > &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_wait_checks",
> > &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
> > @@ -2244,6 +2254,7 @@ init_keywords(vector keywords)
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("retain_attached_hw_handler",
> > &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &ovr_detect_prio=
_handler,
> > &snprint_ovr_detect_prio);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker",
> > &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
> > +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> > &ovr_detect_pgpolicy_handler, &snprint_ovr_detect_pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> > &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_watch_checks",
> > &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
> > =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_wait_checks",
> > &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 65bca744..803230c1 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -67,6 +67,7 @@
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.retain_hwhandler =3D R=
ETAIN_HWHANDLER_ON,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_prio=A0=A0 =3D =
DETECT_PRIO_ON,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_checker =3D DET=
ECT_CHECKER_ON,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_pgpolicy =3D DETE=
CT_PGPOLICY_OFF,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.deferred_remove =3D DE=
FERRED_REMOVE_OFF,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_watch_checks =3D=
 DELAY_CHECKS_OFF,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_wait_checks =3D =
DELAY_CHECKS_OFF,
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index aba1a30e..8f72c452 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> > =A0=A0=A0=A0=A0=A0=A0=A0put_multipath_config;
> > =A0};
> > =A0
> > -LIBMULTIPATH_18.0.0 {
> > +LIBMULTIPATH_19.0.0 {
> > =A0global:
> > =A0=A0=A0=A0=A0=A0=A0=A0/* symbols referenced by multipath and multipat=
hd */
> > =A0=A0=A0=A0=A0=A0=A0=A0add_foreign;
> > @@ -116,6 +116,7 @@ global:
> > =A0=A0=A0=A0=A0=A0=A0=A0get_refwwid;
> > =A0=A0=A0=A0=A0=A0=A0=A0get_state;
> > =A0=A0=A0=A0=A0=A0=A0=A0get_udev_device;
> > +=A0=A0=A0=A0=A0=A0=A0get_uid;
> > =A0=A0=A0=A0=A0=A0=A0=A0get_used_hwes;
> > =A0=A0=A0=A0=A0=A0=A0=A0get_vpd_sgio;
> > =A0=A0=A0=A0=A0=A0=A0=A0group_by_prio;
> > @@ -141,6 +142,7 @@ global:
> > =A0=A0=A0=A0=A0=A0=A0=A0pathcount;
> > =A0=A0=A0=A0=A0=A0=A0=A0path_discovery;
> > =A0=A0=A0=A0=A0=A0=A0=A0path_get_tpgs;
> > +=A0=A0=A0=A0=A0=A0=A0pathinfo;
> > =A0=A0=A0=A0=A0=A0=A0=A0path_offline;
> > =A0=A0=A0=A0=A0=A0=A0=A0print_all_paths;
> > =A0=A0=A0=A0=A0=A0=A0=A0print_foreign_topology;
> > @@ -235,9 +237,3 @@ global:
> > =A0local:
> > =A0=A0=A0=A0=A0=A0=A0=A0*;
> > =A0};
> > -
> > -LIBMULTIPATH_18.1.0 {
> > -global:
> > -=A0=A0=A0=A0=A0=A0=A0get_uid;
> > -=A0=A0=A0=A0=A0=A0=A0pathinfo;
> > -} LIBMULTIPATH_18.0.0;
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index d214281b..12f4825d 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -265,6 +265,21 @@ verify_alua_prio(struct multipath *mp)
> > =A0=A0=A0=A0=A0=A0=A0=A0return true;
> > =A0}
> > =A0
> > +int select_detect_pgpolicy(struct config *conf, struct multipath
> > *mp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const char *origin;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(detect_pgpolicy);
> > +=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(detect_pgpolicy);
> > +=A0=A0=A0=A0=A0=A0=A0mp_set_conf(detect_pgpolicy);
> > +=A0=A0=A0=A0=A0=A0=A0mp_set_default(detect_pgpolicy, DEFAULT_DETECT_PG=
POLICY);
> > +out:
> > +=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: detect_pgpolicy =3D %s %s", mp->a=
lias,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(mp->detect_pgpolicy =3D=
=3D DETECT_PGPOLICY_ON)? "yes" :
> > "no",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 origin);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > =A0int select_pgpolicy(struct config *conf, struct multipath * mp)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> > @@ -275,13 +290,19 @@ int select_pgpolicy(struct config *conf, struct
> > multipath * mp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D cmdline_orig=
in;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (mp->detect_pgpolicy =3D=3D DETECT_PGPOLICY_ON=
 &&
> > verify_alua_prio(mp)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D GROUP_BY=
_TPG;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D autodetect_ori=
gin;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0mp_set_conf(pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> > =A0out:
> > -=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && !verify_a=
lua_prio(mp)) {
> > +=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && origin !=
=3D
> > autodetect_origin &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !verify_alua_prio(mp)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D DEFAUL=
T_PGPOLICY;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D "(setting: e=
mergency fallback - not all
> > paths use alua prio)";
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_prio =3D 1;
> > diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> > index 152ca44c..513ee6ac 100644
> > --- a/libmultipath/propsel.h
> > +++ b/libmultipath/propsel.h
> > @@ -1,5 +1,6 @@
> > =A0int select_rr_weight (struct config *conf, struct multipath * mp);
> > =A0int select_pgfailback (struct config *conf, struct multipath * mp);
> > +int select_detect_pgpolicy (struct config *conf, struct multipath *
> > mp);
> > =A0int select_pgpolicy (struct config *conf, struct multipath * mp);
> > =A0int select_selector (struct config *conf, struct multipath * mp);
> > =A0int select_alias (struct config *conf, struct multipath * mp);
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 0eea19b4..682a7e17 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -143,6 +143,12 @@ enum detect_checker_states {
> > =A0=A0=A0=A0=A0=A0=A0=A0DETECT_CHECKER_ON =3D YNU_YES,
> > =A0};
> > =A0
> > +enum detect_pgpolicy_states {
> > +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_UNDEF =3D YNU_UNDEF,
> > +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_OFF =3D YNU_NO,
> > +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_ON =3D YNU_YES,
> > +};
> > +
> > =A0enum deferred_remove_states {
> > =A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE_UNDEF =3D YNU_UNDEF,
> > =A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE_OFF =3D YNU_NO,
> > @@ -389,6 +395,7 @@ enum prflag_value {
> > =A0struct multipath {
> > =A0=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> > =A0=A0=A0=A0=A0=A0=A0=A0char alias_old[WWID_SIZE];
> > +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> > =A0=A0=A0=A0=A0=A0=A0=A0int pgpolicy;
> > =A0=A0=A0=A0=A0=A0=A0=A0pgpolicyfn *pgpolicyfn;
> > =A0=A0=A0=A0=A0=A0=A0=A0int nextpg;
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index b65a543d..9f8be510 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -242,6 +242,18 @@ The default is: \fBfailover\fR
> > =A0.
> > =A0.
> > =A0.TP
> > +.B detect_pgpolicy
> > +If set to \fIyes\fR and all path devcices are configured with either
> > the
> > +\fIalua\fR or \fIsysfs\fR prioritizer, the multipath device will
> > automatically
> > +use the \fIgroup_by_tpg\fR path_grouping_policy. If set to \fIno\fR,
> > the
> > +path_grouping_policy will be selected as usual.
> > +.RS
> > +.TP
> > +The default is: \fIno\fR
> > +.RE
> > +.
> > +.
> > +.TP
> > =A0.B pg_timeout
> > =A0(Deprecated) This option is not supported any more, and the value is
> > ignored.
> > =A0.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

