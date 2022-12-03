Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 813CEC4321E
	for <dm-devel@archiver.kernel.org>; Sat,  3 Dec 2022 00:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670026775;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=J8scLUDv+DYY1hAn2sXM+aV1qpPmyO2evzTs+Nn7738=;
	b=TJzxIi6fEpGa0ASYBcBEDZ5G2r1zP3TDcj02KNQ8iz6XKwYOuiC4AhURFQCP7qKYL65rW+
	SfaesG/W057FrlKQeS0Fe8MSaJu7/3JzLPlX8flFsTZKooA9qKWyqrEU0H1V8R98ss89iQ
	C7cH/tw/9WwefmlTRawmwpma78AA/R4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-1IQ_XUxlMHGSWbhVfqnkkw-1; Fri, 02 Dec 2022 19:19:31 -0500
X-MC-Unique: 1IQ_XUxlMHGSWbhVfqnkkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CFFF811E7A;
	Sat,  3 Dec 2022 00:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4CE591400B15;
	Sat,  3 Dec 2022 00:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C223194658F;
	Sat,  3 Dec 2022 00:19:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3FC81946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 00:19:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5652940AE336; Sat,  3 Dec 2022 00:19:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E8E740AE335
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:19:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31D941C05147
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:19:25 +0000 (UTC)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com
 [209.85.221.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-29-AIUL--sLOhCqQTp3KNlHSw-1; Fri, 02 Dec 2022 19:19:21 -0500
X-MC-Unique: AIUL--sLOhCqQTp3KNlHSw-1
Received: by mail-vk1-f180.google.com with SMTP id g137so3004785vke.10;
 Fri, 02 Dec 2022 16:19:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=5h6MwyQ2A5RME/o4SFaLJsbtq6i9pfseN6Yi5zWxs7g=;
 b=d4GHp80yEOQhKpEJiJLfHGGVA92uCKx1oH2qZHYKrJGn1Xs2jNz5ZvgK4vB3GAIkiI
 dYXoMifMpFDmBdH2MqMRDUZxQYYmXZO5wNSzVk7AXukledSpT6B6Hxu9DlmxLmu9LqKT
 j/YP45lUSYQpItlWg8ohiDBHPoKADi0Kdq/Vp9pYkHcL/jx2XBWSVzOwRyFAtRjanlyb
 83v2JyMifX5dqgQA3ppPhTQDMQp0HGLYAWbSiexoZtFFRw51WriIu2bOF08phXmgIZNL
 RPQoAN0EIK9mY8thTfJAVk/eqFHnh3XD40d2eVOqU4cnRph+9AJALd6fh80jR0CCDdqf
 +81w==
X-Gm-Message-State: ANoB5pniZd78FuxUC8Wtp+KX9AfWmCjWeFZi9e3rTeyXtUQiwJeGBoEU
 zS9QuKTKZhtlTvFGeAvSNrGCfnyqWdCP7p0Ib2I=
X-Google-Smtp-Source: AA0mqf4AV/KG9bdJwXsLCSNUgufdxXGe/fiYp72Utf6InxvIGsnIRACU43RxNm3n1jgrEd4H21LV+P9Z2YS3jrH0P38=
X-Received: by 2002:a1f:2e12:0:b0:3b8:10e1:f026 with SMTP id
 u18-20020a1f2e12000000b003b810e1f026mr31463124vku.16.1670026760535; Fri, 02
 Dec 2022 16:19:20 -0800 (PST)
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
Date: Fri, 2 Dec 2022 18:19:09 -0600
Message-ID: <CAAMCDef-BLQ_bDAdvLho7NCaohL21yDN2MnjFdEFWWvEuUP9fQ@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3410345787531956457=="

--===============3410345787531956457==
Content-Type: multipart/alternative; boundary="000000000000d3c19305eee1671e"

--000000000000d3c19305eee1671e
Content-Type: text/plain; charset="UTF-8"

Enterprise 8 seems to have the new -T option, so clearly the old option had
limited use, and went away.

I had to read the updates to make sure I was not missing anything in my
understanding of that timeout.    We override the vendors setting on a
number of arrays (we use 87400 seconds, long enough that the paths stay
around for normal array work-fw updates and reboot but short enough the
paths go away if really gone).    We have a very large footprint of arrays
and hosts so have a lot of operational experience debugging issues caused
by poor defaults interacting ( multipath, scsi, cluster,  and applications
timeouts).

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

--000000000000d3c19305eee1671e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Enterprise 8 seems to have the new -T option, so clea=
rly the old option had limited use, and went away.</div><div><br></div><div=
>I had to read the updates to make sure I was not missing anything in my un=
derstanding of that timeout.=C2=A0=C2=A0=C2=A0 We override the vendors sett=
ing on a number of arrays (we use 87400 seconds, long enough that the paths=
 stay around for normal array work-fw updates and reboot but short enough t=
he paths go away if really gone).=C2=A0=C2=A0=C2=A0 We have a very large fo=
otprint of arrays and hosts so have a lot of operational experience debuggi=
ng issues caused by poor defaults interacting ( multipath, scsi, cluster,=
=C2=A0 and applications timeouts).<br></div></div><br><div class=3D"gmail_q=
uote"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Dec 2, 2022 at 4:49 PM =
Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank">mwilc=
k@suse.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">On Fri, 2022-12-02 at 14:48 -0600, Roger Heflin wrote:<br>
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

--000000000000d3c19305eee1671e--

--===============3410345787531956457==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3410345787531956457==--

