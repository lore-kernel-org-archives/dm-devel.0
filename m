From: Guido Guenther <agx@sigxcpu.org>
Subject: scsi_id and EMC Symmetrix
Date: Mon, 24 Jan 2005 15:33:03 +0100
Message-ID: <20050124143303.GD32187@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0666508792=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0666508792==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
sine I believe there are people from EMC listening:
How is one supposed to get a unique path identifier on an EMC Symmetrix?
scsi_id only uses codepage 0x80 and reports different identifiers for
two paths leading to the same storage area. Code page 0x83 seems
unusable since it is malformed (many thanks to Doug for tracking this
down). The Symmetrix is a 8830 connected via a QLA2342.
Cheers,
 -- Guido

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB9Qcfn88szT8+ZCYRAp4yAJ9DGqnxszYeMiTDT+X/4vStMQE+wwCfcvRQ
Fs+3KEa/hjIqPNe6MZV0p0g=
=KUrm
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--


--===============0666508792==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============0666508792==--
