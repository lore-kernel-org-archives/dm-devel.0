From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Mon, 6 Apr 2015 16:51:45 -0400
Message-ID: <20150406205145.GA19677@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
 <20150406132505.GB9978@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150406132505.GB9978@amd>
Sender: linux-pm-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Apr 06 2015 at  9:25am -0400,
Pavel Machek <pavel@ucw.cz> wrote:

> On Mon 2015-04-06 09:00:46, Mike Snitzer wrote:
> > On Sun, Apr 05 2015 at  1:20pm -0400,
> > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> >=20
> > > This patch series increase security of suspend and hibernate acti=
ons. It allows
> > > user to safely wipe crypto keys before suspend and hibernate acti=
ons starts
> > > without race conditions on userspace process with heavy I/O.
> > >=20
> > > To automatically wipe cryto key for <device> before hibernate act=
ion call:
> > > $ dmsetup message <device> 0 key wipe_on_hibernation 1
> > >=20
> > > To automatically wipe cryto key for <device> before suspend actio=
n call:
> > > $ dmsetup message <device> 0 key wipe_on_suspend 1
> > >=20
> > > (Value 0 after wipe_* string reverts original behaviour - to not =
wipe key)
> >=20
> > Can you elaborate on the attack vector your changes are meant to pr=
otect
> > against?  The user already authorized access, why is it inherently
> > dangerous to _not_ wipe the associated key across these events?
>=20
> Umm. You are using your notebook. It is unlikely to be stolen at that
> point. You close the lid and board the airplane, stowing it in
> overhead bin. There's much better chance of notebook being stolen now=
=2E

Yes, pretty straight forward but the thief would need to then login upo=
n
resume (at least with most common desktop configs)... the barrier then
is only the strength of the user's password and not the crypt
passphrase.
