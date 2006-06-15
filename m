From: Arno Wagner <wagner@tik.ee.ethz.ch>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Fri, 16 Jun 2006 00:53:53 +0200
Message-ID: <20060615225353.GA10252@tik.ee.ethz.ch>
References: <20060615232542.6b085337@localhost>
	<Pine.LNX.4.63.0606160031480.22065@pingle.local.rsnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0606160031480.22065@pingle.local.rsnet>
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

On Fri, Jun 16, 2006 at 12:48:24AM +0200, Rune Saetre wrote:
> Hi
> 
> Next silly question then:
> It can't be the power supply not coping with a large number of disks 
> seeking simultaneously? If the voltage drops too much some disks might 
> shut down.
> 
> Probably unlikely, but it would yield a simple solution..

Unlikely but possible IMO. If you can test it with reasonable
effort and cost (e.g. put some of them on another PSU),
you might want to do that.

Arno

 
> Rune
> 
> ---
> Rune S?tre <rune.saetre@netcom-gsm.no>
> NetCom as
> ..
> 
> On Thu, 15 Jun 2006, Tom Wirschell wrote:
> 
> >On 15 Jun 2006, Greg Freemyer wrote:
> >>
> >>In 2.6.17-mm there is a huge SATA error handler (EH) rewrite.  Is is
> >>planned to hit the stable Linus kernel with 2.6.18 towards the end of
> >>the summer, but even then it will only have a few of the actual
> >>drivers modified to use the EH infrastructure.
> >
> >Damn. I read about this in the LWN.net Kernel pages for may 17th. I
> >figured that once it was in, everything would automagically be using it
> >too (i.e. the drivers wouldn't need to be updated to the new system).
> >Guess I was a tad na?ve about that.
> >I tried 2.6.17-rc5-mm2 and ran into some BUG()s which went away when I
> >just stuck to 2.6.17-rc5.
> >
> >>I would repost your problem to the lkml-ide list and see if they think
> >>that the new EH should help you, and when/if your controller will be
> >>using the new EH infrastructure.
> >
> >Looks like a good idea, thanks!
> >Don't let that keep anybody on this list who might have an explanation
> >for this be deterred from responding though. :)
> >
> >>Also, there is a ton of testing going on with the new EH, so if your
> >>willing to be a guinea pig, I'm sure you will get a lot of support
> >>from the dev. team and get your specific driver updated ASAP.
> >
> >I've been sitting on a non-functional array for almost 3 months now.
> >Don't mind having weird issues a little longer if it means things will
> >end up working nicely in the end (or I at least get a sensible
> >explanation for what's wrong, so I know what I must do to fix it).
> >
> >Kind regards,
> >
> >Tom Wirschell
> >
> >--
> >dm-devel mailing list
> >dm-devel@redhat.com
> >https://www.redhat.com/mailman/listinfo/dm-devel
> >

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Arno Wagner, Dipl. Inform., CISSP --- CSG, ETH Zurich, wagner@tik.ee.ethz.ch 
GnuPG:  ID: 1E25338F  FP: 0C30 5782 9D93 F785 E79C  0296 797F 6B50 1E25 338F
----
Cuddly UI's are the manifestation of wishful thinking. -- Dylan Evans
Windows is the "under-3" toy of the OS world. -- Matthew D. Fuller
