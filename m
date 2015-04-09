From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Thu, 9 Apr 2015 09:12:08 -0400
Message-ID: <20150409131208.GA9504@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <20150406130045.GA18583@redhat.com>
 <201504061529.57299@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201504061529.57299@pali>
Sender: linux-pm-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Apr 06 2015 at  9:29am -0400,
Pali Roh=E1r <pali.rohar@gmail.com> wrote:

> On Monday 06 April 2015 15:00:46 Mike Snitzer wrote:
> > On Sun, Apr 05 2015 at  1:20pm -0400,
> >=20
> > Pali Roh=E1r <pali.rohar@gmail.com> wrote:
> > > This patch series increase security of suspend and hibernate
> > > actions. It allows user to safely wipe crypto keys before
> > > suspend and hibernate actions starts without race
> > > conditions on userspace process with heavy I/O.
> > >=20
> > > To automatically wipe cryto key for <device> before
> > > hibernate action call: $ dmsetup message <device> 0 key
> > > wipe_on_hibernation 1
> > >=20
> > > To automatically wipe cryto key for <device> before suspend
> > > action call: $ dmsetup message <device> 0 key
> > > wipe_on_suspend 1
> > >=20
> > > (Value 0 after wipe_* string reverts original behaviour - to
> > > not wipe key)
> >=20
> > Can you elaborate on the attack vector your changes are meant
> > to protect against?  The user already authorized access, why
> > is it inherently dangerous to _not_ wipe the associated key
> > across these events?
>=20
> Hi,
>=20
> yes, I will try to explain current problems with cryptsetup=20
> luksSuspend command and hibernation.
>=20
> First, sometimes it is needed to put machine into other hands.=20
> You can still watch other person what is doing with machine, but=20
> once if you let machine unlocked (e.g opened luks disk), she/he=20
> can access encrypted data.
>=20
> If you turn off machine, it could be safe, because luks disk=20
> devices are locked. But if you enter machine into suspend or=20
> hibernate state luks devices are still open. And my patches try=20
> to achieve similar security as when machine is off (=3D no crypto=20
> keys in RAM or on swap).
>=20
> When doing hibernate on unencrypted swap it is to prevent leaking=20
> crypto keys to hibernate image (which is stored in swap).
>=20
> When doing suspend action it is again to prevent leaking crypto=20
> keys. E.g when you suspend laptop and put it off (somebody can=20
> remove RAMs and do some cold boot attack).
>=20
> The most common situation is:
> You have mounted partition from dm-crypt device (e.g. /home/),=20
> some userspace processes access it (e.g opened firefox which=20
> still reads/writes to cache ~/.firefox/) and you want to drop=20
> crypto keys from kernel for some time.
>=20
> For that operation there is command cryptsetup luksSuspend, which=20
> suspend dm device and then tell kernel to wipe crypto keys. All=20
> I/O operations are then stopped and userspace processes which=20
> want to do some those I/O operations are stopped too (until you=20
> call cryptsetup luksResume and enter correct key).
>=20
> Now if you want to suspend/hiberate your machine (when some of dm=20
> devices are suspeneded and some processes are stopped due to=20
> pending I/O) it is not possible. Kernel freeze_processes function=20
> will fail because userspace processes are still stopped inside=20
> some I/O syscall (read/write, etc,...).
>=20
> My patches fixes this problem and do those operations (suspend dm=20
> device, wipe crypto keys, enter suspend/hiberate) in correct=20
> order and without race condition.
>=20
> dm device is suspended *after* userspace processes are freezed=20
> and after that are crypto keys wiped. And then computer/laptop=20
> enters into suspend/hibernate state.

Wouldn't it be better to fix freeze_processes() to be tolerant of
processes that are hung as a side-effect of their backing storage being
suspended?  A hibernate shouldn't fail simply because a user chose to
suspend a DM device.

Then this entire problem goes away and the key can be wiped from
userspace (like you said above).
