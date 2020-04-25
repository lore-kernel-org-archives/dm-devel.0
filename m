From: Paul Wise <pabs3@bonedaddy.net>
Subject: Re: [PATCH 0/3] dm raid/raid1: enable discard support when any
 devices support discard
Date: Sat, 25 Apr 2020 10:46:40 +0800
Message-ID: <92911928f258ce7d1649b138e71abff90cdf660d.camel@bonedaddy.net>
References: <20200419073026.197967-1-pabs3@bonedaddy.net>
         <20200419131908.GA22398@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-yBq2dcpBngBNf7Rpu8FT"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200419131908.GA22398@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


--=-yBq2dcpBngBNf7Rpu8FT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2020-04-19 at 09:19 -0400, Mike Snitzer wrote:

> You went overboard with implementation before checking to see if your
> work would be well received.
...
> I haven't looked closely at MD raid in this area but if you trully think
> underlying MD raid can cope with issuing discards to devices that don't
> support them (or that it avoids issuing them?) then please update
> dm-raid.c to conditionally set ti->discard_supported (if not all devices
> support discard).  That is how to inform DM core that the target knows
> better and it will manage discards issued to it.  It keeps the change
> local to dm-raid.c without the flag-day you're proposing.

So, now that I know that my approach to this was completely bogus,
what *is* the correct way to safely enable mixed-discard support?

It seems to me that the right way would be one of these options:

 * a sysfs toggle for the block layer
 * an=C2=A0lvchange based option for the dm layer

I'm leaning towards the latter for my personal use-case but the former
would make Linux much more flexible but would touch more code and have
the potential for more damage.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-yBq2dcpBngBNf7Rpu8FT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAl6jpIwACgkQMRa6Xp/6
aaOrrg/+JpSOuup2HurdD9NIAtht/hAlQukVyB8jLF79Y7TiRBj/bGBL3bNFyeu9
9onyY8oKkJNxz2lDP8TX/RthuQQPe4mKIK1naHwZn2v1HGSCCCT0+QuzNOks4FEi
Az+GqNWR3ICss7z59I+4Llq4iLpZx+Zpwe0RtRb9wHoml+RmIN15fh4LzyHlL/+N
go55fQ7wgTcd2V8q0yeleOa6GGpJSr4wAX3GfS7CKHMRunT7TSBrlJnI8Qqt3G9i
+92GpoPbpHBDszeLbTNllCBrx5XsJjdBC5CxTuin4MS1LFZpgEHJpKKePyF5mPge
XlzvbPQlqh6CXNfsGx1c89CEkITvPkmd9ROdSliFE2Gmu8kDN9lWhf3Vhu9GCAzH
7qaJPzK5zYOmQXxRmyaqZ2fqMckWnJhm14toMtb8bIHapwCVXBGfpsBrk6hsXlwB
Ur8nCiDZJAhnrwfPp0VmGpi917vSOF0sp+t9MkdSoj40b58hhwoyyH9rnrtmpEAH
9GE9Cg7iad5fs4+JEyOIXu3HIyoRpCMIAAvvohJltXSSkrN/ww0qr5WOef9amVKs
q/lhcKixRahAn3kfuLd8ecAaPOVlhx/CqB0X/D5xTS+1KFVOdnE2FDbsGKpXRVwA
VSq68JP+twI1qoGxaC+wuH3iPFHAVXgRsRDzMQ0kjEfzS1gN7D4=
=XHKy
-----END PGP SIGNATURE-----

--=-yBq2dcpBngBNf7Rpu8FT--
