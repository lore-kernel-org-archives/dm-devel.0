Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D21C47088
	for <dm-devel@archiver.kernel.org>; Fri,  2 Dec 2022 20:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670014107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=0HxNQIY96rIqxnkK3Y5n9L25whi4tE64uQSN3IJrVkY=;
	b=BsdeG4dORyW2Yu8yx/p3HJsJqlIHclweagUWww7/MuVNaIhbGELKBP0Dj4p4+tr1Zn+RnC
	B+nYlgjShhi8eJ00P6E3zARgnL0666ZDkq6WmGic4bgvoxWatzocv2TDupAQGiIMEmrIyB
	8scB6EvP3ApS2gkEpA1PKs3rny15ilQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-mo81pL7ZN3-BojK2LeNV7w-1; Fri, 02 Dec 2022 15:48:23 -0500
X-MC-Unique: mo81pL7ZN3-BojK2LeNV7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62E2A894E8C;
	Fri,  2 Dec 2022 20:48:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F25A39D7C;
	Fri,  2 Dec 2022 20:48:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A8A3194658F;
	Fri,  2 Dec 2022 20:48:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D97871946587
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Dec 2022 20:48:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CB66AC15BB4; Fri,  2 Dec 2022 20:48:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C3740C1908E
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 20:48:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A74203C0F220
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 20:48:18 +0000 (UTC)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com
 [209.85.217.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-gWoFmbK2MdeIg8whyQhIXw-1; Fri, 02 Dec 2022 15:48:15 -0500
X-MC-Unique: gWoFmbK2MdeIg8whyQhIXw-1
Received: by mail-vs1-f42.google.com with SMTP id 128so5741669vsz.12;
 Fri, 02 Dec 2022 12:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=EPt8quabOFxTiImNRRjEmsQ8hPHZ75Rk5T825/PHxxw=;
 b=cHmOWRypCPnVytvj/pLLLK23UZ9bxGIU9tj6jOmrMlQ6E9GPCCT2LL8IQlCjitFZ/g
 A2ZcAw2BZlToBj7YKvbqyUgJtJljfMI155IZ2wqjpPp/1KOgIGKFPqhdGunMq0aj5Ez1
 4OMUA69IO04NPRJKwYOvirWzQ1QB1zogpXo6jn5OaUHEEm8OwgRzhQfH7Mspjjhiqh+n
 O12VaGnoZhoafUdVLQCfF6eGeVP/i3IuFz0nJBfx3apsj70tnT8ENXKt5RxIvfEjUpho
 Rjt94/KRr0kbNCTWg3a4VZnXoEm3l0p+M2doVnlqm/LFtMPgL+Yk9b+tgkDWtyD7RjE9
 31FA==
X-Gm-Message-State: ANoB5pkgzJrdHea3riTUDULFCEUlQTTHnTRtgwQS6nxHXpgDPQcHSkpT
 LW8Ikk/lpWqWH+MmNImnAJn1HN4iapax/V4i5ig=
X-Google-Smtp-Source: AA0mqf641b7hJgxJbrM6/q/e9RAYc/wPmPbirZuE9FByU9fEIlONkG937PaLbadHKo6y0sClinxWoRoVH0joogxZTks=
X-Received: by 2002:a05:6102:3354:b0:3a9:8207:bb1a with SMTP id
 j20-20020a056102335400b003a98207bb1amr32771429vse.58.1670014094181; Fri, 02
 Dec 2022 12:48:14 -0800 (PST)
MIME-Version: 1.0
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
 <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
 <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
In-Reply-To: <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 2 Dec 2022 14:48:03 -0600
Message-ID: <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============1695860401171543093=="

--===============1695860401171543093==
Content-Type: multipart/alternative; boundary="000000000000da8a2405eede741f"

--000000000000da8a2405eede741f
Content-Type: text/plain; charset="UTF-8"

Reading through it, on the line below, shouldn't it be -t (not -T)?

Line:
+the multipath-tools built-in settings override the default. Run
\fImultipath -T\fR

On Fri, Dec 2, 2022 at 11:58 AM Martin Wilck <mwilck@suse.com> wrote:

> On Fri, 2022-12-02 at 18:57 +0100, Martin Wilck wrote:
> > On Fri, 2022-12-02 at 18:31 +0100, Xose Vazquez Perez wrote:
> > > On 12/1/22 11:32, mwilck@suse.com wrote:
> > >
> > > > From: Martin Wilck <mwilck@suse.com>
> > > >
> > > > The statement that the default is 600 is wrong in most cases.
> > > > Improve the description of the default and the dependency of this
> > > > parameter on other parameters.
> > >
> > > I did change this patch to move "default value" to bottom.
> >
> > The problem is that there is no easily explained default value for
> > this
> > parameter. Nice as the common "default value" format is, it doesn't
> > apply here.
> >
> > If you have a suggestion for improving the formatting or wording,
> > please speak up.
>
> Sorry, I missed your other email because it had been sorted into a
> different folder.
>
> Martin
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>
>

--000000000000da8a2405eede741f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Reading through it, on the line below, shouldn&#39;t =
it be -t (not -T)?</div><div><br></div><div>Line:<br></div><div>
+the multipath-tools built-in settings override the default. Run \fImultipa=
th -T\fR

</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_=
attr">On Fri, Dec 2, 2022 at 11:58 AM Martin Wilck &lt;<a href=3D"mailto:mw=
ilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(2=
04,204,204);padding-left:1ex">On Fri, 2022-12-02 at 18:57 +0100, Martin Wil=
ck wrote:<br>
&gt; On Fri, 2022-12-02 at 18:31 +0100, Xose Vazquez Perez wrote:<br>
&gt; &gt; On 12/1/22 11:32, <a href=3D"mailto:mwilck@suse.com" target=3D"_b=
lank">mwilck@suse.com</a>=C2=A0wrote:<br>
&gt; &gt; <br>
&gt; &gt; &gt; From: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" ta=
rget=3D"_blank">mwilck@suse.com</a>&gt;<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; The statement that the default is 600 is wrong in most cases=
.<br>
&gt; &gt; &gt; Improve the description of the default and the dependency of=
 this<br>
&gt; &gt; &gt; parameter on other parameters.<br>
&gt; &gt; <br>
&gt; &gt; I did change this patch to move &quot;default value&quot; to bott=
om.<br>
&gt; <br>
&gt; The problem is that there is no easily explained default value for<br>
&gt; this<br>
&gt; parameter. Nice as the common &quot;default value&quot; format is, it =
doesn&#39;t<br>
&gt; apply=C2=A0here.<br>
&gt; <br>
&gt; If you have a suggestion for improving the formatting or wording,<br>
&gt; please speak up.<br>
<br>
Sorry, I missed your other email because it had been sorted into a<br>
different folder.<br>
<br>
Martin<br>
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

--000000000000da8a2405eede741f--

--===============1695860401171543093==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1695860401171543093==--

