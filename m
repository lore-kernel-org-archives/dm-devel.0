Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB9F1C77B7A
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686154899;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=ChVYWY0PmhqHl8EeNHlI6SSKmLUgnIq/uuRPAhnYItk=;
	b=i9GGkic9DTK/5/O8eCOl+NuC5vYJ9o3L+TK/gGDSIBrbsrnbqGy1er3IfIVVTF8o6VQldl
	zL4KGrXE9VHGp0sz5CmewHdxmVyfDW9ri7MEU4Is+CzSt6LjxKSgQR3kpBtb3P3faTRLl9
	TJvbn+/jn8bHW+xVBJiTP3PeKXxJhZM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-M1cvgpk8NESLpouL0dWTpQ-1; Wed, 07 Jun 2023 12:21:06 -0400
X-MC-Unique: M1cvgpk8NESLpouL0dWTpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A680C8030D2;
	Wed,  7 Jun 2023 16:18:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AAD49E93;
	Wed,  7 Jun 2023 16:18:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D46A19452C3;
	Wed,  7 Jun 2023 16:18:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EAEDF19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 16:17:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B8356C0004B; Wed,  7 Jun 2023 16:17:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B007DC0448E
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 16:17:55 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87D9E1C01728
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 16:17:55 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
 [66.111.4.29]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-Zs8vzRMfMmi1YilgLWwisw-1; Wed, 07 Jun 2023 12:15:20 -0400
X-MC-Unique: Zs8vzRMfMmi1YilgLWwisw-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.nyi.internal (Postfix) with ESMTP id B0E555C0156;
 Wed,  7 Jun 2023 12:14:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute4.internal (MEProxy); Wed, 07 Jun 2023 12:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:content-type:date
 :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
 :references:reply-to:sender:subject:subject:to:to; s=fm1; t=
 1686154492; x=1686240892; bh=QKN//D7ch2wGcis9ZuO+0faQUbCTNZMH3AV
 l7UWGzdA=; b=Mgdjc0heA9TJLiUXmgzW+Y2ZlCDLFpas+Ymt4B9XT31z+LiMb79
 5kTpRt5Q2Su+FIcVtau2DhPDXi7uL7Rj7JEwPG8TT9Nl2slnd4LTFfkycFqzMPuZ
 Ug6XSb9X1kcGEt9AZxBYZ9Y4uOQCebobSkJ3By0Y1n3UEujGvyjlup82PlKfJT9c
 MGP3qsimyrv3Cilu9LINDWsGySS2n9qGh082z4RpBK+psVpbfbT6UgOxNpz9HYvc
 JmGpyyCRWdTcKbEDciAeUhVT0/lTVJuAFT8KmmWMP009BbPIt4GdmYW7trAwkRQN
 0No89GkOZdl6sXurulELBgGguqtSrWSYnug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm1; t=1686154492; x=1686240892; bh=QKN//D7ch2wGc
 is9ZuO+0faQUbCTNZMH3AVl7UWGzdA=; b=DpXRUWMGSsazhraVGXGV5QIr9QPqL
 yyJmYEu8DScVfJV8rN/tpaCA2NSD+W0VYv/5xvfiW/bjOJY0591/U4itzKSgjQ71
 SPEOcyB75zawDPN4Ok9jUEE8BxIIKCI3McyTMp1eXFWvTslRywp+lGPehhbZ6dBM
 t8RVYGILdS04K1m6P32UB+/EyNSE/P4aqeKXXAmgp43Cv4nJkJtSXDdaq24ZCTvC
 0dWQA5EthbGW4uTYC5yNBdF5csixSXWUYSAhoffZgnpEN9nUXB+RkcEOIevINvKs
 qDbtnogdMkqtAuJ6N+O2v79apbt7O1a/I3MS6GwnpQvN0R3vYW5Fu9DrQ==
X-ME-Sender: <xms:_KyAZHeOSw-jsF99MG_IgHo5j5v0U6HLhs1qZsvZTKzCAlA8foyDvQ>
 <xme:_KyAZNOu1DQboiQVEHMGz5ou9TpzXYovtKt5zR--GMnuaR7HqpGoEIhTMppBeqSh2
 QC5jezi2fenB7o>
X-ME-Received: <xmr:_KyAZAhahK8g40SbSUWOKDRluKGcZb9FHGiMdooAKmhDLA0TRyVOj4EKBJM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtgedgleelucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepvdejteegkefhteduhffgteffgeff
 gfduvdfghfffieefieekkedtheegteehffelnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:_KyAZI_xgNif72LUXabvp63aNuL7PpsTIrEVrSvu36w2WSsS2EFd3w>
 <xmx:_KyAZDsYBfammgWqsUKulry2Jgz0_CrtIpLFS63q1Ve2c_OSP5dIhQ>
 <xmx:_KyAZHHvOlXoPL_U4Hf89KUkNdOXQSGx0smD6s0gzLwe2CskapQ2Tg>
 <xmx:_KyAZHh_pVIzCPW8SwxhUC-8k14yC1qSGYuqGFApIjFNQyL73AwsWw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jun 2023 12:14:51 -0400 (EDT)
Date: Wed, 7 Jun 2023 12:14:46 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Message-ID: <ZICs+WYCPYdu2yoI@itl-email>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-14-demi@invisiblethingslab.com>
 <ZH7tizoYl8YVFN9B@Air-de-Roger> <ZH9mZGbM32CDmKGF@itl-email>
 <ZIA9uBJxx2gqA4Cq@Air-de-Roger>
MIME-Version: 1.0
In-Reply-To: <ZIA9uBJxx2gqA4Cq@Air-de-Roger>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 13/16] xen-blkback: Implement diskseq
 checks
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Content-Type: multipart/mixed; boundary="===============7144277664386820010=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5


--===============7144277664386820010==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0tmOeWojyIbdbJsu"
Content-Disposition: inline


--0tmOeWojyIbdbJsu
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 7 Jun 2023 12:14:46 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 13/16] xen-blkback: Implement diskseq checks

On Wed, Jun 07, 2023 at 10:20:08AM +0200, Roger Pau Monn=C3=A9 wrote:
> On Tue, Jun 06, 2023 at 01:01:20PM -0400, Demi Marie Obenour wrote:
> > On Tue, Jun 06, 2023 at 10:25:47AM +0200, Roger Pau Monn=C3=A9 wrote:
> > > On Tue, May 30, 2023 at 04:31:13PM -0400, Demi Marie Obenour wrote:
> > > > This allows specifying a disk sequence number in XenStore.  If it d=
oes
> > > > not match the disk sequence number of the underlying device, the de=
vice
> > > > will not be exported and a warning will be logged.  Userspace can u=
se
> > > > this to eliminate race conditions due to major/minor number reuse.
> > > > Old kernels do not support the new syntax, but a later patch will a=
llow
> > > > userspace to discover that the new syntax is supported.
> > > >=20
> > > > Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> > > > ---
> > > >  drivers/block/xen-blkback/xenbus.c | 112 +++++++++++++++++++++++--=
----
> > > >  1 file changed, 89 insertions(+), 23 deletions(-)
> > > >=20
> > > > diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen=
-blkback/xenbus.c
> > > > index 4807af1d58059394d7a992335dabaf2bc3901721..9c3eb148fbd802c74e6=
26c3d7bcd69dcb09bd921 100644
> > > > --- a/drivers/block/xen-blkback/xenbus.c
> > > > +++ b/drivers/block/xen-blkback/xenbus.c
> > > > @@ -24,6 +24,7 @@ struct backend_info {
> > > >  	struct xenbus_watch	backend_watch;
> > > >  	unsigned		major;
> > > >  	unsigned		minor;
> > > > +	unsigned long long	diskseq;
> > >=20
> > > Since diskseq is declared as u64 in gendisk, better use the same type
> > > here too?
> >=20
> > simple_strtoull() returns an unsigned long long, and C permits unsigned
> > long long to be larger than 64 bits.
>=20
> Right, but the type of gendisk is u64.  It's fine if you want to store
> the result of simple_strtoull() into an unsigned long long and do
> whatever checks to assert it matches the format expected by gendisk,
> but ultimately the field type would better use u64 for consistency IMO.

I changed my mind on this, not least because the 16-byte length limit
means that the value is limited to UINT64_MAX anyway.

> > > > @@ -725,10 +749,46 @@ static void backend_changed(struct xenbus_wat=
ch *watch,
> > > >  		return;
> > > >  	}
> > > > =20
> > > > -	if (be->major | be->minor) {
> > > > -		if (be->major !=3D major || be->minor !=3D minor)
> > > > -			pr_warn("changing physical device (from %x:%x to %x:%x) not sup=
ported.\n",
> > > > -				be->major, be->minor, major, minor);
> > > > +	diskseq_str =3D xenbus_read(XBT_NIL, dev->nodename, "diskseq", &d=
iskseq_len);
> > > > +	if (IS_ERR(diskseq_str)) {
> > > > +		int err =3D PTR_ERR(diskseq_str);
> > > > +		diskseq_str =3D NULL;
> > > > +
> > > > +		/*
> > > > +		 * If this does not exist, it means legacy userspace that does n=
ot
> > > > +		 * support diskseq.
> > > > +		 */
> > > > +		if (unlikely(!XENBUS_EXIST_ERR(err))) {
> > > > +			xenbus_dev_fatal(dev, err, "reading diskseq");
> > > > +			return;
> > > > +		}
> > > > +		diskseq =3D 0;
> > > > +	} else if (diskseq_len <=3D 0) {
> > > > +		xenbus_dev_fatal(dev, -EFAULT, "diskseq must not be empty");
> > > > +		goto fail;
> > > > +	} else if (diskseq_len > 16) {
> > > > +		xenbus_dev_fatal(dev, -ERANGE, "diskseq too long: got %d but lim=
it is 16",
> > > > +				 diskseq_len);
> > > > +		goto fail;
> > > > +	} else if (diskseq_str[0] =3D=3D '0') {
> > > > +		xenbus_dev_fatal(dev, -ERANGE, "diskseq must not start with '0'"=
);
> > > > +		goto fail;
> > > > +	} else {
> > > > +		char *diskseq_end;
> > > > +		diskseq =3D simple_strtoull(diskseq_str, &diskseq_end, 16);
> > > > +		if (diskseq_end !=3D diskseq_str + diskseq_len) {
> > > > +			xenbus_dev_fatal(dev, -EINVAL, "invalid diskseq");
> > > > +			goto fail;
> > > > +		}
> > > > +		kfree(diskseq_str);
> > > > +		diskseq_str =3D NULL;
> > > > +	}
> > >=20
> > > Won't it be simpler to use xenbus_scanf() with %llx formatter?
> >=20
> > xenbus_scanf() doesn=E2=80=99t check for overflow and accepts lots of j=
unk it
> > really should not.  Should this be fixed in xenbus_scanf()?
>=20
> That would be my preference, so that you can use it here instead of
> kind of open-coding it.

This winds up being a much more invasive patch as it requires changing
sscanf().  It also has a risk (probably mostly theoretical) of breaking
buggy userspace that passes garbage values here.

> > > Also, we might want to fetch "physical-device" and "diskseq" inside
> > > the same xenstore transaction.
> >=20
> > Should the rest of the xenstore reads be included in the same
> > transaction?
>=20
> I guess it would make the code simpler to indeed fetch everything
> inside the same transaction.

Okay, will change in v3.

> > > Also, you tie this logic to the "physical-device" watch, which
> > > strictly implies that the "diskseq" node must be written to xenstore
> > > before the "physical-device" node.  This seems fragile, but I don't
> > > see much better optiono since the "diskseq" is optional.
> >=20
> > What about including the diskseq in the "physical-device" node?  Perhaps
> > use diskseq@major:minor syntax?
>=20
> Hm, how would you know whether the blkback instance in the kernel
> supports the diskseq syntax in physical-device?

That=E2=80=99s what the next patch is for =F0=9F=99=82.

> Can you fetch a disk using a diskseq identifier?

Not yet, although I have considered adding this ability.  It would be
one step towards a =E2=80=9Cdiskseqfs=E2=80=9D that userspace could use to =
open a device
by diskseq.

> Why I understand that this is an extra safety check in order to assert
> blkback is opening the intended device, is this attempting to fix some
> existing issue?

Yes, it is.  I have a block script (written in C) that validates the
device it has opened before passing the information to blkback.  It uses
the diskseq to do this, but for that protection to be complete, blkback
must also be aware of it.

> I'm not sure I see how the major:minor numbers would point to a
> different device than the one specified by the toolstack unless the
> admin explicitly messes with the devices before blkback has got time
> to open them.  But then the admin can already do pretty much
> everything it wants with the system.

Admins typically refer to e.g. device-mapper devices by name, not by
major:minor number.  If a device is destroyed and recreated right as the
block script is running, this race condition can occur.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--0tmOeWojyIbdbJsu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmSArPoACgkQsoi1X/+c
IsG2Sw/+IRODwFvB3hw6+YXnA+p574mfNGw2RAkb4TUKRkKNV9k6a/f7TWk3gk52
dYk5ddTL3KtZNQ0JHuP+MGSsrFHCtFSXR1hwC0jYOSFSrfIHlsFlMJVnYZpdoN0n
vaCWJOthQ2GiUshPKEU5moQUY6h1ncIXazZ+qp+w9ys+NhSuFl1WS3mTg8sFYMH/
DFjVJ34RJgE+l2HAaDfWTpWWD9KnaGSNtnbZT7X6xa3i0c65SeugbFqzi+dGYEJj
kHki/FyHT4118O6S5+oK/4w2p+lr5iF71MqLxPlFLBjZuhjb+75uo7qDR8iN9bDU
p+CH5NiBR9JjZ1AK5kZds8OdhRNjJTVpWfKQBkGd+CS0EXeKGhgCpFItjSmrtwCg
jzClxpTP7/V4pLSjH8eotBIm2g8PX3lkTjyGHujhyQ8zNCAofL8rFVYa7gkkU5ZV
Vr8MH7FNiUZuXkPVuotQ9/QI7XmnBnwxwxvddzo9F4nrewgOQP6/Xn9w7MnTiYN8
O+ixXsULrj01Zna4lFUEwg95dscNrRKKjqoKsvxF/uJrLfdxHdAjZcYgSdJYr9gy
ApUsWXuknsYldPizjC6qkLaJGU1v43xOUODGpELnOqC9mlW8d8TlmfrwnXDUpOhX
i6Uvu+htPNKFH4x1ExbZ0k997nR0Pq1fmZc1mpCsv8wzPALSswY=
=XMZ2
-----END PGP SIGNATURE-----

--0tmOeWojyIbdbJsu--


--===============7144277664386820010==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7144277664386820010==--

