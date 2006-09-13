From: Piet Delaney <piet@bluelane.com>
Subject: Re: Filesystem Code - I'm bumping into you name
	frequenty. Was
	wondering about your thoughts on encrypting selected partitions on a
	block device vs encrypting in the filesystem.
Date: Tue, 12 Sep 2006 22:23:45 -0700
Message-ID: <1158125026.14930.198.camel@piet2.bluelane.com>
References: <1157164960.24314.223.camel@piet2.bluelane.com>
	<20060901195629.6845135d.akpm@osdl.org>
Reply-To: piet@bluelane.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1016449557=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060901195629.6845135d.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: Dan Smith <danms@us.ibm.com>, device-mapper development <dm-devel@redhat.com>, caleb <caleb@bluelane.com>
List-Id: dm-devel.ids


--===============1016449557==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-9Icj8p/90tdGYr+oV5cV"


--=-9Icj8p/90tdGYr+oV5cV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2006-09-01 at 19:56 -0700, Andrew Morton wrote:
> On Fri, 01 Sep 2006 19:42:39 -0700
> Piet Delaney <piet@bluelane.com> wrote:
>=20
> > Hi Andrew:
> >=20
> > Hope the kgdb momentum continues; wondering about getting a login on
> > vger and maybe I could help a bit.
>=20
> I don't detect any momentum.  trini has a new job and Amit remains silent=
.
>=20
> > I'm looking at the file-system code looking for a way to make a=20
> > small hack to allow us to encrypt file-system data; everything,
> > including the root file-system. I first considered loop-back and
> > a crypto file system but was convinced that it wouldn't be as
> > secure because /root couldn't be encrypted.
>=20
> For encryption at the block device level you can use cryptoloop or dm-cry=
pt.

Hi Andrew:

cryptoloop was discouraged and old so I tried dm-crypt. Seem Redhat owns
this and there appears to have been a change in the /dev interface. In
2.6.13 and linux-2.6.18-rc6-kgdb-testing I'm seeing a /dev/device-mapper
file.=20

  crw-rw----  1 root root 10, 63 2006-09-12 21:33 /dev/device-mapper

Note NOT a directory.

The docs from Redhat device-mapper.0.96.03 thru device-mapper.1.02.09
all seem to say:

   "/dev/mapper was called /dev/device-mapper prior to 0.96.04.
    Consequently scripts/devmap_mknod.sh has been updated."

and seem to expect a DIRECTORY. Maybe this is a udev problem,
but I suspect it's a device-mapper problem. Perhaps I need
to go back before 0.96.03.

Thought maybe you might know whats going down.

-piet


>=20
> For encryption at the file level you can use ecryptfs, which is in -mm an=
d
> I'm planning on merging it into 2.6.19.
>=20
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-9Icj8p/90tdGYr+oV5cV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBFB5XhJICwm/rv3hoRAm2QAJ9d6eYzX5ItSuxw1mKI428qQG9duACfSirA
LZmFTQe0pRl4IKnLJw6mzGU=
=o3mG
-----END PGP SIGNATURE-----

--=-9Icj8p/90tdGYr+oV5cV--


--===============1016449557==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1016449557==--
