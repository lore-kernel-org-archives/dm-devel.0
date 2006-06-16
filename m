From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Fri, 16 Jun 2006 14:32:56 -0400
Message-ID: <87f94c370606161132u2a7f0adeia790c73f4da58af0@mail.gmail.com>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
	<20060614215258.6aa76d0f@localhost>
	<62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
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

On 6/16/06, Molle Bestefich <molle.bestefich@gmail.com> wrote:
> Greg Freemeyer:
> > I did not review your e-mail in total, but using lots of SATA drives
> > in a big RAID array is not something I would attempt with 2.6.17 or
> > older kernels.  (I know 2.6.17 is not even out yet.).
>
> I've seen IDE failures on every Linux kernel I ever tried.
> I hope Linux IDE will mature, some glorious day in a distant future...

Based on the feedback I've seen on the mailing list, the new EH for
SATA appears to be a major improvement.  The guy who wrote it (Tejun
Heo) said he had participated in static discharge tests with SATA
drives and had made an effort to catch and recover from the various
transient errors he had seen induced during those tests.  I don't know
if he actually ran any static discharge tests on drives while
developing the new EH routines.

> Tom Wirschell:
> > > Have you tried poking the IDE driver to reset the bus,
> > > might get it running again?
> >
> > How would I do this?
>
> Not sure how it's done with libata.  Perhaps:
> # cd /sys/block/sda/device/
> # echo 1 > rescan
>
> Rune Saetre wrote:
> > It can't be the power supply not coping with a large number of disks
> > seeking simultaneously?  If the voltage drops too much some disks
> > might shut down.
>
> I was of the impression that disks suck tons of juice when they
> spin up, and only 5W a piece or so at any other time.  Is that right?
>
> Of course, WD disks could be weird.
>
> Or they could be configured to go into standby mode after some time,
> requiring another spinup - but AFAIR, MD would spin them up one
> after one.
>
> Arno Wagner:
> > If you can test it with reasonable effort and cost (e.g. put some of
> > them on another PSU), you might want to do that.
>
> Is that safe?

Seems dangerous to me, but I don't know if a standard sata cable
carries ground or not.  That is normally the problem.  ie. if you have
more than one ground, you can get ground loops and most electronics is
not designed to work with those.

The 2 traditional ways to handle it are using differential circuits
like RS-232, and some SCSI cables.  The other is to use fibre
connections to isolate any voltage issues.

> Another way could be to use a meter to gauge how much power it drains.

Not sure that will tell you much.  On the ide list I seem to recall
several posts about problems when using multiple sata drives.  Many of
the problems were resolved by addressing power issues, even thought PS
seemed plenty big.  IIRC one the things done was to not have the
drives daisy-chained off the same power cable.  Search the lkml-ide
archives if your curious.

Greg
-- 
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
