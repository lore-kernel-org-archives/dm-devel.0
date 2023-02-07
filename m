Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3784CC05027
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 07:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675842327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=fKiKgeWMk2/o/+XJxOiYA47FPDVMphJ0p0K5LH8y5O4=;
	b=Vaqmm6zs/1tc9WstNC6NwIZs+Vh1Rzi/n1gKTYoJOVDY+R55jsCsXitBmn8V3aa9mmkQ5i
	2KO6SbRgKJvJmq/rBl8vpA/tzUZ5cfVFDyCVSXg/U2WQHsa9nG+Tq/k87XG0WKv3P6hQzR
	eCzSXXK4Ow6e377zFt25KLMZZwLMT0Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-WLBpwRdHOD6AWfidxGbpEg-1; Wed, 08 Feb 2023 02:45:23 -0500
X-MC-Unique: WLBpwRdHOD6AWfidxGbpEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B78C1101A521;
	Wed,  8 Feb 2023 07:45:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71D8BC15BA0;
	Wed,  8 Feb 2023 07:45:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E6AA1946589;
	Wed,  8 Feb 2023 07:45:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C52B31946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 16:24:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4BC240369A6; Tue,  7 Feb 2023 16:24:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA1C940369A0
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 16:24:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EAD985A5A3
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 16:24:45 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-84-_JFRbrZ4OrmXde7KJ-A_Sw-1; Tue, 07 Feb 2023 11:24:39 -0500
X-MC-Unique: _JFRbrZ4OrmXde7KJ-A_Sw-1
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
 by mailout.west.internal (Postfix) with ESMTP id AC2C63200995;
 Tue,  7 Feb 2023 11:24:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
 by compute6.internal (MEProxy); Tue, 07 Feb 2023 11:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:references
 :reply-to:sender:subject:subject:to:to; s=fm3; t=1675787077; x=
 1675873477; bh=7R/XpmUSA4PMsRDNnIxTLaD71IjwOgO4tuP4PJAPXfE=; b=e
 hS1EsTjdIbS10P2nGog4LDrzwrs60Gy+ynxxfRH9QLMw4Gv8zh76sPfiv0WO1Ym2
 itOUmvmFxZ/UHtWqYVNIwbf4y1WJxH8O1OIVJcOq5D8BUEDxC9b1HxCOi7Fakj5a
 kO4w67pYUEFp4wqnrWDudEgXs0pBUX0ePPK+vYhxBEUxZKvGgPuaI2CUBk01Q48k
 PANmFZiTs4a250SjxrdJnoEFEo4qpaTvIl5xU5OGveYsqoUDfupW4MWNF69nX9zI
 A5f9sIlPY7zABTYqdNlwyayTKcR1SIFsfimZjIAsvxAmFbWQdhAYEsE/ipWywBXU
 E3kxIxHEkFmBy4DlCGH0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:in-reply-to:message-id
 :mime-version:references:reply-to:sender:subject:subject:to:to
 :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
 fm3; t=1675787077; x=1675873477; bh=7R/XpmUSA4PMsRDNnIxTLaD71Ijw
 OgO4tuP4PJAPXfE=; b=TiNHFOBRHipDJhJ2gujiI790VTtFpy7/qED7pvyB5uqK
 o/QT8KEBd6ppeyo4tJAdhAuvtBJiMGlzCh//N+2dIwt/GJqb8H+U7m0haeNbl0gh
 b4bsUwRRUImxpT/V43O6w2dPvgoGpfWHe3N1uyTwFDkf0hb1Rcm7qbZEgegDAdNH
 G1TP0TiIKsvWsilqy5a7BTntG/4rhfGBR1l/lT9pkofZsbCr/ObqfarbnXgC2Fkv
 dECPPJ16UnMYIf6o1p1RQqD359NzXwQyoCRghsah+C+LPa6yhrBMsY3Y9PnyNdQh
 /KGH/sGV999qO0/66fsOrq76ZW2h6XprPw/pzkIVLQ==
X-ME-Sender: <xms:RXviYwff7vGgpVpg44S6Y6cLBDyQIGjHoAFpJCteY6OniUFHbEF7YQ>
 <xme:RXviYyNcf5OAWFWG0eFK9qjMe3cnITx6IKlKnV5IRs9vsm87IT_9Qm00ya2023-r2
 44ZH1L262YIqyo>
X-ME-Received: <xmr:RXviYxgFpnu1FGtgZRB3kk1Ov8mTCY-iMPay46o8bqpQkA4ek0z78Z_Uqxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegkedgkeeiucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepudeileefueetvdelheeuteffjeeg
 jeegffekleevueelueekjeejudffteejkeetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:RXviY18nR5WwQZNZ2B4R-OvY3WMqqumsP3pXw212_wUM6MxeCCAaig>
 <xmx:RXviY8vhgmZ27T05dA911uh4Fk5w8q1z2xScM6kkMUxfST1Dooisbw>
 <xmx:RXviY8Ehoe4Nbs5992bQHDriYNJJ87P-SxY9Y0_XiXo0ATRw3ayBsQ>
 <xmx:RXviY4KeSXyT0o6IhYWhy-qGC8W-HHUimyF2zUj9mf35sxfRL9qOUw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Feb 2023 11:24:36 -0500 (EST)
Date: Tue, 7 Feb 2023 11:24:26 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <Y+J7QrS7JqeNqbot@itl-email>
References: <20230207011849.1343-1-demi@invisiblethingslab.com>
 <20230207011849.1343-2-demi@invisiblethingslab.com>
 <CAJ0trDZ88Tcaf9Y75S-vB1vWXPN9UEsqPV1bTrkAtSYFfUngAQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDZ88Tcaf9Y75S-vB1vWXPN9UEsqPV1bTrkAtSYFfUngAQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Wed, 08 Feb 2023 07:45:20 +0000
Subject: Re: [dm-devel] [PATCH 2/2] dm-thin: Allow specifying an offset
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
Content-Type: multipart/mixed; boundary="===============2630813408164181179=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8


--===============2630813408164181179==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ScLOiD2qe/Xm+M6i"
Content-Disposition: inline


--ScLOiD2qe/Xm+M6i
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 7 Feb 2023 11:24:26 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Joe Thornber <thornber@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@redhat.com,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/2] dm-thin: Allow specifying an offset

On Tue, Feb 07, 2023 at 03:03:57PM +0000, Joe Thornber wrote:
> Nack.  I'm not building a linear target into every other target.  Layering
> targets is simple.

It also introduces a performance penalty, which is measurable on some
workloads.  Even dm-linear is not free.  The crypt target also has this
feature, so there is precedent.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--ScLOiD2qe/Xm+M6i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmPie0IACgkQsoi1X/+c
IsFczhAA1UG7afUNotup5av9jXAA3Zc9u75TsHUT5BOxVMTIuej/hxQMqEWB5WY+
MZBbAjjsaZlnxlUWq3Kmi2ch1RNSWLndSGWszL6itoSZu4IV7aFRoQ/+SDHB0dGj
r4P5K27NDv069VDvjy8wktfV80zbmoDJEnpv7F/1O5A/4X3eH5szB2quko/3YpTS
jraiEvrzOO1qowXzgJILGbbwQDE+NGZKDquKCHrKg6w7JXArzC+FW/F3o0r9+CHL
+7ZyLc6Gpe/LDNmKlPyhjMEE4tSOL7gyMzQ6we+A9mw26lhjfuav4BwJSaue62JA
1qDOB6NtYRLNehKIfO2qzlrdcthUicy+/6CJrC5I+lNKFt8me83TqyNUCaxwuX5w
BeeSWi76NuNLfDVAOTPWe7AhkNAa8BpE69oWQFAS1NC+jYWTzIO053IXPUMgK/ol
v96ZU22tSTi149D+sY3kUo/Nx44dx0lNgiqBIJSwhSkNONuSAl/ajTslJGUOAm5Z
H0/LRZEKAE7y8kDV/U5nEaH6Vn5ijhwUO0ebaPW3Lq8nbN6Ddo3DykkN5uHw5w4f
R6r6P1MGiwp92BqXfBGBsEUR5Ulsh/hVFPOGknHK7HwfuaQXCdwuqljcrCiCL/p8
XTUO5qu0bJ9i2x5NqZSOjlqJfMI3CNu2StJ8PVJSxCBhn2I89QE=
=hLCQ
-----END PGP SIGNATURE-----

--ScLOiD2qe/Xm+M6i--


--===============2630813408164181179==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2630813408164181179==--

