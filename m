From: Piet Delaney <piet@bluelane.com>
Subject: Re: [dm-crypt] Re: [stable][PATCH < 2.6.19] Fix data
	corruption with dm-crypt over RAID5
Date: Mon, 22 Jan 2007 18:19:04 -0800
Message-ID: <1169518745.23559.2.camel@piet2.bluelane.com>
References: <456B732F.6080906@lelik.org>
	<20061129145208.GQ4409@agk.surrey.redhat.com>
	<456F46E3.6030702@lelik.org>
	<1164983209.24524.20.camel@leto.intern.saout.de>
	<20061201152143.GE4409@agk.surrey.redhat.com>
	<45704B95.3020308@lelik.org>
	<1165026116.29307.18.camel@leto.intern.saout.de>
	<1165026476.29307.23.camel@leto.intern.saout.de>
	<1169023448.10964.244.camel@piet2.bluelane.com>
	<1169473139.1772.5.camel@leto.intern.saout.de>
Reply-To: piet@bluelane.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0500596529=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1169473139.1772.5.camel@leto.intern.saout.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Saout <christophe@saout.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============0500596529==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-i8BOxT0qBJRJHqizMwDU"


--=-i8BOxT0qBJRJHqizMwDU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-01-22 at 14:38 +0100, Christophe Saout wrote:
> > I'm wondering about trying out your patch with dm-crypt on 2.6.12.=20
> > The code in drivers/md/dm-crypt.c`crypt_endio() appears to be the
> same.
>=20
> Yes, it should apply as well.

Christophe Saout wrote:

> Am Mittwoch, den 17.01.2007, 00:44 -0800 schrieb Piet Delaney:
>=20
>> I'm wondering about trying out your patch with dm-crypt on 2.6.12.
>> The code in drivers/md/dm-crypt.c`crypt_endio() appears to be the
same.
>=20
> Yes, it should apply as well.

I'll assume that also means that applying the patch is reasonable.

In our case we aren't using raid5; how ever we are using raid to mirror
two root partitions. Your explanation to Andrew indicates the problem
should only occur when using raid5. So applying the patch should be only
have the effect of making it now possible to use raid5 with dm-crypt.
Since we are currently running raid with root encryption it feels like
it's better to include your patch.

-piet

--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-i8BOxT0qBJRJHqizMwDU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBFtXCYJICwm/rv3hoRAt3mAJ9aFslGR3WHYqFaLZeFay2R63x33gCeM+ZR
JS2UrxU7oagdl9ozcsFiwPc=
=n3jN
-----END PGP SIGNATURE-----

--=-i8BOxT0qBJRJHqizMwDU--


--===============0500596529==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0500596529==--
