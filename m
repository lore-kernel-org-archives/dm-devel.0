From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Fri, 16 Jun 2006 20:21:52 +0200
Message-ID: <62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
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

Greg Freemeyer:
> I did not review your e-mail in total, but using lots of SATA drives
> in a big RAID array is not something I would attempt with 2.6.17 or
> older kernels.  (I know 2.6.17 is not even out yet.).

I've seen IDE failures on every Linux kernel I ever tried.
I hope Linux IDE will mature, some glorious day in a distant future...

Tom Wirschell:
> > Have you tried poking the IDE driver to reset the bus,
> > might get it running again?
>
> How would I do this?

Not sure how it's done with libata.  Perhaps:
# cd /sys/block/sda/device/
# echo 1 > rescan

Rune Saetre wrote:
> It can't be the power supply not coping with a large number of disks
> seeking simultaneously?  If the voltage drops too much some disks
> might shut down.

I was of the impression that disks suck tons of juice when they
spin up, and only 5W a piece or so at any other time.  Is that right?

Of course, WD disks could be weird.

Or they could be configured to go into standby mode after some time,
requiring another spinup - but AFAIR, MD would spin them up one
after one.

Arno Wagner:
> If you can test it with reasonable effort and cost (e.g. put some of
> them on another PSU), you might want to do that.

Is that safe?

Another way could be to use a meter to gauge how much power it drains.
