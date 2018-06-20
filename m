From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v3 0/5] bitmap: Introduce alloc/free helpers
Date: Wed, 20 Jun 2018 10:33:41 +0300
Message-ID: <20180620072721.GA19364@yury-thinkpad>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, mika.westerberg@linux.intel.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-input@vger.kernel.org, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 18, 2018 at 04:09:58PM +0300, Andy Shevchenko wrote:
> External Email
> 
> A lot of code is using allocation of bitmaps using BITS_PER_LONG() macro and
> sizeof(unsigned long) operator. The readability suffers because of this.
> 
> The series introduces three helpers, i.e. bitmap_alloc(), bitmap_zalloc() and
> bitmap_free(), to make it more cleaner.

tools/include/linux/bitmap.h already has bitmap_alloc(),
and it corresponds to bitmap_zalloc() in this patch. It may 
cause problems in future if people will copy functions that
use bitmap_alloc between kernel code and tools. So I think
we have to propagate this API to tools and update existing
users of bitmap_alloc() in tools.

What about code that calls specific alloc functions, like
memblock_virt_alloc() and pcpu_mem_zalloc() in mm/percpu.c,
or devm_kcalloc() in drivers/dma/edma.c? If we are going to
unify bitmap allocations in kernel, we should think about
unification of that cases too. Should it be additional
flag or optional pointer to the exact allocator in
bitmap_{,z}alloc()?

Yury
 
> Patch 1 is a preparatory to avoid namespace collisions between bitmap API and
> MD bitmap. No functional changes intended.
> 
> Patch 2 is just orphaned from previous release cycle.
> 
> Patch 3 introduces new helpers.
> 
> Patches 4 and 5 is just an example how to use new helpers. Locally I have like
> dozen of them against different subsystems and drivers.
> 
> Ideally it would go through Input subsystem, thus, needs an Ack from MD maintainer(s).
> 
> Since v2:
> - fix compilation issue in MD bitmap code
> - elaborate changes in commit message of patch 5
> 
> Since v1:
> - added namespace fix patch against MD bitmap API
> - moved functions to lib/bitmap.c to avoid circular dependencies
> - appended Dmitry's tags
> 
> Andy Shevchenko (5):
>   md: Avoid namespace collision with bitmap API
>   bitmap: Drop unnecessary 0 check for u32 array operations
>   bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
>   Input: gpio-keys - Switch to bitmap_zalloc()
>   Input: evdev - Switch to bitmap API
> 
>  drivers/input/evdev.c                         |  16 +-
>  drivers/input/keyboard/gpio_keys.c            |   8 +-
>  drivers/md/dm-raid.c                          |   6 +-
>  drivers/md/md-bitmap.c                        | 301 +++++++++---------
>  drivers/md/md-bitmap.h                        |  46 +--
>  drivers/md/md-cluster.c                       |  16 +-
>  drivers/md/md.c                               |  44 +--
>  .../md/persistent-data/dm-space-map-common.c  |  12 +-
>  drivers/md/raid1.c                            |  20 +-
>  drivers/md/raid10.c                           |  26 +-
>  drivers/md/raid5-cache.c                      |   2 +-
>  drivers/md/raid5.c                            |  24 +-
>  include/linux/bitmap.h                        |   8 +
>  lib/bitmap.c                                  |  28 +-
>  14 files changed, 283 insertions(+), 274 deletions(-)
> 
> --
> 2.17.1
