Return-Path: <SRS0=Tzat=JZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19037C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 01:07:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 576386008E
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 01:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 576386008E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-S_Zn8vJhP4WY1_gj0Gwobw-1; Tue, 27 Apr 2021 21:06:54 -0400
X-MC-Unique: S_Zn8vJhP4WY1_gj0Gwobw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5395C1846099;
	Wed, 28 Apr 2021 01:06:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FBDD60C0F;
	Wed, 28 Apr 2021 01:06:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 883321806D1B;
	Wed, 28 Apr 2021 01:06:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13S16irw019420 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 21:06:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7BAC9E3093; Wed, 28 Apr 2021 01:06:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FE0AF8850
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 01:06:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4882811E93
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 01:06:41 +0000 (UTC)
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com
	[192.185.47.129]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-589-2ypLtMTQNZyAkN763x1Qyw-1; Tue, 27 Apr 2021 21:06:38 -0400
X-MC-Unique: 2ypLtMTQNZyAkN763x1Qyw-1
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
	by gateway22.websitewelcome.com (Postfix) with ESMTP id 3E48F2364C
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 20:06:37 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id bYeylqXgDL7DmbYezlsfpD; Tue, 27 Apr 2021 20:06:37 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:49998
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lbYex-001enM-Tt; Tue, 27 Apr 2021 19:06:36 -0600
Message-ID: <ff5b30ca02ecfad00097ad5f8b84d053514fb61c.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Hannes Reinecke <hare@suse.de>, Martin Wilck <martin.wilck@suse.com>,
	"Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
In-Reply-To: <2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
	<59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
	<b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
	<15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
	<2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
Date: Wed, 28 Apr 2021 11:01:15 +1000
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
X-Exim-ID: 1lbYex-001enM-Tt
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:49998
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 4
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>, "systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6088738108179835174=="

--===============6088738108179835174==
Content-Type: multipart/alternative; boundary="=-PhCNTkjHLWbsaVNeh+69"

--=-PhCNTkjHLWbsaVNeh+69
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable



On Tue, 2021-04-27 at 10:21 +0200, Hannes Reinecke wrote:
> On 4/27/21 10:10 AM, Martin Wilck wrote:
> > On Tue, 2021-04-27 at 13:48 +1000, Erwin van Londen wrote:
> > > >=20
> > > > Wrt 1), we can only hope that it's the case. But 2) and 3) need
> > > > work,
> > > > afaics.
> > > >=20
> > > In my view the WWID should never change.=C2=A0
> >=20
> > In an ideal world, perhaps not. But in the dm-multipath realm, we
> > know
> > that WWID changes can happen with certain storage arrays. See=C2=A0
> > https://listman.redhat.com/archives/dm-devel/2021-February/msg00116.htm=
l
> > =C2=A0
> > and follow-ups, for example.
> >=20
> And it's actually something which might happen quite easily.
> The storage array can unmap a LUN, delete it, create a new one, and
> map
> that one into the same LUN number than the old one.
> If we didn't do I/O during that interval upon the next I/O we will be
> getting the dreaded 'Power-On/Reset' sense code.
> _And nothing else_, due to the arcane rules for sense code generation
> in
> SAM.
> But we end up with a completely different device.
>=20
> The only way out of it is to do a rescan for every POR sense code,
> and
> disable the device eg via DID_NO_CONNECT whenever we find that the
> identification has changed. We already have a copy of the original
> VPD
> page 0x83 at hand, so that should be reasonably easy.

The way out of this is to chuck the array in the bin. As I mentioned in
one of my other emails when a scenario happens as you described above
and the array does not inform the initiator it goes against the SAM-5
standard.

That standard shows:
5.14 Unit attention conditions
5.14.1 Unit attention conditions that are not coalesced
Each logical unit shall establish a unit attention condition whenever
one of the following events occurs:
 a) a power on (see 6.3.1), hard reset (see 6.3.2), logical unit
reset (see 6.3.3), I_T nexus loss (see 6.3.4), or power loss expected
(see 6.3.5) occurs;
 b) commands received on this I_T nexus have been cleared by a
command or a task management function associated with another I_T nexus
and the TAS bit was set to zero in the Control mode page associated
with this I_T nexus (see 5.6);
 c) the portion of the logical unit inventory that consists of
administrative logical units and hierarchical logical units has been
changed (see 4.6.18.1); or
 d) any other event requiring the attention of the SCSI
initiator device.

Especially the I_T nexus loss under a is an important trigger.

---
6.3.4 I_T nexus loss
An I_T nexus loss is a SCSI device condition resulting from:

a) a hard reset condition (see 6.3.2);
b) an I_T nexus loss event (e.g., logout) indicated by a Nexus Loss
event notification (see 6.4);
c) indication that an I_T NEXUS RESET task management request (see 7.6)
has been processed; or
d) an indication that a REMOVE I_T NEXUS command (see SPC-4) has been
processed.
An I_T nexus loss event is an indication from the SCSI transport
protocol to the SAL that an I_T nexus no
longer exists. SCSI transport protocols may define I_T nexus loss
events.

Each SCSI transport protocol standard that defines I_T nexus loss
events should specify when those events
result in the delivery of a Nexus Loss event notification to the SAL.

The I_T nexus loss condition applies to both SCSI initiator devices and
SCSI target devices.

If a SCSI target port detects an I_T nexus loss, then a Nexus Loss
event notification shall be delivered to
each logical unit to which the I_T nexus has access.

In response to an I_T nexus loss condition a logical unit shall take
the following actions:
a) abort all commands received on the I_T nexus as described in 5.6;
b) abort all background third-party copy operations (see SPC-4) that
are using the I_T nexus;
c) terminate all task management functions received on the I_T nexus;
d) clear all ACA conditions (see 5.9.5) associated with the I_T nexus;
e) establish a unit attention condition for the SCSI initiator port
associated with the I_T nexus (see 5.14
and 6.2); and
f) perform any additional functions required by the applicable command
standards.
---

This does also mean that any underlying transport protocol issues like
on FC or TCP for iSCSI will very often trigger aborted commands or UA's
as well which will be picked up by the kernel/respected drivers.

>=20
> I had a rather lengthy discussion with Fred Knight @ NetApp about
> Power-On/Reset handling, what with him complaining that we don't
> handle
> is correctly. So this really is something we should be looking into,
> even independently of multipathing.
>=20
> But actually I like the idea from Martin Petersen to expose the
> parsed
> VPD identifiers to sysfs; that would allow us to drop sg_inq
> completely
> from the udev rules.
>=20
> Cheers,
>=20
> Hannes

--=-PhCNTkjHLWbsaVNeh+69
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div><br></div><div><span></span></div><div><br></=
div><div>On Tue, 2021-04-27 at 10:21 +0200, Hannes Reinecke wrote:</div><bl=
ockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf =
solid;padding-left:1ex"><div>On 4/27/21 10:10 AM, Martin Wilck wrote:<br></=
div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #=
729fcf solid;padding-left:1ex"><div>On Tue, 2021-04-27 at 13:48 +1000, Erwi=
n van Londen wrote:<br></div><blockquote type=3D"cite" style=3D"margin:0 0 =
0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockquote type=3D=
"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-le=
ft:1ex"><div><br></div><div>Wrt 1), we can only hope that it's the case. Bu=
t 2) and 3) need work,<br></div><div>afaics.<br></div><div><br></div></bloc=
kquote><div>In my view the WWID should never change.&nbsp;<br></div></block=
quote><div><br></div><div>In an ideal world, perhaps not. But in the dm-mul=
tipath realm, we know<br></div><div>that WWID changes can happen with certa=
in storage arrays. See&nbsp;<br></div><div><a href=3D"https://listman.redha=
t.com/archives/dm-devel/2021-February/msg00116.html">https://listman.redhat=
.com/archives/dm-devel/2021-February/msg00116.html</a>&nbsp;<br></div><div>=
and follow-ups, for example.<br></div><div><br></div></blockquote><div>And =
it's actually something which might happen quite easily.<br></div><div>The =
storage array can unmap a LUN, delete it, create a new one, and map<br></di=
v><div>that one into the same LUN number than the old one.<br></div><div>If=
 we didn't do I/O during that interval upon the next I/O we will be<br></di=
v><div>getting the dreaded 'Power-On/Reset' sense code.<br></div><div>_And =
nothing else_, due to the arcane rules for sense code generation in<br></di=
v><div>SAM.<br></div><div>But we end up with a completely different device.=
<br></div><div><br></div><div>The only way out of it is to do a rescan for =
every POR sense code, and<br></div><div>disable the device eg via DID_NO_CO=
NNECT whenever we find that the<br></div><div>identification has changed. W=
e already have a copy of the original VPD<br></div><div>page 0x83 at hand, =
so that should be reasonably easy.<br></div></blockquote><div><br></div><di=
v>The way out of this is to chuck the array in the bin. As I mentioned in o=
ne of my other emails when a scenario happens as you described above and th=
e array does not inform the initiator it goes against the SAM-5 standard.</=
div><div><br></div><div>That standard shows:</div><div>5.14 Unit attention =
conditions</div><div>5.14.1 Unit attention conditions that are not coalesce=
d</div><div>Each logical unit shall establish a unit attention condition wh=
enever one of the following events occurs:</div><div><span class=3D"Apple-t=
ab-span" style=3D"white-space:pre">=09</span>a) a power on (see 6.3.1), har=
d reset (see 6.3.2), logical unit reset (see 6.3.3),<b> I_T nexus loss </b>=
(see 6.3.4), or power loss expected (see 6.3.5) occurs;</div><div><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre">=09</span>b) commands recei=
ved on this I_T nexus have been cleared by a command or a task management f=
unction associated with another I_T nexus and the TAS bit was set to zero i=
n the Control mode page associated with this I_T nexus (see 5.6);</div><div=
><span class=3D"Apple-tab-span" style=3D"white-space:pre">=09</span>c) the =
portion of the logical unit inventory that consists of administrative logic=
al units and hierarchical logical units has been changed (see 4.6.18.1); or=
</div><div><span class=3D"Apple-tab-span" style=3D"white-space:pre">=09</sp=
an>d) any other event requiring the attention of the SCSI initiator device.=
</div><div><br></div><div>Especially the I_T nexus loss under a is an impor=
tant trigger.</div><div><br></div><div>---</div><div>6.3.4 I_T nexus loss</=
div><div>An I_T nexus loss is a SCSI device condition resulting from:</div>=
<div><br></div><div>        a) a hard reset condition (see 6.3.2);</div><di=
v>        b) an I_T nexus loss event (e.g., logout) indicated by a Nexus Lo=
ss event notification (see 6.4);</div><div>        c) indication that an I_=
T NEXUS RESET task management request (see 7.6) has been processed; or</div=
><div>        d) an indication that a REMOVE I_T NEXUS command (see SPC-4) =
has been processed.</div><div>        </div><div>An I_T nexus loss event is=
 an indication from the SCSI transport protocol to the SAL that an I_T nexu=
s no</div><div>longer exists. SCSI transport protocols may define I_T nexus=
 loss events.</div><div><br></div><div>Each SCSI transport protocol standar=
d that defines I_T nexus loss events should specify when those events</div>=
<div>result in the delivery of a Nexus Loss event notification to the SAL.<=
/div><div><br></div><div>The I_T nexus loss condition applies to both SCSI =
initiator devices and SCSI target devices.</div><div><br></div><div>If a SC=
SI target port detects an I_T nexus loss, then a Nexus Loss event notificat=
ion shall be delivered to</div><div>each logical unit to which the I_T nexu=
s has access.</div><div><br></div><div>In response to an I_T nexus loss con=
dition a logical unit shall take the following actions:</div><div>a) abort =
all commands received on the I_T nexus as described in 5.6;</div><div>b) ab=
ort all background third-party copy operations (see SPC-4) that are using t=
he I_T nexus;</div><div>c) terminate all task management functions received=
 on the I_T nexus;</div><div>d) clear all ACA conditions (see 5.9.5) associ=
ated with the I_T nexus;</div><div>e) establish a unit attention condition =
for the SCSI initiator port associated with the I_T nexus (see 5.14</div><d=
iv>and 6.2); and</div><div>f) perform any additional functions required by =
the applicable command standards.</div><div>---</div><div><br></div><div>Th=
is does also mean that any underlying transport protocol issues like on FC =
or TCP for iSCSI will very often trigger aborted commands or UA's as well w=
hich will be picked up by the kernel/respected drivers.</div><div><br></div=
><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729=
fcf solid;padding-left:1ex"><div><br></div><div>I had a rather lengthy disc=
ussion with Fred Knight @ NetApp about<br></div><div>Power-On/Reset handlin=
g, what with him complaining that we don't handle<br></div><div>is correctl=
y. So this really is something we should be looking into,<br></div><div>eve=
n independently of multipathing.<br></div><div><br></div><div>But actually =
I like the idea from Martin Petersen to expose the parsed<br></div><div>VPD=
 identifiers to sysfs; that would allow us to drop sg_inq completely<br></d=
iv><div>from the udev rules.<br></div><div><br></div><div>Cheers,<br></div>=
<div><br></div><div>Hannes<br></div></blockquote></body></html>

--=-PhCNTkjHLWbsaVNeh+69--

--===============6088738108179835174==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============6088738108179835174==--

