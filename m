From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: multipath-tools libmultipath/configure.c libmu ...
Date: Tue, 30 Sep 2008 12:22:06 +0300
Message-ID: <20080930092206.GH9714@edu.joroinen.fi>
References: <20080919032710.28653.qmail@sourceware.org>
	<20080919185313.GA2932@thumper2> <20080919215731.GA7172@thumper2>
	<20080923180504.GB3808@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080923180504.GB3808@ether.msp.redhat.com>
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

On Tue, Sep 23, 2008 at 01:05:04PM -0500, Benjamin Marzinski wrote:
> > 
> > Responding to my own mail, I did got the source with the patches from the
> > cvs.  But, the resizing does not work for with with mounted volumes.  There
> > are 4 paths for the volume, so there is no probably with it failing paths. 
> > I get "domap(0) failure for create/reload map" when I run multipath -v 3.
> > 
> > I can get dm to reconize the new size if the volume is umounted.  But, I
> > really would like it to work while it is mounted.
> > 
> 
> It should work for mounted volumes.  Did you try
> multipathd -k"resize map <mapname>"
> 
> Since this requires suspending without the no_flush option, I didn't
> want to have it happen on a normal reload, and since without the kernel
> fixes, this required removing and then readding paths, I did it through
> multipathd.
> 
> So just running multipath -v3 after a path resize won't work. In fact, I
> think it might leave the devices in the suspended state, since the
> resume fails.
> 

Hi!

I just tried this but I'm having problems getting it to work..

# multipathd -k"resize map mpath-resize-test"
fail

The underlying SCSI devices have been online resized already, and verified
from dmesg and from /proc/partitions to be bigger.

I'm running rhel5 kernel with scsi online resize patches (2.6.18-93.el5.bz444964.2)
and dm-multipath testing packages with support for online resizing
(device-mapper-multipath-0.4.7-19.el5.i386.rpm).

Any ideas? 

-- Pasi
