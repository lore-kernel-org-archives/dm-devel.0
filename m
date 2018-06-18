From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 1/5] md: Avoid namespace collision with bitmap API
Date: Mon, 18 Jun 2018 09:44:54 -0400
Message-ID: <20180618134454.GA25547@redhat.com>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
 <20180618131003.88110-2-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180618131003.88110-2-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Mon, Jun 18 2018 at  9:09am -0400,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> bitmap API (include/linux/bitmap.h) has 'bitmap' prefix for its methods.
> 
> On the other hand MD bitmap API is special case.
> Adding 'md' prefix to it to avoid name space collision.
> 
> No functional changes intended.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
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
>  10 files changed, 244 insertions(+), 253 deletions(-)

Seems my previous mail just missed your v3 cutoff but...

<snip>

All of these drivers/md/persistent-data/dm-space-map-common.c renames
are wrong.  DM is the only consumer (it is confusing because all DM and
MD code lives in drivers/md/ despite only sharing a bit of MD code).

Anyway, please rename bitmap methods in this file to have a "dm_bitmap"
prefix instead.  Thanks.

Mike

> diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
> index 829b4ce057d8..049e999fc6c4 100644
> --- a/drivers/md/persistent-data/dm-space-map-common.c
> +++ b/drivers/md/persistent-data/dm-space-map-common.c
> @@ -69,7 +69,7 @@ static struct dm_block_validator index_validator = {
>   */
>  #define BITMAP_CSUM_XOR 240779
>  
> -static void bitmap_prepare_for_write(struct dm_block_validator *v,
> +static void md_bitmap_prepare_for_write(struct dm_block_validator *v,
>  				     struct dm_block *b,
>  				     size_t block_size)
>  {
> @@ -81,7 +81,7 @@ static void bitmap_prepare_for_write(struct dm_block_validator *v,
>  						       BITMAP_CSUM_XOR));
>  }
>  
> -static int bitmap_check(struct dm_block_validator *v,
> +static int md_bitmap_check(struct dm_block_validator *v,
>  			struct dm_block *b,
>  			size_t block_size)
>  {
> @@ -108,8 +108,8 @@ static int bitmap_check(struct dm_block_validator *v,
>  
>  static struct dm_block_validator dm_sm_bitmap_validator = {
>  	.name = "sm_bitmap",
> -	.prepare_for_write = bitmap_prepare_for_write,
> -	.check = bitmap_check
> +	.prepare_for_write = md_bitmap_prepare_for_write,
> +	.check = md_bitmap_check,
>  };
>  
>  /*----------------------------------------------------------------*/
> @@ -124,7 +124,7 @@ static void *dm_bitmap_data(struct dm_block *b)
>  
>  #define WORD_MASK_HIGH 0xAAAAAAAAAAAAAAAAULL
>  
> -static unsigned bitmap_word_used(void *addr, unsigned b)
> +static unsigned md_bitmap_word_used(void *addr, unsigned b)
>  {
>  	__le64 *words_le = addr;
>  	__le64 *w_le = words_le + (b >> ENTRIES_SHIFT);
> @@ -170,7 +170,7 @@ static int sm_find_free(void *addr, unsigned begin, unsigned end,
>  {
>  	while (begin < end) {
>  		if (!(begin & (ENTRIES_PER_WORD - 1)) &&
> -		    bitmap_word_used(addr, begin)) {
> +		    md_bitmap_word_used(addr, begin)) {
>  			begin += ENTRIES_PER_WORD;
>  			continue;
>  		}
