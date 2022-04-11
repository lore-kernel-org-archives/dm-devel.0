Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EA5C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 07:06:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-lekjaj7HO0iXd-jPy8ABzA-1; Tue, 12 Apr 2022 03:06:17 -0400
X-MC-Unique: lekjaj7HO0iXd-jPy8ABzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E74F8339AF;
	Tue, 12 Apr 2022 07:06:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E852940F4945;
	Tue, 12 Apr 2022 07:06:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DDC001940379;
	Tue, 12 Apr 2022 07:06:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5624E1940365
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 22:31:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4567A112131B; Mon, 11 Apr 2022 22:31:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40A0B111E410
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:31:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4420F80418B
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:31:25 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com
 (wout4-smtp.messagingengine.com [64.147.123.20]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-PNskq61AMQWVH5Av9zbOvw-1; Mon, 11 Apr 2022 18:31:19 -0400
X-MC-Unique: PNskq61AMQWVH5Av9zbOvw-1
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
 by mailout.west.internal (Postfix) with ESMTP id BA87F3200E60;
 Mon, 11 Apr 2022 18:31:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute3.internal (MEProxy); Mon, 11 Apr 2022 18:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:references
 :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
 :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649716277; x=
 1649802677; bh=fyGsYug4Q6uAOLHLHJwCLQ9lx6jhEnTbXKJQM3zK/5s=; b=C
 7mttK126GTP0tjwcM6n8SqndTcPuccw8pcg8tDNmw9VkBtpwgslk+KE7WGA/aCw9
 Yk9ETsrC8qLqlzKtghYOUduTr94elZtiNTXXijfPegOj9RLlwub+Hth+tH25TORn
 ENN5KHZTgopsg2KHxzBEHLu4pX0Juxdz7jJxzBF0P9fJ0jKmZIWghTvgnq9H2keu
 w/thm1lqcvO0YLYVWjgB+JszOUfHOOfPcxvk6mLztKxnbxxZJX6QctI2WMn9fqqc
 xgdUJmCKn300VJYNwiqrHZPzNMhQaOPS2RFcOFxie64C9fZhRx2kxkSICt/L7SfB
 pUi+jtJxuCyPGMyntv8bQ==
X-ME-Sender: <xms:NaxUYl8rE6D4GcCLlH0PkBbnP19Ns9JIwsu3kAbkvPRAGVSf7U__TA>
 <xme:NaxUYpvtqgbHCUd9Xwk8xSNeBO3x861PRqhF1YdPtAPzjS3e-GtORW4jnOrjbNkmq
 QfWzgl4DZuosTk>
X-ME-Received: <xmr:NaxUYjDFhNS06nAwHXuChUl5c3TOIzvbNYdiuTXH6mdnyYFrwcOVGep_2Fhd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekjedguddtucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghmihcu
 ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
 hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeeukeeitedvfeffffehveelheeitdfg
 iedtueekieeuheejkefhtedttdevffejfeenucffohhmrghinhepghhithhhuhgsrdgtoh
 hmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggv
 mhhisehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:NaxUYpeB1HJk-5WEWMVv8vItQLIC0vZ94pMa_ulBUvbTKS0YFvCviw>
 <xmx:NaxUYqObYHbfqKfM9WYkSGaGar2WGWXHOjF-Ya1yJErAVTo38Vdcow>
 <xmx:NaxUYrlSIYgaLMeIMEHLxmrLvwvBiZB7yMzouDNsEybYpUvtdCbGOQ>
 <xmx:NaxUYkVY01PNHi7FgPokTxCXyR-O56zyN5pK3O36CZ1dnDdfO4A9Hw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 18:31:16 -0400 (EDT)
Date: Mon, 11 Apr 2022 18:30:53 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <ejt@redhat.com>
Message-ID: <YlSsMlcE5x2B58hc@itl-email>
References: <YlNUhtXltj8vgvcZ@itl-email>
 <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
 <YlRjvp7SH3To0pHe@itl-email>
 <cc43900d-35a3-14ae-73ef-919ab02e01ff@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cc43900d-35a3-14ae-73ef-919ab02e01ff@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Tue, 12 Apr 2022 07:06:10 +0000
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2
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
Cc: dm-devel@redhat.com
Content-Type: multipart/mixed; boundary="===============2414493202368183566=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2


--===============2414493202368183566==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Po3y/7oX2EdkdTjR"
Content-Disposition: inline


--Po3y/7oX2EdkdTjR
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 11 Apr 2022 18:30:53 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2

On Mon, Apr 11, 2022 at 10:16:43PM +0200, Zdenek Kabelac wrote:
> Dne 11. 04. 22 v 19:22 Demi Marie Obenour napsal(a):
> > On Mon, Apr 11, 2022 at 10:16:02AM +0200, Zdenek Kabelac wrote:
> > > Dne 11. 04. 22 v 0:03 Demi Marie Obenour napsal(a):
> > >=20
> > > Your proposal actually breaks this sequence and would move things to =
the
> > > state of=C2=A0 'guess at which states we are now'. (and IMHO presents=
 much more
> > > risk than virtual problem with suspend from user-space - which is onl=
y a
> > > problem if you are using suspended device as 'swap' and 'rootfs' - so=
 there
> > > are very easy ways how to orchestrate your LVs to avoid such problems=
).
> > The intent is less =E2=80=9Cguess what states we are now=E2=80=9D and m=
ore =E2=80=9CIt looks
> > like dm-thin already has the data structures needed to store some
> > per-thin metadata, and that could make writing a simple userspace volume
> > manager FAR FAR easier=E2=80=9D.  It appears to me that the only change=
 needed
>=20
>=20
> I do not spend hours explaining all the details - but running just the
> suspend alone may result in many differnt problem where the things like
> running thin-pool out-of-data space is one of the easiest.
>=20
> Basically each step must be designed with=C2=A0 'power-off' happen during=
 the
> operation. For each step you need to know how the recovery step looks like
> and how the lvm2 & kernel metadata c/would match together.

That is absolutely the case, and is in fact the reason I proposed this
change to begin with.  By having dm-thin store a small amount of
userspace-provided metadata for each thin volume, and by providing an
API to enumerate the thin volumes in a pool, I can store all of the
metadata I need in the thin pool itself.  This is much simpler than
having to store metadata outside of the pool.

> Combining many
> steps together into a single 'kernel' call just increases already large
> range of errors.=C2=A0 So in many case we simply do favour to keep operat=
ion more
> 'low-level-atomic' even at slight higher performance price (as said - we'=
ve
> never seen a creation of snapshot to be 'msec' critical operation - as=C2=
=A0 the=C2=A0
> 'suspend' with implicit flush & fsfreeze itself might be far more expensi=
ve
> operation.

Qubes OS should never be snapshotting an in-use volume of any kind.
Right now, there is one case where it does so, but that is a bug, and I
am working on fixing it.  A future API might support snapshotting to an
in-use volume, but that would likely require a way to tell the VM to
freeze its own filesystem.

> > > But IMHO creation and removal of thousands of devices in very short p=
eriod
> > > of time rather suggest there is something sub-optimal in your original
> > > software design as I'm really having hard time imagining why would yo=
u need
> > > this ?
> > There very well could be (suggestions for improvement welcome).
> >=20
> > > If you wish to operate lots of devices - keep them simply created and=
 ready
> > > - and eventually blkdiscard them for next device reuse.
> > That would work for volatile volumes, but those are only about 1/3 of
> > the volumes in a Qubes OS system.  The other 2/3 are writable snapshots.
> > Also, Qubes OS has found blkdiscard on thins to be a performance
> > problem.  It used to lock up entire pools until Qubes OS moved to doing
> > the blkdiscard in chunks.
>=20
> Always make sure you use recent Linux kernels.

Should the 5.16 series be recent enough?

> Blkdiscard should not differ from lvremove too much=C2=A0 - also experime=
nt how
> the=C2=A0 'lvchange --discards=C2=A0 passdown|nopassdown poolLV' works.

I believe this was with passdown on, which is the default in Qubes OS.
The bug was tracked down by Jinoh Kang in
https://github.com/QubesOS/qubes-issues/issues/5426#issuecomment-761595524
and found to be due to dm-thin deleting B-tree nodes one at a time,
causing large amounts of time to be wasted on btree rebalancing and node
locking.

> > > I'm also unsure from where would arise any special need to instantiat=
e=C2=A0 that
> > > many snapshots -=C2=A0 if there is some valid & logical purpose -=C2=
=A0=C2=A0 lvm2 can have
> > > extended user space API to create multiple snapshots at once maybe (so
> > > i.e.=C2=A0=C2=A0=C2=A0 create=C2=A0 10 snapshots=C2=A0=C2=A0 with=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 name-%d=C2=A0 of a single thinLV)
> > This would be amazing, and Qubes OS should be able to use it.  That
> > said, Qubes OS would prefer to be able to choose the name of each volume
> > separately.  Could there be a more general batching operation?  Just
> > supporting =E2=80=98lvm lvcreate=E2=80=99 and =E2=80=98lvm lvs=E2=80=99=
 would be great, but support for
> > =E2=80=98lvm lvremove=E2=80=99, =E2=80=98lvm lvrename=E2=80=99, =E2=80=
=98lvm lvextend=E2=80=99, and =E2=80=98lvm lvchange
> > --activate=3Dy=E2=80=99 as well would be even better.
>=20
> There is kind of 'hidden' plan inside command line processing to allow
> 'grouped'=C2=A0 processing.
>=20
> lvcreate --snapshot=C2=A0 --name lv1=C2=A0 --snapshot --name lv2 vg/origin
>=20
> However there is currently no man power to proceed further on this part as
> we have other parts of code needed enhancements.
>=20
> But we may put this on our TODO plans...

That would be great, thanks!

> > > Not to mentioning operating that many thin volumes from a single thin=
-pool
> > > is also nothing close to high performance goal you try to reach...
> > Would you mind explaining?  My understanding, and the basis of
> > essentially all my feature requests in this area, was that virtually all
> > of the cost of LVM is the userspace metadata operations, udev syncing,
> > and device scanning.  I have been assuming that the kernel does not have
> > performance problems with large numbers of thin volumes.
>=20
>=20
> The main idea behind the comment is -=C2=A0 when there is increased disk =
usage -
> the manipulation with thin-pool metadata and locking will soon start to b=
e a
> considerable performance problem.
>=20
> So while it's easy to have active=C2=A0 1000 thinLVs from a single thin-p=
ool that
> are UNUSED, situation is dramatically different when there LVs would be in
> some heavy use load.=C2=A0 There you should keep the active thinLV at low=
 number
> of=C2=A0 tens=C2=A0 LVs, especially if you are performance oriented.=C2=
=A0 The lighter
> usage and less provisioning and especially bigger block size - improve

I can try to modify the storage pool so that LVs are not activated by
default.  That said, Qubes OS will always be provisioning-heavy.  With
the notable exception of volatile volumes, qubesd always snapshots a
volume at startup and then provides the snapshot to the VM.  After
shutdown, the original volume is renamed to be a backup, and the
snapshot gets the name of the original volume.  Bigger block sizes would
substantially increase write amplification, as turning off zeroing is
not an option for security reasons.

Is this just a workload that dm-thin is ill-suited for?  Qubes OS does
support storing VM images on either BTRFS or XFS files, and it could be
that this is a better plan going forward.

> > Right now, my machine has 334 active thin volumes, split between one
> > pool on an NVMe drive and one on a spinning hard drive.  The pool on an
> > NVMe drive has 312 active thin volumes, of which I believe 64 are in us=
e.
> > Are these numbers high enough to cause significant performance
> > penalties for dm-thin v1, and would they cause problems for dm-thin v2?
>=20
> There are not yet any numbers for v2
>=20
> For v1 - 64 thins might eventually experience some congestion for heavy l=
oad
> (compared with 'native' raw spindle).
>=20
> > How much of a performance win can I expect from only activating the
> > subset of volumes I actually use?
>=20
>=20
> I can only advice benchmark with some good approximation of your expected
> workload.

That=E2=80=99s already on the Qubes OS team=E2=80=99s (very long) to-do lis=
t.

--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--Po3y/7oX2EdkdTjR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJUrDMACgkQsoi1X/+c
IsFl9g/9GXaaF+QCX4YIqJzZCoOYiqWn89oB/H8p/CGI0toEF7SMFbSpftH1PHfC
uWEMsE2OUgsAWxnPrItZaEk25tfcUKIWV27vNmeTmko3LNdOnD8LNXHJuxwFZ2t6
EcGhg8uurocg3IIY7vwqhe4swrkp1xHIHm4W/pCKgxzDE25RPi9AVF3CR7nc3OHG
Nj3xUVclE/RSbNO/JJdDbgaCW6It0H3VcniqCeBiaRSSrzPR3MK3qaJQ+V1Bgoby
Pm2hdbmzi+NJqO7y+b7bEDyTn3m1sj6T6q17x6HImr5EMk9x74OoDdubqhy3EDWW
MYayay6Y1z7xNCXw8t3zv4IYjlKWKz0l9V4r7SQuZL0SKPxn6WI65O6LPJWgeMwU
FmGffXL+gljnaHEpx85/B3MqJlwvpACyCEOdlk8NMtTAA3C1cPwxtSjZJWcbXwxC
PtFpXdZlMGXVnsCMBurBOIxOoYaJJlQksgsvyvWhH5qVSDq3kc5g793HCjuUdU/B
1bXskJQaVzqt73YfSjmkcqt+TbyLyg2fJozHQHbpQNa5VoxV0vKU8eQ405tf+K2H
A34mY9Plsi5/8c+sxGw5S8CsRnyVy6Dg9iYCD3W6gChl476N8AXK25pUWRpK4sci
2GwJxNFM+yu2SRZiPWXpIXjysrwndvsqGEHyC6OgT142vQH0s8w=
=Niou
-----END PGP SIGNATURE-----

--Po3y/7oX2EdkdTjR--


--===============2414493202368183566==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2414493202368183566==--

