Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF3AC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 20:02:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-LNfjJTWoMHmWJEmfOQgJRQ-1; Tue, 18 Jan 2022 15:02:41 -0500
X-MC-Unique: LNfjJTWoMHmWJEmfOQgJRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C1B01F5AD;
	Tue, 18 Jan 2022 20:02:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCB0AB18A6;
	Tue, 18 Jan 2022 20:02:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4EC241809CB9;
	Tue, 18 Jan 2022 20:02:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20IK2Xc0023141 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 15:02:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2E836401E66; Tue, 18 Jan 2022 20:02:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AD2D401E6A
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 20:02:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11721185A79C
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 20:02:33 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
	[139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-378-yZ_Ih3vrNfKmZI2osXg0JQ-1; Tue, 18 Jan 2022 15:02:31 -0500
X-MC-Unique: yZ_Ih3vrNfKmZI2osXg0JQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id B91536127C;
	Tue, 18 Jan 2022 20:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F24C340E0;
	Tue, 18 Jan 2022 20:02:29 +0000 (UTC)
Date: Tue, 18 Jan 2022 12:02:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Israel Rukshin <israelr@nvidia.com>
Message-ID: <Yecc1BemVbBSjEo+@sol.localdomain>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<YeH+Bv9KlceWbm05@sol.localdomain>
	<ad0f7b35-2f68-ed21-fb14-b6952339a6b8@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <ad0f7b35-2f68-ed21-fb14-b6952339a6b8@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20IK2Xc0023141
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, dm-devel <dm-devel@redhat.com>,
	Nitzan Carmi <nitzanc@nvidia.com>, oren@nvidia.com
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 16, 2022 at 12:15:22PM +0200, Israel Rukshin wrote:
>=20
> Yes, I implemented your inline callbacks at nvme-rdma driver. The driver
> communicates with
>=20
> the HW via a general ib_verbs layer, so I had to extend ib_verbs and mlx5=
_ib
> drivers. Those
>=20
> patches are at internal review and I will send the nvme-rdma patches
> afterwards.
>=20
> >=20
> > Can you also elaborate on how wrapped keys work in your case?  In parti=
cular,
> > are they compatible with the whole design which I've documented in deta=
il in my
> > patchset?  That would include implementing the ->import_key, ->generate=
_key,
> > ->prepare_key, and ->derive_sw_secret operations.  All the different pa=
rts are
> > important.  If something needs to be optional, that's something I can c=
onsider
> > incorporating into the design, but it would restrict the use cases.
>=20
> In my case, the user should create wrapped keys by himself via a user spa=
ce=A0
> tool based
>=20
> on openssl library. Therefore, the ->import_key, ->generate_key and
> ->prepare_key are
>=20
> not necessary at my case. Regarding ->derive_sw_secret, it is not support=
ed
> right now by
>=20
> ConnectX6 DX firmware (we plan to add support for this).=A0 To test fscry=
pt
> with wrapped keys,
>=20
> a temporary WA was added to the ->derive_sw_secret at nvme-rdma driver. T=
he
> other callbacks
>=20
> you mentioned were left empty.

So, what we need to think about is how userspace is expected to actually us=
e and
test the hardware-wrapped keys feature.

My patchset proposed a design where if a block device declares support for
hardware-wrapped keys, then the BLKCRYPTOCREATEKEY and BLKCRYPTOPREPAREKEY
ioctls are available.

Additionally, a specific hardware-internal key hierarchy and KDF is assumed=
 (due
to the need to support ->derive_sw_secret).  While userspace doesn't need t=
o
know these details to use the feature normally, they *must* be known in ord=
er to
test that it's actually working correctly.

If we were to support variants of the feature, such as:

* Hardware-wrapped keys must be created/prepared in some way other than
  BLKCRYPTOCREATEKEY and BLKCRYPTOPREPAREKEY.  (Could you elaborate on=20
  what this way actually is, in your case?)

* Hardware's key hierarchy or KDF is different, so userspace must do someth=
ing
  else when verifying the on-disk ciphertext.

... then we would need to precisely specify these other variants, and defin=
e a
way for userspace to discover what it should do.

In https://lore.kernel.org/r/20211208013534.136590-1-ebiggers@kernel.org, I=
'm
proposing exposing the crypto capabilities of block devices via sysfs.  Tha=
t
could lead to a partial solution, e.g. the kernel could provide a file

=09/sys/block/$disk/queue/crypto/wrapped_keys_variant

... which would allow userspace to discover the supported variant of
hardware-wrapped keys.  I was really hoping that one variant could be
standardized, but that is one possibility.

>=20
> >=20
> > Also, will your driver only support wrapped keys, or will it support st=
andard
> > keys too?
>=20
> Our driver will support both modes. The first step is to support the
> standard keys, because of

Okay, great.  If you're adding inline encryption support to dm-crypt (or to
dm-inline-crypt or to the block layer, depending on what people decide is t=
he
best approach), perhaps you should start with standard keys only, to avoid =
a
dependency on the hardware-wrapped keys feature which is still being worked=
 on?

>=20
> the gap I mentioned above. As I understand, ->derive_sw_secret is not nee=
ded
> for dm-crypt.
>=20
> Is that right?

That's correct.  The larger issue is that if you don't support
->derive_sw_secret, then it's likely that your key hierarchy is different
(probably you don't have a "hierarchy", but rather just one key), which wou=
ld
imply that the feature needs to be tested differently.

As per the above, this could be accounted for in the design by allowing mul=
tiple
variants of wrapped keys.  Of course, that would add complexity.

- Eric


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

