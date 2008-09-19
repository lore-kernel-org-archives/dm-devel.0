From: Andy <genanr@emsphone.com>
Subject: Re: multipath-tools libmultipath/configure.c libmu ...
Date: Fri, 19 Sep 2008 16:57:32 -0500
Message-ID: <20080919215731.GA7172@thumper2>
References: <20080919032710.28653.qmail@sourceware.org>
	<20080919185313.GA2932@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080919185313.GA2932@thumper2>
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

On Fri, Sep 19, 2008 at 01:53:13PM -0500, Andy wrote:
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
> > Patches:
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.3&r2=1.2.2.4
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.5&r2=1.22.2.6
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.4&r2=1.11.2.5
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.2&r2=1.6.2.3
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.2&r2=1.3.2.3
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.13&r2=1.69.2.14
> > http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7&r2=1.7.2.1
> > 
> 
> Where can I get the multipath-tools sources that these patches apply cleanly
> to?  They do not apply cleanly to my multipath 0.4.8 sources, add there
> seems to be some major differences in some places.
> 
> Thanks,
> 
> Andy
> 

Responding to my own mail, I did got the source with the patches from the
cvs.  But, the resizing does not work for with with mounted volumes.  There
are 4 paths for the volume, so there is no probably with it failing paths. 
I get "domap(0) failure for create/reload map" when I run multipath -v 3.

I can get dm to reconize the new size if the volume is umounted.  But, I
really would like it to work while it is mounted.

Andy
