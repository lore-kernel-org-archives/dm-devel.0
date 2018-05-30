From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm: writecache: fix format string warning
Date: Wed, 30 May 2018 08:13:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1805300807090.24812@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180528155432.2864616-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180528155432.2864616-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 28 May 2018, Arnd Bergmann wrote:

> The return type of ACCESS_ONCE is configuration dependent and may be either
> 'int' or 'long int' for the writecache_has_error() macro, so we get a warning
> like this for either format string:

__builtin_expect returns always long, see the GCC documentation (it used 
to return int in very old gcc versions such as 2.96).

I think this is a bug in the macro __branch_check__. The variable ______r 
should be long, but it is int. This bug may cause misbehavior of other 
kernel parts (i.e. truncation of long value to int), so it should be fixed 
in __branch_check__ - not in dm-writecache.

Mikulas

> In file included from drivers/md/dm-writecache.c:8:
> drivers/md/dm-writecache.c: In function 'writecache_status':
> drivers/md/dm-writecache.c:2227:10: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'int' [-Werror=format=]
>    DMEMIT("%ld %llu %llu %llu", writecache_has_error(wc),
>           ^~~~~~~~~~~~~~~~~~~~
> include/linux/device-mapper.h:549:46: note: in definition of macro 'DMEMIT'
>       0 : scnprintf(result + sz, maxlen - sz, x))
>                                               ^
> 
> The code is otherwise correct, so we just need to shut up the warning,
> which can be done using an extra type cast.
> 
> Fixes: bb15b431d650 ("dm: add writecache target")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/md/dm-writecache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 1ef06e738eb6..772ac3a57287 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -2224,7 +2224,7 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
>  
>  	switch (type) {
>  	case STATUSTYPE_INFO:
> -		DMEMIT("%ld %llu %llu %llu", writecache_has_error(wc),
> +		DMEMIT("%ld %llu %llu %llu", (long)writecache_has_error(wc),
>  		       (unsigned long long)wc->n_blocks, (unsigned long long)wc->freelist_size,
>  		       (unsigned long long)wc->writeback_size);
>  		break;
> -- 
> 2.9.0
> 
