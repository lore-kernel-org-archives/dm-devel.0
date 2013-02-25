From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Multipath / iSCSI issues
Date: Mon, 25 Feb 2013 10:42:12 -0600
Message-ID: <512B9464.5000908@cs.wisc.edu>
References: <CAEctU6r9dnVnaMFgzO+8g0ktJ2VFTCaN47NiR5F4QH16_iX53g@mail.gmail.com>
	<512AA728.7040507@cs.wisc.edu>
	<CAEctU6pWmJwJbZd0F+FDTM3YyOrogF4jYav=_hFRcyELqzDVfg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEctU6pWmJwJbZd0F+FDTM3YyOrogF4jYav=_hFRcyELqzDVfg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Devin <delldudedevin@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 02/24/2013 08:07 PM, Devin wrote:
> 
> I am using the iscsi tools that is included with Oracle
> (iscsi-initiator-utils-6.2.0.872-13.0.1.el5). 
> 
> The values I have in my iscsid.conf are:
> node.session.timeo.replacement_timeout = 15
> node.conn[0].timeo.noop_out_timeout = 1
> node.conn[0].timeo.noop_out_interval = 1

Those noop related values are too low. You will get really fast
failovers, but this is going to end up causing failures/failovers when
IO is just executing a little slow.

> 
> {i have previously changed the settings from the values based upon some
> feedback I got from a tech guy but that didn't seem to make much
> difference}.
> 
> In regards to the scsi command timeout it appears to be set to 60.
> 
> # cat /sys/block/sdw/device/timeout 
> 60
> 
> So is my thinking correct that I will want to have the SCSI devices to
> timeout more quickly like 1 second versus the 60 seconds? If so where
> would i make this change in regards to the disks???
> 

I would need the /var/log/messages with the iscsi logging turned on so I
can know for sure what where errors are being fired, but it sounds like
you would want to set the device timeout lower. You do not want it set
to only 1 second, because that is going to be too low. How fast does
Oracle need something to failover?

You can set the device timeout manually through that sysfs file, or you
there should be a udev rule in OEL 5.


> Thanks much.
> 
> Devin Acosta
> 
> 
> On Sun, Feb 24, 2013 at 4:50 PM, Mike Christie <michaelc@cs.wisc.edu
> <mailto:michaelc@cs.wisc.edu>> wrote:
> 
>     On 02/24/2013 01:15 PM, Devin wrote:
>     >
>     > I am running Oracle Enterprise Linux 5.8 (which is really just
>     Redhat).
>     > I am using Multipath and I have LUNS presented to me via iSCSI from a
>     > Hitachi SAN. I have the NICS bonded using the Linux bonding driver and
>     > using Active-Backup mode. I notice that when I loose a switch or
>     > connection to one of the switches that multipath freezes for at
>     least 60
>     > seconds before it starts to respond again. Also it appears that IO
>     being
>     > generated freezes until multipath responds again, this pause up to 60
>     > seconds is causing my Oracle instances to crash.
>     >
>     > I have not been able to easily find what settings i could possibly
>     > change to make it fail to a new path faster. It almost seems like it's
>     > taking multipath a bit to fail all IO to a new path that is working.
>     >
>     > Is there any information that might be useful for me that I can
>     check on
>     > either the multipath side or the iSCSI side to see what is causing the
>     > issue???
>     >
> 
>     What iscsi driver are you using? If you are using software iscsi that
>     comes with OEL 5.8 what are our node.session.timeo.replacement_timeout,
>     .timeo.noop_out_timeout and .timeo.noop_out_interval. And what is your
>     scsi command timeout. You can see that by doing:
> 
>     cat /sys/block/sdX/device/timeout
> 
> 
> 
