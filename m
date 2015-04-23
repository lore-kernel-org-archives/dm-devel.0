From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Thu, 23 Apr 2015 19:02:11 +0200
Message-ID: <20150423170211.GI7646@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
 <201504061529.57299@pali>
 <20150409131208.GA9504@redhat.com>
 <20150409132836.GD12339@atrey.karlin.mff.cuni.cz>
 <20150409140842.GA9779@redhat.com>
 <20150409141633.GJ12339@atrey.karlin.mff.cuni.cz>
 <20150409142658.GA9839@redhat.com>
 <20150409143827.GK12339@atrey.karlin.mff.cuni.cz>
 <20150414065016.GB20597@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150414065016.GB20597@amd>
Sender: linux-pm-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Tuesday 14 April 2015 08:50:16 Pavel Machek wrote:
> Hi!
>=20
> > > > > > So proper way is to wipe luks crypto keys *after* userspace=
 processes
> > > > > > are freezed.
> > > > >=20
> > > > > I know you believe that I'm just not accepting that at face v=
alue.
> > > >=20
> > > > If disks are synced before any DM suspend operation then we hav=
e higher
> > > > chance of preventing data corruption.
> > >=20
> > > disks are already synced as part of the DM suspend operation!
> > >=20
> >=20
> > Yes, but part of hibernate operation is also sync call.
>=20
> Yes. Maybe that was a mistake.
>=20

I think not. I do not see any reason why system should not sync disks..=
=2E

> > > > I still think that correct order is only:
> > > >=20
> > > > * freeze processes (which doing continous I/O)
> > > > * fs & disk sync
> > > > * DM suspend
> > > > * wipe crypto keys
> > > > * enter hibernate
> > >=20
> > > I just don't think that extreme is _required_ to have a hibernate=
/resume
> > > that incorporates dm-crypt key wiping.
> >=20
> > Ok, and what other developers think?
>=20
> If someone can fix freezer to work with LUKS stopped, that would be a=
=20
> good thing. Can you do it, Mike? Then we can look if it works well
> enough for Pali.
>=20

Its not only LUKS devices. Its for all dm devices when are suspended.

> But that might be too hard / impossible. And at that point, I think
> Pali's patch is right thing to do.
> 									Pavel

Yes I think it is hard too...

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
