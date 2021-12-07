Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869EAC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Dec 2021 12:28:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-TMSSrZO5PKWqdPuqELn9Wg-1; Tue, 07 Dec 2021 07:28:11 -0500
X-MC-Unique: TMSSrZO5PKWqdPuqELn9Wg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CC7B800FEB;
	Tue,  7 Dec 2021 12:28:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D430916A59;
	Tue,  7 Dec 2021 12:28:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4FFCA1809CBA;
	Tue,  7 Dec 2021 12:28:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B7CRiG0004205 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 7 Dec 2021 07:27:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DFA3E1400E75; Tue,  7 Dec 2021 12:27:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA0111400E74
	for <dm-devel@redhat.com>; Tue,  7 Dec 2021 12:27:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6C721C13D54
	for <dm-devel@redhat.com>; Tue,  7 Dec 2021 12:27:43 +0000 (UTC)
Received: from gproxy6-pub.mail.unifiedlayer.com
	(outbound-ss-761.bluehost.com [74.220.211.250]) by relay.mimecast.com
	with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-150-84JZNGP1O6WQ7aVAdfCFPA-1; Tue, 07 Dec 2021 07:27:41 -0500
X-MC-Unique: 84JZNGP1O6WQ7aVAdfCFPA-1
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
	by gproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id 807268032930
	for <dm-devel@redhat.com>; Tue,  7 Dec 2021 12:07:21 +0000 (UTC)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with ESMTP
	id uZFhmTgoOEV4ruZFhmCXv7; Tue, 07 Dec 2021 12:07:21 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=dcFFYVbe c=1 sm=1 tr=0 ts=61af4e79
	a=0Zc1vavb5vNBbqz++vQv9A==:117 a=0Zc1vavb5vNBbqz++vQv9A==:17
	a=IOMw9HtfNCkA:10:nop_rcvd_month_year
	a=8QztvWECkzkA:10:endurance_base64_authed_username_1 a=cqvmlmxeAAAA:8
	a=HC1sn1pX6LMellz5Z1YA:9 a=QEXdDO2ut3YA:10:nop_charset_2
	a=3ScklFXDnj2SlwOpPkoA:9 a=vJrg0v2sivpfYav5:21
	a=_W_S_7VecoQA:10:nop_html
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:46692
	helo=[10.69.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1muZFg-001wmW-Nz; Tue, 07 Dec 2021 05:07:21 -0700
Message-ID: <68af0d65f6ab1a877d24a7683b0220972243217c.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Martin Wilck <martin.wilck@suse.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, "muneendra.kumar@broadcom.com"
	<muneendra.kumar@broadcom.com>
In-Reply-To: <b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
	<f7ab2f4c696a7e17806d08b796324ca53cefbb6f.camel@erwinvanlonden.net>
	<b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
Date: Tue, 07 Dec 2021 22:06:56 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34)
X-AntiAbuse: This header was added to track abuse,
	please include it with any abuse report
X-AntiAbuse: Primary Hostname - just2098.justhost.com
X-AntiAbuse: Original Domain - redhat.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - erwinvanlonden.net
X-BWhitelist: no
X-Source-IP: 116.240.66.4
X-Source-L: No
X-Exim-ID: 1muZFg-001wmW-Nz
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([10.69.1.104])
	[116.240.66.4]:46692
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8851035011926197390=="

--===============8851035011926197390==
Content-Type: multipart/alternative; boundary="=-pS5DuLPXfelBiCPpWMCg"

--=-pS5DuLPXfelBiCPpWMCg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Martin,

>From a transport side an example would be an Ethernet Pause or with
Infiniband there is also an ECN (Explicit Congestion Notification) and
I'm sure there may be others for other transport mechanisms.=C2=A0
https://cva.stanford.edu/classes/ee382c/research/infiniband_cong.pdf

I don't know how much of these are currently being used in other parts
of the stack but I think that when a modular approach can be created
with a common set of configuration options from a multipathd level you
would seriously do the entire Linux and Storage sysadmin ecosystem a
huge favour.

I would need to dive into the stacks or seek help from the maintainers
of these code-bases to know more of what the options are.

Cheers
Erwin


On Tue, 2021-12-07 at 09:11 +0000, Martin Wilck wrote:
> On Tue, 2021-12-07 at 09:19 +1000, Erwin van Londen wrote:
> > Hello Martin, Muneendra.
> >=20
> > As I kicked this discussion off in the beginning of the year and
> > seeing the Muneendra and the broadcom people have come up with the
> > first iteration I can only applaud the efforts. On behalf of all
> > storage and linux administrators I would say "Thank you".
> >=20
> > As for your remark Martin my view would be to try and create a
> > modular approach where the transport layer drivers can hook into
> > and
> > inform multipathd of any event. The module in multipathd would then
> > decide based on configured characteristics what the actions should
> > be. (Take it offline, suspend for X amount of time, introduce X us
> > delay etc...) That way when more transport methods are used these
> > can
> > then dynamically be linked into the configuration without having
> > any
> > impact on other parts of the transport stack. I can imagine that
> > Infiniband. ethernet, SAS and others utilise different transport
> > characteristics and as such may need to inform the attached hosts
> > of
> > one or more events. On FC this is FPIN but a similar module may be
> > written for other transports.
>=20
> Interesting idea. Are you aware of a technology for non-FC transports
> that could take the role of FPIN? I have to admit I'm not, but that
> doesn't mean they don't exist or won't exist in the future.
>=20
> In the first place we'd need to "hook in" an event listener. Like
> with
> Muneendra's patch, we're adding a new class of events that we're
> listening to. The events would then than collected and processed by
> separate worker thread (which unlike the listener would take the
> multipath lock), setting paths states to marginal or back to normal.=20
>=20
> I don't think we want to add plug-ins that spawn their own
> independent
> threads, though. That sounds very difficult to handle properly, and
> we
> already have more than enough complexity.
>=20
> If we want to modularize this, we need a *generic* event listener
> thread. A module would basically provide an fd for that thread to
> poll
> on, and a callback to be called when an event occurs. This idea
> appeals
> to me a lot, in particular because we already have an event listener
> (the uevent listener thread) which is sitting idle most of the time.
>=20
> So Muneendra, instead of creating a new receiver thread, you would
> extend the existing uevent listener to handle the FPIN events as
> well.
> The thread would now add uevents to the uevent list and FPIN events
> to
> the FPIN events list.=20
>=20
> Next, we'd also need a generic event consumer, with callbacks for
> different types of marginal state handlers. Perhaps this could even
> be
> the uevent trigger thread? The uevent trigger has more work to do
> than
> the uevent listener. But any handler thread that wants to modify path
> state would need to take the lock anyway, effectively serializing all
> operations. So I guess we might as well use both uevent threads for
> "transport event notification" reception and processing,
> respectively.
>=20
> We also need to think about whether the currently existing marginal
> path handler could fit into this framework. Not so well probably,
> because it's not event driven and hooks into check_path(). OTOH,
> maybe
> possible future mechanisms might hook into check_path(), too, so we'd
> need a generic callback there?
>=20
> Moreover, the existing marginal paths handler has two different modes
> of operation, the "classical" one that disables reinstate, and the=20
> more modern one that uses marginal pathgroups. I am wondering whether
> we need the first mode in the long run. In particular if we want to
> generalize this feature, we may want to get rind of the "classical"
> mode altogether. I'm not aware of any distinct advantages of that
> algorithm compared to marginal path groups.
>=20
> @Ben, Muneendra, what do you think?
>=20
> One word of caution here: we must be careful not to over-engineer.
> As long as no other mechanism like FPIN for other transports is
> conceivable, generalizing the concept makes only so much sense.
> Therefore we shouldn't hold back the FPIN patches until we have
> conceived of a generic mechanism, which may take a lot of time to
> develop. If another mechanism becomes available, we could still try
> to
> generalize the concept, if we keep the current additions clean and
> well-separated from the core multipathd code.
>=20
> However I am really thrilled by the prospect of generalizing event
> handling and reusing the uevent threads for FPIN. That would reduce
> complexity a lot, which is a good thing IMO.
>=20
> @Ben, Muneendra, again, your opinions?
>=20
> Best
> Martin
>=20

--=-pS5DuLPXfelBiCPpWMCg
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div>Hello Martin,</div><div><br></div><div>From a=
 transport side an example would be an Ethernet Pause or with Infiniband th=
ere is also an ECN (Explicit Congestion Notification) and I'm sure there ma=
y be others for other transport mechanisms.&nbsp;</div><div><a href=3D"http=
s://cva.stanford.edu/classes/ee382c/research/infiniband_cong.pdf">https://c=
va.stanford.edu/classes/ee382c/research/infiniband_cong.pdf</a></div><div><=
br></div><div>I don't know how much of these are currently being used in ot=
her parts of the stack but I think that when a modular approach can be crea=
ted with a common set of configuration options from a multipathd level you =
would seriously do the entire Linux and Storage sysadmin ecosystem a huge f=
avour.</div><div><br></div><div>I would need to dive into the stacks or see=
k help from the maintainers of these code-bases to know more of what the op=
tions are.</div><div><br></div><div>Cheers</div><div>Erwin</div><div><br></=
div><div><span></span></div><div><br></div><div>On Tue, 2021-12-07 at 09:11=
 +0000, Martin Wilck wrote:</div><blockquote type=3D"cite" style=3D"margin:=
0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div>On Tue, 20=
21-12-07 at 09:19 +1000, Erwin van Londen wrote:<br></div><blockquote type=
=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding=
-left:1ex"><div>Hello Martin, Muneendra.<br></div><div><br></div><div>As I =
kicked this discussion off in the beginning of the year and<br></div><div>s=
eeing the Muneendra and the broadcom people have come up with the<br></div>=
<div>first iteration I can only applaud the efforts. On behalf of all<br></=
div><div>storage and linux administrators I would say "Thank you".<br></div=
><div><br></div><div>As for your remark Martin my view would be to try and =
create a<br></div><div>modular approach where the transport layer drivers c=
an hook into and<br></div><div>inform multipathd of any event. The module i=
n multipathd would then<br></div><div>decide based on configured characteri=
stics what the actions should<br></div><div>be. (Take it offline, suspend f=
or X amount of time, introduce X us<br></div><div>delay etc...) That way wh=
en more transport methods are used these can<br></div><div>then dynamically=
 be linked into the configuration without having any<br></div><div>impact o=
n other parts of the transport stack. I can imagine that<br></div><div>Infi=
niband. ethernet, SAS and others utilise different transport<br></div><div>=
characteristics and as such may need to inform the attached hosts of<br></d=
iv><div>one or more events. On FC this is FPIN but a similar module may be<=
br></div><div>written for other transports.<br></div></blockquote><div><br>=
</div><div>Interesting idea. Are you aware of a technology for non-FC trans=
ports<br></div><div>that could take the role of FPIN? I have to admit I'm n=
ot, but that<br></div><div>doesn't mean they don't exist or won't exist in =
the future.<br></div><div><br></div><div>In the first place we'd need to "h=
ook in" an event listener. Like with<br></div><div>Muneendra's patch, we're=
 adding a new class of events that we're<br></div><div>listening to. The ev=
ents would then than collected and processed by<br></div><div>separate work=
er thread (which unlike the listener would take the<br></div><div>multipath=
 lock), setting paths states to marginal or back to normal. <br></div><div>=
<br></div><div>I don't think we want to add plug-ins that spawn their own i=
ndependent<br></div><div>threads, though. That sounds very difficult to han=
dle properly, and we<br></div><div>already have more than enough complexity=
.<br></div><div><br></div><div>If we want to modularize this, we need a *ge=
neric* event listener<br></div><div>thread. A module would basically provid=
e an fd for that thread to poll<br></div><div>on, and a callback to be call=
ed when an event occurs. This idea appeals<br></div><div>to me a lot, in pa=
rticular because we already have an event listener<br></div><div>(the ueven=
t listener thread) which is sitting idle most of the time.<br></div><div><b=
r></div><div>So Muneendra, instead of creating a new receiver thread, you w=
ould<br></div><div>extend the existing uevent listener to handle the FPIN e=
vents as well.<br></div><div>The thread would now add uevents to the uevent=
 list and FPIN events to<br></div><div>the FPIN events list. <br></div><div=
><br></div><div>Next, we'd also need a generic event consumer, with callbac=
ks for<br></div><div>different types of marginal state handlers. Perhaps th=
is could even be<br></div><div>the uevent trigger thread? The uevent trigge=
r has more work to do than<br></div><div>the uevent listener. But any handl=
er thread that wants to modify path<br></div><div>state would need to take =
the lock anyway, effectively serializing all<br></div><div>operations. So I=
 guess we might as well use both uevent threads for<br></div><div>"transpor=
t event notification" reception and processing, respectively.<br></div><div=
><br></div><div>We also need to think about whether the currently existing =
marginal<br></div><div>path handler could fit into this framework. Not so w=
ell probably,<br></div><div>because it's not event driven and hooks into ch=
eck_path(). OTOH, maybe<br></div><div>possible future mechanisms might hook=
 into check_path(), too, so we'd<br></div><div>need a generic callback ther=
e?<br></div><div><br></div><div>Moreover, the existing marginal paths handl=
er has two different modes<br></div><div>of operation, the "classical" one =
that disables reinstate, and the <br></div><div>more modern one that uses m=
arginal pathgroups. I am wondering whether<br></div><div>we need the first =
mode in the long run. In particular if we want to<br></div><div>generalize =
this feature, we may want to get rind of the "classical"<br></div><div>mode=
 altogether. I'm not aware of any distinct advantages of that<br></div><div=
>algorithm compared to marginal path groups.<br></div><div><br></div><div>@=
Ben, Muneendra, what do you think?<br></div><div><br></div><div>One word of=
 caution here: we must be careful not to over-engineer.<br></div><div>As lo=
ng as no other mechanism like FPIN for other transports is<br></div><div>co=
nceivable, generalizing the concept makes only so much sense.<br></div><div=
>Therefore we shouldn't hold back the FPIN patches until we have<br></div><=
div>conceived of a generic mechanism, which may take a lot of time to<br></=
div><div>develop. If another mechanism becomes available, we could still tr=
y to<br></div><div>generalize the concept, if we keep the current additions=
 clean and<br></div><div>well-separated from the core multipathd code.<br><=
/div><div><br></div><div>However I am really thrilled by the prospect of ge=
neralizing event<br></div><div>handling and reusing the uevent threads for =
FPIN. That would reduce<br></div><div>complexity a lot, which is a good thi=
ng IMO.<br></div><div><br></div><div>@Ben, Muneendra, again, your opinions?=
<br></div><div><br></div><div>Best<br></div><div>Martin<br></div><div><br><=
/div></blockquote></body></html>

--=-pS5DuLPXfelBiCPpWMCg--

--===============8851035011926197390==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============8851035011926197390==--

