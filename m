From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] There's no need to include linux/version.h in
 drivers/md/dm-bufio.c
Date: Sun, 15 Jan 2012 17:29:00 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201151728510.26479@hs20-bc2-1.build.redhat.com>
References: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
List-Id: dm-devel.ids

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

On Sun, 15 Jan 2012, Jesper Juhl wrote:

> As 'make versioncheck' points out, drivers/md/dm-bufio.c has no need
> to include linux/version.h, so this patch removes the unneeded
> include.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/md/dm-bufio.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 0a6806f..b6e58c7 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -12,7 +12,6 @@
>  #include <linux/dm-io.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> -#include <linux/version.h>
>  #include <linux/shrinker.h>
>  #include <linux/module.h>
>  
> -- 
> 1.7.8.3
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
