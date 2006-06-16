From: Tom Wirschell <Tom@Wirschell.nl>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Sat, 17 Jun 2006 00:47:30 +0200
Message-ID: <20060617004730.70da7373@localhost>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
	<20060614215258.6aa76d0f@localhost>
	<62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
	<87f94c370606161132u2a7f0adeia790c73f4da58af0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87f94c370606161132u2a7f0adeia790c73f4da58af0@mail.gmail.com>
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

On 16 Jun 2006, Greg Freemyer wrote:
>=20
> Based on the feedback I've seen on the mailing list, the new EH for
> SATA appears to be a major improvement.  The guy who wrote it (Tejun
> Heo) said he had participated in static discharge tests with SATA
> drives and had made an effort to catch and recover from the various
> transient errors he had seen induced during those tests.  I don't know
> if he actually ran any static discharge tests on drives while
> developing the new EH routines.

Well at least I should be an interesting subject for them as I can
fairly reliably take a disk out in a rather unpleasant manner, giving
the new EH code something to work with...

> > Not sure how it's done with libata.  Perhaps:
> > # cd /sys/block/sda/device/
> > # echo 1 > rescan

Interesting. I'll try that.

> > Rune Saetre wrote:
> > > It can't be the power supply not coping with a large number of
> > > disks seeking simultaneously?  If the voltage drops too much some
> > > disks might shut down.
> >
> > I was of the impression that disks suck tons of juice when they
> > spin up, and only 5W a piece or so at any other time.  Is that
> > right?

I thought this would be mighty nice to have, and apparently the WD
drives actually support it. Unfortunately the Promise cards do not so
I'm not using this feature. On boot, all drives spin up at once. And
I've yet to see any part of this setup complain about that. It usually
takes me about an hour or two of moderate RAID activity (specifically,
scp-ing a 200GB batch of files over gigabit ethernet at about 20 MB/s
tops. If it survives that I copy this data onto the array until it
fills up. Thus far I've never managed to reach this point).

As for power draw:
http://westerndigital.com/en/products/Products.asp?DriveID=3D58#jump1616
9W a pop for the SATA version.
http://westerndigital.com/en/products/products.asp?driveid=3D38&language=3D=
en#jump1818
Slightly less for the 2 PATA ones.
But even if we make it 10 they're only running 120 watts. That means
there's another 430 Watts for the Mobo, CPU, IO card, a DVD drive and a
bunch of fans which should be ample. It's behind an APC Back-UPS CS 650
which hasn't complained yet by flickering the light that says it's
getting loaded too much. Haven't tried to get any sensible data out of
it yet, but I'm quite confident power draw isn't the problem. Hell,
I've had this problem happen when there were only 6 drives inside this
machine.

> > Or they could be configured to go into standby mode after some time,
> > requiring another spinup - but AFAIR, MD would spin them up one
> > after one.

This would only make sense if the drives weren't in use, and they most
certainly were.

> > Arno Wagner:
> > > If you can test it with reasonable effort and cost (e.g. put some
> > > of them on another PSU), you might want to do that.
> >
> > Is that safe?
>=20
> Seems dangerous to me, but I don't know if a standard sata cable
> carries ground or not.  That is normally the problem.  ie. if you have
> more than one ground, you can get ground loops and most electronics is
> not designed to work with those.
>=20
> The 2 traditional ways to handle it are using differential circuits
> like RS-232, and some SCSI cables.  The other is to use fibre
> connections to isolate any voltage issues.

You're losing me here, but yes, both the SATA power and data cables
carry ground. Plus the ground connectors are closer to the outside than
any other connector so they connect before any data or powerlines get a
chance to. Supposedly it's safe and I've seen images of rigs that
made ample use of this. I wouldn't call it common practice though.
You can turn on a powersupply by connecting the green wire in the chord
that connects to the mobo to any ground connector. Any drive that's
connected to the PS will at that time get its juice and spin up. Or at
least it should.

> > Another way could be to use a meter to gauge how much power it
> > drains.

Yeah, I think the UPS should be able to tell me that. Lemme see if I
can hook it up to another box sometime tomorrow.

> Not sure that will tell you much.  On the ide list I seem to recall
> several posts about problems when using multiple sata drives.  Many of
> the problems were resolved by addressing power issues, even thought PS
> seemed plenty big.  IIRC one the things done was to not have the
> drives daisy-chained off the same power cable.  Search the lkml-ide
> archives if your curious.

I've yet to run into a PS that comes with sufficient connectors to
power a total of 12 drives. My PS (550W Antec TruePower II) has 4 SATA
connectors coming from it, and a total of 5 wide molex connectors that
you can connect regular drives to. Every single one of those has a
splitter attached to it to give me sufficient connectors to power all
the drives as well as the fans. If anything the load should be even
across, and on the off chance that they were the flaky part, I did in
fact replace them but found no change in behaviour. The replacement
were regular molex splitters I might add. The old ones were
molex-to-2-SATA-power and the new ones were molex-to-2-molex. But like
I said, no difference.

I honestly can't find any fault in the hardware, and no logical
explanation for the software deciding to do this. Anyways, I'll ask the
IDE guys. If some kind soul could inform me of the location of the
latest version of their #upstream patch, I=C2=B4d be mighty grateful. I
didn't see any mention of it in the mailinglist archives for this month.

Kind regards,

Tom Wirschell
