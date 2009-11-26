From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Thu, 26 Nov 2009 12:56:07 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911261255070.28831@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
	<20091124191704.GB7971@us.ibm.com>
	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
	<4B0D509E.9090001@redhat.com> <20091125204458.GC1673@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091125204458.GC1673@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Wed, 25 Nov 2009, malahal@us.ibm.com wrote:

> Takahiro Yasui [tyasui@redhat.com] wrote:
> > > The requirements are:
> > > * if one of legs fail or log fails, you must automatically continue 
> > > without human intervention
> > > * if both legs fail, you must shut it down and not pretend that something 
> > > was written when it wasn't (this would break durability requirement of 
> > > transactions).
> > 
> > I agree with this point. lvm mirror could be used on filesystems such as
> > ext3 and each filesystem and application needs to take care those situation
> > to prevent data corruption. I don't think that it is realistic, and the
> > underlying layer should prevent data corruption. I now understand primary
> > and secondary disks need to be blocked.
> 
> If you think that I/O needs to be blocked for first or second leg
> failures, then I am afraid that there is no way to keep the failed
> mirror in the system for re-integrating failed devices.
> 
> I would like to keep the mirror as mirror when one of the legs fails as
> opposed to making it linear now by dmeventd. This is to re-integrate a
> failed leg into the mirror to handle transient device failures. Here is
> what I am planning to do, let me know if you find any issues:
> 
> 1. Secondary leg failure. dmeventd will NOT change the meta data at all.
>    It will call "lvchange --refresh" that will start resynchronization.
>    This will be done a few times. If the device still fails to
>    re-integrate, it is left the way it is and no further re-integrations
>    attempts are done. The number of attempts can be done at configurable
>    intervals.
> 
> 2. First leg failure (aka Primary leg failure): The kernel would stop
>    handling any further I/O. The dmeventd will change mirror meta data
>    [it will re-order the legs ] so that the secondary now becomes the
>    primary. I will try to re-integrate the failed device few times before
>    giving up just as in the case "1" above.
> 
> The kernel module will never progress with a first leg failure as you
> see above.
> 
> Thanks, Malahal.

This is possible but it would need some redesign. The purpose of my patch 
was just to fix the race, not redesign it for transient failures. But yes 
--- in the long term, it could be done.

Mikulas
