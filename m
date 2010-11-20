From: Ben Hutchings <ben@decadent.org.uk>
Subject: Bug#604049: linux-image-2.6.32-5-amd64: data corruption with promise stex driver and use of device-mapper layers (lvm/dm-crypt/..)
Date: Sat, 20 Nov 2010 05:33:42 +0000
Message-ID: <1290231222.3818.167.camel@localhost>
References: <20101119192614.1895.78157.reportbug@niassan.19.ros.03046.com>
Reply-To: Ben Hutchings <ben@decadent.org.uk>, 604049@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zmrLZQ71yAdbSY+ONj3h"
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.604049.B604049.129023125817348@bugs.debian.org>
In-Reply-To: <20101119192614.1895.78157.reportbug@niassan.19.ros.03046.com>
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: Ed Lin - PTU <ed.lin@promise.com>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com
Cc: Markus Schulz <msc@antzsystem.de>, 604049@bugs.debian.org
List-Id: dm-devel.ids


--=-zmrLZQ71yAdbSY+ONj3h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-19 at 20:26 +0100, Markus Schulz wrote:
> Package: linux-2.6
> Version: 2.6.32-27
> Severity: critical
> Tags: d-i upstream
> Justification: causes serious data loss
>=20
> any use of the stex.ko promise hw-raid controller driver with a
> device-mapper layer produces data corruption (or filesystem corruption
> like you can see in my dmesg).
[...]
> i've asked Ed Lin (Maintainer of stex.c from promise) on lkml and got the=
 following answer:
>=20
> > We found similar problem during test.
>=20
> > The stex driver sets sg_tablesize as 32 (for st_yel it's 38) in the pro=
be
> > entry. It seems that this value was overridden by the system if using
> > dm/lvm, for unknown reason. The driver received requests with more
> > sg items than registered. Sg item number could be as high as 64. This
> > is completely unexpected. The firmware could not handle such
> > requests, and error occurred.
[..]

I have little idea how this stuff is supposed to work, but it looks like
dm_dispatch_request() calls blk_insert_cloned_request() which calls
blk_rq_check_limits() which checks the request against the maximum
number of segments initialised from sg_tablesize.

We can perhaps mitigate the data loss by checking the number of segments
again in scsi_dispatch_cmd(), but it won't really solve the problem.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-zmrLZQ71yAdbSY+ONj3h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATOddsOe/yOyVhhEJAQI8+w//Uhtvs7vJcbZrdLKn0L2UeKoaa8U8cV/O
4aVIfDQYzdKo/HV9eKfb8vH8vKh5ZkeslQOd9TGpqACyo+OBs0ga4DnwSuOhQqSg
I1w0ZXDQzSgiAP4/bXVME0SRlhSzKHNxBwPrqWzGT0bZYjUXUWAlaQy5wdIOjfrJ
w6SPLA88bxm1w9b8182b5zDNHOB1FtdrkVTULFK8FwxmcjQvzuEhe5wEtkcL5ryI
IwyNthyLwwlbASxTBbfrG2GMqtqhVr1ocnbs/BfyDoLS9hieD715htdKLW6dJ6Bz
g8/PbbJtB7wQE/xXpErBSvhd3ZpF4RkIioWeYfA7cwPZqG8N6U7PndwdSjEDP06o
bQATKIgTz1FpBCs4UT0b9RQrzJmJY+BfKsXroQj4SihPEwd3R1ticIJAad2ie4QO
X/TbQEtzvArFhVVvssSnJK+a540i/zNuvJT8el2fqEEa6MVXwigT4KhOKcVk0Xdu
EjWYWKcxfGWjWdvpmO2OyjNsQN7oWRyGg6lzmzjj996mwFuWzBN9kfY0h2MKPG2r
WtpwdVppFWsYIV0pUrHlIcBnSpSdhV6UPENmlM0GwmkpZEeJXMVFl9ZqatBhNmwY
UR/qHnLj44eTdQIWZgqT0Jkd50QG/4XMmyQVVStnZYLJXmcCCFcrEkI+ELft8853
I+2XkqnyIbE=
=qSm1
-----END PGP SIGNATURE-----

--=-zmrLZQ71yAdbSY+ONj3h--
