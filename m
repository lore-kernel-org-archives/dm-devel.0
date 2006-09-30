From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 3/4] dm-userspace: fix DMU_FLAG_SYNC
Date: Sat, 30 Sep 2006 09:32:59 -0700
Message-ID: <m3ejttz550.fsf@guaranine.beaverton.ibm.com>
References: <200609301044.k8UAifNn013346@r-dd.iij4u.or.jp>
	<m3irj5z73q.fsf@guaranine.beaverton.ibm.com>
	<20061001011211M.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2030129893=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061001011211M.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Sun, 01 Oct 2006 01:12:11 +0900")
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

--===============2030129893==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> My point is that the kernel module always sets DMU_FLAG_SYNC flag
FT> regardless of user space. As the patch does, should dmu_cpy_flag
FT> be used instead of cmu_set_flag? This enables a user-space
FT> programs to choose the behavior.

This is what I did previously; I let userspace set the sync flag if it
wanted to catch the endio.  However, during some debugging, I decided
to just send every endio to userspace.  I think I did this because I
was getting some corruption and thought it might be related to endio.
I think you are right, however, that because we can complete the IOs
in any order, we can delay some endios and not others.  I'll change it
back to copy the flag and do some more testing Monday to verify.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHpw7wtEf7b4GJVQRAr0yAJ4oIAmLP0bVKdCxUQhark7Vh4M9ewCeN1Yb
a/7SXPbhj2zzSDswOehcZo8=
=B9ob
-----END PGP SIGNATURE-----
--=-=-=--


--===============2030129893==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2030129893==--
