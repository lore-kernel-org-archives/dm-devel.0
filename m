Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488042206E
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711665143; cv=none; b=jzOe/ZsRL5I0j63pJqZNFDGCiTzvK5SmVriP/gu8WR9Acyjrce000qXo3L6VmBXviVd6gVbqJkq9mxcypzM1hcmGnqGqpMIyEfWIISHQ2RJNNjjeeUaxkd3ALvBgr90FtFpPdSO3BN6r3EVAUKmus5IrCUnkwJ4qhRkRcxZcp9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711665143; c=relaxed/simple;
	bh=HM9dI0+v2dvDagfXfBDPOTWaC1BvVu/Bw0HFxTguW+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtqjtT0p0Vaa5ZFVmsEnYwIu0mc8EFMAiEOKG3HhxXdha17ab5WOB9fFPZTS+uTqXP8tVYJRdy3GHRb0HjXWCs0Nccsl/mDoxQPv0uy0HudnqKAsJlfj3uw/W0965IOIMu/zrej6os3C5VciqDGcwnFXdAKNNYHiGSAGPFhTPpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dZNOFzTL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZNOFzTL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711665139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VkMXoVK2Q46JPYfsAJWLWQVhxzDC46YOif/NfcourZg=;
	b=dZNOFzTLwCG0GxEk2jlL98Ut61suWvE4uv1CUC4wSBhfXneiO1AxERtlWRTSGIQcMYqRfk
	37kNQbM9OI7MgTumF2e8cHSBKKzK1fz18O466xHs/eRBazhCtOAvTdPsbI1OzJzVtzN2wu
	bjm4hk4raqoJNtQo7p0HXSHtvhwO954=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-mZTjqzYJP4OmW3P53SeQJw-1; Thu,
 28 Mar 2024 18:32:15 -0400
X-MC-Unique: mZTjqzYJP4OmW3P53SeQJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 235FD293248C;
	Thu, 28 Mar 2024 22:32:15 +0000 (UTC)
Received: from localhost (unknown [10.39.194.117])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B24210CB296;
	Thu, 28 Mar 2024 22:32:14 +0000 (UTC)
Date: Thu, 28 Mar 2024 18:32:08 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Eric Blake <eblake@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	David Teigland <teigland@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 5/9] selftests: block_seek_hole: add dm-zero test
Message-ID: <20240328223208.GA2373362@fedora>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240328203910.2370087-6-stefanha@redhat.com>
 <sr42hsk5rqu5siso6xwjlu5akfegl6glco3ug6pleawszgtfcb@h5pca4b3yqot>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="errnYgf4vO9JYY3s"
Content-Disposition: inline
In-Reply-To: <sr42hsk5rqu5siso6xwjlu5akfegl6glco3ug6pleawszgtfcb@h5pca4b3yqot>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3


--errnYgf4vO9JYY3s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 05:19:26PM -0500, Eric Blake wrote:
> On Thu, Mar 28, 2024 at 04:39:06PM -0400, Stefan Hajnoczi wrote:
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  .../selftests/block_seek_hole/Makefile        |  2 +-
> >  .../testing/selftests/block_seek_hole/config  |  2 ++
> >  .../selftests/block_seek_hole/dm_zero.sh      | 31 +++++++++++++++++++
> >  3 files changed, 34 insertions(+), 1 deletion(-)
> >  create mode 100755 tools/testing/selftests/block_seek_hole/dm_zero.sh
> >=20
>=20
> > +++ b/tools/testing/selftests/block_seek_hole/dm_zero.sh
> > @@ -0,0 +1,31 @@
> > +#!/bin/sh
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +#
> > +# dm_zero.sh
> > +#
> > +# Test that dm-zero reports data because it does not have a custom
> > +# SEEK_HOLE/SEEK_DATA implementation.
>=20
> Why not?  Wouldn't it make more sense to have dm-zero report the
> entire device as a hole (that is, an in-range SEEK_HOLE always returns
> the same offset, while an in-range SEEK_DATA returns the device size)?

Yes, dm-zero could report a hole. I just added this test to verify that
targets that do not implement seek_hole_data() work and the dm-zero
target was convenient for testing.

Stefan

>=20
> --=20
> Eric Blake, Principal Software Engineer
> Red Hat, Inc.
> Virtualization:  qemu.org | libguestfs.org
>=20

--errnYgf4vO9JYY3s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmYF7+gACgkQnKSrs4Gr
c8gJTAf/drxTuPXV8DqCjh9n+P+C32Fxs32+AcAhMqGlVsD4b9Ypw4/n8QNyAFpx
VvaJroLpR4zj5glSVAr1V/YAIHfU5HB+xheL5Mfd/JGCQLJXfiI4zmI3w70sp+CJ
m+FkD5vP6fvc8sOexR86We6lVDEXCzSvvck1ChQtmZ/TsO1Tf/iBSq4NbMRNoG6r
/sy+qV5z5NXBsYAagHkPb+a4lUktrCvR9v6StbRIsAh/pMNUKsN/2gtPshYUUs5h
YMjipkwZztToUud98eUEehe3BV+IjyJ/m5Bjf99HkN6sQE6ftjx7X7BwXOFBj3eV
RE6fSCJTogaq6/GrUh6PCDyPXZ97WA==
=uXCc
-----END PGP SIGNATURE-----

--errnYgf4vO9JYY3s--

