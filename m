From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 3/4] dm-userspace: fix DMU_FLAG_SYNC
Date: Sat, 30 Sep 2006 08:50:33 -0700
Message-ID: <m3irj5z73q.fsf@guaranine.beaverton.ibm.com>
References: <200609301044.k8UAifNn013346@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0795824746=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609301044.k8UAifNn013346@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Sat, 30 Sep 2006 19:44:35 +0900")
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

--===============0795824746==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> Seems that DMU_FLAG_SYNC flag is always set. Is this intentional?

Yes.  We set this flag so that in endio we can decide whether or not
to send a notification to userspace before we allow it to complete.
Perhaps this should be named something more descriptive, like
DELAY_COMPLETE or something like that.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHpJJwtEf7b4GJVQRAkB0AJ9Qd3MuoXPSXODcbsh9Gnz08HBNEQCeI54P
pAVCkLBAnIZ62j8N6n2eU+0=
=UVKe
-----END PGP SIGNATURE-----
--=-=-=--


--===============0795824746==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0795824746==--
