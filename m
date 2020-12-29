Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822ECC433E6
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E795206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E795206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-3hKe6R6BMkO3t3_eH3bANw-1; Mon, 04 Jan 2021 14:04:03 -0500
X-MC-Unique: 3hKe6R6BMkO3t3_eH3bANw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24B9C801AF7;
	Mon,  4 Jan 2021 19:03:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05FEC6F927;
	Mon,  4 Jan 2021 19:03:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CC1635003E;
	Mon,  4 Jan 2021 19:03:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BT9qmdo015888 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 04:52:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B49852166B28; Tue, 29 Dec 2020 09:52:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF9DD2166B29
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:52:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F054800183
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:52:46 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1609235566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Onyfrxv8O+yGNVGuoQH9CY4WCluAevuH9UHb0UBkuHs=;
	b=Q6IvZtxbv3lIfpPXZZcTxp3ethtdRBPpfMm3V//i8jClbI5HwpFm6stw5FowwDLRg2cAK3
	IdBK4ClP892/Wyjo52r7oKPp8QKIBf5hju5bIzitsbR7MlGCwgxBKNX+dzEMOwX5vAGXTK
	Q9aD2cRRCYR9SAtJrEAseDweRhkcQMuJpElzYCtvIVVNBVrw+GcnT/UwD00jKPLz/DnBxC
	OQUVLH/rmMDD9Z/F2RWC2QKdGcZVd9nvaLMstHMokQku9DXsJTa0KC9FAWPaXqIcHfpk/a
	gTjR0EpszGFEcLdk8fkMjRLgBr/Zz3hhzt6zT46tFw+Sw82yJRoX6rwyi22V6A==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1609235566; a=rsa-sha256;
	cv=none;
	b=XNb6ZL/1qqUPJYUrW3g5lhcE/yNsgj+ImLxsmaLuuHWtenmbz2vLlu0N9WuS3CxwsnkQbn
	ufiy2/DDXBm+3Tw3BPEvjt+ITBfWALzUY2bL7q/gtf9YQuFBqDsXLilm0Gd3vqY1RCGdJT
	LU44bOIMqluJGB5xzrA6zBF+vIqaEPVuwYYRmVsXP8AOrP6B7Lc752XB/0ItUPtK8Ma0zb
	B+xkysQA4yiHKCcFn6vbKichoRBD9K9grFlj+GofZhFoYAJlLzCmA6qjMMSCr7m/3VdmT3
	IfC+TagKle3ddpwE7T7rMDdRBXRzb1sLx8zkF9+H9fMGg6H+xGDL5zZrEXyIFw==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=V27w50DN;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.17.11 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
Received: from mout.web.de (mout.web.de [212.227.17.11]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-283-rKdbTlMZOMGu5Hkgh9qhTQ-1;
	Tue, 29 Dec 2020 04:52:41 -0500
X-MC-Unique: rKdbTlMZOMGu5Hkgh9qhTQ-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1609235559;
	bh=j1Cvhgjj4+j6EH+E4Epji9YzK92OlyvfhvECnn2jGu0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V27w50DNuGsiJyOdMyhSaRcr47LnL8M72ghvdL2KLLUCVPdCvrSeNJTpLkokSBVRY
	/sY/+N1hgFv4o6shMXTCpBGTfmfrkZl3nxEnOFFQxHqmhVL0G0g9uGfrCO8qIt0K8N
	G5uR2ODRekOf+BrOnb+OLysVVNBlRXkTcajWaPlg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.88]) by smtp.web.de (mrweb102
	[213.165.67.124]) with ESMTPSA (Nemesis) id 0Lz3BE-1jyjU02g9g-014GWe;
	Tue, 29 Dec 2020 10:47:36 +0100
Date: Tue, 29 Dec 2020 10:47:27 +0100
From: Lukas Straub <lukasstraub2@web.de>
To: dm-devel <dm-devel@redhat.com>
Message-ID: <20201229104727.3b828165@gecko.fritz.box>
In-Reply-To: <20201220140222.2f341344@gecko.fritz.box>
References: <20201220140222.2f341344@gecko.fritz.box>
MIME-Version: 1.0
X-Provags-ID: V03:K1:FVsPjWmIc0UirreRO3JoMHlAuAHmiR2ovYEW4lcnNxiE9vwztH+
	9srRYXAGRF28EGLiHnZwk43dixPIEczg7e/NYhsjDBAkMJrS6vdPghCfxj5124cgMKFJfu2
	uvc6zQMblqBT4D68k+Nr3FbKLg346OZPfCzrOEnVS2Qu3iq32LDKLwqwYhDxdMcuY/npOu+
	Z0//H2PvOATBxPnH1j6UA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3FEyFAwyHQM=:KleKW6ZjnKkoxvTXW5DlxN
	pYrza5hbIkJ6IJm5ctel/IN52LdVWzhYqasCCv9bfw0Kq2VjbGMBxnMsRTsRY6P+uAF/U8ay7
	+75HPE5TkyHkseCTV4KIlwqr4dztHx5y8868RKil7UU5YaDHolrL759pjLDDh1Ce+Z4+JQ0+z
	K38DfSevF+cu5IKxhbBPeWnlVUgdtN8plM2TRcfX9k08hoycGmaH/SV1Lfs5v1PeOBSpZRe3p
	YOWJdj04KQrQXSmVD7Izmfnc2g8eJxJk0UxxYd0nyecEDErreXeSHnPMzhJU2O6FyF2ULONnA
	J3eJxj2ymUQx+gIxsGXZnYdP3dAf6/CUOK+HkzzWIay+hgWFUFkurrZEfqHeFajwxxQFINy2D
	zBzj9CEPB2U7xhTZGfG1Ry1owjBORKQJTygO1uVVMEk2GrbJIoVVcPTpjBL6crWCeq7lQUxi3
	n7wHOFIY9DzEf9Pbyk6ZclV1tI+LWCge0HNOvdtl/+rsMVZ5SGNArE4v0YY5AfTkjyp7GlSUj
	0ASmywgkMVKEon+SIvve4YaQltPNRzF0hA38P7XEO37cCBI0j3wNkhPsrpSc4it3phKok5VSM
	8BDgZNyyvoBAgV3tq8rzGoxZt5v4XiCYCL5HimrwuabIXtVXKZW7djB9Ad4ANMQW97meQ4RM9
	3kLQLkA0uNAuno1AWUIWYJzVvv7B5zJoCUiIb5Z7HFZil6nXlQ9k/CZ6ykCuJATH94Ytn4EPA
	+GYF/+T7uZ+bbRE4ibA/mTWEomjk0HuJTR5IAQ0wXINVMur7Qk2JKn0s1x/X5W70+SYcE/NAt
	k9ZNhGj/PMNeN5vclQpmTQnnNXvOiAu410+V8jN/+pOP9NQDGn26gUPwGn9GhRrWF+EA0tlQX
	kEkhBUKeul+mIQ0815mTxI9G1U2fblB4jfWQQcXFI=
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=V27w50DN;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.17.11 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
X-Mimecast-Spam-Score: -1
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-integrity: Fix flush with external
	metadata device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7352154839735412175=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============7352154839735412175==
Content-Type: multipart/signed; boundary="Sig_/FJoFZz46L.FQLvX.ny/gC_k";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/FJoFZz46L.FQLvX.ny/gC_k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Dec 2020 14:02:22 +0100
Lukas Straub <lukasstraub2@web.de> wrote:

> With an external metadata device, flush requests aren't passed down
> to the data device.
>=20
> Fix this by issuing flush in the right places: In integrity_commit
> when not in journal mode, in do_journal_write after writing the
> contents of the journal to the disk and in dm_integrity_postsuspend.
>=20
> Signed-off-by: Lukas Straub <lukasstraub2@web.de>
> ---
>  drivers/md/dm-integrity.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 5a7a1b90e671..a26ed65869f6 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -2196,6 +2196,8 @@ static void integrity_commit(struct work_struct *w)
>  =09if (unlikely(ic->mode !=3D 'J')) {
>  =09=09spin_unlock_irq(&ic->endio_wait.lock);
>  =09=09dm_integrity_flush_buffers(ic);
> +=09=09if (ic->meta_dev)
> +=09=09=09blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
>  =09=09goto release_flush_bios;
>  =09}
> =20
> @@ -2410,6 +2412,9 @@ static void do_journal_write(struct dm_integrity_c =
*ic, unsigned write_start,
>  =09wait_for_completion_io(&comp.comp);
> =20
>  =09dm_integrity_flush_buffers(ic);
> +=09if (ic->meta_dev)
> +=09=09blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> +
>  }
> =20
>  static void integrity_writer(struct work_struct *w)
> @@ -2949,6 +2954,9 @@ static void dm_integrity_postsuspend(struct dm_targ=
et *ti)
>  #endif
>  =09}
> =20
> +=09if (ic->meta_dev)
> +=09=09blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> +
>  =09BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
> =20
>  =09ic->journal_uptodate =3D true;

Ping...

--=20


--Sig_/FJoFZz46L.FQLvX.ny/gC_k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAl/q+y8ACgkQNasLKJxd
sliKPw//cxjIm5kE6MLZfBl3CrFDEB/i8/AQCNXvIi0tN82zkkXbfzQdvZecz49l
oyatria9VANwzdPzo3ghbrAaRrsEMO0xAvDiwGQxEiDeOaRyxmtBilZgN5eO13bM
gEsV3+2jF0vlaZWBKv7OpBkwEgPFyl3K524W4UuHBGD0gmm1eBKxa4XVANCzviOX
xjjLJQ5sdsW+4/kTL7jPJDrm4y86csxWnZRYUpHHuraK3thS/0cTXHiNrsJtQTc8
PjokaOI8gXLjbmrRO1lEWe7BS/gpgg2KSITu6HOdwKt448BOWE7ZSdUeRCLAxsev
owFAR89M0akZBZREfqBeCiehjr20yS+HTM/QPBhZ8fZAykWI8Sh2JhqXL3Bkdm1T
kpr4aNoSdoBcpDUInrE7kK8BWHNDb8HgZEW+9lHo52zDQDsuMtvkQgpF82Ao3cPL
4sparoyL+H/0Bf/IB6GT2dIyka1AMtc47qbLf15XrWpOMbAIfcwHCT5lNON6vyK7
jb3EXszlJVr2T7yj/LjZtevXS6NZev1nEiCg56LchvtJR8408325C0LzI6QWDesf
NY4BNhML8lU8K54XmT690gS/eo1+16eCFu6Lt/DLD8Rw+SbARSMDkpo+gJyzr7Go
caXPQRwxjfhNx5wY9dD/54nxtnX9VnK4MmJDdRc+EyrBEbNew6I=
=dk8y
-----END PGP SIGNATURE-----

--Sig_/FJoFZz46L.FQLvX.ny/gC_k--


--===============7352154839735412175==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============7352154839735412175==--

