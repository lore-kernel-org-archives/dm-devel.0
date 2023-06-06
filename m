Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971C7C77B7A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 06:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686033912;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=9enzRQNWpEcbSEIzvZnFabp/kDctPig32q5LAL9jA0E=;
	b=O2eeUHup3Ff5mGC/se16FOAmFFNCTqtT8U/5VtW6CrHEenGB4HSv/9khqgFTV1BkukIwmA
	Fco4q/j07R6hyaR5C/JJa9f/L4rFJAoQE3wivjLjZaEKTVJ3UBOK4W+0Rt65rXPmzcs++i
	lkWqvmjE9zXN/VHLk6kytp7KdBEDyPo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-G-xu-jKsPICIQDIVbmsUdg-1; Tue, 06 Jun 2023 02:45:08 -0400
X-MC-Unique: G-xu-jKsPICIQDIVbmsUdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0D623C0BE4A;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44E072166B27;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 11CEC19452C5;
	Tue,  6 Jun 2023 06:45:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 338971946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 02:17:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20E8A2026D6A; Tue,  6 Jun 2023 02:17:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 197822026D49
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:17:30 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02F8238035CC
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:17:30 +0000 (UTC)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
 [209.85.166.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-xeWupgDWMDC5yZc1l3Y6RQ-1; Mon, 05 Jun 2023 22:17:26 -0400
X-MC-Unique: xeWupgDWMDC5yZc1l3Y6RQ-1
Received: by mail-il1-f169.google.com with SMTP id
 e9e14a558f8ab-33b36a9fdf8so22270385ab.2; 
 Mon, 05 Jun 2023 19:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1686017845; x=1688609845;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=2vW14s+LE6Ttn8SPLTIyRZdmATyKiDyL2I8ox3trYy0=;
 b=rLjnkdmQI8PFiJOmi+wmXVBOgHPSrf1E9gnzGliRVqTVRZF3ub/OF0ETHszU/Hy7s9
 pkBvyRzTYzgYEifQ6CSnBaXnc5qRcGDYkGuA9T7sRszyqeYbojDC01Fh0XEDAQJxflSc
 A6Ffh23TeqN7at7Fbu7V7wXy8sY5eq4bFhQLrVPp27vYXMww5vIpZ/t9ZkcjSKhXSmik
 lXHAmExr/QuA7KKxrGgdm3tuwwevvwCrvT/T/UoxjLQrMVNtH3+hGK59kH38VlnjRTAf
 WQtw08AlWD9Qh1LQBojSCzXOWI7XpdMzPLo3taYfKuKaBNUeq/RCoNhiCWJkY5PPWoCm
 Jm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686017845; x=1688609845;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=2vW14s+LE6Ttn8SPLTIyRZdmATyKiDyL2I8ox3trYy0=;
 b=dL8mvP0e49Qj2jyatTU9aH8ThtMmsApXIJfsXWO/8NduXqs1D2xK3fGbaGFiR52+YG
 jL+ghPjQPRt0kTDPvhlp/sN12Sm02PlihKEfBq3WifLceJaR775Ajye889ylF6IlpMvI
 XtkOlER5W0ZJXqSak3SRMHGKd1wlT87t5s8oAZBJZbpSJnoViq8BG6NNb89N1WlMpkoX
 NJmalSP7eVXpDL1bgrJPFtwnhSXWW8JiJb1KDLIFqDCsCqn+PnNlgDNkB6AoLOwSHkOo
 S5h1m2kofH4oEYjDbeEsI/21QMobdj6x8tJsG3LTvgvfQNkF7m+7uezM05Y7GUlwSARu
 Ujbg==
X-Gm-Message-State: AC+VfDwlU9cPATRtdNIfAqhHon77jik3QKDg3kE1y81t0db4RrLoS0Xt
 +SZUtqjyvqzhHZrxdUA8MRY=
X-Google-Smtp-Source: ACHHUZ5ag2NMpKr6CzNSt35USmFRvJsmBb6gDSyagdHvLIlRmN8qXlHkiMLlWXIGM7cqZrhRC0fLVQ==
X-Received: by 2002:a05:6e02:110:b0:328:c3ae:12be with SMTP id
 t16-20020a056e02011000b00328c3ae12bemr857519ilm.13.1686017845230; 
 Mon, 05 Jun 2023 19:17:25 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-36.three.co.id. [116.206.28.36])
 by smtp.gmail.com with ESMTPSA id
 c10-20020aa781ca000000b0062e0c39977csm5774737pfn.139.2023.06.05.19.17.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Jun 2023 19:17:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id C822E1069FD; Tue,  6 Jun 2023 09:17:21 +0700 (WIB)
Date: Tue, 6 Jun 2023 09:17:21 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>
Message-ID: <ZH6XMbH7mocamzJA@debian.me>
References: <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230605050853.6240-1-eatnumber1@gmail.com>
 <20230605050853.6240-2-eatnumber1@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230605050853.6240-2-eatnumber1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 06 Jun 2023 06:45:04 +0000
Subject: Re: [dm-devel] [PATCH v4 1/4] Documentation: dm-integrity: Fix
 minor grammatical error.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Content-Type: multipart/mixed; boundary="===============5505049169085177681=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6


--===============5505049169085177681==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8f6GLla2tqI7Vmyw"
Content-Disposition: inline


--8f6GLla2tqI7Vmyw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2023 at 10:08:50PM -0700, Russell Harmon wrote:
> -There's an alternate mode of operation where dm-integrity uses bitmap
> +There's an alternate mode of operation where dm-integrity uses a bitmap

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--8f6GLla2tqI7Vmyw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH6XMQAKCRD2uYlJVVFO
o6AhAQCVKdKDcVHOWjP95YAh/XZC8sTMIMLMrijBeuH4mlE0yAEAh0bCR3ECtBLx
g4VuTvLrWIOODkGD9S1EoiMHmNWTBAM=
=64qt
-----END PGP SIGNATURE-----

--8f6GLla2tqI7Vmyw--


--===============5505049169085177681==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5505049169085177681==--

