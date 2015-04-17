From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key when doing suspend/hibernation
Date: Fri, 17 Apr 2015 08:53:21 -0700
Message-ID: <mgra9i$rla$2@ger.gmane.org>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <20150406130045.GA18583@redhat.com> <201504061529.57299@pali> <20150409131208.GA9504@redhat.com> <20150409132836.GD12339@atrey.karlin.mff.cuni.cz> <20150409140842.GA9779@redhat.com> <mgnv2g$if5$2@ger.gmane.org> <20150417075211.GC403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

Mike Snitzer wrote:

> On Thu, Apr 16 2015 at  5:23am -0400,
> Alex Elsayed <eternaleye@gmail.com> wrote:
>=20
>> Mike Snitzer wrote:
>>=20
>> > On Thu, Apr 09 2015 at  9:28am -0400,
>> > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
>> >=20
>> >> On Thursday 09 April 2015 09:12:08 Mike Snitzer wrote:
>> >> > On Mon, Apr 06 2015 at  9:29am -0400,
>> >> > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
>> >> >=20
>> >> > > On Monday 06 April 2015 15:00:46 Mike Snitzer wrote:
>> >> > > > On Sun, Apr 05 2015 at  1:20pm -0400,
>> >> > > >=20
>> >> > > > Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
>> >> > > > > This patch series increase security of suspend and hibern=
ate
>> >> > > > > actions. It allows user to safely wipe crypto keys before
>> >> > > > > suspend and hibernate actions starts without race
>> >> > > > > conditions on userspace process with heavy I/O.
>> >> > > > >=20
>> >> > > > > To automatically wipe cryto key for <device> before
>> >> > > > > hibernate action call: $ dmsetup message <device> 0 key
>> >> > > > > wipe_on_hibernation 1
>> >> > > > >=20
>> >> > > > > To automatically wipe cryto key for <device> before suspe=
nd
>> >> > > > > action call: $ dmsetup message <device> 0 key
>> >> > > > > wipe_on_suspend 1
>> >> > > > >=20
>> >> > > > > (Value 0 after wipe_* string reverts original behaviour -=
 to
>> >> > > > > not wipe key)
>> >> > > >=20
>> >> > > > Can you elaborate on the attack vector your changes are mea=
nt
>> >> > > > to protect against?  The user already authorized access, wh=
y
>> >> > > > is it inherently dangerous to _not_ wipe the associated key
>> >> > > > across these events?
>> >> > >=20
>> >> > > Hi,
>> >> > >=20
>> >> > > yes, I will try to explain current problems with cryptsetup
>> >> > > luksSuspend command and hibernation.
>> >> > >=20
>> >> > > First, sometimes it is needed to put machine into other hands=
=2E
>> >> > > You can still watch other person what is doing with machine, =
but
>> >> > > once if you let machine unlocked (e.g opened luks disk), she/=
he
>> >> > > can access encrypted data.
>> >> > >=20
>> >> > > If you turn off machine, it could be safe, because luks disk
>> >> > > devices are locked. But if you enter machine into suspend or
>> >> > > hibernate state luks devices are still open. And my patches t=
ry
>> >> > > to achieve similar security as when machine is off (=3D no cr=
ypto
>> >> > > keys in RAM or on swap).
>> >> > >=20
>> >> > > When doing hibernate on unencrypted swap it is to prevent lea=
king
>> >> > > crypto keys to hibernate image (which is stored in swap).
>> >> > >=20
>> >> > > When doing suspend action it is again to prevent leaking cryp=
to
>> >> > > keys. E.g when you suspend laptop and put it off (somebody ca=
n
>> >> > > remove RAMs and do some cold boot attack).
>> >> > >=20
>> >> > > The most common situation is:
>> >> > > You have mounted partition from dm-crypt device (e.g. /home/)=
,
>> >> > > some userspace processes access it (e.g opened firefox which
>> >> > > still reads/writes to cache ~/.firefox/) and you want to drop
>> >> > > crypto keys from kernel for some time.
>> >> > >=20
>> >> > > For that operation there is command cryptsetup luksSuspend, w=
hich
>> >> > > suspend dm device and then tell kernel to wipe crypto keys. A=
ll
>> >> > > I/O operations are then stopped and userspace processes which
>> >> > > want to do some those I/O operations are stopped too (until y=
ou
>> >> > > call cryptsetup luksResume and enter correct key).
>> >> > >=20
>> >> > > Now if you want to suspend/hiberate your machine (when some o=
f dm
>> >> > > devices are suspeneded and some processes are stopped due to
>> >> > > pending I/O) it is not possible. Kernel freeze_processes func=
tion
>> >> > > will fail because userspace processes are still stopped insid=
e
>> >> > > some I/O syscall (read/write, etc,...).
>> >> > >=20
>> >> > > My patches fixes this problem and do those operations (suspen=
d dm
>> >> > > device, wipe crypto keys, enter suspend/hiberate) in correct
>> >> > > order and without race condition.
>> >> > >=20
>> >> > > dm device is suspended *after* userspace processes are freeze=
d
>> >> > > and after that are crypto keys wiped. And then computer/lapto=
p
>> >> > > enters into suspend/hibernate state.
>> >> >=20
>> >> > Wouldn't it be better to fix freeze_processes() to be tolerant =
of
>> >> > processes that are hung as a side-effect of their backing stora=
ge
>> >> > being
>> >> > suspended?  A hibernate shouldn't fail simply because a user ch=
ose
>> >> > to suspend a DM device.
>> >> >=20
>> >> > Then this entire problem goes away and the key can be wiped fro=
m
>> >> > userspace (like you said above).
>> >>=20
>> >> Still there will be race condition. Before hibernation (and devic=
e
>> >> poweroff) we should have synced disks and filesystems to prevent =
data
>> >> lose (or other damage) as more as we can. And if there will be so=
me
>> >> application which using lot of I/O (e.g normal firefox) then ther=
e
>> >> always will be race condtion.
>> >=20
>> > The DM suspend will take care of flushing any pending I/O.  So I d=
on't
>> > see where the supposed race is...
>> >=20
>> > Anything else that is trapped in userspace memory will be there wh=
en
>> > the machine resumes.
>> >=20
>> >> So proper way is to wipe luks crypto keys *after* userspace proce=
sses
>> >> are freezed.
>> >=20
>> > I know you believe that I'm just not accepting that at face value.
>>=20
>> Um, pardon me if I'm being naive, but what about the case of hiberna=
tion
>> where the swapdev and the root device are both LVs on the same dm_cr=
ypt
>> device?
>>=20
>> The kernel is writing to swap _after_ userspace processes are all fr=
ozen;
>> that seems to me like an ordering dependency entirely incompatible w=
ith
>> userspace dropping the key...
>=20
> Good point, definitely not compatible with the Pali's approach.
>=20
> (but is swap really configured ontop of the same dm-crypt device like
> this in practice?  I've not heard of that being a common pattern but =
I
> could just be sheltered)

Every laptop I've owned in the past five years has been set up as follo=
ws:

- GPT partition table (mostly for the redundant table at the end in cas=
e of=20
fuckups)
- 1GB ESP as /boot (first with grub2, then gummiboot) - It's there _any=
way_
- 32MB BIOS Boot Partition (for a traditional BIOS bootloader, so I can=
 pop
  the drive in a non-efi machine if the laptop dies - this has happened=
)
- The rest of the drive is a single dm-crypt volume, with LVM on top. W=
hat
  goes on top of LVM has varied, but these days it's just swap and btrf=
s.

The main reason for this is that I find dealing with crypttab / multipl=
e
LUKS devices on boot (or resume from hibernate) to be an incredible has=
sle;
and it's vastly simpler to  just have a single dm-crypt device and let
Dracut unlock it from a single boot prompt.

I haven't set up custom-key secure boot yet, so the evil maid attack is
still on the table, but I do this more out of "Eh, why not" (and origin=
ally,=20
"I should at least know _how_ to set it up") than actually having stuff=
 I=20
need the security for anyway.
