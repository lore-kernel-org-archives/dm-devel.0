From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Fri, 17 Apr 2015 03:52:12 -0400
Message-ID: <20150417075211.GC403@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
 <201504061529.57299@pali>
 <20150409131208.GA9504@redhat.com>
 <20150409132836.GD12339@atrey.karlin.mff.cuni.cz>
 <20150409140842.GA9779@redhat.com>
 <mgnv2g$if5$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <mgnv2g$if5$2@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Apr 16 2015 at  5:23am -0400,
Alex Elsayed <eternaleye@gmail.com> wrote:

> Mike Snitzer wrote:
>=20
> > On Thu, Apr 09 2015 at  9:28am -0400,
> > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> >=20
> >> On Thursday 09 April 2015 09:12:08 Mike Snitzer wrote:
> >> > On Mon, Apr 06 2015 at  9:29am -0400,
> >> > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> >> >=20
> >> > > On Monday 06 April 2015 15:00:46 Mike Snitzer wrote:
> >> > > > On Sun, Apr 05 2015 at  1:20pm -0400,
> >> > > >=20
> >> > > > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> >> > > > > This patch series increase security of suspend and hiberna=
te
> >> > > > > actions. It allows user to safely wipe crypto keys before
> >> > > > > suspend and hibernate actions starts without race
> >> > > > > conditions on userspace process with heavy I/O.
> >> > > > >=20
> >> > > > > To automatically wipe cryto key for <device> before
> >> > > > > hibernate action call: $ dmsetup message <device> 0 key
> >> > > > > wipe_on_hibernation 1
> >> > > > >=20
> >> > > > > To automatically wipe cryto key for <device> before suspen=
d
> >> > > > > action call: $ dmsetup message <device> 0 key
> >> > > > > wipe_on_suspend 1
> >> > > > >=20
> >> > > > > (Value 0 after wipe_* string reverts original behaviour - =
to
> >> > > > > not wipe key)
> >> > > >=20
> >> > > > Can you elaborate on the attack vector your changes are mean=
t
> >> > > > to protect against?  The user already authorized access, why
> >> > > > is it inherently dangerous to _not_ wipe the associated key
> >> > > > across these events?
> >> > >=20
> >> > > Hi,
> >> > >=20
> >> > > yes, I will try to explain current problems with cryptsetup
> >> > > luksSuspend command and hibernation.
> >> > >=20
> >> > > First, sometimes it is needed to put machine into other hands.
> >> > > You can still watch other person what is doing with machine, b=
ut
> >> > > once if you let machine unlocked (e.g opened luks disk), she/h=
e
> >> > > can access encrypted data.
> >> > >=20
> >> > > If you turn off machine, it could be safe, because luks disk
> >> > > devices are locked. But if you enter machine into suspend or
> >> > > hibernate state luks devices are still open. And my patches tr=
y
> >> > > to achieve similar security as when machine is off (=3D no cry=
pto
> >> > > keys in RAM or on swap).
> >> > >=20
> >> > > When doing hibernate on unencrypted swap it is to prevent leak=
ing
> >> > > crypto keys to hibernate image (which is stored in swap).
> >> > >=20
> >> > > When doing suspend action it is again to prevent leaking crypt=
o
> >> > > keys. E.g when you suspend laptop and put it off (somebody can
> >> > > remove RAMs and do some cold boot attack).
> >> > >=20
> >> > > The most common situation is:
> >> > > You have mounted partition from dm-crypt device (e.g. /home/),
> >> > > some userspace processes access it (e.g opened firefox which
> >> > > still reads/writes to cache ~/.firefox/) and you want to drop
> >> > > crypto keys from kernel for some time.
> >> > >=20
> >> > > For that operation there is command cryptsetup luksSuspend, wh=
ich
> >> > > suspend dm device and then tell kernel to wipe crypto keys. Al=
l
> >> > > I/O operations are then stopped and userspace processes which
> >> > > want to do some those I/O operations are stopped too (until yo=
u
> >> > > call cryptsetup luksResume and enter correct key).
> >> > >=20
> >> > > Now if you want to suspend/hiberate your machine (when some of=
 dm
> >> > > devices are suspeneded and some processes are stopped due to
> >> > > pending I/O) it is not possible. Kernel freeze_processes funct=
ion
> >> > > will fail because userspace processes are still stopped inside
> >> > > some I/O syscall (read/write, etc,...).
> >> > >=20
> >> > > My patches fixes this problem and do those operations (suspend=
 dm
> >> > > device, wipe crypto keys, enter suspend/hiberate) in correct
> >> > > order and without race condition.
> >> > >=20
> >> > > dm device is suspended *after* userspace processes are freezed
> >> > > and after that are crypto keys wiped. And then computer/laptop
> >> > > enters into suspend/hibernate state.
> >> >=20
> >> > Wouldn't it be better to fix freeze_processes() to be tolerant o=
f
> >> > processes that are hung as a side-effect of their backing storag=
e being
> >> > suspended?  A hibernate shouldn't fail simply because a user cho=
se to
> >> > suspend a DM device.
> >> >=20
> >> > Then this entire problem goes away and the key can be wiped from
> >> > userspace (like you said above).
> >>=20
> >> Still there will be race condition. Before hibernation (and device
> >> poweroff) we should have synced disks and filesystems to prevent d=
ata
> >> lose (or other damage) as more as we can. And if there will be som=
e
> >> application which using lot of I/O (e.g normal firefox) then there
> >> always will be race condtion.
> >=20
> > The DM suspend will take care of flushing any pending I/O.  So I do=
n't
> > see where the supposed race is...
> >=20
> > Anything else that is trapped in userspace memory will be there whe=
n the
> > machine resumes.
> >=20
> >> So proper way is to wipe luks crypto keys *after* userspace proces=
ses
> >> are freezed.
> >=20
> > I know you believe that I'm just not accepting that at face value.
>=20
> Um, pardon me if I'm being naive, but what about the case of hibernat=
ion=20
> where the swapdev and the root device are both LVs on the same dm_cry=
pt=20
> device?
>=20
> The kernel is writing to swap _after_ userspace processes are all fro=
zen;=20
> that seems to me like an ordering dependency entirely incompatible wi=
th=20
> userspace dropping the key...

Good point, definitely not compatible with the Pali's approach.

(but is swap really configured ontop of the same dm-crypt device like
this in practice?  I've not heard of that being a common pattern but I
could just be sheltered)
