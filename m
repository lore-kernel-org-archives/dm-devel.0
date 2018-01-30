From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 14/16] multipath.rules:
 find_multipaths+ignore_wwids logic
Date: Tue, 30 Jan 2018 17:40:16 -0600
Message-ID: <20180130234015.GL14513@octiron.msp.redhat.com>
References: <20180119002916.10323-1-mwilck@suse.com>
	<20180119002916.10323-15-mwilck@suse.com>
	<20180119181219.GD5638@octiron.msp.redhat.com>
	<1516411258.4005.49.camel@suse.com>
	<20180121032153.GA14513@octiron.msp.redhat.com>
	<1516658179.30796.146.camel@suse.com>
	<20180125134024.GD14513@octiron.msp.redhat.com>
	<1516987744.2758.90.camel@suse.com>
	<20180129222802.GJ14513@octiron.msp.redhat.com>
	<1517317677.4072.42.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1517317677.4072.42.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 30, 2018 at 02:07:57PM +0100, Martin Wilck wrote:
> On Mon, 2018-01-29 at 16:28 -0600, Benjamin Marzinski wrote:
> > On Fri, Jan 26, 2018 at 06:29:04PM +0100, Martin Wilck wrote:
> > > On Thu, 2018-01-25 at 07:40 -0600, Benjamin Marzinski wrote:
> > > > =

> > > > Possibly another option is to check if something else is using
> > > > the
> > > > device
> > > > and to not claim the device in this case. That will solve the
> > > > initramfs
> > > > case, with is the really bad one.
> > > =

> > > I agree it's bad, but AFAICS "i" only eliminates a part of the
> > > problem.
> > =

> > I agree "i" isn't a perfect solution.  But adding code to never claim
> > a
> > device that is currently in use will help things, regardless of any
> > other changes we do or whatever mode we are in.  If we are in
> > agreement
> > that reassign_maps isn't safe, then there's never a good reason for
> > multipathd to set up on a path that is already in use. If we don't do
> > that, then we should never claim these paths either. =

> =

> If a path is in use, multipathd fails to claim it. I've been pondering
> to simply try "open(device, O_EXCL)" to test for "is in use". =

> If the open() fails, the problem is to determine whether the device is =

> permanently in use (e.g. already mounted or claimed by MD) or only
> temporarily (because some other process is probing it at the same time
> as us). Retrying, at least over more than a minimal time span, is out
> of the question. Maybe multipathd could try to claim a single-path map
> (if should_multipath is true), and just try the open() call in the case
> of failure, to test whether the reason for the failure was that the
> path was in use.

I was hoping that there was a better way to find this out than actually
going through with an exlcusive open, but I don't see one. I'm not a big
fan of exclusively opening every multipathable device on every event,
even if its just for a second. I'm worried that this could make things
like mounting a device fail, because an event happened on the device,
and multipath was holding it open exclusively at the same time that
mount tried to grab it exclusively.

To speak to your worry, I can't find too much that does hold a device
open exclusively for a short period of time. I wrote this systemtap
script to check =


******

probe kernel.function("blkdev_get") {
	if ($mode & 0x80) {
		printf("%s(%d) opened %d:%d EXCLUSIVELY with %x\n", execname(), pid(), MA=
JOR($bdev->bd_dev), MINOR($bdev->bd_dev), $mode)
	}
	else {
		printf("%s(%d) opened %d:%d with %x\n", execname(), pid(), MAJOR($bdev->b=
d_dev), MINOR($bdev->bd_dev), $mode)
	}
}

*****

after discovering, mounting, and trying other commands with some devices,
the only things that I found which do temporary exclusive opens are lvm
commands like (pv|vg|lv)(create|remove). But I'm sure I missed other
cases.

Without the ability to not claim devices that are currently being used,
"FIn" can easily run into problems. Imagine multipath claiming a single
path device, and then timing out and unclaiming it, and having the
device get mounted. Later another path shows up. Multipath will claim
that one too, but multipathd will fail to assemble on it, since the
other path device is in use.  However the next time an uevent occurs for
the mounted path device, multipath will claim it again since it does
have two paths (right?), setting it and its partitions to not ready.
This can cause systemd to auto-unmount them.

Possibly, multipath could only use "FIn" criteria the first time it
claims a device, and after that, switch back to "Fin" criteria. That
would solve this case, although there might still be a problem after
switching from the initramfs. =

 =

> Btw, I've been wondering what the additional "in use" logic based on
> lock_multipath()/flock() is useful for these days. We can either grab a
> path (which comes down to open(..., O_EXCL)), or we can't. It seems odd
> to have an additional, not fully equivalent "in use" logic
> (lock_multipath() success doesn't imply subsequent O_EXCL succcess!). =

> =

> IMO we should determine if we're supposed to grab the path
> (should_multipath(), using the best heuristics we can), and if yes, we
> should immediately do so without doing other checks first. If that
> fails, we might either retry or fall back. Once we have the O_EXCL fd,
> we may  also (try to) flock() the paths to notify other processes using
> flock(), but that would be fully optional.

I don't know what the lock_multipath code is protecting us from. It was
originally to protect multiple multipath commands (or multipath and
multipathd) from both trying to create the same device at the same time.
However, after Hannes changed this to a shared lock like udev uses, I'm
not sure what it protects us from.  However, I didn't object to keeping
it as a shared lock on the grounds that udev is clearly doing this to
protect against something, and by doing this, we are being protected
against the same thing, whatever that is.  But I'm not sure if it is
necessary at all. =


> >  =

> > > > It will still leave the case where
> > > > multipath will never be able to create the device for some other
> > > > reason,
> > > > but that is almost always a configuration issues, where for
> > > > instance
> > > > multipath should be blacklisting a whole class of devices that it
> > > > isn't.
> > > =

> > > Hannes and I have recently discussed an idea how to deal with this
> > > situation. It's quite high on my todo list. The basic idea is to
> > > that
> > > if multipathd fails to set up a device, it leaves a flag somewhere
> > > and
> > > retrigger an uevent. When multipath sees the flag, it doesn't claim
> > > the
> > > device next time.
> > =

> > How is this different from the pathes you just wrote to deal with the
> > find_multipaths case? It claims the path device immediately, sets a
> > timer, and if multipathd doesn't set itself up within that time, it
> > unclaims the path.
> >   The only addition you need is for multipathd to
> > trigger that change event for devices that it fails set up on, so
> > that
> > you don't have to wait for the timeout. You still do need a backup
> =

> That's the idea. But a flag is necessary that multipath -u will see.
> =

> > timeout to deal with the case where mutipathd doesn't start up
> > correctly.
> =

> Hm. IMO we have to assume that multipathd will start up. If it doesn't,
> all the schemes we've discussed so far would fail, even strict fiN. But
> you've just hinted that my "retry timer" idea might actually be a
> solution to this problem :-)

That's my point. Your timer code should work just fine for this.
 =

> > =

> > > =

> > > If you insist, we'll just let "fin" survive as, say,
> > > 'find_multipaths
> > > "conservative"'. Or we call "fIn" "greedy" and "fin" "no".
> > =

> > I'm fine with this. But, assuming you agree with my two above
> > comments,
> > then I'm not sure why you don't like the five options outlined in my
> > last email: =

> > =

> > fin like we have now
> > Fin like we have now
> > fIn with the ability to go back and unclaim the device
> > Fin with the ability to go back and unclaim the device
> > xxN where f/F and i/I are ignored
> =

> I think we should differentiate "what we try to claim" and "what we do
> if we fail". The ability to go back in the error case is highly
> desirable, but orthogonal to the options which describe the "try to"
> side. Luckily, for "go back and unclaim" we need no option - it seems
> obvious that failure recovery shouldn't be disabled (assuming we get
> this right).

Fair enough. We could back out claiming a device, even if it's in the
wwids file, if multipathd fails to assemble on the device.
 =

> > * all with the additional check that we don't claim or assemble on
> > paths
> > that are currently in use.
> > =

> > I really don't care how we expose these options to the user. I was
> > just
> > pointing out that if we used "find_multipaths", "ignore_wwids", and
> > "no_new_devs", where "ignore_wwids" implied the ability to go back
> > and
> > unclaim the device, then every combination of the three is valid. But
> > whether we use one config option with 5 keywords, or three config
> > options that are boolean, or whatever, is fine by me.
> =

> I think one config option is far better, be it only for the sake of
> documenting it. I hate stuff like "option X does Y if set to Z, but
> only if option A is set to B, ...". It's bad for readers and even worse
> for writers.

I'm fine with that.

> >  =

> > > We had a case where the customer ran "dracut --add multipath", but
> > > forgot to run "systemctl enable multipath.service". Because we use
> > > "fIn", multipathd grabbed the device in the initrd, and afterwards
> > > the
> > > root device's subvolumes couldn't be mounted, because systemd would
> > > try
> > > to mount the members, which were locked by the multipath device.
> > =

> > So, I'm still a little fuzzy on what happened here. Are you saying
> > that
> > this case was also an instance of 4C.2 after all? If not that, was
> > the
> > problem that multipath was assembled on the path device, but not
> > having
> > multipathd enabled made "multipath -u" not claim the device after the
> > switch-root, making it appear available for others to use. =

> =

> Exactly. systemd would have been able to mount the other files systems
> through the mpath device, but the path devices show up earlier during
> "coldplug", and once the mount unit is in FAILED state, systemd heads
> towards emergency.
> =

> >  Perhaps in
> > that case, if we fail the check to see if multipathd is
> > running/wanted
> > in "multipath -u", we should still check if the path device is
> > multipathed already, and if it is, we should claim it regardless,
> > because nobody else will be able to.
> =

> Yes, that might have helped in this failure scenario.
> =

> >  =

> > > >  As an
> > > > aside, I am personally very wary about reassign_maps. Multipath
> > > > doesn't
> > > > own the other devices it is reloading. There is nothing to
> > > > guarantee
> > > > that someone else isn't trying to modify the LVM device at the
> > > > same
> > > > time. I don't know of a specific bug with this (we never turn it
> > > > on),
> > > > but it seems very risky to start changing devices we don't own
> > > > with
> > > > no
> > > > coordination.
> > > =

> > > I've no experience with reassign_maps. It's tempting to think that
> > > it
> > > could solve all these nasty issues, but my gut feeling, like yours,
> > > says that it might be dangerous. We don't turn it on, either.
> > > =

> > =

> > If neither of us find this safe, we should deprecate it at the least,
> > and probably disable it and print a warning message instead, if it is
> > set in multipath.conf.
> =

> I'm unsure. I don't have the experience to say it does work or it
> doesn't.
> =

> @ALL: (if anyone except Ben read this far :-), can you contribute
> experience with reassign_maps?
> =

> > > I agree your approach can't hurt, although I still think it will
> > > just
> > > make a very unlikely outcome even more unlikely (the 4C.3 case
> > > described above is obviously very special, and your patch wouldn't
> > > avoid it). I hope that our mutual ideas can go together.
> > > =

> > =

> > If we can cut down the cases where we end up waiting, I'm fine with
> > dropping my idea. I had some discussions this week, and people do
> > recognize that there are problems with the existing device assembling
> > code in udev. I'm now pretty confident that sooner or later, we will
> > have the ability to find about how a device was labelled in the past,
> > even between boots. =

> =

> I'd be interested to learn more about this. Do you have a reference?

There's nothing specific posted about this. It was just a conversation
with people who have had conversations with the udev/systemd developers.

-Ben

> Cheers,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
