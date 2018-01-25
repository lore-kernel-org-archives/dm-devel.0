From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 14/16] multipath.rules:
 find_multipaths+ignore_wwids logic
Date: Thu, 25 Jan 2018 07:40:24 -0600
Message-ID: <20180125134024.GD14513@octiron.msp.redhat.com>
References: <20180119002916.10323-1-mwilck@suse.com>
	<20180119002916.10323-15-mwilck@suse.com>
	<20180119181219.GD5638@octiron.msp.redhat.com>
	<1516411258.4005.49.camel@suse.com>
	<20180121032153.GA14513@octiron.msp.redhat.com>
	<1516658179.30796.146.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516658179.30796.146.camel@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Mon, Jan 22, 2018 at 10:56:19PM +0100, Martin Wilck wrote:
> Hi Ben,
> =

> I agree with most of your analysis, I've added some replies below. =

> =

> But I'd like to discuss something else first.
> =

> I'd like to *simplify the configuration*, and exclude configurations
> that make no sense. Before my commits 64e27e and ffbb88 last year,
> there were 3 settings related to path detection: find_multipaths, -i
> for multipath (ignore_wwids), and -n for multipathd (ignore_new_devs).
> This adds up to 8 combinations, which I denote "fin", "FiN", etc. in
> the following, using upper case for "on" and lower case for "off".
> =

> The SUSE default setup is "fIn", and the Red Hat / Ubuntu one is "Fin".
> In initramfs, Red hat is effectively using "FiN" ("multipathd -n" isn't
> used, but strict blacklisting is used to the same effect).
> =

> My patch es 64e27e and ffbb88 forced F=3D>N and F=3D>i, thus "FiN" became
> the only combination with find_multipaths, leaving 5 valid
> combinations. My recent RFC series allows only "xiN" and "xIn"
> combinations for consistency reasons. But I can see this doesn't fit
> the way Red Hat and others are setting up multipath, thus we need
> something different.
> =

> I wonder if we can agree that the combinations "fIN", "FIN", and "fin"
> are useless. "IN" combinations are really dangerous and can lead to the
> fatal outcomes 4A.2, 4B.2, 4C.2 from your analysis; they shouldn't be
> allowed. "fin" is similar to "Fin" at first sight, but without the
> protection of "find_multipaths", it becomes much more likely that a
> device that multipath hasn't claimed is claimed by multipathd later, I
> think we should disallow it as well, although it's the current upstream
> default. Moreover, "fiN" and "FiN" are equivalent: if new devices are
> completely ignored, "find_multipaths yes" has no effect.

I'd be o.k with removing "fin" from upstream in favor of "fIn". My
analysis ingnores class 3 devices, on the assumption that "fIn" is
correct. If we do this, I will change "fIn" to "fin" in redhat's local
patches. Here's why. Outcome 2 is really bad. Imagine a
non-find-mutipaths equivalent of 4C Outcome 2 (3C Outcome 2?). The "I"
makes sure that multipath claims the device when it first appears, but
for some reason multipathd simply can't create a device on it.  This can
happen if multipath is not running in your initramfs, and something else
sets itself up on a path device.  When you switch-root, multipath will
claim the device, and mess everything up. But basically, this can happen
any time that multipathd fails to be able to set up on a device it has
claimed.  One way you can deal with most of these possibilites is to
require that multipathd has to set itself up on path at least once
before we claim it. That's exactly what "i" gives us.

Possibly another option is to check if something else is using the device
and to not claim the device in this case. That will solve the initramfs
case, with is the really bad one. It will still leave the case where
multipath will never be able to create the device for some other reason,
but that is almost always a configuration issues, where for instance
multipath should be blacklisting a whole class of devices that it isn't.

> If we agree on that, I'd like to propose a new configuration scheme. As
> in my RFC series, I'd like to replace the command line options with
> config file options (**). For backward compatibility reasons, I propose
> to use the "find_multipaths" option, but with 4 rather than 2 possible
> values:
> =

>  - find_multipaths "no": fIn, current SUSE default
>  - find_multipaths "yes": Fin, current Red Hat / Ubuntu default
>  - find_multipaths "strict": fiN/FiN, use only known WWIDs =

>  - find_multipaths "auto": FIn, try to be smart; this is what we've
> been discussing.

I would still like to put forward the code for my idea, but if we don't
find agreement on anything else, I would definitely accept this as
the upstream version (with the caveat that I really don't like ending up
in Outcome 2, and will make "no" be "fin" on RedHat if I can't convince
you to do that upstream).

Actually, AFAICS, FIn with being smart is not safe if you don't have
multipath in the initrd, and something grabs a device there. After the
switch-root, multipath will claim the device (even if just for a limited
time). If you are directly using this device (instead of through
LVM/MD), and it gets set to not ready in systemd, which can
automatically unmount the device.  If we can check if a path device is
in use before claiming it, that should solve this.

> Having limited the path detection options to reasonable combinations,
> we can add more logic to improve the "auto" case, one way or the other.
> =

> [(**) "multipath -u -i" might still be allowed for purposes like you
> pointed out for anaconda, or interactive querying. It would override
> "ignore_wwids" for the "yes" and "strict" cases.]
> =

> Now my reply to your mail.
> =

> On Sat, 2018-01-20 at 21:21 -0600, Benjamin Marzinski wrote:
> > I apologize in advance for how long this is.
> =

> It has to be, it's complex :-) Anyway I'll skip everything except 4C),
> because we agree on the rest anyway.
> =

> > 4C: If in reality, the device should be multipathed but there is
> > something else that also wants to use the device, there are four
> > possible outcomes:
> > =

> >         1. The device is not claimed by multipath, and is not
> >            multipathed
> >         2. The device is claimed by multipath, but not multipathed
> >         3. The device is not claimed by multipath, but is multipathed
> >         4. The device is claimed by multipath and is multipathed
> > =

> > Outcome 1 is suboptimal, since the device really should be
> > multipathed,
> > but the system will still be usable (albeit, with only a single path
> > to
> > the storage).  However, this is fixable for future boots, by adding
> > the
> > wwid to the wwids file.
> =

> A common case is that users install without multipath, and convert the
> system to using multipath later. That means dracut is run in a non-
> multipathed system, where the wwids file doesn't contain the entries
> for the root FS yet. That's a case which may lead to a fatal variant of
> 4C.3 later on. =


How? This outcome only happens in a "Fin" or "FiN" setup. You never
claim the device, because you never multipath the device. In this
sitution, multipath never changes the path device at all. If dracut is
run without multipath running, it will create an initramfs where
multipathd won't grab the devices (which I agree is what Outcome 1 is
all about).  This will mean that the other users grab the devices, which
means that Outcome 3 is pretty impossible, because the device is already
in use by something else.  The only thing that can grab a path device
device and have multipath grab it later is LVM on a whole device. This
is the specific case that reassign_maps is designed to handle. Even
without it, if multipathd created a device on top of (and later claimed)
the same paths that a LVM device is using, it would set the path devices
to not ready, not the LVM device.

> Along similar lines, it's essential for the Red Hat "multipath-
> hostonly" approach that indeed no service in the initrd grabs devices
> which might be multipathed later. If that happens, a fatal form of 4C.3
> can occur. We see this often with BTRFS + subvolumes.

Again, I don't understand how the case here works.  If something in the
initrd grabs the device, that will keep multipathd from assembling on
it. If LVM is already assembled, it shouldn't be hard to make multipath
notice this and not assemble even if LVM is on the whole device. As an
aside, I am personally very wary about reassign_maps. Multipath doesn't
own the other devices it is reloading. There is nothing to guarantee
that someone else isn't trying to modify the LVM device at the same
time. I don't know of a specific bug with this (we never turn it on),
but it seems very risky to start changing devices we don't own with no
coordination.

If I had to make a guess, I can definitely see how you could get into a
problem with the SUSE policy of "fIn".  In this case, multipathd doesn't
claim or grab the device in the initrd, so something else does. Then
after the switch-root, multipath will claim the device and multipathd
won't be able to assemble on it.  This is the dreaded Outcome 2, and
this is the reason I never use "I", even when find_multipaths is not
set.

On the other hand, it's quite possible that I'm just missing something,
and you can get to state 4C.3 (where mutipathd wins the race to assemble
on the device, even though it hasn't claimed it). Could you try to
explain how this happens a little more.

> But initrd issues are out of scope for the current discussion, I guess.
> =

> > Outcome 2 is just as bad as Outcome 2 in class 4A. Of course, if the
> > device is supposed to be multipathed, and is claimed by multipath, it
> > is
> > very likely that multipathd will assemble on it, so this is an
> > extremely
> > rare case.
> =

> Certainly. This is why "xIN" should be avoided (see above).

So, I could see Outcome 2 happening because of initrd issues. But I look
at this as a problem with using "I" in the udev rules.

> =

> > Outcome 3 is the cause of the never actually observed bug I explained
> > in
> > an earlier eamil.
> =

> We did observe this, but the fatal cases where usually related to
> initrd/root FS configuration inconsistencies (see above). But then,
> SUSE is normally working with "fIn", where things are a little
> different.

I still don't see how you get here instead of Outcome 2.

> > [...]
> >
> > RedHat's current solution guarantees that you always get Outcome 1
> > for
> > 4A devices, Outcome 3 for 4B devices, and either Outcome 1 or Outcome
> > 3
> > for 4C devices (however in practice, 4C Outcome 3 has never been
> > reported).
> > =

> > SUSE's "imply -n on find_multipaths" solution guarantees that you
> > always
> > get Outcome 1 for 4A devices, Outcome 1 for 4B devices, and Outcome 1
> > for 4C devices.
> > =

> > Hopefully we agree on the above analysis. If you think I'm wrong in
> > part
> > of it, please let me know, because this is what I'm reasoning from.
> > Now
> > on to your and my proposed solutions.
> =

> All of this made sense to me. I made a similar write-up for myself.
> =

> > Your proposed solution guarantees that you always get Outcome 1 for
> > 4A
> > devices.
> > =

> > After that it gets a little trickier. Your solution involves a
> > timeout,
> > and that timeout can delay booting if there are 4A devices. Even if
> > we
> > do the equivalent of "multipath -n" in the initramfs, there are often
> > still filesystems that need to mount after we switch-root. Those will
> > get delayed, and the machine may not be usable until they are
> > mounted. I
> > really do feel that this will not be a rare case at all. You pointed
> > out
> > that this can be dealt with by decreasing the timeout, even all the
> > way
> > to 0.  I think that since this timeout is protecting against a
> > problem
> > in the rare case, by making the common case slower, users will be
> > very
> > inclined to decrease it.  Thus, it's worth looking at what happens in
> > the case where the timeout is long enough for multipathd to assemble
> > the device, and the case where it is not long enough.
> =

> Yes, the problem is that for large multipath installations and/or SANs
> with slow device detection, the timeout has to be large to avoid "false
> negatives"; but a large timeout would delay booting in inacceptible
> ways for systems with single-path devices.
> =

> My idea how to solve this is to make the timeout configurable through
> multipath.conf and hwtable, with extra logic to use a *very* small
> timeout (1s or no waiting at all) if a device is not listed in the in
> either hwtable or config file; thus the typical SAS or SATA devices of
> non-multipath OS installations wouldn't be waited for. That should
> address your main critique.

I agree that this will make the boot problem much less likely. It would
still exist for SAN storage that isn't multipathed, but this is rarer
(although not incredibly rare).

> > My solution idea is basically a mirror of yours.
> > =

> > At a high level, your solution is:
> > When you see a "maybe" device, assume it's a "yes" and claim it so
> > that
> > nothing else can use the device. Then, set a timeout for multipathd
> > to
> > make use of the device. If that timeout passes, and multipathd hasn't
> > used the device, go back and unclaim the device so that it's in the
> > correct state. Then, if something else should use the device, it can.
> > =

> > At a high level, my solution is:
> > When you see a "maybe" device, assume it's a "no" and don't claim it.
> > Also, disallow multipathd from using the device. Then, set a timeout
> > for
> > other things to make use of the device.  When that timeout passes,
> > mutipathd is no longer disallowed from using that device, so that if
> > mutipathd should use the device, it can. If multipathd uses the
> > device,
> > go back and claim the device, so it's in the correct state.
> =

> How would you disallow multipathd to use the device? By setting an udev
> property?

No. I would do it by having should_multipath() return "maybe" and having
multipathd flag those paths and then ignore them, and set the path's
checker ticks for whatever timeout you choose. When that time expires,
the cherckerloop will assemble the map. It already does things like this
is different cases.  All the code changes are in multipath.

> And why would you do it? Don't you agree that, as soon as a
> second path is encountered, multipathd should be allowed to grab both?
> Maybe I misunderstood, and multipathd will only be forbidden to use the
> path as long as there's only one? But no, with "find_multipaths on",
> multipathd wouldn't grab a single path anyway... I'm a bit confused.

Well, in RedHat, multipathd currently grabs the device as soon as two
paths appear, and I am fine with keeping things that way.  But this idea
IS to keep multipathd from assembling on a device, even after the second
path appears (assuming it appears before the timeout). I'm doing this
for one purpose only, to make sure that I am always in case 4C.1 instead
of 4C.3.  I have never seen case 4C.3 happen, since in practice
multipathd always loses this race, which gives you case 4C.1.  Also, I
look at 4C.1 as only being different from the ideal case in that it
misses a nice-to-have feature. Since I have never seen 4C.3 happen, any
timeout, even 1 second, will only make it even more remote a chance.
And the only downside is that it takes a second longer to get to case
4B.3, which will only happen the first time you see new multipathed
storage.

> =

> Along similar lines as you argued about my approach, by delaying
> multipathd's actions, you'd increase the probability of the suboptimal
> outcome 1).

This is not only true. It is the whole point. 4C.3 is bad, 4C.1 is only
not ideal. Wasting a couple of seconds on creating a multipath device
the very rare case that you are seeing it for the first time, in a way
that doesn't slow anything else down, is a reasonable trade-off to make
sure you get the better outcome (4C.1).

> And you're opening up the time window in which both
> multipathd and other layers can grab the device, which may be not so
> bad in practice as you say, but still bothers me for principal reasons.

multipathd and others can't both grab the device (except in the case of
whole device LVs, and I'm fine with removing that ability as well). The
race that is really important to remove is multipath claiming the
device, and someone else using it. I do get that I am forcing a
non-optimal case, where you are trying to make sure that we are always
in the optimal one.  It's just that we only see these 4B and 4C devices
in rare cases where we are adding new multipath storage to the system,
and I don't want to slow the common case to make this better. I also
don't want to push any more complexity into the udev rules.

> Finally, as you said yourself, multipathd is likely to "loose the race"
> anyway. With your patch you just make its chance even smaller. In a
> way, d7188fc "multipathd: start daemon after udev trigger" already
> implements your idea, because by the time multipathd starts, essential
> device detection will be finished (with the exception of extremely slow
> device detection where the udev queue runs empty).

I don't worry about 4C.3 happening in our current RedHat setup. There
isn't a hard barrier that is keeping this from happening, but the timing
makes it very unlikely.  If we assume that it won't happen, then
RedHat's current implementation guarantees 4A.1, 4B.3, and 4C.1.  I'm
fine with those guarantees.  Problems like you mention above, which can
cause 4C.2 if you use "I", even in the non-find-multipaths case, make me
leary about using "I" in any setup. But I'm willing to switch the
non-find-multipaths case to "i" in a RedHat patch, if I am alone in this
concern.

> > The advantage of your method is that, as long as the timeout is long
> > enough, you always do the correct thing with multipath devices. The
> > disadvantage is that the timeout slows down the common case, to make
> > the
> > rare case correct.
> =

> Would the idea with variable timeouts improve my approach in your eyes?

Yes. It still will cause slowdowns on single-pathed SAN storage, but it
should fix the most common case.

> > The advantage of my method is that it only slows down the rare case.
> > The
> > disadvantage is that it will not get the "Nice-to-have" outcome in
> > the
> > rare case.
> > =

> > I'm working on coding up my solution, which includes a number of the
> > patches from your solution, but I'm leaving tomorrow for a week of
> > meetings and conferences, so it might be a little bit it coming.
> =

> Looking forward to it.

If nobody is worried about multipathd winning the race against other
device users, then 4C.3 is basically an impossible state, and there is
no point in adding an additional timeout to make an impossible state
less likely. In this case, there is no point in my solution. As far as
limiting the number of possible configurations. If we could agree that
"I" isn't safe when checking if multipath should claim a device in udev,
then there would be only 3 cases: fin, Fin, and FiN/fiN.  Like I said,
there two classes of problem where "I" causes problems: if the device is
already in use, and if multipathd simply can't set itself up on the
device.  If we check the path device is not being used before claiming
it, then FIn with being smart is also a safe case since it will solve
both of these. fIn with being smart is also safe. I simply don't believe
that fIn is safe without doing these extra steps to protect against
claiming devices that we shouldn't.

This would still allow 5 states, that would probably need 3 config
parameters

- (f)ind_multipaths
- (i)gnore_wwids (or "smart" or something else. I orginally called this
  mode "greedy")
- (n)o_new_devs

In this case, N would ignore f/F and i/I. Because we are protecting
against problems with "I", any of the other four states are valid.

> Btw, it just occured to me that your approach could be implemented in
> exactly the way as mine. Basically, all we need to change is what udev
> properties get set on the "maybe" uevents. Take my code, but don't set
> SYSTEMD_READY=3D0 and DM_MULTIPATH_DEVICE_PATH=3D1 in the "maybe" case...
> Should work, no? =


No. This would let nobody use the device. lvm won't scan devices in
SYSTEMD_READY=3D0 state, and they can't be mounted.  These are exactly
the things I am trying to allow.

-Ben

> Cheers,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
