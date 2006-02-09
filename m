From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: HDIO_GETGEO doesn't work on dm devices...
Date: Wed, 08 Feb 2006 17:09:36 -0800
Message-ID: <1139447376.23539.2.camel@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1584583658=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
Cc: Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids


--===============1584583658==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-X5tqrQUS3ri+tDwXUZt4"


--=-X5tqrQUS3ri+tDwXUZt4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi there,

I've been trying to install grub on a "bootable" device-mapper array
that was created with dmraid.  (I've a fakeraid card that will set up
the requisite BIOS drive fiction to make this work.)  It seems that grub
calls the HDIO_GETGEO ioctl on the dm device, but the dm driver returns
ENOTTY.  Grub then uses its own weird defaults (620/128/63 CHS), causing
all attempts to read beyond the 2.4GB mark fail.

My question is, would it be acceptable to implement HDIO_GETGEO for dm
devices?  I realize that this CHS geometry is all nonsense anyway, but
it seems that we could at least try to help out grub/fdisk/etc on the
odd chance that someone wants a bootable dmraid array.

Granted, a workaround would be to create a 100MB /boot partition, but
since grub can boot off regular disks that are >2GB, it seems to me that
it ought to be able to do the same with a fakeraid array.

If I've just volunteered to write a patch by asking this question, I'm
ok with that too. :)

Thanks,

--Darrick

--=-X5tqrQUS3ri+tDwXUZt4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD6pZQa6vRYYgWQuURAniWAJ9aQi6yp5xzEfRy+Wf8eAGqMumOkQCeNxwQ
xhxcjUAfx2vOuZu8PGMgS0M=
=3E+P
-----END PGP SIGNATURE-----

--=-X5tqrQUS3ri+tDwXUZt4--


--===============1584583658==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1584583658==--
