Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9968BC4332F
	for <dm-devel@archiver.kernel.org>; Fri,  2 Dec 2022 23:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670024726;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=F8zvbFAwFmBmLGKNx+aDdboWlGIW30uoTfUizFlOQU8=;
	b=IPmlLNFUOJDn+jK4gyivTftek88SDkZri52bL1U6wD4wkGFCVtRlKQLkKgQUYpoHPy1W1S
	B8dVBBfYKFyeEtiwQ3lpyGI0iIohk5j0KJ4u43NaAbKsPOUQ3xwe4kZjGIRdnXJt3Cqf2x
	pV+vieuRHWSTYKct7iJyhbnYGj9pJp0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-Hc31TSAcPt61-GDKcqVIbA-1; Fri, 02 Dec 2022 18:45:22 -0500
X-MC-Unique: Hc31TSAcPt61-GDKcqVIbA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 602A438149BD;
	Fri,  2 Dec 2022 23:45:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D000492B06;
	Fri,  2 Dec 2022 23:45:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F1369194658F;
	Fri,  2 Dec 2022 23:45:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EAF3A1946587
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Dec 2022 23:45:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D8B42111E410; Fri,  2 Dec 2022 23:45:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1336111E3FA
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 23:45:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1B76101A52A
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 23:45:16 +0000 (UTC)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com
 [209.85.222.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-OLOxjwmaPuqE2IoN4_KOMQ-1; Fri, 02 Dec 2022 18:45:09 -0500
X-MC-Unique: OLOxjwmaPuqE2IoN4_KOMQ-1
Received: by mail-ua1-f53.google.com with SMTP id e24so2165281uam.10;
 Fri, 02 Dec 2022 15:45:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=fwmNKCkm+oFXwsC/pu52RBsx2rQN9p1QScOqOh1AG74=;
 b=T6JmsLBUiK3AOVcn1s5kW7h/igbWZAFDB2h0CAMGZTPc/Kj1c15hjNP1tE5MSHv874
 19DopeLD0q1FBgOCxI0tpKQBUZgG1/VXIEjPZv1yZ09w2vM6ksw/x/VzMCMuY1AWJGee
 16mixMU1zjmYAB83v3rmgbwKAsc8SDMDtP7myE0WNqurY1ttEBmgeNcJ1NRpnMVf9kjY
 3Q1atX9xZGIguUlnNQAtFvDS+M3ogGtrEp1D5sPC7pPuzTJduo265MQyc4f5eNy5YFRQ
 0kE4Bc3Z/0Ue5THGvr1R6AikYDLzdpjpsxHb2iwxWDoCnMFHQ/3iXD3Bra+jZ/zyZxI8
 yIcw==
X-Gm-Message-State: ANoB5plwzKd6B/kufxMZXLG+C2lcj/Nj3etx6N3GT0DatFLeuUy8eJzK
 QsomtRg3KfpbY1s+QicmK4wI+y2CO2RhZVQuDbs=
X-Google-Smtp-Source: AA0mqf5nzf9k29RWGgLjzbFvY6A/jbhanf5sMT1f3PkmDTHetch82hPCKVW2xf5P9KhCSMvhSRWYswWwnr0eVH8SJhw=
X-Received: by 2002:a9f:22c7:0:b0:3d6:45ee:7efc with SMTP id
 65-20020a9f22c7000000b003d645ee7efcmr33416733uan.86.1670024708664; Fri, 02
 Dec 2022 15:45:08 -0800 (PST)
MIME-Version: 1.0
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
 <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
 <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
 <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
 <e506d4c8d63e0fda3c28297c4316b49c0e2a9fb1.camel@suse.com>
In-Reply-To: <e506d4c8d63e0fda3c28297c4316b49c0e2a9fb1.camel@suse.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 2 Dec 2022 17:44:58 -0600
Message-ID: <CAAMCDeeAQL8yaq2HVE+hFdYv=Ax7aSCn0gqKEW2AV-jzzN9esg@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 2/2] multipath.conf(5): improve documentation
 of dev_loss_tmo
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4456309785400207262=="

--===============4456309785400207262==
Content-Type: multipart/alternative; boundary="00000000000086b05805eee0ed24"

--00000000000086b05805eee0ed24
Content-Type: text/plain; charset="UTF-8"

Thanks.

The older distribution I checked has this for -T
     -T tm:valid
              check if tm matches the multipathd configuration timestamp
value from /run/multipathd/timestamp If so, return success if valid is 1.
Otherwise, return failure. If the timestamp doesn't match continue with
multipath execution.  This option is designed to be used with -c by the
udev rules.

So really weird option.

On Fri, Dec 2, 2022 at 4:49 PM Martin Wilck <mwilck@suse.com> wrote:

> On Fri, 2022-12-02 at 14:48 -0600, Roger Heflin wrote:
> > Reading through it, on the line below, shouldn't it be -t (not -T)?
> >
>
> No, -T is correct. -t prints the entire internal table, most of which
> doesn't apply on any given system. -T prints only the settings for
> hardware that's present in the given system, which is what most users
> will prefer (I assume).
>
> But thanks for reading carefully. Appreciated!
>
> Martin
>
>
>
> > Line:
> > +the multipath-tools built-in settings override the default. Run
> > \fImultipath -T\fR
> >
> > On Fri, Dec 2, 2022 at 11:58 AM Martin Wilck <mwilck@suse.com> wrote:
> > > On Fri, 2022-12-02 at 18:57 +0100, Martin Wilck wrote:
> > > > On Fri, 2022-12-02 at 18:31 +0100, Xose Vazquez Perez wrote:
> > > > > On 12/1/22 11:32, mwilck@suse.com wrote:
> > > > >
> > > > > > From: Martin Wilck <mwilck@suse.com>
> > > > > >
> > > > > > The statement that the default is 600 is wrong in most cases.
> > > > > > Improve the description of the default and the dependency of
> > > > > > this
> > > > > > parameter on other parameters.
> > > > >
> > > > > I did change this patch to move "default value" to bottom.
> > > >
> > > > The problem is that there is no easily explained default value
> > > > for
> > > > this
> > > > parameter. Nice as the common "default value" format is, it
> > > > doesn't
> > > > apply here.
> > > >
> > > > If you have a suggestion for improving the formatting or wording,
> > > > please speak up.
> > >
> > > Sorry, I missed your other email because it had been sorted into a
> > > different folder.
> > >
> > > Martin
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/dm-devel
> > >
>
>

--00000000000086b05805eee0ed24
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thanks.</div><div><br></div><div>The older distributi=
on I checked has this for -T</div><div>=C2=A0 =C2=A0=C2=A0 -T tm:valid<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 check if tm matches the mu=
ltipathd configuration timestamp value from /run/multipathd/timestamp If so=
, return success if valid is 1. Otherwise, return failure. If the timestamp=
 doesn&#39;t match continue with multipath execution.=C2=A0 This option is =
designed to be used with -c by the udev rules.</div><div><br></div><div>So =
really weird option.<br></div></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Fri, Dec 2, 2022 at 4:49 PM Martin Wilck &=
lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bord=
er-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, 2022-12-02 at =
14:48 -0600, Roger Heflin wrote:<br>
&gt; Reading through it, on the line below, shouldn&#39;t it be -t (not -T)=
?<br>
&gt; <br>
<br>
No, -T is correct. -t prints the entire internal table, most of which<br>
doesn&#39;t apply on any given system. -T prints only the settings for<br>
hardware that&#39;s present in the given system, which is what most users<b=
r>
will prefer (I assume).<br>
<br>
But thanks for reading carefully. Appreciated!<br>
<br>
Martin<br>
<br>
<br>
<br>
&gt; Line:<br>
&gt; +the multipath-tools built-in settings override the default. Run<br>
&gt; \fImultipath -T\fR<br>
&gt; <br>
&gt; On Fri, Dec 2, 2022 at 11:58 AM Martin Wilck &lt;<a href=3D"mailto:mwi=
lck@suse.com" target=3D"_blank">mwilck@suse.com</a>&gt; wrote:<br>
&gt; &gt; On Fri, 2022-12-02 at 18:57 +0100, Martin Wilck wrote:<br>
&gt; &gt; &gt; On Fri, 2022-12-02 at 18:31 +0100, Xose Vazquez Perez wrote:=
<br>
&gt; &gt; &gt; &gt; On 12/1/22 11:32, <a href=3D"mailto:mwilck@suse.com" ta=
rget=3D"_blank">mwilck@suse.com</a>=C2=A0wrote:<br>
&gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; From: Martin Wilck &lt;<a href=3D"mailto:mwilck@su=
se.com" target=3D"_blank">mwilck@suse.com</a>&gt;<br>
&gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; The statement that the default is 600 is wrong in =
most cases.<br>
&gt; &gt; &gt; &gt; &gt; Improve the description of the default and the dep=
endency of<br>
&gt; &gt; &gt; &gt; &gt; this<br>
&gt; &gt; &gt; &gt; &gt; parameter on other parameters.<br>
&gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; I did change this patch to move &quot;default value&quo=
t; to bottom.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; The problem is that there is no easily explained default val=
ue<br>
&gt; &gt; &gt; for<br>
&gt; &gt; &gt; this<br>
&gt; &gt; &gt; parameter. Nice as the common &quot;default value&quot; form=
at is, it<br>
&gt; &gt; &gt; doesn&#39;t<br>
&gt; &gt; &gt; apply=C2=A0here.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; If you have a suggestion for improving the formatting or wor=
ding,<br>
&gt; &gt; &gt; please speak up.<br>
&gt; &gt; <br>
&gt; &gt; Sorry, I missed your other email because it had been sorted into =
a<br>
&gt; &gt; different folder.<br>
&gt; &gt; <br>
&gt; &gt; Martin<br>
&gt; &gt; <br>
&gt; &gt; --<br>
&gt; &gt; dm-devel mailing list<br>
&gt; &gt; <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel=
@redhat.com</a><br>
&gt; &gt; <a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" =
rel=3D"noreferrer" target=3D"_blank">https://listman.redhat.com/mailman/lis=
tinfo/dm-devel</a><br>
&gt; &gt; <br>
<br>
</blockquote></div>

--00000000000086b05805eee0ed24--

--===============4456309785400207262==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4456309785400207262==--

