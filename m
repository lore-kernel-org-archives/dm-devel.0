From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: fix reversed logic in device_area_is_valid
Date: Mon, 27 Jul 2009 10:23:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907271022490.3823@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0907270913170.25437@hs20-bc2-1.build.redhat.com>
	<20090727141506.GA4964@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090727141506.GA4964@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, 27 Jul 2009, Mike Snitzer wrote:

> On Mon, Jul 27 2009 at  9:21am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > This patch fixes a bug introduced in 2.6.31-rc1. Targets that define 
> > iterate_devices and don't contain any devices (such as dm-loop in fsio) 
> > don't work.
> > 
> > Mikulas
> > 
> > ---
> > 
> > Fix reverse logic in device_area_is_valid
> > 
> > ->iterate_devices method calls the callback for every underlying device
> > in the target. If the callback returns non-zero, iterate_devices exits
> > and returns this value. If the callback returns zero for all the devices,
> > iterate_devices returns zero.
> > 
> > The logic to check for invalid device areas was reversed.
> > device_area_is_valid returned 0 on error and 1 on success.
> > 
> > Thus:
> > - error was returned only if all the devices vere errorneous. If some of them
> >   returned 1 (success), dm_calculate_queue_limits understood this as success.
> > - if the target had no device (the example is dm-loop target in FSIO mode),
> >   iterate_devices returned error straight away and dm_calculate_queue_limits
> >   understood this as an error.
> > 
> > This patch reverses the logic so that 0 means success and 1 means error.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Nice catch, interesting that this was somehow missed.  All targets do
> treat a non-zero return from .iterate_devices as an error.
> 
> We should probably rename device_area_is_valid to device_area_invalid.
> 
> Mike

Yes, you can rename it to that.

Mikulas
