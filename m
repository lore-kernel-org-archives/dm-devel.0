From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] dm raid/raid1: enable discard support when any
 devices support discard
Date: Sun, 19 Apr 2020 09:19:09 -0400
Message-ID: <20200419131908.GA22398@redhat.com>
References: <20200419073026.197967-1-pabs3@bonedaddy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200419073026.197967-1-pabs3@bonedaddy.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Wise <pabs3@bonedaddy.net>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Apr 19 2020 at  3:30am -0400,
Paul Wise <pabs3@bonedaddy.net> wrote:

> This makes dm raid and dm raid1 (mirroring) consistent with md raid,
> which supports discard when only some of the devices support discard.
> 
> Another patch will be needed to fix the queue discard limits sysfs files,
> fixing `fstrim --fstab`, but these patches suffice to fix `fstrim /` and
> I haven't finished figuring out how the queue discard limits are set yet.
> 
> Paul Wise (3):
>   dm: add support for targets that allow discard when one device does
>   dm raid: only check for RAID 4/5/6 once during discard support setup
>   dm raid/raid1: enable discard support when any devices support discard
> 
>  drivers/md/dm-cache-target.c  |  2 +-
>  drivers/md/dm-clone-target.c  |  2 +-
>  drivers/md/dm-log-writes.c    |  2 +-
>  drivers/md/dm-raid.c          | 21 ++++++++++-----------
>  drivers/md/dm-raid1.c         |  1 +
>  drivers/md/dm-table.c         | 32 +++++++++++++++++++++-----------
>  drivers/md/dm-thin.c          |  8 ++++----
>  drivers/md/dm-zoned-target.c  |  2 +-
>  include/linux/device-mapper.h | 13 ++++++++-----
>  include/uapi/linux/dm-ioctl.h |  4 ++--
>  10 files changed, 50 insertions(+), 37 deletions(-)

You went overboard with implementation before checking to see if your
work would be well received.  Your 2/3 patch header shows you're
capable of analyzing past commits to explain the evolution of code,
etc.  But yet you make no mention of this commit header which explicitly
speaks to why what you're proposing is _not_ acceptable:

commit 8a74d29d541cd86569139c6f3f44b2d210458071
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue Nov 14 15:40:52 2017 -0500

    dm: discard support requires all targets in a table support discards

    A DM device with a mix of discard capabilities (due to some underlying
    devices not having discard support) _should_ just return -EOPNOTSUPP for
    the region of the device that doesn't support discards (even if only by
    way of the underlying driver formally not supporting discards).  BUT,
    that does ask the underlying driver to handle something that it never
    advertised support for.  In doing so we're exposing users to the
    potential for a underlying disk driver hanging if/when a discard is
    issued a the device that is incapable and never claimed to support
    discards.

    Fix this by requiring that each DM target in a DM table provide discard
    support as a prereq for a DM device to advertise support for discards.

    This may cause some configurations that were happily supporting discards
    (even in the face of a mix of discard support) to stop supporting
    discards -- but the risk of users hitting driver hangs, and forced
    reboots, outweighs supporting those fringe mixed discard
    configurations.

    Cc: stable@vger.kernel.org
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

I haven't looked closely at MD raid in this area but if you trully think
underlying MD raid can cope with issuing discards to devices that don't
support them (or that it avoids issuing them?) then please update
dm-raid.c to conditionally set ti->discard_supported (if not all devices
support discard).  That is how to inform DM core that the target knows
better and it will manage discards issued to it.  It keeps the change
local to dm-raid.c without the flag-day you're proposing.

Mike
