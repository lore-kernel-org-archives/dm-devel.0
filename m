From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: scsi_id and EMC Symmetrix
Date: Wed, 26 Jan 2005 11:07:15 +0100
Message-ID: <20050126100715.GD6859@bogon.ms20.nix>
References: <C2EEB4E538D3DC48BF57F391F422779321A6FC@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2008824483=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A6FC@SRMANNING.eng.emc.com>
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


--===============2008824483==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 24, 2005 at 02:56:30PM -0500, goggin, edward wrote:
> UID for SCSI LU on all currently available EMC Symmetrix storage
> is encoded from various byte fields of the standard inquiry reply
> message.  Will likely soon be attempting to push upstream an
> update to scsi_id(8) to do just that.
Could you post a patch for that, we need that badly here.
Cheers,
 -- Guido

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB92vTn88szT8+ZCYRApQyAJ9ejQKry1tYyDaIgahx2CIIVawimACdF4lI
wh/dFKXmvjFftbyBoavLZPo=
=7cx+
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--


--===============2008824483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============2008824483==--
