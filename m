Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C3CC433F5
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jan 2022 20:35:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-TTt9-b6pPkyDLQAeiV2i-w-1; Sat, 08 Jan 2022 15:35:29 -0500
X-MC-Unique: TTt9-b6pPkyDLQAeiV2i-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFE6384E253;
	Sat,  8 Jan 2022 20:35:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE4275E482;
	Sat,  8 Jan 2022 20:35:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 689844BB7C;
	Sat,  8 Jan 2022 20:35:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 208KZLiX014453 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 8 Jan 2022 15:35:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD48B1120AB8; Sat,  8 Jan 2022 20:35:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7221112131E
	for <dm-devel@redhat.com>; Sat,  8 Jan 2022 20:35:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C80DA85A5A8
	for <dm-devel@redhat.com>; Sat,  8 Jan 2022 20:35:18 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1641674118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjuB8Rqq5dVc5YUlxoNmQrTqz6XNY1G4HU8qapBvjCg=;
	b=lrvO4GixshLDriqt/PN7FZYud4MmQRRYU/9UWvYAsg/aAsX7v9HV1F23vLoomR5bhW/6Os
	6NZvxjZfZKoQJbRUE31JTpU+F5nihCcw5LCEnQSAWjCIqoE+paBXGeEWvvrI7ka0TN6XOD
	YYUjHOi98FXHHjqm6z3MhZuevdtpSvVQUOO4RVV7hvUMBe8tU0Y1jrhccS55i4C+HW4bZE
	+x0PEfiUu2zgH6Zi5wTccTrBAgZcarQeHsPEIGqPUBRhL5hhS9NIr6JwPc2w3bF6YNn8LU
	bBelX/W5BeiIiWdpvieFzP0ESV1rHcohv6n5eALYsVvs7oUlIwIFhtKLjuK+Dg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1641674118; a=rsa-sha256;
	cv=none;
	b=CNxKerJMcq8pRubddFcEBk3DyIbga6tQj3EZoH5UCTeMqgn1u4TS6B3he0LmSzX00sFmnw
	7isAaeEm0HQ1fxPADU9ocrAjx4Jdt5FADjzMtL/NulKDw2IBsfJZCQRmYSyCeEySuPoFkY
	rB19nYvmu0WA9UBbu89Ln1XSWRuYhg/EznQJ3xOG8jXIsDORTFKCIeRBkhIxvVwIGGpp67
	hFVXKJzr9YLhtkXxvUzsH8MvR9jBNpXiCpKjyhcyiarzp05s/1EnIq6gDXglncrgRIGk9G
	ropq18+eRv3RZoFDhUspS+vTyMND1c1fKYk7l84w0lxMKYmKiym21GQo8jxK/w==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=R3gNIefI;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.3 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
Received: from mout.web.de (mout.web.de [212.227.15.3]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-253-r77uT3Y1Mbyi0W5bVzVUig-1; Sat, 08 Jan 2022 15:35:17 -0500
X-MC-Unique: r77uT3Y1Mbyi0W5bVzVUig-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1641674116;
	bh=QFZg+bg1P8kqTX2//hD6BrVKJC1HEPIw1TpHP7jDhuQ=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
	b=R3gNIefIdTDkWI8f/Slv/CUdLeUAhVIUatc0Q3/kSWr9EFcwX1Et2R7Nf4BdZ5gC9
	27/R5QRkcZdgdT1U0x6kZL7efab4c3Zk3rcpcZ5ef5ulS9GM9WwkPpzwu/BcAqeOR6
	TVRLLkL1qPRA4BCsHYMz+gRXgW6NU3FtuqCXJTsE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.24]) by smtp.web.de (mrweb006
	[213.165.67.108]) with ESMTPSA (Nemesis) id 1MOUxu-1mjfQB0CkA-00QH8k;
	Sat, 08 Jan 2022 21:29:33 +0100
Date: Sat, 8 Jan 2022 20:29:22 +0000
From: Lukas Straub <lukasstraub2@web.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20220108202922.6b00de19@gecko>
In-Reply-To: <20220108195259.33e9bdf0@gecko>
References: <0535d6c3-dec3-fb49-3707-709e8d26b538@gmx.com>
	<20220108195259.33e9bdf0@gecko>
MIME-Version: 1.0
X-Provags-ID: V03:K1:QDvD7CzCcfEct07ZG6h2ro0ZPpjryenoHtIY5TobsDPGc/+cmT0
	2bko9etukW3oeqt/RGAIGu4AcwhGoH1PawViXyai8IvWS8f3CPfADXijS63sl0l/80ZgOp9
	VQmsnTwoW0807gbb60fKng7c1gXi16moKPeBs909k6OCDKgQHxXUPY04fSDXNr0xrBlBRYc
	k8ZpcHwdBoafussgaVxXw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xCLiMgj1JrI=:+5W+kOEJvD8TRpB9KCNua7
	QCuKDF7oDf0N/uyclB87h5S991tP0U8YpUPX9undWkNRGtTKnC2wqvCNALdAVl6mong3jAL0I
	bDhcdhMC6yJFOeB2umTDPCuOPK23FsRG7s6PEW19we2pdNV55RbP3syqimAmlVQFw89YnTimx
	74EhcX84o1lYip/7F3k8OXOzf7itdxMfYdAC66nyxj+gSkpqtVvp5sg4pliiygt8qChZySnG8
	R5MrdGaJjpOynDZvCWVaxWit5sZNkYX45CWyzGBbuaFp2sobSmfsUmt2H0SiwencBW73kk+X2
	fuyFFBxYaQ0ZlAbzfM4VEdLLdgPmuALnPU5OXimoZsE77bGtwsWIYIlL4ZLRsPSln02vwbh9F
	n2EdrjKgn7lDhZ5RVbo3h1hpmQDPteFXxe5WzbYQD+j0bUfIh+G60W9HUFDX5o+uPflUjl1kN
	bOC481v62tMgI3yFuYnz9X8m6v6JP0vlROSs1haKotVHLjF6p4hl9V14EmlBs5FrZixFw9l/E
	pPlC17+u4ERkWXcciKw28XK2D8wmkR5CSU1Su+GnjexnRsiHYdSDiVOmNwDDiKd3zG6ZRmuVg
	BL5XCrElCXgCCV5c6Cwims3Deu4vyA6P+7F42949EKN53QRWkYMh2TV6NuzKlMBv050ll5cFy
	QRYOLgSccKXFp2oRZFEqKGqUBOpXmXREI2cY/HVvoIIGDDFh4UlamGdwleOxYaEaCVH9EUIBj
	A/W0C3WnCTueiuJMato+Kv6rk7ve3awMXujaLIEjDN2rc2gbMtjLrT+PSCX//LxHMxxKFz7sm
	oF/9jS4DCkyhZOFRoIAl3dsDkgMPvD2D7WewTcRHCZ8BiMBA5f1axb8kCKDlvpqVAN1WwuErU
	wyau8nv5mLyzGa47o2ELqEWaYh2q2131snTJbYKLWYWipXO5VEoZuRv9wrtCUIR7IqE3/m9In
	FBxfaYPhlZqN9OCmkE62Ol9XUCeLqZCJDBhiK1ttXfnAdmi9jEMzo9dYaNBMCEaYLDSZGPazy
	0OJF14IdvRekbxWw9oVVwDn8GglmF2S4DFq964aptKBc+yOHzZG+ILXrmJEH5AWxKeG+vfVBn
	HPO/P5J994+UH0=
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=R3gNIefI;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.3 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
X-Mimecast-Spam-Score: 0
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
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [dm-devel] Proper way to test RAID456?
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
Content-Type: multipart/mixed; boundary="===============7949674497893539950=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

--===============7949674497893539950==
Content-Type: multipart/signed; boundary="Sig_/bleRxGKigDWXtjWdAU2Z=W3";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/bleRxGKigDWXtjWdAU2Z=W3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Jan 2022 19:52:59 +0000
Lukas Straub <lukasstraub2@web.de> wrote:

> CC'ing linux-raid mailing list, where md raid development happens.
> dm-raid is just a different interface to md raid.
>=20
> On Fri, 7 Jan 2022 10:30:56 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
> > Hi,
> >=20
> > Recently I'm working on refactor btrfs raid56 (with long term objective
> > to add proper journal to solve write-hole), and the coverage of current
> > fstests for btrfs RAID56 is not that ideal.
> >=20
> > Is there any project testing dm/md RAID456 for things like
> > re-silvering/write-hole problems?
> >=20
> > And how you dm guys do the tests for stacked RAID456?
> >=20
> > I really hope to learn some tricks from the existing, tried-and-true
> > RAID456 implementations, and hopefully to solve the known write-hole
> > bugs in btrfs.

Just some thoughts:
Besides the journal to mitigate the write-hole, md raid has another
trick:
The Partial Parity Log
https://www.kernel.org/doc/html/latest/driver-api/md/raid5-ppl.html

When a stripe is partially updated with new data, PPL ensures that the
old data in the stripe will not be corrupted by the write-hole. The new
data on the other hand is still affected by the write hole, but for
btrfs that is no problem.

But there is a even simpler solution for btrfs: It could just not touch
stripes that already contain data.

The big problem will be NOCOW files, since a write to an already
allocated extent will necessarily touch a stripe with old data in it
and the new data also needs to be protected from the write-hole.

Regards,
Lukas Straub

> > Thanks,
> > Qu
> >=20
> >=20
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://listman.redhat.com/mailman/listinfo/dm-devel
> >  =20
>=20
>=20
>=20



--=20


--Sig_/bleRxGKigDWXtjWdAU2Z=W3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHZ9CIACgkQNasLKJxd
sliGvg//T1egoa1W0T4PFUsHLBQ2VCuxBKRczSVau4rZfncHaDA8bkax/al0uBbX
6W5b0nACUL00ZD1QNPEijVP7p4DvAF7I8TRY+WNnZaQmH1OupPI5PNU3KEPrj1at
EkcYNcCJrsZo2D4PitXjU9gt8/UNtbDPh9UROm3psGq9zmK3tFUfmoDmZK9ceVq0
2jecB9uEfQmZBAQLo2Pb+uSLbK6z06K0KkBa2Urt9PPXlJUJ5RD2IHz1+yJbp5hs
N7AqjoD9WPimSftQ0pLYGtUUVYFNc1KA+BXbE1JevRVlS6DdllDhYnmOWNk6Oqgv
yqRRbDZ4UirZsUBMt2HKXjKKZehwMErJ5bO6o2BaH45XpPp1cOrSOR7EV2T4B4sZ
oz07FuxuK2cnDyRGvZlJ4PmXyWRZBg1o+RYKCMJ/niSaRfhWEHX55b7wmJIpoqDd
0eBkNHPHr9SU395BJ25qF0R9oWpixS67BZ5cYuMp+jFuOW3miXcYMaatLN2SXzNH
bQJmaO1P109JCaMOjl39SSiMAT53v5B7PiHbBHOAGOi7s8zL3l0AEqp89QSrJWF2
v3MqSHSyuQqjZbNh0zhC0WH/URErmPb3gzDDQwIHTt+k1pe9XSa87C3Im40y+HQT
2Nfplumm4U8wqXoTdKOQXcHbyH0RRxFEXtwGESls/jwLFUvuIMA=
=DIxA
-----END PGP SIGNATURE-----

--Sig_/bleRxGKigDWXtjWdAU2Z=W3--


--===============7949674497893539950==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============7949674497893539950==--

