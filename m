Return-Path: <SRS0=s6iH=JY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,TRACKER_ID autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79354C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 04:14:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A2D88611BE
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 04:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2D88611BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-eTKDkPpgPQu0W2Of6AEP2g-1; Tue, 27 Apr 2021 00:14:18 -0400
X-MC-Unique: eTKDkPpgPQu0W2Of6AEP2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5E3B1802508;
	Tue, 27 Apr 2021 04:14:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB4B01724D;
	Tue, 27 Apr 2021 04:14:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 584851806D1A;
	Tue, 27 Apr 2021 04:14:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13R4E2wF031474 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 00:14:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 48B73200E20E; Tue, 27 Apr 2021 04:14:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4436A2014F89
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 04:14:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 071A01018AA0
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 04:14:00 +0000 (UTC)
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com
	[192.185.146.130]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-293-0mGJRY_nNOuBaxAdEfDeoA-1; Tue, 27 Apr 2021 00:13:56 -0400
X-MC-Unique: 0mGJRY_nNOuBaxAdEfDeoA-1
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
	by gateway33.websitewelcome.com (Postfix) with ESMTP id 68C31DF193
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 22:53:49 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id bEnFlRfqZw11MbEnFlqSh5; Mon, 26 Apr 2021 22:53:49 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:48806
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lbEnE-0014qA-6g; Mon, 26 Apr 2021 21:53:48 -0600
Message-ID: <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Martin Wilck <martin.wilck@suse.com>,
	"Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
In-Reply-To: <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
	<59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
Date: Tue, 27 Apr 2021 13:48:36 +1000
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
X-Exim-ID: 1lbEnE-0014qA-6g
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:48806
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5956025120904080506=="

--===============5956025120904080506==
Content-Type: multipart/alternative; boundary="=-XBkgi4/JbC0uN6YOZk6w"

--=-XBkgi4/JbC0uN6YOZk6w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable



On Mon, 2021-04-26 at 13:16 +0000, Martin Wilck wrote:
> On Mon, 2021-04-26 at 13:14 +0200, Ulrich Windl wrote:
> > > >=20
> > >=20
> > > While we're at it, I'd like to mention another issue: WWID
> > > changes.
> > >=20
> > > This is a big problem for multipathd. The gist is that the device
> > > identification attributes in sysfs only change after rescanning
> > > the
> > > device. Thus if a user changes LUN assignments on a storage
> > > system,
> > > it can happen that a direct INQUIRY returns a different WWID as
> > > in
> > > sysfs, which is fatal. If we plan to rely more on sysfs for
> > > device
> > > identification in the future, the problem gets worse.=20
> >=20
> > I think many devices rely on the fact that they are identified by
> > Vendor/model/serial_nr, because in most professional SAN storage
> > systems you
> > can pre-set the serial number to a custom value; so if you want a
> > new
> > disk
> > (maybe a snapshot) to be compatible with the old one, just assign
> > the
> > same
> > serial number. I guess that's the idea behind.
>=20
> What you are saying sounds dangerous to me. If a snapshot has the
> same
> WWID as the device it's a snapshot of, it must not be exposed to any
> host(s) at the same time with its origin, otherwise the host may
> happily combine it with the origin into one multipath map, and data
> corruption will almost certainly result.=20
>=20
> My argument is about how the host is supposed to deal with a WWID
> change if it happens. Here, "WWID change" means that a given H:C:T:L
> suddenly exposes different device designators than it used to, while
> this device is in use by a host. Here, too, data corruption is
> imminent, and can happen in a blink of an eye. To avoid this, several
> things are needed:
>=20
> =C2=A01) the host needs to get notified about the change (likely by an UA
> of
> some sort)
> =C2=A02) the kernel needs to react to the notification immediately, e.g.
> by
> blocking IO to the device,
> =C2=A03) userspace tooling such as udev or multipathd need to figure out
> how
> to=C2=A0 how to deal with the situation cleanly, and eventually unblock
> it.
>=20
> Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
> afaics.
>=20
In my view the WWID should never change. If a snapshot is created it
should either obtain a new WWID. An example out of a Hitachi array is

Device Identification VPD page:
Addressed logical unit:
designator type: T10 vendor identification, code set: ASCII
vendor id: HITACHI=20
vendor specific: 50403B050709
designator type: NAA, code set: Binary
0x60060e80123b050050403b0500000709

The majority of the naa wwid is tied to the storage subsystem and
identifies the vendor oui, model, serial etc. The last 4 in this
example indicate the LDEV ID (Sorry mainframe heritage here..). When a
snapshot is taken these 4 will change as a new LDEV ID is assigned to
the snapshot. This sort of behaviour should be consistent across all
storage vendors imho.

> Martin
>=20

--=-XBkgi4/JbC0uN6YOZk6w
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div><br></div><div><span></span></div><div><br></=
div><div>On Mon, 2021-04-26 at 13:16 +0000, Martin Wilck wrote:</div><block=
quote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf sol=
id;padding-left:1ex"><div>On Mon, 2021-04-26 at 13:14 +0200, Ulrich Windl w=
rote:<br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border=
-left:2px #729fcf solid;padding-left:1ex"><blockquote type=3D"cite" style=
=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><blo=
ckquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf s=
olid;padding-left:1ex"><div><br></div></blockquote><div><br></div><div>Whil=
e we're at it, I'd like to mention another issue: WWID changes.<br></div><d=
iv><br></div><div>This is a big problem for multipathd. The gist is that th=
e device<br></div><div>identification attributes in sysfs only change after=
 rescanning the<br></div><div>device. Thus if a user changes LUN assignment=
s on a storage system,<br></div><div>it can happen that a direct INQUIRY re=
turns a different WWID as in<br></div><div>sysfs, which is fatal. If we pla=
n to rely more on sysfs for device<br></div><div>identification in the futu=
re, the problem gets worse. <br></div></blockquote><div><br></div><div>I th=
ink many devices rely on the fact that they are identified by<br></div><div=
>Vendor/model/serial_nr, because in most professional SAN storage<br></div>=
<div>systems you<br></div><div>can pre-set the serial number to a custom va=
lue; so if you want a new<br></div><div>disk<br></div><div>(maybe a snapsho=
t) to be compatible with the old one, just assign the<br></div><div>same<br=
></div><div>serial number. I guess that's the idea behind.<br></div></block=
quote><div><br></div><div>What you are saying sounds dangerous to me. If a =
snapshot has the same<br></div><div>WWID as the device it's a snapshot of, =
it must not be exposed to any<br></div><div>host(s) at the same time with i=
ts origin, otherwise the host may<br></div><div>happily combine it with the=
 origin into one multipath map, and data<br></div><div>corruption will almo=
st certainly result. <br></div><div><br></div><div>My argument is about how=
 the host is supposed to deal with a WWID<br></div><div>change if it happen=
s. Here, "WWID change" means that a given H:C:T:L<br></div><div>suddenly ex=
poses different device designators than it used to, while<br></div><div>thi=
s device is in use by a host. Here, too, data corruption is<br></div><div>i=
mminent, and can happen in a blink of an eye. To avoid this, several<br></d=
iv><div>things are needed:<br></div><div><br></div><div>&nbsp;1) the host n=
eeds to get notified about the change (likely by an UA of<br></div><div>som=
e sort)<br></div><div>&nbsp;2) the kernel needs to react to the notificatio=
n immediately, e.g. by<br></div><div>blocking IO to the device,<br></div><d=
iv>&nbsp;3) userspace tooling such as udev or multipathd need to figure out=
 how<br></div><div>to&nbsp; how to deal with the situation cleanly, and eve=
ntually unblock it.<br></div><div><br></div><div>Wrt 1), we can only hope t=
hat it's the case. But 2) and 3) need work,<br></div><div>afaics.<br></div>=
<div><br></div></blockquote><div>In my view the WWID should never change. I=
f a snapshot is created it should either obtain a new WWID. An example out =
of a Hitachi array is</div><div><br></div><div>Device Identification VPD pa=
ge:</div><div>  Addressed logical unit:</div><div>    designator type: T10 =
vendor identification,  code set: ASCII</div><div>      vendor id: HITACHI =
</div><div>      vendor specific: 50403B050709</div><div>    designator typ=
e: NAA,  code set: Binary</div><div>      0x60060e80123b050050403b050000<b>=
<u>0709</u></b></div><div><br></div><div>The majority of the naa wwid is ti=
ed to the storage subsystem and identifies the vendor oui, model, serial et=
c. The last 4 in this example indicate the LDEV ID (Sorry mainframe heritag=
e here..). When a snapshot is taken these 4 will change as a new LDEV ID is=
 assigned to the snapshot. This sort of behaviour should be consistent acro=
ss all storage vendors imho.</div><div><br></div><blockquote type=3D"cite" =
style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"=
><div>Martin<br></div><div><br></div></blockquote></body></html>

--=-XBkgi4/JbC0uN6YOZk6w--

--===============5956025120904080506==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============5956025120904080506==--

