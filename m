Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E29C1C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 14:34:38 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-485-d3SGmYGHP7K2AyPQxoN8_A-1; Mon, 13 Dec 2021 09:34:35 -0500
X-MC-Unique: d3SGmYGHP7K2AyPQxoN8_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB67C10144E1;
	Mon, 13 Dec 2021 14:34:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE8B45D86;
	Mon, 13 Dec 2021 14:34:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3EA321809CB8;
	Mon, 13 Dec 2021 14:34:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BDEYLg4006051 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 09:34:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F41C7400E137; Mon, 13 Dec 2021 14:34:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0378400E109
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 14:34:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D41582B478C2
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 14:34:20 +0000 (UTC)
Received: from gproxy4-pub.mail.unifiedlayer.com
	(gproxy4-pub.mail.unifiedlayer.com [69.89.23.142]) by
	relay.mimecast.com
	with ESMTP id us-mta-433-6aigsaviOLC34-HjhlVLGQ-1; Mon, 13 Dec 2021
	09:34:18 -0500
X-MC-Unique: 6aigsaviOLC34-HjhlVLGQ-1
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
	by gproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 0A2D88033B47
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 05:45:32 +0000 (UTC)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with ESMTP
	id we9Tmbe9WU08Gwe9TmPh6J; Mon, 13 Dec 2021 05:45:31 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=To0jOBbh c=1 sm=1 tr=0 ts=61b6ddfc
	a=0Zc1vavb5vNBbqz++vQv9A==:117 a=0Zc1vavb5vNBbqz++vQv9A==:17
	a=IOMw9HtfNCkA:10:nop_rcvd_month_year
	a=8QztvWECkzkA:10:endurance_base64_authed_username_1 a=20KFwNOVAAAA:8
	a=vJ0mL5gONpUvShE1cHYA:9 a=QEXdDO2ut3YA:10:nop_charset_2
	a=0WsZoExNXDjyHHtb6rYA:9 a=as-m7dDMGYfLGXHl:21
	a=_W_S_7VecoQA:10:nop_html
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:39618
	helo=[10.69.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1mwe9T-003Sj3-7I; Sun, 12 Dec 2021 22:45:31 -0700
Message-ID: <e36a235ee7c626221415d1b94d50c1fe0b801763.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Martin Wilck <martin.wilck@suse.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, "muneendra.kumar@broadcom.com"
	<muneendra.kumar@broadcom.com>
In-Reply-To: <bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
Date: Mon, 13 Dec 2021 15:40:19 +1000
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
X-Exim-ID: 1mwe9T-003Sj3-7I
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([10.69.1.104])
	[116.240.66.4]:39618
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3029003367428674959=="

--===============3029003367428674959==
Content-Type: multipart/alternative; boundary="=-Y/g+u+lm96OytYL90gmF"

--=-Y/g+u+lm96OytYL90gmF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello Martin,

That is exactly the reason why we would need to modularise this. Access
characteristics between different transport protocols can differ
significantly and thus are susceptible to different indicators,
tolerances and other variations that would need a different config
setup. You don't really want to mix and match config options between
the various options as that would significantly increase complexity and
thus make the setup more errorprone. Things may often seem very clear
cut from a develop(ers/ment) perspective however from a system
administration side it gets often very confusing when even the smallest
things start to contradict each other.

When tcp packets timeout from a iscsi based device we're 100% relying
on tcp to sort itself out based on RTT values and slow start behaviour
whereas FC is far more reliant on all upper levels from scsi/nvme-o-f
side. These tolerances should be configurable independantly.

Regards
Erwin

On Mon, 2021-12-06 at 13:58 +0000, Martin Wilck wrote:
> On Fri, 2021-12-03 at 18:02 +0100, Martin Wilck wrote:
> > 
> > 
> > Rather than adding a new config option, I'd prefer to add a new
> > value
> > "fpin" to the marginal_pathgroups option. That would make it more
> > clear
> > that the two are actually related / exclusive.
> 
> Another thought that occurred to me over the weekend: FPIN is fibre-
> channel only. What if someone has a mix of FC and other transports?
> Would it make sense to use FPIN for FC paths and "traditional"
> marginal
> path detection for others? If yes, we'd need to change the logic and
> we'd probably have to add a 4th mode ("fpin-mixed" or whatever).
> 
> Regards
> Martin
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--=-Y/g+u+lm96OytYL90gmF
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div>Hello Martin,</div><div><br></div><div>That i=
s exactly the reason why we would need to modularise this. Access character=
istics between different transport protocols can differ significantly and t=
hus are susceptible to different indicators, tolerances and other variation=
s that would need a different config setup. You don't really want to mix an=
d match config options between the various options as that would significan=
tly increase complexity and thus make the setup more errorprone. Things may=
 often seem very clear cut from a develop(ers/ment) perspective however fro=
m a system administration side it gets often very confusing when even the s=
mallest things start to contradict each other.</div><div><br></div><div>Whe=
n tcp packets timeout from a iscsi based device we're 100% relying on tcp t=
o sort itself out based on RTT values and slow start behaviour whereas FC i=
s far more reliant on all upper levels from scsi/nvme-o-f side. These toler=
ances should be configurable independantly.</div><div><br></div><div>Regard=
s</div><div>Erwin</div><div><span></span></div><div><br></div><div>On Mon, =
2021-12-06 at 13:58 +0000, Martin Wilck wrote:</div><blockquote type=3D"cit=
e" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1=
ex"><div>On Fri, 2021-12-03 at 18:02 +0100, Martin Wilck wrote:<br></div><b=
lockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf=
 solid;padding-left:1ex"><div><br></div><div><br></div><div>Rather than add=
ing a new config option, I'd prefer to add a new value<br></div><div>"fpin"=
 to the marginal_pathgroups option. That would make it more<br></div><div>c=
lear<br></div><div>that the two are actually related / exclusive.<br></div>=
</blockquote><div><br></div><div>Another thought that occurred to me over t=
he weekend: FPIN is fibre-<br></div><div>channel only. What if someone has =
a mix of FC and other transports?<br></div><div>Would it make sense to use =
FPIN for FC paths and "traditional" marginal<br></div><div>path detection f=
or others? If yes, we'd need to change the logic and<br></div><div>we'd pro=
bably have to add a 4th mode ("fpin-mixed" or whatever).<br></div><div><br>=
</div><div>Regards<br></div><div>Martin<br></div><div><br></div><div><br></=
div><div><br></div><div>--<br></div><div>dm-devel mailing list<br></div><di=
v><a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br></div><=
div><a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel">https:=
//listman.redhat.com/mailman/listinfo/dm-devel</a><br></div><div><br></div>=
</blockquote></body></html>

--=-Y/g+u+lm96OytYL90gmF--

--===============3029003367428674959==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============3029003367428674959==--

