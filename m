Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D98C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 08:49:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E106B22CF6
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 08:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E106B22CF6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-yiC8aS1ZNP-1zp24cNd0Hw-1; Mon, 25 Jan 2021 03:49:03 -0500
X-MC-Unique: yiC8aS1ZNP-1zp24cNd0Hw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3341E612B2;
	Mon, 25 Jan 2021 08:48:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0483A10016FB;
	Mon, 25 Jan 2021 08:48:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA8541809CA2;
	Mon, 25 Jan 2021 08:48:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MIBjr2017182 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 13:11:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CBB3610E60F7; Fri, 22 Jan 2021 18:11:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97F6510EB2BE
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 18:11:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CF29101A567
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 18:11:43 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-31-JrkOAZVZPxyd52z-Gbq16w-1; 
	Fri, 22 Jan 2021 13:11:39 -0500
X-MC-Unique: JrkOAZVZPxyd52z-Gbq16w-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F92223A6A;
	Fri, 22 Jan 2021 18:05:50 +0000 (UTC)
Date: Fri, 22 Jan 2021 20:05:48 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <YAsT/N8CHHNTZcj3@kernel.org>
References: <20210122084321.24012-1-a.fatoum@pengutronix.de>
	<20210122084321.24012-2-a.fatoum@pengutronix.de>
MIME-Version: 1.0
In-Reply-To: <20210122084321.24012-2-a.fatoum@pengutronix.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10MIBjr2017182
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 25 Jan 2021 03:48:36 -0500
Cc: Sumit Garg <sumit.garg@linaro.org>,
	Jan =?iso-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>,
	Mike Snitzer <snitzer@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, keyrings@vger.kernel.org,
	kernel@pengutronix.de, linux-integrity@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] dm crypt: support using trusted keys
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 22, 2021 at 09:43:21AM +0100, Ahmad Fatoum wrote:
> Commit 27f5411a718c ("dm crypt: support using encrypted keys") extended
> dm-crypt to allow use of "encrypted" keys along with "user" and "logon".
>=20
> Along the same lines, teach dm-crypt to support "trusted" keys as well.
>=20
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---

Is it possible to test run this with tmpfs? Would be a good test
target for Sumit's ARM-TEE trusted keys patches.

https://lore.kernel.org/linux-integrity/1604419306-26105-1-git-send-email-s=
umit.garg@linaro.org/

/Jarkko

> Unsure on whether target_type::version is something authors increment or
> maintainers fix up. I can respin if needed.
>=20
> Cc: Jan L=FCbbe <jlu@pengutronix.de>
> Cc: linux-integrity@vger.kernel.org
> Cc: keyrings@vger.kernel.org
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  .../admin-guide/device-mapper/dm-crypt.rst    |  2 +-
>  drivers/md/Kconfig                            |  1 +
>  drivers/md/dm-crypt.c                         | 23 ++++++++++++++++++-
>  3 files changed, 24 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Docum=
entation/admin-guide/device-mapper/dm-crypt.rst
> index 1a6753b76dbb..aa2d04d95df6 100644
> --- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> @@ -67,7 +67,7 @@ Parameters::
>      the value passed in <key_size>.
> =20
>  <key_type>
> -    Either 'logon', 'user' or 'encrypted' kernel key type.
> +    Either 'logon', 'user', 'encrypted' or 'trusted' kernel key type.
> =20
>  <key_description>
>      The kernel keyring key description crypt target should look for
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 9e44c09f6410..f2014385d48b 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -270,6 +270,7 @@ config DM_CRYPT
>  =09tristate "Crypt target support"
>  =09depends on BLK_DEV_DM
>  =09depends on (ENCRYPTED_KEYS || ENCRYPTED_KEYS=3Dn)
> +=09depends on (TRUSTED_KEYS || TRUSTED_KEYS=3Dn)
>  =09select CRYPTO
>  =09select CRYPTO_CBC
>  =09select CRYPTO_ESSIV
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 7eeb9248eda5..6c7c687e546c 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -37,6 +37,7 @@
>  #include <linux/key-type.h>
>  #include <keys/user-type.h>
>  #include <keys/encrypted-type.h>
> +#include <keys/trusted-type.h>
> =20
>  #include <linux/device-mapper.h>
> =20
> @@ -2452,6 +2453,22 @@ static int set_key_encrypted(struct crypt_config *=
cc, struct key *key)
>  =09return 0;
>  }
> =20
> +static int set_key_trusted(struct crypt_config *cc, struct key *key)
> +{
> +=09const struct trusted_key_payload *tkp;
> +
> +=09tkp =3D key->payload.data[0];
> +=09if (!tkp)
> +=09=09return -EKEYREVOKED;
> +
> +=09if (cc->key_size !=3D tkp->key_len)
> +=09=09return -EINVAL;
> +
> +=09memcpy(cc->key, tkp->key, cc->key_size);
> +
> +=09return 0;
> +}
> +
>  static int crypt_set_keyring_key(struct crypt_config *cc, const char *ke=
y_string)
>  {
>  =09char *new_key_string, *key_desc;
> @@ -2484,6 +2501,10 @@ static int crypt_set_keyring_key(struct crypt_conf=
ig *cc, const char *key_string
>  =09=09   !strncmp(key_string, "encrypted:", key_desc - key_string + 1)) =
{
>  =09=09type =3D &key_type_encrypted;
>  =09=09set_key =3D set_key_encrypted;
> +=09} else if (IS_ENABLED(CONFIG_TRUSTED_KEYS) &&
> +=09           !strncmp(key_string, "trusted:", key_desc - key_string + 1=
)) {
> +=09=09type =3D &key_type_trusted;
> +=09=09set_key =3D set_key_trusted;
>  =09} else {
>  =09=09return -EINVAL;
>  =09}
> @@ -3555,7 +3576,7 @@ static void crypt_io_hints(struct dm_target *ti, st=
ruct queue_limits *limits)
> =20
>  static struct target_type crypt_target =3D {
>  =09.name   =3D "crypt",
> -=09.version =3D {1, 22, 0},
> +=09.version =3D {1, 23, 0},
>  =09.module =3D THIS_MODULE,
>  =09.ctr    =3D crypt_ctr,
>  =09.dtr    =3D crypt_dtr,
> --=20
> 2.30.0
>=20
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

