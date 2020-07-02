From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 0/7] Fix muitpath/multipathd flush issue
Date: Thu, 2 Jul 2020 12:24:32 +0000
Message-ID: <8158d509bca2cae483d553defdd1eb378c16d813.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<f60b8ea30ee0ce68a46ce8f5c9ebaee6314d57e4.camel@suse.com>
	<20200618180458.GI5894@octiron.msp.redhat.com>
	<c5e95e7bc75b11e811854ff0b0988ff19ef45e13.camel@suse.com>
	<20200618230625.GJ5894@octiron.msp.redhat.com>
	<5357998bd17e1147fd3a6615e03251d1aa4900d8.camel@suse.com>
	<20200702031449.GB29962@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200702031449.GB29962@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <3BE20DCC9E0B6044B88AAA9FA846710F@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-07-01 at 22:14 -0500, Benjamin Marzinski wrote:
> On Wed, Jul 01, 2020 at 10:54:34PM +0200, Martin Wilck wrote:
> > On Thu, 2020-06-18 at 18:06 -0500, Benjamin Marzinski wrote:
> > > I uploaded the test program, aio_test:
> > >=20
> > > https://github.com/bmarzins/test_programs.git
> > >=20
> > > You just need to run in on a queueing multipath device with no
> > > active
> > > paths and an open count of 0. It will hang with the device open.
> > > Restore
> > > a path, and it will exit, and the open count will go to 0.
> >=20
> > Tried it now, it behaves as you say. I admit I can't imagine how
> > the
> > suspend/resume would improve anything here. Indeed, as you say, it
> > opens=20
> > up a race window. Another process might open the device while
> > it's suspended. Worse perhaps, once the device is resumed, an
> > uevent will be=20
> > generated, and stacked devices might (in principle at least) be
> > recreated
> > before we get down to flush the map.
> >=20
> > MAYBE the suspend/resume was necessary in the past because some
> > earlier=20
> > kernels wouldn't immediately fail all outstanding commands when=20
> > queue_if_no_path was deactivated? (just speculating, I don't know
> > if this
> > is the case).
>=20
> If you disable queue_if_no_path and then do a suspend with flushing,
> you
> are guaranteed that the supend won't return until all the IO has
> completed or failed.

I just realized that if we suspend, we don't even need disable
queue_if_no_path, because the kernel does that automatically if a
"suspend with flush" is issued, and has been doing so basically
forever.

>   This would allow anything that was waiting on
> queued IO to have the IO failback, which could allow it to close the
> device in time for multipath to be able to remove it (obviously this
> is
> racey).  However, this assumes that you do your open checks after the
> suspend, which multipath no longer does.
>  I realize that multipath can't
> suspend until after it tries to remove the partition devices,
> otherwise
> those can get stuck. But there probably is some order that gets this
> all
> right-ish.

Our code is currently racy. IMO we should

 0 unset queue_if_no_path
 1 remove partition mappings
 2 open(O_EXCL|O_RDONLY) the device
 3 If this fails, in multipath, try again after a suspend/resume cycle.
   In multipathd, I think we should just fail for now; perhaps later
   we could handle the explicit "remove map" command like multipath.
 4 If it fails again, bail out (in multipath, retry if asked to do so)
 5 run a "deferred remove" ioctl
 6 close the fd, the dm device will now be removed "atomically".

This cuts down the race window to the minimum possible - after (2), no
mounts / kpartx / lvm operations won't be possible any more.

When we remove the partition mappings, we could use the same technique
to avoid races on that layer. Unfortunately, a pending "deferred
remove" operation doesn't cause new open() or mount() calls to fail; if
it did, we could use a simpler approach.

> So, for a while now, the suspending has been doing nothing for
> us.  We
> could either try to reorder things so that we actually try to flush
> the
> queued IOs back first (with or without suspending), or we could just
> remove suspending and say that things are working fine the way they
> currently are.

What else can we do except suspend/resume to avoid racing with pending
close(), umount() or similar operations? Well, I guess if we open the
device anyway as I proposed, we could do an fsync() on it. That might
actually be better because it avoids the uevent being sent on resume.

We definitely can't suspend the map before we remove the partitions. We
could try a suspend/resume on the partition devices themselves (or
fsync()) if the opencount is > 0.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
