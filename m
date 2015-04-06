From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Mon, 6 Apr 2015 15:25:05 +0200
Message-ID: <20150406132505.GB9978@amd>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150406130045.GA18583@redhat.com>
Sender: linux-pm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Mon 2015-04-06 09:00:46, Mike Snitzer wrote:
> On Sun, Apr 05 2015 at  1:20pm -0400,
> Pali Roh=E1r <pali.rohar@gmail.com> wrote:
>=20
> > This patch series increase security of suspend and hibernate action=
s. It allows
> > user to safely wipe crypto keys before suspend and hibernate action=
s starts
> > without race conditions on userspace process with heavy I/O.
> >=20
> > To automatically wipe cryto key for <device> before hibernate actio=
n call:
> > $ dmsetup message <device> 0 key wipe_on_hibernation 1
> >=20
> > To automatically wipe cryto key for <device> before suspend action =
call:
> > $ dmsetup message <device> 0 key wipe_on_suspend 1
> >=20
> > (Value 0 after wipe_* string reverts original behaviour - to not wi=
pe key)
>=20
> Can you elaborate on the attack vector your changes are meant to prot=
ect
> against?  The user already authorized access, why is it inherently
> dangerous to _not_ wipe the associated key across these events?

Umm. You are using your notebook. It is unlikely to be stolen at that
point. You close the lid and board the airplane, stowing it in
overhead bin. There's much better chance of notebook being stolen now.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
