From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH] multipathd daemon: Fix incorrect use of
 CLOCK_MONOTONIC in pthread
Date: Thu, 10 Aug 2017 00:19:19 +0800
Message-ID: <20170809161919.GA7163@redhat.com>
References: <20170809132214.3081-1-fge@redhat.com>
	<1502290980.2356.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6297120435105294651=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1502290980.2356.1.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============6297120435105294651==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2017 at 03:03:00PM +0000, Bart Van Assche wrote:
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 4be2c579..67997d08 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -198,7 +198,7 @@ int set_config_state(enum daemon_status state)
> >  		if (running_state !=3D DAEMON_IDLE) {
> >  			struct timespec ts;
> > =20
> > -			clock_gettime(CLOCK_MONOTONIC, &ts);
> > +			clock_gettime(CLOCK_REALTIME, &ts);
> >  			ts.tv_sec +=3D 1;
> >  			rc =3D pthread_cond_timedwait(&config_cond,
> >  						    &config_lock, &ts);
>=20
> But this change looks wrong to me. Have you noticed that
> pthread_condattr_setclock(&attr, CLOCK_MONOTONIC) is used to make
> config_cond use the monotonic clock? See also libmultipath/time-util.c.
>=20
> Bart.
Hi Bart,

I missed the pthread_cond_init_mono().
Will send V2 patch without this change.

Thanks.

--=20
Gris Ge

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8f1XsqXpyNthgIbGbM3lj+QeKP8FAlmLNgMACgkQbM3lj+Qe
KP8KWg//U43tbKaNjkpCPIcZaCL0A2tdOK7ZWRnsnsDDztuJuyrBGpQfNcGPPnVy
GWYf4IaGnFd0tRrNP4mWiMOxYGC7Ue7NUAC4zoM6uDeOOloNCeEFkb910HVkbCjr
Ob9Gn1v6mJHzuBV+cpnmCLm2M+jDn27hybSn9BK457idoun5gSY388ie4Jhi2Ta1
fn77+RFn1zjF2tsR/LzAVfhKN14d8LlVloMspoVftpelfqenHLQodETCDftqcXC3
BqWJoWe4VFlLHWsc22o6clV6Ohxmh2DjQux4R1XrlrnUfs1n8AldqCUwGTzKkg3X
/XJOFdG1Q2if351svzw/xtlLNZ0VBW+P9Ai3Nd08MEsDpqIlv5vZ3Xy06/ncxcJT
6Qze4mBU6gkGtUqi/EgGMU0GSp20gEkmzOCU1gBy5a8nSux4bTD4DbwztcUthY9o
KSYj/pDncxYbvWAEFghxQh3w3u+cstzbV+nZkdLUmTI59C6YpnUQra6bhu3c02x9
VIbFFdB0reCF2CKvZ1+NfLsooA436Zp0DSJmWd2iJKqaPvveV9KeP3VAw3KMbd4Y
fTHqNbyfEL8IsQQzgzdnIvSmEIw/i5cKnyAFwteIGeWzGb3uO9SdfKa7jiG56OYV
TmNQNCse/jMna2ac220K9rdjMkicHhFoXFqpcx4LVMg7GyC60DY=
=Bc6g
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--


--===============6297120435105294651==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6297120435105294651==--
