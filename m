Return-Path: <SRS0=hjg8=E4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357A7C63697
	for <dm-devel@archiver.kernel.org>; Sun, 22 Nov 2020 21:01:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91CCC20782
	for <dm-devel@archiver.kernel.org>; Sun, 22 Nov 2020 21:01:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91CCC20782
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-0u58glHBNWKJKuvx9fPZfw-1; Sun, 22 Nov 2020 16:00:58 -0500
X-MC-Unique: 0u58glHBNWKJKuvx9fPZfw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4166651E1;
	Sun, 22 Nov 2020 21:00:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B29505D6CF;
	Sun, 22 Nov 2020 21:00:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 759F4180954D;
	Sun, 22 Nov 2020 21:00:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AML0hrw012138 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 22 Nov 2020 16:00:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9D3371000DB2; Sun, 22 Nov 2020 21:00:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 988711111A6F
	for <dm-devel@redhat.com>; Sun, 22 Nov 2020 21:00:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34C22185A794
	for <dm-devel@redhat.com>; Sun, 22 Nov 2020 21:00:41 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1606078841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=iDQH8jIk8Cfoc2+2ua5loBf9gKtMorxlR3JdI6qnzPY=;
	b=pxD1cZMbK72EZjAfVD2F4xNeCG+cmMbqCtTYXUFusUtEfC3NT4QdNqwDodvs/YxTdkyqqO
	NE4Z/iaV+oYe6EW9/bA17ytgjl6izZtp2zcNJyaXlLuIrEtanky2NGLSKj1wG3ohR/sy0T
	QRVB5OVqihZk5HZ3vmn2ww1hphqAZxSilWG5NHYambtF9g2qfFlGXjQYsCF4NMfhYH08yJ
	hPt/CzRH28QXoKfjVKIdRzRDaxXtbMVK3K25rQhkhRBiRtQsJOTUx9epIY4HZMpPxRTxOC
	8oSWztsm9knHhSR81oVazNjV6gZtfJfFSZVzTyWk5qr1Gl99BSCgSfad3sXzMQ==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1606078841; a=rsa-sha256;
	cv=none;
	b=rSXZFJDXEgZZ7yff/L+B+303C9P0IiyiPLomyn3I7M387u/DqglxflAXKBA2Lg7G+SvEsE
	u1jknyYlckc4kqrY38Vy30huungpIKgTuOh7oDUhiWdxFbiGD3UxXmoPOdIO1HdwB4p/fc
	2L9/wNwKJlbrXcvFADvXurldq0kuUUGhtSsssHbYlN8zM3h4RnCT8QuV52Bf7AWgAbVvEM
	5B4JBkZwVj1LA1x8nbOZFMkAWU6FxhUZf6Z+XTc8vhX7l23UHb41U/T3M5h6W0USIvkm1f
	3/1snXumpoEGGC4h4dnDgGRAXvnwhwKQCZZlOz7Rrn1X76AP1vL2NNvG/TgNHg==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=none (relay.mimecast.com: domain of pavel@ucw.cz has no SPF policy
	when checking 46.255.230.98) smtp.mailfrom=pavel@ucw.cz
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-504-fWcvRZcGPACGlBiXucnlvg-1; Sun, 22 Nov 2020 16:00:35 -0500
X-MC-Unique: fWcvRZcGPACGlBiXucnlvg-1
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 46B251C0BA9; Sun, 22 Nov 2020 22:00:32 +0100 (CET)
Date: Sun, 22 Nov 2020 22:00:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201122210031.GA26756@amd>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
	<20201120124657.GA31468@duo.ucw.cz>
	<aadf6e35-39bc-74d4-6ca3-d708860738a5@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <aadf6e35-39bc-74d4-6ca3-d708860738a5@linux.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, casey@schaufler-ca.com,
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
Content-Type: multipart/mixed; boundary="===============3776978264229862536=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

--===============3776978264229862536==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >How is it supposed to be useful?
> >
> >I'm pretty sure there are critical data that are not measured by
> >proposed module... and that are written under normal circumstances.
> >
> The goal of this series is to introduce the IMA hook
> measure_critical_data() and the necessary policies to use it; and
> illustrate that use with one example (SELinux). It is not scalable to
> identify and update all the critical data sources to use the proposed
> module at once.
>=20
> A piecemeal approach to add more critical data measurement in subsequent
> patches would be easy to implement and review.

Basically every other data structure in kernel is "critical" by your
definition, and you can't really measure them all; some of them change
rather often. Going piecemeal does not really help here.

Example of critical data structure: page table entries for process I
own.

Best regards,
=09=09=09=09=09=09=09=09Pavel
--=20
http://www.livejournal.com/~pavelmachek

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+60W8ACgkQMOfwapXb+vIcigCeMzGk7j6mjC+lCez6JgfwCYJI
Z1YAnihbhsor2KAe3Vx6iXF3suE279VG
=O8SH
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--


--===============3776978264229862536==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============3776978264229862536==--

