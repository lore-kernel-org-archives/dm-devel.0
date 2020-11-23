Return-Path: <SRS0=JGfJ=E5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A56DC2D0E4
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 17:18:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2C3222075A
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 17:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C3222075A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-eblu_4o6MgqFCohNLhB3Fg-1; Mon, 23 Nov 2020 12:18:23 -0500
X-MC-Unique: eblu_4o6MgqFCohNLhB3Fg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B89371074640;
	Mon, 23 Nov 2020 17:18:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE9EF5B4A0;
	Mon, 23 Nov 2020 17:18:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EE2735002C;
	Mon, 23 Nov 2020 17:18:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ANHICMO026826 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Nov 2020 12:18:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57D0D2166B2C; Mon, 23 Nov 2020 17:18:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 526E42166B27
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 17:18:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F27D4811E78
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 17:18:09 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1606151889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=rW03BVLHp8RH7+AOefTr6epbKAh17T0SugmVUD5v6kQ=;
	b=CMaQQ5TP4gY7rGqCVEb0RrXu7vK2uWj3+ZTqc+d6vwpKIKMiFGcC6LmKRyAiIijeT8wLDr
	4ozOaZSRLVkduFZmpVwctjd68pBYozTPf/2C7CCwojDDxNlUpplKqrIV8W+yId8c/b9fsf
	nsk18eWqRg6nr2tD7xpnhM5iNLIJkwtWkzk+WrUammXCRsr0ldhnovQd6/WkvZD0TolJIB
	iZHLRu6vimt8sq2OGSyfZGD/rRsJpDTpWRwjEtCh7AArQksQfSrN7MdwPloTYAPUDpHZGj
	UK7xalWQEsaO5ZgoDQohhedHtvW3FM5vGKpWG9PeRdj03byuFs4H3iYWKeud7A==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1606151889; a=rsa-sha256;
	cv=none;
	b=ooJ7h/Svpj7gaYYp0QSqaMiFoPlAs3RaSwzWLLag4zVT3PpeyZ1VtXFSTCnAQdBEjD/i0e
	lsVcAQaCUeDJmBtXxGqHptBLDJzKtgdqnHwwGE6s/+aHlOf52HFe2oCh+fCG2ROJW/Ntpy
	sDKAAl1LM6Dz0L1Ct+TZYjWTGr6V+o+D0iOPmZCKDpIufZLX7kyng9Auo93SZ/tYx6Nkf4
	TXsELF/U7NRi6RRXxXEvQGn8cBua2P3AZNTUa6/STFI32x0dLsR7klrwu0pyRCDWgTYd8+
	JEOY0bPN/QuTrkMfjVVNNuvNUhPioW0jPOHsaSxzrNByfbnqxP1TjflFWv7zUg==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=none (relay.mimecast.com: domain of pavel@ucw.cz has no SPF policy
	when checking 46.255.230.98) smtp.mailfrom=pavel@ucw.cz
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-326-lFodbYFrMduPX0xiKM0Brw-1; Mon, 23 Nov 2020 12:18:04 -0500
X-MC-Unique: lFodbYFrMduPX0xiKM0Brw-1
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 23EAC1C0B9D; Mon, 23 Nov 2020 18:18:01 +0100 (CET)
Date: Mon, 23 Nov 2020 18:18:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mimi Zohar <zohar@linux.ibm.com>
Message-ID: <20201123171800.GA6407@duo.ucw.cz>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
	<20201120124657.GA31468@duo.ucw.cz>
	<aadf6e35-39bc-74d4-6ca3-d708860738a5@linux.microsoft.com>
	<20201122210031.GA26756@amd>
	<d82ad1cac36e948c904300548c64244c145589ee.camel@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <d82ad1cac36e948c904300548c64244c145589ee.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=none (relay.mimecast.com: domain of pavel@ucw.cz has no SPF policy
	when checking 46.255.230.98) smtp.mailfrom=pavel@ucw.cz
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
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	nramas@linux.microsoft.com, selinux@vger.kernel.org,
	stephen.smalley.work@gmail.com, jmorris@namei.org,
	linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, tyhicks@linux.microsoft.com,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 0/8] IMA: support for measuring kernel
 integrity critical data
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
Content-Type: multipart/mixed; boundary="===============6950231625013064731=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============6950231625013064731==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > >How is it supposed to be useful?
> > > >
> > > >I'm pretty sure there are critical data that are not measured by
> > > >proposed module... and that are written under normal circumstances.
> > > >
> > > The goal of this series is to introduce the IMA hook
> > > measure_critical_data() and the necessary policies to use it; and
> > > illustrate that use with one example (SELinux). It is not scalable to
> > > identify and update all the critical data sources to use the proposed
> > > module at once.
> > >=20
> > > A piecemeal approach to add more critical data measurement in subsequ=
ent
> > > patches would be easy to implement and review.
> >=20
> > Basically every other data structure in kernel is "critical" by your
> > definition, and you can't really measure them all; some of them change
> > rather often. Going piecemeal does not really help here.
>=20
> Agreed, measuring data structures that change is not really applicable.
> However, measuring data structures that once initialized don't change,
> does make sense (similar concept to __ro_after_init).  The attestation
> server doesn't need to know anything about the measurement, other than
> more than a single measurement is indicative of a problem.

So, why not simply measure everything that is ro_after_init?

But... I really fail to see how this is useful. It is trivial to
"backdoor" kernel w/o modifying anything that is
ro_after_init. (Example: page tables).

=09=09=09=09=09=09=09=09Pavel
--=20
http://www.livejournal.com/~pavelmachek

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX7vuyAAKCRAw5/Bqldv6
8l0NAKCno5uLV1J+u9T4SaYxmY8EkH/yQQCeJ/9tVl7wyA/jWR7tMN6Lj6pfIx8=
=FwxO
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--


--===============6950231625013064731==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============6950231625013064731==--

