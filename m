From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 14/16] multipath.rules:
 find_multipaths+ignore_wwids logic
Date: Mon, 29 Jan 2018 16:28:02 -0600
Message-ID: <20180129222802.GJ14513@octiron.msp.redhat.com>
References: <20180119002916.10323-1-mwilck@suse.com>
	<20180119002916.10323-15-mwilck@suse.com>
	<20180119181219.GD5638@octiron.msp.redhat.com>
	<1516411258.4005.49.camel@suse.com>
	<20180121032153.GA14513@octiron.msp.redhat.com>
	<1516658179.30796.146.camel@suse.com>
	<20180125134024.GD14513@octiron.msp.redhat.com>
	<1516987744.2758.90.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516987744.2758.90.camel@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 26, 2018 at 06:29:04PM +0100, Martin Wilck wrote:
> On Thu, 2018-01-25 at 07:40 -0600, Benjamin Marzinski wrote:
> > On Mon, Jan 22, 2018 at 10:56:19PM +0100, Martin Wilck wrote:
> > I'd be o.k with removing "fin" from upstream in favor of "fIn". My
> > analysis ingnores class 3 devices, on the assumption that "fIn" is
> > correct. If we do this, I will change "fIn" to "fin" in redhat's
> > local
> > patches. Here's why. Outcome 2 is really bad. Imagine a
> > non-find-mutipaths equivalent of 4C Outcome 2 (3C Outcome 2?). The
> > "I"
> > makes sure that multipath claims the device when it first appears,
> > but
> > for some reason multipathd simply can't create a device on it.  This
> > can
> > happen if multipath is not running in your initramfs, and something
> > else
> > sets itself up on a path device.  When you switch-root, multipath
> > will
> > claim the device, and mess everything up. But basically, this can
> > happen
> > any time that multipathd fails to be able to set up on a device it
> > has
> > claimed.  One way you can deal with most of these possibilites is to
> > require that multipathd has to set itself up on path at least once
> > before we claim it. That's exactly what "i" gives us.
> 
> I agree that this makes perfect sense in the "Fin" case, but for "fin",
> if find_multipaths is off, it seems odd. "fXn" means that multipathd
> claims everything it comes by, which pairs better with "I" than "i".
> 
> > Possibly another option is to check if something else is using the
> > device
> > and to not claim the device in this case. That will solve the
> > initramfs
> > case, with is the really bad one.
> 
> I agree it's bad, but AFAICS "i" only eliminates a part of the problem.

I agree "i" isn't a perfect solution.  But adding code to never claim a
device that is currently in use will help things, regardless of any
other changes we do or whatever mode we are in.  If we are in agreement
that reassign_maps isn't safe, then there's never a good reason for
multipathd to set up on a path that is already in use. If we don't do
that, then we should never claim these paths either. 
 
> > It will still leave the case where
> > multipath will never be able to create the device for some other
> > reason,
> > but that is almost always a configuration issues, where for instance
> > multipath should be blacklisting a whole class of devices that it
> > isn't.
> 
> Hannes and I have recently discussed an idea how to deal with this
> situation. It's quite high on my todo list. The basic idea is to that
> if multipathd fails to set up a device, it leaves a flag somewhere and
> retrigger an uevent. When multipath sees the flag, it doesn't claim the
> device next time.

How is this different from the pathes you just wrote to deal with the
find_multipaths case? It claims the path device immediately, sets a
timer, and if multipathd doesn't set itself up within that time, it
unclaims the path.  The only addition you need is for multipathd to
trigger that change event for devices that it fails set up on, so that
you don't have to wait for the timeout. You still do need a backup
timeout to deal with the case where mutipathd doesn't start up
correctly.

> 
> If you insist, we'll just let "fin" survive as, say, 'find_multipaths
> "conservative"'. Or we call "fIn" "greedy" and "fin" "no".

I'm fine with this. But, assuming you agree with my two above comments,
then I'm not sure why you don't like the five options outlined in my
last email: 

fin like we have now
Fin like we have now
fIn with the ability to go back and unclaim the device
Fin with the ability to go back and unclaim the device
xxN where f/F and i/I are ignored

* all with the additional check that we don't claim or assemble on paths
that are currently in use.

I really don't care how we expose these options to the user. I was just
pointing out that if we used "find_multipaths", "ignore_wwids", and
"no_new_devs", where "ignore_wwids" implied the ability to go back and
unclaim the device, then every combination of the three is valid. But
whether we use one config option with 5 keywords, or three config
options that are boolean, or whatever, is fine by me.
 
> We had a case where the customer ran "dracut --add multipath", but
> forgot to run "systemctl enable multipath.service". Because we use
> "fIn", multipathd grabbed the device in the initrd, and afterwards the
> root device's subvolumes couldn't be mounted, because systemd would try
> to mount the members, which were locked by the multipath device.

So, I'm still a little fuzzy on what happened here. Are you saying that
this case was also an instance of 4C.2 after all? If not that, was the
problem that multipath was assembled on the path device, but not having
multipathd enabled made "multipath -u" not claim the device after the
switch-root, making it appear available for others to use.  Perhaps in
that case, if we fail the check to see if multipathd is running/wanted
in "multipath -u", we should still check if the path device is
multipathed already, and if it is, we should claim it regardless,
because nobody else will be able to.
 
> >  As an
> > aside, I am personally very wary about reassign_maps. Multipath
> > doesn't
> > own the other devices it is reloading. There is nothing to guarantee
> > that someone else isn't trying to modify the LVM device at the same
> > time. I don't know of a specific bug with this (we never turn it on),
> > but it seems very risky to start changing devices we don't own with
> > no
> > coordination.
> 
> I've no experience with reassign_maps. It's tempting to think that it
> could solve all these nasty issues, but my gut feeling, like yours,
> says that it might be dangerous. We don't turn it on, either.
> 

If neither of us find this safe, we should deprecate it at the least,
and probably disable it and print a warning message instead, if it is
set in multipath.conf.

> > > 
> > > Finally, as you said yourself, multipathd is likely to "loose the
> > > race"
> > > anyway. With your patch you just make its chance even smaller. In a
> > > way, d7188fc "multipathd: start daemon after udev trigger" already
> > > implements your idea, because by the time multipathd starts,
> > > essential
> > > device detection will be finished (with the exception of extremely
> > > slow
> > > device detection where the udev queue runs empty).
> > 
> > I don't worry about 4C.3 happening in our current RedHat setup. There
> > isn't a hard barrier that is keeping this from happening, but the
> > timing
> > makes it very unlikely.  If we assume that it won't happen, then
> > RedHat's current implementation guarantees 4A.1, 4B.3, and 4C.1.  I'm
> > fine with those guarantees.
> 
> I agree your approach can't hurt, although I still think it will just
> make a very unlikely outcome even more unlikely (the 4C.3 case
> described above is obviously very special, and your patch wouldn't
> avoid it). I hope that our mutual ideas can go together.
> 

If we can cut down the cases where we end up waiting, I'm fine with
dropping my idea. I had some discussions this week, and people do
recognize that there are problems with the existing device assembling
code in udev. I'm now pretty confident that sooner or later, we will
have the ability to find about how a device was labelled in the past,
even between boots.  With that ability, we can easily set a timeout on
devices that haven't been used by anything in the past, and on devices
that have been used by something other than multipath we can skip the
timeout, since we expect that the device will still be
non-multipathable. This would mean that we only ever have timeouts in
the rare case when new storage is added. Until we have these abilities,
I would be fine with continuing the way that RedHat currently does
things.

> 
> You don't have to use it, but please let's keep the "fIn" option
> around. Our customers are used to this behavior. I don't deny that it
> has caused some problems (usually related to mishandling one way or the
> other), but we're not ready to give it up. We'll be working on
> improving it. Dropping it upstream would hurt us.
> 

I'm fine with you keeping it exactly as it is, if you want, but if you
are planning on improving it using the same sorts of ideas as you are
doing for the "FIn" case, then why not just use the same code?


> That's why I said *don't* set SYSTEMD_READY=0 :-)

Oops. I mis-read that.

-Ben
