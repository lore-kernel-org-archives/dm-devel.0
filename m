Return-Path: <SRS0=Tzat=JZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B4CC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 00:15:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE702613F7
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 00:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE702613F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-_mZpXO3yOsOQ1WrSkQylfA-1; Tue, 27 Apr 2021 20:14:58 -0400
X-MC-Unique: _mZpXO3yOsOQ1WrSkQylfA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EC14107ACCA;
	Wed, 28 Apr 2021 00:14:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B48B5D9C0;
	Wed, 28 Apr 2021 00:14:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 03F5235B76;
	Wed, 28 Apr 2021 00:14:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13S0EiWa016400 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 20:14:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D770621D01DB; Wed, 28 Apr 2021 00:14:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2D8121C85F6
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 00:14:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 953AB803DDA
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 00:14:42 +0000 (UTC)
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com
	[192.185.47.129]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-314-SY4zvCq0Mzqkpesc6t4SyA-1; Tue, 27 Apr 2021 20:14:40 -0400
X-MC-Unique: SY4zvCq0Mzqkpesc6t4SyA-1
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
	by gateway22.websitewelcome.com (Postfix) with ESMTP id CCF6926C5E
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 19:14:38 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id bXqglndk1w11MbXqglBBXV; Tue, 27 Apr 2021 19:14:38 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:48746
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lbXqf-001ARM-IW; Tue, 27 Apr 2021 18:14:38 -0600
Message-ID: <455a6e5086831323af86a150d21d5a0a7c2299eb.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: "Ewan D. Milne" <emilne@redhat.com>, Martin Wilck <martin.wilck@suse.com>,
	"Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
In-Reply-To: <c8ede601244e1710dbf320c33c0f7853e249bbee.camel@redhat.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
	<59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
	<65f66a5e03081dd3b470fa9aeff9a77dbc41743c.camel@redhat.com>
	<488ef3e7fa0cca4f0a0cb2e9307ddaa08385d3f7.camel@suse.com>
	<c8ede601244e1710dbf320c33c0f7853e249bbee.camel@redhat.com>
Date: Wed, 28 Apr 2021 10:09:25 +1000
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
X-Exim-ID: 1lbXqf-001ARM-IW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:48746
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8723577805685795230=="

--===============8723577805685795230==
Content-Type: multipart/alternative; boundary="=-6itdzK+JZI6c9hhwPbqQ"

--=-6itdzK+JZI6c9hhwPbqQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable



On Tue, 2021-04-27 at 16:41 -0400, Ewan D. Milne wrote:
> On Tue, 2021-04-27 at 20:33 +0000, Martin Wilck wrote:
> > On Tue, 2021-04-27 at 16:14 -0400, Ewan D. Milne wrote:
> > >=20
> > > There's no way to do that, in principle.=C2=A0 Because there could be
> > > other I/Os in flight.=C2=A0 You might (somehow) avoid retrying an I/O
> > > that got a UA until you figured out if something changed, but
> > > other
> > > I/Os can already have been sent to the target, or issued before
> > > you
> > > get to look at the status.

If something happens on a storage side where a lun gets it's attributes
changed (any, doesn't matter which one) a UA should be sent. Also all
outstanding IO's on that lun should be returning an Abort as it can no
longer warrant the validity of any IO due to these changes. Especially
when parameters are involved like reservations (PR's) etc. If that does
not happen from an array side all bets are off as the only way to be
able to get back in business is to start from scratch.

> >=20
> >=20
> > Right. But in practice, a WWID change will hardly happen under full
> > IO
> > load. The storage side will probably have to block IO while this
> > happens, at least for a short time period. So blocking and
> > quiescing
> > the queue upon an UA might still work, most of the time. Even if we
> > were too late already, the sooner we stop the queue, the better.

I think in most cases when something happens on an array side you will
see IO's being aborted. That might be a good time to start doing TUR's
and if these come back OK do a new inquiry. From a host side there is
only so much you can do.

> >=20
> > The current algorithm in multipath-tools needs to detect a path
> > going
> > down and being reinstated. The time interval during which a WWID
> > change
> > will go unnoticed is one or more path checker intervals, typically
> > on
> > the order of 5-30 seconds. If we could decrease this interval to a
> > sub-
> > second or even millisecond range by blocking the queue in the
> > kernel
> > quickly, we'd have made a big step forward.
>=20
> Yes, and in many situations this may help.=C2=A0 But in the general case
> we can't protect against a storage array misconfiguration,
> where something like this can happen.=C2=A0 So I worry about people
> believing the host software will protect them against a mistake,
> when we can't really do that.

My thought exactly.=C2=A0

>=20
> All it takes is one I/O (a discard) to make a thorough mess of the
> LUN.
>=20
> -Ewan
>=20
> >=20
> > Regards
> > Martin
> >=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>=20

--=-6itdzK+JZI6c9hhwPbqQ
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div><br></div><div><span></span></div><div><br></=
div><div>On Tue, 2021-04-27 at 16:41 -0400, Ewan D. Milne wrote:</div><bloc=
kquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf so=
lid;padding-left:1ex"><div>On Tue, 2021-04-27 at 20:33 +0000, Martin Wilck =
wrote:<br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; borde=
r-left:2px #729fcf solid;padding-left:1ex"><div>On Tue, 2021-04-27 at 16:14=
 -0400, Ewan D. Milne wrote:<br></div><blockquote type=3D"cite" style=3D"ma=
rgin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div><br><=
/div><div>There's no way to do that, in principle.&nbsp; Because there coul=
d be<br></div><div>other I/Os in flight.&nbsp; You might (somehow) avoid re=
trying an I/O<br></div><div>that got a UA until you figured out if somethin=
g changed, but other<br></div><div>I/Os can already have been sent to the t=
arget, or issued before you<br></div><div>get to look at the status.<br></d=
iv></blockquote></blockquote></blockquote><div><br></div><div>If something =
happens on a storage side where a lun gets it's attributes changed (any, do=
esn't matter which one) a UA should be sent. Also all outstanding IO's on t=
hat lun should be returning an Abort as it can no longer warrant the validi=
ty of any IO due to these changes. Especially when parameters are involved =
like reservations (PR's) etc. If that does not happen from an array side al=
l bets are off as the only way to be able to get back in business is to sta=
rt from scratch.</div><div><br></div><blockquote type=3D"cite" style=3D"mar=
gin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockquote=
 type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;pa=
dding-left:1ex"><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; borde=
r-left:2px #729fcf solid;padding-left:1ex"></blockquote><div><br></div><div=
>Right. But in practice, a WWID change will hardly happen under full<br></d=
iv><div>IO<br></div><div>load. The storage side will probably have to block=
 IO while this<br></div><div>happens, at least for a short time period. So =
blocking and quiescing<br></div><div>the queue upon an UA might still work,=
 most of the time. Even if we<br></div><div>were too late already, the soon=
er we stop the queue, the better.<br></div></blockquote></blockquote><div><=
br></div><div>I think in most cases when something happens on an array side=
 you will see IO's being aborted. That might be a good time to start doing =
TUR's and if these come back OK do a new inquiry. From a host side there is=
 only so much you can do.</div><div><br></div><blockquote type=3D"cite" sty=
le=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><b=
lockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf=
 solid;padding-left:1ex"><div><br></div><div>The current algorithm in multi=
path-tools needs to detect a path going<br></div><div>down and being reinst=
ated. The time interval during which a WWID<br></div><div>change<br></div><=
div>will go unnoticed is one or more path checker intervals, typically on<b=
r></div><div>the order of 5-30 seconds. If we could decrease this interval =
to a<br></div><div>sub-<br></div><div>second or even millisecond range by b=
locking the queue in the kernel<br></div><div>quickly, we'd have made a big=
 step forward.<br></div></blockquote><div><br></div><div>Yes, and in many s=
ituations this may help.&nbsp; But in the general case<br></div><div>we can=
't protect against a storage array misconfiguration,<br></div><div>where so=
mething like this can happen.&nbsp; So I worry about people<br></div><div>b=
elieving the host software will protect them against a mistake,<br></div><d=
iv>when we can't really do that.<br></div></blockquote><div><br></div><div>=
My thought exactly.&nbsp;</div><div><br></div><blockquote type=3D"cite" sty=
le=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><d=
iv><br></div><div>All it takes is one I/O (a discard) to make a thorough me=
ss of the LUN.<br></div><div><br></div><div>-Ewan<br></div><div><br></div><=
blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fc=
f solid;padding-left:1ex"><div><br></div><div>Regards<br></div><div>Martin<=
br></div><div><br></div></blockquote><div><br></div><div>--<br></div><div>d=
m-devel mailing list<br></div><div><a href=3D"mailto:dm-devel@redhat.com">d=
m-devel@redhat.com</a><br></div><div><a href=3D"https://listman.redhat.com/=
mailman/listinfo/dm-devel">https://listman.redhat.com/mailman/listinfo/dm-d=
evel</a><br></div><div><br></div></blockquote></body></html>

--=-6itdzK+JZI6c9hhwPbqQ--

--===============8723577805685795230==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============8723577805685795230==--

