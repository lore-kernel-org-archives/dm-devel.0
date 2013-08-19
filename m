From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Mon, 19 Aug 2013 10:00:16 -0400
Message-ID: <20130819140016.GB27167@redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Aug 16 2013 at  6:55pm -0400,
Frank Mayhar <fmayhar@google.com> wrote:

> The device mapper and some of its modules allocate memory pools at
> various points when setting up a device.  In some cases, these pools are
> fairly large, for example the multipath module allocates a 256-entry
> pool and the dm itself allocates three of that size.  In a
> memory-constrained environment where we're creating a lot of these
> devices, the memory use can quickly become significant.  Unfortunately,
> there's currently no way to change the size of the pools other than by
> changing a constant and rebuilding the kernel.
> 
> This patch fixes that by changing the hardcoded MIN_IOS (and certain
> other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> sysctl-modifiable values.  This lets us change the size of these pools
> on the fly, we can reduce the size of the pools and reduce memory
> pressure.

These memory reserves are a long-standing issue with DM (made worse when
request-based mpath was introduced).  Two years ago, I assembled a patch
series that took one approach to trying to fix it:
http://people.redhat.com/msnitzer/patches/upstream/dm-rq-based-mempool-sharing/series.html

But in the end I wasn't convinced sharing the memory reserve would allow
for 100s of mpath devices to make forward progress if memory is
depleted.

All said, I think adding the ability to control the size of the memory
reserves is reasonable.  It allows for informed admins to establish
lower reserves (based on the awareness that rq-based mpath doesn't need
to support really large IOs, etc) without compromising the ability to
make forward progress.

But, as mentioned in my porevious mail, I'd like to see this implemnted
in terms of module_param_named().

> We tested performance of dm-mpath with smaller MIN_IOS sizes for both dm
> and dm-mpath, from a value of 32 all the way down to zero.

Bio-based can safely be reduced, as this older (uncommitted) patch did:
http://people.redhat.com/msnitzer/patches/upstream/dm-rq-based-mempool-sharing/0000-dm-lower-bio-based-reservation.patch

> Bearing in mind that the underlying devices were network-based, we saw
> essentially no performance degradation; if there was any, it was down
> in the noise.  One might wonder why these sizes are the way they are;
> I investigated and they've been unchanged since at least 2006.

Performance isn't the concern.  The concern is: does DM allow for
forward progress if the system's memory is completely exhausted?

This is why request-based has such an extensive reserve, because it
needs to account for cloning the largest possible request that comes in
(with multiple bios).
