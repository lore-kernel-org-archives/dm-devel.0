From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Date: Tue, 6 Jan 2009 14:04:48 +1100
Message-ID: <20090106140448.a4f54d2b.sfr@canb.auug.org.au>
References: <20081010125159.GK5098@agk.fab.redhat.com>
	<20090105191824.GP5098@agk.fab.redhat.com>
	<alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1796576202=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Andi, Takahiro, linux-kernel@vger.kernel.org, Kleen <ak@suse.de>, dm-devel@redhat.com, Cheng Renquan <crquan@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

--===============1796576202==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ"

--Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair.

On Mon, 5 Jan 2009 18:51:00 -0800 (PST) Linus Torvalds <torvalds@linux-foun=
dation.org> wrote:
>
> Oh no, this is totally broken, and doesn't compile even with my fairly=20
> minimal install:
>=20
>   drivers/md/dm-target.c: In function =E2=80=98dm_unregister_target=E2=80=
=99:
>   drivers/md/dm-target.c:106: error: implicit declaration of function =E2=
=80=98module_refcount=E2=80=99

This is from a patch added to linux-next only yesterday and was
reported by Randy Dunlap from his overnight build testing.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkliylAACgkQjjKRsyhoI8zb9wCfWOSEjPCUWjxLSj9P0tNdiNUe
v8sAoLoUNxIaR1gnZd03C8jb9RCPo8Q9
=R8nO
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Jan_2009_14_04_48_+1100_.iX5JcqqJq4DdTcQ--


--===============1796576202==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1796576202==--
