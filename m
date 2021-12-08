Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6E2C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  8 Dec 2021 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638981384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=yj0WxSO55+WnZ5Ax/7AvPo5Vdp08URhwHOWcL9jP4tU=;
	b=SSREDkrvwmOrcti1Ab+GogzkiKCvEcKNCEx1k6bC+vAdsgNH/lGBF7S3nm/AFPYPyvS/fL
	L3Tu5LD8ZGfVkhAXW2h+x2YaEfjJgVlpLBDwhY4tr7Pf9cunBBZMR/196kEKLCsubK/Jm4
	p5oOGlupUV63sbGaUXuae/HziktBEfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-_045AydDOLOZKo0FjvV2Fw-1; Wed, 08 Dec 2021 11:36:21 -0500
X-MC-Unique: _045AydDOLOZKo0FjvV2Fw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FE99100E326;
	Wed,  8 Dec 2021 16:36:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A479C2B178;
	Wed,  8 Dec 2021 16:35:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4EDA64BB7C;
	Wed,  8 Dec 2021 16:35:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B8GZgrE006772 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Dec 2021 11:35:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4B5BF4047279; Wed,  8 Dec 2021 16:35:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46EE84047272
	for <dm-devel@redhat.com>; Wed,  8 Dec 2021 16:35:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E83E3C9A01C
	for <dm-devel@redhat.com>; Wed,  8 Dec 2021 16:35:42 +0000 (UTC)
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
	[209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-408-vRgB6tgbMBm8zJj4vCQVpw-1; Wed, 08 Dec 2021 11:35:40 -0500
X-MC-Unique: vRgB6tgbMBm8zJj4vCQVpw-1
Received: by mail-yb1-f199.google.com with SMTP id
	j204-20020a2523d5000000b005c21574c704so5330495ybj.13
	for <dm-devel@redhat.com>; Wed, 08 Dec 2021 08:35:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=tfdztpqLpq7mVcQWH5ACSyTsyMy1N13SZdYi9Un4YOA=;
	b=bCZn4uk8OQqz9JoCnyT/WUfk8b89kOGfylpTVEtDNdGSU9eh4tfaIuwUOMXdjlxUh5
	8X46H0sVqL0coc0p9GBggfMq1YKV/xis/MVIE5JsUSSi0a6/rWZYzkC48qjGTA3p7B74
	urodHJYsMmN41JNW/oa/Mr2uuHRk1Jo9+45mbeUbgKTHC4l6yf2kzcKUdi0y8xt52gj+
	rsQfT9j3om304Y9FzUgI6kjfp0WT5wwZ8Vyg6urccsqpoZnB8WxHeTlkU/Sj/26Cf8ih
	0raxWB1pVEVrQCVJp+ml443WVzfl/S0UJ/6DU/WI0q0pqbZkTcOSEv0bjEZte6GfPyc4
	ognQ==
X-Gm-Message-State: AOAM533l6SKqOTm+NTl8MnpfMDloG5Cyw4XEjawQh+4+mzdjWj0EoTub
	4WU+t83bpRQY2ZA8johlTTQh8d3AExLNVymP6SxlMUsr2YsydGqcL3f6uGdWS9ktSnqCV87rFze
	J7rAFo5kBtBKuQtGiCm4NQTG+uZOIMNY=
X-Received: by 2002:a25:5f11:: with SMTP id t17mr56887053ybb.633.1638981340335;
	Wed, 08 Dec 2021 08:35:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzo17yV7rNQCIoIpYtj6fWJPgV6DPYLJtFO+QgG3tdkfydBufIE9HDGIW9M2fZWUkrPfSPMxmnNbK/Cfvqc+o=
X-Received: by 2002:a25:5f11:: with SMTP id t17mr56887018ybb.633.1638981340050;
	Wed, 08 Dec 2021 08:35:40 -0800 (PST)
MIME-Version: 1.0
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
	<9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
	<CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
	<a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
	<3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
	<abe73176-03ca-9305-2005-677edc6ef158@linux.dev>
In-Reply-To: <abe73176-03ca-9305-2005-677edc6ef158@linux.dev>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Wed, 8 Dec 2021 17:35:29 +0100
Message-ID: <CAM23VxrYRbWEUsCsez2QOQM9oWKxSv432rc9oZCj5zEPmtND0A@mail.gmail.com>
To: Guoqing Jiang <guoqing.jiang@linux.dev>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Mike Snitzer <snitzer@redhat.com>,
	linux-raid <linux-raid@vger.kernel.org>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	it+raid@molgen.mpg.de, Donald Buczek <buczek@molgen.mpg.de>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
	reconfig_mutex held
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4595696516237216418=="

--===============4595696516237216418==
Content-Type: multipart/alternative; boundary="0000000000009149d605d2a514c2"

--0000000000009149d605d2a514c2
Content-Type: text/plain; charset="UTF-8"

NACK, see details below.

On Wed, Dec 8, 2021 at 3:24 PM Guoqing Jiang <guoqing.jiang@linux.dev>
wrote:

>
>
> On 12/1/21 1:27 AM, Paul Menzel wrote:
> >
> >>>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>>>>>> index cab12b2..0c4cbba 100644
> >>>>>>> --- a/drivers/md/dm-raid.c
> >>>>>>> +++ b/drivers/md/dm-raid.c
> >>>>>>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target
> >>>>>>> *ti, unsigned int argc, char **argv,
> >>>>>>>         if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0],
> >>>>>>> "frozen")) {
> >>>>>>>                 if (mddev->sync_thread) {
> >>>>>>>                         set_bit(MD_RECOVERY_INTR,
> >>>>>>> &mddev->recovery);
> >>>>>>> -                     md_reap_sync_thread(mddev);
> >>>>>>> +                     md_reap_sync_thread(mddev, false);
> >>>>>
> >>>>> I think we can add mddev_lock() and mddev_unlock() here and then
> >>>>> we don't
> >>>>> need the extra parameter?
> >>>>
> >>>> I thought it too, but I would prefer get the input from DM people
> >>>> first.
> >>>>
> >>>> @ Mike or Alasdair
> >>>
> >>> Hi Mike and Alasdair,
> >>>
> >>> Could you please comment on this option: adding mddev_lock() and
> >>> mddev_unlock()
> >>> to raid_message() around md_reap_sync_thread()?
>
> Add Heinz and Jonathan, could you comment about this? Thanks.
>
> >>
> >> The issue is unfortunately still unresolved (at least Linux 5.10.82).
> >> How can we move forward?
>
> If it is not applicable to change dm-raid, another alternative could be
> like this
>
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9409,8 +9409,12 @@ void md_reap_sync_thread(struct mdev *mddev)
>          sector_t old_dev_sectors = mddev->dev_sectors;
>          bool is_reshaped = false;
>
> +       if (mddev_is_locked(mddev))
> +               mddev_unlock(mddev);
>          /* resync has finished, collect result */
>          md_unregister_thread(&mddev->sync_thread);
> +       if (mddev_is_locked(mddev))
> +               mddev_lock(mddev);
>          if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>              !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>              mddev->degraded != mddev->raid_disks) {
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 53ea7a6961de..96a88b7681d6 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -549,6 +549,11 @@ static inline int mddev_trylock(struct mddev *mddev)
>   }
>   extern void mddev_unlock(struct mddev *mddev);
>
> +static inline int mddev_is_locked(struct mddev *mddev)
> +{
> +       return mutex_is_locked(&mddev->reconfig_mutex);
> +}
> +
>
>
Patch is bogus relative to the proposed mddev_unlock/mddev_lock logic in
md.c around the
md_unregister_thread() as it's failing to lock again if it was holding the
mutex before as it again
calls mddev_locked() after having the mutex unlocked just before the
md_unregister_thread() call.

If that patch to md.c holds up in further analysis, it has to keep the
mddev_is_locked() result
and unlock/lock conditionally based on its result.

Thanks,
Heinz


BTW, it is holiday season,  so people are probably on vacation.
>
> Thanks,
> Guoqing
>
>

--0000000000009149d605d2a514c2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>NACK, see details below.</div><div><br></div><div>On =
Wed, Dec 8, 2021 at 3:24 PM Guoqing Jiang &lt;<a href=3D"mailto:guoqing.jia=
ng@linux.dev" target=3D"_blank">guoqing.jiang@linux.dev</a>&gt; wrote:<br><=
/div><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex"><br>
<br>
On 12/1/21 1:27 AM, Paul Menzel wrote:<br>
&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; diff --git a/drivers/md/dm-raid.c b/drivers/md=
/dm-raid.c<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; index cab12b2..0c4cbba 100644<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; --- a/drivers/md/dm-raid.c<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; +++ b/drivers/md/dm-raid.c<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; @@ -3668,7 +3668,7 @@ static int raid_message(=
struct dm_target <br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; *ti, unsigned int argc, char **argv,<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(!strcasecmp(argv[0], &quot;idle&quot;) || !strcasecmp(argv[0], <br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; &quot;frozen&quot;)) {<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev-&gt;sync_thread) {<=
br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 set_bit(MD_RECOVERY_INTR, <br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; &amp;mddev-&gt;recovery);<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 md_reap_sync_thread(mddev);<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 md_reap_sync_thread(mddev, false);<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; I think we can add mddev_lock() and mddev_unlock() her=
e and then <br>
&gt;&gt;&gt;&gt;&gt; we don&#39;t<br>
&gt;&gt;&gt;&gt;&gt; need the extra parameter?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; I thought it too, but I would prefer get the input from DM=
 people <br>
&gt;&gt;&gt;&gt; first.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; @ Mike or Alasdair<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Hi Mike and Alasdair,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Could you please comment on this option: adding mddev_lock() a=
nd <br>
&gt;&gt;&gt; mddev_unlock()<br>
&gt;&gt;&gt; to raid_message() around md_reap_sync_thread()?<br>
<br>
Add Heinz and Jonathan, could you comment about this? Thanks.<br>
<br>
&gt;&gt;<br>
&gt;&gt; The issue is unfortunately still unresolved (at least Linux 5.10.8=
2). <br>
&gt;&gt; How can we move forward?<br>
<br>
If it is not applicable to change dm-raid, another alternative could be <br=
>
like this<br>
<br>
--- a/drivers/md/md.c<br>
+++ b/drivers/md/md.c<br>
@@ -9409,8 +9409,12 @@ void md_reap_sync_thread(struct mdev *mddev)<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector_t old_dev_sectors =
=3D mddev-&gt;dev_sectors;<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool is_reshaped =3D false=
;<br>
<br>
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev_is_locked(mddev))<br>
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 mddev_unlock(mddev);<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* resync has finished, co=
llect result */<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_unregister_thread(&amp;=
mddev-&gt;sync_thread);<br>
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev_is_locked(mddev))<br>
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 mddev_lock(mddev);<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!test_bit(MD_RECOVERY_=
INTR, &amp;mddev-&gt;recovery) &amp;&amp;<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !t=
est_bit(MD_RECOVERY_REQUESTED, &amp;mddev-&gt;recovery) &amp;&amp;<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md=
dev-&gt;degraded !=3D mddev-&gt;raid_disks) {<br>
diff --git a/drivers/md/md.h b/drivers/md/md.h<br>
index 53ea7a6961de..96a88b7681d6 100644<br>
--- a/drivers/md/md.h<br>
+++ b/drivers/md/md.h<br>
@@ -549,6 +549,11 @@ static inline int mddev_trylock(struct mddev *mddev)<b=
r>
=C2=A0=C2=A0}<br>
=C2=A0=C2=A0extern void mddev_unlock(struct mddev *mddev);<br>
<br>
+static inline int mddev_is_locked(struct mddev *mddev)<br>
+{<br>
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return mutex_is_locked(&amp;mddev-&gt=
;reconfig_mutex);<br>
+}<br>
+<br>
<br></blockquote><div><br></div><div>Patch is bogus relative to the propose=
d=C2=A0mddev_unlock/mddev_lock logic in md.c around the<br>md_unregister_th=
read() as it&#39;s failing to lock again if it was holding the mutex before=
 as it again<br>calls mddev_locked() after having the mutex unlocked just b=
efore the md_unregister_thread() call.</div><div><br></div><div>If that pat=
ch to md.c holds up in further analysis, it has to keep the mddev_is_locked=
() result<br>and unlock/lock conditionally based on its result.</div><div><=
br></div><div>Thanks,<br></div><div>Heinz=C2=A0</div><div><br></div><div><b=
r></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex=
;border-left:1px solid rgb(204,204,204);padding-left:1ex">
BTW, it is holiday season,=C2=A0 so people are probably on vacation.<br>
<br>
Thanks,<br>
Guoqing<br>
<br>
</blockquote></div></div>

--0000000000009149d605d2a514c2--

--===============4595696516237216418==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============4595696516237216418==--

