Return-Path: <SRS0=HU+X=JD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9903C433B4
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:40:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E04B06136A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E04B06136A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-D9NPN7bwOhy-LDewRaQX_Q-1; Tue, 06 Apr 2021 07:40:48 -0400
X-MC-Unique: D9NPN7bwOhy-LDewRaQX_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DBF81800D50;
	Tue,  6 Apr 2021 11:40:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AA9560C3A;
	Tue,  6 Apr 2021 11:40:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BD154A7C8;
	Tue,  6 Apr 2021 11:40:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 131Muv7P014940 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 1 Apr 2021 18:56:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0EB70115D36C; Thu,  1 Apr 2021 22:56:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09574115D368
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 22:56:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35A1D101A531
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 22:56:54 +0000 (UTC)
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com
	[192.185.48.251]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-415-P_CCY_mqPM2meTqwIEk-5w-1; Thu, 01 Apr 2021 18:56:51 -0400
X-MC-Unique: P_CCY_mqPM2meTqwIEk-5w-1
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
	by gateway23.websitewelcome.com (Postfix) with ESMTP id F15E539EE
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 17:08:45 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id S5UblQHGGb8LyS5UblgocP; Thu, 01 Apr 2021 17:08:45 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:50332
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lS5Ua-001AJU-P1; Thu, 01 Apr 2021 16:08:45 -0600
Message-ID: <d6c3e5c7682d209263de5ca3612228b9468051a2.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Martin Wilck <martin.wilck@suse.com>, "muneendra.kumar@broadcom.com"
	<muneendra.kumar@broadcom.com>, "bblock@linux.ibm.com"
	<bblock@linux.ibm.com>, "hare@suse.de" <hare@suse.de>
In-Reply-To: <93f19c1bb5731394225f71936e1cc44509020152.camel@suse.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
	<7b5ce0567f03bc3d394481642a97a3d499fe3976.camel@erwinvanlonden.net>
	<93f19c1bb5731394225f71936e1cc44509020152.camel@suse.com>
Date: Fri, 02 Apr 2021 08:04:56 +1000
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
X-Exim-ID: 1lS5Ua-001AJU-P1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:50332
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 2
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 06 Apr 2021 07:35:52 -0400
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2484464756393903996=="

--===============2484464756393903996==
Content-Type: multipart/related; type="multipart/alternative";
	boundary="=-hq+HMKMb+n38/XQ3DR2G"

--=-hq+HMKMb+n38/XQ3DR2G
Content-Type: multipart/alternative; boundary="=-S6Ff2Jt5O9mfoengEDLC"

--=-S6Ff2Jt5O9mfoengEDLC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Martin,

On Thu, 2021-04-01 at 10:16 +0000, Martin Wilck wrote:
> On Thu, 2021-04-01 at 12:48 +1000, Erwin van Londen wrote:
> > >=20
> > > Benjamin has added a marginal_path group(multipath marginal
> > > pathgroups) in
> > > the dm-multipath.
> > > https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-=
1-git
> > > -send-email-bmarzins@redhat.com/
> > >=20
> > > One of the intention of the Benjamin's patch (support for maginal
> > > path) is
> > > to support for the FPIN events we receive from fabric.
> > > On receiving the fpin-li our intention was to=C2=A0 place all the
> > > paths
> > > that
> > > are affected into the marginal path group.
> > I think this should all be done in kernel space as we're talking
> > sub-
> > millisecond timings here when it comes to fpins and the reaction
> > time
> > expected. I may be wrong but I'll leave that up to you.
>=20
> Sub-ms latency is impossible with this setup=C2=A0 (kernel -> broadcom FC
> daemon -> multipathd -> kernel). It's only suitable for "fatal" FPINs
> that would suggest taking a path offline on the time scale of
> minutes.
> I suppose that would work well for LN FPINs, but not for the other
> types.
I agree. I was hoping the FC drivers would be able to play a role in
this and provide a direct hook into the FPIN notifications in such a
way that userspace daemons would not be required and multipath would be
able to play a direct role here.
When it comes to latency in a san we're indeed talking about sub-ms
when it comes to impacting other parts of the fabrics having an
immediate effect on multiple initiators and targets due to the shared
nature of the beast.
>=20
> > >=20
> > > On receiving the congestion notifications our intention is to
> > > slowdown the
> > > work load gradually from the host until it stops receiving the
> > > congestion
> > > notifications.
> > > We need to validate the same how we can achieve the same of
> > > decreasing the
> > > workloads with the help of dm-multipath.
> > Would it be possible to piggyback on the service time path selector
> > in this when it pertains latency? =C2=A0
>=20
> Not on service-time itself, but someone could write a new path
> selector
> algorithm. IMO we'd still have the problem that this would be seen as
> a
> layering violation. In the long run dm-mpath may need to add
> transport-
> specific callbacks. But for a proof-of-concept, a selector algorithm
> with layering violations would be ok, I believe.
Is that an offer of volunteering?? :-)
>=20
> Regards
> Martin
>=20

--=-S6Ff2Jt5O9mfoengEDLC
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div>Hello Martin,</div><div><span></span></div><d=
iv><br></div><div>On Thu, 2021-04-01 at 10:16 +0000, Martin Wilck wrote:</d=
iv><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #7=
29fcf solid;padding-left:1ex"><div>On Thu, 2021-04-01 at 12:48 +1000, Erwin=
 van Londen wrote:<br></div><blockquote type=3D"cite" style=3D"margin:0 0 0=
 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockquote type=3D"=
cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-lef=
t:1ex"><div><br></div><div>Benjamin has added a marginal_path group(multipa=
th marginal<br></div><div>pathgroups) in<br></div><div>the dm-multipath.<br=
></div><div><a href=3D"https://patchwork.kernel.org/project/dm-devel/cover/=
1564763622-31752-1-git">https://patchwork.kernel.org/project/dm-devel/cover=
/1564763622-31752-1-git</a><br></div><div><a href=3D"mailto:-send-email-bma=
rzins@redhat.com">-send-email-bmarzins@redhat.com</a>/<br></div><div><br></=
div><div>One of the intention of the Benjamin's patch (support for maginal<=
br></div><div>path) is<br></div><div>to support for the FPIN events we rece=
ive from fabric.<br></div><div>On receiving the fpin-li our intention was t=
o&nbsp; place all the paths<br></div><div>that<br></div><div>are affected i=
nto the marginal path group.<br></div></blockquote><div>I think this should=
 all be done in kernel space as we're talking sub-<br></div><div>millisecon=
d timings here when it comes to fpins and the reaction time<br></div><div>e=
xpected. I may be wrong but I'll leave that up to you.<br></div></blockquot=
e><div><br></div><div>Sub-ms latency is impossible with this setup&nbsp; (k=
ernel -&gt; broadcom FC<br></div><div>daemon -&gt; multipathd -&gt; kernel)=
. It's only suitable for "fatal" FPINs<br></div><div>that would suggest tak=
ing a path offline on the time scale of minutes.<br></div><div>I suppose th=
at would work well for LN FPINs, but not for the other<br></div><div>types.=
<br></div></blockquote><div>I agree. I was hoping the FC drivers would be a=
ble to play a role in this and provide a direct hook into the FPIN notifica=
tions in such a way that userspace daemons would not be required and multip=
ath would be able to play a direct role here.</div><div>When it comes to la=
tency in a san we're indeed talking about sub-ms when it comes to impacting=
 other parts of the fabrics having an immediate effect on multiple initiato=
rs and targets due to the shared nature of the beast.</div><blockquote type=
=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding=
-left:1ex"><div><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .=
8ex; border-left:2px #729fcf solid;padding-left:1ex"><blockquote type=3D"ci=
te" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:=
1ex"><div><br></div><div>On receiving the congestion notifications our inte=
ntion is to<br></div><div>slowdown the<br></div><div>work load gradually fr=
om the host until it stops receiving the<br></div><div>congestion<br></div>=
<div>notifications.<br></div><div>We need to validate the same how we can a=
chieve the same of<br></div><div>decreasing the<br></div><div>workloads wit=
h the help of dm-multipath.<br></div></blockquote><div>Would it be possible=
 to piggyback on the service time path selector<br></div><div>in this when =
it pertains latency? &nbsp;<br></div></blockquote><div><br></div><div>Not o=
n service-time itself, but someone could write a new path selector<br></div=
><div>algorithm. IMO we'd still have the problem that this would be seen as=
 a<br></div><div>layering violation. In the long run dm-mpath may need to a=
dd transport-<br></div><div>specific callbacks. But for a proof-of-concept,=
 a selector algorithm<br></div><div>with layering violations would be ok, I=
 believe.<br></div></blockquote><div>Is that an offer of volunteering?? <im=
g src=3D"cid:88740517b7df4d6319c3f74bbf138f921aa2fb37.camel@erwinvanlonden.=
net-0" alt=3D":-)" width=3D"16px" height=3D"16px"></div><blockquote type=3D=
"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-le=
ft:1ex"><div><br></div><div>Regards<br></div><div>Martin<br></div><div><br>=
</div></blockquote></body></html>

--=-S6Ff2Jt5O9mfoengEDLC--

--=-hq+HMKMb+n38/XQ3DR2G
Content-ID: <88740517b7df4d6319c3f74bbf138f921aa2fb37.camel@erwinvanlonden.net-0>
Content-Disposition: inline; filename="face-smile.png"
Content-Type: image/png; name="face-smile.png"
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADLklEQVR4AV2MA5Q0uRpAb6raPTj9
G2PjvbVt27btPV7btm3btjW23Swklax5P1PwH+49bYNqQsHhEdvaCSGWasA2esRV5mktwrcdfPHb
ffyDvx48uvvutqwaugzLOqp1hapwWXNrKDZvHgKBm04z3NYuv/q8TSlf3Vg8UnHmHo89Fvz14K2z
NwoN5bxXFqbia627w26JSCqJ1m2YsAtohB9BmDoCJ8lbTz9YGBic+HDBZPVWvz6xATZbZck184oj
22+0x9EJCt/x2HOP8tNImtY1yrBiYYzJcs4591PMBOtufWh4rLdtyZA3OP/lL0dfsW49Zb0GP9CH
rrvptgk59iHBzPv80OfyXXsaEYnBrxZP8nVHnm+/+xav42E2226vhA9HnnfQSvWWdOWxDYsSkUhp
GX73sxgM0YggHrMB/ZsJo3+ro1GBGvkQy59lrZbaiPKCY+wtVl58y9or/T8V8kbQ6R+xYxESC1PU
NS5h+fIoKB9yGVRWsmalJildtONTvPT/1idff7c45AVmcbJkAbmxL8lMeywpcVh1SQx7sYuZGAYD
Opdll1UVctwlyEqmhrsRDWvhSJaGPGmEk5sjYiRaKp5+d5bKSklzs0/J/CQC0I6DM5Pn+x+z/NSd
p26Jw8orhfEDbYWklFMD/e3L6lI28+yALf8/j++nI9zxxBhYGtsSKD8gn1O0lpWySWsR84oX0N/5
FVKqyV8emJe/6ug7qHyVWgtXEcpMseKiJayywoZIO4lUGtuOYCsXPfY9argNv6SaT77+VkulXxIn
7NS0qkXw7naV+URDkcQSWXQ8ihQW0ooRiDg68LC8LLFAETIJevQC7vrMLfi+Wc/+pG1qdNX6eSsN
p2VNqZkIF2tFKDCIQKOlT1DII1yHqPTB8emd83iyXThpx3r2kfcGrrcBVm6MvZDzYrsNFqLF8VAh
bAUBESUJKUX4F8OXzLma7qzguYF5zng+2i0Cs92PQxkl+IP9t1icNCp2nzFmi9qSdKI2WRCpqAJg
xgvRlYmb9tliB8RLrqsPeO6LkQKA4D/svE7l2rbQJwGbB1ACYAkyGF412Fc/+UHfx/yDnwGHuJ5z
2Cp4/gAAAABJRU5ErkJggg==
--=-hq+HMKMb+n38/XQ3DR2G--

--===============2484464756393903996==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2484464756393903996==--

