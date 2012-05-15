From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 04/16] Fix ratelimit macro to compile in c99 mode
Date: Tue, 15 May 2012 09:43:00 -0700
Message-ID: <20120515164300.GA20827@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <d7cfd6b70316efc3fe2ce575203d906a610e3670.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d7cfd6b70316efc3fe2ce575203d906a610e3670.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:09:00PM -0400, Kent Overstreet wrote:
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/ratelimit.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> index e11ccb4..9ad57d3 100644
> --- a/include/linux/ratelimit.h
> +++ b/include/linux/ratelimit.h
> @@ -20,7 +20,7 @@ struct ratelimit_state {
>  #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
>  									\
>  	struct ratelimit_state name = {					\
> -		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
> +		.lock		= __RAW_SPIN_LOCK_INITIALIZER(name.lock),\

NACK, kernel is not built in c99 mode and using anonymous struct in
struct initializers is an accepted convention.

Thanks.

-- 
tejun
