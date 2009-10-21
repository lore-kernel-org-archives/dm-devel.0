From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: multipathd support for non-SCSI devices (AOE)?
Date: Wed, 21 Oct 2009 09:52:51 +0200
Message-ID: <20091021075251.GC23138@mother.pipebreaker.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1032118362=="
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20091027071044.GB14807@mother.pipebreaker.pl>
Resent-To: dm-devel@redhat.com
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
Cc: tomek@pipebreaker.pl
List-Id: dm-devel.ids


--===============1032118362==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

 Hello,

  I was playing with ATA-over-Ethernet lately and to my sadness, multipathd
seem to ignore aoe devices. I've traced it to followingg error:

Oct 20 09:05:52 | Discover device /sys/block/etherd!e0.0
Oct 20 09:05:52 | path /sys/block/etherd!e0.0/device not present

  AOE devices don't have "device" file or symlink in their sysfs directorie=
s.
I've found one mailing list message from 2005 stating that multipath tools =
are
designed to be general, but current implementation is SCSI-only.
  Has the situation changed recently, or am I out of luck trying to multipa=
th
AOE devices?
  I'm using device-mapper-multipath-0.4.9-5.fc12.x86_64


--=20
Tomasz Torcz                 Morality must always be based on practicality.
xmpp: zdzichubg@chrome.pl                -- Baron Vladimir Harkonnen


--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: gpg --search-keys Tomasz Torcz

iEYEARECAAYFAkrevdIACgkQ10UJr+75NrlysgCeLAIGtlSTEHp7XfV6W7wvJX4+
31cAn1cF1A5JYKO6xJp3B6iTdAsTnXHw
=jLQd
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--


--===============1032118362==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1032118362==--
