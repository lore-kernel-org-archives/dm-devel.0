From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Thu, 9 Apr 2015 16:16:33 +0200
Message-ID: <20150409141633.GJ12339@atrey.karlin.mff.cuni.cz>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
 <201504061529.57299@pali>
 <20150409131208.GA9504@redhat.com>
 <20150409132836.GD12339@atrey.karlin.mff.cuni.cz>
 <20150409140842.GA9779@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150409140842.GA9779@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Thursday 09 April 2015 10:08:43 Mike Snitzer wrote:
> On Thu, Apr 09 2015 at  9:28am -0400,
> Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
>=20
> > On Thursday 09 April 2015 09:12:08 Mike Snitzer wrote:
> > > On Mon, Apr 06 2015 at  9:29am -0400,
> > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > >=20
> > > > On Monday 06 April 2015 15:00:46 Mike Snitzer wrote:
> > > > > On Sun, Apr 05 2015 at  1:20pm -0400,
> > > > >=20
> > > > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > > > > > This patch series increase security of suspend and hibernat=
e
> > > > > > actions. It allows user to safely wipe crypto keys before
> > > > > > suspend and hibernate actions starts without race
> > > > > > conditions on userspace process with heavy I/O.
> > > > > >=20
> > > > > > To automatically wipe cryto key for <device> before
> > > > > > hibernate action call: $ dmsetup message <device> 0 key
> > > > > > wipe_on_hibernation 1
> > > > > >=20
> > > > > > To automatically wipe cryto key for <device> before suspend
> > > > > > action call: $ dmsetup message <device> 0 key
> > > > > > wipe_on_suspend 1
> > > > > >=20
> > > > > > (Value 0 after wipe_* string reverts original behaviour - t=
o
> > > > > > not wipe key)
> > > > >=20
> > > > > Can you elaborate on the attack vector your changes are meant
> > > > > to protect against?  The user already authorized access, why
> > > > > is it inherently dangerous to _not_ wipe the associated key
> > > > > across these events?
> > > >=20
> > > > Hi,
> > > >=20
> > > > yes, I will try to explain current problems with cryptsetup=20
> > > > luksSuspend command and hibernation.
> > > >=20
> > > > First, sometimes it is needed to put machine into other hands.=20
> > > > You can still watch other person what is doing with machine, bu=
t=20
> > > > once if you let machine unlocked (e.g opened luks disk), she/he=
=20
> > > > can access encrypted data.
> > > >=20
> > > > If you turn off machine, it could be safe, because luks disk=20
> > > > devices are locked. But if you enter machine into suspend or=20
> > > > hibernate state luks devices are still open. And my patches try=
=20
> > > > to achieve similar security as when machine is off (=3D no cryp=
to=20
> > > > keys in RAM or on swap).
> > > >=20
> > > > When doing hibernate on unencrypted swap it is to prevent leaki=
ng=20
> > > > crypto keys to hibernate image (which is stored in swap).
> > > >=20
> > > > When doing suspend action it is again to prevent leaking crypto=
=20
> > > > keys. E.g when you suspend laptop and put it off (somebody can=20
> > > > remove RAMs and do some cold boot attack).
> > > >=20
> > > > The most common situation is:
> > > > You have mounted partition from dm-crypt device (e.g. /home/),=20
> > > > some userspace processes access it (e.g opened firefox which=20
> > > > still reads/writes to cache ~/.firefox/) and you want to drop=20
> > > > crypto keys from kernel for some time.
> > > >=20
> > > > For that operation there is command cryptsetup luksSuspend, whi=
ch=20
> > > > suspend dm device and then tell kernel to wipe crypto keys. All=
=20
> > > > I/O operations are then stopped and userspace processes which=20
> > > > want to do some those I/O operations are stopped too (until you=
=20
> > > > call cryptsetup luksResume and enter correct key).
> > > >=20
> > > > Now if you want to suspend/hiberate your machine (when some of =
dm=20
> > > > devices are suspeneded and some processes are stopped due to=20
> > > > pending I/O) it is not possible. Kernel freeze_processes functi=
on=20
> > > > will fail because userspace processes are still stopped inside=20
> > > > some I/O syscall (read/write, etc,...).
> > > >=20
> > > > My patches fixes this problem and do those operations (suspend =
dm=20
> > > > device, wipe crypto keys, enter suspend/hiberate) in correct=20
> > > > order and without race condition.
> > > >=20
> > > > dm device is suspended *after* userspace processes are freezed=20
> > > > and after that are crypto keys wiped. And then computer/laptop=20
> > > > enters into suspend/hibernate state.
> > >=20
> > > Wouldn't it be better to fix freeze_processes() to be tolerant of
> > > processes that are hung as a side-effect of their backing storage=
 being
> > > suspended?  A hibernate shouldn't fail simply because a user chos=
e to
> > > suspend a DM device.
> > >=20
> > > Then this entire problem goes away and the key can be wiped from
> > > userspace (like you said above).
> >=20
> > Still there will be race condition. Before hibernation (and device
> > poweroff) we should have synced disks and filesystems to prevent da=
ta
> > lose (or other damage) as more as we can. And if there will be some
> > application which using lot of I/O (e.g normal firefox) then there
> > always will be race condtion.
>=20
> The DM suspend will take care of flushing any pending I/O.  So I don'=
t
> see where the supposed race is...
>=20

Any I/O operation after DM suspend is race condition and could cause
data lost.

> Anything else that is trapped in userspace memory will be there when =
the
> machine resumes.
>=20

You are expecting that machine resumes always at 100% and correctly. Bu=
t
this is not truth in real world. There are planty of users who reported
lot of random problems with suspend or hibernate...

> > So proper way is to wipe luks crypto keys *after* userspace process=
es
> > are freezed.
>=20
> I know you believe that I'm just not accepting that at face value.

If disks are synced before any DM suspend operation then we have higher
chance of preventing data corruption.

I still think that correct order is only:

* freeze processes (which doing continous I/O)
* fs & disk sync
* DM suspend
* wipe crypto keys
* enter hibernate

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
