Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E932C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 12 Dec 2022 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670857058;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Xbc+b9PMOUi47ZvQv0CVhIiM1WcOb80dohTwrghdvHU=;
	b=YlKoJPKkDmhOV1IsX6Z2GUkANy8wMoBGxlIZftsOwFvQAruWd5pgX6omjfkomHBof77fBg
	r3QKlM0KXMa4yP+RFAH5m+bU3lxHW2/iG5qU6/ouT5yy+92LfKlKrmz42s7PKQPBr7+JEM
	tbhZ2x1IzJrKtUo86pjqFzDyU4QSBfM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-d-Aq225SMzqcUjS3i7a7zw-1; Mon, 12 Dec 2022 09:57:35 -0500
X-MC-Unique: d-Aq225SMzqcUjS3i7a7zw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C59F7101AA47;
	Mon, 12 Dec 2022 14:57:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1124C492C14;
	Mon, 12 Dec 2022 14:57:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDE4F1946588;
	Mon, 12 Dec 2022 14:57:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0D55F1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Dec 2022 14:57:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC6EE2026D68; Mon, 12 Dec 2022 14:57:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D51172026D4B
 for <dm-devel@redhat.com>; Mon, 12 Dec 2022 14:57:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B68AA858F13
 for <dm-devel@redhat.com>; Mon, 12 Dec 2022 14:57:18 +0000 (UTC)
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-46-JqA-EVr6MzK3QjqX3C5Gaw-1; Mon, 12 Dec 2022 09:57:16 -0500
X-MC-Unique: JqA-EVr6MzK3QjqX3C5Gaw-1
Received: by mail-vs1-f71.google.com with SMTP id
 190-20020a6719c7000000b003aa14ac75f5so3031042vsz.1
 for <dm-devel@redhat.com>; Mon, 12 Dec 2022 06:57:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=19pHUKKxvn4JQ7oedP68csdOCv4Yg5h/g0L1lI2Dqro=;
 b=QAhYLpdummdxBIMqS4eRno6eJ+72GP8pRWbn3Ya60DEC6XNcLk/oZo2yxGLQFrdWCf
 inkRLCpyYXf9cvDo8JRc1GoVk5rKOPVFU7f0Q93D5WUodOIEiZjIZipOrbQN1oDc7YF8
 wifQ9WKcztchF/QjKQqfarAmTcVNMoEeCCOxOdyI+i7Noa/xsBcDoHH3WDw8vsIHxqsL
 kLT8PBUz2AoXL/r700NEc0+PSWKTxfuSMc3exBGp43maoLqfHI5NL1HYYqPjHt/fiR0A
 RYePCJUqzRHpIrXEM6N/WRzIf/+VFGOOdPQIyfP3XGW5mw1bz3vYtntgFE7LZ7OyFyKb
 QzTA==
X-Gm-Message-State: ANoB5pna+JlSsyZN5rExPniOVDmK2pK8VXvz24USYKkGveYbJco5su4X
 0u9zTGpj6QfP17ddeS2P145a4812tErewm2jGGH5K9dvCUkYr9BZiunEhWtJLhRsLYPoqA5P0dI
 kN1bu+KWVoozG0fOLpx2t14g6Rx/D85w=
X-Received: by 2002:ab0:59ae:0:b0:419:c3a3:9d0 with SMTP id
 g43-20020ab059ae000000b00419c3a309d0mr10795116uad.98.1670857036289; 
 Mon, 12 Dec 2022 06:57:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf53zXjGDxnt5QkyVYwRD6wxdbpbZmy5vm+6Zvc8TRW/2GWgw6g9lWizASJfPx1Mtik2A5gWL7+MgjtcGrfyqoU=
X-Received: by 2002:ab0:59ae:0:b0:419:c3a3:9d0 with SMTP id
 g43-20020ab059ae000000b00419c3a309d0mr10795114uad.98.1670857035922; Mon, 12
 Dec 2022 06:57:15 -0800 (PST)
MIME-Version: 1.0
From: Joe Thornber <thornber@redhat.com>
Date: Mon, 12 Dec 2022 14:57:05 +0000
Message-ID: <CAJ0trDZW8FRFuuonKrgSMp7i7m0sLdPGyFHd2ap0Gw8iadrA-A@mail.gmail.com>
To: "development, device-mapper" <dm-devel@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [announce] thin-provisioning-tools v1.0.0-rc1
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8116299188923323723=="

--===============8116299188923323723==
Content-Type: multipart/alternative; boundary="00000000000018db1d05efa2b83e"

--00000000000018db1d05efa2b83e
Content-Type: text/plain; charset="UTF-8"

We're pleased to announce the first release candidate of v1.0.0 of the
thin-provisioning-tools (which also contains tools for dm-cache and
dm-era).

Please try it out on your test systems and give us feedback.  In
particular regarding documentation, build and install process.

    https://github.com/jthornber/thin-provisioning-tools


# Rust

This is a complete rewrite of the tools in the Rust language.  This switch
was made for three primary reasons:

- Memory safety.
- The type system makes it easier to reason about multithreaded code and we
need
  to use multiple threads to boost performance.
- Rust is a more expressive language than C++ (eg, proper algebraic data
types).

# IO engines

The old C++ tools used libaio for all IO.  The Rust version by default
uses traditional synchronous IO.  This sounds like a step backwards,
but the use of multiple threads and IO scheduling means there's a big
leap in performance.

In addition there's a compile time option to include asynchronous
IO support via io_uring.  This engine is slightly faster, but not all
distributions support io_uring at the moment.  In addition we've seen
recent (summer 2022) kernel versions that lose io notifications, causing
us to feel that io_uring itself isn't quite ready.

# Performance

We've focussed on thin_check and cache_check performance most of all
since these regularly get run on system startup.  But all tools should
have made significant performance improvements.

Over the years we've collected some gnarly dm-thin metadata examples from
users, eg, using hundreds of thousands of snapshots, and completely
filling the maximum metadata size of 16G.  These are great for
benchmarking, for example running thin_check on my system with one of these
files:

    thin_check (v0.9):                  6m
    thin_check (v1.0, sync engine):     28s  (12.9 times faster)
    thin_check (v1.0, io_uring engine): 23s  (15.6 times faster)

# thin_dump/restore retains snapshot sharing

Another issue with previous versions of the tools is dumping and restoring
thin metadata would have the effect of losing sharing of the metadata
btrees for snapshots.  Meaning restored metadata often took up more space,
and
in some cases would exceed the 16G metadata limit.  This is no longer the
case.

[note: _data_ sharing was always maintained, this is purely about metadata
space usage]

# thin_metadata_pack/unpack

These are a couple of new tools that are used for support.  They compress
thin metadata, typically to a tenth of the size (much better than you'd
get with generic compressors).  This makes it easier to pass damaged
metadata around for inspection.

# blk-archive

The blk-archive tools were initially part of this thin-provisioning-tools
package.  But have now been split off to their own project:

    https://github.com/jthornber/blk-archive

They allow efficient archiving of thin devices (data deduplication
and compression).  Which will be of interest to those of you who are
holding large numbers of snapshots in thin pools as a poor man's backup.

In particular:

    - Thin snapshots can be used to archive live data.
    - it avoids reading unprovisioned areas of thin devices.
    - it can calculate deltas between thin devices to minimise
      how much data is read and deduped (incremental backups).
    - restoring to a thin device tries to maximise data sharing
      within the thin pool (a big win if you're restoring snapshots).

--00000000000018db1d05efa2b83e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">We&#39;re pleased to announce the first release candidate =
of v1.0.0 of the<br>thin-provisioning-tools (which also contains tools for =
dm-cache and<br>dm-era).<br><br>Please try it out on your test systems and =
give us feedback.=C2=A0 In<br>particular regarding documentation, build and=
 install process.<br><br>=C2=A0 =C2=A0 <a href=3D"https://github.com/jthorn=
ber/thin-provisioning-tools">https://github.com/jthornber/thin-provisioning=
-tools</a><br><br><br># Rust<br><br>This is a complete rewrite of the tools=
 in the Rust language.=C2=A0 This switch<br>was made for three primary reas=
ons:<br><br>- Memory safety.<br>- The type system makes it easier to reason=
 about multithreaded code and we need<br>=C2=A0 to use multiple threads to =
boost performance.<br>- Rust is a more expressive language than C++ (eg, pr=
oper algebraic data types).<br><br># IO engines<br><br>The old C++ tools us=
ed libaio for all IO.=C2=A0 The Rust version by default<br>uses traditional=
 synchronous IO.=C2=A0 This sounds like a step backwards,<br>but the use of=
 multiple threads and IO scheduling means there&#39;s a big<br>leap in perf=
ormance.<br><br>In addition there&#39;s a compile time option to include as=
ynchronous<br>IO support via io_uring.=C2=A0 This engine is slightly faster=
, but not all<br>distributions support io_uring at the moment.=C2=A0 In add=
ition we&#39;ve seen<br>recent (summer 2022) kernel versions that lose io n=
otifications, causing<br>us to feel that io_uring itself isn&#39;t quite re=
ady.<br><div><br></div><div># Performance<br><br>We&#39;ve focussed on thin=
_check and cache_check performance most of all<br>since these regularly get=
 run on system startup.=C2=A0 But all tools should<br>have made significant=
 performance improvements.<br><br>Over the years we&#39;ve collected some g=
narly dm-thin metadata examples from<br>users, eg, using hundreds of thousa=
nds of snapshots, and completely<br>filling the maximum metadata size of 16=
G.=C2=A0 These are great for<br>benchmarking, for example running thin_chec=
k on my system with one of these files:<br><br>=C2=A0 =C2=A0 thin_check (v0=
.9): =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A06m<br>=
=C2=A0 =C2=A0 thin_check (v1.0, sync engine): =C2=A0 =C2=A0 28s =C2=A0(12.9=
 times faster)<br>=C2=A0 =C2=A0 thin_check (v1.0, io_uring engine): 23s =C2=
=A0(15.6 times faster)<br><br># thin_dump/restore retains snapshot sharing =
<br><br>Another issue with previous versions of the tools is dumping and re=
storing<br>thin metadata would have the effect of losing sharing of the met=
adata<br>btrees for snapshots.=C2=A0 Meaning restored metadata often took u=
p more space, and<br>in some cases would exceed the 16G metadata limit.=C2=
=A0 This is no longer the case.<br><br>[note: _data_ sharing was always mai=
ntained, this is purely about metadata space usage]<br><br># thin_metadata_=
pack/unpack<br><br>These are a couple of new tools that are used for suppor=
t.=C2=A0 They compress<br>thin metadata, typically to a tenth of the size (=
much better than you&#39;d<br>get with generic compressors).=C2=A0 This mak=
es it easier to pass damaged<br>metadata around for inspection.<br></div><d=
iv><br></div><div># blk-archive<br><br>The blk-archive tools were initially=
 part of this thin-provisioning-tools<br>package.=C2=A0 But have now been s=
plit off to their own project:<br><br>=C2=A0 =C2=A0 <a href=3D"https://gith=
ub.com/jthornber/blk-archive">https://github.com/jthornber/blk-archive</a><=
br><br>They allow efficient archiving of thin devices (data deduplication<b=
r>and compression).=C2=A0 Which will be of interest to those of you who are=
<br>holding large numbers of snapshots in thin pools as a poor man&#39;s ba=
ckup.<br><br>In particular:<br><br>=C2=A0 =C2=A0 - Thin snapshots can be us=
ed to archive live data.<br>=C2=A0 =C2=A0 - it avoids reading unprovisioned=
 areas of thin devices.<br>=C2=A0 =C2=A0 - it can calculate deltas between =
thin devices to minimise<br>=C2=A0 =C2=A0 =C2=A0 how much data is read and =
deduped (incremental backups).<br>=C2=A0 =C2=A0 - restoring to a thin devic=
e tries to maximise data sharing<br>=C2=A0 =C2=A0 =C2=A0 within the thin po=
ol (a big win if you&#39;re restoring snapshots).<br></div></div>

--00000000000018db1d05efa2b83e--

--===============8116299188923323723==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8116299188923323723==--

