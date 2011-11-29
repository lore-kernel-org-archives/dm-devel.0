From: Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH] deadlock with suspend and quotas
Date: Tue, 29 Nov 2011 12:00:10 -0800
Message-ID: <1322596810.27747.42.camel@fourier>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
	 <20111128150400.GE6366@quack.suse.cz>
	 <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YejpjQoCUeSYf2NgrExs"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Valerie Aurora <val@vaaconsulting.com>
Cc: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Christopher Chaltain <christopher.chaltain@canonical.com>, Surbhi Palande <csurbhi@gmail.com>
List-Id: dm-devel.ids


--=-YejpjQoCUeSYf2NgrExs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Mon, Nov 28, 2011 at 8:04 AM, Jan Kara <jack@suse.cz> wrote:
> >  Thanks for the patch. I'm aware of the deadlock and Val Henson is work=
ing
> > on resolving these types of deadlocks more systematically. [...]

On Mon, 2011-11-28 at 14:00 -0700, Valerie Aurora wrote:
> FYI, I no longer have time to consult in addition to my full-time job.
>  Canonical is taking over this patch set.

We've been testing the patch set Val refers to (patches developed by her
and by Surbhi Palande) within Canonical.  I will resubmit them on their
behalf within the next day or two.

 -Kamal


--=-YejpjQoCUeSYf2NgrExs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJO1TnKAAoJEOf3EFVUCeQiFJcP/iSjvaTeiYmhWaMEPd2zYJZU
9rmRGljOk3yv4vYa1KLRaUor1fBVRjNUkzlNvQ9u4e3SANt5FxEPEew9pmdAq8P7
pqPpmAGDDUbvtjgRzbKLq9pzSWBrmC+brCspDNpoeKKydisV48UT1gGcub4gmhgY
Mmlq+xOewlaeclY+BH0mM9Pw8twXbYUc1NlRDEChPaw/r3lm4cHdvAjUE8tJtuJG
YZZiRXZs1Gpi3nqAv6RaMWL2VAJdcYKKm0uTuakwJx0ENP41L8sdINSA1KOdQur3
/8q0/QF0Ln8ufu34xvKDCwbpb2xDW3sDdGLW9z+QQIMqHNf9K2Lob00yZ60Lhrru
THFdZDfmvvUEHxLV1AtM9HYasNJzttDgAGDxDCJbi836dZF2u9wLnuiBiRwS76iy
GGCM+b9Jne3yMK29ma0k5JnvUnAUe8dIlV4krrqF7l3jF8ARHdF0mIqBQjuajcNu
45Hn2EtmxBEJSeTQnpLxKhyVrfcl3r+j1K31Ii/H6Kzhedx6At3lWHfNgqVdnAr1
XVSqn15BHMOG8hZGFm6HK4Nhp1F7ZV0hRlMuWlcnuJoQ4h1QKURX5uJsvJYk/hdy
GQQnRkD7Cb6qfENxJsDrbace6ntTV3cS1F7720eF1Gd8Q20/bSP18SyUtFmuYKja
iqcCHzhlefehic+4i3ht
=TB+C
-----END PGP SIGNATURE-----

--=-YejpjQoCUeSYf2NgrExs--

