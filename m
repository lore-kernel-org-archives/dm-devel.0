Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEC6C67871
	for <dm-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673857415;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=EWDYkMPx9jFxSryioUhAk0eFG4wnFo/j77NG1cycues=;
	b=KLulIfZ+m4oJ7qQLv1Idyc1pKZ2/zTAXqUdyrfWQ/SPwyldpwPqbdkeP30P1iQH6vZxfDX
	RNxQlSQnnBtej3kBjSZqu2h3ptp9OzMOUsIYxYALuzAM+4NUU/DaLn2PsFWa8SuopW5N0n
	TlGRkxoko0/XJNP7cP+Yi4x/1bqaZQk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-Ry6wWyamOriE-f296P6aNA-1; Mon, 16 Jan 2023 03:23:31 -0500
X-MC-Unique: Ry6wWyamOriE-f296P6aNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4977D857A89;
	Mon, 16 Jan 2023 08:23:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F0352026D68;
	Mon, 16 Jan 2023 08:23:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0534019459CC;
	Mon, 16 Jan 2023 08:23:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C4431946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 Jan 2023 12:47:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D1812166B29; Fri, 13 Jan 2023 12:47:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4639A2166B26
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 12:47:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 257A885A588
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 12:47:17 +0000 (UTC)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-563-4mn6tR21PM-q77rV0WYehg-1; Fri, 13 Jan 2023 07:47:15 -0500
X-MC-Unique: 4mn6tR21PM-q77rV0WYehg-1
Received: by mail-yw1-f200.google.com with SMTP id
 00721157ae682-4c16ff0159eso228609247b3.17
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 04:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=YSsvd8JJ+FCjE5tm1yZZ9tOm/I8EwtdjXW7R+oWXZWA=;
 b=RgqIV82y8ZAz0wZE+eyRRFI8m+ml/tva8RWR5e2wolIX9+9J9TSLDzgVdSh81SmW9a
 pWRMS/qC9jNgIEeQAh7SQjvwly3I5erZgxTICDJ5oK6Dti7ONB/ag0sgxp9Ud0l9Mra9
 0LLRQnuIew54UY8BkMejcAWc/kibI9ikJa+mm8p318PY9KApnDrEd6gPXc8O2Me8ySmC
 28yVVQfPQuhkKYrC1Mcz8QuVHGjJJJ4GK94+sR59ljpQFmJWG6R8En9rBFo/ElDmB1Qf
 FhhoHfbTQLTzyolC+TC7nHVgizyBrSqW+53ahb4PTVYfly6giThep5E4UYMJbYhYiFzG
 R0Aw==
X-Gm-Message-State: AFqh2kpuk9Si2xrd3nsifLN6sG7/y3H3H0Me3Ce2PAOcnvjYBo47iyA5
 vAhzBv6+QuWsHbIi9ozXL+cAK5444ksWwVPMVPQ6QNqesMF6nhIqyY3TRFA4zwIR0Ld3RdmCoMw
 R6ZIji9F9DiGPhoUwMruGfTVJiNqRlLg=
X-Received: by 2002:a81:7254:0:b0:4ce:54dc:d69f with SMTP id
 n81-20020a817254000000b004ce54dcd69fmr3030148ywc.373.1673614034593; 
 Fri, 13 Jan 2023 04:47:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs7y2/qkMswkiamu3shT8ERwdaaaWJnzP9/lpq0KOWgJG1SZm9ScuMmphsx+E0HhFVoiuWEqwoVTGkJqkLjr80=
X-Received: by 2002:a81:7254:0:b0:4ce:54dc:d69f with SMTP id
 n81-20020a817254000000b004ce54dcd69fmr3030145ywc.373.1673614034332; Fri, 13
 Jan 2023 04:47:14 -0800 (PST)
MIME-Version: 1.0
References: <1673555329-9850-1-git-send-email-bmarzins@redhat.com>
 <1673555329-9850-2-git-send-email-bmarzins@redhat.com>
 <0ce9d087cc48ed97f2cee1a5c48c0149d5728332.camel@suse.com>
In-Reply-To: <0ce9d087cc48ed97f2cee1a5c48c0149d5728332.camel@suse.com>
From: Nitin Yewale <nyewale@redhat.com>
Date: Fri, 13 Jan 2023 18:16:37 +0530
Message-ID: <CACgRdraG3XRpmJB7L=kRce3eYOMWeWfUQ63pD0g1Bt0O5sA4LA@mail.gmail.com>
To: Ben Marzinski <bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 16 Jan 2023 08:23:20 +0000
Subject: Re: [dm-devel] [PATCH 1/2] multipathd: Add format options to
 multipathd man page
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7686226387061487846=="

--===============7686226387061487846==
Content-Type: multipart/alternative; boundary="0000000000000207da05f224a217"

--0000000000000207da05f224a217
Content-Type: text/plain; charset="UTF-8"

Hello Ben,

I can try to explain the $format options. Will update bz with the new patch.

Thank you,
Nitin Yewale

On Fri, Jan 13, 2023 at 2:22 PM Martin Wilck <martin.wilck@suse.com> wrote:

> On Thu, 2023-01-12 at 14:28 -0600, Benjamin Marzinski wrote:
> > From: Nitin Yewale <nyewale@redhat.com>
> >
> > Move "multipathd show wildcards" command above the $format commands
> > and
> > also add $format options for "map" and "path" commands to the
> > multipathd
> > man page.
> >
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/multipathd.8 | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
> > index bdf102eb..95d475da 100644
> > --- a/multipathd/multipathd.8
> > +++ b/multipathd/multipathd.8
> > @@ -113,9 +113,17 @@ The following commands can be used in
> > interactive mode:
> >  Show the paths that multipathd is monitoring, and their state.
> >  .
> >  .TP
> > +.B list|show wildcards
> > +Show the format wildcards used in interactive commands taking
> > $format.
> > +.
> > +.TP
> >  .B list|show paths format $format
> >  Show the paths that multipathd is monitoring, using a format string
> > with path
> >  format wildcards.
> > +
> > +path format wildcards:
> > +
> > +%w (uuid), %i (hcil), %d (dev), %D (dev_t), %t (dm_st), %o (dev_st),
> > %T (chk_st), %s (vend/prod/rev), %c (checker), %C (next_check), %p
> > (pri), %S (size), %z (serial), %M (marginal_st), %m (multipath), %N
> > (host WWNN), %n (target WWNN), %R (host WWPN), %r (target WWPN), %a
> > (host adapter), %G (foreign), %g (vpd page data), %0 (failures), %P
> > (protocol)
> >  .
>
> If we do this in the first place, we should explain it better. Terms
> like "dm_st" need explanation. The explanation would grow into a longer
> paragraph, which should be moved to the bottom of the man page with a
> cross reference here.
>
> >  .TP
> >  .B list|show maps|multipaths
> > @@ -125,6 +133,10 @@ Show the multipath devices that the multipathd
> > is monitoring.
> >  .B list|show maps|multipaths format $format
> >  Show the status of all multipath devices that the multipathd is
> > monitoring,
> >  using a format string with multipath format wildcards.
> > +
> > +multipath format wildcards:
> > +
> > +%n (name), %w (uuid), %d (sysfs), %F (failback), %Q (queueing), %N
> > (no. of paths), %r (write_prot), %t (dm-st), %S (size), %f
> > (features), %x (failures), %h (hwhandler), %A (action), %0
> > (path_faults), %1 (switch_grp), %2 (map_loads), %3 (total_q_time), %4
> > (q_timeouts), %s (vend/prod/rev), %v (vend), %p (prod), %e (rev), %G
> > (foreign), %g (vpd page data)
>
> Same comment as above.
>
> Martin
>
> >  .
> >  .TP
> >  .B list|show maps|multipaths status
> > @@ -148,10 +160,6 @@ Show topology of a single multipath device
> > specified by $map, for example
> >  36005076303ffc56200000000000010aa. This map could be obtained from
> > '\fIlist maps\fR'.
> >  .
> >  .TP
> > -.B list|show wildcards
> > -Show the format wildcards used in interactive commands taking
> > $format.
> > -.
> > -.TP
> >  .B list|show config
> >  Show the currently used configuration, derived from default values
> > and values
> >  specified within the configuration file \fI/etc/multipath.conf\fR.
>
>

-- 
Regards,

--0000000000000207da05f224a217
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hello Ben,</div><div><br></div>I can try to explain t=
he $format options. Will update bz with the new patch.<div><br></div><div>T=
hank you,</div><div>Nitin Yewale</div></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Fri, Jan 13, 2023 at 2:22 PM Marti=
n Wilck &lt;<a href=3D"mailto:martin.wilck@suse.com">martin.wilck@suse.com<=
/a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">O=
n Thu, 2023-01-12 at 14:28 -0600, Benjamin Marzinski wrote:<br>
&gt; From: Nitin Yewale &lt;<a href=3D"mailto:nyewale@redhat.com" target=3D=
"_blank">nyewale@redhat.com</a>&gt;<br>
&gt; <br>
&gt; Move &quot;multipathd show wildcards&quot; command above the $format c=
ommands<br>
&gt; and<br>
&gt; also add $format options for &quot;map&quot; and &quot;path&quot; comm=
ands to the<br>
&gt; multipathd<br>
&gt; man page.<br>
&gt; <br>
&gt; Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redha=
t.com" target=3D"_blank">bmarzins@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt; =C2=A0multipathd/multipathd.8 | 16 ++++++++++++----<br>
&gt; =C2=A01 file changed, 12 insertions(+), 4 deletions(-)<br>
&gt; <br>
&gt; diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8<br>
&gt; index bdf102eb..95d475da 100644<br>
&gt; --- a/multipathd/multipathd.8<br>
&gt; +++ b/multipathd/multipathd.8<br>
&gt; @@ -113,9 +113,17 @@ The following commands can be used in<br>
&gt; interactive mode:<br>
&gt; =C2=A0Show the paths that multipathd is monitoring, and their state.<b=
r>
&gt; =C2=A0.<br>
&gt; =C2=A0.TP<br>
&gt; +.B list|show wildcards<br>
&gt; +Show the format wildcards used in interactive commands taking<br>
&gt; $format.<br>
&gt; +.<br>
&gt; +.TP<br>
&gt; =C2=A0.B list|show paths format $format<br>
&gt; =C2=A0Show the paths that multipathd is monitoring, using a format str=
ing<br>
&gt; with path<br>
&gt; =C2=A0format wildcards.<br>
&gt; +<br>
&gt; +path format wildcards:<br>
&gt; +<br>
&gt; +%w (uuid), %i (hcil), %d (dev), %D (dev_t), %t (dm_st), %o (dev_st),<=
br>
&gt; %T (chk_st), %s (vend/prod/rev), %c (checker), %C (next_check), %p<br>
&gt; (pri), %S (size), %z (serial), %M (marginal_st), %m (multipath), %N<br=
>
&gt; (host WWNN), %n (target WWNN), %R (host WWPN), %r (target WWPN), %a<br=
>
&gt; (host adapter), %G (foreign), %g (vpd page data), %0 (failures), %P<br=
>
&gt; (protocol)<br>
&gt; =C2=A0.<br>
<br>
If we do this in the first place, we should explain it better. Terms<br>
like &quot;dm_st&quot; need explanation. The explanation would grow into a =
longer<br>
paragraph, which should be moved to the bottom of the man page with a<br>
cross reference here.<br>
<br>
&gt; =C2=A0.TP<br>
&gt; =C2=A0.B list|show maps|multipaths<br>
&gt; @@ -125,6 +133,10 @@ Show the multipath devices that the multipathd<br=
>
&gt; is monitoring.<br>
&gt; =C2=A0.B list|show maps|multipaths format $format<br>
&gt; =C2=A0Show the status of all multipath devices that the multipathd is<=
br>
&gt; monitoring,<br>
&gt; =C2=A0using a format string with multipath format wildcards.<br>
&gt; +<br>
&gt; +multipath format wildcards:<br>
&gt; +<br>
&gt; +%n (name), %w (uuid), %d (sysfs), %F (failback), %Q (queueing), %N<br=
>
&gt; (no. of paths), %r (write_prot), %t (dm-st), %S (size), %f<br>
&gt; (features), %x (failures), %h (hwhandler), %A (action), %0<br>
&gt; (path_faults), %1 (switch_grp), %2 (map_loads), %3 (total_q_time), %4<=
br>
&gt; (q_timeouts), %s (vend/prod/rev), %v (vend), %p (prod), %e (rev), %G<b=
r>
&gt; (foreign), %g (vpd page data)<br>
<br>
Same comment as above.<br>
<br>
Martin<br>
<br>
&gt; =C2=A0.<br>
&gt; =C2=A0.TP<br>
&gt; =C2=A0.B list|show maps|multipaths status<br>
&gt; @@ -148,10 +160,6 @@ Show topology of a single multipath device<br>
&gt; specified by $map, for example<br>
&gt; =C2=A036005076303ffc56200000000000010aa. This map could be obtained fr=
om<br>
&gt; &#39;\fIlist maps\fR&#39;.<br>
&gt; =C2=A0.<br>
&gt; =C2=A0.TP<br>
&gt; -.B list|show wildcards<br>
&gt; -Show the format wildcards used in interactive commands taking<br>
&gt; $format.<br>
&gt; -.<br>
&gt; -.TP<br>
&gt; =C2=A0.B list|show config<br>
&gt; =C2=A0Show the currently used configuration, derived from default valu=
es<br>
&gt; and values<br>
&gt; =C2=A0specified within the configuration file \fI/etc/multipath.conf\f=
R.<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
 class=3D"gmail_signature"><div dir=3D"ltr"><div>Regards,</div></div></div>

--0000000000000207da05f224a217--

--===============7686226387061487846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7686226387061487846==--

