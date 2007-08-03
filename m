From: =?ISO-8859-1?Q?Philipp_T=F6lke?= <philipptoelke@web.de>
Subject: Re: PROBLEM: Oops when using dm-crypt with dpt_i2o
Date: Fri, 03 Aug 2007 22:46:14 +0200
Message-ID: <46B39416.7040809@web.de>
References: <46B0D4B4.2040809@web.de> <20070803110430.88a4b543.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763479AbXHCUq2@vger.kernel.org>
In-Reply-To: <20070803110430.88a4b543.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Christophe Saout <christophe@saout.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Andrew, hi everybody!

Thanks for the reply!

Andrew Morton wrote:
>> The oopses:
>>
>> #v+
>> BUG: unable to handle kernel paging request at virtual address 14001=
000
>> [...]
>=20
> So it looks like q->request_fn points at 0x14001000, which is in oute=
r
> space.
>=20
> I wonder how that could happen, in the middle of heavy IO operations.=
=20
> Possibly a memory scribble.  I'd suggest you enable CONFIG_SLAB,
> CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC.

That doesn't change anything, apart from adding a line "DEBUG_PAGEALLOC=
"
to the oopses. Do I have to enable the debugging manually? After a quic=
k
grep over the sources and a google-session I think not but I'm no
kernel-hacker.

> You could also try switching
> from CONFIG_SLAB to CONFIG_SLUB, then enable CONFIG_SLUB_DEBUG.

Unfortunately the only change seems to be, that the Keyboard-Leds don't
flash after the crash. Everything else is the same.

Could a hardware-error cause this?

Thanks again,
--=20
Philipp T=F6lke
