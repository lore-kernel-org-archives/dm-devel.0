From: Axel Thimm <Axel.Thimm@ATrpms.net>
Subject: multipath missed udev-renamed devices
Date: Fri, 22 Jul 2005 02:56:51 +0200
Message-ID: <20050722005651.GA10987@neu.nirvana>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0581123700=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============0581123700==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

In order to be able to handle multipath devices better (avoid anything
else, but multipath to access the single paths) I moved the paths from
the devices to different names:

# ls /dev/*sd*
/dev/hsv100-sdb  /dev/hsv100-sdd   /dev/hsv100-sde   /dev/sda   /dev/sda2
/dev/hsv100-sdc  /dev/hsv100-sdd1  /dev/hsv100-sde1  /dev/sda1

The /dev/sda is the system disk, while the 4 /dev/hsv100-sd* devices
are the 4 paths to an EVA 3000.

Unfortuantely multipath does not see the /dev/hsv100-sd* devices. This
is because after querying sysfs devinfo in libmultipath/discovery.c
also wants to get a file descriptor on the device.

But it is using the kernel's device name, not the one from udev, the
access fails, and the path gets dropped.

What can be done to fix this? multipath needs the fd on the device for
further queries (serial and state). Should multipath call udev to get
the device's name?

Is there a workaround I can use now to get multipath on my
/dev/hsv100-sd* devices running?

Thanks!
--=20
Axel.Thimm at ATrpms.net

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC4ERSQBVS1GOamfERAkQ0AJ927Wd8jvYGtssCcm5C2vjeEqtq0QCglRnL
JYIoIF+3x2Nwb2Ci/X+Y0i4=
=ISCW
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--


--===============0581123700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0581123700==--
