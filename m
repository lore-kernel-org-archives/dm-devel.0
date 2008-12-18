From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath-tools libmultipath/configure.c libmu ...
Date: Thu, 18 Dec 2008 15:21:44 -0600
Message-ID: <20081218212143.GS1585@ether.msp.redhat.com>
References: <20080919032710.28653.qmail@sourceware.org>
	<20081218202606.GA24492@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081218202606.GA24492@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 18, 2008 at 03:26:06PM -0500, Konrad Rzeszutek wrote:
> On Fri, Sep 19, 2008 at 03:27:10AM -0000, bmarzins@sourceware.org wrote:
> > CVSROOT:	/cvs/dm
> > Module name:	multipath-tools
> > Branch: 	RHEL5_FC6
> > Changes by:	bmarzins@sourceware.org	2008-09-19 03:27:08
> > 
> > Modified files:
> > 	libmultipath   : configure.c configure.h devmapper.c devmapper.h 
> > 	multipathd     : cli.c cli.h cli_handlers.c cli_handlers.h 
> > 	                 main.c main.h 
> > 
> > Log message:
> > 	Fix for bz #455692. There is now a command for multipathd, 'resize map'. This
> > 	does online grows or shrinks for your multipath device. It has some warts.
> > 	
> > 	1. It needs to remove and re-add every path in the device. This can cause two
> > 	annoyances. First, if you only have one valid path, you go into an all paths
> > 	down scenario. However, you will immediately re-add the path, so it won't
> > 	trigger problem #2. Second, if the path is inaccessable, you may not be able to
> > 	re-add it.
> > 	
> > 	2. You can't disable flushing on suspend for a device-mapper device, when you
> > 	want to change size. This means that if all your paths are down, you will fail
> > 	the queued IOs when you suspend. This is a problem with the device-mapper kernel
> > 	code, and there's no real way to avoid it, except by fixing it in the kernel.
> > 	
> > 	This commit also has some minor fixups for 238421, and adds the ability to
> > 	disable and restore queueing on all multipath devices through multipathd
> > 
> 
> Benjamin,
> 
> I was wondering if you were planning to re-submit this patch to upstream git tree?
> I tried to apply it and got:

Yes.  It's on my list that I'm slowly working through when I get time.
Sorry. I'll try to get it out here quickly.

-Ben

> 
> patching file libmultipath/configure.c
> Hunk #1 FAILED at 360.
> 1 out of 1 hunk FAILED -- saving rejects to file libmultipath/configure.c.rej
> patching file libmultipath/configure.h
> patching file libmultipath/devmapper.c
> Hunk #1 succeeded at 150 (offset 20 lines).
> Hunk #2 FAILED at 162.
> Hunk #3 succeeded at 517 with fuzz 2 (offset 42 lines).
> Hunk #4 succeeded at 894 (offset 10 lines).
> 1 out of 4 hunks FAILED -- saving rejects to file libmultipath/devmapper.c.rej
> patching file libmultipath/devmapper.h
> Hunk #1 FAILED at 4.
> 1 out of 1 hunk FAILED -- saving rejects to file libmultipath/devmapper.h.rej
> patching file multipathd/cli.c
> Hunk #1 FAILED at 131.
> 1 out of 1 hunk FAILED -- saving rejects to file multipathd/cli.c.rej
> patching file multipathd/cli.h
> Hunk #1 FAILED at 9.
> Hunk #2 FAILED at 34.
> 2 out of 2 hunks FAILED -- saving rejects to file multipathd/cli.h.rej
> patching file multipathd/cli_handlers.c
> Hunk #1 FAILED at 13.
> Hunk #2 FAILED at 345.
> Hunk #3 FAILED at 368.
> Hunk #4 FAILED at 396.
> Hunk #5 succeeded at 619 (offset 42 lines).
> 4 out of 6 hunks FAILED -- saving rejects to file multipathd/cli_handlers.c.rej
> patching file multipathd/cli_handlers.h
> Hunk #1 FAILED at 14.
> 1 out of 1 hunk FAILED -- saving rejects to file multipathd/cli_handlers.h.rej
> patching file multipathd/main.c
> Hunk #1 succeeded at 147 (offset -11 lines).
> Hunk #2 FAILED at 757.
> 1 out of 2 hunks FAILED -- saving rejects to file multipathd/main.c.rej
> patching file multipathd/main.h
> Hunk #1 succeeded at 9 with fuzz 2.
> 
> I haven't looked in detail on the rejects and tried to see if I can "jam" it in
> correctly.
