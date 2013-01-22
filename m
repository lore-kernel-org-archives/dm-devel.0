From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: A thin-p over 256 GiB fails with I/O errors with
 non-power-of-two chunk
Date: Tue, 22 Jan 2013 08:51:32 -0500
Message-ID: <20130122135132.GA24851@redhat.com>
References: <201301180219.10467.db@kavod.com>
	<20130121184954.GA18892@redhat.com> <50FE739C.5090200@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <50FE739C.5090200@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: sandeen@redhat.com, device-mapper development <dm-devel@redhat.com>, Daniel Browning <db@kavod.com>
List-Id: dm-devel.ids

On Tue, Jan 22 2013 at  6:10am -0500,
Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 21.1.2013 19:49, Mike Snitzer napsal(a):
> >
> >Switching the thin-pool lvcreate to use --chunksize 1152K at least
> >enables me to format the filesystem.
> >
> >And both the thin-pool and thin device have an optimal_io_size that
> >matches the chunk_size of the underlying raid volume:
> >
> >cat /sys/block/dm-9/queue/optimal_io_size
> >1179648
> >cat /sys/block/dm-10/queue/optimal_io_size
> >1179648
> >
> >I'm still investigating the limits issue when --chunksize 1152K isn't
> >used for the thin-pool lvcreate.
> 
> Just a comment for the selection of thin chunksize here -
> 
> I think it has couple aspects here - by default (unless changed via
> lvm.conf {allocation/thin_pool_chunk_size}) it is targeting for 64K
> and scales chunksize up to fit thin metadata within 128MB.
> (compiled in as DEFAULT_THIN_POOL_OPTIMAL_SIZE)
> So lvm2 here scaled from 64k to 256k in multiTB case.

Not quite sure what you mean by "to fit thin metadata within 128MB".
Why is fitting within 128MB the goal?  I recall Joe helping to establish
the rule of thumb for lvm2 but I don't recall specifics at this point.

> lvcreate currently doesn't look out for geometry of underlying PV(s)
> during its allocation (somewhat chicken-egg problem) - yet there are
> possible ways to try to put this into equation - thought it might
> not be actually wanted by the user - since for snapshots the smaller
> chunksize is more usable
> (>1MB is quite a lot here IMHO) - but it probably worth some thinking.

I've found that the mkfs.xfs (which uses direct IO) will work if the
thinp chunksize is a factor of the raid0 chunksize.  So all of the
following thinp chunksizes "work" given that the raid0 chunksize is
1152K: 64K, 128K, 384K, 576K, 1152K

I haven't done extensive IO testing on the result XFS filesystem though.
So I don't want to get too far into shaping lvm2's chunksize selection
algorithm until I can dive into the kernel's limits stacking further
(which I'm doing now).
