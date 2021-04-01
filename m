Return-Path: <SRS0=Hv8r=I6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MIME_HTML_MOSTLY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CC2C433B4
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 10:20:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0A091610A5
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 10:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A091610A5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-0SFuIBKHMxuX-QBQugZZvA-1; Thu, 01 Apr 2021 06:20:06 -0400
X-MC-Unique: 0SFuIBKHMxuX-QBQugZZvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D51E1005D4F;
	Thu,  1 Apr 2021 10:20:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F50959454;
	Thu,  1 Apr 2021 10:19:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B13844BB7C;
	Thu,  1 Apr 2021 10:19:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1313FfoZ022643 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 23:15:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 98E462157F24; Thu,  1 Apr 2021 03:15:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 915CC2157F23
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 03:15:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1ED38002E2
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 03:15:38 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1617246938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=pZ6xbyQszxADurcEroqFuMYWJcC8AslBNO2kBGd6YeU=;
	b=WuHx4Moqyne8U+TmpQ+bVUBcdqy6U81k8Bg7iAdGufLIuQ+1UP2L9LtbaesjDWe1dXR+hN
	dStp3lN95sw+MNs08NBPZktsoo8m4Bx5nCMmS0Gx1+ocFJkcby3sXS7DUjDuMIftYFKmXK
	C91n+VwIWBPEy/M53QZM5lTYTtyWqbF+97uYiYckSbOHMd6e6UTNAts0EWgCIi3qp9jd0n
	Kbolrpjpkrq83nJEPokQZp4ZbOUPbc+DeESKaAzXHJilRMM6Sud1T1lUDYhHr4uAaqp4zm
	3BBFH6cd7CJ/BWF9G7NG7K3CUIOYtmVNcgJr1bHxf6mMU7+om4UXdbpLQH6gbg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1617246938; a=rsa-sha256;
	cv=none;
	b=CeEa0c1dgGd18D6eyIp3GJLFcmdZOBVinH/zjg/NvQ77K2Ofd8TWq262d5WuWgZ+fIMfu4
	cWJiwaN0vtYiARRcfPg8XDCaj+UF7AoyaHAlnLn00kORPegAw6VDW8veTG0ntX0Jng01rz
	78ETdp/VS69feLUxjwpcHtbDHjYoInbNlnmKYeBF3qWP0KwppYj0/2+H6yNm2cs9czLr3M
	WghBej8/ucxczmqJ6daQjjZmrHYOmt0KuCA9V4Btfl0SgfEWmKvF79mOBrrL+b+sMQdPDA
	ip7mzO/sPL/LIF/qRvu8lVgyie653Hj2JuDc404CR+gci7KHKKtNQbMbgmtSKg==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=neutral (relay.mimecast.com: 192.185.145.184 is neither permitted
	nor denied by domain of erwin@erwinvanlonden.net)
	smtp.mailfrom=erwin@erwinvanlonden.net
Received: from gateway32.websitewelcome.com (gateway32.websitewelcome.com
	[192.185.145.184]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-394-_JNXSxSXNdC-m1y6nORwYQ-1; Wed, 31 Mar 2021 23:15:34 -0400
X-MC-Unique: _JNXSxSXNdC-m1y6nORwYQ-1
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
	by gateway32.websitewelcome.com (Postfix) with ESMTP id B983373D55A
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 21:53:47 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id RnStlBxaOPkftRnStlf4m0; Wed, 31 Mar 2021 21:53:47 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:44566
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lRnSs-001cDK-DF; Wed, 31 Mar 2021 20:53:46 -0600
Message-ID: <7b5ce0567f03bc3d394481642a97a3d499fe3976.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>, Martin Wilck
	<martin.wilck@suse.com>, bblock@linux.ibm.com, hare@suse.de
In-Reply-To: <30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
Date: Thu, 01 Apr 2021 12:48:36 +1000
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
X-Exim-ID: 1lRnSs-001cDK-DF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:44566
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 2
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=neutral (relay.mimecast.com: 192.185.145.184 is neither permitted
	nor denied by domain of erwin@erwinvanlonden.net)
	smtp.mailfrom=erwin@erwinvanlonden.net
X-Mimecast-Spam-Score: -5
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
X-Mailman-Approved-At: Thu, 01 Apr 2021 06:19:54 -0400
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
Content-Type: multipart/mixed; boundary="===============2901514465072449176=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============2901514465072449176==
Content-Type: multipart/signed; micalg="pgp-sha1";
	protocol="application/pgp-signature"; 
	boundary="=-XqiL3mrJL2q8LJ2Xj8ib"

--=-XqiL3mrJL2q8LJ2Xj8ib
Content-Type: multipart/alternative; boundary="=-hzw9tLZiCgXALD8tZfz9"

--=-hzw9tLZiCgXALD8tZfz9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Muneendra

On Wed, 2021-03-31 at 16:18 +0530, Muneendra Kumar M wrote:
> Hi Martin,
> Below are my replies.
>=20
>=20
> > If there was any discussion, I haven't been involved :-)
>=20
> > I haven't looked into FPIN much so far. I'm rather sceptic with
> > it's
> usefulness for dm-multipath. Being a property of FC-2, FPIN works at
> least
> 2 layers below dm-multipath. dm-multipath is agnostic against
> protocol and
> transport properties by design. User space multipathd can cross these
> layers and tune dm-multipath based on lower-level properties, but
> such
> actions=C2=A0 have rather large latencies.
>=20
> > As you know, dm-multipath has 3 switches for routing IO via
> > different
> paths:
>=20
> > 1 priority groups,
> > 2 path status (good / failed)
> =C2=A0>3 path selector algorithm
>=20
> > 1) and 2) are controlled by user space, and have high latency.
>=20
> > The current "marginal" concept in multipathd watches paths for
> > repeated
> failures, and configures the kernel to avoid using paths that are
> considered marginal, using methods 1) and 2). This is a very-high-
> latency
> algorithm that >changes state on the time scale of minutes.
> > There is no concept for "delaying" or "pausing" IO on paths on
> > short time
> scale.
>=20
> > The only low-latency mechanism is 3). But it's block level, no
> > existing
> selector looks at transport-level properties.
>=20
> > That said, I can quite well imagine a feedback mechanism based on
> throttling or delays applied in the FC drivers. For example, it a
> remote
> port was throttled by the driver in response to FPIN messages, it's
> bandwidth would >decrease, and a path selector like "service-time"
> > would automatically assign less IO to such paths. This wouldn't
> > need any
> changes in dm-multipath or multipath-tools, it would work entirely on
> the
> FC level.
>=20
> [Muneendra]Agreed.
I think the only way the FC drivers can respond to this is by delaying
the R_RDY primitives resulting in less credits being available for the
remote side to use. That only works on a link layer and not fabric
wide. It cannot change linkspeed at all as that would bounce a port
resulting in all sorts of state changes. That being said this is
already the existing behavior and not really tied to fpins. The goal of
the fpin method was to provide a more proactive method and inform the
OS layer of fabric issues so it could act upon it by adjusting the IO
profile.
>=20
> > Talking about improving the current "marginal" algorithm in
> > multipathd,
> and knowing that it's slow, FPIN might provide additional data that
> would
> be good to have. Currently, multipathd only has 2 inputs, "good<-
> >bad"
> state >transitions based either on kernel I/O errors or path checker
> results, and failure statistics from multipathd's internal
> "io_err_stat"
> thread, which only reads sector 0. This could obviously be improved,
> but
> there may actually be >lower-hanging fruit than evaluating FPIN
> notifications (for example, I've pondered utilizing the kernel's
> blktrace
> functionality to detect unusually long IO latencies or bandwidth
> drops).
>=20
> > Talking about FPIN, is it planned to notify user space about such
> > fabric
> events, and if yes, how?
>=20
> [Muneendra]Yes. FC drivers, when receiving FC FPIN ELS's are calling
> a
> scsi transport routine with the FPIN payload.=C2=A0 The transport
> is pushing this as an "event" via netlink.=C2=A0 An app bound to the loca=
l
> address used by the scsi transport can receive the event and parse
> it.
>=20
> Benjamin has added a marginal_path group(multipath marginal
> pathgroups) in
> the dm-multipath.
> https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-1-gi=
t
> -send-email-bmarzins@redhat.com/
>=20
> One of the intention of the Benjamin's patch (support for maginal
> path) is
> to support for the FPIN events we receive from fabric.
> On receiving the fpin-li our intention was to=C2=A0 place all the paths
> that
> are affected into the marginal path group.
I think this should all be done in kernel space as we're talking sub-
millisecond timings here when it comes to fpins and the reaction time
expected. I may be wrong but I'll leave that up to you.
>=20
> Below are the 4 types of descriptors returned in an FPIN:
> =E2=80=A2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Link Integrity (LN): s=
ome error on a link that affected
> frames,
> which is the main one for "flaky path"
> =E2=80=A2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Delivery Notification =
(DN):=C2=A0 something explicitly knew about
> a
> dropped frame and is reporting it. Usually, things like a CRC error
> says
> you can't trust the frame header, so you it's a LI error. But if you
> do
> have a valid frame, but drop it, such as a fabric edge timer (don't
> queue
> it more the 250-600ms), then it becomes a DN type. Could be flaky
> path,
> but not necessarily.
> =E2=80=A2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Congestion (CN): fabri=
c is saying it's congested sending to
> "your"
> port. Meaning if a host receives it - fabric is saying it has more
> frames
> for the host than it's pulling in so it's backing up the fabric.What
> should happen is load by the host should be lowered - but it's across
> all
> targets. Not all targets are perhaps in the mpio path list
> =E2=80=A2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Peer Congestion (PCN):=
 this goes along with CN in that the
> fabric
> is now telling the other devices in the zone sending traffic to that
> congested port that the other port is backing up. So the idea is
> these
> peer send less load to the congested port.=C2=A0 Shouldn't really tie to
> mpio.
> some of the current thinking is targets could see this and reduce
> their
> transmission rate to a host to the link speed of the host
>=20
> On receiving the congestion notifications our intention is to
> slowdown the
> work load gradually from the host until it stops receiving the
> congestion
> notifications.
> We need to validate the same how we can achieve the same of
> decreasing the
> workloads with the help of dm-multipath.
Would it be possible to piggyback on the service time path selector in
this when it pertains latency? =C2=A0

Another thing is that at some stage the IO queueing decision needs to
take into account the various different FPIN descriptors. A remote
delivery notification due to slow drain behaviour is very different
than ISL congestion or any physical issues.
>=20
> As Hannes mentioned=C2=A0 in his earlier mail our primary goal is that th=
e
> admin first should be _alerted_, having FPINs showing up in the
> message
> log, to alert the
> admin that his fabric is not performing well.
>=20
This is a bit of a reactive approach that should be a secondary
objective. Having been in storage/fc support for 20 years I know that
most admins are not really responsive to this and taking actions based
on event entries take a very very long time. From an operations
perspective any sort of manual action should be avoided as much as
possible.
>=20
> Regards,
> Muneendra.
>=20

--=-hzw9tLZiCgXALD8tZfz9
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode:=
 space; line-break: after-white-space;"><div>Hello Muneendra</div><div><spa=
n></span></div><div><br></div><div>On Wed, 2021-03-31 at 16:18 +0530, Munee=
ndra Kumar M wrote:</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8=
ex; border-left:2px #729fcf solid;padding-left:1ex"><div>Hi Martin,<br></di=
v><div>Below are my replies.<br></div><div><br></div><div><br></div><blockq=
uote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf soli=
d;padding-left:1ex"><div>If there was any discussion, I haven't been involv=
ed :-)<br></div></blockquote><div><br></div><blockquote type=3D"cite" style=
=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div=
>I haven't looked into FPIN much so far. I'm rather sceptic with it's<br></=
div></blockquote><div>usefulness for dm-multipath. Being a property of FC-2=
, FPIN works at least<br></div><div>2 layers below dm-multipath. dm-multipa=
th is agnostic against protocol and<br></div><div>transport properties by d=
esign. User space multipathd can cross these<br></div><div>layers and tune =
dm-multipath based on lower-level properties, but such<br></div><div>action=
s&nbsp; have rather large latencies.<br></div><div><br></div><blockquote ty=
pe=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;paddi=
ng-left:1ex"><div>As you know, dm-multipath has 3 switches for routing IO v=
ia different<br></div></blockquote><div>paths:<br></div><div><br></div><blo=
ckquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf s=
olid;padding-left:1ex"><div>1 priority groups,<br></div><div>2 path status =
(good / failed)<br></div></blockquote><div>&nbsp;&gt;3 path selector algori=
thm<br></div><div><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0=
 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div>1) and 2) are c=
ontrolled by user space, and have high latency.<br></div></blockquote><div>=
<br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left=
:2px #729fcf solid;padding-left:1ex"><div>The current "marginal" concept in=
 multipathd watches paths for repeated<br></div></blockquote><div>failures,=
 and configures the kernel to avoid using paths that are<br></div><div>cons=
idered marginal, using methods 1) and 2). This is a very-high- latency<br><=
/div><div>algorithm that &gt;changes state on the time scale of minutes.<br=
></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2p=
x #729fcf solid;padding-left:1ex"><div>There is no concept for "delaying" o=
r "pausing" IO on paths on short time<br></div></blockquote><div>scale.<br>=
</div><div><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; =
border-left:2px #729fcf solid;padding-left:1ex"><div>The only low-latency m=
echanism is 3). But it's block level, no existing<br></div></blockquote><di=
v>selector looks at transport-level properties.<br></div><div><br></div><bl=
ockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf =
solid;padding-left:1ex"><div>That said, I can quite well imagine a feedback=
 mechanism based on<br></div></blockquote><div>throttling or delays applied=
 in the FC drivers. For example, it a remote<br></div><div>port was throttl=
ed by the driver in response to FPIN messages, it's<br></div><div>bandwidth=
 would &gt;decrease, and a path selector like "service-time"<br></div><bloc=
kquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf so=
lid;padding-left:1ex"><div>would automatically assign less IO to such paths=
. This wouldn't need any<br></div></blockquote><div>changes in dm-multipath=
 or multipath-tools, it would work entirely on the<br></div><div>FC level.<=
br></div><div><br></div><div>[Muneendra]Agreed.<br></div></blockquote><div>=
I think the only way the FC drivers can respond to this is by delaying the =
R_RDY primitives resulting in less credits being available for the remote s=
ide to use. That only works on a link layer and not fabric wide. It cannot =
change linkspeed at all as that would bounce a port resulting in all sorts =
of state changes. That being said this is already the existing behavior and=
 not really tied to fpins. The goal of the fpin method was to provide a mor=
e proactive method and inform the OS layer of fabric issues so it could act=
 upon it by adjusting the IO profile.</div><blockquote type=3D"cite" style=
=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div=
><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-lef=
t:2px #729fcf solid;padding-left:1ex"><div>Talking about improving the curr=
ent "marginal" algorithm in multipathd,<br></div></blockquote><div>and know=
ing that it's slow, FPIN might provide additional data that would<br></div>=
<div>be good to have. Currently, multipathd only has 2 inputs, "good&lt;-&g=
t;bad"<br></div><div>state &gt;transitions based either on kernel I/O error=
s or path checker<br></div><div>results, and failure statistics from multip=
athd's internal "io_err_stat"<br></div><div>thread, which only reads sector=
 0. This could obviously be improved, but<br></div><div>there may actually =
be &gt;lower-hanging fruit than evaluating FPIN<br></div><div>notifications=
 (for example, I've pondered utilizing the kernel's blktrace<br></div><div>=
functionality to detect unusually long IO latencies or bandwidth drops).<br=
></div><div><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex;=
 border-left:2px #729fcf solid;padding-left:1ex"><div>Talking about FPIN, i=
s it planned to notify user space about such fabric<br></div></blockquote><=
div>events, and if yes, how?<br></div><div><br></div><div>[Muneendra]Yes. F=
C drivers, when receiving FC FPIN ELS's are calling a<br></div><div>scsi tr=
ansport routine with the FPIN payload.&nbsp; The transport<br></div><div>is=
 pushing this as an "event" via netlink.&nbsp; An app bound to the local<br=
></div><div>address used by the scsi transport can receive the event and pa=
rse it.<br></div><div><br></div><div>Benjamin has added a marginal_path gro=
up(multipath marginal pathgroups) in<br></div><div>the dm-multipath.<br></d=
iv><div><a href=3D"https://patchwork.kernel.org/project/dm-devel/cover/1564=
763622-31752-1-git">https://patchwork.kernel.org/project/dm-devel/cover/156=
4763622-31752-1-git</a><br></div><div><a href=3D"mailto:-send-email-bmarzin=
s@redhat.com">-send-email-bmarzins@redhat.com</a>/<br></div><div><br></div>=
<div>One of the intention of the Benjamin's patch (support for maginal path=
) is<br></div><div>to support for the FPIN events we receive from fabric.<b=
r></div><div>On receiving the fpin-li our intention was to&nbsp; place all =
the paths that<br></div><div>are affected into the marginal path group.<br>=
</div></blockquote><div>I think this should all be done in kernel space as =
we're talking sub-millisecond timings here when it comes to fpins and the r=
eaction time expected. I may be wrong but I'll leave that up to you.</div><=
blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fc=
f solid;padding-left:1ex"><div><br></div><div>Below are the 4 types of desc=
riptors returned in an FPIN:<br></div><div>=E2=80=A2&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;Link Integrity (LN): some error on a link that affected =
frames,<br></div><div>which is the main one for "flaky path"<br></div><div>=
=E2=80=A2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delivery Notification (D=
N):&nbsp; something explicitly knew about a<br></div><div>dropped frame and=
 is reporting it. Usually, things like a CRC error says<br></div><div>you c=
an't trust the frame header, so you it's a LI error. But if you do<br></div=
><div>have a valid frame, but drop it, such as a fabric edge timer (don't q=
ueue<br></div><div>it more the 250-600ms), then it becomes a DN type. Could=
 be flaky path,<br></div><div>but not necessarily.<br></div><div>=E2=80=A2&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Congestion (CN): fabric is saying =
it's congested sending to "your"<br></div><div>port. Meaning if a host rece=
ives it - fabric is saying it has more frames<br></div><div>for the host th=
an it's pulling in so it's backing up the fabric.What<br></div><div>should =
happen is load by the host should be lowered - but it's across all<br></div=
><div>targets. Not all targets are perhaps in the mpio path list<br></div><=
div>=E2=80=A2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Peer Congestion (PCN=
): this goes along with CN in that the fabric<br></div><div>is now telling =
the other devices in the zone sending traffic to that<br></div><div>congest=
ed port that the other port is backing up. So the idea is these<br></div><d=
iv>peer send less load to the congested port.&nbsp; Shouldn't really tie to=
 mpio.<br></div><div>some of the current thinking is targets could see this=
 and reduce their<br></div><div>transmission rate to a host to the link spe=
ed of the host<br></div><div><br></div><div>On receiving the congestion not=
ifications our intention is to slowdown the<br></div><div>work load gradual=
ly from the host until it stops receiving the congestion<br></div><div>noti=
fications.<br></div><div>We need to validate the same how we can achieve th=
e same of decreasing the<br></div><div>workloads with the help of dm-multip=
ath.<br></div></blockquote><div>Would it be possible to piggyback on the se=
rvice time path selector in this when it pertains latency? &nbsp;</div><div=
><br></div><div>Another thing is that at some stage the IO queueing decisio=
n needs to take into account the various different FPIN descriptors. A remo=
te delivery notification due to slow drain behaviour is very different than=
 ISL congestion or any physical issues.</div><blockquote type=3D"cite" styl=
e=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><di=
v><br></div><div>As Hannes mentioned&nbsp; in his earlier mail our primary =
goal is that the<br></div><div>admin first should be _alerted_, having FPIN=
s showing up in the message<br></div><div>log, to alert the<br></div><div>a=
dmin that his fabric is not performing well.<br></div><div><br></div></bloc=
kquote><div>This is a bit of a reactive approach that should be a secondary=
 objective. Having been in storage/fc support for 20 years I know that most=
 admins are not really responsive to this and taking actions based on event=
 entries take a very very long time. From an operations perspective any sor=
t of manual action should be avoided as much as possible.</div><blockquote =
type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;pad=
ding-left:1ex"><div><br></div><div>Regards,<br></div><div>Muneendra.<br></d=
iv><div><br></div></blockquote></body></html>

--=-hzw9tLZiCgXALD8tZfz9--

--=-XqiL3mrJL2q8LJ2Xj8ib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABAgAdFiEEnGxzPPTOzYO47pZEpZCDQR/xNU8FAmBlNIQACgkQpZCDQR/x
NU/huwgAnwGx8/JQ3x/0ynwh7xTB7O1c0jaM7ZZB6z7vGLMxp11ZTTMD3/2eiFkI
CT88yWWTs2SNZ1xXvqz2YrmKuQf6FmcXQi9M42Axm0opU8IZprKKDSSOQ4OV4LLL
hc7ViwYbfuR/sVNYPF6IZm7zZQiP/yzhJ0ozFYK74LiwoRTuRSeQoYc60rPAWxbz
N54sXGJjMLG7XfZR/pHpJyk3GeVyHdu7TFB82OX6JIjGdf27/Vt9kc0frXd7VQJN
JLTny+CPLDbzTKDhzWfkOe8p/QyKXheSH29rXLj7SSQXs9kvs4fapJQiojYvvJCv
K/UlTb67u53+x6nNKTbnA3/JO7A45Q==
=N3e9
-----END PGP SIGNATURE-----

--=-XqiL3mrJL2q8LJ2Xj8ib--


--===============2901514465072449176==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2901514465072449176==--

