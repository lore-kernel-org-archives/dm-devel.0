Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B07C636D4
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 07:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675842327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=+Of4Ulsk9cuiRke6nKAP75oBe9bpO36DrNPu/dwcD6U=;
	b=eEZRO4zGneWplcf7xOcevcomiU6rT2zYYqlF4YJvuFAC8ZUx/iOzLpUjGgfXutmHJnoeU5
	e1teLyKF/nkZolZ0a7U67WVXSEPXLvF73vZOoJEidWq1qWXEz+qBzFPQwQwc+hU25kszHe
	imJIa5kWsdUPorIsTR5YvvcyiTK2FME=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-WdKGFaf0OPGapsh6rZHPJA-1; Wed, 08 Feb 2023 02:45:24 -0500
X-MC-Unique: WdKGFaf0OPGapsh6rZHPJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37F1D3C02543;
	Wed,  8 Feb 2023 07:45:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2352018EC5;
	Wed,  8 Feb 2023 07:45:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5217319465A4;
	Wed,  8 Feb 2023 07:45:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 472821946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 16:19:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1EE98401014C; Tue,  7 Feb 2023 16:19:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16F1F4024CA2
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 16:19:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECC6429DD989
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 16:19:29 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-36Tw4rVwO-Wk5ieAJOYcVQ-1; Tue, 07 Feb 2023 11:19:27 -0500
X-MC-Unique: 36Tw4rVwO-Wk5ieAJOYcVQ-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id A9E78320016F;
 Tue,  7 Feb 2023 11:19:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
 by compute1.internal (MEProxy); Tue, 07 Feb 2023 11:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:references
 :reply-to:sender:subject:subject:to:to; s=fm3; t=1675786765; x=
 1675873165; bh=KrfmSrDkm//BSwsEycuDONuPAOVzLiga9Uqg5PG0Wpo=; b=d
 OtoLEwCndNUNNfu+mAZmuiJh5dhk7wK2Ax1nY9hBBMnjzFjZxrrEUmWD7j//RexS
 dhl0LnKhuMd9m8z5d+DkpveJ45g4IImZaz6rkocvVigCBuwmoAVPPDl78lw+7q3b
 VHYWS6HF6KhgIgBGSCi7xQ8R8Qfgl4XZWtL8AyXXFKjfxo6pkLAUXOedR/sJ3w5P
 oBz1WVyEl6vsyb79UOd94kMnrAZJMHvBVoD1/2Q03dM1CIzmz53J7PDIdgxtb36m
 kyaiDLR3LUWG3vSkKVMZXTOJCcybnqhErD76guRN1GhXi6+MBO2kQMOVWJFfN87j
 6yW4UWMq1nYWegBR6gVuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:in-reply-to:message-id
 :mime-version:references:reply-to:sender:subject:subject:to:to
 :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
 fm3; t=1675786765; x=1675873165; bh=KrfmSrDkm//BSwsEycuDONuPAOVz
 Liga9Uqg5PG0Wpo=; b=DQlyYVXQamLdndjZR1/V7bBTpBiXNyW2+w+zIJHrYCv1
 rsRrgRvznCNE/vI4B7+4U0QMbVwv/3oPoLWB2pqfvahKfjQO5Q67NjvA6n+2nRVH
 TyX4nDgcuOCZjzVnnB/e6sJKF3Rnjbd998UM3NP+egulN+Oxil+Yd5W38zw6U/LQ
 pKRjiVp1gR0KeabFmDFQcv/xjN5uRPHv5PdFZrdITMn70CfDbOlotsoUpg5dtjkK
 fs4/Tv3KaUohoVjmzB8MgKp3eln8I5C/x6IYpRmR7QuEk6TakVS+lZl2YiL4aQLs
 iHKiivvJuxFPzj71obM11B/ESj9o7pXk6U/e5szU0A==
X-ME-Sender: <xms:DXriYyBDbgqpat3Jk2biqZ9Nb_SKRZWbw7EoereqxAuREpA9dd0Zng>
 <xme:DXriY8hwt2ojVITKISaVzYIWgQVBdXOMeIgWeJMaYH_wzTeYG7gxmHe5CR4Blzp9X
 wioFQBoIVNuChY>
X-ME-Received: <xmr:DXriY1kNL581gjeick9_HKeKE3vQU66urjZODwvZE8N--pG57Px8MtdeJY8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegkedgkeegucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepudeileefueetvdelheeuteffjeeg
 jeegffekleevueelueekjeejudffteejkeetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:DXriYwwR9s30cJkCtOSnUSn3VcHm2PJYlh2y2FrZPvZp76RpyAgc0Q>
 <xmx:DXriY3TOaSBztWGuKHSrZXhC4Yp5zkoxaUvVGp-I_ow1XIK0QFrwPQ>
 <xmx:DXriY7a7X0hRXZCx8JLKlFkHz28Sgx10X_Qgwk9SIb0Kc9bsOsfugw>
 <xmx:DXriYxei49rKiCKNiIwI0RqNqwCtMnm-pK7LsMYBgVnYfOhiFdfRCg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Feb 2023 11:19:24 -0500 (EST)
Date: Tue, 7 Feb 2023 11:19:19 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <Y+J6CgDVnBlW3pO+@itl-email>
References: <20230207011849.1343-1-demi@invisiblethingslab.com>
 <CAJ0trDZsTcD43s3GQ7aKR_3eABWv0rREMrajw8xBQiu96X+B8w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDZsTcD43s3GQ7aKR_3eABWv0rREMrajw8xBQiu96X+B8w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 08 Feb 2023 07:45:20 +0000
Subject: Re: [dm-devel] [PATCH 1/2] Fail I/O to thin pool devices
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="===============5880247397720233845=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5


--===============5880247397720233845==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m1OVs7FAMuWaSnHQ"
Content-Disposition: inline


--m1OVs7FAMuWaSnHQ
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 7 Feb 2023 11:19:19 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Joe Thornber <thornber@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@redhat.com,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/2] Fail I/O to thin pool devices

On Tue, Feb 07, 2023 at 03:02:51PM +0000, Joe Thornber wrote:
> Nack.
>=20
> I don't see the security issue; how is this any different from running the
> thin tools on any incorrect device?  Or even the data device that the pool
> is mirroring.

I special-cased the pool device for two reasons:

1. I have run the thin tools on the pool device myself before realising
   that they needed to be run on the metadata device.  It took me a
   while to realize that I was using the wrong device.  I have not made
   that mistake with other devices, which is why I special-cased the
   pool device in this patch.

2. Doing I/O to the pool device is pointless.  The pool device is
   strictly slower than the data device and exposes the exact same
   contents, so accessing the pool device directly is never what one
   wants.

If there are backwards compatibility concerns, I could make this be
controlled by a Kconfig option, module parameter, or both.

> In general the thin tools don't modify the metadata they're
> running on.  If you know of a security issue with the thin tools please l=
et
> me know.

I am not aware of a concrete security problem, but in general I prefer
not to expose unnecessary attack surface.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--m1OVs7FAMuWaSnHQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmPiegoACgkQsoi1X/+c
IsHkYw/+LTzTC8ug1ruR4e+mUmoP2RCdrC8KFvx7cij6HJHKKUYi4KpCz/OKbYVH
QADgI2McT/0jHWIamXJ+J6gH7HjRS9MJv5HBSjmnG2AHJaFJh+gnv16OYwLhCVTE
wuGUrvLwSzwJj+Nlkn3q699tDob12x3p54tLDcM08EuKB+jqOzxYXQieOwvEADWM
qdLksdx5dG7eSJjo5GMqotJUBFxoBnkIIRmDqhTAyXOHsdMqceGGvkhfubrifz8v
oWn9Gat90HVS6i7qwkwOu02mNwCPGqD3oCz8lk/eUrSFjeAkOvyeXV6FjYXjY9f3
t55cByzDHmaRn6CzkIRdkkg7GeMBcxpPSzyodc8Fkr9eR28beEkGJ0dpFMFt2TTL
XqulnLVae4ZZ0OobiUGnwK0dgmQY03sKgGwp0/BoAGjIjgueLC/5BlcHUDTZmsTv
3aSihwfvvyY8POBrv46nsf8ONTBETu6u39YGk8Q7zagTxP2SBlns0IBbVIll+CZY
3egP7e/CTZVlCbeI/5zmakwB5R0hNqUMyW5SLX/rvoz+w9W2AbR1jxUmCOye8wNE
kJ3Cuv9u2UcN78pR4DZDnh9Np0nlWHxAq+jQSeovYzbTiUVe0+K0c40Zo0J2tCrl
E+UT4FGfeBAbY/AB2S19OgxRTNLMN0TO5HHUdlMV7+C9h+aubd4=
=OCkT
-----END PGP SIGNATURE-----

--m1OVs7FAMuWaSnHQ--


--===============5880247397720233845==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5880247397720233845==--

