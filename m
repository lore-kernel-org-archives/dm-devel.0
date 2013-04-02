From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] libmultipath/discovery: read sysfs files
	uncached
Date: Tue, 02 Apr 2013 23:00:48 +0200
Message-ID: <1364936448.5344.8.camel@lapoo.opensvc.com>
References: <1364912936-14636-1-git-send-email-sebastian.riemer@profitbricks.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1364912936-14636-1-git-send-email-sebastian.riemer@profitbricks.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel <dm-devel@redhat.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On mar., 2013-04-02 at 16:28 +0200, Sebastian Riemer wrote:
> The libudev function udev_device_get_sysattr_value() reads sysfs
> attributes cached. This is useless for checking a device state.
> There we want to see if it changes.
> 
> Unfortunately, libudev doesn't provide an uncached variant. This
> is why we have to reimplement the functionality and some libudev
> internal functions here.
> 
Hannes,

as the commit 058a0044cb2ab7cac6f7c3e2e17b16e00b5e57fa author, would you
sign-off this patch ? Or do you prefer the issue addressed on the udev
side ...

Best regards,
Christophe Varoqui
www.opensvc.com


> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> ---
>  libmultipath/discovery.c |   78 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 0b5fd1d..1cb1f15 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -132,6 +132,82 @@ path_discovery (vector pathvec, struct config * conf, int flag)
>  	return r;
>  }
>  
> +/* helpers for get_udev_device_sysattr_value() */
> +static size_t
> +strpcpy(char **dest, size_t size, const char *src)
> +{
> +	size_t len;
> +
> +	len = strlen(src);
> +	if (len >= size) {
> +		if (size > 1)
> +			*dest = mempcpy(*dest, src, size-1);
> +		size = 0;
> +	} else {
> +		if (len > 0) {
> +			*dest = mempcpy(*dest, src, len);
> +			size -= len;
> +		}
> +	}
> +	*dest[0] = '\0';
> +	return size;
> +}
> +
> +static size_t
> +strscpyl(char *dest, size_t size, const char *src, ...)
> +{
> +	va_list va;
> +	char *s;
> +
> +	va_start(va, src);
> +	s = dest;
> +	do {
> +		size = strpcpy(&s, size, src);
> +		src = va_arg(va, char *);
> +	} while (src != NULL);
> +	va_end(va);
> +
> +	return size;
> +}
> +
> +static void
> +util_remove_trailing_chars(char *path, char c)
> +{
> +	size_t len;
> +
> +	if (path == NULL)
> +		return;
> +	len = strlen(path);
> +	while (len > 0 && path[len-1] == c)
> +		path[--len] = '\0';
> +}
> +
> +/* like udev_device_get_sysattr_value() but uncached */
> +static const char *
> +get_udev_device_sysattr_value(struct udev_device *udev,
> +			      const char *sysattr)
> +{
> +	const char *val = NULL;
> +	char path[1024];
> +	char value[4096];
> +	int fd;
> +	ssize_t size;
> +
> +	strscpyl(path, sizeof(path), udev_device_get_syspath(udev),
> +		 "/", sysattr, NULL);
> +	fd = open(path, O_RDONLY|O_CLOEXEC);
> +	if (fd >= 0) {
> +		size = read(fd, value, sizeof(value));
> +		close(fd);
> +		if (size >= 0 && size < sizeof(value)) {
> +			value[size] = '\0';
> +			util_remove_trailing_chars(value, '\n');
> +			val = value;
> +		}
> +	}
> +	return val;
> +}
> +
>  #define declare_sysfs_get_str(fname)					\
>  extern int								\
>  sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)	\
> @@ -141,7 +217,7 @@ sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)	\
>  									\
>  	devname = udev_device_get_sysname(udev);			\
>  									\
> -	attr = udev_device_get_sysattr_value(udev, #fname);		\
> +	attr = get_udev_device_sysattr_value(udev, #fname);		\
>  	if (!attr) {							\
>  		condlog(3, "%s: attribute %s not found in sysfs",	\
>  			devname, #fname);				\
