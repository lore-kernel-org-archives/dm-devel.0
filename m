From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [REVISED PULL REQUEST] md updates for 2.6.36
Date: Wed, 11 Aug 2010 00:23:31 +0100
Message-ID: <1281482611.5887.38.camel@localhost>
References: <19552.39399.490494.51990@notabene.brown>
	 <AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2010-08-10 at 15:47 -0700, Linus Torvalds wrote:
>=20
> Hmm. Why "lib/raid6/raid6sse2.c" and friends? Why "raid6" twice? You
> don't mean "raid6+1" (mirrored raid6 ;), so why not just remove the
> second "raid6", and call it "lib/raid6/sse2.c"
>=20
> But I pulled. Just in case there was some logic to the duplication.=20

No particular reason -- I just wanted the initial move to be as simple
as possible. Since it all gets built into raid6_pq.ko and we never see
these filenames even in module names, it does make sense to rename them=
=2E

If Neil approves, git://git.infradead.org/~dwmw2/libraid-2.6.git

The userspace test/ (ne=C3=A9 raid6test/) directory doesn't build, but =
it
didn't before. At least I fixed the awk incantations.

--=20
David Woodhouse                            Open Source Technology Centr=
e
David.Woodhouse@intel.com                              Intel Corporatio=
n

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
