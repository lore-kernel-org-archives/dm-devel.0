From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REVISED PULL REQUEST] md updates for 2.6.36
Date: Tue, 10 Aug 2010 15:47:21 -0700
Message-ID: <AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
References: <19552.39399.490494.51990@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19552.39399.490494.51990@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, David Woodhouse <dwmw2@infradead.org>
List-Id: dm-devel.ids

On Mon, Aug 9, 2010 at 5:14 PM, Neil Brown <neilb@suse.de> wrote:
>
> =A0create mode 100644 lib/raid6/Makefile
> =A0rename {drivers/md =3D> lib/raid6}/mktables.c (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6algos.c (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6altivec.uc (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6int.uc (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6mmx.c (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6recov.c (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6sse1.c (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6sse2.c (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6test/Makefile (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6test/test.c (100%)
> =A0rename {drivers/md =3D> lib/raid6}/raid6x86.h (100%)
> =A0rename {drivers/md =3D> lib/raid6}/unroll.awk (100%)

Hmm. Why "lib/raid6/raid6sse2.c" and friends? Why "raid6" twice? You
don't mean "raid6+1" (mirrored raid6 ;), so why not just remove the
second "raid6", and call it "lib/raid6/sse2.c"

But I pulled. Just in case there was some logic to the duplication.

                               Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
