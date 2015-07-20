From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 1/3] PM suspend/hibernate: Call notifier after freezing processes
Date: Mon, 20 Jul 2015 23:46:32 +0200
Message-ID: <1715416.hWBvT0iLvO@vostro.rjw.lan>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <3179448.TScsKEAuyR@vostro.rjw.lan> <20150720073226.GB25910@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20150720073226.GB25910@pali>
Sender: linux-pm-owner@vger.kernel.org
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Monday, July 20, 2015 09:32:26 AM Pali Roh=C3=A1r wrote:
> On Saturday 18 July 2015 01:27:15 Rafael J. Wysocki wrote:
> > On Thursday, July 16, 2015 09:33:02 AM Pali Roh=C3=A1r wrote:
> > > On Thursday 16 July 2015 03:02:03 Rafael J. Wysocki wrote:
> > > > Also, if you're adding AFTER_FREEZE, it would be good to add BE=
=46ORE_THAW too
> > > > for symmetry.
> > > >=20
> > >=20
> > > But there is no use case for BEFORE_THAW. At least it is not need=
ed for now.
> >=20
> > For your use case, a single function pointer would be sufficient to=
o.
> >=20
>=20
> What do you mean by single function pointer? kernel/power is part of
> kernel image and dm-crypt is external kernel module.

Well, if there is a function pointer in the core suspend code initially=
 set to
NULL and exported to modules such that the dm-crypt code can set it to
something else, that should be sufficient, shouldn't it?

So if you're adding new PM notifier events, that's already more than *y=
ou* need.

Anyway, I guess the "post freeze" new one should be enough for now, but=
 please
change the name to POST_FREEZE.

Also I think we don't need separate "post freeze" events for suspend an=
d
hibernation.

Thanks,
Rafael

