Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2153AC678D4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 08:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677747227;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=1ExOkZrucoCo0ftNUSYprww6AjEt/wYPihxE1Nl5HWQ=;
	b=PGOK9PeISjBYbNJK7/ohULMwIdCICRyFbSPdliREK7t2wAZpdrZkqyxsPy90VUGBythQbK
	iXQiyut3MJovYt3wD22J2S+Mj+rj5tA13fCue0NvNm6YsLLYdb+nT/Q3E7XIQc1rch52s4
	IUoRh6qD9vb4Rgvg51/uC73OtEUtyKw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-Jv0V1HaXOO2xglKj6Laidw-1; Thu, 02 Mar 2023 03:53:46 -0500
X-MC-Unique: Jv0V1HaXOO2xglKj6Laidw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBEBF3811F22;
	Thu,  2 Mar 2023 08:53:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 456C42166B26;
	Thu,  2 Mar 2023 08:53:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1AD4919452CE;
	Thu,  2 Mar 2023 08:53:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4AE0819452CD
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Mar 2023 08:53:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D06140CF8E2; Thu,  2 Mar 2023 08:53:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35591400EA93
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 08:53:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 151C9882825
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 08:53:42 +0000 (UTC)
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-iaFdDNguPIiXWKPjNQwc0A-1; Thu, 02 Mar 2023 03:53:40 -0500
X-MC-Unique: iaFdDNguPIiXWKPjNQwc0A-1
Received: by mail-yb1-f200.google.com with SMTP id
 l85-20020a252558000000b0095d2ada3d26so3350835ybl.5
 for <dm-devel@redhat.com>; Thu, 02 Mar 2023 00:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=+H8IhfJeBfs7eR0MM92P0PlE/7BM3A6fmV/sc4VZJII=;
 b=nnqgaqm/wmFCtsjoXZgmnORvJbsjNGEqaBc4vRunZJB2MHmosStiIq/n9meZY6zNjy
 wicKrem44cs54y9LFBWWw8YZIRGK8B3FkWJRlfAU31Ha4NewB0C4cOXQshW6S6y1cKFN
 CF3dbAsgsrgeN9F7wVorctH65ZVIU6ufSvQADDU4w8b1sKl9mLyTE9Odg7VirQTenJwt
 6VN+duzTKdIBV6Be/YjYgEvFyCCId4NFG8dtMmP/6wOWEhNyghaZwfhGj5J0lmXgcYHb
 XS0sNKoJh0xUHegX48XFd7g6tGgwqT8/mZ46dhtSpAx3QLxn2iRefUp4usYyzj6Uoeem
 fEtA==
X-Gm-Message-State: AO0yUKXnrVgdMEbzMTQP0EjqrmuE0wwR+Vk5uboox4D9NiPHyOZY0wM2
 w+SNbjz3bJLuQu0zZcCe20aOA/aQYYszs5cjs9o7y6cHKNyGp0DhTD5sESjn3qiTblx7M7pEQaZ
 wAe72hgolXgT2BM7rCAsC9TBhiLtHNrCdqVYO+T8=
X-Received: by 2002:a5b:b03:0:b0:ace:1ae4:9dd2 with SMTP id
 z3-20020a5b0b03000000b00ace1ae49dd2mr1765778ybp.8.1677747219982; 
 Thu, 02 Mar 2023 00:53:39 -0800 (PST)
X-Google-Smtp-Source: AK7set9cMjzRd5LAG/fF+iFOJBBoUjGcKmemP7iPWtIoTJ4ZeWn9Elv9Xt27QTPgD+HukPnbeGCXfBdJjoser7buOXc=
X-Received: by 2002:a5b:b03:0:b0:ace:1ae4:9dd2 with SMTP id
 z3-20020a5b0b03000000b00ace1ae49dd2mr1765773ybp.8.1677747219674; Thu, 02 Mar
 2023 00:53:39 -0800 (PST)
MIME-Version: 1.0
References: <CAJ0trDZW8FRFuuonKrgSMp7i7m0sLdPGyFHd2ap0Gw8iadrA-A@mail.gmail.com>
 <74a2b8c1-71cf-10b5-a837-c1af60773e98@ewheeler.net>
In-Reply-To: <74a2b8c1-71cf-10b5-a837-c1af60773e98@ewheeler.net>
From: Joe Thornber <thornber@redhat.com>
Date: Thu, 2 Mar 2023 08:53:28 +0000
Message-ID: <CAJ0trDYAyHHh2crMAQuQPMt3FzFmii0nmLnsL5N-cdhfvWZnMg@mail.gmail.com>
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [announce] thin-provisioning-tools v1.0.0-rc1
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
Cc: "development, device-mapper" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3098560482626858134=="

--===============3098560482626858134==
Content-Type: multipart/alternative; boundary="0000000000000d47ef05f5e6f7ab"

--0000000000000d47ef05f5e6f7ab
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Wed, Mar 1, 2023 at 10:26=E2=80=AFPM Eric Wheeler <dm-devel@lists.ewheel=
er.net>
wrote:

>
> Hurrah! I've been looking forward to this for a long time...
>
>
> ...So if you have any commentary on the future of dm-thin with respect
> to metadata range support, or dm-thin performance in general, that I woul=
d
> be very curious about your roadmap and your plans.
>

The plan over the next few months is roughly:

- Get people using the new Rust tools.  They are _so_ much faster than the
old C++ ones. [available now]
- Push upstream a set of patches I've been working on to boost thin
concurrency performance.  These are
  nearing completion and are available here for those who are interested:
https://github.com/jthornber/linux/tree/2023-02-28-thin-concurrency-7.
  These are making a huge difference to performance in my testing, eg, fio
with 16 jobs running concurrently gets several times the throughput.
  [Upstream in the next month hopefully]
- Change thinp metadata to store ranges rather than individual mappings.
This will reduce the amount of space the metadata consumes, and
  have the knock on effect of boosting performance slightly (less metadata
means faster lookups).  However I consider this a half-way house, in
  that I'm only going to change the metadata and not start using ranges
within the core target (I'm not moving away from fixed block sizes).  [Next
3 months]

I don't envisage significant changes to dm-thin or dm-cache after this.


Longer term I think we're nearing a crunch point where we drastically
change how we do things.  Since I wrote device-mapper in 2001 the speed of
devices has increased so much that I think dm is no longer doing a good job=
:

- The layering approach introduces inefficiencies with each layer.  Sure it
may only be a 5% hit to add another linear mapping into the stack.
  But those 5%'s add up.
- dm targets only see individual bios rather than the whole request queue.
This prevents a lot of really useful optimisations.
  Think how much smarter dm-cache and dm-thin could be if they could look
at the whole queue.
- The targets are getting too complicated.  I think dm-thin is around 8k
lines of code, though it shares most of that with dm-cache.
   I understand the dedup target from the vdo guys weighs in at 64k lines.
Kernel development is fantastically expensive (or slow depending
   how you want to look at it).  I did a lot of development work on thinp
v2, and it was looking a lot like a filesystem shoe-horned into the block
layer.
   I can see why bcache turned into bcache-fs.
- Code within the block layer is memory constrained.  We can't allocate
arbitrary sized allocations within targets, instead we have to use mempools
  of fixed size objects (frowned upon these days), or declare up front how
much memory we need to service a bio (forcing us to assume the worst case).
  This stuff isn't hard, just tedious and makes coding sophisticated
targets pretty joyless.

So my plan going forwards is to keep the fast path of these targets in
kernel (eg, a write to a provisioned, unsnapshotted region).  But take
the slow paths out to userland.  I think io_uring, and ublk have shown us
that this is viable.  That way a snapshot copy-on-write, or dm-cache data
migration, which are very slow operations can be done with ordinary
userland code.  For the fast paths, layering will be removed by having
userland give the kernel
instruction to execute for specific regions of the virtual device (ie.
remap to here).  The kernel driver will have nothing specific to thin/cache
etc.
I'm not sure how many of the current dm-targets would fit into this model,
but I'm sure thin provisioning, caching, linear, and stripe can.

- Joe








> Thanks again for all your great work on this.
>
> -Eric
>
> > [note: _data_ sharing was always maintained, this is purely about
> metadata space usage]
> >
> > # thin_metadata_pack/unpack
> >
> > These are a couple of new tools that are used for support.  They compre=
ss
> > thin metadata, typically to a tenth of the size (much better than you'd
> > get with generic compressors).  This makes it easier to pass damaged
> > metadata around for inspection.
> >
> > # blk-archive
> >
> > The blk-archive tools were initially part of this thin-provisioning-too=
ls
> > package.  But have now been split off to their own project:
> >
> >     https://github.com/jthornber/blk-archive
> >
> > They allow efficient archiving of thin devices (data deduplication
> > and compression).  Which will be of interest to those of you who are
> > holding large numbers of snapshots in thin pools as a poor man's backup=
.
> >
> > In particular:
> >
> >     - Thin snapshots can be used to archive live data.
> >     - it avoids reading unprovisioned areas of thin devices.
> >     - it can calculate deltas between thin devices to minimise
> >       how much data is read and deduped (incremental backups).
> >     - restoring to a thin device tries to maximise data sharing
> >       within the thin pool (a big win if you're restoring snapshots).
> >
> >

--0000000000000d47ef05f5e6f7ab
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Eric,</div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Wed, Mar 1, 2023 at 10:26=E2=80=AFPM Eric =
Wheeler &lt;<a href=3D"mailto:dm-devel@lists.ewheeler.net">dm-devel@lists.e=
wheeler.net</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex"><br>
Hurrah! I&#39;ve been looking forward to this for a long time...<br>
<br>
<br></blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
...So if you have any commentary on the future of dm-thin with respect <br>
to metadata range support, or dm-thin performance in general, that I would =
<br>
be very curious about your roadmap and your plans.<br></blockquote><div><br=
></div><div>The plan over the next few months is roughly:</div><div><br></d=
iv><div>- Get people using the new Rust tools.=C2=A0 They are _so_ much fas=
ter than the old C++ ones. [available now]</div><div>- Push upstream a set =
of patches I&#39;ve been working on to boost thin concurrency performance.=
=C2=A0 These are=C2=A0</div><div>=C2=A0 nearing completion and are availabl=
e here for those who are interested:=C2=A0<a href=3D"https://github.com/jth=
ornber/linux/tree/2023-02-28-thin-concurrency-7">https://github.com/jthornb=
er/linux/tree/2023-02-28-thin-concurrency-7</a>.</div><div>=C2=A0 These are=
 making a huge difference to performance in my testing, eg, fio with 16 job=
s running concurrently gets several times the throughput.</div><div>=C2=A0 =
[Upstream in the next month hopefully]</div><div>- Change thinp metadata to=
 store ranges rather than individual mappings.=C2=A0 This will reduce the a=
mount of space the metadata consumes, and=C2=A0</div><div>=C2=A0 have the k=
nock on effect of boosting performance slightly (less metadata means faster=
 lookups).=C2=A0 However I consider this a half-way house, in</div><div>=C2=
=A0 that I&#39;m only going to change the metadata and not start using rang=
es within=C2=A0the core target (I&#39;m=C2=A0not moving away from fixed blo=
ck sizes).=C2=A0 [Next 3 months]</div><div><br></div><div>I don&#39;t envis=
age significant changes to dm-thin or dm-cache after this.</div><div><br></=
div><div><br></div><div>Longer term I think we&#39;re nearing a crunch poin=
t where we drastically change how we do things.=C2=A0 Since I wrote device-=
mapper in 2001 the speed of</div><div>devices has increased so much that I =
think dm is no longer doing a good job:</div><div><br></div><div>- The laye=
ring approach introduces inefficiencies with each layer.=C2=A0 Sure it may =
only be a 5% hit to add another linear mapping into the stack.</div><div>=
=C2=A0 But those 5%&#39;s add up.</div><div>- dm targets only see individua=
l bios rather than the whole request queue.=C2=A0 This prevents a lot of re=
ally useful optimisations.</div><div>=C2=A0 Think how much smarter dm-cache=
 and dm-thin could be if they could look at the whole queue.</div><div>- Th=
e targets are getting too complicated.=C2=A0 I think dm-thin is around 8k l=
ines of code, though it shares most of that with dm-cache.</div><div>=C2=A0=
 =C2=A0I understand the dedup target from the vdo guys weighs in at 64k lin=
es.=C2=A0 Kernel development is fantastically expensive (or slow depending<=
/div><div>=C2=A0 =C2=A0how you want to look at it).=C2=A0 I did a lot of de=
velopment work on thinp v2, and it was looking a lot like a filesystem shoe=
-horned into the block layer.</div><div>=C2=A0 =C2=A0I can see why bcache t=
urned into bcache-fs.</div><div>- Code within the block layer is memory con=
strained.=C2=A0 We can&#39;t allocate arbitrary sized allocations within ta=
rgets, instead we have to use mempools</div><div>=C2=A0 of fixed size objec=
ts (frowned upon these days), or declare up front how much memory we need t=
o service a bio (forcing us to assume the worst case).</div><div>=C2=A0 Thi=
s stuff isn&#39;t hard, just tedious and makes coding sophisticated targets=
 pretty joyless.</div><div><br></div><div>So my plan going forwards is to k=
eep the fast path of these targets in kernel (eg, a write to a provisioned,=
 unsnapshotted=C2=A0region).=C2=A0 But take</div><div>the slow paths out to=
 userland.=C2=A0 I think io_uring, and ublk have shown us that this is viab=
le.=C2=A0 That way a snapshot copy-on-write, or dm-cache data</div><div>mig=
ration, which are very slow operations can be done with ordinary userland c=
ode.=C2=A0 For the fast paths, layering will be removed by having userland =
give the kernel</div><div>instruction to execute for specific regions of th=
e virtual device (ie. remap to here).=C2=A0 The kernel driver will have not=
hing specific to thin/cache etc.</div><div>I&#39;m not sure how many of the=
 current dm-targets would fit into this model, but I&#39;m sure thin=C2=A0p=
rovisioning, caching, linear, and stripe can.</div><div><br></div><div>- Jo=
e</div><div><br></div><div><br></div><div><br></div><div><br></div><div><br=
></div><div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padd=
ing-left:1ex">
Thanks again for all your great work on this.<br>
<br>
-Eric<br>
<br>
&gt; [note: _data_ sharing was always maintained, this is purely about meta=
data space usage]<br>
&gt; <br>
&gt; # thin_metadata_pack/unpack<br>
&gt; <br>
&gt; These are a couple of new tools that are used for support.=C2=A0 They =
compress<br>
&gt; thin metadata, typically to a tenth of the size (much better than you&=
#39;d<br>
&gt; get with generic compressors).=C2=A0 This makes it easier to pass dama=
ged<br>
&gt; metadata around for inspection.<br>
&gt; <br>
&gt; # blk-archive<br>
&gt; <br>
&gt; The blk-archive tools were initially part of this thin-provisioning-to=
ols<br>
&gt; package.=C2=A0 But have now been split off to their own project:<br>
&gt; <br>
&gt; =C2=A0 =C2=A0 <a href=3D"https://github.com/jthornber/blk-archive" rel=
=3D"noreferrer" target=3D"_blank">https://github.com/jthornber/blk-archive<=
/a><br>
&gt; <br>
&gt; They allow efficient archiving of thin devices (data deduplication<br>
&gt; and compression).=C2=A0 Which will be of interest to those of you who =
are<br>
&gt; holding large numbers of snapshots in thin pools as a poor man&#39;s b=
ackup.<br>
&gt; <br>
&gt; In particular:<br>
&gt; <br>
&gt; =C2=A0 =C2=A0 - Thin snapshots can be used to archive live data.<br>
&gt; =C2=A0 =C2=A0 - it avoids reading unprovisioned areas of thin devices.=
<br>
&gt; =C2=A0 =C2=A0 - it can calculate deltas between thin devices to minimi=
se<br>
&gt; =C2=A0 =C2=A0 =C2=A0 how much data is read and deduped (incremental ba=
ckups).<br>
&gt; =C2=A0 =C2=A0 - restoring to a thin device tries to maximise data shar=
ing<br>
&gt; =C2=A0 =C2=A0 =C2=A0 within the thin pool (a big win if you&#39;re res=
toring snapshots).<br>
&gt; <br>
&gt; </blockquote></div></div>

--0000000000000d47ef05f5e6f7ab--

--===============3098560482626858134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3098560482626858134==--

