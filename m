Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3344CC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 23 Jan 2022 18:01:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-YawHGftKPgeZHTvazcaCSg-1; Sun, 23 Jan 2022 13:01:40 -0500
X-MC-Unique: YawHGftKPgeZHTvazcaCSg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCC69809B98;
	Sun, 23 Jan 2022 18:01:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB5C97EDAB;
	Sun, 23 Jan 2022 18:01:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B46754BB7C;
	Sun, 23 Jan 2022 18:01:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20NI1TmH022011 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 Jan 2022 13:01:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B8960401E37; Sun, 23 Jan 2022 18:01:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 996AB401DBD
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 18:01:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 810EB803D66
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 18:01:29 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.17.12]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-170-VFozxIB-OhePDNyxPXZeTg-1; Sun, 23 Jan 2022 13:01:27 -0500
X-MC-Unique: VFozxIB-OhePDNyxPXZeTg-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1642960885;
	bh=bJsXUuPlICLfbiMkqCIV04KvOojmltiJuRPCGGD/u4U=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nbY02BpE2Kqki6uJfnLbdJJ/jJ0v/4ZSgx98Zf41cEi9U/wGWt2a/hvF5oU6EP9ga
	ZGFznj3fJFalfn0wo99vxCStNh0uLo6JeFQHwvN5GNHwio6uI8nJKJ9A8vX3oKYfVP
	6a2lkVJTwiCPL2ME2/0EDvRZHUEaWz+HdLNNqkVw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.190]) by smtp.web.de (mrweb105
	[213.165.67.124]) with ESMTPSA (Nemesis) id 1N2jWI-1m8liL0rs4-013RFz;
	Sun, 23 Jan 2022 19:01:25 +0100
Date: Sun, 23 Jan 2022 18:00:58 +0000
From: Lukas Straub <lukasstraub2@web.de>
To: Roger Willcocks <roger@filmlight.ltd.uk>
Message-ID: <20220123180058.372f72ce@gecko.fritz.box>
In-Reply-To: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
References: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
MIME-Version: 1.0
X-Provags-ID: V03:K1:kPWNIjImIHtuCjzpGybCkDSuTRJFlUEXHw8hoVW59PKAIbK2WEp
	SqypDWP/V44GOWjrPD/PIwM1hRp8jyONukUuWUNThzrwRpkZBLetPO5mEqh1LDNhw7ucx5f
	bGcZcRJr3iRsLeM2Eh2Hlrw+ScpBPfMrz3R5jAM/66Vm4P+oOYZgXr5JVzcWxTYpZmxU/KA
	eg8QqnPgwbN1+IwzdoH5A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7DHrsCfIh00=:H9N7OWxrwBp/8CgtS6PCb1
	6ilP9T8pGFRJ171de7chibE+7APLwkWJxGlXUAs3ybf4O7rRKAwJauL6Youaj+Kqr6Oc0ybcJ
	mgtT/NbkkC21gtog5W/OUS1DaNyPnWz4r5UxlxGxVh1Yea74gqRsOdXftuvCE0HQnJSPzprAU
	HZO8kJaRoSIitxRTfi7BaHfgtI4R2hZcgRJFAYAH8Ysa+h/rLN7X4//bQe+7kmFH5j9kUq6Bg
	XZWzPetr4OjIYV4/5zmyy0w7v7XRtoO36T19LT/838WYBPscO7cqrtO37wIXpJ3JQXTaehlhg
	VkFHUaGJlHrJr9BQtP/GRP0eNfd6hSgQ5c9oZpXXnwWbgzlf/Kse3xeckamK8Bta2JjXfgr9s
	pRFRtCn/1TIZzQ2sGa5L/cuFYuU48aem/P/aFB3iJ41KORYpAQ2VbXlqTSDHa/zE+PXfARXlU
	3cGgtL/+HQEu1j6cEsNsRiNC8HFGVPU8andb/Heqeqpx+qCjmvwc8YnAffzDF7YFHJ4FzOxp6
	ngMCGasROZkP4ZKLLd4AgMpmtUxuIPGwoGnL1j1M20qG0NLNQHI86kcl+st4HfmZubCT4PNc5
	xJdfmhMdG0hLxW+IiT5TbVhz2+TpyEm98oD+Dv9bX9FPpU1dmC4GVBzs4vTlp9u6MBE7bmR90
	HhStCEvi66SeYnYmezVNyRGCjE0gaeYYOLGrP0Pnzre0Q5oKRNme/5zvJpxxoi4JBUvw8d08V
	KwqYcDJDpYrpiMv1puhIyQ4ZQ0wA13d2SDToVPYV5hkV22ES2xT171IgzqN7bqyJ7porApNPc
	5XkcalVZv1Xgp6lury7AQ4g62vxuDo179bosBNQTVSoLik+ycWKt2omD7JqP441iWx3OR1H4D
	Fb+PmxFlHIQuMq1q4Qp5TF6RV46qnxKeib7jlLBt0yUmwoOzHYpBKKsprYr1QPExPOcQtJkoR
	F2L1ym8BG+pUjvs/cv2197CouzEEKgQLPB8u/JpMHYie0XwV41dPVEb3iuolVreWBi9EzN4Dw
	dZoBN6Adi1gvUu3pRXctvVkl1jypdZkGNL73cw1/pAAO7O/mo7RBwPhteaolV4N/ds7ANKjZh
	rYkb3gFZ3yDuqU=
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com
Subject: Re: [dm-devel] Raid0 performance regression
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
Content-Type: multipart/mixed; boundary="===============2144499198061939889=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============2144499198061939889==
Content-Type: multipart/signed; boundary="Sig_/GZ0tmCs_SnSHS/nelJGggip";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/GZ0tmCs_SnSHS/nelJGggip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

CC'ing Song Liu (md-raid maintainer) and linux-raid mailing list.

On Fri, 21 Jan 2022 16:38:03 +0000
Roger Willcocks <roger@filmlight.ltd.uk> wrote:

> Hi folks,
>=20
> we noticed a thirty percent drop in performance on one of our raid
> arrays when switching from CentOS 6.5 to 8.4; it uses raid0-like
> striping to balance (by time) access to a pair of hardware raid-6
> arrays. The underlying issue is also present in the native raid0
> driver so herewith the gory details; I'd appreciate your thoughts.
>=20
> --
>=20
> blkdev_direct_IO() calls submit_bio() which calls an outermost
> generic_make_request() (aka submit_bio_noacct()).
>=20
> md_make_request() calls blk_queue_split() which cuts an incoming
> request into two parts with the first no larger than get_max_io_size()
> bytes (which in the case of raid0, is the chunk size):
>=20
>   R -> AB
>  =20
> blk_queue_split() gives the second part 'B' to generic_make_request()
> to worry about later and returns the first part 'A'.
>=20
> md_make_request() then passes 'A' to a more specific request handler,
> In this case raid0_make_request().
>=20
> raid0_make_request() cuts its incoming request into two parts at the
> next chunk boundary:
>=20
> A -> ab
>=20
> it then fixes up the device (chooses a physical device) for 'a', and
> gives both parts, separately, to generic make request()
>=20
> This is where things go awry, because 'b' is still targetted to the
> original device (same as 'B'), but 'B' was queued before 'b'. So we
> end up with:
>=20
>   R -> Bab
>=20
> The outermost generic_make_request() then cuts 'B' at
> get_max_io_size(), and the process repeats. Ascii art follows:
>=20
>=20
>     /---------------------------------------------------/   incoming rq
>=20
>     /--------/--------/--------/--------/--------/------/   max_io_size
>      =20
> |--------|--------|--------|--------|--------|--------|--------| chunks
>=20
> |...=3D=3D=3D=3D=3D|---=3D=3D=3D=3D=3D|---=3D=3D=3D=3D=3D|---=3D=3D=3D=3D=
=3D|---=3D=3D=3D=3D=3D|---=3D=3D=3D=3D=3D|--......| rq out
>       a    b  c     d  e     f  g     h  i     j  k     l
>=20
> Actual submission order for two-disk raid0: 'aeilhd' and 'cgkjfb'
>=20
> --
>=20
> There are several potential fixes -
>=20
> simplest is to set raid0 blk_queue_max_hw_sectors() to UINT_MAX
> instead of chunk_size, so that raid0_make_request() receives the
> entire transfer length and cuts it up at chunk boundaries;
>=20
> neatest is for raid0_make_request() to recognise that 'b' doesn't
> cross a chunk boundary so it can be sent directly to the physical
> device;
>=20
> and correct is for blk_queue_split to requeue 'A' before 'B'.
>=20
> --
>=20
> There's also a second issue - with large raid0 chunk size (256K), the
> segments submitted to the physical device are at least 128K and
> trigger the early unplug code in blk_mq_make_request(), so the
> requests are never merged. There are legitimate reasons for a large
> chunk size so this seems unhelpful.
>=20
> --
>=20
> As I said, I'd appreciate your thoughts.
>=20
> --
>=20
> Roger
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>=20



--=20


--Sig_/GZ0tmCs_SnSHS/nelJGggip
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHtl9oACgkQNasLKJxd
sli4Sw/+N9iq8lks5gThYPYEHqhuC6L6uxjdOaKbogXJeJTFOJgeEVK2h8uDmmRF
O2v0r6+GVf9NUL6PDYPKYyixprJVIFAlnysylH/dWxXoQpfOgy43ZZ1GzsHabuvb
zNUszjQZup1siYl4aPm/XmHF3IhaQWlM0zRVSC/A5kysJaAWvdRV2ZW8G0kO5kBP
kDTF0oNEaq2LuYhH5V//9gXJnG7uNAqh+m+vEs/spYLiExkvBv4zHnKIJqA46ZxZ
zb/NXlRuAKE7EQZUzKCUhErSaMz/YDxA9eb/6lDFq44SwjE3tJoW269ED5pKNxm9
yiZebo+iWCKm1qkzyECSTNAQ/qqVb+jXCI8864tQjjd/tRYnV15MGeFfJkhmUKJP
E2cjz5jmNNg6m95qzQKB0dAepJSq4b6xWdg2CvfPdxnj5UQU5PXVpeopldaE9DER
pCXHPPpBwbYDkIVWgFP2HV8GQ71xHl3Y9jfrMzMrA44vUPK7agU4gZcqEdP80mle
mrv/xbkqo/uvZ2AVBs89Ohxdd5AdnbcVJjfnDRWHAC5HFMDB4wJoLPQX0cByMhlr
QQbfxv1/QdPWGugwSxPMkET0ya8xlMNgGADn1aCzmGCgnhih33s0YxyDFPaQBV4N
oAFbVrpJW068KXTSyBwTN5migxe58FEkOjDQKfdvATOZfpMaIag=
=MMEp
-----END PGP SIGNATURE-----

--Sig_/GZ0tmCs_SnSHS/nelJGggip--


--===============2144499198061939889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2144499198061939889==--

