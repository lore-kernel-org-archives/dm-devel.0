Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E30149DE1
	for <dm-devel@lists.linux.dev>; Wed,  3 Apr 2024 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712154216; cv=none; b=VbAYApdprXmc68vpeN2w534MTutWmjEiuo999oMyYi5PWgEvfLGyHOIc27ImpKmrja6xvgPaZc1Tabh3yovSe//f1YrTnbOiTKQylm0aaZ/DFJyQy4+hHHXzB6dkkGNWgaKasbA/UVm0wOKpNXmnBU5m3mViTLwneY3x5mtgE70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712154216; c=relaxed/simple;
	bh=MJsYbHNQg0lSwmPG/X2o3oLlRyBN/Ty3EYj1mD55ruA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLhj9WeUdYPqguErmhH/MliPc7wOVbYRMCP5qmUh4MEWqSU//g3+3y1bnLaaw3Ia9EKoEihHbCBmmN2BeCfbNsNMB+qUoxRYG6EXM1Po3Yo7GtY+1//2g22ygz7ki12M7A53Ap7/27whr9ozBBRWc0UxCB246hekNdbX8Wv0VJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iqIvpgT1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iqIvpgT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712154213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+gSUDQRMNdN4LCSZGFVEafCl8Q9JC4BYcnfOXZQvm7Y=;
	b=iqIvpgT1KnWTJWBD5IMgA7YO3KnQWIFl7DVOLA47px9I6ICzcrml+ph/3f7wRQvBBYlbOk
	I6NSDb4jpdSaOdY9AOqmerpPk5zwKOKJdelWF85fXLJnvI2B5u8sngBVse5m82XdZO9RGQ
	7XJQlBsE6BqkxK5yfUVLQ+A9K3vAWek=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-466-d96tnrTYOqmWlR_Cdp8zTA-1; Wed,
 03 Apr 2024 10:23:30 -0400
X-MC-Unique: d96tnrTYOqmWlR_Cdp8zTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFABD1C0AF54;
	Wed,  3 Apr 2024 14:23:29 +0000 (UTC)
Received: from localhost (unknown [10.39.194.118])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D1822166B32;
	Wed,  3 Apr 2024 14:23:28 +0000 (UTC)
Date: Wed, 3 Apr 2024 10:23:23 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Eric Blake <eblake@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	David Teigland <teigland@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 7/9] selftests: block_seek_hole: add dm-linear test
Message-ID: <20240403142323.GG2524049@fedora>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240328203910.2370087-8-stefanha@redhat.com>
 <tb76h2qr2aoj6gi5q2ps4dszgvb723vsevm3637kuimxhnhhup@ezvqkck4qgt3>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UFe5qkLdFPYhOF/f"
Content-Disposition: inline
In-Reply-To: <tb76h2qr2aoj6gi5q2ps4dszgvb723vsevm3637kuimxhnhhup@ezvqkck4qgt3>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6


--UFe5qkLdFPYhOF/f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 07:59:14PM -0500, Eric Blake wrote:
> On Thu, Mar 28, 2024 at 04:39:08PM -0400, Stefan Hajnoczi wrote:
> > The dm-linear linear target passes through SEEK_HOLE/SEEK_DATA. Extend
> > the test case to check that the same holes/data are reported as for the
> > underlying file.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  tools/testing/selftests/block_seek_hole/test.py | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/tools/testing/selftests/block_seek_hole/test.py b/tools/te=
sting/selftests/block_seek_hole/test.py
> > index 4f7c2d01ab3d3..6360b72aee338 100755
> > --- a/tools/testing/selftests/block_seek_hole/test.py
> > +++ b/tools/testing/selftests/block_seek_hole/test.py
> > @@ -45,6 +45,20 @@ def loop_device(file_path):
> >      finally:
> >          run(['losetup', '-d', loop_path])
> > =20
> > +@contextmanager
> > +def dm_linear(file_path):
> > +    file_size =3D os.path.getsize(file_path)
> > +
> > +    with loop_device(file_path) as loop_path:
> > +        dm_name =3D f'test-{os.getpid()}'
> > +        run(['dmsetup', 'create', dm_name, '--table',
> > +             f'0 {file_size // 512} linear {loop_path} 0'])
>=20
> Would it be worth tryiing to create the dm with two copies of
> loop_path concatenated one after the other?  You'd have to do more
> work on expected output (coalescing adjacent data or holes between the
> tail of the first copy and the head of the second), but without that
> in place, I worry that you are missing logic bugs for when there is
> more than one table in the overall dm (as evidenced by my review in
> 4/9).

Yes, I agree that more tests are needed to cover transitions between
adjacent targets.

Stefan

--UFe5qkLdFPYhOF/f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmYNZlsACgkQnKSrs4Gr
c8irpggAgEsdY3HQUxjbzRdNS2viwwbbMIvyPfW7lJqspI9OLhurqOITHHLhaF0Q
EpWb8UJotzcmaqLesjFzwrXMJecUfbhF0ON7A4NbgNd9LhxG6eF1C3VmSUR9kgZI
PKU5+t6H1N5jvKWBngnoTcL/dtJk3o9qbN759KpAMMQ5djRmZU3y52BOD0ciW4v4
6jAcBP4tHfJU4wde2cEP3N9f9ZY1fa1DstlvA2PaFYIbeIMGF4q8z9O2wcoTLAdT
fX/r52mR+XnpvzVLUU9bLX3EUDLkkVykPBtI4NHeqN/xNwpu5tS0pc5P+cOc6hdn
68VRDKu2SVH/Sa0jUZ6I7xLwFZ+YhQ==
=CUG2
-----END PGP SIGNATURE-----

--UFe5qkLdFPYhOF/f--

