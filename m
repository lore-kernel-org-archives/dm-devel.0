From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC 04/11] remove CONFIG_KMOD from drivers
Date: Tue, 8 Jul 2008 21:30:20 +0300
Message-ID: <20080708183019.GA11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net> <20080708170044.262684000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-ppp-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080708170044.262684000@sipsolutions.net>
Sender: linux-ppp-owner@vger.kernel.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@infradead.org>, video4linux-list@redhat.com, David Woodhouse <dwmw2@infradead.org>, linux-ppp@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 08, 2008 at 07:00:19PM +0200, Johannes Berg wrote:
>...
> --- everything.orig/drivers/md/md.c	2008-07-08 18:46:21.000000000 +0200
> +++ everything/drivers/md/md.c	2008-07-08 18:49:10.000000000 +0200
>...
> @@ -3410,7 +3405,7 @@ static int do_md_run(mddev_t * mddev)
>  		}
>  	}
>  
> -#ifdef CONFIG_KMOD
> +#ifdef CONFIG_MODULES
>  	if (mddev->level != LEVEL_NONE)
>  		request_module("md-level-%d", mddev->level);
>  	else if (mddev->clevel[0])
>...

You can remove the #ifdef

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

