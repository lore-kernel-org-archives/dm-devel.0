Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438FBC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 06:44:47 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-Uy7xaXT2PkywJBxCsfUwGw-1; Thu, 25 Nov 2021 01:44:42 -0500
X-MC-Unique: Uy7xaXT2PkywJBxCsfUwGw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A0AF1F2E3;
	Thu, 25 Nov 2021 06:44:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F84C5D6CF;
	Thu, 25 Nov 2021 06:44:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A37F4BB7C;
	Thu, 25 Nov 2021 06:44:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AP1JPVt007769 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 20:19:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E5DCA51DD; Thu, 25 Nov 2021 01:19:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E01BD51DC
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 01:19:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F01D101AA63
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 01:19:22 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
	[209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-285-BQ3Gky5-MD66dUuLY_bUtQ-1; Wed, 24 Nov 2021 20:19:18 -0500
X-MC-Unique: BQ3Gky5-MD66dUuLY_bUtQ-1
Received: by mail-qv1-f47.google.com with SMTP id kl8so3043260qvb.3
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 17:19:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=sLuZyfaT/4AZ6gqPLiY4IvYhA8fmmzWi6fo2HLuudC8=;
	b=y+urZmQ8bxtOpbUJh9wPBsLLHe+njX3X2W0C2JqvucVIF16yPglNKWT0DXXJjdRlEX
	x0NVFqJgza8vxQ0AeM8W98hOjkkOwt/eMRrzbD5NducGTvUlhqGtV/C+XO0MiUXgojfE
	F8ZTJ04zTJrR4NT2PPxKAREtbzDgRMgPr9LYHrNY9E/uGsqKkci9YKj6Vc99QG9NsQr5
	foZQK931e+pBngf/Dumlg6Vf62Bpk460ruTQpEWD/85f+rxTnNZ3Y4O74GwhtQPWuHOJ
	LJG79deA6npDHI/BZyVvuY+YgVcjBo99iF5HrmADf6C78A/gzPXRGw51wSZ65Rt3Amt/
	2qTg==
X-Gm-Message-State: AOAM5315iJaBNKmZkrkXzkEykNgCItFbuIoRAYZ9Mg2vUbFpwtNClaMU
	s4XXaJDaMvrzCwPObSTzmWwvNpYRM8vdSFLq5LLutg==
X-Google-Smtp-Source: ABdhPJx7IN7634HCA9iU9yV+Rx6pHX9E6MZsOutv/zzO/syVCUMoB5cofd4wjI1KGUhc5itQE4onAzQpiD7x7dQWEeg=
X-Received: by 2002:a05:6214:301b:: with SMTP id
	ke27mr1081838qvb.68.1637803157652; 
	Wed, 24 Nov 2021 17:19:17 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDJX8tVtGbuxo_Xqo=7GNd66W_FoVk=i6Kssp-6zP5cmmA@mail.gmail.com>
	<20211123231518.GA63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CA+FmFJBs9ocSbXHxdEncdGRRByamziXc+h9DMNH=r6qWPk3nzQ@mail.gmail.com>
	<alpine.LRH.2.02.2111240819520.1631@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvD+_mfAJ6SAmkTAve=i8w_xpvPPg1VyC7a3+KO6YAnGRiw@mail.gmail.com>
In-Reply-To: <CABSDvD+_mfAJ6SAmkTAve=i8w_xpvPPg1VyC7a3+KO6YAnGRiw@mail.gmail.com>
From: Kelvin Zhang <zhangkelvin@google.com>
Date: Wed, 24 Nov 2021 17:19:06 -0800
Message-ID: <CAOSmRzirCpAyhdtdyvVB1u78ibHvL7UKEuLSTuggq9E1sXQNng@mail.gmail.com>
To: Akilesh Kailash <akailash@google.com>
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
X-Mailman-Approved-At: Thu, 25 Nov 2021 01:44:00 -0500
Cc: Mike Snitzer <msnitzer@redhat.com>, Tianjie Xu <xunchang@google.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, David Anderson <dvander@google.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2495492856874463840=="

--===============2495492856874463840==
Content-Type: multipart/alternative; boundary="0000000000006cd86a05d192c375"

--0000000000006cd86a05d192c375
Content-Type: text/plain; charset="UTF-8"

There are two different formats in Android's OTA infrastructure:

1. The OTA format. This is what we generate from two android images, and
this is what Android devices download when installing an update.
    This format is designed to be as small as possible. Therefore it is not
suitable to serve as an on disk COW format, as disk read performance would
be horrible.
2. The COW format. After the device downloads the OTA package, it will
translate OTA format into COW format. The COW format has larger disk space
footprint,
    but much better disk read performance.

Unfortunately you can't get example COW images easily. As we don't [yet]
have tools to create them on host. The only way to get a COW image is to
apply OTA on device and read data from the android device.

Below are some instructions on how to produce android OTA packages(format
#1)

Android's OTA generator is open source at
https://cs.android.com/android/platform/superproject/+/master:system/update_engine/payload_generator/generate_delta_main.cc?q=generate_delta_main

We have precompiled OTA generator binaries available at
https://ci.android.com/ . To download:
1. Look for column "aosp_cf_x86_64_phone"
2. Click on any green squares
3. Click on "artifacts" tab e.g.
https://ci.android.com/builds/submitted/7945102/aosp_cf_x86_64_phone-userdebug/latest
4. Look for otatools.zip , download it

The same https://ci.android.com/ website also has android images available
for download. To fetch an android image:

1. Look for column "aosp_cf_x86_64_phone"
2. Click on any green squares
3. Click on "artifacts" tab
4. Look for "target_files" e.g.
aosp_cf_x86_64_phone-target_files-7945102.zip . Note, this name will be
different for each build.

To generate an incremental OTA package:

1. Extract otatools.zip, add bin/ subdir to your PATH, add lib/lib64 subdir
to LD_LIBRARY_PATH
2. ota_from_target_files -v -i source_build_target_files.zip
target_build_target_files.zip ota.zip


> How do you search for blocks that are similar, so that the "XOR" method is
> benefical for them?

In short, we use BSDIFF. The core algorithm is explained in
https://www.daemonology.net/papers/bsdiff.pdf . It uses suffix array + some
heuristics to identify similar blocks.

> How do you make sure that you don't perform the "XOR"
> operation twice, if there's system crash when performing it?

That's handled by snapuserd. Akilesh can show you all the details. But
basically:

1. We compute an order which COW operation should be applied, and this
order is guaranteed to be conflict free(an operation earlier in the order
will never overwrite blocks needed by a later operation).
2. The snapuserd has to write checkpoint data to disk so it can properly
resume.

On Wed, Nov 24, 2021 at 3:44 PM Akilesh Kailash <akailash@google.com> wrote:

> On Wed, Nov 24, 2021 at 8:10 AM Mikulas Patocka <mpatocka@redhat.com>
> wrote:
> >
> >
> >
> > On Tue, 23 Nov 2021, David Anderson wrote:
> >
> > > In our ecosystem, the OTA generation and on-device application process
> > > has evolved continually, in every release, for over 10 years now. So
> > > we think it's unlikely that we'll stop making improvements to it. Our
> > > current roadmap has other changes in the pipeline too. It's not just
> > > us trying to eek out diminishing returns. Other parts of the system
> > > change around us, and the OTA system needs to adapt.
> > >
> > > The performance penalty is something we've been working on, and have
> > > improved a lot since our first iteration. We're currently
> > > experimenting with io_uring as well.
> > >
> > > Best,
> > >
> > > -David
> >
> > Hi
> >
> > I understand that an update format developed over 10 years will have
> > better compression ratio than my format developed in 2 months.
> >
> > I'd be interested in extending dm-update to handle your your update
> format
> > and possibly add some abstraction, so that it can work with multiple
> > formats.
> >
> > You say that you have "COPY" and "XOR" operations.
> >
> > How do you search for blocks that are similar, so that the "XOR" method
> is
> > benefical for them? How do you make sure that you don't perform the "XOR"
> > operation twice, if there's system crash when performing it?
>
> CC: Kelvin and Tianjie who are familiar with the  OTA generation.
>
> > Could it be possible for you to give us two Android images and a program
> > that calculates difference between them? So that we could see how well we
> > are performing compared to the existing solution.
> >
> > Mikulas
> >
>


-- 
Sincerely,

Kelvin Zhang

--0000000000006cd86a05d192c375
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>There are two different formats in Android&#39;s OTA =
infrastructure:</div><div><br></div><div>1. The OTA format. This is what we=
 generate from two android images, and this is what Android devices downloa=
d when installing an update.</div><div>=C2=A0 =C2=A0 This format is designe=
d to be as small as possible. Therefore it is not suitable to serve as an o=
n disk COW format, as disk read performance would be horrible.</div><div>2.=
 The COW format. After the device downloads the OTA package, it will transl=
ate OTA format into COW format. The COW format has larger disk space footpr=
int,</div><div>=C2=A0 =C2=A0 but much better disk read performance.</div><d=
iv><br></div><div>Unfortunately you can&#39;t get example COW images easily=
. As we don&#39;t [yet] have tools to create them on host. The only way to =
get a COW image is to apply OTA on device=C2=A0and read data from the andro=
id device.</div><div><br></div><div>Below are some instructions on how to p=
roduce android OTA packages(format #1)</div><div><br></div>Android&#39;s OT=
A generator is open source at=C2=A0<a href=3D"https://cs.android.com/androi=
d/platform/superproject/+/master:system/update_engine/payload_generator/gen=
erate_delta_main.cc?q=3Dgenerate_delta_main">https://cs.android.com/android=
/platform/superproject/+/master:system/update_engine/payload_generator/gene=
rate_delta_main.cc?q=3Dgenerate_delta_main</a><div><br></div><div>We have p=
recompiled OTA generator binaries available at=C2=A0<a href=3D"https://ci.a=
ndroid.com/">https://ci.android.com/</a>=C2=A0. To download:</div><div>1. L=
ook for column &quot;aosp_cf_x86_64_phone&quot;</div><div>2. Click on any g=
reen squares</div><div>3. Click on &quot;artifacts&quot; tab e.g.=C2=A0<a h=
ref=3D"https://ci.android.com/builds/submitted/7945102/aosp_cf_x86_64_phone=
-userdebug/latest">https://ci.android.com/builds/submitted/7945102/aosp_cf_=
x86_64_phone-userdebug/latest</a></div><div>4. Look for otatools.zip , down=
load it</div><div><br></div><div>The same=C2=A0<a href=3D"https://ci.androi=
d.com/">https://ci.android.com/</a>=C2=A0website also has android images av=
ailable for download. To fetch an android image:</div><div><br></div><div>1=
. Look for column &quot;aosp_cf_x86_64_phone&quot;</div><div>2. Click on an=
y green squares</div><div>3. Click on &quot;artifacts&quot; tab</div><div>4=
. Look for &quot;target_files&quot; e.g. aosp_cf_x86_64_phone-target_files-=
7945102.zip . Note, this name will be different for each build.</div><div><=
br></div><div>To generate an incremental OTA package:</div><div><br></div><=
div>1. Extract otatools.zip, add bin/ subdir to your PATH, add lib/lib64 su=
bdir to LD_LIBRARY_PATH</div><div>2. ota_from_target_files -v -i source_bui=
ld_target_files.zip target_build_target_files.zip ota.zip<br><div><br></div=
></div><div><br></div><div>&gt; How do you search for blocks that are simil=
ar, so that the &quot;XOR&quot; method is<br>&gt; benefical for them? <br><=
/div><div><br></div><div>In short, we use BSDIFF. The core algorithm is exp=
lained in <a href=3D"https://www.daemonology.net/papers/bsdiff.pdf">https:/=
/www.daemonology.net/papers/bsdiff.pdf</a> . It uses suffix array=C2=A0+ so=
me heuristics to identify similar blocks.</div><div><br></div><div>&gt; How=
 do you make sure that you don&#39;t perform the &quot;XOR&quot;</div>&gt; =
operation twice, if there&#39;s system crash when performing it?<div><br></=
div><div>That&#39;s handled by snapuserd. Akilesh can show you all the deta=
ils. But basically:</div><div><br></div><div>1. We compute an order which C=
OW operation should be applied, and this order is guaranteed to be conflict=
 free(an operation earlier in the order will never overwrite blocks needed =
by a later operation).</div><div>2. The snapuserd has to write checkpoint d=
ata to disk so it can properly resume.</div></div><br><div class=3D"gmail_q=
uote"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Nov 24, 2021 at 3:44 PM=
 Akilesh Kailash &lt;<a href=3D"mailto:akailash@google.com">akailash@google=
.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">On Wed, Nov 24, 2021 at 8:10 AM Mikulas Patocka &lt;<a href=3D"mailto:m=
patocka@redhat.com" target=3D"_blank">mpatocka@redhat.com</a>&gt; wrote:<br=
>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Tue, 23 Nov 2021, David Anderson wrote:<br>
&gt;<br>
&gt; &gt; In our ecosystem, the OTA generation and on-device application pr=
ocess<br>
&gt; &gt; has evolved continually, in every release, for over 10 years now.=
 So<br>
&gt; &gt; we think it&#39;s unlikely that we&#39;ll stop making improvement=
s to it. Our<br>
&gt; &gt; current roadmap has other changes in the pipeline too. It&#39;s n=
ot just<br>
&gt; &gt; us trying to eek out diminishing returns. Other parts of the syst=
em<br>
&gt; &gt; change around us, and the OTA system needs to adapt.<br>
&gt; &gt;<br>
&gt; &gt; The performance penalty is something we&#39;ve been working on, a=
nd have<br>
&gt; &gt; improved a lot since our first iteration. We&#39;re currently<br>
&gt; &gt; experimenting with io_uring as well.<br>
&gt; &gt;<br>
&gt; &gt; Best,<br>
&gt; &gt;<br>
&gt; &gt; -David<br>
&gt;<br>
&gt; Hi<br>
&gt;<br>
&gt; I understand that an update format developed over 10 years will have<b=
r>
&gt; better compression ratio than my format developed in 2 months.<br>
&gt;<br>
&gt; I&#39;d be interested in extending dm-update to handle your your updat=
e format<br>
&gt; and possibly add some abstraction, so that it can work with multiple<b=
r>
&gt; formats.<br>
&gt;<br>
&gt; You say that you have &quot;COPY&quot; and &quot;XOR&quot; operations.=
<br>
&gt;<br>
&gt; How do you search for blocks that are similar, so that the &quot;XOR&q=
uot; method is<br>
&gt; benefical for them? How do you make sure that you don&#39;t perform th=
e &quot;XOR&quot;<br>
&gt; operation twice, if there&#39;s system crash when performing it?<br>
<br>
CC: Kelvin and Tianjie who are familiar with the=C2=A0 OTA generation.<br>
<br>
&gt; Could it be possible for you to give us two Android images and a progr=
am<br>
&gt; that calculates difference between them? So that we could see how well=
 we<br>
&gt; are performing compared to the existing solution.<br>
&gt;<br>
&gt; Mikulas<br>
&gt;<br>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
 class=3D"gmail_signature"><div dir=3D"ltr">Sincerely,<div><br></div><div>K=
elvin Zhang</div></div></div>

--0000000000006cd86a05d192c375--

--===============2495492856874463840==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2495492856874463840==--

