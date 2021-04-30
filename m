Return-Path: <SRS0=Ylab=J3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5501FC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 23:48:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C42A461423
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 23:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C42A461423
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619826533;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=og3SnP7RhpHPz0t/t5ROtLt9OHrGo1FAHHWeuJMEOfk=;
	b=gxe1vHKAkcANKxJPMR436y5QRT/CO/cJEPMY5NPlg8xF8d5bx/Xh0o9rTLxkgSTO8GInIJ
	1N+L2xb2HHojq+2u1Ctwa9r5JeE/jyDEtt/EjLAmVU1rcSkbEFUucLqW2L/dgFN7WUGH16
	mxxbZ3n77V2miSXUVdaP6RqsV/vp6IM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-oaC-KUdIPt6tBgHHLceSwQ-1; Fri, 30 Apr 2021 19:48:50 -0400
X-MC-Unique: oaC-KUdIPt6tBgHHLceSwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6282C10066E5;
	Fri, 30 Apr 2021 23:48:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFFAC19C66;
	Fri, 30 Apr 2021 23:48:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 98DFE55346;
	Fri, 30 Apr 2021 23:48:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13UNisL5009594 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Apr 2021 19:44:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 043021045E8D; Fri, 30 Apr 2021 23:44:54 +0000 (UTC)
Received: from ovpn-112-213.phx2.redhat.com (ovpn-112-213.phx2.redhat.com
	[10.3.112.213])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11BDD1045E8A;
	Fri, 30 Apr 2021 23:44:48 +0000 (UTC)
Message-ID: <ba1ed6166b285d4ccb90f5f17b971983092d382e.camel@redhat.com>
From: "Ewan D. Milne" <emilne@redhat.com>
To: Erwin van Londen <erwin@erwinvanlonden.net>, Martin Wilck
	<martin.wilck@suse.com>, "Ulrich.Windl@rz.uni-regensburg.de"
	<Ulrich.Windl@rz.uni-regensburg.de>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Date: Fri, 30 Apr 2021 19:44:48 -0400
In-Reply-To: <455a6e5086831323af86a150d21d5a0a7c2299eb.camel@erwinvanlonden.net>
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
	<455a6e5086831323af86a150d21d5a0a7c2299eb.camel@erwinvanlonden.net>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>, "hch@lst.de" <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0501020410436871002=="

--===============0501020410436871002==
Content-Type: multipart/alternative; boundary="=-k+6e6GnuvzHPpSUsaKLD"

--=-k+6e6GnuvzHPpSUsaKLD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2021-04-28 at 10:09 +1000, Erwin van Londen wrote:
> 
> On Tue, 2021-04-27 at 16:41 -0400, Ewan D. Milne wrote:
> > On Tue, 2021-04-27 at 20:33 +0000, Martin Wilck wrote:
> > > On Tue, 2021-04-27 at 16:14 -0400, Ewan D. Milne wrote:
> > > > There's no way to do that, in principle.  Because there could
> > > > be
> > > > other I/Os in flight.  You might (somehow) avoid retrying an
> > > > I/O
> > > > that got a UA until you figured out if something changed, but
> > > > other
> > > > I/Os can already have been sent to the target, or issued before
> > > > you
> > > > get to look at the status.
> 
> If something happens on a storage side where a lun gets it's
> attributes changed (any, doesn't matter which one) a UA should be
> sent. Also all outstanding IO's on that lun should be returning an
> Abort as it can no longer warrant the validity of any IO due to these
> changes. Especially when parameters are involved like reservations
> (PR's) etc. If that does not happen from an array side all bets are
> off as the only way to be able to get back in business is to start
> from scratch.

Perhaps an array might abort I/Os it has received in the Device Server
whensomething changes.  I have no idea if most or any arrays actually
do that.
But, what about I/O that has already been queued from the host to
thehost bus adapter?  I don't see how we can abort those I/Os
properly.Most high-performance HBAs have a queue of commands and a
queueof responses, there could be lots of commands queued before
wemanage to notice an interesting status.  And AFAIK there is no
conditionalmechanism that could hold them off (and, they could be in-
flight on thewire anyway).
I get what you are saying about what SAM describes, I just don't see
howwe can guarantee we don't send any further commands after the
statuswith the UA is sent back, before we can understand what happened.
-Ewan
> > > 
> > > Right. But in practice, a WWID change will hardly happen under
> > > full
> > > IO
> > > load. The storage side will probably have to block IO while this
> > > happens, at least for a short time period. So blocking and
> > > quiescing
> > > the queue upon an UA might still work, most of the time. Even if
> > > we
> > > were too late already, the sooner we stop the queue, the better.
> 
> I think in most cases when something happens on an array side you
> will see IO's being aborted. That might be a good time to start doing
> TUR's and if these come back OK do a new inquiry. From a host side
> there is only so much you can do.
> 
> > > The current algorithm in multipath-tools needs to detect a path
> > > going
> > > down and being reinstated. The time interval during which a WWID
> > > change
> > > will go unnoticed is one or more path checker intervals,
> > > typically on
> > > the order of 5-30 seconds. If we could decrease this interval to
> > > a
> > > sub-
> > > second or even millisecond range by blocking the queue in the
> > > kernel
> > > quickly, we'd have made a big step forward.
> > 
> > Yes, and in many situations this may help.  But in the general case
> > we can't protect against a storage array misconfiguration,
> > where something like this can happen.  So I worry about people
> > believing the host software will protect them against a mistake,
> > when we can't really do that.
> 
> My thought exactly. 
> 
> > All it takes is one I/O (a discard) to make a thorough mess of the
> > LUN.
> > 
> > -Ewan
> > 
> > > Regards
> > > Martin
> > > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://listman.redhat.com/mailman/listinfo/dm-devel
> > 
> 
> --dm-devel mailing listdm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--=-k+6e6GnuvzHPpSUsaKLD
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr"><head></head><body style=3D"text-align:left; direction:lt=
r;"><div>On Wed, 2021-04-28 at 10:09 +1000, Erwin van Londen wrote:</div><b=
lockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf=
 solid;padding-left:1ex"><div><br></div><div><span></span></div><div><br></=
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
rt from scratch.</div></blockquote><div><br></div><div>Perhaps an array mig=
ht abort I/Os it has received in the Device Server when</div><div>something=
 changes.  I have no idea if most or any arrays actually do that.</div><div=
><br></div><div>But, what about I/O that has already been queued from the h=
ost to the</div><div>host bus adapter?  I don't see how we can abort those =
I/Os properly.</div><div>Most high-performance HBAs have a queue of command=
s and a queue</div><div>of responses, there could be lots of commands queue=
d before we</div><div>manage to notice an interesting status.  And AFAIK th=
ere is no conditional</div><div>mechanism that could hold them off (and, th=
ey could be in-flight on the</div><div>wire anyway).</div><div><br></div><d=
iv>I get what you are saying about what SAM describes, I just don't see how=
</div><div>we can guarantee we don't send any further commands after the st=
atus</div><div>with the UA is sent back, before we can understand what happ=
ened.</div><div><br></div><div>-Ewan</div><div><br></div><blockquote type=
=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding=
-left:1ex"><div><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .=
8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockquote type=3D"ci=
te" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:=
1ex"><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px =
#729fcf solid;padding-left:1ex"></blockquote><div><br></div><div>Right. But=
 in practice, a WWID change will hardly happen under full<br></div><div>IO<=
br></div><div>load. The storage side will probably have to block IO while t=
his<br></div><div>happens, at least for a short time period. So blocking an=
d quiescing<br></div><div>the queue upon an UA might still work, most of th=
e time. Even if we<br></div><div>were too late already, the sooner we stop =
the queue, the better.<br></div></blockquote></blockquote><div><br></div><d=
iv>I think in most cases when something happens on an array side you will s=
ee IO's being aborted. That might be a good time to start doing TUR's and i=
f these come back OK do a new inquiry. From a host side there is only so mu=
ch you can do.</div><div><br></div><blockquote type=3D"cite" style=3D"margi=
n:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockquote t=
ype=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padd=
ing-left:1ex"><div><br></div><div>The current algorithm in multipath-tools =
needs to detect a path going<br></div><div>down and being reinstated. The t=
ime interval during which a WWID<br></div><div>change<br></div><div>will go=
 unnoticed is one or more path checker intervals, typically on<br></div><di=
v>the order of 5-30 seconds. If we could decrease this interval to a<br></d=
iv><div>sub-<br></div><div>second or even millisecond range by blocking the=
 queue in the kernel<br></div><div>quickly, we'd have made a big step forwa=
rd.<br></div></blockquote><div><br></div><div>Yes, and in many situations t=
his may help.&nbsp; But in the general case<br></div><div>we can't protect =
against a storage array misconfiguration,<br></div><div>where something lik=
e this can happen.&nbsp; So I worry about people<br></div><div>believing th=
e host software will protect them against a mistake,<br></div><div>when we =
can't really do that.<br></div></blockquote><div><br></div><div>My thought =
exactly.&nbsp;</div><div><br></div><blockquote type=3D"cite" style=3D"margi=
n:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div><br></di=
v><div>All it takes is one I/O (a discard) to make a thorough mess of the L=
UN.<br></div><div><br></div><div>-Ewan<br></div><div><br></div><blockquote =
type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;pad=
ding-left:1ex"><div><br></div><div>Regards<br></div><div>Martin<br></div><d=
iv><br></div></blockquote><div><br></div><div>--<br></div><div>dm-devel mai=
ling list<br></div><div><a href=3D"mailto:dm-devel@redhat.com">dm-devel@red=
hat.com</a><br></div><div><a href=3D"https://listman.redhat.com/mailman/lis=
tinfo/dm-devel">https://listman.redhat.com/mailman/listinfo/dm-devel</a><br=
></div><div><br></div></blockquote>
<pre>--</pre><pre>dm-devel mailing list</pre><pre><a href=3D"mailto:dm-deve=
l@redhat.com">dm-devel@redhat.com</a></pre><pre><a href=3D"https://listman.=
redhat.com/mailman/listinfo/dm-devel">https://listman.redhat.com/mailman/li=
stinfo/dm-devel</a></pre></blockquote></body></html>

--=-k+6e6GnuvzHPpSUsaKLD--

--===============0501020410436871002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0501020410436871002==--

