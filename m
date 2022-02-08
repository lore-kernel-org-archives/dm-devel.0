Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33DDC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 08:12:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-ffu-_xcXO6q98M-ginM00w-1; Wed, 09 Feb 2022 03:12:07 -0500
X-MC-Unique: ffu-_xcXO6q98M-ginM00w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA8251019983;
	Wed,  9 Feb 2022 08:12:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0C625BC5B;
	Wed,  9 Feb 2022 08:12:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DE3251809CBA;
	Wed,  9 Feb 2022 08:12:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 218L3Hbx032615 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Feb 2022 16:03:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0A0D02166B16; Tue,  8 Feb 2022 21:03:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 049A32166B48
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 21:03:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01A621C05AFB
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 21:03:11 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
	(wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com
	with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-369-oQtM7BYBOHWWqm_ZS2nKHA-1; Tue, 08 Feb 2022 16:03:08 -0500
X-MC-Unique: oQtM7BYBOHWWqm_ZS2nKHA-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.west.internal (Postfix) with ESMTP id 105543202255;
	Tue,  8 Feb 2022 16:03:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
	by compute4.internal (MEProxy); Tue, 08 Feb 2022 16:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DIkbOFBmbUGur4wua
	Kfii0G8UH/Nq6ecEvh000YVJKM=; b=XExIgpUQ3HkvwmyOnFotDGjK79vDuTqaR
	t+Un0aYhr8GNzzQBjNX/vStSlMN4Nx/xu+qGmzDHC+3/EI2R/ctajvBu/927MFLU
	/1wTI3nEhxG1FN58sXPIM9qwNPFAOv3M+by4fGoeglIzcoDNMy3FYg0ROjyG9dLm
	kehri7VQqKs/kWQIIKB0L1waZsh4M7dy/lL6RI79PAaU23PqFJN4TnqHjGaTZeOG
	4Qs1gBxmd0feIg2YZ8FRZCkcYkHwlSGSIbNaFJpaoKmPwkjHu1A7ROZRbIyB7/Bu
	uwE/SblIRHkBsgJ6hdFNpsWeavGcaEneZ/XfZMhstqK0iR+oLXI9w==
X-ME-Sender: <xms:itoCYhqeWKri4uVCVD-eY11rU6Ui7Bhc5CLWahxGjLYi40FsGzMeow>
	<xme:itoCYjrJtLlJuujBGWUAfd0fT8K41j1WEaabyMoSIYj9ELN9Zt_k4x_3zNCw6pVC0
	FwUtHcbMLv3uXc>
X-ME-Received: <xmr:itoCYuMhnEMvWBE_4YnfzL5XbYJpE5yzUj1KLljHv4VfioIVhGg3PI9rVKBDC9QnbfQrTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgddugedtucetufdoteggodetrfdotf
	fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
	uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
	cujfgurhepkfffgggfuffvfhfhjggtsehgtderredtfeejnecuhfhrohhmpeffvghmihcu
	ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
	hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeeukeefhefffeetheffffeftdeigedv
	leetffehvdekuefhfeduteetfeetvdelhfenucevlhhushhtvghrufhiiigvpedtnecurf
	grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
	rggsrdgtohhm
X-ME-Proxy: <xmx:itoCYs7LE2xyhApXj6PXqmgbWiuc_GznCo2eIlKejcPuf0W_quXcAw>
	<xmx:itoCYg6ftI_Ys4eC9GZtVPGDbEQFWs-2juIIjkHGYEpnIuX8BnOBZg>
	<xmx:itoCYkjpnLw9dFujCPLYQDIyI_HxaNXROQXglCziQGSdGUdfDeEUMw>
	<xmx:itoCYgFA4yAKuu0qnjfWh46yD0Fh54GCep7yQnn1IGFA6hOdpadQpQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
	8 Feb 2022 16:03:05 -0500 (EST)
Message-ID: <733f87f3-5ed9-b266-b951-4526f872bad1@invisiblethingslab.com>
Date: Tue, 8 Feb 2022 16:02:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
Content-Language: en-US
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	LVM general discussion and development <linux-lvm@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
References: <YgK+Avj+VURDqo7j@itl-email>
	<9a14a7a5-a8a1-a4d6-f9fd-012d3c170f2a@gmail.com>
From: Demi Marie Obenour <demi@invisiblethingslab.com>
In-Reply-To: <9a14a7a5-a8a1-a4d6-f9fd-012d3c170f2a@gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 09 Feb 2022 03:12:00 -0500
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= <frederic.pierret@qubes-os.org>,
	=?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
	<marmarek@invisiblethingslab.com>
Subject: Re: [dm-devel] Thin pool performance when allocating lots of blocks
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
Content-Type: multipart/mixed; boundary="===============0676031080906658772=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0676031080906658772==
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="------------vGGc1CdQiVCEEy26YxeSaoWa"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------vGGc1CdQiVCEEy26YxeSaoWa
Content-Type: multipart/mixed; boundary="------------tomwkswKn8t6bL0N0O9LU62C";
	protected-headers="v1"
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	LVM general discussion and development <linux-lvm@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= <frederic.pierret@qubes-os.org>,
	=?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
	<marmarek@invisiblethingslab.com>
Message-ID: <733f87f3-5ed9-b266-b951-4526f872bad1@invisiblethingslab.com>
Subject: Re: Thin pool performance when allocating lots of blocks
References: <YgK+Avj+VURDqo7j@itl-email>
	<9a14a7a5-a8a1-a4d6-f9fd-012d3c170f2a@gmail.com>
In-Reply-To: <9a14a7a5-a8a1-a4d6-f9fd-012d3c170f2a@gmail.com>

--------------tomwkswKn8t6bL0N0O9LU62C
Content-Type: multipart/mixed; boundary="------------J991s0grMXKVkyL81RffJdDF"

--------------J991s0grMXKVkyL81RffJdDF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2/8/22 15:37, Zdenek Kabelac wrote:
> Dne 08. 02. 22 v 20:00 Demi Marie Obenour napsal(a):
>> Are thin volumes (which start as snapshots of a blank volume) efficien=
t
>> for building virtual machine images?  Given the nature of this workloa=
d
>> (writing to lots of new, possibly-small files, then copying data from
>> them to a huge disk image), I expect that this will cause sharing to b=
e
>> broken many, many times, and the kernel code that breaks sharing appea=
rs
>> to be rather heavyweight.  Furthermore, since zeroing is enabled, this=

>> might cause substantial write amplification.  Turning zeroing off is n=
ot
>> an option for security reasons.
>>
>> Is there a way to determine if breaking sharing is the cause of
>> performance problems?  If it is, are there any better solutions?
>=20
> Hi
>=20
> Usually the smaller the thin chunks size is the smaller the problem get=
s.
> With current released version of thin-provisioning minimal chunk size i=
s=20
> 64KiB. So you can't use smaller value to further reduce this impact.
>=20
> Note - even if you do a lot of tiny 4KiB writes  - only the 'first' suc=
h write=20
> into 64K area breaks sharing all following writes to same location no l=
onger=20
> have this penalty (also zeroing with 64K is less impactful...)
>=20
> But it's clear thin-provisioning comes with some price - so if it's not=
 good=20
> enough from time constrains some other solutions might need to be explo=
red.
> (i.e. caching, better hw, splitting  FS into multiple partitions with=20
> 'read-only sections,....)

Are the code paths that break sharing as heavyweight as I was worried
about?  Would a hypothetical dm-thin2 that used dm-bio-prison-v2 be
faster?

--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
--------------J991s0grMXKVkyL81RffJdDF
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=3Dx+Ro
-----END PGP PUBLIC KEY BLOCK-----

--------------J991s0grMXKVkyL81RffJdDF--

--------------tomwkswKn8t6bL0N0O9LU62C--

--------------vGGc1CdQiVCEEy26YxeSaoWa
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmIC2ogACgkQsoi1X/+c
IsFaRw//cG9prIY9FF6bJ+qVw3qZUK+R5X5egf6DK/iKejzsLiQpFlmuqhLTdryA
VmpLbJsdKzC+vQCpRgzsSFQR9oPCxw6ioKTcUAkcL+HPQCZjMVP8GxBVYO0Zx68m
8mueFlcGsKnSshXVlFwgXdm3mKj9ucNB5dnOS14EY8VVrvSwfPC3jyKFkWOF6HnZ
LXXfRa3TIHditYlHowGRDYJIrBVTUKIqnGbnHAJf8TKt94JUjFWd/V5AwedeB273
E6prwioaTWNiLPUuCldOwg1ZmTvx4rjhX0gH2NiZ++69SrYabhpkMUv75FRxIaMY
xPsNp57Oi8RHb+Oqkf7fo51jMWZF9zpVzyR9XHstv9sfjXrINqIlBELxotTwpoix
lZbwkL+lHu6Os8cdVjtZ5uYHhD6VBdBJvJ3+YwhKH+DIAT+soBDGaD/gOMD2vnL1
ynwPfplK/osWDQ9VpV2FMNhkrJHE9H9GPw+2SBIDJr3SHA0M1/2ynkB0dlh6QkyJ
9Rh9eze4bE29ypsUSCauszycQHlYW+yQ6yKl855w4TkMlO0fbeR6dJK+r9CgTZxT
YcBNWnjjAZUSPqHzYzvKOjh8d2MLohwA8L/11KpgW7EHTjdy7tu33ExYqQP9JNrL
79+tx2qIWhF8F1AifX0LqH+ML8zweKFLQAGAMiRsdAsHWHaK8Kw=
=5VlF
-----END PGP SIGNATURE-----

--------------vGGc1CdQiVCEEy26YxeSaoWa--


--===============0676031080906658772==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0676031080906658772==--

