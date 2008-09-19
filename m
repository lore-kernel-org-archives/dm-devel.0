From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: multipath-tools libmultipath/configure.c libmu ...
Date: Fri, 19 Sep 2008 11:52:05 +0300
Message-ID: <20080919085205.GA13941@edu.joroinen.fi>
References: <20080919032710.28653.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080919032710.28653.qmail@sourceware.org>
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

On Fri, Sep 19, 2008 at 03:27:10AM -0000, bmarzins@sourceware.org wrote:
> CVSROOT:	/cvs/dm
> Module name:	multipath-tools
> Branch: 	RHEL5_FC6
> Changes by:	bmarzins@sourceware.org	2008-09-19 03:27:08
> 
> Modified files:
> 	libmultipath   : configure.c configure.h devmapper.c devmapper.h 
> 	multipathd     : cli.c cli.h cli_handlers.c cli_handlers.h 
> 	                 main.c main.h 
> 
> Log message:
> 	Fix for bz #455692. There is now a command for multipathd, 'resize map'. This
> 	does online grows or shrinks for your multipath device. It has some warts.
> 	
> 	1. It needs to remove and re-add every path in the device. This can cause two
> 	annoyances. First, if you only have one valid path, you go into an all paths
> 	down scenario. However, you will immediately re-add the path, so it won't
> 	trigger problem #2. Second, if the path is inaccessable, you may not be able to
> 	re-add it.
> 	
> 	2. You can't disable flushing on suspend for a device-mapper device, when you
> 	want to change size. This means that if all your paths are down, you will fail
> 	the queued IOs when you suspend. This is a problem with the device-mapper kernel
> 	code, and there's no real way to avoid it, except by fixing it in the kernel.
> 	
> 	This commit also has some minor fixups for 238421, and adds the ability to
> 	disable and restore queueing on all multipath devices through multipathd
> 

Nice!!

So now we have SCSI disk online resizing, and dm-multipath online resizing. Excellent. 

I assume both of these will be in RHEL 5.3? 

-- Pasi
