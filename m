From: Neil Brown <neilb@suse.de>
Subject: Re: [REVISED PULL REQUEST] md updates for 2.6.36
Date: Thu, 12 Aug 2010 06:49:26 +1000
Message-ID: <20100812064926.15dafbf7@notabene>
References: <19552.39399.490494.51990@notabene.brown>
	<AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
	<1281482611.5887.38.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281482611.5887.38.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 11 Aug 2010 00:23:31 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2010-08-10 at 15:47 -0700, Linus Torvalds wrote:
> >=20
> > Hmm. Why "lib/raid6/raid6sse2.c" and friends? Why "raid6" twice? Yo=
u
> > don't mean "raid6+1" (mirrored raid6 ;), so why not just remove the
> > second "raid6", and call it "lib/raid6/sse2.c"
> >=20
> > But I pulled. Just in case there was some logic to the duplication.=
=20
>=20
> No particular reason -- I just wanted the initial move to be as simpl=
e
> as possible. Since it all gets built into raid6_pq.ko and we never se=
e
> these filenames even in module names, it does make sense to rename th=
em.
>=20
> If Neil approves, git://git.infradead.org/~dwmw2/libraid-2.6.git

Looks good,thanks.  There are a few comments still say "raid6xxx.c" and=
 there
is a .h file (raid6x86.h) which you didn't rename but probably should b=
e.

I've added a patch to clean these up.

>=20
> The userspace test/ (ne=C3=A9 raid6test/) directory doesn't build, bu=
t it
> didn't before. At least I fixed the awk incantations.
>=20
Yep, there is some bit rot in there.  Fixed that too.

Linus, you can get all this from
    git://neil.brown.name/md for-linus

Thanks.

The following changes since commit 3d30701b58970425e1d45994d6cb82f82892=
4fdd:

  Merge branch 'for-linus' of git://neil.brown.name/md (2010-08-10 15:3=
8:19 -0700)

are available in the git repository at:

  git://neil.brown.name/md for-linus

David Woodhouse (1):
      Rename raid6 files now they're in a 'raid6' directory.

NeilBrown (2):
      Make lib/raid6/test build correctly.
      Further tidyup of raid6 naming in lib/raid6

 include/linux/raid/pq.h                   |    2 +
 lib/raid6/Makefile                        |   81 ++++++++++++++-------=
--------
 lib/raid6/{raid6algos.c =3D> algos.c}       |    4 +-
 lib/raid6/{raid6altivec.uc =3D> altivec.uc} |    0
 lib/raid6/{raid6int.uc =3D> int.uc}         |    0
 lib/raid6/{raid6mmx.c =3D> mmx.c}           |    6 +-
 lib/raid6/raid6test/Makefile              |   75 ---------------------=
-----
 lib/raid6/{raid6recov.c =3D> recov.c}       |    2 +-
 lib/raid6/{raid6sse1.c =3D> sse1.c}         |    6 +-
 lib/raid6/{raid6sse2.c =3D> sse2.c}         |    4 +-
 lib/raid6/test/Makefile                   |   72 +++++++++++++++++++++=
++++
 lib/raid6/{raid6test =3D> test}/test.c      |    0
 lib/raid6/{raid6x86.h =3D> x86.h}           |    2 +-
 13 files changed, 125 insertions(+), 129 deletions(-)
 rename lib/raid6/{raid6algos.c =3D> algos.c} (99%)
 rename lib/raid6/{raid6altivec.uc =3D> altivec.uc} (100%)
 rename lib/raid6/{raid6int.uc =3D> int.uc} (100%)
 rename lib/raid6/{raid6mmx.c =3D> mmx.c} (98%)
 delete mode 100644 lib/raid6/raid6test/Makefile
 rename lib/raid6/{raid6recov.c =3D> recov.c} (99%)
 rename lib/raid6/{raid6sse1.c =3D> sse1.c} (98%)
 rename lib/raid6/{raid6sse2.c =3D> sse2.c} (99%)
 create mode 100644 lib/raid6/test/Makefile
 rename lib/raid6/{raid6test =3D> test}/test.c (100%)
 rename lib/raid6/{raid6x86.h =3D> x86.h} (99%)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
