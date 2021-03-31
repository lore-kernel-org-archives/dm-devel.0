Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F47C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EBFEE61985
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBFEE61985
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-z1Y5G1v3P0WlVFdh229zdA-1; Wed, 31 Mar 2021 09:32:54 -0400
X-MC-Unique: z1Y5G1v3P0WlVFdh229zdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 241D783DD20;
	Wed, 31 Mar 2021 13:32:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E5E0910016F4;
	Wed, 31 Mar 2021 13:32:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B40194A7CA;
	Wed, 31 Mar 2021 13:32:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12V8IGN7029308 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 04:18:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 090E32166B2D; Wed, 31 Mar 2021 08:18:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 024F92166B44
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 08:18:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 333D9811E7A
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 08:18:13 +0000 (UTC)
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com
	[192.185.47.228]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-187-idYvZYg5Pc2xTyVfKb2udA-1; Wed, 31 Mar 2021 04:18:09 -0400
X-MC-Unique: idYvZYg5Pc2xTyVfKb2udA-1
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
	by gateway22.websitewelcome.com (Postfix) with ESMTP id 82C4A564C
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 03:18:08 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id RW3ElK5ptw11MRW3El5QFg; Wed, 31 Mar 2021 03:18:08 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:41002
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lRW3D-001iPd-D8; Wed, 31 Mar 2021 02:18:07 -0600
Message-ID: <06265a53d3a50353e285cb4b61120bd3cf2ccc7f.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Hannes Reinecke <hare@suse.de>, Muneendra Kumar M
	<muneendra.kumar@broadcom.com>, Benjamin Block <bblock@linux.ibm.com>
In-Reply-To: <8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
Date: Wed, 31 Mar 2021 18:12:57 +1000
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
X-Exim-ID: 1lRW3D-001iPd-D8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:41002
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 3
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
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
X-Mailman-Approved-At: Wed, 31 Mar 2021 09:32:18 -0400
Cc: dm-devel@redhat.com, Wilck <Martin.Wilck@suse.com>, Martin
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============1102831959996881165=="

--===============1102831959996881165==
Content-Type: multipart/alternative; boundary="=-qB86vl340GF995lk/j3p"

--=-qB86vl340GF995lk/j3p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Hannes,

Thanks for responding.

On Wed, 2021-03-31 at 09:25 +0200, Hannes Reinecke wrote:
> Hi Erwin,
>=20
> On 3/31/21 2:22 AM, Erwin van Londen wrote:
> > Hello Muneendra, benjamin,
> >=20
> > The fpin options that are developed do have a whole plethora of
> > options
> > and do not mainly trigger paths being in a marginal state. Th mpio
> > layer
> > could utilise the various triggers like congestion and latency and
> > not
> > just use a marginal state as a decisive point. If a path is
> > somewhat
> > congested the amount of io's dispersed over these paths could just
> > be
> > reduced by a flexible margin depending on how often and which fpins
> > are
> > actually received. If for instance and fpin is recieved that an
> > upstream
> > port is throwing physical errors you may exclude is entirely from
> > queueing IO's to it. If it is a latency related problem where
> > credit
> > shortages come in play you may just need to queue very small IO's
> > to it.
> > The scsi CDB will tell the size of the IO. Congestion notifications
> > may
> > just be used for potentially adding an artificial=C2=A0 delay to reduce
> > the
> > workload on these paths and schedule them on another.
> >=20
> As correctly noted, FPINs come with a variety of options.
> And I'm not certain we can everything correctly; a degraded path is
> simple, but for congestion there is only _so_ much we can do.
> The typical cause for congestion is, say, a 32G host port talking to
> a
> 16G (or even 8G) target port _and_ a 32G target port.
Congestion can also be caused by a change in workload characteristics
where, for example, read and write workload start interfering. The
funnel principle would not apply in that case.
>=20
> So the host cannot 'tune down' it's link to 8G; doing so would impact
> performance on the 32G target port.
> (And we would suffer reverse congestion whenever that target port
> sends
> frames).
>=20
> And throttling things on the SCSI layer only helps _so_ much, as the
> real congestion is due to the speed with which the frames are
> sequenced
> onto the wire. Which is not something we from the OS can control.
If you can interleave IOs with an artificial delay depending on the
type and frequency these FPINS arrive you would be able to prevent
latency buildup in the san.
>=20
> From another POV this is arguably a fabric mis-design; so it _could_
> be
> alleviated by separating out the ports with lower speeds into its own
> zone (or even on a separate SAN); that would trivially make the
> congestion go away.
The entire FPIN concept was designed to be able to provide clients with
the option to respond and react to changing behaviours in sans. A mis-
design is often not really the case but ongoing changes and continuous
provisioning is =C2=A0mainly contributing to the case.=C2=A0
>=20
> But for that the admin first should be _alerted_, and this really is
> my
> primary goal: having FPINs showing up in the message log, to alert
> the
> admin that his fabric is not performing well.
I think the FC drivers are already having facilities to do that or they
will have that shortly. dm-multipath is not really required to handle
the notifications but would be useful if actions have been done based
on fpins.=C2=A0
>=20
> A second step will be to massaging FPINs into DM multipath, and have
> it
> influencing the path priority or path status. But this is currently
> under discussion how it could be integrated best.
OK
>=20
> > Not really sure what the possibilities are from a DM-Multipath
> > viewpoint, but I feel if the OS options are not properly aligned
> > with
> > what the FC protocol and HBA drivers are able to provide we may
> > miss a
> > good opportunity to optimize the dispersion of IO's and improve
> > overall
> > performance.=C2=A0
> >=20
> Looking at the size of the commands is one possibility, but at this
> time
> this presumes too much on how we _think_ FPINs will be generated.
> I'd rather do some more tests to figure out under which circumstances
> we
> can expect which type of FPINs, and then start looking for ways on
> how
> to integrate them.
The FC protocol only describes the framework and not the values that
need to be adhered to. That depends on the end devices and their
capabilities.=C2=A0
>=20
> Cheers,
>=20
> Hannes

--=-qB86vl340GF995lk/j3p
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div>Hello Hannes,</div><div><br></div><div>Thanks=
 for responding.</div><div><span></span></div><div><br></div><div>On Wed, 2=
021-03-31 at 09:25 +0200, Hannes Reinecke wrote:</div><blockquote type=3D"c=
ite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left=
:1ex"><div>Hi Erwin,<br></div><div><br></div><div>On 3/31/21 2:22 AM, Erwin=
 van Londen wrote:<br></div><blockquote type=3D"cite" style=3D"margin:0 0 0=
 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div>Hello Muneendra=
, benjamin,<br></div><div><br></div><div>The fpin options that are develope=
d do have a whole plethora of options<br></div><div>and do not mainly trigg=
er paths being in a marginal state. Th mpio layer<br></div><div>could utili=
se the various triggers like congestion and latency and not<br></div><div>j=
ust use a marginal state as a decisive point. If a path is somewhat<br></di=
v><div>congested the amount of io's dispersed over these paths could just b=
e<br></div><div>reduced by a flexible margin depending on how often and whi=
ch fpins are<br></div><div>actually received. If for instance and fpin is r=
ecieved that an upstream<br></div><div>port is throwing physical errors you=
 may exclude is entirely from<br></div><div>queueing IO's to it. If it is a=
 latency related problem where credit<br></div><div>shortages come in play =
you may just need to queue very small IO's to it.<br></div><div>The scsi CD=
B will tell the size of the IO. Congestion notifications may<br></div><div>=
just be used for potentially adding an artificial&nbsp; delay to reduce the=
<br></div><div>workload on these paths and schedule them on another.<br></d=
iv><div><br></div></blockquote><div>As correctly noted, FPINs come with a v=
ariety of options.<br></div><div>And I'm not certain we can everything corr=
ectly; a degraded path is<br></div><div>simple, but for congestion there is=
 only _so_ much we can do.<br></div><div>The typical cause for congestion i=
s, say, a 32G host port talking to a<br></div><div>16G (or even 8G) target =
port _and_ a 32G target port.</div></blockquote><div>Congestion can also be=
 caused by a change in workload characteristics where, for example, read an=
d write workload start interfering. The funnel principle would not apply in=
 that case.</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; bord=
er-left:2px #729fcf solid;padding-left:1ex"><div><br></div><div>So the host=
 cannot 'tune down' it's link to 8G; doing so would impact<br></div><div>pe=
rformance on the 32G target port.<br></div><div>(And we would suffer revers=
e congestion whenever that target port sends<br></div><div>frames).<br></di=
v><div><br></div><div>And throttling things on the SCSI layer only helps _s=
o_ much, as the<br></div><div>real congestion is due to the speed with whic=
h the frames are sequenced<br></div><div>onto the wire. Which is not someth=
ing we from the OS can control.<br></div></blockquote><div>If you can inter=
leave IOs with an artificial delay depending on the type and frequency thes=
e FPINS arrive you would be able to prevent latency buildup in the san.</di=
v><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #72=
9fcf solid;padding-left:1ex"><div><br></div><div>From another POV this is a=
rguably a fabric mis-design; so it _could_ be<br></div><div>alleviated by s=
eparating out the ports with lower speeds into its own<br></div><div>zone (=
or even on a separate SAN); that would trivially make the<br></div><div>con=
gestion go away.<br></div></blockquote><div>The entire FPIN concept was des=
igned to be able to provide clients with the option to respond and react to=
 changing behaviours in sans. A mis-design is often not really the case but=
 ongoing changes and continuous provisioning is &nbsp;mainly contributing t=
o the case.&nbsp;</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex=
; border-left:2px #729fcf solid;padding-left:1ex"><div><br></div><div>But f=
or that the admin first should be _alerted_, and this really is my<br></div=
><div>primary goal: having FPINs showing up in the message log, to alert th=
e<br></div><div>admin that his fabric is not performing well.<br></div></bl=
ockquote><div>I think the FC drivers are already having facilities to do th=
at or they will have that shortly. dm-multipath is not really required to h=
andle the notifications but would be useful if actions have been done based=
 on fpins.&nbsp;</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex;=
 border-left:2px #729fcf solid;padding-left:1ex"><div><br></div><div>A seco=
nd step will be to massaging FPINs into DM multipath, and have it<br></div>=
<div>influencing the path priority or path status. But this is currently<br=
></div><div>under discussion how it could be integrated best.<br></div></bl=
ockquote><div>OK</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex;=
 border-left:2px #729fcf solid;padding-left:1ex"><div><br></div><blockquote=
 type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;pa=
dding-left:1ex"><div>Not really sure what the possibilities are from a DM-M=
ultipath<br></div><div>viewpoint, but I feel if the OS options are not prop=
erly aligned with<br></div><div>what the FC protocol and HBA drivers are ab=
le to provide we may miss a<br></div><div>good opportunity to optimize the =
dispersion of IO's and improve overall<br></div><div>performance.&nbsp;<br>=
</div><div><br></div></blockquote><div>Looking at the size of the commands =
is one possibility, but at this time<br></div><div>this presumes too much o=
n how we _think_ FPINs will be generated.<br></div><div>I'd rather do some =
more tests to figure out under which circumstances we<br></div><div>can exp=
ect which type of FPINs, and then start looking for ways on how<br></div><d=
iv>to integrate them.<br></div></blockquote><div>The FC protocol only descr=
ibes the framework and not the values that need to be adhered to. That depe=
nds on the end devices and their capabilities.&nbsp;</div><blockquote type=
=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding=
-left:1ex"><div><br></div><div>Cheers,<br></div><div><br></div><div>Hannes<=
br></div></blockquote></body></html>

--=-qB86vl340GF995lk/j3p--

--===============1102831959996881165==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============1102831959996881165==--

