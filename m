From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm: Avoid sleeping while holding the dm_bufio lock
Date: Thu, 8 Dec 2016 18:20:06 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1612081758250.25149@file01.intranet.prod.int.rdu2.redhat.com>
References: <1479410660-31408-1-git-send-email-dianders@chromium.org> <alpine.LRH.2.02.1611231543020.31481@file01.intranet.prod.int.rdu2.redhat.com> <CAD=FV=V85=ZTXURVZ3Xo1gS80rqA8gOhr+Xm47axrwVUpjQFuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD=FV=V85=ZTXURVZ3Xo1gS80rqA8gOhr+Xm47axrwVUpjQFuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Anderson <dianders@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Sonny Rao <sonnyrao@chromium.org>, Guenter Roeck <linux@roeck-us.net>
List-Id: dm-devel.ids



On Wed, 7 Dec 2016, Doug Anderson wrote:

> Hi,
> 
> On Wed, Nov 23, 2016 at 12:57 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Hi
> >
> > The GFP_NOIO allocation frees clean cached pages. The GFP_NOWAIT
> > allocation doesn't. Your patch would incorrectly reuse buffers in a
> > situation when the memory is filled with clean cached pages.
> >
> > Here I'm proposing an alternate patch that first tries GFP_NOWAIT
> > allocation, then drops the lock and tries GFP_NOIO allocation.
> >
> > Note that the root cause why you are seeing this stacktrace is, that your
> > block device is congested - i.e. there are too many requests in the
> > device's queue - and note that fixing this wait won't fix the root cause
> > (congested device).
> >
> > The congestion limits are set in blk_queue_congestion_threshold to 7/8 to
> > 13/16 size of the nr_requests value.
> >
> > If you don't want your device to report the congested status, you can
> > increase /sys/block/<device>/queue/nr_requests - you should test if your
> > chromebook is faster of slower with this setting increased. But note that
> > this setting won't increase the IO-per-second of the device.
> 
> Cool, thanks for the insight!
> 
> Can you clarify which block device is relevant here?  Is this the DM
> block device, the underlying block device, or the swap block device?
> I'm not at all an expert on DM, but I think we have:
> 
> 1. /dev/mmcblk0 - the underlying storage device.
> 2. /dev/dm-0 - The verity device that's run atop /dev/mmcblk0p3
> 3. /dev/zram0 - Our swap device

The /dev/mmcblk0 device is congested. You can see the number of requests 
in /sys/block/mmcblk0/inflight

> As stated in the original email, I'm running on a downstream kernel
> (kernel-4.4) with bunches of local patches, so it's plausible that
> things have changed in the meantime, but:
> 
> * At boot time the "nr_requests" for all block devices was 128
> * I was unable to set the "nr_requests" for dm-0 and zram0 (it just
> gives an error in sysfs).
> * When I set "nr_requests" to 4096 for /dev/mmcblk0 it didn't seem to
> affect the problem.

The eMMC has some IOPS and the IOPS can't be improved. Use faster block 
device - but it will cost more money.

If you want to handle such a situation where you run 4 tasks each eating 
900MB, just use more memory, don't expect that this will work smoothly on 
4GB machine.

If you want to protect the chromebook from runaway memory allocations, you 
can detect this situation in some watchdog process and either kill the 
process that consumes most memory with the kill syscall or trigger the 
kernel OOM killer by writing 'f' to /proc/sysrq-trigger.

The question is what you really want - handle this situation smoothly 
(then, you must add more memory) or protect chromeOS from applications 
allocating too much memory?

Mikulas
