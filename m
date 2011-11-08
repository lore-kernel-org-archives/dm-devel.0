From: Hauke Laging <mailinglisten@hauke-laging.de>
Subject: Re: turning the root volume into a snapshot stalls
	(ioctl hangs)
Date: Tue, 8 Nov 2011 19:29:47 +0100
Message-ID: <201111081929.48163.mailinglisten@hauke-laging.de>
References: <201111081257.08114.mailinglisten@hauke-laging.de>
	<20111108132120.GA19817@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3057100156451584105=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111108132120.GA19817@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3057100156451584105==
Content-Type: multipart/signed; boundary="nextPart8693180.zj9JMq7TiE";
	protocol="application/pgp-signature"; micalg=pgp-ripemd160
Content-Transfer-Encoding: 7bit

--nextPart8693180.zj9JMq7TiE
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, 8. November 2011, 14:21:21 schrieb Mike Snitzer:
> So you're somehow activating the snapshot to be the root volume.  And
> then later trying to merge the tmpfs COW into the origin (obviously
> before you reboot otherwise you'd lose the tmpfs).  This isn't going to
> work with the current snapshot-merge code given the constraints that
> both the origin and snapshot must be closed before merge.

Yes but not even the snapshot part works (I copied the code in the first ma=
il=20
from the wrong part of the script; it should have been "snaphot" instead of=
=20
"snapshot-merge".


> The lvm tools both document and guard against this, from lvconvert(8):

OK, I don't use lvconvert thus I had not read that.


>    Merging a snapshot into an origin that cannot be closed, for
>    example a root filesystem, is deferred until the next time the origin
>    volume is activated.

I am curious: Is there a technical explanation of this problem? I do not=20
understand what "close" is supposed to mean in this context and how the roo=
t=20
volume is different from the home volume (with users logged in).

Could this restriction be avoided by using another dm layer? I have an LV=20
linux2/rootfs. If I create a new dm device rootfs and have it point to=20
/dev/mapper/linux2-rootfs would the restriction apply to both then? It is n=
ot=20
necessary in this case that the file system gets flushed (and the superbloc=
k=20
cleaned).


Thanks for your help

Hauke
=2D-=20
PGP: D44C 6A5B 71B0 427C CED3 025C BD7D 6D27 ECCB 5814

--nextPart8693180.zj9JMq7TiE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQFMBAABAwA2BQJOuXUcLxpodHRwOi8vd3d3LmhhdWtlLWxhZ2luZy5kZS9vcGVu
cGdwL3BvbGljeS5odG1sAAoJEFug+LU6QDJRsT8H/iUfsFi0H9t4xMJ18FPOaVn4
XgH0QRRU12l3G/C6oDv2FvEoKKNWRpwZH0dpOuq+y/4cNgxhRcBucezC/aRIhGCF
SgFTynVJGKwFBLHxWVNT1pCLBuTfy83jKUZn2PGj4WDJBpgMIhIYtztA6h++pIuo
3Hh0bUbd0u+RpYm1GSP8zyoveqeB0WJa9PgFvbc1lP0AHcKDtKLEkMUCffoRxp9T
EjAvoXq4HY7iLdzupeqPk+8Qis3yv0GNGje03Fu2nPL2oMfdDnLVHZasUC6myQbI
pNfkypqzOIERBLJAlrQfz3Ckt0iLUdL6Lu0Rj0Ox9kqQ5tHK+OfMtLaQi1kZtnk=
=0U6H
-----END PGP SIGNATURE-----

--nextPart8693180.zj9JMq7TiE--


--===============3057100156451584105==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3057100156451584105==--
