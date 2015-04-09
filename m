From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Thu, 9 Apr 2015 16:38:27 +0200
Message-ID: <20150409143827.GK12339@atrey.karlin.mff.cuni.cz>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
 <201504061529.57299@pali>
 <20150409131208.GA9504@redhat.com>
 <20150409132836.GD12339@atrey.karlin.mff.cuni.cz>
 <20150409140842.GA9779@redhat.com>
 <20150409141633.GJ12339@atrey.karlin.mff.cuni.cz>
 <20150409142658.GA9839@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150409142658.GA9839@redhat.com>
Sender: linux-pm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Thursday 09 April 2015 10:26:58 Mike Snitzer wrote:
> On Thu, Apr 09 2015 at 10:16am -0400,
> Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
>=20
> > On Thursday 09 April 2015 10:08:43 Mike Snitzer wrote:
> > > On Thu, Apr 09 2015 at  9:28am -0400,
> > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > >=20
> > > > On Thursday 09 April 2015 09:12:08 Mike Snitzer wrote:
> > > > > On Mon, Apr 06 2015 at  9:29am -0400,
> > > > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > > > >=20
> > > > > > On Monday 06 April 2015 15:00:46 Mike Snitzer wrote:
> > > > > > > On Sun, Apr 05 2015 at  1:20pm -0400,
> > > > > > >=20
> > > > > > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > > > > > > > This patch series increase security of suspend and hibe=
rnate
> > > > > > > > actions. It allows user to safely wipe crypto keys befo=
re
> > > > > > > > suspend and hibernate actions starts without race
> > > > > > > > conditions on userspace process with heavy I/O.
> > > > > > > >=20
> > > > > > > > To automatically wipe cryto key for <device> before
> > > > > > > > hibernate action call: $ dmsetup message <device> 0 key
> > > > > > > > wipe_on_hibernation 1
> > > > > > > >=20
> > > > > > > > To automatically wipe cryto key for <device> before sus=
pend
> > > > > > > > action call: $ dmsetup message <device> 0 key
> > > > > > > > wipe_on_suspend 1
> > > > > > > >=20
> > > > > > > > (Value 0 after wipe_* string reverts original behaviour=
 - to
> > > > > > > > not wipe key)
> > > > > > >=20
> > > > > > > Can you elaborate on the attack vector your changes are m=
eant
> > > > > > > to protect against?  The user already authorized access, =
why
> > > > > > > is it inherently dangerous to _not_ wipe the associated k=
ey
> > > > > > > across these events?
> > > > > >=20
> > > > > > Hi,
> > > > > >=20
> > > > > > yes, I will try to explain current problems with cryptsetup=
=20
> > > > > > luksSuspend command and hibernation.
> > > > > >=20
> > > > > > First, sometimes it is needed to put machine into other han=
ds.=20
> > > > > > You can still watch other person what is doing with machine=
, but=20
> > > > > > once if you let machine unlocked (e.g opened luks disk), sh=
e/he=20
> > > > > > can access encrypted data.
> > > > > >=20
> > > > > > If you turn off machine, it could be safe, because luks dis=
k=20
> > > > > > devices are locked. But if you enter machine into suspend o=
r=20
> > > > > > hibernate state luks devices are still open. And my patches=
 try=20
> > > > > > to achieve similar security as when machine is off (=3D no =
crypto=20
> > > > > > keys in RAM or on swap).
> > > > > >=20
> > > > > > When doing hibernate on unencrypted swap it is to prevent l=
eaking=20
> > > > > > crypto keys to hibernate image (which is stored in swap).
> > > > > >=20
> > > > > > When doing suspend action it is again to prevent leaking cr=
ypto=20
> > > > > > keys. E.g when you suspend laptop and put it off (somebody =
can=20
> > > > > > remove RAMs and do some cold boot attack).
> > > > > >=20
> > > > > > The most common situation is:
> > > > > > You have mounted partition from dm-crypt device (e.g. /home=
/),=20
> > > > > > some userspace processes access it (e.g opened firefox whic=
h=20
> > > > > > still reads/writes to cache ~/.firefox/) and you want to dr=
op=20
> > > > > > crypto keys from kernel for some time.
> > > > > >=20
> > > > > > For that operation there is command cryptsetup luksSuspend,=
 which=20
> > > > > > suspend dm device and then tell kernel to wipe crypto keys.=
 All=20
> > > > > > I/O operations are then stopped and userspace processes whi=
ch=20
> > > > > > want to do some those I/O operations are stopped too (until=
 you=20
> > > > > > call cryptsetup luksResume and enter correct key).
> > > > > >=20
> > > > > > Now if you want to suspend/hiberate your machine (when some=
 of dm=20
> > > > > > devices are suspeneded and some processes are stopped due t=
o=20
> > > > > > pending I/O) it is not possible. Kernel freeze_processes fu=
nction=20
> > > > > > will fail because userspace processes are still stopped ins=
ide=20
> > > > > > some I/O syscall (read/write, etc,...).
> > > > > >=20
> > > > > > My patches fixes this problem and do those operations (susp=
end dm=20
> > > > > > device, wipe crypto keys, enter suspend/hiberate) in correc=
t=20
> > > > > > order and without race condition.
> > > > > >=20
> > > > > > dm device is suspended *after* userspace processes are free=
zed=20
> > > > > > and after that are crypto keys wiped. And then computer/lap=
top=20
> > > > > > enters into suspend/hibernate state.
> > > > >=20
> > > > > Wouldn't it be better to fix freeze_processes() to be toleran=
t of
> > > > > processes that are hung as a side-effect of their backing sto=
rage being
> > > > > suspended?  A hibernate shouldn't fail simply because a user =
chose to
> > > > > suspend a DM device.
> > > > >=20
> > > > > Then this entire problem goes away and the key can be wiped f=
rom
> > > > > userspace (like you said above).
> > > >=20
> > > > Still there will be race condition. Before hibernation (and dev=
ice
> > > > poweroff) we should have synced disks and filesystems to preven=
t data
> > > > lose (or other damage) as more as we can. And if there will be =
some
> > > > application which using lot of I/O (e.g normal firefox) then th=
ere
> > > > always will be race condtion.
> > >=20
> > > The DM suspend will take care of flushing any pending I/O.  So I =
don't
> > > see where the supposed race is...
> > >=20
> >=20
> > Any I/O operation after DM suspend is race condition and could caus=
e
> > data lost.
> >=20
> > > Anything else that is trapped in userspace memory will be there w=
hen the
> > > machine resumes.
> > >=20
> >=20
> > You are expecting that machine resumes always at 100% and correctly=
=2E But
> > this is not truth in real world. There are planty of users who repo=
rted
> > lot of random problems with suspend or hibernate...
>=20
> But the system was left in a crash consistent state.  Properly writte=
n
> apps will wait for I/O to ensure data loss (in the event of a failed
> resume) isn't a problem.
> =20

I think you are too optimistic about ideal world...
"Properly written apps" "ensure data loss"

> > > > So proper way is to wipe luks crypto keys *after* userspace pro=
cesses
> > > > are freezed.
> > >=20
> > > I know you believe that I'm just not accepting that at face value=
=2E
> >=20
> > If disks are synced before any DM suspend operation then we have hi=
gher
> > chance of preventing data corruption.
>=20
> disks are already synced as part of the DM suspend operation!
>=20

Yes, but part of hibernate operation is also sync call.

> But you're saying that all user processes are frozen (and associated
> I/O flushed) before the DM suspend, that is different:
>=20

Yes, I want to ensure that. So processes wont be able to do any other
I/O.

> > I still think that correct order is only:
> >=20
> > * freeze processes (which doing continous I/O)
> > * fs & disk sync
> > * DM suspend
> > * wipe crypto keys
> > * enter hibernate
>=20
> I just don't think that extreme is _required_ to have a hibernate/res=
ume
> that incorporates dm-crypt key wiping.

Ok, and what other developers think?

I'm saying that if I want to wipe luks keys before suspend/hibernate an=
d
have system in consistant state as much as possible, keys must be wiped
*after* userspace processes are freezed. Or do you have relevant or
functional argument why not? Or is there any problem in my thinking?

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
