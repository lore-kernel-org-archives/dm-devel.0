From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing suspend/hibernation
Date: Mon, 6 Apr 2015 23:27:35 +0200
Message-ID: <201504062327.35325@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <201504061529.57299@pali> <20150406181738.GC9978@amd>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4075191.yf6hhQT2n7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20150406181738.GC9978@amd>
Sender: linux-pm-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

--nextPart4075191.yf6hhQT2n7
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 06 April 2015 20:17:38 Pavel Machek wrote:
> On Mon 2015-04-06 15:29:57, Pali Roh=C3=A1r wrote:
> > On Monday 06 April 2015 15:00:46 Mike Snitzer wrote:
> > > On Sun, Apr 05 2015 at  1:20pm -0400,
> > >=20
> > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > > > This patch series increase security of suspend and
> > > > hibernate actions. It allows user to safely wipe crypto
> > > > keys before suspend and hibernate actions starts
> > > > without race conditions on userspace process with heavy
> > > > I/O.
> > > >=20
> > > > To automatically wipe cryto key for <device> before
> > > > hibernate action call: $ dmsetup message <device> 0 key
> > > > wipe_on_hibernation 1
> > > >=20
> > > > To automatically wipe cryto key for <device> before
> > > > suspend action call: $ dmsetup message <device> 0 key
> > > > wipe_on_suspend 1
> > > >=20
> > > > (Value 0 after wipe_* string reverts original behaviour
> > > > - to not wipe key)
> > >=20
> > > Can you elaborate on the attack vector your changes are
> > > meant to protect against?  The user already authorized
> > > access, why is it inherently dangerous to _not_ wipe the
> > > associated key across these events?
> >=20
> > Hi,
> >=20
> > yes, I will try to explain current problems with cryptsetup
> > luksSuspend command and hibernation.
> >=20
> > First, sometimes it is needed to put machine into other
> > hands. You can still watch other person what is doing with
> > machine, but once if you let machine unlocked (e.g opened
> > luks disk), she/he can access encrypted data.
> >=20
> > If you turn off machine, it could be safe, because luks disk
> > devices are locked. But if you enter machine into suspend or
> > hibernate state luks devices are still open. And my patches
> > try to achieve similar security as when machine is off (=3D
> > no crypto keys in RAM or on swap).
> >=20
> > When doing hibernate on unencrypted swap it is to prevent
> > leaking crypto keys to hibernate image (which is stored in
> > swap).
> >=20
> > When doing suspend action it is again to prevent leaking
> > crypto keys. E.g when you suspend laptop and put it off
> > (somebody can remove RAMs and do some cold boot attack).
> >=20
> > The most common situation is:
> > You have mounted partition from dm-crypt device (e.g.
> > /home/), some userspace processes access it (e.g opened
> > firefox which still reads/writes to cache ~/.firefox/) and
> > you want to drop crypto keys from kernel for some time.
> >=20
> > For that operation there is command cryptsetup luksSuspend,
> > which suspend dm device and then tell kernel to wipe crypto
> > keys. All I/O operations are then stopped and userspace
> > processes which want to do some those I/O operations are
> > stopped too (until you call cryptsetup luksResume and enter
> > correct key).
>=20
> Actually... is the list of sites where the process wait small
> enough? Could we modify them to be freezeable? Suspend should
> work even if user stopped the his crypto partitions...
>=20
> 								Pavel

If you suspend dm device and then you want to read file from fs=20
which is on that device, then process freeze and you even cannot=20
kill it with SIGKILL. Before entering suspend kernel tries to do=20
sync and that operation also fails...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4075191.yf6hhQT2n7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlUi+kcACgkQi/DJPQPkQ1LtpQCfYAKMN41fzSvwf3/7NSbH3OAh
WbAAoLH3VSH0KYKZbwGtlm7vORo18BuH
=TmEZ
-----END PGP SIGNATURE-----

--nextPart4075191.yf6hhQT2n7--
