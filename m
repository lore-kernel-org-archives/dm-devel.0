From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] blk/core: Gracefully handle unset make_request_fn
Date: Tue, 28 Jan 2020 11:26:10 -0500
Message-ID: <20200128162610.GA15575@redhat.com>
References: <20200123091713.12623-1-stefan.bader@canonical.com>
 <20200123091713.12623-2-stefan.bader@canonical.com>
 <20200123103541.GA28102@redhat.com>
 <20200123172816.GA31063@redhat.com>
 <81055166-37fb-ad65-6a53-11c22c626ab1@kernel.dk>
 <20200127193225.GA5065@redhat.com>
 <e0475dae-a55f-f30e-a82f-ee35cdb171c4@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e0475dae-a55f-f30e-a82f-ee35cdb171c4@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Tyler Hicks <tyler.hicks@canonical.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 28 2020 at  9:32am -0500,
Stefan Bader <stefan.bader@canonical.com> wrote:

> On 27.01.20 20:32, Mike Snitzer wrote:
> > 
> > I just staged the following DM fix:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.6&id=28a101d6b344f5a38d482a686d18b1205bc92333
> 
> Thanks Mike,
> 
> yeah this looks like it resolves the problem without adding any impact on the
> generic I/O path. We certainly had thought about that but felt uncertain whether
> it would not open other risks. Like something adding requests just before the
> table load. Could this cause some I/O be handled by one function and the rest by
> another? And would that really matter?

I considered this too.  Any IO issued to the device before it is "ready"
won't matter anyway (no where to send the IO due to not having a DM
table -- such IO should result in an error (from dm.c:dm_process_bio's
!map check).  But given the device has no size, a simple write will hit
-ENOSPC before.

And the only way to get the DM device to have a proper destination for
its IO is to load a table, which requires a sequence like:

# dmsetup create -n test
# dmsetup table
test:
# echo "0 20971520 linear 259:0 2048" | dmsetup load test
# dmsetup table --inactive
test: 0 20971520 linear 259:0 2048
# dmsetup suspend test
# dmsetup resume test
# dmsetup table
test: 0 20971520 linear 259:0 2048

And once a table is loaded there will be accompanying change
uevents that trigger udev, blkid, etc.

(NOTE: the suspend phase implies a flush of all outstanding IO, but even
if 'dmsetup suspend --noflush test' were used the IO would just get
pushed onto a list in DM core and it would be issued after the new table
is in place).

> The other thing that was a bit strange but maybe someone else's problem is that
> mount generated I/O requests to start with. The device size should be 0 still.

That's just mount not having a negative check for device size being 0.

Mike
