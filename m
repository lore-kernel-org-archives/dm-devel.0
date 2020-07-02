From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 0/7] Fix muitpath/multipathd flush issue
Date: Thu, 2 Jul 2020 16:45:21 +0000
Message-ID: <cd568c7aabaa102db8ef6ba8ceb87b96d62f632c.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<f60b8ea30ee0ce68a46ce8f5c9ebaee6314d57e4.camel@suse.com>
	<20200618180458.GI5894@octiron.msp.redhat.com>
	<c5e95e7bc75b11e811854ff0b0988ff19ef45e13.camel@suse.com>
	<20200618230625.GJ5894@octiron.msp.redhat.com>
	<5357998bd17e1147fd3a6615e03251d1aa4900d8.camel@suse.com>
	<20200702031449.GB29962@octiron.msp.redhat.com>
	<8158d509bca2cae483d553defdd1eb378c16d813.camel@suse.com>
	<20200702151829.GA11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200702151829.GA11089@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <1883E6D4452DB44ABBE8A6AC5990AF16@eurprd04.prod.outlook.com>
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

On Thu, 2020-07-02 at 10:18 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 02, 2020 at 12:24:32PM +0000, Martin Wilck wrote:
> > On Wed, 2020-07-01 at 22:14 -0500, Benjamin Marzinski wrote:
> > > On Wed, Jul 01, 2020 at 10:54:34PM +0200, Martin Wilck wrote:
> > > > On Thu, 2020-06-18 at 18:06 -0500, Benjamin Marzinski wrote:
> > > > > I uploaded the test program, aio_test:
> > > > > 
> > > > > https://github.com/bmarzins/test_programs.git
> > > > > 
> > > > > You just need to run in on a queueing multipath device with
> > > > > no
> > > > > active
> > > > > paths and an open count of 0. It will hang with the device
> > > > > open.
> > > > > Restore
> > > > > a path, and it will exit, and the open count will go to 0.
> > > > 
> > > > Tried it now, it behaves as you say. I admit I can't imagine
> > > > how
> > > > the
> > > > suspend/resume would improve anything here. Indeed, as you say,
> > > > it
> > > > opens 
> > > > up a race window. Another process might open the device while
> > > > it's suspended. Worse perhaps, once the device is resumed, an
> > > > uevent will be 
> > > > generated, and stacked devices might (in principle at least) be
> > > > recreated
> > > > before we get down to flush the map.
> > > > 
> > > > MAYBE the suspend/resume was necessary in the past because some
> > > > earlier 
> > > > kernels wouldn't immediately fail all outstanding commands
> > > > when 
> > > > queue_if_no_path was deactivated? (just speculating, I don't
> > > > know
> > > > if this
> > > > is the case).
> > > 
> > > If you disable queue_if_no_path and then do a suspend with
> > > flushing,
> > > you
> > > are guaranteed that the supend won't return until all the IO has
> > > completed or failed.
> > 
> > I just realized that if we suspend, we don't even need disable
> > queue_if_no_path, because the kernel does that automatically if a
> > "suspend with flush" is issued, and has been doing so basically
> > forever.
> > 
> > >   This would allow anything that was waiting on
> > > queued IO to have the IO failback, which could allow it to close
> > > the
> > > device in time for multipath to be able to remove it (obviously
> > > this
> > > is
> > > racey).  However, this assumes that you do your open checks after
> > > the
> > > suspend, which multipath no longer does.
> > >  I realize that multipath can't
> > > suspend until after it tries to remove the partition devices,
> > > otherwise
> > > those can get stuck. But there probably is some order that gets
> > > this
> > > all
> > > right-ish.
> > 
> > Our code is currently racy. IMO we should
> > 
> >  0 unset queue_if_no_path
> >  1 remove partition mappings
> >  2 open(O_EXCL|O_RDONLY) the device
> >  3 If this fails, in multipath, try again after a suspend/resume
> > cycle.
> >    In multipathd, I think we should just fail for now; perhaps
> > later
> >    we could handle the explicit "remove map" command like
> > multipath.
> >  4 If it fails again, bail out (in multipath, retry if asked to do
> > so)
> >  5 run a "deferred remove" ioctl
> >  6 close the fd, the dm device will now be removed "atomically".
> > 
> > This cuts down the race window to the minimum possible - after (2),
> > no
> > mounts / kpartx / lvm operations won't be possible any more.
> 
> I wasn't actually worried about someone wanting to use the device. In
> that case the remove should fail.  I was worried about things that
> would
> close the device, but couldn't because of queued IO.  
> The race I was
> talking about is that after whatever has the device open gets the IO
> error, it might not close the device before multipath checks the open
> count.

Understood.

> Also, I'm not sure that resume helps us, since that will trigger
> uevents, which will open the device again.

Not sure if I understand correctly: It's possible to just suspend/flush
and then remove the device, without resuming. But that's dangerous,
because if some process opens the device while it's resumed, even if
it's just for reading a single block (think blkid), the open will
succeed, the IO will hang, the opencount will be increased, and the
REMOVE ioctl will fail. Therefore I think *if* we suspend we should
also resume. But I concur wrt the uevent, of course.

> > When we remove the partition mappings, we could use the same
> > technique
> > to avoid races on that layer. Unfortunately, a pending "deferred
> > remove" operation doesn't cause new open() or mount() calls to
> > fail; if
> > it did, we could use a simpler approach.
> > 
> > > So, for a while now, the suspending has been doing nothing for
> > > us.  We
> > > could either try to reorder things so that we actually try to
> > > flush
> > > the
> > > queued IOs back first (with or without suspending), or we could
> > > just
> > > remove suspending and say that things are working fine the way
> > > they
> > > currently are.
> > 
> > What else can we do except suspend/resume to avoid racing with
> > pending
> > close(), umount() or similar operations? Well, I guess if we open
> > the
> > device anyway as I proposed, we could do an fsync() on it. That
> > might
> > actually be better because it avoids the uevent being sent on
> > resume.
> 
> yeah. I think that simply disabling queueing and doing an fsync() is
> probably better than suspending. If new IO comes in after that, then
> something IS using the device, and we don't want to remove it. In
> multipath, maybe:
> 
> 1. disable queueing
> 2. remove partition mappings
> 3. open device
> 4. flush
> 5. check if we are the only opener.
> 	If not, and there are retries left... goto 4? sleep and
> recheck?
> 	we don't want to wait if the answer is that they device really
> 	is in use.
> 6. close device
> 7. remove device
> 
> Possibly the solution to not wanting to wait when a device is in use
> is
> that we could add an option to multipath to distinguish between the
> way
> flushing works now, where we check early if the device is in use, and
> just bail if it is, and a more aggressive attempt at remove that
> might
> take longer if used on devices that are in use.

What's wrong with deferred remove? After all, the user explicitly asked
for a flush. As long as some other process has the device open, it
won't be removed. That's why I like the O_EXCL idea, which will allow
small programs like blkid to access the device, but will cause all
attempts to mount or add stacked devices to fail until the device is
actually removed. I see no reason no to do this, as it's a race anyway
if some other process opens the device when we're supposed to flush it
and the opencount already dropped to 0. By using O_EXCL, we just
increase multipathd's chances to win the race and do what the user
asked for.

To make sure we're on the same boat: this is a topic for a separate
patch set IMO, I'm not expecting you to fix it in a v3.

Cheers,
Martin
