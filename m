From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Thu, 15 Jun 2006 16:29:12 -0400
Message-ID: <87f94c370606151329y4132e53dgf964a093683435e3@mail.gmail.com>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
	<20060614215258.6aa76d0f@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060614215258.6aa76d0f@localhost>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Tom,

I did not review your e-mail in total, but using lots of SATA drives
in a big RAID array is not something I would attempt with 2.6.17 or
older kernels.  (I know 2.6.17 is not even out yet.).

In 2.6.17-mm there is a huge SATA error handler (EH) rewrite.  Is is
planned to hit the stable Linus kernel with 2.6.18 towards the end of
the summer, but even then it will only have a few of the actual
drivers modified to use the EH infrastructure.

I would repost your problem to the lkml-ide list and see if they think
that the new EH should help you, and when/if your controller will be
using the new EH infrastructure.

FYI: that is linux-ide@vger.kernel.org: sata is discussed there, no
need to subscribe, they will cc you on responses.

Also, there is a ton of testing going on with the new EH, so if your
willing to be a guinea pig, I'm sure you will get a lot of support
from the dev. team and get your specific driver updated ASAP.

HTH
Greg
-- 
Greg Freemyer

On 6/14/06, Tom Wirschell <Tom@wirschell.nl> wrote:
> On 14 Jun 2006, Rune Saetre wrote:
> >
> > I always thought the loud click came from the disks parking their
> > heads before spinning down.
>
> Well, it's most certainly loud. The same type of loud that you get when
> the machine shuts down and removes the power from the drives. I thought
> recalibration ticks weren't particularly loud.
>
> > Anyway, it can take several seconds before a disk responds to
> > commands after having spun down.
>
> The problem isn't that it takes time to come back up after a spin down.
> The drive isn't spinning down. It's turning itself off completely
> (note the 'no device found' bit in the error). And it does this while
> it's actively being used.
>
> > On Wed, 14 Jun 2006, Molle Bestefich wrote:
> > >
> > > Does the drive's SMART log say anything interesting?
>
> That's a damned good question. I didn't even know you could query that,
> so I just recreated the array and started my test again. Took about 90
> minutes for one of the drives to die. Unfortunately when it dies it
> refuses to respond to anything.
>
> When I try the smartctl program on the failed drive I get:
> Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)
> When I issue the exact same command for another disk on the controller
> I get a nice listing that you would expect from this program.
>
> When I use hdparm -I on the died drive I get:
> HDIO_DRIVE_CMD(identify) failed: Input/output error
> And again, if I issue the exact same command for another disk on this
> same controller I get a nice bit of info on the drive.
>
> To me at least, this basically says that the drive is actually turned
> off at this point in time. It would explain why SMART isn't getting any
> data. On the other hand, it doesn't explain *WHY* the drive is off.
> Do you know any program that's capable of telling a drive that isn't on
> to activate itself? I don't think it's even possible but might be
> mistaken there.
>
> So, I reboot, run smartctl again and I'm presented with a nice sheet
> of output that basically says all is well, nothing ever went wrong with
> this drive and you can feel safe in using it.
>
> This royally sucks...
>
> > > Have you tried poking the IDE driver to reset the bus, might get it
> > > running again?
>
> How would I do this? I've compiled the driver into the kernel. But if
> SMART data is kept even when a drive is off, this won't fix anything.
>
> > > Not a very pretty solution, especially since you might still suffer
> > > two drives going down at once from time to time.  Maybe you can
> > > patch MD to pause the array and poke the IDE driver whenever a disk
> > > is lost? Then you would at least only have intermittent failures /
> > > timeouts on a rare basis rather than a non-redundant array when
> > > something happens.
>
> The problem is that I can't tell if it's really MD that is telling the
> drive to turn itself off. Is there even code in MD that does this?
> Shouldn't it complain VERY LOUDLY that it's unhappy with a drive and
> thus decide to kill it?
>
> > > If the disk never comes up, being patient surely won't help.
> > > Wait for an hour and see if the drive comes up, ask the WD folks
> > > exactly how patient they want you to be? :-)
>
> The assumption was that since the drive took so long to respond, MD is
> telling the drive "You know what, fuck it. Never mind those outstanding
> requests, just shut down and let the rest of us get on with business",
> only thereby killing the array.
>
> > > bonnie++ does random seeks, right?
>
> I think so, yeah.
>
> Kind regards,
>
> Tom Wirschell
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


-- 
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
