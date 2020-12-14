Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D07C4361B
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 10:20:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24FFF22B47
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 10:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24FFF22B47
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=opensvc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-wWRuw0tPNpufH97r5fwyHQ-1; Mon, 14 Dec 2020 05:20:10 -0500
X-MC-Unique: wWRuw0tPNpufH97r5fwyHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFC9F107ACE3;
	Mon, 14 Dec 2020 10:20:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6268762692;
	Mon, 14 Dec 2020 10:20:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 951CC180954D;
	Mon, 14 Dec 2020 10:20:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BEAK1ch024325 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 05:20:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C1A482166B2F; Mon, 14 Dec 2020 10:20:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB8112166B2B
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 10:19:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44AB0186E124
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 10:19:57 +0000 (UTC)
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net
	[217.70.183.201]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-339-TqIKB3A_OJ2p8YYe_TxnUg-1; Mon, 14 Dec 2020 05:19:51 -0500
X-MC-Unique: TqIKB3A_OJ2p8YYe_TxnUg-1
X-Originating-IP: 209.85.167.53
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
	[209.85.167.53]) (Authenticated sender: smtp@opensvc.com)
	by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 893231BF219;
	Mon, 14 Dec 2020 10:19:49 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id a12so28786511lfl.6;
	Mon, 14 Dec 2020 02:19:49 -0800 (PST)
X-Gm-Message-State: AOAM533HbLBDjgBlJPLYKcfHMNJyC+wT8QY1c4/vm47GkQj2iYRsxKu1
	rly03BHDaH7thptURcu3rFqW5ZTh4UQ7jc82+oc=
X-Google-Smtp-Source: ABdhPJz+cS81I2QHudiJ14lOoOsCkbk0lciGXbBvc7Hft0nE3WfRSgty6eFfUy7KVfv8grcErOXDn8QBXrs2AcjQSfc=
X-Received: by 2002:ac2:510c:: with SMTP id q12mr7019024lfb.654.1607941188695; 
	Mon, 14 Dec 2020 02:19:48 -0800 (PST)
MIME-Version: 1.0
References: <CABr-GnfTqde6t2LFTHbrRkp1qMVbsRUEFBqU6tW1M_uR1svHFg@mail.gmail.com>
	<d40f6d93d398a3bbb6b9a42d67f47521d35c4d65.camel@suse.com>
In-Reply-To: <d40f6d93d398a3bbb6b9a42d67f47521d35c4d65.camel@suse.com>
From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 14 Dec 2020 11:19:37 +0100
X-Gmail-Original-Message-ID: <CABr-GnfpHZ97dqD_XrgggjDVzK+_1g-sU-SHic_2jA2S=TDK0Q@mail.gmail.com>
Message-ID: <CABr-GnfpHZ97dqD_XrgggjDVzK+_1g-sU-SHic_2jA2S=TDK0Q@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] uxsock_timeout default value in man page
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============1659260593072783670=="

--===============1659260593072783670==
Content-Type: multipart/alternative; boundary="0000000000005f3a8305b669fbab"

--0000000000005f3a8305b669fbab
Content-Type: text/plain; charset="UTF-8"

Thank you for the review, the commit is in.

the user reporting this, seems to face exactly the problem mentioned in
7db0c44 :

commit 7db0c4466c0e5ed2179710f93d1d14a0bf92922a
...
    And the default timeout should be increased to 4 seconds to ensure
    multipath runs correctly on large installations.

He clearly qualifies as "large installation", and reach that timeout when
submitting a large number of mpathpersist registers in parallel on boot.
Regardless, needing a uxsock_timeout greater than 4 seconds hints we do
something non-optimal there.
Have you already had a chance to investigate possible enhancements on this ?

Christophe


On Mon, Dec 14, 2020 at 10:39 AM Martin Wilck <mwilck@suse.com> wrote:

> On Mon, 2020-12-14 at 08:56 +0100, Christophe Varoqui wrote:
> > Hello,
> >
> > a user brought to my attention "multipathd show config | grep
> > usock_timeout" does not agree with the default value stated in the
> > manpage : 4000 instead of 1000.
> >
> > And indeed,
> >
> > ./libmpathcmd/mpath_cmd.h:#define DEFAULT_REPLY_TIMEOUT 4000
> >
> > Can you confirm this change is valid ?
>
> Yes.
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>
> You may want to add
>
> Fixes: 7db0c44 ("multipathd: Set CLI timeout correctly")
>
> because that commit changed the timeout without changing the man page.
>
> Martin
>
>
> >
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index d2101ed6..7242d39b 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -1153,7 +1153,7 @@ In these cases it is recommended to increase
> > the CLI timeout to avoid
> >  those issues.
> >  .RS
> >  .TP
> > -The default is: \fB1000\fR
> > +The default is: \fB4000\fR
> >  .RE
> >  .
> >  .
> >
> > Best Regards,
> > Christophe
>
>
>

--0000000000005f3a8305b669fbab
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thank you for the review, the commit is in.<div><br></div>=
<div>the user reporting this, seems to face exactly the problem mentioned i=
n 7db0c44 :</div><div><br></div><div>commit 7db0c4466c0e5ed2179710f93d1d14a=
0bf92922a<br>...</div><div>=C2=A0 =C2=A0 And the default timeout should be =
increased to 4 seconds to ensure<br>=C2=A0 =C2=A0 multipath runs correctly =
on large installations.<br><br></div><div>He clearly qualifies as &quot;lar=
ge installation&quot;, and reach that timeout when submitting a large numbe=
r of mpathpersist=C2=A0registers in parallel on boot.</div><div>Regardless,=
 needing a uxsock_timeout greater than 4 seconds hints we do something non-=
optimal there.</div><div>Have you already had a chance to investigate possi=
ble enhancements on this ?</div><div><br></div><div>Christophe</div><div><b=
r></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmai=
l_attr">On Mon, Dec 14, 2020 at 10:39 AM Martin Wilck &lt;<a href=3D"mailto=
:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">On Mon, 2020-12-14 at 08:56 +0100, Christo=
phe Varoqui wrote:<br>
&gt; Hello,<br>
&gt; <br>
&gt; a user brought to my attention &quot;multipathd show config | grep<br>
&gt; usock_timeout&quot; does not agree with the default value stated in th=
e<br>
&gt; manpage : 4000 instead of 1000.<br>
&gt; <br>
&gt; And indeed,<br>
&gt; <br>
&gt; ./libmpathcmd/mpath_cmd.h:#define DEFAULT_REPLY_TIMEOUT 4000<br>
&gt; <br>
&gt; Can you confirm this change is valid ?<br>
<br>
Yes. <br>
Reviewed-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"=
_blank">mwilck@suse.com</a>&gt;<br>
<br>
You may want to add<br>
<br>
Fixes: 7db0c44 (&quot;multipathd: Set CLI timeout correctly&quot;)<br>
<br>
because that commit changed the timeout without changing the man page.<br>
<br>
Martin<br>
<br>
<br>
&gt; <br>
&gt; diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<b=
r>
&gt; index d2101ed6..7242d39b 100644<br>
&gt; --- a/multipath/multipath.conf.5<br>
&gt; +++ b/multipath/multipath.conf.5<br>
&gt; @@ -1153,7 +1153,7 @@ In these cases it is recommended to increase<br>
&gt; the CLI timeout to avoid<br>
&gt;=C2=A0 those issues.<br>
&gt;=C2=A0 .RS<br>
&gt;=C2=A0 .TP<br>
&gt; -The default is: \fB1000\fR<br>
&gt; +The default is: \fB4000\fR<br>
&gt;=C2=A0 .RE<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .<br>
&gt; <br>
&gt; Best Regards,<br>
&gt; Christophe<br>
<br>
<br>
</blockquote></div>

--0000000000005f3a8305b669fbab--

--===============1659260593072783670==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============1659260593072783670==--

