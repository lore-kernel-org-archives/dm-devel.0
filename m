From: David Juran <djuran@redhat.com>
Subject: SNMP trap on path failure
Date: Wed, 04 Jun 2008 16:58:07 +0300
Message-ID: <1212587887.13634.21.camel@dhcppc2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1915090618=="
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
Cc: "Nicholas C. Strugnell" <nstrug@redhat.com>
List-Id: dm-devel.ids


--===============1915090618==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-i7ak8phaG+7KHebfLEqS"


--=-i7ak8phaG+7KHebfLEqS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello.

Is there a way I can configure e.g. multipathd to perform an action when
a path-status changes e.g. sending a SNMP trap? Without resorting to
parsing syslog? It would be very nice if one could configure a program
(script) that would be executed when there is a change in path status.

--=20
David Juran
Sr. Consultant
Red Hat
+358-504-146348

--=-i7ak8phaG+7KHebfLEqS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBIRp9v0Z3pChMh0UURAiQaAJ4h1EG1OHo3xmkhSbX6dZbpieVsJwCgtrX3
kuuC6LmHbuurp7iPGH5LLMA=
=4Tnt
-----END PGP SIGNATURE-----

--=-i7ak8phaG+7KHebfLEqS--


--===============1915090618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1915090618==--
