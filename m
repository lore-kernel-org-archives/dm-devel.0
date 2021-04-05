Return-Path: <SRS0=HU+X=JD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00997C433ED
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:42:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FE99613BD
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:42:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FE99613BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-JXHu-QgUMJChzQrEvsMcuQ-1; Tue, 06 Apr 2021 07:42:17 -0400
X-MC-Unique: JXHu-QgUMJChzQrEvsMcuQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B298108BD09;
	Tue,  6 Apr 2021 11:42:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15F2360C4A;
	Tue,  6 Apr 2021 11:42:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D15C11800232;
	Tue,  6 Apr 2021 11:42:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13560Yl3025182 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 5 Apr 2021 02:00:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C24922026D64; Mon,  5 Apr 2021 06:00:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB30D2026D65
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 06:00:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF37D805F07
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 06:00:31 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1617602431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=12PynBTwzvMb7HbrXu59edQj5Kio1im3HGs2RkWTBKY=;
	b=XoHDrHSx3UzF3JmnBhbWwHZUJiUHUCTQ+1yR0yaqtP6gK55kvXrCFfhskEJ8yAnZlAd28r
	9n36VUBStGUvp2L2AAzeyYHjvLnWMD8HkIEXYqzbY1WVUooQyGGYPsHjMccKDSk1yqtqad
	9pmOZqek6bZGr8VVe9Gl+S2mNoXyJbXU+JnyfAR+a56OxFL2T/ekCItxvlQ517lxIOrQPw
	dCxU+uBv7yGqVzDfOCv6GLNsgPObYHQu7pxTzbbqbTyqFSt63eWMUHq6mFAiLYL/BBIvy2
	HhLCRL8fEVM7OvCWgPE6MX8AbzJMLR5sNm4pruohlJHOudTTeYykP+zhTAjU9A==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1617602431; a=rsa-sha256;
	cv=none;
	b=efrg0KLDD4neyLaQHnFd1sn7JvcBXHcZXru6cOe4bQ1BODCiu2JhjfOZYZ0NaLkvHqZLQH
	mcEqDecDiL0A4ArRhMvHf71R1P4OuAAgsO/RKKJj0bckP7AKIFeCNOsm7fPfts7cvwigwd
	uvguCaGYhG/iQ7PkfXdF01pBAM1b4vmoYlLD6/pbPNiL2yCRYxhA5M8wv8e/8qZe8rXCUL
	3qV0ciVuAZhdtq5e2fbmdfAeymn28EBE0sFrlMEGDPlYSzVOJyNaEs2m49HIevvDZxm/+8
	IOJd5CfQF8F307RNvr6yBaj8fHa3bdbnqXhUgOrdXzhW6yPw+a4dfvefhETCWQ==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=neutral (relay.mimecast.com: 192.185.145.100 is neither permitted
	nor denied by domain of erwin@erwinvanlonden.net)
	smtp.mailfrom=erwin@erwinvanlonden.net
Received: from gateway32.websitewelcome.com (gateway32.websitewelcome.com
	[192.185.145.100]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-292-XJKOrj1UNZafEKIs4bqvxQ-1; Mon, 05 Apr 2021 02:00:28 -0400
X-MC-Unique: XJKOrj1UNZafEKIs4bqvxQ-1
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
	by gateway32.websitewelcome.com (Postfix) with ESMTP id 78F822DB5004
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 01:00:27 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id TIHilkEs3w11MTIHjlT28X; Mon, 05 Apr 2021 01:00:27 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:55192
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lTIHi-0003wL-3X; Mon, 05 Apr 2021 00:00:26 -0600
Message-ID: <d10003acef1196b9b49212af937b4698505c4ffa.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>, Martin Wilck
	<martin.wilck@suse.com>, bblock@linux.ibm.com, hare@suse.de
In-Reply-To: <47a0bf4bb540f052625afeb78ce6e592@mail.gmail.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
	<7b5ce0567f03bc3d394481642a97a3d499fe3976.camel@erwinvanlonden.net>
	<93f19c1bb5731394225f71936e1cc44509020152.camel@suse.com>
	<d6c3e5c7682d209263de5ca3612228b9468051a2.camel@erwinvanlonden.net>
	<47a0bf4bb540f052625afeb78ce6e592@mail.gmail.com>
Date: Mon, 05 Apr 2021 15:55:15 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33)
X-AntiAbuse: This header was added to track abuse,
	please include it with any abuse report
X-AntiAbuse: Primary Hostname - just2098.justhost.com
X-AntiAbuse: Original Domain - redhat.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - erwinvanlonden.net
X-BWhitelist: no
X-Source-IP: 116.240.66.4
X-Source-L: No
X-Exim-ID: 1lTIHi-0003wL-3X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:55192
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 2
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=neutral (relay.mimecast.com: 192.185.145.100 is neither permitted
	nor denied by domain of erwin@erwinvanlonden.net)
	smtp.mailfrom=erwin@erwinvanlonden.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 06 Apr 2021 07:35:52 -0400
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
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
Content-Type: multipart/mixed; boundary="===============0810835392645258640=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============0810835392645258640==
Content-Type: multipart/signed; micalg="pgp-sha1";
	protocol="application/pgp-signature"; 
	boundary="=-I3C13NWvVNVDfusAiORx"

--=-I3C13NWvVNVDfusAiORx
Content-Type: multipart/related; type="multipart/alternative";
	boundary="=-TRN8V7e+GsD1lQJme82r"

--=-TRN8V7e+GsD1lQJme82r
Content-Type: multipart/alternative; boundary="=-Xipf0kRu9X2c7bTi/Q/9"

--=-Xipf0kRu9X2c7bTi/Q/9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Muneendra,

On Mon, 2021-04-05 at 11:00 +0530, Muneendra Kumar M wrote:
> Hi Erwin,
> Below are my replies.
> =C2=A0
> On Thu, 2021-04-01 at 10:16 +0000, Martin Wilck wrote:
> > On Thu, 2021-04-01 at 12:48 +1000, Erwin van Londen wrote:
> > > > =C2=A0
> > > > Benjamin has added a marginal_path group(multipath marginal
> > > > pathgroups) in
> > > > the dm-multipath.
> > > >
> https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-1-gi=
t
> > > > -send-email-bmarzins@redhat.com/
> > > > =C2=A0
> > > > One of the intention of the Benjamin's patch (support for
> > > > maginal
> > > > path) is
> > > > to support for the FPIN events we receive from fabric.
> > > > On receiving the fpin-li our intention was to=C2=A0 place all the
> > > > paths
> > > > that
> > > > are affected into the marginal path group.
> > > I think this should all be done in kernel space as we're talking
> > > sub-
> > > millisecond timings here when it comes to fpins and the reaction
> > > time
> > > expected. I may be wrong but I'll leave that up to you.
> > =C2=A0
> > Sub-ms latency is impossible with this setup=C2=A0 (kernel -> broadcom
> > FC
> > daemon -> multipathd -> kernel). It's only suitable for "fatal"
> > FPINs
> > that would suggest taking a path offline on the time scale of
> > minutes.
> > I suppose that would work well for LN FPINs, but not for the other
> > types.
>=20
> >>I agree. I was hoping the FC drivers would be able to play a role
> in this and provide a direct hook into the FPIN notifications in such
> a way that userspace daemons would not be required and multipath
> would >>be able to play a direct role here.
> >>When it comes to latency in a san we're indeed talking about sub-ms
> when it comes to impacting other parts of the fabrics having an
> immediate effect on multiple initiators and targets due to the shared
> nature >>of the beast.
> >>=C2=A0
> > =C2=A0
> > > > =C2=A0
> > > > On receiving the congestion notifications our intention is to
> > > > slowdown the
> > > > work load gradually from the host until it stops receiving the
> > > > congestion
> > > > notifications.
> > > > We need to validate the same how we can achieve the same of
> > > > decreasing the
> > > > workloads with the help of dm-multipath.
> > > Would it be possible to piggyback on the service time path
> > > selector
> > > in this when it pertains latency? =C2=A0
> > =C2=A0
> > Not on service-time itself, but someone could write a new path
> > selector
> > algorithm. IMO we'd still have the problem that this would be seen
> > as a
> > layering violation. In the long run dm-mpath may need to add
> > transport-
> > specific callbacks. But for a proof-of-concept, a selector
> > algorithm
> > with layering violations would be ok, I believe.
>=20
> >>Is that an offer of volunteering?? :-)
> [Muneendra]To address all the issues we are planning to come up with
> new dm-path selector algorithm which should address=20
> the above concerns where FC drivers will do a direct hook into the
> FPIN notifications in such a way that userspace daemons would not be
> required and multipath would be able to play a=20
> direct role here.
> Will come up with more details regarding the new dm-path selector
> algorithm for FPIN notifications.

That is awesome. Thank you very much. If you need any input or feedback
then please let me know.
> =C2=A0
> Regards,
> Muneendra.
> =C2=A0
>=20
> This electronic communication and the information and any files
> transmitted with it, or attached to it, are confidential and are
> intended solely for the use of the individual or entity to whom it is
> addressed and may contain information that is confidential, legally
> privileged, protected by privacy laws, or otherwise restricted from
> disclosure to anyone else. If you are not the intended recipient or
> the person responsible for delivering the e-mail to the intended
> recipient, you are hereby notified that any use, copying,
> distributing, dissemination, forwarding, printing, or copying of this
> e-mail is strictly prohibited. If you received this e-mail in error,
> please return the e-mail to the sender, delete it from your computer,
> and destroy any printed copy of it.

--=-Xipf0kRu9X2c7bTi/Q/9
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head><style><!--
/* Font Definitions */
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09margin-bottom:.0001pt;
=09font-size:12.0pt;
=09font-family:"Times New Roman",serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:purple;
=09text-decoration:underline;}
span.EmailStyle17
=09{mso-style-type:personal-reply;
=09font-family:"Calibri",sans-serif;
=09color:#1F497D;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-size:10.0pt;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style></head><body lang=3D"EN-US" link=3D"blue" vlink=3D"purple" style=
=3D"word-wrap: break-word; -webkit-nbsp-mode: space; line-break: after-whit=
e-space;"><div>Hello Muneendra,</div><div><br></div><div>On Mon, 2021-04-05=
 at 11:00 +0530, Muneendra Kumar M wrote:</div><blockquote type=3D"cite" st=
yle=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><=
div class=3D"WordSection1"><p class=3D"MsoNormal"><span style=3D"font-size:=
11.0pt;font-family:&quot;Calibri&quot;,sans-serif;color:#1f497d">Hi Erwin,<=
/span></p><p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-famil=
y:&quot;Calibri&quot;,sans-serif;color:#1f497d">Below are my replies.</span=
></p><p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&qu=
ot;Calibri&quot;,sans-serif;color:#1f497d">&nbsp;</span></p><div><p class=
=3D"MsoNormal">On Thu, 2021-04-01 at 10:16 +0000, Martin Wilck wrote:</p></=
div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #=
729fcf solid;padding-left:1ex"><div><p class=3D"MsoNormal">On Thu, 2021-04-=
01 at 12:48 +1000, Erwin van Londen wrote:</p></div><blockquote type=3D"cit=
e" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1=
ex"><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #=
729fcf solid;padding-left:1ex"><div><p class=3D"MsoNormal">&nbsp;</p></div>=
<div><p class=3D"MsoNormal">Benjamin has added a marginal_path group(multip=
ath marginal</p></div><div><p class=3D"MsoNormal">pathgroups) in</p></div><=
div><p class=3D"MsoNormal">the dm-multipath.</p></div><div><p class=3D"MsoN=
ormal"><a href=3D"https://patchwork.kernel.org/project/dm-devel/cover/15647=
63622-31752-1-git">https://patchwork.kernel.org/project/dm-devel/cover/1564=
763622-31752-1-git</a></p></div><div><p class=3D"MsoNormal"><a href=3D"mail=
to:-send-email-bmarzins@redhat.com">-send-email-bmarzins@redhat.com</a>/</p=
></div><div><p class=3D"MsoNormal">&nbsp;</p></div><div><p class=3D"MsoNorm=
al">One of the intention of the Benjamin's patch (support for maginal</p></=
div><div><p class=3D"MsoNormal">path) is</p></div><div><p class=3D"MsoNorma=
l">to support for the FPIN events we receive from fabric.</p></div><div><p =
class=3D"MsoNormal">On receiving the fpin-li our intention was to&nbsp; pla=
ce all the paths</p></div><div><p class=3D"MsoNormal">that</p></div><div><p=
 class=3D"MsoNormal">are affected into the marginal path group.</p></div></=
blockquote><div><p class=3D"MsoNormal">I think this should all be done in k=
ernel space as we're talking sub-</p></div><div><p class=3D"MsoNormal">mill=
isecond timings here when it comes to fpins and the reaction time</p></div>=
<div><p class=3D"MsoNormal">expected. I may be wrong but I'll leave that up=
 to you.</p></div></blockquote><div><p class=3D"MsoNormal">&nbsp;</p></div>=
<div><p class=3D"MsoNormal">Sub-ms latency is impossible with this setup&nb=
sp; (kernel -&gt; broadcom FC</p></div><div><p class=3D"MsoNormal">daemon -=
&gt; multipathd -&gt; kernel). It's only suitable for "fatal" FPINs</p></di=
v><div><p class=3D"MsoNormal">that would suggest taking a path offline on t=
he time scale of minutes.</p></div><div><p class=3D"MsoNormal">I suppose th=
at would work well for LN FPINs, but not for the other</p></div><div><p cla=
ss=3D"MsoNormal">types.</p></div></blockquote><div><p class=3D"MsoNormal"><=
span style=3D"color:#1f497d">&gt;&gt;</span>I agree. I was hoping the FC dr=
ivers would be able to play a role in this and provide a direct hook into t=
he FPIN notifications in such a way that userspace daemons would not be req=
uired and multipath would <span style=3D"color:#1f497d">&gt;&gt;</span>be a=
ble to play a direct role here.</p></div><div><p class=3D"MsoNormal"><span =
style=3D"color:#1f497d">&gt;&gt;</span>When it comes to latency in a san we=
're indeed talking about sub-ms when it comes to impacting other parts of t=
he fabrics having an immediate effect on multiple initiators and targets du=
e to the shared nature <span style=3D"color:#1f497d">&gt;&gt;</span>of the =
beast.<span style=3D"color:#1f497d"></span></p><p class=3D"MsoNormal"><span=
 style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,sans-serif;color=
:#1f497d">&gt;&gt;&nbsp;</span></p></div><blockquote type=3D"cite" style=3D=
"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div><p=
 class=3D"MsoNormal">&nbsp;</p></div><blockquote type=3D"cite" style=3D"mar=
gin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockquote=
 type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;pa=
dding-left:1ex"><div><p class=3D"MsoNormal">&nbsp;</p></div><div><p class=
=3D"MsoNormal">On receiving the congestion notifications our intention is t=
o</p></div><div><p class=3D"MsoNormal">slowdown the</p></div><div><p class=
=3D"MsoNormal">work load gradually from the host until it stops receiving t=
he</p></div><div><p class=3D"MsoNormal">congestion</p></div><div><p class=
=3D"MsoNormal">notifications.</p></div><div><p class=3D"MsoNormal">We need =
to validate the same how we can achieve the same of</p></div><div><p class=
=3D"MsoNormal">decreasing the</p></div><div><p class=3D"MsoNormal">workload=
s with the help of dm-multipath.</p></div></blockquote><div><p class=3D"Mso=
Normal">Would it be possible to piggyback on the service time path selector=
</p></div><div><p class=3D"MsoNormal">in this when it pertains latency? &nb=
sp;</p></div></blockquote><div><p class=3D"MsoNormal">&nbsp;</p></div><div>=
<p class=3D"MsoNormal">Not on service-time itself, but someone could write =
a new path selector</p></div><div><p class=3D"MsoNormal">algorithm. IMO we'=
d still have the problem that this would be seen as a</p></div><div><p clas=
s=3D"MsoNormal">layering violation. In the long run dm-mpath may need to ad=
d transport-</p></div><div><p class=3D"MsoNormal">specific callbacks. But f=
or a proof-of-concept, a selector algorithm</p></div><div><p class=3D"MsoNo=
rmal">with layering violations would be ok, I believe.</p></div></blockquot=
e><div><p class=3D"MsoNormal"><span style=3D"color:#1f497d">&gt;&gt;</span>=
Is that an offer of volunteering?? <img border=3D"0" width=3D"16" height=3D=
"16" id=3D"_x0000_i1025" src=3D"cid:image001.png@01D72A0A.4F10A750" alt=3D"=
:-)"></p><p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family=
:&quot;Calibri&quot;,sans-serif;color:#1f497d">[Muneendra]To address all th=
e issues we are planning to come up with new dm-path selector algorithm whi=
ch should address </span></p><p class=3D"MsoNormal"><span style=3D"font-siz=
e:11.0pt;font-family:&quot;Calibri&quot;,sans-serif;color:#1f497d">the abov=
e concerns where FC drivers will do a direct hook into the FPIN notificatio=
ns in such a way that userspace daemons would not be required and multipath=
 would be able to play a </span></p><p class=3D"MsoNormal"><span style=3D"f=
ont-size:11.0pt;font-family:&quot;Calibri&quot;,sans-serif;color:#1f497d">d=
irect role here.</span></p><p class=3D"MsoNormal"><span style=3D"font-size:=
11.0pt;font-family:&quot;Calibri&quot;,sans-serif;color:#1f497d">Will come =
up with more details regarding the new dm-path selector algorithm for FPIN =
notifications.</span></p><p class=3D"MsoNormal"></p></div></div></blockquot=
e><div><br></div><div><div>That is awesome. Thank you very much. If you nee=
d any input or feedback then please let me know.</div></div><blockquote typ=
e=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;paddin=
g-left:1ex"><div class=3D"WordSection1"><div><p class=3D"MsoNormal">&nbsp;<=
/p><p class=3D"MsoNormal">Regards,</p><p class=3D"MsoNormal">Muneendra.</p>=
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,sans-serif;color:#1f497d">&nbsp;</span></p></div></div><div><br=
></div><div><span style=3D"background-color:rgb(255,255,255)"><font size=3D=
"2">This electronic communication and the information and any files transmi=
tted with it, or attached to it, are confidential and are intended solely f=
or the use of the individual or entity to whom it is addressed and may cont=
ain information that is confidential, legally privileged, protected by priv=
acy laws, or otherwise restricted from disclosure to anyone else. If you ar=
e not the intended recipient or the person responsible for delivering the e=
-mail to the intended recipient, you are hereby notified that any use, copy=
ing, distributing, dissemination, forwarding, printing, or copying of this =
e-mail is strictly prohibited. If you received this e-mail in error, please=
 return the e-mail to the sender, delete it from your computer, and destroy=
 any printed copy of it.</font></span></div></blockquote></body></html>

--=-Xipf0kRu9X2c7bTi/Q/9--

--=-TRN8V7e+GsD1lQJme82r
Content-Type: image/png; name="image001.png"
Content-Disposition: inline; filename="image001.png"
Content-Transfer-Encoding: base64
Content-ID: <image001.png@01D72A0A.4F10A750>
X-Attachment-Id: 5f4c81bd76e73921_0.1

iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADLklEQVR4AV2MA5Q0uRpAb6raPTj9
G2PjvbVt27btPV7btm3btjW23Swklax5P1PwH+49bYNqQsHhEdvaCSGWasA2esRV5mktwrcdfPHb
ffyDvx48uvvutqwaugzLOqp1hapwWXNrKDZvHgKBm04z3NYuv/q8TSlf3Vg8UnHmHo89Fvz14K2z
NwoN5bxXFqbia627w26JSCqJ1m2YsAtohB9BmDoCJ8lbTz9YGBic+HDBZPVWvz6xATZbZck184oj
22+0x9EJCt/x2HOP8tNImtY1yrBiYYzJcs4591PMBOtufWh4rLdtyZA3OP/lL0dfsW49Zb0GP9CH
rrvptgk59iHBzPv80OfyXXsaEYnBrxZP8nVHnm+/+xav42E2226vhA9HnnfQSvWWdOWxDYsSkUhp
GX73sxgM0YggHrMB/ZsJo3+ro1GBGvkQy59lrZbaiPKCY+wtVl58y9or/T8V8kbQ6R+xYxESC1PU
NS5h+fIoKB9yGVRWsmalJildtONTvPT/1idff7c45AVmcbJkAbmxL8lMeywpcVh1SQx7sYuZGAYD
Opdll1UVctwlyEqmhrsRDWvhSJaGPGmEk5sjYiRaKp5+d5bKSklzs0/J/CQC0I6DM5Pn+x+z/NSd
p26Jw8orhfEDbYWklFMD/e3L6lI28+yALf8/j++nI9zxxBhYGtsSKD8gn1O0lpWySWsR84oX0N/5
FVKqyV8emJe/6ug7qHyVWgtXEcpMseKiJayywoZIO4lUGtuOYCsXPfY9argNv6SaT77+VkulXxIn
7NS0qkXw7naV+URDkcQSWXQ8ihQW0ooRiDg68LC8LLFAETIJevQC7vrMLfi+Wc/+pG1qdNX6eSsN
p2VNqZkIF2tFKDCIQKOlT1DII1yHqPTB8emd83iyXThpx3r2kfcGrrcBVm6MvZDzYrsNFqLF8VAh
bAUBESUJKUX4F8OXzLma7qzguYF5zng+2i0Cs92PQxkl+IP9t1icNCp2nzFmi9qSdKI2WRCpqAJg
xgvRlYmb9tliB8RLrqsPeO6LkQKA4D/svE7l2rbQJwGbB1ACYAkyGF412Fc/+UHfx/yDnwGHuJ5z
2Cp4/gAAAABJRU5ErkJggg==
--=-TRN8V7e+GsD1lQJme82r--

--=-I3C13NWvVNVDfusAiORx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABAgAdFiEEnGxzPPTOzYO47pZEpZCDQR/xNU8FAmBqpkMACgkQpZCDQR/x
NU9eOQf/YHJBkCyuXEfOVfYQyAmM7oFqMyY8+Hup9c0s0MtZCrxvcjbjcFMY5BZJ
vOoO8K4qbJr1yFbYWGoF5DAqcurXD3ZUm2yEcAb6IWGgsZ6S9cNu0cGVoxTUm46p
l1/hVLuRxgEjWalVRWzicoZOfULAls4vHEgZ9hgCLFNoT1bqGdKFFpe6ZMuhmE4T
6N7hulm4V3ogS4y5RlRO8cE5Y1Hd6iaoPD9p5bEiWqRB6UXCLpoZctiCPfR04qXP
JWkc6SPiR5f1ew0RkfxOzGeKhu0uQCEL4HFDKvUQOSvA0QCgK3lu5Opu1JoFdDdI
esfwFpcwm5Sm0+IQ71JzMCb8t78azw==
=dVhC
-----END PGP SIGNATURE-----

--=-I3C13NWvVNVDfusAiORx--


--===============0810835392645258640==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0810835392645258640==--

