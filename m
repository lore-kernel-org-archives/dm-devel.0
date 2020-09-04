From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/14] multipath-tools series: some cleanups
 and fixes checked by codedex tool
Date: Fri, 4 Sep 2020 15:00:32 -0500
Message-ID: <20200904200032.GB11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<73d14f51e1ca6aeb8dbd40f5a22c21508b6d4401.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <73d14f51e1ca6aeb8dbd40f5a22c21508b6d4401.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Thu, Sep 03, 2020 at 10:08:53PM +0200, Martin Wilck wrote:
> Hello Lixiaokeng,
> 
> On Wed, 2020-09-02 at 14:40 +0800, lixiaokeng wrote:
> > Hi:
> >     Now, we check multipath-tools codes with codedex tool. Here
> > are some some cleanups and fixes.
> 
> Thank you. However I'm going to nack all patches that add error
> messages after unsuccesful memory allocations. Such messages are
> unhelpful most of the time, and increase the code size without a true
> benefit. I've actually considered to get rid of all these, and replace
> them by a log_oom() macro.

O.k. This answers my question from patch 0005. I'm fine with this.

As a side note: man, those are some ugly preprocessor hoops you need to
jump through to stringify __LINE__.

-Ben

> 
> See an untested prototype attached, to better understand what I mean.
> 
> Regards
> Martin
> 
> 

> From fbbca2c5076a489ee4ae643d6d9199ca5085be95 Mon Sep 17 00:00:00 2001
> From: Martin Wilck <mwilck@suse.com>
> Date: Thu, 3 Sep 2020 22:03:22 +0200
> Subject: [PATCH] libmultipath: prototype implementation of log_oom()
> 
> Rationale: with VERBOSE_OOM_LOGGING, we log the part of the code
> where OOM occured, with minimal runtime effort (no string formatting).
> With lots of log_oom() invocations, our binary will increase by many
> static strings. Without VERBOSE_OOM_LOGGING, we just print a minimal
> error message, which will be enough most of the time.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/debug.c | 7 +++++++
>  libmultipath/debug.h | 8 ++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> index 4128cb9..9062581 100644
> --- a/libmultipath/debug.c
> +++ b/libmultipath/debug.c
> @@ -48,3 +48,10 @@ void dlog (int sink, int prio, const char * fmt, ...)
>  	}
>  	va_end(ap);
>  }
> +
> +#ifndef VERBOSE_OOM_LOGGING
> +void log_oom(void)
> +{
> +	condlog(0, "Out of memory");
> +}
> +#endif
> diff --git a/libmultipath/debug.h b/libmultipath/debug.h
> index c6120c1..f61ecb6 100644
> --- a/libmultipath/debug.h
> +++ b/libmultipath/debug.h
> @@ -11,3 +11,11 @@ extern int logsink;
>  
>  #define condlog(prio, fmt, args...) \
>  	dlog(logsink, prio, fmt "\n", ##args)
> +
> +#ifdef VERBOSE_OOM_LOGGING
> +#define __log_oom(file, line) condlog(0, "Out of memory in " file ":" #line)
> +#define _log_oom(file, line) __log_oom(file, line)
> +#define log_oom() _log_oom(__FILE__, __LINE__)
> +#else
> +void log_oom(void);
> +#endif
> -- 
> 2.28.0
> 
