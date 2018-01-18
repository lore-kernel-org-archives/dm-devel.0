From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Multipath path classification revisited
Date: Thu, 18 Jan 2018 16:35:45 -0600
Message-ID: <20180118223545.GB5638@octiron.msp.redhat.com>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
	<20180115154424.fcjuudt7phxrks6q@jak-x230>
	<1516032730.5699.38.camel@suse.com>
	<20180115162658.wlccxhlaq56byykg@jak-x230>
	<1516034784.5699.44.camel@suse.com>
	<20180116202946.GO5638@octiron.msp.redhat.com>
	<1516206427.9784.125.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516206427.9784.125.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Julian Andres Klode <julian.klode@canonical.com>, Guan Junxiong <guanjunxiong@huawei.com>, development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 17, 2018 at 05:27:07PM +0100, Martin Wilck wrote:
> Here's an attempt to write down the issue from ground up. Let me know
> if I've missed, or if you disagree with, anything in this document.
> =

> **TL;DR:** Please scroll down to the "Recommendations" section.
> =

> # The goal
> =

> The goal is to make good decisions whether a given path is part of a mult=
ipath
> map, and make multipath setup "just work". This implies:
> =

>  * (Mandatory) multipathing must not harm system stability.
> =

>    - Entering emergency mode because a wrong multipath classification mus=
t be
>      avoided. =

>    - Multipath activation shouldn't cause devices or filesystems to
>      be undetected, even if they're not required for booting (unless thes=
e file
>      systems are marked "nofail", emergency mode will be entered anyway).
>  =

>  * (Important) Known devices that are reachable via multiple paths should=
 be
>     detected and set up correctly under multipath. It should be avoided t=
hat only
>     a single path is used for such devices.
> =

>  * (Nice-to-have) Newly added devices should classified correctly.
> =

> # Blacklisting
> =

> The historical approach to the problem has been blacklisting. Users are
> supposed to set the list of paths to be multipathed using blacklist and
> blacklist exceptions. This works well if done properly.
> =

> Unfortunately, getting the blacklist right is not so easy, in particular =
if it
> has to be done on many hosts, and thus I'll restrict the discussion from =
now
> on to a setup without explicit blacklisting by the user. Furthermore, I'll
> consider only setups using systemd.
> =

> # Critical points in the code flow
> =

> There are four places where paths are considered for multipathing:
> =

>  - `multipath -u` call in udev rules in initramfs,
>  - multipathd in initramfs,
>  - `multipath -u` call after switching root,
>  - multipathd after switching root.
> =

> # Avoiding errors
> =

> It's simple: in order to avoid boot errors of the "mandatory"
> category, we must make sure that the results for all four points above ar=
e the
> same, for all paths to a given device. If the classifications differ, var=
ious
> kinds of problems may arise, from hard-to-even-notice to fatal.

This may be a nit, but like I've said, I don't see this as necessary to
satisfy your "mandatory" requirements. If multipath and multipathd
classify all devices that have never been seen before as not-multipathed
in the initramfs, and then allow them after switching root, I fail to
see how this could break any of your mandatory requirements.
 =

> # Agreement between initramfs and booted system
> =

> This is also quite simple:
> =

>    **Ensure identical configuration between root fs and initrd.**
> =

> `multipath.conf`, `config_dir` contents, `wwids` file, udev rules, and co=
mmand
> line parameters have to be equal between initramfs and root FS. Moreover,=
 all
> relevant kernel modules =

> need to be available and loaded early in initramfs (before uevent process=
ing),
> to avoid errors caused by missing drivers. Also, multipathd service/socke=
t must
> be enabled both in root and initrd.
> =

> Unfortunately, that __puts the burden on the user__. He must recreate the=
 initrd
> whenever any of the above changes. We have no means to enforce that. One =
might
> consider making the multipath configuration files read-only and creating a
> tool such as `visudo` that would recreate the initrd after every change, =
but
> that would be a future project and might not be appreciated by users.
> =

> The above needs to be taken with a grain of salt, obviously only few conf=
ig
> parameters and command line options have an effect on path classification:
> =

>  - blacklist and blacklist exceptions
>  - `find_multipaths` =

>  - options related to WWID detection, `uid_attrs` etc.
>  - `-i` option to multipath (`ignore_wwids`)
>  - `-n` option to multipathd (`ignore_new_devs`)
>  - `wwids`
> =

> ## non-multipathed root
> =

> An exception to the rule in the previous section is the use case where on=
ly
> data partitions (no disks required to boot the root FS) are multipathed. =
In
> this case it's sufficient to make sure that multipathing is off during in=
itrd
> processing, and that, after switching root, the root device isn't falsely
> classied as multipath member. The latter can be achieved in various ways:
> =

>  - blacklisting
>  - find_multipaths
>  - not using "ignore_wwids" in udev rules
> =

> If either of these is used, it actually doesn't matter whether multipath =
is
> kept out of the initrd or the "equal configuration" rule is followed.
> =

> # Agreement between "multipath -u" and multipathd
> =

> This is where it gets tricky, because configuration and timing matter.
> multipath and multipathd share most of the configuration, so unless
> the configuration is modified between the runs of the two executables, we=
 can
> focus on just a few parameters.
> =

> ## find_multipaths=3Doff
> =

> This case is quite simple:
> =

> **"`ignore_wwids`" should be used if and only if "ignore_new_devs" is not=
**
> =

>  1. `ignore_new_devs`=3Doff and `ignore_wwids`=3Don: all paths will be tr=
eated as multipath
>     devices by both multipathd and multipath -u.
>  2. `ignore_new devs`=3Don and `ignore_wwids`=3Doff: both multipath and m=
ultipathd will
>     only consider paths with WWIDs in the wwids file.
> =

> Unfortunately, the current upstream default is `ignore_new_devs` off and
> `ignore_wwids` off, which is almost certain to lead to trouble.

I don't think this is as problematic as you seem to think. What is the
problem you are worried about? Obviously, it will only happen with new
devices. The problem as I see it is that multipathd will attempt to use
devices that multipath hasn't claimed. This can have one of two
outcomes:

1. Multipathd fails to create a multipath device with these devices
because they weren't claimed by udev, and someone else started using
them. This is pretty clearly only a failure of the "Nice-to-have" type.
Some other subsystem is using the device, and the udev variables reflect
that, and this is a new device.

2. Multipathd creates a multipath device using these devices, even
though it hasn't claimed the devices, and something else uses the
devices.  Due to device-mapper locking the devices, you are very limited
as to how this can happen. You can't mount a filesystem or have anything
besides device-mapper autoassemble on either the whole device or a
partition.  Other device mapper devices will be able to use the whole
device, but not the partitions (because of some quirks of kernel device
locking that I can explain if anyone is interested and doesn't feel like
reading the kernel source to see why). The only real danger that I see
is that systemd is planning on using that device for something, and
can't because multipath is. This is a real concern, but if you don't
allow new devices in your initramfs, you will guarantee the you have
gotten your regular root filesystem booted before this can ever take
place. And remember, we're talking about systemd wanting to do something
with a new device the first time it has been seen.

Here is the only scenario that I know if that fits this situation. Your
storage dies. You restore the data on a new device, and reboot.  If this
device is set up in the initramfs, then it will come up perfectly
correctly but in single-pathed mode. Assuming that "-i" correctly tells
you whether a device should be multipathed (this is what I made it for),
you run

# multipath -ic <device>

It shows you that "yes, multipath should be working on this device".
Then you run

# multipath -a <device>

to add it to the wwids file, remake your initramfs, and reboot. It's not
simplicity itself, but it's not horrible.

So the only real problem is if the device isn't mounted by the
initramfs.  In practice multipathd will almost invariably lose this
race, but if you replace a failed drive that contains no filesystems
mounted in the initramfs and does contain a filesystem directly on the
device (instead of being on LVM or MD, which will simply wait and
autoassemble on the multipath device), it is possible, I think, for
systemd to fail in boot after the switch-root because it can't mount
that filesystem.  You would need to manually mount the filesystem on the
multipath device to continue. This wouldn't occur on future boots
because the wwid will already be in the wwids file. I should point out
that I have never gotten a bug report on this.  I don't believe that
systemd is smart enough to say, "I failed using this device, but there
is another device that would also satisfy my requirements. Let me try
using it." But in theory, it could be, and this would solve the problem.

Outside of this boot race, multipath claiming a device that multipathd
doesn't use is stil bad.  multipathd using a device that multipath
hasn't claimed is much less bad.  The reason is that once multipathd
uses a device, no one else can, and even if they think they can, they
don't change the device state any.  The converse is not true.  Multipath
does change the device state when it claims a device.  This comes down
to the fact that LVM/MD present you with a different device than the one
they were assembled on (one that, for instance, no longer contains that
LVM/MD metadata). Multipath doesn't do this, it presents you with the
same device, just through a different devnode.  This is why multipath
has to do the extra work to make sure that others are using it and not
its path devices.

That is why it's so much worse to get things wrong when multipath is
running -u with -i.  When multipath claims the device, it sets it to
not ready, changes the blkid info, removes the partition devs, etc.
When lvmetad tries to autoassemble on a device and fails, it doesn't
muck with the device state.

> Option 1. is the current SUSE approach.
> =

> ## find_multipaths=3Don
> =

> The simple case, again, is
> =

>  3. ignore_new devs=3Don and `ignore_wwids`=3Doff: this behaves like 2.
>     above. Users  must explicitly add WWIDs in order to have them multipa=
thed.

I feel that this change will be completely non-obvious to users, since
(at least for RedHat and Ubuntu) that is not how find_multipaths has
ever worked before. And it is different from how non-find_multipaths
setups work for everyone.

> If `ignore_new_devs`=3Doff, multipathd will try to set up a map for a WWI=
D if and
> only if
> =

>  - a) it sees more than one path to the WWID, or
>  - b) the WWID is referenced in the wwids file.
> =

> Setting up the map may fail if one or more paths have already been opened
> otherwise (by FS mounts, LVM, MD, whatever), which can happen if the path=
 was
> classified as non-multipath before.
> =

> If `ignore_wwids`=3Don, multipath -u will classify a path as multipath me=
mber if
>  and only if
> =

>  - c) it sees more than one path to the WWID, or
>  - d) there is already a multipath map referencing the path.
> =

> "multipath -u" sees paths before multipathd during udev rule processing, =
so
> d) matters only in the root FS after a map may have been set up
> in initramfs already. Anyway, d) is an important difference to the behavi=
or of
> multipathd, because multipathd (currently, as of 0.7.4) has no such
> logic. Vice versa, the logic of b) isn't followed by `multipath -u`.

Is d) necessary for multipathd?  If so, then I'd say there is some other
bug. When multipathd starts up, it makes sure all of the wwids of any
existing multipath devices are in the wwids file. Whenever it creates a
new multipath device, it adds the wwid to the wwids file. If multipathd
is running and there is a multipath device without its wwid in the wwids
file, then that seems like its own bug to me. Otherwise, the check for
b) should always include the devices that a check for d) would catch. Am
I missing a case here?

I agree that mutipath should contain the logic for b).

> If we insist that multipath  and multipathd come to the same conclusion a=
bout
> a given path at in a given situation, it follows that only 3. above is va=
lid.
> This is what the past patches 64e27ec and ffbb886 enforce.
> =

> It's obvious that `ignore_new_devs` and `ignore_wwids` should neither bot=
h be
> "on" nor "off". In both cases the applied logic would be just too differe=
nt, agreement
> would be by coincidence only.

Again, if run "multipath -u" without "-i", having "ignore_new_devs" off
is only a problem in the case of new devices, and like I detailed above,
AFAIK only in one very specific and unlikely case.
 =

> ### ignore_new_devs=3Doff+ignore_wwids=3Don
> =

> Most of this can be fixed by adding case d) to the logic of multipathd, a=
nd b) to
> the logic of multipath.
> =

> What remains is the question of paths being detected one at a time. If we=
 fix
> b), we can focus on the case where the WWID is not in the wwids file.
> =

> The first `multipath -u` invocation for a given WWID is guaranteed to yie=
ld
> "non multipath" (only one visible path). Once multipathd gets to see this
> path, the situation may already have changed, because additional paths may
> have been detected in the meantime. Follow-up invocations of `multipath -=
u`
> will also see several paths.
> =

> Red Hat already has a patch that generates a change event on all paths wh=
en
> multipathd creates a map. When this event is processed, `multipath -u` wi=
ll
> see the existing map and (re-)classify the paths as multipath members.
> =

> The problematic case arises when the first uevent is processed by systemd=
, as
> it will not have `SYSTEMD_READY=3D0` set. If some other service such as L=
VM grabs
> the device at this point, subsequent attempts to create a multipath map w=
ill
> fail. If it's DM, the `reassign_maps` option may come to rescue. But if s=
ometing
> else (MD, mounted file system or swap, you name it) grabbed the device, t=
hat's
> impossible. As we currently start multipathd pretty late in the boot cycl=
e,
> it's highly likely that this problem occurs if the device in question con=
tains
> meta data that is recognized by higher layers.

So, in this case you simply have a non-multipathed device, correctly
identified in udev as such (assuming the you don't use "multipath -iu".
If you do use "-iu", you get a mess).

> Here's an idea how to fix this: When a path is first encountered, and
> `ignore_new_devs`=3Doff+`ignore_wwids`=3Don, udev rules set a certain pro=
perty
> (e.g. `DM_MULTIPATH_DEVICE_PATH=3D=3D2`), set `SYSTEMD_READY=3D0`, and us=
e **systemd-run**
> to create a timer that will fire a change event for the same path
> at a certain point in time. For that we need a new config option.
> =

> multipathd treats this path as orphan, until additional paths show up,
> in which case it will create a map as usual. Nothing special here.
> =

> When the timer fires, either the map will have been set up, or multipath =
will
> see that it's being invoked for the second time, and proceed with SYSTEMD=
_READY=3D1.

This is much like first approach i tried years ago when we first
integrated multipath into udev, and gave up due to corner cases and
problems with large numbers of non-multipathable device. udev has come
along way since then, and we've added systemd, and this may work better
now.  But RedHat is doing what it is doing due to the problems with
getting this method to work reliably. Also, multipath would be grabbing
every possibly-multipathable block device and holding it for a timeout.
I have a feeling that people will complain about this. For one thing,
this hold and timeout wouldn't just happen the first time multipath saw
a single-pathed device. It would happen every time.

I suppose that we could store a list of non-multipathable devices to
avoid waiting when we saw them in the future. But then, what happens if
you time out before seeing the second path, the first time you see a new
device.  It would be declared non-multipathable, and you would have to
run multipath to change that. Users sometimes having to run multipath to
get a multipath device and sometimes not would be really confusing.

> # Recommendation
> =

> The command line options `multipath -i` and `multipathd -n` should be
> deprecated and replaced by a config option shared between multipath and
> multipathd. As the double negation ("unset ignore_wwids") is sort of
> irritating, I propose something like `force_wwids`. This option, if set, =
would
> imply `ignore_new_devs`=3Don and `ignore_wwids`=3Doff; otherwise, the con=
trary.
> The default value of `force_wwids` would be "off". In that case, multipat=
h and
> multipathd should apply exactly the same logic (a), b), d) above).

If we are going to say that multipathd doesn't automatically create new
multipath devices, that is a big change. There are certainly advantages
to it, but I feel like it would require some significant version number
bumping, and a lot of explaining to users that things are going to work
differently now. It also seems like something that would be even more
important to keep consistent between dirtibutions, because it will
impact the end user, and anyone writing documentation on how to use
multipath for them. I know SUSE has been doing this for a while on
find_multipaths devices. Do you default to using find_multipaths in
SUSE, because by default RedHat creates a multipath.conf file with
find_multipaths enabled when people set up multipath?

On the other hand, saying that multipathd will automatically create new
devices, and you won't check the wwids file before claiming them is
definitely broken in the find_multipaths case. That's why you wrote
those patches in the first place.

I'm not sure that this is the right route to take.

-Ben

> Finally, the idea outlined in the previous section, or maybe something be=
tter,
> should be implemented. And, maybe, we can come up with a user-friendly sc=
heme
> to make sure that multipath configuration between initramfs and root FS i=
s in
> agreement.
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
