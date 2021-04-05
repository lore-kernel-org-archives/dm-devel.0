Return-Path: <SRS0=HU+X=JD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66006C433ED
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:42:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8D3D6136A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8D3D6136A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-fHXUuCfYNWmMVH0pMCc1ng-1; Tue, 06 Apr 2021 07:42:10 -0400
X-MC-Unique: fHXUuCfYNWmMVH0pMCc1ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55F4E802690;
	Tue,  6 Apr 2021 11:42:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E33CD60C17;
	Tue,  6 Apr 2021 11:42:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B20A24A7C8;
	Tue,  6 Apr 2021 11:42:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1355V4bL023633 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 5 Apr 2021 01:31:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 418802EFB0; Mon,  5 Apr 2021 05:31:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3856B2ED8C
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 05:31:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1A63800140
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 05:31:00 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1617600660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGNq8rihVBcXa7p/G+VQj0axgVXgmXx9irlMgGJfAuo=;
	b=EPY0x286x9b5l+g+UWTfXM30DqPzd+30woVjJ/u+EKPUsfbXxoJWu1E04jKiuURQPxVoZ1
	Z7EAFJOXgsJN526TWWn6b22cPpylDTcdq4OBL/H6rI/VI569e5u6HC/3q/Az8It4OJFJyX
	vZ6hj5tfkBnV54RATOt7ZZwZ2u6AxCTOsZ3Nyg/KktCY8NszUzr3Ln5uvA/0JyTmkk/x2B
	UZ4Y6Jinrhiz9+ylnE50XmSahiJdwo4od+KYA/MJLFfhljalGY1bF7HbQhSuF+Y5qvp0yI
	obN1xcfxQcVV4iC8ku6IoWi0dGIA90UBJBMnLIM/FmzzNWRmGZXkpmJqut6mMQ==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1617600660; a=rsa-sha256;
	cv=none;
	b=mR1vE/Aks4eKONc+s0QyU7PG2+t7AYS56KBlE5ICs5Jp9EE8WD/F+G+q5x+6Q0JpvWimIS
	MXwRZrCaodV57vjeGT/tFocpVbF8jNj1cGHI8+Kic6Ad4zD9LjwJrTKgDUaRy/KIcNsDTB
	8CjWywkQGxL3tmByD0rAb/zxzfOyTtUQcWJL0ZoF7/LDnIJNK/a/AsVWlrbzV0wb0Q+dWB
	C3aQRwBWX+wETORnHnGaZiM1qhNM4C5J2v6lGwA41pzc2yrgCS9E9yvixfmcPyTlerZ2PU
	ssp3p5V0NHlgElZ6nULxoWOC9qdBZfW0U14tgb9pyU+Cqu+gI8pYlqTAnBe6Ag==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=XI1OInjg;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.167.177 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
	[209.85.167.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-232-q7g0g2pSNeOMkY3lx_FG0A-1; Mon, 05 Apr 2021 01:30:55 -0400
X-MC-Unique: q7g0g2pSNeOMkY3lx_FG0A-1
Received: by mail-oi1-f177.google.com with SMTP id d12so10714982oiw.12
	for <dm-devel@redhat.com>; Sun, 04 Apr 2021 22:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=broadcom.com; s=google;
	h=from:references:in-reply-to:mime-version:thread-index:date
	:message-id:subject:to:cc;
	bh=Tvv3HYmTfhrufDSl6ueVhvhAsekGmYv7TJjHMq9fspY=;
	b=XI1OInjgObBo1zl0bSAbjJ6goRsgOkQZENPgugkudbnM2cBHtH0RvNaEpwYgzKD4Pp
	XmgcNyhB+S5+PFwT6ws6r6rZPSWUkyexjq77p73Bj6EBHaFDD6rjN6qpWHiGiWhaYohs
	tn4K1oaW2obcGMcVO2nBgImcTLrXQJ09sVDe0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:references:in-reply-to:mime-version
	:thread-index:date:message-id:subject:to:cc;
	bh=Tvv3HYmTfhrufDSl6ueVhvhAsekGmYv7TJjHMq9fspY=;
	b=qw241bMt0xHNtGxFBbNomcbIji1AKOvL5KZinXVjanMwngxtwy+NUjKS6fantPntri
	BoLvxvFFMDHChVNZH3Bl0A4MS8lgKlms0h3v1NirAhvZ80Mm5VJqkbPiW0qtbogSEtJr
	N6r4WFevXU/nqdKAtpjdoA+oAZ2PHhey5KNXDOYfGLD3NDxb226OhEtnIums5Z1YVBml
	NUCegas+OULN0nmr3wdkUU5mMQU/U+80zJ3XoUGioHAA9lPMYyGNWoqOVOvWCY1WRK03
	JBTmaqn6nUWh0gY/VyoELaa/SdBkSYnKrTOR3Vu7ovIH06Vy65zjQI2TjeKAoRUPSEDL
	wXzA==
X-Gm-Message-State: AOAM530qIyRW/Q9J4WbNkCBIuGVCDxLfDv3W5EtF0w452TkUYU/T1rYL
	4NZNKVD68DtGmgTm3j4rgubPCV/WjSAqYrrxs4MLaaM/t0ksALB2LmMXLEL8WsGExR0t6dK/c5x
	bljbhxi8Ar1VvIam6A2Q=
X-Google-Smtp-Source: ABdhPJzLEJLafErTS/zIi6WuYrH80MxYJ5HgqLhqOpFLWVMpNjQounOfzMGFUtI28NroHB2Kn1r6joN9RuBkpPJrnEo=
X-Received: by 2002:aca:c349:: with SMTP id t70mr17927563oif.87.1617600654343; 
	Sun, 04 Apr 2021 22:30:54 -0700 (PDT)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>	
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>	
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>	
	<7b5ce0567f03bc3d394481642a97a3d499fe3976.camel@erwinvanlonden.net>
	<93f19c1bb5731394225f71936e1cc44509020152.camel@suse.com>
	<d6c3e5c7682d209263de5ca3612228b9468051a2.camel@erwinvanlonden.net>
In-Reply-To: <d6c3e5c7682d209263de5ca3612228b9468051a2.camel@erwinvanlonden.net>
MIME-Version: 1.0
Thread-Index: AQLUV1ngcOMspX6X38mhg1atAytU1gI8PjAEAcHXiSEBxD6w4wJahNoMAZbORjYBrNJNuwIqYHd6ApJrS/QAqQ3gzagk1OBA
Date: Mon, 5 Apr 2021 11:00:51 +0530
Message-ID: <47a0bf4bb540f052625afeb78ce6e592@mail.gmail.com>
To: Erwin van Londen <erwin@erwinvanlonden.net>,
	Martin Wilck <martin.wilck@suse.com>, bblock@linux.ibm.com, hare@suse.de
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=XI1OInjg;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.167.177 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
X-Mimecast-Spam-Score: 0
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
X-Mailman-Approved-At: Tue, 06 Apr 2021 07:35:52 -0400
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
Content-Type: multipart/mixed; boundary="===============1431118644906181029=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============1431118644906181029==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-256; boundary="0000000000006d05ce05bf330047"

--0000000000006d05ce05bf330047
Content-Type: multipart/related; boundary="000000000000645f6105bf330041"

--000000000000645f6105bf330041
Content-Type: multipart/alternative; boundary="000000000000645f6005bf330040"

--000000000000645f6005bf330040
Content-Type: text/plain; charset="UTF-8"

Hi Erwin,

Below are my replies.



On Thu, 2021-04-01 at 10:16 +0000, Martin Wilck wrote:

On Thu, 2021-04-01 at 12:48 +1000, Erwin van Londen wrote:



Benjamin has added a marginal_path group(multipath marginal

pathgroups) in

the dm-multipath.

https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-1-git

-send-email-bmarzins@redhat.com/



One of the intention of the Benjamin's patch (support for maginal

path) is

to support for the FPIN events we receive from fabric.

On receiving the fpin-li our intention was to  place all the paths

that

are affected into the marginal path group.

I think this should all be done in kernel space as we're talking sub-

millisecond timings here when it comes to fpins and the reaction time

expected. I may be wrong but I'll leave that up to you.



Sub-ms latency is impossible with this setup  (kernel -> broadcom FC

daemon -> multipathd -> kernel). It's only suitable for "fatal" FPINs

that would suggest taking a path offline on the time scale of minutes.

I suppose that would work well for LN FPINs, but not for the other

types.

>>I agree. I was hoping the FC drivers would be able to play a role in this
and provide a direct hook into the FPIN notifications in such a way that
userspace daemons would not be required and multipath would >>be able to
play a direct role here.

>>When it comes to latency in a san we're indeed talking about sub-ms when
it comes to impacting other parts of the fabrics having an immediate effect
on multiple initiators and targets due to the shared nature >>of the beast.

>>





On receiving the congestion notifications our intention is to

slowdown the

work load gradually from the host until it stops receiving the

congestion

notifications.

We need to validate the same how we can achieve the same of

decreasing the

workloads with the help of dm-multipath.

Would it be possible to piggyback on the service time path selector

in this when it pertains latency?



Not on service-time itself, but someone could write a new path selector

algorithm. IMO we'd still have the problem that this would be seen as a

layering violation. In the long run dm-mpath may need to add transport-

specific callbacks. But for a proof-of-concept, a selector algorithm

with layering violations would be ok, I believe.

>>Is that an offer of volunteering?? [image: :-)]

[Muneendra]To address all the issues we are planning to come up with new
dm-path selector algorithm which should address

the above concerns where FC drivers will do a direct hook into the FPIN
notifications in such a way that userspace daemons would not be required
and multipath would be able to play a

direct role here.

Will come up with more details regarding the new dm-path selector algorithm
for FPIN notifications.



Regards,

Muneendra.

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000645f6005bf330040
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dutf-8"><meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered m=
edium)"><style><!--
/* Font Definitions */
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09margin-bottom:.0001pt;
=09font-size:12.0pt;
=09font-family:"Times New Roman",serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:purple;
=09text-decoration:underline;}
span.EmailStyle17
=09{mso-style-type:personal-reply;
=09font-family:"Calibri",sans-serif;
=09color:#1F497D;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-size:10.0pt;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style></head><body lang=3D"EN-US" link=3D"blue" vlink=3D"purple"><div =
class=3D"WordSection1"><p class=3D"MsoNormal"><span style=3D"font-size:11.0=
pt;font-family:&quot;Calibri&quot;,sans-serif;color:#1f497d">Hi Erwin,</spa=
n></p><p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&q=
uot;Calibri&quot;,sans-serif;color:#1f497d">Below are my replies.</span></p=
><p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;C=
alibri&quot;,sans-serif;color:#1f497d">=C2=A0</span></p><div><p class=3D"Ms=
oNormal">On Thu, 2021-04-01 at 10:16 +0000, Martin Wilck wrote:</p></div><b=
lockquote style=3D"border:none;border-left:solid #729fcf 1.5pt;padding:0in =
0in 0in 6.0pt;margin-left:4.8pt;margin-right:0in"><div><p class=3D"MsoNorma=
l">On Thu, 2021-04-01 at 12:48 +1000, Erwin van Londen wrote:</p></div><blo=
ckquote style=3D"border:none;border-left:solid #729fcf 1.5pt;padding:0in 0i=
n 0in 6.0pt;margin-left:4.8pt;margin-right:0in"><blockquote style=3D"border=
:none;border-left:solid #729fcf 1.5pt;padding:0in 0in 0in 6.0pt;margin-left=
:4.8pt;margin-right:0in"><div><p class=3D"MsoNormal">=C2=A0</p></div><div><=
p class=3D"MsoNormal">Benjamin has added a marginal_path group(multipath ma=
rginal</p></div><div><p class=3D"MsoNormal">pathgroups) in</p></div><div><p=
 class=3D"MsoNormal">the dm-multipath.</p></div><div><p class=3D"MsoNormal"=
><a href=3D"https://patchwork.kernel.org/project/dm-devel/cover/1564763622-=
31752-1-git">https://patchwork.kernel.org/project/dm-devel/cover/1564763622=
-31752-1-git</a></p></div><div><p class=3D"MsoNormal"><a href=3D"mailto:-se=
nd-email-bmarzins@redhat.com">-send-email-bmarzins@redhat.com</a>/</p></div=
><div><p class=3D"MsoNormal">=C2=A0</p></div><div><p class=3D"MsoNormal">On=
e of the intention of the Benjamin&#39;s patch (support for maginal</p></di=
v><div><p class=3D"MsoNormal">path) is</p></div><div><p class=3D"MsoNormal"=
>to support for the FPIN events we receive from fabric.</p></div><div><p cl=
ass=3D"MsoNormal">On receiving the fpin-li our intention was to=C2=A0 place=
 all the paths</p></div><div><p class=3D"MsoNormal">that</p></div><div><p c=
lass=3D"MsoNormal">are affected into the marginal path group.</p></div></bl=
ockquote><div><p class=3D"MsoNormal">I think this should all be done in ker=
nel space as we&#39;re talking sub-</p></div><div><p class=3D"MsoNormal">mi=
llisecond timings here when it comes to fpins and the reaction time</p></di=
v><div><p class=3D"MsoNormal">expected. I may be wrong but I&#39;ll leave t=
hat up to you.</p></div></blockquote><div><p class=3D"MsoNormal">=C2=A0</p>=
</div><div><p class=3D"MsoNormal">Sub-ms latency is impossible with this se=
tup=C2=A0 (kernel -&gt; broadcom FC</p></div><div><p class=3D"MsoNormal">da=
emon -&gt; multipathd -&gt; kernel). It&#39;s only suitable for &quot;fatal=
&quot; FPINs</p></div><div><p class=3D"MsoNormal">that would suggest taking=
 a path offline on the time scale of minutes.</p></div><div><p class=3D"Mso=
Normal">I suppose that would work well for LN FPINs, but not for the other<=
/p></div><div><p class=3D"MsoNormal">types.</p></div></blockquote><div><p c=
lass=3D"MsoNormal"><span style=3D"color:#1f497d">&gt;&gt;</span>I agree. I =
was hoping the FC drivers would be able to play a role in this and provide =
a direct hook into the FPIN notifications in such a way that userspace daem=
ons would not be required and multipath would <span style=3D"color:#1f497d"=
>&gt;&gt;</span>be able to play a direct role here.</p></div><div><p class=
=3D"MsoNormal"><span style=3D"color:#1f497d">&gt;&gt;</span>When it comes t=
o latency in a san we&#39;re indeed talking about sub-ms when it comes to i=
mpacting other parts of the fabrics having an immediate effect on multiple =
initiators and targets due to the shared nature <span style=3D"color:#1f497=
d">&gt;&gt;</span>of the beast.<span style=3D"color:#1f497d"></span></p><p =
class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Calib=
ri&quot;,sans-serif;color:#1f497d">&gt;&gt;=C2=A0</span></p></div><blockquo=
te style=3D"border:none;border-left:solid #729fcf 1.5pt;padding:0in 0in 0in=
 6.0pt;margin-left:4.8pt;margin-right:0in"><div><p class=3D"MsoNormal">=C2=
=A0</p></div><blockquote style=3D"border:none;border-left:solid #729fcf 1.5=
pt;padding:0in 0in 0in 6.0pt;margin-left:4.8pt;margin-right:0in"><blockquot=
e style=3D"border:none;border-left:solid #729fcf 1.5pt;padding:0in 0in 0in =
6.0pt;margin-left:4.8pt;margin-right:0in"><div><p class=3D"MsoNormal">=C2=
=A0</p></div><div><p class=3D"MsoNormal">On receiving the congestion notifi=
cations our intention is to</p></div><div><p class=3D"MsoNormal">slowdown t=
he</p></div><div><p class=3D"MsoNormal">work load gradually from the host u=
ntil it stops receiving the</p></div><div><p class=3D"MsoNormal">congestion=
</p></div><div><p class=3D"MsoNormal">notifications.</p></div><div><p class=
=3D"MsoNormal">We need to validate the same how we can achieve the same of<=
/p></div><div><p class=3D"MsoNormal">decreasing the</p></div><div><p class=
=3D"MsoNormal">workloads with the help of dm-multipath.</p></div></blockquo=
te><div><p class=3D"MsoNormal">Would it be possible to piggyback on the ser=
vice time path selector</p></div><div><p class=3D"MsoNormal">in this when i=
t pertains latency? =C2=A0</p></div></blockquote><div><p class=3D"MsoNormal=
">=C2=A0</p></div><div><p class=3D"MsoNormal">Not on service-time itself, b=
ut someone could write a new path selector</p></div><div><p class=3D"MsoNor=
mal">algorithm. IMO we&#39;d still have the problem that this would be seen=
 as a</p></div><div><p class=3D"MsoNormal">layering violation. In the long =
run dm-mpath may need to add transport-</p></div><div><p class=3D"MsoNormal=
">specific callbacks. But for a proof-of-concept, a selector algorithm</p><=
/div><div><p class=3D"MsoNormal">with layering violations would be ok, I be=
lieve.</p></div></blockquote><div><p class=3D"MsoNormal"><span style=3D"col=
or:#1f497d">&gt;&gt;</span>Is that an offer of volunteering?? <img border=
=3D"0" width=3D"16" height=3D"16" id=3D"_x0000_i1025" src=3D"cid:image001.p=
ng@01D72A0A.4F10A750" alt=3D":-)"></p><p class=3D"MsoNormal"><span style=3D=
"font-size:11.0pt;font-family:&quot;Calibri&quot;,sans-serif;color:#1f497d"=
>[Muneendra]To address all the issues we are planning to come up with new d=
m-path selector algorithm which should address </span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,sans-=
serif;color:#1f497d">the above concerns where FC drivers will do a direct h=
ook into the FPIN notifications in such a way that userspace daemons would =
not be required and multipath would be able to play a </span></p><p class=
=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&qu=
ot;,sans-serif;color:#1f497d">direct role here.</span></p><p class=3D"MsoNo=
rmal"><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,sans-=
serif;color:#1f497d">Will come up with more details regarding the new dm-pa=
th selector algorithm for FPIN notifications.</span></p><p class=3D"MsoNorm=
al">=C2=A0</p><p class=3D"MsoNormal">Regards,</p><p class=3D"MsoNormal">Mun=
eendra.</p><p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-fami=
ly:&quot;Calibri&quot;,sans-serif;color:#1f497d">=C2=A0</span></p></div></d=
iv></body></html>

<br>
<span style=3D"background-color:rgb(255,255,255)"><font size=3D"2">This ele=
ctronic communication and the information and any files transmitted with it=
, or attached to it, are confidential and are intended solely for the use o=
f the individual or entity to whom it is addressed and may contain informat=
ion that is confidential, legally privileged, protected by privacy laws, or=
 otherwise restricted from disclosure to anyone else. If you are not the in=
tended recipient or the person responsible for delivering the e-mail to the=
 intended recipient, you are hereby notified that any use, copying, distrib=
uting, dissemination, forwarding, printing, or copying of this e-mail is st=
rictly prohibited. If you received this e-mail in error, please return the =
e-mail to the sender, delete it from your computer, and destroy any printed=
 copy of it.</font></span>
--000000000000645f6005bf330040--

--000000000000645f6105bf330041
Content-Type: image/png; name="image001.png"
Content-Disposition: inline; filename="image001.png"
Content-Transfer-Encoding: base64
Content-ID: <image001.png@01D72A0A.4F10A750>
X-Attachment-Id: 5f4c81bd76e73921_0.1

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
--000000000000645f6105bf330041--

--0000000000006d05ce05bf330047
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
6dyIRB5g0cWmkcO89O0W56d+wWwa7GeeTIJHMzJ0rco8nzcXkz/oeEmXSjZU3erpKBaLCQBkZud1
iNM/8mFL1vZxCwUACcMw+a8FhrHJq29QwrBHqDJ1ocrJlDaZcn1UDQIDAQABo4IB3TCCAdkwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsG
AQUFBwMEMB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBTMJfPJzmVP
1lwJptwb21ozx4G7wzANBgkqhkiG9w0BAQsFAAOCAQEAmz4/3oyLhfXMYVZWtDEKcP5Bk/6JAhfa
9q4eZDy1W/1FSuRfEWMq7xi9T3DvxUQqJtpJ8bM6SU37fZAvvMdRF23qdKRy6gBZ9NkYOCP7Tr2u
wNYznMfaHEGY/aa65EiywAsbVn1X7vKMKqSj3cmpEUO2I+FcRtPdyicqyU2E3856b5d+fMc01FRg
pQQRz3kWlIpG/CJ2SiOg0gpkZIkUde0r4e6ipDi+xVSoBdOOJzirs8IkwOeJ4w9GPS9uOkB1bRvJ
RU+Nz1h4p9eH2nsPAq7S5l6y/n3+g/olazbUoiEx8GRFqzoHLudsqmnzISDPoe+rczkpYreF/mEU
Y6pL2DGCAm0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDHE+
9dgalq0zfRWBQDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgrx4L1JT9LdGDEqDs
GIk4Gwd3NNuDfffw0aSHwvKk/FQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjEwNDA1MDUzMDU0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBALz6huilWpvPmJyQhvjoaaaIYzMckZuO0CAA
QK6uEyPgJxCre81+YsrhkC6aSUWhvxg/K1dm/IcgwMiL3TgDvyDvCprIoisXDeEm0zhZa74QdoBH
tePQrsVfXqPbSgtYQ6EPW4apC4QSRCUR0XInfPOXgsACMfSzejUQEjcWBwjLAlOqHxC9fUZon6W6
XqMua1arRkVYwIgFMQG4wOF2SmGOo+yFGzRx11wLCxCRjTM+9XDekdOjO7JJ9ZeERiV9nco3ffiX
RKtLSSL6X4LSxnqt4+QoGlsCAFqiTFYmxXvx80uxh0F3zRNdxq/qQFrOfaQ4W7ynU8+LX9EaoEWM
0qY=
--0000000000006d05ce05bf330047--


--===============1431118644906181029==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============1431118644906181029==--

