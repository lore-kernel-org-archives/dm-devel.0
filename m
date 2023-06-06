Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71FEC7EE2F
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 06:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686033913;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=0MpRWBK3TtGsSwT+TPVf/dFDwG2EEZuv49NBuv3pO64=;
	b=D4nnWrNsxBEj2AQys5Ni0A5lI5XAbTi1ZQgT/R9Jwx0LSUh7X4OLMyWBYAVzsfv/3sIvXw
	K6h4so1f1L783iAjvL9K9kl5zo8s0sqBMeMJEVfZnHBkEbXWSDiAWEZHLPYaYAGho7h/C/
	8tQobe22sQoNVKXGvcgRVHPdyT0EuC4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-VLry0NaxMzqcb_LpsVOB2Q-1; Tue, 06 Jun 2023 02:45:09 -0400
X-MC-Unique: VLry0NaxMzqcb_LpsVOB2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 004018039B7;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFD8D9E8F;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 69A861946A41;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D6D01946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 02:16:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 180872026E03; Tue,  6 Jun 2023 02:16:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E4162026D2F
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:16:13 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E87918032F1
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:16:12 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-p0XSoRicNhqHdoqRjj-O4A-1; Mon, 05 Jun 2023 22:16:11 -0400
X-MC-Unique: p0XSoRicNhqHdoqRjj-O4A-1
Received: by mail-pj1-f47.google.com with SMTP id
 98e67ed59e1d1-256712e2be3so4784172a91.2; 
 Mon, 05 Jun 2023 19:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1686017770; x=1688609770;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=C5XyoZjWsuOCRV87SUXSoI1z8iAmtIIbTjGmQ4j3EJ8=;
 b=hdWbrRa4Fi5VSH7GYleswA8LBDhJHmZd2cT5dzDxy9OF3VeBcM3dDqjToGMmjW4lo8
 3qE4CEiizuk8qjEV+jlnQ/lt7n02FBQQhdgSGvcPW9NUZf5va8X62VJvpV+5KicZ1V3Q
 6z/hpUb1dbmrbOeEs9Tm93w4ue+tXNqkBXNYohXN8YMpZaKjjxKBI3lOXjs8Juy5FG4h
 uODdthiGP5jhQKzgWTivXeXBzuIICMES1BnmGf04NxDwosGevlT/d/gdI3sJeAXWVjMo
 t2xxTa9wbYvUKA8S+BYD1u+WLhp3axp4CYZBuqX+wyuggQvrjkXYxrlPnQZ5q+ZgLARh
 EHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686017770; x=1688609770;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=C5XyoZjWsuOCRV87SUXSoI1z8iAmtIIbTjGmQ4j3EJ8=;
 b=jEv8vucrc3JQ9SDiuDuHRsQHgvLWkVG2C2GHzeUbQY9qNvbwMJmFKS4J2B0FIN2EpS
 zG5lieBqASFBtKs0z/0BMBMNBvVjs3knoMKoF87vwYcuKkzG9gybhjcpu/OCPy+fvI4V
 BGhOmmRoEdY3Q42buWvRCxYoW15Xmr28kUTBSs68IQHR2uBQ/YAoABuDvzlQWB7rha3g
 +K53BnW2fRtTI93DbswC+o5shS/XWYTyf6m4akqZ92F1mjeEgDWQScAlxMwUspPB+pYB
 ELf+wFa1RsQXI0qfGZR2KdqMsrsFGXVWWerosx/bLZyOxhqG8gg60uGDtl7EvllGwp6Z
 uKQQ==
X-Gm-Message-State: AC+VfDwasmG8KO2RCj9MdUTj2b+YyLF+Di+TtN+up35Z68UuNcmG4xIv
 cosvO7U3DjEJq9mBdRlsK8MxMJbBnK8=
X-Google-Smtp-Source: ACHHUZ5N9RU4fhFUW5Lc67Fb7VuqKmhcmQPducBgOZuXThdKJqR83I91aNFur900MA4NmiMh3ZWtBA==
X-Received: by 2002:a17:90a:1a11:b0:255:a1d9:4486 with SMTP id
 17-20020a17090a1a1100b00255a1d94486mr641168pjk.1.1686017769632; 
 Mon, 05 Jun 2023 19:16:09 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-36.three.co.id. [116.206.28.36])
 by smtp.gmail.com with ESMTPSA id
 gf18-20020a17090ac7d200b00256b9d26a2bsm8318745pjb.44.2023.06.05.19.16.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Jun 2023 19:16:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id CB2161069FD; Tue,  6 Jun 2023 09:16:04 +0700 (WIB)
Date: Tue, 6 Jun 2023 09:16:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, Russell Harmon <eatnumber1@gmail.com>
Message-ID: <ZH6W4yegFI1ioMzt@debian.me>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-4-eatnumber1@gmail.com>
 <ZH1TmkyVJbIlNUEE@debian.me> <875y82yre1.fsf@meer.lwn.net>
MIME-Version: 1.0
In-Reply-To: <875y82yre1.fsf@meer.lwn.net>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 06 Jun 2023 06:45:04 +0000
Subject: Re: [dm-devel] [PATCH v3 3/4] Document dm-integrity default values.
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
Content-Type: multipart/mixed; boundary="===============5986415236816870954=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5


--===============5986415236816870954==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="M9h4JANILIPQgPJG"
Content-Disposition: inline


--M9h4JANILIPQgPJG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 05, 2023 at 07:23:34AM -0600, Jonathan Corbet wrote:
> Bagas Sanjaya <bagasdotme@gmail.com> writes:
>=20
> > On Sun, Jun 04, 2023 at 12:06:03PM -0700, Russell Harmon wrote:
> >> Specifically:
> >>   interleave_sectors =3D 32768
> >>   buffer_sectors =3D 128
> >>   block_size =3D 512
> >>   journal_watermark =3D 50
> >>   commit_time =3D 10000
> >
> > Your patch description duplicates the diff content below. Please write
> > in a mood that evocates curiosity to read the diff (and make sure it is
> > also imperative).
>=20
> Bagas, this is a typo-fix patch.  It does not need to be nitpicked into
> the ground.
>=20
> Russell, Bagas is inadvertently teaching you another lesson about the
> kernel development community; it includes a certain number of people who
> like to push contributors around with authoritative-sounding messages.
> These people do not always need to be listened to.

OK, thanks for the tip again!

--=20
An old man doll... just what I always wanted! - Clara

--M9h4JANILIPQgPJG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH6W4wAKCRD2uYlJVVFO
o+HiAQClaUBtBehl8TpkH8yaVIXPPll/LkDnss0br3iiXPCjFAD/XUI9GPV0AyGM
9q7MPwXm/t0Xxn84QJSh1OtLXeSHUw8=
=b2Ha
-----END PGP SIGNATURE-----

--M9h4JANILIPQgPJG--


--===============5986415236816870954==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5986415236816870954==--

