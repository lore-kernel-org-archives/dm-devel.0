Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD10BC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  6 Dec 2021 23:48:49 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-Xyw-UDWZN1uAmYzTu60Iww-1; Mon, 06 Dec 2021 18:48:47 -0500
X-MC-Unique: Xyw-UDWZN1uAmYzTu60Iww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD4E281CCB4;
	Mon,  6 Dec 2021 23:48:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B09E60843;
	Mon,  6 Dec 2021 23:48:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0185C1809CB8;
	Mon,  6 Dec 2021 23:48:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B6NmXcr010986 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Dec 2021 18:48:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9B1B9C15E74; Mon,  6 Dec 2021 23:48:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9629AC15E72
	for <dm-devel@redhat.com>; Mon,  6 Dec 2021 23:48:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D04F811E81
	for <dm-devel@redhat.com>; Mon,  6 Dec 2021 23:48:33 +0000 (UTC)
Received: from gproxy2-pub.mail.unifiedlayer.com
	(gproxy2-pub.mail.unifiedlayer.com [69.89.18.3]) by relay.mimecast.com
	with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-380-3SoCjnpWNxCE4xNzrDL0JQ-1; Mon, 06 Dec 2021 18:48:32 -0500
X-MC-Unique: 3SoCjnpWNxCE4xNzrDL0JQ-1
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
	by gproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id 488238033C23
	for <dm-devel@redhat.com>; Mon,  6 Dec 2021 23:24:10 +0000 (UTC)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with ESMTP
	id uNL8meCLdoTT8uNL8mfIg5; Mon, 06 Dec 2021 23:24:10 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=LMCj/La9 c=1 sm=1 tr=0 ts=61ae9b9a
	a=0Zc1vavb5vNBbqz++vQv9A==:117 a=0Zc1vavb5vNBbqz++vQv9A==:17
	a=IOMw9HtfNCkA:10:nop_rcvd_month_year
	a=8QztvWECkzkA:10:endurance_base64_authed_username_1 a=20KFwNOVAAAA:8
	a=NuaeAdkCxJkXdndNKV4A:9 a=QEXdDO2ut3YA:10:nop_charset_2
	a=0WsZoExNXDjyHHtb6rYA:9 a=as-m7dDMGYfLGXHl:21
	a=_W_S_7VecoQA:10:nop_html
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:46568
	helo=[10.69.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1muNL7-000YKm-Fw; Mon, 06 Dec 2021 16:24:09 -0700
Message-ID: <f7ab2f4c696a7e17806d08b796324ca53cefbb6f.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Martin Wilck <martin.wilck@suse.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, "muneendra.kumar@broadcom.com"
	<muneendra.kumar@broadcom.com>
In-Reply-To: <bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
Date: Tue, 07 Dec 2021 09:19:00 +1000
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
X-Exim-ID: 1muNL7-000YKm-Fw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([10.69.1.104])
	[116.240.66.4]:46568
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2032001489612174200=="

--===============2032001489612174200==
Content-Type: multipart/alternative; boundary="=-w9I4/qw2tSAq9QKROxRs"

--=-w9I4/qw2tSAq9QKROxRs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello Martin, Muneendra.

As I kicked this discussion off in the beginning of the year and seeing
the Muneendra and the broadcom people have come up with the first
iteration I can only applaud the efforts. On behalf of all storage and
linux administrators I would say "Thank you".

As for your remark Martin my view would be to try and create a modular
approach where the transport layer drivers can hook into and inform
multipathd of any event. The module in multipathd would then decide
based on configured characteristics what the actions should be. (Take
it offline, suspend for X amount of time, introduce X us delay etc...)
That way when more transport methods are used these can then
dynamically be linked into the configuration without having any impact
on other parts of the transport stack. I can imagine that Infiniband.
ethernet, SAS and others utilise different transport characteristics
and as such may need to inform the attached hosts of one or more
events. On FC this is FPIN but a similar module may be written for
other transports.

Thanks
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

--=-w9I4/qw2tSAq9QKROxRs
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div>Hello Martin, Muneendra.</div><div><br></div>=
<div>As I kicked this discussion off in the beginning of the year and seein=
g the Muneendra and the broadcom people have come up with the first iterati=
on I can only applaud the efforts. On behalf of all storage and linux admin=
istrators I would say "Thank you".</div><div><br></div><div>As for your rem=
ark Martin my view would be to try and create a modular approach where the =
transport layer drivers can hook into and inform multipathd of any event. T=
he module in multipathd would then decide based on configured characteristi=
cs what the actions should be. (Take it offline, suspend for X amount of ti=
me, introduce X us delay etc...) That way when more transport methods are u=
sed these can then dynamically be linked into the configuration without hav=
ing any impact on other parts of the transport stack. I can imagine that In=
finiband. ethernet, SAS and others utilise different transport characterist=
ics and as such may need to inform the attached hosts of one or more events=
. On FC this is FPIN but a similar module may be written for other transpor=
ts.</div><div><br></div><div>Thanks</div><div>Erwin</div><div><span></span>=
</div><div><br></div><div>On Mon, 2021-12-06 at 13:58 +0000, Martin Wilck w=
rote:</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-lef=
t:2px #729fcf solid;padding-left:1ex"><div>On Fri, 2021-12-03 at 18:02 +010=
0, Martin Wilck wrote:<br></div><blockquote type=3D"cite" style=3D"margin:0=
 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div><br></div><=
div><br></div><div>Rather than adding a new config option, I'd prefer to ad=
d a new value<br></div><div>"fpin" to the marginal_pathgroups option. That =
would make it more<br></div><div>clear<br></div><div>that the two are actua=
lly related / exclusive.<br></div></blockquote><div><br></div><div>Another =
thought that occurred to me over the weekend: FPIN is fibre-<br></div><div>=
channel only. What if someone has a mix of FC and other transports?<br></di=
v><div>Would it make sense to use FPIN for FC paths and "traditional" margi=
nal<br></div><div>path detection for others? If yes, we'd need to change th=
e logic and<br></div><div>we'd probably have to add a 4th mode ("fpin-mixed=
" or whatever).<br></div><div><br></div><div>Regards<br></div><div>Martin<b=
r></div><div><br></div><div><br></div><div><br></div><div>--<br></div><div>=
dm-devel mailing list<br></div><div><a href=3D"mailto:dm-devel@redhat.com">=
dm-devel@redhat.com</a><br></div><div><a href=3D"https://listman.redhat.com=
/mailman/listinfo/dm-devel">https://listman.redhat.com/mailman/listinfo/dm-=
devel</a><br></div><div><br></div></blockquote></body></html>

--=-w9I4/qw2tSAq9QKROxRs--

--===============2032001489612174200==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2032001489612174200==--

