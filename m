Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B74FEB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 20:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687465726;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=k6zCLYnB1N0/E69A2Fr9aPzB1+mHk7duGKxge1KPZWE=;
	b=Je7hl4FkAWzwZYyYmsRyE1lSyWHwYDzGfy0j2zMEILg8efEL4Ab7VZqUSHmzYc04GXgcw1
	UHu7ZCa1hzrJxnzVNb+5kD8MobmBxGh7CqCpOMlB3zjYvXPwTg1YqpIhXa1m1BFWuTypYi
	t1uzFkm2uh7PH7IEV7qUB7PrvskFsVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-R1CGPNu3MmelNl3e2iCS4w-1; Thu, 22 Jun 2023 16:28:38 -0400
X-MC-Unique: R1CGPNu3MmelNl3e2iCS4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EA158E44EC;
	Thu, 22 Jun 2023 20:27:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 51C32F5AD6;
	Thu, 22 Jun 2023 20:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 06BE11946588;
	Thu, 22 Jun 2023 20:27:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1F5A1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 20:27:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 70D5F40C2070; Thu, 22 Jun 2023 20:27:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 690F240C2063
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 20:27:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B5198E44E8
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 20:27:56 +0000 (UTC)
Received: from wout3-smtp.messagingengine.com
 (wout3-smtp.messagingengine.com [64.147.123.19]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-5wstxshnOyK0FsU_0DHC4A-1; Thu, 22 Jun 2023 16:27:53 -0400
X-MC-Unique: 5wstxshnOyK0FsU_0DHC4A-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id 3FEE53200907;
 Thu, 22 Jun 2023 16:27:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute1.internal (MEProxy); Thu, 22 Jun 2023 16:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:content-type:date
 :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
 :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
 1687465665; x=1687552065; bh=ilJlmW5t/nNPJnmJ9TZkHLhft7UuDMdmosF
 my2qk/S8=; b=EBJHw7L/eT0J4kZs8eq/RthZPLrXyDpbFYbvrT4ELAQ20aQTYbN
 fSTsVTOwvCXp5i/KCrZSsG5dmGT21hGXrN6I+qcp23GFOioAkC7JmYXKD/rSMbbh
 ZPngWtXETA7q5tn1vk4IZxxZa4w2hO+EOYgjL9xqb1WB/gK/gFo2BKTZuNWXEBtA
 1D8Qow9UjF2AIzWNV4jVDfCoKJKbkt8mRdM24nxe9tnitkibT/dTEdhDSWiuuO0z
 imGn8pS0p+mAIfGH7mWKf4wpgylhqNwkavwsLGeTglu7OmiMwGQxAlF1mhwadBxD
 Dcqt3rDMM1k5qIr+fcAu1TqxtoNZ159GFjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm2; t=1687465665; x=1687552065; bh=ilJlmW5t/nNPJ
 nmJ9TZkHLhft7UuDMdmosFmy2qk/S8=; b=UhNHZ5sPRRswW9vfl+/iSssWVKGLG
 hY8lnOd+QcqY4UXlJW0VoqunDgXCIpyeGIbK+QLkPRP9dCSS86+WAdtdU9R+zRBP
 6x71TfJAK2G5fT4qaAaqSzsuBQnlTa2A7KFsQFsY6Z2ncpFRKjBFidsnyG5z9BLc
 cCCseu17H5OgyPRW4omgbg9VI6ZbuyYw6QsZPDCQiTG1ZmCDWDRgWstZCKLM61U7
 iD7Sv/ZnsCiJ4pfQJXftBfCuWD2+8JogVQni/CiVN0N/Y95ryxqU1dAPjCum7tT9
 xyR0D5N0tVZEwI+KjsAaNuTOSFLm/gfCV7iIV8/ksb124asDuDCjlqc1Q==
X-ME-Sender: <xms:wa6UZEBWPUC4gRnfPLhesSBAALBGJJQ-nMbwENMcotb_n07fHo_ASQ>
 <xme:wa6UZGhVkcDF15PMF8HWRzo7R88XMFNP3wmjbQWDBVwnv93mILaqou11ZqqOdjcQM
 XHocqlGuXfXvmM>
X-ME-Received: <xmr:wa6UZHkl3XPU0J6zssPiHXctf7TNeYKAZdKPbFDDj9huRouHeQu_Xd9cOSs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeeguddgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvjeetgeekhfetudfhgfetffeg
 fffguddvgffhffeifeeikeektdehgeetheffleenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:wa6UZKwWQ8OXEO61atZ6yScKd2o3GssCiKCRndZxW6qlS2LvHTimDA>
 <xmx:wa6UZJTzwrQ7UtnPND0ecjnRMAJVHBvYZu4eZr_lU4YxcVTzDUHUrw>
 <xmx:wa6UZFZKL4MQuK1gBljJJHpZ2zh1zVIYPnVBHfiWrmMMQy8MiTRDwQ>
 <xmx:wa6UZLdkWlYfiM0yzNViaGbzhthhAv5GOf7W13M7WwwQZjeb5kDKcw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jun 2023 16:27:45 -0400 (EDT)
Date: Thu, 22 Jun 2023 16:27:40 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZJSuv0cdqGR1BEbS@itl-email>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-2-demi@invisiblethingslab.com>
 <7d56d190-b97c-f515-ebd0-c3790f11954@redhat.com>
MIME-Version: 1.0
In-Reply-To: <7d56d190-b97c-f515-ebd0-c3790f11954@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 1/6] device-mapper: Check that target
 specs are sufficiently aligned
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Content-Type: multipart/mixed; boundary="===============6708973722263653402=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5


--===============6708973722263653402==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="atMqDGrroiLEtsgA"
Content-Disposition: inline


--atMqDGrroiLEtsgA
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Jun 2023 16:27:40 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 1/6] device-mapper: Check that target specs
 are sufficiently aligned

On Thu, Jun 22, 2023 at 07:29:52PM +0200, Mikulas Patocka wrote:
>=20
>=20
> On Sat, 3 Jun 2023, Demi Marie Obenour wrote:
>=20
> > Otherwise subsequent code will dereference a misaligned
> > `struct dm_target_spec *`, which is undefined behavior.
> >=20
> > Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/md/dm-ioctl.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >=20
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index cc77cf3d410921432eb0c62cdede7d55b9aa674a..34fa74c6a70db8aa67aaba3=
f6a2fc4f38ef736bc 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -1394,6 +1394,13 @@ static inline fmode_t get_mode(struct dm_ioctl *=
param)
> >  static int next_target(struct dm_target_spec *last, uint32_t next, voi=
d *end,
> >  		       struct dm_target_spec **spec, char **target_params)
> >  {
> > +	static_assert(_Alignof(struct dm_target_spec) <=3D 8,
> > +		      "struct dm_target_spec has excessive alignment requirements");
> > +	if (next % 8) {
> > +		DMERR("Next target spec (offset %u) is not 8-byte aligned", next);
> > +		return -EINVAL;
> > +	}
> > +
> >  	*spec =3D (struct dm_target_spec *) ((unsigned char *) last + next);
> >  	*target_params =3D (char *) (*spec + 1);
> > =20
> > --=20
> > Sincerely,
> > Demi Marie Obenour (she/her/hers)
> > Invisible Things Lab
>=20
> Hi
>=20
> Some architectures (such as 32-bit x86) specify that the alignment of=20
> 64-bit integers is only 4-byte. This could in theory break old userspace=
=20
> code that only uses 4-byte alignment. I would change "next % 8" to "next =
%=20
> __alignof__(struct dm_target_spec)".

That=E2=80=99s fine, provided that the rest of the code is okay with 4-byte
alignment.

> I think that there is no need to backport this patch series to the stable=
=20
> kernels because the bugs that it fixes may only be exploited by the user=
=20
> with CAP_SYS_ADMIN privilege. So, there is no security or reliability=20
> problem being fixed.

I agree that there is no reliability problem, but with kernel lockdown
root =E2=86=92 kernel is a security boundary, so fixes for memory unsafety
problems should still be backported IMO.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--atMqDGrroiLEtsgA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmSUrr8ACgkQsoi1X/+c
IsEIoA/8DWkGd0KGw2WnHuJEvQDRBwlh1Ul4+Bx9L6TCUVH56McjuQR+fUiH/QKg
PGQJSofqHwfFcaadQpHjJSp5FNcElA2gfFARBtOnFkRZAnytpZkEdvbgcPeNC0iD
1C3ss025m7IBVFxyWXbZqL6fyAIsYPSFjYUmlRVJ7lUySzUNIbTuuXoRWtzRdv9D
CmJlKfSI1LDuPVcV96bTJtTXItG+6whsKyQSoZOUV7Wg4JVpO+OqPaBahZFX20Ju
ArgxFM4N1u4VZQjUqf63YwT5ijjNIFOgsh/h37H7H4LtGYcRyu7oSFby8klfQa2T
aOexZyalxphANKoZm4AYpbx1Zp4G0g2Y1r06anldmNsD2PZsbFBsgv7lX2dJapVY
01JaexjpJuvtLQ4NrJgiVOd4Is2C26P3cQnb1R7mdwiwmyf6tWlkkqayVSI8JJJV
EdHnPvYJyx5hKZH8eSeodb8ylcRZoWGROdCu3m3hOBU6+asBfqwXLx80RiFqSLAy
998TUZZ2rfJYLZsvYmNNBdfBQC65xp4iO+sB4Me0By9e3r5tJO27tKm63LR1oO63
wlmPQYEnMFUr1gX2u7opD3XJPow9d9MBk2mjwN0IKqjqyni7kieNTU7MpnVEIaa9
agQLGBCuQ/lQm3zC/OTbpIF1F4ledIhfeGoV0jhOGXiQYfCB/i0=
=Ls9+
-----END PGP SIGNATURE-----

--atMqDGrroiLEtsgA--


--===============6708973722263653402==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6708973722263653402==--

