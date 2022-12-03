Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECADC4321E
	for <dm-devel@archiver.kernel.org>; Sat,  3 Dec 2022 00:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670025679;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=rjgNr11dCNwMuBtqTTJNCVDADyeWG65yl3pT6hqGTcs=;
	b=dkUeeUIe/yYIArnfB2vhc+VgthEwr82Xh3JBa7uRb0tdqycp++z+XUwsh+uwt2pMa+ErYE
	+A4uX/J2p0Gt9ELWdwi3trDgJrhtFIX1POdxX7nYF7n5nkrc4PUgLOH3/z0deq/9Scv0kY
	eh7QVNn37eK9QQY7mmboPBy1csxf070=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-c6sWW2izNhORFzYC1OFNvA-1; Fri, 02 Dec 2022 19:01:15 -0500
X-MC-Unique: c6sWW2izNhORFzYC1OFNvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B58941C05AEB;
	Sat,  3 Dec 2022 00:01:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A33A440C955A;
	Sat,  3 Dec 2022 00:01:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65B73194658F;
	Sat,  3 Dec 2022 00:01:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B9B1194658F
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 00:01:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CBB8F4EA4D; Sat,  3 Dec 2022 00:01:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C3B7C63AE0
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:01:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4501811E67
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:01:12 +0000 (UTC)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com
 [209.85.217.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-2QwXydt1MvmQNiux2ENyCw-1; Fri, 02 Dec 2022 19:01:10 -0500
X-MC-Unique: 2QwXydt1MvmQNiux2ENyCw-1
Received: by mail-vs1-f45.google.com with SMTP id c184so6152784vsc.3;
 Fri, 02 Dec 2022 16:01:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=cpPP5IPbCEAtOlnAgTVSGnhKCPm55K4CTFQkbCln/Yk=;
 b=gS8DXBgff4LTPXZ0syrNW0tStWl4PTHhGBWJkwRBx0FZ54eN5pJd3B6FH/+QejiVh4
 V01YYvYagOgUrkg25rIvWti/gywPGYK7ly8dYvYFQP51oNhuZKZjBkPwuJ/2zF4eXw+c
 UTgigozlCC6EAvt8mKn/LL33QXege5vqIrS8Hw8Jp/+JIxNxmIhpqmWTbkWjI5MDyAHK
 6VOdUxaQTVKg+fP5ecSRxMvevR9jEw+RKd4JOnr4LEzuHRPeX5qmXjZgs02xJNVGxpzt
 yqJtY15FtNCtpM0PNRfNFDNSpJ3g03Hjw4z2oqFw4LlZJpQJ4tcfTVFZruuFxDwcFhj9
 vJPg==
X-Gm-Message-State: ANoB5pkbDlLNbhd+8k6SFxIWuYdwEDbKKPVjqK3y5ReU5X6gMAtn3l6w
 LdCDb1ktuSQK8vTt84jCAaWGvl7HJfMaiRBAXAI=
X-Google-Smtp-Source: AA0mqf7IVNqXlI0nLJvatbP/tB89tXQhyzEc0nAQ1aD1zz8kTKXvuRmOCUG4mK0RjUkVciXeUsilRlfPjHlRJ0qhEC0=
X-Received: by 2002:a67:fb52:0:b0:3b1:1914:e63d with SMTP id
 e18-20020a67fb52000000b003b11914e63dmr2221131vsr.40.1670025670093; Fri, 02
 Dec 2022 16:01:10 -0800 (PST)
MIME-Version: 1.0
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
 <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
 <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
 <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
 <e506d4c8d63e0fda3c28297c4316b49c0e2a9fb1.camel@suse.com>
 <CAAMCDeeAQL8yaq2HVE+hFdYv=Ax7aSCn0gqKEW2AV-jzzN9esg@mail.gmail.com>
 <cf398b5ccefd3a1a6f458ab5e4811f8f6afc415c.camel@suse.com>
In-Reply-To: <cf398b5ccefd3a1a6f458ab5e4811f8f6afc415c.camel@suse.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 2 Dec 2022 18:00:58 -0600
Message-ID: <CAAMCDeeUkfetN6ABUcDTU29m0yR1gv7UPh8_2HtLg_ZPBougXg@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7937598591228735865=="

--===============7937598591228735865==
Content-Type: multipart/alternative; boundary="000000000000d4f02205eee126b2"

--000000000000d4f02205eee126b2
Content-Type: text/plain; charset="UTF-8"

One of the Enterprise 7 variants, Claims "0.4.9" multipath but appears to
have a number of recent features backported, so some frankensteined version.

On Fri, Dec 2, 2022 at 5:50 PM Martin Wilck <mwilck@suse.com> wrote:

> On Fri, 2022-12-02 at 17:44 -0600, Roger Heflin wrote:
> > Thanks.
> >
> > The older distribution I checked has this for -T
> >      -T tm:valid
> >               check if tm matches the multipathd configuration
> > timestamp value from /run/multipathd/timestamp If so, return success
> > if valid is 1. Otherwise, return failure. If the timestamp doesn't
> > match continue with multipath execution.  This option is designed to
> > be used with -c by the udev rules.
>
> Strange, I can't find this anywhere in the sources I know.
> What distro is this? "multipath -T" in the sense I described has
> existed since 0.7.7, so for more than 4 years.
>
> Martin
>
>

--000000000000d4f02205eee126b2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">One of the Enterprise 7 variants, Claims &quot;0.4.9&quot;=
 multipath but appears to have a number of recent features backported, so s=
ome frankensteined version.<br></div><br><div class=3D"gmail_quote"><div di=
r=3D"ltr" class=3D"gmail_attr">On Fri, Dec 2, 2022 at 5:50 PM Martin Wilck =
&lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, 2022-12-02 at=
 17:44 -0600, Roger Heflin wrote:<br>
&gt; Thanks.<br>
&gt; <br>
&gt; The older distribution I checked has this for -T<br>
&gt; =C2=A0 =C2=A0=C2=A0 -T tm:valid<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 check if tm matches t=
he multipathd configuration<br>
&gt; timestamp value from /run/multipathd/timestamp If so, return success<b=
r>
&gt; if valid is 1. Otherwise, return failure. If the timestamp doesn&#39;t=
<br>
&gt; match continue with multipath execution.=C2=A0 This option is designed=
 to<br>
&gt; be used with -c by the udev rules.<br>
<br>
Strange, I can&#39;t find this anywhere in the sources I know.<br>
What distro is this? &quot;multipath -T&quot; in the sense I described has<=
br>
existed since 0.7.7, so for more than 4 years.<br>
<br>
Martin<br>
<br>
</blockquote></div>

--000000000000d4f02205eee126b2--

--===============7937598591228735865==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7937598591228735865==--

