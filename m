Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E50CC6FD1D
	for <dm-devel@archiver.kernel.org>; Wed, 15 Mar 2023 21:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678915980;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8CAC0pawA1UOCHcj7tMcOqUTaFD/e0aVcX3MCqkaSA4=;
	b=Lix+tzYpCqu0P2NpzFuKyVHXdA0QQzBKRSez7G6Xu/eea8rdlsYQpL4ycfRaAZjdT/4esf
	p0BDMwYEvzvexA5WDfe1WMDI/tk7FiUgLWbGDceRBE27cQDA9oAOY8gFydQvaw8ruUl1xu
	YDafw8VciEGJyblyaAoWsNa6Jxc3HEI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-I5mp9FjUOzSz4sq0uzpJOw-1; Wed, 15 Mar 2023 17:32:56 -0400
X-MC-Unique: I5mp9FjUOzSz4sq0uzpJOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF0C928237D1;
	Wed, 15 Mar 2023 21:32:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 331E72166B26;
	Wed, 15 Mar 2023 21:32:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EBAD419466DF;
	Wed, 15 Mar 2023 21:32:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E1351946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Mar 2023 21:32:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 173EAC15A0B; Wed, 15 Mar 2023 21:32:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D188EC164E7;
 Wed, 15 Mar 2023 21:32:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 32FLWn3a013586;
 Wed, 15 Mar 2023 16:32:49 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 32FLWmg0013585;
 Wed, 15 Mar 2023 16:32:48 -0500
Date: Wed, 15 Mar 2023 16:32:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230315213248.GD19878@octiron.msp.redhat.com>
References: <20230315164813.2939-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230315164813.2939-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] multipath-tools tests: use assert_true/false
 instead of assert()
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
Cc: dm-devel@redhat.com, dmueller@suse.com,
 Dirk =?iso-8859-1?Q?M=FCller?= <dirk@dmllr.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 05:48:12PM +0100, mwilck@suse.com wrote:
> From: Dirk M=FCller <dirk@dmllr.de>
>=20
> Otherwise the build fails with userspace-rcu 0.14 with
>=20
>    error: implicit declaration of function 'assert' [-Werror=3Dimplicit-f=
unction-declaration]
>    note: 'assert' is defined in header '<assert.h>'; did you forget to '#=
include <assert.h>'?
>=20
> Until liburcu 0.13.0, this didn't show up as a compile error, because
> "assert.h" was pulled in via config.h -> urcu.h.
>=20
> But these assert() calls should have been cmocka assert macros
> in the first place.
>=20
> Signed-off-by: Dirk M=FCller <dirk@dmllr.de>
> Signed-off-by: Martin Wilck <mwilck@suse.com>


Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  tests/util.c | 44 +++++++++++++++++++++-----------------------
>  tests/vpd.c  |  2 +-
>  2 files changed, 22 insertions(+), 24 deletions(-)
>=20
> diff --git a/tests/util.c b/tests/util.c
> index 9affb0e..d6083dc 100644
> --- a/tests/util.c
> +++ b/tests/util.c
> @@ -193,7 +193,7 @@ static void test_bitmask_1(void **state)
>  =09for (j =3D 0; j < BITARR_SZ; j++) {
>  =09=09for (i =3D 0; i < 64; i++) {
>  =09=09=09b =3D 64 * j + i;
> -=09=09=09assert(!is_bit_set_in_bitfield(b, bf));
> +=09=09=09assert_false(is_bit_set_in_bitfield(b, bf));
>  =09=09=09set_bit_in_bitfield(b, bf);
>  =09=09=09for (k =3D 0; k < BITARR_SZ; k++) {
>  #if 0
> @@ -207,13 +207,13 @@ static void test_bitmask_1(void **state)
>  =09=09=09}
>  =09=09=09for (m =3D 0; m < 64; m++)
>  =09=09=09=09if (i =3D=3D m)
> -=09=09=09=09=09assert(is_bit_set_in_bitfield(64 * j + m,
> -=09=09=09=09=09=09=09=09      bf));
> +=09=09=09=09=09assert_true(is_bit_set_in_bitfield(64 * j + m,
> +=09=09=09=09=09=09=09=09=09   bf));
>  =09=09=09=09else
> -=09=09=09=09=09assert(!is_bit_set_in_bitfield(64 * j + m,
> -=09=09=09=09=09=09=09=09       bf));
> +=09=09=09=09=09assert_false(is_bit_set_in_bitfield(64 * j + m,
> +=09=09=09=09=09=09=09=09=09   bf));
>  =09=09=09clear_bit_in_bitfield(b, bf);
> -=09=09=09assert(!is_bit_set_in_bitfield(b, bf));
> +=09=09=09assert_false(is_bit_set_in_bitfield(b, bf));
>  =09=09=09for (k =3D 0; k < BITARR_SZ; k++)
>  =09=09=09=09assert_int_equal(arr[k], 0ULL);
>  =09=09}
> @@ -235,16 +235,16 @@ static void test_bitmask_2(void **state)
>  =09for (j =3D 0; j < BITARR_SZ; j++) {
>  =09=09for (i =3D 0; i < 64; i++) {
>  =09=09=09b =3D 64 * j + i;
> -=09=09=09assert(!is_bit_set_in_bitfield(b, bf));
> +=09=09=09assert_false(is_bit_set_in_bitfield(b, bf));
>  =09=09=09set_bit_in_bitfield(b, bf);
>  =09=09=09for (m =3D 0; m < 64; m++)
>  =09=09=09=09if (m <=3D i)
> -=09=09=09=09=09assert(is_bit_set_in_bitfield(64 * j + m,
> -=09=09=09=09=09=09=09=09      bf));
> +=09=09=09=09=09assert_true(is_bit_set_in_bitfield(64 * j + m,
> +=09=09=09=09=09=09=09=09=09   bf));
>  =09=09=09=09else
> -=09=09=09=09=09assert(!is_bit_set_in_bitfield(64 * j + m,
> -=09=09=09=09=09=09=09=09       bf));
> -=09=09=09assert(is_bit_set_in_bitfield(b, bf));
> +=09=09=09=09=09assert_false(is_bit_set_in_bitfield(64 * j + m,
> +=09=09=09=09=09=09=09=09=09    bf));
> +=09=09=09assert_true(is_bit_set_in_bitfield(b, bf));
>  =09=09=09for (k =3D 0; k < BITARR_SZ; k++) {
>  =09=09=09=09if (k < j || (k =3D=3D j && i =3D=3D 63))
>  =09=09=09=09=09assert_int_equal(arr[k], ~0ULL);
> @@ -260,16 +260,16 @@ static void test_bitmask_2(void **state)
>  =09for (j =3D 0; j < BITARR_SZ; j++) {
>  =09=09for (i =3D 0; i < 64; i++) {
>  =09=09=09b =3D 64 * j + i;
> -=09=09=09assert(is_bit_set_in_bitfield(b, bf));
> +=09=09=09assert_true(is_bit_set_in_bitfield(b, bf));
>  =09=09=09clear_bit_in_bitfield(b, bf);
>  =09=09=09for (m =3D 0; m < 64; m++)
>  =09=09=09=09if (m <=3D i)
> -=09=09=09=09=09assert(!is_bit_set_in_bitfield(64 * j + m,
> -=09=09=09=09=09=09=09=09       bf));
> +=09=09=09=09=09assert_false(is_bit_set_in_bitfield(64 * j + m,
> +=09=09=09=09=09=09=09=09=09    bf));
>  =09=09=09=09else
> -=09=09=09=09=09assert(is_bit_set_in_bitfield(64 * j + m,
> -=09=09=09=09=09=09=09=09      bf));
> -=09=09=09assert(!is_bit_set_in_bitfield(b, bf));
> +=09=09=09=09=09assert_true(is_bit_set_in_bitfield(64 * j + m,
> +=09=09=09=09=09=09=09=09=09   bf));
> +=09=09=09assert_false(is_bit_set_in_bitfield(b, bf));
>  =09=09=09for (k =3D 0; k < BITARR_SZ; k++) {
>  =09=09=09=09if (k < j || (k =3D=3D j && i =3D=3D 63))
>  =09=09=09=09=09assert_int_equal(arr[k], 0ULL);
> @@ -316,9 +316,8 @@ static void _test_bitmask_small(unsigned int n)
>  =09uint32_t *arr;
>  =09unsigned int size =3D maybe_swap_idx((n - 1) / 32) + 1, i;
> =20
> -=09assert(sizeof(bitfield_t) =3D=3D 4 || sizeof(bitfield_t) =3D=3D 8);
> -=09assert(n <=3D 64);
> -=09assert(n >=3D 1);
> +=09assert_true(sizeof(bitfield_t) =3D=3D 4 || sizeof(bitfield_t) =3D=3D =
8);
> +=09assert_in_range(n, 1, 64);
> =20
>  =09bf =3D alloc_bitfield(n);
>  =09assert_non_null(bf);
> @@ -366,8 +365,7 @@ static void _test_bitmask_small_2(unsigned int n)
>  =09uint32_t *arr;
>  =09unsigned int size =3D maybe_swap_idx((n - 1) / 32) + 1, i;
> =20
> -=09assert(n <=3D 128);
> -=09assert(n >=3D 65);
> +=09assert_in_range(n, 65, 128);
> =20
>  =09bf =3D alloc_bitfield(n);
>  =09assert_non_null(bf);
> diff --git a/tests/vpd.c b/tests/vpd.c
> index a7d2092..1b2d62d 100644
> --- a/tests/vpd.c
> +++ b/tests/vpd.c
> @@ -119,7 +119,7 @@ static void hex2bin(unsigned char *dst, const char *s=
rc,
>  =09const char *sc;
>  =09unsigned char *ds;
> =20
> -=09assert(srclen % 2 =3D=3D 0);
> +=09assert_true(srclen % 2 =3D=3D 0);
>  =09for (sc =3D src, ds =3D dst;
>  =09     sc < src + srclen &&  ds < dst + dstlen;
>  =09     sc +=3D 2, ++ds)
> --=20
> 2.39.2
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

