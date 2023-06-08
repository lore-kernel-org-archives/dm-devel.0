Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 860A2C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686237886;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=p4qGv3xqoSD8gcK9AcOKU+Tj8QHuIwqD2HWvuPg4Ab8=;
	b=BebRh+XYptVDhSblYcmSIvJNhFfzUKtIdw14CtFy7gaLhpg9SO/YIW8a8WnblhYuQsI3Pe
	GF001asSp9otqVQijbM3wDcHZ5SwgUQoAlo2FTZZ2u+6/UxDqarTt04lbpNixJu2SKD6zH
	t1h8vb4P9EcAdei7s67IO3GQjMSxKB0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-sp32NPxMM7OycicV-awo-Q-1; Thu, 08 Jun 2023 11:24:43 -0400
X-MC-Unique: sp32NPxMM7OycicV-awo-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12358803DBC;
	Thu,  8 Jun 2023 15:24:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00A201121314;
	Thu,  8 Jun 2023 15:24:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BABB919452D3;
	Thu,  8 Jun 2023 15:24:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8759E194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 15:24:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45B35C16044; Thu,  8 Jun 2023 15:24:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DF1EC1603B
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 15:24:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E62428EC108
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 15:24:39 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com
 [66.111.4.28]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-GOfjvOmBPKqLSR2dK1erzQ-1; Thu, 08 Jun 2023 11:24:23 -0400
X-MC-Unique: GOfjvOmBPKqLSR2dK1erzQ-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.nyi.internal (Postfix) with ESMTP id 0F3BC5C01E9;
 Thu,  8 Jun 2023 11:24:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute2.internal (MEProxy); Thu, 08 Jun 2023 11:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:content-type:date
 :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
 :references:reply-to:sender:subject:subject:to:to; s=fm1; t=
 1686237850; x=1686324250; bh=IUwV7Mu/3eeunQeH2XK30qt0uf9HHgiQtGt
 /LtpN1XE=; b=qkWSqIIhlL3j6f0o2QA3qjwAhifNX1DVceBxIUx80pu40CAbu00
 rG8BdFX5TCACouopEHlb/IMkNI6qtZMhwvR1Gpd2ltEgWLJhh+qDJTfx9LUwP2U+
 o0Fnd4VynfaIdgELqjIQRNOIHQhlhIOySyb7sxw+A8h9WXGlJLNX5TuEaelLmWl9
 IHXDFCtEKOBWm53s1hjhnawK1T6f4p0vAdJAR1bHw0WcxN/w0tYVo7/wNliOfqVw
 QFshIhJe7kV1vhILMaT6wk7/PswRPwurSQM0aCBHgAisq8tgX3p1f37FDNrrNYlb
 KFbLXDHXtO5kNgHG2pvFIdm2g/n67mDPTdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm1; t=1686237850; x=1686324250; bh=IUwV7Mu/3eeun
 QeH2XK30qt0uf9HHgiQtGt/LtpN1XE=; b=Wp7Efil1kW9JdynZmx2MHe+A9VB/H
 TzHbaEQQCyWkxQ1ekigse3L5qwdYtyNNlAl5Gc0Q38lykiETgRSoo/IADKhUr1P1
 PLZwmj2CWn1DNebeSS2a+J8JfTI6EhHn95VkHFtWe7bWG4VOeDVfbgwIJM8LFt9w
 3lsWcrcB6a58Whlq4ynJ8YLYzmJ9dOXcFmWOUmDJVnfR8scNHQ0LZ5FrErrW+bJt
 aHAcspBnYmYdLtxeQqvmSBpYyBmaV2jT6bT4bzaq+7AM5k4anQ1dCc8eMbqEanct
 4j3nErhC4feMyerw6a4iCzJH247hXmm4itdQUHnSBPlX9s8ffOuagZSTw==
X-ME-Sender: <xms:mfKBZOxI1o0PYMqIpPuxIUxANT07tGV5lD0i5iGnsIjqHBkIC7HOfQ>
 <xme:mfKBZKQwRxPpdELe6J4ZFN-vjgmvg3Rp91LnJGWA0SpSoX8Dj2Cp0uaUvOPPE7xwz
 1kfOR56rI4jzkI>
X-ME-Received: <xmr:mfKBZAVmkzE4rEcFIEIMuhqkaXhVUZbLXu4fn6VNwXoAos7KHXa2UBvGFZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtiedgkeejucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepvdejteegkefhteduhffgteffgeff
 gfduvdfghfffieefieekkedtheegteehffelnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:mfKBZEha6jDGZjXc0JmuBhTWJJEpwJXdEcExcinxHBVYjkNgUiJ1Jw>
 <xmx:mfKBZADliEfQ41_FA0gBOwXt0thVTYm3OWhulErEFW9hhaffRUIWNw>
 <xmx:mfKBZFId7g--5ZFhk3WSRKZI_EhndyUtmSTEl5e3Te3TsuDsLVwvnA>
 <xmx:mvKBZC3BV-Ydv-Jp1hyhHhc-_ehW1LoJyYt6Zuki_sIl6b1uJ0ai-Q>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jun 2023 11:24:09 -0400 (EDT)
Date: Thu, 8 Jun 2023 11:24:06 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Message-ID: <ZIHyl3skhh/Yy5fe@itl-email>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-17-demi@invisiblethingslab.com>
 <ZIGot1mn+lChK4q8@Air-de-Roger>
MIME-Version: 1.0
In-Reply-To: <ZIGot1mn+lChK4q8@Air-de-Roger>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 16/16] xen-blkback: Inform userspace that
 device has been opened
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Content-Type: multipart/mixed; boundary="===============5952184690455564138=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3


--===============5952184690455564138==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DG4zdBvb0kvaNjmD"
Content-Disposition: inline


--DG4zdBvb0kvaNjmD
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 8 Jun 2023 11:24:06 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 16/16] xen-blkback: Inform userspace that device has
 been opened

On Thu, Jun 08, 2023 at 12:08:55PM +0200, Roger Pau Monn=C3=A9 wrote:
> On Tue, May 30, 2023 at 04:31:16PM -0400, Demi Marie Obenour wrote:
> > Set "opened" to "0" before the hotplug script is called.  Once the
> > device node has been opened, set "opened" to "1".
> >=20
> > "opened" is used exclusively by userspace.  It serves two purposes:
> >=20
> > 1. It tells userspace that the diskseq Xenstore entry is supported.
> >=20
> > 2. It tells userspace that it can wait for "opened" to be set to 1.
> >    Once "opened" is 1, blkback has a reference to the device, so
> >    userspace doesn't need to keep one.
> >=20
> > Together, these changes allow userspace to use block devices with
> > delete-on-close behavior, such as loop devices with the autoclear flag
> > set or device-mapper devices with the deferred-remove flag set.
>=20
> Now that I think a bit more about this, how are you planning to handle
> reboot with such devices?  It's fine for loop (because those get
> instantiated by the block script), but likely not with other block
> devices, as on reboot the toolstack will find the block device is
> gone.
>=20
> I guess the delete-on-close is only intended to be used for loop
> devices? (or in general block devices that are instantiated by the
> block script itself)

You understand correctly.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--DG4zdBvb0kvaNjmD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmSB8pcACgkQsoi1X/+c
IsFDgg/+LvYLn6bwcjUeONWEIyGKyw603h+1aYfMvgtLZNeFOldTtAfcVOMlZy8y
SSlLFAqfePxh7n7mCyi03wisScbGDY+iDNI+6Y0pmCKmrKXzZEKkRdXld9mejI/c
Sp5g2yz9lEV0lwqrX4vBMFux41AdCe9CwTxQ072RQabojUem8EdmvV82l88YJrBU
ZPe6mgZEknzAIDrbth/FIA7eowKITBrEwdDmdsHw1HzGzJcHbfpzdxKgcdg0r/b0
cqf2DdIi1DHUsCzjTILR6akwxuprAvEArGy00iB+wS+eXfZBZIBlLrwsAFYSwZSD
tRAZ0BgjeL5b0MxTP5KP1rRB6p4hBPxVyuBduDEaaBdsNJJcAHGDgiuvkTVKqMZM
HzaSWI9HCuJ/xIRTtAd620ogZDwlzjkVsc3vHo++hDEF3WvwEaKjfNjvVr1wg4HC
NQ+Tc4JllfsJgwAp6D7zsEAL/KwlcoQqZYf1o/Z9ukjCU+iRL9NXhPtMPX4Kjdqn
HPdBnnjAU8dyMebH0N4ltPt6CZw9cQ1V43QtJy89OpEt0PqF7BkIRkdXZ3yw8pAN
jCjWYIKy54g5Qzm3G/zQ7J3oc83/o0KWdZIfpZCWdZmO3mHD3i2fb/opIngDxsbR
M9HcUCFwbGOuwQ97S4t2XB2dXP106oxDkCRphDEwDFq9BpWmxQQ=
=wJOc
-----END PGP SIGNATURE-----

--DG4zdBvb0kvaNjmD--


--===============5952184690455564138==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5952184690455564138==--

