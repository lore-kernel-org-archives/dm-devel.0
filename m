From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3] dm-cache watermarks
Date: Mon, 7 Mar 2016 09:17:13 -0500
Message-ID: <20160307141713.GA19967@redhat.com>
References: <56DBFAEB.2050801@fluentit.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56DBFAEB.2050801@fluentit.com.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steven Wilton <swilton@fluentit.com.au>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Mar 06 2016 at  4:39am -0500,
Steven Wilton <swilton@fluentit.com.au> wrote:

> I realised that I over-thought the original logic.  The attached
> patch is much simpler - write back dirty cache entries at the
> migration threshold rate when we are over the low watermark, and we
> write back as fast as possible when we go over the high watermark.
> 
> The current behaviour can be replicated by setting the high
> watermark to 100, and the low watermark to 0.
> 
> regards
> 
> Steven

...

> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 7dab682..7b8b4a3 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2332,6 +2364,8 @@ static void set_cache_size(struct cache *cache, dm_cblock_t size)
>  }
>  
>  #define DEFAULT_MIGRATION_THRESHOLD 2048
> +#define DEFAULT_WRITEBACK_HIGH_WATERMARK 40
> +#define DEFAULT_WRITEBACK_LOW_WATERMARK 30
>  

These should default to current behavior (100 and 0 respectively, like
you mentioned above).

This change needs an accompanying Documentation update.  It also needs a
proper path header to accurately convey the scope of the change.

Please post v4 with these changes and then I'll take a closer look (as
I'm sure Joe will).  But please be aware that in general we want less
knobs, not more.

Thanks,
Mike
