Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9315FC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:32:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 09DE561990
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09DE561990
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-nGGytM0WNcyjwceXLofSSA-1; Wed, 31 Mar 2021 09:32:33 -0400
X-MC-Unique: nGGytM0WNcyjwceXLofSSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D81A107BEF9;
	Wed, 31 Mar 2021 13:32:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CE412BFE2;
	Wed, 31 Mar 2021 13:32:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DECF54BB7C;
	Wed, 31 Mar 2021 13:32:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12V0pkjo022459 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 20:51:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 603652026D6B; Wed, 31 Mar 2021 00:51:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A00A2026D65
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 00:51:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C4A8800B28
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 00:51:43 +0000 (UTC)
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com
	[192.185.62.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-348-dg7Gg3eaMUuf_-aFIMaaJw-1; Tue, 30 Mar 2021 20:51:40 -0400
X-MC-Unique: dg7Gg3eaMUuf_-aFIMaaJw-1
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
	by gateway20.websitewelcome.com (Postfix) with ESMTP id 11CF7400D5C3B
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 19:17:55 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id ROi8ljW0rb8LyROi8l1SPt; Tue, 30 Mar 2021 19:27:52 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:33476
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lROi7-0013om-87; Tue, 30 Mar 2021 18:27:51 -0600
Message-ID: <2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>, Benjamin Block
	<bblock@linux.ibm.com>
In-Reply-To: <b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
Date: Wed, 31 Mar 2021 10:22:40 +1000
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
X-Exim-ID: 1lROi7-0013om-87
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:33476
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 31 Mar 2021 09:32:18 -0400
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============9038819408258075827=="

--===============9038819408258075827==
Content-Type: multipart/alternative; boundary="=-ZIqzsuC+gpOXXU3mPSza"

--=-ZIqzsuC+gpOXXU3mPSza
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Muneendra, benjamin,

The fpin options that are developed do have a whole plethora of options
and do not mainly trigger paths being in a marginal state. Th mpio
layer could utilise the various triggers like congestion and latency
and not just use a marginal state as a decisive point. If a path is
somewhat congested the amount of io's dispersed over these paths could
just be reduced by a flexible margin depending on how often and which
fpins are actually received. If for instance and fpin is recieved that
an upstream port is throwing physical errors you may exclude is
entirely from queueing IO's to it. If it is a latency related problem
where credit shortages come in play you may just need to queue very
small IO's to it. The scsi CDB will tell the size of the IO. Congestion
notifications may just be used for potentially adding an artificial=C2=A0
delay to reduce the workload on these paths and schedule them on
another.

Not really sure what the possibilities are from a DM-Multipath
viewpoint, but I feel if the OS options are not properly aligned with
what the FC protocol and HBA drivers are able to provide we may miss a
good opportunity to optimize the dispersion of IO's and improve overall
performance.=C2=A0

Regards,
Erwin

On Fri, 2021-03-26 at 16:45 +0530, Muneendra Kumar M wrote:
> Hi Benjamin,
> My replies are below
>=20
>=20
> On Tue, Mar 23, 2021 at 05:52:33PM +1000, Erwin van Londen wrote:
> > > Hello All,
> > >=20
> > > Just wondering if there were any plans to incorporate FPIN
> > > congestion/latency notifications in dm-multipath to disperse IO
> > > over
> > > non-affected paths.
> >=20
>=20
> > For whats worth, general support in Kernel for a new path state in
> > answer
> to existing FPIN notifications was added earlier this year:
> > https://lore.kernel.org/linux-scsi/1609969748-17684-1-git-send-email-mu=
ne
> endra.kumar@broadcom.com/T/
>=20
> > But this only adds a new port-state and support of it for one
> > particular
> driver (lpfc). Not aware of any other driver supporting this new
> state
> yet, but I might have missed it. Also, the port-state is not set in
> kernel, but has to be set by something external, unlike with RSCNs,
> where
> we set the >state in the kernel.
>=20
> We had a discussion with Marvel and they are adding the support in
> their(qlaxx) driver.
>=20
>=20
> > What it does, once a path is set into 'Marginal' state, is to not
> > retry
> commands on the same shaky path, once it already failed one time
> already.
> Yes
>=20
> > As far as dm-multipath is concerned, I asked that as well when this
> > patch
> series was developed:
> > https://lore.kernel.org/linux-scsi/20201002162633.GA8365@t480-pf1aa2c2/
> > Hannes answered that in the thread:
> > https://lore.kernel.org/linux-scsi/ca995d96-608b-39b9-8ded-4a6dd7598660=
@s
> use.de/
>=20
> > Not sure what happened in between, didn't see anything on the mpath
> > topic
> yet.
>=20
> As Hannes mentioned in his reply we have an external daemon called
> fctxpd
> which acts on fpin-li events and sets the path to marginal path group
> as
> well as set the port state to marginal.
> This daemon is part of epel8.
> Below is the path for the same where we have changes
> https://github.com/brocade/bsn-fc-txptd
>=20
> The above code is reviewed by the Benjamin Marzinski from redhat .
>=20
> Note:The latest release will be available on the epel8 where we have
> the
> support to set the port state to marginal in a week time
>=20
> As we have all the support in the kernel for fpin registration,
> notifications and also setting the port_state to marginal
> We had a initial discussion with Hannes adding the fpin based native
> support in dm multipathd for FPIN Congestion/Latency notifications .
> I will take the initiative and start the discussion with Benjamin
> Marzinski and get this work done with the help of Hannes.
>=20
>=20
>=20
>=20
> Regards,
> Muneendra.
>=20

--=-ZIqzsuC+gpOXXU3mPSza
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode:=
 space; line-break: after-white-space;"><div>Hello Muneendra, benjamin,</di=
v><div><br></div><div>The fpin options that are developed do have a whole p=
lethora of options and do not mainly trigger paths being in a marginal stat=
e. Th mpio layer could utilise the various triggers like congestion and lat=
ency and not just use a marginal state as a decisive point. If a path is so=
mewhat congested the amount of io's dispersed over these paths could just b=
e reduced by a flexible margin depending on how often and which fpins are a=
ctually received. If for instance and fpin is recieved that an upstream por=
t is throwing physical errors you may exclude is entirely from queueing IO'=
s to it. If it is a latency related problem where credit shortages come in =
play you may just need to queue very small IO's to it. The scsi CDB will te=
ll the size of the IO. Congestion notifications may just be used for potent=
ially adding an artificial&nbsp; delay to reduce the workload on these path=
s and schedule them on another.</div><div><br></div><div>Not really sure wh=
at the possibilities are from a DM-Multipath viewpoint, but I feel if the O=
S options are not properly aligned with what the FC protocol and HBA driver=
s are able to provide we may miss a good opportunity to optimize the disper=
sion of IO's and improve overall performance.&nbsp;</div><div><br></div><di=
v>Regards,</div><div>Erwin</div><div><span></span></div><div><br></div><div=
>On Fri, 2021-03-26 at 16:45 +0530, Muneendra Kumar M wrote:</div><blockquo=
te type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;=
padding-left:1ex"><div>Hi Benjamin,<br></div><div>My replies are below<br><=
/div><div><br></div><div><br></div><div>On Tue, Mar 23, 2021 at 05:52:33PM =
+1000, Erwin van Londen wrote:<br></div><blockquote type=3D"cite" style=3D"=
margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockqu=
ote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid=
;padding-left:1ex"><div>Hello All,<br></div><div><br></div><div>Just wonder=
ing if there were any plans to incorporate FPIN<br></div><div>congestion/la=
tency notifications in dm-multipath to disperse IO over<br></div><div>non-a=
ffected paths.<br></div></blockquote><div><br></div></blockquote><div><br><=
/div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px =
#729fcf solid;padding-left:1ex"><div>For whats worth, general support in Ke=
rnel for a new path state in answer<br></div></blockquote><div>to existing =
FPIN notifications was added earlier this year:<br></div><blockquote type=
=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding=
-left:1ex"><div><a href=3D"https://lore.kernel.org/linux-scsi/1609969748-17=
684-1-git-send-email-mune">https://lore.kernel.org/linux-scsi/1609969748-17=
684-1-git-send-email-mune</a><br></div></blockquote><div><a href=3D"mailto:=
endra.kumar@broadcom.com">endra.kumar@broadcom.com</a>/T/<br></div><div><br=
></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2p=
x #729fcf solid;padding-left:1ex"><div>But this only adds a new port-state =
and support of it for one particular<br></div></blockquote><div>driver (lpf=
c). Not aware of any other driver supporting this new state<br></div><div>y=
et, but I might have missed it. Also, the port-state is not set in<br></div=
><div>kernel, but has to be set by something external, unlike with RSCNs, w=
here<br></div><div>we set the &gt;state in the kernel.<br></div><div><br></=
div><div>We had a discussion with Marvel and they are adding the support in=
<br></div><div>their(qlaxx) driver.<br></div><div><br></div><div><br></div>=
<blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729f=
cf solid;padding-left:1ex"><div>What it does, once a path is set into 'Marg=
inal' state, is to not retry<br></div></blockquote><div>commands on the sam=
e shaky path, once it already failed one time already.<br></div><div>Yes<br=
></div><div><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex;=
 border-left:2px #729fcf solid;padding-left:1ex"><div>As far as dm-multipat=
h is concerned, I asked that as well when this patch<br></div></blockquote>=
<div>series was developed:<br></div><blockquote type=3D"cite" style=3D"marg=
in:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div><a href=
=3D"https://lore.kernel.org/linux-scsi/20201002162633.GA8365@t480-pf1aa2c2/=
">https://lore.kernel.org/linux-scsi/20201002162633.GA8365@t480-pf1aa2c2/</=
a><br></div><div>Hannes answered that in the thread:<br></div><div><a href=
=3D"https://lore.kernel.org/linux-scsi/ca995d96-608b-39b9-8ded-4a6dd7598660=
@s">https://lore.kernel.org/linux-scsi/ca995d96-608b-39b9-8ded-4a6dd7598660=
@s</a><br></div></blockquote><div>use.de/<br></div><div><br></div><blockquo=
te type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;=
padding-left:1ex"><div>Not sure what happened in between, didn't see anythi=
ng on the mpath topic<br></div></blockquote><div>yet.<br></div><div><br></d=
iv><div>As Hannes mentioned in his reply we have an external daemon called =
fctxpd<br></div><div>which acts on fpin-li events and sets the path to marg=
inal path group as<br></div><div>well as set the port state to marginal.<br=
></div><div>This daemon is part of epel8.<br></div><div>Below is the path f=
or the same where we have changes<br></div><div><a href=3D"https://github.c=
om/brocade/bsn-fc-txptd">https://github.com/brocade/bsn-fc-txptd</a><br></d=
iv><div><br></div><div>The above code is reviewed by the Benjamin Marzinski=
 from redhat .<br></div><div><br></div><div>Note:The latest release will be=
 available on the epel8 where we have the<br></div><div>support to set the =
port state to marginal in a week time<br></div><div><br></div><div>As we ha=
ve all the support in the kernel for fpin registration,<br></div><div>notif=
ications and also setting the port_state to marginal<br></div><div>We had a=
 initial discussion with Hannes adding the fpin based native<br></div><div>=
support in dm multipathd for FPIN Congestion/Latency notifications .<br></d=
iv><div>I will take the initiative and start the discussion with Benjamin<b=
r></div><div>Marzinski and get this work done with the help of Hannes.<br><=
/div><div><br></div><div><br></div><div><br></div><div><br></div><div>Regar=
ds,<br></div><div>Muneendra.<br></div><div><br></div></blockquote></body></=
html>

--=-ZIqzsuC+gpOXXU3mPSza--

--===============9038819408258075827==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============9038819408258075827==--

