From: Ed Wilts <ewilts@ewilts.org>
Subject: Re: not all paths working at boot
Date: Thu, 3 Aug 2006 16:02:52 -0500
Message-ID: <20060803210252.GB9952@www.ewilts.org>
References: <20060803135447.GE15820@sanger.ac.uk>
	<20060803172925.GB6204@www.ewilts.org>
	<1154634091.3072.20.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1154634091.3072.20.camel@gator.sc.steeleye.com>
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

On Thu, Aug 03, 2006 at 03:41:31PM -0400, Eddie Williams wrote:
> 
> If you can, upgrade to 4.004 firmware.  This makes the EVA active/active
> and perhaps will resolve your problems.  It definitely makes it work
> better!

This is a *major* change that most customers are not doing because of
the significance of it.  I'm not saying that it's a bad thing but this
*MUST* be planned very, very carefully and even then, if it goes wrong,
you have the potential to lose the frame since there is no roll-back.

        .../Ed
> 
> Eddie
> On Thu, 2006-08-03 at 12:29 -0500, Ed Wilts wrote:
> > On Thu, Aug 03, 2006 at 02:54:47PM +0100, Dave Holland wrote:
> > > I have a problem with multipath-tools 0.4.7 (I also tried the latest
> > > "git" version) running on Debian (mix of stable/unstable), kernel
> > > 2.6.17-1-amd64-k8, libdevmapper 1.02.07-1, udev 0.093-1. The machine is
> > > a HP DL385 with QLA2312 FC card.
> > > 
> > > Basically, at boot time, multipath does not recognise all the paths. The
> > > underlying LUNs are visible, the mid-layer allocates /dev/sd* device
> > > names, but not all the paths are not used:
> > > 
> > > newftp1b:~# lsscsi -d | grep ':1]'
> > > [0:0:0:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sda[8:0]
> > > [0:0:1:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sdi[8:128]
> > > [1:0:0:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sdq[65:0]
> > > [1:0:1:1]    disk    COMPAQ   HSV110 (C)COMPAQ 3028  /dev/sdy[65:128]
> > 
> > The EVAs are strange beasts...  You are running an EVA5000 with firmware
> > 3.028.  That makes it an active/passive controller.  In addition,
> > although each HSV controller in the EVA has 2 paths to each fabric, only
> > 1 path is actually ever used and the other is there in case the first
> > fails.   So...your storage is really available on only 1 of the 4 paths.
> > 
> > My personal solution to the EVAs on Linux is to just use the qlogic
> > failover driver.  It just works.  That's not to say that there isn't a
> > problem in the multipath software - I'm just saying that you don't need
> > the multipath suite to make stuff work (in this case).
> > 
> >         .../Ed
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Ed Wilts, RHCE
Mounds View, MN, USA
mailto:ewilts@ewilts.org
Member #1, Red Hat Community Ambassador Program
