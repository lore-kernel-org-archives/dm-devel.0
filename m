From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 17/19] libmultipath: add udev and logsink
	symbols
Date: Mon, 21 Sep 2020 15:10:52 -0500
Message-ID: <20200921201052.GY11108@octiron.msp.redhat.com>
References: <20200916153718.582-1-mwilck@suse.com>
	<20200916153718.582-18-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-18-mwilck@suse.com>
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
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 16, 2020 at 05:37:16PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> With these symbols added, applications using libmultipath don't
> need to define global variables "udev" and "logsink" any more.
> This comes at the cost of having to call an init function.
> Currently, libmultipath_init() does nothing but initialize
> "udev".
> 
> The linker's symbol lookup order still allows applications to use
> their own "logsink" and "udev" variables, which will take precendence
> over libmultipath's internal ones. In this case, calling
> libmultipath_init() can be skipped, but like before,
> udev should be initialized (using udev_new()) before making any
> libmultipath calls.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c | 22 ++++++++++++++++++++++
>  libmultipath/config.h |  4 +++-
>  libmultipath/debug.c  |  2 ++
>  3 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index b83e5cd..4b48b27 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -27,6 +27,28 @@
>  #include "mpath_cmd.h"
>  #include "propsel.h"
>  
> +static pthread_once_t _udev_once = PTHREAD_ONCE_INIT;
> +struct udev *udev;
> +
> +void _udev_init(void)
> +{
> +	udev = udev_new();
> +	if (!udev)
> +		condlog(0, "%s: failed to initialize udev", __func__);
> +}
> +
> +int libmultipath_init(void)
> +{
> +	if (!udev)
> +		pthread_once(&_udev_once, _udev_init);
> +	return udev ? 0 : 1;
> +}
> +
> +void libmultipath_exit(void)
> +{
> +	udev_unref(udev);
> +}

After calling libmultipath_exit(), you can never reinitialized the udev
device.  That seems fine, but it should probably set udev to null, so
that future calls to libmultipath_init() don't return success. Either
that or multipath_init() should use a mutex instead of pthread_once() to
avoid races, so that you can reinitialize udev after a call to
libmultipath_exit().

-Ben

> +
>  static struct config __internal_config;
>  struct config *libmp_get_multipath_config(void)
>  {
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 5997b71..541b2e4 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -232,7 +232,9 @@ struct config {
>  	char *enable_foreign;
>  };
>  
> -extern struct udev * udev;
> +extern struct udev *udev;
> +int libmultipath_init(void);
> +void libmultipath_exit(void);
>  
>  int find_hwe (const struct _vector *hwtable,
>  	      const char * vendor, const char * product, const char *revision,
> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> index 4128cb9..b3a1de9 100644
> --- a/libmultipath/debug.c
> +++ b/libmultipath/debug.c
> @@ -15,6 +15,8 @@
>  #include "defaults.h"
>  #include "debug.h"
>  
> +int logsink;
> +
>  void dlog (int sink, int prio, const char * fmt, ...)
>  {
>  	va_list ap;
> -- 
> 2.28.0
