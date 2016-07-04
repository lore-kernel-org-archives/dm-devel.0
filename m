From: Gris Ge <fge@redhat.com>
Subject: Please ignore this patch set. ([PATCH V4 0/3]
 Introducing multipath C API)
Date: Mon, 4 Jul 2016 17:29:22 +0800
Message-ID: <20160704092922.GA120489@redhat.com>
References: <20160704091146.GA3081@redhat.com>
	<20160704091704.119896-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4496672324053887700=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160704091704.119896-1-fge@redhat.com>
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


--===============4496672324053887700==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 05:17:01PM +0800, Gris Ge wrote:
> Changes since V3:
>  * Replace limitation of MAX_REPLY_LEN with MAX_SEND_CMD_LEN.
>  * Treat IPC connection refuse error as DMMP_ERR_NO_DAEMON.
>=20
> Gris Ge (3):
>   multipath-tools: New way to limit the IPC command length.
>   multipath-tools: Set errno mpath_recv_reply() when failure
>   multipath-tools: Introducing multipath C API

Sorry. Please ignore this patch set.
Found a issue. Will send V5 soon.

--=20
Gris Ge

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXeixyAAoJEGzN5Y/kHij/FDoP/RuKVd8dzT4l2lkANwiIuenx
LChh0TcU9VGBcumYqn4BULF1i2WbyPjlTSpWTgyAqQHYRW9EENINK/DY00tDHh+a
FPMSsV9/APkObcoZKE4F3jgCDCoC4SLG96Iu/Gtf+mUjE2mHqA1qRStZA9xxq8ey
KNVRWFWhS6iOJD5H06GgpFSX/Ry8sCIUIW8Nbxg8qAaaHjP3qcAlQeWf4ZgrjXEd
d08WE+hc2f0l5c/KGkM1sXqm6y3j4osSs4u0U3ycgPz4v29zM5dFjiErvt1nOzmj
rOiByB3ls/Po8cSYiHq7FK2UXA19DgY6a0wY/1X6/hN++jO3bp6fz51bvzWDT02G
wcZnSH9WjycsOvJok9HT+i8pHnIoppHVFM/h1zzhCtOoKu5HOiOxPhxH8KjVYa4i
ewfCMAtQCNqkZBD0AvGRZvVAh3OVs3uG/pgXH0roEPPvhiNe6Zm9VP2SDsFo+oOR
vxUTxAshdookhkpUohhs9jQNfFDBAa9Lzf80a0inBMcXLEgOw4CfBuBY/fvbXBlK
fUQRlglQv2ha0zd92EXnQ19eews5Xf/tEPge/hbYfwXDTBm7cyYOHdZ3s8nd1jS3
IsVMF+se6RDFQV2Pl4rSIpvd4kpbjU2sI+ITqdTZzjKdXZy63sH2eAnlEJlvDogR
MstwkXlfTthEo/HeYGWg
=wVHt
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--


--===============4496672324053887700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4496672324053887700==--
