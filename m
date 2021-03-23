Return-Path: <SRS0=HPtm=IV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FE0C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 09:24:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A3A761984
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 09:24:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A3A761984
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-IfXJDUDsObSS9fdaj_-3WQ-1; Tue, 23 Mar 2021 05:24:14 -0400
X-MC-Unique: IfXJDUDsObSS9fdaj_-3WQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45B9E107ACCD;
	Tue, 23 Mar 2021 09:24:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59C1319D61;
	Tue, 23 Mar 2021 09:24:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B2CA34BB7C;
	Tue, 23 Mar 2021 09:24:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12N8jceS008317 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Mar 2021 04:45:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6934D2166B44; Tue, 23 Mar 2021 08:45:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61A672157F23
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 08:45:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83D4C805F4B
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 08:45:35 +0000 (UTC)
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com
	[192.185.47.206]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-132-W9z80KKtO3ulK27hs--2Nw-1; Tue, 23 Mar 2021 04:45:32 -0400
X-MC-Unique: W9z80KKtO3ulK27hs--2Nw-1
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
	by gateway22.websitewelcome.com (Postfix) with ESMTP id 2D75212B91
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 02:57:44 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id Obv5lq6FRmJLsObv6lZQ92; Tue, 23 Mar 2021 02:57:44 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:54686
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>) id 1lObv5-0049Fx-5Y
	for dm-devel@redhat.com; Tue, 23 Mar 2021 01:57:43 -0600
Message-ID: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: dm-devel@redhat.com
Date: Tue, 23 Mar 2021 17:52:33 +1000
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
X-Exim-ID: 1lObv5-0049Fx-5Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:54686
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 1
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
X-Mailman-Approved-At: Tue, 23 Mar 2021 05:24:01 -0400
Subject: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3627668160293451811=="

--===============3627668160293451811==
Content-Type: multipart/alternative; boundary="=-0maMX4gR6CgBgYxF2vJe"

--=-0maMX4gR6CgBgYxF2vJe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello All,

Just wondering if there were any plans to incorporate FPIN
congestion/latency notifications in dm-multipath to disperse IO over
non-affected paths.

Regards,
Erwin van Londen
-- 
Kind regards,

Erwin van Londen
http://erwinvanlonden.net
PGP key: http://erwinvanlonden.net/pgp-key-id/




--=-0maMX4gR6CgBgYxF2vJe
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div style=3D"caret-color: rgb(0, 0, 0); color: rg=
b(0, 0, 0); font-family: &quot;Comic Sans MS&quot;; font-size: 13.333333015=
441895px; font-style: normal; font-variant-caps: normal; font-weight: norma=
l; letter-spacing: normal; orphans: auto; text-align: start; text-indent: 0=
px; text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-stroke-w=
idth: 0px; text-decoration: none;">Hello All,</div><div style=3D"caret-colo=
r: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: &quot;Comic Sans MS&quot=
;; font-size: 13.333333015441895px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; text-al=
ign: start; text-indent: 0px; text-transform: none; white-space: normal; wi=
dows: auto; word-spacing: 0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0=
.4); -webkit-text-stroke-width: 0px; text-decoration: none;"><br></div><div=
 style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: &quo=
t;Comic Sans MS&quot;; font-size: 13.333333015441895px; font-style: normal;=
 font-variant-caps: normal; font-weight: normal; letter-spacing: normal; or=
phans: auto; text-align: start; text-indent: 0px; text-transform: none; whi=
te-space: normal; widows: auto; word-spacing: 0px; -webkit-tap-highlight-co=
lor: rgba(0, 0, 0, 0.4); -webkit-text-stroke-width: 0px; text-decoration: n=
one;">Just wondering if there were any plans to incorporate FPIN congestion=
/latency notifications in dm-multipath to disperse IO over non-affected pat=
hs.</div><div style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font=
-family: &quot;Comic Sans MS&quot;; font-size: 13.333333015441895px; font-s=
tyle: normal; font-variant-caps: normal; font-weight: normal; letter-spacin=
g: normal; orphans: auto; text-align: start; text-indent: 0px; text-transfo=
rm: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-tap=
-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-stroke-width: 0px; text-=
decoration: none;"><br></div><div style=3D"caret-color: rgb(0, 0, 0); color=
: rgb(0, 0, 0); font-family: &quot;Comic Sans MS&quot;; font-size: 13.33333=
3015441895px; font-style: normal; font-variant-caps: normal; font-weight: n=
ormal; letter-spacing: normal; orphans: auto; text-align: start; text-inden=
t: 0px; text-transform: none; white-space: normal; widows: auto; word-spaci=
ng: 0px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0.4); -webkit-text-stro=
ke-width: 0px; text-decoration: none;">Regards,</div><div style=3D"caret-co=
lor: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: &quot;Comic Sans MS&qu=
ot;; font-size: 13.333333015441895px; font-style: normal; font-variant-caps=
: normal; font-weight: normal; letter-spacing: normal; orphans: auto; text-=
align: start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-tap-highlight-color: rgba(0, 0, 0,=
 0.4); -webkit-text-stroke-width: 0px; text-decoration: none;">Erwin van Lo=
nden</div><div><span><pre>-- <br></pre><div data-evo-paragraph=3D"" class=
=3D"" style=3D"width: 71ch;" data-evo-signature-plain-text-mode=3D"">Kind r=
egards,</div><div data-evo-paragraph=3D"" class=3D"" style=3D"width: 71ch;"=
><br></div><div data-evo-paragraph=3D"" class=3D"" style=3D"width: 71ch;">E=
rwin van Londen</div><div data-evo-paragraph=3D"" class=3D"" style=3D"width=
: 71ch;"><a href=3D"http://erwinvanlonden.net">http://erwinvanlonden.net</a=
></div><div data-evo-paragraph=3D"" class=3D"" style=3D"width: 71ch;">PGP k=
ey: <a href=3D"http://erwinvanlonden.net/pgp-key-id/">http://erwinvanlonden=
.net/pgp-key-id/</a></div><div data-evo-paragraph=3D"" class=3D"" style=3D"=
width: 71ch;"><br></div></span></div><div><br></div><div><br></div></body><=
/html>

--=-0maMX4gR6CgBgYxF2vJe--

--===============3627668160293451811==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============3627668160293451811==--

