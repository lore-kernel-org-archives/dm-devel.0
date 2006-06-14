From: Tom Wirschell <Tom@Wirschell.nl>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Wed, 14 Jun 2006 21:52:58 +0200
Message-ID: <20060614215258.6aa76d0f@localhost>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 14 Jun 2006, Rune Saetre wrote:
> 
> I always thought the loud click came from the disks parking their
> heads before spinning down.

Well, it's most certainly loud. The same type of loud that you get when
the machine shuts down and removes the power from the drives. I thought
recalibration ticks weren't particularly loud.

> Anyway, it can take several seconds before a disk responds to
> commands after having spun down.

The problem isn't that it takes time to come back up after a spin down.
The drive isn't spinning down. It's turning itself off completely
(note the 'no device found' bit in the error). And it does this while
it's actively being used.

> On Wed, 14 Jun 2006, Molle Bestefich wrote:
> >
> > Does the drive's SMART log say anything interesting?

That's a damned good question. I didn't even know you could query that,
so I just recreated the array and started my test again. Took about 90
minutes for one of the drives to die. Unfortunately when it dies it
refuses to respond to anything.

When I try the smartctl program on the failed drive I get:
Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)
When I issue the exact same command for another disk on the controller
I get a nice listing that you would expect from this program.

When I use hdparm -I on the died drive I get:
HDIO_DRIVE_CMD(identify) failed: Input/output error
And again, if I issue the exact same command for another disk on this
same controller I get a nice bit of info on the drive.

To me at least, this basically says that the drive is actually turned
off at this point in time. It would explain why SMART isn't getting any
data. On the other hand, it doesn't explain *WHY* the drive is off.
Do you know any program that's capable of telling a drive that isn't on
to activate itself? I don't think it's even possible but might be
mistaken there.

So, I reboot, run smartctl again and I'm presented with a nice sheet
of output that basically says all is well, nothing ever went wrong with
this drive and you can feel safe in using it.

This royally sucks...

> > Have you tried poking the IDE driver to reset the bus, might get it
> > running again?

How would I do this? I've compiled the driver into the kernel. But if
SMART data is kept even when a drive is off, this won't fix anything.

> > Not a very pretty solution, especially since you might still suffer
> > two drives going down at once from time to time.  Maybe you can
> > patch MD to pause the array and poke the IDE driver whenever a disk
> > is lost? Then you would at least only have intermittent failures /
> > timeouts on a rare basis rather than a non-redundant array when
> > something happens.

The problem is that I can't tell if it's really MD that is telling the
drive to turn itself off. Is there even code in MD that does this?
Shouldn't it complain VERY LOUDLY that it's unhappy with a drive and
thus decide to kill it?

> > If the disk never comes up, being patient surely won't help.
> > Wait for an hour and see if the drive comes up, ask the WD folks
> > exactly how patient they want you to be? :-)

The assumption was that since the drive took so long to respond, MD is
telling the drive "You know what, fuck it. Never mind those outstanding
requests, just shut down and let the rest of us get on with business",
only thereby killing the array.

> > bonnie++ does random seeks, right?

I think so, yeah.

Kind regards,

Tom Wirschell
