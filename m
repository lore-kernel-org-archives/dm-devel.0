Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D130C7EE30
	for <dm-devel@archiver.kernel.org>; Fri,  3 Mar 2023 21:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677878488;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=C1tG7RWk6WF6nSiQpxeE9VhUEhBV/9fT1K58FlN5Pqo=;
	b=JrxXwrfzXulgqWiJI84wlGWiLdH/N+nrXzwmZa/4PmZhwu107K54tp6Oqf8y404vhDc0g3
	AAbiZ8TNJaw+XUQzf76BWrOh+F2cXddq7TEH5VV/K5g64+okBskNZFCbIOQEbNmjqHRYB2
	YDTUcJ+7KEGgFCZKsD9qVCNLk2T/pUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643--DPsZMUmMqC-QfsZ9DA6ig-1; Fri, 03 Mar 2023 16:21:25 -0500
X-MC-Unique: -DPsZMUmMqC-QfsZ9DA6ig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E81E286F152;
	Fri,  3 Mar 2023 21:21:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8007140C6EC4;
	Fri,  3 Mar 2023 21:21:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5086119452CD;
	Fri,  3 Mar 2023 21:21:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 70AB619465A0
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Mar 2023 21:21:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54B01492C18; Fri,  3 Mar 2023 21:21:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AB1A492C14
 for <dm-devel@redhat.com>; Fri,  3 Mar 2023 21:21:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F49F86F123
 for <dm-devel@redhat.com>; Fri,  3 Mar 2023 21:21:21 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-zCbWQ_7PMjuDJrIQnIpFuQ-1; Fri, 03 Mar 2023 16:21:18 -0500
X-MC-Unique: zCbWQ_7PMjuDJrIQnIpFuQ-1
Received: from localhost (localhost [127.0.0.1])
 by mx.ewheeler.net (Postfix) with ESMTP id 9243E4B;
 Fri,  3 Mar 2023 13:21:17 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
 by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id fVZ5LxnC8pXB; Fri,  3 Mar 2023 13:21:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mx.ewheeler.net (Postfix) with ESMTPSA id 29A5540;
 Fri,  3 Mar 2023 13:21:13 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 29A5540
Date: Fri, 3 Mar 2023 13:21:13 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Joe Thornber <thornber@redhat.com>
In-Reply-To: <CAJ0trDYAyHHh2crMAQuQPMt3FzFmii0nmLnsL5N-cdhfvWZnMg@mail.gmail.com>
Message-ID: <b4874d2f-12ec-bd7a-889d-e4f59dcfc6bc@ewheeler.net>
References: <CAJ0trDZW8FRFuuonKrgSMp7i7m0sLdPGyFHd2ap0Gw8iadrA-A@mail.gmail.com>
 <74a2b8c1-71cf-10b5-a837-c1af60773e98@ewheeler.net>
 <CAJ0trDYAyHHh2crMAQuQPMt3FzFmii0nmLnsL5N-cdhfvWZnMg@mail.gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="8323328-32617837-1677878473=:14692"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--8323328-32617837-1677878473=:14692
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Mar 2023, Joe Thornber wrote:
> Hi Eric,
>=20
> On Wed, Mar 1, 2023 at 10:26=E2=80=AFPM Eric Wheeler <dm-devel@lists.ewhe=
eler.net> wrote:
>=20
>       Hurrah! I've been looking forward to this for a long time...
>=20
>=20
>       ...So if you have any commentary on the future of dm-thin with resp=
ect
>       to metadata range support, or dm-thin performance in general, that =
I would
>       be very curious about your roadmap and your plans.
>=20
>=20
> The plan over the next few months is roughly:
>=20
> - Get people using the new Rust tools.  They are _so_ much faster than=20
>   the old C++ ones. [available now]
> - Push upstream a set of patches I've been working on to boost thin=20
>   concurrency performance.  These are nearing completion and are=20
>   available here for those who are interested:=20
>   https://github.com/jthornber/linux/tree/2023-02-28-thin-concurrency-7.
> =C2=A0 These are making a huge difference to performance in my testing, e=
g,=20
>   fio with 16 jobs running concurrently gets several times the throughput=
.
> =C2=A0 [Upstream in the next month hopefully]

It would be nice to get people testing the new improvements:

Do you think it can make it for the 6.3 merge window that is open?

> - Change thinp metadata to store ranges rather than individual mappings. =
=20
>   This will reduce the amount of space the metadata consumes, and have=20
>   the knock on effect of boosting performance slightly (less metadata=20
>   means faster lookups).  However I consider this a half-way house, in
> =C2=A0 that I'm only going to change the metadata and not start using ran=
ges=20
>   within the core target (I'm not moving away from fixed block sizes).
>   [Next 3 months]

Good idea.
=20
> I don't envisage significant changes to dm-thin or dm-cache after this.

Seems reasonable.

> Longer term I think we're nearing a crunch point where we drastically=20
> change how we do things.  Since I wrote device-mapper in 2001 the speed=
=20
> of devices has increased so much that I think dm is no longer doing a=20
> good job:
>=20
> - The layering approach introduces inefficiencies with each layer. =20
>   Sure it may only be a 5% hit to add another linear mapping into the=20
>   stack.  But those 5%'s add up.
> - dm targets only see individual bios rather than the whole request=20
>   queue.  This prevents a lot of really useful optimisations.  Think how=
=20
>   much smarter dm-cache and dm-thin could be if they could look at the=20
>   whole queue.
> - The targets are getting too complicated.  I think dm-thin is around 8k=
=20
>   lines of code, though it shares most of that with dm-cache.  I=20
>   understand the dedup target from the vdo guys weighs in at 64k lines. =
=20
>   Kernel development is fantastically expensive (or slow depending
> =C2=A0 how you want to look at it).  I did a lot of development work on=
=20
>   thinp v2, and it was looking a lot like a filesystem shoe-horned into=
=20
>   the block layer.=C2=A0 I can see why bcache turned into bcache-fs.

Did thinp v2 get dropped, or just turn into the patchset above?

> - Code within the block layer is memory constrained.  We can't allocate=
=20
>   arbitrary sized allocations within targets, instead we have to use=20
>   mempools of fixed size objects (frowned upon these days), or declare=20
>   up front how much memory we need to service a bio (forcing us to=20
>   assume the worst case).
> =C2=A0 This stuff isn't hard, just tedious and makes coding sophisticated=
 targets pretty joyless.
>=20
> So my plan going forwards is to keep the fast path of these targets in=20
> kernel (eg, a write to a provisioned, unsnapshotted region).  But take=20
> the slow paths out to userland.

Seems reasonable.

> I think io_uring, and ublk have shown us that this is viable.  That way=
=20
> a snapshot copy-on-write, or dm-cache data migration, which are very=20
> slow operations can be done with ordinary userland code.

Would be nice to minimize CoW latency somehow if going to userspace=20
increases that a notable amount.  CoW for spinning disks is definitely=20
slow, but NVMe's are pretty quick to copy a 64k chunk.

>=C2=A0For the fast paths, layering will be removed by having userland give
> the kernel instruction to execute for specific regions of the virtual=20
> device (ie. remap to here).

Maybe you just answered my question of latency?

> The kernel driver will have nothing specific to thin/cache etc. I'm not=
=20
> sure how many of the current dm-targets would fit into this model, but=20
> I'm sure thin provisioning, caching, linear, and stripe can.

To be clear, linear and stripe would stay in the kernel?=20

-Eric


>=20
> - Joe
>=20
>=20
>=20
>=20
>=20
>=20
> =C2=A0
>       Thanks again for all your great work on this.
>=20
>       -Eric
>=20
>       > [note: _data_ sharing was always maintained, this is purely about=
 metadata space usage]
>       >
>       > # thin_metadata_pack/unpack
>       >
>       > These are a couple of new tools that are used for support.=C2=A0 =
They compress
>       > thin metadata, typically to a tenth of the size (much better than=
 you'd
>       > get with generic compressors).=C2=A0 This makes it easier to pass=
 damaged
>       > metadata around for inspection.
>       >
>       > # blk-archive
>       >
>       > The blk-archive tools were initially part of this thin-provisioni=
ng-tools
>       > package.=C2=A0 But have now been split off to their own project:
>       >
>       > =C2=A0 =C2=A0 https://github.com/jthornber/blk-archive
>       >
>       > They allow efficient archiving of thin devices (data deduplicatio=
n
>       > and compression).=C2=A0 Which will be of interest to those of you=
 who are
>       > holding large numbers of snapshots in thin pools as a poor man's =
backup.
>       >
>       > In particular:
>       >
>       > =C2=A0 =C2=A0 - Thin snapshots can be used to archive live data.
>       > =C2=A0 =C2=A0 - it avoids reading unprovisioned areas of thin dev=
ices.
>       > =C2=A0 =C2=A0 - it can calculate deltas between thin devices to m=
inimise
>       > =C2=A0 =C2=A0 =C2=A0 how much data is read and deduped (increment=
al backups).
>       > =C2=A0 =C2=A0 - restoring to a thin device tries to maximise data=
 sharing
>       > =C2=A0 =C2=A0 =C2=A0 within the thin pool (a big win if you're re=
storing snapshots).
>       >
>       >
>=20
>=20
> 
--8323328-32617837-1677878473=:14692
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--8323328-32617837-1677878473=:14692--

