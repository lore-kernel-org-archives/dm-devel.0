From: NeilBrown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH 0 of 4] dm-raid: various bug fixes
Date: Thu, 19 Apr 2012 09:58:08 +1000
Message-ID: <20120419095808.323b01b0@notabene.brown>
References: <1334716219.23908.14.camel@f14.redhat.com>
	<20120418134843.1376cc7e@notabene.brown>
	<3F107DB9-0ED6-47C5-9F5A-DF485017EA92@redhat.com>
	<A71FAACD-D1A7-4452-BDD3-5156DB9E5497@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xRY2.rzI1r3ryEGeFy3iU=n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A71FAACD-D1A7-4452-BDD3-5156DB9E5497@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/xRY2.rzI1r3ryEGeFy3iU=n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 16:32:00 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Apr 18, 2012, at 9:05 AM, Brassow Jonathan wrote:
>=20
> >=20
> > 5-of-5: changing the check to 'saved_raid_disk >=3D 0' would be fine, b=
ut I think I should initialize 'saved_raid_disk' to -1 in dm-raid.c then no=
rmally.  Right now, an nominal initial value is not set - meaning it is '0'=
.  (When a device comes back from a failure, 'saved_raid_disk' is assigned =
its old position.)
>=20
> ... that's not quite right.  I do call 'md_rdev_init' which sets 'saved_r=
aid_disk' to -1.  Then, if the device has returned after a disappearance, I=
 set 'saved_raid_disk' to it's old position.  Therefore, 'saved_raid_disk >=
=3D 0' would be fine and wouldn't require me to set -1 in dm-raid.c.
>=20
>  brassow
>=20

Excellent.  I've taken the liberty of making that change in the patch you
sent me and converted your RFC-by: to Signed-off-by:

Result can be viewed at or near the top of

http://neil.brown.name/git?p=3Dmd;a=3Dshortlog;h=3Drefs/heads/for-next

Please confirm that is OK to submit (eventually for 3.5).

Thanks,
NeilBrown

--Sig_/xRY2.rzI1r3ryEGeFy3iU=n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT49VEDnsnt1WYoG5AQLfcg//T4x3d9TwdshjKJ++fEbauIfAfhFnaH9/
N0xNHcVVxlhu6ZscYVkOSBPjYBBtslQXe2wv3PpNFqaMEtmTBNQ+75JsW6CbyWPe
t4kaLEC4ZLIQHZKn9T/8QV66YhtjQnNIOeVoseL30qgtoUgmPYS9LvNg29DaQOip
op33h2SainUJhsN6E5O1edrwz4iDxMMYSybjgHuWJHGQ68TP4ZE98p647rhWvQ9q
MtX4X8w7VIK4FPHCbWXVAjY+0Xxe7C8kLuXg/nIwTlcN6ku6ngBYgJXbcd3svl/h
OL6uYUDBOim3aq9a2UCpGM39wdVKSZokcRvFNbPLXCQjR7ujdXbapmxyxMQyI/HV
Ub5OKyBLYLKjX3JzVuOH/fgCIeTW5lhuwXGtM9b8w9YFXNKYnAyW9nif375c9bZv
PizOBiJiZJO8Z/eMaNnEYBMVPxgiya7exkvGHDxWfqwFflEp+vZ80YsCBECC4/Vh
DX5JqohDZfezkI28rtUwL5Njkj6b4zdpqpNAb79gyugKEa+RFgK0yvMl95Fbf6rb
fPtV54LPkgB4wcDKlDr5gL7Pcl5aYhWXtCxVhzmKkfFvxqoCnZ4se8Cy8lbglc5b
FW5yRpnVOrR8xvo914dRMnJ0LReLYgUQ142tKiS/znVhnZVhk2GgBH+aH3I5Ljj6
zudLyWcRrdc=
=Siyf
-----END PGP SIGNATURE-----

--Sig_/xRY2.rzI1r3ryEGeFy3iU=n--
