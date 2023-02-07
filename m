Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE009C636CC
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675782316;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=/8DTksCgTeX/TxcRkxFPMv6zWxeJrvy5Ssqj/jkoQMw=;
	b=ZAHzk7eA6SLnlPlljqYZyLAcGsgGL/vJf/yiL9eidUlEJOrOF6a1rnluq/C9F9xTzpsI6J
	UI7RP7dZcKMGwc8MXtNjxZhvqwsHLNsQI/OuSXRP6sUwEsvXCA9nIvmkrPaJgvbyBQQL5K
	wIyzQgvH8noTa/Ky4W2WIsNOArzyAcg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-F2GQBz8gP12SbLDEEs4cAQ-1; Tue, 07 Feb 2023 10:04:30 -0500
X-MC-Unique: F2GQBz8gP12SbLDEEs4cAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 365453804061;
	Tue,  7 Feb 2023 15:04:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2194F440DD;
	Tue,  7 Feb 2023 15:04:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F0623194658D;
	Tue,  7 Feb 2023 15:04:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B6FBB1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 15:04:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98F0A40398A3; Tue,  7 Feb 2023 15:04:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90DCB40398A2
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 15:04:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70AD3802D19
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 15:04:11 +0000 (UTC)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-axbHPfu1PquqksPS1-hqgQ-1; Tue, 07 Feb 2023 10:04:09 -0500
X-MC-Unique: axbHPfu1PquqksPS1-hqgQ-1
Received: by mail-yw1-f198.google.com with SMTP id
 00721157ae682-517f8be4b00so146571507b3.3
 for <dm-devel@redhat.com>; Tue, 07 Feb 2023 07:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=s8/+1l8UPEFhfqFYFxiTWimISkfcSZbF7ts4u06jXE4=;
 b=G/7HfHFckHpk1GjW/iS6kxex5qpVPqGmHgzxckWdhFbMCjteJh798E1YW0f67X7YE8
 NJavhZ4wGpcrYA/JBcZ98GBsKKMkiOOttnDO6nZmYhsHXwuoJlU1ZgpMLSPRZmHvTB6J
 Rj5eVPAdng0gQ4RMQA+iAo9/dQHK1OpjCxsHafhiru2vZQBPRqAHnS3kzxXOC6cLK2A6
 /glZGN3a+OMIpAijdoR3PQumjPKWITRDpB+dUo0Ejb//1Er2T6zYiipfEc5ieqqu7dhw
 XScv9ArAizcjqmlXc22FkizksDNQNuilymMuG6k9a5Dw4OQuX4T0D6kuMoP5SqZCNB+g
 ewdA==
X-Gm-Message-State: AO0yUKWCoT+0XdAdCm2ZA0rTm9PXlg6eV038GZSSaWmRKfrFH/yvkiLg
 x1AqjsDpBhDwQXFhzD5FqD5WFj21AZHfk5t1pF2rtBu7Mp/ofZ4YHFR11TPdsD0pvKjgKoh5veY
 4F0t9//O6PwIupu9Prvzv9QH88mtt6Ow=
X-Received: by 2002:a81:92d2:0:b0:52a:887d:e7f2 with SMTP id
 j201-20020a8192d2000000b0052a887de7f2mr335265ywg.461.1675782248602; 
 Tue, 07 Feb 2023 07:04:08 -0800 (PST)
X-Google-Smtp-Source: AK7set+oFSiRbYpXpwOVu06Dtr/3cnWkD/dDbiqQcyfueIdVjBp49ehCubQIzUBqTkhAdVtM3dMe+3cPn72Hc6XSsnU=
X-Received: by 2002:a81:92d2:0:b0:52a:887d:e7f2 with SMTP id
 j201-20020a8192d2000000b0052a887de7f2mr335261ywg.461.1675782248378; Tue, 07
 Feb 2023 07:04:08 -0800 (PST)
MIME-Version: 1.0
References: <20230207011849.1343-1-demi@invisiblethingslab.com>
 <20230207011849.1343-2-demi@invisiblethingslab.com>
In-Reply-To: <20230207011849.1343-2-demi@invisiblethingslab.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 7 Feb 2023 15:03:57 +0000
Message-ID: <CAJ0trDZ88Tcaf9Y75S-vB1vWXPN9UEsqPV1bTrkAtSYFfUngAQ@mail.gmail.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 2/2] dm-thin: Allow specifying an offset
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
 =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2108295073160483474=="

--===============2108295073160483474==
Content-Type: multipart/alternative; boundary="000000000000a2c97605f41d75ca"

--000000000000a2c97605f41d75ca
Content-Type: text/plain; charset="UTF-8"

Nack.  I'm not building a linear target into every other target.  Layering
targets is simple.

On Tue, Feb 7, 2023 at 7:56 AM Demi Marie Obenour <
demi@invisiblethingslab.com> wrote:

> This allows exposing only part of a thin volume without having to layer
> dm-linear.  One use-case is a hypervisor replacing a partition table.
>
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> ---
>  drivers/md/dm-thin.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index
> d85fdbd782ae5426003c99a4b4bf53818cc85efa..87f14933375b050a950a5f58e98c13b4d28f6af0
> 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -357,6 +357,7 @@ struct thin_c {
>          */
>         refcount_t refcount;
>         struct completion can_destroy;
> +       u64 offset;
>  };
>
>  /*----------------------------------------------------------------*/
> @@ -1180,9 +1181,9 @@ static void
> process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
>         discard_parent = bio_alloc(NULL, 1, 0, GFP_NOIO);
>         discard_parent->bi_end_io = passdown_endio;
>         discard_parent->bi_private = m;
> -       if (m->maybe_shared)
> -               passdown_double_checking_shared_status(m, discard_parent);
> -       else {
> +       if (m->maybe_shared)
> +               passdown_double_checking_shared_status(m, discard_parent);
> +       else {
>                 struct discard_op op;
>
>                 begin_discard(&op, tc, discard_parent);
> @@ -4149,7 +4150,7 @@ static int thin_ctr(struct dm_target *ti, unsigned
> argc, char **argv)
>
>         mutex_lock(&dm_thin_pool_table.mutex);
>
> -       if (argc != 2 && argc != 3) {
> +       if (argc < 2 || argc > 4) {
>                 ti->error = "Invalid argument count";
>                 r = -EINVAL;
>                 goto out_unlock;
> @@ -4168,7 +4169,8 @@ static int thin_ctr(struct dm_target *ti, unsigned
> argc, char **argv)
>         bio_list_init(&tc->retry_on_resume_list);
>         tc->sort_bio_list = RB_ROOT;
>
> -       if (argc == 3) {
> +       /* Use "/" to indicate "no origin device" while providing an
> offset */
> +       if (argc >= 3 && strcmp(argv[2], "/")) {
>                 if (!strcmp(argv[0], argv[2])) {
>                         ti->error = "Error setting origin device";
>                         r = -EINVAL;
> @@ -4196,6 +4198,23 @@ static int thin_ctr(struct dm_target *ti, unsigned
> argc, char **argv)
>                 goto bad_common;
>         }
>
> +       tc->offset = 0;
> +       if (argc > 3) {
> +               sector_t sector_offset;
> +
> +               if (kstrtoull(argv[3], 10, &tc->offset)) {
> +                       ti->error = "Invalid offset";
> +                       r = -EINVAL;
> +                       goto bad_common;
> +               }
> +
> +               if (check_add_overflow(tc->offset, ti->len,
> &sector_offset)) {
> +                       ti->error = "Offset + len overflows sector_t";
> +                       r = -EINVAL;
> +                       goto bad_common;
> +               }
> +       }
> +
>         pool_md = dm_get_md(tc->pool_dev->bdev->bd_dev);
>         if (!pool_md) {
>                 ti->error = "Couldn't get pool mapped device";
> @@ -4285,8 +4304,9 @@ static int thin_ctr(struct dm_target *ti, unsigned
> argc, char **argv)
>
>  static int thin_map(struct dm_target *ti, struct bio *bio)
>  {
> -       bio->bi_iter.bi_sector = dm_target_offset(ti,
> bio->bi_iter.bi_sector);
> +       struct thin_c *tc = ti->private;
>
> +       bio->bi_iter.bi_sector = dm_target_offset(ti,
> bio->bi_iter.bi_sector) + tc->offset;
>         return thin_bio_map(ti, bio);
>  }
>
> --
> Sincerely,
> Demi Marie Obenour (she/her/hers)
> Invisible Things Lab
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>
>

--000000000000a2c97605f41d75ca
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Nack.=C2=A0 I&#39;m not building a linear target into ever=
y other target.=C2=A0 Layering targets is simple.</div><br><div class=3D"gm=
ail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Feb 7, 2023 at 7:5=
6 AM Demi Marie Obenour &lt;<a href=3D"mailto:demi@invisiblethingslab.com">=
demi@invisiblethingslab.com</a>&gt; wrote:<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex">This allows exposing only part of a thin volume =
without having to layer<br>
dm-linear.=C2=A0 One use-case is a hypervisor replacing a partition table.<=
br>
<br>
Signed-off-by: Demi Marie Obenour &lt;<a href=3D"mailto:demi@invisiblething=
slab.com" target=3D"_blank">demi@invisiblethingslab.com</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm-thin.c | 32 ++++++++++++++++++++++++++------<br>
=C2=A01 file changed, 26 insertions(+), 6 deletions(-)<br>
<br>
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c<br>
index d85fdbd782ae5426003c99a4b4bf53818cc85efa..87f14933375b050a950a5f58e98=
c13b4d28f6af0 100644<br>
--- a/drivers/md/dm-thin.c<br>
+++ b/drivers/md/dm-thin.c<br>
@@ -357,6 +357,7 @@ struct thin_c {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 refcount_t refcount;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct completion can_destroy;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 offset;<br>
=C2=A0};<br>
<br>
=C2=A0/*----------------------------------------------------------------*/<=
br>
@@ -1180,9 +1181,9 @@ static void process_prepared_discard_passdown_pt1(str=
uct dm_thin_new_mapping *m)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 discard_parent =3D bio_alloc(NULL, 1, 0, GFP_NO=
IO);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 discard_parent-&gt;bi_end_io =3D passdown_endio=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 discard_parent-&gt;bi_private =3D m;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (m-&gt;maybe_shared)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0passdown_double_che=
cking_shared_status(m, discard_parent);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (m-&gt;maybe_shared)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0passdown_double_che=
cking_shared_status(m, discard_parent);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct discard_op o=
p;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 begin_discard(&amp;=
op, tc, discard_parent);<br>
@@ -4149,7 +4150,7 @@ static int thin_ctr(struct dm_target *ti, unsigned ar=
gc, char **argv)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_lock(&amp;dm_thin_pool_table.mutex);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc !=3D 2 &amp;&amp; argc !=3D 3) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc &lt; 2 || argc &gt; 4) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ti-&gt;error =3D &q=
uot;Invalid argument count&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -EINVAL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_unlock;<br=
>
@@ -4168,7 +4169,8 @@ static int thin_ctr(struct dm_target *ti, unsigned ar=
gc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_list_init(&amp;tc-&gt;retry_on_resume_list)=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tc-&gt;sort_bio_list =3D RB_ROOT;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc =3D=3D 3) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Use &quot;/&quot; to indicate &quot;no origi=
n device&quot; while providing an offset */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc &gt;=3D 3 &amp;&amp; strcmp(argv[2], &=
quot;/&quot;)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!strcmp(argv[0]=
, argv[2])) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ti-&gt;error =3D &quot;Error setting origin device&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 r =3D -EINVAL;<br>
@@ -4196,6 +4198,23 @@ static int thin_ctr(struct dm_target *ti, unsigned a=
rgc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto bad_common;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0tc-&gt;offset =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc &gt; 3) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sector_t sector_off=
set;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (kstrtoull(argv[=
3], 10, &amp;tc-&gt;offset)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ti-&gt;error =3D &quot;Invalid offset&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0r =3D -EINVAL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto bad_common;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (check_add_overf=
low(tc-&gt;offset, ti-&gt;len, &amp;sector_offset)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ti-&gt;error =3D &quot;Offset + len overflows sector_t&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0r =3D -EINVAL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto bad_common;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pool_md =3D dm_get_md(tc-&gt;pool_dev-&gt;bdev-=
&gt;bd_dev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!pool_md) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ti-&gt;error =3D &q=
uot;Couldn&#39;t get pool mapped device&quot;;<br>
@@ -4285,8 +4304,9 @@ static int thin_ctr(struct dm_target *ti, unsigned ar=
gc, char **argv)<br>
<br>
=C2=A0static int thin_map(struct dm_target *ti, struct bio *bio)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0bio-&gt;bi_iter.bi_sector =3D dm_target_offset(=
ti, bio-&gt;bi_iter.bi_sector);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct thin_c *tc =3D ti-&gt;private;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bio-&gt;bi_iter.bi_sector =3D dm_target_offset(=
ti, bio-&gt;bi_iter.bi_sector) + tc-&gt;offset;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return thin_bio_map(ti, bio);<br>
=C2=A0}<br>
<br>
-- <br>
Sincerely,<br>
Demi Marie Obenour (she/her/hers)<br>
Invisible Things Lab<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" rel=3D"nor=
eferrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/dm-d=
evel</a><br>
<br>
</blockquote></div>

--000000000000a2c97605f41d75ca--

--===============2108295073160483474==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2108295073160483474==--

