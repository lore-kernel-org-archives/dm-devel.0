From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm block manager: use do/while(0) for empty macros
Date: Tue, 25 Oct 2016 14:20:30 -0400
Message-ID: <20161025182030.GA4879@redhat.com>
References: <20161025155434.21727-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161025155434.21727-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 25 2016 at 11:54am -0400,
Arnd Bergmann <arnd@arndb.de> wrote:

> make W=1 reports a new warning for the dm-block-manager:
> 
> drivers/md/persistent-data/dm-block-manager.c: In function ‘dm_bm_unlock’:
> drivers/md/persistent-data/dm-block-manager.c:598:3: error: suggest braces around empty body in an ‘else’ statement [-Werror=empty-body]
> 
> This is completely harmless, but generally speaking it's a good idea to
> address this warning as it can often detect nasty bugs, and replacing
> empty macros with "do { } while (0)" is generally considered good style
> to make code more robust anyway.
> 
> Fixes: f94bdb2e26b6 ("dm block manager: make block locking optional")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks Arnd, I'll fold this in.  I suspected this was the right thing to
do.  Strange that my build didn't say anything through, I used:
make C=1 CF=-D__CHECK_ENDIAN__ M=drivers/md

I'll be sure to use make W=1 in the future.

> ---
>  drivers/md/persistent-data/dm-block-manager.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
> index b619c383d88d..a6dde7cab458 100644
> --- a/drivers/md/persistent-data/dm-block-manager.c
> +++ b/drivers/md/persistent-data/dm-block-manager.c
> @@ -306,13 +306,13 @@ static void report_recursive_bug(dm_block_t b, int r)
>  
>  #else  /* !CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING */
>  
> -#define bl_init(x)
> +#define bl_init(x) do { } while (0)
>  #define bl_down_read(x) 0
>  #define bl_down_read_nonblock(x) 0
> -#define bl_up_read(x)
> +#define bl_up_read(x) do { } while (0)
>  #define bl_down_write(x) 0
> -#define bl_up_write(x)
> -#define report_recursive_bug(x, y)
> +#define bl_up_write(x) do { } while (0)
> +#define report_recursive_bug(x, y) do { } while (0)
>  
>  #endif /* CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING */
>  
> -- 
> 2.9.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
