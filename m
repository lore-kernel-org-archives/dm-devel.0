Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA412C43219
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 07:06:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-dFf-fbP4Ove8yv1XCDIgBw-1; Tue, 12 Apr 2022 03:06:14 -0400
X-MC-Unique: dFf-fbP4Ove8yv1XCDIgBw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37563100BAAA;
	Tue, 12 Apr 2022 07:06:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E51354AC85;
	Tue, 12 Apr 2022 07:06:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DD8CC1949762;
	Tue, 12 Apr 2022 07:06:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9278C19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 17:22:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8214FC2813C; Mon, 11 Apr 2022 17:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DD7BC15D76
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 17:22:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61ECA86B8AB
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 17:22:14 +0000 (UTC)
Received: from wout2-smtp.messagingengine.com
 (wout2-smtp.messagingengine.com [64.147.123.25]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-Tss-kI6vMSy9XMqxzX01_w-1; Mon, 11 Apr 2022 13:22:10 -0400
X-MC-Unique: Tss-kI6vMSy9XMqxzX01_w-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.west.internal (Postfix) with ESMTP id 01FF23201D9C;
 Mon, 11 Apr 2022 13:22:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute4.internal (MEProxy); Mon, 11 Apr 2022 13:22:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:references
 :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
 :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649697728; x=
 1649784128; bh=ynIJcoYmQfhRcdbgdKg4f68GdOnODg2lQKZLNjSLI3E=; b=G
 j7XzmykQaNVcS9x6iWJhKGg59mO80lLJnAhDT/4asy+0gC6Ye/oIdAMiUOJmKjz2
 DoI1X1WLa1z6g/sYOtxYsJfcWFQqhfV+nmHjYr0CohSrdnbR0/8+ijK+58u5cnSs
 myvQa5iQc7S1Iw0TiEfRMDRsbsXAb2IvjzeHVp6faKmW5zorEIzLK7YK4UTJO660
 7/LH/hjCWsYHX+4nhne2tW8QDKOVynlt79wT7RCJgOdL0l3D4oK8vhQCD2QUwsr8
 QJfuv/qYOR4+uYJfKXdLqzPDnmKueiLnDRbrCQxi6q3oy/wemvyP9iuGdKshunzV
 W3RLmdxftQkkgA5K79K+w==
X-ME-Sender: <xms:wGNUYp91WMX7J1XwR1gGVU5APNvnZ4r5JxQozCNC7tA_CXUjkV2j4w>
 <xme:wGNUYtsK4RioO-cCULZG-vG0JyGM2s40puhDF49-1mXgkUIP9k1mdBzelX6PexGL_
 Y9VmnaHEXAsP4M>
X-ME-Received: <xmr:wGNUYnC51qp2SNcWGr3p3xBmIBjQSyS4Rf7Vgj53Zz99nu9NKvB9dHMvwnWH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekiedguddufecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnheptdettdeuiedvfeeiudfgjedtuedt
 leefvdeukeeltddugeejvdeiudekfefhueetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:wGNUYtcAKwDJMpwE7cZBnGThYerS1C_7V3sgWMTR21IBJRA0jLCQAA>
 <xmx:wGNUYuNJiCnmyxuO86uo3YgGnNo62yvQRNCk3n8IhEUkhqZMKzL6Wg>
 <xmx:wGNUYvkDlJli-4B1El6OUGgHQoZ97uYA4UqONsnmWBN6WYeJ6a_5-Q>
 <xmx:wGNUYoWUV-glOIXBGGrIW2ioPHXisxNr-85N2hkYfGfheUa1_AIuQw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 13:22:08 -0400 (EDT)
Date: Mon, 11 Apr 2022 13:22:03 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <ejt@redhat.com>
Message-ID: <YlRjvp7SH3To0pHe@itl-email>
References: <YlNUhtXltj8vgvcZ@itl-email>
 <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
MIME-Version: 1.0
In-Reply-To: <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Content-Type: multipart/mixed; boundary="===============1546039141188719660=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9


--===============1546039141188719660==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cVhCP/VtnkM68htk"
Content-Disposition: inline


--cVhCP/VtnkM68htk
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 11 Apr 2022 13:22:03 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2

On Mon, Apr 11, 2022 at 10:16:02AM +0200, Zdenek Kabelac wrote:
> Dne 11. 04. 22 v 0:03 Demi Marie Obenour napsal(a):
> > For quite a while, I have wanted to write a tool to manage thin volumes
> > that is not based on LVM.  The main thing holding me back is that the
> > current dm-thin interface is extremely error-prone.  The only per-thin
> > metadata stored by the kernel is a 24-bit thin ID, and userspace must
> > take great care to keep that ID in sync with its own metadata.  Failure
> > to do so results in data loss, data corruption, or even security
> > vulnerabilities.  Furthermore, having to suspend a thin volume before
> > one can take a snapshot of it creates a critical section during which
> > userspace must be very careful, as I/O or a crash can lead to deadlock.
> > I believe both of these problems can be solved without overly
> > complicating the kernel implementation.
>=20
>=20
> Hi
>=20
> These things are coming with initial design of whole DM world - where the=
re
> is a split of complexity between kernel & user-space. So projects like
> btrfs, ZFS, decided to go the other way and create a monolithic 'all-in-o=
ne'
> solution, where they avoid some problems related with communication betwe=
en
> kernel & user-space - but at the price of having a pretty complicated and
> very hard to devel & debug=C2=A0 kernel code.
>=20
> So let me explain one of the reasons, we have this logic with suspend is
> this basic principle:
>=20
> write new lvm metadata ->=C2=A0 suspend (with all table preloads) ->=C2=
=A0 commit=C2=A0 new
> lvm2 metadata -> resume
>=20
> with this we ensure the user space maintain the only valid 'view' of meta=
data.
>=20
> Your proposal actually breaks this sequence and would move things to the
> state of=C2=A0 'guess at which states we are now'. (and IMHO presents muc=
h more
> risk than virtual problem with suspend from user-space - which is only a
> problem if you are using suspended device as 'swap' and 'rootfs' - so the=
re
> are very easy ways how to orchestrate your LVs to avoid such problems).

The intent is less =E2=80=9Cguess what states we are now=E2=80=9D and more =
=E2=80=9CIt looks
like dm-thin already has the data structures needed to store some
per-thin metadata, and that could make writing a simple userspace volume
manager FAR FAR easier=E2=80=9D.  It appears to me that the only change nee=
ded
would be reserving some space (amount fixed at pool creation) after
=E2=80=98struct disk_device_details=E2=80=99 for use by userspace, and prov=
iding a way
for userspace to enumerate the thin devices on a volume and to set and
retrieve that extra data.  Suspend isn=E2=80=99t actually that big of a pro=
blem,
since new Qubes OS 4.1 (and later) installs use one pool for the root
filesystem and a separate one for VMs.  As a userspace writer, the
scariest part of managing thin volumes is actually making sure I don=E2=80=
=99t
lose track of which thin ID corresponds to which volume name.  The
*only* metadata Qubes OS would need would be a per-thin name, size, thin
ID, and possibly UUID.  All of those could be put in that extra space.

> Basically you are essentially wanting to move whole management into kernel
> for some not so great speed gains (related to the rest of the running sys=
tem
> (and you can certainly do that by writing your own kernel module to manage
> your ratehr unique software problem)

=46rom a storage perspective, my problem is basically the same as Docker=E2=
=80=99s
devicemapper driver.  Unlike Docker, though, Qubes OS must work at the
block level; it can=E2=80=99t work at the filesystem level.  So overlayfs a=
nd
friends aren=E2=80=99t options.

> But IMHO creation and removal of thousands of devices in very short period
> of time rather suggest there is something sub-optimal in your original
> software design as I'm really having hard time imagining why would you ne=
ed
> this ?

There very well could be (suggestions for improvement welcome).

> If you wish to operate lots of devices - keep them simply created and rea=
dy
> - and eventually blkdiscard them for next device reuse.

That would work for volatile volumes, but those are only about 1/3 of
the volumes in a Qubes OS system.  The other 2/3 are writable snapshots.
Also, Qubes OS has found blkdiscard on thins to be a performance
problem.  It used to lock up entire pools until Qubes OS moved to doing
the blkdiscard in chunks.

> I'm also unsure from where would arise any special need to instantiate=C2=
=A0 that
> many snapshots -=C2=A0 if there is some valid & logical purpose -=C2=A0=
=C2=A0 lvm2 can have
> extended user space API to create multiple snapshots at once maybe (so
> i.e.=C2=A0=C2=A0=C2=A0 create=C2=A0 10 snapshots=C2=A0=C2=A0 with=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 name-%d=C2=A0 of a single thinLV)

This would be amazing, and Qubes OS should be able to use it.  That
said, Qubes OS would prefer to be able to choose the name of each volume
separately.  Could there be a more general batching operation?  Just
supporting =E2=80=98lvm lvcreate=E2=80=99 and =E2=80=98lvm lvs=E2=80=99 wou=
ld be great, but support for
=E2=80=98lvm lvremove=E2=80=99, =E2=80=98lvm lvrename=E2=80=99, =E2=80=98lv=
m lvextend=E2=80=99, and =E2=80=98lvm lvchange
--activate=3Dy=E2=80=99 as well would be even better.

> Not to mentioning operating that many thin volumes from a single thin-pool
> is also nothing close to high performance goal you try to reach...

Would you mind explaining?  My understanding, and the basis of
essentially all my feature requests in this area, was that virtually all
of the cost of LVM is the userspace metadata operations, udev syncing,
and device scanning.  I have been assuming that the kernel does not have
performance problems with large numbers of thin volumes.

Right now, my machine has 334 active thin volumes, split between one
pool on an NVMe drive and one on a spinning hard drive.  The pool on an
NVMe drive has 312 active thin volumes, of which I believe 64 are in use.
Are these numbers high enough to cause significant performance
penalties for dm-thin v1, and would they cause problems for dm-thin v2?
How much of a performance win can I expect from only activating the
subset of volumes I actually use?

Also, I believe a significant fraction of I/O is writes to previously
unallocated blocks.  I haven=E2=80=99t measured how much, though, since I a=
m not
aware of any way to get that statistic, at least without kprobes or
similar.

The pool on a spinning hard drive has 22 thin volumes, of which I
believe only one is in use.  The HDD is mostly used for backups, so its
performance doesn=E2=80=99t matter that much.

--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--cVhCP/VtnkM68htk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJUY74ACgkQsoi1X/+c
IsGmhg/8C2Otczg5aPrNlL2Ue7RDhY0ZrPVOf055jW3XtkKeClSDz5mlpwNOEwkA
gtDLUB+qzI+GUZEOnJWh1O1sPa4JavcInsU9KfxbkNH5kL8sEwofEPxSEhUEzIfE
95YXpZxcvOJwvxhClvZ20Mw4kcFPgqnXGzNmEmWpQVr8MrPjz+bnVyXOQs8ICv00
QXS3FtqlIuR/jD0Acj1cGTpihXvNTLW7kNJw10Tv45v6oA59DhkG6qORKuJRCV+X
8YNri4+LbDC3GdYN7CqBFXwhXX54vgBenohAlKQa+1/d3v8pX/e1Wvq2j7dPl8Nq
ZXpSLwe/zvIcfvmy3Pz90AG5fdOaZaScDsecIlZkOrIJ2NxROIRLHzd/scO6aw8D
yJqvEk5/sjEvyxPM2dzPF1Q8bOgRxxbJToG2pXOLMEdfanW49WYRJ3JfLg2+NpqV
U5zGa2Qf57QUvdX0+CoL7sbhjSfQ70Zm7MDxAAXfyt9YkwdFvA/IxVerQcZwYvqX
t9oTGAxkAEmjev7lL2kAJXpvrT75YvBp0m6iQpWlfBWdHhJBwM11Sd70jWrwWtek
Sp3mLBfgT6oxIwhS++GdTw0h8DjzQqy/Gjf6GqHCpl8uBPIEqkmEIO33dJxC39Py
S6FWqFc8UMRZxx0+7b7kL4527cuIqnkmy7Wjk5SEzFwszWxrB0g=
=nxyZ
-----END PGP SIGNATURE-----

--cVhCP/VtnkM68htk--


--===============1546039141188719660==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1546039141188719660==--

