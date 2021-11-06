Return-Path: <SRS0=0/af=PZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51788C433F5
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:50:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADF7F611C4
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ADF7F611C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-owb3w-2vOw6n6BUrwHj_FQ-1; Sat, 06 Nov 2021 14:50:11 -0400
X-MC-Unique: owb3w-2vOw6n6BUrwHj_FQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FAF780A5C3;
	Sat,  6 Nov 2021 18:50:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5616617C58;
	Sat,  6 Nov 2021 18:50:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C42994EA2A;
	Sat,  6 Nov 2021 18:50:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A6Io4Hl019532 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Nov 2021 14:50:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9B3904047279; Sat,  6 Nov 2021 18:50:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96257404727A
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:50:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E2AC85A5AA
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:50:04 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1636224604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muCOQuR8pTpyQBrD4Y1VLugCiZ+RmGwsT2Eh9q4e/xc=;
	b=Dk64Y0UnsYHd1NjWEkrBEtY6Ri9vuL3KVgKBaCsVdD2X9nBJN5hfdJkp3wOef8AvQrGsiu
	gTCUkzCWW9c+74u9OfsdKp+nfttc17VP1Wwz9icgGOq6FhGbyRnobe8Gs4ocilE6d47ZwN
	5/UNIyXTTuomrexR1m/Elzn9uIl3EsJdfOQ4+r1PL/IwT9wiBBJkoqhE1iDnjbyEg3SxWr
	XTAXmSWVQcaNGJDr3NBbS2uNuhb3ekaFYBjkf7Q6jpaRgZrTOzkROKvuExWu42G/L8wReU
	M9uRXYHRUyjUh4uXprolYcu03SNCVxWAcIwCubhumTAZb6bDhtXpomLiOawYFw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1636224604; a=rsa-sha256;
	cv=none;
	b=WuBlFeYdJtRkj7zDtNGo8VXBadrHR0ePWH99sbKjT3maV72V14qhGqt1lV/8aZGjH7VnBW
	ReDUmb6+G79QZqu0BzlskcMzZD8uvHAw5J3LH70nW41UT9pYcM6cdjJfquVgBCV3WqEFzd
	xgSD9wABVGHobUxvDOTQj3/ztntntLnHNN+ekwmGn3K8dR42+v0apJz7/F11PZjRTxYP++
	VHoqIbisV1X/00OUgUnh8KRt3Tug8asFz3r1WGIa7w2QzgpmzxDYwKCB0pKD0r9p4euntg
	4AStM10TYF9TrY7IGmAr6bKyiwJ0iCW8BtLdsV59w/ZxUfPYz9aYZsP8K0m21A==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=bwBmB8vC;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.4 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
Received: from mout.web.de (mout.web.de [212.227.15.4]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-235-RnH4qPWkNLuX2uCROg2bdA-1;
	Sat, 06 Nov 2021 03:48:18 -0400
X-MC-Unique: RnH4qPWkNLuX2uCROg2bdA-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1636184896;
	bh=35PqTHwkplKaAMFgJ59LBZT6nBoDV7pVOc0kXy1wcE4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bwBmB8vC89T4QHgZSHsmwpoSx8lwxYb1Ygm/EengR7x2kOO+11cNhUfFZKBNiLcT9
	946CW26hkfrE8dnVk1sz7cJ0IMOVEDQXeCQYnqdFhfygCmDDtSheaJrA0hx0ou7P7E
	7d+wkD1ILt++1n/Exyi3A+6Epqpk6qAbM64MaSq8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.150.38]) by smtp.web.de (mrweb006
	[213.165.67.108]) with ESMTPSA (Nemesis) id 1Mt8gP-1mULqo15JZ-00t62y;
	Sat, 06 Nov 2021 08:41:59 +0100
Date: Sat, 6 Nov 2021 07:41:46 +0000
From: Lukas Straub <lukasstraub2@web.de>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20211106074146.04fc36a3@gecko>
In-Reply-To: <CAPcyv4hK18DetEf9+NcDqM5y07Vp-=nhysHJ3JSnKbS-ET2ppw@mail.gmail.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<CAPcyv4hK18DetEf9+NcDqM5y07Vp-=nhysHJ3JSnKbS-ET2ppw@mail.gmail.com>
MIME-Version: 1.0
X-Provags-ID: V03:K1:cgcmyG78PhSL4Zie9BD7YaHQeP9628H6KkHtTzOyZ3i+4wJ78J8
	CVAakX/Hc4C9zy9aH/Eq8qbaCUlHAY2KwCknO/3N/XooBP+bO/4K17nL8q0WJP1pkOkqsCP
	jh9EK9kbxryW4SXw8vfZDLkigyiu/hBiE6JIywmP5F8tybHoYhl44p35REdmELfp6rsLju9
	sVkrHjhk2SSXrVs4bD1Nw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:y6OGW9NNMlc=:ZI5uEMg1m56TbW3wf28WK0
	rNQRy1qDUq8ZMnbD5lSDkZ+zJRGyoQQqxzuJaoKBdzNHfS0AmyeCJd/6bfrOQPR36QHu6HHtO
	G3H1yiLpissxCDbeb+Rwydf0A0VA4IPsZ8ARd6iEU2QZ77nuP3tMiaZOzBmanfLznxMSmnbLd
	uZ5c+oQ1zoiv3jgeG8Vh1YImaY4mI6tsFeOACum1s80DxJxc4FFwLkeEhFAPtu5dHuPH8UemM
	UUgbencA8oN1sGOJHQ1iEF8iFwQhb6XySSMcoz434iSll3LAIKMAFbTs4fJ87WYtlqPsVdzzi
	q1ou1lxeWhU+7+7k04YDEjZosST9Zg6+vkGhRV681xO5FozQ7xd0+S1w59M6sfbmVyLoOGip+
	xNVYfiR26ARSxZjCigTrznNOyuItMW9fGWfz8rJP8amTnhjvMeEFu3DyhwvW66S9XqDaGFGBr
	X0TRljMWRQz9KRYcyWyXVzYe3WRvRvDdjzyskbAnDhgEHzVGIlwHXvsn4Ax0STPaOz/hsNEnD
	sBeIEhQIi6vnTI96vydPADW2RXk7hR1vLIQlEO7bsUnFW95wnqMVIfdnfoANkpptZf3hPozn7
	ZQTCp1WJR2pdWXkwfzG8T6zLa53nHbTEZmnAfo3kmPdQfyDv7bW1J1Cq+YnxqkS1yYFxLgHGP
	lDuh28z7NhZQDllVzr1ToSNyPJCch+OhjOsZYmWmBkJmYTSZUsB1ND6Gay87JTbFPbkvzOQC8
	+2K39xnVoRESwRaBZCstRyA5wm2UnBjn8kuEE/F9cBTP/F5UxcnVa9tWXEVlWbjHuNRAfIqVD
	GekZ/2qAnbOmuB3/i3f1644tgnoI0AkrYQUs3fNqDDKFW2gIarewiBKDc3vlHqogGJK9Nmw6A
	x7Pgr7wpbFbRe9xwSQ+ISo9UT2RoG6XLhD0vO4E8bI2G83HR17KfcdLdD7KazsHrD1X694DU5
	yVBTIXjMDCMeeC2Z/N3wcAEh8xMPSYKtzYYd1xqyf0gIyO0wdaQwtZ1Syjuf3Nq+/JLGK6CI+
	1/qvQagITL69kNNaE5EUP1gPPa5C20JEGS1VA3h4woyxjf4pXH8eVPa11jouVW+XpgHBlijur
	KpoJcGi3BwqT7DbCtjih3Fqv96PJs3+XpwhwsyEB5Pi9Y/etkNBUofa9jN+mva9oYE3qjR9VM
	4HB8JV25QVXVTjXhprmT/zX32+UU3c3cdNmHvVER4gqmD3zo25fSci8GJ3oLP09VPjQM48V1p
	mG5BITr/rZvoFmL9ZYUyRd7lFuOPh487JhT7CRxjlznLKcCIZ91rfnOoBAsk=
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=bwBmB8vC;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.4 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
X-Mimecast-Spam-Score: -5
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
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
Content-Type: multipart/mixed; boundary="===============3083569891154831329=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============3083569891154831329==
Content-Type: multipart/signed; boundary="Sig_/bO7uynQmFI27w4fHadpypym";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/bO7uynQmFI27w4fHadpypym
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Nov 2021 09:03:55 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, Oct 26, 2021 at 11:50 PM Christoph Hellwig <hch@infradead.org> wr=
ote:
> >
> > On Fri, Oct 22, 2021 at 08:52:55PM +0000, Jane Chu wrote: =20
> > > Thanks - I try to be honest.  As far as I can tell, the argument
> > > about the flag is a philosophical argument between two views.
> > > One view assumes design based on perfect hardware, and media error
> > > belongs to the category of brokenness. Another view sees media
> > > error as a build-in hardware component and make design to include
> > > dealing with such errors. =20
> >
> > No, I don't think so.  Bit errors do happen in all media, which is
> > why devices are built to handle them.  It is just the Intel-style
> > pmem interface to handle them which is completely broken. =20
>=20
> No, any media can report checksum / parity errors. NVME also seems to
> do a poor job with multi-bit ECC errors consumed from DRAM. There is
> nothing "pmem" or "Intel" specific here.
>=20
> > > errors in mind from start.  I guess I'm trying to articulate why
> > > it is acceptable to include the RWF_DATA_RECOVERY flag to the
> > > existing RWF_ flags. - this way, pwritev2 remain fast on fast path,
> > > and its slow path (w/ error clearing) is faster than other alternativ=
e.
> > > Other alternative being 1 system call to clear the poison, and
> > > another system call to run the fast pwrite for recovery, what
> > > happens if something happened in between? =20
> >
> > Well, my point is doing recovery from bit errors is by definition not
> > the fast path.  Which is why I'd rather keep it away from the pmem
> > read/write fast path, which also happens to be the (much more important=
)
> > non-pmem read/write path. =20
>=20
> I would expect this interface to be useful outside of pmem as a
> "failfast" or "try harder to recover" flag for reading over media
> errors.

Yeah, I think this flag could also be useful for non-raid btrfs.

If you have an extend that is shared between multiple snapshots and
it's data is corrupted (without the disk returning an i/o error), btrfs
won't be able to fix the corruption without raid and will always return
an i/o error when accessing the affected range (due to checksum
mismatch).

Of course you could just overwrite the range in the file with good
data, but that would only fix the file you are operating on, snapshots
will still reference the corrupted data.

With this flag, a read could just return the corrupted data without i/o
error and a write could write directly to the on-disk data to fixup the
corruption everywhere. btrfs could also check that the newly written
data actually matches the checksum.
However, in this btrfs usecase the process still needs to be
CAP_SYS_ADMIN or similar, since it's easy to create collisions for
crc32 and so an attacker could write to a file that he has no
permissions for, if that file shares an extend with one where he has
write permissions.

Regards,
Lukas Straub
--=20


--Sig_/bO7uynQmFI27w4fHadpypym
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmGGMboACgkQNasLKJxd
slh+lRAAmqlkYqSnahrbcMNcIf/3kQ4uICysOb5Of52uTw3AE5Zg5scO4Znz1I4i
C9VdaWeKGFRS80+qPZG4yl7RKXhJncImtTa58DIZH600g2Y9ZKezU/n3fT3Ucqt0
Qer/iVBgFfx7Gg4W5ecdAGoA9yvyftTlKrPYwjB2NJxEBx+jlJW7uFpFeNUCn8KE
mi06wFpQE2AgvXzLwkemXopL1IX/MNJLZlnayfRuaUuC98WCbhNdUfHb57NyJge9
iaHXtYeIoq8F8z/nCiV5lxjSbxXmG3Kjf/7/GhomNfKe4inPSNdg0+Z2rPpyXQ9s
Svfo62cr0hpLQXe8rrtd6gGQ/Ya58xpc3Ty8+n5uvJbDqE+OXWbJJn/K2q/sEZS4
RNMqhIj781hbQ3jjTOfZhgEkUDw3H3RZziGSPLWUvYLN2YSxtzi97x/ECPZ6ZMEa
HlamKMVDk6jOcbYGcn4wJw9QME8AWfezsOD32bE96iLO3zSFPAf1kv3k+rPZNDIB
OviD9ZIz8gunPk/Zb9rycvLyKgkMF1iGo7sCl9PQiPnEb/xuCfsRQut2DD3YQLFO
b9sbSP7ETTQ5YeTTm3SKl1X+6PBl4Jdhm7KhPEwhGJzuh3UQqHbrEns1EIlmDXhE
GVpiyzVzqx65VlNc78VMwO6qyrWuqf0VKV5EObIFQ5v0oXjKXgw=
=PyLM
-----END PGP SIGNATURE-----

--Sig_/bO7uynQmFI27w4fHadpypym--


--===============3083569891154831329==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============3083569891154831329==--

