From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [BUG?] register_blkdev: failed to get major for
	device mapper
Date: Tue, 20 Feb 2007 08:24:01 +0100
Message-ID: <200702200824.06728.eike-kernel@sf-tec.de>
References: <200702161437.34063.eike-kernel@sf-tec.de>
	<200702191539.38902.eike-kernel@sf-tec.de>
	<20070219115952.a06be52c.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1020767379=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070219115952.a06be52c.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============1020767379==
Content-Type: multipart/signed; boundary="nextPart2104166.tgITizfczl";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2104166.tgITizfczl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 19. Februar 2007 schrieben Sie:
> On Mon, 19 Feb 2007 15:39:38 +0100 Rolf Eike Beer <eike-kernel@sf-tec.de>=
=20
wrote:
> > > It's totally weird. It prints the "skipped" message for every (!)
> > > number, not just for the blacklisted ones. And I've triple checked th=
at
> > > I don't have missed the '{'.
> > >
> > > Compiler is SuSEs 4.1.0 from their 10.1. I remember some rumors that
> > > this thing is just broken?
> >
> > Ok, I'm using the compiler from SuSE 10.2 now and it works. Time that we
> > refuse to build if it's a 4.1.0.
>
> argh, I was down to suspecting gcc.
>
> I suppose we can just stir the code around to make it go away.  Like this?

Too late, sorry. I've upgraded to 4.1.3 and it works fine now. Maybe I'll f=
ind=20
time to check again but this will take some days.

Eike

--nextPart2104166.tgITizfczl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF2qIWXKSJPmm5/E4RAkcDAKCCt4WNOZu+iq2epwGXwnVXiWtzagCfSChJ
/VR11Lp21D0vlhxQZL5gp40=
=tjKB
-----END PGP SIGNATURE-----

--nextPart2104166.tgITizfczl--


--===============1020767379==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1020767379==--
