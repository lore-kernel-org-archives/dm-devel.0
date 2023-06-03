Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEFF2C7EE32
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945056;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=EwptwkP80cMPCnTdlJPpuFPNpXXG5qe/eblYTTnOQug=;
	b=F0Xhy2YOEt4ns9cp3LRHhtT3xWPzLQRhI3H/1QJscfoY/uDQLtAY9gFgjr6eGauEA/QVR4
	ajtzWxP24DIYjHIc9ZGRPfr4o5pmTz+sc2mu3FXRI5O3p/XZwbxGGAzuYXRfuJpnV1Vle9
	dCrZaDES81eWVRIkJ8mFZCq26G1W7xI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-bgBp_fiAN2eLYxjET5tGGw-1; Mon, 05 Jun 2023 02:04:12 -0400
X-MC-Unique: bgBp_fiAN2eLYxjET5tGGw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 419681019DE4;
	Mon,  5 Jun 2023 06:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E6DA492B00;
	Mon,  5 Jun 2023 06:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C5211946F09;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27B661946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 12:50:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 088702166B27; Sat,  3 Jun 2023 12:50:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F311E2166B25
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 12:50:36 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6B8B38123A4
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 12:50:36 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235--_5c52PNMhGWV-bx8XVtCg-1; Sat, 03 Jun 2023 08:50:35 -0400
X-MC-Unique: -_5c52PNMhGWV-bx8XVtCg-1
Received: by mail-pl1-f176.google.com with SMTP id
 d9443c01a7336-1b034ca1195so14668495ad.2; 
 Sat, 03 Jun 2023 05:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1685796633; x=1688388633;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=m3+BN/msO9N0mLkjvZX/WeFDqGUSTUi10KeGYtSRPn8=;
 b=WcdJ5db8SpF+7Z9Mgld6LKA3AFANFfOvRJPEKGX4Q1Aa27/SVtm80Dcdtfaf3QRcWu
 XgvkdEAgPmwgM2/tew1uTt/76Qi/u/q4/fgMkr52vHpUkWcrbbpaYo2YYoUaYPqHl1as
 IyJ2lA0cy/yl+qile4nwxdKk7gCbA7x2PUoHyyMV8SkUUhzkrIP/gpzG9u2NldQc2bNJ
 /7mVCj+sQDFvi3+/zcb3uhl4A8iqaHNCxTvQ2mVvcGhcKQDO8SCYb2K4yPvDK1s7rSNK
 zQ7fAOGgN6bFQZo/NIZb50Rt7s/Tg+/DypcFCLIWs7U1JGmNNpONGtz5J829ic8NaEZj
 ZUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685796633; x=1688388633;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=m3+BN/msO9N0mLkjvZX/WeFDqGUSTUi10KeGYtSRPn8=;
 b=NQmQM2BdxY/tvR20S0FDmnqWGJmE3t3clmP75tMIqalmm0ZdMmzM+QwmW0ow0DI/P4
 5xhptiQJu+mI2ZoIJNIQF8uSBNXZfEaigYx2aJG8UrBKTBjt42ux6Smmmle4jC8UIQ/k
 BGgSzOCMLAv65zITUiW0k2vINACHcccCbx9R1jxtuH515U0YYd+dNAY2nMj8NZw1378C
 1vUWfIL/8urzkzxzu+A0gq2Kx9symnX8cvuvEmP+L/Wc1ccV9L1NNC4wE7cHgXpdTFNH
 5y6gtoziYGrnFEuRCYikAWo8WS/11bH9jrEbhjH3HXY3kM/XCpIutFibdchzkbGAq41Q
 t0tQ==
X-Gm-Message-State: AC+VfDzXgc1A0tV6pxX9QbjLhzuIYcdc3WhD1XnVF7kWGHJDsUqCcSco
 6O33esjIJUgsp/pjKqYZ0U7SPR3wnkyfpw==
X-Google-Smtp-Source: ACHHUZ4gLl/xOpectOIjLYWNGUcmE9PAkvHkWOLhO70Bg6SSw5dmS0ttDNkqZBjhSB7ZNzaXZpOLwg==
X-Received: by 2002:a17:902:d505:b0:1ae:57d4:efbc with SMTP id
 b5-20020a170902d50500b001ae57d4efbcmr1467938plg.13.1685796633536; 
 Sat, 03 Jun 2023 05:50:33 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-18.three.co.id. [180.214.233.18])
 by smtp.gmail.com with ESMTPSA id
 ix20-20020a170902f81400b001a285269b70sm3103021plb.280.2023.06.03.05.50.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Jun 2023 05:50:33 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 35E111069C9; Sat,  3 Jun 2023 19:50:30 +0700 (WIB)
Date: Sat, 3 Jun 2023 19:50:30 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>, mpatocka@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com
Message-ID: <ZHs3FqIWkkuFxMjS@debian.me>
References: <20230530002032.15227-1-eatnumber1@gmail.com>
 <CA+zrezTKon+02mfMRsW34Tkovqn3FsSD2_9tk-+a4icjt9PsDg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+zrezTKon+02mfMRsW34Tkovqn3FsSD2_9tk-+a4icjt9PsDg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH] Improve the dm-integrity documentation.
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
Cc: Linux Documentation <linux-doc@vger.kernel.org>
Content-Type: multipart/mixed; boundary="===============2098405604009634138=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9


--===============2098405604009634138==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XVArsN7NhrhXjAZn"
Content-Disposition: inline


--XVArsN7NhrhXjAZn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 03, 2023 at 03:02:09AM -0700, Russell Harmon wrote:
> Apologies for my inexperience here, but is this patch likely to get
> included? I see there's been no discussion.
>=20

tl;dr:

> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>=20
> A: No.
> Q: Should I include quotations after my reply?
>=20
> http://daringfireball.net/2007/07/on_top

Next time don't top-post here; reply inline with appropriate context instea=
d.

Bye!

--=20
An old man doll... just what I always wanted! - Clara

--XVArsN7NhrhXjAZn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHs3FgAKCRD2uYlJVVFO
o5PPAP9htOp2ajlrdlZygU/aGwwxv07nU6VNumDM05NqxZ+LFAEA1alMSdN2/KAw
Gk/nzfnApbFJA82uiTlqw8oIzL0tvgk=
=D5kI
-----END PGP SIGNATURE-----

--XVArsN7NhrhXjAZn--


--===============2098405604009634138==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2098405604009634138==--

