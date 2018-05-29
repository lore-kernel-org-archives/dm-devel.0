From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: writecache: fix format string warning
Date: Tue, 29 May 2018 14:09:26 -0400
Message-ID: <20180529180926.GC32763@redhat.com>
References: <20180528155432.2864616-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180528155432.2864616-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 28 2018 at 11:54am -0400,
Arnd Bergmann <arnd@arndb.de> wrote:

> The return type of ACCESS_ONCE is configuration dependent and may be either
> 'int' or 'long int' for the writecache_has_error() macro, so we get a warning
> like this for either format string:
> 
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

Thanks, I've picked this up.
