From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 1/3] PM suspend/hibernate: Call notifier after
 freezing processes
Date: Wed, 22 Jul 2015 08:08:27 +1000
Message-ID: <20150722080827.5adcf5f1@noble>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
	<3179448.TScsKEAuyR@vostro.rjw.lan>
	<20150720073226.GB25910@pali>
	<1715416.hWBvT0iLvO@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1715416.hWBvT0iLvO@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 20 Jul 2015 23:46:32 +0200 "Rafael J. Wysocki"
<rjw@rjwysocki.net> wrote:

> On Monday, July 20, 2015 09:32:26 AM Pali Roh=C3=A1r wrote:
> > On Saturday 18 July 2015 01:27:15 Rafael J. Wysocki wrote:
> > > On Thursday, July 16, 2015 09:33:02 AM Pali Roh=C3=A1r wrote:
> > > > On Thursday 16 July 2015 03:02:03 Rafael J. Wysocki wrote:
> > > > > Also, if you're adding AFTER_FREEZE, it would be good to add =
BEFORE_THAW too
> > > > > for symmetry.
> > > > >=20
> > > >=20
> > > > But there is no use case for BEFORE_THAW. At least it is not ne=
eded for now.
> > >=20
> > > For your use case, a single function pointer would be sufficient =
too.
> > >=20
> >=20
> > What do you mean by single function pointer? kernel/power is part o=
f
> > kernel image and dm-crypt is external kernel module.
>=20
> Well, if there is a function pointer in the core suspend code initial=
ly set to
> NULL and exported to modules such that the dm-crypt code can set it t=
o
> something else, that should be sufficient, shouldn't it?

As long as the dm-crypt module is never unloaded.  And as long as no
other module could very possible want functionality like this. Ever.

If a module wants to be notified - the providing a notifier chain
really seems like the right thing to do...

NeilBrown


>=20
> So if you're adding new PM notifier events, that's already more than =
*you* need.
>=20
> Anyway, I guess the "post freeze" new one should be enough for now, b=
ut please
> change the name to POST_FREEZE.
>=20
> Also I think we don't need separate "post freeze" events for suspend =
and
> hibernation.
>=20
> Thanks,
> Rafael
