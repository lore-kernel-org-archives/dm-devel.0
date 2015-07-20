From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2 1/3] PM suspend/hibernate: Call notifier after
 freezing processes
Date: Mon, 20 Jul 2015 09:32:26 +0200
Message-ID: <20150720073226.GB25910@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <3729395.1oJCgMXcLU@vostro.rjw.lan>
 <20150716073302.GA10393@pali>
 <3179448.TScsKEAuyR@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3179448.TScsKEAuyR@vostro.rjw.lan>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Saturday 18 July 2015 01:27:15 Rafael J. Wysocki wrote:
> On Thursday, July 16, 2015 09:33:02 AM Pali Roh=C3=A1r wrote:
> > On Thursday 16 July 2015 03:02:03 Rafael J. Wysocki wrote:
> > > Also, if you're adding AFTER_FREEZE, it would be good to add BEFO=
RE_THAW too
> > > for symmetry.
> > >=20
> >=20
> > But there is no use case for BEFORE_THAW. At least it is not needed=
 for now.
>=20
> For your use case, a single function pointer would be sufficient too.
>=20

What do you mean by single function pointer? kernel/power is part of
kernel image and dm-crypt is external kernel module.

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
