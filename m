Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F028C761A6
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680271729;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=uRHTs7vwbJbTBoNrxmJuQWrSfzn7ByWmB2nGjUFCvNg=;
	b=NPgy7yT+E3i7EHOvJxHumIHgMPHYOyP4Qq80siO3eBqUhapWPLpAUQlS6O2A/XWJ0SxZSI
	ytYa0U7qQeaikuFSi0YEBPhEFV0znQq0ImUMksiQQx3fidnjspx7VVj1FYOzfT44wez4Hq
	LX8W6M4N3nfA6tJm1A7HVsNLXtA5Q2U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-WXuzl1FMPbmbsi1ijn16vw-1; Fri, 31 Mar 2023 10:08:45 -0400
X-MC-Unique: WXuzl1FMPbmbsi1ijn16vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07D36802D1A;
	Fri, 31 Mar 2023 14:08:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAADD1121314;
	Fri, 31 Mar 2023 14:08:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9597A19465BD;
	Fri, 31 Mar 2023 14:08:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D887919465BC
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 14:08:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC84BC15BB8; Fri, 31 Mar 2023 14:08:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4B12C15BA0
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 14:08:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6B433C16E95
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 14:08:34 +0000 (UTC)
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-MWPTvuksM7CBhQ5cFr-a8Q-1; Fri, 31 Mar 2023 10:08:33 -0400
X-MC-Unique: MWPTvuksM7CBhQ5cFr-a8Q-1
Received: by mail-ua1-f71.google.com with SMTP id
 n13-20020ab01e4d000000b0076512b30a3bso7968673uak.13
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 07:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680271711;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=QmiV3AxtpnKHTOvk3sJG74o/pOKsSia3N02eQMUuDG4=;
 b=ft/2lsNyAADkYv/TVxHkeYzJKcMpcM3s51f7PIQau2iPWpazqWTOel3BsgPho2Mut/
 FC3ynmcxYOlHCg4cRkHAgHZCHq2iW9yQJWW3RmiCtXprOPUCbcv2MD/aBP/eM6m9sdY9
 CfJlweWnvW285QtsJzTPMh6gq6Q5OoKgEqd2EE1R7RJisbK+8GoZw4GL1BYV4JSkDARx
 T8V+Wt9skZxKEiPmj7X5YkWKQH4i9EyC2s4GJ+gNq+hb2ntqLmq3B0BMOqTX+JZetunL
 GivdyK2u5C1NlQXTdVIwATXZ1e2AVrpYtnwt2onzVoYq2IQ899MiwqkkHEuBT5JsDna4
 tCHw==
X-Gm-Message-State: AAQBX9ewPWGBG3k70kkhCaBj4dhNfneWfOfaMwG2q9bMsCJIl7QkGblL
 2tpaneKIiTtAvDqCO+88O4TljFERkMC90InZVH53rQqiNrij4jfZUrXj+YA5EQ3Dogy3K1ST/2J
 bMHUpgh/xT96uA/mSFwlJRcBiYZugl8Q=
X-Received: by 2002:a67:d892:0:b0:426:7730:1b8a with SMTP id
 f18-20020a67d892000000b0042677301b8amr14950645vsj.0.1680271711535; 
 Fri, 31 Mar 2023 07:08:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350bOUzhT+WKEw6PrNdYon2QT/0KLECU2FS3GxE/qhXuW5f3Jn/ZsOoq+HWQ07gB39gpkWc5rgokSF+c8V25hE2o=
X-Received: by 2002:a67:d892:0:b0:426:7730:1b8a with SMTP id
 f18-20020a67d892000000b0042677301b8amr14950630vsj.0.1680271711178; Fri, 31
 Mar 2023 07:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230330212753.1843266-1-trix@redhat.com>
In-Reply-To: <20230330212753.1843266-1-trix@redhat.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Fri, 31 Mar 2023 16:08:20 +0200
Message-ID: <CAM23VxpxeO-YFixZNAHGnqCFZTZmCHCozed6CzHDzs1A1uAXLA@mail.gmail.com>
To: Tom Rix <trix@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] dm raid: remove unused d variable
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
Cc: snitzer@kernel.org, llvm@lists.linux.dev, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, nathan@kernel.org, dm-devel@redhat.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============1598278776006391167=="

--===============1598278776006391167==
Content-Type: multipart/alternative; boundary="00000000000078acaa05f832bee2"

--00000000000078acaa05f832bee2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30, 2023 at 11:28=E2=80=AFPM Tom Rix <trix@redhat.com> wrote:

> clang with W=3D1 reports
> drivers/md/dm-raid.c:2212:15: error: variable
>   'd' set but not used [-Werror,-Wunused-but-set-variable]
>         unsigned int d;
>                      ^
> This variable is not used so remove it.
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/md/dm-raid.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 60632b409b80..2dfd51509647 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -2209,7 +2209,6 @@ static int super_load(struct md_rdev *rdev, struct
> md_rdev *refdev)
>  static int super_init_validation(struct raid_set *rs, struct md_rdev
> *rdev)
>  {
>         int role;
> -       unsigned int d;
>         struct mddev *mddev =3D &rs->md;
>         uint64_t events_sb;
>         uint64_t failed_devices[DISKS_ARRAY_ELEMS];
> @@ -2324,7 +2323,6 @@ static int super_init_validation(struct raid_set
> *rs, struct md_rdev *rdev)
>          *    to provide capacity for redundancy or during reshape
>          *    to add capacity to grow the raid set.
>          */
> -       d =3D 0;
>         rdev_for_each(r, mddev) {
>                 if (test_bit(Journal, &rdev->flags))
>                         continue;
> @@ -2340,8 +2338,6 @@ static int super_init_validation(struct raid_set
> *rs, struct md_rdev *rdev)
>                         if (test_bit(FirstUse, &r->flags))
>                                 rebuild_and_new++;
>                 }
> -
> -               d++;
>         }
>
>         if (new_devs =3D=3D rs->raid_disks || !rebuilds) {
> --
> 2.27.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>
>
Acked

--00000000000078acaa05f832bee2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">On Thu, Mar 30, 2023 at 11:28=E2=80=AFPM =
Tom Rix &lt;<a href=3D"mailto:trix@redhat.com" target=3D"_blank">trix@redha=
t.com</a>&gt; wrote:<br></div><div class=3D"gmail_quote"><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">clang with W=3D1 reports<br>
drivers/md/dm-raid.c:2212:15: error: variable<br>
=C2=A0 &#39;d&#39; set but not used [-Werror,-Wunused-but-set-variable]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int d;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0^<br>
This variable is not used so remove it.<br>
<br>
Signed-off-by: Tom Rix &lt;<a href=3D"mailto:trix@redhat.com" target=3D"_bl=
ank">trix@redhat.com</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm-raid.c | 4 ----<br>
=C2=A01 file changed, 4 deletions(-)<br>
<br>
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c<br>
index 60632b409b80..2dfd51509647 100644<br>
--- a/drivers/md/dm-raid.c<br>
+++ b/drivers/md/dm-raid.c<br>
@@ -2209,7 +2209,6 @@ static int super_load(struct md_rdev *rdev, struct md=
_rdev *refdev)<br>
=C2=A0static int super_init_validation(struct raid_set *rs, struct md_rdev =
*rdev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int role;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int d;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mddev *mddev =3D &amp;rs-&gt;md;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint64_t events_sb;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint64_t failed_devices[DISKS_ARRAY_ELEMS];<br>
@@ -2324,7 +2323,6 @@ static int super_init_validation(struct raid_set *rs,=
 struct md_rdev *rdev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=C2=A0 =C2=A0 to provide capacity for re=
dundancy or during reshape<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=C2=A0 =C2=A0 to add capacity to grow th=
e raid set.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0d =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rdev_for_each(r, mddev) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(Journa=
l, &amp;rdev-&gt;flags))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;<br>
@@ -2340,8 +2338,6 @@ static int super_init_validation(struct raid_set *rs,=
 struct md_rdev *rdev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (test_bit(FirstUse, &amp;r-&gt;flags))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rebuild_and_new++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0d++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (new_devs =3D=3D rs-&gt;raid_disks || !rebui=
lds) {<br>
-- <br>
2.27.0<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" rel=3D"nor=
eferrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/dm-d=
evel</a><br>
<br></blockquote><div><br></div><div>Acked=C2=A0</div></div></div>

--00000000000078acaa05f832bee2--

--===============1598278776006391167==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1598278776006391167==--

